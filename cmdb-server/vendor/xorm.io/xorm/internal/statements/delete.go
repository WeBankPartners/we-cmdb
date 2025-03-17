// Copyright 2023 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package statements

import (
	"errors"
	"fmt"
	"time"

	"xorm.io/builder"
	"xorm.io/xorm/internal/utils"
	"xorm.io/xorm/schemas"
)

func (statement *Statement) writeDeleteOrder(w *builder.BytesWriter) error {
	if err := statement.writeOrderBys(w); err != nil {
		return err
	}

	if statement.LimitN != nil && *statement.LimitN > 0 {
		if statement.Start > 0 {
			return fmt.Errorf("Delete with Limit start is unsupported")
		}
		limitNValue := *statement.LimitN
		if _, err := fmt.Fprintf(w, " LIMIT %d", limitNValue); err != nil {
			return err
		}
	}

	return nil
}

// ErrNotImplemented not implemented
var ErrNotImplemented = errors.New("Not implemented")

func (statement *Statement) writeOrderCond(orderCondWriter *builder.BytesWriter, tableName string) error {
	orderSQLWriter := builder.NewWriter()
	if err := statement.writeDeleteOrder(orderSQLWriter); err != nil {
		return err
	}

	if orderSQLWriter.Len() == 0 {
		return nil
	}

	switch statement.dialect.URI().DBType {
	case schemas.POSTGRES:
		if statement.cond.IsValid() {
			if _, err := fmt.Fprint(orderCondWriter, " AND "); err != nil {
				return err
			}
		} else {
			if _, err := fmt.Fprint(orderCondWriter, " WHERE "); err != nil {
				return err
			}
		}
		if _, err := fmt.Fprintf(orderCondWriter, "ctid IN (SELECT ctid FROM %s%s)", tableName, orderSQLWriter.String()); err != nil {
			return err
		}
		orderCondWriter.Append(orderSQLWriter.Args()...)
		return nil
	case schemas.SQLITE:
		if statement.cond.IsValid() {
			if _, err := fmt.Fprint(orderCondWriter, " AND "); err != nil {
				return err
			}
		} else {
			if _, err := fmt.Fprint(orderCondWriter, " WHERE "); err != nil {
				return err
			}
		}
		if _, err := fmt.Fprintf(orderCondWriter, "rowid IN (SELECT rowid FROM %s%s)", tableName, orderSQLWriter.String()); err != nil {
			return err
		}
		orderCondWriter.Append(orderSQLWriter.Args()...)
		return nil
		// TODO: how to handle delete limit on mssql?
	case schemas.MSSQL:
		return ErrNotImplemented
	default:
		return utils.WriteBuilder(orderCondWriter, orderSQLWriter)
	}
}

func (statement *Statement) WriteDelete(realSQLWriter, deleteSQLWriter *builder.BytesWriter, nowTime func(*schemas.Column) (interface{}, time.Time, error)) error {
	tableNameNoQuote := statement.TableName()
	tableName := statement.dialect.Quoter().Quote(tableNameNoQuote)
	table := statement.RefTable
	if _, err := fmt.Fprint(deleteSQLWriter, "DELETE FROM ", tableName); err != nil {
		return err
	}
	if err := statement.writeWhere(deleteSQLWriter); err != nil {
		return err
	}

	orderCondWriter := builder.NewWriter()
	if err := statement.writeOrderCond(orderCondWriter, tableName); err != nil {
		return err
	}

	if statement.GetUnscoped() || table == nil || table.DeletedColumn() == nil { // tag "deleted" is disabled
		return utils.WriteBuilder(realSQLWriter, deleteSQLWriter, orderCondWriter)
	}

	deletedColumn := table.DeletedColumn()
	if _, err := fmt.Fprintf(realSQLWriter, "UPDATE %v SET %v = ?",
		statement.dialect.Quoter().Quote(statement.TableName()),
		statement.dialect.Quoter().Quote(deletedColumn.Name)); err != nil {
		return err
	}

	val, _, err := nowTime(deletedColumn)
	if err != nil {
		return err
	}
	realSQLWriter.Append(val)

	if err := statement.writeWhere(realSQLWriter); err != nil {
		return err
	}

	return utils.WriteBuilder(realSQLWriter, orderCondWriter)
}
