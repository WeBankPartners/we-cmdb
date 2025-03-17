// Copyright 2019 The Xorm Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package dialects

import (
	"context"
	"fmt"
	"strconv"
	"strings"
)

// Filter is an interface to filter SQL
type Filter interface {
	Do(ctx context.Context, sql string) string
}

// postgresSeqFilter filter SQL replace ?, ? ... to $1, $2 ...
type postgresSeqFilter struct {
	Prefix string
	Start  int
}

func postgresSeqFilterConvertQuestionMark(sql, prefix string, start int) string {
	var buf strings.Builder
	var beginSingleQuote bool
	var isLineComment bool
	var isComment bool
	var isMaybeLineComment bool
	var isMaybeComment bool
	var isMaybeCommentEnd bool
	var isMaybeJsonbQuestion bool
	index := start
	for i, c := range sql {
		if !beginSingleQuote && !isLineComment && !isComment && !isMaybeJsonbQuestion && c == '?' {
			buf.WriteString(fmt.Sprintf("%s%v", prefix, index))
			index++
		} else {
			if isMaybeJsonbQuestion && c == '?' {
				isMaybeJsonbQuestion = false
			} else if isMaybeLineComment {
				if c == '-' {
					isLineComment = true
				}
				isMaybeLineComment = false
			} else if isMaybeComment {
				if c == '*' {
					isComment = true
				}
				isMaybeComment = false
			} else if isMaybeCommentEnd {
				if c == '/' {
					isComment = false
				}
				isMaybeCommentEnd = false
			} else if isLineComment {
				if c == '\n' {
					isLineComment = false
				}
			} else if isComment {
				if c == '*' {
					isMaybeCommentEnd = true
				}
			} else if !beginSingleQuote && c == '-' {
				isMaybeLineComment = true
			} else if !beginSingleQuote && c == '/' {
				isMaybeComment = true
			} else if !beginSingleQuote && c == ' ' && i >= 7 && strings.TrimSpace(sql[i-7:i]) == "::jsonb" {
				isMaybeJsonbQuestion = true
			} else if c == '\'' {
				beginSingleQuote = !beginSingleQuote
			}
			buf.WriteRune(c)
		}
	}
	return buf.String()
}

// Do implements Filter
func (s *postgresSeqFilter) Do(ctx context.Context, sql string) string {
	return postgresSeqFilterConvertQuestionMark(sql, s.Prefix, s.Start)
}

// oracleSeqFilter filter SQL replace ?, ? ... to :1, :2 ...
type oracleSeqFilter struct {
	Prefix string
	Start  int
}

func oracleSeqFilterConvertQuestionMark(sql, prefix string, start int) string {
	var buf strings.Builder
	var beginSingleQuote bool
	var isLineComment bool
	var isComment bool
	var isMaybeLineComment bool
	var isMaybeComment bool
	var isMaybeCommentEnd bool
	index := start
	for _, c := range sql {
		if !beginSingleQuote && !isLineComment && !isComment && c == '?' {
			buf.WriteString(prefix)
			buf.WriteString(strconv.Itoa(index))
			index++
		} else {
			if isMaybeLineComment {
				if c == '-' {
					isLineComment = true
				}
				isMaybeLineComment = false
			} else if isMaybeComment {
				if c == '*' {
					isComment = true
				}
				isMaybeComment = false
			} else if isMaybeCommentEnd {
				if c == '/' {
					isComment = false
				}
				isMaybeCommentEnd = false
			} else if isLineComment {
				if c == '\n' {
					isLineComment = false
				}
			} else if isComment {
				if c == '*' {
					isMaybeCommentEnd = true
				}
			} else if !beginSingleQuote && c == '-' {
				isMaybeLineComment = true
			} else if !beginSingleQuote && c == '/' {
				isMaybeComment = true
			} else if c == '\'' {
				beginSingleQuote = !beginSingleQuote
			}
			buf.WriteRune(c)
		}
	}
	return buf.String()
}

// Do implements Filter
func (s *oracleSeqFilter) Do(ctx context.Context, sql string) string {
	return oracleSeqFilterConvertQuestionMark(sql, s.Prefix, s.Start)
}
