package db

import (
	"fmt"
	"strings"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

func GetViewList(paramsMap map[string]interface{}, permissiveViewIds []string) (rowData []*models.SysViewTable, err error) {
	sqlCmd := "SELECT * FROM sys_view"
	hasWhere := false
	if len(permissiveViewIds) > 0 {
		permissiveViewIdsStr := strings.Join(permissiveViewIds, "','")
		sqlCmd += " WHERE id IN ('" + permissiveViewIdsStr + "')"
		hasWhere = true
	}
	paramArgs := []interface{}{}
	for k, v := range paramsMap {
		if !hasWhere {
			sqlCmd += " WHERE " + k + "=?"
			hasWhere = true
		} else {
			sqlCmd += " AND " + k + "=?"
		}
		paramArgs = append(paramArgs, v)
	}
	err = x.SQL(sqlCmd, paramArgs...).Find(&rowData)
	if err != nil {
		log.Logger.Error("Get view list error", log.Error(err))
	}
	return
}

func QueryViewById(viewId string) (rowData *models.ViewQuery, err error) {
	var viewInfo []*models.ViewQuery
	err = x.SQL(`SELECT t1.report,t1.editable,t1.suport_version,t1.multiple,t1.filter_value,t2.ci_type,t3.name as filter_attr_name FROM sys_view t1 
				left join sys_report t2 on t1.report=t2.id left join sys_ci_type_attr t3 on t1.filter_attr=t3.id WHERE t1.id=?`, viewId).Find(&viewInfo)
	if err != nil {
		log.Logger.Error("Query view by id error", log.String("viewId", viewId), log.Error(err))
		return
	}
	if len(viewInfo) == 0 {
		err = fmt.Errorf("View %s can not found ", viewId)
		log.Logger.Warn("Query view by id fail", log.Error(err))
	} else {
		rowData = viewInfo[0]
	}
	return
}

func GetGraphByView(viewId string) (rowData []*models.SysGraphTable, err error) {
	err = x.SQL(`SELECT * FROM sys_graph WHERE view=?`, viewId).Find(&rowData)
	if err != nil {
		log.Logger.Error("Get graph by view error", log.String("viewId", viewId), log.Error(err))
		return
	}
	if len(rowData) == 0 {
		err = fmt.Errorf("Get graph by view %s can not found ", viewId)
		log.Logger.Warn("Get graph by view fail", log.Error(err))
	}
	return
}

func GetGraphById(graphId string) (rowData *models.SysGraphTable, err error) {
	var exist bool
	rowData = &models.SysGraphTable{Id: graphId}
	if exist, err = x.Table("sys_graph").Get(rowData); err != nil {
		log.Logger.Error("Get graph by id error", log.String("graphId", graphId), log.Error(err))
		return
	}

	if !exist {
		err = fmt.Errorf("Get graph by id %s can not found ", graphId)
		log.Logger.Warn("Get graph by view fail", log.Error(err))
	}
	return
}

func GetRootGraphElementByGraph(graphId string) (rowData *models.GraphElementNode, err error) {
	var geData []*models.GraphElementNode
	err = x.SQL(`SELECT t1.*,t2.ci_type,t2.data_name FROM sys_graph_element t1 left join sys_report_object t2 
				on t1.report_object=t2.id WHERE t1.parent_element is null and t1.graph=?`, graphId).Find(&geData)
	if err != nil {
		log.Logger.Error("Get root graph element by graph error", log.String("graphId", graphId), log.Error(err))
		return
	}
	if len(geData) == 0 {
		log.Logger.Warn("Get root graph element by graph fail", log.Error(err))
	} else {
		rowData = geData[0]
	}
	return
}

func GetChildGraphElement(root *models.GraphElementNode) (rowData *models.GraphElementNode, err error) {
	if root == nil {
		err = nil
		return
	}
	var geData []*models.GraphElementNode
	err = x.SQL(`SELECT t1.*,t2.ci_type,t2.data_name,t3.name as edit_ref_attr_name FROM sys_graph_element t1 
				left join sys_report_object t2 on t1.report_object=t2.id 
				left join sys_ci_type_attr t3 on t1.edit_ref_attr=t3.id
				WHERE t1.parent_element=?`, root.Id).Find(&geData)
	if err != nil {
		log.Logger.Error("Query graph element by parent graph element error", log.String("parentGraphElementId", root.Id), log.Error(err))
		return
	}
	if len(geData) == 0 {
		err = nil
		return
	}

	for _, ge := range geData {
		childNode := ge
		root.Children = append(root.Children, childNode)
		_, err = GetChildGraphElement(childNode)
		if err != nil {
			return
		}
	}
	return
}

func GetPermissiveViewId(permissions []string, roles []string, hasViewIds []string) (viewIds []string, err error) {
	permissionStr := strings.Join(permissions, "','")
	roleStr := strings.Join(roles, "','")
	sqlCmd := "SELECT DISTINCT view FROM sys_role_view WHERE role IN ('" + roleStr + "')" + " AND permission IN ('" + permissionStr + "')"
	if len(hasViewIds) > 0 {
		viewIdStr := strings.Join(hasViewIds, "','")
		sqlCmd += " AND view IN ('" + viewIdStr + "')"
	}
	rowData, tmpErr := x.QueryString(sqlCmd)
	if tmpErr != nil {
		err = fmt.Errorf("Query permissive view ids in role view error:%s", tmpErr.Error())
		log.Logger.Error("Query permissive view ids in role view error", log.Error(err))
	}
	for i := range rowData {
		viewIds = append(viewIds, rowData[i]["view"])
	}
	return
}

func GetRootCiDataWithReportId(reportId string) (ciDataGuidList []string, err error) {
	ciDataGuidList = []string{}
	rootReportObjects, queryReportErr := x.QueryString("select ci_type from sys_report_object where report=? and (parent_object is NULL or parent_object='')", reportId)
	if queryReportErr != nil {
		err = fmt.Errorf("Try to query report object fail,%s ", queryReportErr.Error())
		return
	}
	for _, rootCi := range rootReportObjects {
		tmpGuidQuery, tmpErr := x.QueryString("select guid from " + rootCi["ci_type"])
		if tmpErr != nil {
			err = fmt.Errorf("Try to query ci:%s data fail,%s ", rootCi["ci_type"], tmpErr.Error())
			break
		}
		for _, tmpGuidObj := range tmpGuidQuery {
			ciDataGuidList = append(ciDataGuidList, tmpGuidObj["guid"])
		}
	}
	return
}

func ViewConfirmAction(param models.ViewData, userToken, operator string, userRoles []string) (result []models.CiDataMapObj, err error) {
	result = []models.CiDataMapObj{}
	rootGuidList := strings.Split(param.RootCi, ",")
	viewData, queryViewErr := QueryViewById(param.ViewId)
	if queryViewErr != nil {
		err = fmt.Errorf("Query view error:%s ", queryViewErr.Error())
		return
	}
	reportId := viewData.Report
	var rootReportObjectsData []*models.ReportObjectNode
	rootReportObjectsData, err = QueryRootReportObj(reportId)
	if err != nil {
		err = fmt.Errorf("Query root report fail,%s ", err.Error())
		return
	}
	editableGuidList := []string{}
	existMap := make(map[string]int)
	for _, roNode := range rootReportObjectsData {
		rootReportAttr, _, tmpErr := GetReportAttr(roNode.Id)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		_, tmpEditableList, queryErr := GetChildReportObject(roNode, rootGuidList, rootReportAttr, param.ConfirmTime, param.ViewId, false)
		if queryErr != nil {
			err = queryErr
			break
		}
		for _, tmpGuid := range tmpEditableList {
			if _, b := existMap[tmpGuid]; !b {
				editableGuidList = append(editableGuidList, tmpGuid)
				existMap[tmpGuid] = 1
			}
		}
	}
	if err != nil {
		return
	}
	log.Logger.Info("Confirm view", log.Int("guidLength", len(editableGuidList)), log.StringList("guid", editableGuidList))
	if len(editableGuidList) == 0 {
		return
	}
	// confirm data
	var confirmParam []models.CiDataMapObj
	for _, v := range editableGuidList {
		tmpMap := make(map[string]string)
		tmpMap["guid"] = v
		confirmParam = append(confirmParam, tmpMap)
	}
	permission := true
	if operator == "SYSTEM" {
		permission = false
	}
	handleParam := models.HandleCiDataParam{InputData: confirmParam, CiTypeId: viewData.CiType, Operation: "Confirm", Operator: operator, Roles: userRoles, Permission: permission}
	handleParam.UserToken = userToken
	result, _, err = HandleCiDataOperation(handleParam)
	if err != nil {
		err = fmt.Errorf("Handle ci data confirm fail,%s ", err.Error())
	}
	return
}
