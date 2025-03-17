package db

import (
	"fmt"
	"strings"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"go.uber.org/zap"
)

func QueryReportImportHistory(param *models.QueryRequestParam) (pageInfo models.PageInfo, rowData []*models.SysReportImportHistoryObj, err error) {
	rowData = []*models.SysReportImportHistoryObj{}
	filterSql, _, queryParam := transFiltersToSQL(param, &models.TransFiltersParam{IsStruct: true, StructObj: models.SysReportImportHistoryObj{}, PrimaryKey: "guid", Prefix: "tt"})
	baseSql := fmt.Sprintf("SELECT tt.*, sr.name as report_name, sct.display_name as root_ci_type_name FROM sys_report_import_history tt left join sys_report sr on tt.report = sr.id left join sys_ci_type sct on tt.root_ci_type = sct.id WHERE 1=1 %s ", filterSql)
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

func QueryReportImportHistoryById(guid string) (rowData []*models.SysReportImportHistoryObj, err error) {
	baseSql := fmt.Sprintf(`select
	tt.*,
	sr.name as report_name,
	sct.display_name as root_ci_type_name,
	group_concat(distinct sct2.display_name) as ci_type_names,
	SUM(case when scigm.is_unique = 0 or scigm.is_not_empty = 0 then 1 else 0 end) as not_pass_count
from
	sys_report_import_history tt
join sys_ci_import_guid_map scigm on
	tt.guid = scigm.report_import_guid
left join sys_report sr on
	tt.report = sr.id
left join sys_ci_type sct on
	tt.root_ci_type = sct.id
left join sys_ci_type sct2 on
	scigm.ci_type = sct2.id
where
	tt.guid = '%s'
group by
	tt.guid
`, guid)
	err = x.SQL(baseSql).Find(&rowData)
	return
}

func QuerySysCiImportGuidMapStatistics(guid string) (rowData []*models.ReportHistoryCiDataStatistics, err error) {
	baseSql := fmt.Sprintf(`select
	sct.id as ci_type,
	sct.display_name as ci_type_display_name,
	COUNT(*) as total_count,
	SUM(case when tt.is_unique = 0 or tt.is_not_empty = 0 then 1 else 0 end) as not_pass_count
from
	sys_ci_import_guid_map tt
left join
    sys_ci_type sct on
	tt.ci_type = sct.id
where
	tt.report_import_guid = '%s'
group by
	sct.id`, guid)

	err = x.SQL(baseSql).Find(&rowData)
	return
}

func QuerySysCiImportGuidMapForNotPassCountAndCiTypeNames(list []string) (rowData []*models.SysReportImportHistoryObj, err error) {
	baseSql := fmt.Sprintf(`select
	tt.report_import_guid as guid,
	SUM(case when tt.is_unique = 0 or tt.is_not_empty = 0 then 1 else 0 end) as not_pass_count
from
	sys_ci_import_guid_map tt
left join
    sys_ci_type sct on
	tt.ci_type = sct.id
where
	tt.report_import_guid in ('%s')
group by
	tt.report_import_guid 
`, strings.Join(list, "','"))
	err = x.SQL(baseSql).Find(&rowData)
	return
}

func QueryCiImportGuidMapByReportImportGuid(guid string) (rowData []*models.SysCiImportGuidMapTable, err error) {
	baseSql := fmt.Sprintf("select * from sys_ci_import_guid_map where report_import_guid = '%s'", guid)
	err = x.SQL(baseSql).Find(&rowData)
	return
}

func QueryCiImportGuidMapByTarget(target string) (result *models.SysCiImportGuidMapTable, err error) {
	baseSql := fmt.Sprintf("select * from sys_ci_import_guid_map where target = '%s'", target)
	var rowData []*models.SysCiImportGuidMapTable
	err = x.SQL(baseSql).Find(&rowData)
	if err != nil {
		return
	}
	if rowData != nil && len(rowData) > 0 {
		return rowData[0], nil
	}
	return
}

func UpdateReportImportStatus(firstRowData *models.SysReportImportHistoryObj, status string) error {
	updateTime := time.Now().Format(models.DateTimeFormat)
	updateAction := []*execAction{{Sql: "update sys_report_import_history set status = ?, update_user = ?, update_time = ?, confirm_time = ? where guid = ?", Param: []interface{}{status, firstRowData.UpdateUser, updateTime, updateTime, firstRowData.Guid}}}
	return transaction(updateAction)
}

func DeleteReportImportCiData(user string, rowData []*models.SysCiImportGuidMapTable) error {
	var action []*execAction
	// delete imported ci data
	var targets []string
	for _, row := range rowData {
		targets = append(targets, row.Target)
		action = append(action, &execAction{Sql: fmt.Sprintf("delete from %s where guid=?", row.CiType), Param: []interface{}{row.Target}})
	}
	action = append(action, &execAction{Sql: fmt.Sprintf("delete from sys_ci_import_guid_map where target in ('%s')", strings.Join(targets, "','")), Param: []interface{}{}})
	// update import status to canceled
	status := "canceled"
	updateTime := time.Now().Format(models.DateTimeFormat)
	action = append(action, &execAction{Sql: "update sys_report_import_history set status = ?, update_user = ?, update_time = ?  where guid = ?", Param: []interface{}{status, user, updateTime, rowData[0].ReportImportGuid}})

	return transaction(action)
}

func QueryReportImportUser() (userData []string, err error) {
	err = x.SQL("select distinct create_user from sys_report_import_history").Find(&userData)
	return
}

func QueryReportImportHistoryStatusByCiTypeGuid(ciTypeGuid string) (rowData []*models.SysReportImportHistoryTable, err error) {
	err = x.SQL("select srih.* from sys_ci_import_guid_map tt join sys_report_import_history srih on tt.report_import_guid = srih.guid where tt.target = ?", ciTypeGuid).Find(&rowData)
	return
}

// 为报告中的每个导入记录生成更新操作，以标记其唯一性和非空性。
func addActionForReportCiImportGuidMap(ciObj *models.MultiCiDataObj) (action []*execAction, err error) {
	// 初始化一个映射，用于记录已看到的属性值，以属性名为键，以值为键，以true为值表示是否重复
	var seenValues = make(map[string]map[string]bool)
	// 初始化一个切片，用于存储唯一属性的名称。
	uniqueAttrNames := make([]string, 0)
	uniqueAttrNameMap := make(map[string]bool)

	// 遍历CI对象的属性，找出所有标记为唯一的属性，并记录它们的名称和唯一性。
	for _, attr := range ciObj.Attributes {
		if attr.UniqueConstraint == "yes" {
			uniqueAttrNames = append(uniqueAttrNames, attr.Name)
			uniqueAttrNameMap[attr.Name] = true
		}
	}

	// 构造过滤条件，排除ciObj.InputData中的guid
	var excludeGuids []string
	for _, inputData := range ciObj.InputData {
		excludeGuids = append(excludeGuids, inputData["guid"])
	}
	excludeGuidsStr := strings.Join(excludeGuids, "','")
	filterClause := ""
	if len(excludeGuids) > 0 {
		filterClause = fmt.Sprintf(" AND guid NOT IN ('%s')", excludeGuidsStr)
	}
	// 构造SQL查询语句，用于选择唯一的属性组合。
	selectSql := fmt.Sprintf("SELECT DISTINCT %s FROM `%s` WHERE 1=1%s", strings.Join(uniqueAttrNames, ","), ciObj.CiTypeId, filterClause)
	rows, err := x.QueryString(selectSql)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Failed to fetch existing unique attribute combinations", zap.Error(err))
		return nil, err
	}

	// 把查询结果存进seenValues
	for _, row := range rows {
		for _, attrName := range uniqueAttrNames {
			if row[attrName] == "" {
				continue
			}
			if _, ok := seenValues[attrName]; !ok {
				seenValues[attrName] = make(map[string]bool)
			}
			seenValues[attrName][row[attrName]] = true
		}
	}

	// 遍历输入数据，检查每个记录的唯一性和非空性，并生成相应的更新操作。
	var reportImportHistoryGuid string
	for _, inputData := range ciObj.InputData {
		importGuidMap, queryErr := x.QueryString("select * from sys_ci_import_guid_map where target = ?", inputData["guid"])
		if queryErr != nil || importGuidMap == nil {
			log.Info(nil, log.LOGGER_APP, "query import guid map table fail,ignore", zap.Error(queryErr))
			// 历史记录可能在sys_ci_import_guid_map查不到，错误不返回，直接跳过
			continue
		}

		var hasDuplicate bool
		var hasEmpty bool
		// 检查每个属性的唯一性和非空性。
		for _, attr := range ciObj.Attributes {
			attrName := attr.Name
			if value, ok := inputData[attrName]; ok {
				if attr.UniqueConstraint == "yes" && uniqueAttrNameMap[attrName] == true {
					if _, ok := seenValues[attrName]; !ok {
						seenValues[attrName] = make(map[string]bool)
					}
					if seenValues[attrName] != nil && seenValues[attrName][value] {
						hasDuplicate = true
						if hasEmpty {
							break
						}
					} else {
						if value == "" {
							continue
						}
						seenValues[attrName][value] = true
					}
				}
				if attr.Nullable == "no" && value == "" {
					hasEmpty = true
					if hasDuplicate {
						break
					}
				}
			} else {
				if attr.Nullable == "no" {
					hasEmpty = true
					if hasDuplicate {
						break
					}
				}
			}
		}
		// 根据检查结果，生成更新操作。
		isUnique := !hasDuplicate
		isNotEmpty := !hasEmpty
		target, err := QueryCiImportGuidMapByTarget(inputData["guid"])
		if err != nil {
			return nil, err
		}
		if target != nil && (target.IsUnique != isUnique || target.IsNotEmpty != isNotEmpty) {
			action = append(action, &execAction{Sql: "update sys_ci_import_guid_map set is_unique = ?, is_not_empty = ? where target = ?",
				Param: []interface{}{isUnique, isNotEmpty, inputData["guid"]}})
		}
		//
		reportImportRowData, errQuery := QueryReportImportHistoryStatusByCiTypeGuid(inputData["guid"])
		if errQuery != nil {
			log.Error(nil, log.LOGGER_APP, "QueryReportImportHistoryStatusByCiTypeGuid", zap.Error(errQuery))
		}
		if reportImportRowData != nil && len(reportImportRowData) > 0 {
			reportImportHistoryGuid = reportImportRowData[0].Guid
		}
	}
	//
	if reportImportHistoryGuid != "" {
		action = append(action, &execAction{Sql: "update sys_report_import_history set update_time = ? where guid = ?", Param: []interface{}{
			time.Now().Format(models.DateTimeFormat), reportImportHistoryGuid}})
	}

	return
}

func deleteActionForReportCiImportGuidMap(ciObj *models.MultiCiDataObj) (action []*execAction, err error) {
	for _, inputData := range ciObj.InputData {
		importGuidMap, queryErr := x.QueryString("select * from sys_ci_import_guid_map where target = ?", inputData["guid"])
		if queryErr != nil || importGuidMap == nil {
			log.Error(nil, log.LOGGER_APP, "query import guid map table fail", zap.Error(queryErr))
			// 历史记录可能在sys_ci_import_guid_map查不到，错误不返回，直接跳过
			return nil, nil
		}
		action = append(action, &execAction{Sql: "delete from sys_ci_import_guid_map where target = ?", Param: []interface{}{inputData["guid"]}})
	}
	return
}

func UpdateImportGuidMapTable(ciObj *models.MultiCiDataObj, importGuidMapTable []*models.SysCiImportGuidMapTable, indexMap map[string]int) {
	// 创建一个映射表来记录已出现的值
	var seenValues = make(map[string]map[string]bool)
	uniqueAttrNames := make([]string, 0)
	uniqueAttrNameMap := make(map[string]bool)

	// 初始化 uniqueAttrNames 和 uniqueAttrNameMap
	for _, attr := range ciObj.Attributes {
		if attr.UniqueConstraint == "yes" {
			uniqueAttrNames = append(uniqueAttrNames, attr.Name)
			uniqueAttrNameMap[attr.Name] = true
		}
	}

	selectSql := fmt.Sprintf("SELECT DISTINCT %s FROM `%s` WHERE 1=1", strings.Join(uniqueAttrNames, ","), ciObj.CiTypeId)
	rows, queryErr := x.QueryString(selectSql)
	if queryErr != nil {
		log.Error(nil, log.LOGGER_APP, "Failed to fetch existing unique attribute combinations", zap.Error(queryErr))
		return
	}

	//
	for _, row := range rows {
		for _, attrName := range uniqueAttrNames {
			if row[attrName] == "" {
				continue
			}
			if _, ok := seenValues[attrName]; !ok {
				seenValues[attrName] = make(map[string]bool)
			}
			seenValues[attrName][row[attrName]] = true
		}
	}

	// 遍历输入数据
	for _, inputData := range ciObj.InputData {
		var hasDuplicate bool
		var hasEmpty bool

		// 遍历属性
		for _, attr := range ciObj.Attributes {
			attrName := attr.Name

			// 跳过一些通用属性的检查
			if attrName == "create_time" || attrName == "create_user" || attrName == "update_time" || attrName == "update_user" {
				continue
			}

			if value, ok := inputData[attrName]; ok {
				if attr.UniqueConstraint == "yes" && uniqueAttrNameMap[attrName] == true {
					if _, ok := seenValues[attrName]; !ok {
						seenValues[attrName] = make(map[string]bool)
					}
					if seenValues[attrName] != nil && seenValues[attrName][value] {
						hasDuplicate = true
						if hasEmpty {
							break
						}
					} else {
						if value == "" {
							continue
						}
						seenValues[attrName][value] = true
					}
				}
				if attr.Nullable == "no" && value == "" {
					hasEmpty = true
					if hasDuplicate {
						break
					}
				}
			} else {
				if attr.Nullable == "no" {
					hasEmpty = true
					if hasDuplicate {
						break
					}
				}
			}
		}

		// 获取guid
		guid := inputData["guid"]
		isUnique := !hasDuplicate
		isNotEmpty := !hasEmpty

		// 更新 importGuidMapTable 中对应条目的 IsUnique 和 IsNotEmpty 字段
		if index, ok := indexMap[guid]; ok {
			importGuidMapTable[index].IsUnique = isUnique
			importGuidMapTable[index].IsNotEmpty = isNotEmpty
		}
	}
}

func QueryCiTypeByReport(report string) (rowData []*models.SysReportObjectTable, err error) {
	// 查找 report 对应的根 report object
	sqlCmd := `SELECT * FROM sys_report_object WHERE report=?`
	err = x.SQL(sqlCmd, report).Find(&rowData)
	if err != nil {
		err = fmt.Errorf("Query report object by report:%s error,%s ", report, err.Error())
	}
	return
}

func QueryReportRelateCiType(list []string) (rowData []*models.SysReportImportHistoryObj, err error) {
	err = x.SQL(fmt.Sprintf(`SELECT
	    report,
	    GROUP_CONCAT(data_title_name ORDER BY seq_no ASC) AS ci_type_names
	FROM
	    sys_report_object
	WHERE
	    report IN ('%s')
	    AND parent_object IS NOT NULL
	GROUP BY
	    report
	ORDER BY
	    seq_no ASC`, strings.Join(list, "','"))).Find(&rowData)
	if err != nil {
		err = fmt.Errorf("Query report object by report:%s error,%s ", list, err.Error())
	}
	return
}

func QueryReportImportHistoryByStatus(status string) (rowData []*models.SysReportImportHistoryObj, err error) {
	err = x.SQL(fmt.Sprintf(`SELECT * FROM sys_report_import_history WHERE status='%s'`, status)).Find(&rowData)
	if err != nil {
		err = fmt.Errorf("Query report import history by status:%s error,%s ", status, err.Error())
	}
	return
}

func GetUniqueAndNotNullColumn(multiCiData []*models.MultiCiDataObj, importHistoryRowData []*models.SysCiImportGuidMapTable) (err error) {
	for _, ciDataObj := range multiCiData {
		columnList := []string{}
		for _, attr := range ciDataObj.Attributes {
			//if attr.AutofillAble == "yes" {
			//	continue
			//}
			if attr.UniqueConstraint == "yes" || attr.Nullable == "no" {
				columnList = append(columnList, attr.Name)
			}
		}
		if len(columnList) == 0 {
			continue
		}
		for _, importGuidMap := range importHistoryRowData {
			if ciDataObj.CiTypeId == importGuidMap.CiType {
				rowData, err := x.QueryString(fmt.Sprintf("select %s from `%s` where guid = '%s' ", strings.Join(columnList, ","), ciDataObj.CiTypeId, importGuidMap.Target))
				if err != nil {
					log.Error(nil, log.LOGGER_APP, "Query ci data column value fail. ", zap.Error(err), zap.String("guid", importGuidMap.Target), zap.String("column", strings.Join(columnList, ",")))
					return fmt.Errorf("Query ci data column value fail,%s ", err.Error())
				}
				if rowData != nil {
					ciDataObj.InputData = append(ciDataObj.InputData, rowData[0])
				}
			}
		}
	}
	return
}

func RefreshReportImportHistory(multiCiData []*models.MultiCiDataObj) (err error) {
	var actions []*execAction
	for _, ciObj := range multiCiData {
		// 检查是否合法：唯一性和不为空
		tmpAction, tmpErr := addActionForReportCiImportGuidMap(ciObj)
		if tmpAction != nil && tmpErr == nil {
			actions = append(actions, tmpAction...)
		}
	}
	if actions != nil {
		err = transaction(actions)
	}
	return
}
