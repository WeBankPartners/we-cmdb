package db

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"strings"
)

func GetRoleMenu(role string) (rowData []*models.SysMenuTable, err error) {
	role = strings.ReplaceAll(role, ",", "','")
	rowData = []*models.SysMenuTable{}
	err = x.SQL("select distinct t2.* from sys_role_menu t1 left join sys_menu t2 on t1.menu_guid=t2.id where t1.role_guid in ('" + role + "')").Find(&rowData)
	return
}

func GetUserMenu(user string) (rowData []*models.SysMenuTable, err error) {
	var parentRowData []*models.SysMenuTable
	var paramMenuMap = make(map[string]*models.SysMenuTable)
	x.SQL("select * from sys_menu where parent is null").Find(&parentRowData)
	for _, v := range parentRowData {
		paramMenuMap[v.Id] = v
	}
	rowData = []*models.SysMenuTable{}
	err = x.SQL("select distinct t2.* from sys_role_menu t1 left join sys_menu t2 on t1.menu_guid=t2.id where t2.parent is not null and t1.role_guid in (select role_id from sys_role_user where user_id=?)", user).Find(&rowData)
	if err != nil {
		return
	}
	for _, v := range rowData {
		if _, b := paramMenuMap[v.Parent]; b {
			rowData = append(rowData, paramMenuMap[v.Parent])
			delete(paramMenuMap, v.Parent)
		}
	}
	return
}

func GetMenuList() (rowData []*models.SysMenuTable, err error) {
	err = x.SQL("select * from sys_menu").Find(&rowData)
	return
}

func UpdateRoleMenu(param models.UpdateRoleMenuParam) error {
	var actions []*execAction
	actions = append(actions, &execAction{Sql: "delete from sys_role_menu where role_guid=?", Param: []interface{}{param.RoleName}})
	for _, menu := range param.MenuList {
		actions = append(actions, &execAction{Sql: "insert into sys_role_menu value (?,?,?)", Param: []interface{}{param.RoleName + models.SysTableIdConnector + menu, param.RoleName, menu}})
	}
	return transaction(actions)
}

func ValidateMenuApi(roles []string, apiUrl, method string) (legal bool, err error) {
	legal = false
	var roleMenuTable []*models.SysRoleMenuTable
	err = x.SQL("select * from sys_role_menu where role_guid in ('" + strings.Join(roles, "','") + "')").Find(&roleMenuTable)
	if err != nil {
		err = fmt.Errorf("Try to validate api permission fail,%s ", err.Error())
		return
	}
	if len(roleMenuTable) == 0 {
		legal = false
		return
	}
	if method == "GET" && strings.Contains(apiUrl, "?") {
		apiUrl = apiUrl[:strings.Index(apiUrl, "?")]
	}
	apiUrl = apiUrl[len(models.UrlPrefix):]
	for _, menuApi := range models.MenuApiGlobalList {
		for _, roleMenu := range roleMenuTable {
			if menuApi.Menu == roleMenu.MenuGuid {
				for _, api := range menuApi.Urls {
					if api.Method == method && api.Url == apiUrl {
						legal = true
						break
					}
				}
				break
			}
		}
		if legal {
			break
		}
	}
	return
}
