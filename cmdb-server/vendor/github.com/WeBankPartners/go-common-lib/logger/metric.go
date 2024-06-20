package logger

import (
	"fmt"
	"go.uber.org/zap"
	"go.uber.org/zap/buffer"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
	"strings"
)

const (
	LogTimeFormat = "2006-01-02 15:04:05.000"
)

func init() {
	err := zap.RegisterEncoder("metric-encoder", func(cfg zapcore.EncoderConfig) (zapcore.Encoder, error) {
		pce := metricEncoder{
			EncoderConfig: &cfg,
			Encoder:       zapcore.NewConsoleEncoder(cfg),
		}
		return &pce, nil
	})
	if err != nil {
		fmt.Printf("register zap log encoder fail,%s \n", err.Error())
	}
}

func NewMetricEncoder(cfg zapcore.EncoderConfig) zapcore.Encoder {
	return &metricEncoder{EncoderConfig: &cfg, Encoder: zapcore.NewConsoleEncoder(cfg)}
}

type metricEncoder struct {
	*zapcore.EncoderConfig
	zapcore.Encoder
}

func (te *metricEncoder) Clone() zapcore.Encoder {
	return &metricEncoder{
		EncoderConfig: te.EncoderConfig,
		Encoder:       te.Encoder.Clone(),
	}
}

func (te *metricEncoder) EncodeEntry(ent zapcore.Entry, fields []zapcore.Field) (*buffer.Buffer, error) {
	line, err := te.Encoder.EncodeEntry(ent, nil)
	if err != nil {
		return line, err
	}
	line.Reset()
	fmt.Fprint(line, "[", ent.Level.CapitalString(), "]")
	fmt.Fprint(line, "[", ent.Time.Format(LogTimeFormat), "]")
	for _, field := range fields {
		fmt.Fprint(line, "[", field.String, "]")
	}
	line.AppendString(zapcore.DefaultLineEnding)
	return line, nil
}

func InitMetricZapLogger(config LogConfig) (zapLogger *zap.Logger) {
	config.LogLevel = strings.ToLower(config.LogLevel)
	zapLevel := zap.NewAtomicLevel()
	zapLevel.SetLevel(zapcore.Level(0))
	hook := lumberjack.Logger{
		Filename:   config.FilePath,
		MaxSize:    config.ArchiveMaxSize,
		MaxBackups: config.ArchiveMaxBackup,
		MaxAge:     config.ArchiveMaxDay,
		Compress:   config.Compress,
	}
	encoderConfig := zapcore.EncoderConfig{
		TimeKey:        "time",
		LevelKey:       "level",
		NameKey:        "logger",
		CallerKey:      "caller",
		MessageKey:     "msg",
		StacktraceKey:  "stacktrace",
		LineEnding:     zapcore.DefaultLineEnding,
		EncodeLevel:    zapcore.CapitalLevelEncoder,
		EncodeTime:     zapcore.TimeEncoderOfLayout(LogTimeFormat),
		EncodeDuration: zapcore.SecondsDurationEncoder,
		EncodeCaller:   zapcore.ShortCallerEncoder,
	}
	zCore := zapcore.NewCore(NewMetricEncoder(encoderConfig), zapcore.NewMultiWriteSyncer(zapcore.AddSync(&hook)), zapLevel)
	zapLogger = zap.New(zCore, zap.AddCaller(), zap.Development())
	return zapLogger
}
