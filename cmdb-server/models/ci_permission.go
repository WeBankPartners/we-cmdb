package models

import "time"

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
	Guid            string                 `json:"guid" xorm:"guid"`
	RoleId          string                 `json:"roleId" xorm:"role_id"`
	CiType          string                 `json:"ciTypeId" xorm:"ci_type"`
	CiTypeName      string                 `json:"ciTypeName" xorm:"ci_type_name"`
	Insert          string                 `json:"insert" xorm:"insert"`
	Delete          string                 `json:"delete" xorm:"delete"`
	Update          string                 `json:"update" xorm:"update"`
	Query           string                 `json:"query" xorm:"query"`
	Execution       string                 `json:"execute" xorm:"execute"`
	Confirm         string                 `json:"confirm" xorm:"confirm"`
	Attrs           []*CiAttrPermissionObj `json:"attrs" xorm:"-"`
	ConditionEnable bool                   `json:"conditionEnable" xorm:"-"`
	ListRowEnable   bool                   `json:"listRowEnable" xorm:"-"`
}

type CiAttrPermissionObj struct {
	Guid            string `json:"guid" xorm:"guid"`
	RoleId          string `json:"roleId" xorm:"role_id"`
	CiType          string `json:"ciTypeId" xorm:"ci_type"`
	CiTypeAttr      string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiAttrName      string `json:"ciAttrName" xorm:"ci_attr_name"`
	Insert          string `json:"insert" xorm:"insert"`
	Delete          string `json:"delete" xorm:"delete"`
	Update          string `json:"update" xorm:"update"`
	Query           string `json:"query" xorm:"query"`
	Execution       string `json:"execute" xorm:"execute"`
	Confirm         string `json:"confirm" xorm:"confirm"`
	ConditionEnable bool   `json:"conditionEnable" xorm:"-"`
	ListRowEnable   bool   `json:"listRowEnable" xorm:"-"`
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
	Guid                   string   `json:"roleCiTypeConditionFilterGuid" xorm:"guid"`
	RoleCiTypeCondition    string   `json:"roleCiTypeConditionGuid" xorm:"role_ci_type_condition"`
	PermissionConditionTpl string   `json:"permissionConditionTpl" xorm:"permission_condition_tpl"`
	CiTypeAttr             string   `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiTypeAttrName         string   `json:"ciTypeAttrName" xorm:"ci_type_attr_name"`
	Expression             string   `json:"expression" xorm:"expression"`
	ConditionValueExprs    []string `json:"conditionValueExprs" xorm:"-"`
	FilterType             string   `json:"filterType" xorm:"filter_type"`
	SelectList             string   `json:"selectList" xorm:"select_list"`
	SelectValues           []string `json:"selectValues" xorm:"-"`
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
	Guid              string                               `json:"roleConditionGuid" xorm:"guid"`
	RoleCiTypeId      string                               `json:"roleCiType" xorm:"role_ci_type"`
	PermissionCiTplId string                               `json:"permissionCiTpl" xorm:"permission_ci_tpl"`
	Insert            string                               `json:"insert" xorm:"insert"`
	Delete            string                               `json:"delete" xorm:"delete"`
	Update            string                               `json:"update" xorm:"update"`
	Query             string                               `json:"query" xorm:"query"`
	Execution         string                               `json:"execute" xorm:"execute"`
	Confirm           string                               `json:"confirm" xorm:"confirm"`
	Filters           []*SysRoleCiTypeConditionFilterTable `json:"filters" xorm:"filters"`
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

type SysPermissionTplTable struct {
	Id         string    `json:"id" xorm:"id"`
	Name       string    `json:"name" xorm:"name"`
	CreateUser string    `json:"createUser" xorm:"create_user"`
	CreateTime time.Time `json:"createTime" xorm:"create_time"`
	UpdateUser string    `json:"updateUser" xorm:"update_user"`
	UpdateTime time.Time `json:"updateTime" xorm:"update_time"`
}

type SysRoleTplPermissionTable struct {
	Id                string `json:"id" xorm:"id"`
	RoleId            string `json:"roleId" xorm:"role_id"`
	PermissionTpl     string `json:"permissionTpl" xorm:"permission_tpl"`
	ParamConfig       string `json:"paramConfig" xorm:"param_config"`
	PermissionTplName string `json:"permissionTplName" json:"permission_tpl_name"` // 查询字段
}

type SysPermissionCiTplTable struct {
	Guid          string `json:"guid" xorm:"guid"`
	PermissionTpl string `json:"permissionTpl" xorm:"permission_tpl"`
	CiType        string `json:"ciType" xorm:"ci_type"`
	Insert        string `json:"insert" xorm:"insert"`
	Delete        string `json:"delete" xorm:"delete"`
	Update        string `json:"update" xorm:"update"`
	Query         string `json:"query" xorm:"query"`
	Execution     string `json:"execute" xorm:"execute"`
	Confirm       string `json:"confirm" xorm:"confirm"`
	CiTypeAttr    string `json:"ciTypeAttr" xorm:"ci_type_attr"`
}

type SysPermissionConditionTplTable struct {
	Guid            string `json:"guid" xorm:"guid"`
	PermissionCiTpl string `json:"permissionCiTpl" xorm:"permission_ci_tpl"`
	Insert          string `json:"insert" xorm:"insert"`
	Delete          string `json:"delete" xorm:"delete"`
	Update          string `json:"update" xorm:"update"`
	Query           string `json:"query" xorm:"query"`
	Execution       string `json:"execute" xorm:"execute"`
	Confirm         string `json:"confirm" xorm:"confirm"`
}

type SysPermissionConditionFilterTplTable struct {
	Guid                   string   `json:"roleCiTypeConditionFilterGuid" xorm:"guid"`
	PermissionConditionTpl string   `json:"permissionConditionTpl" xorm:"permission_condition_tpl"`
	CiTypeAttr             string   `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiTypeAttrName         string   `json:"ciTypeAttrName" xorm:"ci_type_attr_name"`
	Expression             string   `json:"expression" xorm:"expression"`
	ConditionValueExprs    []string `json:"conditionValueExprs" xorm:"-"`
	FilterType             string   `json:"filterType" xorm:"filter_type"`
	SelectList             string   `json:"selectList" xorm:"select_list"`
	SelectValues           []string `json:"selectValues" xorm:"-"`
	ParamList              string   `json:"paramList" xorm:"param_list"`
}

type SysPermissionListTplTable struct {
	Guid            string `json:"guid" xorm:"guid"`
	PermissionCiTpl string `json:"permissionCiTpl" xorm:"permission_ci_tpl"`
	List            string `json:"list" xorm:"list"`
	ListName        string `json:"listName" xorm:"-"`
	Insert          string `json:"insert" xorm:"insert"`
	Delete          string `json:"delete" xorm:"delete"`
	Update          string `json:"update" xorm:"update"`
	Query           string `json:"query" xorm:"query"`
	Execution       string `json:"execute" xorm:"execute"`
	Confirm         string `json:"confirm" xorm:"confirm"`
}

type PermissionTplData struct {
	Id       string                    `json:"id"`
	Name     string                    `json:"name" binding:"required"`
	Configs  []*CiTypePermissionTplObj `json:"configs"`
	Operator string                    `json:"operator,omitempty"`
}

type CiTypePermissionTplObj struct {
	Guid            string                    `json:"guid" xorm:"guid"`
	PermissionTpl   string                    `json:"permissionTpl" xorm:"permission_tpl"`
	CiType          string                    `json:"ciTypeId" xorm:"ci_type"`
	CiTypeName      string                    `json:"ciTypeName" xorm:"ci_type_name"`
	Insert          string                    `json:"insert" xorm:"insert"`
	Delete          string                    `json:"delete" xorm:"delete"`
	Update          string                    `json:"update" xorm:"update"`
	Query           string                    `json:"query" xorm:"query"`
	Execution       string                    `json:"execute" xorm:"execute"`
	Confirm         string                    `json:"confirm" xorm:"confirm"`
	Attrs           []*CiAttrPermissionTplObj `json:"attrs" xorm:"-"`
	ConditionEnable bool                      `json:"conditionEnable" xorm:"-"`
	ListRowEnable   bool                      `json:"listRowEnable" xorm:"-"`
}

type CiAttrPermissionTplObj struct {
	Guid            string `json:"guid" xorm:"guid"`
	CiType          string `json:"ciTypeId" xorm:"ci_type"`
	CiTypeAttr      string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiAttrName      string `json:"ciAttrName" xorm:"ci_attr_name"`
	Insert          string `json:"insert" xorm:"insert"`
	Delete          string `json:"delete" xorm:"delete"`
	Update          string `json:"update" xorm:"update"`
	Query           string `json:"query" xorm:"query"`
	Execution       string `json:"execute" xorm:"execute"`
	Confirm         string `json:"confirm" xorm:"confirm"`
	ConditionEnable bool   `json:"conditionEnable" xorm:"-"`
	ListRowEnable   bool   `json:"listRowEnable" xorm:"-"`
}

type PermissionTplParam struct {
	PermissionTplId   string                         `json:"permissionTplId"`
	PermissionTplName string                         `json:"permissionTplName"`
	Params            []*PermissionTplFilterParamObj `json:"params"`
}

type PermissionTplFilterParamObj struct {
	PermissionCiTplId        string `json:"permissionCiTplId"`
	ConditionTplId           string `json:"conditionTplId"`
	ConditionFilterTplId     string `json:"conditionFilterTplId"`
	CiType                   string `json:"ciType"`
	CiTypeDisplayName        string `json:"ciTypeDisplayName,omitempty"`
	SensitiveAttr            string `json:"sensitiveAttr"`
	SensitiveAttrName        string `json:"sensitiveAttrName"`
	SensitiveAttrDisplayName string `json:"sensitiveAttrDisplayName,omitempty"`
	FilterExpression         string `json:"filterExpression"`
	FilterAttr               string `json:"filterAttr"`
	FilterAttrName           string `json:"filterAttrName"`
	FilterAttrDisplayName    string `json:"filterAttrDisplayName,omitempty"`
	FilterParamName          string `json:"filterParamName"`
	FilterParamDefaultValue  string `json:"filterParamDefaultValue"`
	FilterParamValue         string `json:"filterParamValue"`
}

type TplConditionListQueryObj struct {
	Guid                   string `json:"roleCiTypeConditionFilterGuid" xorm:"guid"`
	PermissionConditionTpl string `json:"permissionConditionTpl" xorm:"permission_condition_tpl"`
	CiTypeAttr             string `json:"ciTypeAttr" xorm:"ci_type_attr"`
	CiTypeAttrName         string `json:"ciTypeAttrName" xorm:"ci_type_attr_name"`
	Expression             string `json:"expression" xorm:"expression"`
	PermissionCiTpl        string `json:"permissionCiTpl" xorm:"permission_ci_tpl"`
	Insert                 string `json:"insert" xorm:"insert"`
	Delete                 string `json:"delete" xorm:"delete"`
	Update                 string `json:"update" xorm:"update"`
	Query                  string `json:"query" xorm:"query"`
	Execution              string `json:"execute" xorm:"execute"`
	Confirm                string `json:"confirm" xorm:"confirm"`
	FilterType             string `json:"filterType" xorm:"filter_type"`
	SelectList             string `json:"selectList" xorm:"select_list"`
}

type PermissionTplFilterParamSortList []*PermissionTplFilterParamObj

func (c PermissionTplFilterParamSortList) Len() int {
	return len(c)
}

func (c PermissionTplFilterParamSortList) Swap(i, j int) {
	c[i], c[j] = c[j], c[i]
}

func (c PermissionTplFilterParamSortList) Less(i, j int) bool {
	if c[i].PermissionCiTplId > c[j].PermissionCiTplId {
		return true
	} else if c[i].PermissionCiTplId == c[j].PermissionCiTplId {
		if c[i].ConditionTplId > c[j].ConditionTplId {
			return true
		} else if c[i].ConditionTplId == c[j].ConditionTplId {
			if c[i].FilterAttrName > c[j].FilterAttrName {
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}
	return false
}
