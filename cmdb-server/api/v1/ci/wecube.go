package ci

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"io/ioutil"
	"net/http"
	"reflect"
	"strings"
)

func HandleCiModelRequest(c *gin.Context) {
	ciType := c.Param("ciType")
	operation := c.Request.RequestURI[strings.LastIndex(c.Request.RequestURI, "/")+1:]
	var resp, logResp models.EntityResponse
	var bodyBytes []byte
	var err error
	if ciType == "" {
		resp.Status = "ERROR"
		resp.Message = "Url param ciType is empty"
		bodyBytes, _ = json.Marshal(resp)
		c.Set("responseBody", string(bodyBytes))
		c.JSON(http.StatusOK, resp)
		return
	}
	bodyBytes, err = ioutil.ReadAll(c.Request.Body)
	if err != nil {
		resp.Status = "ERROR"
		resp.Message = fmt.Sprintf("Read request body fail,%s ", err.Error())
		bodyBytes, _ = json.Marshal(resp)
		c.Set("responseBody", string(bodyBytes))
		c.JSON(http.StatusOK, resp)
		return
	}
	c.Request.Body.Close()
	newInputData := string(bodyBytes)
	headerOperation := c.GetHeader("x-operation")
	var dataGuidList []string
	if operation == "query" {
		resp.Data, err = ciModelQuery(ciType, bodyBytes, middleware.GetRequestUser(c), middleware.GetRequestRoles(c))
	} else if operation == "create" {
		resp.Data, logResp.Data, newInputData, err = ciModelCreate(ciType, bodyBytes)
	} else if operation == "update" {
		resp.Data, logResp.Data, newInputData, dataGuidList, err = ciModeUpdate(ciType, bodyBytes)
	} else if operation == "delete" {
		newInputData, err = ciModeDelete(ciType, bodyBytes)
	} else {
		err = fmt.Errorf("Url param operation is illegal ")
	}
	c.Set("requestBody", newInputData)
	if err == nil && headerOperation != "" && len(dataGuidList) > 0 {
		doOperationParam := models.PluginCiDataOperationRequestObj{CiType: ciType, Operation: headerOperation}
		var dataGuidMapList []map[string]string
		for _, v := range dataGuidList {
			tmpGuidData := make(map[string]string)
			tmpGuidData["guid"] = v
			dataGuidMapList = append(dataGuidMapList, tmpGuidData)
		}
		mapJsonBytes, _ := json.Marshal(dataGuidMapList)
		doOperationParam.JsonData = string(mapJsonBytes)
		_, _, err = pluginCiDataOperation(&doOperationParam)
	}
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Request entity data fail", zap.Error(err))
		resp.Status = "ERROR"
		resp.Message = err.Error()
		logResp.Status, logResp.Message = resp.Status, resp.Message
		if operation == "query" {
			logResp.Data = resp.Data
		}
		bodyBytes, _ = json.Marshal(logResp)
		c.Set("responseBody", string(bodyBytes))
		c.JSON(http.StatusOK, resp)
		return
	}
	resp.Status = "OK"
	resp.Message = "success"
	logResp.Status, logResp.Message = resp.Status, resp.Message
	if operation == "query" {
		logResp.Data = resp.Data
	}
	bodyBytes, _ = json.Marshal(logResp)
	c.Set("responseBody", string(bodyBytes))
	c.JSON(http.StatusOK, resp)
}

func ciModelQuery(ciType string, bodyBytes []byte, user string, roles []string) (result []map[string]interface{}, err error) {
	var param models.EntityQueryParam
	err = json.Unmarshal(bodyBytes, &param)
	if err != nil {
		return
	}
	queryParam := models.QueryRequestParam{}
	queryParam.Dialect = &models.QueryRequestDialect{QueryMode: "now"}
	queryParam.Filters = []*models.QueryRequestFilterObj{}
	if param.Criteria.AttrName != "" {
		if param.Criteria.AttrName == "id" {
			param.Criteria.AttrName = "guid"
		}
		if param.Criteria.AttrName == "displayName" {
			param.Criteria.AttrName = "key_name"
		}
		if param.Criteria.Op == "" {
			param.Criteria.Op = "eq"
		}
		queryParam.Filters = append(queryParam.Filters, &models.QueryRequestFilterObj{Name: param.Criteria.AttrName, Operator: param.Criteria.Op, Value: param.Criteria.Condition})
	}
	for _, filter := range param.AdditionalFilters {
		if filter.AttrName == "id" {
			filter.AttrName = "guid"
		}
		if filter.AttrName == "displayName" {
			filter.AttrName = "key_name"
		}
		if filter.Op == "" {
			filter.Op = "eq"
		}
		queryParam.Filters = append(queryParam.Filters, &models.QueryRequestFilterObj{Name: filter.AttrName, Operator: filter.Op, Value: filter.Condition})
	}
	queryParam.Paging = false
	legalGuidList := models.CiDataLegalGuidList{Legal: true}
	if user != models.PlatformUser {
		permissions, tmpErr := db.GetRoleCiDataPermission(roles, ciType, "", models.DataActionQuery)
		if tmpErr != nil {
			err = tmpErr
			return
		}
		legalGuidList, err = db.GetCiDataPermissionGuidList(&permissions, models.DataActionQuery)
		if err != nil {
			return
		}
	}
	_, result, err = db.CiDataQuery(ciType, &queryParam, &legalGuidList, true, false)
	for _, tmpObj := range result {
		tmpObj["id"] = tmpObj["guid"]
		tmpObj["displayName"] = tmpObj["key_name"]
	}
	if len(result) == 0 {
		result = []map[string]interface{}{}
	}
	return
}

func ciModelCreate(ciType string, bodyBytes []byte) (result, logResult []map[string]interface{}, newInputData string, err error) {
	newInputData = string(bodyBytes)
	var param []map[string]interface{}
	var stringParam []models.CiDataMapObj
	err = json.Unmarshal(bodyBytes, &param)
	if err != nil {
		return
	}
	for i, tmpMap := range param {
		if _, b := tmpMap["id"]; b {
			tmpMap["guid"] = tmpMap["id"]
			delete(tmpMap, "id")
		}
		if _, b := tmpMap["displayName"]; b {
			tmpMap["key_name"] = tmpMap["displayName"]
			delete(tmpMap, "displayName")
		}
		tmpStringMap := make(map[string]string)
		for k, v := range tmpMap {
			if v == nil {
				continue
			}
			valueType := reflect.TypeOf(v).String()
			if valueType == "string" {
				tmpStringMap[k] = v.(string)
			} else if valueType == "int" {
				tmpStringMap[k] = fmt.Sprintf("%d", v.(int))
			} else {
				tmpJsonByte, tmpErr := json.Marshal(v)
				if tmpErr != nil {
					err = fmt.Errorf("Row:%d column:%s value type not support ", i, k)
					break
				}
				tmpStringMap[k] = string(tmpJsonByte)
			}
		}
		if err != nil {
			break
		}
		stringParam = append(stringParam, tmpStringMap)
	}
	if err != nil {
		return
	}
	handleParam := models.HandleCiDataParam{InputData: stringParam, CiTypeId: ciType, Operation: "insert", Operator: "wecube", BareAction: "insert", Roles: []string{}, Permission: false, FromCore: true}
	output, newInput, tmpErr := db.HandleCiDataOperation(handleParam)
	newInputData = newInput
	if tmpErr != nil {
		err = tmpErr
		return
	}
	for _, outputObj := range output {
		tmpResultMap := make(map[string]interface{})
		tmpLogResultMap := make(map[string]interface{})
		for k, v := range outputObj {
			if strings.HasPrefix(v, "******^") {
				tmpLogResultMap[k] = "******"
				tmpResultMap[k] = v[7:]
				continue
			}
			tmpResultMap[k] = v
			tmpLogResultMap[k] = v
		}
		if v, b := tmpResultMap["guid"]; b {
			tmpResultMap["id"] = v
			tmpLogResultMap["id"] = v
		}
		if v, b := tmpResultMap["key_name"]; b {
			tmpResultMap["displayName"] = v
			tmpLogResultMap["displayName"] = v
		}
		result = append(result, tmpResultMap)
		logResult = append(logResult, tmpLogResultMap)
	}
	return
}

func ciModeUpdate(ciType string, bodyBytes []byte) (result, logResult []map[string]interface{}, newInputData string, dataGuidList []string, err error) {
	newInputData = string(bodyBytes)
	var param []map[string]interface{}
	var stringParam []models.CiDataMapObj
	err = json.Unmarshal(bodyBytes, &param)
	if err != nil {
		return
	}
	for i, tmpMap := range param {
		if _, b := tmpMap["id"]; b {
			tmpMap["guid"] = tmpMap["id"]
			delete(tmpMap, "id")
		}
		if _, b := tmpMap["displayName"]; b {
			tmpMap["key_name"] = tmpMap["displayName"]
			delete(tmpMap, "displayName")
		}
		tmpStringMap := make(map[string]string)
		for k, v := range tmpMap {
			if v == nil {
				continue
			}
			if k == "guid" {
				dataGuidList = append(dataGuidList, v.(string))
			}
			valueType := reflect.TypeOf(v).String()
			if valueType == "string" {
				tmpStringMap[k] = v.(string)
			} else if valueType == "int" {
				tmpStringMap[k] = fmt.Sprintf("%d", v.(int))
			} else {
				tmpJsonByte, tmpErr := json.Marshal(v)
				if tmpErr != nil {
					err = fmt.Errorf("Row:%d column:%s value type not support ", i, k)
					break
				}
				tmpStringMap[k] = string(tmpJsonByte)
			}
		}
		if err != nil {
			break
		}
		stringParam = append(stringParam, tmpStringMap)
	}
	if err != nil {
		return
	}
	handleParam := models.HandleCiDataParam{InputData: stringParam, CiTypeId: ciType, Operation: "update", Operator: "wecube", BareAction: "update", Roles: []string{}, Permission: false, FromCore: true}
	output, newInput, tmpErr := db.HandleCiDataOperation(handleParam)
	newInputData = newInput
	if tmpErr != nil {
		err = tmpErr
		return
	}
	for _, outputObj := range output {
		tmpResultMap := make(map[string]interface{})
		tmpLogResultMap := make(map[string]interface{})
		for k, v := range outputObj {
			if strings.HasPrefix(v, "******^") {
				tmpLogResultMap[k] = "******"
				tmpResultMap[k] = v[7:]
				continue
			}
			tmpResultMap[k] = v
			tmpLogResultMap[k] = v
		}
		if v, b := tmpResultMap["guid"]; b {
			tmpResultMap["id"] = v
			tmpLogResultMap["id"] = v
		}
		if v, b := tmpResultMap["key_name"]; b {
			tmpResultMap["displayName"] = v
			tmpLogResultMap["displayName"] = v
		}
		result = append(result, tmpResultMap)
		logResult = append(logResult, tmpLogResultMap)
	}
	return
}

func ciModeDelete(ciType string, bodyBytes []byte) (newInputData string, err error) {
	newInputData = string(bodyBytes)
	var param []map[string]interface{}
	var stringParam []models.CiDataMapObj
	err = json.Unmarshal(bodyBytes, &param)
	if err != nil {
		return
	}
	for i, tmpMap := range param {
		if _, b := tmpMap["id"]; b {
			tmpMap["guid"] = tmpMap["id"]
			delete(tmpMap, "id")
		}
		if _, b := tmpMap["displayName"]; b {
			tmpMap["key_name"] = tmpMap["displayName"]
			delete(tmpMap, "displayName")
		}
		tmpStringMap := make(map[string]string)
		for k, v := range tmpMap {
			if v == nil {
				continue
			}
			valueType := reflect.TypeOf(v).String()
			if valueType == "string" {
				tmpStringMap[k] = v.(string)
			} else if valueType == "int" {
				tmpStringMap[k] = fmt.Sprintf("%d", v.(int))
			} else {
				tmpJsonByte, tmpErr := json.Marshal(v)
				if tmpErr != nil {
					err = fmt.Errorf("Row:%d column:%s value type not support ", i, k)
					break
				}
				tmpStringMap[k] = string(tmpJsonByte)
			}
		}
		if err != nil {
			break
		}
		stringParam = append(stringParam, tmpStringMap)
	}
	if err != nil {
		return
	}
	handleParam := models.HandleCiDataParam{InputData: stringParam, CiTypeId: ciType, Operation: "delete", Operator: "wecube", BareAction: "delete", Roles: []string{}, Permission: false, FromCore: true}
	_, newInputData, err = db.HandleCiDataOperation(handleParam)
	return
}

func GetAllDataModel(c *gin.Context) {
	result, err := db.GetAllDataModel()
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Get all data model fail", zap.Error(err))
		result = models.SyncDataModelResponse{Status: "ERROR", Message: err.Error()}
	}
	bodyBytes, _ := json.Marshal(result)
	c.Set("responseBody", string(bodyBytes))
	c.JSON(http.StatusOK, result)
}

func PluginCiDataOperationHandle(c *gin.Context) {
	response := models.PluginCiDataOperationResp{ResultCode: "0", ResultMessage: "success", Results: models.PluginCiDataOperationOutput{}}
	var err error
	defer func() {
		if err != nil {
			log.Error(nil, log.LOGGER_APP, "Plugin ci data operation handle fail", zap.Error(err))
			response.ResultCode = "1"
			response.ResultMessage = err.Error()
		}
		bodyBytes, _ := json.Marshal(response)
		c.Set("responseBody", string(bodyBytes))
		c.JSON(http.StatusOK, response)
	}()
	var param models.PluginCiDataOperationRequest
	c.ShouldBindJSON(&param)
	if len(param.Inputs) == 0 {
		return
	}
	for _, input := range param.Inputs {
		output, tmpInputData, tmpErr := pluginCiDataOperation(input)
		if tmpErr != nil {
			output.ErrorCode = "1"
			output.ErrorMessage = tmpErr.Error()
			err = tmpErr
		}
		input.JsonData = tmpInputData
		response.Results.Outputs = append(response.Results.Outputs, output)
	}
	logParam, _ := json.Marshal(param)
	c.Set("requestBody", string(logParam))
}

func pluginCiDataOperation(input *models.PluginCiDataOperationRequestObj) (result *models.PluginCiDataOperationOutputObj, newInputData string, err error) {
	newInputData = input.JsonData
	result = &models.PluginCiDataOperationOutputObj{CallbackParameter: input.CallbackParameter, ErrorCode: "0", ErrorMessage: ""}
	if input.JsonData == "" || input.JsonData == "{}" || input.JsonData == "<nil>" || input.JsonData == "[]" {
		return
	}
	if input.CiType == "" || input.Operation == "" {
		err = fmt.Errorf("Param validate fail,ciType & operation & jsonData can not empty ")
		return
	}
	var handleDataList []models.CiDataMapObj
	dataMap := make(map[string]interface{})
	var dataMapList []map[string]interface{}
	err = json.Unmarshal([]byte(input.JsonData), &dataMapList)
	if err != nil {
		err = json.Unmarshal([]byte(input.JsonData), &dataMap)
		if err != nil {
			if !strings.Contains(input.JsonData, "_") {
				err = fmt.Errorf("Param jsonData illegal ")
				return
			}
			if strings.HasPrefix(input.JsonData, "[") && strings.HasSuffix(input.JsonData, "]") {
				for _, tmpSplitData := range strings.Split(input.JsonData[1:len(input.JsonData)-1], ",") {
					if tmpSplitData == "" {
						continue
					}
					tmpDataMap := make(map[string]interface{})
					tmpDataMap["guid"] = tmpSplitData
					dataMapList = append(dataMapList, tmpDataMap)
				}
			} else {
				dataMap["guid"] = input.JsonData
				dataMapList = append(dataMapList, dataMap)
			}
			err = nil
		} else {
			dataMapList = append(dataMapList, dataMap)
		}
	}
	if len(dataMapList) == 0 {
		return
	}
	var inputDataGuid string
	for _, tmpDataMap := range dataMapList {
		dataStringMap := make(map[string]string)
		for k, v := range tmpDataMap {
			if v == nil {
				dataStringMap[k] = ""
			}
			valueType := reflect.TypeOf(v).String()
			if valueType == "string" {
				dataStringMap[k] = v.(string)
			} else if valueType == "int" {
				dataStringMap[k] = fmt.Sprintf("%d", v.(int))
			} else {
				tmpJsonByte, tmpErr := json.Marshal(v)
				if tmpErr != nil {
					err = fmt.Errorf("Column:%s valueType not support ", k)
					break
				}
				dataStringMap[k] = string(tmpJsonByte)
			}
		}
		if err != nil {
			break
		}
		if v, b := dataStringMap["id"]; b {
			dataStringMap["guid"] = v
			delete(dataStringMap, "id")
		}
		if v, b := dataStringMap["displayName"]; b {
			dataStringMap["key_name"] = v
			delete(dataStringMap, "displayName")
		}
		if v, b := dataStringMap["guid"]; b {
			if inputDataGuid == "" {
				inputDataGuid = v
			}
		}
		if input.Operation == "Rollback" {
			if dataStringMap["guid"] == "" {
				err = fmt.Errorf("Rollback need history data guid,please check input data ")
				break
			}
			lastConfirmData, getErr := db.GetRollbackLastConfirmData(dataStringMap["guid"])
			if getErr != nil {
				err = fmt.Errorf("Rollback try to get last confirm data fail,%s ", getErr.Error())
				break
			}
			dataStringMap = lastConfirmData
		}
		handleDataList = append(handleDataList, dataStringMap)
	}
	if err != nil {
		return
	}
	if inputDataGuid != "" {
		input.CiType = inputDataGuid[:strings.LastIndex(inputDataGuid, "_")]
	}
	handleParam := models.HandleCiDataParam{InputData: handleDataList, CiTypeId: input.CiType, Operation: input.Operation, Operator: "wecube", Roles: []string{}, Permission: false, FromCore: true}
	outputData, newInput, handleErr := db.HandleCiDataOperation(handleParam)
	newInputData = newInput
	if handleErr != nil {
		err = handleErr
		return
	}
	if len(outputData) > 0 {
		result.Guid = outputData[0]["guid"]
	}
	return
}

func PluginCiDataAttrValueHandle(c *gin.Context) {
	response := models.PluginCiDataOperationResp{ResultCode: "0", ResultMessage: "success", Results: models.PluginCiDataOperationOutput{}}
	var err error
	defer func() {
		if err != nil {
			log.Error(nil, log.LOGGER_APP, "Plugin ci data operation handle fail", zap.Error(err))
			response.ResultCode = "1"
			response.ResultMessage = err.Error()
		}
		bodyBytes, _ := json.Marshal(response)
		c.Set("responseBody", string(bodyBytes))
		c.JSON(http.StatusOK, response)
	}()
	var param models.PluginCiDataAttrValueRequest
	if err = c.ShouldBindJSON(&param); err != nil {
		return
	}
	if len(param.Inputs) == 0 {
		return
	}
	for _, input := range param.Inputs {
		output, isPwd, tmpErr := pluginAttrValue(input)
		if tmpErr != nil {
			output.ErrorCode = "1"
			output.ErrorMessage = tmpErr.Error()
			err = tmpErr
		}
		if isPwd {
			input.Value = "******"
		}
		response.Results.Outputs = append(response.Results.Outputs, output)
	}
	logParam, _ := json.Marshal(param)
	c.Set("requestBody", string(logParam))
}

func pluginAttrValue(input *models.PluginCiDataAttrValueRequestObj) (result *models.PluginCiDataOperationOutputObj, isPwd bool, err error) {
	result = &models.PluginCiDataOperationOutputObj{CallbackParameter: input.CallbackParameter, ErrorCode: "0", ErrorMessage: ""}
	if input.CiType == "" || input.Guid == "" || input.CiTypeAttr == "" {
		err = fmt.Errorf("Param validate fail,ciType & guid & ciTypeAttr can not empty ")
		return
	}
	isPwd, err = db.CheckCiAttrIsPassword(input.CiType, input.CiTypeAttr)
	if err != nil {
		return
	}
	dataStringMap := make(map[string]string)
	dataStringMap["guid"] = input.Guid
	result.Guid = input.Guid
	dataStringMap[input.CiTypeAttr] = input.Value
	handleParam := models.HandleCiDataParam{InputData: []models.CiDataMapObj{dataStringMap}, CiTypeId: input.CiType, Operation: "update", Operator: "wecube", BareAction: "update", Roles: []string{}, Permission: false, FromCore: true}
	_, _, err = db.HandleCiDataOperation(handleParam)
	return
}

func PluginViewConfirmHandle(c *gin.Context) {
	response := models.PluginViewConfirmResp{ResultCode: "0", ResultMessage: "success", Results: models.PluginViewConfirmOutput{}}
	var err error
	defer func() {
		if err != nil {
			log.Error(nil, log.LOGGER_APP, "Plugin view confirm handle fail", zap.Error(err))
			response.ResultCode = "1"
			response.ResultMessage = err.Error()
		}
		bodyBytes, _ := json.Marshal(response)
		c.Set("responseBody", string(bodyBytes))
		c.JSON(http.StatusOK, response)
	}()
	var param models.PluginViewConfirmRequest
	if err = c.ShouldBindJSON(&param); err != nil {
		return
	}
	if len(param.Inputs) == 0 {
		return
	}
	userToken := c.GetHeader("Authorization")
	for _, input := range param.Inputs {
		output, tmpErr := pluginViewConfirm(input, userToken)
		if tmpErr != nil {
			output.ErrorCode = "1"
			output.ErrorMessage = tmpErr.Error()
			err = tmpErr
		}
		response.Results.Outputs = append(response.Results.Outputs, output)
	}
	logParam, _ := json.Marshal(param)
	c.Set("requestBody", string(logParam))
}

func pluginViewConfirm(input *models.PluginViewConfirmRequestObj, userToken string) (result *models.PluginViewConfirmOutputObj, err error) {
	result = &models.PluginViewConfirmOutputObj{CallbackParameter: input.CallbackParameter, ErrorCode: "0", ErrorMessage: ""}
	if input.ViewId == "" || input.RootCi == "" {
		err = fmt.Errorf("Param validate fail,viewId && rootCi can not empty ")
		return
	}
	confirmResult, confirmErr := db.ViewConfirmAction(models.ViewData{ViewId: input.ViewId, RootCi: input.RootCi}, userToken, "SYSTEM", []string{})
	if confirmErr != nil {
		err = confirmErr
		return
	}
	if len(confirmResult) > 0 {
		result.ConfirmTime = confirmResult[0]["confirm_time"]
	}
	return
}
