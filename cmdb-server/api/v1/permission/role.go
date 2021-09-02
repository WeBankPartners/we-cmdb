package permission

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
)

func GetRoleList(c *gin.Context) {
	db.SyncCoreRole()
	rowData, err := db.GetRoleList()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func RoleCreate(c *gin.Context) {
	var param models.SysRoleTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.RoleCreate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func RoleUpdate(c *gin.Context) {
	var param models.SysRoleTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.RoleUpdate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func RoleDelete(c *gin.Context) {
	roleId := c.Query("role_id")
	err := db.RoleDelete(roleId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetRoleUser(c *gin.Context) {
	roleId := c.Query("role_id")
	if roleId == "" {
		middleware.ReturnParamEmptyError(c, "role_id")
		return
	}
	rowData, err := db.GetRoleUser(roleId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func UpdateRoleUser(c *gin.Context) {
	var params []*models.UpdateRoleUserParam
	if err := c.ShouldBindJSON(&params); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.UpdateRoleUser(params)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}
