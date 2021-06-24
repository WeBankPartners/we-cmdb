package db

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common-lib/guid"
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
	err = x.SQL("select t1.*,t2.display_name as 'ci_type_name' from sys_role_ci_type t1 left join sys_ci_type t2 on t1.ci_type=t2.id where t1.role_id=?", query.Role).Find(&ciTypePermissionTable)
	if err != nil {
		return fmt.Errorf("Try to get role ci type data fail,%s ", err.Error())
	}
	if len(ciTypePermissionTable) == 0 {
		ciTypePermissionTable = []*models.CiTypePermissionObj{}
	}
	query.CiTypePermissions = ciTypePermissionTable
	return nil
}

func UpdateRoleCiPermission(role string, params []*models.CiTypePermissionObj) error {
	var actions []*execAction
	for _, param := range params {
		actions = append(actions, &execAction{Sql: "update sys_role_ci_type set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=? where role_id=? and ci_type=?",
			Param: []interface{}{param.Insert, param.Delete, param.Update, param.Query, param.Execution, role, param.CiType}})
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
	result.Header = attrs
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
		filterObj.ConditionValueExprs = []string{filterObj.Expression}
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
		result.Body = append(result.Body, resultBodyObj)
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
		actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type_condition value (?,?,?,?,?,?,?)", Param: []interface{}{tmpConditionGuid,
			roleCiType, condition.Insert, condition.Delete, condition.Update, condition.Query, condition.Execution}})
		filterGuidList := guid.CreateGuidList(len(condition.Filters))
		for j, filter := range condition.Filters {
			filterActions = append(filterActions, &execAction{Sql: "insert into sys_role_ci_type_condition_filter value (?,?,?,?,?)", Param: []interface{}{"filter_" + filterGuidList[j],
				tmpConditionGuid, roleCiTypeData.CiType + models.SysTableIdConnector + filter.CiTypeAttrName, filter.CiTypeAttrName, filter.Expression}})
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
		actions = append(actions, &execAction{Sql: "update sys_role_ci_type_condition set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=? where guid=?", Param: []interface{}{condition.Insert,
			condition.Delete, condition.Update, condition.Query, condition.Execution, condition.Guid}})
		filterGuidList := guid.CreateGuidList(len(condition.Filters))
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type_condition_filter where role_ci_type_condition=?", Param: []interface{}{condition.Guid}})
		for j, filter := range condition.Filters {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type_condition_filter value (?,?,?,?,?)", Param: []interface{}{"filter_" + filterGuidList[j],
				condition.Guid, roleCiTypeData.CiType + models.SysTableIdConnector + filter.CiTypeAttrName, filter.CiTypeAttrName, filter.Expression}})
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
		actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type_list value (?,?,?,?,?,?,?,?)", Param: []interface{}{"role_list_" + guidList[i],
			roleCiType, data.List, data.Insert, data.Delete, data.Update, data.Query, data.Execution}})
	}
	return transaction(actions)
}

func EditRoleCiTypeList(roleCiType string, inputData []*models.SysRoleCiTypeListTable) error {
	if len(inputData) == 0 {
		return nil
	}
	var actions []*execAction
	for _, data := range inputData {
		actions = append(actions, &execAction{Sql: "update sys_role_ci_type_list set `list`=?,`insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=? where guid=?", Param: []interface{}{data.List,
			data.Insert, data.Delete, data.Update, data.Query, data.Execution, data.Guid}})
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

func AutoCreateRoleCiTypeData(ciTypeId string) {
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
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type value (?,?,?,'Y','Y','Y','Y','Y')", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciTypeId}})
		} else {
			actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type) value (?,?,?)", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciTypeId}})
		}
	}
	if err = transaction(actions); err != nil {
		log.Logger.Error("Try to update roleCiType data fail", log.String("ciType", ciTypeId), log.Error(err))
	}
}

func GetRoleCiDataPermission(roles []string, ciType string) (result models.CiDataPermission, err error) {
	if len(roles) == 0 {
		return
	}
	var roleCiTable []*models.SysRoleCiTypeTable
	err = x.SQL("select * from sys_role_ci_type where ci_type=? and role_id in ('"+strings.Join(roles, "','")+"')", ciType).Find(&roleCiTable)
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
		roleCiTypeGuidList = append(roleCiTypeGuidList, roleCiTypeObj.Guid)
	}
	if result.Insert && result.Delete && result.Update && result.Query && result.Execute {
		return
	}
	var roleCiTypeMap = make(map[string]*models.RoleCiTypePermissionObj)
	var conditionQuery []*models.ConditionListQueryObj
	err = x.SQL("select t2.*,t1.role_ci_type,t1.`insert`,t1.`delete`,t1.`update`,t1.`query`,t1.`execute` from sys_role_ci_type_condition t1 left join sys_role_ci_type_condition_filter t2 on t1.guid=t2.role_ci_type_condition where role_ci_type in ('" + strings.Join(roleCiTypeGuidList, "','") + "')").Find(&conditionQuery)
	if err != nil {
		err = fmt.Errorf("Get role condition data fail,%s ", err.Error())
		return
	}
	for _, conditionFilter := range conditionQuery {
		tmpFilterObj := models.SysRoleCiTypeConditionFilterTable{Guid: conditionFilter.Guid, RoleCiTypeCondition: conditionFilter.RoleCiTypeCondition, CiTypeAttr: conditionFilter.CiTypeAttr,
			CiTypeAttrName: conditionFilter.CiTypeAttrName, Expression: conditionFilter.Expression}
		tmpConditionObj := models.RoleAttrConditionObj{Guid: conditionFilter.RoleCiTypeCondition, RoleCiTypeId: conditionFilter.RoleCiType, Insert: conditionFilter.Insert,
			Delete: conditionFilter.Delete, Update: conditionFilter.Update, Query: conditionFilter.Query, Execution: conditionFilter.Execution, Filters: []*models.SysRoleCiTypeConditionFilterTable{&tmpFilterObj}}
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
		result.Enable = config.Insert
	case "delete":
		result.Enable = config.Delete
	case "update":
		result.Enable = config.Update
	case "query":
		result.Enable = config.Query
	case "execute":
		result.Enable = config.Execute
	}
	if result.Enable {
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
				if filter.Expression == "" {
					continue
				}
				filterColumnGuidList, tmpErr := getExpressResultList(filter.Expression, "", make(map[string]string), true)
				if tmpErr != nil {
					err = fmt.Errorf("Try to analyze filter expression fail,%s ", tmpErr.Error())
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
	ciTypePermissionConfig, err := GetRoleCiDataPermission(roles, ciType)
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
				if filter.Expression == "" {
					continue
				}
				filterColumnGuidList, tmpErr := getExpressResultList(filter.Expression, "", make(map[string]string), true)
				if tmpErr != nil {
					err = fmt.Errorf("Try to analyze filter expression fail,%s ", tmpErr.Error())
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
				err = fmt.Errorf("Get permission legal data fail,condition:%s build with empty filter sql ", condition.Guid)
				break
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
	for i, rowGuid := range param.GuidList {
		if _, b := guidMap[rowGuid]; !b {
			err = fmt.Errorf("Row: %s permission deny ", param.KeyNameList[i])
			break
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
	}
	if enableString == "Y" {
		return true
	}
	return false
}
