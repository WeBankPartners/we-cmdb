package ci

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
	"reflect"
	"strings"
)

func HandleCiModelRequest(c *gin.Context) {
	ciType := c.Param("ciType")
	operation := c.Request.RequestURI[strings.LastIndex(c.Request.RequestURI, "/")+1:]
	var resp models.EntityResponse
	if ciType == "" {
		resp.Status = "ERROR"
		resp.Message = "Url param ciType is empty"
		c.JSON(http.StatusOK, resp)
		return
	}
	bodyBytes, err := ioutil.ReadAll(c.Request.Body)
	if err != nil {
		resp.Status = "ERROR"
		resp.Message = fmt.Sprintf("Read request body fail,%s ", err.Error())
		c.JSON(http.StatusOK, resp)
		return
	}
	c.Request.Body.Close()
	if operation == "query" {
		resp.Data, err = ciModelQuery(ciType, bodyBytes)
	} else if operation == "create" {
		resp.Data, err = ciModelCreate(ciType, bodyBytes)
	} else if operation == "update" {
		err = ciModeUpdate(ciType, bodyBytes)
	} else if operation == "delete" {
		err = ciModeDelete(ciType, bodyBytes)
	} else {
		err = fmt.Errorf("Url param operation is illegal ")
	}
	if err != nil {
		log.Logger.Error("Request entity data fail", log.Error(err))
		resp.Status = "ERROR"
		resp.Message = err.Error()
		c.JSON(http.StatusOK, resp)
		return
	}
	resp.Status = "OK"
	resp.Message = "success"
	c.JSON(http.StatusOK, resp)
}

func ciModelQuery(ciType string, bodyBytes []byte) (result []map[string]interface{}, err error) {
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
	_, result, err = db.CiDataQuery(ciType, &queryParam, &models.CiDataLegalGuidList{Enable: true}, true)
	for _, tmpObj := range result {
		tmpObj["id"] = tmpObj["guid"]
		tmpObj["displayName"] = tmpObj["key_name"]
	}
	if len(result) == 0 {
		result = []map[string]interface{}{}
	}
	return
}

func ciModelCreate(ciType string, bodyBytes []byte) (result []map[string]interface{}, err error) {
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
	output, tmpErr := db.HandleCiDataOperation(stringParam, ciType, "insert", "wecube", "insert", []string{}, false, true)
	if tmpErr != nil {
		err = tmpErr
		return
	}
	for _, outputObj := range output {
		tmpResultMap := make(map[string]interface{})
		for k, v := range outputObj {
			tmpResultMap[k] = v
		}
		if v, b := tmpResultMap["guid"]; b {
			tmpResultMap["id"] = v
		}
		if v, b := tmpResultMap["key_name"]; b {
			tmpResultMap["displayName"] = v
		}
		result = append(result, tmpResultMap)
	}
	return
}

func ciModeUpdate(ciType string, bodyBytes []byte) error {
	var param []map[string]interface{}
	var stringParam []models.CiDataMapObj
	err := json.Unmarshal(bodyBytes, &param)
	if err != nil {
		return err
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
		return err
	}
	_, err = db.HandleCiDataOperation(stringParam, ciType, "update", "wecube", "update", []string{}, false, true)
	return err
}

func ciModeDelete(ciType string, bodyBytes []byte) error {
	var param []map[string]interface{}
	var stringParam []models.CiDataMapObj
	err := json.Unmarshal(bodyBytes, &param)
	if err != nil {
		return err
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
		return err
	}
	_, err = db.HandleCiDataOperation(stringParam, ciType, "delete", "wecube", "delete", []string{}, false, true)
	return err
}

func GetAllDataModel(c *gin.Context) {
	result, err := db.GetAllDataModel()
	if err != nil {
		log.Logger.Error("Get all data model fail", log.Error(err))
		result = models.SyncDataModelResponse{Status: "ERROR", Message: err.Error()}
	}
	c.JSON(http.StatusOK, result)
}

func PluginCiDataOperationHandle(c *gin.Context) {
	response := models.PluginCiDataOperationResp{ResultCode: "0", ResultMessage: "success", Results: models.PluginCiDataOperationOutput{}}
	var err error
	defer func() {
		if err != nil {
			log.Logger.Error("Plugin ci data operation handle fail", log.Error(err))
			response.ResultCode = "1"
			response.ResultMessage = err.Error()
		}
		c.JSON(http.StatusOK, response)
	}()
	var param models.PluginCiDataOperationRequest
	c.ShouldBindJSON(&param)
	if len(param.Inputs) == 0 {
		return
	}
	for _, input := range param.Inputs {
		output, tmpErr := pluginCiDataOperation(input)
		if tmpErr != nil {
			output.ErrorCode = "1"
			output.ErrorMessage = tmpErr.Error()
			err = tmpErr
		}
		response.Results.Outputs = append(response.Results.Outputs, output)
	}
}

func pluginCiDataOperation(input *models.PluginCiDataOperationRequestObj) (result *models.PluginCiDataOperationOutputObj, err error) {
	result = &models.PluginCiDataOperationOutputObj{CallbackParameter: input.CallbackParameter, ErrorCode: "0", ErrorMessage: ""}
	if input.JsonData == "" || input.JsonData == "{}" || input.JsonData == "[]" {
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
		handleDataList = append(handleDataList, dataStringMap)
	}
	if err != nil {
		return
	}
	if inputDataGuid != "" {
		tmpExampleGuid := guid.CreateGuid()
		input.CiType = inputDataGuid[:len(inputDataGuid)-len(tmpExampleGuid)-1]
	}
	outputData, handleErr := db.HandleCiDataOperation(handleDataList, input.CiType, input.Operation, "wecube", "", []string{}, false, true)
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
			log.Logger.Error("Plugin ci data operation handle fail", log.Error(err))
			response.ResultCode = "1"
			response.ResultMessage = err.Error()
		}
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
		output, tmpErr := pluginAttrValue(input)
		if tmpErr != nil {
			output.ErrorCode = "1"
			output.ErrorMessage = tmpErr.Error()
			err = tmpErr
		}
		response.Results.Outputs = append(response.Results.Outputs, output)
	}
}

func pluginAttrValue(input *models.PluginCiDataAttrValueRequestObj) (result *models.PluginCiDataOperationOutputObj, err error) {
	result = &models.PluginCiDataOperationOutputObj{CallbackParameter: input.CallbackParameter, ErrorCode: "0", ErrorMessage: ""}
	if input.CiType == "" || input.Guid == "" || input.CiTypeAttr == "" {
		err = fmt.Errorf("Param validate fail,ciType & guid & ciTypeAttr can not empty ")
		return
	}
	dataStringMap := make(map[string]string)
	dataStringMap["guid"] = input.Guid
	result.Guid = input.Guid
	dataStringMap[input.CiTypeAttr] = input.Value
	_, err = db.HandleCiDataOperation([]models.CiDataMapObj{dataStringMap}, input.CiType, "update", "wecube", "update", []string{}, false, true)
	return
}
