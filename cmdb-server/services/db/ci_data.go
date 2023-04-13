package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/go-common-lib/pcre"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"sort"
	"strconv"
	"strings"
	"time"
)

func HandleCiDataOperation(param models.HandleCiDataParam) (outputData []models.CiDataMapObj, newInputBody string, err error) {
	var multiCiData []*models.MultiCiDataObj
	var firstAction string
	var deleteList []string
	if param.BareAction == "" {
		opActions, tmpErr := getActionByOperation(param.CiTypeId, param.Operation)
		if tmpErr != nil {
			err = tmpErr
			return
		}
		// TODO 把这个action的判断放到每行数据中
		firstAction = opActions[0]
	} else {
		firstAction = param.BareAction
	}
	if firstAction == "insert" {
		if param.CiTypeId == "" {
			err = fmt.Errorf("Url param ciType can not empty ")
			return
		} else {
			newGuidList := guid.CreateGuidList(len(param.InputData))
			for i, inputDataObj := range param.InputData {
				inputDataObj["guid"] = fmt.Sprintf("%s_%s", param.CiTypeId, newGuidList[i])
			}
			multiCiData = []*models.MultiCiDataObj{&models.MultiCiDataObj{CiTypeId: param.CiTypeId, InputData: param.InputData}}
		}
	} else {
		// 按ciType归类输入的数据行
		legalGuidMap := make(map[string]bool)
		guidPermissionEnable := false
		if param.Permission {
			permissionAction := firstAction
			if permissionAction == "confirm" {
				permissionAction = "execute"
			}
			permissions, tmpErr := GetRoleCiDataPermission(param.Roles, param.CiTypeId)
			if tmpErr != nil {
				err = tmpErr
				return
			}
			legalGuidList, tmpErr := GetCiDataPermissionGuidList(&permissions, permissionAction)
			if tmpErr != nil {
				err = tmpErr
				return
			}
			if !legalGuidList.Enable {
				for _, tmpGuid := range legalGuidList.GuidList {
					legalGuidMap[tmpGuid] = true
				}
				guidPermissionEnable = true
			}
		}
		for i, inputRowData := range param.InputData {
			tmpRowGuid := inputRowData["guid"]
			if tmpRowGuid == "" {
				if _, b := inputRowData["id"]; b {
					tmpHistoryObj := getHistoryDataById(param.CiTypeId, inputRowData["id"])
					tmpRowGuid = tmpHistoryObj["guid"]
					inputRowData["guid"] = tmpHistoryObj["guid"]
					inputRowData["state"] = tmpHistoryObj["state"]
				}
				if tmpRowGuid == "" {
					err = fmt.Errorf("Row:%d data can not find guid ", i)
					break
				}
			}
			if guidPermissionEnable {
				if _, b := legalGuidMap[tmpRowGuid]; !b {
					err = fmt.Errorf("Row:%d %s permission deny ", i, inputRowData["key_name"])
					break
				}
			}
			if firstAction == "delete" {
				deleteList = append(deleteList, tmpRowGuid)
			}
			if firstAction == "execute" {
				inputRowData["Authorization"] = param.UserToken
			}
			inputRowCiType := tmpRowGuid[:strings.LastIndex(tmpRowGuid, "_")]
			existFlag := false
			for j, tmpCiData := range multiCiData {
				if tmpCiData.CiTypeId == inputRowCiType {
					existFlag = true
					multiCiData[j].InputData = append(multiCiData[j].InputData, inputRowData)
					break
				}
			}
			if !existFlag {
				multiCiData = append(multiCiData, &models.MultiCiDataObj{CiTypeId: inputRowCiType, InputData: []models.CiDataMapObj{inputRowData}})
			}
		}
		if err != nil {
			// build new request body with guid
			return
		}
	}
	tNow := time.Now().Format(models.DateTimeFormat)
	// 获取属性字段
	if err = getMultiCiAttributes(multiCiData); err != nil {
		return
	}
	outputData, newInputBody = buildRequestBodyWithoutPwd(multiCiData, param.BareAction, tNow, param.Operation)
	// 获取状态机
	if param.BareAction == "" {
		if err = getMultiCiTransition(multiCiData); err != nil {
			return
		}
	} else if param.BareAction == "insert" {
		if err = getMultiCiStartTransition(multiCiData); err != nil {
			return
		}
	}
	if (firstAction == "update" || firstAction == "insert") && strings.ToLower(param.Operation) != models.RollbackAction {
		if err = validateUniqueColumn(multiCiData); err != nil {
			return
		}
		if param.BareAction == "" {
			if err = validateMultiRefFilterData(multiCiData); err != nil {
				return
			}
		}
	}
	if firstAction != "insert" {
		// 获取数据行现有数据
		if err = getMultiNowData(multiCiData); err != nil {
			return
		}
	}
	// 获取被依赖的引用,因为数据的改动可能会影响上游数据
	if err = getMultiReferenceAttributes(multiCiData); err != nil {
		return
	}
	var actions []*execAction
	var insertPermissionMap = make(map[string]*InsertPermissionObj)
	var autofillChainMap = make(map[string][]*models.AutofillChainObj)
	var uniquePathList []*models.AutoActiveHandleParam
	deleteUniquePath := models.AutoActiveHandleParam{User: models.SystemUser}
	for _, ciObj := range multiCiData {
		for i, inputRowData := range ciObj.InputData {
			actionParam := models.ActionFuncParam{CiType: ciObj.CiTypeId, InputData: inputRowData, Attributes: ciObj.Attributes, ReferenceAttributes: ciObj.ReferenceAttributes, Operator: param.Operator, Operation: param.Operation, NowTime: tNow, RefCiTypeMap: ciObj.RefCiTypeMap, DeleteList: deleteList, FromCore: param.FromCore}
			// 检查数据目标状态
			if param.BareAction != "" {
				if param.BareAction == "insert" {
					actionParam.Transition = ciObj.Transition[0]
				} else {
					actionParam.NowData = ciObj.NowData[i]
					actionParam.Transition = &models.SysStateTransitionQuery{Action: param.BareAction, TargetStateName: actionParam.NowData["state"], TargetState: actionParam.NowData["state"]}
				}
				actionParam.BareAction = param.BareAction
			} else {
				if firstAction != "insert" {
					actionParam.NowData = ciObj.NowData[i]
					tmpTransList := []*models.SysStateTransitionQuery{}
					for _, transObj := range ciObj.Transition {
						if transObj.CurrentStateName == actionParam.NowData["state"] && transObj.Operation == param.Operation {
							tmpTransList = append(tmpTransList, transObj)
						}
					}
					// 正常来说下一跳只有一个
					if len(tmpTransList) == 1 {
						actionParam.Transition = tmpTransList[0]
					} else if len(tmpTransList) > 1 {
						// rollback的情况下会有多个,此时需要从inputData中拿state来确定下一跳是哪个
						for _, tmpTransObj := range tmpTransList {
							if tmpTransObj.TargetStateName == inputRowData["state"] {
								actionParam.Transition = tmpTransObj
								break
							}
						}
					}
				} else {
					for _, transObj := range ciObj.Transition {
						if transObj.CurrentState == transObj.StartState {
							actionParam.Transition = transObj
							break
						}
					}
				}
				if actionParam.Transition == nil {
					err = fmt.Errorf("CiType:%s key_name:%s guid:%s data can not find target state from transition ", ciObj.CiTypeId, inputRowData["key_name"], inputRowData["guid"])
					break
				}
			}
			// 处理输入,把参数变成对应的SQL加进事务里
			tmpAction, tmpErr := doActionFunc(&actionParam)
			if tmpErr != nil {
				err = fmt.Errorf("CiType:%s do action:%s fail,%s ", ciObj.CiTypeId, actionParam.Transition.Action, tmpErr.Error())
				break
			}
			//outputData = append(outputData, actionParam.InputData)
			actions = append(actions, tmpAction...)
			if actionParam.Transition.Action == "insert" && param.Permission {
				if _, b := insertPermissionMap[ciObj.CiTypeId]; b {
					insertPermissionMap[ciObj.CiTypeId].GuidList = append(insertPermissionMap[ciObj.CiTypeId].GuidList, actionParam.InputData["guid"])
					insertPermissionMap[ciObj.CiTypeId].KeyNameList = append(insertPermissionMap[ciObj.CiTypeId].KeyNameList, actionParam.InputData["key_name"])
					insertPermissionMap[ciObj.CiTypeId].Actions = append(insertPermissionMap[ciObj.CiTypeId].Actions, tmpAction...)
				} else {
					insertPermissionMap[ciObj.CiTypeId] = &InsertPermissionObj{CiType: ciObj.CiTypeId, GuidList: []string{actionParam.InputData["guid"]}, Actions: tmpAction, KeyNameList: []string{actionParam.InputData["key_name"]}}
				}
			}
			if actionParam.Transition.Action == "update" {
				log.Logger.Info("update column", log.StringList("column", actionParam.UpdateColumn))
				if _, b := autofillChainMap[ciObj.CiTypeId]; b {
					autofillChainMap[ciObj.CiTypeId] = append(autofillChainMap[ciObj.CiTypeId], &models.AutofillChainObj{Guid: inputRowData["guid"], UpdateColumn: actionParam.UpdateColumn})
				} else {
					autofillChainMap[ciObj.CiTypeId] = []*models.AutofillChainObj{&models.AutofillChainObj{Guid: inputRowData["guid"], UpdateColumn: actionParam.UpdateColumn}}
				}
			}
			if actionParam.Transition.TargetUniquePath == "yes" {
				log.Logger.Info("Unique path trigger", log.String("data", actionParam.InputData["guid"]))
				uniqueTransition, tmpErr := getUniquePathNextOperation(actionParam.Transition.TargetState)
				if tmpErr != nil {
					err = fmt.Errorf("Unique path trigger find error,row:%s ,%s ", actionParam.InputData["key_name"], tmpErr.Error())
					break
				}
				if len(uniqueTransition) > 1 {
					err = fmt.Errorf("Unique path triger find more then one transition,row:%s ", actionParam.InputData["key_name"])
					break
				}
				if len(uniqueTransition) == 1 {
					if uniqueTransition[0].Action == "delete" {
						deleteUniquePath.Data = append(deleteUniquePath.Data, actionParam.NowData)
						deleteUniquePath.Operation = uniqueTransition[0].OperationEn
						deleteUniquePath.CiType = actionParam.CiType
					} else {
						tmpUniquePathObj := models.AutoActiveHandleParam{Operation: uniqueTransition[0].OperationEn, User: models.SystemUser, CiType: actionParam.CiType}
						if actionParam.Transition.Action == "insert" || actionParam.Transition.Action == "update" {
							tmpUniquePathObj.Data = []map[string]string{actionParam.InputData}
						} else {
							tmpUniquePathObj.Data = []map[string]string{actionParam.NowData}
						}
						uniquePathList = append(uniquePathList, &tmpUniquePathObj)
					}
				}
			}
		}
		if err != nil {
			break
		}
	}
	if err == nil {
		if len(insertPermissionMap) > 0 {
			err = ValidateInsertPermission(insertPermissionMap, param.Roles)
			if err != nil {
				return
			}
		}
		err = transaction(actions)
	}
	if err == nil {
		if len(autofillChainMap) > 0 {
			affectGuidListChan <- autofillChainMap
		}
		if len(deleteUniquePath.Data) > 0 {
			uniquePathList = append(uniquePathList, &deleteUniquePath)
		}
		if len(uniquePathList) > 0 {
			uniquePathHandleChan <- uniquePathList
		}
		if firstAction == "insert" {
			outputData, err = fetchNewRowData(multiCiData)
		}
	}
	return
}

func doActionFunc(param *models.ActionFuncParam) (result []*execAction, err error) {
	log.Logger.Info("do action func", log.String("action", param.Transition.Action))
	switch param.Transition.Action {
	case "insert":
		result, err = insertActionFunc(param)
		break
	case "update":
		result, err = updateActionFunc(param)
		break
	case "confirm":
		result, err = confirmActionFunc(param)
		break
	case "delete":
		result, err = deleteActionFunc(param)
		break
	case "execute":
		result, err = executeActionFunc(param)
		break
	default:
		err = fmt.Errorf("Action:%s can not support ", param.Transition.Action)
	}
	return
}

func insertActionFunc(param *models.ActionFuncParam) (result []*execAction, err error) {
	var columnList []*models.CiDataColumnObj
	var multiRefColumnList []string
	for _, ciAttr := range param.Attributes {
		buildValueParam := models.BuildAttrValueParam{NowTime: param.NowTime, AttributeConfig: ciAttr, IsSystem: false, Action: param.Transition.Action}
		if ciAttr.Name == "guid" {
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "create_user" {
			param.InputData["create_user"] = param.Operator
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "create_time" {
			param.InputData["create_time"] = param.NowTime
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "update_user" {
			param.InputData["update_user"] = param.Operator
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "update_time" {
			param.InputData["update_time"] = param.NowTime
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "state" {
			param.InputData["state"] = param.Transition.TargetStateName
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "confirm_time" {
			delete(param.InputData, ciAttr.Name)
			continue
		}
		if ciAttr.DataType == "datetime" && param.InputData[ciAttr.Name] == "" {
			delete(param.InputData, ciAttr.Name)
			continue
		}
		if _, b := param.InputData[ciAttr.Name]; !b {
			if ciAttr.AutofillAble != "yes" {
				if ciAttr.Nullable == "yes" {
					continue
				}
			}
		}
		buildValueParam.InputData = param.InputData
		tmpColumn, multiRefActions, tmpErr := buildAttrValue(&buildValueParam)
		if tmpErr != nil {
			err = fmt.Errorf("Column:%s %s \n", ciAttr.Name, tmpErr.Error())
			break
		}
		if ciAttr.InputType == models.MultiRefType {
			result = append(result, multiRefActions...)
			multiRefColumnList = append(multiRefColumnList, ciAttr.Name)
			continue
		}
		if !buildValueParam.IsSystem {
			param.InputData[ciAttr.Name] = tmpColumn.ValueString
		}
		columnList = append(columnList, tmpColumn)
	}
	for _, multiRefColumn := range multiRefColumnList {
		delete(param.InputData, multiRefColumn)
	}
	param.InputData = cleanInputData(param.InputData, param.Attributes)
	if err == nil {
		result = append(result, getInsertActionByColumnList(columnList, param.CiType))
		result = append(result, getHistoryActionByData(param.InputData, param.CiType, param.NowTime, param.Transition))
	}
	return
}

func updateActionFunc(param *models.ActionFuncParam) (result []*execAction, err error) {
	rollbackFlag := false
	if strings.ToLower(param.Operation) == models.RollbackAction {
		rollbackFlag = true
	}
	if rollbackFlag {
		// Rollback action
		rollbackData, tmpErr := x.QueryString(fmt.Sprintf("select * from %s%s where id=?", HistoryTablePrefix, param.CiType), param.InputData["id"])
		if tmpErr != nil {
			err = fmt.Errorf("Try to get history data with id:%s fail,%s ", param.InputData["id"], tmpErr.Error())
			return
		}
		if len(rollbackData) > 0 {
			rollbackFlag = true
			param.InputData = rollbackData[0]
		}
	} else {
		if param.InputData["update_time"] != "" {
			if param.InputData["update_time"] != param.NowData["update_time"] {
				err = fmt.Errorf("Row:%s update_time is diff with database ", param.NowData["key_name"])
				return
			}
		}
	}
	if param.BareAction == "" {
		if err = validateRightStateTrans(param); err != nil {
			return
		}
		if len(param.ReferenceAttributes) > 0 {
			if err = validateLeftStateTrans(param); err != nil {
				return
			}
		}
	}
	var columnList []*models.CiDataColumnObj
	var multiRefColumnList []string
	for k, _ := range param.InputData {
		if k == "history_action" || k == "history_time" || k == "history_state_confirmed" {
			delete(param.InputData, k)
		}
		//log.Logger.Debug("input data", log.String("k", k), log.String("v", v))
	}
	for _, ciAttr := range param.Attributes {
		if ciAttr.Name == "guid" {
			continue
		}
		if ciAttr.InputType == "password" {
			if param.InputData[ciAttr.Name] == models.PasswordDisplay {
				param.InputData[ciAttr.Name] = param.NowData[ciAttr.Name]
			}
		}
		buildValueParam := models.BuildAttrValueParam{NowTime: param.NowTime, AttributeConfig: ciAttr, IsSystem: false, Action: param.Transition.Action}
		if ciAttr.Name == "update_user" {
			param.InputData["update_user"] = param.Operator
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "update_time" {
			param.InputData["update_time"] = param.NowTime
			buildValueParam.IsSystem = true
		}
		if ciAttr.Name == "state" {
			param.InputData["state"] = param.Transition.TargetStateName
			buildValueParam.IsSystem = true
		}
		if ciAttr.Editable == "no" && ciAttr.AutofillAble == "no" && !buildValueParam.IsSystem {
			if ciAttr.DataType == "datetime" && param.NowData[ciAttr.Name] == "" {
				continue
			}
			param.InputData[ciAttr.Name] = param.NowData[ciAttr.Name]
			continue
		}
		if _, b := param.InputData[ciAttr.Name]; !b {
			if ciAttr.DataType == "datetime" && param.NowData[ciAttr.Name] == "" {
				continue
			}
			param.InputData[ciAttr.Name] = param.NowData[ciAttr.Name]
		} else if ciAttr.DataType == "datetime" {
			if param.InputData[ciAttr.Name] == "" || param.InputData[ciAttr.Name] == "0000-00-00 00:00:00" {
				param.InputData[ciAttr.Name] = "reset_null^"
			}
		}
		buildValueParam.InputData = param.InputData
		tmpColumn, multiRefActions, tmpErr := buildAttrValue(&buildValueParam)
		if tmpErr != nil {
			err = fmt.Errorf("KeyName:%s column:%s %s \n", param.InputData["key_name"], ciAttr.Name, tmpErr.Error())
			break
		}
		if ciAttr.InputType == models.MultiRefType {
			result = append(result, multiRefActions...)
			multiRefColumnList = append(multiRefColumnList, ciAttr.Name)
			continue
		}
		if !buildValueParam.IsSystem {
			param.InputData[ciAttr.Name] = tmpColumn.ValueString
		}
		columnList = append(columnList, tmpColumn)
		if param.InputData[ciAttr.Name] != param.NowData[ciAttr.Name] {
			param.UpdateColumn = append(param.UpdateColumn, ciAttr.Name)
		}
	}
	for _, multiRefColumn := range multiRefColumnList {
		delete(param.InputData, multiRefColumn)
	}
	if (!rollbackFlag && param.BareAction == "") || param.InputData["confirm_time"] == "" || param.InputData["confirm_time"] == "0000-00-00 00:00:00" {
		columnList = append(columnList, &models.CiDataColumnObj{ColumnName: "confirm_time", ColumnValue: "reset_null^"})
		param.InputData["confirm_time"] = "reset_null^"
	} else if param.InputData["confirm_time"] != "" {
		columnList = append(columnList, &models.CiDataColumnObj{ColumnName: "confirm_time", ColumnValue: param.InputData["confirm_time"]})
	}
	if err == nil {
		result = append(result, getUpdateActionByColumnList(columnList, param.CiType, param.InputData["guid"]))
		result = append(result, getHistoryActionByData(param.InputData, param.CiType, param.NowTime, param.Transition))
	}
	if !rollbackFlag && param.BareAction == "" {
		param.InputData["confirm_time"] = ""
	}
	return
}

func confirmActionFunc(param *models.ActionFuncParam) (result []*execAction, err error) {
	if err = validateRightStateTrans(param); err != nil {
		return
	}
	if len(param.ReferenceAttributes) > 0 {
		if err = validateLeftStateTrans(param); err != nil {
			return
		}
	}
	var columnList []*models.CiDataColumnObj
	var multiRefColumnList []string
	oldConfirmTime := param.NowData["confirm_time"]
	for _, ciAttr := range param.Attributes {
		if ciAttr.Name == "state" {
			param.NowData["state"] = param.Transition.TargetStateName
			columnList = append(columnList, &models.CiDataColumnObj{ColumnName: "state", ColumnValue: param.Transition.TargetStateName})
			continue
		}
		if ciAttr.Name == "update_time" {
			if oldConfirmTime == "" {
				param.NowData["update_time"] = param.NowTime
				columnList = append(columnList, &models.CiDataColumnObj{ColumnName: "update_time", ColumnValue: param.NowTime})
			}
			continue
		}
		if ciAttr.Name == "confirm_time" {
			param.NowData["confirm_time"] = param.NowTime
			columnList = append(columnList, &models.CiDataColumnObj{ColumnName: "confirm_time", ColumnValue: param.NowTime})
			continue
		}
		if ciAttr.DataType == "datetime" && param.NowData[ciAttr.Name] == "" {
			param.NowData[ciAttr.Name] = "reset_null^"
		}
		if ciAttr.RefCiType != "" {
			if ciAttr.InputType == models.MultiRefType {
				multiRefActions, tmpErr := buildMultiRefActions(&models.BuildAttrValueParam{NowTime: param.NowTime, AttributeConfig: ciAttr, IsSystem: false, Action: param.Transition.Action, InputData: param.NowData})
				if tmpErr != nil {
					err = tmpErr
					break
				}
				result = append(result, multiRefActions...)
				multiRefColumnList = append(multiRefColumnList, ciAttr.Name)
				//delete(param.NowData, ciAttr.Name)
			}
		}
	}
	for _, multiRefColumn := range multiRefColumnList {
		delete(param.NowData, multiRefColumn)
	}
	param.NowData = cleanInputData(param.NowData, param.Attributes)
	if err == nil {
		result = append(result, getUpdateActionByColumnList(columnList, param.CiType, param.InputData["guid"]))
		result = append(result, getHistoryActionByData(param.NowData, param.CiType, param.NowTime, param.Transition))
	}
	return
}

func deleteActionFunc(param *models.ActionFuncParam) (result []*execAction, err error) {
	toNull := false
	if strings.HasSuffix(param.Transition.TargetState, "null_0") || strings.HasSuffix(param.Transition.TargetState, "null_1") {
		toNull = true
	}
	if len(param.ReferenceAttributes) > 0 && param.BareAction == "" && !toNull {
		if err = validateLeftStateTrans(param); err != nil {
			return
		}
	}
	for _, ciAttr := range param.Attributes {
		if ciAttr.DataType == "datetime" && param.NowData[ciAttr.Name] == "" {
			delete(param.NowData, ciAttr.Name)
			continue
		}
		if ciAttr.InputType == models.MultiRefType {
			multiRefActions, tmpErr := buildMultiRefActions(&models.BuildAttrValueParam{NowTime: param.NowTime, AttributeConfig: ciAttr, IsSystem: false, Action: param.Transition.Action, InputData: param.NowData})
			if tmpErr != nil {
				err = tmpErr
				break
			}
			result = append(result, multiRefActions...)
			delete(param.NowData, ciAttr.Name)
		}
	}
	param.NowData = cleanInputData(param.NowData, param.Attributes)
	result = append(result, &execAction{Sql: fmt.Sprintf("DELETE FROM %s WHERE guid=?", param.CiType), Param: []interface{}{param.InputData["guid"]}})
	param.NowData["state"] = param.Transition.TargetStateName
	result = append(result, getHistoryActionByData(param.NowData, param.CiType, param.NowTime, param.Transition))
	return
}

func executeActionFunc(param *models.ActionFuncParam) (result []*execAction, err error) {
	var columnList []*models.CiDataColumnObj
	var multiRefColumnList []string
	for _, ciAttr := range param.Attributes {
		if ciAttr.Name == "state" {
			param.NowData["state"] = param.Transition.TargetStateName
			columnList = append(columnList, &models.CiDataColumnObj{ColumnName: "state", ColumnValue: param.Transition.TargetStateName})
			continue
		}
		if ciAttr.RefCiType != "" {
			if ciAttr.InputType == models.MultiRefType {
				multiRefActions, tmpErr := buildMultiRefActions(&models.BuildAttrValueParam{NowTime: param.NowTime, AttributeConfig: ciAttr, IsSystem: false, Action: param.Transition.Action, InputData: param.NowData})
				if tmpErr != nil {
					err = tmpErr
					break
				}
				result = append(result, multiRefActions...)
				multiRefColumnList = append(multiRefColumnList, ciAttr.Name)
				//delete(param.NowData, ciAttr.Name)
			}
		}
	}
	for _, multiRefColumn := range multiRefColumnList {
		delete(param.NowData, multiRefColumn)
	}
	param.NowData = cleanInputData(param.NowData, param.Attributes)
	result = append(result, getUpdateActionByColumnList(columnList, param.CiType, param.InputData["guid"]))
	result = append(result, getHistoryActionByData(param.NowData, param.CiType, param.NowTime, param.Transition))
	err = StartCiDataCallback(models.CiDataCallbackParam{RowGuid: param.InputData["guid"], ProcessName: param.InputData["procDefName"], ProcessKey: param.InputData["procDefKey"], CiType: param.CiType, UserToken: param.InputData["Authorization"]})
	return
}

func autofillAffectActionFunc(ciTypeId, guid, nowTime string) {
	// get attribute
	var attrTable []*models.SysCiTypeAttrTable
	err := x.SQL("select * from sys_ci_type_attr where ci_type=?", ciTypeId).Find(&attrTable)
	if err != nil {
		log.Logger.Error("Try to auto refresh autofill,get attributes data fail", log.String("ciTypeId", ciTypeId), log.Error(err))
		return
	}
	if len(attrTable) == 0 {
		log.Logger.Warn("Try to auto refresh autofill data break,no attribute is autofill", log.String("ciTypeId", ciTypeId))
		return
	}
	// get now data
	//nowDataList, err := x.QueryString(fmt.Sprintf("select * from %s%s where guid='%s' order by id desc limit 1", HistoryTablePrefix, ciTypeId, guid))
	nowDataList, err := x.QueryString(fmt.Sprintf("select * from %s where guid='%s'", ciTypeId, guid))
	if err != nil {
		log.Logger.Error("Try to auto refresh autofill,get ci data fail", log.String("guid", guid), log.Error(err))
		return
	}
	if len(nowDataList) == 0 {
		log.Logger.Warn("Try to auto refresh autofill data break,can not find any data", log.String("guid", guid))
		return
	}
	// buildAutofillValue
	nowData := nowDataList[0]
	log.Logger.Info("autofill now data", log.JsonObj("nowData", nowData))
	var updateColumnList []*models.CiDataColumnObj
	var multiRefColumn, updateColumn []string
	for _, attr := range attrTable {
		if attr.InputType == models.MultiRefType {
			multiRefData, tmpErr := queryMultiRefMapData(ciTypeId, attr.Name, []string{guid})
			//multiRefData, tmpErr := x.QueryString(fmt.Sprintf("select GROUP_CONCAT(to_guid) as to_guid from %s$%s where from_guid=? group by from_guid", ciTypeId, attr.Name), guid)
			if tmpErr != nil {
				log.Logger.Error("Try to auto refresh autofill data error when get multi ref data", log.Error(tmpErr))
				continue
			}
			if len(multiRefData) > 0 {
				//nowData[attr.Name] = multiRefData[0]["to_guid"]
				if tmpMultiRefList, b := multiRefData[guid]; b {
					nowData[attr.Name] = strings.Join(tmpMultiRefList, ",")
				} else {
					nowData[attr.Name] = ""
				}
				multiRefColumn = append(multiRefColumn, attr.Name)
			}
		}
	}
	for _, attr := range attrTable {
		if attr.DataType == "datetime" && nowData[attr.Name] == "" {
			delete(nowData, attr.Name)
		}
		if attr.AutofillAble == "no" || attr.AutofillType == "suggest" {
			continue
		}
		autofillValueList, tmpErr := buildAutofillValue(nowData, attr.AutofillRule, attr.InputType)
		if tmpErr != nil {
			log.Logger.Error("Try to auto refresh autofill data fail,build value error", log.String("guid", guid), log.String("attr", attr.Name), log.Error(err))
			continue
		}
		afterAutoBuildData := getAutofillValueString(autofillValueList)
		if afterAutoBuildData != nowData[attr.Name] {
			updateColumn = append(updateColumn, attr.Name)
			nowData[attr.Name] = getAutofillValueString(autofillValueList)
			updateColumnList = append(updateColumnList, &models.CiDataColumnObj{ColumnName: attr.Name, ColumnValue: nowData[attr.Name]})
		}
	}
	if len(updateColumnList) == 0 {
		log.Logger.Warn("Try to auto refresh autofill data break,no column in update list", log.String("guid", guid))
		return
	}
	updateColumnList = append(updateColumnList, &models.CiDataColumnObj{ColumnName: "update_time", ColumnValue: nowTime})
	// update now && insert history
	var actions []*execAction
	actions = append(actions, getUpdateActionByColumnList(updateColumnList, ciTypeId, guid))
	isConfirm := "no"
	if nowData["history_state_confirmed"] == "1" {
		isConfirm = "yes"
	}
	for _, col := range multiRefColumn {
		delete(nowData, col)
	}
	nowData["update_time"] = nowTime
	actions = append(actions, getHistoryActionByData(nowData, ciTypeId, nowTime, &models.SysStateTransitionQuery{Action: "autofill", TargetIsConfirm: isConfirm}))
	err = transaction(actions)
	if err != nil {
		log.Logger.Error("Try to auto refresh autofill data,update database fail", log.Error(err))
	} else {
		log.Logger.Info("Refresh autofill data success", log.String("guid", guid))
		var autofillChainMap = make(map[string][]*models.AutofillChainObj)
		autofillChainMap[ciTypeId] = []*models.AutofillChainObj{&models.AutofillChainObj{Guid: guid, UpdateColumn: updateColumn}}
		affectGuidListChan <- autofillChainMap
	}
}

func buildAttrValue(param *models.BuildAttrValueParam) (result *models.CiDataColumnObj, multiRefAction []*execAction, err error) {
	if param.IsSystem {
		result = &models.CiDataColumnObj{ColumnName: param.AttributeConfig.Name, ColumnValue: param.InputData[param.AttributeConfig.Name]}
		return
	}
	inputValue := param.InputData[param.AttributeConfig.Name]
	// if autofill
	if param.AttributeConfig.AutofillAble == "yes" {
		suggestActive := false
		if param.InputData[param.AttributeConfig.Name] == models.AutofillSuggest {
			suggestActive = true
		}
		if param.AttributeConfig.AutofillType == "forced" || suggestActive {
			inputStringData := make(map[string]string)
			for k, v := range param.InputData {
				inputStringData[k] = v
			}
			autofillValueList, tmpErr := buildAutofillValue(inputStringData, param.AttributeConfig.AutofillRule, param.AttributeConfig.InputType)
			if tmpErr != nil {
				err = tmpErr
				return
			}
			inputValue = getAutofillValueString(autofillValueList)
		}
		// check unique
		if param.AttributeConfig.UniqueConstraint == "yes" {
			err = validateAutofillUniqueColumn(param.AttributeConfig.CiType, param.AttributeConfig.Name, inputValue, param.InputData["guid"], param.InputData["key_name"])
			if err != nil {
				return
			}
		}
	}
	// if enable empty
	if param.AttributeConfig.Nullable == "no" && inputValue == "" && param.AttributeConfig.DataType != "datetime" {
		err = fmt.Errorf("Attribute:%s can not empty ", param.AttributeConfig.Name)
		return
	}
	// regex validate
	needValidateText := false
	if param.AttributeConfig.TextValidate != "" {
		needValidateText = true
	}
	if param.AttributeConfig.Nullable == "yes" && inputValue == "" {
		if param.AttributeConfig.DataType == "int" {
			inputValue = "0"
		}
		needValidateText = false
	}
	if needValidateText {
		textReg, tmpErr := pcre.Compile(param.AttributeConfig.TextValidate, 0)
		if tmpErr != nil {
			err = fmt.Errorf("Try to validate column:%s fail,init regexp rule error:%s ", param.AttributeConfig.Name, tmpErr.Message)
			return
		}
		tmpMultiValueList := []string{inputValue}
		if strings.HasPrefix(param.AttributeConfig.InputType, "multi") {
			tmpMultiValueList = getMultiStringInputTypeValue(param.AttributeConfig.InputType, inputValue)
		}
		for _, v := range tmpMultiValueList {
			if !textReg.MatcherString(v, 0).Matches() {
				err = fmt.Errorf("Attribute:%s validate text:%s fail ", param.AttributeConfig.Name, v)
				break
			}
		}
		if err != nil {
			return
		}
	}
	// build multi ref data
	if param.AttributeConfig.InputType == models.MultiRefType {
		multiRefAction, err = buildMultiRefActions(param)
		return
	}
	// add to column list
	if param.AttributeConfig.DataType == "int" {
		valueInt, tmpErr := strconv.Atoi(inputValue)
		if tmpErr != nil {
			err = fmt.Errorf("Attribute:%s value %s can not frase to int ", param.AttributeConfig.Name, inputValue)
			return
		}
		result = &models.CiDataColumnObj{ColumnName: param.AttributeConfig.Name, ColumnValue: valueInt, ValueString: inputValue}
	} else if param.AttributeConfig.DataType == "datetime" {
		if inputValue == "" {
			inputValue = "reset_null^"
		}
		result = &models.CiDataColumnObj{ColumnName: param.AttributeConfig.Name, ColumnValue: inputValue, ValueString: inputValue}
	} else {
		result = &models.CiDataColumnObj{ColumnName: param.AttributeConfig.Name, ColumnValue: inputValue, ValueString: inputValue}
	}
	return
}

func getCiRowDataByGuid(ciTypeId string, rowGuidList []string, filters []*models.AutofillFilterObj, inputType string, startRowData map[string]string) (rowMapList []map[string]string, err error) {
	var filterSqlList []string
	for _, f := range filters {
		f.CiType = ciTypeId
		tmpSql, tmpErr := getFilterSql(f, "", inputType, startRowData)
		if tmpErr != nil {
			err = fmt.Errorf("Get filter:%s sql error:%s ", f, tmpErr.Error())
			break
		}
		filterSqlList = append(filterSqlList, tmpSql)
	}
	sql := fmt.Sprintf("SELECT * FROM %s WHERE guid in ('%s') ", ciTypeId, strings.Join(rowGuidList, "','"))
	if len(filterSqlList) > 0 {
		sql += " AND " + strings.Join(filterSqlList, " AND ")
	}
	rowMapList, err = x.QueryString(sql)
	if err != nil {
		log.Logger.Error("Get ci row data by guid list error", log.Error(err))
	}
	return
}

func getMultiRefRowData(ciTypeId, attrName, refCiTypeId string, rowGuidList []string, filters []*models.AutofillFilterObj, inputType string, startRowData map[string]string) (rowMapList []map[string]string, err error) {
	var filterSqlList []string
	for _, f := range filters {
		f.CiType = ciTypeId
		tmpSql, tmpErr := getFilterSql(f, "t2", inputType, startRowData)
		if tmpErr != nil {
			err = fmt.Errorf("Get filter:%s sql error:%s ", f, tmpErr.Error())
			break
		}
		filterSqlList = append(filterSqlList, tmpSql)
	}
	sql := fmt.Sprintf("select distinct t2.* from %s$%s t1 left join %s t2 on t1.to_guid=t2.guid where t1.from_guid in ('%s') ", ciTypeId, attrName, refCiTypeId, strings.Join(rowGuidList, "','"))
	if len(filterSqlList) > 0 {
		sql += " AND " + strings.Join(filterSqlList, " AND ")
	}
	rowMapList, err = x.QueryString(sql)
	if err != nil {
		log.Logger.Error("Get ci row data by guid list error", log.Error(err))
	}
	return
}

func queryMultiRefMapData(ciType, attr string, guidList []string) (resultMap map[string][]string, err error) {
	resultMap = make(map[string][]string)
	tmpMultiQueryData, tmpErr := x.QueryString(fmt.Sprintf("select from_guid,to_guid from %s$%s where from_guid in ('%s') order by from_guid", ciType, attr, strings.Join(guidList, "','")))
	if tmpErr != nil {
		return resultMap, fmt.Errorf("query Multi ref map data fail,%s ", tmpErr.Error())
	}
	for _, v := range tmpMultiQueryData {
		if vv, b := resultMap[v["from_guid"]]; b {
			resultMap[v["from_guid"]] = append(vv, v["to_guid"])
		} else {
			resultMap[v["from_guid"]] = []string{v["to_guid"]}
		}
	}
	return
}

func getMultiNowData(multiCiData []*models.MultiCiDataObj) error {
	var err error
	for _, ciDataObj := range multiCiData {
		inputGuidList := []string{}
		for _, inputRow := range ciDataObj.InputData {
			inputGuidList = append(inputGuidList, inputRow["guid"])
		}
		joinSql := ""
		columnSql := "*"
		//for i, attr := range ciDataObj.Attributes {
		//	if attr.InputType == models.MultiRefType {
		//		tmpMultiQueryData,tmpErr := x.QueryString(fmt.Sprintf("select from_guid,to_guid from %s$%s where from_guid in ('%s') order by from_guid", ciDataObj.CiTypeId, attr.Name, strings.Join(inputGuidList, "','")))
		//
		//		joinSql += fmt.Sprintf(" left join (select from_guid,GROUP_CONCAT(to_guid) to_guid from %s$%s where from_guid in ('%s') group by from_guid) t%d on t%d.from_guid=tt.guid ",
		//			ciDataObj.CiTypeId, attr.Name, strings.Join(inputGuidList, "','"), i, i)
		//		columnSql += fmt.Sprintf(",t%d.to_guid as %s", i, attr.Name)
		//	}
		//}
		queryRowData, tmpErr := x.QueryString(fmt.Sprintf("SELECT %s FROM %s tt %s where tt.guid in ('%s')", columnSql, ciDataObj.CiTypeId, joinSql, strings.Join(inputGuidList, "','")))
		if tmpErr != nil {
			err = fmt.Errorf("Try to get exist ci:%s Data fail,%s ", ciDataObj.CiTypeId, tmpErr.Error())
			break
		}
		for _, attr := range ciDataObj.Attributes {
			if attr.InputType == models.MultiRefType {
				tmpMultiMap, tmpErr := queryMultiRefMapData(ciDataObj.CiTypeId, attr.Name, inputGuidList)
				if tmpErr != nil {
					err = tmpErr
					break
				}
				for _, baseData := range queryRowData {
					if tmpMultiDataList, b := tmpMultiMap[baseData["guid"]]; b {
						baseData[attr.Name] = strings.Join(tmpMultiDataList, ",")
					}
				}
			}
		}
		if err != nil {
			break
		}
		for _, inputRow := range ciDataObj.InputData {
			findFlag := false
			for _, queryRow := range queryRowData {
				if queryRow["guid"] == inputRow["guid"] {
					findFlag = true
					ciDataObj.NowData = append(ciDataObj.NowData, queryRow)
					break
				}
			}
			if !findFlag {
				err = fmt.Errorf("Ci data:%s can not find in database ", inputRow["guid"])
				break
			}
		}
	}
	return err
}

func validateMultiRefFilterData(multiCiData []*models.MultiCiDataObj) error {
	var err error
	for _, ciDataObj := range multiCiData {
		for _, inputRow := range ciDataObj.InputData {
			for _, attr := range ciDataObj.Attributes {
				if inputRow[attr.Name] == "" || inputRow[attr.Name] == "[]" {
					continue
				}
				if attr.RefCiType != "" {
					tmpInputRow := make(map[string]string)
					for k, v := range inputRow {
						tmpInputRow[k] = v
					}
					_, fetchRows, tmpErr := GetCiDataByFilters(attr.Id, tmpInputRow, models.QueryRequestParam{Paging: false})
					if tmpErr != nil {
						err = tmpErr
						break
					}
					if len(fetchRows) == 0 {
						err = fmt.Errorf("Row:%s column:%s value illegal with refFilter rule ", inputRow["key_name"], attr.Name)
						break
					}
					fetchGuidMap := make(map[string]bool)
					for _, fetRowObj := range fetchRows {
						fetchGuidMap[fetRowObj["guid"].(string)] = true
					}
					inputRowValueList := []string{}
					if strings.Contains(inputRow[attr.Name], "[") {
						tmpErr = json.Unmarshal([]byte(inputRow[attr.Name]), &inputRowValueList)
						if tmpErr != nil {
							err = fmt.Errorf("Validate multiRef data fail,json unmarshal input data to []string fail,%s ", tmpErr.Error())
							break
						}
					} else {
						inputRowValueList = strings.Split(inputRow[attr.Name], ",")
					}
					for _, tmpValueObj := range inputRowValueList {
						if _, b := fetchGuidMap[tmpValueObj]; !b {
							err = fmt.Errorf("Row:%s column:%s value illegal with refFilter rule ", inputRow["key_name"], attr.Name)
							break
						}
					}
					if err != nil {
						break
					}
				}
			}
			if err != nil {
				break
			}
		}
		if err != nil {
			break
		}
	}
	return err
}

func getActionByOperation(ciTypeId, operation string) (result []string, err error) {
	var stateTransTable []*models.SysStateTransitionTable
	err = x.SQL("select action from sys_state_transition where state_machine in (select state_machine from sys_ci_type where id=?) and (operation=? or operation_en=?)", ciTypeId, operation, operation).Find(&stateTransTable)
	if err != nil {
		err = fmt.Errorf("Try to get ci:%s action by operation:%s fail,%s ", ciTypeId, operation, err.Error())
		return
	}
	if len(stateTransTable) == 0 {
		err = fmt.Errorf("Can not find action by ci:%s operation:%s ", ciTypeId, operation)
		return
	}
	for _, v := range stateTransTable {
		result = append(result, v.Action)
	}
	return
}

func getMultiCiTransition(multiCiData []*models.MultiCiDataObj) error {
	var ciTypeList []string
	var transList []*models.SysStateTransitionQuery
	for _, ciDataObj := range multiCiData {
		ciTypeList = append(ciTypeList, ciDataObj.CiTypeId)
	}
	querySql := `select t1.id as 'ci_type',t3.*,t4.name as 'target_state_name',t4.is_confirm as 'target_is_confirm',t4.unique_path_trigger as 'target_unique_path',t2.start_state,t2.final_state from sys_ci_type t1 
		left join sys_state_machine t2 on t1.state_machine=t2.id 
		right join sys_state_transition t3 on t3.state_machine=t2.id 
		left join sys_state t4 on t3.target_state=t4.id ` + fmt.Sprintf("where t1.id in ('%s') order by t1.id", strings.Join(ciTypeList, "','"))
	err := x.SQL(querySql).Find(&transList)
	if err != nil {
		err = fmt.Errorf("Try to get state transition list error,%s ", err.Error())
		return err
	}
	if len(transList) == 0 {
		err = fmt.Errorf("Can not find any state transition with ci:%s,please check state_machine ", ciTypeList)
		return err
	}
	var ciTransMap = make(map[string][]*models.SysStateTransitionQuery)
	tmpCiType := transList[0].CiType
	tmpTransList := []*models.SysStateTransitionQuery{}
	for _, trans := range transList {
		trans.CurrentStateName = trans.CurrentState[len(trans.StateMachine)+2:]
		trans.Operation = trans.OperationEn
		if trans.CiType != tmpCiType {
			ciTransMap[tmpCiType] = tmpTransList
			tmpCiType = trans.CiType
			tmpTransList = []*models.SysStateTransitionQuery{}
		}
		tmpTransList = append(tmpTransList, trans)
	}
	if len(tmpTransList) > 0 {
		ciTransMap[tmpCiType] = tmpTransList
	}
	for _, ciDataObj := range multiCiData {
		ciDataObj.Transition = ciTransMap[ciDataObj.CiTypeId]
	}
	return nil
}

func getMultiCiStartTransition(multiCiData []*models.MultiCiDataObj) error {
	var err error
	querySql := `select t1.*,t2.name as 'target_state_name' from sys_state_transition t1 left join sys_state t2 on t1.target_state=t2.id where t1.current_state in (
		select id from sys_state where id in (select start_state from sys_state_machine where id in (
		select state_machine from sys_ci_type where id=?)))`
	for _, ciDataObj := range multiCiData {
		stateTransTable := []*models.SysStateTransitionQuery{}
		err = x.SQL(querySql, ciDataObj.CiTypeId).Find(&stateTransTable)
		if err != nil {
			err = fmt.Errorf("Try to get state transition list error,%s ", err.Error())
			break
		}
		if len(stateTransTable) == 0 {
			err = fmt.Errorf("Can not get start state with ci:%s ", ciDataObj.CiTypeId)
			break
		}
		ciDataObj.Transition = stateTransTable
	}
	return err
}

func getMultiCiAttributes(multiCiData []*models.MultiCiDataObj) error {
	var ciTypeList []string
	var attrTable []*models.SysCiTypeAttrTable
	for _, ciDataObj := range multiCiData {
		ciTypeList = append(ciTypeList, ciDataObj.CiTypeId)
	}
	err := x.SQL(fmt.Sprintf("select * from sys_ci_type_attr where ci_type in ('%s') and status='created' order by ci_type", strings.Join(ciTypeList, "','"))).Find(&attrTable)
	if err != nil {
		err = fmt.Errorf("Try to get ci attributes error,%s ", err.Error())
		return err
	}
	if len(attrTable) == 0 {
		err = fmt.Errorf("Can not find any attributes with ci:%s,please check ci config ", ciTypeList)
		return err
	}
	var ciAttrMap = make(map[string][]*models.SysCiTypeAttrTable)
	var refCiTypeIdList []string
	tmpCiType := attrTable[0].CiType
	tmpAttrList := []*models.SysCiTypeAttrTable{}
	for _, attr := range attrTable {
		if attr.RefCiType != "" {
			refCiTypeIdList = append(refCiTypeIdList, attr.CiType)
		}
		if attr.CiType != tmpCiType {
			ciAttrMap[tmpCiType] = tmpAttrList
			tmpCiType = attr.CiType
			tmpAttrList = []*models.SysCiTypeAttrTable{}
		}
		tmpAttrList = append(tmpAttrList, attr)
	}
	if len(tmpAttrList) > 0 {
		ciAttrMap[tmpCiType] = tmpAttrList
	}
	for _, ciDataObj := range multiCiData {
		newAttrs, tmpErr := rebuildAttrOrderByAutofill(ciDataObj.CiTypeId, ciAttrMap[ciDataObj.CiTypeId])
		if tmpErr != nil {
			err = tmpErr
			break
		}
		ciDataObj.Attributes = newAttrs
	}
	if err != nil {
		return err
	}
	if len(refCiTypeIdList) > 0 {
		var refCiTypeTable []*models.SysCiTypeTable
		err = x.SQL(fmt.Sprintf("select id,status,state_machine from sys_ci_type where id in ('%s')", strings.Join(refCiTypeIdList, "','"))).Find(&refCiTypeTable)
		if err != nil {
			err = fmt.Errorf("Try to get reference ci state_machine fail,%s ", err.Error())
			return err
		}
		refCiTypeMap := make(map[string]*models.SysCiTypeTable)
		for _, refCiType := range refCiTypeTable {
			refCiTypeMap[refCiType.Id] = refCiType
		}
		for _, ciDataObj := range multiCiData {
			ciDataObj.RefCiTypeMap = refCiTypeMap
		}
	}
	return nil
}

func buildRequestBodyWithoutPwd(multiCiData []*models.MultiCiDataObj, baseAction, nowTime, operation string) (output []models.CiDataMapObj, newInputBody string) {
	inputStringList := []string{}
	operation = strings.ToLower(operation)
	for _, ciDataObj := range multiCiData {
		tmpPwdKeyMap := make(map[string]int)
		for _, attr := range ciDataObj.Attributes {
			if attr.InputType == "password" {
				tmpPwdKeyMap[attr.Name] = 1
			}
		}
		for _, rowData := range ciDataObj.InputData {
			tmpNewRowData := make(map[string]string)
			outputRowData := make(map[string]string)
			for k, v := range rowData {
				if _, b := tmpPwdKeyMap[k]; b {
					tmpNewRowData[k] = "******"
					if baseAction != "" {
						outputRowData[k] = "******^" + v
					} else {
						outputRowData[k] = "******"
					}
				} else {
					tmpNewRowData[k] = v
					outputRowData[k] = v
				}
			}
			if operation == "confirm" {
				outputRowData["confirm_time"] = nowTime
			} else {
				outputRowData["update_time"] = nowTime
			}
			output = append(output, outputRowData)
			tmpInputByte, _ := json.Marshal(tmpNewRowData)
			inputStringList = append(inputStringList, string(tmpInputByte))
		}
	}
	newInputBody = fmt.Sprintf("[%s]", strings.Join(inputStringList, ","))
	return
}

func fetchNewRowData(multiCiData []*models.MultiCiDataObj) (output []models.CiDataMapObj, err error) {
	output = []models.CiDataMapObj{}
	for _, ciDataObj := range multiCiData {
		inputGuidList := []string{}
		for _, inputRow := range ciDataObj.InputData {
			inputGuidList = append(inputGuidList, inputRow["guid"])
		}
		joinSql := ""
		columnSql := "*"
		//for i, attr := range ciDataObj.Attributes {
		//	if attr.InputType == models.MultiRefType {
		//		joinSql += fmt.Sprintf(" left join (select from_guid,GROUP_CONCAT(to_guid) to_guid from %s$%s where from_guid in ('%s') group by from_guid) t%d on t%d.from_guid=tt.guid ",
		//			ciDataObj.CiTypeId, attr.Name, strings.Join(inputGuidList, "','"), i, i)
		//		columnSql += fmt.Sprintf(",t%d.to_guid as %s", i, attr.Name)
		//	}
		//}
		queryRowData, tmpErr := x.QueryString(fmt.Sprintf("SELECT %s FROM %s tt %s where tt.guid in ('%s')", columnSql, ciDataObj.CiTypeId, joinSql, strings.Join(inputGuidList, "','")))
		if tmpErr != nil {
			err = fmt.Errorf("Try to get exist ci:%s Data fail,%s ", ciDataObj.CiTypeId, tmpErr.Error())
			break
		}
		for _, attr := range ciDataObj.Attributes {
			if attr.InputType == models.MultiRefType {
				tmpMultiMap, tmpErr := queryMultiRefMapData(ciDataObj.CiTypeId, attr.Name, inputGuidList)
				if tmpErr != nil {
					err = tmpErr
					break
				}
				for _, baseData := range queryRowData {
					if tmpMultiDataList, b := tmpMultiMap[baseData["guid"]]; b {
						baseData[attr.Name] = strings.Join(tmpMultiDataList, ",")
					}
				}
			}
		}
		tmpPwdKeyMap := make(map[string]int)
		for _, attr := range ciDataObj.Attributes {
			if attr.InputType == "password" {
				tmpPwdKeyMap[attr.Name] = 1
			}
		}
		for _, rowData := range queryRowData {
			for k, _ := range rowData {
				if _, b := tmpPwdKeyMap[k]; b {
					rowData[k] = "******"
				}
			}
			output = append(output, rowData)
		}
	}
	return
}

func validateUniqueColumn(multiCiData []*models.MultiCiDataObj) error {
	var err error
	for _, ciDataObj := range multiCiData {
		uniqueColumnList := []string{}
		for _, attr := range ciDataObj.Attributes {
			if attr.Name == "guid" {
				continue
			}
			if attr.AutofillAble == "yes" {
				continue
			}
			if attr.UniqueConstraint == "yes" {
				uniqueColumnList = append(uniqueColumnList, attr.Name)
			}
		}
		if len(uniqueColumnList) == 0 {
			continue
		}
		var filterSqlList, filterColumnSqlList []string
		for _, uc := range uniqueColumnList {
			tmpInputDataColumn := []string{}
			for _, inputRow := range ciDataObj.InputData {
				if inputRow[uc] != "" {
					tmpInputDataColumn = append(tmpInputDataColumn, inputRow[uc])
				}
			}
			if len(tmpInputDataColumn) > 0 {
				filterSqlList = append(filterSqlList, fmt.Sprintf(" %s in ('%s') ", uc, strings.Join(tmpInputDataColumn, "','")))
				filterColumnSqlList = append(filterColumnSqlList, fmt.Sprintf("'%s' as unique_c", uc))
			}
		}
		if len(filterSqlList) == 0 {
			continue
		}
		querySqlList := []string{}
		for i, filterSql := range filterSqlList {
			querySqlList = append(querySqlList, fmt.Sprintf("select *,%s from %s where %s ", filterColumnSqlList[i], ciDataObj.CiTypeId, filterSql))
		}
		queryRows, tmpErr := x.QueryString(strings.Join(querySqlList, " union "))
		if tmpErr != nil {
			err = fmt.Errorf("Try to validate unique column value fail,%s ", tmpErr.Error())
			break
		}
		if len(queryRows) > 0 {
			//err = fmt.Errorf("") queryRows[0][queryRows[0]["unique_c"]]
			for _, queryRow := range queryRows {
				tmpColumnName := queryRow["unique_c"]
				for _, inputRow := range ciDataObj.InputData {
					if inputRow["guid"] != queryRow["guid"] && inputRow[tmpColumnName] == queryRow[tmpColumnName] {
						err = fmt.Errorf("Unique validate fail,row:%s column:%s is same with row:%s ", inputRow["key_name"], tmpColumnName, queryRow["key_name"])
						break
					}
				}
				if err != nil {
					break
				}
			}
		}
		if err != nil {
			break
		}
	}
	return err
}

func validateAutofillUniqueColumn(ciTypeId, column, value, guid, keyName string) error {
	if value == "" {
		return nil
	}
	queryRows, err := x.QueryString(fmt.Sprintf("select * from %s where %s=?", ciTypeId, column), value)
	if err != nil {
		err = fmt.Errorf("Try to validate unique column fail,%s ", err.Error())
		return err
	}
	if len(queryRows) == 0 {
		return nil
	}
	for _, row := range queryRows {
		if row["guid"] != guid {
			err = fmt.Errorf("Unique validate fail,row:%s column:%s is same with row:%s ", keyName, column, row["key_name"])
			break
		}
	}
	return err
}

func getMultiReferenceAttributes(multiCiData []*models.MultiCiDataObj) error {
	var ciTypeList []string
	var attrTable []*models.SysCiTypeAttrTable
	for _, ciDataObj := range multiCiData {
		ciTypeList = append(ciTypeList, ciDataObj.CiTypeId)
	}
	err := x.SQL(fmt.Sprintf("select * from sys_ci_type_attr where ref_ci_type in ('%s') and status='created' order by ref_ci_type", strings.Join(ciTypeList, "','"))).Find(&attrTable)
	if err != nil {
		err = fmt.Errorf("Try to get reference ci attributes error,%s ", err.Error())
		return err
	}
	if len(attrTable) == 0 {
		return nil
	}
	var ciAttrMap = make(map[string][]*models.SysCiTypeAttrTable)
	var refCiTypeIdList []string
	tmpRefCiType := attrTable[0].RefCiType
	tmpAttrList := []*models.SysCiTypeAttrTable{}
	for _, attr := range attrTable {
		refCiTypeIdList = append(refCiTypeIdList, attr.CiType)
		if attr.RefCiType != tmpRefCiType {
			ciAttrMap[tmpRefCiType] = tmpAttrList
			tmpRefCiType = attr.RefCiType
			tmpAttrList = []*models.SysCiTypeAttrTable{}
		}
		tmpAttrList = append(tmpAttrList, attr)
	}
	if len(tmpAttrList) > 0 {
		ciAttrMap[tmpRefCiType] = tmpAttrList
	}
	for _, ciDataObj := range multiCiData {
		ciDataObj.ReferenceAttributes = ciAttrMap[ciDataObj.CiTypeId]
	}
	if len(refCiTypeIdList) > 0 {
		var refCiTypeTable []*models.SysCiTypeTable
		err = x.SQL(fmt.Sprintf("select id,status,state_machine from sys_ci_type where id in ('%s')", strings.Join(refCiTypeIdList, "','"))).Find(&refCiTypeTable)
		if err != nil {
			err = fmt.Errorf("Try to get reference ci state_machine fail,%s ", err.Error())
			return err
		}
		refCiTypeMap := make(map[string]*models.SysCiTypeTable)
		if len(multiCiData[0].RefCiTypeMap) > 0 {
			refCiTypeMap = multiCiData[0].RefCiTypeMap
		}
		for _, refCiType := range refCiTypeTable {
			refCiTypeMap[refCiType.Id] = refCiType
		}
		for _, ciDataObj := range multiCiData {
			ciDataObj.RefCiTypeMap = refCiTypeMap
		}
	}
	return nil
}

func getInsertActionByColumnList(columnList []*models.CiDataColumnObj, tableName string) *execAction {
	var nameList, specCharList []string
	var params []interface{}
	for _, column := range columnList {
		if column.ColumnValue == "reset_null^" {
			continue
		}
		nameList = append(nameList, column.ColumnName)
		specCharList = append(specCharList, "?")
		params = append(params, column.ColumnValue)
	}
	return &execAction{Sql: fmt.Sprintf("INSERT INTO %s(`%s`) VALUE (%s)", tableName, strings.Join(nameList, "`,`"), strings.Join(specCharList, ",")), Param: params}
}

func getUpdateActionByColumnList(columnList []*models.CiDataColumnObj, tableName, guid string) *execAction {
	var updateColumnList []string
	var params []interface{}
	for _, column := range columnList {
		if column.ColumnValue == "reset_null^" {
			updateColumnList = append(updateColumnList, fmt.Sprintf("`%s`=NULL", column.ColumnName))
		} else {
			updateColumnList = append(updateColumnList, fmt.Sprintf("`%s`=?", column.ColumnName))
			params = append(params, column.ColumnValue)
		}
	}
	params = append(params, guid)
	return &execAction{Sql: fmt.Sprintf("UPDATE %s SET %s WHERE guid=?", tableName, strings.Join(updateColumnList, ",")), Param: params}
}

func getHistoryActionByData(nowData models.CiDataMapObj, ciType, nowTime string, trans *models.SysStateTransitionQuery) *execAction {
	var historyColumnList []*models.CiDataColumnObj
	for columnName, columnValue := range nowData {
		if columnName == "id" || columnName == "history_action" || columnName == "history_time" || columnName == "history_state_confirmed" {
			continue
		}
		historyColumnList = append(historyColumnList, &models.CiDataColumnObj{ColumnName: columnName, ColumnValue: columnValue})
	}
	historyColumnList = append(historyColumnList, &models.CiDataColumnObj{ColumnName: "history_action", ColumnValue: trans.Action})
	isTargetConfirm := 0
	if trans.TargetIsConfirm == "yes" {
		isTargetConfirm = 1
	}
	historyColumnList = append(historyColumnList, &models.CiDataColumnObj{ColumnName: "history_state_confirmed", ColumnValue: isTargetConfirm})
	historyColumnList = append(historyColumnList, &models.CiDataColumnObj{ColumnName: "history_time", ColumnValue: nowTime})
	return getInsertActionByColumnList(historyColumnList, HistoryTablePrefix+ciType)
}

func validateReference(columnValue, targetState, action string, attr *models.SysCiTypeAttrTable) error {
	queryParams := []interface{}{fmt.Sprintf("select guid,state from %s where guid=?", attr.RefCiType), columnValue}
	if strings.Contains(columnValue, ",") {
		specSql, sqlParams := createListParams(strings.Split(columnValue, ","), "")
		queryParams = []interface{}{fmt.Sprintf("select guid,state from %s where guid in (%s)", attr.RefCiType, specSql)}
		queryParams = append(queryParams, sqlParams...)
	}
	fetRowData, err := x.QueryString(queryParams...)
	if err != nil {
		return fmt.Errorf("Try to validate %s reference error,%s ", attr.Name, err.Error())
	}
	if len(fetRowData) == 0 {
		return fmt.Errorf("Validate %s reference fail,can not fetch data in %s with guid:%s ", attr.Name, attr.RefCiType, columnValue)
	}
	validateStateMapString := ""
	if action == "update" {
		validateStateMapString = attr.RefUpdateStateValidate
	} else if action == "confirm" {
		validateStateMapString = attr.RefConfirmStateValidate
	}
	if validateStateMapString != "" {
		stateMapList := []map[string]string{}
		err = json.Unmarshal([]byte(validateStateMapString), &stateMapList)
		if err != nil {
			err = fmt.Errorf("Try to validate %s reference error,json unmarchal validate state map fail,%s ", attr.Name, err.Error())
		} else {
			if len(stateMapList) > 0 {
				legalStateList := []string{}
				for _, tmpStateMap := range stateMapList {
					if refState, b := tmpStateMap[targetState]; b {
						legalStateList = append(legalStateList, refState)
					}
				}
				if len(legalStateList) == 0 {
					err = fmt.Errorf("Validate attr %s reference fail,have no legal %s state map with state:%s ", attr.Name, action, targetState)
					return err
				}
				for _, row := range fetRowData {
					illegalFlag := true
					for _, legalState := range legalStateList {
						if row["state"] == legalState {
							illegalFlag = false
							break
						}
					}
					if illegalFlag {
						err = fmt.Errorf("Validate %s reference fail,row state:%s is illegal when reference row:%s state:%s ", attr.Name, targetState, row["guid"], row["state"])
						break
					}
				}
			}
		}
	}
	return err
}

// 校验其它依赖该目标行的数据状态
func validateLeftStateTrans(param *models.ActionFuncParam) error {
	var err error
	rowGuid := param.InputData["guid"]
	for _, attr := range param.ReferenceAttributes {
		var fetRowData []map[string]string
		if attr.InputType == models.MultiRefType {
			fetRowData, err = x.QueryString(fmt.Sprintf("select guid,state,key_name from %s where guid in (select from_guid from %s$%s where to_guid=?)", attr.CiType, attr.CiType, attr.Name), rowGuid)
		} else {
			fetRowData, err = x.QueryString(fmt.Sprintf("select guid,state,key_name from %s where %s=?", attr.CiType, attr.Name), rowGuid)
		}
		if err != nil {
			err = fmt.Errorf("Try to validate left reference ciType:%s attr:%s error,%s ", attr.CiType, attr.Name, err.Error())
			break
		}
		if len(fetRowData) == 0 {
			continue
		}
		// 如果有被其它行所依赖,则没法删除目标行
		if param.Transition.Action == "delete" {
			isInDeleteListFlag := false
			for _, v := range param.DeleteList {
				if fetRowData[0]["guid"] == v {
					isInDeleteListFlag = true
					break
				}
			}
			if !isInDeleteListFlag {
				err = fmt.Errorf("Row:%s was reference by ciType:%s attr:%s row:%s ", rowGuid, attr.CiType, attr.Name, fetRowData[0]["key_name"])
				break
			}
		}
		configMapString := ""
		if param.Transition.Action == "update" && attr.RefUpdateStateValidate != "" {
			configMapString = attr.RefUpdateStateValidate
		}
		if param.Transition.Action == "confirm" && attr.RefConfirmStateValidate != "" {
			configMapString = attr.RefConfirmStateValidate
		}
		if configMapString == "" {
			continue
		}
		stateMapList := []map[string]string{}
		err = json.Unmarshal([]byte(configMapString), &stateMapList)
		if err != nil {
			err = fmt.Errorf("Validate left reference ciType:%s attr:%s row:%s error,json unmarchal validate state map fail,%s ", attr.CiType, attr.Name, fetRowData[0]["key_name"], err.Error())
			break
		}
		if len(stateMapList) == 0 {
			continue
		}
		// 尝试找到上游关联行row的state:a 是否在 [{a,b},{c,d},{e,b}] 的key中
		keyList := []string{}
		// 尝试找到下游目标状态:b 是否在 [{a,b},{c,d},{e,b}] 的key中
		for _, tmpMap := range stateMapList {
			for k, v := range tmpMap {
				if v == param.Transition.TargetState {
					keyList = append(keyList, k)
				}
			}
		}
		if len(keyList) == 0 {
			continue
		}
		stateMachine := param.RefCiTypeMap[attr.CiType].StateMachine
		for _, row := range fetRowData {
			if !strings.HasPrefix(row["state"], stateMachine) {
				row["state"] = stateMachine + models.SysTableIdConnector + row["state"]
			}
			// 如果没有找到,则不用校验,说明没约束,按上面的应该会找到 [a,e]
			illegalFlag := true
			for _, k := range keyList {
				if row["state"] == k {
					log.Logger.Info("illegal state", log.String("row_state", row["state"]), log.String("k", k))
					illegalFlag = false
					break
				}
			}
			if illegalFlag {
				err = fmt.Errorf("Validate reference dep ciType:%s attr:%s row:%s fail,row state:%s is illegal ", attr.CiType, attr.Name, row["key_name"], param.Transition.TargetState)
				break
			}
		}
		if err != nil {
			break
		}
	}
	return err
}

// 找目标行数据所关联的目标行,检查目标行状态是否在map配置的约束中,这里需要注意,上面的leftState是校验其它依赖该目标行的数据状态
func validateRightStateTrans(param *models.ActionFuncParam) error {
	var err error
	for _, attr := range param.Attributes {
		if attr.RefCiType == "" {
			continue
		}
		configMapString := ""
		if param.Transition.Action == "update" && attr.RefUpdateStateValidate != "" {
			configMapString = attr.RefUpdateStateValidate
		}
		if param.Transition.Action == "confirm" && attr.RefConfirmStateValidate != "" {
			configMapString = attr.RefConfirmStateValidate
		}
		if configMapString == "" {
			continue
		}
		stateMapList := []map[string]string{}
		err = json.Unmarshal([]byte(configMapString), &stateMapList)
		if err != nil {
			err = fmt.Errorf("Validate reference with ciType:%s attr:%s refCiType:%s key_name:%s error,json unmarchal validate state map fail,%s ", attr.CiType, attr.Name, attr.RefCiType, param.NowData["key_name"], err.Error())
			break
		}
		if len(stateMapList) == 0 {
			continue
		}
		columnValue := param.NowData[attr.Name]
		if _, b := param.InputData[attr.Name]; b {
			columnValue = param.InputData[attr.Name]
		}
		if columnValue == "" {
			continue
		}
		var fetRowData []map[string]string
		if attr.InputType == models.MultiRefType {
			fetRowData, err = x.QueryString(fmt.Sprintf("select t2.guid,t2.state,t2.key_name from %s$%s t1 join %s t2 on t1.to_guid=t2.guid where t1.from_guid=?", attr.CiType, attr.Name, attr.RefCiType), param.NowData["guid"])
		} else {
			fetRowData, err = x.QueryString(fmt.Sprintf("select guid,state,key_name from %s where guid=?", attr.RefCiType), columnValue)
		}
		if err != nil {
			err = fmt.Errorf("Try to validate state trans fail,get ci:%s refAttr:%s refCiType:%s data error,%s ", attr.CiType, attr.Name, attr.RefCiType, err.Error())
			break
		}
		if len(fetRowData) == 0 {
			continue
		}
		var keyList, valueList, mapValueList []string
		for _, tmpMap := range stateMapList {
			for k, v := range tmpMap {
				if k == param.Transition.CurrentState {
					keyList = append(keyList, k)
				}
				if k == param.Transition.TargetState {
					valueList = append(valueList, v)
				}
				mapValueList = append(mapValueList, v)
			}
		}
		if len(keyList) == 0 {
			continue
		}
		stateMachine := param.RefCiTypeMap[attr.CiType].StateMachine
		for _, row := range fetRowData {
			if !strings.HasPrefix(row["state"], stateMachine) {
				row["state"] = stateMachine + models.SysTableIdConnector + row["state"]
			}
			// 尝试找到目标行state:a 是否在 [{a,b},{c,d},{e,b}] 的key中
			//for _, tmpMap := range stateMapList {
			//	for k, v := range tmpMap {
			//		if v == row["state"] {
			//			keyList = append(keyList, k)
			//		}
			//	}
			//}
			// 如果没有找到,则不用校验,说明没约束,按上面的应该会找到 [b]
			illegalFlag := false
			if len(valueList) == 0 {
				for _, v := range mapValueList {
					if row["state"] == v {
						illegalFlag = true
					}
				}
			} else {
				for _, v := range valueList {
					if row["state"] != v {
						illegalFlag = true
					}
				}
			}
			if illegalFlag {
				err = fmt.Errorf("Validate reference state map fail,row:%s attr:%s ref_row:%s ref_row_state:%s is illegal with row state:%s ",
					param.NowData["key_name"], attr.Name, row["key_name"], row["state"], param.Transition.TargetState)
				break
			}
		}
	}
	return err
}

func buildMultiRefActions(param *models.BuildAttrValueParam) (actions []*execAction, err error) {
	inputValue := param.InputData[param.AttributeConfig.Name]
	if param.Action == "insert" && inputValue == "" {
		return
	}
	valueList := []string{}
	if strings.Contains(inputValue, "[") {
		err = json.Unmarshal([]byte(inputValue), &valueList)
		if err != nil {
			err = fmt.Errorf("Format multiRef value to []string fail,%s ", err.Error())
			return
		}
	} else {
		valueList = strings.Split(inputValue, ",")
	}
	if len(valueList) == 0 {
		return
	}
	var specList []string
	var toGuidList []interface{}
	rowGuid := param.InputData["guid"]
	tableName := fmt.Sprintf("%s$%s", param.AttributeConfig.CiType, param.AttributeConfig.Name)
	actions = append(actions, &execAction{Sql: fmt.Sprintf("delete from %s where from_guid=?", tableName), Param: []interface{}{rowGuid}})
	if len(valueList) == 0 {
		return
	}
	for i, to := range valueList {
		actions = append(actions, &execAction{Sql: fmt.Sprintf("insert into %s(from_guid,to_guid,seq_no) value (?,?,%d)", tableName, i+1),
			Param: []interface{}{rowGuid, to}})
		toGuidList = append(toGuidList, to)
		specList = append(specList, "?")
	}
	queryHistoryParams := []interface{}{fmt.Sprintf("select id,guid from %s%s where id in (select max(id) from %s%s where guid in (%s) group by guid)",
		HistoryTablePrefix, param.AttributeConfig.RefCiType, HistoryTablePrefix, param.AttributeConfig.RefCiType, strings.Join(specList, ","))}
	queryHistoryParams = append(queryHistoryParams, toGuidList...)
	rowData, err := x.QueryString(queryHistoryParams...)
	if err != nil {
		err = fmt.Errorf("Try to query history table %s%s fail,%s ", HistoryTablePrefix, param.AttributeConfig.RefCiType, err.Error())
		return
	}
	for i, to := range valueList {
		tmpId := 0
		for _, row := range rowData {
			if row["guid"] == to {
				tmpId, _ = strconv.Atoi(row["id"])
				break
			}
		}
		actions = append(actions, &execAction{Sql: fmt.Sprintf("insert into %s%s(from_guid,to_guid,seq_no,history_to_id,history_time) value (?,?,%d,?,?)", HistoryTablePrefix, tableName, i), Param: []interface{}{
			rowGuid, to, tmpId, param.NowTime}})
	}
	return
}

func isAttributeMultiRef(ciTypeId, ciAttrName string) bool {
	rowData, err := x.QueryString("select name,input_type from sys_ci_type_attr where ci_type=? and name=?", ciTypeId, ciAttrName)
	if err != nil {
		log.Logger.Error("Try to check attribute is multiRef fail", log.Error(err))
		return false
	}
	if len(rowData) > 0 {
		if rowData[0]["input_type"] == models.MultiRefType {
			return true
		}
	}
	return false
}

func getAttributeInputType(ciTypeId, ciAttrName, id string) string {
	if id == "" {
		id = ciTypeId + models.SysTableIdConnector + ciAttrName
	}
	rowData, err := x.QueryString("select name,input_type from sys_ci_type_attr where id=?", id)
	if err != nil {
		log.Logger.Error("Try to get attribute inputType fail", log.Error(err))
	}
	if len(rowData) > 0 {
		return rowData[0]["input_type"]
	}
	return ""
}

func rebuildAttrOrderByAutofill(ciTypeId string, attrs []*models.SysCiTypeAttrTable) (newAttrs []*models.SysCiTypeAttrTable, err error) {
	autofillAttrList := models.AttrAutofillSortList{}
	for _, attr := range attrs {
		if attr.AutofillAble == "yes" {
			if strings.Contains(attr.AutofillRule, ciTypeId+"#") {
				tmpAfObj := models.AttrAutofillSortObj{Attr: attr, AttrName: attr.Name, PValue: 1}
				for i, v := range strings.Split(attr.AutofillRule, ciTypeId+"#") {
					if i == 0 {
						continue
					}
					tmpAfObj.Dep = append(tmpAfObj.Dep, strings.ReplaceAll(v[:strings.Index(v, "\"")], "\\", ""))
				}
				autofillAttrList = append(autofillAttrList, &tmpAfObj)
			} else {
				newAttrs = append(newAttrs, attr)
			}
		} else {
			newAttrs = append(newAttrs, attr)
		}
	}
	if len(newAttrs) == len(attrs) {
		return
	}
	for _, af := range autofillAttrList {
		if tmpErr := recursiveAttrAutofill(autofillAttrList, af, af.PValue, []string{}); tmpErr != nil {
			err = fmt.Errorf("Check endless loop with attributes autofill rules,%s ", tmpErr.Error())
			break
		}
	}
	if err != nil {
		return
	}
	sort.Sort(autofillAttrList)
	for _, af := range autofillAttrList {
		newAttrs = append(newAttrs, af.Attr)
	}
	return
}

func recursiveAttrAutofill(afList []*models.AttrAutofillSortObj, af *models.AttrAutofillSortObj, index int, flagList []string) (err error) {
	for _, v := range flagList {
		if v == af.AttrName {
			err = fmt.Errorf("Attr:%s is roll with %s ", v, append(flagList, v))
		}
	}
	if err != nil {
		return
	}
	index = index + 1
	flagList = append(flagList, af.AttrName)
	for _, v := range af.Dep {
		for _, tmpAf := range afList {
			if tmpAf.AttrName == v {
				err = recursiveAttrAutofill(afList, tmpAf, index, flagList)
				break
			}
		}
		if err != nil {
			break
		}
	}
	af.PValue = index
	af.Link = append(af.Link, flagList...)
	return
}

func DataRollbackList(inputGuid string) (rowData []map[string]interface{}, title []*models.CiDataActionQueryTitle, err error) {
	ciTypeId := inputGuid[:strings.LastIndex(inputGuid, "_")]
	title = []*models.CiDataActionQueryTitle{}
	var attrs []*models.SysCiTypeAttrTable
	x.SQL("select name,display_name,input_type from sys_ci_type_attr where display_by_default='yes' and status='created' and ci_type=? order by ui_form_order", ciTypeId).Find(&attrs)
	for _, attr := range attrs {
		title = append(title, &models.CiDataActionQueryTitle{Id: attr.Name, Name: attr.DisplayName, Type: attr.InputType})
	}
	queryParam := models.QueryRequestParam{}
	queryParam.Dialect = &models.QueryRequestDialect{QueryMode: "all"}
	queryParam.Filters = []*models.QueryRequestFilterObj{{Name: "guid", Operator: "eq", Value: inputGuid}}
	queryParam.Paging = false
	queryParam.Sorting = &models.QueryRequestSorting{Asc: true, Field: "history_time"}
	_, rowData, err = CiDataQuery(ciTypeId, &queryParam, &models.CiDataLegalGuidList{Enable: true}, false)
	if err != nil {
		return
	}
	if len(rowData) == 0 {
		//err = fmt.Errorf("Can not find any data with guid:%s ", inputGuid)
		rowData = []map[string]interface{}{}
		return
	}
	if rowData[len(rowData)-1]["history_state_confirmed"].(string) == "1" {
		err = fmt.Errorf("Can not rollback confirm data ")
		return
	}
	if len(rowData) < 2 {
		//err = fmt.Errorf("Can not find any history data with guid:%s ", inputGuid)
		return rowData, title, nil
	}
	var newRowData []map[string]interface{}
	for i := len(rowData) - 2; i >= 0; i-- {
		if rowData[i]["history_state_confirmed"].(string) == "1" {
			newRowData = append(newRowData, rowData[i])
			break
		} else {
			newRowData = append(newRowData, rowData[i])
		}
	}
	return newRowData, title, nil
}

func cleanInputData(inputData models.CiDataMapObj, attrs []*models.SysCiTypeAttrTable) models.CiDataMapObj {
	deleteColumnList := []string{}
	for k, _ := range inputData {
		legalFlag := false
		for _, v := range attrs {
			if k == v.Name {
				legalFlag = true
				break
			}
		}
		if !legalFlag {
			deleteColumnList = append(deleteColumnList, k)
		}
	}
	for _, v := range deleteColumnList {
		delete(inputData, v)
	}
	return inputData
}

func getUniquePathNextOperation(stateId string) (result []*models.SysStateTransitionTable, err error) {
	result = []*models.SysStateTransitionTable{}
	err = x.SQL("select * from sys_state_transition where current_state=?", stateId).Find(&result)
	return
}

func DataPasswordQuery(ciType, guid, field string, id int) (password string, err error) {
	baseSql := fmt.Sprintf("select %s from %s where guid='%s'", field, ciType, guid)
	if id > 0 {
		baseSql = fmt.Sprintf("select %s from %s%s where id=%d", field, HistoryTablePrefix, ciType, id)
	}
	queryData, err := x.QueryString(baseSql)
	if err != nil {
		err = fmt.Errorf("Query database fail,%s ", err.Error())
		return
	}
	if len(queryData) == 0 {
		err = fmt.Errorf("Can not fetch any data ")
		return
	}
	password = queryData[0][field]
	return
}

func getHistoryDataById(ciTypeId, id string) map[string]string {
	var historyObj = make(map[string]string)
	queryRows, err := x.QueryString(fmt.Sprintf("select * from %s%s where id=?", HistoryTablePrefix, ciTypeId), id)
	if err != nil {
		log.Logger.Error("Try to get history guid by id fail", log.Error(err))
	}
	if len(queryRows) > 0 {
		historyObj = queryRows[0]
	}
	return historyObj
}

func getMultiStringInputTypeValue(inputType, value string) []string {
	result := []string{}
	if inputType == "multiText" {
		err := json.Unmarshal([]byte(value), &result)
		if err != nil {
			log.Logger.Error("GetMultiStringInputTypeValue format []string error", log.Error(err))
		}
	} else if inputType == "multiInt" {
		var intList []int
		err := json.Unmarshal([]byte(value), &intList)
		if err != nil {
			log.Logger.Error("GetMultiStringInputTypeValue format []int error", log.Error(err))
		} else {
			for _, v := range intList {
				result = append(result, strconv.Itoa(v))
			}
		}
	}
	return result
}
