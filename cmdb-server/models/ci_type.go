package models

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
	StateMachine string `json:"stateMachine" xorm:"state_machine"`
}

type SysFilesTable struct {
	Guid    string `json:"guid"`
	Type    string `json:"type"`
	Content []byte `json:"content"`
}
