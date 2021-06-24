package permission

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
)

func GetRoleMenu(c *gin.Context) {
	rowData, err := db.GetRoleMenu(c.Query("role_id"))
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func GetUserMenu(c *gin.Context) {
	if !models.Config.Auth.Enable {
		GetMenuList(c)
		return
	}
	rowData, err := db.GetUserMenu(middleware.GetRequestUser(c))
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func GetMenuList(c *gin.Context) {
	rowData, err := db.GetMenuList()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func UpdateRoleMenu(c *gin.Context) {
	var param models.UpdateRoleMenuParam
	// Check context role,if SUPER_ADMIN
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.UpdateRoleMenu(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}
