package models

type SysCiTypeAttrTable struct {
	Id                      string `json:"ciTypeAttrId" xorm:"id"`
	CiType                  string `json:"ciTypeId" xorm:"ci_type"`
	Name                    string `json:"propertyName" xorm:"name"`
	DisplayNameTmp          string `json:"displayName" xorm:"-"`
	DisplayName             string `json:"name" xorm:"display_name"`
	Description             string `json:"description" xorm:"description"`
	Status                  string `json:"status" xorm:"status"`
	InputType               string `json:"inputType" xorm:"input_type"`
	DataType                string `json:"propertyType" xorm:"data_type"`
	DataLength              int    `json:"length" xorm:"data_length"`
	TextValidate            string `json:"regularExpressionRule" xorm:"text_validate"`
	RefCiType               string `json:"referenceId" xorm:"ref_ci_type"`
	RefName                 string `json:"referenceName" xorm:"ref_name"`
	RefType                 string `json:"referenceType" xorm:"ref_type"`
	RefFilter               string `json:"referenceFilter" xorm:"ref_filter"`
	RefUpdateStateValidate  string `json:"refUpdateStateValidate" xorm:"ref_update_state_validate"`
	RefConfirmStateValidate string `json:"refConfirmStateValidate" xorm:"ref_confirm_state_validate"`
	SelectList              string `json:"selectList" xorm:"select_list"`
	UiSearchOrder           int    `json:"uiSearchOrder" xorm:"ui_search_order"`
	UiFormOrder             int    `json:"uiFormOrder" xorm:"ui_form_order"`
	UniqueConstraint        string `json:"uniqueConstraint" xorm:"unique_constraint"`
	UiNullable              string `json:"uiNullable" xorm:"ui_nullable"`
	Nullable                string `json:"nullable" xorm:"nullable"`
	Editable                string `json:"editable" xorm:"editable"`
	DisplayByDefault        string `json:"displayByDefault" xorm:"display_by_default"`
	PermissionUsage         string `json:"permissionUsage" xorm:"permission_usage"`
	ResetOnEdit             string `json:"resetOnEdit" xorm:"reset_on_edit"`
	Source                  string `json:"source" xorm:"source"`
	Customizable            string `json:"customizable" xorm:"customizable"`
	AutofillAble            string `json:"autofillable" xorm:"autofillable"`
	AutofillRule            string `json:"autoFillRule" xorm:"autofill_rule"`
	AutofillType            string `json:"autoFillType" xorm:"autofill_type"`
	EditGroupControl        string `json:"editGroupControl" xorm:"edit_group_control"`
	EditGroupValues         string `json:"editGroupValues" xorm:"edit_group_value"`
}

type CiAttrSwapPositionParam struct {
	CiAttrId    string `json:"ciTypeAttrId" binding:"required"`
	TargetIndex int    `json:"targetIndex"`
}

type SysCiTemplateAttrTable struct {
	Id                      string `json:"id" xorm:"id"`
	CiTemplate              string `json:"ciTemplate" xorm:"ci_template"`
	Name                    string `json:"name" xorm:"name"`
	DisplayName             string `json:"displayName" xorm:"display_name"`
	Description             string `json:"description" xorm:"description"`
	Status                  string `json:"status" xorm:"status"`
	InputType               string `json:"inputType" xorm:"input_type"`
	DataType                string `json:"dataType" xorm:"data_type"`
	DataLength              int    `json:"dataLength" xorm:"data_length"`
	TextValidate            string `json:"textValidate" xorm:"text_validate"`
	RefCiType               string `json:"-" xorm:"ref_ci_type"`
	RefName                 string `json:"-" xorm:"ref_name"`
	RefType                 string `json:"-" xorm:"ref_type"`
	RefFilter               string `json:"-" xorm:"ref_filter"`
	RefUpdateStateValidate  string `json:"-" xorm:"ref_update_state_validate"`
	RefConfirmStateValidate string `json:"-" xorm:"ref_confirm_state_validate"`
	SelectList              string `json:"-" xorm:"select_list"`
	UiSearchOrder           int    `json:"uiSearchOrder" xorm:"ui_search_order"`
	UiFormOrder             int    `json:"uiFormOrder" xorm:"ui_form_order"`
	UniqueConstraint        string `json:"uniqueConstraint" xorm:"unique_constraint"`
	UiNullable              string `json:"uiNullable" xorm:"ui_nullable"`
	Nullable                string `json:"nullable" xorm:"nullable"`
	Editable                string `json:"editable" xorm:"editable"`
	DisplayByDefault        string `json:"displayByDefault" xorm:"display_by_default"`
	PermissionUsage         string `json:"permissionUsage" xorm:"permission_usage"`
	ResetOnEdit             string `json:"resetOnEdit" xorm:"reset_on_edit"`
	Source                  string `json:"source" xorm:"source"`
	Customizable            string `json:"customizable" xorm:"customizable"`
	AutofillAble            string `json:"-" xorm:"autofillable"`
	AutofillRule            string `json:"-" xorm:"autofill_rule"`
	AutofillType            string `json:"-" xorm:"autofill_type"`
	EditGroupControl        string `json:"-" xorm:"edit_group_control"`
	EditGroupValues         string `json:"-" xorm:"edit_group_value"`
}

type CiTypeReferenceObj struct {
	Id             string `json:"ciTypeAttrId" xorm:"id"`
	CiType         string `json:"ciTypeId" xorm:"ci_type"`
	CiTypeName     string `json:"ciTypeName" xorm:"ci_type_name"`
	Name           string `json:"propertyName" xorm:"name" binding:"required"`
	DisplayNameTmp string `json:"displayName" xorm:"-"`
	DisplayName    string `json:"name" xorm:"display_name" binding:"required"`
	Description    string `json:"description" xorm:"description"`
	Status         string `json:"status" xorm:"status"`
	InputType      string `json:"inputType" xorm:"input_type"`
	RefCiType      string `json:"referenceId" xorm:"ref_ci_type"`
	RefName        string `json:"referenceName" xorm:"ref_name"`
	RefType        string `json:"referenceType" xorm:"ref_type"`
}
