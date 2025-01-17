package db

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"regexp"
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

func ValidateMenuApi(roles []string, path, method string) (legal bool) {
	// 防止ip 之类数据配置不上
	path = strings.ReplaceAll(path, ".", "")
	for _, menuApi := range models.MenuApiGlobalList {
		for _, role := range roles {
			if strings.ToLower(menuApi.Menu) == strings.ToLower(role) {
				for _, item := range menuApi.Urls {
					if strings.ToLower(item.Method) == strings.ToLower(method) {
						re := regexp.MustCompile(BuildRegexPattern(item.Url))
						if re.MatchString(path) {
							legal = true
							return
						}
					}
				}
			}
		}
	}
	return
}

func BuildRegexPattern(template string) string {
	// 将 ${variable-a.b} 替换为 (\w+)
	return regexp.MustCompile(`\$\{[\w.-]+\}`).ReplaceAllString(template, `(\w+)`)
}
