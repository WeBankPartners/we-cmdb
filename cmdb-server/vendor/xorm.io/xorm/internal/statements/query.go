// Copyright 2019 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package statements

import (
	"errors"
	"fmt"
	"reflect"
	"strings"

	"xorm.io/builder"
	"xorm.io/xorm/schemas"
)

// GenQuerySQL generate query SQL
func (statement *Statement) GenQuerySQL(sqlOrArgs ...interface{}) (string, []interface{}, error) {
	if len(sqlOrArgs) > 0 {
		return statement.ConvertSQLOrArgs(sqlOrArgs...)
	}

	if statement.RawSQL != "" {
		return statement.GenRawSQL(), statement.RawParams, nil
	}

	if len(statement.TableName()) <= 0 {
		return "", nil, ErrTableNotFound
	}

	if err := statement.ProcessIDParam(); err != nil {
		return "", nil, err
	}

	buf := builder.NewWriter()
	if err := statement.writeSelect(buf, statement.genSelectColumnStr(), false); err != nil {
		return "", nil, err
	}
	return buf.String(), buf.Args(), nil
}

// GenSumSQL generates sum SQL
func (statement *Statement) GenSumSQL(bean interface{}, columns ...string) (string, []interface{}, error) {
	if statement.RawSQL != "" {
		return statement.GenRawSQL(), statement.RawParams, nil
	}

	if err := statement.SetRefBean(bean); err != nil {
		return "", nil, err
	}

	sumStrs := make([]string, 0, len(columns))
	for _, colName := range columns {
		if !strings.Contains(colName, " ") && !strings.Contains(colName, "(") {
			colName = statement.quote(colName)
		} else {
			colName = statement.ReplaceQuote(colName)
		}
		sumStrs = append(sumStrs, fmt.Sprintf("COALESCE(sum(%s),0)", colName))
	}

	if err := statement.MergeConds(bean); err != nil {
		return "", nil, err
	}

	buf := builder.NewWriter()
	if err := statement.writeSelect(buf, strings.Join(sumStrs, ", "), true); err != nil {
		return "", nil, err
	}
	return buf.String(), buf.Args(), nil
}

// GenGetSQL generates Get SQL
func (statement *Statement) GenGetSQL(bean interface{}) (string, []interface{}, error) {
	var isStruct bool
	if bean != nil {
		v := rValue(bean)
		isStruct = v.Kind() == reflect.Struct
		if isStruct {
			if err := statement.SetRefBean(bean); err != nil {
				return "", nil, err
			}
		}
	}

	columnStr := statement.ColumnStr()
	if len(statement.SelectStr) > 0 {
		columnStr = statement.SelectStr
	} else {
		// TODO: always generate column names, not use * even if join
		if len(statement.joins) == 0 {
			if len(columnStr) == 0 {
				if len(statement.GroupByStr) > 0 {
					columnStr = statement.quoteColumnStr(statement.GroupByStr)
				} else {
					columnStr = statement.genColumnStr()
				}
			}
		} else {
			if len(columnStr) == 0 {
				if len(statement.GroupByStr) > 0 {
					columnStr = statement.quoteColumnStr(statement.GroupByStr)
				}
			}
		}
	}

	if len(columnStr) == 0 {
		columnStr = "*"
	}

	if isStruct {
		if err := statement.MergeConds(bean); err != nil {
			return "", nil, err
		}
	} else {
		if err := statement.ProcessIDParam(); err != nil {
			return "", nil, err
		}
	}

	buf := builder.NewWriter()
	if err := statement.writeSelect(buf, columnStr, false); err != nil {
		return "", nil, err
	}
	return buf.String(), buf.Args(), nil
}

// GenCountSQL generates the SQL for counting
func (statement *Statement) GenCountSQL(beans ...interface{}) (string, []interface{}, error) {
	if statement.RawSQL != "" {
		return statement.GenRawSQL(), statement.RawParams, nil
	}

	if len(beans) > 0 {
		if err := statement.SetRefBean(beans[0]); err != nil {
			return "", nil, err
		}
		if err := statement.MergeConds(beans[0]); err != nil {
			return "", nil, err
		}
	}

	selectSQL := statement.SelectStr
	if len(selectSQL) <= 0 {
		if statement.IsDistinct {
			selectSQL = fmt.Sprintf("count(DISTINCT %s)", statement.ColumnStr())
		} else if statement.ColumnStr() != "" {
			selectSQL = fmt.Sprintf("count(%s)", statement.ColumnStr())
		} else {
			selectSQL = "count(*)"
		}
	}

	buf := builder.NewWriter()
	if statement.GroupByStr != "" {
		if _, err := fmt.Fprintf(buf, "SELECT %s FROM (", selectSQL); err != nil {
			return "", nil, err
		}
	}

	var subQuerySelect string
	if statement.GroupByStr != "" {
		subQuerySelect = statement.GroupByStr
	} else {
		subQuerySelect = selectSQL
	}

	if err := statement.writeSelect(buf, subQuerySelect, true); err != nil {
		return "", nil, err
	}

	if statement.GroupByStr != "" {
		if _, err := fmt.Fprintf(buf, ") sub"); err != nil {
			return "", nil, err
		}
	}

	return buf.String(), buf.Args(), nil
}

func (statement *Statement) writeFrom(w *builder.BytesWriter) error {
	return statement.writeMultiple(w,
		statement.writeStrings(" FROM "),
		statement.writeTableName,
		statement.writeAlias,
		statement.writeIndexHints,
		statement.writeJoins,
	)
}

// write "TOP <n>" (mssql only)
func (statement *Statement) writeTop(w *builder.BytesWriter) error {
	if statement.LimitN == nil {
		return nil
	}
	_, err := fmt.Fprintf(w, " TOP %d", *statement.LimitN)
	return err
}

func (statement *Statement) writeDistinct(w *builder.BytesWriter) error {
	if statement.IsDistinct && !strings.HasPrefix(statement.SelectStr, "count(") {
		_, err := fmt.Fprint(w, " DISTINCT")
		return err
	}
	return nil
}

func (statement *Statement) writeSelectColumns(columnStr string) func(w *builder.BytesWriter) error {
	return statement.groupWriteFns(
		statement.writeStrings("SELECT"),
		statement.writeDistinct,
		statement.writeStrings(" ", columnStr),
	)
}

func (statement *Statement) writeWhereCond(w *builder.BytesWriter, cond builder.Cond) error {
	if !cond.IsValid() {
		return nil
	}

	if _, err := fmt.Fprint(w, " WHERE "); err != nil {
		return err
	}
	return cond.WriteTo(statement.QuoteReplacer(w))
}

func (statement *Statement) writeWhere(w *builder.BytesWriter) error {
	return statement.writeWhereCond(w, statement.cond)
}

func (statement *Statement) writeForUpdate(w *builder.BytesWriter) error {
	if !statement.IsForUpdate {
		return nil
	}

	if statement.dialect.URI().DBType != schemas.MYSQL {
		return errors.New("only support mysql for update")
	}
	_, err := fmt.Fprint(w, " FOR UPDATE")
	return err
}

func (statement *Statement) writeSelect(buf *builder.BytesWriter, columnStr string, isCounting bool) error {
	dbType := statement.dialect.URI().DBType
	if statement.isUsingLegacyLimitOffset() {
		if dbType == "mssql" {
			return statement.writeMssqlLegacySelect(buf, columnStr)
		}
		if dbType == "oracle" {
			return statement.writeOracleLegacySelect(buf, columnStr)
		}
	}

	return statement.writeMultiple(buf,
		statement.writeSelectColumns(columnStr),
		statement.writeFrom,
		statement.writeWhere,
		statement.writeGroupBy,
		statement.writeHaving,
		func(bw *builder.BytesWriter) (err error) {
			if dbType == "mssql" && len(statement.orderBy) == 0 {
				// ORDER BY is mandatory to use OFFSET and FETCH clause (only in sqlserver)
				if statement.LimitN == nil && statement.Start == 0 {
					// no need to add
					return
				}
				if statement.IsDistinct || len(statement.GroupByStr) > 0 || isCounting {
					// the order-by column should be one of distincts or group-bys
					// order by the first column
					_, err = bw.WriteString(" ORDER BY 1 ASC")
					return
				}
				if statement.RefTable == nil || len(statement.RefTable.PrimaryKeys) != 1 {
					// no primary key, order by the first column
					_, err = bw.WriteString(" ORDER BY 1 ASC")
					return
				}
				// order by primary key
				statement.orderBy = []orderBy{{orderStr: statement.colName(statement.RefTable.GetColumn(statement.RefTable.PrimaryKeys[0]), statement.TableName()), direction: "ASC"}}
			}
			return statement.writeOrderBys(bw)
		},
		statement.writePagination,
		statement.writeForUpdate,
	)
}

// GenExistSQL generates Exist SQL
func (statement *Statement) GenExistSQL(bean ...interface{}) (string, []interface{}, error) {
	if statement.RawSQL != "" {
		return statement.GenRawSQL(), statement.RawParams, nil
	}

	var b interface{}
	if len(bean) > 0 {
		b = bean[0]
		beanValue := reflect.ValueOf(bean[0])
		if beanValue.Kind() != reflect.Ptr {
			return "", nil, errors.New("needs a pointer")
		}

		if beanValue.Elem().Kind() == reflect.Struct {
			if err := statement.SetRefBean(bean[0]); err != nil {
				return "", nil, err
			}
		}
	}
	tableName := statement.TableName()
	if len(tableName) <= 0 {
		return "", nil, ErrTableNotFound
	}
	if statement.RefTable != nil {
		return statement.Limit(1).GenGetSQL(b)
	}

	tableName = statement.quote(tableName)

	buf := builder.NewWriter()
	if statement.dialect.URI().DBType == schemas.MSSQL {
		if _, err := fmt.Fprintf(buf, "SELECT TOP 1 * FROM %s", tableName); err != nil {
			return "", nil, err
		}
		if err := statement.writeJoins(buf); err != nil {
			return "", nil, err
		}
		if err := statement.writeWhere(buf); err != nil {
			return "", nil, err
		}
	} else if statement.dialect.URI().DBType == schemas.ORACLE {
		if _, err := fmt.Fprintf(buf, "SELECT * FROM %s", tableName); err != nil {
			return "", nil, err
		}
		if err := statement.writeJoins(buf); err != nil {
			return "", nil, err
		}
		if _, err := fmt.Fprintf(buf, " WHERE "); err != nil {
			return "", nil, err
		}
		if statement.Conds().IsValid() {
			if err := statement.Conds().WriteTo(statement.QuoteReplacer(buf)); err != nil {
				return "", nil, err
			}
			if _, err := fmt.Fprintf(buf, " AND "); err != nil {
				return "", nil, err
			}
		}
		if _, err := fmt.Fprintf(buf, "ROWNUM=1"); err != nil {
			return "", nil, err
		}
	} else {
		if _, err := fmt.Fprintf(buf, "SELECT 1 FROM %s", tableName); err != nil {
			return "", nil, err
		}
		if err := statement.writeJoins(buf); err != nil {
			return "", nil, err
		}
		if err := statement.writeWhere(buf); err != nil {
			return "", nil, err
		}
		if _, err := fmt.Fprintf(buf, " LIMIT 1"); err != nil {
			return "", nil, err
		}
	}

	return buf.String(), buf.Args(), nil
}

func (statement *Statement) genSelectColumnStr() string {
	// manually select columns
	if len(statement.SelectStr) > 0 {
		return statement.SelectStr
	}

	columnStr := statement.ColumnStr()
	if columnStr != "" {
		return columnStr
	}

	// autodetect columns
	if statement.GroupByStr != "" {
		return statement.quoteColumnStr(statement.GroupByStr)
	}

	if len(statement.joins) != 0 {
		return "*"
	}

	columnStr = statement.genColumnStr()
	if columnStr == "" {
		columnStr = "*"
	}
	return columnStr
}

// GenFindSQL generates Find SQL
func (statement *Statement) GenFindSQL(autoCond builder.Cond) (string, []interface{}, error) {
	if statement.RawSQL != "" {
		return statement.GenRawSQL(), statement.RawParams, nil
	}

	if len(statement.TableName()) <= 0 {
		return "", nil, ErrTableNotFound
	}

	statement.cond = statement.cond.And(autoCond)

	buf := builder.NewWriter()
	if err := statement.writeSelect(buf, statement.genSelectColumnStr(), false); err != nil {
		return "", nil, err
	}
	return buf.String(), buf.Args(), nil
}
