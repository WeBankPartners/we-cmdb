package permission

import (
	"fmt"
	"github.com/WeBankPartners/go-common-lib/token"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"time"
)

func GetUserList(c *gin.Context) {
	rowData, err := db.GetUserList()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func UserCreate(c *gin.Context) {
	var param models.SysUserTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.UserCreate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	password, err := db.UserPasswordReset(param.Id, "", "")
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, password)
	}
}

func UserUpdate(c *gin.Context) {
	var param models.SysUserTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.UserUpdate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func UserDelete(c *gin.Context) {
	userId := c.Query("user_id")
	err := db.UserDelete(userId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetUserRole(c *gin.Context) {
	userId := c.Query("user_id")
	if userId == "" {
		//middleware.ReturnParamEmptyError(c, "user_id")
		//return
		userId = middleware.GetRequestUser(c)
	}
	rowData, err := db.GetUserRole(userId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func UserPasswordReset(c *gin.Context) {
	var err error
	var param models.LoginParam
	c.ShouldBindJSON(&param)
	if param.Username == "" {
		middleware.ReturnParamEmptyError(c, "username")
		return
	}
	legalFlag := false
	for _, role := range middleware.GetRequestRoles(c) {
		if role == models.AdminRole {
			legalFlag = true
			break
		}
	}
	if !legalFlag {
		middleware.ReturnParamValidateError(c, fmt.Errorf("permission illegal "))
		return
	}
	rowData, err := db.UserPasswordReset(param.Username, "", "")
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func UserPasswordUpdate(c *gin.Context) {
	var param models.UpdatePasswordParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	rowData, err := db.UserPasswordReset(middleware.GetRequestUser(c), param.NewPassword, param.OldPassword)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func Login(c *gin.Context) {
	var param models.LoginParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	userMessage, err := db.Login(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	permissions, err := db.GetUserTokenPermission(userMessage.Id)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	nowTime := time.Now().Unix()
	var result []*models.LoginOutputObj
	accessToken, err := token.CreateJwtToken(userMessage.Id, models.Config.Wecube.JwtSigningKey, nowTime+models.Config.Auth.ExpireSec, permissions)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	result = append(result, &models.LoginOutputObj{Expiration: fmt.Sprintf("%d", nowTime+models.Config.Auth.ExpireSec), TokenType: "accessToken", Token: accessToken})
	refreshToken, _ := token.CreateJwtToken(userMessage.Id, models.Config.Wecube.JwtSigningKey, nowTime+models.Config.Auth.FreshTokenExpire, []string{})
	result = append(result, &models.LoginOutputObj{Expiration: fmt.Sprintf("%d", nowTime+models.Config.Auth.FreshTokenExpire), TokenType: "refreshToken", Token: refreshToken})
	middleware.ReturnData(c, result)
}

func RefreshToken(c *gin.Context) {
	userId := middleware.GetRequestUser(c)
	permissions, err := db.GetUserTokenPermission(userId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	nowTime := time.Now().Unix()
	var result []*models.LoginOutputObj
	accessToken, err := token.CreateJwtToken(userId, models.Config.Wecube.JwtSigningKey, nowTime+models.Config.Auth.ExpireSec, permissions)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	result = append(result, &models.LoginOutputObj{Expiration: fmt.Sprintf("%d", nowTime+models.Config.Auth.ExpireSec), TokenType: "accessToken", Token: accessToken})
	refreshToken, _ := token.CreateJwtToken(userId, models.Config.Wecube.JwtSigningKey, nowTime+models.Config.Auth.FreshTokenExpire, []string{})
	result = append(result, &models.LoginOutputObj{Expiration: fmt.Sprintf("%d", nowTime+models.Config.Auth.FreshTokenExpire), TokenType: "refreshToken", Token: refreshToken})
	middleware.ReturnData(c, result)
}
