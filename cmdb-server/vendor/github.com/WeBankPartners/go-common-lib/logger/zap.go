package logger

import (
	"fmt"
	"strings"
	"time"

	"github.com/petermattis/goid"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
)

var levelStringList = []string{"debug", "info", "warn", "error", "fatal"}

type LogConfig struct {
	Name             string
	FilePath         string
	LogLevel         string
	ArchiveMaxSize   int
	ArchiveMaxBackup int
	ArchiveMaxDay    int
	Compress         bool
	FormatJson       bool
}

func InitArchiveZapLogger(config LogConfig) (zapLogger *zap.Logger) {
	config.LogLevel = strings.ToLower(config.LogLevel)
	var level int
	for i, v := range levelStringList {
		if v == config.LogLevel {
			level = i - 1
			break
		}
	}
	if config.LogLevel == "fatal" {
		level = 5
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
		EncodeLevel:   zapcore.CapitalLevelEncoder,
		EncodeTime: func(t time.Time, enc zapcore.PrimitiveArrayEncoder) {
			enc.AppendString(t.Format("2006-01-02 15:04:05.000"))
		},
		EncodeDuration: zapcore.SecondsDurationEncoder,
		EncodeCaller:   zapcore.ShortCallerEncoder,
	}
	if !config.FormatJson {
		encoderConfig.EncodeCaller = func(caller zapcore.EntryCaller, enc zapcore.PrimitiveArrayEncoder) {
			trimPath := caller.TrimmedPath()
			if len(trimPath) > 40 {
				trimPath = trimPath[len(trimPath)-40:]
			}
			enc.AppendString("[" + fmt.Sprintf("goid-%d", goid.Get()) + "]" + "[" + trimPath + "]")
		}
		zCore := zapcore.NewCore(zapcore.NewConsoleEncoder(encoderConfig), zapcore.NewMultiWriteSyncer(zapcore.AddSync(&hook)), zapLevel)
		zapLogger = zap.New(zCore, zap.AddCaller(), zap.Development(), zap.AddCallerSkip(1))
	} else {
		zCore := zapcore.NewCore(zapcore.NewJSONEncoder(encoderConfig), zapcore.NewMultiWriteSyncer(zapcore.AddSync(&hook)), zapLevel)
		zapLogger = zap.New(zCore, zap.AddCaller(), zap.Development(), zap.AddCallerSkip(1))
	}
	zapLogger.Info("Success init " + config.Name + " log !!")
	return zapLogger
}
