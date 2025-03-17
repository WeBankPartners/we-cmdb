// Copyright 2022 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package statements

import (
	"xorm.io/builder"
)

// isUsingLegacy returns true if xorm uses legacy LIMIT OFFSET.
// It's only available in sqlserver and oracle, if param USE_LEGACY_LIMIT_OFFSET is set to "true"
func (statement *Statement) isUsingLegacyLimitOffset() bool {
	u, ok := statement.dialect.(interface{ UseLegacyLimitOffset() bool })
	return ok && u.UseLegacyLimitOffset()
}

// write mssql legacy query sql
func (statement *Statement) writeMssqlLegacySelect(buf *builder.BytesWriter, columnStr string) error {
	return statement.writeMultiple(buf,
		statement.writeStrings("SELECT"),
		statement.writeDistinct,
		statement.writeTop,
		statement.writeFrom,
		statement.writeWhereWithMssqlPagination,
		statement.writeGroupBy,
		statement.writeHaving,
		statement.writeOrderBys,
		statement.writeForUpdate,
	)
}

func (statement *Statement) writeOracleLegacySelect(buf *builder.BytesWriter, columnStr string) error {
	return statement.writeMultiple(buf,
		statement.writeSelectColumns(columnStr),
		statement.writeFrom,
		statement.writeWhere,
		statement.writeOracleLimit(columnStr),
		statement.writeGroupBy,
		statement.writeHaving,
		statement.writeOrderBys,
		statement.writeForUpdate,
	)
}
