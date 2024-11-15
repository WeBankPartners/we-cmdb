package permission

import (
	"encoding/json"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
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

func bindRoleCiTypeConditionParam(c *gin.Context) (conditions []*models.RoleAttrConditionObj, err error) {
	var params []map[string]interface{}
	if bindErr := c.ShouldBindJSON(&params); bindErr != nil {
		err = bindErr
		return
	}
	for _, tmpMap := range params {
		tmpCondition := models.RoleAttrConditionObj{Insert: tmpMap["insert"].(string), Update: tmpMap["update"].(string), Delete: tmpMap["delete"].(string), Query: tmpMap["query"].(string), Execution: tmpMap["execute"].(string)}
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
				log.Logger.Warn("bindRoleCiTypeConditionParam with illegal config attr data", log.String("attr", k), log.JsonObj("data", params))
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
