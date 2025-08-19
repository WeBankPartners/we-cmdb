package logger

import (
	"fmt"
	"math"
	"strings"

	"github.com/petermattis/goid"
	"go.uber.org/zap/buffer"
	"go.uber.org/zap/zapcore"
)

var (
	_pool = buffer.NewPool()
)

// 自定义日志编码器
type customEncoder struct {
	zapcore.Encoder
	cfg *zapcore.EncoderConfig
}

// 构造函数
func newCustomEncoder(cfg *zapcore.EncoderConfig) *customEncoder {
	return &customEncoder{
		Encoder: zapcore.NewConsoleEncoder(*cfg),
		cfg:     cfg,
	}
}

// 实现Encoder接口的Clone方法
func (e *customEncoder) Clone() zapcore.Encoder {
	return &customEncoder{
		Encoder: e.Encoder.Clone(),
		cfg:     e.cfg,
	}
}

// 实现Encoder接口的EncodeEntry方法
// 格式：[级别][时间][协程ID][调用模块][功能名/交易ID][流水号][调用文件]日志内容
func (e *customEncoder) EncodeEntry(entry zapcore.Entry,
	fields []zapcore.Field) (line *buffer.Buffer, err error) {

	line = _pool.Get()
	leftSep := "["
	rightSep := "]"
	// 日志级别
	fmt.Fprint(line, leftSep, entry.Level.CapitalString(), rightSep)
	// 时间
	fmt.Fprint(line, leftSep, entry.Time.Format(DATETIME_LAYOUT), rightSep)
	// 协程ID
	fmt.Fprint(line, leftSep, goid.Get(), rightSep)
	// 调用模块
	callerPath := entry.Caller.TrimmedPath()
	var packageName string
	if idx := strings.LastIndex(callerPath, "/"); idx > 0 {
		packageName = callerPath[:idx]
	}
	fmt.Fprint(line, leftSep, packageName, rightSep)
	// 功能名/交易ID
	var transId string
	for _, field := range fields {
		if field.Key == HEADER_TRANSACTION_ID {
			transId = field.String
			break
		}
	}
	fmt.Fprint(line, leftSep, transId, rightSep)
	// 流水号
	var reqId string
	for _, field := range fields {
		if field.Key == HEADER_REQUEST_ID {
			reqId = field.String
			break
		}
	}
	fmt.Fprint(line, leftSep, reqId, rightSep)
	// 调用文件
	fmt.Fprint(line, leftSep, callerPath, rightSep)
	// 日志内容
	fmt.Fprint(line, entry.Message)
	// 字段内容
	hasFields := false
	appendLeftBrackets := func() {
		if !hasFields {
			line.WriteString(" {")
			hasFields = true
		}
	}
	for _, field := range fields {
		if field.Key == HEADER_TRANSACTION_ID || field.Key == HEADER_REQUEST_ID {
			continue
		}
		switch field.Type {
		case zapcore.StringType:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%q,", field.Key, field.String)
		case zapcore.Int64Type, zapcore.Int32Type, zapcore.Int16Type,
			zapcore.Int8Type:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%d,", field.Key, field.Integer)
		case zapcore.Float64Type:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%f,", field.Key,
				math.Float64frombits(uint64(field.Integer)))
		case zapcore.Float32Type:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%f,", field.Key,
				math.Float32frombits(uint32(field.Integer)))
		case zapcore.BoolType:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%t,", field.Key, field.Integer == 1)
		case zapcore.ErrorType:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%q,", field.Key, field.Interface)
		default:
			appendLeftBrackets()
			fmt.Fprintf(line, "%q:%v,", field.Key, field.Interface)
		}
	}
	if hasFields {
		// 去掉最后一个逗号
		content := line.Bytes()
		content = content[:len(content)-1]
		line.Reset()
		line.Write(content)
		line.WriteString("}")
	}
	// 换行符
	line.AppendString(e.cfg.LineEnding)
	return
}
