package report

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"sort"
	"strconv"
)

// QueryReportImportHistory 查询报告导入历史
func QueryReportImportHistory(c *gin.Context) {
	// 参数验证
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}

	// 从数据库查询报告导入历史信息
	pageInfo, rowDataResult, err := db.QueryReportImportHistory(&param)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("QueryReportImportHistory failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}

	// 收集所有行数据的GUID和唯一的报告名称
	rowDataGuidList := []string{}
	reportList := []string{}
	seen := make(map[string]bool)
	for _, row := range rowDataResult {
		rowDataGuidList = append(rowDataGuidList, row.Guid)
		if _, ok := seen[row.Report]; !ok {
			seen[row.Report] = true
			reportList = append(reportList, row.Report)
		}
	}
	// 查询未通过的行数据及其CI类型名称
	notPassRowData, err := db.QuerySysCiImportGuidMapForNotPassCountAndCiTypeNames(rowDataGuidList)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query CI import detail failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}

	// 查询报告关联的CI类型
	reportRelateCiTypeObj, err := db.QueryReportRelateCiType(reportList)
	reportRelateCiTypeMap := make(map[string]string)
	for _, row := range reportRelateCiTypeObj {
		reportRelateCiTypeMap[row.Report] = row.CiTypeNames
	}

	// 处理查询结果，填充CI类型名称和未通过计数
	for i, rowData := range rowDataResult {
		if ciTypeNames, ok := reportRelateCiTypeMap[rowData.Report]; ok {
			rowDataResult[i].CiTypeNames = ciTypeNames
		}
		for _, row := range notPassRowData {
			if rowData.Guid == row.Guid {
				rowDataResult[i].NotPassCount = row.NotPassCount
				break
			}
		}
	}

	// 返回分页数据
	middleware.ReturnPageData(c, pageInfo, rowDataResult)
	return
}

// 刷新报告导入历史记录
func RefreshReportImportHistory(c *gin.Context) {
	// 查询状态为"created"的报告导入历史记录
	status := "created"
	importHistoryRowData, err := db.QueryReportImportHistoryByStatus(status)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query report import history failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if importHistoryRowData == nil || len(importHistoryRowData) == 0 {
		middleware.ReturnSuccess(c)
		return
	}

	// 遍历每一项导入历史记录
	for _, rowData := range importHistoryRowData {
		// 根据报告导入GUID查询导入GUID映射表
		importGuidMapTable, err := db.QueryCiImportGuidMapByReportImportGuid(rowData.Guid)
		if err != nil {
			log.Logger.Error(fmt.Sprintf("Query ci import detail failed, err:%s", err.Error()))
			middleware.ReturnServerHandleError(c, err)
			return
		}
		if importGuidMapTable == nil || len(importGuidMapTable) == 0 {
			middleware.ReturnSuccess(c)
			return
		}
		// 调用refreshReportImportHistory函数刷新报告导入历史记录
		err = refreshReportImportHistory(c, importGuidMapTable)
		if err != nil {
			log.Logger.Error(fmt.Sprintf("Refresh report import history failed, err:%s", err.Error()))
			middleware.ReturnServerHandleError(c, err)
			return
		}
	}
	middleware.ReturnSuccess(c)
}

// 根据ID刷新报告导入历史记录
func RefreshReportImportHistoryById(c *gin.Context) {
	guid := c.Query("guid")
	if guid == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param guid can not empty"))
		return
	}

	// 根据报告导入GUID查询导入映射表
	importGuidMapTable, err := db.QueryCiImportGuidMapByReportImportGuid(guid)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query ci import detail failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if importGuidMapTable == nil || len(importGuidMapTable) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("report import guid is invalid"))
		return
	}

	// 调用refreshReportImportHistory函数刷新报告导入历史记录
	err = refreshReportImportHistory(c, importGuidMapTable)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Refresh report import history failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	middleware.ReturnSuccess(c)
}

// 刷新报告导入历史记录：主要功能是构造MultiCiDataObj的切片，然后获取其Attributes和InputData，并最终刷新报告导入历史记录
func refreshReportImportHistory(c *gin.Context, importGuidMapTable []*models.SysCiImportGuidMapTable) (err error) {
	// 构造multiCiData，获取multiCiData的CiTypeId
	var multiCiData []*models.MultiCiDataObj
	var ciTypeMap = make(map[string]bool)
	for _, row := range importGuidMapTable {
		if _, exists := ciTypeMap[row.CiType]; !exists {
			ciTypeMap[row.CiType] = true
			multiCiData = append(multiCiData, &models.MultiCiDataObj{CiTypeId: row.CiType})
		}
	}
	// 获取multiCiData的Attributes
	if err = db.GetMultiCiAttributes(multiCiData); err != nil {
		log.Logger.Error(fmt.Sprintf("Query CI attributes failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	// 获取multiCiData的InputData
	err = db.GetUniqueAndNotNullColumn(multiCiData, importGuidMapTable)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Get unique and not null column failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}

	err = db.RefreshReportImportHistory(multiCiData)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Refresh report import history failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	return
}

// 查询报告导入历史记录
func QueryReportImportHistoryById(c *gin.Context) {
	// 获取URL查询参数guid
	guid := c.Query("guid")
	if guid == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param guid can not empty"))
		return
	}

	// 从sys_report_import_history表中查询报告导入历史记录
	var result models.SysReportImportHistoryResult
	rowData, err := db.QueryReportImportHistoryById(guid)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query report import history failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if rowData == nil || len(rowData) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("report import guid is invalid"))
		return
	}
	// 将查询结果赋值给结果变量
	result.ReportHistoryObject = rowData[0]

	// 从sys_ci_import_guid_map表中查询CI导入GUID映射统计信息
	statisticsRowData, err := db.QuerySysCiImportGuidMapStatistics(guid)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query CI import statistics failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	// 遍历统计信息，为每个CI类型添加isRootCiType字段，判断是否为根CI类型
	for _, row := range statisticsRowData {
		row.IsRootCiType = row.CiType == rowData[0].RootCiType
	}

	// 查询报告对应的CI类型
	ciTypeRowData, err := db.QueryCiTypeByReport(rowData[0].Report)
	// 合并CI类型数据和统计信息
	for _, row := range ciTypeRowData {
		found := false
		for i, statRow := range statisticsRowData {
			if row.DataName == statRow.CiType {
				statisticsRowData[i].SeqNo = row.SeqNo
				statisticsRowData[i].CiTypeDisplayName = row.DataTitleName
				found = true
				break
			}
		}
		if !found {
			tempRowData := &models.ReportHistoryCiDataStatistics{
				SeqNo:             row.SeqNo,
				CiType:            row.DataName,
				CiTypeDisplayName: row.DataTitleName,
			}
			statisticsRowData = append(statisticsRowData, tempRowData)
		}
	}

	// 根据SeqNo对统计信息进行正序排序
	sort.Slice(statisticsRowData, func(i, j int) bool {
		return statisticsRowData[i].SeqNo < statisticsRowData[j].SeqNo
	})

	// 将统计信息赋值给结果变量
	result.ReportHistoryCiDataStatistics = statisticsRowData

	middleware.ReturnData(c, result)
}

// 确认报告导入
func ConfirmReportImport(c *gin.Context) {
	// 初始化存储接口类型的参数映射
	var interfaceParam map[string]interface{}
	var err error

	// 绑定JSON请求到interfaceParam，发生错误则返回参数验证错误
	if err = c.ShouldBindJSON(&interfaceParam); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if len(interfaceParam) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param guid can not empty"))
		return
	}

	var guid = interfaceParam["guid"].(string)
	rowData, err := db.QueryReportImportHistoryById(guid)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query report import history failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}

	if len(rowData) == 0 || rowData[0] == nil {
		middleware.ReturnParamValidateError(c, fmt.Errorf("report import guid is invalid"))
		return
	}

	// 检查未通过验证的数据数量，有未通过则返回参数验证错误
	var firstRowData = rowData[0]
	if firstRowData.NotPassCount > 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("current import still has "+strconv.Itoa(firstRowData.NotPassCount)+" pieces of data that have not passed the verification, confirmation is not allowed"))
		return
	}

	firstRowData.UpdateUser = middleware.GetRequestUser(c)

	// 如果记录状态为"created"，则更新为"confirmed"
	if rowData[0].Status == "created" {
		status := "confirmed"
		err = db.UpdateReportImportStatus(firstRowData, status)
	}

	middleware.ReturnSuccess(c)
}

func CancelReportImport(c *gin.Context) {
	var interfaceParam map[string]interface{}
	var err error
	if err = c.ShouldBindJSON(&interfaceParam); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if len(interfaceParam) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param guid can not empty "))
		return
	}

	//
	var guid = interfaceParam["guid"].(string)
	// get already imported ci data
	importGuidRowData, err := db.QueryCiImportGuidMapByReportImportGuid(guid)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query ci import detail failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if len(importGuidRowData) > 0 {
		// delete ci data
		var updateUser = middleware.GetRequestUser(c)
		err := db.DeleteReportImportCiData(updateUser, importGuidRowData)
		if err != nil {
			log.Logger.Error(fmt.Sprintf("Delete ci data failed, err:%s", err.Error()))
			middleware.ReturnServerHandleError(c, err)
			return
		}
	}

	middleware.ReturnSuccess(c)
}

func AttrQueryWithCheckResult(c *gin.Context) {
	// Param validate
	ciTypeGuid := c.Param("ciType")
	if ciTypeGuid == "" {
		middleware.ReturnParamEmptyError(c, "ciType")
		return
	}
	status := c.Query("status")
	isCreated := true
	if status == "all" {
		isCreated = false
	}
	// Query database
	rowData, err := db.GetCiAttrByCiType(ciTypeGuid, isCreated)
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query ci type attr failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
	} else {
		// Add a new column for check result
		firstRowData := rowData[0]
		checkResultRowData := &models.SysCiTypeAttrTable{
			Id:               firstRowData.CiType + "__check_result",
			CiType:           firstRowData.CiType,
			Name:             "check_result",
			DisplayNameTmp:   "校验结果",
			DisplayName:      "校验结果",
			Status:           "created",
			InputType:        "tagShow",
			DataType:         "varchar",
			DataLength:       64,
			Editable:         "no",
			Source:           "custom",
			UiFormOrder:      0, // 先设为 0，稍后调整
			UiSearchOrder:    1, // 设置为 1
			DisplayByDefault: "yes",
		}
		// 查找 DisplayName 为 “唯一名称” 的元素位置，并将 checkResultRowData 插入到它的后面
		insertIndex := -1
		for i, row := range rowData {
			if row.DisplayName == "唯一名称" {
				insertIndex = i + 1
				checkResultRowData.UiFormOrder = row.UiFormOrder + 1
				break
			}
		}

		// 如果找到了指定的元素，则在它后面插入新的元素
		if insertIndex >= 0 && insertIndex <= len(rowData) {
			rowData = append(rowData[:insertIndex], append([]*models.SysCiTypeAttrTable{checkResultRowData}, rowData[insertIndex:]...)...)
		}

		// 调整后续元素的 UiFormOrder 和 UiSearchOrder
		for i, row := range rowData {
			if row.DisplayName == "校验结果" {
				continue
			}
			if row.UiFormOrder >= checkResultRowData.UiFormOrder {
				rowData[i].UiFormOrder++
			}
			if row.UiSearchOrder > 0 && row.UiSearchOrder >= checkResultRowData.UiSearchOrder {
				rowData[i].UiSearchOrder++
			}
		}

		middleware.ReturnData(c, rowData)
	}
}

func DataQueryWithCheckResult(c *gin.Context) {
	// Param validate
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	// Permissions
	permissions, tmpErr := db.GetRoleCiDataPermission(middleware.GetRequestRoles(c), c.Param("ciType"))
	if tmpErr != nil {
		log.Logger.Error(fmt.Sprintf("Get role ci data permission failed, err:%s", tmpErr.Error()))
		middleware.ReturnDataPermissionError(c, tmpErr)
		return
	}
	legalGuidList, tmpErr := db.GetCiDataPermissionGuidList(&permissions, "query")
	if tmpErr != nil {
		log.Logger.Error(fmt.Sprintf("Get ci data permission guid list failed, err:%s", tmpErr.Error()))
		middleware.ReturnDataPermissionError(c, tmpErr)
		return
	}
	if !legalGuidList.Disable && len(legalGuidList.GuidList) == 0 {
		middleware.ReturnDataPermissionDenyError(c)
		return
	}
	// Query database
	pageInfo, rowData, err := db.CiDataQuery(c.Param("ciType"), &param, &legalGuidList, false, true)

	// add check_result
	for _, row := range rowData {
		var checkResultList []string
		if row["is_not_empty"] == "0" {
			checkResultList = append(checkResultList, "10")
		}
		if row["is_unique"] == "0" {
			checkResultList = append(checkResultList, "01")
		}
		if len(checkResultList) == 0 {
			checkResultList = append(checkResultList, "11")
		}
		row["check_result"] = checkResultList
	}

	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query ci data failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(rowData) == 0 {
			rowData = []map[string]interface{}{}
		}
		middleware.ReturnPageData(c, pageInfo, rowData)
	}
}

func QueryReportImportUser(c *gin.Context) {
	rowData, err := db.QueryReportImportUser()
	if err != nil {
		log.Logger.Error(fmt.Sprintf("Query report import user failed, err:%s", err.Error()))
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}

}
