package models

type SysRoleCiTypeTable struct {
	Guid       string `json:"guid" xorm:"guid"`
	RoleId     string `json:"roleId" xorm:"role_id"`
	CiType     string `json:"ciTypeId" xorm:"ci_type"`
	Insert     string `json:"insert" xorm:"insert"`
	Delete     string `json:"delete" xorm:"delete"`
	Update     string `json:"update" xorm:"update"`
	Query      string `json:"query" xorm:"query"`
	Execution  string `json:"execute" xorm:"execute"`
	Confirm    string `json:"confirm" xorm:"confirm"`
	CiTypeAttr string `json:"ciTypeAttr" xorm:"ci_type_attr"`
}

type CiTypePermissionObj struct {
	Guid       string                 `json:"guid" xorm:"guid"`
	RoleId     string                 `json:"roleId" xorm:"role_id"`
	CiType     string                 `json:"ciTypeId" xorm:"ci_type"`
	CiTypeName string                 `json:"ciTypeName" xorm:"ci_type_name"`
	Insert     string                 `json:"insert" xorm:"insert"`
	Delete     string                 `json:"delete" xorm:"delete"`
	Update     string                 `json:"update" xorm:"update"`
	Query      string                 `json:"query" xorm:"query"`
	Execution  string                 `json:"execute" xorm:"execute"`
	Confirm    string                 `json:"confirm" xorm:"confirm"`
	Attrs      []*CiAttrPermissionObj `json:"attrs" xorm:"-"`
}

type CiAttrPermissionObj struct {
	Guid       string `json:"guid" xorm:"guid"`
	RoleId     string `json:"roleId" xorm:"role_id"`
	CiType     string `json:"ciTypeId" xorm:"ci_type"`
	CiTypeAttr string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiAttrName string `json:"ciAttrName" xorm:"ci_attr_name"`
	Insert     string `json:"insert" xorm:"insert"`
	Delete     string `json:"delete" xorm:"delete"`
	Update     string `json:"update" xorm:"update"`
	Query      string `json:"query" xorm:"query"`
	Execution  string `json:"execute" xorm:"execute"`
	Confirm    string `json:"confirm" xorm:"confirm"`
}

type SysRoleCiTypeConditionTable struct {
	Guid       string `json:"guid" xorm:"guid"`
	RoleCiType string `json:"roleCiType" xorm:"role_ci_type"`
	Insert     string `json:"insert" xorm:"insert"`
	Delete     string `json:"delete" xorm:"delete"`
	Update     string `json:"update" xorm:"update"`
	Query      string `json:"query" xorm:"query"`
	Execution  string `json:"execute" xorm:"execute"`
	Confirm    string `json:"confirm" xorm:"confirm"`
}

type SysRoleCiTypeConditionFilterTable struct {
	Guid                string   `json:"roleCiTypeConditionFilterGuid" xorm:"guid"`
	RoleCiTypeCondition string   `json:"roleCiTypeConditionGuid" xorm:"role_ci_type_condition"`
	CiTypeAttr          string   `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiTypeAttrName      string   `json:"ciTypeAttrName" xorm:"ci_type_attr_name"`
	Expression          string   `json:"expression" xorm:"expression"`
	ConditionValueExprs []string `json:"conditionValueExprs" xorm:"-"`
	FilterType          string   `json:"filterType" xorm:"filter_type"`
	SelectList          string   `json:"selectList" xorm:"select_list"`
	SelectValues        []string `json:"selectValues" xorm:"-"`
}

type SysRoleCiTypeListTable struct {
	Guid       string `json:"guid" xorm:"guid"`
	RoleCiType string `json:"roleCiType" xorm:"role_ci_type"`
	List       string `json:"list" xorm:"list"`
	ListName   string `json:"listName" xorm:"-"`
	Insert     string `json:"insert" xorm:"insert"`
	Delete     string `json:"delete" xorm:"delete"`
	Update     string `json:"update" xorm:"update"`
	Query      string `json:"query" xorm:"query"`
	Execution  string `json:"execute" xorm:"execute"`
	Confirm    string `json:"confirm" xorm:"confirm"`
}

type RolePermissionQuery struct {
	Role              string                 `json:"-"`
	User              string                 `json:"-"`
	MenuPermissions   []string               `json:"menuPermissions"`
	CiTypePermissions []*CiTypePermissionObj `json:"ciTypePermissionObj"`
}

type RoleAttrConditionObj struct {
	Guid         string                               `json:"roleConditionGuid" xorm:"guid"`
	RoleCiTypeId string                               `json:"roleCiType" xorm:"role_ci_type"`
	Insert       string                               `json:"insert" xorm:"insert"`
	Delete       string                               `json:"delete" xorm:"delete"`
	Update       string                               `json:"update" xorm:"update"`
	Query        string                               `json:"query" xorm:"query"`
	Execution    string                               `json:"execute" xorm:"execute"`
	Confirm      string                               `json:"confirm" xorm:"confirm"`
	Filters      []*SysRoleCiTypeConditionFilterTable `json:"filters" xorm:"filters"`
}

type RoleAttrConditionResult struct {
	Body   []map[string]interface{}      `json:"body"`
	Header []*RoleAttrConditionHeaderObj `json:"header"`
}

type RoleAttrConditionHeaderObj struct {
	SysCiTypeAttrTable
	Options []*RoleAttrOptionItem `json:"options"`
}

type RoleAttrOptionItem struct {
	Label string `json:"label"`
	Value string `json:"value"`
}

type CiDataPermission struct {
	CiType    string
	ConfigMap map[string]*RoleCiTypePermissionObj
	Insert    bool
	Delete    bool
	Update    bool
	Query     bool
	Execute   bool
	Confirm   bool
}

type CiDataLegalGuidList struct {
	Legal    bool // legal for all
	GuidList []string
}

type ConditionListQueryObj struct {
	Guid                string `json:"roleCiTypeConditionFilterGuid" xorm:"guid"`
	RoleCiTypeCondition string `json:"roleCiTypeConditionGuid" xorm:"role_ci_type_condition"`
	CiTypeAttr          string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiTypeAttrName      string `json:"ciTypeAttrName" xorm:"ci_type_attr_name"`
	Expression          string `json:"expression" xorm:"expression"`
	RoleCiType          string `json:"roleCiType" xorm:"role_ci_type"`
	Insert              string `json:"insert" xorm:"insert"`
	Delete              string `json:"delete" xorm:"delete"`
	Update              string `json:"update" xorm:"update"`
	Query               string `json:"query" xorm:"query"`
	Execution           string `json:"execute" xorm:"execute"`
	Confirm             string `json:"confirm" xorm:"confirm"`
	FilterType          string `json:"filterType" xorm:"filter_type"`
	SelectList          string `json:"selectList" xorm:"select_list"`
}

type RoleCiTypePermissionObj struct {
	Conditions []*RoleAttrConditionObj
	List       []*SysRoleCiTypeListTable
}

type RoleAttrConditionExtendObj struct {
	Expression   string   `json:"expression"`
	SelectValues []string `json:"selectValues"`
}

type AttrPermissionQueryObj struct {
	HistoryId        int    `json:"historyId,omitempty"`
	CiType           string `json:"ciType" binding:"required"`
	AttrName         string `json:"attrName" binding:"required"`
	Guid             string `json:"guid" binding:"required"`
	QueryPermission  bool   `json:"queryPermission"`
	UpdatePermission bool   `json:"updatePermission"`
	Value            string `json:"value"`
}
