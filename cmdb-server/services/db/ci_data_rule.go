package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"strings"
	"time"
)

var (
	affectGuidListChan   = make(chan map[string][]*models.AutofillChainObj, 100)
	affectCiTypeChan     = make(chan string, 10)
	uniquePathHandleChan = make(chan []*models.AutoActiveHandleParam, 100)
	specialEqualChar     = models.SEPERATOR + "=" + models.SEPERATOR
	specialSeparateChar  = "," + models.SEPERATOR
	specialAndChar       = "&" + models.SEPERATOR
)

func buildAutofillValue(columnMap map[string]string, rule, attrInputType string) (newValueList []string, err error) {
	log.Logger.Debug("-----start buildAutofillValue columnMap", log.JsonObj("map", columnMap))
	if rule == "" {
		return
	}
	var ruleList []*models.AutofillObj
	err = json.Unmarshal([]byte(rule), &ruleList)
	if err != nil {
		err = fmt.Errorf("Build autofill value fail,json unmarhsal rule string error:%s ", err.Error())
		return
	}
	if len(ruleList) == 0 {
		err = fmt.Errorf("Analyze buil autofill value rule list fail,rule is empty ")
		return
	}
	var ruleObjValueList [][]string
	var autofillSubIndex, ruleSubIndex []int
	isSpecialStruct := false
	for i, ruleObj := range ruleList {
		// json结构表达式
		if ruleObj.Type == "rule" {
			tmpValueList, tmpIsAutofill, tmpErr := getRuleValue(columnMap, ruleObj.Value)
			if tmpErr != nil {
				err = fmt.Errorf("Try to get autofill reference data with rule value:%s fail,%s ", ruleObj.Value, tmpErr.Error())
				break
			}
			log.Logger.Debug("make resultValueList 2", log.StringList("list", tmpValueList))
			if tmpIsAutofill {
				newTmpValueList := []string{}
				log.Logger.Debug("auto fill decode result 1", log.StringList("valueList", tmpValueList))
				autofillSubIndex = append(autofillSubIndex, i)
				for _, autofillObj := range tmpValueList {
					log.Logger.Debug("sub autofill rule", log.String("rule", autofillObj))
					autofillSubResult, tmpErr := buildAutofillValue(columnMap, autofillObj, models.AutofillRuleType)
					if tmpErr != nil {
						log.Logger.Error("sub autofill rule error", log.Error(tmpErr))
						err = fmt.Errorf("sub autofill rule error:%s ", tmpErr.Error())
						break
						//newTmpValueList = append(newTmpValueList, "")
					} else {
						newTmpValueList = append(newTmpValueList, getAutofillValueString(autofillSubResult))
					}
				}
				if err != nil {
					break
				}
				log.Logger.Debug("auto fill decode result 2", log.StringList("valueList", newTmpValueList))
				tmpValueList = newTmpValueList
			}
			ruleSubIndex = append(ruleSubIndex, i)
			ruleObjValueList = append(ruleObjValueList, tmpValueList)
		} else if ruleObj.Type == "delimiter" {
			// 连接符
			ruleObjValueList = append(ruleObjValueList, []string{ruleObj.Value})
		} else if ruleObj.Type == "specialDelimiter" {
			if ruleObj.Value == "=" {
				ruleObj.Value = specialEqualChar
			}
			if ruleObj.Value == "&" {
				ruleObj.Value = specialAndChar
			}
			ruleObjValueList = append(ruleObjValueList, []string{ruleObj.Value})
			isSpecialStruct = true
		}
	}
	if err != nil || len(ruleObjValueList) == 0 {
		return
	}
	// 特殊处理autofillRule类型的值
	if len(autofillSubIndex) > 0 {
		autofillSubIndex = ruleSubIndex
		tmpSubListLength := len(ruleObjValueList[autofillSubIndex[0]])
		for _, listIndex := range autofillSubIndex {
			if tmpSubListLength != len(ruleObjValueList[listIndex]) {
				err = fmt.Errorf("InpuType:%s fetch diff length value,first rule value length:%d Num:%d rule length:%d ", models.AutofillRuleType, tmpSubListLength, listIndex, len(ruleObjValueList[listIndex]))
				break
			}
		}
		if err != nil {
			return
		}
		if attrInputType == models.ObjectInputType {
			for i := 0; i < tmpSubListLength; i++ {
				tmpValue := ""
				for j, v := range ruleObjValueList {
					if len(v) == 0 {
						continue
					}
					isAutofillIndex := false
					for _, listIndex := range autofillSubIndex {
						if listIndex == j {
							isAutofillIndex = true
							break
						}
					}
					if isAutofillIndex {
						tmpValue += v[i]
					} else {
						tmpValue += v[0]
					}
				}
				newValueList = append(newValueList, tmpValue)
			}
			return
		}
		for _, listIndex := range autofillSubIndex {
			if isSpecialStruct {
				ruleObjValueList[listIndex] = []string{strings.Join(ruleObjValueList[listIndex], specialSeparateChar)}
				continue
			}
			ruleObjValueList[listIndex] = []string{strings.Join(ruleObjValueList[listIndex], ",")}
		}
	}
	// 起始数组,从第一个不为空的数组开始
	startRuleValueIndex := 0
	for i, ruleObjValue := range ruleObjValueList {
		if len(ruleObjValue) > 0 {
			startRuleValueIndex = i
			newValueList = ruleObjValue
			break
		}
	}
	if len(ruleObjValueList) == 1 || len(newValueList) == 0 {
		return
	}
	// 多段进行笛卡尔积拼接
	for i := startRuleValueIndex; i < len(ruleObjValueList)-1; i++ {
		if len(ruleObjValueList[i+1]) == 0 {
			continue
		}
		tmpValueList := []string{}
		for _, v := range newValueList {
			for _, vv := range ruleObjValueList[i+1] {
				tmpValueList = append(tmpValueList, v+vv)
			}
		}
		newValueList = tmpValueList
	}
	log.Logger.Debug("-----end buildAutofillValue", log.StringList("result", newValueList))
	return
}

func getRuleValue(rowData map[string]string, ruleString string) (resultValueList []string, isTypeAutofill bool, err error) {
	var ruleList []*models.AutofillValueObj
	err = json.Unmarshal([]byte(ruleString), &ruleList)
	if err != nil {
		err = fmt.Errorf("Json unmarshal rule expression error,%s ", err.Error())
		return
	}
	if len(ruleList) == 0 {
		err = fmt.Errorf("Analyze rule string fail,ruleList is empty ")
		return
	}
	var rowDataList []map[string]string
	if len(rowData) > 0 {
		// 如果是从头出发，以某行数据为原始数据开始
		rowDataList = append(rowDataList, rowData)
	} else {
		// 如果是嵌套递归的，因为是从过滤规则中开始填充，则没有原始行数据，需要查出所有行数据来
		rowDataList, err = x.QueryString("select * from " + ruleList[0].CiTypeId)
	}
	isTypeAutofill = false
	for i, rule := range ruleList {
		if i == 0 {
			continue
		}
		rule.ParentRs.AttrId = strings.ReplaceAll(rule.ParentRs.AttrId, models.SysTableIdConnector, "#")
		// ciType与attribute用#连接
		log.Logger.Debug("rule do 1", log.String("attrId", rule.ParentRs.AttrId), log.Int("i", i))
		tmpAttrSplit := strings.Split(rule.ParentRs.AttrId, "#")
		if len(tmpAttrSplit) < 2 {
			continue
		}
		//isMultiRef := isAttributeMultiRef(tmpAttrSplit[0], tmpAttrSplit[1])
		isMultiRef := false
		tmpAttrInputType := getAttributeInputType(tmpAttrSplit[0], tmpAttrSplit[1], "")
		if tmpAttrInputType == models.MultiRefType {
			isMultiRef = true
		}
		if tmpAttrInputType == models.AutofillRuleType {
			isTypeAutofill = true
		}
		// 是否被上一个rule引用,如果为0的话说明是当前rule的ci引用上一个rule的ci
		if rule.ParentRs.IsReferedFromParent == 1 {
			if i == len(ruleList)-1 {
				// 此时应该是落到了某个非关联的属性上，理应在最后节点上，获取值
				for _, tmpRowData := range rowDataList {
					resultValueList = append(resultValueList, tmpRowData[tmpAttrSplit[1]])
				}
				log.Logger.Debug("make resultValueList 1", log.StringList("list", resultValueList))
			} else {
				tmpGuidList := []string{}
				if !isMultiRef || i == 1 {
					// 直接从rowDataList里面的相应attr拿下一个关联的guid列表
					for _, tmpRowData := range rowDataList {
						if strings.Contains(tmpRowData[tmpAttrSplit[1]], ",") {
							tmpGuidList = append(tmpGuidList, strings.Split(tmpRowData[tmpAttrSplit[1]], ",")...)
						} else {
							tmpGuidList = append(tmpGuidList, tmpRowData[tmpAttrSplit[1]])
						}
					}
					log.Logger.Debug("tmpGuidList 1", log.StringList("guidList", tmpGuidList), log.String("attr", tmpAttrSplit[1]))
					rowDataList, err = getCiRowDataByGuid(rule.CiTypeId, tmpGuidList, rule.Filters, tmpAttrInputType, rowData)
				} else {
					// 直接从rowDataList里面的相应attr拿下一个关联的guid列表
					for _, tmpRowData := range rowDataList {
						if strings.Contains(tmpRowData["guid"], ",") {
							tmpGuidList = append(tmpGuidList, strings.Split(tmpRowData["guid"], ",")...)
						} else {
							tmpGuidList = append(tmpGuidList, tmpRowData["guid"])
						}
					}
					// 需要再去关联表里面查出关联的目标行
					log.Logger.Debug("tmpGuidList multi 2", log.StringList("guidList", tmpGuidList), log.String("attr", tmpAttrSplit[1]))
					rowDataList, err = getMultiRefRowData(tmpAttrSplit[0], tmpAttrSplit[1], rule.CiTypeId, tmpGuidList, rule.Filters, tmpAttrInputType, rowData)
				}
			}
			log.Logger.Debug("tmpRowDataObj", log.Int("len", len(rowDataList)))
		} else {
			rowDataList, err = getReferRowDataByFilter(rule.CiTypeId, tmpAttrSplit[1], rule.Filters, rowDataList, isMultiRef, tmpAttrInputType, rowData)
		}
		if err != nil {
			break
		}
	}
	return
}

func getReferRowDataByFilter(ciTypeId, attr string, filters []*models.AutofillFilterObj, rowDataList []map[string]string, multiRef bool, inputType string, startRowData map[string]string) (rowMapList []map[string]string, err error) {
	var filterSqlList, rowGuidList []string
	for _, f := range filters {
		f.CiType = ciTypeId
		tmpSql, tmpErr := getFilterSql(f, "t1", inputType, startRowData)
		if tmpErr != nil {
			err = fmt.Errorf("Get filter:%s sql error:%s ", f, tmpErr.Error())
			break
		}
		filterSqlList = append(filterSqlList, tmpSql)
	}
	if err != nil {
		return
	}
	for _, rowData := range rowDataList {
		rowGuidList = append(rowGuidList, rowData["guid"])
	}
	var sql string
	if !multiRef {
		sql = fmt.Sprintf("select * from %s t1 where t1.%s in ('%s')", ciTypeId, attr, strings.Join(rowGuidList, "','"))
	} else {
		sql = fmt.Sprintf("select distinct t1.* from %s t1 join %s$%s t2 on t1.guid=t2.from_guid where t2.to_guid in ('%s')", ciTypeId, ciTypeId, attr, strings.Join(rowGuidList, "','"))
	}
	if len(filterSqlList) > 0 {
		sql += " AND " + strings.Join(filterSqlList, " AND ")
	}
	log.Logger.Debug("getReferRowDataByFilter", log.String("sql", sql))
	rowMapList, err = x.QueryString(sql)
	if err != nil {
		log.Logger.Error("Get reference row data by filter fail", log.Error(err))
	}
	return
}

func getFilterSql(filter *models.AutofillFilterObj, prefix, inputType string, startRowData map[string]string) (sql string, err error) {
	var valueString, columnString string
	var valueList []string
	log.Logger.Debug("getFilterSql", log.String("ciType", filter.CiType), log.String("attr", filter.Name), log.String("filterType", filter.Type))
	if filter.Type == "autoFill" {
		valueString := filter.Value.(string)
		valueList, err = buildAutofillValue(startRowData, valueString, inputType)
		if err != nil {
			err = fmt.Errorf("Build filter value error:%s ", err.Error())
			return
		}
		if len(valueList) > 0 {
			valueString = valueList[0]
		}
	} else if filter.Operator == "in" {
		for _, rv := range filter.Value.([]interface{}) {
			valueList = append(valueList, rv.(string))
		}
	}
	if valueString == "" {
		valueString = fmt.Sprintf("%s", filter.Value)
	}
	if prefix != "" {
		columnString = filter.Name
		filter.Name = fmt.Sprintf("%s.%s", prefix, filter.Name)
	}
	var multiSql string
	switch filter.Operator {
	case "in":
		sql = fmt.Sprintf("%s IN ('%s')", filter.Name, strings.Join(valueList, "','"))
		multiSql = fmt.Sprintf("to_guid IN ('%s')", strings.Join(valueList, "','"))
		break
	case "contains":
		sql = fmt.Sprintf("%s LIKE '%%%s%%'", filter.Name, valueString)
		break
	case "eq":
		sql = fmt.Sprintf("%s='%s'", filter.Name, valueString)
		multiSql = fmt.Sprintf("to_guid='%s'", valueString)
		break
	case "gt":
		sql = fmt.Sprintf("%s>'%s'", filter.Name, valueString)
		break
	case "lt":
		sql = fmt.Sprintf("%s<'%s'", filter.Name, valueString)
		break
	case "ne":
		sql = fmt.Sprintf("%s!='%s'", filter.Name, valueString)
		multiSql = fmt.Sprintf("to_guid!='%s'", valueString)
		break
	case "notNull":
		sql = fmt.Sprintf("%s IS NOT NULL", filter.Name)
		break
	case "null":
		sql = fmt.Sprintf("%s IS NULL", filter.Name)
		break
	}
	if isAttributeMultiRef(filter.CiType, columnString) {
		if multiSql != "" {
			multiSql = " and " + multiSql
		}
		queryRows, queryErr := x.QueryString(fmt.Sprintf("select * from %s$%s where 1=1 %s", filter.CiType, columnString, multiSql))
		if queryErr != nil {
			err = fmt.Errorf("getFilterSql:Try to query multiRef fail,%s ", queryErr.Error())
			return
		}
		guidList := []string{}
		for _, v := range queryRows {
			guidList = append(guidList, v["from_guid"])
		}
		sql = fmt.Sprintf("guid in ('%s')", strings.Join(guidList, "','"))
	}
	return
}

func getAutofillValueString(valueList []string) string {
	if len(valueList) == 0 {
		return ""
	}
	if len(valueList) == 1 {
		return valueList[0]
	}
	return fmt.Sprintf("[%s]", strings.Join(valueList, ","))
}

func GetCiDataByFilters(attrId string, filterMap map[string]string, reqParam models.QueryRequestParam) (pageInfo models.PageInfo, rowData []map[string]interface{}, err error) {
	var attrTable []*models.SysCiTypeAttrTable
	err = x.SQL("select name,input_type,ref_ci_type,ref_filter from sys_ci_type_attr where id=?", attrId).Find(&attrTable)
	if err != nil {
		err = fmt.Errorf("Get ci reference data fail,query database error:%s ", err.Error())
		return
	}
	if len(attrTable) == 0 {
		err = fmt.Errorf("Get ci reference data fail,can not find attribyte:%s ", attrId)
		return
	}
	if attrTable[0].RefCiType == "" {
		err = fmt.Errorf("Get ci reference data fail,attr:%s is not reference type ", attrId)
		return
	}
	if attrTable[0].RefFilter == "" {
		var queryResults []*models.CiDataRefDataObj
		err = x.SQL(fmt.Sprintf("select guid,key_name from %s", attrTable[0].RefCiType)).Find(&queryResults)
		if err != nil {
			return
		}
		for _, row := range queryResults {
			tmpMap := make(map[string]interface{})
			tmpMap["guid"] = row.Guid
			tmpMap["key_name"] = row.KeyName
			rowData = append(rowData, tmpMap)
		}
		return
	}
	//Example: [{"filter_1":{"left":"host_resource:[guid]","operator":"in","right":{"type":"expression","value":"app_instance.unit>unit.resource_set>resource_set~(resource_set)host_resource:[guid]"}}}]
	var filters []map[string]models.CiDataRefFilterObj
	err = json.Unmarshal([]byte(attrTable[0].RefFilter), &filters)
	if err != nil {
		err = fmt.Errorf("Json unmarshal filters string fail,%s ", err.Error())
		return
	}
	if len(filters) == 0 {
		err = fmt.Errorf("Get ci reference data fail,filters string illgeal ")
		return
	}
	if _, b := filterMap[attrTable[0].Name]; b {
		delete(filterMap, attrTable[0].Name)
	}
	var filterSqlList []string
	for _, filter := range filters[0] {
		tmpFilterSql, tmpErr := getRefFilterSql(&filter, filterMap)
		if tmpErr != nil {
			err = tmpErr
			break
		}
		filterSqlList = append(filterSqlList, tmpFilterSql)
	}
	if err != nil {
		err = fmt.Errorf("Get ci reference data fail when build filter sql,%s ", err.Error())
		return
	}
	querySql := fmt.Sprintf("select guid,key_name from %s ", attrTable[0].RefCiType)
	if len(filterSqlList) > 0 {
		querySql = fmt.Sprintf("select guid,key_name from %s where 1=1 AND (%s)", attrTable[0].RefCiType, strings.Join(filterSqlList, ") AND ("))
	}
	rowStringData, queryErr := x.QueryString(querySql)
	if queryErr != nil {
		err = queryErr
		return
	}
	if reqParam.Paging == false {
		log.Logger.Debug("req Param paging is false")
		for _, row := range rowStringData {
			tmpRowData := make(map[string]interface{})
			for k, v := range row {
				tmpRowData[k] = v
			}
			rowData = append(rowData, tmpRowData)
		}
	} else {
		filterGuidParam := models.CiDataLegalGuidList{Enable: false}
		if len(filterSqlList) > 0 {
			filterGuidParam.Enable = true
			filterGuidParam.GuidList = []string{}
			for _, row := range rowStringData {
				filterGuidParam.GuidList = append(filterGuidParam.GuidList, row["guid"])
			}
		}
		pageInfo, rowData, err = CiDataQuery(attrTable[0].RefCiType, &reqParam, &filterGuidParam, false)
	}
	return
}

func getRefFilterSql(filter *models.CiDataRefFilterObj, filterMap map[string]string) (sql string, err error) {
	startCiType := filter.Left[:strings.LastIndex(filter.Left, "[")]
	//if _, b := filterMap[startCiType]; b {
	//	delete(filterMap, startCiType)
	//}
	column := filter.Left[strings.LastIndex(filter.Left, "[")+1 : strings.LastIndex(filter.Left, "]")]
	var valueList []string
	if filter.Right.Type == "expression" {
		//Example: {"type":"expression","value":"app_instance.unit>unit.resource_set>resource_set~(resource_set)host_resource:[guid]"}
		valueList, err = getExpressResultList(fmt.Sprintf("%s", filter.Right.Value), startCiType, filterMap, false)
		if err != nil {
			return
		}
		if len(valueList) == 0 {
			if _, b := filterMap[column]; b {
				if filterMap[column] != "" {
					valueList = append(valueList, filterMap[column])
				}
			}
		}
	} else if filter.Right.Type == "array" {
		//Example: ["JAVA","NGINX","MYSQL"]
		for _, rv := range filter.Right.Value.([]interface{}) {
			valueList = append(valueList, rv.(string))
		}
	}
	if strings.Contains(filter.Left, ">") || strings.Contains(filter.Left, "~") {
		valueList, err = getLeftFilterResultList(filter.Left, filter.Operator, fmt.Sprintf("%s", filter.Right.Value), valueList, filterMap)
		sql = buildConditionSql("guid", "in", "", valueList)
	} else {
		sql = buildConditionSql(column, filter.Operator, fmt.Sprintf("%s", filter.Right.Value), valueList)
	}
	log.Logger.Debug("getRefFilterSql", log.String("sql", sql))
	return
}

type expressionSqlObj struct {
	Table           string
	IndexTableName  string
	LeftJoinColumn  string
	RightJoinColumn string
	WhereSql        string
	ResultColumn    string
	RefColumn       string
	MultiRefTable   string
}

func getConditionExpressResult(express, startCiType string, filterMap map[string]string, permission bool) (result []string, err error) {
	var filterParams, tmpSplitList []string
	tmpExpress := express
	if strings.Contains(tmpExpress, "'") {
		tmpSplitList = strings.Split(tmpExpress, "'")
		tmpExpress = ""
		for i, v := range tmpSplitList {
			if i%2 == 0 {
				if i == len(tmpSplitList)-1 {
					tmpExpress += v
				} else {
					tmpExpress += fmt.Sprintf("%s'$%d'", v, i/2)
				}
			} else {
				filterParams = append(filterParams, strings.ReplaceAll(v, "'", ""))
			}
		}
	}
	if strings.Contains(tmpExpress, ",") {
		tmpList := [][]string{}
		for _, v := range strings.Split(tmpExpress, ",") {
			for ii, vv := range filterParams {
				v = strings.ReplaceAll(v, fmt.Sprintf("$%d", ii), vv)
			}
			tmpResult, tmpErr := getExpressResultList(v, startCiType, filterMap, permission)
			if tmpErr != nil {
				err = tmpErr
				break
			}
			tmpList = append(tmpList, tmpResult)
		}
		if err != nil {
			return
		}
		result = getSameElementList(tmpList)
		return
	}
	return getExpressResultList(express, startCiType, filterMap, permission)
}

func getSameElementList(input [][]string) []string {
	result := []string{}
	var tmpMap = make(map[string]int)
	for _, v := range input {
		for _, vv := range v {
			if _, b := tmpMap[vv]; b {
				tmpMap[vv] += 1
			} else {
				tmpMap[vv] = 1
			}
		}
	}
	for k, v := range tmpMap {
		if v == len(input) {
			result = append(result, k)
		}
	}
	return result
}

func getExpressResultList(express, startCiType string, filterMap map[string]string, permission bool) (result []string, err error) {
	log.Logger.Debug("getExpressResultList", log.String("express", express))
	// Example expression -> "host_resource_instance.resource_set>resource_set~(resource_set)unit[{key_name eq 'hhh'},{code in ['u','v']}]:[guid]"
	var ciList, filterParams, tmpSplitList []string
	// replace content 'xxx' to '$1' in case of content have '>~.:()[]'
	if strings.Contains(express, "'") {
		tmpSplitList = strings.Split(express, "'")
		express = ""
		for i, v := range tmpSplitList {
			if i%2 == 0 {
				if i == len(tmpSplitList)-1 {
					express += v
				} else {
					express += fmt.Sprintf("%s'$%d'", v, i/2)
				}
			} else {
				filterParams = append(filterParams, strings.ReplaceAll(v, "'", ""))
			}
		}
	}
	if permission {
		firstGuidIndex := strings.Index(express, ":[guid]")
		if firstGuidIndex > 0 {
			express = express[:firstGuidIndex] + express[firstGuidIndex+7:]
		}
	}
	// split with > or ~
	var cursor int
	for i, v := range express {
		if v == 62 || v == 126 {
			ciList = append(ciList, express[cursor:i])
			cursor = i
		}
	}
	ciList = append(ciList, express[cursor:])
	// analyze each ci segment
	var expressionSqlList []*expressionSqlObj
	for i, ci := range ciList {
		eso := expressionSqlObj{IndexTableName: fmt.Sprintf("t%d", i)}
		if strings.HasPrefix(ci, ">") {
			eso.LeftJoinColumn = ciList[i-1][strings.LastIndex(ciList[i-1], ".")+1:]
			ci = ci[1:]
		} else if strings.HasPrefix(ci, "~") {
			eso.RightJoinColumn = ci[2:strings.Index(ci, ")")]
			eso.RefColumn = eso.RightJoinColumn
			ci = ci[strings.Index(ci, ")")+1:]
		}
		// ASCII . -> 46 , [ -> 91 , ] -> 93 , : -> 58 , { -> 123 , } -> 125
		for j, v := range ci {
			if v == 46 || v == 58 || v == 91 {
				eso.Table = ci[:j]
				ci = ci[j:]
				break
			}
		}
		if eso.Table == "" {
			eso.Table = ci
		}
		if ci[0] == 91 {
			tmpFilterStr := ci[2 : len(ci)-2]
			for j, v := range ci {
				if v == 46 || v == 58 {
					tmpFilterStr = ci[2 : j-2]
					ci = ci[j:]
					break
				}
			}
			for _, v := range strings.Split(tmpFilterStr, "},{") {
				tmpFilterList := strings.Split(v, " ")
				if len(tmpFilterList) > 2 {
					eso.WhereSql += " and " + buildConditionSql(fmt.Sprintf("%s.%s", eso.IndexTableName, tmpFilterList[0]), tmpFilterList[1], tmpFilterList[2], []string{})
				} else {
					eso.WhereSql += " and " + buildConditionSql(fmt.Sprintf("%s.%s", eso.IndexTableName, tmpFilterList[0]), tmpFilterList[1], "", []string{})
				}
			}
		}
		if ci[0] == 58 {
			eso.ResultColumn = ci[2 : len(ci)-1]
		}
		if i == 0 && !permission && len(ciList) > 1 {
			continue
		}
		expressionSqlList = append(expressionSqlList, &eso)
	}
	eLen := len(expressionSqlList)
	if eLen == 0 {
		return
	}
	checkFilterAttrMultiRef(expressionSqlList)
	eLen = eLen - 1
	sql := fmt.Sprintf("select %s.%s from ", expressionSqlList[eLen].IndexTableName, expressionSqlList[eLen].ResultColumn)
	if permission {
		sql = fmt.Sprintf("select %s.guid from ", expressionSqlList[0].IndexTableName)
	}
	var whereSql string
	for i, v := range expressionSqlList {
		tmpTableName := v.Table
		if v.MultiRefTable != "" {
			tmpTableName = v.MultiRefTable
		}
		if i == 0 {
			sql += fmt.Sprintf(" %s %s ", tmpTableName, v.IndexTableName)
		} else {
			if v.LeftJoinColumn != "" {
				sql += fmt.Sprintf(" left join %s %s on %s.%s=%s.guid ", tmpTableName, v.IndexTableName, expressionSqlList[i-1].IndexTableName, v.LeftJoinColumn, v.IndexTableName)
			} else if expressionSqlList[i].RightJoinColumn != "" {
				sql += fmt.Sprintf(" right join %s %s on %s.guid=%s.%s ", tmpTableName, v.IndexTableName, expressionSqlList[i-1].IndexTableName, v.IndexTableName, v.RightJoinColumn)
			}
		}
		if v.WhereSql != "" {
			whereSql += v.WhereSql
		}
		if i == 0 {
			if _, b := filterMap[v.Table]; b {
				if strings.Contains(filterMap[v.Table], ",") {
					whereSql += fmt.Sprintf(" and %s.guid in ('%s') ", v.IndexTableName, strings.ReplaceAll(filterMap[v.Table], ",", "','"))
				} else {
					whereSql += fmt.Sprintf(" and %s.guid='%s' ", v.IndexTableName, filterMap[v.Table])
				}
			} else {
				joinColumn := ""
				if v.LeftJoinColumn != "" {
					joinColumn = v.LeftJoinColumn
				} else if v.RightJoinColumn != "" {
					joinColumn = v.RightJoinColumn
				}
				if _, b := filterMap[joinColumn]; b {
					if strings.Contains(filterMap[joinColumn], ",") {
						whereSql += fmt.Sprintf(" and %s.guid in ('%s') ", v.IndexTableName, strings.ReplaceAll(filterMap[joinColumn], ",", "','"))
					} else {
						whereSql += fmt.Sprintf(" and %s.guid='%s' ", v.IndexTableName, filterMap[joinColumn])
					}
				}
			}
		}
	}
	if whereSql != "" {
		sql += " where 1=1 " + whereSql
	}
	for i, v := range filterParams {
		sql = strings.ReplaceAll(sql, fmt.Sprintf("$%d", i), v)
	}
	log.Logger.Debug("Expression filter sql", log.String("sql", sql))
	queryResults, queryErr := x.QueryString(sql)
	if queryErr != nil {
		err = fmt.Errorf("Query expression filter sql error,%s ", queryErr.Error())
	} else {
		for _, queryRow := range queryResults {
			if permission {
				result = append(result, queryRow["guid"])
			} else {
				result = append(result, queryRow[expressionSqlList[eLen].ResultColumn])
			}
		}
	}
	return
}

func buildConditionSql(column, operator, value string, valueList []string) string {
	if operator == "in" && len(valueList) == 0 && value != "" {
		valueList = strings.Split(strings.ReplaceAll(value[1:len(value)-1], "'", ""), ",")
	}
	value = strings.ReplaceAll(value, "'", "")
	var sql string
	switch operator {
	case "in":
		sql = fmt.Sprintf("%s in ('%s')", column, strings.Join(valueList, "','"))
		break
	case "eq":
		sql = fmt.Sprintf("%s='%s'", column, value)
		break
	case "ne":
		sql = fmt.Sprintf("%s!='%s'", column, value)
		break
	case "notNull":
		sql = fmt.Sprintf("%s IS NOT NULL", column)
		break
	case "null":
		sql = fmt.Sprintf("%s IS NULL", column)
		break
	case "notEmpty":
		sql = fmt.Sprintf("%s<>''", column)
		break
	case "empty":
		sql = fmt.Sprintf("%s=''", column)
		break
	case "like":
		sql = fmt.Sprintf("%s LIKE '%%%s%%'", column, value)
		break
	}
	return sql
}

func checkFilterAttrMultiRef(expressionSqlList []*expressionSqlObj) {
	for i := 0; i < len(expressionSqlList)-1; i++ {
		if expressionSqlList[i+1].LeftJoinColumn != "" {
			expressionSqlList[i].RefColumn = expressionSqlList[i+1].LeftJoinColumn
		}
	}
	var ciAttrSqlList []string
	for _, v := range expressionSqlList {
		if v.RefColumn == "" {
			continue
		}
		ciAttrSqlList = append(ciAttrSqlList, fmt.Sprintf("ci_type='%s' and name='%s'", v.Table, v.RefColumn))
	}
	if len(ciAttrSqlList) > 0 {
		var attrTable []*models.SysCiTypeAttrTable
		err := x.SQL(fmt.Sprintf("select id,ci_type,name,input_type,ref_filter from sys_ci_type_attr where (%s)", strings.Join(ciAttrSqlList, ") or ("))).Find(&attrTable)
		if err != nil {
			log.Logger.Error("check filter attribute if multi ref fail", log.Error(err))
		} else {
			for i, v := range expressionSqlList {
				if v.RefColumn == "" {
					continue
				}
				for _, attr := range attrTable {
					if attr.CiType == v.Table && attr.Name == v.RefColumn {
						if attr.InputType == models.MultiRefType {
							expressionSqlList[i].MultiRefTable = fmt.Sprintf("(select %s.*,%s$%s.to_guid as %s from %s left join %s$%s on %s.guid=%s$%s.from_guid)",
								v.Table, v.Table, v.RefColumn, v.RefColumn, v.Table, v.Table, v.RefColumn, v.Table, v.Table, v.RefColumn)
						}
						break
					}
				}
			}
		}
	}
}

func StartConsumeAffectGuidMap() {
	log.Logger.Debug("Start consume affect guid map cron job")
	for {
		autofillChainMap := <-affectGuidListChan
		go handleAffectGuidMap(autofillChainMap)
	}
}

func StartConsumeAffectCiType() {
	log.Logger.Debug("Start consume affect ci type cron job")
	for {
		ciType := <-affectCiTypeChan
		go handleAffectCiType(ciType)
	}
}

func handleAffectGuidMap(autofillChainMap map[string][]*models.AutofillChainObj) {
	log.Logger.Debug("Start handle affect guid list")
	//if len(autofillChainMap) > 0 {
	//	return
	//}
	affectCiMap := make(map[string]*models.AutofillChainCiColumn)
	for k, rows := range autofillChainMap {
		ciDepColumnList, tmpErr := getCiTypeAutofillDepColumn(k)
		if tmpErr != nil || len(ciDepColumnList) == 0 {
			continue
		}
		for _, row := range rows {
			for _, ciColumnObj := range ciDepColumnList {
				if compareListIsJoin(row.UpdateColumn, ciColumnObj.UsedColumn) {
					if _, b := affectCiMap[ciColumnObj.AttrId]; !b {
						affectCiMap[ciColumnObj.AttrId] = &models.AutofillChainCiColumn{AttrId: ciColumnObj.AttrId, CiTypeId: ciColumnObj.CiTypeId, CiAttrName: ciColumnObj.CiAttrName, AutofillRule: ciColumnObj.AutofillRule, UpdatedSubMap: make(map[string][]string)}
						affectCiMap[ciColumnObj.AttrId].UpdatedSubMap[k] = []string{row.Guid}
					} else {
						affectCiMap[ciColumnObj.AttrId].UpdatedSubMap[k] = append(affectCiMap[ciColumnObj.AttrId].UpdatedSubMap[k], row.Guid)
					}
				}
			}
		}
	}
	if len(affectCiMap) == 0 {
		log.Logger.Debug("End handle affect guid list,no ci to update")
		return
	}
	nowTime := time.Now().Format(models.DateTimeFormat)
	for _, attr := range affectCiMap {
		affectGuidList := findAutofillGuidDepList(attr)
		log.Logger.Debug("Handle affect autofill guid list", log.StringList("affect", affectGuidList))
		if len(affectGuidList) == 0 {
			continue
		}
		// Do update affect row
		for _, row := range affectGuidList {
			autofillAffectActionFunc(attr.CiTypeId, row, nowTime)
		}
	}
}

func handleAffectCiType(ciType string) {
	log.Logger.Info("start handle affect ci type autofill mode", log.String("ciType", ciType))
	queryRows, err := x.QueryString(fmt.Sprintf("select guid from %s", ciType))
	if err != nil {
		log.Logger.Error("Try to handle affect ci type fail,query ci data error", log.Error(err))
		return
	}
	nowTime := time.Now().Format(models.DateTimeFormat)
	for _, row := range queryRows {
		autofillAffectActionFunc(ciType, row["guid"], nowTime)
	}
}

// 查询其它ci中自动填充用到该ciType的ci,比如说 A->B.b C->B.c,则查询出自动填充中用了ciType:B的 A[b],C[c]
func getCiTypeAutofillDepColumn(ciType string) (ciColumnList []*models.AutofillChainCiColumn, err error) {
	var attributes []*models.SysCiTypeAttrTable
	err = x.SQL("select id,ci_type,name,autofill_rule from sys_ci_type_attr where autofill_rule like '%" + ciType + "#%' and ci_type<>'" + ciType + "'").Find(&attributes)
	if err != nil {
		log.Logger.Error("Try to get ciType autofill dependence column fail", log.Error(err))
		return
	}
	if len(attributes) == 0 {
		return
	}
	for _, attr := range attributes {
		tmpColumnList := []string{}
		for i, v := range strings.Split(attr.AutofillRule, ciType+"#") {
			if i == 0 {
				continue
			}
			tmpColumnList = append(tmpColumnList, v[:strings.Index(v, "\\\"")])
		}
		if len(tmpColumnList) == 0 {
			continue
		}
		ciColumnList = append(ciColumnList, &models.AutofillChainCiColumn{AttrId: attr.Id, CiTypeId: attr.CiType, CiAttrName: attr.Name, AutofillRule: attr.AutofillRule, UsedColumn: tmpColumnList})
	}
	return
}

func compareListIsJoin(aList, bList []string) bool {
	if len(aList) == 0 || len(bList) == 0 {
		return false
	}
	joinFlag := false
	for _, a := range aList {
		for _, b := range bList {
			if b == a {
				joinFlag = true
				break
			}
		}
		if joinFlag {
			break
		}
	}
	return joinFlag
}

func findAutofillGuidDepList(ciAttr *models.AutofillChainCiColumn) []string {
	var affectGuidList []string
	var ruleList []*models.AutofillObj
	err := json.Unmarshal([]byte(ciAttr.AutofillRule), &ruleList)
	if err != nil {
		log.Logger.Error("Find autofill dep list fail,json unmarhsal rule string error", log.Error(err))
		return affectGuidList
	}
	if len(ruleList) == 0 {
		return affectGuidList
	}
	for changeCiType, changeGuidList := range ciAttr.UpdatedSubMap {
		for _, rule := range ruleList {
			if !strings.Contains(rule.Value, changeCiType+"#") {
				continue
			}
			subRuleList, tmpErr := jsonParseAutofillValue(rule.Value)
			if tmpErr != nil {
				break
			}
			startFlag := false
			var tmpRowList []map[string]string
			for _, changeGuidObj := range changeGuidList {
				tmpMap := make(map[string]string)
				tmpMap["guid"] = changeGuidObj
				tmpRowList = append(tmpRowList, tmpMap)
			}
			tmpCiType := changeCiType
			for i := len(subRuleList) - 1; i > 0; i-- {
				attrIdSplit := strings.Split(subRuleList[i].ParentRs.AttrId, "#")
				if attrIdSplit[0] == changeCiType {
					startFlag = true
				}
				if !startFlag {
					continue
				}
				if subRuleList[i].ParentRs.IsReferedFromParent == 1 {
					if tmpCiType != attrIdSplit[0] {
						tmpRowList, tmpErr = queryAutofillLeftRows(attrIdSplit[0], attrIdSplit[1], tmpRowList, isAttributeMultiRef(attrIdSplit[0], attrIdSplit[1]))
					} else {
						tmpRowList, tmpErr = queryAutofillLeftRows(attrIdSplit[0], "guid", tmpRowList, false)
					}
				} else {
					tmpRowList, tmpErr = queryAutofillRightRows(attrIdSplit[0], subRuleList[i-1].CiTypeId, attrIdSplit[1], tmpRowList, isAttributeMultiRef(attrIdSplit[0], attrIdSplit[1]))
				}
				if tmpErr != nil {
					break
				}
			}
			if tmpErr != nil {
				break
			}
			for _, tmpRowObj := range tmpRowList {
				affectGuidList = append(affectGuidList, tmpRowObj["guid"])
			}
		}
	}
	return affectGuidList
}

func jsonParseAutofillValue(ruleString string) (ruleList []*models.AutofillValueObj, err error) {
	err = json.Unmarshal([]byte(strings.ReplaceAll(ruleString, "\\", "")), &ruleList)
	if err != nil {
		log.Logger.Error("json unmarshal autofill rule value fail", log.Error(err))
	}
	return
}

func queryAutofillLeftRows(ciTypeId, attr string, rowList []map[string]string, multiRef bool) (result []map[string]string, err error) {
	var guidList []string
	for _, v := range rowList {
		guidList = append(guidList, v["guid"])
	}
	if multiRef {
		rowList, err = x.QueryString(fmt.Sprintf("select distinct from_guid from %s$%s where to_guid in ('%s')", ciTypeId, attr, strings.Join(guidList, "','")))
		if err != nil {
			log.Logger.Error("query autofill multi left row data fail", log.Error(err))
			return
		}
		guidList = []string{}
		for _, v := range rowList {
			guidList = append(guidList, v["from_guid"])
		}
		attr = "guid"
	}
	result, err = x.QueryString(fmt.Sprintf("select * from %s where %s in ('%s')", ciTypeId, attr, strings.Join(guidList, "','")))
	if err != nil {
		log.Logger.Error("query autofill left row data fail", log.Error(err))
	}
	return
}

func queryAutofillRightRows(sourceCiTypeId, targetCiTypeId, attr string, rowList []map[string]string, multiRef bool) (result []map[string]string, err error) {
	var guidList []string
	if multiRef {
		for _, v := range rowList {
			guidList = append(guidList, v["guid"])
		}
		rowList, err = x.QueryString(fmt.Sprintf("select distinct to_guid from %s$%s where from_guid in ('%s')", sourceCiTypeId, attr, strings.Join(guidList, "','")))
		if err != nil {
			log.Logger.Error("query autofill multiRef right row data fail", log.Error(err))
			return
		}
		guidList = []string{}
		for _, v := range rowList {
			guidList = append(guidList, v["to_guid"])
		}
	} else {
		for _, v := range rowList {
			guidList = append(guidList, v[attr])
		}
	}
	result, err = x.QueryString(fmt.Sprintf("select * from %s where guid in ('%s')", targetCiTypeId, strings.Join(guidList, "','")))
	if err != nil {
		log.Logger.Error("query autofill right row data fail", log.Error(err))
	}
	return
}

func StartConsumeUniquePathHandle() {
	log.Logger.Info("Start consume unique path trigger cron job")
	for {
		uniquePathList := <-uniquePathHandleChan
		go consumeUniquePathHandle(uniquePathList)
	}
}

func consumeUniquePathHandle(uniquePathList []*models.AutoActiveHandleParam) {
	for _, uniquePathObj := range uniquePathList {
		tmpInputData := []models.CiDataMapObj{}
		guidList := []string{}
		for _, v := range uniquePathObj.Data {
			tmpInputData = append(tmpInputData, v)
			guidList = append(guidList, v["guid"])
		}
		log.Logger.Info("Start to active unique path handle", log.StringList("guid", guidList), log.String("operation", uniquePathObj.Operation))
		handleParam := models.HandleCiDataParam{InputData: tmpInputData, CiTypeId: uniquePathObj.CiType, Operation: uniquePathObj.Operation, Operator: uniquePathObj.User, Roles: []string{}, Permission: false, FromCore: false}
		_, _, err := HandleCiDataOperation(handleParam)
		if err != nil {
			log.Logger.Error("Unique path handle fail", log.Error(err))
		}
	}
}

func getLeftFilterResultList(left, operator, value string, rightValueList []string, filterMap map[string]string) (valueList []string, err error) {
	log.Logger.Debug("getLeftFilterResultList", log.String("left before", left))
	column := left[strings.LastIndex(left, "[")+1 : strings.LastIndex(left, "]")]
	left = left[:strings.LastIndex(left, ":")] + fmt.Sprintf("[{%s}]", buildLeftExpressCondition(column, operator, value, rightValueList))
	log.Logger.Debug("getLeftFilterResultList", log.String("left after", left))
	valueList, err = getExpressResultList(left, "", filterMap, true)
	if err != nil {
		err = fmt.Errorf("Try to analyze filter left express fail,%s ", err.Error())
	}
	return
}

func buildLeftExpressCondition(column, operator, value string, valueList []string) string {
	if operator == "in" && len(valueList) == 0 && value != "" {
		valueList = strings.Split(strings.ReplaceAll(value[1:len(value)-1], "'", ""), ",")
	}
	value = strings.ReplaceAll(value, "'", "")
	var sql string
	switch operator {
	case "in":
		sql = fmt.Sprintf("%s in ['%s']", column, strings.Join(valueList, "','"))
		break
	case "eq":
		sql = fmt.Sprintf("%s %s '%s'", column, operator, value)
		break
	case "ne":
		sql = fmt.Sprintf("%s %s '%s'", column, operator, value)
		break
	case "notNull":
		sql = fmt.Sprintf("%s %s", column, operator)
		break
	case "null":
		sql = fmt.Sprintf("%s %s", column, operator)
		break
	case "notEmpty":
		sql = fmt.Sprintf("%s %s", column, operator)
		break
	case "empty":
		sql = fmt.Sprintf("%s %s", column, operator)
		break
	case "like":
		sql = fmt.Sprintf("%s %s '%s'", column, operator, value)
		break
	}
	return sql
}
