package db

import (
	"fmt"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
)

func SaveOperationLog(param *models.SysLogTable) {
	_, err := x.Exec("INSERT INTO sys_log(log_cat,operator,operation,content,request_url,client_host,created_date,data_ci_type,data_guid,data_key_name) value (?,?,?,?,?,?,?,?,?,?)",
		param.LogCat, param.Operator, param.Operation, param.Content, param.RequestUrl, param.ClientHost, time.Now().Format(models.DateTimeFormat), param.DataCiType, param.DataGuid, param.DataKeyName)
	if err != nil {
		log.Logger.Error("Save operation log fail", log.Error(err))
	}
}

func QueryOperationLog(param *models.QueryRequestParam) (pageInfo models.PageInfo, rowData []*models.SysLogTable, err error) {
	rowData = []*models.SysLogTable{}
	filterSql, queryColumn, queryParam := transFiltersToSQL(param, &models.TransFiltersParam{IsStruct: true, StructObj: models.SysLogTable{}, PrimaryKey: "id"})
	baseSql := fmt.Sprintf("SELECT %s FROM sys_log WHERE 1=1 %s ", queryColumn, filterSql)
	if param.Paging {
		pageInfo.StartIndex = param.Pageable.StartIndex
		pageInfo.PageSize = param.Pageable.PageSize
		pageInfo.TotalRows = queryCount(baseSql, queryParam...)
		pageSql, pageParam := transPageInfoToSQL(*param.Pageable)
		baseSql += pageSql
		queryParam = append(queryParam, pageParam...)
	}
	err = x.SQL(baseSql, queryParam...).Find(&rowData)
	return
}

func GetAllLogOperation() []string {
	result := []string{"POST", "PUT", "DELETE"}
	queryRows, err := x.QueryString("select distinct operation_en from sys_state_transition")
	if err != nil {
		log.Logger.Error("Try to get all log operation fail", log.Error(err))
	} else {
		for _, row := range queryRows {
			result = append(result, row["operation_en"])
		}
	}
	return result
}
