package db

import (
	"encoding/base64"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common-lib/cipher"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"strings"
)

func GetUserList() (rowData []*models.SysUserTable, err error) {
	err = x.SQL("select * from sys_user").Find(&rowData)
	return
}

func UserCreate(user models.SysUserTable) error {
	_, err := x.Exec("insert into sys_user(id,display_name,description,is_system) value (?,?,?,?)", user.Id, user.DisplayName, user.Description, "no")
	return err
}

func UserUpdate(user models.SysUserTable) error {
	_, err := x.Exec("update sys_user set display_name=?,description=? where id=?", user.DisplayName, user.Description, user.Id)
	return err
}

func UserDelete(userId string) error {
	var userTable []*models.SysUserTable
	err := x.SQL("select * from sys_user where id=?", userId).Find(&userTable)
	if err != nil {
		return fmt.Errorf("Try to query user fail,%s ", err.Error())
	}
	if len(userTable) == 0 {
		return nil
	}
	if userTable[0].IsSystem == "yes" {
		return fmt.Errorf("Warnning: system user can not delete ")
	}
	_, err = x.Exec("delete from sys_role_user where user_id=?", userId)
	if err != nil {
		return err
	}
	_, err = x.Exec("delete from sys_user where id=?", userId)
	return err
}

func GetUserRole(userId string) (rowData []*models.SysRoleTable, err error) {
	rowData = []*models.SysRoleTable{}
	err = x.SQL("select * from sys_role where id in (select role_id from sys_role_user where user_id=?)", userId).Find(&rowData)
	return
}

func UserPasswordReset(userId, pwd, oldPwd string) (password string, err error) {
	password = pwd
	if password == "" {
		password = cipher.CreateRandomPassword()
	} else {
		passwordByte, _ := base64.StdEncoding.DecodeString(pwd)
		password = string(passwordByte)
		oldPasswordByte, _ := base64.StdEncoding.DecodeString(oldPwd)
		queryUser, tmpErr := x.QueryString("select * from sys_user where id=?", userId)
		if tmpErr != nil {
			err = fmt.Errorf("Try to query exist user message fail,%s ", tmpErr.Error())
			return
		}
		if len(queryUser) == 0 {
			err = fmt.Errorf("No user name:%s ", userId)
			return
		}
		enCodeOldPassword, encodeErr := cipher.AesEnPassword(models.Config.Auth.PasswordSeed, string(oldPasswordByte))
		if encodeErr != nil {
			err = fmt.Errorf("Try to encode old password fail,%s ", encodeErr.Error())
			return
		}
		if enCodeOldPassword != queryUser[0]["encrypted_password"] {
			err = fmt.Errorf("Old password validate fail ")
			return
		}
	}
	enCodePassword, err := cipher.AesEnPassword(models.Config.Auth.PasswordSeed, password)
	if err != nil {
		err = fmt.Errorf("Try to aes encode password fail,%s ", err.Error())
		return "", err
	}
	_, err = x.Exec("update sys_user set encrypted_password=? where id=?", enCodePassword, userId)
	return password, err
}

func Login(param models.LoginParam) (userMessage models.SysUserTable, err error) {
	var userTable []*models.SysUserTable
	err = x.SQL("select * from sys_user where id=?", param.Username).Find(&userTable)
	if err != nil {
		err = fmt.Errorf("Try to query database user table fail,%s ", err.Error())
		return
	}
	if len(userTable) == 0 {
		err = fmt.Errorf("Can not find user:%s ", param.Username)
		return
	}
	inputPassword, decodeErr := base64.StdEncoding.DecodeString(param.Password)
	if decodeErr != nil {
		err = fmt.Errorf("Try to decode password fail,%s ", decodeErr.Error())
		return
	}
	enCodePassword, encodeErr := cipher.AesEnPassword(models.Config.Auth.PasswordSeed, string(inputPassword))
	if encodeErr != nil {
		err = fmt.Errorf("Try to encode password fail,%s ", encodeErr.Error())
		return
	}
	if enCodePassword == userTable[0].EncryptedPassword {
		userMessage = *userTable[0]
		userMessage.EncryptedPassword = ""
	} else {
		log.Logger.Debug("Password error", log.String("inputPwd", string(inputPassword)), log.String("enCodePwd", enCodePassword), log.String("dbPwd", userTable[0].EncryptedPassword))
		err = fmt.Errorf("Password error ")
	}
	return
}

func GetUserTokenPermission(userId string) (permissions []string, err error) {
	roles, err := GetUserRole(userId)
	if err != nil {
		err = fmt.Errorf("Try to get user roles fail,%s ", err.Error())
		return
	}
	var roleList []string
	for _, role := range roles {
		roleList = append(roleList, role.Id)
	}
	var roleMenuTable []*models.SysRoleMenuTable
	err = x.SQL("select distinct menu_guid from sys_role_menu where role_guid in ('" + strings.Join(roleList, "','") + "')").Find(&roleMenuTable)
	if err != nil {
		err = fmt.Errorf("Try to get user menus fail,%s ", err.Error())
		return
	}
	for _, menu := range roleMenuTable {
		roleList = append(roleList, menu.MenuGuid)
	}
	permissions = roleList
	return
}
