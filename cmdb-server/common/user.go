package models

type SysUserTable struct {
	Id                string `json:"userId" xorm:"id"  binding:"required"`
	DisplayName       string `json:"displayName" xorm:"display_name"`
	EncryptedPassword string `json:"-" xorm:"encrypted_password"`
	Description       string `json:"description" xorm:"description"`
	IsSystem          string `json:"isSystem" xorm:"is_system"`
}

type SysRoleUserTable struct {
	Id     int    `json:"id" xorm:"id"`
	RoleId string `json:"roleId" xorm:"role_id"`
	UserId string `json:"userId" xorm:"user_id"`
}

type LoginParam struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type UpdatePasswordParam struct {
	OldPassword string `json:"oldPassword" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required"`
}

type LoginOutputObj struct {
	Expiration string `json:"expiration"`
	Token      string `json:"token"`
	TokenType  string `json:"tokenType"`
}
