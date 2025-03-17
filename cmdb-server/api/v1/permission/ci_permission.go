package permission

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"strings"
)

func GetRoleCiPermission(c *gin.Context) {
	roleId := c.Param("roleId")
	db.AutoCreateRoleCiTypeDataByRole(roleId)
	query := models.RolePermissionQuery{Role: roleId}
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

func getPermissionValue(permissionMap map[string]interface{}, key string) string {
	if permissionMap != nil {
		if v, b := permissionMap[key]; b {
			if fmt.Sprintf("%s", v) == "Y" {
				return "Y"
			}
		}
	}
	return "N"
}

func bindRoleCiTypeConditionParam(c *gin.Context) (conditions []*models.RoleAttrConditionObj, err error) {
	var params []map[string]interface{}
	if bindErr := c.ShouldBindJSON(&params); bindErr != nil {
		err = bindErr
		return
	}
	for _, tmpMap := range params {
		tmpCondition := models.RoleAttrConditionObj{Insert: getPermissionValue(tmpMap, "insert"), Update: getPermissionValue(tmpMap, "update"), Delete: getPermissionValue(tmpMap, "delete"), Query: getPermissionValue(tmpMap, "query"), Execution: getPermissionValue(tmpMap, "execute")}
		if confirmInputValue, ok := tmpMap["confirm"]; ok {
			tmpCondition.Confirm = confirmInputValue.(string)
		} else {
			tmpCondition.Confirm = "N"
		}
		if _, b := tmpMap["roleCiType"]; b {
			tmpCondition.RoleCiTypeId = tmpMap["roleCiType"].(string)
		}
		if _, b := tmpMap["roleConditionGuid"]; b {
			tmpCondition.Guid = tmpMap["roleConditionGuid"].(string)
		}
		if _, b := tmpMap["permissionCiTpl"]; b {
			tmpCondition.PermissionCiTplId = tmpMap["permissionCiTpl"].(string)
		}
		if _, b := tmpMap["guid"]; b {
			tmpCondition.Guid = tmpMap["guid"].(string)
		}
		for k, v := range tmpMap {
			if k == "insert" || k == "update" || k == "delete" || k == "query" || k == "execute" || k == "confirm" || k == "roleCiType" || k == "roleConditionGuid" {
				continue
			}
			if tmpValueMap, isMap := v.(map[string]interface{}); isMap {
				if selectValueList, isSelect := tmpValueMap["conditionValueSelects"]; isSelect {
					tmpValueStringList := []string{}
					for _, selectItem := range selectValueList.([]interface{}) {
						tmpValueStringList = append(tmpValueStringList, selectItem.(string))
					}
					tmpFilterObj := models.SysRoleCiTypeConditionFilterTable{CiTypeAttrName: k, FilterType: models.FilterTypeSelectList, SelectList: strings.Join(tmpValueStringList, ",")}
					tmpCondition.Filters = append(tmpCondition.Filters, &tmpFilterObj)
				} else {
					if expressionValue, isExpression := tmpValueMap["expression"]; isExpression {
						tmpExpressionStringList := []string{}
						if tmpExpressionList, isMultiExpression := expressionValue.([]interface{}); isMultiExpression {
							for _, expressionItem := range tmpExpressionList {
								tmpExpressionStringList = append(tmpExpressionStringList, expressionItem.(string))
							}
						} else {
							tmpExpressionStringList = append(tmpExpressionStringList, expressionValue.(string))
						}
						tmpExpressionDataValueBytes, _ := json.Marshal(tmpExpressionStringList)
						tmpFilterObj := models.SysRoleCiTypeConditionFilterTable{Expression: string(tmpExpressionDataValueBytes), CiTypeAttrName: k, FilterType: models.FilterTypeExpression}
						tmpCondition.Filters = append(tmpCondition.Filters, &tmpFilterObj)
					}
				}
			} else {
				log.Warn(nil, log.LOGGER_APP, "bindRoleCiTypeConditionParam with illegal config attr data", zap.String("attr", k), log.JsonObj("data", params))
			}
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

func ListTemplate(c *gin.Context) {
	result, err := db.ListTemplate()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func SaveTemplate(c *gin.Context) {
	var param models.PermissionTplData
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	param.Operator = middleware.GetRequestUser(c)
	err := db.SaveTemplate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		result, getErr := db.GetTemplate(param.Id)
		if getErr != nil {
			err = fmt.Errorf("get template return data fail,%s ", getErr.Error())
			middleware.ReturnServerHandleError(c, err)
		} else {
			middleware.ReturnData(c, result)
		}
	}
}

func GetTemplate(c *gin.Context) {
	permissionTplId := c.Query("permissionTplId")
	result, err := db.GetTemplate(permissionTplId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func DeleteTemplate(c *gin.Context) {
	permissionTplId := c.Query("permissionTplId")
	err := db.DeleteTemplate(permissionTplId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetTemplateParam(c *gin.Context) {
	permissionTplId := c.Query("permissionTplId")
	result, err := db.GetTemplateParam(permissionTplId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func SaveTemplateParam(c *gin.Context) {
	var param models.PermissionTplParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.SaveTemplateParam(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetRoleTemplate(c *gin.Context) {
	roleId := c.Param("roleId")
	withFilterParamFlag := false
	if c.Query("withFilterParam") == "true" {
		withFilterParamFlag = true
	}
	result, err := db.GetRoleTemplate(roleId, withFilterParamFlag)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func SaveRoleTemplate(c *gin.Context) {
	roleId := c.Param("roleId")
	var param []*models.PermissionTplParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.SaveRoleTemplate(roleId, param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetTemplateCiTypeCondition(c *gin.Context) {
	roleCiType := c.Param("permissionCiTpl")
	if roleCiType == "" {
		middleware.ReturnParamEmptyError(c, "permissionCiTpl")
		return
	}
	result, err := db.GetPermissionTplCondition(roleCiType)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func AddTemplateCiTypeCondition(c *gin.Context) {
	permissionCiTpl := c.Param("permissionCiTpl")
	conditions, err := bindRoleCiTypeConditionParam(c)
	if err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	affectRoles := []string{}
	affectRoles, err = db.AddPermissionTplCondition(permissionCiTpl, conditions)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, affectRoles)
	}
}

func EditTemplateCiTypeCondition(c *gin.Context) {
	roleCiType := c.Param("permissionCiTpl")
	conditions, err := bindRoleCiTypeConditionParam(c)
	if err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	affectRoles := []string{}
	affectRoles, err = db.EditPermissionTplCondition(roleCiType, conditions)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, affectRoles)
	}
}

func DeleteTemplateCiTypeCondition(c *gin.Context) {
	ids := c.Query("ids")
	param := strings.Split(ids, ",")
	if len(param) == 0 {
		middleware.ReturnParamEmptyError(c, "ids")
		return
	}
	err := db.DeletePermissionTplCondition(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func GetTemplateCiTypeList(c *gin.Context) {
	roleCiType := c.Param("permissionCiTpl")
	if roleCiType == "" {
		middleware.ReturnParamEmptyError(c, "permissionCiTpl")
		return
	}
	result, err := db.GetPermissionTplList(roleCiType)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func AddTemplateCiTypeList(c *gin.Context) {
	roleCiType := c.Param("permissionCiTpl")
	var inputData []*models.SysRoleCiTypeListTable
	if err := c.ShouldBindJSON(&inputData); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.AddPermissionTplList(roleCiType, inputData)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func EditTemplateCiTypeList(c *gin.Context) {
	roleCiType := c.Param("permissionCiTpl")
	var inputData []*models.SysRoleCiTypeListTable
	if err := c.ShouldBindJSON(&inputData); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.EditPermissionTplList(roleCiType, inputData)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func DeleteTemplateCiTypeList(c *gin.Context) {
	ids := c.Query("ids")
	param := strings.Split(ids, ",")
	if len(param) == 0 {
		middleware.ReturnParamEmptyError(c, "ids")
		return
	}
	err := db.DeletePermissionTplList(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}
