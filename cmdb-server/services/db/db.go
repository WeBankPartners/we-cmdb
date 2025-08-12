package db

import (
	"fmt"
	"reflect"
	"strconv"
	"strings"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	_ "github.com/go-sql-driver/mysql"
	"go.uber.org/zap"
	"xorm.io/core"
	"xorm.io/xorm"
	xorm_log "xorm.io/xorm/log"
)

const HistoryTablePrefix = "history_"

var (
	x *xorm.Engine
	_ xorm_log.Logger = &dbLogger{}
)

func InitDatabase() error {
	connStr := fmt.Sprintf("%s:%s@%s(%s)/%s?collation=utf8mb4_unicode_ci&allowNativePasswords=true",
		models.Config.Database.User, models.Config.Database.Password, "tcp", fmt.Sprintf("%s:%s", models.Config.Database.Server, models.Config.Database.Port), models.Config.Database.DataBase)
	engine, err := xorm.NewEngine("mysql", connStr)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Init database connect fail", zap.Error(err))
		return err
	}
	engine.SetMaxIdleConns(models.Config.Database.MaxIdle)
	engine.SetMaxOpenConns(models.Config.Database.MaxOpen)
	engine.SetConnMaxLifetime(time.Duration(models.Config.Database.Timeout) * time.Second)
	if models.Config.Log.DbLogEnable {
		engine.SetLogger(&dbLogger{LogLevel: 1, ShowSql: true, Logger: log.DatabaseLogger})
	}
	// 使用驼峰式映射
	engine.SetMapper(core.SnakeMapper{})
	x = engine
	log.Info(nil, log.LOGGER_APP, "Success init database connect !!")
	return nil
}

type dbLogger struct {
	LogLevel xorm_log.LogLevel
	ShowSql  bool
	Logger   *zap.SugaredLogger
}

func (d *dbLogger) Debug(v ...interface{}) {
	d.Logger.Debugw(fmt.Sprint(v...))
}

func (d *dbLogger) Debugf(format string, v ...interface{}) {
	d.Logger.Debugw(fmt.Sprintf(format, v...))
}

func (d *dbLogger) Error(v ...interface{}) {
	d.Logger.Errorw(fmt.Sprint(v...))
}

func (d *dbLogger) Errorf(format string, v ...interface{}) {
	d.Logger.Errorw(fmt.Sprintf(format, v...))
}

func (d *dbLogger) Info(v ...interface{}) {
	d.Logger.Infow(fmt.Sprint(v...))
}

func (d *dbLogger) Infof(format string, v ...interface{}) {
	if len(v) < 4 {
		d.Logger.Infow(fmt.Sprintf(format, v...))
		return
	}
	var costMs float64 = 0
	costTime := fmt.Sprintf("%s", v[3])
	if strings.Contains(costTime, "µs") {
		costMs, _ = strconv.ParseFloat(strings.ReplaceAll(costTime, "µs", ""), 64)
		costMs = costMs / 1000
	} else if strings.Contains(costTime, "ms") {
		costMs, _ = strconv.ParseFloat(costTime[:len(costTime)-2], 64)
	} else if strings.Contains(costTime, "s") && !strings.Contains(costTime, "m") {
		costMs, _ = strconv.ParseFloat(costTime[:len(costTime)-1], 64)
		costMs = costMs * 1000
	} else {
		costTime = costTime[:len(costTime)-1]
		mIndex := strings.Index(costTime, "m")
		minTime, _ := strconv.ParseFloat(costTime[:mIndex], 64)
		secTime, _ := strconv.ParseFloat(costTime[mIndex+1:], 64)
		costMs = (minTime*60 + secTime) * 1000
	}
	d.Logger.Infow("db_log", zap.String("sql", fmt.Sprintf("%s", v[1])), zap.String("param", fmt.Sprintf("%v", v[2])), zap.Float64("cost_ms", costMs))
}

func (d *dbLogger) Warn(v ...interface{}) {
	d.Logger.Warnw(fmt.Sprint(v...))
}

func (d *dbLogger) Warnf(format string, v ...interface{}) {
	d.Logger.Warnw(fmt.Sprintf(format, v...))
}

func (d *dbLogger) Level() xorm_log.LogLevel {
	return d.LogLevel
}

func (d *dbLogger) SetLevel(l xorm_log.LogLevel) {
	d.LogLevel = l
}

func (d *dbLogger) ShowSQL(b ...bool) {
	d.ShowSql = b[0]
}

func (d *dbLogger) IsShowSQL() bool {
	return d.ShowSql
}

func queryCount(sql string, params ...interface{}) int {
	sql = "SELECT COUNT(1) FROM ( " + sql + " ) sub_query"
	// resultMap := make(map[string]int)
	params = append([]interface{}{sql}, params...)
	resultMap, err := x.QueryString(params...)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Query sql count message fail", zap.Error(err))
		return 0
	}
	if len(resultMap) > 0 {
		countNum, _ := strconv.Atoi(resultMap[0]["COUNT(1)"])
		return countNum
	}
	// if _, b := resultMap["COUNT(1)"]; b {
	// 	return resultMap["COUNT(1)"]
	// }
	return 0
}

func getJsonToXormMap(input interface{}) (resultMap map[string]string, idKeyName string) {
	resultMap = make(map[string]string)
	t := reflect.TypeOf(input)
	for i := 0; i < t.NumField(); i++ {
		resultMap[t.Field(i).Tag.Get("json")] = t.Field(i).Tag.Get("xorm")
		if i == 0 {
			idKeyName = t.Field(i).Tag.Get("xorm")
		}
	}
	return resultMap, idKeyName
}

func transFiltersToSQL(queryParam *models.QueryRequestParam, transParam *models.TransFiltersParam) (filterSql, queryColumn string, param []interface{}) {
	if transParam.Prefix != "" && !strings.HasSuffix(transParam.Prefix, ".") {
		transParam.Prefix = transParam.Prefix + "."
	}
	if transParam.IsStruct {
		transParam.KeyMap, transParam.PrimaryKey = getJsonToXormMap(transParam.StructObj)
	}
	for _, filter := range queryParam.Filters {
		if transParam.KeyMap[filter.Name] == "" || transParam.KeyMap[filter.Name] == "-" {
			continue
		}
		filterSqlColumn := fmt.Sprintf("%s", transParam.KeyMap[filter.Name])
		if pointIndex := strings.Index(filterSqlColumn, "."); pointIndex > 0 {
			filterSqlColumn = filterSqlColumn[:pointIndex+1] + "`" + filterSqlColumn[pointIndex+1:] + "`"
		} else {
			if transParam.Prefix != "" {
				filterSqlColumn = fmt.Sprintf("%s`%s`", transParam.Prefix, transParam.KeyMap[filter.Name])
			}
		}
		if filter.Operator == "eq" {
			if strings.Contains(filterSqlColumn, "time") && filter.Value == "" {
				continue
			}
			filterSql += fmt.Sprintf(" AND %s=? ", filterSqlColumn)
			param = append(param, filter.Value)
		} else if filter.Operator == "contains" || filter.Operator == "like" {
			filterSql += fmt.Sprintf(" AND %s LIKE ? ", filterSqlColumn)
			param = append(param, fmt.Sprintf("%%%s%%", filter.Value))
		} else if filter.Operator == "notLike" {
			filterSql += fmt.Sprintf(" AND %s NOT LIKE ? ", filterSqlColumn)
			param = append(param, fmt.Sprintf("%%%s%%", filter.Value))
		} else if filter.Operator == "in" {
			inValueStringList := []string{}
			if filter.Value != nil {
				if inValueList, ok := filter.Value.([]interface{}); ok {
					for _, inValueInterfaceObj := range inValueList {
						if inValueInterfaceObj == nil {
							inValueStringList = append(inValueStringList, "")
						} else {
							inValueStringList = append(inValueStringList, inValueInterfaceObj.(string))
						}
					}
				}
			}
			tmpSpecSql, tmpListParams := createListParams(inValueStringList, "")
			if tmpSpecSql == "" {
				tmpSpecSql = "''"
			}
			filterSql += fmt.Sprintf(" AND %s in (%s) ", filterSqlColumn, tmpSpecSql)
			param = append(param, tmpListParams...)
		} else if filter.Operator == "lt" {
			filterSql += fmt.Sprintf(" AND %s<=? ", filterSqlColumn)
			param = append(param, filter.Value)
		} else if filter.Operator == "gt" {
			filterSql += fmt.Sprintf(" AND %s>=? ", filterSqlColumn)
			param = append(param, filter.Value)
		} else if filter.Operator == "ne" || filter.Operator == "neq" {
			if strings.Contains(filterSqlColumn, "time") && filter.Value == "" {
				continue
			}
			filterSql += fmt.Sprintf(" AND %s!=? ", filterSqlColumn)
			param = append(param, filter.Value)
		} else if filter.Operator == "notNull" || filter.Operator == "isnot" {
			filterSql += fmt.Sprintf(" AND %s is not null ", filterSqlColumn)
		} else if filter.Operator == "null" || filter.Operator == "is" {
			filterSql += fmt.Sprintf(" AND %s is null ", filterSqlColumn)
		}
	}
	if queryParam.Sorting != nil {
		if transParam.KeyMap[queryParam.Sorting.Field] == "" || transParam.KeyMap[queryParam.Sorting.Field] == "-" {
			queryParam.Sorting.Field = transParam.PrimaryKey
		} else {
			queryParam.Sorting.Field = transParam.KeyMap[queryParam.Sorting.Field]
		}
		sortSqlColumn := fmt.Sprintf("`%s`", queryParam.Sorting.Field)
		if transParam.Prefix != "" {
			sortSqlColumn = fmt.Sprintf("%s`%s`", transParam.Prefix, queryParam.Sorting.Field)
		}
		if queryParam.Sorting.Asc {
			filterSql += fmt.Sprintf(" ORDER BY %s ASC ", sortSqlColumn)
		} else {
			filterSql += fmt.Sprintf(" ORDER BY %s DESC ", sortSqlColumn)
		}
	}
	if len(queryParam.ResultColumns) > 0 {
		for _, resultColumn := range queryParam.ResultColumns {
			if transParam.KeyMap[resultColumn] == "" || transParam.KeyMap[resultColumn] == "-" {
				continue
			}
			if transParam.Prefix != "" {
				queryColumn += fmt.Sprintf("%s`%s`,", transParam.Prefix, transParam.KeyMap[resultColumn])
			} else {
				queryColumn += fmt.Sprintf("`%s`,", transParam.KeyMap[resultColumn])
			}
		}
	}
	if queryColumn == "" {
		queryColumn = " * "
	} else {
		queryColumn = queryColumn[:len(queryColumn)-1]
	}
	return
}

func transPageInfoToSQL(pageInfo models.PageInfo) (pageSql string, param []interface{}) {
	pageSql = " LIMIT ?,? "
	param = append(param, pageInfo.StartIndex)
	param = append(param, pageInfo.PageSize)
	return
}

type execAction struct {
	Sql   string
	Param []interface{}
}

func transaction(actions []*execAction) error {
	if len(actions) == 0 {
		log.Warn(nil, log.LOGGER_APP, "Transaction is empty,nothing to do")
		return fmt.Errorf("SQL exec transaction is empty,nothing to do,please check server log ")
	}
	for i, action := range actions {
		if action == nil {
			return fmt.Errorf("SQL exec transaction index%d is nill error,please check server log", i)
		}
	}
	session := x.NewSession()
	err := session.Begin()
	for _, action := range actions {
		params := make([]interface{}, 0)
		params = append(params, action.Sql)
		for _, v := range action.Param {
			params = append(params, v)
		}
		_, err = session.Exec(params...)
		if err != nil {
			session.Rollback()
			break
		}
	}
	if err == nil {
		err = session.Commit()
	}
	session.Close()
	return err
}

func getDefaultInsertSqlByStruct(obj interface{}, tableName string, ignoreColumns []string) string {
	var columnList, valueList []string
	t := reflect.TypeOf(obj)
	for i := 0; i < t.NumField(); i++ {
		tmpXormTag := t.Field(i).Tag.Get("xorm")
		ignoreFlag := false
		for _, ignoreColumn := range ignoreColumns {
			if ignoreColumn == tmpXormTag {
				ignoreFlag = true
				break
			}
		}
		if ignoreFlag {
			continue
		}
		if tmpXormTag == "-" || tmpXormTag == "" {
			continue
		}
		columnList = append(columnList, fmt.Sprintf("`%s`", tmpXormTag))
		valueList = append(valueList, "?")
	}
	return fmt.Sprintf("INSERT INTO %s(%s) VALUE (%s)", tableName, strings.Join(columnList, ","), strings.Join(valueList, ","))
}

func transactionWithoutForeignCheck(actions []*execAction) error {
	if len(actions) == 0 {
		log.Warn(nil, log.LOGGER_APP, "Transaction is empty,nothing to do")
		return fmt.Errorf("SQL exec transaction is empty,nothing to do,please check server log ")
	}
	for i, action := range actions {
		if action == nil {
			return fmt.Errorf("SQL exec transaction index%d is nill error,please check server log", i)
		}
	}
	session := x.NewSession()
	err := session.Begin()
	if err != nil {
		return err
	}
	session.Exec("SET FOREIGN_KEY_CHECKS=0")
	for _, action := range actions {
		params := make([]interface{}, 0)
		params = append(params, action.Sql)
		for _, v := range action.Param {
			params = append(params, v)
		}
		_, err = session.Exec(params...)
		if err != nil {
			session.Rollback()
			break
		}
	}
	if err == nil {
		err = session.Commit()
	}
	session.Exec("SET FOREIGN_KEY_CHECKS=1")
	session.Close()
	return err
}
