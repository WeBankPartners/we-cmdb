package models

import "time"

type SysWecubeProcessTable struct {
	Guid                  string    `json:"guid"`
	CiDataGuid            string    `json:"ci_data_guid"`
	WecubeProcInstanceTmp string    `json:"wecube_proc_instance_tmp"`
	WecubeProcInstance    string    `json:"wecube_proc_instance"`
	WecubeProcDefine      string    `json:"wecube_proc_define"`
	Status                string    `json:"status"`
	UpdateTime            time.Time `json:"update_time"`
}

type CoreProcessQueryResponse struct {
	Status  string                 `json:"status"`
	Message string                 `json:"message"`
	Data    []*CodeProcessQueryObj `json:"data"`
}

type CodeProcessQueryObj struct {
	ExcludeMode          string      `json:"excludeMode"`
	ProcDefId            string      `json:"procDefId"`
	ProcDefKey           string      `json:"procDefKey"`
	ProcDefName          string      `json:"procDefName"`
	ProcDefVersion       string      `json:"procDefVersion"`
	RootEntity           interface{} `json:"rootEntity"`
	Status               string      `json:"status"`
	CreatedTime          string      `json:"createdTime"`
	CreatedUnixTime      int64       `json:"-"`
	Tags                 string      `json:"tags"`
	RootEntityExpression string      `json:"rootEntityExpression"`
}

type ProcEntity struct {
	Id          string `json:"id"`
	PackageName string `json:"packageName"`
	Name        string `json:"name"`
	Description string `json:"description"`
	DisplayName string `json:"displayName"`
}

type CoreProcessRequest struct {
	EventSeqNo      string `json:"eventSeqNo"`
	EventType       string `json:"eventType"`
	SourceSubSystem string `json:"sourceSubSystem"`
	OperationKey    string `json:"operationKey"`
	OperationData   string `json:"operationData"`
	NotifyRequired  string `json:"notifyRequired"`
	NotifyEndpoint  string `json:"notifyEndpoint"`
	OperationUser   string `json:"operationUser"`
	OperationMode   string `json:"operationMode"`
}

type CoreStartProcess struct {
	Status  string               `json:"status"`
	Message string               `json:"message"`
	Data    CoreStartProcessData `json:"data"`
}

type CoreStartProcessData struct {
	ProcInstId        string                  `json:"procInstId"`
	Status            string                  `json:"status"`
	TaskNodeInstances []*CoreStartProcessData `json:"taskNodeInstances"`
}

type CoreProcessResult struct {
	Status  string                `json:"status"`
	Message string                `json:"message"`
	Data    CoreProcessResultData `json:"data"`
}

type CoreProcessResultData struct {
	ProcInstId        interface{}              `json:"procInstId"`
	Status            string                   `json:"status"`
	TaskNodeInstances []*CoreProcessResultData `json:"taskNodeInstances"`
}

type CiDataCallbackParam struct {
	CiType        string `json:"ciType"`
	RowGuid       string `json:"rowGuid"`
	ProcessKey    string `json:"processKey"`
	ProcessName   string `json:"processName"`
	OperationUser string `json:"operationUser"`
	UserToken     string `json:"userToken"`
}

type CiDataActionQuery struct {
	Title      []*CiDataActionQueryTitle `json:"title"`
	Data       []map[string]interface{}  `json:"data"`
	Selectable bool                      `json:"selectable"`
}

type CiDataActionQueryTitle struct {
	Id   string `json:"key"`
	Name string `json:"title"`
	Type string `json:"type"`
}
