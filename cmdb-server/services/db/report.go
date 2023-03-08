package db

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"reflect"
	"strconv"
	"strings"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

func QueryRootReportObj(reportId string) (rowData []*models.ReportObjectNode, err error) {
	sqlCmd := "SELECT * FROM sys_report_object WHERE report=? and parent_attr is null"
	err = x.SQL(sqlCmd, reportId).Find(&rowData)
	if err != nil {
		log.Logger.Error("Query report object error", log.String("reportId", reportId), log.Error(err))
		return
	}
	if len(rowData) == 0 {
		err = fmt.Errorf("Query report object can not found ")
		log.Logger.Warn("Query report object fail", log.Error(err))
	}
	return
}

func GetChildReportObject(root *models.ReportObjectNode, rootGuidList []string, roAttrData []*models.SysReportObjectAttrTable, confirmTime, viewId string) (rowData []map[string]interface{}, editableList []string, err error) {
	if root == nil {
		err = nil
		return
	}
	// 1.查找 report_object_attr , 确定属性的值
	// 2.根据1中的字段的值，获取citype指定的表中的对应字段的值，report_object 的data_name 作为下一级的入口key名
	//nameMap := make(map[string]string)
	//var roAttrData []*models.SysReportObjectAttrTable
	//err = x.SQL(`SELECT * FROM sys_report_object_attr WHERE report_object=?`, root.Id).Find(&roAttrData)
	//if err != nil {
	//	log.Logger.Error("Query report object attr error", log.String("reportObjectId", root.Id), log.Error(err))
	//	return
	//}
	if len(roAttrData) == 0 {
		roAttrData, _, err = GetReportAttr(root.Id)
		if err != nil {
			return
		}
	}
	myAttrQuery, tmpErr := x.QueryString("select my_attr from sys_report_object where id = ?", root.Id)
	if tmpErr != nil {
		err = fmt.Errorf("Try to query report owner attribute fail,%s ", tmpErr.Error())
		return
	}
	//attrDataNameMap := make(map[string]string)
	roAttrDataNames := []string{"guid"}
	for _, roAttr := range roAttrData {
		//nameMap[roAttrData[i].DataName] = roAttrData[i].DataDisplayName
		columnName := roAttr.CiTypeAttr
		columnName = columnName[strings.Index(columnName, "__")+2:]
		//attrDataNameMap[columnName] = roAttr.DataName
		if columnName == "guid" {
			continue
		}
		roAttrDataNames = append(roAttrDataNames, columnName)
	}
	if len(myAttrQuery) > 0 {
		for _, v := range myAttrQuery {
			if v["my_attr"] != "" {
				roAttrDataNames = append(roAttrDataNames, v["my_attr"][strings.Index(v["my_attr"], "__")+2:])
			}
		}
	}

	filterCols := strings.Join(roAttrDataNames, ",")
	tmpFilter := "guid"
	if root.MyAttr != "" {
		if strings.Index(root.MyAttr, "__") < len(root.MyAttr)-2 {
			tmpFilter = root.MyAttr[strings.Index(root.MyAttr, "__")+2:]
		}

	}
	extendFilterSql := ""
	queryTableName := root.CiType
	isEditable := checkReportObjectEditable(viewId, root.Id)
	if confirmTime != "" {
		queryTableName = HistoryTablePrefix + root.CiType
		if isEditable {
			extendFilterSql = fmt.Sprintf(" AND confirm_time='%s' AND history_state_confirmed=1", confirmTime)
		} else {
			filterCols += ",id"
			extendFilterSql = fmt.Sprintf(" AND ((confirm_time<='%s' AND history_state_confirmed=1) OR (update_time<='%s' AND confirm_time IS NULL))", confirmTime, confirmTime)
		}
	}
	sqlCmd := "SELECT " + filterCols + " FROM " + queryTableName + " WHERE " + tmpFilter + " in ('" + strings.Join(rootGuidList, "','") + "')" + extendFilterSql
	ciTypeTableData, err := x.QueryString(sqlCmd)
	if err != nil {
		log.Logger.Error("Query report object citype table error", log.String("ciTypeTable", root.CiType), log.Error(err))
		return
	}
	if !isEditable {
		ciTypeTableData = distinctViewCiData(ciTypeTableData)
	}
	for _, v := range ciTypeTableData {
		tmpMap := make(map[string]interface{})
		for k, val := range v {
			if k == "id" {
				continue
			}
			tmpMap[k] = val
		}
		rowData = append(rowData, tmpMap)
		if isEditable {
			editableList = append(editableList, v["guid"])
		}
	}

	var roData []*models.ReportObjectNode
	err = x.SQL(`SELECT * FROM sys_report_object WHERE parent_object=?`, root.Id).Find(&roData)
	if err != nil {
		log.Logger.Error("Query report object by parent object error", log.String("parentObjectId", root.Id), log.Error(err))
		return
	}

	if len(roData) == 0 {
		err = nil
		return
	}

	for _, ro := range roData {
		tmpList := []string{}
		for _, v := range ciTypeTableData {
			tmpList = append(tmpList, v[ro.ParentAttr[strings.Index(ro.ParentAttr, "__")+2:]])
		}
		subReportAttr, subReportNameMap, tmpErr := GetReportAttr(ro.Id)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		childDataList, childEditList, tmpErr := GetChildReportObject(ro, tmpList, subReportAttr, confirmTime, viewId)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		if len(childEditList) > 0 {
			editableList = append(editableList, childEditList...)
		}
		for i, v := range rowData {
			var sub []map[string]interface{}
			for _, v2 := range childDataList {
				if v2[ro.MyAttr[strings.Index(ro.MyAttr, "__")+2:]] == v[ro.ParentAttr[strings.Index(ro.ParentAttr, "__")+2:]] {
					tmpSubObj := make(map[string]interface{})
					for subKey, subValue := range v2 {
						if _, b := subReportNameMap[subKey]; b {
							tmpSubObj[subReportNameMap[subKey]] = subValue
						} else {
							if strings.HasSuffix(subKey, "^") {
								subKey = subKey[:len(subKey)-1]
							}
							tmpSubObj[subKey] = subValue
						}
					}
					sub = append(sub, tmpSubObj)
				}
			}
			if len(sub) > 0 {
				rowData[i][ro.DataName+"^"] = sub
			} else {
				rowData[i][ro.DataName+"^"] = []string{}
			}
		}
	}
	return
}

func distinctViewCiData(input []map[string]string) []map[string]string {
	result := []map[string]string{}
	if len(input) == 0 {
		return result
	}
	guidMap := make(map[string][]string)
	for _, v := range input {
		tmpTime := v["update_time"]
		if v["confirm_time"] != "" {
			tmpTime = v["confirm_time"]
		}
		if tmpV, b := guidMap[v["guid"]]; b {
			if tmpTime > tmpV[0] {
				guidMap[v["guid"]] = []string{tmpTime, v["id"]}
			}
		} else {
			guidMap[v["guid"]] = []string{tmpTime, v["id"]}
		}
	}
	idMap := make(map[string]int)
	for _, v := range guidMap {
		idMap[v[1]] = 1
	}
	for _, v := range input {
		if _, b := idMap[v["id"]]; b {
			result = append(result, v)
		}
	}
	return result
}

func checkReportObjectEditable(viewId, reportObjId string) bool {
	result := false
	var sysGraphElememts []*models.SysGraphElementTable
	x.SQL("select id,editable from sys_graph_element where report_object=? and graph in (select id from sys_graph where `view`=?)", reportObjId, viewId).Find(&sysGraphElememts)
	if len(sysGraphElememts) > 0 {
		if sysGraphElememts[0].Editable == "yes" {
			result = true
		}
	}
	return result
}

func GetReportAttr(reportObj string) (roAttrData []*models.SysReportObjectAttrTable, dataNameMap map[string]string, err error) {
	err = x.SQL(`SELECT * FROM sys_report_object_attr WHERE report_object=?`, reportObj).Find(&roAttrData)
	if err != nil {
		err = fmt.Errorf("Query report:%s object attr error,%s ", reportObj, err.Error())
		log.Logger.Error("Query report object attr error", log.String("reportObjectId", reportObj), log.Error(err))
		return
	}
	dataNameMap = make(map[string]string)
	for _, attr := range roAttrData {
		columnName := attr.CiTypeAttr
		columnName = columnName[strings.Index(columnName, "__")+2:]
		dataNameMap[columnName] = attr.DataName
	}
	return
}

func QueryReportList(paramsMap map[string]interface{}, permissiveReportIds []string) (rowData []*models.SysReportTable, err error) {
	permissiveReportIdsStr := strings.Join(permissiveReportIds, "','")
	sqlCmd := "SELECT * FROM sys_report WHERE id IN ('" + permissiveReportIdsStr + "')"
	paramArgs := []interface{}{}
	for k, v := range paramsMap {
		sqlCmd += " AND " + k + "=?"
		paramArgs = append(paramArgs, v)
	}
	var tmpErr error
	// sqlOrArgs := []interface{}{sqlCmd}
	// sqlOrArgs = append(sqlOrArgs, paramArgs...)
	// rowData, tmpErr = x.QueryString(sqlOrArgs...)
	tmpErr = x.SQL(sqlCmd, paramArgs...).Find(&rowData)

	if tmpErr != nil {
		err = fmt.Errorf("Query report list error:%s ", tmpErr.Error())
		log.Logger.Error("Query report list error", log.Error(err))
		return
	}
	if len(rowData) == 0 {
		rowData = []*models.SysReportTable{}
		log.Logger.Warn("Query report list fail", log.Error(err))
		return
	}
	return
}

func QueryReportStruct(reportId string) (rowData *models.QueryReport, err error) {
	sqlCmd := "SELECT * FROM sys_report WHERE id=?"
	var tmpRowData []*models.QueryReport
	tmpErr := x.SQL(sqlCmd, reportId).Find(&tmpRowData)
	if tmpErr != nil {
		err = fmt.Errorf("Query report by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query report by reportId error", log.String("reportId", reportId), log.Error(err))
		return
	}
	if len(tmpRowData) == 0 {
		log.Logger.Warn("Query report by reportId fail", log.Error(err))
		return
	}
	rowData = tmpRowData[0]
	// 查找 report 对应的根 report object
	sqlCmd = `SELECT * FROM sys_report_object WHERE report=? AND parent_object is null;`
	var roData []*models.QueryReportObject
	tmpErr = x.SQL(sqlCmd, rowData.Id).Find(&roData)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object by report:%s error,%s ", rowData.Id, tmpErr.Error())
		log.Logger.Error("Query report object by report error", log.String("report", rowData.Id), log.Error(err))
		return
	}
	if len(roData) == 0 {
		log.Logger.Warn("Query report object by report fail", log.String("report", rowData.Id), log.Error(err))
		rowData.Object = []*models.QueryReportObject{}
		return
	}

	rowData.Object, tmpErr = QueryReportObjectStruct(roData)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object struct error,%s ", tmpErr.Error())
		log.Logger.Error("Query report object struct error", log.Error(err))
		return
	}

	return
}

func QueryReportObjectStruct(reportObjectData []*models.QueryReportObject) (objects []*models.QueryReportObject, err error) {
	if reportObjectData == nil || len(reportObjectData) == 0 {
		return
	}
	objects = reportObjectData
	for i := range reportObjectData {
		// 查询当前 report object 的 attrs
		var roAttrsData []*models.QueryReportObjectAttr
		sqlCmd := "SELECT * FROM sys_report_object_attr WHERE report_object=?"
		tmpErr := x.SQL(sqlCmd, reportObjectData[i].Id).Find(&roAttrsData)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object attrs by reportObjs error,%s ", tmpErr.Error())
			log.Logger.Error("Query report object attrs by reportObjs error", log.Error(err))
			return
		}
		if len(roAttrsData) == 0 {
			log.Logger.Warn("Query report object attrs by reportObjs fail", log.Error(err))
			roAttrsData = []*models.QueryReportObjectAttr{}
		}
		reportObjectData[i].Attr = roAttrsData

		// 查询当前 report object 的子 report object
		var childReportObject []*models.QueryReportObject
		sqlCmd = "SELECT * FROM sys_report_object WHERE parent_object=?"
		tmpErr = x.SQL(sqlCmd, reportObjectData[i].Id).Find(&childReportObject)
		if tmpErr != nil {
			err = fmt.Errorf("Query child report object by reportObjs error,%s ", tmpErr.Error())
			log.Logger.Error("Query child report object by reportObjs error", log.Error(err))
			return
		}
		if len(childReportObject) == 0 {
			log.Logger.Warn("Query child report object by reportObjs fail", log.Error(err))
			reportObjectData[i].Object = []*models.QueryReportObject{}
			continue
		}

		_, tmpErr = QueryReportObjectStruct(childReportObject)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object struct error,%s ", tmpErr.Error())
			log.Logger.Error("Query report object struct error", log.Error(err))
			return
		}
		reportObjectData[i].Object = childReportObject
	}
	return
}

func QueryReportData(reportId string, queryRequestParam *models.QueryRequestParam, user string) (pageInfo models.PageInfo, rowData []map[string]string, err error) {
	// 查找 reportId 对应的 report
	sqlCmd := `SELECT * FROM sys_report WHERE id=?`
	rData, tmpErr := x.QueryString(sqlCmd, reportId)
	if tmpErr != nil {
		err = fmt.Errorf("Query report by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query report by reportId error", log.String("reportId", reportId), log.Error(err))
		return
	}
	if len(rData) == 0 {
		rowData = []map[string]string{}
		log.Logger.Warn("Query report by reportId fail", log.Error(err))
		return
	}

	// 查找 report 对应的 report object, 仅有一个根 report object
	sqlCmd = `SELECT * FROM sys_report_object WHERE report=? ORDER BY seq_no;`
	roData, tmpErr := x.QueryString(sqlCmd, rData[0]["id"])
	if tmpErr != nil {
		err = fmt.Errorf("Query report object by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query report object by reportId error", log.String("reportId", reportId), log.Error(err))
		return
	}
	if len(roData) == 0 {
		rowData = []map[string]string{}
		log.Logger.Warn("Query report object by report fail", log.String("report", rData[0]["id"]), log.Error(err))
		return
	}

	roDataIds := []string{}
	for i := range roData {
		roDataIds = append(roDataIds, roData[i]["id"])
	}

	// 查找 report object data 对应的 attrs
	roIds := strings.Join(roDataIds, "','")
	sqlCmd = "SELECT * FROM sys_report_object_attr WHERE report_object in ('" + roIds + "')"
	roAttrsData, tmpErr := x.QueryString(sqlCmd)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object attrs by reportObjs error,%s ", tmpErr.Error())
		log.Logger.Error("Query report object attrs by reportObjs error", log.Error(err))
		return
	}
	if len(roAttrsData) == 0 {
		rowData = []map[string]string{}
		log.Logger.Warn("Query report object attrs by reportObjs fail", log.Error(err))
		return
	}
	// 根据查找的 roAttrs, 获取 report_object 的 ci_type_attr('__'后面部分的值) 与其roAttrsId(最终结果展示为该id)之间的映射
	roaCiTypeAttrMapAttrId := make(map[string]map[string]string)
	for i := range roAttrsData {
		ro := roAttrsData[i]["report_object"]
		if _, ok := roaCiTypeAttrMapAttrId[ro]; !ok {
			roaCiTypeAttrMapAttrId[ro] = make(map[string]string)
		}
		originCiTypeAttr := roAttrsData[i]["ci_type_attr"]
		ciTypeAttr := originCiTypeAttr[strings.Index(originCiTypeAttr, "__")+2:]
		roaCiTypeAttrMapAttrId[ro][ciTypeAttr] = roAttrsData[i]["id"]
	}

	resultSqlCmd := "SELECT "
	sqlCmdPostfix := " FROM "
	var multiRefTable string
	var tableAliasName string
	var preTableAliasName string
	var parentTable, parentAttr, myTable, myAttr string
	ciTypeTableMapTableAliasName := make(map[string]string)

	// 判断是否为多对多的表, 若是, 则 table name 应该使用 multiRefName
	ciTypeTableMapMultiRef := make(map[string]string)
	for i := range roData {
		ciTypeTableMapMultiRef[roData[i]["ci_type"]] = roData[i]["ci_type"]
		if i > 0 {
			parentTable = roData[i]["parent_attr"][:strings.Index(roData[i]["parent_attr"], "__")]
			parentAttr = roData[i]["parent_attr"][strings.Index(roData[i]["parent_attr"], "__")+2:]
			myTable = roData[i]["ci_type"]
			myAttr = roData[i]["my_attr"][strings.Index(roData[i]["my_attr"], "__")+2:]
			if parentAttr == "guid" {
				ciTypeTable := myTable
				ciAttrName := myAttr
				multiRefTable = myTable
				if isAttributeMultiRef(ciTypeTable, ciAttrName) == true {
					multiRefTable = fmt.Sprintf("(select %s.*,%s$%s.to_guid as %s from %s left join %s$%s on %s.guid=%s$%s.from_guid)",
						ciTypeTable, ciTypeTable, ciAttrName, ciAttrName, ciTypeTable, ciTypeTable, ciAttrName, ciTypeTable, ciTypeTable, ciAttrName)
				}
				ciTypeTableMapMultiRef[myTable] = multiRefTable
			} else {
				ciTypeTable := parentTable
				ciAttrName := parentAttr
				multiRefTable = parentTable
				if isAttributeMultiRef(ciTypeTable, ciAttrName) == true {
					multiRefTable = fmt.Sprintf("(select %s.*,%s$%s.to_guid as %s from %s left join %s$%s on %s.guid=%s$%s.from_guid)",
						ciTypeTable, ciTypeTable, ciAttrName, ciAttrName, ciTypeTable, ciTypeTable, ciAttrName, ciTypeTable, ciTypeTable, ciAttrName)
				}
				ciTypeTableMapMultiRef[parentTable] = multiRefTable
			}
		}
	}
	filterKeyMap := make(map[string]string)
	for i := range roData {
		tableAliasName = "t" + strconv.Itoa(i+1)

		for k, v := range roaCiTypeAttrMapAttrId[roData[i]["id"]] {
			resultSqlCmd += tableAliasName + "." + k + " AS " + v + ","
			filterKeyMap[v] = tableAliasName + "." + k
		}
		if i == len(roData)-1 {
			resultSqlCmd = resultSqlCmd[:len(resultSqlCmd)-1]
		}
		// 当前 ro 的父节点的表名为 ro.parent_attr 中 "__" 前的值
		if i != 0 {
			parentTable = roData[i]["parent_attr"][:strings.Index(roData[i]["parent_attr"], "__")]
			preTableAliasName = ciTypeTableMapTableAliasName[parentTable]
			parentAttr = roData[i]["parent_attr"][strings.Index(roData[i]["parent_attr"], "__")+2:]
			myAttr = roData[i]["my_attr"][strings.Index(roData[i]["my_attr"], "__")+2:]
			if parentAttr == "guid" {
				// sqlCmdPostfix += " RIGHT JOIN "
				// 防止出现上游没有数据，而下游有数据的情况
				sqlCmdPostfix += " LEFT JOIN "
			} else {
				sqlCmdPostfix += " LEFT JOIN "
			}
			sqlCmdPostfix += ciTypeTableMapMultiRef[roData[i]["ci_type"]] + " " + tableAliasName + " ON " + preTableAliasName + "." + parentAttr + "=" + tableAliasName + "." + myAttr
		} else {
			sqlCmdPostfix += ciTypeTableMapMultiRef[roData[i]["ci_type"]] + " " + tableAliasName
		}
		// 放在拼完当前 report object 的 sql 语句后，防止覆盖父 report object 的同名 ciTypeTableMapTableAliasName
		ciTypeTableMapTableAliasName[roData[i]["ci_type"]] = tableAliasName
	}
	resultSqlCmd += sqlCmdPostfix

	// 处理查询的过滤条件
	filterSql, _, queryParam := transFiltersToSQL(queryRequestParam, &models.TransFiltersParam{KeyMap: filterKeyMap})
	querySql := fmt.Sprintf("%s WHERE 1=1 %s ", resultSqlCmd, filterSql)
	if queryRequestParam.Paging {
		pageInfo.StartIndex = queryRequestParam.Pageable.StartIndex
		pageInfo.PageSize = queryRequestParam.Pageable.PageSize
		pageInfo.TotalRows = queryCount(querySql, queryParam...)
		pageSql, pageParam := transPageInfoToSQL(*queryRequestParam.Pageable)
		querySql += pageSql
		queryParam = append(queryParam, pageParam...)
	}
	sqlOrArgs := []interface{}{querySql}
	sqlOrArgs = append(sqlOrArgs, queryParam...)
	curRoData, tmpErr := x.QueryString(sqlOrArgs...)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query report object by reportId error", log.String("reportId", reportId), log.Error(err))
		return
	}

	// 将查询的 sqlcmd 保存到 report table, 不包括过滤条件部分
	cacheSqlCmd := "UPDATE sys_report SET update_time=?,update_user=?,sql_cache=? WHERE id=?"
	updateTime := time.Now().Format(models.DateTimeFormat)
	sqlOrArgs = []interface{}{cacheSqlCmd, updateTime, user, resultSqlCmd, reportId}
	_, tmpErr = x.QueryString(sqlOrArgs...)
	if tmpErr != nil {
		log.Logger.Error("Cache resultSqlCmd in report table error", log.String("reportId", reportId), log.Error(tmpErr))
	}

	if len(curRoData) > 0 {
		rowData = curRoData
	}
	if len(rowData) == 0 {
		log.Logger.Warn("Query report object by reportId fail", log.Error(err))
		return
	}
	return
}

func GetReport(reportId string) (result models.ModifyReport, err error) {
	result = models.ModifyReport{Id: reportId, UseRoleList: []string{}, MgmtRoleList: []string{}}
	var reportTable []*models.SysReportTable
	err = x.SQL("select * from sys_report where id=?", reportId).Find(&reportTable)
	if err != nil {
		return
	}
	if len(reportTable) == 0 {
		return result, fmt.Errorf("Can not find report with id:%s ", reportId)
	}
	result.Name = reportTable[0].Name
	result.CiType = reportTable[0].CiType
	var reportObjTable []*models.SysReportObjectTable
	x.SQL("select * from sys_report_object where report=? and parent_object is null", reportId).Find(&reportObjTable)
	if len(reportObjTable) > 0 {
		result.DataName = reportObjTable[0].DataName
		result.DataTitleName = reportObjTable[0].DataTitleName
	}
	var roleReportTable []*models.SysRoleReportTable
	x.SQL("select * from sys_role_report where report=?", reportId).Find(&roleReportTable)
	for _, v := range roleReportTable {
		if v.Permission == "USE" {
			result.UseRoleList = append(result.UseRoleList, v.Role)
		}
		if v.Permission == "MGMT" {
			result.MgmtRoleList = append(result.MgmtRoleList, v.Role)
		}
	}
	result.UseRole = strings.Join(result.UseRoleList, ",")
	result.MgmtRole = strings.Join(result.MgmtRoleList, ",")
	return
}

func CreateReport(param models.ModifyReport) (rowData *models.SysReportTable, err error) {
	actions := []*execAction{}
	createTime := time.Now().Format(models.DateTimeFormat)
	//_, err = x.Exec("INSERT INTO sys_report(id,name,ci_type,create_time,create_user) VALUE (?,?,?,?,?)",
	//	param.Id, param.Name, param.CiType, createTime, param.CreateUser)
	execSqlCmd := "INSERT INTO sys_report(id,name,ci_type,create_time,create_user) VALUE (?,?,?,?,?)"
	execParams := []interface{}{param.Id, param.Name, param.CiType, createTime, param.CreateUser}
	action := &execAction{Sql: execSqlCmd, Param: execParams}
	actions = append(actions, action)

	rowData = &models.SysReportTable{Id: param.Id, Name: param.Name, CiType: param.CiType, CreateTime: createTime, CreateUser: param.CreateUser}

	// 添加 report 对应的权限到 sys_role_report
	var useRoleSlice, mgmtRoleSlice []string
	if param.UseRole != "" {
		useRoleSlice = strings.Split(param.UseRole, ",")
	}
	if param.MgmtRole != "" {
		mgmtRoleSlice = strings.Split(param.MgmtRole, ",")
	}

	execSqlCmd = "INSERT INTO sys_role_report(id,role,report,permission) VALUE (?,?,?,?)"
	reportId := rowData.Id
	var role_report_id string
	for i := range useRoleSlice {
		role_report_id = useRoleSlice[i] + "__" + reportId + "__" + "USE"
		execParams := []interface{}{role_report_id, useRoleSlice[i], reportId, "USE"}
		action := &execAction{Sql: execSqlCmd, Param: execParams}
		actions = append(actions, action)
	}
	for i := range mgmtRoleSlice {
		role_report_id = mgmtRoleSlice[i] + "__" + reportId + "__" + "MGMT"
		execParams := []interface{}{role_report_id, mgmtRoleSlice[i], reportId, "MGMT"}
		action := &execAction{Sql: execSqlCmd, Param: execParams}
		actions = append(actions, action)
	}

	// 新增 root report object
	rootReportObjParam := models.ModifyReportObject{DataName: param.DataName, DataTitleName: param.DataTitleName, Report: param.Id, CiType: param.CiType}
	rootReportObjActions, tmpErr := CreateRootReportObject(rootReportObjParam)
	if tmpErr != nil {
		err = fmt.Errorf("Create root report object by reportId:%s error,%s ", param.Id, tmpErr.Error())
		log.Logger.Error("Create root report object by reportId error", log.String("reportId", param.Id), log.Error(err))
		return
	}
	actions = append(actions, rootReportObjActions...)

	err = transaction(actions)
	if err != nil {
		err = fmt.Errorf("Try to create report fail,%s ", err.Error())
	}
	return
}

func UpdateReport(param models.ModifyReport) (rowData *models.SysReportTable, err error) {
	var reportList []*models.SysReportTable
	err = x.SQL("select id,name,ci_type,create_time,create_user,update_time,update_user from sys_report where id=?", param.Id).Find(&reportList)
	if err != nil {
		return
	}
	if len(reportList) == 0 {
		return nil, fmt.Errorf("Can not find report with id:%s ", param.Id)
	}
	rowData = reportList[0]
	actions := []*execAction{}
	updateTime := time.Now().Format(models.DateTimeFormat)
	rowData.Name = param.Name
	rowData.UpdateTime = updateTime
	rowData.UpdateUser = param.UpdateUser
	actions = append(actions, &execAction{Sql: "update sys_report set name=?,update_user=?,update_time=? where id=?", Param: []interface{}{param.Name, param.UpdateUser, updateTime, param.Id}})
	var reportObjTable []*models.SysReportObjectTable
	x.SQL("select id from sys_report_object where report=? and parent_object is null", param.Id).Find(&reportObjTable)
	if len(reportObjTable) > 0 {
		actions = append(actions, &execAction{Sql: "update sys_report_object set data_name=?,data_title_name=? where id=?", Param: []interface{}{param.DataName, param.DataTitleName, reportObjTable[0].Id}})
	}
	actions = append(actions, &execAction{Sql: "delete from sys_role_report where report=?", Param: []interface{}{param.Id}})
	// 添加 report 对应的权限到 sys_role_report
	var useRoleSlice, mgmtRoleSlice []string
	if param.UseRole != "" {
		useRoleSlice = strings.Split(param.UseRole, ",")
	}
	if param.MgmtRole != "" {
		mgmtRoleSlice = strings.Split(param.MgmtRole, ",")
	}
	execSqlCmd := "INSERT INTO sys_role_report(id,role,report,permission) VALUE (?,?,?,?)"
	reportId := param.Id
	var role_report_id string
	for i := range useRoleSlice {
		role_report_id = useRoleSlice[i] + "__" + reportId + "__" + "USE"
		execParams := []interface{}{role_report_id, useRoleSlice[i], reportId, "USE"}
		action := &execAction{Sql: execSqlCmd, Param: execParams}
		actions = append(actions, action)
	}
	for i := range mgmtRoleSlice {
		role_report_id = mgmtRoleSlice[i] + "__" + reportId + "__" + "MGMT"
		execParams := []interface{}{role_report_id, mgmtRoleSlice[i], reportId, "MGMT"}
		action := &execAction{Sql: execSqlCmd, Param: execParams}
		actions = append(actions, action)
	}
	err = transaction(actions)
	return
}

func DeleteReport(reportId string) (err error) {
	// 需要删除 report 关联的 report object 以及对应的 report object attr
	actions := []*execAction{}
	tableName := "sys_report"
	action, _ := GetDeleteTableExecAction(tableName, "id", reportId)
	actions = append(actions, action)

	// 按 seq_no 从小到大排序，可保证父 report object 是在子 report object 之前的，后面删除时需要逆序进行
	sqlCmd := `SELECT id FROM sys_report_object WHERE report=? order by seq_no`
	rowData, tmpErr := x.QueryString(sqlCmd, reportId)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query report object by reportId error", log.String("reportId", reportId), log.Error(err))
		return
	}

	if len(rowData) > 0 {
		// 需要删除的 report object
		reportObjectIds := []string{}
		for i := range rowData {
			reportObjectIds = append(reportObjectIds, rowData[i]["id"])
		}

		for i := range reportObjectIds {
			tableName = "sys_report_object"
			action, _ := GetDeleteTableExecAction(tableName, "id", reportObjectIds[i])
			actions = append(actions, action)
		}

		// 需要删除的 report object attr
		roIdStr := strings.Join(reportObjectIds, "','")
		sqlCmd = "SELECT id FROM sys_report_object_attr WHERE report_object IN ('" + roIdStr + "')"
		roAttrData, tmpErr := x.QueryString(sqlCmd)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object attr by reportObject error,%s ", tmpErr.Error())
			log.Logger.Error("Query report object attr by reportObject error", log.Error(err))
			return
		}
		if len(roAttrData) > 0 {
			for i := range roAttrData {
				tableName = "sys_report_object_attr"
				action, _ := GetDeleteTableExecAction(tableName, "id", roAttrData[i]["id"])
				actions = append(actions, action)
			}
		}

		// 删除 report 的权限
		tableName = "sys_role_report"
		action, _ := GetDeleteTableExecAction(tableName, "report", reportId)
		actions = append(actions, action)

	}
	// 防止因 foreign key constraint 而无法删除, 即从 reportObjectAttr -> reportObject -> report 的顺序删除
	for i, j := 0, len(actions)-1; i < j; {
		actions[i], actions[j] = actions[j], actions[i]
		i++
		j--
	}
	err = transaction(actions)
	return
}

func CreateRootReportObject(param models.ModifyReportObject) (actions []*execAction, err error) {
	if param.Id == "" {
		// 该 report object 为新增
		reportObjectData := &models.SysReportObjectTable{Id: param.Report + "__" + param.DataName,
			Report: param.Report, ParentObject: "", ParentAttr: "", CiType: param.CiType, MyAttr: "",
			DataName: param.DataName, DataTitleName: param.DataTitleName}

		// 获取该 report 下 report object 的 max seq_no 值
		curSeqNo, tmpErr := QueryMaxReportObjetSeqNo(param.Report)
		if tmpErr != nil {
			err = fmt.Errorf("Query max report object seq_no by reportId:%s error,%s ", param.Report, tmpErr.Error())
			log.Logger.Error("Query max report object seq_no by reportId error", log.String("reportId", param.Report), log.Error(err))
			return
		}
		reportObjectData.SeqNo = curSeqNo + 1
		curSeqNo += 1

		// 新增该 report object 的子 report object
		childReportObject := []*models.SysReportObjectTable{}
		for i := range param.Object {
			curChild := &models.SysReportObjectTable{Id: param.Report + "__" + param.Object[i].DataName,
				Report: param.Report, ParentObject: reportObjectData.Id, ParentAttr: param.Object[i].ParentAttr, CiType: param.Object[i].CiType, MyAttr: param.Object[i].MyAttr,
				DataName: param.Object[i].DataName, DataTitleName: param.Object[i].DataTitleName, SeqNo: curSeqNo + 1}
			childReportObject = append(childReportObject, curChild)
			curSeqNo += 1
		}

		// 新增该 report object 的 report object attr
		reportObjectAttr := []*models.SysReportObjectAttrTable{}
		// 获取 default report object attr
		defaultReportObjAttr := models.Config.DefaultReportObjAttr
		defaultRoAttrMap := make(map[string]map[string]string)
		for i := range defaultReportObjAttr {
			v := defaultReportObjAttr[i]
			defaultRoAttrMap[v.Id] = make(map[string]string)
			defaultRoAttrMap[v.Id]["title"] = v.Title
			defaultRoAttrMap[v.Id]["querialbe"] = v.Querialbe
		}

		// 添加 default report object attr
		for k, v := range defaultRoAttrMap {
			defaultRoAttrCiTypeAttr := reportObjectData.CiType + "__" + k
			curAttr := &models.SysReportObjectAttrTable{Id: reportObjectData.Id + "__" + k,
				ReportObject: reportObjectData.Id, CiTypeAttr: defaultRoAttrCiTypeAttr, DataName: k,
				DataTitleName: v["title"], Querialbe: v["querialbe"]}
			reportObjectAttr = append(reportObjectAttr, curAttr)
		}

		for i := range param.Attr {
			if _, ok := defaultRoAttrMap[param.Attr[i].DataName]; ok {
				defaultRoAttrCiTypeAttr := reportObjectData.CiType + "__" + param.Attr[i].DataName
				if param.Attr[i].CiTypeAttr == defaultRoAttrCiTypeAttr {
					continue
				} else {
					err = fmt.Errorf("The report object attr's ciTypeAttr:%s of report object: %s is conflict with "+
						"default report object attr's ciTypeAttr: %s ", param.Attr[i].CiTypeAttr, reportObjectData.Id, defaultRoAttrCiTypeAttr)
					log.Logger.Error("The report object attr's ciTypeAttr of report object is conflict with "+
						"default report object attr's ciTypeAttr", log.Error(err))
					return
				}
			}
			curAttr := &models.SysReportObjectAttrTable{Id: reportObjectData.Id + "__" + param.Attr[i].DataName,
				ReportObject: reportObjectData.Id, CiTypeAttr: param.Attr[i].CiTypeAttr, DataName: param.Attr[i].DataName,
				DataTitleName: param.Attr[i].DataTitleName, Querialbe: param.Attr[i].Querialbe}
			reportObjectAttr = append(reportObjectAttr, curAttr)
		}
		// 当 transNullStr 的 key 表示的字段为空时，表示需要将其插入 null
		transNullStr := make(map[string]string)
		transNullStr["parent_object"] = "true"
		transNullStr["parent_attr"] = "true"
		transNullStr["my_attr"] = "true"

		tableName := "sys_report_object"
		action, _ := GetInsertTableExecAction(tableName, *reportObjectData, transNullStr)
		actions = append(actions, action)

		for i := range childReportObject {
			action, _ := GetInsertTableExecAction(tableName, *childReportObject[i], transNullStr)
			actions = append(actions, action)
		}

		tableName = "sys_report_object_attr"
		for i := range reportObjectAttr {
			action, _ := GetInsertTableExecAction(tableName, *reportObjectAttr[i], nil)
			actions = append(actions, action)
		}
	}
	return
}

func ModifyReportObject(param models.ModifyReportObject) (err error) {
	actions := []*execAction{}
	if param.Id == "" {
		// 该 report object 为新增
		reportObjActions, tmpErr := CreateRootReportObject(param)
		if tmpErr != nil {
			err = fmt.Errorf("Create root report object by reportId:%s error,%s ", param.Report, tmpErr.Error())
			log.Logger.Error("Create root report object by reportId error", log.String("reportId", param.Report), log.Error(err))
			return
		}
		actions = append(actions, reportObjActions...)
	} else {
		// 该 report object 已存在
		sqlCmd := "SELECT * FROM sys_report_object WHERE id=?"
		reportObjectId := param.Id
		var rowData []*models.SysReportObjectTable
		tmpErr := x.SQL(sqlCmd, reportObjectId).Find(&rowData)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object by Id:%s error,%s ", reportObjectId, tmpErr.Error())
			log.Logger.Error("Query report object by Id error", log.String("reportObjectId", reportObjectId), log.Error(err))
			return
		}
		if len(rowData) == 0 {
			err = fmt.Errorf("Report object: %s not found", reportObjectId)
			log.Logger.Error("Report object not found", log.String("Id", reportObjectId), log.Error(err))
			return
		}
		curReportObject := rowData[0]
		reportObjectData := &models.SysReportObjectTable{Id: curReportObject.Id,
			Report: param.Report, ParentObject: curReportObject.ParentObject, ParentAttr: curReportObject.ParentAttr, CiType: curReportObject.CiType,
			MyAttr: curReportObject.MyAttr, DataName: param.DataName, DataTitleName: param.DataTitleName, SeqNo: curReportObject.SeqNo}

		// 当 transNullStr 的 key 表示的字段为空时，表示需要将其插入 null
		transNullStr := make(map[string]string)
		transNullStr["parent_object"] = "true"
		transNullStr["parent_attr"] = "true"
		transNullStr["my_attr"] = "true"

		tableName := "sys_report_object"
		action, _ := GetUpdateTableExecAction(tableName, "id", curReportObject.Id, *reportObjectData, transNullStr)
		actions = append(actions, action)

		// 获取该 report 下 report object 的 max seq_no 值
		curSeqNo, tmpErr := QueryMaxReportObjetSeqNo(param.Report)
		if tmpErr != nil {
			err = fmt.Errorf("Query max report object seq_no by reportId:%s error,%s ", param.Report, tmpErr.Error())
			log.Logger.Error("Query max report object seq_no by reportId error", log.String("reportId", param.Report), log.Error(err))
			return
		}

		// 获取该 report object 下的所有子 report object
		parentObjectId := reportObjectId
		sqlCmd = "SELECT id,seq_no FROM sys_report_object WHERE parent_object=?"
		var childReportObject []*models.SysReportObjectTable
		tmpErr = x.SQL(sqlCmd, parentObjectId).Find(&childReportObject)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object by parent object:%s error,%s ", parentObjectId, tmpErr.Error())
			log.Logger.Error("Query report object by parent object error", log.String("parentObjectId", parentObjectId), log.Error(err))
			return
		}
		existChildReportObjectIds := make(map[string]int)
		for i := range childReportObject {
			existChildReportObjectIds[childReportObject[i].Id] = childReportObject[i].SeqNo
		}

		// 区分该 report object 的子 report object 是新增的，更新的，还是需要删除的
		createChildReportObject := []*models.SysReportObjectTable{}
		updateChildReportObject := []*models.SysReportObjectTable{}
		for i := range param.Object {
			if param.Object[i].Id == "" {
				// 新增的 report object
				curChild := &models.SysReportObjectTable{Id: param.Report + "__" + param.Object[i].DataName,
					Report: param.Report, ParentObject: curReportObject.Id, ParentAttr: param.Object[i].ParentAttr, CiType: param.Object[i].CiType, MyAttr: param.Object[i].MyAttr,
					DataName: param.Object[i].DataName, DataTitleName: param.Object[i].DataTitleName, SeqNo: curSeqNo + 1}
				createChildReportObject = append(createChildReportObject, curChild)
				curSeqNo += 1
			} else {
				reportObjId := param.Object[i].Id
				curChild := &models.SysReportObjectTable{Id: reportObjId,
					Report: param.Report, ParentObject: curReportObject.Id, ParentAttr: param.Object[i].ParentAttr, CiType: param.Object[i].CiType, MyAttr: param.Object[i].MyAttr,
					DataName: param.Object[i].DataName, DataTitleName: param.Object[i].DataTitleName, SeqNo: existChildReportObjectIds[reportObjId]}
				updateChildReportObject = append(updateChildReportObject, curChild)
				delete(existChildReportObjectIds, reportObjId)
			}
		}

		deleteChildReportObjectIds := []string{}
		for k := range existChildReportObjectIds {
			deleteChildReportObjectIds = append(deleteChildReportObjectIds, k)
		}

		tableName = "sys_report_object"
		for i := range createChildReportObject {
			action, _ := GetInsertTableExecAction(tableName, *createChildReportObject[i], nil)
			actions = append(actions, action)
		}

		for i := range updateChildReportObject {
			action, _ := GetUpdateTableExecAction(tableName, "id", updateChildReportObject[i].Id, *updateChildReportObject[i], transNullStr)
			actions = append(actions, action)
		}

		for i := range deleteChildReportObjectIds {
			// 需要删除对应 report objects 下面的所有 report objects 及其 report objects attr
			// 注意删除顺序：子 report object -> 根 report object, 且删除对应的 report object 前需先删除 report object attr
			deleteActions, tmpErr := GenReportObjectDelAction(deleteChildReportObjectIds[i])
			if tmpErr != nil {
				err = fmt.Errorf("Gen delete child report object actions by report object:%s error,%s ", deleteChildReportObjectIds[i], tmpErr.Error())
				log.Logger.Error("Gen delete child report object actions by report object error", log.String("reportObjectId", deleteChildReportObjectIds[i]), log.Error(err))
				return
			}
			actions = append(actions, deleteActions...)
		}

		// 获取该 report object 下的所有 report object attr
		sqlCmd = "SELECT id FROM sys_report_object_attr WHERE report_object=?"
		var reportObjectAttr []*models.SysReportObjectAttrTable
		tmpErr = x.SQL(sqlCmd, reportObjectId).Find(&reportObjectAttr)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object attr by report object:%s error,%s ", reportObjectId, tmpErr.Error())
			log.Logger.Error("Query report object attr by report object error", log.String("reportObjectId", reportObjectId), log.Error(err))
			return
		}
		existReportObjectAttrIds := make(map[string]int)
		for i := range reportObjectAttr {
			existReportObjectAttrIds[reportObjectAttr[i].Id] = 0
		}

		// 获取 default report object attr
		defaultReportObjAttr := models.Config.DefaultReportObjAttr
		defaultRoAttrMap := make(map[string]map[string]string)
		defaultRoAttrIds := make(map[string]int)
		for i := range defaultReportObjAttr {
			v := defaultReportObjAttr[i]
			defaultRoAttrMap[v.Id] = make(map[string]string)
			defaultRoAttrMap[v.Id]["title"] = v.Title
			defaultRoAttrMap[v.Id]["querialbe"] = v.Querialbe
			defaultRoAttrIds[reportObjectData.Id+"__"+v.Id] = 1
		}

		for i := range reportObjectAttr {
			if _, ok := defaultRoAttrIds[reportObjectAttr[i].Id]; ok {
				// 需要创建的 default report object attr, 若已存在, 则无需新增
				delete(defaultRoAttrIds, reportObjectAttr[i].Id)

				// 将 default report object attr 从已存在的集合中删除，以防被删掉
				delete(existReportObjectAttrIds, reportObjectAttr[i].Id)
			}
		}

		// 区分该 report object 的 report object attr 是新增的，更新的，还是需要删除的
		createReportObjectAttr := []*models.SysReportObjectAttrTable{}
		updateReportObjectAttr := []*models.SysReportObjectAttrTable{}

		// 添加需要创建的 default report object attr
		for k, v := range defaultRoAttrMap {
			if _, ok := defaultRoAttrIds[reportObjectData.Id+"__"+k]; ok {
				defaultRoAttrCiTypeAttr := reportObjectData.CiType + "__" + k
				curAttr := &models.SysReportObjectAttrTable{Id: reportObjectData.Id + "__" + k,
					ReportObject: reportObjectData.Id, CiTypeAttr: defaultRoAttrCiTypeAttr, DataName: k,
					DataTitleName: v["title"], Querialbe: v["querialbe"]}
				createReportObjectAttr = append(createReportObjectAttr, curAttr)
			}
		}

		for i := range param.Attr {
			if _, ok := defaultRoAttrMap[param.Attr[i].DataName]; ok {
				defaultRoAttrCiTypeAttr := reportObjectData.CiType + "__" + param.Attr[i].DataName
				if param.Attr[i].CiTypeAttr == defaultRoAttrCiTypeAttr {
					continue
				} else {
					err = fmt.Errorf("The report object attr's ciTypeAttr:%s of report object: %s is conflict with "+
						"default report object attr's ciTypeAttr: %s ", param.Attr[i].CiTypeAttr, reportObjectData.Id, defaultRoAttrCiTypeAttr)
					log.Logger.Error("The report object attr's ciTypeAttr of report object is conflict with "+
						"default report object attr's ciTypeAttr", log.Error(err))
					return
				}
			}
			if param.Attr[i].Id == "" {
				// 新增的 report object attr
				curAttr := &models.SysReportObjectAttrTable{Id: reportObjectData.Id + "__" + param.Attr[i].DataName,
					ReportObject: reportObjectData.Id, CiTypeAttr: param.Attr[i].CiTypeAttr, DataName: param.Attr[i].DataName,
					DataTitleName: param.Attr[i].DataTitleName, Querialbe: param.Attr[i].Querialbe}
				createReportObjectAttr = append(createReportObjectAttr, curAttr)
			} else {
				reportObjAttrId := param.Attr[i].Id
				curAttr := &models.SysReportObjectAttrTable{Id: reportObjAttrId,
					ReportObject: reportObjectData.Id, CiTypeAttr: param.Attr[i].CiTypeAttr, DataName: param.Attr[i].DataName,
					DataTitleName: param.Attr[i].DataTitleName, Querialbe: param.Attr[i].Querialbe}
				updateReportObjectAttr = append(updateReportObjectAttr, curAttr)
				delete(existReportObjectAttrIds, reportObjAttrId)
			}
		}

		deleteReportObjectAttrIds := []string{}
		for k := range existReportObjectAttrIds {
			deleteReportObjectAttrIds = append(deleteReportObjectAttrIds, k)
		}

		// 为新增的子 report object 创建 default report object attr
		for i := range createChildReportObject {
			for k, v := range defaultRoAttrMap {
				defaultRoAttrCiTypeAttr := createChildReportObject[i].CiType + "__" + k
				curAttr := &models.SysReportObjectAttrTable{Id: createChildReportObject[i].Id + "__" + k,
					ReportObject: createChildReportObject[i].Id, CiTypeAttr: defaultRoAttrCiTypeAttr, DataName: k,
					DataTitleName: v["title"], Querialbe: v["querialbe"]}
				createReportObjectAttr = append(createReportObjectAttr, curAttr)
			}
		}

		tableName = "sys_report_object_attr"
		for i := range createReportObjectAttr {
			action, _ := GetInsertTableExecAction(tableName, *createReportObjectAttr[i], nil)
			actions = append(actions, action)
		}

		for i := range updateReportObjectAttr {
			action, _ := GetUpdateTableExecAction(tableName, "id", updateReportObjectAttr[i].Id, *updateReportObjectAttr[i], nil)
			actions = append(actions, action)
		}

		for i := range deleteReportObjectAttrIds {
			action, _ := GetDeleteTableExecAction(tableName, "id", deleteReportObjectAttrIds[i])
			actions = append(actions, action)
		}
	}
	err = transaction(actions)
	return
}

func GenReportObjectDelAction(reportObjectId string) (actions []*execAction, err error) {
	allReportObjectIds := []string{}
	curReportObjectIdsQueue := []string{reportObjectId}
	sqlCmd := "SELECT id FROM sys_report_object WHERE parent_object=?"
	for len(curReportObjectIdsQueue) > 0 {
		n := len(curReportObjectIdsQueue)

		for i := 0; i < n; i++ {
			var childReportObject []*models.SysReportObjectTable
			tmpErr := x.SQL(sqlCmd, curReportObjectIdsQueue[i]).Find(&childReportObject)
			if tmpErr != nil {
				err = fmt.Errorf("Query child report object by report object:%s error,%s ", curReportObjectIdsQueue[i], tmpErr.Error())
				log.Logger.Error("Query child report object by report object error", log.String("reportObjectId", curReportObjectIdsQueue[i]), log.Error(err))
				return
			}
			// 处理下一层的子 reportObject
			for j := 0; j < len(childReportObject); j++ {
				curReportObjectIdsQueue = append(curReportObjectIdsQueue, childReportObject[j].Id)
			}
			// 处理当前层的当前 reportObject, 生成当前 reportObject 的 action
			allReportObjectIds = append(allReportObjectIds, curReportObjectIdsQueue[i])
			action, _ := GetDeleteTableExecAction("sys_report_object", "id", curReportObjectIdsQueue[i])
			actions = append(actions, action)
		}
		curReportObjectIdsQueue = curReportObjectIdsQueue[n:]
	}
	// 处理上述所有 report object 的 attr
	allRoIdStr := strings.Join(allReportObjectIds, "','")
	sqlCmd = "SELECT id FROM sys_report_object_attr WHERE report_object IN ('" + allRoIdStr + "')"
	roAttrData, tmpErr := x.QueryString(sqlCmd)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object attr by reportObject error,%s ", tmpErr.Error())
		log.Logger.Error("Query report object attr by reportObject error", log.Error(err))
		return
	}
	if len(roAttrData) > 0 {
		for i := range roAttrData {
			tableName := "sys_report_object_attr"
			action, _ := GetDeleteTableExecAction(tableName, "id", roAttrData[i]["id"])
			actions = append(actions, action)
		}
	}

	// 防止因 foreign key constraint 而无法删除, 即先删 reportObjectAttr, 再从子 reportObject -> 父 reportObject 顺序删除
	for i, j := 0, len(actions)-1; i < j; {
		actions[i], actions[j] = actions[j], actions[i]
		i++
		j--
	}
	return
}

func GetInsertTableExecAction(tableName string, data interface{}, transNullStr map[string]string) (action *execAction, err error) {
	execParams := []interface{}{}
	columnStr := ""
	valueStr := ""
	t := reflect.TypeOf(data)
	v := reflect.ValueOf(data)
	for i := 0; i < t.NumField(); i++ {
		if i > 0 {
			columnStr += ","
			valueStr += ","
		}
		columnStr += t.Field(i).Tag.Get("xorm")
		valueStr += "?"

		if len(transNullStr) > 0 {
			if _, ok := transNullStr[t.Field(i).Tag.Get("xorm")]; ok {
				execParams = append(execParams, NewNullString(v.FieldByName(t.Field(i).Name).String()))
			} else {
				execParams = append(execParams, v.FieldByName(t.Field(i).Name).Interface())
			}
		} else {
			execParams = append(execParams, v.FieldByName(t.Field(i).Name).Interface())
		}
	}
	execSqlCmd := "INSERT INTO " + tableName + "("
	execSqlCmd += columnStr + ") VALUE (" + valueStr + ")"
	action = &execAction{Sql: execSqlCmd, Param: execParams}
	return
}

func GetUpdateTableExecAction(tableName string, primeKey string, primeKeyVal string, data interface{}, transNullStr map[string]string) (action *execAction, err error) {
	execParams := []interface{}{}
	columnStr := ""
	t := reflect.TypeOf(data)
	v := reflect.ValueOf(data)
	for i := 0; i < t.NumField(); i++ {
		if i > 0 {
			columnStr += ","
		}
		columnStr += t.Field(i).Tag.Get("xorm")
		columnStr += "=?"

		if len(transNullStr) > 0 {
			if _, ok := transNullStr[t.Field(i).Tag.Get("xorm")]; ok {
				execParams = append(execParams, NewNullString(v.FieldByName(t.Field(i).Name).String()))
			} else {
				execParams = append(execParams, v.FieldByName(t.Field(i).Name).Interface())
			}
		} else {
			execParams = append(execParams, v.FieldByName(t.Field(i).Name).Interface())
		}
	}
	execSqlCmd := "UPDATE " + tableName + " SET "
	execSqlCmd += columnStr
	execSqlCmd += " WHERE " + primeKey + "=?"
	execParams = append(execParams, primeKeyVal)
	action = &execAction{Sql: execSqlCmd, Param: execParams}
	return
}

func GetDeleteTableExecAction(tableName string, primeKey string, primeKeyVal string) (action *execAction, err error) {
	execParams := []interface{}{}
	execSqlCmd := "DELETE FROM " + tableName + " WHERE " + primeKey + "=?"
	execParams = append(execParams, primeKeyVal)
	action = &execAction{Sql: execSqlCmd, Param: execParams}
	return
}

func NewNullString(s string) sql.NullString {
	if len(s) == 0 {
		return sql.NullString{}
	}
	return sql.NullString{
		String: s,
		Valid:  true,
	}
}

func QueryMaxReportObjetSeqNo(reportId string) (seqNo int, err error) {
	sqlCmd := `SELECT MAX(seq_no) as seq_no FROM sys_report_object WHERE report=?`
	rowData, tmpErr := x.QueryString(sqlCmd, reportId)
	if tmpErr != nil {
		err = fmt.Errorf("Query max report object seq_no by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query max report object seq_no by reportId error", log.String("reportId", reportId), log.Error(err))
		seqNo = 0
		return
	}
	if len(rowData) == 0 || rowData[0]["seq_no"] == "" {
		seqNo = 0
		return
	}
	tmpSeqNo, _ := strconv.Atoi(rowData[0]["seq_no"])
	seqNo = tmpSeqNo
	return
}

func isReportObjEditable(reportObjId string) bool {
	queryRows, err := x.QueryString("select editable from sys_graph_element where report_object=?", reportObjId)
	if err != nil {
		log.Logger.Error("Try to judge report object is editable fail", log.Error(err))
		return true
	}
	if len(queryRows) > 0 {
		if queryRows[0]["editable"] == "no" {
			return false
		}
	}
	return true
}

func GetPermissiveReportId(permissions []string, roles []string, hasReportIds []string) (reportIds []string, err error) {
	permissionStr := strings.Join(permissions, "','")
	roleStr := strings.Join(roles, "','")
	sqlCmd := "SELECT DISTINCT report FROM sys_role_report WHERE role IN ('" + roleStr + "')" + " AND permission IN ('" + permissionStr + "')"
	if len(hasReportIds) > 0 {
		reportIdStr := strings.Join(hasReportIds, "','")
		sqlCmd += " AND view IN ('" + reportIdStr + "')"
	}
	rowData, tmpErr := x.QueryString(sqlCmd)
	if tmpErr != nil {
		err = fmt.Errorf("Query permissive report ids in role report error:%s", tmpErr.Error())
		log.Logger.Error("Query permissive report ids in role report error", log.Error(err))
	}
	for i := range rowData {
		reportIds = append(reportIds, rowData[i]["report"])
	}
	return
}

func QueryReportFlatStruct(reportId string) (rowData *models.QueryReport, err error) {
	sqlCmd := "SELECT * FROM sys_report WHERE id=?"
	var tmpRowData []*models.QueryReport
	tmpErr := x.SQL(sqlCmd, reportId).Find(&tmpRowData)
	if tmpErr != nil {
		err = fmt.Errorf("Query report by reportId:%s error,%s ", reportId, tmpErr.Error())
		log.Logger.Error("Query report by reportId error", log.String("reportId", reportId), log.Error(err))
		return
	}
	if len(tmpRowData) == 0 {
		log.Logger.Warn("Query report by reportId fail", log.Error(err))
		return
	}
	rowData = tmpRowData[0]
	// 查找 report 对应的 report object
	sqlCmd = `SELECT * FROM sys_report_object WHERE report=? ORDER BY seq_no;`
	var roData []*models.QueryReportObject
	tmpErr = x.SQL(sqlCmd, rowData.Id).Find(&roData)
	if tmpErr != nil {
		err = fmt.Errorf("Query report object by report:%s error,%s ", rowData.Id, tmpErr.Error())
		log.Logger.Error("Query report object by report error", log.String("report", rowData.Id), log.Error(err))
		return
	}
	if len(roData) == 0 {
		log.Logger.Warn("Query report object by report fail", log.String("report", rowData.Id), log.Error(err))
		return
	}

	for i := range roData {
		var roAttrsData []*models.QueryReportObjectAttr
		// 查找 report object data 对应的 attrs
		sqlCmd = "SELECT * FROM sys_report_object_attr WHERE report_object=?"
		tmpErr = x.SQL(sqlCmd, roData[i].Id).Find(&roAttrsData)
		if tmpErr != nil {
			err = fmt.Errorf("Query report object attrs by reportObjs error,%s ", tmpErr.Error())
			log.Logger.Error("Query report object attrs by reportObjs error", log.Error(err))
			return
		}
		if len(roAttrsData) == 0 {
			log.Logger.Warn("Query report object attrs by reportObjs fail", log.Error(err))
		}
		tmpRoAttrsData := roAttrsData
		roData[i].Attr = tmpRoAttrsData
	}
	rowData.Object = roData
	return
}

func QueryReportObject(param *models.QueryRequestParam) (pageInfo models.PageInfo, rowData []*models.SysReportObjectTable, err error) {
	rowData = []*models.SysReportObjectTable{}
	filterSql, queryColumn, queryParam := transFiltersToSQL(param, &models.TransFiltersParam{IsStruct: true, StructObj: models.SysReportObjectTable{}, PrimaryKey: "id"})
	baseSql := fmt.Sprintf("SELECT %s FROM sys_report_object WHERE 1=1 %s ", queryColumn, filterSql)
	if param.Paging {
		pageInfo.StartIndex = param.Pageable.StartIndex
		pageInfo.PageSize = param.Pageable.PageSize
		pageInfo.TotalRows = queryCount(baseSql, queryParam...)
		pageSql, pageParam := transPageInfoToSQL(*param.Pageable)
		baseSql += pageSql
		queryParam = append(queryParam, pageParam...)
	}
	err = x.SQL(baseSql, queryParam...).Find(&rowData)
	return
}

func QueryReportAttr(param *models.QueryRequestParam) (pageInfo models.PageInfo, rowData []*models.SysReportObjectAttrTable, err error) {
	rowData = []*models.SysReportObjectAttrTable{}
	filterSql, queryColumn, queryParam := transFiltersToSQL(param, &models.TransFiltersParam{IsStruct: true, StructObj: models.SysReportObjectAttrTable{}, PrimaryKey: "id"})
	baseSql := fmt.Sprintf("SELECT %s FROM sys_report_object_attr WHERE 1=1 %s ", queryColumn, filterSql)
	if param.Paging {
		pageInfo.StartIndex = param.Pageable.StartIndex
		pageInfo.PageSize = param.Pageable.PageSize
		pageInfo.TotalRows = queryCount(baseSql, queryParam...)
		pageSql, pageParam := transPageInfoToSQL(*param.Pageable)
		baseSql += pageSql
		queryParam = append(queryParam, pageParam...)
	}
	err = x.SQL(baseSql, queryParam...).Find(&rowData)
	return
}

func ExportReportData(param *models.ExportReportParam) (result *models.ExportReportResult, err error) {
	var reportRows []*models.SysReportTable
	if err = x.SQL("select id,ci_type from sys_report where id=?", param.ReportId).Find(&reportRows); err != nil {
		return
	}
	if len(reportRows) == 0 {
		err = fmt.Errorf("can not find report %s ", param.ReportId)
		return
	}
	result = &models.ExportReportResult{ReportId: param.ReportId, ExportTime: time.Now().Format(models.DateTimeFormat), RootCiType: reportRows[0].CiType, CiData: []*models.ExportReportCiData{}}
	var reportObjectRows []*models.SysReportObjectTable
	if err = x.SQL("select * from sys_report_object where report=?", param.ReportId).Find(&reportObjectRows); err != nil {
		return
	}
	var rootReportObject models.SysReportObjectTable
	reportObjectCiTypeMap := make(map[string]string)
	for _, row := range reportObjectRows {
		if row.ParentObject == "" {
			rootReportObject = *row
		}
		reportObjectCiTypeMap[row.Id] = row.CiType
	}
	var reportObjectAttrRows []*models.SysReportObjectAttrTable
	if err = x.SQL("select * from sys_report_object_attr where report_object in (select id from sys_report_object where report=?) order by id", param.ReportId).Find(&reportObjectAttrRows); err != nil {
		return
	}
	attrMap := make(map[string][]*models.SysReportObjectAttrTable)
	for _, row := range reportObjectAttrRows {
		if v, b := attrMap[row.ReportObject]; b {
			attrMap[row.ReportObject] = append(v, row)
		} else {
			attrMap[row.ReportObject] = []*models.SysReportObjectAttrTable{row}
		}
	}
	result.CiData, err = getExportReportCiData(&rootReportObject, param.RootCiData, reportObjectRows, attrMap, reportObjectCiTypeMap)
	return
}

func getExportReportCiData(reportObject *models.SysReportObjectTable, guids []string, reportObjects []*models.SysReportObjectTable, attrMap map[string][]*models.SysReportObjectAttrTable, reportObjectCiTypeMap map[string]string) (result []*models.ExportReportCiData, err error) {
	exportObj := models.ExportReportCiData{CiType: reportObject.CiType, ParentCiType: reportObjectCiTypeMap[reportObject.ParentObject]}
	var guidFilterValues []interface{}
	for _, v := range guids {
		guidFilterValues = append(guidFilterValues, v)
	}
	queryParam := models.QueryRequestParam{Dialect: &models.QueryRequestDialect{QueryMode: "new"}, Filters: []*models.QueryRequestFilterObj{}}
	columnAttrExistsMap := make(map[string]int)
	queryParamFilterColumn := "guid"
	for _, attr := range attrMap[reportObject.Id] {
		attrName := strings.Split(attr.CiTypeAttr, models.SysTableIdConnector)[1]
		queryParam.ResultColumns = append(queryParam.ResultColumns, attrName)
		exportObj.Attributes = append(exportObj.Attributes, attrName)
		columnAttrExistsMap[attrName] = 1
	}
	if strings.Contains(reportObject.ParentAttr, models.SysTableIdConnector) {
		exportObj.ParentAttribute = strings.Split(reportObject.ParentAttr, models.SysTableIdConnector)[1]
	}
	if strings.Contains(reportObject.MyAttr, models.SysTableIdConnector) {
		exportObj.RefParentAttribute = strings.Split(reportObject.MyAttr, models.SysTableIdConnector)[1]
		queryParamFilterColumn = exportObj.RefParentAttribute
		if _, b := columnAttrExistsMap[exportObj.RefParentAttribute]; !b {
			columnAttrExistsMap[exportObj.RefParentAttribute] = 1
			queryParam.ResultColumns = append(queryParam.ResultColumns, exportObj.RefParentAttribute)
			exportObj.Attributes = append(exportObj.Attributes, exportObj.RefParentAttribute)
		}
	}
	queryParam.Filters = append(queryParam.Filters, &models.QueryRequestFilterObj{Name: queryParamFilterColumn, Operator: "in", Value: guidFilterValues})
	for _, v := range reportObjects {
		if v.ParentObject == reportObject.Id && v.ParentAttr != "" {
			parentAttr := strings.Split(v.ParentAttr, models.SysTableIdConnector)[1]
			if _, b := columnAttrExistsMap[parentAttr]; !b {
				columnAttrExistsMap[parentAttr] = 1
				queryParam.ResultColumns = append(queryParam.ResultColumns, parentAttr)
				exportObj.Attributes = append(exportObj.Attributes, parentAttr)
			}
		}
	}
	_, rowData, queryErr := CiDataQuery(reportObject.CiType, &queryParam, &models.CiDataLegalGuidList{Enable: true}, true)
	if queryErr != nil {
		err = fmt.Errorf("query ciType:%s data fail,%s ", reportObject.CiType, queryErr.Error())
		return
	}
	for _, v := range rowData {
		delete(v, "nextOperations")
		exportObj.Data = append(exportObj.Data, v)
	}
	result = append(result, &exportObj)
	// children
	for _, v := range reportObjects {
		if v.ParentObject == reportObject.Id {
			childGuids := []string{}
			parentAttr := strings.Split(v.ParentAttr, models.SysTableIdConnector)[1]
			for _, ciRowDataMap := range exportObj.Data {
				if rowValue, b := ciRowDataMap[parentAttr]; b {
					childGuids = append(childGuids, getRefGuidStringList(rowValue)...)
				}
			}
			childCiData, getChildDataErr := getExportReportCiData(v, childGuids, reportObjects, attrMap, reportObjectCiTypeMap)
			if getChildDataErr != nil {
				err = fmt.Errorf("get child ci type:%s data fail,%s ", v.CiType, getChildDataErr.Error())
				break
			}
			result = append(result, childCiData...)
		}
	}
	return
}

func getRefGuidStringList(input interface{}) (guidList []string) {
	refType := reflect.TypeOf(input).String()
	if refType == "[]string" {
		guidList = input.([]string)
	} else if refType == "[]interface {}" {
		for _, v := range input.([]interface{}) {
			guidList = append(guidList, fmt.Sprintf("%s", v))
		}
	} else {
		guidList = []string{fmt.Sprintf("%s", input)}
	}
	return
}

func ImportCiData(param *models.ExportReportResult, operator string) (err error) {
	tNow := time.Now().Format(models.DateTimeFormat)
	var actions []*execAction
	if len(param.CiData) == 0 {
		return
	}
	newGuidMap := make(map[string]string)
	ciTypeRefColumn := make(map[string]map[string]int)
	for _, ciDataObj := range param.CiData {
		if ciDataObj.ParentCiType != "" {
			if v, b := ciTypeRefColumn[ciDataObj.ParentCiType]; b {
				v[ciDataObj.ParentAttribute] = 1
			} else {
				ciTypeRefColumn[ciDataObj.ParentCiType] = make(map[string]int)
				ciTypeRefColumn[ciDataObj.ParentCiType][ciDataObj.ParentAttribute] = 1
			}
		}
		if ciDataObj.RefParentAttribute != "" {
			if v, b := ciTypeRefColumn[ciDataObj.CiType]; b {
				v[ciDataObj.RefParentAttribute] = 1
			} else {
				ciTypeRefColumn[ciDataObj.CiType] = make(map[string]int)
				ciTypeRefColumn[ciDataObj.CiType][ciDataObj.RefParentAttribute] = 1
			}
		}
		for _, v := range ciDataObj.Data {
			oldGuid := fmt.Sprintf("%s", v["guid"])
			if lastIndex := strings.LastIndex(oldGuid, "_"); lastIndex > 0 {
				newGuid := oldGuid[:lastIndex] + "_" + guid.CreateGuid()
				newGuidMap[oldGuid] = newGuid
			}
		}
	}
	var multiCiData []*models.MultiCiDataObj
	importedCiGuidMap := make(map[string]int)
	for _, ciDataObj := range param.CiData {
		tmpMultiCiDataObj := models.MultiCiDataObj{CiTypeId: ciDataObj.CiType}
		tmpRefColumnsMap := ciTypeRefColumn[ciDataObj.CiType]
		for _, row := range ciDataObj.Data {
			newRowData := make(map[string]string)
			for k, v := range row {
				_, b := tmpRefColumnsMap[k]
				if b || k == "guid" {
					newRowData[k] = getImportRefCiDataNewValue(v, newGuidMap)
				} else {
					newValue, tmpErr := transInputDataToString(v)
					if tmpErr != nil {
						err = fmt.Errorf("ciType:%s key:%s data illegal,%s ", ciDataObj.CiType, k, tmpErr.Error())
						return
					}
					newRowData[k] = newValue
				}
			}
			if _, b := importedCiGuidMap[newRowData["guid"]]; b {
				continue
			} else {
				importedCiGuidMap[newRowData["guid"]] = 1
			}
			tmpMultiCiDataObj.InputData = append(tmpMultiCiDataObj.InputData, newRowData)
		}
		if len(tmpMultiCiDataObj.InputData) > 0 {
			multiCiData = append(multiCiData, &tmpMultiCiDataObj)
		}
	}
	if err != nil {
		return
	}
	// 获取属性字段
	if err = getMultiCiAttributes(multiCiData); err != nil {
		return
	}
	// 获取状态机
	if err = getMultiCiStartTransition(multiCiData); err != nil {
		return
	}
	for _, ciObj := range multiCiData {
		for _, attr := range ciObj.Attributes {
			attr.TextValidate = ""
			attr.Nullable = "yes"
			attr.UniqueConstraint = "no"
		}
		for _, inputRowData := range ciObj.InputData {
			for _, attr := range ciObj.Attributes {
				if _, b := inputRowData[attr.Name]; !b {
					inputRowData[attr.Name] = ""
				}
			}
			actionParam := models.ActionFuncParam{CiType: ciObj.CiTypeId, InputData: inputRowData, Attributes: ciObj.Attributes, ReferenceAttributes: ciObj.ReferenceAttributes, Operator: operator, Operation: "Add", NowTime: tNow, RefCiTypeMap: ciObj.RefCiTypeMap, FromCore: true}
			// 检查数据目标状态
			actionParam.Transition = ciObj.Transition[0]
			// 处理输入,把参数变成对应的SQL加进事务里
			tmpAction, tmpErr := doActionFunc(&actionParam)
			if tmpErr != nil {
				err = fmt.Errorf("CiType:%s do action:%s fail,%s ", ciObj.CiTypeId, actionParam.Transition.Action, tmpErr.Error())
				return
			}
			actions = append(actions, tmpAction...)
		}
	}
	err = transaction(actions)
	return
}

func transInputDataToString(input interface{}) (output string, err error) {
	valueType := reflect.TypeOf(input).String()
	if valueType == "string" {
		output = input.(string)
	} else if valueType == "int" {
		output = fmt.Sprintf("%d", input.(int))
	} else {
		tmpJsonByte, tmpErr := json.Marshal(input)
		if tmpErr != nil {
			err = fmt.Errorf("value type %s not support ", valueType)
		}
		output = string(tmpJsonByte)
	}
	return
}

func getImportRefCiDataNewValue(input interface{}, guidMap map[string]string) (output string) {
	valueType := reflect.TypeOf(input).String()
	valueList := []string{}
	if valueType == "string" {
		stringValue := input.(string)
		if v, b := guidMap[stringValue]; b {
			output = v
		} else {
			output = stringValue
		}
		return
	} else if valueType == "int" {
		output = fmt.Sprintf("%d", input.(int))
		return
	} else if valueType == "[]string" {
		for _, oldValue := range input.([]string) {
			if v, b := guidMap[oldValue]; b {
				valueList = append(valueList, v)
			} else {
				valueList = append(valueList, oldValue)
			}
		}
	} else if valueType == "[]interface {}" {
		for _, oldValue := range input.([]interface{}) {
			oldValueString := fmt.Sprintf("%s", oldValue)
			if v, b := guidMap[oldValueString]; b {
				valueList = append(valueList, v)
			} else {
				valueList = append(valueList, oldValueString)
			}
		}
	}
	tmpJsonByte, _ := json.Marshal(valueList)
	output = string(tmpJsonByte)
	return
}
