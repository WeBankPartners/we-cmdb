package logger

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
)

// 日志对象参数
type LoggerParam struct {
	// 以下为 lumberjack.Logger 参数
	Filename   string // 日志文件名
	MaxSize    int    // 日志文件最大大小，单位：M
	MaxAge     int    // 日志文件最长保存时间，单位：天
	MaxBackups int    // 日志文件保留个数
	LocalTime  bool   // 是否使用本地时间
	Compress   bool   // 是否压缩日志文件

	// 日志级别，可选值 debug|info|warn|error|dpanic|panic|fatal，大小写不敏感
	Level string
	// 调用者深度，默认为 0，表示只记录调用者自己，如果设置为 1，则记录调用者和被调用者
	AddCallerSkip int
}

// 创建日志对象
func NewLogger(param *LoggerParam) (logger *zap.Logger, err error) {
	encoder := getEncoder()
	writer := getWriter(param)
	level, err := zapcore.ParseLevel(param.Level)
	if err != nil {
		return
	}
	// core := zapcore.NewCore(encoder, writer, zapcore.DebugLevel)
	core := zapcore.NewCore(encoder, writer, level)
	// logger, _ = zap.NewDevelopment()
	logger = zap.New(core, zap.AddCaller(),
		zap.AddCallerSkip(param.AddCallerSkip), zap.Development())
	return
}

// 获取日志编码器
func getEncoder() zapcore.Encoder {
	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.TimeKey = "time"
	// encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encoderConfig.EncodeTime = zapcore.TimeEncoderOfLayout(DATETIME_LAYOUT)
	encoderConfig.EncodeLevel = zapcore.CapitalLevelEncoder
	// 输出格式：
	// {"level":"INFO","time":"2025-01-08 19:17:20.722",
	//"caller":"log/logger_test.go:27","msg":"Test log sugar"}
	// return zapcore.NewJSONEncoder(encoderConfig)

	// 输出格式：
	// 2025-01-08 19:20:14.330	INFO	log/logger_test.go:26	Test log
	// return zapcore.NewConsoleEncoder(encoderConfig)

	return newCustomEncoder(&encoderConfig)
}

// 获取日志写入器
func getWriter(param *LoggerParam) zapcore.WriteSyncer {
	l := &lumberjack.Logger{
		Filename:   param.Filename,
		MaxSize:    param.MaxSize,
		MaxBackups: param.MaxBackups,
		MaxAge:     param.MaxAge,
		LocalTime:  param.LocalTime,
		Compress:   param.Compress,
	}
	return zapcore.AddSync(l)
}
