package ci

import (
	"bytes"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/cipher"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"reflect"
	"strconv"
	"strings"
)

func DataQuery(c *gin.Context) {
	//Param validate
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	// Permissions
	permissions, tmpErr := db.GetRoleCiDataPermission(middleware.GetRequestRoles(c), c.Param("ciType"), "", models.DataActionQuery)
	if tmpErr != nil {
		middleware.ReturnDataPermissionError(c, tmpErr)
		return
	}
	legalGuidList, tmpErr := db.GetCiDataPermissionGuidList(&permissions, models.DataActionQuery)
	if tmpErr != nil {
		middleware.ReturnDataPermissionError(c, tmpErr)
		return
	}
	if !legalGuidList.Legal && len(legalGuidList.GuidList) == 0 {
		middleware.ReturnDataPermissionDenyError(c)
		return
	}
	//Query database
	pageInfo, rowData, err := db.CiDataQuery(c.Param("ciType"), &param, &legalGuidList, false, false)
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
	//
	onlyQueryStr := c.Query("onlyQuery")
	var onlyQuery bool
	if onlyQueryStr != "" {
		onlyQuery, _ = strconv.ParseBool(onlyQueryStr)
	}
	handleParam := models.HandleCiDataParam{InputData: param, CiTypeId: c.Param("ciType"), Operation: c.Param("operation"), Operator: middleware.GetRequestUser(c), Roles: middleware.GetRequestRoles(c), Permission: true, OnlyQuery: onlyQuery}
	handleParam.UserToken = c.GetHeader("Authorization")
	//resultData, err := db.HandleCiDataOperation(param, c.Param("ciType"), c.Param("operation"), middleware.GetRequestUser(c), "", middleware.GetRequestRoles(c), true, false)
	resultData, newInputData, handleErr := db.HandleCiDataOperation(handleParam)
	c.Set("requestBody", newInputData)
	if handleErr != nil {
		if strings.Contains(handleErr.Error(), "permission deny") {
			middleware.ReturnDataPermissionDenyWithError(c, handleErr)
		} else {
			middleware.ReturnServerHandleError(c, handleErr)
		}
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
	if param.Dialect == nil {
		param.Dialect = &models.QueryRequestDialect{}
	}
	pageInfo, resultData, err := db.GetCiDataByFilters(ciAttrId, param.Dialect.AssociatedData, param, c.GetHeader(models.HeaderAuthorization))
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
	result, err := db.DataColumnQuery(ciTypeId, guid, field, id, middleware.GetRequestRoles(c), true)
	if err != nil {
		if strings.Contains(err.Error(), "permission deny") {
			middleware.ReturnDataPermissionDenyWithError(c, err)
		} else {
			middleware.ReturnServerHandleError(c, err)
		}
	} else {
		middleware.ReturnData(c, result)
	}
}

func DataImport(c *gin.Context) {
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
	//if param.RootCiType != ciTypeId {
	//middleware.ReturnParamValidateError(c, fmt.Errorf("rootCiType is %s,not %s", param.RootCiType, ciTypeId))
	//return
	//}
	if err = db.ImportCiData(&param, middleware.GetRequestUser(c), false); err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func SimpleCiDataImport(c *gin.Context) {
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
	fileBytes, readFileErr := ioutil.ReadAll(f)
	defer f.Close()
	if readFileErr != nil {
		middleware.ReturnServerHandleError(c, readFileErr)
		return
	}
	r := csv.NewReader(bytes.NewReader(fileBytes))
	r.LazyQuotes = true
	dataRowList, formatErr := r.ReadAll()
	if formatErr != nil {
		middleware.ReturnServerHandleError(c, formatErr)
		return
	}
	if len(dataRowList) == 0 {
		middleware.ReturnServerHandleError(c, fmt.Errorf("data row empty"))
		return
	}
	ciAttrList, getAttrErr := db.GetCiAttrByCiType(ciTypeId, true)
	if getAttrErr != nil {
		middleware.ReturnServerHandleError(c, getAttrErr)
		return
	}
	attrIndexMap := make(map[int]*models.SysCiTypeAttrTable)
	for i, attrDisplayName := range dataRowList[0] {
		for _, attrObj := range ciAttrList {
			if attrObj.DisplayName == attrDisplayName {
				attrIndexMap[i] = attrObj
				break
			}
		}
	}
	var param []models.CiDataMapObj
	for i, inputRow := range dataRowList {
		if i == 0 {
			continue
		}
		stringMap := make(map[string]string)
		for k, v := range inputRow {
			if v == "" {
				continue
			}
			if attrObj, ok := attrIndexMap[k]; ok {
				if attrObj.InputType == "ref" {
					if tmpGuidList, tmpErr := db.GetGuidByKeyName(attrObj.RefCiType, []string{v}); tmpErr != nil {
						err = tmpErr
						break
					} else {
						if len(tmpGuidList) == 0 {
							err = fmt.Errorf("can not find ciType:%s with name:%s ", attrObj.RefCiType, v)
							break
						} else {
							stringMap[attrObj.Name] = tmpGuidList[0]
						}
					}
				} else if attrObj.InputType == "multiRef" {
					if tmpGuidList, tmpErr := db.GetGuidByKeyName(attrObj.RefCiType, strings.Split(v, ",")); tmpErr != nil {
						err = tmpErr
						break
					} else {
						guidListBytes, _ := json.Marshal(tmpGuidList)
						stringMap[attrObj.Name] = string(guidListBytes)
					}
				} else {
					stringMap[attrObj.Name] = v
				}
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
	if len(param) == 0 {
		middleware.ReturnServerHandleError(c, fmt.Errorf("data row empty"))
		return
	}
	handleParam := models.HandleCiDataParam{InputData: param, CiTypeId: ciTypeId, Operation: "Add", Operator: middleware.GetRequestUser(c), Roles: middleware.GetRequestRoles(c), Permission: false}
	handleParam.UserToken = c.GetHeader("Authorization")
	resultData, _, handleErr := db.HandleCiDataOperation(handleParam)
	if handleErr != nil {
		middleware.ReturnServerHandleError(c, handleErr)
	} else {
		middleware.ReturnData(c, resultData)
	}
}

func GetCiPasswordAESKey(c *gin.Context) {
	md5sum := cipher.Md5Encode(models.Config.Wecube.EncryptSeed)
	middleware.ReturnData(c, md5sum[0:16])
}

func GetExtendModelData(c *gin.Context) {
	ciAttr := c.Param("ciAttr")
	ciAttrRow, getAttrErr := db.GetCiAttrById(ciAttr)
	if getAttrErr != nil {
		middleware.ReturnParamValidateError(c, getAttrErr)
		return
	}
	entitySplit := strings.Split(ciAttrRow.ExtRefEntity, ":")
	if len(entitySplit) != 2 {
		middleware.ReturnServerHandleError(c, fmt.Errorf("attr refCiType:%s illegal with extent model", ciAttrRow.RefCiType))
		return
	}
	//Param validate
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	var dataGuid string
	for _, v := range param.Filters {
		if v.Name == "guid" && v.Operator == "eq" {
			dataGuid = fmt.Sprintf("%s", v.Value)
			break
		}
	}
	result, err := db.GetExtendModelData(entitySplit[0], entitySplit[1], dataGuid, c.GetHeader(models.HeaderAuthorization))
	if err != nil {
		middleware.ReturnServerHandleError(c, fmt.Errorf("get ext model data fail,%s ", err.Error()))
		return
	}
	middleware.ReturnPageData(c, models.PageInfo{}, result)
}

func AttrSensitiveDataQuery(c *gin.Context) {
	var err error
	var paramList []*models.AttrPermissionQueryObj
	if err = c.ShouldBindJSON(&paramList); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	userRoles := middleware.GetRequestRoles(c)
	queryAttrPermissionMap := make(map[string]*models.CiDataLegalGuidList)
	updateAttrPermissionMap := make(map[string]*models.CiDataLegalGuidList)
	for _, param := range paramList {
		attrId := param.CiType + models.SysTableIdConnector + param.AttrName
		if _, ok := queryAttrPermissionMap[attrId]; !ok {
			permissions, tmpGetPermissionConfigErr := db.GetRoleCiDataPermission(userRoles, param.CiType, attrId, models.DataActionQuery)
			if tmpGetPermissionConfigErr != nil {
				err = tmpGetPermissionConfigErr
				break
			}
			tmpLegalConfig, tmpGetPermissionGuidListErr := db.GetCiDataPermissionGuidList(&permissions, models.DataActionQuery)
			if tmpGetPermissionGuidListErr != nil {
				err = tmpGetPermissionGuidListErr
				break
			}
			queryAttrPermissionMap[attrId] = &tmpLegalConfig
		}
		queryConfig := queryAttrPermissionMap[attrId]
		if queryConfig.Legal {
			param.QueryPermission = true
		} else {
			for _, legalGuid := range queryConfig.GuidList {
				if legalGuid == param.Guid {
					param.QueryPermission = true
					break
				}
			}
		}
		if param.QueryPermission {
			result, queryDataErr := db.DataColumnQuery(param.CiType, param.Guid, param.AttrName, param.HistoryId, userRoles, false)
			if queryDataErr != nil {
				err = fmt.Errorf("query column value from ci:%s attr:%s guid:%s fail,%s ", param.CiType, param.AttrName, param.Guid, queryDataErr.Error())
				break
			}
			param.Value = result
		}
		if _, ok := updateAttrPermissionMap[attrId]; !ok {
			permissions, tmpGetPermissionConfigErr := db.GetRoleCiDataPermission(userRoles, param.CiType, attrId, models.DataActionUpdate)
			if tmpGetPermissionConfigErr != nil {
				err = tmpGetPermissionConfigErr
				break
			}
			tmpLegalConfig, tmpGetPermissionGuidListErr := db.GetCiDataPermissionGuidList(&permissions, models.DataActionUpdate)
			if tmpGetPermissionGuidListErr != nil {
				err = tmpGetPermissionGuidListErr
				break
			}
			updateAttrPermissionMap[attrId] = &tmpLegalConfig
		}
		updateConfig := updateAttrPermissionMap[attrId]
		if updateConfig.Legal {
			param.UpdatePermission = true
		} else {
			for _, legalGuid := range updateConfig.GuidList {
				if legalGuid == param.Guid {
					param.UpdatePermission = true
					break
				}
			}
		}
	}
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, paramList)
	}
}
