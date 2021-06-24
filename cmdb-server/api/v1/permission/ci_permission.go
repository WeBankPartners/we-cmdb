package permission

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"strings"
)

func GetRoleCiPermission(c *gin.Context) {
	query := models.RolePermissionQuery{Role: c.Param("roleId")}
	err := db.GetRoleCiPermission(&query)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, query)
	}
}

func UpdateRoleCiPermission(c *gin.Context) {
	var params []*models.CiTypePermissionObj
	if err := c.ShouldBindJSON(&params); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.UpdateRoleCiPermission(c.Param("roleId"), params)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetRoleCiTypeCondition(c *gin.Context) {
	roleCiType := c.Param("roleCiType")
	if roleCiType == "" {
		middleware.ReturnParamEmptyError(c, "roleCiType")
		return
	}
	result, err := db.GetRoleCiTypeCondition(roleCiType)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func AddRoleCiTypeCondition(c *gin.Context) {
	roleCiType := c.Param("roleCiType")
	conditions, err := bindRoleCiTypeConditionParam(c)
	if err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err = db.AddRoleCiTypeCondition(roleCiType, conditions)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func EditRoleCiTypeCondition(c *gin.Context) {
	roleCiType := c.Param("roleCiType")
	conditions, err := bindRoleCiTypeConditionParam(c)
	if err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err = db.EditRoleCiTypeCondition(roleCiType, conditions)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func DeleteRoleCiTypeCondition(c *gin.Context) {
	ids := c.Query("ids")
	param := strings.Split(ids, ",")
	if len(param) == 0 {
		middleware.ReturnParamEmptyError(c, "ids")
		return
	}
	err := db.DeleteRoleCiTypeCondition(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func bindRoleCiTypeConditionParam(c *gin.Context) (conditions []*models.RoleAttrConditionObj, err error) {
	var params []map[string]interface{}
	if bindErr := c.ShouldBindJSON(&params); bindErr != nil {
		err = bindErr
		return
	}
	for _, tmpMap := range params {
		tmpCondition := models.RoleAttrConditionObj{Insert: tmpMap["insert"].(string), Update: tmpMap["update"].(string), Delete: tmpMap["delete"].(string), Query: tmpMap["query"].(string), Execution: tmpMap["execute"].(string)}
		if _, b := tmpMap["roleCiType"]; b {
			tmpCondition.RoleCiTypeId = tmpMap["roleCiType"].(string)
		}
		if _, b := tmpMap["roleConditionGuid"]; b {
			tmpCondition.Guid = tmpMap["roleConditionGuid"].(string)
		}
		for k, v := range tmpMap {
			if k == "insert" || k == "update" || k == "delete" || k == "query" || k == "execute" || k == "roleCiType" || k == "roleConditionGuid" {
				continue
			}
			tmpValueMap := v.(map[string]interface{})
			tmpFilterObj := models.SysRoleCiTypeConditionFilterTable{Expression: tmpValueMap["expression"].(string), CiTypeAttrName: k}
			tmpCondition.Filters = append(tmpCondition.Filters, &tmpFilterObj)
		}
		conditions = append(conditions, &tmpCondition)
	}
	return
}

func GetRoleCiTypeList(c *gin.Context) {
	roleCiType := c.Param("roleCiType")
	if roleCiType == "" {
		middleware.ReturnParamEmptyError(c, "roleCiType")
		return
	}
	result, err := db.GetRoleCiTypeList(roleCiType)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func AddRoleCiTypeList(c *gin.Context) {
	roleCiType := c.Param("roleCiType")
	var inputData []*models.SysRoleCiTypeListTable
	if err := c.ShouldBindJSON(&inputData); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.AddRoleCiTypeList(roleCiType, inputData)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func EditRoleCiTypeList(c *gin.Context) {
	roleCiType := c.Param("roleCiType")
	var inputData []*models.SysRoleCiTypeListTable
	if err := c.ShouldBindJSON(&inputData); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.EditRoleCiTypeList(roleCiType, inputData)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func DeleteRoleCiTypeList(c *gin.Context) {
	ids := c.Query("ids")
	param := strings.Split(ids, ",")
	if len(param) == 0 {
		middleware.ReturnParamEmptyError(c, "ids")
		return
	}
	err := db.DeleteRoleCiTypeList(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}
