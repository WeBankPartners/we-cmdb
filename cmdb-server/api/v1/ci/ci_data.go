package ci

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"io/ioutil"
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
	handleParam := models.HandleCiDataParam{InputData: param, CiTypeId: c.Param("ciType"), Operation: c.Param("operation"), Operator: middleware.GetRequestUser(c), Roles: middleware.GetRequestRoles(c), Permission: true}
	handleParam.UserToken = c.GetHeader("Authorization")
	//resultData, err := db.HandleCiDataOperation(param, c.Param("ciType"), c.Param("operation"), middleware.GetRequestUser(c), "", middleware.GetRequestRoles(c), true, false)
	resultData, newInputData, err := db.HandleCiDataOperation(handleParam)
	c.Set("requestBody", newInputData)
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
	pageInfo, resultData, err := db.GetCiDataByFilters(ciAttrId, param.Dialect.AssociatedData, param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(resultData) == 0 {
			resultData = []map[string]interface{}{}
		}
		if param.Paging {
			middleware.ReturnPageData(c, pageInfo, resultData)
		} else {
			middleware.ReturnData(c, resultData)
		}
	}
}

func DataRollbackList(c *gin.Context) {
	guid := c.Param("guid")
	resultData, _, err := db.DataRollbackList(guid)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(resultData) == 0 {
			resultData = []map[string]interface{}{}
		}
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

func DataImport(c *gin.Context) {
	ciTypeId := c.Param("ciType")
	file, err := c.FormFile("file")
	if err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	f, openFileErr := file.Open()
	if openFileErr != nil {
		middleware.ReturnParamValidateError(c, openFileErr)
		return
	}
	var param models.ExportReportResult
	b, readFileErr := ioutil.ReadAll(f)
	defer f.Close()
	if readFileErr != nil {
		middleware.ReturnServerHandleError(c, readFileErr)
		return
	}
	err = json.Unmarshal(b, &param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if param.RootCiType != ciTypeId {
		middleware.ReturnParamValidateError(c, fmt.Errorf("rootCiType is %s,not %s", param.RootCiType, ciTypeId))
		return
	}
	if err = db.ImportCiData(&param, middleware.GetRequestUser(c)); err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}
