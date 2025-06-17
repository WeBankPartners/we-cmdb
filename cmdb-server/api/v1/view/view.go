package view

import (
	"fmt"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/graph"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
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
		if len(param.RootCiList) > 0 {
			rootGuidList = param.RootCiList
		} else {
			rootGuidList, err = db.GetRootCiDataWithReportId(reportId, param.RootCiKeyName)
			if err != nil {
				middleware.ReturnServerHandleError(c, err)
				return
			}
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
	log.Info(nil, log.LOGGER_APP, "view-data", zap.Strings("rootGuidList", rootGuidList))
	var rowDataList []map[string]interface{}
	for _, roNode := range rootReportObjectsData {
		var rowData []map[string]interface{}
		rootReportAttr, rootAttrMap, tmpErr := db.GetReportAttr(roNode.Id)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		rowData, _, err = db.GetChildReportObject(roNode, rootGuidList, rootReportAttr, param.ConfirmTime, param.ViewId, param.WithoutChildren)
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
		//
		if param.WithoutChildren {
			sort.Slice(rowDataList, func(i, j int) bool {
				return rowDataList[i]["update_time"].(string) > rowDataList[j]["update_time"].(string)
			})
		}
		//
		if !param.WithoutChildren && len(param.RootCiList) > 0 {
			// 创建一个映射来存储每个元素在 param.RootCiList 中的位置
			indexMap := make(map[string]int)
			for i, guid := range param.RootCiList {
				indexMap[guid] = i
			}
			// 使用自定义排序函数对 rowDataList 进行排序
			sort.Slice(rowDataList, func(i, j int) bool {
				indexI, okI := indexMap[rowDataList[i]["guid"].(string)]
				indexJ, okJ := indexMap[rowDataList[j]["guid"].(string)]
				if !okI || !okJ {
					return false
				}
				return indexI < indexJ
			})
		}
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
		// db.SyncPushConfirmView(&param, result)
		middleware.ReturnData(c, result)
	}
}

func GetGraphViewData(c *gin.Context) {

	var param models.GraphViewData
	var err error
	if err = c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}

	// Query for ciTypeMapping and create imageMap
	paramCi := models.CiTypeQuery{
		CiTypeId:       c.Query("id"),
		WithAttributes: "yes",
		Status:         []string{"dirty", "created"},
	}
	err = db.CiTypesQuery(&paramCi)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	imageMap := map[string]string{}
	for _, ciType := range paramCi.CiTypeListData {
		imageMap[ciType.Id] = filepath.Join("/wecmdb/fonts/", ciType.ImageFile)
	}

	// Query for viewSettings for graph
	var viewSettings *models.ViewQuery
	if viewSettings, err = db.QueryViewById(param.ViewId); err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	var graphData *models.SysGraphTable
	if graphData, err = db.GetGraphById(param.GraphId); err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	var graphElementNode *models.GraphElementNode
	if graphElementNode, err = db.GetRootGraphElementByGraph(graphData.Id); err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	if graphElementNode != nil {
		if _, err = db.GetChildGraphElement(graphElementNode); err != nil {
			middleware.ReturnServerHandleError(c, err)
			return
		}
	}

	viewSettings.Graphs = []*models.GraphQuery{{
		ViewGraphType:   graphData.GraphType,
		NodeGroups:      graphData.NodeGroups,
		GraphDir:        graphData.GraphDir,
		Name:            graphData.Name,
		RootData:        graphElementNode,
		GraphEdgeConfig: graphData.GraphEdgeConfig,
		GraphNodeConfig: graphData.GraphNodeConfig,
	}}

	// Query ViewData for graph
	var rootReportObjectsData []*models.ReportObjectNode
	if rootReportObjectsData, err = db.QueryRootReportObj(viewSettings.Report); err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	// ignore confirmTime when SuportVersion is no
	confirmTime := ""
	if viewSettings.SuportVersion == "yes" {
		confirmTime = param.ConfirmTime
	}

	var rowDataList []map[string]interface{}
	rootGuidList := strings.Split(param.RootCi, ",")
	for _, roNode := range rootReportObjectsData {
		var rowData []map[string]interface{}
		rootReportAttr, rootAttrMap, tmpErr := db.GetReportAttr(roNode.Id)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		rowData, _, err = db.GetChildReportObject(roNode, rootGuidList, rootReportAttr, confirmTime, param.ViewId, false)
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

	// Render graph
	var dots []string
	for _, g := range viewSettings.Graphs {
		start := time.Now()
		dot, err1 := graph.Render(*g, rowDataList, graph.RenderOption{
			SuportVersion: viewSettings.SuportVersion, ImageMap: imageMap,
		})
		if err1 != nil {
			middleware.ReturnServerHandleError(c, err1)
		}

		duration := time.Since(start)
		log.Debug(nil, log.LOGGER_APP, "render graph: ", zap.String("duration", duration.String()),
			log.JsonObj("g", g), log.JsonObj("rowDataList", rowDataList), zap.String("dot", dot))
		//dotSingle := strings.Replace(strings.Replace(dot, "\n", "", -1), "\t", "", -1)
		dots = append(dots, dot)
	}

	// always return only one graph
	middleware.ReturnData(c, dots[0])
}
