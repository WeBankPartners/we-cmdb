package models

type EntityQueryParam struct {
	Criteria          EntityQueryObj    `json:"criteria"`
	AdditionalFilters []*EntityQueryObj `json:"additionalFilters"`
}

type EntityQueryObj struct {
	AttrName  string      `json:"attrName"`
	Op        string      `json:"op"`
	Condition interface{} `json:"condition"`
}

type EntityResponse struct {
	Status  string                   `json:"status"`
	Message string                   `json:"message"`
	Data    []map[string]interface{} `json:"data"`
}

type SyncDataModelResponse struct {
	Status  string                 `json:"status"`
	Message string                 `json:"message"`
	Data    []*SyncDataModelCiType `json:"data"`
}

type SyncDataModelCiType struct {
	Name        string                 `json:"name" xorm:"id"`
	DisplayName string                 `json:"displayName" xorm:"display_name"`
	Description string                 `json:"description" xorm:"description"`
	Attributes  []*SyncDataModelCiAttr `json:"attributes" xorm:"-"`
}

type SyncDataModelCiAttr struct {
	Name             string `json:"name" xorm:"name"`
	EntityName       string `json:"entityName" xorm:"ci_type"`
	Description      string `json:"description" xorm:"description"`
	DataType         string `json:"dataType" xorm:"input_type"`
	RefPackageName   string `json:"refPackageName" xorm:"-"`
	RefEntityName    string `json:"refEntityName" xorm:"ref_ci_type"`
	RefAttributeName string `json:"refAttributeName" xorm:"-"`
	Required         string `json:"required" xorm:"nullable"`
	Multiple         string `json:"multiple"`
}

type PluginCiDataOperationRequest struct {
	RequestId string                             `json:"requestId"`
	Inputs    []*PluginCiDataOperationRequestObj `json:"inputs"`
}

type PluginCiDataOperationRequestObj struct {
	CallbackParameter string `json:"callbackParameter"`
	CiType            string `json:"ciType"`
	Operation         string `json:"operation"`
	JsonData          string `json:"jsonData"`
}

type PluginCiDataAttrValueRequest struct {
	RequestId string                             `json:"requestId"`
	Inputs    []*PluginCiDataAttrValueRequestObj `json:"inputs"`
}

type PluginCiDataAttrValueRequestObj struct {
	CallbackParameter string `json:"callbackParameter"`
	CiType            string `json:"ciType"`
	Guid              string `json:"guid"`
	CiTypeAttr        string `json:"ciTypeAttr"`
	Value             string `json:"value"`
}

type PluginCiDataOperationResp struct {
	ResultCode    string                      `json:"resultCode"`
	ResultMessage string                      `json:"resultMessage"`
	Results       PluginCiDataOperationOutput `json:"results"`
}

type PluginCiDataOperationOutput struct {
	Outputs []*PluginCiDataOperationOutputObj `json:"outputs"`
}

type PluginCiDataOperationOutputObj struct {
	CallbackParameter string `json:"callbackParameter"`
	Guid              string `json:"guid"`
	ErrorCode         string `json:"errorCode"`
	ErrorMessage      string `json:"errorMessage"`
	ErrorDetail       string `json:"errorDetail,omitempty"`
}

type CoreRoleDto struct {
	Status  string            `json:"status"`
	Message string            `json:"message"`
	Data    []CoreRoleDataObj `json:"data"`
}

type CoreRoleDataObj struct {
	Id          string `json:"id"`
	Name        string `json:"name"`
	Email       string `json:"email"`
	DisplayName string `json:"displayName"`
}
