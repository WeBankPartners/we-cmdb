package db

import (
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"io/ioutil"
	"os"
	"strings"
	"time"
)

var (
	staticImageListChan = make(chan []string, 100)
)

func CiTypesQuery(query *models.CiTypeQuery) error {
	var ciTypeQueryFilterSql, specSql string
	var ciTypeQueryParams, ciTypeSubParams []interface{}
	ciTypesTable := []*models.CiTypeQueryCiObj{}
	ciTypeQuerySql := `SELECT t1.id,t1.display_name,t1.description,t1.status,t1.ci_group,t1.ci_layer,t1.ci_template,t1.state_machine,CONCAT(t2.guid,'.',t2.type) as 'image_file' 
		FROM sys_ci_type t1 
		left join sys_files t2 on t1.image_file=t2.guid WHERE 1=1`
	if query.CiTypeId != "" {
		ciTypeQueryFilterSql += " AND t1.id=? "
		ciTypeQueryParams = append(ciTypeQueryParams, query.CiTypeId)
	}
	if len(query.Status) > 0 {
		specSql, ciTypeSubParams = createListParams(query.Status, "")
		ciTypeQueryFilterSql += " AND t1.status in (" + specSql + ") "
		ciTypeQueryParams = append(ciTypeQueryParams, ciTypeSubParams...)
	}
	if len(query.Group) > 0 {
		specSql, ciTypeSubParams = createListParams(query.Group, "")
		ciTypeQueryFilterSql += " AND t1.ci_group in (" + specSql + ") "
		ciTypeQueryParams = append(ciTypeQueryParams, ciTypeSubParams...)
	}
	if len(query.Layer) > 0 {
		specSql, ciTypeSubParams = createListParams(query.Layer, "")
		ciTypeQueryFilterSql += " AND t1.ci_layer in (" + specSql + ") "
		ciTypeQueryParams = append(ciTypeQueryParams, ciTypeSubParams...)
	}
	err := x.SQL(ciTypeQuerySql+ciTypeQueryFilterSql, ciTypeQueryParams...).Find(&ciTypesTable)
	if err != nil {
		return fmt.Errorf("Query ci type data from database fail,%s ", err.Error())
	}
	var imageList []string
	if query.WithAttributes == "yes" {
		var ciAttrTable []*models.SysCiTypeAttrTable
		if len(query.AttrInputType) > 0 {
			specSql, ciTypeSubParams = createListParams(query.AttrInputType, "")
			ciTypeQueryFilterSql += " AND t2.input_type in (" + specSql + ") "
			ciTypeQueryParams = append(ciTypeQueryParams, ciTypeSubParams...)
		}
		if len(query.AttrTypeStatus) > 0 {
			specSql, ciTypeSubParams = createListParams(query.AttrTypeStatus, "")
			ciTypeQueryFilterSql += " AND t2.status in (" + specSql + ") "
			ciTypeQueryParams = append(ciTypeQueryParams, ciTypeSubParams...)
		}
		err = x.SQL("SELECT t2.* FROM sys_ci_type t1 LEFT JOIN sys_ci_type_attr t2 ON t1.id = t2.ci_type WHERE 1=1 "+ciTypeQueryFilterSql+" ORDER BY t2.ui_form_order", ciTypeQueryParams...).Find(&ciAttrTable)
		if err != nil {
			return fmt.Errorf("Query ci attr from database fail,%s ", err.Error())
		} else {
			ciAttrMap := make(map[string][]*models.SysCiTypeAttrTable)
			for _, ciAttr := range ciAttrTable {
				if ciAttr.AutofillType == "" {
					ciAttr.AutofillType = "suggest"
				}
				// add attribute
				if _, b := ciAttrMap[ciAttr.CiType]; !b {
					ciAttrMap[ciAttr.CiType] = []*models.SysCiTypeAttrTable{ciAttr}
				} else {
					ciAttrMap[ciAttr.CiType] = append(ciAttrMap[ciAttr.CiType], ciAttr)
				}
			}
			for _, ciType := range ciTypesTable {
				if _, b := ciAttrMap[ciType.Id]; !b {
					ciType.Attributes = []*models.SysCiTypeAttrTable{}
				} else {
					ciType.Attributes = ciAttrMap[ciType.Id]
				}
				if strings.Contains(ciType.ImageFile, ".") {
					imageList = append(imageList, ciType.ImageFile[:strings.LastIndex(ciType.ImageFile, ".")])
				}
			}
		}
	} else {
		for _, ciType := range ciTypesTable {
			ciType.Attributes = []*models.SysCiTypeAttrTable{}
			if strings.Contains(ciType.ImageFile, ".") {
				imageList = append(imageList, ciType.ImageFile[:strings.LastIndex(ciType.ImageFile, ".")])
			}
		}
	}
	staticImageListChan <- imageList
	query.CiTypeListData = ciTypesTable
	if query.GroupBy == "group" {
		groupTable := []*models.CiTypeQueryGroupObj{}
		ciTypeQueryFilterSql = ""
		ciTypeQueryParams = []interface{}{}
		if len(query.Group) > 0 {
			specSql, ciTypeSubParams = createListParams(query.Group, "")
			ciTypeQueryFilterSql = " AND id in (" + specSql + ") "
			ciTypeQueryParams = ciTypeSubParams
		}
		err = x.SQL("SELECT * FROM sys_basekey_code WHERE cat_id='ci_group' "+ciTypeQueryFilterSql+" order by seq_no", ciTypeQueryParams...).Find(&groupTable)
		if err != nil {
			return fmt.Errorf("Query basekey code with ci_group cat from database fail,%s ", err.Error())
		} else {
			groupMap := make(map[string][]*models.CiTypeQueryCiObj)
			for _, ciType := range ciTypesTable {
				if _, b := groupMap[ciType.CiGroup]; !b {
					groupMap[ciType.CiGroup] = []*models.CiTypeQueryCiObj{ciType}
				} else {
					groupMap[ciType.CiGroup] = append(groupMap[ciType.CiGroup], ciType)
				}
			}
			for _, group := range groupTable {
				if _, b := groupMap[group.Id]; b {
					group.CiTypes = groupMap[group.Id]
				} else {
					group.CiTypes = []*models.CiTypeQueryCiObj{}
				}
			}
		}
		query.GroupData = groupTable
	}
	return nil
}

func GetCiTypeById(ciTypeId string) (rowData *models.SysCiTypeTable, err error) {
	var ciTypeTable []*models.SysCiTypeTable
	err = x.SQL("SELECT * FROM sys_ci_type WHERE id=?", ciTypeId).Find(&ciTypeTable)
	if err != nil {
		log.Logger.Error("Get ci type error", log.String("ciTypeId", ciTypeId), log.Error(err))
		return
	}
	if len(ciTypeTable) == 0 {
		err = fmt.Errorf("Ci type %s can not found ", ciTypeId)
		log.Logger.Warn("Get ci type fail", log.Error(err))
	} else {
		rowData = ciTypeTable[0]
	}
	return
}

func getImageFileName(imageGuid string) (fileName string, err error) {
	var imageTable []*models.SysFilesTable
	err = x.SQL("select guid,type from sys_files where guid=?", imageGuid).Find(&imageTable)
	if err != nil {
		err = fmt.Errorf("Try to get image file table fail,%s ", err.Error())
	}
	if len(imageTable) > 0 {
		fileName = fmt.Sprintf("%s.%s", imageTable[0].Guid, imageTable[0].Type)
	} else {
		err = fmt.Errorf("Can not find image file data with guid:%s ", imageGuid)
	}
	return
}

func CiTypesImageSave(imageBytes []byte, imageType string) (imageGuid string, err error) {
	imageGuid = guid.CreateGuid()
	_, err = x.Exec("INSERT INTO sys_files(guid,type,content,update_time) VALUE (?,?,?,?)", imageGuid, imageType, imageBytes, time.Now().Format(models.DateTimeFormat))
	return
}

func CiTypesImageDelete(imageGuid, imageFileName string) {
	_, err := x.Exec("DELETE FROM sys_files WHERE guid=?", imageGuid)
	if err != nil {
		log.Logger.Error("Delete ci type image file data fail", log.Error(err))
	}
	err = os.Remove(fmt.Sprintf("public%s/fonts/%s", models.UrlPrefix, imageFileName))
	if err != nil {
		log.Logger.Error("Delete image file fail", log.String("path", fmt.Sprintf("public%s/fonts/%s", models.UrlPrefix, imageFileName)), log.Error(err))
	}
}

func CheckIfCiTypesNameExists(name string) bool {
	var ciTypes []*models.SysCiTypeTable
	x.SQL("SELECT guid FROM sys_ci_type WHERE id=?", name).Find(&ciTypes)
	if len(ciTypes) > 0 {
		return true
	}
	return false
}

func CiTypesCreate(param *models.SysCiTypeTable) error {
	var ciTemplateTable []*models.SysCiTemplateTable
	err := x.SQL("select * from sys_ci_template where id=?", param.CiTemplate).Find(&ciTemplateTable)
	if err != nil {
		return fmt.Errorf("Try to get ci template:%s fail,%s ", param.CiTemplate, err.Error())
	}
	if len(ciTemplateTable) == 0 {
		return fmt.Errorf("Can not find ci template with id:%s ", param.CiTemplate)
	}
	param.StateMachine = ciTemplateTable[0].StateMachine
	if param.ImageFile == "" {
		param.ImageFile = ciTemplateTable[0].ImageFile
	}
	_, err = x.Exec("INSERT INTO sys_ci_type(id,display_name,description,image_file,ci_group,ci_layer,ci_template,state_machine) VALUE (?,?,?,?,?,?,?,?)",
		param.Id, param.DisplayName, param.Description, param.ImageFile, param.CiGroup, param.CiLayer, param.CiTemplate, param.StateMachine)
	if err != nil {
		return fmt.Errorf("Try to insert ci type record to database fail,%s ", err.Error())
	}
	err = CiAttrCreateByTemplate(param.Id, param.CiTemplate)
	if err != nil {
		err = fmt.Errorf("Try to create attributes by template fail,%s ", err.Error())
	} else {
		log.Logger.Info("Create ci types success", log.String("id", param.Id))
	}
	return err
}

func CiTypesUpdate(param *models.SysCiTypeTable, newImageGuid string) (imageFileName string, err error) {
	var actions []*execAction
	oldCiData, err := GetCiTypeById(param.Id)
	if err != nil {
		return
	}
	imageGuid := newImageGuid
	imageFileName, err = getImageFileName(oldCiData.ImageFile)
	if imageGuid == "" {
		imageGuid = oldCiData.ImageFile
	}
	if err != nil {
		return
	}
	if param.CiLayer != "" && param.CiGroup != "" {
		actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type SET display_name=?,description=?,ci_group=?,ci_layer=?,image_file=? where id=?",
			Param: []interface{}{param.DisplayName, param.Description, param.CiGroup, param.CiLayer, imageGuid, param.Id}})
	} else {
		actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type SET display_name=? where id=?", Param: []interface{}{param.DisplayName, param.Id}})
	}
	err = transaction(actions)
	if err != nil {
		err = fmt.Errorf("Update ci type exec sql error,%s ", err.Error())
		return
	}
	if newImageGuid != "" {
		CiTypesImageDelete(oldCiData.ImageFile, imageFileName)
	}
	return
}

func CiTypesDelete(ciTypeId string) error {
	ciTypeData, err := GetCiTypeById(ciTypeId)
	if err != nil {
		return err
	}
	refAttrs, err := GetCiTypesReference(ciTypeId)
	if err != nil {
		return fmt.Errorf("Try to get ci reference fail,%s ", err.Error())
	}
	if len(refAttrs) > 0 {
		refCiTypeList := []string{}
		for _, attr := range refAttrs {
			if attr.Status == "deleted" {
				continue
			}
			refCiTypeList = append(refCiTypeList, attr.CiType)
		}
		var refCiTypeTable []*models.SysCiTypeTable
		err = x.SQL("select id,status from sys_ci_type where id in ('" + strings.Join(refCiTypeList, "','") + "')").Find(&refCiTypeTable)
		if err != nil {
			return fmt.Errorf("Try to validate reference ciType:%s fail,%s ", refCiTypeList, err.Error())
		}
		for _, refCiType := range refCiTypeTable {
			if refCiType.Status == "created" {
				err = fmt.Errorf("CiType:%s is still created ", refCiType.Id)
				break
			}
		}
		if err != nil {
			return err
		}
	}
	if ciTypeData.Status == "notCreated" {
		var actions []*execAction
		actions = append(actions, &execAction{Sql: "delete from sys_ci_type_attr where ci_type=?", Param: []interface{}{ciTypeId}})
		actions = append(actions, &execAction{Sql: "delete from sys_ci_type where id=?", Param: []interface{}{ciTypeId}})
		err = transaction(actions)
	} else {
		var actions []*execAction
		actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type_attr SET status='deleted' WHERE ci_type=?", Param: []interface{}{ciTypeId}})
		actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type SET status='deleted' WHERE id=?", Param: []interface{}{ciTypeId}})
		err = transaction(actions)
	}
	return err
}

func CreateCiTable(ciTypeId string) error {
	ciAttrRows, err := GetCiAttrByCiType(ciTypeId, false)
	if err != nil {
		return fmt.Errorf("Get ci attrbutes error,%s ", err.Error())
	}
	if len(ciAttrRows) == 0 {
		return fmt.Errorf("Ci type %s have no attrbutes,please check ", ciTypeId)
	}
	// build attribute column
	var multiRefAttr []*models.SysCiTypeAttrTable
	var columnList, historyColumnList, attrRefCiTypeList []string
	historyColumnList = append(historyColumnList, "`id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY")
	for _, ciAttr := range ciAttrRows {
		if ciAttr.InputType == models.MultiRefType {
			attrRefCiTypeList = append(attrRefCiTypeList, ciAttr.RefCiType)
			multiRefAttr = append(multiRefAttr, ciAttr)
			continue
		}
		if ciAttr.RefCiType != "" {
			attrRefCiTypeList = append(attrRefCiTypeList, ciAttr.RefCiType)
		}
		tmpAttrSql, tmpHistoryAttrSql := buildColumnSqlFromCiAttr(ciAttr)
		columnList = append(columnList, tmpAttrSql)
		historyColumnList = append(historyColumnList, tmpHistoryAttrSql)
	}
	// check ciType reference ci is confirmed
	if len(attrRefCiTypeList) > 0 {
		var refCiTypeTable []*models.SysCiTypeTable
		err = x.SQL("select id,status from sys_ci_type where id in ('" + strings.Join(attrRefCiTypeList, "','") + "')").Find(&refCiTypeTable)
		if err != nil {
			return fmt.Errorf("Try to check ref ciTypes is confirmed fail,%s ", err.Error())
		}
		for _, refCiType := range refCiTypeTable {
			if refCiType.Id == ciTypeId {
				continue
			}
			if refCiType.Status != "created" {
				err = fmt.Errorf("Ref ciType:%s is not confirmed ", refCiType.Id)
				break
			}
		}
		if err != nil {
			return err
		}
	}
	// check table if exists
	err = checkTableIfExists(ciTypeId)
	if err != nil {
		return fmt.Errorf("Check table exists error,%s ", err.Error())
	}
	// create ci table & ci history table
	_, err = x.Exec(fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%s` (%s) ENGINE=InnoDB DEFAULT CHARSET=utf8", ciTypeId, strings.Join(columnList, ",")))
	if err != nil {
		return fmt.Errorf("Try to create table %s fail,%s ", ciTypeId, err.Error())
	}
	historyColumnList = append(historyColumnList, "`history_action` VARCHAR(16) NOT NULL")
	historyColumnList = append(historyColumnList, "`history_state_confirmed` TINYINT DEFAULT 0")
	historyColumnList = append(historyColumnList, "`history_time` DATETIME NOT NULL")
	historyColumnList = append(historyColumnList, fmt.Sprintf("INDEX `index_%s%s_guid` (`guid`)", HistoryTablePrefix, ciTypeId))
	_, err = x.Exec(fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%s` (%s) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8", HistoryTablePrefix+ciTypeId, strings.Join(historyColumnList, ",")))
	if err != nil {
		return fmt.Errorf("Try to create history table %s fail,%s ", HistoryTablePrefix+ciTypeId, err.Error())
	}
	if len(multiRefAttr) > 0 {
		for _, attr := range multiRefAttr {
			tmpErr := buildMultiRefTable(attr)
			if tmpErr != nil {
				err = fmt.Errorf("Try to create multi ref table:%s$%s fail,%s ", attr.CiType, attr.Name, tmpErr.Error())
				break
			}
		}
		if err != nil {
			return err
		}
	}
	return nil
}

func buildMultiRefTable(attr *models.SysCiTypeAttrTable) error {
	tableName := fmt.Sprintf("%s$%s", attr.CiType, attr.Name)
	historyTableName := HistoryTablePrefix + tableName
	columnList := []string{
		"`id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY key",
		"`from_guid` VARCHAR(64) NOT null",
		"`to_guid` VARCHAR(64) NOT null",
		"`seq_no` INT",
		"`note` VARCHAR(32)",
	}
	historyColumnList := columnList
	columnList = append(columnList,
		"index `"+fmt.Sprintf("%s_%s_from", attr.CiType, attr.Name)+"` (`from_guid`)")
	historyColumnList = append(historyColumnList,
		"`history_to_id` INT",
		"`history_time` DATETIME NOT NULL",
		"index `"+fmt.Sprintf("h_%s_%s_from", attr.CiType, attr.Name)+"` (`from_guid`)")
	actions := []*execAction{{Sql: fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%s` (%s) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8", tableName, strings.Join(columnList, ","))},
		{Sql: fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%s` (%s) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8", historyTableName, strings.Join(historyColumnList, ","))}}
	return transaction(actions)
}

func UpdateCiTypesStatus(ciTypeId, status string) {
	var actions []*execAction
	actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type SET status=? WHERE id=?", Param: []interface{}{status, ciTypeId}})
	actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type_attr SET status=? WHERE ci_type=?", Param: []interface{}{status, ciTypeId}})
	if err := transaction(actions); err != nil {
		log.Logger.Error("Try to update ci type status fail", log.Error(err))
	}
}

func CiTypesRollback(ciTypeId string) error {
	var actions []*execAction
	actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type_attr SET status='created' WHERE ci_type=?", Param: []interface{}{ciTypeId}})
	actions = append(actions, &execAction{Sql: "UPDATE sys_ci_type SET status='created' where id=?", Param: []interface{}{ciTypeId}})
	return transaction(actions)
}

func checkTableIfExists(tableName string) error {
	var existTableList []*models.DatabaseTableList
	err := x.SQL("SELECT `TABLE_NAME` FROM information_schema.`TABLES` WHERE TABLE_SCHEMA=? ", models.Config.Database.DataBase).Find(&existTableList)
	if err != nil {
		return fmt.Errorf("Try to get database table list fail,%s ", err.Error())
	}
	historyTableName := HistoryTablePrefix + tableName
	for _, existTable := range existTableList {
		if existTable.TableName == tableName {
			err = fmt.Errorf("table:%s already exist ", tableName)
			break
		}
		if existTable.TableName == historyTableName {
			err = fmt.Errorf("history table:%s already exist ", historyTableName)
			break
		}
	}
	return err
}

func buildColumnSqlFromCiAttr(ciAttr *models.SysCiTypeAttrTable) (nowTable, historyTable string) {
	nowTable = fmt.Sprintf("`%s` %s", ciAttr.Name, ciAttr.DataType)
	if ciAttr.DataType != "datetime" {
		nowTable += fmt.Sprintf("(%d)", ciAttr.DataLength)
	}
	if ciAttr.Nullable == "no" {
		nowTable += " NOT NULL"
	}
	historyTable = nowTable
	if ciAttr.Name == "guid" {
		nowTable += " PRIMARY KEY"
	}
	//if ciAttr.UniqueConstraint == "yes" {
	//	nowTable += " UNIQUE KEY"
	//}
	return
}

func GetCiTypesReference(ciTypeId string) (result []*models.CiTypeReferenceObj, err error) {
	result = []*models.CiTypeReferenceObj{}
	err = x.SQL("SELECT t1.id,t1.ci_type,t1.name,t1.display_name,t1.description,t1.status,t1.input_type,t1.ref_ci_type,t1.ref_name,t1.ref_type,t2.display_name as ci_type_name FROM sys_ci_type_attr t1 left join sys_ci_type t2 on t1.ci_type=t2.id WHERE t1.ref_ci_type=?", ciTypeId).Find(&result)
	for _, row := range result {
		row.DisplayNameTmp = row.DisplayName
	}
	return
}

func GetCiTemplate() (rowData []*models.SysCiTemplateTable, err error) {
	rowData = []*models.SysCiTemplateTable{}
	err = x.SQL("select t1.id,t1.description ,t1.state_machine,concat(t2.guid,'.',t2.`type`) as image_file from sys_ci_template t1 left join sys_files t2 on t1.image_file=t2.guid").Find(&rowData)
	return
}

func GetStateMachineStateList(machineList []string) (rowData []*models.GetStateMachineList, err error) {
	var machineTable []*models.SysStateMachineTable
	specSql, params := createListParams(machineList, "")
	if specSql == "" {
		specSql = "''"
	}
	err = x.SQL("select * from sys_state_machine where id in ("+specSql+")", params...).Find(&machineTable)
	if err != nil {
		err = fmt.Errorf("Try to get sys_state_machine table data fail,%s ", err.Error())
		return
	}
	var stateTable []*models.SysStateTable
	err = x.SQL("select * from sys_state where state_machine in ("+specSql+")", params...).Find(&stateTable)
	if err != nil {
		err = fmt.Errorf("Try to get sys_state table data fail,%s ", err.Error())
		return
	}
	stateListMap := make(map[string][]*models.SysStateTable)
	for _, state := range stateTable {
		if _, b := stateListMap[state.StateMachine]; !b {
			stateListMap[state.StateMachine] = []*models.SysStateTable{state}
		} else {
			stateListMap[state.StateMachine] = append(stateListMap[state.StateMachine], state)
		}
	}
	for _, machine := range machineTable {
		machineObj := models.GetStateMachineList{Id: machine.Id, Description: machine.Description, StartState: machine.StartState, FinalState: machine.FinalState}
		if _, b := stateListMap[machineObj.Id]; b {
			machineObj.States = stateListMap[machineObj.Id]
		} else {
			machineObj.States = []*models.SysStateTable{}
		}
		rowData = append(rowData, &machineObj)
	}
	return
}

func GetStateTransitionByCiType(ciTypeId string, onlyOperation bool) (rowData []*models.SysStateTransitionTable, err error) {
	rowData = []*models.SysStateTransitionTable{}
	if onlyOperation {
		err = x.SQL("select distinct operation,operation_en,operation_form_type,operation_multiple from sys_state_transition where state_machine in (select state_machine from sys_ci_type where id=?)", ciTypeId).Find(&rowData)
	} else {
		err = x.SQL("select * from sys_state_transition where state_machine in (select state_machine from sys_ci_type where id=?)", ciTypeId).Find(&rowData)
	}
	if err != nil {
		err = fmt.Errorf("Try to get ciType:%s state machine transition fail,%s ", ciTypeId, err.Error())
	}
	if len(rowData) == 0 {
		err = fmt.Errorf("CiType:%s state machine transtion is empty ", ciTypeId)
	}
	return
}

func StartSyncImageFile() {
	log.Logger.Info("start sync image file job")
	for {
		imageList := <-staticImageListChan
		go syncImageFile(imageList)
	}
}

func getStaticImageMap() (staticImageMap map[string]string, err error) {
	staticImageMap = make(map[string]string)
	files, readErr := ioutil.ReadDir(fmt.Sprintf("public%s/fonts/", models.UrlPrefix))
	if readErr != nil {
		log.Logger.Error("start sync image file job fail", log.Error(readErr))
		err = readErr
		return
	} else {
		for _, f := range files {
			fName := f.Name()
			fName = fName[:strings.LastIndex(fName, ".")]
			staticImageMap[fName] = f.Name()
		}
	}
	return
}

func syncImageFile(configList []string) {
	staticImageMap, err := getStaticImageMap()
	if err != nil {
		log.Logger.Error("Try to sync image file fail", log.Error(err))
		return
	}
	addMap := make(map[string]int)
	for _, v := range configList {
		if _, b := staticImageMap[v]; !b {
			addMap[v] = 1
		}
	}
	if len(addMap) == 0 {
		return
	}
	var addList []string
	for k, _ := range addMap {
		addList = append(addList, k)
	}
	log.Logger.Info("Start to sync image file", log.StringList("imageId", addList))
	var imageTable []*models.SysFilesTable
	err = x.SQL("select * from sys_files where guid in ('" + strings.Join(addList, "','") + "')").Find(&imageTable)
	if err != nil {
		log.Logger.Error("Try to sync image file fail", log.Error(err))
		return
	}
	var imageFilePath string
	for _, imageObj := range imageTable {
		if imageObj.Type == "" {
			imageObj.Type = "png"
		}
		imageFilePath = fmt.Sprintf("public%s/fonts/%s.%s", models.UrlPrefix, imageObj.Guid, imageObj.Type)
		err = ioutil.WriteFile(imageFilePath, imageObj.Content, 0666)
		if err != nil {
			log.Logger.Error("Save static image file fail", log.String("path", imageFilePath), log.Error(err))
		} else {
			staticImageMap[imageObj.Guid] = fmt.Sprintf("%s.%s", imageObj.Guid, imageObj.Type)
		}
	}
}

func createListParams(inputList []string, prefix string) (specSql string, paramList []interface{}) {
	if len(inputList) > 0 {
		var specList []string
		for _, v := range inputList {
			specList = append(specList, "?")
			paramList = append(paramList, prefix+v)
		}
		specSql = strings.Join(specList, ",")
	}
	return
}
