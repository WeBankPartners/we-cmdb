package models

import (
	"fmt"
	"sort"
	"strings"
)

type CiDataMapObj map[string]string

type CiDataColumnObj struct {
	ColumnName  string
	ColumnValue interface{}
	ValueString string
}

type AutofillObj struct {
	Type  string `json:"type"`
	Value string `json:"value"`
}

type AutofillValueObj struct {
	CiTypeId string                `json:"ciTypeId"`
	ParentRs *AutofillValueAttrObj `json:"parentRs"`
	Filters  []*AutofillFilterObj  `json:"filters"`
}

type AutofillValueAttrObj struct {
	AttrId              string `json:"attrId"`
	IsReferedFromParent int    `json:"isReferedFromParent"`
}

type AutofillFilterObj struct {
	Name     string      `json:"name"`
	Code     string      `json:"code"`
	Operator string      `json:"operator"`
	Type     string      `json:"type"`
	Value    interface{} `json:"value"`
}

type SysStateMachineTable struct {
	Id          string `json:"id" xorm:"id"`
	Description string `json:"description" xorm:"description"`
	StartState  string `json:"startState" xorm:"start_state"`
	FinalState  string `json:"finalState" xorm:"final_state"`
}

type GetStateMachineList struct {
	Id          string                     `json:"id" xorm:"id"`
	Description string                     `json:"description" xorm:"description"`
	StartState  string                     `json:"startState" xorm:"start_state"`
	FinalState  string                     `json:"finalState" xorm:"final_state"`
	States      []*SysStateTable           `json:"states"`
	Transitions []*SysStateTransitionTable `json:"transitions"`
}

type ImportStateMachineResult struct {
	DiffFlag       bool                       `json:"diff_flag"`
	StateMachine   *SysStateMachineTable      `json:"state_machine"`
	OldStates      []*SysStateTable           `json:"old_states"`
	NewStates      []*SysStateTable           `json:"new_states"`
	OldTransitions []*SysStateTransitionTable `json:"old_transitions"`
	NewTransitions []*SysStateTransitionTable `json:"new_transitions"`
}

type SysStateTable struct {
	Id                string `json:"id" xorm:"id"`
	Name              string `json:"name" xorm:"name"`
	Description       string `json:"description" xorm:"description"`
	StateMachine      string `json:"stateMachine" xorm:"state_machine"`
	UniquePathTrigger string `json:"uniquePathTrigger" xorm:"unique_path_trigger"`
	IsConfirm         string `json:"isConfirm" xorm:"is_confirm"`
}

type SysStateTransitionTable struct {
	Guid              string `json:"guid" xorm:"guid"`
	StateMachine      string `json:"stateMachine" xorm:"state_machine"`
	CurrentState      string `json:"currentState" xorm:"current_state"`
	TargetState       string `json:"targetState" xorm:"target_state"`
	Operation         string `json:"operation" xorm:"operation"`
	OperationEn       string `json:"operation_en" xorm:"operation_en"`
	Permission        string `json:"permission" xorm:"permission"`
	Action            string `json:"action" xorm:"action"`
	OperationFormType string `json:"operationFormType" xorm:"operation_form_type"`
	OperationMultiple string `json:"operationMultiple" xorm:"operation_multiple"`
}

type SysStateTransitionQuery struct {
	CiType           string `json:"ci_type" xorm:"ci_type"`
	Guid             string `json:"guid" xorm:"guid"`
	StateMachine     string `json:"stateMachine" xorm:"state_machine"`
	CurrentState     string `json:"currentState" xorm:"current_state"`
	CurrentStateName string `json:"currentStateName" xorm:"current_state_name"`
	TargetState      string `json:"targetState" xorm:"target_state"`
	TargetStateName  string `json:"targetStateName" xorm:"target_state_name"`
	TargetIsConfirm  string `json:"targetIsConfirm" xorm:"target_is_confirm"`
	TargetUniquePath string `json:"targetUniquePath" xorm:"target_unique_path"`
	Operation        string `json:"operation" xorm:"operation"`
	OperationEn      string `json:"operation_en" xorm:"operation_en"`
	Action           string `json:"action" xorm:"action"`
	StartState       string `json:"start_state" xorm:"start_state"`
	FinalState       string `json:"final_state" xorm:"final_state"`
}

type BuildAttrValueParam struct {
	IsSystem        bool
	NowTime         string
	AttributeConfig *SysCiTypeAttrTable
	InputData       CiDataMapObj
	Action          string
}

type ActionFuncParam struct {
	CiType              string
	Attributes          []*SysCiTypeAttrTable
	ReferenceAttributes []*SysCiTypeAttrTable
	Transition          *SysStateTransitionQuery
	InputData           CiDataMapObj
	NowData             CiDataMapObj
	Operator            string
	NowTime             string
	RefCiTypeMap        map[string]*SysCiTypeTable
	UpdateColumn        []string
	BareAction          string
	DeleteList          []string
	FromCore            bool
}

type MultiCiDataObj struct {
	CiTypeId            string
	Transition          []*SysStateTransitionQuery
	Attributes          []*SysCiTypeAttrTable
	ReferenceAttributes []*SysCiTypeAttrTable
	NowData             []map[string]string
	InputData           []CiDataMapObj
	RefCiTypeMap        map[string]*SysCiTypeTable
}

type AttrRefFilterLegalObj struct {
	AttrName string
	GuidMap  map[string]bool
}

type CiQueryColumnObj struct {
	Name  string
	Index int
}

type CiDataRefDataObj struct {
	Guid        string `json:"guid"`
	KeyName     string `json:"key_name"`
	HistoryTime string `json:"-"`
}

type CiDataRefFilterRight struct {
	Type  string      `json:"type"`
	Value interface{} `json:"value"`
}

type CiDataRefFilterObj struct {
	Left     string               `json:"left"`
	Operator string               `json:"operator"`
	Right    CiDataRefFilterRight `json:"right"`
}

type HistoryGuidObj struct {
	Guid        string
	HistoryTime string
}

type CiDataQueryRefAttrObj struct {
	Attribute       *SysCiTypeAttrTable
	GuidList        []string
	HistoryGuidList []*HistoryGuidObj
	RefObj          map[string]*CiDataRefDataObj
	MultiGuidList   []string
	MultiRefObj     map[string][]*CiDataRefDataObj
}

type CiQueryColumnList []*CiQueryColumnObj

func (c CiQueryColumnList) Len() int {
	return len(c)
}

func (c CiQueryColumnList) Swap(i, j int) {
	c[i], c[j] = c[j], c[i]
}

func (c CiQueryColumnList) Less(i, j int) bool {
	if c[i].Index == c[j].Index {
		return c[i].Name < c[j].Name
	}
	return c[i].Index < c[j].Index
}

func (c CiQueryColumnList) GetNameList() []string {
	sort.Sort(c)
	nameList := []string{}
	for _, v := range c {
		nameList = append(nameList, v.Name)
	}
	return nameList
}

// Try to build sql to impl autofill
type AutofillRuleList []*AutofillValueObj

func (af AutofillRuleList) BuildBaseSql(prefix string) (sql, column string) {
	afLen := len(af)
	if afLen < 2 {
		return
	} else if afLen == 2 {
		column = af[1].ParentRs.AttrId
		column = column[strings.Index(column, "#")+1:]
		return
	}
	var whereSql string
	column = af[1].ParentRs.AttrId
	column = column[strings.Index(column, "#")+1:]
	if af[1].ParentRs.IsReferedFromParent == 1 {
		whereSql = fmt.Sprintf(" where %st1.guid=?", prefix)
	} else {
		whereSql = fmt.Sprintf(" where %st1.%s=?", prefix, column)
		column = "guid"
	}
	sql = fmt.Sprintf("select %st%d.%s from ", prefix, afLen-1, af[afLen-1].ParentRs.AttrId[strings.Index(af[afLen-1].ParentRs.AttrId, "#")+1:])
	for i, rule := range af {
		if i == 0 {
			continue
		}
		if rule.ParentRs.IsReferedFromParent == 0 && len(af[i].Filters) > 0 {

			continue
		}
		if i == 1 {
			sql += fmt.Sprintf(" %s %st%d ", af[i].CiTypeId, prefix, i)
			continue
		}
		if rule.ParentRs.IsReferedFromParent == 1 {
			sql += fmt.Sprintf(" left join %s %st%d on %st%d.%s=%s.guid ", af[i].CiTypeId, prefix, i, prefix, i-1,
				af[i].ParentRs.AttrId[strings.Index(af[i].ParentRs.AttrId, "#")+1:], af[i].CiTypeId)
		} else {
			sql += fmt.Sprintf(" right join %s %st%d on %st%d.%s=%s.guid ", af[i].CiTypeId, prefix, i, prefix, i-1,
				af[i].ParentRs.AttrId[strings.Index(af[i].ParentRs.AttrId, "#")+1:], af[i].CiTypeId)
		}
	}
	sql += whereSql
	return
}

type AttrAutofillSortObj struct {
	AttrName string              `json:"attr_name"`
	Attr     *SysCiTypeAttrTable `json:"attr"`
	Dep      []string            `json:"type"`
	PValue   int                 `json:"value"`
	Link     []string            `json:"link"`
}

type AttrAutofillSortList []*AttrAutofillSortObj

func (a AttrAutofillSortList) Len() int {
	return len(a)
}

func (a AttrAutofillSortList) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}

func (a AttrAutofillSortList) Less(i, j int) bool {
	return a[i].PValue > a[j].PValue
}

type AutofillChainObj struct {
	Guid         string
	UpdateColumn []string
}

type AutofillChainCiColumn struct {
	AttrId        string
	CiTypeId      string
	CiAttrName    string
	AutofillRule  string
	UsedColumn    []string
	UpdatedSubMap map[string][]string
}

type AutoActiveHandleParam struct {
	Data      []map[string]string
	CiType    string
	Operation string
	User      string
}

type CiDataObjectErrOutput struct {
	Error   string `json:"error"`
	Content string `json:"content"`
}

type HandleCiDataParam struct {
	InputData  []CiDataMapObj
	CiTypeId   string
	Operation  string
	Operator   string
	BareAction string
	Roles      []string
	Permission bool
	FromCore   bool
	UserToken  string
}
