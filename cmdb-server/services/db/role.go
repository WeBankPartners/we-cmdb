package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"io/ioutil"
	"net/http"
	"strings"
)

func GetRoleList() (rowData []*models.SysRoleTable, err error) {
	err = x.SQL("select * from sys_role").Find(&rowData)
	return
}

func RoleCreate(role models.SysRoleTable) error {
	_, err := x.Exec("insert into sys_role(id,description,is_system) value (?,?,?)", role.Id, role.Description, "no")
	if err != nil {
		err = fmt.Errorf("Try to insert new row to database fail,%s ", err)
		return err
	}
	var ciTypeTable []*models.SysCiTypeTable
	err = x.SQL("select id from sys_ci_type where status='created'").Find(&ciTypeTable)
	if err != nil {
		err = fmt.Errorf("Try to create roleCiType data fail,%s ", err.Error())
		return err
	}
	if len(ciTypeTable) == 0 {
		return nil
	}
	var actions []*execAction
	guidList := guid.CreateGuidList(len(ciTypeTable))
	for i, ciType := range ciTypeTable {
		actions = append(actions, &execAction{Sql: "insert into sys_role_ci_type(guid,role_id,ci_type) value (?,?,?)", Param: []interface{}{"role_ci_" + guidList[i], role.Id, ciType.Id}})
	}
	err = transaction(actions)
	return err
}

func RoleUpdate(role models.SysRoleTable) error {
	_, err := x.Exec("update sys_role set description=? where id=?", role.Description, role.Id)
	return err
}

func RoleDelete(roleId string) error {
	var roleTable []*models.SysRoleTable
	err := x.SQL("select * from sys_role where id=?", roleId).Find(&roleTable)
	if err != nil {
		return fmt.Errorf("Try to query role data fail,%s ", err.Error())
	}
	if len(roleTable) == 0 {
		return nil
	}
	if roleTable[0].IsSystem == "yes" {
		return nil
	}
	var roleCiTypeTable []*models.SysRoleCiTypeTable
	err = x.SQL("select guid from sys_role_ci_type where role_id=?", roleId).Find(&roleCiTypeTable)
	if err != nil {
		err = fmt.Errorf("Try to get roleCiType data fail,%s ", err.Error())
		return err
	}
	var actions []*execAction
	if len(roleCiTypeTable) > 0 {
		roleCiTypeGuidList := []string{}
		for _, roleCiType := range roleCiTypeTable {
			roleCiTypeGuidList = append(roleCiTypeGuidList, roleCiType.Guid)
		}
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type_condition_filter where role_ci_type_condition in (select guid from sys_role_ci_type_condition where role_ci_type in ('" + strings.Join(roleCiTypeGuidList, "','") + "'))"})
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type_condition where role_ci_type in ('" + strings.Join(roleCiTypeGuidList, "','") + "')"})
		actions = append(actions, &execAction{Sql: "delete from sys_role_ci_type where guid in ('" + strings.Join(roleCiTypeGuidList, "','") + "')"})
	}
	actions = append(actions, &execAction{Sql: "delete from sys_role_user where role_id=?", Param: []interface{}{roleId}})
	actions = append(actions, &execAction{Sql: "delete from sys_role_menu where role_guid=?", Param: []interface{}{roleId}})
	actions = append(actions, &execAction{Sql: "delete from sys_role_report where `role`=?", Param: []interface{}{roleId}})
	actions = append(actions, &execAction{Sql: "delete from sys_role_view where `view`=?", Param: []interface{}{roleId}})
	err = transaction(actions)
	if err != nil {
		err = fmt.Errorf("Try to delete role dependence data fail,%s ", err)
		return err
	}
	_, err = x.Exec("delete from sys_role where id=?", roleId)
	if err != nil {
		err = fmt.Errorf("Try to delete role from database fail,%s ", err)
		return err
	}
	return err
}

func GetRoleUser(roleId string) (rowData []*models.SysUserTable, err error) {
	rowData = []*models.SysUserTable{}
	err = x.SQL("select * from sys_user where id in (select user_id from sys_role_user where role_id=?)", roleId).Find(&rowData)
	return
}

func UpdateRoleUser(params []*models.UpdateRoleUserParam) error {
	var actions []*execAction
	for _, param := range params {
		actions = append(actions, &execAction{Sql: "delete from sys_role_user where role_id=?", Param: []interface{}{param.RoleName}})
		if len(param.UserList) == 0 {
			continue
		}
		valueList := []string{}
		execParams := []interface{}{}
		for _, user := range param.UserList {
			valueList = append(valueList, fmt.Sprintf("(?,?,?)"))
			execParams = append(execParams, param.RoleName+models.SysTableIdConnector+user, param.RoleName, user)
		}
		actions = append(actions, &execAction{Sql: "insert into sys_role_user(id,role_id,user_id) values " + strings.Join(valueList, ","), Param: execParams})
	}
	return transaction(actions)
}

func SyncCoreRole() {
	if models.CoreToken.BaseUrl == "" {
		return
	}
	request, err := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/platform/v1/roles/retrieve", models.CoreToken.BaseUrl), strings.NewReader(""))
	if err != nil {
		log.Logger.Error("Get core role key new request fail", log.Error(err))
		return
	}
	request.Header.Set("Authorization", models.CoreToken.GetCoreToken())
	res, err := http.DefaultClient.Do(request)
	if err != nil {
		log.Logger.Error("Get core role key ctxhttp request fail", log.Error(err))
		return
	}
	b, _ := ioutil.ReadAll(res.Body)
	res.Body.Close()
	//log.Logger.Debug("Get core role response", log.String("body", string(b)))
	var result models.CoreRoleDto
	err = json.Unmarshal(b, &result)
	if err != nil {
		log.Logger.Error("Get core role key json unmarshal result", log.Error(err))
		return
	}
	if len(result.Data) == 0 {
		log.Logger.Warn("Get core role key fail with no data")
		return
	}
	var roleTable, addRoleList, delRoleList, updateRoleList []*models.SysRoleTable
	err = x.SQL("select * from sys_role").Find(&roleTable)
	if err != nil {
		log.Logger.Error("Try to sync core role fail", log.Error(err))
		return
	}
	for _, v := range result.Data {
		existFlag := false
		for _, vv := range roleTable {
			if strings.ToLower(v.Name) == strings.ToLower(vv.Id) {
				if vv.Description != v.DisplayName {
					updateRoleList = append(updateRoleList, &models.SysRoleTable{Id: v.Name, Description: v.DisplayName})
				}
				existFlag = true
				break
			}
		}
		if !existFlag {
			addRoleList = append(addRoleList, &models.SysRoleTable{Id: v.Name, Description: v.DisplayName})
		}
	}
	for _, v := range roleTable {
		existFlag := false
		for _, vv := range result.Data {
			if strings.ToLower(v.Id) == strings.ToLower(vv.Name) {
				existFlag = true
				break
			}
		}
		if !existFlag {
			delRoleList = append(delRoleList, &models.SysRoleTable{Id: v.Id})
		}
	}
	if len(addRoleList) > 0 {
		for _, role := range addRoleList {
			err = RoleCreate(*role)
			if err != nil {
				log.Logger.Error("Try to add core role to local fail", log.Error(err))
			}
		}
	}
	if len(updateRoleList) > 0 {
		for _, role := range updateRoleList {
			err = RoleUpdate(*role)
			if err != nil {
				log.Logger.Error("Try to update core role to local fail", log.Error(err))
			}
		}
	}
	if len(delRoleList) > 0 {
		for _, role := range delRoleList {
			err = RoleDelete(role.Id)
			if err != nil {
				log.Logger.Error("Try to delete local role from core data fail", log.Error(err))
			}
		}
	}
}
