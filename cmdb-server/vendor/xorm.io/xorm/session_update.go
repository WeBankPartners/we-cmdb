// Copyright 2016 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package xorm

import (
	"reflect"

	"xorm.io/builder"
	"xorm.io/xorm/internal/statements"
	"xorm.io/xorm/internal/utils"
	"xorm.io/xorm/schemas"
)

// enumerated all errors
var (
	ErrNoColumnsTobeUpdated = statements.ErrNoColumnsTobeUpdated
)

func (session *Session) genAutoCond(condiBean interface{}) (builder.Cond, error) {
	if session.statement.NoAutoCondition {
		return builder.NewCond(), nil
	}

	if c, ok := condiBean.(map[string]interface{}); ok {
		eq := make(builder.Eq)
		for k, v := range c {
			eq[session.engine.Quote(k)] = v
		}

		if session.statement.RefTable != nil {
			if col := session.statement.RefTable.DeletedColumn(); col != nil && !session.statement.GetUnscoped() { // tag "deleted" is enabled
				return eq.And(session.statement.CondDeleted(col)), nil
			}
		}
		return eq, nil
	}

	ct := reflect.TypeOf(condiBean)
	k := ct.Kind()
	if k == reflect.Ptr {
		k = ct.Elem().Kind()
	}
	if k != reflect.Struct {
		return nil, ErrConditionType
	}

	condTable, err := session.engine.TableInfo(condiBean)
	if err != nil {
		return nil, err
	}
	return session.statement.BuildConds(condTable, condiBean, true, true, false, true, false)
}

// Update records, bean's non-empty fields are updated contents,
// condiBean' non-empty filds are conditions
// CAUTION:
//
//	1.bool will defaultly be updated content nor conditions
//	 You should call UseBool if you have bool to use.
//	2.float32 & float64 may be not inexact as conditions
func (session *Session) Update(bean interface{}, condiBean ...interface{}) (int64, error) {
	if session.isAutoClose {
		defer session.Close()
	}

	defer session.resetStatement()

	if session.statement.LastError != nil {
		return 0, session.statement.LastError
	}

	v := utils.ReflectValue(bean)
	t := v.Type()

	// handle before update processors
	for _, closure := range session.beforeClosures {
		closure(bean)
	}
	cleanupProcessorsClosures(&session.beforeClosures) // cleanup after used
	if processor, ok := interface{}(bean).(BeforeUpdateProcessor); ok {
		processor.BeforeUpdate()
	}
	// --

	var colNames []string
	var args []interface{}
	var err error
	isMap := t.Kind() == reflect.Map
	isStruct := t.Kind() == reflect.Struct
	if isStruct {
		if err := session.statement.SetRefBean(bean); err != nil {
			return 0, err
		}

		if len(session.statement.TableName()) == 0 {
			return 0, ErrTableNotFound
		}

		if session.statement.ColumnStr() == "" {
			colNames, args, err = session.statement.BuildUpdates(v, false, false,
				false, false, true)
		} else {
			colNames, args, err = session.genUpdateColumns(bean)
		}
		if err != nil {
			return 0, err
		}
	} else if isMap {
		colNames = make([]string, 0)
		args = make([]interface{}, 0)
		bValue := reflect.Indirect(reflect.ValueOf(bean))

		for _, v := range bValue.MapKeys() {
			colNames = append(colNames, session.engine.Quote(v.String())+" = ?")
			args = append(args, bValue.MapIndex(v).Interface())
		}
	} else {
		return 0, ErrParamsType
	}

	table := session.statement.RefTable

	if session.statement.UseAutoTime && table != nil && table.Updated != "" {
		if !session.statement.ColumnMap.Contain(table.Updated) &&
			!session.statement.OmitColumnMap.Contain(table.Updated) {
			colNames = append(colNames, session.engine.Quote(table.Updated)+" = ?")
			col := table.UpdatedColumn()
			val, t, err := session.engine.nowTime(col)
			if err != nil {
				return 0, err
			}
			if session.engine.dialect.URI().DBType == schemas.ORACLE {
				args = append(args, t)
			} else {
				args = append(args, val)
			}

			colName := col.Name
			if isStruct {
				session.afterClosures = append(session.afterClosures, func(bean interface{}) {
					col := table.GetColumn(colName)
					setColumnTime(bean, col, t)
				})
			}
		}
	}

	if err = session.statement.ProcessIDParam(); err != nil {
		return 0, err
	}

	var autoCond builder.Cond
	if len(condiBean) > 0 {
		autoCond, err = session.genAutoCond(condiBean[0])
		if err != nil {
			return 0, err
		}
	} else if table != nil {
		if col := table.DeletedColumn(); col != nil && !session.statement.GetUnscoped() { // tag "deleted" is enabled
			autoCond1 := session.statement.CondDeleted(col)

			if autoCond == nil {
				autoCond = autoCond1
			} else {
				autoCond = autoCond.And(autoCond1)
			}
		}
	}

	var (
		cond     = session.statement.Conds().And(autoCond)
		doIncVer = isStruct && (table != nil && table.Version != "" && session.statement.CheckVersion)
		verValue *reflect.Value
	)
	if doIncVer {
		verValue, err = table.VersionColumn().ValueOfV(&v)
		if err != nil {
			return 0, err
		}

		if verValue != nil {
			cond = cond.And(builder.Eq{session.engine.Quote(table.Version): verValue.Interface()})
		}
	}

	updateWriter := builder.NewWriter()
	if err := session.statement.WriteUpdate(updateWriter, cond, v, colNames, args); err != nil {
		return 0, err
	}

	tableName := session.statement.TableName() // table name must been get before exec because statement will be reset
	useCache := session.statement.UseCache

	res, err := session.exec(updateWriter.String(), updateWriter.Args()...)
	if err != nil {
		return 0, err
	} else if doIncVer {
		if verValue != nil && verValue.IsValid() && verValue.CanSet() {
			session.incrVersionFieldValue(verValue)
		}
	}

	if cacher := session.engine.GetCacher(tableName); cacher != nil && useCache {
		session.engine.logger.Debugf("[cache] clear table: %v", tableName)
		cacher.ClearIds(tableName)
		cacher.ClearBeans(tableName)
	}

	// handle after update processors
	if session.isAutoCommit {
		for _, closure := range session.afterClosures {
			closure(bean)
		}
		if processor, ok := interface{}(bean).(AfterUpdateProcessor); ok {
			session.engine.logger.Debugf("[event] %v has after update processor", tableName)
			processor.AfterUpdate()
		}
	} else {
		lenAfterClosures := len(session.afterClosures)
		if lenAfterClosures > 0 {
			if value, has := session.afterUpdateBeans[bean]; has && value != nil {
				*value = append(*value, session.afterClosures...)
			} else {
				afterClosures := make([]func(interface{}), lenAfterClosures)
				copy(afterClosures, session.afterClosures)
				// FIXME: if bean is a map type, it will panic because map cannot be as map key
				session.afterUpdateBeans[bean] = &afterClosures
			}
		} else {
			if _, ok := interface{}(bean).(AfterUpdateProcessor); ok {
				session.afterUpdateBeans[bean] = nil
			}
		}
	}
	cleanupProcessorsClosures(&session.afterClosures) // cleanup after used
	// --

	return res.RowsAffected()
}

func (session *Session) genUpdateColumns(bean interface{}) ([]string, []interface{}, error) {
	table := session.statement.RefTable
	colNames := make([]string, 0, len(table.ColumnsSeq()))
	args := make([]interface{}, 0, len(table.ColumnsSeq()))

	for _, col := range table.Columns() {
		if !col.IsVersion && !col.IsCreated && !col.IsUpdated {
			if session.statement.OmitColumnMap.Contain(col.Name) {
				continue
			}
		}
		if col.MapType == schemas.ONLYFROMDB {
			continue
		}

		fieldValuePtr, err := col.ValueOf(bean)
		if err != nil {
			return nil, nil, err
		}
		fieldValue := *fieldValuePtr

		if col.IsAutoIncrement && utils.IsValueZero(fieldValue) {
			continue
		}

		if (col.IsDeleted && !session.statement.GetUnscoped()) || col.IsCreated {
			continue
		}

		// if only update specify columns
		if len(session.statement.ColumnMap) > 0 && !session.statement.ColumnMap.Contain(col.Name) {
			continue
		}

		if session.statement.IncrColumns.IsColExist(col.Name) {
			continue
		} else if session.statement.DecrColumns.IsColExist(col.Name) {
			continue
		} else if session.statement.ExprColumns.IsColExist(col.Name) {
			continue
		}

		// !evalphobia! set fieldValue as nil when column is nullable and zero-value
		if _, ok := getFlagForColumn(session.statement.NullableMap, col); ok {
			if col.Nullable && utils.IsValueZero(fieldValue) {
				var nilValue *int
				fieldValue = reflect.ValueOf(nilValue)
			}
		}

		if col.IsUpdated && session.statement.UseAutoTime /*&& isZero(fieldValue.Interface())*/ {
			// if time is non-empty, then set to auto time
			val, t, err := session.engine.nowTime(col)
			if err != nil {
				return nil, nil, err
			}
			args = append(args, val)

			colName := col.Name
			session.afterClosures = append(session.afterClosures, func(bean interface{}) {
				col := table.GetColumn(colName)
				setColumnTime(bean, col, t)
			})
		} else if col.IsVersion && session.statement.CheckVersion {
			args = append(args, 1)
		} else {
			arg, err := session.statement.Value2Interface(col, fieldValue)
			if err != nil {
				return colNames, args, err
			}
			args = append(args, arg)
		}

		colNames = append(colNames, session.engine.Quote(col.Name)+" = ?")
	}
	return colNames, args, nil
}
