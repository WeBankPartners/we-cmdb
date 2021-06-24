package db

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

func BaseKeyCatQuery(page, pageSize int) (pageInfo models.PageInfo, rowData []*models.SysBaseKeyCatTable, err error) {
	rowData = []*models.SysBaseKeyCatTable{}
	pageInfo.StartIndex = page
	pageInfo.PageSize = pageSize
	baseSql := "SELECT * FROM sys_basekey_cat "
	err = x.SQL(baseSql+" LIMIT ?,?", page*pageSize, pageSize).Find(&rowData)
	if err != nil {
		return
	}
	pageInfo.TotalRows = queryCount(baseSql)
	return
}

func BaseKeyCatCreate(input models.SysBaseKeyCatTable) error {
	if input.Name == "" {
		input.Name = input.Id
	}
	_, err := x.Exec("insert into sys_basekey_cat value (?,?,?)", input.Id, input.Name, input.Description)
	return err
}

func BaseKeyCodeQuery(param *models.QueryRequestParam) (pageInfo models.PageInfo, rowData []*models.SysBaseKeyCodeTable, err error) {
	rowData = []*models.SysBaseKeyCodeTable{}
	filterSql, queryColumn, queryParam := transFiltersToSQL(param, &models.TransFiltersParam{IsStruct: true, StructObj: models.SysBaseKeyCodeTable{}})
	baseSql := fmt.Sprintf("SELECT %s FROM sys_basekey_code WHERE 1=1 %s ", queryColumn, filterSql)
	if param.Paging {
		pageInfo.StartIndex = param.Pageable.StartIndex
		pageInfo.PageSize = param.Pageable.PageSize
		pageInfo.TotalRows = queryCount(baseSql, queryParam...)
		pageSql, pageParam := transPageInfoToSQL(*param.Pageable)
		baseSql += pageSql
		queryParam = append(queryParam, pageParam...)
	}
	err = x.SQL(baseSql, queryParam...).Find(&rowData)
	if err != nil {
		err = fmt.Errorf("BaseKey code query fail,%s ", err.Error())
		return
	}
	// Fetch baseKey cat
	var catRowData []*models.SysBaseKeyCatTable
	var catMap = make(map[string]*models.SysBaseKeyCatTable)
	x.SQL("SELECT * FROM sys_basekey_cat").Find(&catRowData)
	for _, catRow := range catRowData {
		catMap[catRow.Id] = catRow
	}
	for _, row := range rowData {
		row.Cat = catMap[row.CatId]
	}
	return
}

func BaseKeyCodeCreate(params []*models.BaseKeyCodeCreateObj) (rowData []*models.SysBaseKeyCodeTable, err error) {
	rowData = []*models.SysBaseKeyCodeTable{}
	var errMessage string
	catSeqNoMap := make(map[string]int)
	for i, param := range params {
		if param.CatId == "" {
			errMessage = fmt.Sprintf("Index:%d param catId can not empty ", i)
			continue
		}
		param.CodeId = param.CatId + models.SysTableIdConnector + param.Code
		if _, b := catSeqNoMap[param.CatId]; b {
			catSeqNoMap[param.CatId] = catSeqNoMap[param.CatId] + 1
		} else {
			catSeqNoMap[param.CatId] = getBaseKeyCodeSeqNo(param.CatId)
		}
		_, execErr := x.Exec("INSERT INTO sys_basekey_code(id,cat_id,code,value,status,seq_no,description) VALUE (?,?,?,?,?,?,?)", param.CodeId, param.CatId, param.Code, param.Value, param.Status, catSeqNoMap[param.CatId], param.Description)
		if execErr != nil {
			errMessage += fmt.Sprintf("Index %d data insert fail,%s. ", i, execErr.Error())
			continue
		}
		rowData = append(rowData, &models.SysBaseKeyCodeTable{Id: param.CodeId, CatId: param.CatId, Code: param.Code, Value: param.Value, Status: param.Status, SeqNo: catSeqNoMap[param.CatId], Description: param.Description})
	}
	if errMessage != "" {
		err = fmt.Errorf(errMessage)
	}
	return
}

func getBaseKeyCodeSeqNo(catId string) int {
	var rowData []*models.SysBaseKeyCodeTable
	err := x.SQL("SELECT seq_no FROM sys_basekey_code WHERE cat_id=? order by seq_no desc limit 1", catId).Find(&rowData)
	if len(rowData) == 0 {
		log.Logger.Warn("Get base key max seq no fail", log.Error(err), log.String("cat_id", catId))
		return 1
	}
	return rowData[0].SeqNo + 1
}

func BaseKeyCodeUpdate(params []*models.BaseKeyCodeCreateObj) (rowData []*models.SysBaseKeyCodeTable, err error) {
	rowData = []*models.SysBaseKeyCodeTable{}
	var errMessage string
	for i, param := range params {
		var execErr error
		if param.Status != "" {
			_, execErr = x.Exec("UPDATE sys_basekey_code SET value=?,status=?,description=? WHERE id=? ", param.Value, param.Status, param.Description, param.CodeId)
		} else {
			_, execErr = x.Exec("UPDATE sys_basekey_code SET code=?,value=? WHERE id=? ", param.Code, param.Value, param.CodeId)
		}
		if execErr != nil {
			errMessage += fmt.Sprintf("Index %d data update fail,%s. ", i, execErr.Error())
			continue
		}
		rowData = append(rowData, &models.SysBaseKeyCodeTable{Id: param.CodeId, CatId: param.CatId, Code: param.Code, Value: param.Value, Status: param.Status, Description: param.Description})
	}
	if errMessage != "" {
		err = fmt.Errorf(errMessage)
	}
	return
}

func BaseKeyCodeDelete(params []*models.BaseKeyCodeCreateObj) error {
	var actions []*execAction
	for _, param := range params {
		actions = append(actions, &execAction{Sql: "DELETE FROM sys_basekey_code WHERE id=?", Param: []interface{}{param.CodeId}})
	}
	return transaction(actions)
}

func BaseKeyCodeSwapPosition(param *models.BaseKeyCodeSwapPositionParam) error {
	var rowData []*models.SysBaseKeyCodeTable
	err := x.SQL("SELECT id,cat_id,seq_no FROM sys_basekey_code").Find(&rowData)
	if err != nil {
		return err
	}
	fetchRow := models.SysBaseKeyCodeTable{}
	for _, row := range rowData {
		if row.Id == param.CodeId {
			fetchRow = *row
			break
		}
	}
	if fetchRow.Id == "" {
		return fmt.Errorf("Base key code id:%s can not fetch any data ", param.CodeId)
	}
	if param.TargetIndex == 0 {
		if param.Up {
			if fetchRow.SeqNo == 0 {
				return fmt.Errorf("SeqNo is already 0,can not lowwer ")
			}
			param.TargetIndex = fetchRow.SeqNo - 1
		} else {
			param.TargetIndex = fetchRow.SeqNo + 1
		}
	}
	if param.TargetIndex == fetchRow.SeqNo {
		return nil
	}
	upFlag := false
	if param.TargetIndex < fetchRow.SeqNo {
		upFlag = true
	}
	updateAction := []*execAction{&execAction{Sql: "UPDATE sys_basekey_code SET seq_no=? WHERE id=?", Param: []interface{}{param.TargetIndex, fetchRow.Id}}}
	for _, row := range rowData {
		if row.CatId == fetchRow.CatId {
			if upFlag {
				if row.SeqNo >= param.TargetIndex && row.SeqNo < fetchRow.SeqNo {
					updateAction = append(updateAction, &execAction{Sql: "UPDATE sys_basekey_code SET seq_no=? WHERE id=?", Param: []interface{}{row.SeqNo + 1, row.Id}})
				}
			} else {
				if row.SeqNo <= param.TargetIndex && row.SeqNo > fetchRow.SeqNo {
					updateAction = append(updateAction, &execAction{Sql: "UPDATE sys_basekey_code SET seq_no=? WHERE id=?", Param: []interface{}{row.SeqNo - 1, row.Id}})
				}
			}
		}
	}
	return transaction(updateAction)
}
