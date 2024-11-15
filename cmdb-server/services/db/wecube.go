package db

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"io"
	"net/http"
	"strings"
)

func GetAllDataModel() (result models.SyncDataModelResponse, err error) {
	result = models.SyncDataModelResponse{Status: "OK", Message: "success"}
	var attrTable []*models.SyncDataModelCiAttr
	err = x.SQL("select id,ci_type,name,display_name,description,input_type,ref_ci_type,nullable from sys_ci_type_attr where status='created' order by ci_type,ui_form_order").Find(&attrTable)
	if err != nil {
		return
	}
	var ciTable []*models.SyncDataModelCiType
	err = x.SQL("select id,display_name,description from sys_ci_type where status='created'").Find(&ciTable)
	if err != nil {
		return
	}
	attrMap := make(map[string][]*models.SyncDataModelCiAttr)
	for _, attr := range attrTable {
		if strings.HasPrefix(attr.DataType, "multi") {
			attr.Multiple = "Y"
		} else {
			attr.Multiple = "N"
		}
		if attr.DataType == "ref" || attr.DataType == "multiRef" {
			attr.DataType = "ref"
		} else if attr.DataType == "int" || attr.DataType == "multiInt" {
			attr.DataType = "int"
		} else {
			attr.DataType = "str"
		}
		if attr.RefEntityName != "" {
			attr.RefAttributeName = "id"
			attr.RefPackageName = "wecmdb"
		}
		if attr.Required == "no" {
			attr.Required = "Y"
		} else {
			attr.Required = "N"
		}
		if attr.Name == "guid" {
			tmpAttr := &models.SyncDataModelCiAttr{Name: "id", EntityName: attr.EntityName, Description: attr.Description, DataType: attr.DataType, RefPackageName: attr.RefPackageName, RefAttributeName: attr.RefAttributeName, RefEntityName: attr.RefEntityName, Multiple: attr.Multiple, Required: attr.Required}
			if _, b := attrMap[attr.EntityName]; b {
				attrMap[attr.EntityName] = append(attrMap[attr.EntityName], attr, tmpAttr)
			} else {
				attrMap[attr.EntityName] = []*models.SyncDataModelCiAttr{attr, tmpAttr}
			}
		} else if attr.Name == "key_name" {
			tmpAttr := &models.SyncDataModelCiAttr{Name: "displayName", EntityName: attr.EntityName, Description: attr.Description, DataType: attr.DataType, RefPackageName: attr.RefPackageName, RefAttributeName: attr.RefAttributeName, RefEntityName: attr.RefEntityName, Multiple: attr.Multiple, Required: attr.Required}
			if _, b := attrMap[attr.EntityName]; b {
				attrMap[attr.EntityName] = append(attrMap[attr.EntityName], attr, tmpAttr)
			} else {
				attrMap[attr.EntityName] = []*models.SyncDataModelCiAttr{attr, tmpAttr}
			}
		} else {
			if _, b := attrMap[attr.EntityName]; b {
				attrMap[attr.EntityName] = append(attrMap[attr.EntityName], attr)
			} else {
				attrMap[attr.EntityName] = []*models.SyncDataModelCiAttr{attr}
			}
		}
	}

	for _, ci := range ciTable {
		if _, b := attrMap[ci.Name]; b {
			ci.Attributes = attrMap[ci.Name]
		} else {
			ci.Attributes = []*models.SyncDataModelCiAttr{}
		}
		result.Data = append(result.Data, ci)
	}
	return
}

// GetExtendModelList 获取平台的数据模型
func GetExtendModelList(userToken string) (result []*models.OptionItemObj, err error) {
	responseBytes, respErr := doRequestPlatform("/platform/v1/models?withAttr=no", http.MethodGet, userToken, nil)
	if respErr != nil {
		err = respErr
		return
	}
	var response models.PlatformEntityQueryResponse
	if err = json.Unmarshal(responseBytes, &response); err != nil {
		err = fmt.Errorf("json unmarshal response fail,%s ", err.Error())
		return
	}
	if response.Status != "OK" {
		err = fmt.Errorf(response.Message)
		return
	}
	for _, v := range response.Data {
		if v.PackageName == "wecmdb" {
			continue
		}
		for _, entity := range v.Entities {
			result = append(result, &models.OptionItemObj{Value: fmt.Sprintf("%s:%s", v.PackageName, entity.Name), Label: entity.DisplayName})
		}
	}
	return
}

func GetExtendModelData(packageName, entity, id, userToken string) (result []map[string]interface{}, err error) {
	param := models.EntityQueryParam{}
	if id != "" {
		param.Criteria = models.EntityQueryObj{AttrName: "id", Op: "eq", Condition: id}
	}
	responseBytes, respErr := doRequestPlatform(fmt.Sprintf("/%s/entities/%s/query", packageName, entity), http.MethodPost, userToken, &param)
	if respErr != nil {
		err = respErr
		return
	}
	var response models.EntityResponse
	if err = json.Unmarshal(responseBytes, &response); err != nil {
		err = fmt.Errorf("json unmarshal response fail,%s ", err.Error())
		return
	}
	if response.Status != "OK" {
		err = fmt.Errorf(response.Message)
		return
	}
	result = response.Data
	return
}

func doRequestPlatform(url, method, token string, postData interface{}) (responseBytes []byte, err error) {
	var req *http.Request
	if method == http.MethodGet {
		req, err = http.NewRequest(http.MethodGet, models.Config.Wecube.BaseUrl+url, nil)
	} else if method == http.MethodPost {
		postBytes, jsonParseErr := json.Marshal(postData)
		if jsonParseErr != nil {
			err = fmt.Errorf("json marshal postData fail,%s ", jsonParseErr.Error())
			return
		}
		req, err = http.NewRequest(http.MethodPost, models.Config.Wecube.BaseUrl+url, bytes.NewReader(postBytes))
	}
	if err != nil {
		err = fmt.Errorf("Start new request to platform fail:%s ", err.Error())
		return
	}
	req.Header.Set("Authorization", token)
	req.Header.Set("Content-Type", "application/json")
	requestId := "req_" + guid.CreateGuid()
	req.Header.Set("RequestId", requestId)
	log.Logger.Debug("doRequest to Platform start --->", log.String("requestId", requestId), log.String("url", url), log.String("method", method))
	resp, respErr := http.DefaultClient.Do(req)
	if respErr != nil {
		err = fmt.Errorf("Start do request to platform fail:%s ", respErr.Error())
		return
	}
	log.Logger.Debug("doRequest to Platform end <---", log.String("requestId", requestId), log.String("url", url), log.String("method", method))
	if responseBytes, err = io.ReadAll(resp.Body); err != nil {
		err = fmt.Errorf("Try to read response body fail,%s ", err.Error())
		return
	}
	resp.Body.Close()
	return
}
