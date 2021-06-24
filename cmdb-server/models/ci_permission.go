package models

type SysRoleCiTypeTable struct {
	Guid      string `json:"guid" xorm:"guid"`
	RoleId    string `json:"roleId" xorm:"role_id"`
	CiType    string `json:"ciTypeId" xorm:"ci_type"`
	Insert    string `json:"insert" xorm:"insert"`
	Delete    string `json:"delete" xorm:"delete"`
	Update    string `json:"update" xorm:"update"`
	Query     string `json:"query" xorm:"query"`
	Execution string `json:"execute" xorm:"execute"`
}

type CiTypePermissionObj struct {
	Guid       string `json:"guid" xorm:"guid"`
	RoleId     string `json:"roleId" xorm:"role_id"`
	CiType     string `json:"ciTypeId" xorm:"ci_type"`
	CiTypeName string `json:"ciTypeName" xorm:"ci_type_name"`
	Insert     string `json:"insert" xorm:"insert"`
	Delete     string `json:"delete" xorm:"delete"`
	Update     string `json:"update" xorm:"update"`
	Query      string `json:"query" xorm:"query"`
	Execution  string `json:"execute" xorm:"execute"`
}

type SysRoleCiTypeConditionTable struct {
	Guid       string `json:"guid" xorm:"guid"`
	RoleCiType string `json:"roleCiType" xorm:"role_ci_type"`
	Insert     string `json:"insert" xorm:"insert"`
	Delete     string `json:"delete" xorm:"delete"`
	Update     string `json:"update" xorm:"update"`
	Query      string `json:"query" xorm:"query"`
	Execution  string `json:"execute" xorm:"execute"`
}

type SysRoleCiTypeConditionFilterTable struct {
	Guid                string   `json:"roleCiTypeConditionFilterGuid" xorm:"guid"`
	RoleCiTypeCondition string   `json:"roleCiTypeConditionGuid" xorm:"role_ci_type_condition"`
	CiTypeAttr          string   `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiTypeAttrName      string   `json:"ciTypeAttrName" xorm:"ci_type_attr_name"`
	Expression          string   `json:"expression" xorm:"expression"`
	ConditionValueExprs []string `json:"conditionValueExprs" xorm:"-"`
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
	Filters      []*SysRoleCiTypeConditionFilterTable `json:"filters" xorm:"filters"`
}

type RoleAttrConditionResult struct {
	Body   []map[string]interface{} `json:"body"`
	Header []*SysCiTypeAttrTable    `json:"header"`
}

type CiDataPermission struct {
	CiType    string
	ConfigMap map[string]*RoleCiTypePermissionObj
	Insert    bool
	Delete    bool
	Update    bool
	Query     bool
	Execute   bool
}

type CiDataLegalGuidList struct {
	Enable   bool
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
}

type RoleCiTypePermissionObj struct {
	Conditions []*RoleAttrConditionObj
	List       []*SysRoleCiTypeListTable
}
