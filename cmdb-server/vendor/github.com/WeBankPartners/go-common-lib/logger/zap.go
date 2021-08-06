package logger

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
	"strings"
	"time"
)

var levelStringList = []string{"debug", "info", "warn", "error"}

type LogConfig struct {
	Name             string
	FilePath         string
	LogLevel         string
	ArchiveMaxSize   int
	ArchiveMaxBackup int
	ArchiveMaxDay    int
	Compress         bool
}

func InitArchiveZapLogger(config LogConfig) *zap.Logger {
	config.LogLevel = strings.ToLower(config.LogLevel)
	var level int
	for i, v := range levelStringList {
		if v == config.LogLevel {
			level = i - 1
			break
		}
	}
	zapLevel := zap.NewAtomicLevel()
	zapLevel.SetLevel(zapcore.Level(level))
	hook := lumberjack.Logger{
		Filename:   config.FilePath,
		MaxSize:    config.ArchiveMaxSize,
		MaxBackups: config.ArchiveMaxBackup,
		MaxAge:     config.ArchiveMaxDay,
		Compress:   config.Compress,
	}
	encoderConfig := zapcore.EncoderConfig{
		TimeKey:       "time",
		LevelKey:      "level",
		NameKey:       "logger",
		CallerKey:     "caller",
		MessageKey:    "msg",
		StacktraceKey: "stacktrace",
		LineEnding:    zapcore.DefaultLineEnding,
		EncodeLevel:   zapcore.LowercaseLevelEncoder,
		EncodeTime: func(t time.Time, enc zapcore.PrimitiveArrayEncoder) {
			enc.AppendString(t.Format("2006-01-02 15:04:05"))
		},
		EncodeDuration: zapcore.SecondsDurationEncoder,
		EncodeCaller:   zapcore.ShortCallerEncoder,
	}
	core := zapcore.NewCore(zapcore.NewJSONEncoder(encoderConfig), zapcore.NewMultiWriteSyncer(zapcore.AddSync(&hook)), zapLevel)
	zapLogger := zap.New(core, zap.AddCaller(), zap.Development())
	zapLogger.Info("Success init " + config.Name + " log !!")
	return zapLogger
}
