package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"strings"
)

func CiDataQuery(ciType string, param *models.QueryRequestParam, permission *models.CiDataLegalGuidList, fromCore bool) (pageInfo models.PageInfo, rowData []map[string]interface{}, err error) {
	ciAttrs, err := GetCiAttrByCiType(ciType, true)
	if err != nil {
		err = fmt.Errorf("Try to get ci attribute with ciType:%s error,%s ", ciType, err.Error())
		return
	}
	var keyMap = make(map[string]string)
	var refAttrs, multiRefAttrs, objectAttrs, passwordAttrs, multiTextAttrs, multiIntAttrs []*models.CiDataQueryRefAttrObj
	resultColumns := models.CiQueryColumnList{}
	for _, attr := range ciAttrs {
		if attr.InputType != models.MultiRefType {
			keyMap[attr.Name] = attr.Name
		}
		if attr.Name == "guid" {
			continue
		}
		columnEnable := false
		if len(param.ResultColumns) == 0 {
			resultColumns = append(resultColumns, &models.CiQueryColumnObj{Name: attr.Name, Index: attr.UiFormOrder})
			columnEnable = true
		} else {
			for _, tmpColumn := range param.ResultColumns {
				if tmpColumn == attr.Name {
					resultColumns = append(resultColumns, &models.CiQueryColumnObj{Name: attr.Name, Index: attr.UiFormOrder})
					columnEnable = true
					break
				}
			}
		}
		if columnEnable {
			if attr.InputType == models.MultiRefType {
				multiRefAttrs = append(multiRefAttrs, &models.CiDataQueryRefAttrObj{Attribute: attr})
				continue
			}
			if attr.RefCiType != "" {
				refAttrs = append(refAttrs, &models.CiDataQueryRefAttrObj{Attribute: attr})
			} else if attr.InputType == "object" || attr.InputType == "multiObject" {
				objectAttrs = append(objectAttrs, &models.CiDataQueryRefAttrObj{Attribute: attr})
			} else if attr.InputType == "password" {
				passwordAttrs = append(passwordAttrs, &models.CiDataQueryRefAttrObj{Attribute: attr})
			} else if attr.InputType == "multiText" || attr.InputType == "multiSelect" {
				multiTextAttrs = append(multiTextAttrs, &models.CiDataQueryRefAttrObj{Attribute: attr})
			} else if attr.InputType == "multiInt" {
				multiIntAttrs = append(multiIntAttrs, &models.CiDataQueryRefAttrObj{Attribute: attr})
			}
		}
	}
	keyMap["history_state_confirmed"] = "history_state_confirmed"
	param.ResultColumns = append([]string{"guid"}, resultColumns.GetNameList()...)
	filterSql, queryColumn, queryParam := transFiltersToSQL(param, &models.TransFiltersParam{IsStruct: false, KeyMap: keyMap, PrimaryKey: "guid", Prefix: "tt"})
	var baseSql string
	if !permission.Enable {
		filterSql += " and tt.guid in ('" + strings.Join(permission.GuidList, "','") + "') "
	}
	historyFlag := false
	if param.Dialect == nil {
		param.Dialect = &models.QueryRequestDialect{QueryMode: "new"}
	}
	if param.Dialect.QueryMode == "new" {
		baseSql = fmt.Sprintf("SELECT %s FROM %s tt WHERE 1=1 %s ", queryColumn, ciType, filterSql)
	} else if param.Dialect.QueryMode == "all" {
		historyFlag = true
		if queryColumn != " * " {
			queryColumn += ",tt.history_action,tt.history_state_confirmed,tt.history_time,tt.id"
		}
		baseSql = fmt.Sprintf("SELECT %s FROM %s%s tt WHERE 1=1 %s ", queryColumn, HistoryTablePrefix, ciType, filterSql)
	} else if param.Dialect.QueryMode == "real" {
		historyFlag = true
		if queryColumn != " * " {
			queryColumn += ",tt.history_action,tt.history_state_confirmed,tt.history_time,tt.id"
		}
		//filterSql += " and tt.history_state_confirmed=1 "
		subBaseSql := fmt.Sprintf("select * from %s%s where id in (select max(id) from %s%s where history_state_confirmed=1 and guid in (select guid from %s) group by guid)",
			HistoryTablePrefix, ciType, HistoryTablePrefix, ciType, ciType)
		baseSql = fmt.Sprintf("SELECT %s FROM (%s) tt WHERE 1=1 %s ", queryColumn, subBaseSql, filterSql)
	} else {
		baseSql = fmt.Sprintf("SELECT %s FROM %s tt WHERE 1=1 %s ", queryColumn, ciType, filterSql)
	}
	if param.Paging {
		pageInfo.StartIndex = param.Pageable.StartIndex
		pageInfo.PageSize = param.Pageable.PageSize
		pageInfo.TotalRows = queryCount(baseSql, queryParam...)
		pageSql, pageParam := transPageInfoToSQL(*param.Pageable)
		baseSql += pageSql
		queryParam = append(queryParam, pageParam...)
	}
	queryParam = append([]interface{}{baseSql}, queryParam...)
	queryRowData, queryErr := x.QueryString(queryParam...)
	if queryErr != nil {
		err = fmt.Errorf("Query database fail,%s ", queryErr.Error())
		return
	}
	if len(queryRowData) == 0 {
		return
	}
	transData, transErr := GetStateTransitionByCiType(ciType, false)
	if transErr != nil {
		err = transErr
		return
	}
	var transStateMap = make(map[string][]string)
	for _, transRow := range transData {
		tmpState := transRow.CurrentState[len(transRow.StateMachine)+2:]
		if _, b := transStateMap[tmpState]; b {
			existFlag := false
			for _, v := range transStateMap[tmpState] {
				if v == transRow.OperationEn {
					existFlag = true
					break
				}
			}
			if !existFlag {
				transStateMap[tmpState] = append(transStateMap[tmpState], transRow.OperationEn)
			}
		} else {
			transStateMap[tmpState] = []string{transRow.OperationEn}
		}
	}
	for _, row := range queryRowData {
		tmpMapObj := make(map[string]interface{})
		for k, v := range row {
			tmpMapObj[k] = v
		}
		if mapV, b := transStateMap[row["state"]]; b {
			tmpMapObj["nextOperations"] = mapV
		} else {
			tmpMapObj["nextOperations"] = []string{}
		}
		rowData = append(rowData, tmpMapObj)
	}
	if len(refAttrs) > 0 && !fromCore {
		if historyFlag {
			err = fetchRefAttrHistoryData(rowData, refAttrs)
		} else {
			err = fetchRefAttrData(rowData, refAttrs)
		}
		if err != nil {
			return
		}
		for i, row := range rowData {
			for _, refAttr := range refAttrs {
				if historyFlag {
					rowData[i][refAttr.Attribute.Name] = refAttr.RefObj[fmt.Sprintf("%s^%s", rowData[i][refAttr.Attribute.Name], rowData[i]["history_time"])]
				} else {
					rowData[i][refAttr.Attribute.Name] = refAttr.RefObj[row[refAttr.Attribute.Name].(string)]
				}
			}
		}
	}
	if len(multiRefAttrs) > 0 {
		err = fetchMultiRefAttrData(rowData, multiRefAttrs, historyFlag)
		if err != nil {
			return
		}
		for i, row := range rowData {
			for _, refAttr := range multiRefAttrs {
				rowGuidString := row["guid"].(string)
				if _, b := refAttr.MultiRefObj[rowGuidString]; b {
					if fromCore {
						tmpRefGuidList := []string{}
						for _, tmpRefObj := range refAttr.MultiRefObj[rowGuidString] {
							tmpRefGuidList = append(tmpRefGuidList, tmpRefObj.Guid)
						}
						rowData[i][refAttr.Attribute.Name] = tmpRefGuidList
					} else {
						rowData[i][refAttr.Attribute.Name] = refAttr.MultiRefObj[rowGuidString]
					}
				} else {
					rowData[i][refAttr.Attribute.Name] = []*models.CiDataRefDataObj{}
				}
			}
		}
	}
	if len(objectAttrs) > 0 || len(passwordAttrs) > 0 || len(multiTextAttrs) > 0 || len(multiIntAttrs) > 0 {
		for _, row := range rowData {
			for _, objAttr := range objectAttrs {
				handleQueryRowObject(objAttr.Attribute.Name, row)
			}
			if !fromCore {
				for _, pwdAttr := range passwordAttrs {
					handleQueryRowPassword(pwdAttr.Attribute.Name, row)
				}
			}
			for _, multiTextAttr := range multiTextAttrs {
				handleQueryRowMultiText(multiTextAttr.Attribute.Name, row)
			}
			for _, multiIntAttr := range multiIntAttrs {
				handleQueryRowMultiInt(multiIntAttr.Attribute.Name, row)
			}
		}
	}
	return
}

func handleQueryRowObject(attrName string, row map[string]interface{}) {
	if row[attrName] == nil {
		return
	}
	tmpRowStringValue := row[attrName].(string)
	if tmpRowStringValue != "" {
		tmpObj, tmpErr := jsonUnmarshalColumnValue(tmpRowStringValue)
		if tmpErr != nil {
			row[attrName] = models.CiDataObjectErrOutput{Error: tmpErr.Error(), Content: tmpRowStringValue}
		} else {
			row[attrName] = tmpObj
		}
	}
}

func handleQueryRowPassword(attrName string, row map[string]interface{}) {
	row[attrName] = models.PasswordDisplay
}

func handleQueryRowMultiText(attrName string, row map[string]interface{}) {
	if row[attrName] == nil {
		return
	}
	tmpRowStringValue := row[attrName].(string)
	if tmpRowStringValue != "" {
		tmpStringList := []string{}
		err := json.Unmarshal([]byte(tmpRowStringValue), &tmpStringList)
		if err != nil {
			row[attrName] = []string{fmt.Sprintf("Parse to []string error:%s ", err.Error())}
		} else {
			row[attrName] = tmpStringList
		}
	} else {
		row[attrName] = []string{}
	}
}

func handleQueryRowMultiInt(attrName string, row map[string]interface{}) {
	if row[attrName] == nil {
		return
	}
	tmpRowStringValue := row[attrName].(string)
	if tmpRowStringValue != "" {
		tmpIntList := []int{}
		err := json.Unmarshal([]byte(tmpRowStringValue), &tmpIntList)
		if err != nil {
			row[attrName] = fmt.Sprintf("Parse to []int error:%s ", err.Error())
		} else {
			row[attrName] = tmpIntList
		}
	} else {
		row[attrName] = []int{}
	}
}

func jsonUnmarshalColumnValue(input string) (result interface{}, err error) {
	if strings.Contains(input, models.SEPERATOR) {
		input = strings.ReplaceAll(input, models.SEPERATOR, "\\u0001")
	}
	var mapObj = make(map[string]interface{})
	var listMapObj []map[string]interface{}
	err = json.Unmarshal([]byte(input), &mapObj)
	if err != nil {
		err = json.Unmarshal([]byte(input), &listMapObj)
		if err != nil {
			return nil, err
		} else {
			return listMapObj, nil
		}
	} else {
		return mapObj, nil
	}
}

func fetchRefAttrData(rowData []map[string]interface{}, refAttrs []*models.CiDataQueryRefAttrObj) error {
	var err error
	for _, row := range rowData {
		for _, refAttr := range refAttrs {
			refAttr.GuidList = append(refAttr.GuidList, row[refAttr.Attribute.Name].(string))
		}
	}
	for _, refAttr := range refAttrs {
		refRowDatas := []*models.CiDataRefDataObj{}
		tmpErr := x.SQL(fmt.Sprintf("select guid,key_name from %s where guid in ('%s')", refAttr.Attribute.RefCiType, strings.Join(refAttr.GuidList, "','"))).Find(&refRowDatas)
		if tmpErr != nil {
			err = fmt.Errorf("Try to query ref attr:%s refCiType:%s fail,%s ", refAttr.Attribute.Name, refAttr.Attribute.RefCiType, tmpErr.Error())
			break
		}
		if len(refRowDatas) == 0 {
			x.SQL(fmt.Sprintf("select guid,key_name from %s%s where guid in ('%s') and state in ('null_0','null_1')", HistoryTablePrefix, refAttr.Attribute.RefCiType, strings.Join(refAttr.GuidList, "','"))).Find(&refRowDatas)
		}
		refRowMap := make(map[string]*models.CiDataRefDataObj)
		for _, refRow := range refRowDatas {
			refRowMap[refRow.Guid] = refRow
		}
		refAttr.RefObj = refRowMap
	}
	return err
}

func fetchRefAttrHistoryData(rowData []map[string]interface{}, refAttrs []*models.CiDataQueryRefAttrObj) error {
	var err error
	for _, row := range rowData {
		for _, refAttr := range refAttrs {
			refAttr.GuidList = append(refAttr.GuidList, row[refAttr.Attribute.Name].(string))
			refAttr.HistoryGuidList = append(refAttr.HistoryGuidList, &models.HistoryGuidObj{Guid: row[refAttr.Attribute.Name].(string), HistoryTime: row["history_time"].(string)})
		}
	}
	for _, refAttr := range refAttrs {
		refRowDatas := []*models.CiDataRefDataObj{}
		tmpErr := x.SQL(fmt.Sprintf("select guid,key_name,history_time from %s%s where guid in ('%s') order by guid,history_time", HistoryTablePrefix, refAttr.Attribute.RefCiType, strings.Join(refAttr.GuidList, "','"))).Find(&refRowDatas)
		if tmpErr != nil {
			err = fmt.Errorf("Try to query ref attr:%s refCiType:%s fail,%s ", refAttr.Attribute.Name, refAttr.Attribute.RefCiType, tmpErr.Error())
			break
		}
		refRowMap := make(map[string]*models.CiDataRefDataObj)
		for _, historyGuid := range refAttr.HistoryGuidList {
			tmpFetchData := models.CiDataRefDataObj{HistoryTime: ""}
			for _, refRow := range refRowDatas {
				if historyGuid.Guid != refRow.Guid {
					continue
				}
				if refRow.HistoryTime > historyGuid.HistoryTime {
					break
				}
				if refRow.HistoryTime > tmpFetchData.HistoryTime {
					tmpFetchData = *refRow
				}
			}
			refRowMap[fmt.Sprintf("%s^%s", historyGuid.Guid, historyGuid.HistoryTime)] = &tmpFetchData
		}
		refAttr.RefObj = refRowMap
	}
	return err
}

func fetchMultiRefAttrData(rowData []map[string]interface{}, multiRefAttrs []*models.CiDataQueryRefAttrObj, history bool) error {
	var err error
	rowGuidList := []string{}
	for _, row := range rowData {
		rowGuidList = append(rowGuidList, row["guid"].(string))
	}
	for _, attr := range multiRefAttrs {
		tmpQueryData, tmpErr := x.QueryString(fmt.Sprintf("select t1.from_guid,t1.to_guid,t2.key_name from %s$%s t1 join %s t2 on t1.to_guid=t2.guid where t1.from_guid in ('%s') order by t1.from_guid",
			attr.Attribute.CiType, attr.Attribute.Name, attr.Attribute.RefCiType, strings.Join(rowGuidList, "','")))
		if tmpErr != nil {
			err = fmt.Errorf("Try to query multi ref attr:%s refCiType:%s fail,%s ", attr.Attribute.Name, attr.Attribute.RefCiType, tmpErr.Error())
			break
		}
		guidGroupMap := make(map[string][]*models.CiDataRefDataObj)
		for _, row := range tmpQueryData {
			if _, b := guidGroupMap[row["from_guid"]]; b {
				guidGroupMap[row["from_guid"]] = append(guidGroupMap[row["from_guid"]], &models.CiDataRefDataObj{Guid: row["to_guid"], KeyName: row["key_name"]})
			} else {
				guidGroupMap[row["from_guid"]] = []*models.CiDataRefDataObj{&models.CiDataRefDataObj{Guid: row["to_guid"], KeyName: row["key_name"]}}
			}
		}
		attr.MultiRefObj = guidGroupMap
	}
	return err
}
