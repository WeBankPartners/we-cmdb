package models

import "time"

var (
	CiStatusList = []string{"created", "notCreated", "dirty", "deleted"}
)

type SysCiTypeTable struct {
	Id           string `json:"ciTypeId" xorm:"id" binding:"required"`
	DisplayName  string `json:"name" xorm:"display_name"`
	Description  string `json:"description" xorm:"description"`
	Status       string `json:"status" xorm:"status"`
	ImageFile    string `json:"imageFile" xorm:"image_file"`
	FileName     string `json:"fileName" xorm:"file_name"`
	CiGroup      string `json:"ciGroup" xorm:"ci_group"`
	CiLayer      string `json:"ciLayer" xorm:"ci_layer"`
	CiTemplate   string `json:"ciTemplate" xorm:"ci_template"`
	StateMachine string `json:"stateMachine" xorm:"state_machine"`
	SeqNo        string `json:"seqNo" xorm:"seq_no"`
	SyncEnable   string `json:"syncEnable" xorm:"sync_enable"`
}

type DatabaseTableList struct {
	TableName string `xorm:"TABLE_NAME"`
}

type CiTypeQuery struct {
	CiTypeId       string   `json:"ciTypeId"`
	GroupBy        string   `json:"group-by"`
	Group          []string `json:"group"`
	Layer          []string `json:"layer"`
	WithAttributes string   `json:"with-attributes"`
	AttrInputType  []string `json:"attr-input-type"`
	Status         []string `json:"status"`
	AttrTypeStatus []string `json:"attr-type-status"`
	GroupData      []*CiTypeQueryGroupObj
	CiTypeListData []*CiTypeQueryCiObj
}

type CiTypeQueryGroupObj struct {
	Id          string              `json:"codeId" xorm:"id"`
	CatGuid     string              `json:"catId" xorm:"cat_guid"`
	Code        string              `json:"code" xorm:"code"`
	Value       string              `json:"value" xorm:"value"`
	Description string              `json:"codeDescription" xorm:"description"`
	SeqNo       int                 `json:"seqNo" xorm:"seq_no"`
	Status      string              `json:"status" xorm:"status"`
	CiTypes     []*CiTypeQueryCiObj `json:"ciTypes"`
}

type CiTypeQueryCiObj struct {
	Id           string                `json:"ciTypeId" xorm:"id" binding:"required"`
	DisplayName  string                `json:"name" xorm:"display_name" binding:"required"`
	Description  string                `json:"description" xorm:"description"`
	Status       string                `json:"status" xorm:"status"`
	ImageFile    string                `json:"imageFile" xorm:"image_file"`
	CiGroup      string                `json:"ciGroup" xorm:"ci_group"`
	CiLayer      string                `json:"ciLayer" xorm:"ci_layer"`
	CiTemplate   string                `json:"ciTemplate" xorm:"ci_template"`
	StateMachine string                `json:"stateMachine" xorm:"state_machine"`
	SeqNo        string                `json:"seqNo" xorm:"seq_no"`
	SyncEnable   string                `json:"syncEnable" xorm:"sync_enable"`
	Attributes   []*SysCiTypeAttrTable `json:"attributes"`
}

type CiSwapPositionParam struct {
	CiTypeId    string `json:"ciTypeId" binding:"required"`
	TargetIndex int    `json:"targetIndex"`
}

type SysCiTemplateTable struct {
	Id           string `json:"id" xorm:"id"`
	Description  string `json:"description" xorm:"description"`
	ImageFile    string `json:"imageFile" xorm:"image_file"`
	FileName     string `json:"fileName" xorm:"-"`
	StateMachine string `json:"stateMachine" xorm:"state_machine"`
}

type SysFilesTable struct {
	Guid    string `json:"guid"`
	Type    string `json:"type"`
	Content []byte `json:"content"`
}

type SysSyncRecordTable struct {
	ID           string      `json:"id" xorm:"id"`
	SyncType     string      `json:"syncType" xorm:"sync_type"`
	RemoteRepo   string      `json:"remoteRepo" xorm:"remote_repo"`
	ActionFunc   string      `json:"actionFunc" xorm:"action_func"`
	DataCategory string      `json:"dataCategory" xorm:"data_category"`
	DataType     string      `json:"dataType" xorm:"data_type"`
	Content      string      `json:"content" xorm:"content"`
	Source       string      `json:"source" xorm:"source"`
	SourceID     string      `json:"sourceId" xorm:"source_id"`
	Target       string      `json:"target" xorm:"target"`
	Status       string      `json:"status" xorm:"status"` // ok,fail,wait
	RetryCount   int         `json:"retryCount" xorm:"retry_count"`
	ErrorMsg     string      `json:"errorMsg" xorm:"error_msg"`
	CreateTime   time.Time   `json:"createTime" xorm:"create_time"`
	UpdateTime   time.Time   `json:"updateTime" xorm:"update_time"`
	Operator     string      `json:"operator" xorm:"operator"`
	ContentData  interface{} `json:"-" xorm:"-"`
	SyncDataIds  []string    `json:"-" xorm:"-"`
}

type SyncRecordQuery struct {
	Config *SyncConfig           `json:"config"`
	List   []*SysSyncRecordTable `json:"list"`
}

type SysSyncDataTable struct {
	ID          int       `json:"id" xorm:"id"`
	SyncRecord  string    `json:"syncRecord" xorm:"sync_record"`
	DataId      string    `json:"dataId" xorm:"data_id"`
	DataContent string    `json:"dataContent" xorm:"data_content"`
	Action      string    `json:"action" xorm:"action"`
	Operation   string    `json:"operation" xorm:"operation"`
	HandleTime  time.Time `json:"handleTime" xorm:"handle_time"`
	Status      string    `json:"status" xorm:"status"` // ok,fail,wait
	RetryCount  int       `json:"retryCount" xorm:"retry_count"`
	ErrorMsg    string    `json:"errorMsg" xorm:"error_msg"`
	CreateTime  time.Time `json:"createTime" xorm:"create_time"`
	UpdateTime  time.Time `json:"updateTime" xorm:"update_time"`
}
