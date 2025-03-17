package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"go.uber.org/zap"
	"sort"
	"strings"
	"time"
)

func ListTemplate() (result []*models.SysPermissionTplTable, err error) {
	result = []*models.SysPermissionTplTable{}
	err = x.SQL("select * from sys_permission_tpl order by update_time desc").Find(&result)
	if err != nil {
		err = fmt.Errorf("query permission tpl table fail,%s ", err.Error())
	}
	return
}

func SaveTemplate(param *models.PermissionTplData) (err error) {
	if err = checkPermissionTplName(param.Id, param.Name); err != nil {
		return
	}
	var actions []*execAction
	nowTime := time.Now()
	if param.Id == "" {
		// add
		var ciRows []*models.SysCiTypeTable
		err = x.SQL("select id from sys_ci_type where status='created'").Find(&ciRows)
		if err != nil {
			err = fmt.Errorf("query sys_ci_type table fail,%s ", err.Error())
			return
		}
		var ciAttrRows []*models.SysCiTypeAttrTable
		err = x.SQL("select id,ci_type,name,display_name from sys_ci_type_attr where status='created' and `sensitive`='yes'").Find(&ciAttrRows)
		if err != nil {
			err = fmt.Errorf("query ci type attr table fail,%s ", err.Error())
			return
		}
		param.Id = "perm_tpl_" + guid.CreateGuid()
		actions = append(actions, &execAction{Sql: "insert into sys_permission_tpl(id,name,create_user,create_time,update_user,update_time) values (?,?,?,?,?,?)", Param: []interface{}{param.Id, param.Name, param.Operator, nowTime, param.Operator, nowTime}})
		ciGuidList := guid.CreateGuidList(len(ciRows))
		for i, row := range ciRows {
			actions = append(actions, &execAction{Sql: "insert into sys_permission_ci_tpl(guid,permission_tpl,ci_type) values (?,?,?)", Param: []interface{}{"perm_ci_" + ciGuidList[i], param.Id, row.Id}})
		}
		if len(ciAttrRows) > 0 {
			ciAttrGuidList := guid.CreateGuidList(len(ciAttrRows))
			for i, row := range ciAttrRows {
				actions = append(actions, &execAction{Sql: "insert into sys_permission_ci_tpl(guid,permission_tpl,ci_type,ci_type_attr) values (?,?,?,?)", Param: []interface{}{"perm_ci_" + ciAttrGuidList[i], param.Id, row.CiType, row.Id}})
			}
		}
		err = transaction(actions)
		return
	}
	// update
	if _, err = getSimplePermissionTpl(param.Id); err != nil {
		return
	}
	actions = append(actions, &execAction{Sql: "update sys_permission_tpl set name=?,update_user=?,update_time=? where id=?", Param: []interface{}{param.Name, param.Operator, nowTime, param.Id}})
	for _, ciConfig := range param.Configs {
		actions = append(actions, &execAction{Sql: "update sys_permission_ci_tpl set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`confirm`=? where permission_tpl=? and ci_type=? and ci_type_attr is null",
			Param: []interface{}{ciConfig.Insert, ciConfig.Delete, ciConfig.Update, ciConfig.Query, ciConfig.Execution, ciConfig.Confirm, param.Id, ciConfig.CiType}})
		for _, attrParam := range ciConfig.Attrs {
			actions = append(actions, &execAction{Sql: "update sys_permission_ci_tpl set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`confirm`=? where permission_tpl=? and ci_type=? and ci_type_attr=?",
				Param: []interface{}{attrParam.Insert, attrParam.Delete, attrParam.Update, attrParam.Query, attrParam.Execution, attrParam.Confirm, param.Id, attrParam.CiType, attrParam.CiTypeAttr}})
		}
	}
	err = transaction(actions)
	return
}

func getSimplePermissionTpl(id string) (result *models.SysPermissionTplTable, err error) {
	var rows []*models.SysPermissionTplTable
	err = x.SQL("select * from sys_permission_tpl where id=?", id).Find(&rows)
	if err != nil {
		err = fmt.Errorf("query permission tpl table fail,%s ", err.Error())
		return
	}
	if len(rows) == 0 {
		err = fmt.Errorf("can not find permission template with id:%s ", id)
		return
	}
	result = rows[0]
	return
}

func checkPermissionTplName(id, name string) (err error) {
	if name == "" {
		err = fmt.Errorf("param name can not empty")
		return
	}
	var rows []*models.SysPermissionTplTable
	err = x.SQL("select id,name from sys_permission_tpl where name=?", name).Find(&rows)
	if err != nil {
		err = fmt.Errorf("query permission tpl table fail,%s ", err.Error())
		return
	}
	if len(rows) > 0 {
		err = fmt.Errorf("name:%s duplicate", name)
		if id != "" {
			for _, row := range rows {
				if row.Id == id {
					err = nil
					break
				}
			}
		}
	}
	return
}

func GetTemplate(id string) (result *models.PermissionTplData, err error) {
	permissionRow, getErr := getSimplePermissionTpl(id)
	if getErr != nil {
		err = getErr
		return
	}
	result = &models.PermissionTplData{Id: permissionRow.Id, Name: permissionRow.Name, Configs: []*models.CiTypePermissionTplObj{}}
	var ciPermissionRows []*models.SysPermissionCiTplTable
	err = x.SQL("select * from sys_permission_ci_tpl where permission_tpl=?", id).Find(&ciPermissionRows)
	if err != nil {
		err = fmt.Errorf("query permission_ci_tpl table fail,%s ", err.Error())
		return
	}

	var ciTypePermissionTable []*models.CiTypePermissionTplObj
	err = x.SQL("select t1.*,t2.display_name as 'ci_type_name' from sys_permission_ci_tpl t1 left join sys_ci_type t2 on t1.ci_type=t2.id where t1.permission_tpl=? and t1.ci_type_attr is null", id).Find(&ciTypePermissionTable)
	if err != nil {
		err = fmt.Errorf("Try to permission ci type data fail,%s ", err.Error())
		return
	}
	if len(ciTypePermissionTable) == 0 {
		ciTypePermissionTable = []*models.CiTypePermissionTplObj{}
	} else {
		var ciAttrPermissionRows []*models.CiAttrPermissionTplObj
		err = x.SQL("select t1.*,t2.display_name as 'ci_attr_name' from sys_permission_ci_tpl t1 left join sys_ci_type_attr t2 on t1.ci_type_attr=t2.id  where t1.permission_tpl=? and t1.ci_type_attr<>''", id).Find(&ciAttrPermissionRows)
		if err != nil {
			err = fmt.Errorf("Try to get permission ci attr data fail,%s ", err.Error())
			return
		}
		var permissionAttrRows []*models.SysCiTypeAttrTable
		err = x.SQL("select id,ci_type,name from sys_ci_type_attr where `sensitive`='yes'").Find(&permissionAttrRows)
		if err != nil {
			err = fmt.Errorf("Try to get sys ci sensitive attr rows fail,%s ", err.Error())
			return
		}
		ciTypeAttrMap := make(map[string][]*models.CiAttrPermissionTplObj)
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
				ciTypeAttrMap[row.CiType] = []*models.CiAttrPermissionTplObj{row}
			}
		}
		var ciTypeConditionRows []*models.SysPermissionConditionTplTable
		err = x.SQL("select * from sys_permission_condition_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?)", id).Find(&ciTypeConditionRows)
		if err != nil {
			err = fmt.Errorf("Try to get permission ci condition data fail,%s ", err.Error())
			return
		}
		var ciTypeListRows []*models.SysPermissionListTplTable
		err = x.SQL("select * from sys_permission_list_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?)", id).Find(&ciTypeListRows)
		if err != nil {
			err = fmt.Errorf("Try to get permission ci condition list data fail,%s ", err.Error())
			return
		}
		conditionMap := make(map[string]*models.SysPermissionConditionTplTable)
		withConditionMap := make(map[string]int8) // key -> role_ci_type_id value -> 1 true
		withListRowMap := make(map[string]int8)   // key -> role_ci_type_id value -> 1 true
		for _, row := range ciTypeConditionRows {
			withConditionMap[row.PermissionCiTpl] = 1
			if v, ok := conditionMap[row.PermissionCiTpl]; ok {
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
				conditionMap[row.PermissionCiTpl] = row
			}
		}
		for _, row := range ciTypeListRows {
			withListRowMap[row.PermissionCiTpl] = 1
		}
		for _, row := range ciTypePermissionTable {
			if attrList, ok := ciTypeAttrMap[row.CiType]; ok {
				row.Attrs = attrList
			} else {
				row.Attrs = []*models.CiAttrPermissionTplObj{}
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
				if _, conditionEnable := withConditionMap[rowAttr.Guid]; conditionEnable {
					rowAttr.ConditionEnable = conditionEnable
				}
				if _, listRowEnable := withListRowMap[rowAttr.Guid]; listRowEnable {
					rowAttr.ListRowEnable = listRowEnable
				}
			}
			if _, conditionEnable := withConditionMap[row.Guid]; conditionEnable {
				row.ConditionEnable = conditionEnable
			}
			if _, listRowEnable := withListRowMap[row.Guid]; listRowEnable {
				row.ListRowEnable = listRowEnable
			}
		}
	}
	result.Configs = ciTypePermissionTable
	return
}

func DeleteTemplate(id string) (err error) {
	if _, err = getSimplePermissionTpl(id); err != nil {
		return
	}
	var actions []*execAction
	actions = append(actions, &execAction{Sql: "delete from sys_role_tpl_permission where permission_tpl=?", Param: []interface{}{id}})
	actions = append(actions, &execAction{Sql: "delete from sys_permission_list_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?)", Param: []interface{}{id}})
	actions = append(actions, &execAction{Sql: "delete from sys_permission_condition_filter_tpl where permission_condition_tpl in (select guid from sys_permission_condition_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?))", Param: []interface{}{id}})
	actions = append(actions, &execAction{Sql: "delete from sys_permission_condition_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?)", Param: []interface{}{id}})
	actions = append(actions, &execAction{Sql: "delete from sys_permission_ci_tpl where permission_tpl=?", Param: []interface{}{id}})
	actions = append(actions, &execAction{Sql: "delete from sys_permission_tpl where id=?", Param: []interface{}{id}})
	err = transaction(actions)
	return
}

func GetTemplateParam(id string) (result *models.PermissionTplParam, err error) {
	permissionTplRow, getErr := getSimplePermissionTpl(id)
	if getErr != nil {
		err = getErr
		return
	}
	result = &models.PermissionTplParam{PermissionTplId: permissionTplRow.Id, PermissionTplName: permissionTplRow.Name, Params: []*models.PermissionTplFilterParamObj{}}
	var filterRows []*models.SysPermissionConditionFilterTplTable
	err = x.SQL("select guid,param_list from sys_permission_condition_filter_tpl where param_list is not null and permission_condition_tpl in (select guid from sys_permission_condition_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?))", id).Find(&filterRows)
	if err != nil {
		err = fmt.Errorf("query permission condition filter table fail,%s ", err.Error())
		return
	}
	var filterCiTypeList []string
	for _, row := range filterRows {
		if row.ParamList == "" || row.ParamList == "[]" {
			continue
		}
		tmpParamList := []*models.PermissionTplFilterParamObj{}
		if err = json.Unmarshal([]byte(row.ParamList), &tmpParamList); err != nil {
			err = fmt.Errorf("json unmarshal permission tpl param filter:%s fail,%s ", row.Guid, err.Error())
			return
		}
		result.Params = append(result.Params, tmpParamList...)
		for _, v := range tmpParamList {
			filterCiTypeList = append(filterCiTypeList, v.CiType)
		}
	}
	ciTypeNameMap, ciAttrNameMap, getNameErr := getCiTypeAndAttrNameMap(filterCiTypeList)
	if getNameErr != nil {
		err = getNameErr
		return
	}
	for _, v := range result.Params {
		v.CiTypeDisplayName = ciTypeNameMap[v.CiType]
		v.SensitiveAttrDisplayName = ciAttrNameMap[v.SensitiveAttr]
		v.FilterAttrDisplayName = ciAttrNameMap[v.FilterAttr]
	}
	return
}

func SaveTemplateParam(param *models.PermissionTplParam) (err error) {
	// 查询之前的配置
	var filterRows []*models.SysPermissionConditionFilterTplTable
	err = x.SQL("select guid,param_list from sys_permission_condition_filter_tpl where param_list is not null and permission_condition_tpl in (select guid from sys_permission_condition_tpl where permission_ci_tpl in (select guid from sys_permission_ci_tpl where permission_tpl=?))", param.PermissionTplId).Find(&filterRows)
	if err != nil {
		err = fmt.Errorf("query permission condition filter table fail,%s ", err.Error())
		return
	}
	filterParamMap := make(map[string][]*models.PermissionTplFilterParamObj)
	for _, row := range filterRows {
		if row.ParamList == "" || row.ParamList == "[]" {
			continue
		}
		tmpParamList := []*models.PermissionTplFilterParamObj{}
		if err = json.Unmarshal([]byte(row.ParamList), &tmpParamList); err == nil {
			filterParamMap[row.Guid] = tmpParamList
		}
	}
	// 对比当前配置与之前配置，看哪些变量名改了
	var actions []*execAction
	filterMap := make(map[string][]*models.PermissionTplFilterParamObj)
	filterParamNameMap := make(map[string][]string) // key->filterTplId  value->[oldValue,newValue]
	for _, v := range param.Params {
		if existList, ok := filterMap[v.ConditionFilterTplId]; ok {
			filterMap[v.ConditionFilterTplId] = append(existList, v)
		} else {
			filterMap[v.ConditionFilterTplId] = []*models.PermissionTplFilterParamObj{v}
		}
		if existParamList, ok := filterParamMap[v.ConditionFilterTplId]; ok {
			for _, existFilterObj := range existParamList {
				if existFilterObj.FilterParamDefaultValue == v.FilterParamDefaultValue {
					if existFilterObj.FilterParamName != v.FilterParamName {
						filterParamNameMap[v.ConditionFilterTplId] = []string{existFilterObj.FilterParamName, v.FilterParamName}
					}
				}
			}
		}
	}
	for k, v := range filterMap {
		paramListBytes, _ := json.Marshal(v)
		actions = append(actions, &execAction{Sql: "update sys_permission_condition_filter_tpl set param_list=? where guid=?", Param: []interface{}{string(paramListBytes), k}})
	}
	err = transaction(actions)
	if err != nil {
		return
	}
	if len(filterParamNameMap) == 0 {
		return
	}
	// 更新使用了该模版参数的参数名
	var filterGuidSqlList []string
	for k, _ := range filterParamNameMap {
		filterGuidSqlList = append(filterGuidSqlList, fmt.Sprintf("param_config like '%%%s%%'", k))
	}
	var rolePermissionRows []*models.SysRoleTplPermissionTable
	updateErr := x.SQL("select id,param_config from sys_role_tpl_permission where " + strings.Join(filterGuidSqlList, " or ")).Find(&rolePermissionRows)
	if updateErr != nil {
		log.Error(nil, log.LOGGER_APP, "SaveTemplateParam query role tpl fail", zap.Error(updateErr))
		return
	}
	if len(rolePermissionRows) > 0 {
		var updateActions []*execAction
		for _, row := range rolePermissionRows {
			rowParamList := []*models.PermissionTplFilterParamObj{}
			if tmpErr := json.Unmarshal([]byte(row.ParamConfig), &rowParamList); tmpErr != nil {
				log.Warn(nil, log.LOGGER_APP, "json unmarshal role tpl param fail", zap.String("paramConfig", row.ParamConfig), zap.Error(tmpErr))
				continue
			}
			for _, v := range rowParamList {
				if matchFilter, ok := filterParamNameMap[v.ConditionFilterTplId]; ok {
					if v.FilterParamName == matchFilter[0] {
						v.FilterParamName = matchFilter[1]
					}
				}
			}
			newRowBytes, _ := json.Marshal(&rowParamList)
			updateActions = append(updateActions, &execAction{Sql: "update sys_role_tpl_permission set param_config=? where id=?", Param: []interface{}{string(newRowBytes), row.Id}})
		}
		if updateErr = transaction(updateActions); updateErr != nil {
			log.Error(nil, log.LOGGER_APP, "SaveTemplateParam update role tpl fail", zap.Error(updateErr))
		}
	}
	return
}

func getCiTypeAndAttrNameMap(ciTypeList []string) (ciTypeNameMap, ciAttrNameMap map[string]string, err error) {
	ciTypeNameMap = make(map[string]string)
	ciAttrNameMap = make(map[string]string)
	if len(ciTypeList) == 0 {
		return
	}
	filterSql, filterParam := createListParams(ciTypeList, "")
	var ciTypeRows []*models.SysCiTypeTable
	err = x.SQL("select id,display_name from sys_ci_type where id in ("+filterSql+")", filterParam...).Find(&ciTypeRows)
	if err != nil {
		err = fmt.Errorf("query ci type table fail,%s ", err.Error())
		return
	}
	for _, row := range ciTypeRows {
		ciTypeNameMap[row.Id] = row.DisplayName
	}
	var ciAttrRows []*models.SysCiTypeAttrTable
	err = x.SQL("select id,name,display_name from sys_ci_type_attr where ci_type in ("+filterSql+")", filterParam...).Find(&ciAttrRows)
	if err != nil {
		err = fmt.Errorf("query ci attr table fail,%s ", err.Error())
		return
	}
	for _, row := range ciAttrRows {
		ciAttrNameMap[row.Id] = row.DisplayName
	}
	return
}

func GetRoleTemplate(roleId string, withFilterParam bool) (result []*models.PermissionTplParam, err error) {
	result = []*models.PermissionTplParam{}
	var rolePermissionRows []*models.SysRoleTplPermissionTable
	err = x.SQL("select t1.*,t2.name as 'permission_tpl_name' from sys_role_tpl_permission t1 left join sys_permission_tpl t2 on t1.permission_tpl=t2.id where t1.role_id=?", roleId).Find(&rolePermissionRows)
	if err != nil {
		err = fmt.Errorf("query role permission table fail,%s ", err.Error())
		return
	}
	if !withFilterParam {
		for _, row := range rolePermissionRows {
			result = append(result, &models.PermissionTplParam{PermissionTplId: row.PermissionTpl, PermissionTplName: row.PermissionTplName, Params: []*models.PermissionTplFilterParamObj{}})
		}
		return
	}
	var filterCiTypeList []string
	for _, row := range rolePermissionRows {
		tmpRolePermissionObj := models.PermissionTplParam{PermissionTplId: row.PermissionTpl, PermissionTplName: row.PermissionTplName, Params: []*models.PermissionTplFilterParamObj{}}
		if row.ParamConfig != "" && row.ParamConfig != "[]" {
			tmpParamList := []*models.PermissionTplFilterParamObj{}
			if err = json.Unmarshal([]byte(row.ParamConfig), &tmpParamList); err != nil {
				err = fmt.Errorf("json unmarshal role permission param config:%s fail,%s ", row.Id, err.Error())
				return
			}
			tmpRolePermissionObj.Params = append(tmpRolePermissionObj.Params, tmpParamList...)
			for _, v := range tmpParamList {
				filterCiTypeList = append(filterCiTypeList, v.CiType)
			}
		}
		result = append(result, &tmpRolePermissionObj)
	}
	ciTypeNameMap, ciAttrNameMap, getNameErr := getCiTypeAndAttrNameMap(filterCiTypeList)
	if getNameErr != nil {
		err = getNameErr
		return
	}
	for _, resultObj := range result {
		for _, v := range resultObj.Params {
			v.CiTypeDisplayName = ciTypeNameMap[v.CiType]
			v.SensitiveAttrDisplayName = ciAttrNameMap[v.SensitiveAttr]
			v.FilterAttrDisplayName = ciAttrNameMap[v.FilterAttr]
		}
	}
	return
}

func SaveRoleTemplate(roleId string, permissionTelList []*models.PermissionTplParam) (err error) {
	var actions []*execAction
	actions = append(actions, &execAction{Sql: "delete from sys_role_tpl_permission where role_id=?", Param: []interface{}{roleId}})
	for _, permissionTplConfig := range permissionTelList {
		tmpParamBytes, tmpErr := json.Marshal(permissionTplConfig.Params)
		if tmpErr != nil {
			err = fmt.Errorf("json marshal permission tpl param fail,%s ", tmpErr.Error())
			return
		}
		actions = append(actions, &execAction{Sql: "insert into sys_role_tpl_permission(id,role_id,permission_tpl,param_config) values (?,?,?,?)", Param: []interface{}{
			fmt.Sprintf("%s__%s", roleId, permissionTplConfig.PermissionTplId), roleId, permissionTplConfig.PermissionTplId, string(tmpParamBytes),
		}})
	}
	err = transaction(actions)
	return
}

func getSimplePermissionCiTpl(permissionCiTplId string) (result *models.SysPermissionCiTplTable, err error) {
	var rows []*models.SysPermissionCiTplTable
	err = x.SQL("select * from sys_permission_ci_tpl where guid=?", permissionCiTplId).Find(&rows)
	if err != nil {
		err = fmt.Errorf("query permission ci tpl table fail,%s ", err.Error())
		return
	}
	if len(rows) == 0 {
		err = fmt.Errorf("can not find permission ci tpl with guid:%s ", permissionCiTplId)
		return
	}
	result = rows[0]
	return
}

func GetPermissionTplCondition(permissionCiTpl string) (result models.RoleAttrConditionResult, err error) {
	permissionCiTplData, tmpErr := getSimplePermissionCiTpl(permissionCiTpl)
	if tmpErr != nil {
		err = tmpErr
		return
	}
	var attrs []*models.SysCiTypeAttrTable
	err = x.SQL("select * from sys_ci_type_attr where ci_type=? and permission_usage='yes'", permissionCiTplData.CiType).Find(&attrs)
	if err != nil {
		err = fmt.Errorf("Try to get attributes with ciType:%s error:%s ", permissionCiTplData.CiType, err.Error())
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
	var conditionTable []*models.SysPermissionConditionTplTable
	err = x.SQL("select * from sys_permission_condition_tpl where permission_ci_tpl=?", permissionCiTpl).Find(&conditionTable)
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
	var filterTable []*models.SysPermissionConditionFilterTplTable
	err = x.SQL("select * from sys_permission_condition_filter_tpl where permission_condition_tpl in ('" + strings.Join(conditionGuidList, "','") + "') order by permission_condition_tpl").Find(&filterTable)
	if err != nil {
		err = fmt.Errorf("Try to get condition filter data fail,%s ", err.Error())
		return
	}
	var filterMap = make(map[string][]*models.SysPermissionConditionFilterTplTable)
	for _, filterObj := range filterTable {
		tmpExpressionList := []string{}
		if tmpUnmarshalErr := json.Unmarshal([]byte(filterObj.Expression), &tmpExpressionList); tmpUnmarshalErr == nil {
			filterObj.ConditionValueExprs = tmpExpressionList
		} else {
			filterObj.ConditionValueExprs = []string{filterObj.Expression}
		}
		filterObj.SelectValues = strings.Split(filterObj.SelectList, ",")
		if _, b := filterMap[filterObj.PermissionConditionTpl]; b {
			filterMap[filterObj.PermissionConditionTpl] = append(filterMap[filterObj.PermissionConditionTpl], filterObj)
		} else {
			filterMap[filterObj.PermissionConditionTpl] = []*models.SysPermissionConditionFilterTplTable{filterObj}
		}
	}
	for _, condition := range conditionTable {
		resultBodyObj := make(map[string]interface{})
		if cFilterList, b := filterMap[condition.Guid]; b {
			for _, filterObj := range cFilterList {
				resultBodyObj[filterObj.CiTypeAttrName] = filterObj
			}
		}
		resultBodyObj["permissionCiTpl"] = condition.PermissionCiTpl
		resultBodyObj["guid"] = condition.Guid
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

func AddPermissionTplCondition(permissionCiTpl string, conditions []*models.RoleAttrConditionObj) (affectRoles []string, err error) {
	if len(conditions) == 0 {
		err = fmt.Errorf("Param list is empty ")
		return
	}
	permissionCiTplData, getErr := getSimplePermissionCiTpl(permissionCiTpl)
	if getErr != nil {
		err = getErr
		return
	}
	conditionGuidList := guid.CreateGuidList(len(conditions))
	var filterParamList []*models.PermissionTplFilterParamObj
	var actions []*execAction
	for i, condition := range conditions {
		if len(condition.Filters) == 0 {
			err = fmt.Errorf("InputRow:%d have no attribute column ", i)
			break
		}
		tmpConditionGuid := "cond_tpl_" + conditionGuidList[i]
		actions = append(actions, &execAction{Sql: "insert into sys_permission_condition_tpl(guid,permission_ci_tpl,`insert`,`delete`,`update`,`query`,`execute`,`confirm`) values (?,?,?,?,?,?,?,?)", Param: []interface{}{tmpConditionGuid,
			permissionCiTpl, condition.Insert, condition.Delete, condition.Update, condition.Query, condition.Execution, condition.Confirm}})
		//filterGuidList := guid.CreateGuidList(len(condition.Filters))
		for _, filter := range condition.Filters {
			tmpParamList := "[]"
			tmpFilterTplGuid := "filter_tpl_" + conditionGuidList[i] + "_" + filter.CiTypeAttrName
			if filter.Expression != "" {
				tmpKeyList, tmpFilterList := getExpressionFilterParam(filter.Expression)
				if len(tmpFilterList) > 0 {
					tmpParamObjList := []*models.PermissionTplFilterParamObj{}
					for filterValueIndex, tmpFilterValue := range tmpFilterList {
						tmpFilterParamObj := models.PermissionTplFilterParamObj{
							PermissionCiTplId:       permissionCiTpl,
							ConditionTplId:          tmpConditionGuid,
							ConditionFilterTplId:    tmpFilterTplGuid,
							CiType:                  permissionCiTplData.CiType,
							SensitiveAttr:           permissionCiTplData.CiTypeAttr,
							FilterAttr:              fmt.Sprintf("%s__%s", permissionCiTplData.CiType, filter.CiTypeAttrName),
							FilterAttrName:          filter.CiTypeAttrName,
							FilterParamName:         tmpKeyList[filterValueIndex],
							FilterParamDefaultValue: tmpFilterValue,
							FilterParamValue:        tmpFilterValue,
							FilterExpression:        filter.Expression,
						}
						tmpParamObjList = append(tmpParamObjList, &tmpFilterParamObj)
						filterParamList = append(filterParamList, &tmpFilterParamObj)
					}
					tmpParamListBytes, _ := json.Marshal(&tmpParamObjList)
					tmpParamList = string(tmpParamListBytes)
				}
			}
			actions = append(actions, &execAction{Sql: "insert into sys_permission_condition_filter_tpl(guid,permission_condition_tpl,ci_type_attr,ci_type_attr_name,expression,filter_type,select_list,param_list) values (?,?,?,?,?,?,?,?)", Param: []interface{}{
				tmpFilterTplGuid, tmpConditionGuid, permissionCiTplData.CiType + models.SysTableIdConnector + filter.CiTypeAttrName, filter.CiTypeAttrName, filter.Expression, filter.FilterType, filter.SelectList, tmpParamList}})
		}
	}
	if err != nil {
		return
	}
	if err = transaction(actions); err == nil {
		affectRoles = GetPermissionTplUsedRoles(permissionCiTplData.PermissionTpl)
		if len(affectRoles) > 0 {
			if autoUpdateErr := autoUpdateRolePermissionParam(permissionCiTpl, filterParamList); autoUpdateErr != nil {
				log.Error(nil, log.LOGGER_APP, "autoUpdateRolePermissionParam fail", zap.Error(autoUpdateErr))
			}
		}
	}
	return
}

func autoUpdateRolePermissionParam(permissionCiTpl string, configParamList []*models.PermissionTplFilterParamObj) (err error) {
	var rolePermissionRows []*models.SysRoleTplPermissionTable
	err = x.SQL("select * from sys_role_tpl_permission where permission_tpl in (select permission_tpl from sys_permission_ci_tpl where guid=?)", permissionCiTpl).Find(&rolePermissionRows)
	if err != nil {
		err = fmt.Errorf("query sys role tpl permission fail,%s ", err.Error())
		return
	}
	configConditionMap := make(map[string][]*models.PermissionTplFilterParamObj) // key->conditionTplId value->[]*filterTpl
	for _, v := range configParamList {
		if existList, ok := configConditionMap[v.ConditionTplId]; ok {
			configConditionMap[v.ConditionTplId] = append(existList, v)
		} else {
			configConditionMap[v.ConditionTplId] = []*models.PermissionTplFilterParamObj{v}
		}
	}
	var actions []*execAction
	for _, row := range rolePermissionRows {
		existRoleParamList := []*models.PermissionTplFilterParamObj{}
		newRoleParamList := models.PermissionTplFilterParamSortList{}
		tmpErr := json.Unmarshal([]byte(row.ParamConfig), &existRoleParamList)
		if tmpErr != nil {
			log.Error(nil, log.LOGGER_APP, "autoUpdateRolePermissionParam json unmarshal role param config fail", zap.String("paramConfig", row.ParamConfig), zap.Error(tmpErr))
			continue
		}
		existConditionMap := make(map[string][]*models.PermissionTplFilterParamObj) // key->conditionTplId value->[]*filterTpl
		for _, existParam := range existRoleParamList {
			if existList, ok := existConditionMap[existParam.ConditionTplId]; ok {
				existConditionMap[existParam.ConditionTplId] = append(existList, existParam)
			} else {
				existConditionMap[existParam.ConditionTplId] = []*models.PermissionTplFilterParamObj{existParam}
			}
			if existParam.PermissionCiTplId != permissionCiTpl {
				newRoleParamList = append(newRoleParamList, existParam)
			}
		}
		for existConditionTpl, existFilterList := range existConditionMap {
			if configFilterList, ok := configConditionMap[existConditionTpl]; ok {
				// 更新了该条件行
				for _, configFilterObj := range configFilterList {
					matchExistAttrFlag := false
					for _, existFilterObj := range existFilterList {
						if existFilterObj.FilterAttrName == configFilterObj.FilterAttrName {
							// 判断条件的表达式是否有修改，如果有修改就用新的配置，如果没修改就用当前使用的配置
							if existFilterObj.FilterExpression == configFilterObj.FilterExpression {
								newRoleParamList = append(newRoleParamList, existFilterObj)
							} else {
								newRoleParamList = append(newRoleParamList, configFilterObj)
							}
							matchExistAttrFlag = true
							break
						}
					}
					// 如果没有找到该属性，可能是新加的权限控制列
					if !matchExistAttrFlag {
						newRoleParamList = append(newRoleParamList, configFilterObj)
					}
				}
			} else {
				// 删除了该条件行
			}
		}
		for configConditionTpl, configFilterList := range configConditionMap {
			if _, ok := existConditionMap[configConditionTpl]; !ok {
				// 角色使用模版时当时模版还没有该条件行
				newRoleParamList = append(newRoleParamList, configFilterList...)
			}
		}
		sort.Sort(newRoleParamList)
		newRoleParamBytes, _ := json.Marshal(&newRoleParamList)
		actions = append(actions, &execAction{Sql: "update sys_role_tpl_permission set param_config=? where id=?", Param: []interface{}{string(newRoleParamBytes), row.Id}})
	}
	if len(actions) > 0 {
		err = transaction(actions)
	}
	return
}

func GetPermissionTplUsedRoles(permissionTpl string) (affectRoles []string) {
	var rolePermissionRows []*models.SysRoleTplPermissionTable
	err := x.SQL("select id,role_id from sys_role_tpl_permission where permission_tpl=?", permissionTpl).Find(&rolePermissionRows)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "GetPermissionTplUsedRoles query table fail", zap.Error(err))
	} else {
		for _, row := range rolePermissionRows {
			affectRoles = append(affectRoles, row.RoleId)
		}
	}
	return
}

func EditPermissionTplCondition(permissionCiTpl string, conditions []*models.RoleAttrConditionObj) (affectRoles []string, err error) {
	if len(conditions) == 0 {
		err = fmt.Errorf("Param list is empty ")
		return
	}
	permissionCiTplData, getErr := getSimplePermissionCiTpl(permissionCiTpl)
	if getErr != nil {
		err = getErr
		return
	}
	var filterParamList []*models.PermissionTplFilterParamObj
	var actions []*execAction
	for i, condition := range conditions {
		if len(condition.Filters) == 0 {
			err = fmt.Errorf("InputRow:%d have no attribute column ", i)
			break
		}
		actions = append(actions, &execAction{Sql: "update sys_permission_condition_tpl set `insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`confirm`=? where guid=?", Param: []interface{}{condition.Insert,
			condition.Delete, condition.Update, condition.Query, condition.Execution, condition.Confirm, condition.Guid}})
		//filterGuidList := guid.CreateGuidList(len(condition.Filters))
		actions = append(actions, &execAction{Sql: "delete from sys_permission_condition_filter_tpl where permission_condition_tpl=?", Param: []interface{}{condition.Guid}})
		for _, filter := range condition.Filters {
			tmpParamList := "[]"
			tmpFilterTplGuid := strings.ReplaceAll(condition.Guid, "cond_tpl_", "filter_tpl_") + "_" + filter.CiTypeAttrName
			if filter.Expression != "" {
				tmpKeyList, tmpFilterList := getExpressionFilterParam(filter.Expression)
				if len(tmpFilterList) > 0 {
					tmpParamObjList := []*models.PermissionTplFilterParamObj{}
					for filterValueIndex, tmpFilterValue := range tmpFilterList {
						tmpFilterParamObj := models.PermissionTplFilterParamObj{
							PermissionCiTplId:       permissionCiTpl,
							ConditionTplId:          condition.Guid,
							ConditionFilterTplId:    tmpFilterTplGuid,
							CiType:                  permissionCiTplData.CiType,
							SensitiveAttr:           permissionCiTplData.CiTypeAttr,
							FilterAttr:              fmt.Sprintf("%s__%s", permissionCiTplData.CiType, filter.CiTypeAttrName),
							FilterAttrName:          filter.CiTypeAttrName,
							FilterParamName:         tmpKeyList[filterValueIndex],
							FilterParamDefaultValue: tmpFilterValue,
							FilterParamValue:        tmpFilterValue,
							FilterExpression:        filter.Expression,
						}
						tmpParamObjList = append(tmpParamObjList, &tmpFilterParamObj)
						filterParamList = append(filterParamList, &tmpFilterParamObj)
					}
					tmpParamListBytes, _ := json.Marshal(&tmpParamObjList)
					tmpParamList = string(tmpParamListBytes)
				}
			}
			actions = append(actions, &execAction{Sql: "insert into sys_permission_condition_filter_tpl(guid,permission_condition_tpl,ci_type_attr,ci_type_attr_name,expression,filter_type,select_list,param_list) values (?,?,?,?,?,?,?,?)", Param: []interface{}{
				tmpFilterTplGuid, condition.Guid, permissionCiTplData.CiType + models.SysTableIdConnector + filter.CiTypeAttrName, filter.CiTypeAttrName, filter.Expression, filter.FilterType, filter.SelectList, tmpParamList}})
		}
	}
	if err != nil {
		return
	}
	if err = transaction(actions); err == nil {
		affectRoles = GetPermissionTplUsedRoles(permissionCiTplData.PermissionTpl)
		if len(affectRoles) > 0 {
			if autoUpdateErr := autoUpdateRolePermissionParam(permissionCiTpl, filterParamList); autoUpdateErr != nil {
				log.Error(nil, log.LOGGER_APP, "autoUpdateRolePermissionParam fail", zap.Error(autoUpdateErr))
			}
		}
	}
	return
}

func DeletePermissionTplCondition(conditionGuidList []string) (err error) {
	if len(conditionGuidList) == 0 {
		return fmt.Errorf("Param list is empty ")
	}
	var conditionRows []*models.SysPermissionConditionTplTable
	err = x.SQL("select guid,permission_ci_tpl from sys_permission_condition_tpl where guid=?", conditionGuidList[0]).Find(&conditionRows)
	if err != nil {
		err = fmt.Errorf("query permission condition tpl fail,%s ", err.Error())
		return
	}
	if len(conditionRows) == 0 {
		return
	}
	var actions []*execAction
	for _, conditionGuid := range conditionGuidList {
		actions = append(actions, &execAction{Sql: "delete from sys_permission_condition_filter_tpl where permission_condition_tpl=?", Param: []interface{}{conditionGuid}})
		actions = append(actions, &execAction{Sql: "delete from sys_permission_condition_tpl where guid=?", Param: []interface{}{conditionGuid}})
	}
	err = transaction(actions)
	if err != nil {
		return
	}
	configList, getConfigErr := getPermissionCiTplParam(conditionRows[0].PermissionCiTpl)
	if getConfigErr != nil {
		log.Error(nil, log.LOGGER_APP, "DeletePermissionTplCondition getPermissionCiTplParam fail", zap.Error(getConfigErr))
		return
	}
	if autoUpdateErr := autoUpdateRolePermissionParam(conditionRows[0].PermissionCiTpl, configList); autoUpdateErr != nil {
		log.Error(nil, log.LOGGER_APP, "autoUpdateRolePermissionParam fail", zap.Error(autoUpdateErr))
	}
	return
}

func GetPermissionTplList(permissionCiTpl string) (result []*models.SysRoleCiTypeListTable, err error) {
	permissionCiTplData, tmpErr := getSimplePermissionCiTpl(permissionCiTpl)
	if tmpErr != nil {
		err = tmpErr
		return
	}
	result = []*models.SysRoleCiTypeListTable{}
	err = x.SQL("select * from sys_permission_list_tpl where permission_ci_tpl=?", permissionCiTpl).Find(&result)
	var guidList []string
	for _, v := range result {
		guidList = append(guidList, strings.Split(v.List, ",")...)
	}
	if len(guidList) > 0 {
		queryRows, queryErr := x.QueryString(fmt.Sprintf("select guid,key_name from %s where guid in ('%s')", permissionCiTplData.CiType, strings.Join(guidList, "','")))
		if queryErr != nil {
			err = fmt.Errorf("Try to query table:%s fail,%s ", permissionCiTplData.CiType, queryErr.Error())
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

func AddPermissionTplList(permissionCiTpl string, inputData []*models.SysRoleCiTypeListTable) error {
	_, err := getSimplePermissionCiTpl(permissionCiTpl)
	if err != nil {
		return err
	}
	if len(inputData) == 0 {
		return nil
	}
	guidList := guid.CreateGuidList(len(inputData))
	var actions []*execAction
	for i, data := range inputData {
		actions = append(actions, &execAction{Sql: "insert into sys_permission_list_tpl(guid,permission_ci_tpl,list,`insert`,`delete`,`update`,query,`execute`,`confirm`) values (?,?,?,?,?,?,?,?,?)", Param: []interface{}{"perm_list_" + guidList[i],
			permissionCiTpl, data.List, data.Insert, data.Delete, data.Update, data.Query, data.Execution, data.Confirm}})
	}
	return transaction(actions)
}

func EditPermissionTplList(permissionCiTpl string, inputData []*models.SysRoleCiTypeListTable) error {
	if len(inputData) == 0 {
		return nil
	}
	var actions []*execAction
	for _, data := range inputData {
		actions = append(actions, &execAction{Sql: "update sys_permission_list_tpl set `list`=?,`insert`=?,`delete`=?,`update`=?,`query`=?,`execute`=?,`confirm`=? where guid=?", Param: []interface{}{data.List,
			data.Insert, data.Delete, data.Update, data.Query, data.Execution, data.Confirm, data.Guid}})
	}
	return transaction(actions)
}

func DeletePermissionTplList(inputList []string) error {
	specSql, param := createListParams(inputList, "")
	param = append([]interface{}{"delete from sys_permission_list_tpl where guid in (" + specSql + ")"}, param...)
	_, err := x.Exec(param...)
	return err
}

func getPermissionCiTplParam(permissionCiTpl string) (configParamList []*models.PermissionTplFilterParamObj, err error) {
	var filterRows []*models.SysPermissionConditionFilterTplTable
	err = x.SQL("select guid,param_list from sys_permission_condition_filter_tpl where param_list is not null and permission_condition_tpl in (select guid from sys_permission_condition_tpl where permission_ci_tpl=?)", permissionCiTpl).Find(&filterRows)
	if err != nil {
		err = fmt.Errorf("query permission condition filter table fail,%s ", err.Error())
		return
	}
	for _, row := range filterRows {
		if row.ParamList == "" || row.ParamList == "[]" {
			continue
		}
		tmpParamList := []*models.PermissionTplFilterParamObj{}
		if err = json.Unmarshal([]byte(row.ParamList), &tmpParamList); err != nil {
			err = fmt.Errorf("json unmarshal permission tpl param filter:%s fail,%s ", row.Guid, err.Error())
			return
		}
		configParamList = append(configParamList, tmpParamList...)
	}
	return
}
