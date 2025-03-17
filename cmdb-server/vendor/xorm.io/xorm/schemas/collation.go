// Copyright 2023 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package schemas

type Collation struct {
	Name   string
	Column string // blank means it's a table collation
}
