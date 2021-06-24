package models

type SysRoleTable struct {
	Id          string `json:"roleName" xorm:"id" binding:"required"`
	Description string `json:"description" xorm:"description"`
	IsSystem    string `json:"isSystem" xorm:"is_system"`
}

type SysMenuTable struct {
	Id          string `json:"id" xorm:"id"`
	DisplayName string `json:"displayName" xorm:"display_name"`
	SeqNo       int    `json:"seqNo" xorm:"seq_no"`
	Parent      string `json:"parent" xorm:"parent"`
	IsActive    string `json:"isActive" xorm:"is_active"`
}

type SysRoleMenuTable struct {
	Id       string `json:"id" xorm:"id"`
	RoleGuid string `json:"roleName" xorm:"role_guid"`
	MenuGuid string `json:"menuId" xorm:"menu_guid"`
}

type UpdateRoleMenuParam struct {
	RoleName string   `json:"roleName"`
	MenuList []string `json:"menuList"`
}

type UpdateRoleUserParam struct {
	RoleName string   `json:"roleName"`
	UserList []string `json:"userList"`
}

type MenuApiMapObj struct {
	Menu string           `json:"menu"`
	Urls []*MenuApiUrlObj `json:"urls"`
}

type MenuApiUrlObj struct {
	Url    string `json:"url"`
	Method string `json:"method"`
}
