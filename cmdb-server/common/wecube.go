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

type PluginViewConfirmRequest struct {
	RequestId string                         `json:"requestId"`
	Inputs    []*PluginViewConfirmRequestObj `json:"inputs"`
}

type PluginViewConfirmRequestObj struct {
	CallbackParameter string `json:"callbackParameter"`
	ViewId            string `json:"viewId"`
	RootCi            string `json:"rootCi"`
}

type PluginViewConfirmResp struct {
	ResultCode    string                  `json:"resultCode"`
	ResultMessage string                  `json:"resultMessage"`
	Results       PluginViewConfirmOutput `json:"results"`
}

type PluginViewConfirmOutput struct {
	Outputs []*PluginViewConfirmOutputObj `json:"outputs"`
}

type PluginViewConfirmOutputObj struct {
	CallbackParameter string `json:"callbackParameter"`
	ConfirmTime       string `json:"confirmTime"`
	ErrorCode         string `json:"errorCode"`
	ErrorMessage      string `json:"errorMessage"`
	ErrorDetail       string `json:"errorDetail,omitempty"`
}

type PlatformDataModel struct {
	Id           string                     `json:"id" xorm:"id"`                      // 唯一标识
	Version      int                        `json:"version" xorm:"version"`            // 版本
	PackageName  string                     `json:"packageName" xorm:"package_name"`   // 包名
	IsDynamic    bool                       `json:"dynamic" xorm:"is_dynamic"`         // 是否动态
	UpdatePath   string                     `json:"updatePath" xorm:"update_path"`     // 请求路径
	UpdateMethod string                     `json:"updateMethod" xorm:"update_method"` // 请求方法
	UpdateSource string                     `json:"updateSource" xorm:"update_source"` // 来源
	Entities     []*PlatformDataModelEntity `json:"entities"`
}

type PlatformDataModelEntity struct {
	Id               string `json:"id" xorm:"id"`                               // 唯一标识
	DataModelId      string `json:"dataModelId" xorm:"data_model_id"`           // 所属数据模型
	DataModelVersion int    `json:"dataModelVersion" xorm:"data_model_version"` // 版本
	PackageName      string `json:"packageName" xorm:"package_name"`            // 包名
	Name             string `json:"name" xorm:"name"`                           // 模型名
	DisplayName      string `json:"displayName" xorm:"display_name"`            // 显示名
	Description      string `json:"description" xorm:"description"`             // 描述
}

type PlatformEntityQueryResponse struct {
	Code    int                  `json:"code"`
	Status  string               `json:"status"`
	Message string               `json:"message"`
	Data    []*PlatformDataModel `json:"data"`
}
