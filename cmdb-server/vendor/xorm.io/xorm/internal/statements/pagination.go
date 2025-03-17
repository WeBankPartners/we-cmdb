// Copyright 2023 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package statements

import (
	"errors"
	"fmt"

	"xorm.io/builder"
	"xorm.io/xorm/internal/utils"
	"xorm.io/xorm/schemas"
)

func (statement *Statement) writePagination(bw *builder.BytesWriter) error {
	dbType := statement.dialect.URI().DBType
	if dbType == schemas.MSSQL || dbType == schemas.ORACLE {
		return statement.writeOffsetFetch(bw)
	}
	return statement.writeLimitOffset(bw)
}

func (statement *Statement) writeLimitOffset(w builder.Writer) error {
	if statement.Start > 0 {
		if statement.LimitN != nil {
			_, err := fmt.Fprintf(w, " LIMIT %v OFFSET %v", *statement.LimitN, statement.Start)
			return err
		}
		_, err := fmt.Fprintf(w, " OFFSET %v", statement.Start)
		return err
	}
	if statement.LimitN != nil {
		_, err := fmt.Fprint(w, " LIMIT ", *statement.LimitN)
		return err
	}
	// no limit statement
	return nil
}

func (statement *Statement) writeOffsetFetch(w builder.Writer) error {
	if statement.LimitN != nil {
		_, err := fmt.Fprintf(w, " OFFSET %v ROWS FETCH NEXT %v ROWS ONLY", statement.Start, *statement.LimitN)
		return err
	}
	if statement.Start > 0 {
		_, err := fmt.Fprintf(w, " OFFSET %v ROWS", statement.Start)
		return err
	}
	return nil
}

func (statement *Statement) writeWhereWithMssqlPagination(w *builder.BytesWriter) error {
	if statement.cond.IsValid() {
		if _, err := fmt.Fprint(w, " WHERE "); err != nil {
			return err
		}
		if err := statement.cond.WriteTo(statement.QuoteReplacer(w)); err != nil {
			return err
		}
	}

	return statement.writeMssqlPaginationCond(w)
}

// write subquery to implement limit offset
// (mssql legacy only)
func (statement *Statement) writeMssqlPaginationCond(w *builder.BytesWriter) error {
	if statement.Start <= 0 {
		return nil
	}

	if statement.RefTable == nil {
		return errors.New("unsupported query limit without reference table")
	}

	var column string
	if len(statement.RefTable.PKColumns()) == 0 {
		for _, index := range statement.RefTable.Indexes {
			if len(index.Cols) == 1 {
				column = index.Cols[0]
				break
			}
		}
		if len(column) == 0 {
			column = statement.RefTable.ColumnsSeq()[0]
		}
	} else {
		column = statement.RefTable.PKColumns()[0].Name
	}
	if statement.NeedTableName() {
		if len(statement.TableAlias) > 0 {
			column = fmt.Sprintf("%s.%s", statement.TableAlias, column)
		} else {
			column = fmt.Sprintf("%s.%s", statement.TableName(), column)
		}
	}

	subWriter := builder.NewWriter()
	if _, err := fmt.Fprintf(subWriter, "(%s NOT IN (SELECT TOP %d %s",
		column, statement.Start, column); err != nil {
		return err
	}
	if err := statement.writeFrom(subWriter); err != nil {
		return err
	}
	if err := statement.writeWhere(subWriter); err != nil {
		return err
	}
	if err := statement.writeOrderBys(subWriter); err != nil {
		return err
	}
	if err := statement.writeGroupBy(subWriter); err != nil {
		return err
	}
	if _, err := fmt.Fprint(subWriter, "))"); err != nil {
		return err
	}
	if err := statement.writeWhereOrAnd(w, statement.cond.IsValid()); err != nil {
		return err
	}

	return utils.WriteBuilder(w, subWriter)
}

func (statement *Statement) writeOracleLimit(columnStr string) func(w *builder.BytesWriter) error {
	return func(w *builder.BytesWriter) error {
		if statement.LimitN == nil {
			return nil
		}

		oldString := w.String()
		w.Reset()
		rawColStr := columnStr
		if rawColStr == "*" {
			rawColStr = "at.*"
		}
		_, err := fmt.Fprintf(w, "SELECT %v FROM (SELECT %v,ROWNUM RN FROM (%v) at WHERE ROWNUM <= %d) aat WHERE RN > %d",
			columnStr, rawColStr, oldString, statement.Start+*statement.LimitN, statement.Start)
		return err
	}
}
