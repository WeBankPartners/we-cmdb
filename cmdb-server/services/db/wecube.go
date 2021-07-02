package db

import "github.com/WeBankPartners/we-cmdb/cmdb-server/models"

func GetAllDataModel() (result models.SyncDataModelResponse, err error) {
	result = models.SyncDataModelResponse{Status: "OK", Message: "success"}
	var attrTable []*models.SyncDataModelCiAttr
	err = x.SQL("select id,ci_type,name,display_name,description,input_type,ref_ci_type from sys_ci_type_attr where status='created' order by ci_type,ui_form_order").Find(&attrTable)
	if err != nil {
		return
	}
	var ciTable []*models.SyncDataModelCiType
	err = x.SQL("select id,display_name,description from sys_ci_type where status='created'").Find(&ciTable)
	if err != nil {
		return
	}
	attrMap := make(map[string][]*models.SyncDataModelCiAttr)
	for _, attr := range attrTable {
		if attr.DataType == "ref" || attr.DataType == "multiRef" {
			attr.DataType = "ref"
		} else if attr.DataType == "int" {
			attr.DataType = "int"
		} else {
			attr.DataType = "str"
		}
		if attr.RefEntityName != "" {
			attr.RefAttributeName = "id"
			attr.RefPackageName = "wecmdb"
		}
		if attr.Name == "guid" {
			tmpAttr := &models.SyncDataModelCiAttr{Name: "id", EntityName: attr.EntityName, Description: attr.Description, DataType: attr.DataType, RefPackageName: attr.RefPackageName, RefAttributeName: attr.RefAttributeName, RefEntityName: attr.RefEntityName}
			if _, b := attrMap[attr.EntityName]; b {
				attrMap[attr.EntityName] = append(attrMap[attr.EntityName], attr, tmpAttr)
			} else {
				attrMap[attr.EntityName] = []*models.SyncDataModelCiAttr{attr, tmpAttr}
			}
		} else if attr.Name == "key_name" {
			tmpAttr := &models.SyncDataModelCiAttr{Name: "displayName", EntityName: attr.EntityName, Description: attr.Description, DataType: attr.DataType, RefPackageName: attr.RefPackageName, RefAttributeName: attr.RefAttributeName, RefEntityName: attr.RefEntityName}
			if _, b := attrMap[attr.EntityName]; b {
				attrMap[attr.EntityName] = append(attrMap[attr.EntityName], attr, tmpAttr)
			} else {
				attrMap[attr.EntityName] = []*models.SyncDataModelCiAttr{attr, tmpAttr}
			}
		} else {
			if _, b := attrMap[attr.EntityName]; b {
				attrMap[attr.EntityName] = append(attrMap[attr.EntityName], attr)
			} else {
				attrMap[attr.EntityName] = []*models.SyncDataModelCiAttr{attr}
			}
		}
	}

	for _, ci := range ciTable {
		if _, b := attrMap[ci.Name]; b {
			ci.Attributes = attrMap[ci.Name]
		} else {
			ci.Attributes = []*models.SyncDataModelCiAttr{}
		}
		result.Data = append(result.Data, ci)
	}
	return
}
