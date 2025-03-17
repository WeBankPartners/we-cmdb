// Copyright 2016 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package xorm

import (
	"errors"
	"strconv"

	"xorm.io/builder"
	"xorm.io/xorm/caches"
	"xorm.io/xorm/schemas"
)

// ErrNeedDeletedCond delete needs less one condition error
var ErrNeedDeletedCond = errors.New("Delete action needs at least one condition")

func (session *Session) cacheDelete(table *schemas.Table, tableName, sqlStr string, args ...interface{}) error {
	if table == nil ||
		session.tx != nil {
		return ErrCacheFailed
	}

	for _, filter := range session.engine.dialect.Filters() {
		sqlStr = filter.Do(session.ctx, sqlStr)
	}

	newsql := session.statement.ConvertIDSQL(sqlStr)
	if newsql == "" {
		return ErrCacheFailed
	}

	cacher := session.engine.cacherMgr.GetCacher(tableName)
	pkColumns := table.PKColumns()
	ids, err := caches.GetCacheSql(cacher, tableName, newsql, args)
	if err != nil {
		rows, err := session.queryRows(newsql, args...)
		if err != nil {
			return err
		}
		defer rows.Close()

		resultsSlice, err := session.engine.ScanStringMaps(rows)
		if err != nil {
			return err
		}
		ids = make([]schemas.PK, 0)
		if len(resultsSlice) > 0 {
			for _, data := range resultsSlice {
				var id int64
				var pk schemas.PK = make([]interface{}, 0)
				for _, col := range pkColumns {
					if v, ok := data[col.Name]; !ok {
						return errors.New("no id")
					} else if col.SQLType.IsText() {
						pk = append(pk, v)
					} else if col.SQLType.IsNumeric() {
						id, err = strconv.ParseInt(v, 10, 64)
						if err != nil {
							return err
						}
						pk = append(pk, id)
					} else {
						return errors.New("not supported primary key type")
					}
				}
				ids = append(ids, pk)
			}
		}
	}

	for _, id := range ids {
		session.engine.logger.Debugf("[cache] delete cache obj: %v, %v", tableName, id)
		sid, err := id.ToString()
		if err != nil {
			return err
		}
		cacher.DelBean(tableName, sid)
	}
	session.engine.logger.Debugf("[cache] clear cache table: %v", tableName)
	cacher.ClearIds(tableName)
	return nil
}

// Delete records, bean's non-empty fields are conditions
// At least one condition must be set.
func (session *Session) Delete(beans ...interface{}) (int64, error) {
	return session.delete(beans, true)
}

// Truncate records, bean's non-empty fields are conditions
// In contrast to Delete this method allows deletes without conditions.
func (session *Session) Truncate(beans ...interface{}) (int64, error) {
	return session.delete(beans, false)
}

func (session *Session) delete(beans []interface{}, mustHaveConditions bool) (int64, error) {
	if session.isAutoClose {
		defer session.Close()
	}

	if session.statement.LastError != nil {
		return 0, session.statement.LastError
	}

	var (
		err  error
		bean interface{}
	)
	if len(beans) > 0 {
		bean = beans[0]
		if err = session.statement.SetRefBean(bean); err != nil {
			return 0, err
		}

		executeBeforeClosures(session, bean)

		if processor, ok := interface{}(bean).(BeforeDeleteProcessor); ok {
			processor.BeforeDelete()
		}

		if err = session.statement.MergeConds(bean); err != nil {
			return 0, err
		}
	}

	pLimitN := session.statement.LimitN
	if mustHaveConditions && !session.statement.Conds().IsValid() && (pLimitN == nil || *pLimitN == 0) {
		return 0, ErrNeedDeletedCond
	}

	tableNameNoQuote := session.statement.TableName()
	table := session.statement.RefTable

	realSQLWriter := builder.NewWriter()
	deleteSQLWriter := builder.NewWriter()
	if err := session.statement.WriteDelete(realSQLWriter, deleteSQLWriter, session.engine.nowTime); err != nil {
		return 0, err
	}

	if session.statement.GetUnscoped() || table == nil || table.DeletedColumn() == nil { // tag "deleted" is disabled
	} else {
		deletedColumn := table.DeletedColumn()
		_, t, err := session.engine.nowTime(deletedColumn)
		if err != nil {
			return 0, err
		}

		colName := deletedColumn.Name
		session.afterClosures = append(session.afterClosures, func(bean interface{}) {
			col := table.GetColumn(colName)
			setColumnTime(bean, col, t)
		})
	}

	argsForCache := make([]interface{}, 0, len(deleteSQLWriter.Args())*2)
	copy(argsForCache, deleteSQLWriter.Args())
	argsForCache = append(deleteSQLWriter.Args(), argsForCache...)

	if cacher := session.engine.GetCacher(tableNameNoQuote); cacher != nil && session.statement.UseCache {
		_ = session.cacheDelete(table, tableNameNoQuote, deleteSQLWriter.String(), argsForCache...)
	}

	session.statement.RefTable = table
	res, err := session.exec(realSQLWriter.String(), realSQLWriter.Args()...)
	if err != nil {
		return 0, err
	}

	if bean != nil {
		// handle after delete processors
		if session.isAutoCommit {
			for _, closure := range session.afterClosures {
				closure(bean)
			}
			if processor, ok := interface{}(bean).(AfterDeleteProcessor); ok {
				processor.AfterDelete()
			}
		} else {
			lenAfterClosures := len(session.afterClosures)
			if lenAfterClosures > 0 && len(beans) > 0 {
				if value, has := session.afterDeleteBeans[beans[0]]; has && value != nil {
					*value = append(*value, session.afterClosures...)
				} else {
					afterClosures := make([]func(interface{}), lenAfterClosures)
					copy(afterClosures, session.afterClosures)
					session.afterDeleteBeans[bean] = &afterClosures
				}
			} else {
				if _, ok := interface{}(bean).(AfterDeleteProcessor); ok {
					session.afterDeleteBeans[bean] = nil
				}
			}
		}
	}
	cleanupProcessorsClosures(&session.afterClosures)
	// --

	return res.RowsAffected()
}
