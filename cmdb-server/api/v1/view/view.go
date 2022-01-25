package view

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"strings"
)

func GetViewList(c *gin.Context) {
	//Param validate
	paramsMap := make(map[string]interface{})
	if val, ok := c.GetQuery("editable"); ok {
		paramsMap["editable"] = val
	}

	var err error
	var permissiveViewIds []string
	if _, ok := c.GetQuery("permission"); ok {
		roles := middleware.GetRequestRoles(c)
		permissions := strings.Split(c.Query("permission"), ",")
		permissiveViewIds, err = db.GetPermissiveViewId(permissions, roles, nil)
		if len(permissiveViewIds) == 0 {
			rowData := []string{}
			middleware.ReturnData(c, rowData)
			return
		}
	}
	rowData, err := db.GetViewList(paramsMap, permissiveViewIds)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(rowData) == 0 {
			rowData = []*models.SysViewTable{}
		}
		middleware.ReturnData(c, rowData)
	}
}

func GetView(c *gin.Context) {
	/*
		roles := middleware.GetRequestRoles(c)
		permissionName := "permission"
		if c.Query(permissionName) == "" {
			middleware.ReturnParamValidateError(c, fmt.Errorf("Url param permission can not empty "))
			return
		}
	*/

	viewId := c.Param("viewId")
	if viewId == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param viewId can not empty "))
		return
	}
	/*
		permissions := strings.Split(c.Query(permissionName), ",")
		hasViewIds := []string{viewId}
		permissiveViewIds, err := db.GetPermissiveViewId(permissions, roles, hasViewIds)
		if len(permissiveViewIds) == 0 {
			rowData := []string{}
			middleware.ReturnData(c, rowData)
			return
		}
	*/

	viewData, err := db.QueryViewById(viewId)
	rowData := viewData

	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		var graphsData []*models.SysGraphTable
		graphsData, err = db.GetGraphByView(viewId)
		if err != nil {
			middleware.ReturnServerHandleError(c, err)
			return
		}

		var graphElementNode *models.GraphElementNode
		for _, graph := range graphsData {
			graphQuery := &models.GraphQuery{ViewGraphType: graph.GraphType,
				NodeGroups: graph.NodeGroups,
				GraphDir:   graph.GraphDir,
				Name:       graph.Name,
			}
			viewData.Graphs = append(viewData.Graphs, graphQuery)

			graphElementNode, err = db.GetRootGraphElementByGraph(graph.Id)
			if err != nil {
				middleware.ReturnServerHandleError(c, err)
				return
			}
			if graphElementNode != nil {
				_, err = db.GetChildGraphElement(graphElementNode)
				if err != nil {
					middleware.ReturnServerHandleError(c, err)
					return
				}
			}
			graphQuery.RootData = graphElementNode
		}
		middleware.ReturnData(c, rowData)
	}
}

func GetViewData(c *gin.Context) {
	//Param validate
	var param models.ViewData
	var err error
	if err = c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	/*
		roles := middleware.GetRequestRoles(c)
		permissions := strings.Split(param.Permission, ",")
		hasViewIds := []string{param.ViewId}
		permissiveViewIds, err := db.GetPermissiveViewId(permissions, roles, hasViewIds)
		if len(permissiveViewIds) == 0 {
			rowData := []string{}
			middleware.ReturnData(c, rowData)
			return
		}
	*/
	var rootGuidList []string
	var reportId string
	if param.ReportId != "" {
		reportId = param.ReportId
		rootGuidList, err = db.GetRootCiDataWithReportId(reportId)
		if err != nil {
			middleware.ReturnServerHandleError(c, err)
			return
		}
	} else {
		rootGuidList = strings.Split(param.RootCi, ",")
		viewData, err := db.QueryViewById(param.ViewId)
		if err != nil {
			middleware.ReturnServerHandleError(c, err)
			return
		}
		reportId = viewData.Report
	}
	var rootReportObjectsData []*models.ReportObjectNode
	rootReportObjectsData, err = db.QueryRootReportObj(reportId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	var rowDataList []map[string]interface{}
	for _, roNode := range rootReportObjectsData {
		var rowData []map[string]interface{}
		rootReportAttr, rootAttrMap, tmpErr := db.GetReportAttr(roNode.Id)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		rowData, _, err = db.GetChildReportObject(roNode, rootGuidList, rootReportAttr, param.ConfirmTime, param.ViewId)
		if err != nil {
			break
		}
		for _, rowDataObj := range rowData {
			tmpRowData := make(map[string]interface{})
			for k, v := range rowDataObj {
				if _, b := rootAttrMap[k]; b {
					tmpRowData[rootAttrMap[k]] = v
				} else {
					if strings.HasSuffix(k, "^") {
						k = k[:len(k)-1]
					}
					tmpRowData[k] = v
				}
			}
			rowDataList = append(rowDataList, tmpRowData)
		}
	}
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if len(rowDataList) == 0 {
		middleware.ReturnData(c, []string{})
	} else {
		middleware.ReturnData(c, rowDataList)
	}
}

func ConfirmView(c *gin.Context) {
	var param models.ViewData
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	result, err := db.ViewConfirmAction(param, c.GetHeader("Authorization"), middleware.GetRequestUser(c), middleware.GetRequestRoles(c))
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	} else {
		middleware.ReturnData(c, result)
	}
}
