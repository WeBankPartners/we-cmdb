package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"strings"
)

func GetRoleCiPermission(query *models.RolePermissionQuery) error {
	var roleMenuTable []*models.SysRoleMenuTable
	err := x.SQL("select menu_guid from sys_role_menu where role_guid=?", query.Role).Find(&roleMenuTable)
	if err != nil {
		return fmt.Errorf("Try to get role menu data fail,%s ", err.Error())
	}
	query.MenuPermissions = []string{}
	for _, menu := range roleMenuTable {
		query.MenuPermissions = append(query.MenuPermissions, menu.MenuGuid)
	}
	var ciTypePermissionTable []*models.CiTypePermissionObj
	err = x.SQL("select t1.*,t2.display_name as 'ci_type_name' from sys_role_ci_type t1 left join sys_ci_type t2 on t1.ci_type=t2.id where t1.role_id=? and t1.ci_type_attr is null", query.Role).Find(&ciTypePermissionTable)
	if err != nil {
		return fmt.Errorf("Try to get role ci type data fail,%s ", err.Error())
	}
	if len(ciTypePermissionTable) == 0 {
		ciTypePermissionTable = []*models.CiTypePermissionObj{}
	} else {
		var ciAttrPermissionRows []*models.CiAttrPermissionObj
		err = x.SQL("select t1.*,t2.display_name as 'ci_attr_name' from sys_role_ci_type t1 left join sys_ci_type_attr t2 on t1.ci_type_attr=t2.id  where t1.role_id=? and t1.ci_type_attr<>''", query.Role).Find(&ciAttrPermissionRows)
		if err != nil {
			return fmt.Errorf("Try to get role ci attr data fail,%s ", err.Error())
		}
		var permissionAttrRows []*models.SysCiTypeAttrTable
		err = x.SQL("select id,ci_type,name from sys_ci_type_attr where `sensitive`='yes'").Find(&permissionAttrRows)
		if err != nil {
			return fmt.Errorf("Try to get sys ci sensitive attr rows fail,%s ", err.Error())
		}
		ciTypeAttrMap := make(map[string][]*models.CiAttrPermissionObj)
		for _, row := range ciAttrPermissionRows {
			matchFlag := false
			for _, attrRow := range permissionAttrRows {
				if attrRow.Id == row.CiTypeAttr {
					matchFlag = true
					break
				}
			}
			if !matchFlag {
				continue
			}
			if existList, ok := ciTypeAttrMap[row.CiType]; ok {
				ciTypeAttrMap[row.CiType] = append(existList, row)
			} else {
				ciTypeAttrMap[row.CiType] = []*models.CiAttrPermissionObj{row}
			}
		}
		var ciTypeConditionRows []*models.SysRoleCiTypeConditionTable
		err = x.SQL("select * from sys_role_ci_type_condition").Find(&ciTypeConditionRows)
		if err != nil {
			return fmt.Errorf("Try to get role ci condition data fail,%s ", err.Error())
		}
		conditionMap := make(map[string]*models.SysRoleCiTypeConditionTable)
		for _, row := range ciTypeConditionRows {
			if v, ok := conditionMap[row.RoleCiType]; ok {
				if row.Insert == "Y" {
					v.Insert = "Y"
				}
				if row.Update == "Y" {
					v.Update = "Y"
				}
				if row.Delete == "Y" {
					v.Delete = "Y"
				}
				if row.Query == "Y" {
					v.Query = "Y"
				}
				if row.Execution == "Y" {
					v.Execution = "Y"
				}
				if row.Confirm == "Y" {
					v.Confirm = "Y"
				}
			} else {
				conditionMap[row.RoleCiType] = row
			}
		}
		for _, row := range ciTypePermissionTable {
			if attrList, ok := ciTypeAttrMap[row.CiType]; ok {
				row.Attrs = attrList
			} else {
				row.Attrs = []*models.CiAttrPermissionObj{}
			}
			if conditionObj, ok := conditionMap[row.Guid]; ok {
				if row.Query != "Y" && conditionObj.Query == "Y" {
					row.Query = "P"
				}
				if row.Insert != "Y" && conditionObj.Insert == "Y" {
					row.Insert = "P"
				}
				if row.Update != "Y" && conditionObj.Update == "Y" {
					row.Update = "P"
				}
				if row.Delete != "Y" && conditionObj.Delete == "Y" {
					row.Delete = "P"
				}
				if row.Execution != "Y" && conditionObj.Execution == "Y" {
					row.Execution = "P"
				}
				if row.Confirm != "Y" && conditionObj.Confirm == "Y" {
					row.Confirm = "P"
				}
			}
			for _, rowAttr := range row.Attrs {
				if conditionObj, ok := conditionMap[rowAttr.Guid]; ok {
					if rowAttr.Query != "Y" && conditionObj.Query == "Y" {
						rowAttr.Query = "P"
					}
					if rowAttr.Insert != "Y" && conditionObj.Insert == "Y" {
						rowAttr.Insert = "P"
					}
					if rowAttr.Update != "Y" && conditionObj.Update == "Y" {
						rowAttr.Update = "P"
					}
					if rowAttr.Delete != "Y" && conditionObj.Delete == "Y" {
						rowAttr.Delete = "P"
					}
					if rowAttr.Execution != "Y" && conditionObj.Execution == "Y" {
						rowAttr.Execution = "P"
					}
					if rowAttr.Confirm != "Y" && conditionObj.Confirm == "Y" {
						rowAttr.Confirm = "P"
					}
				}
			}
		}
	}
	query.CiTypePermissions = ciTypePermissionTable
	return nil
}

func UpdateRoleCiPermission(role string, params []*models.CiTypePermissionObj) error {
	var actions []*execAction
	for _, param := range params {
		actions = append(actions, &execAction{Sql: "update sys_role_ci_type set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`confirm`=? where role_id=? and ci_type=? and ci_type_attr is null",
			Param: []interface{}{param.Insert, param.Delete, param.Update, param.Query, param.Execution, param.Confirm, role, param.CiType}})
		for _, attrParam := range param.Attrs {
			actions = append(actions, &execAction{Sql: "update sys_role_ci_type set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`confirm`=? where role_id=? and ci_type=? and ci_type_attr=?",
				Param: []interface{}{attrParam.Insert, attrParam.Delete, attrParam.Update, attrParam.Query, attrParam.Execution, attrParam.Confirm, role, attrParam.CiType, attrParam.CiTypeAttr}})
		}
	}
	return transaction(actions)
}

func GetRoleCiTypeCondition(roleCiType string) (result models.RoleAttrConditionResult, err error) {
	roleCiTypeData, tmpErr := getRoleCiTypeByGuid(roleCiType)
	if tmpErr != nil {
		err = tmpErr
		return
	}
	var attrs []*models.SysCiTypeAttrTable
	err = x.SQL("select * from sys_ci_type_attr where ci_type=? and permission_usage='yes'", roleCiTypeData.CiType).Find(&attrs)
	if err != nil {
		err = fmt.Errorf("Try to get attributes with ciType:%s error:%s ", roleCiTypeData.CiType, err.Error())
		return
	}
	if len(attrs) == 0 {
		err = fmt.Errorf("There is no attribute enable permission control ")
		return
	}
	for _, v := range attrs {
		tmpHeaderObj := models.RoleAttrConditionHeaderObj{SysCiTypeAttrTable: *v}
		if tmpHeaderObj.InputType == "select" || tmpHeaderObj.InputType == "multiSelect" {
			if tmpOptions, getOptionsErr := getSelectInputTypeOptions(tmpHeaderObj.SelectList); getOptionsErr != nil {
				err = getOptionsErr
				break
			} else {
				tmpHeaderObj.Options = tmpOptions
			}
		}
		result.Header = append(result.Header, &tmpHeaderObj)
	}
	if err != nil {
		return
	}
	var conditionTable []*models.SysRoleCiTypeConditionTable
	err = x.SQL("select * from sys_role_ci_type_condition where role_ci_type=?", roleCiType).Find(&conditionTable)
	if err != nil {
		err = fmt.Errorf("Try to get condition table data fail,%s ", err.Error())
		return
	}
	if len(conditionTable) == 0 {
		result.Body = []map[string]interface{}{}
		return
	}
	var conditionGuidList []string
	for _, condition := range conditionTable {
		conditionGuidList = append(conditionGuidList, condition.Guid)
	}
	var filterTable []*models.SysRoleCiTypeConditionFilterTable
	err = x.SQL("select * from sys_role_ci_type_condition_filter where role_ci_type_condition in ('" + strings.Join(conditionGuidList, "','") + "') order by role_ci_type_condition").Find(&filterTable)
	if err != nil {
		err = fmt.Errorf("Try to get condition filter data fail,%s ", err.Error())
		return
	}
	var filterMap = make(map[string][]*models.SysRoleCiTypeConditionFilterTable)
	for _, filterObj := range filterTable {
		tmpExpressionList := []string{}
		if tmpUnmarshalErr := json.Unmarshal([]byte(filterObj.Expression), &tmpExpressionList); tmpUnmarshalErr == nil {
			filterObj.ConditionValueExprs = tmpExpressionList
		} else {
			filterObj.ConditionValueExprs = []string{filterObj.Expression}
		}
		filterObj.SelectValues = strings.Split(filterObj.SelectList, ",")
		if _, b := filterMap[filterObj.RoleCiTypeCondition]; b {
			filterMap[filterObj.RoleCiTypeCondition] = append(filterMap[filterObj.RoleCiTypeCondition], filterObj)
		} else {
			filterMap[filterObj.RoleCiTypeCondition] = []*models.SysRoleCiTypeConditionFilterTable{filterObj}
		}
	}
	for _, condition := range conditionTable {
		resultBodyObj := make(map[string]interface{})
		if cFilterList, b := filterMap[condition.Guid]; b {
			for _, filterObj := range cFilterList {
				resultBodyObj[filterObj.CiTypeAttrName] = filterObj
			}
		}
		resultBodyObj["roleCiType"] = condition.RoleCiType
		resultBodyObj["roleConditionGuid"] = condition.Guid
		resultBodyObj["insert"] = condition.Insert
		resultBodyObj["update"] = condition.Update
		resultBodyObj["delete"] = condition.Delete
		resultBodyObj["query"] = condition.Query
		resultBodyObj["execute"] = condition.Execution
		resultBodyObj["confirm"] = condition.Confirm
		result.Body = append(result.Body, resultBodyObj)
	}
	return
}

func getSelectInputTypeOptions(catId string) (options []*models.RoleAttrOptionItem, err error) {
	var rowData []*models.SysBaseKeyCodeTable
	err = x.SQL("SELECT `code`,`value` FROM sys_basekey_code WHERE cat_id=? order by seq_no", catId).Find(&rowData)
	if err != nil {
		err = fmt.Errorf("query sys basekey code fail,%s ", err.Error())
		return
	}
	options = []*models.RoleAttrOptionItem{}
	for _, v := range rowData {
		options = append(options, &models.RoleAttrOptionItem{Label: v.Value, Value: v.Code})
	}
	return
}

func AddRoleCiTypeCondition(roleCiType string, conditions []*models.RoleAttrConditionObj) error {
	if len(conditions) == 0 {
		return fmt.Errorf("Param list is empty ")
	}
	roleCiTypeData, err := getRoleCiTypeByGuid(roleCiType)
	if err != nil {
		return err
	}
	conditionGuidList := guid.CreateGuidList(len(conditions))
	var actions, filterActions []*execAction
	for i, condition := range conditions {
		if len(condition.Filters) == 0 {
			err = fmt.Errorf("InputRow:%d have no attribute column ", i)
			break
		}
		tmpConditionGuid := "condition_" + conditionGuidList[i]
		actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type_condition(guid,role_ci_type,`insert`,`delete`,`update`,query,`execute`,`Confirm`) values (?,?,?,?,?,?,?,?)", Param: []interface{}{tmpConditionGuid,
			roleCiType, condition.Insert, condition.Delete, condition.Update, condition.Query, condition.Execution, condition.Confirm}})
		filterGuidList := guid.CreateGuidList(len(condition.Filters))
		for j, filter := range condition.Filters {
			filterActions = append(filterActions, &execAction{Sql: "insert into sys_role_ci_type_condition_filter value (?,?,?,?,?,?,?)", Param: []interface{}{"filter_" + filterGuidList[j],
				tmpConditionGuid, roleCiTypeData.CiType + models.SysTableIdConnector + filter.CiTypeAttrName, filter.CiTypeAttrName, filter.Expression, filter.FilterType, filter.SelectList}})
		}
	}
	if err != nil {
		return err
	}
	err = transaction(actions)
	if err != nil {
		return err
	}
	return transaction(filterActions)
}

func EditRoleCiTypeCondition(roleCiType string, conditions []*models.RoleAttrConditionObj) error {
	if len(conditions) == 0 {
		return fmt.Errorf("Param list is empty ")
	}
	roleCiTypeData, err := getRoleCiTypeByGuid(roleCiType)
	if err != nil {
		return err
	}
	var actions []*execAction
	for i, condition := range conditions {
		if len(condition.Filters) == 0 {
			err = fmt.Errorf("InputRow:%d have no attribute column ", i)
			break
		}
		actions = append(actions, &execAction{Sql: "update sys_role_ci_type_condition set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`Confirm`=? where guid=?", Param: []interface{}{condition.Insert,
			condition.Delete, condition.Update, condition.Query, condition.Execution, condition.Confirm, condition.Guid}})
		filterGuidList := guid.CreateGuidList(len(condition.Filters))
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type_condition_filter where role_ci_type_condition=?", Param: []interface{}{condition.Guid}})
		for j, filter := range condition.Filters {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type_condition_filter value (?,?,?,?,?,?,?)", Param: []interface{}{"filter_" + filterGuidList[j],
				condition.Guid, roleCiTypeData.CiType + models.SysTableIdConnector + filter.CiTypeAttrName, filter.CiTypeAttrName, filter.Expression, filter.FilterType, filter.SelectList}})
		}
	}
	if err != nil {
		return err
	}
	return transaction(actions)
}

func DeleteRoleCiTypeCondition(conditionGuidList []string) error {
	if len(conditionGuidList) == 0 {
		return fmt.Errorf("Param list is empty ")
	}
	var actions []*execAction
	for _, conditionGuid := range conditionGuidList {
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type_condition_filter where role_ci_type_condition=?", Param: []interface{}{conditionGuid}})
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type_condition where guid=?", Param: []interface{}{conditionGuid}})
	}
	return transaction(actions)
}

func GetRoleCiTypeList(roleCiType string) (result []*models.SysRoleCiTypeListTable, err error) {
	roleCiTypeObj, tmpErr := getRoleCiTypeByGuid(roleCiType)
	if tmpErr != nil {
		err = tmpErr
		return
	}
	result = []*models.SysRoleCiTypeListTable{}
	err = x.SQL("select * from sys_role_ci_type_list where role_ci_type=?", roleCiType).Find(&result)
	var guidList []string
	for _, v := range result {
		guidList = append(guidList, strings.Split(v.List, ",")...)
	}
	if len(guidList) > 0 {
		queryRows, tmpErr := x.QueryString(fmt.Sprintf("select guid,key_name from %s where guid in ('%s')", roleCiTypeObj.CiType, strings.Join(guidList, "','")))
		if tmpErr != nil {
			err = fmt.Errorf("Try to query table:%s fail,%s ", roleCiTypeObj.CiType, tmpErr.Error())
			return
		}
		if len(queryRows) > 0 {
			rowKeyMap := make(map[string]string)
			for _, queryRow := range queryRows {
				rowKeyMap[queryRow["guid"]] = queryRow["key_name"]
			}
			for i, v := range result {
				tmpGuidNameList := []string{}
				for _, tmpGuidObj := range strings.Split(v.List, ",") {
					tmpGuidNameList = append(tmpGuidNameList, rowKeyMap[tmpGuidObj])
				}
				result[i].ListName = strings.Join(tmpGuidNameList, ",")
			}
		}
	}
	return
}

func AddRoleCiTypeList(roleCiType string, inputData []*models.SysRoleCiTypeListTable) error {
	_, err := getRoleCiTypeByGuid(roleCiType)
	if err != nil {
		return err
	}
	if len(inputData) == 0 {
		return nil
	}
	guidList := guid.CreateGuidList(len(inputData))
	var actions []*execAction
	for i, data := range inputData {
		actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type_list(guid,role_ci_type,list,`insert`,`delete`,`update`,query,`execute`,`Confirm`) values (?,?,?,?,?,?,?,?,?)", Param: []interface{}{"role_list_" + guidList[i],
			roleCiType, data.List, data.Insert, data.Delete, data.Update, data.Query, data.Execution, data.Confirm}})
	}
	return transaction(actions)
}

func EditRoleCiTypeList(roleCiType string, inputData []*models.SysRoleCiTypeListTable) error {
	if len(inputData) == 0 {
		return nil
	}
	var actions []*execAction
	for _, data := range inputData {
		actions = append(actions, &execAction{Sql: "update sys_role_ci_type_list set `list`=?,`insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`Confirm`=? where guid=?", Param: []interface{}{data.List,
			data.Insert, data.Delete, data.Update, data.Query, data.Execution, data.Confirm, data.Guid}})
	}
	return transaction(actions)
}

func DeleteRoleCiTypeList(inputList []string) error {
	specSql, param := createListParams(inputList, "")
	param = append([]interface{}{"delete from sys_role_ci_type_list where guid in (" + specSql + ")"}, param...)
	_, err := x.Exec(param...)
	return err
}

func getRoleCiTypeByGuid(roleCiType string) (result *models.SysRoleCiTypeTable, err error) {
	var roleCiTypeTable []*models.SysRoleCiTypeTable
	err = x.SQL("select * from sys_role_ci_type where guid=?", roleCiType).Find(&roleCiTypeTable)
	if err != nil {
		err = fmt.Errorf("Try to get roleCiType table data fail,%s ", err.Error())
		return
	}
	if len(roleCiTypeTable) == 0 {
		err = fmt.Errorf("Can not find roleCiType:%s ", roleCiType)
		return
	}
	return roleCiTypeTable[0], nil
}

func AutoCreateRoleCiTypeDataByCiType(ciTypeId string) {
	var roleCiTypeTable []*models.SysRoleCiTypeTable
	err := x.SQL("select guid from sys_role_ci_type where ci_type=?", ciTypeId).Find(&roleCiTypeTable)
	if err != nil {
		log.Logger.Error("Try to auto update roleCiType data fail,query roleCiType data error", log.String("ciType", ciTypeId), log.Error(err))
		return
	}
	var actions []*execAction
	if len(roleCiTypeTable) > 0 {
		return
	}
	var roles []*models.SysRoleTable
	err = x.SQL("select * from sys_role").Find(&roles)
	if err != nil {
		log.Logger.Error("Try to auto update roleCiType data fail,query roles data error", log.String("ciType", ciTypeId), log.Error(err))
		return
	}
	if len(roles) == 0 {
		return
	}
	guidList := guid.CreateGuidList(len(roles))
	for i, role := range roles {
		if strings.ToLower(role.Id) == strings.ToLower(models.AdminUser) {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type,`insert`,`delete`,`update`,query,`execute`,`Confirm`) values (?,?,?,'Y','Y','Y','Y','Y','Y')", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciTypeId}})
		} else {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type) value (?,?,?)", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciTypeId}})
		}
	}
	if err = transaction(actions); err != nil {
		log.Logger.Error("Try to update roleCiType data fail", log.String("ciType", ciTypeId), log.Error(err))
	}
}

func AutoCreateRoleCiTypeAttrPermission(ciTypeId string) {
	var ciAttrRows []*models.SysCiTypeAttrTable
	err := x.SQL("select id,ci_type,name,display_name from sys_ci_type_attr where ci_type=? and status='created' and `sensitive`='yes'", ciTypeId).Find(&ciAttrRows)
	if err != nil {
		log.Logger.Error("Try to auto create role ci attr permission fail,query ci type attr error", log.Error(err))
		return
	}
	if len(ciAttrRows) == 0 {
		return
	}
	var roleCiTypeTable []*models.SysRoleCiTypeTable
	err = x.SQL("select guid,ci_type,ci_type_attr from sys_role_ci_type where ci_type=? and ci_type_attr<>''", ciTypeId).Find(&roleCiTypeTable)
	if err != nil {
		log.Logger.Error("Try to auto update roleCiType attr data fail,query roleCiType data error", log.String("ciType", ciTypeId), log.Error(err))
		return
	}
	var roles []*models.SysRoleTable
	err = x.SQL("select * from sys_role").Find(&roles)
	if err != nil {
		log.Logger.Error("Try to auto update roleCiType attr data fail,query roles data error", log.String("ciType", ciTypeId), log.Error(err))
		return
	}
	if len(roles) == 0 {
		return
	}
	var actions []*execAction
	for _, attrRow := range ciAttrRows {
		existFlag := false
		for _, roleCiRow := range roleCiTypeTable {
			if roleCiRow.CiTypeAttr == attrRow.Id {
				existFlag = true
				break
			}
		}
		if !existFlag {
			guidList := guid.CreateGuidList(len(roles))
			for i, role := range roles {
				if strings.ToLower(role.Id) == strings.ToLower(models.AdminUser) {
					actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type,`insert`,`delete`,`update`,query,`execute`,`Confirm`,`ci_type_attr`) values (?,?,?,'Y','Y','Y','Y','Y','Y',?)", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciTypeId, attrRow.Id}})
				} else {
					actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type,`ci_type_attr`) value (?,?,?,?)", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciTypeId, attrRow.Id}})
				}
			}
		}
	}
	if err = transaction(actions); err != nil {
		log.Logger.Error("Try to update roleCiType attr data fail", log.String("ciType", ciTypeId), log.Error(err))
	}
}

func AutoCreateRoleCiTypeDataByRole(roleId string) {
	var ciTypeTable []*models.SysCiTypeTable
	err := x.SQL("select id from sys_ci_type where status<>'notCreated' and id not in (select ci_type from sys_role_ci_type where role_id=? and ci_type_attr is null)", roleId).Find(&ciTypeTable)
	if err != nil {
		log.Logger.Error("Try to auto update roleCiType data by roleId fail,query ci_type data error", log.String("roleId", roleId), log.Error(err))
		return
	}
	if len(ciTypeTable) == 0 {
		return
	}
	guidList := guid.CreateGuidList(len(ciTypeTable))
	var actions []*execAction
	for i, ciType := range ciTypeTable {
		if strings.ToLower(roleId) == strings.ToLower(models.AdminUser) {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type,`insert`,`delete`,`update`,query,`execute`,`Confirm`) value (?,?,?,'Y','Y','Y','Y','Y','Y')", Param: []interface{}{"role_ci_" + guidList[i], roleId, ciType.Id}})
		} else {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type) value (?,?,?)", Param: []interface{}{"role_ci_" + guidList[i], roleId, ciType.Id}})
		}
	}
	if err = transaction(actions); err != nil {
		log.Logger.Error("Try to update roleCiType data fail", log.String("roleId", roleId), log.Error(err))
	}
}

func GetRoleCiDataPermission(roles []string, ciType, ciTypeAttr string) (result models.CiDataPermission, err error) {
	if len(roles) == 0 {
		return
	}
	var roleCiTable []*models.SysRoleCiTypeTable
	if ciTypeAttr == "" {
		err = x.SQL("select * from sys_role_ci_type where ci_type=? and ci_type_attr is null and role_id in ('"+strings.Join(roles, "','")+"')", ciType).Find(&roleCiTable)
	} else {
		err = x.SQL("select * from sys_role_ci_type where ci_type=? and ci_type_attr=? and role_id in ('"+strings.Join(roles, "','")+"')", ciType, ciTypeAttr).Find(&roleCiTable)
	}
	if err != nil {
		err = fmt.Errorf("Get role ciData permission fail,%s ", err.Error())
	}
	if len(roleCiTable) == 0 {
		//err = fmt.Errorf("Can not get ciData permission config with ci:%s ", ciType)
		result.Query = true
		result.Insert = true
		result.Delete = true
		result.Update = true
		result.Execute = true
		result.Confirm = true
		return
	}
	result.CiType = ciType
	var roleCiTypeGuidList []string
	for _, roleCiTypeObj := range roleCiTable {
		if !result.Insert && roleCiTypeObj.Insert == "Y" {
			result.Insert = true
		}
		if !result.Delete && roleCiTypeObj.Delete == "Y" {
			result.Delete = true
		}
		if !result.Update && roleCiTypeObj.Update == "Y" {
			result.Update = true
		}
		if !result.Query && roleCiTypeObj.Query == "Y" {
			result.Query = true
		}
		if !result.Execute && roleCiTypeObj.Execution == "Y" {
			result.Execute = true
		}
		if !result.Confirm && roleCiTypeObj.Confirm == "Y" {
			result.Confirm = true
		}
		roleCiTypeGuidList = append(roleCiTypeGuidList, roleCiTypeObj.Guid)
	}
	if result.Insert && result.Delete && result.Update && result.Query && result.Execute && result.Confirm {
		return
	}
	var roleCiTypeMap = make(map[string]*models.RoleCiTypePermissionObj)
	var conditionQuery []*models.ConditionListQueryObj
	err = x.SQL("select t2.*,t1.role_ci_type,t1.`insert`,t1.`delete`,t1.`update`,t1.`query`,t1.`execute`,t1.`Confirm` from sys_role_ci_type_condition t1 left join sys_role_ci_type_condition_filter t2 on t1.guid=t2.role_ci_type_condition where t1.role_ci_type in ('" + strings.Join(roleCiTypeGuidList, "','") + "')").Find(&conditionQuery)
	if err != nil {
		err = fmt.Errorf("Get role condition data fail,%s ", err.Error())
		return
	}
	for _, conditionFilter := range conditionQuery {
		tmpFilterObj := models.SysRoleCiTypeConditionFilterTable{Guid: conditionFilter.Guid, RoleCiTypeCondition: conditionFilter.RoleCiTypeCondition, CiTypeAttr: conditionFilter.CiTypeAttr,
			CiTypeAttrName: conditionFilter.CiTypeAttrName, Expression: conditionFilter.Expression, FilterType: conditionFilter.FilterType, SelectList: conditionFilter.SelectList}
		tmpConditionObj := models.RoleAttrConditionObj{Guid: conditionFilter.RoleCiTypeCondition, RoleCiTypeId: conditionFilter.RoleCiType, Insert: conditionFilter.Insert,
			Delete: conditionFilter.Delete, Update: conditionFilter.Update, Query: conditionFilter.Query, Execution: conditionFilter.Execution, Confirm: conditionFilter.Confirm, Filters: []*models.SysRoleCiTypeConditionFilterTable{&tmpFilterObj}}
		if _, b := roleCiTypeMap[conditionFilter.RoleCiType]; b {
			indexFlag := -1
			for i, condition := range roleCiTypeMap[conditionFilter.RoleCiType].Conditions {
				if condition.Guid == conditionFilter.RoleCiTypeCondition {
					indexFlag = i
					break
				}
			}
			if indexFlag >= 0 {
				roleCiTypeMap[conditionFilter.RoleCiType].Conditions[indexFlag].Filters = append(roleCiTypeMap[conditionFilter.RoleCiType].Conditions[indexFlag].Filters, &tmpFilterObj)
			} else {
				roleCiTypeMap[conditionFilter.RoleCiType].Conditions = append(roleCiTypeMap[conditionFilter.RoleCiType].Conditions, &tmpConditionObj)
			}
		} else {
			roleCiTypeMap[conditionFilter.RoleCiType] = &models.RoleCiTypePermissionObj{Conditions: []*models.RoleAttrConditionObj{&tmpConditionObj}}
		}
	}
	var roleListQuery []*models.SysRoleCiTypeListTable
	err = x.SQL("select * from sys_role_ci_type_list where role_ci_type in ('" + strings.Join(roleCiTypeGuidList, "','") + "')").Find(&roleListQuery)
	if err != nil {
		err = fmt.Errorf("Get role list data fail,%s ", err.Error())
		return
	}
	for _, roleList := range roleListQuery {
		if _, b := roleCiTypeMap[roleList.RoleCiType]; b {
			roleCiTypeMap[roleList.RoleCiType].List = append(roleCiTypeMap[roleList.RoleCiType].List, roleList)
		} else {
			roleCiTypeMap[roleList.RoleCiType] = &models.RoleCiTypePermissionObj{List: []*models.SysRoleCiTypeListTable{roleList}}
		}
	}
	result.ConfigMap = roleCiTypeMap
	return
}

func GetCiDataPermissionGuidList(config *models.CiDataPermission, action string) (result models.CiDataLegalGuidList, err error) {
	result = models.CiDataLegalGuidList{}
	switch action {
	case "insert":
		result.Legal = config.Insert
	case "delete":
		result.Legal = config.Delete
	case "update":
		result.Legal = config.Update
	case "query":
		result.Legal = config.Query
	case "execute":
		result.Legal = config.Execute
	case "confirm":
		result.Legal = config.Confirm
	}
	if result.Legal {
		return
	}
	guidMap := make(map[string]bool)
	for _, configMap := range config.ConfigMap {
		// fetch roleList config
		for _, roleList := range configMap.List {
			if isRoleListActionEnable(action, roleList) {
				for _, tmpGuid := range strings.Split(roleList.List, ",") {
					guidMap[tmpGuid] = true
				}
			}
		}
		// fetch condition config
		for _, condition := range configMap.Conditions {
			if !isConditionActionEnable(action, condition) {
				continue
			}
			columnFilterList := []string{}
			for _, filter := range condition.Filters {
				if filter.FilterType == models.FilterTypeSelectList {
					if filter.SelectList != "" {
						tmpSelectFilterList := strings.Split(filter.SelectList, ",")
						columnFilterList = append(columnFilterList, fmt.Sprintf(" %s in ('%s') ", filter.CiTypeAttrName, strings.Join(tmpSelectFilterList, "','")))
					}
					continue
				}
				if filter.Expression == "" || filter.Expression == "[\"\"]" {
					continue
				}
				filterExpressionList := []string{}
				if strings.HasPrefix(filter.Expression, "[") {
					if tmpErr := json.Unmarshal([]byte(filter.Expression), &filterExpressionList); tmpErr != nil {
						err = fmt.Errorf("Try to parse expression filter to []string fail,data:%s,err:%s ", filter.Expression, tmpErr.Error())
						break
					}
				} else {
					filterExpressionList = append(filterExpressionList, filter.Expression)
				}
				filterColumnGuidList := []string{}
				for _, tmpExpression := range filterExpressionList {
					tmpFilterColumnGuidList, tmpErr := getConditionExpressResult(tmpExpression, "", make(map[string]string), true)
					if tmpErr != nil {
						err = fmt.Errorf("Try to analyze filter expression fail,%s ", tmpErr.Error())
						break
					}
					filterColumnGuidList = append(filterColumnGuidList, tmpFilterColumnGuidList...)
				}
				if err != nil {
					break
				}
				//tmpCiType := filter.CiTypeAttr[:strings.Index(filter.CiTypeAttr, models.SysTableIdConnector)]
				if isAttributeMultiRef(config.CiType, filter.CiTypeAttrName) {
					multiRefQueryRows, tmpErr := x.QueryString(fmt.Sprintf("select from_guid from %s$%s where to_guid in ('%s')", config.CiType, filter.CiTypeAttrName, strings.Join(filterColumnGuidList, "','")))
					if tmpErr != nil {
						err = fmt.Errorf("Try to get expression data with multiRef attr:%s fail,%s ", filter.CiTypeAttr, tmpErr.Error())
						break
					}
					filterColumnGuidList = []string{}
					for _, multiRefQueryRow := range multiRefQueryRows {
						filterColumnGuidList = append(filterColumnGuidList, multiRefQueryRow["from_guid"])
					}
					columnFilterList = append(columnFilterList, fmt.Sprintf(" guid in ('%s') ", strings.Join(filterColumnGuidList, "','")))
				} else {
					columnFilterList = append(columnFilterList, fmt.Sprintf(" %s in ('%s') ", filter.CiTypeAttrName, strings.Join(filterColumnGuidList, "','")))
				}
			}
			if err != nil {
				break
			}
			if len(columnFilterList) == 0 {
				err = fmt.Errorf("Get permission legal data fail,condition:%s build with empty filter sql ", condition.Guid)
				break
			}
			queryRows, tmpErr := x.QueryString(fmt.Sprintf("select guid from %s where %s", config.CiType, strings.Join(columnFilterList, " and ")))
			if tmpErr != nil {
				err = fmt.Errorf("Get permission legal data fail,query ciTable:%s error:%s ", config.CiType, tmpErr.Error())
				break
			}
			for _, queryRow := range queryRows {
				guidMap[queryRow["guid"]] = true
			}
		}
		if err != nil {
			break
		}
	}
	for k, _ := range guidMap {
		result.GuidList = append(result.GuidList, k)
	}
	return
}

type InsertPermissionObj struct {
	CiType      string
	Actions     []*execAction
	GuidList    []string
	KeyNameList []string
}

func ValidateInsertPermission(param map[string]*InsertPermissionObj, roles []string) error {
	var err error
	for k, v := range param {
		err = ciTypeInsertPermissionValidate(k, v, roles)
		if err != nil {
			break
		}
	}
	return err
}

func ciTypeInsertPermissionValidate(ciType string, param *InsertPermissionObj, roles []string) error {
	ciTypePermissionConfig, err := GetRoleCiDataPermission(roles, ciType, "")
	if err != nil {
		return err
	}
	if ciTypePermissionConfig.Insert {
		return nil
	}
	session := x.NewSession()
	err = session.Begin()
	for _, v := range param.Actions {
		tmpExecParam := []interface{}{v.Sql}
		_, err = session.Exec(append(tmpExecParam, v.Param...)...)
		if err != nil {
			session.Rollback()
			break
		}
	}
	if err != nil {
		session.Close()
		return fmt.Errorf("Validate permisssion do actions fail,%s ", err.Error())
	}
	guidMap := make(map[string]bool)
	for _, configMap := range ciTypePermissionConfig.ConfigMap {
		for _, condition := range configMap.Conditions {
			if condition.Insert != "Y" {
				continue
			}
			columnFilterList := []string{}
			for _, filter := range condition.Filters {
				if filter.FilterType == models.FilterTypeSelectList {
					if filter.SelectList != "" {
						tmpSelectFilterList := strings.Split(filter.SelectList, ",")
						columnFilterList = append(columnFilterList, fmt.Sprintf(" %s in ('%s') ", filter.CiTypeAttrName, strings.Join(tmpSelectFilterList, "','")))
					}
					continue
				}
				if filter.Expression == "" || filter.Expression == "[\"\"]" {
					continue
				}
				filterExpressionList := []string{}
				if strings.HasPrefix(filter.Expression, "[") {
					if tmpErr := json.Unmarshal([]byte(filter.Expression), &filterExpressionList); tmpErr != nil {
						err = fmt.Errorf("Try to parse expression filter to []string fail,data:%s,err:%s ", filter.Expression, tmpErr.Error())
						break
					}
				} else {
					filterExpressionList = append(filterExpressionList, filter.Expression)
				}
				filterColumnGuidList := []string{}
				for _, tmpExpression := range filterExpressionList {
					tmpFilterColumnGuidList, tmpErr := getConditionExpressResult(tmpExpression, "", make(map[string]string), true)
					if tmpErr != nil {
						err = fmt.Errorf("Try to analyze filter expression fail,%s ", tmpErr.Error())
						break
					}
					filterColumnGuidList = append(filterColumnGuidList, tmpFilterColumnGuidList...)
				}
				if err != nil {
					break
				}
				//tmpCiType := filter.CiTypeAttr[:strings.Index(filter.CiTypeAttr, models.SysTableIdConnector)]
				if isAttributeMultiRef(ciType, filter.CiTypeAttrName) {
					multiRefQueryRows, tmpErr := session.QueryString(fmt.Sprintf("select from_guid from %s$%s where to_guid in ('%s')", ciType, filter.CiTypeAttrName, strings.Join(filterColumnGuidList, "','")))
					if tmpErr != nil {
						err = fmt.Errorf("Try to get expression data with multiRef attr:%s fail,%s ", filter.CiTypeAttr, tmpErr.Error())
						break
					}
					filterColumnGuidList = []string{}
					for _, multiRefQueryRow := range multiRefQueryRows {
						filterColumnGuidList = append(filterColumnGuidList, multiRefQueryRow["from_guid"])
					}
					columnFilterList = append(columnFilterList, fmt.Sprintf(" guid in ('%s') ", strings.Join(filterColumnGuidList, "','")))
				} else {
					columnFilterList = append(columnFilterList, fmt.Sprintf(" %s in ('%s') ", filter.CiTypeAttrName, strings.Join(filterColumnGuidList, "','")))
				}
			}
			if err != nil {
				break
			}
			if len(columnFilterList) == 0 {
				log.Logger.Warn("ciTypeInsertPermissionValidate Get permission legal data fail, build with empty filter sql", log.String(condition.Guid, "condition.Guid"))
				continue
			}
			queryRows, tmpErr := session.QueryString(fmt.Sprintf("select guid from %s where %s", ciType, strings.Join(columnFilterList, " and ")))
			if tmpErr != nil {
				err = fmt.Errorf("Get permission legal data fail,query ciTable:%s error:%s ", ciType, tmpErr.Error())
				break
			}
			for _, queryRow := range queryRows {
				guidMap[queryRow["guid"]] = true
			}
		}
		if err != nil {
			break
		}
	}
	if err == nil {
		for i, rowGuid := range param.GuidList {
			if _, b := guidMap[rowGuid]; !b {
				err = fmt.Errorf("Row: %s permission deny ", param.KeyNameList[i])
				break
			}
		}
	}
	session.Rollback()
	session.Close()
	return err
}

func isRoleListActionEnable(action string, roleListConfig *models.SysRoleCiTypeListTable) bool {
	enableString := "N"
	switch action {
	case "insert":
		enableString = roleListConfig.Insert
	case "delete":
		enableString = roleListConfig.Delete
	case "update":
		enableString = roleListConfig.Update
	case "query":
		enableString = roleListConfig.Query
	case "execute":
		enableString = roleListConfig.Execution
	case "confirm":
		enableString = roleListConfig.Confirm
	}
	if enableString == "Y" {
		return true
	}
	return false
}

func isConditionActionEnable(action string, condition *models.RoleAttrConditionObj) bool {
	enableString := "N"
	switch action {
	case "insert":
		enableString = condition.Insert
	case "delete":
		enableString = condition.Delete
	case "update":
		enableString = condition.Update
	case "query":
		enableString = condition.Query
	case "execute":
		enableString = condition.Execution
	case "confirm":
		enableString = condition.Confirm
	}
	if enableString == "Y" {
		return true
	}
	return false
}

func ValidateAttrUpdatePermission(multiCiData []*models.MultiCiDataObj, userRoles []string) (err error) {
	for _, ciDataObj := range multiCiData {
		// key -> attrName, value -> guidList
		tmpSensitiveAttrMap := make(map[string][]string)
		tmpSensitiveAttrNameIdMap := make(map[string]string)
		for _, attr := range ciDataObj.Attributes {
			if attr.Sensitive == "yes" {
				tmpSensitiveAttrMap[attr.Name] = []string{}
				tmpSensitiveAttrNameIdMap[attr.Name] = attr.Id
			}
		}
		if len(tmpSensitiveAttrMap) == 0 {
			continue
		}
		for _, rowData := range ciDataObj.InputData {
			tmpRowGuid := rowData["guid"]
			if tmpRowGuid == "" {
				continue
			}
			for k, v := range rowData {
				if existGuidList, ok := tmpSensitiveAttrMap[k]; ok {
					if v != "" && v != models.PasswordDisplay {
						tmpSensitiveAttrMap[k] = append(existGuidList, tmpRowGuid)
					}
				}
			}
		}
		for attrName, guidList := range tmpSensitiveAttrMap {
			if len(guidList) == 0 {
				continue
			}
			permissions, tmpGetPermissionConfigErr := GetRoleCiDataPermission(userRoles, ciDataObj.CiTypeId, tmpSensitiveAttrNameIdMap[attrName])
			if tmpGetPermissionConfigErr != nil {
				err = fmt.Errorf("validate attr permission fail, attr:%s get permission config error:%s ", attrName, tmpGetPermissionConfigErr.Error())
				return
			}
			tmpLegalGuidList, tmpGetPermissionGuidListErr := GetCiDataPermissionGuidList(&permissions, "update")
			if tmpGetPermissionGuidListErr != nil {
				err = fmt.Errorf("validate attr permission fail, attr:%s get legal guid list error:%s", attrName, tmpGetPermissionGuidListErr.Error())
				return
			}
			if !tmpLegalGuidList.Legal {
				for _, inputRowGuid := range guidList {
					matchGuidFlag := false
					for _, tmpGuid := range tmpLegalGuidList.GuidList {
						if inputRowGuid == tmpGuid {
							matchGuidFlag = true
							break
						}
					}
					if !matchGuidFlag {
						err = fmt.Errorf("Row:%s attr:%s permission deny ", inputRowGuid, attrName)
						return
					}
				}
			}
		}
	}
	return
}
