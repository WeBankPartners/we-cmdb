package db

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

var (
	ciAttrInsertSql    string
	ciRefAttrInsertSql string
)

func init() {
	ciAttrInsertSql = getDefaultInsertSqlByStruct(models.SysCiTypeAttrTable{}, "sys_ci_type_attr", []string{"ref_type", "ref_ci_type", "select_list"})
	ciRefAttrInsertSql = getDefaultInsertSqlByStruct(models.SysCiTypeAttrTable{}, "sys_ci_type_attr", []string{})
}

func getCiAttrById(ciAttrId string) (rowData *models.SysCiTypeAttrTable, err error) {
	var ciAttrTable []*models.SysCiTypeAttrTable
	err = x.SQL("SELECT * FROM sys_ci_type_attr WHERE id=?", ciAttrId).Find(&ciAttrTable)
	if err != nil {
		log.Logger.Error("Get ci type attribute error", log.String("ciAttrId", ciAttrId), log.Error(err))
		return
	}
	if len(ciAttrTable) == 0 {
		err = fmt.Errorf("Ci type attribute %s can not found ", ciAttrId)
		log.Logger.Warn("Get ci type attribute fail", log.Error(err))
	} else {
		rowData = ciAttrTable[0]
	}
	return
}

func GetCiAttrByCiType(ciTypeId string, isCreated bool) (rowData []*models.SysCiTypeAttrTable, err error) {
	rowData = []*models.SysCiTypeAttrTable{}
	if isCreated {
		err = x.SQL("SELECT * FROM sys_ci_type_attr WHERE ci_type=? and status='created' order by ui_form_order asc", ciTypeId).Find(&rowData)
	} else {
		err = x.SQL("SELECT * FROM sys_ci_type_attr WHERE ci_type=? order by ui_form_order asc", ciTypeId).Find(&rowData)
	}
	for _, row := range rowData {
		row.DisplayNameTmp = row.DisplayName
	}
	return
}

func CiAttrCreate(param *models.SysCiTypeAttrTable) error {
	param.Status = "notCreated"
	param.Source = "custom"
	param.Id = param.CiType + models.SysTableIdConnector + param.Name
	if strings.Contains(param.DataType, "(") {
		tmpDataType := param.DataType[:strings.Index(param.DataType, "(")]
		param.DataLength, _ = strconv.Atoi(param.DataType[strings.Index(param.DataType, "(")+1 : len(param.DataType)-1])
		param.DataType = tmpDataType
	}
	if param.UiFormOrder <= 0 {
		uiFormQuery, _ := x.QueryString("select max(ui_form_order) ui_form_order from sys_ci_type_attr where ci_type=?", param.CiType)
		if len(uiFormQuery) > 0 {
			param.UiFormOrder, _ = strconv.Atoi(uiFormQuery[0]["ui_form_order"])
		}
		param.UiFormOrder = param.UiFormOrder + 1
	}
	if param.Customizable == "" {
		param.Customizable = "yes"
	}
	if param.EditGroupControl == "" {
		param.EditGroupControl = "no"
	}
	var err error
	execSql := ciAttrInsertSql
	execParams := []interface{}{param.Id, param.CiType, param.Name, param.DisplayName, param.Description, param.Status, param.InputType, param.DataType,
		param.DataLength, param.TextValidate, param.RefName, param.RefFilter, param.RefUpdateStateValidate, param.RefConfirmStateValidate, param.UiSearchOrder,
		param.UiFormOrder, param.UniqueConstraint, param.UiNullable, param.Nullable, param.Editable, param.DisplayByDefault, param.PermissionUsage, param.ResetOnEdit,
		param.Source, param.Customizable, param.AutofillAble, param.AutofillRule, param.AutofillType, param.EditGroupControl, param.EditGroupValues}
	if param.RefType != "" && param.RefCiType != "" {
		execSql = strings.ReplaceAll(execSql, ") VALUE", ",ref_type,ref_ci_type) VALUE")
		execSql = execSql[:len(execSql)-1] + ",?,?)"
		execParams = append(execParams, param.RefType, param.RefCiType)
	}
	if param.SelectList != "" {
		execSql = strings.ReplaceAll(execSql, ") VALUE", ",select_list) VALUE")
		execSql = execSql[:len(execSql)-1] + ",?)"
		execParams = append(execParams, param.SelectList)
	}
	execParams = append([]interface{}{execSql}, execParams...)
	_, err = x.Exec(execParams...)
	if err != nil {
		log.Logger.Error("Insert ci attr data fail", log.Error(err))
	}
	return err
}

func CiAttrCreateByTemplate(ciTypeId, ciTemplateId string) error {
	var ciAttrTemplateData []*models.SysCiTemplateAttrTable
	err := x.SQL("SELECT * FROM sys_ci_template_attr WHERE ci_template=?", ciTemplateId).Find(&ciAttrTemplateData)
	if err != nil {
		log.Logger.Error("Try to create ci attr from ci template fail", log.Error(err))
		return err
	}
	if len(ciAttrTemplateData) == 0 {
		return nil
	}
	var actions []*execAction
	for _, row := range ciAttrTemplateData {
		execSql := ciAttrInsertSql
		execParams := []interface{}{ciTypeId + models.SysTableIdConnector + row.Name, ciTypeId, row.Name, row.DisplayName, row.Description, row.Status, row.InputType, row.DataType,
			row.DataLength, row.TextValidate, row.RefName, row.RefFilter, row.RefUpdateStateValidate, row.RefConfirmStateValidate, row.UiSearchOrder,
			row.UiFormOrder, row.UniqueConstraint, row.UiNullable, row.Nullable, row.Editable, row.DisplayByDefault, row.PermissionUsage, row.ResetOnEdit,
			row.Source, row.Customizable, row.AutofillAble, row.AutofillRule, row.AutofillType, row.EditGroupControl, row.EditGroupValues}
		if row.RefType != "" && row.RefCiType != "" {
			execSql = strings.ReplaceAll(execSql, ") VALUE", ",ref_type,ref_ci_type) VALUE")
			execSql = execSql[:len(execSql)-1] + ",?,?)"
			execParams = append(execParams, row.RefType, row.RefCiType)
		}
		if row.SelectList != "" {
			execSql = strings.ReplaceAll(execSql, ") VALUE", ",select_list) VALUE")
			execSql = execSql[:len(execSql)-1] + ",?)"
			execParams = append(execParams, row.SelectList)
		}
		actions = append(actions, &execAction{Sql: execSql, Param: execParams})
	}
	return transaction(actions)
}

func CiAttrUpdate(param *models.SysCiTypeAttrTable) (updateAutoFill bool, err error) {
	updateAutoFill = false
	ciAttrData, err := getCiAttrById(param.Id)
	if err != nil {
		return updateAutoFill, err
	}
	if ciAttrData.Customizable == "no" {
		return updateAutoFill, fmt.Errorf("Attribute:%s is not editable ", param.Id)
	}
	if param.EditGroupControl == "" {
		param.EditGroupControl = "no"
	}
	var actions []*execAction
	execParams := []interface{}{"", param.DisplayName, param.Description, param.UiSearchOrder, param.TextValidate, param.ResetOnEdit, param.DisplayByDefault, param.UiNullable, param.Nullable, param.Editable,
		param.UniqueConstraint, param.AutofillAble, param.AutofillRule, param.AutofillType, param.EditGroupControl, param.EditGroupValues, param.RefName, param.RefFilter, param.RefUpdateStateValidate, param.RefConfirmStateValidate, param.PermissionUsage}
	extendUpdateColumn := ""
	if ciAttrData.Status == "notCreated" || ciAttrData.Status == "dirty" {
		if strings.Contains(param.DataType, "(") {
			tmpDataType := param.DataType[:strings.Index(param.DataType, "(")]
			param.DataLength, _ = strconv.Atoi(param.DataType[strings.Index(param.DataType, "(")+1 : len(param.DataType)-1])
			param.DataType = tmpDataType
		}
		extendUpdateColumn = ",input_type=?,data_type=?,data_length=?"
		execParams = append(execParams, param.InputType, param.DataType, param.DataLength)
		if param.RefType != "" && param.RefCiType != "" {
			extendUpdateColumn += ",ref_ci_type=?,ref_type=?"
			execParams = append(execParams, param.RefCiType, param.RefType)
		}
	} else {
		if strings.Contains(param.DataType, "(") {
			param.DataLength, _ = strconv.Atoi(param.DataType[strings.Index(param.DataType, "(")+1 : len(param.DataType)-1])
		}
		if ciAttrData.DataLength != param.DataLength {
			if ciAttrData.DataType == "varchar" || ciAttrData.DataType == "int" {
				alterSql := fmt.Sprintf("alter table %s modify column %s %s(%d)", ciAttrData.CiType, ciAttrData.Name, ciAttrData.DataType, param.DataLength)
				alertHistorySql := fmt.Sprintf("alter table %s%s modify column %s %s(%d)", HistoryTablePrefix, ciAttrData.CiType, ciAttrData.Name, ciAttrData.DataType, param.DataLength)
				if param.Nullable == "no" {
					alterSql += " not null"
					alertHistorySql += " not null"
				}
				actions = append(actions, &execAction{Sql: alterSql, Param: []interface{}{}})
				actions = append(actions, &execAction{Sql: alertHistorySql, Param: []interface{}{}})
				extendUpdateColumn += ",data_length=?"
				execParams = append(execParams, param.DataLength)
			}
		}
		if param.AutofillAble == "yes" && param.AutofillType == "forced" {
			if param.AutofillRule != ciAttrData.AutofillRule {
				updateAutoFill = true
			}
		}
	}
	if param.SelectList != "" {
		extendUpdateColumn += ",select_list=?"
		execParams = append(execParams, param.SelectList)
	}
	execParams = append(execParams, param.Id)
	execParams[0] = "UPDATE sys_ci_type_attr SET display_name=?,description=?,ui_search_order=?,text_validate=?,reset_on_edit=?,display_by_default=?,ui_nullable=?,nullable=?,editable=?,unique_constraint=?,autofillable=?,autofill_rule=?,autofill_type=?,edit_group_control=?,edit_group_value=?,ref_name=?,ref_filter=?,ref_update_state_validate=?,ref_confirm_state_validate=?,permission_usage=?" + extendUpdateColumn + "  WHERE id=?"
	_, err = x.Exec(execParams...)
	if err != nil {
		log.Logger.Error("Update ci attr data fail", log.Error(err))
	} else {
		if len(actions) > 0 {
			err = transaction(actions)
		}
	}
	return updateAutoFill, err
}

func CiAttrDelete(ciAttrId string) error {
	ciAttrData, err := getCiAttrById(ciAttrId)
	if err != nil {
		return err
	}
	if ciAttrData.Status == "notCreated" {
		_, err = x.Exec("DELETE FROM sys_ci_type_attr WHERE id=?", ciAttrId)
	} else {
		_, err = x.Exec("UPDATE sys_ci_type_attr SET status='deleted' WHERE id=?", ciAttrId)
	}
	return err
}

func CiAttrRollback(ciAttrId string) error {
	ciAttrData, err := getCiAttrById(ciAttrId)
	if err != nil {
		return err
	}
	var refCiTypeTable []*models.SysCiTypeTable
	err = x.SQL("select id,status from sys_ci_type where id=?", ciAttrData.RefCiType).Find(&refCiTypeTable)
	if err != nil {
		return fmt.Errorf("Try to validate reference ciType:%s fail,%s ", ciAttrData.RefCiType, err.Error())
	}
	if len(refCiTypeTable) == 0 {
		return fmt.Errorf("can not find ref ciType:%s ", ciAttrData.RefCiType)
	}
	if refCiTypeTable[0].Status == "deleted" {
		return fmt.Errorf("target ciType:%s is deleted,please rollback it first", ciAttrData.RefCiType)
	}
	_, err = x.Exec("UPDATE sys_ci_type_attr SET status='created' where id=?", ciAttrId)
	return err
}

func CiAttrSwapPositionByUi(params []*models.CiAttrSwapPositionParam, ciTypeId string) error {
	var actions []*execAction
	for _, param := range params {
		actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type_attr SET ui_form_order=? WHERE id=?", Param: []interface{}{param.TargetIndex, param.CiAttrId}})
	}
	return transaction(actions)
}

func CiAttrSwapPosition(param *models.CiAttrSwapPositionParam, ciTypeId string) error {
	var rowData []*models.SysCiTypeAttrTable
	err := x.SQL("SELECT id,ui_form_order FROM sys_ci_type_attr WHERE ci_type=?", ciTypeId).Find(&rowData)
	if err != nil {
		return err
	}
	fetchRow := models.SysCiTypeAttrTable{}
	for _, row := range rowData {
		if row.Id == param.CiAttrId {
			fetchRow = *row
			break
		}
	}
	if fetchRow.Id == "" {
		return fmt.Errorf("Ci attr id:%s can not fetch any data ", param.CiAttrId)
	}
	if param.TargetIndex == fetchRow.UiFormOrder {
		return nil
	}
	upFlag := false
	if param.TargetIndex < fetchRow.UiFormOrder {
		upFlag = true
	}
	updateAction := []*execAction{&execAction{Sql: "UPDATE sys_ci_type_attr SET ui_form_order=? WHERE id=?", Param: []interface{}{param.TargetIndex, fetchRow.Id}}}
	for _, row := range rowData {
		if upFlag {
			if row.UiFormOrder >= param.TargetIndex && row.UiFormOrder < fetchRow.UiFormOrder {
				updateAction = append(updateAction, &execAction{Sql: "UPDATE sys_ci_type_attr SET ui_form_order=? WHERE id=?", Param: []interface{}{row.UiFormOrder + 1, row.Id}})
			}
		} else {
			if row.UiFormOrder <= param.TargetIndex && row.UiFormOrder > fetchRow.UiFormOrder {
				updateAction = append(updateAction, &execAction{Sql: "UPDATE sys_ci_type_attr SET ui_form_order=? WHERE id=?", Param: []interface{}{row.UiFormOrder - 1, row.Id}})
			}
		}
	}
	return transaction(updateAction)
}

func CiAttrApply(ciTypeId, ciAttrId string, updateAutofill bool) error {
	ciTypeData, err := GetCiTypeById(ciTypeId)
	if err != nil {
		return err
	}
	if ciTypeData.Status != "created" {
		return fmt.Errorf("Ci type %s is not created ", ciTypeId)
	}
	ciAttrData, err := getCiAttrById(ciAttrId)
	if err != nil {
		return err
	}
	if ciAttrData.Status == "created" {
		if updateAutofill {
			affectCiTypeChan <- ciTypeId
		}
		return nil
	}
	if ciAttrData.RefCiType != "" {
		refCiType, err := GetCiTypeById(ciAttrData.RefCiType)
		if err != nil {
			return err
		}
		if refCiType.Status != "created" {
			return fmt.Errorf("Attr ref ciType:%s is not created ", ciAttrData.RefCiType)
		}
	}
	ciAttrStatus := "created"
	if ciAttrData.InputType == models.MultiRefType {
		err = buildMultiRefTable(ciAttrData)
		if err != nil {
			err = fmt.Errorf("Try to create multi ref table:%s$%s fail,%s ", ciAttrData.CiType, ciAttrData.Name, err.Error())
			return err
		}
	} else {
		attrSql, historyAttrSql := buildColumnSqlFromCiAttr(ciAttrData)
		var actions []*execAction
		actions = append(actions, &execAction{Sql: fmt.Sprintf("ALTER TABLE %s ADD COLUMN %s", ciTypeId, attrSql)})
		actions = append(actions, &execAction{Sql: fmt.Sprintf("ALTER TABLE %s%s ADD COLUMN %s", HistoryTablePrefix, ciTypeId, historyAttrSql)})
		err = transaction(actions)
		if err != nil {
			err = fmt.Errorf("Try to alter table %s add column %s fail,%s ", ciTypeId, ciAttrData.Name, err.Error())
			return err
		}
	}
	_, updateStatusErr := x.Exec("UPDATE sys_ci_type_attr SET status=? WHERE id=?", ciAttrStatus, ciAttrId)
	if updateStatusErr != nil {
		log.Logger.Error("Update ci attr status error", log.String("ciAttrId", ciAttrId), log.Error(err))
		err = fmt.Errorf("Update ci attr database fail,%s ", updateStatusErr.Error())
	}
	return err
}

func CheckCiAttrIsPassword(ciType, attr string) (isPwd bool, err error) {
	queryList, queryErr := x.QueryString("select input_type from sys_ci_type_attr where ci_type=? and name=?", ciType, attr)
	if queryErr != nil {
		err = fmt.Errorf("Try to check if ci attr password fail,%s ", queryErr.Error())
		return
	}
	if len(queryList) == 0 {
		err = fmt.Errorf("Can not find attr:%s from ci:%s ", attr, ciType)
		return
	}
	if queryList[0]["input_type"] == "password" {
		isPwd = true
	}
	return
}
