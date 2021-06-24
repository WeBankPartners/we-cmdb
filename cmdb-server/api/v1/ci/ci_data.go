package ci

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"reflect"
	"strconv"
)

func DataQuery(c *gin.Context) {
	//Param validate
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	// Permissions
	permissions, tmpErr := db.GetRoleCiDataPermission(middleware.GetRequestRoles(c), c.Param("ciType"))
	if tmpErr != nil {
		middleware.ReturnDataPermissionError(c, tmpErr)
		return
	}
	legalGuidList, tmpErr := db.GetCiDataPermissionGuidList(&permissions, "query")
	if tmpErr != nil {
		middleware.ReturnDataPermissionError(c, tmpErr)
		return
	}
	if !legalGuidList.Enable && len(legalGuidList.GuidList) == 0 {
		middleware.ReturnDataPermissionDenyError(c)
		return
	}
	//Query database
	pageInfo, rowData, err := db.CiDataQuery(c.Param("ciType"), &param, &legalGuidList, false)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(rowData) == 0 {
			rowData = []map[string]interface{}{}
		}
		middleware.ReturnPageData(c, pageInfo, rowData)
	}
}

func DataOperation(c *gin.Context) {
	var interfaceParam []map[string]interface{}
	var err error
	if err = c.ShouldBindJSON(&interfaceParam); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if len(interfaceParam) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Input data empty "))
		return
	}
	var param []models.CiDataMapObj
	for i, inputRow := range interfaceParam {
		stringMap := make(map[string]string)
		for k, v := range inputRow {
			if v == nil {
				continue
			}
			valueType := reflect.TypeOf(v).String()
			if valueType == "string" {
				stringMap[k] = v.(string)
			} else if valueType == "int" {
				stringMap[k] = fmt.Sprintf("%d", v.(int))
			} else {
				tmpJsonByte, tmpErr := json.Marshal(v)
				if tmpErr != nil {
					err = fmt.Errorf("Row:%d column:%s value type not support ", i, k)
				}
				stringMap[k] = string(tmpJsonByte)
			}
		}
		if err != nil {
			break
		}
		param = append(param, stringMap)
	}
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	resultData, err := db.HandleCiDataOperation(param, c.Param("ciType"), c.Param("operation"), middleware.GetRequestUser(c), "", middleware.GetRequestRoles(c), true, false)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, resultData)
	}
}

func DataReferenceQuery(c *gin.Context) {
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	ciAttrId := c.Param("ciAttr")
	resultData, err := db.GetCiDataByFilters(ciAttrId, param.Dialect.AssociatedData)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(resultData) == 0 {
			resultData = []*models.CiDataRefDataObj{}
		}
		middleware.ReturnData(c, resultData)
	}
}

func DataRollbackList(c *gin.Context) {
	guid := c.Param("guid")
	resultData, err := db.DataRollbackList(guid)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, resultData)
	}
}

func DataPasswordQuery(c *gin.Context) {
	ciTypeId := c.Param("ciType")
	guid := c.Param("guid")
	field := c.Param("field")
	if ciTypeId == "" || guid == "" || field == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("ciType and guid and field can not empty "))
		return
	}
	id := 0
	if c.Query("history_id") != "" {
		id, _ = strconv.Atoi(c.Query("history_id"))
	}
	password, err := db.DataPasswordQuery(ciTypeId, guid, field, id)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, password)
	}
}
