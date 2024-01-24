package log

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/logger"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"go.uber.org/zap"
	"strings"
)

var (
	Logger         *zap.Logger
	AccessLogger   *zap.Logger
	DatabaseLogger *zap.Logger
)

func InitLogger() {
	baseLogDir := models.Config.Log.LogDir
	if strings.HasSuffix(models.Config.Log.LogDir, "/") {
		baseLogDir = baseLogDir[:len(baseLogDir)-1]
	}
	Logger = logger.InitArchiveZapLogger(logger.LogConfig{
		Name:             "server",
		FilePath:         fmt.Sprintf("%s/wecmdb.log", baseLogDir),
		LogLevel:         models.Config.Log.Level,
		ArchiveMaxSize:   models.Config.Log.ArchiveMaxSize,
		ArchiveMaxBackup: models.Config.Log.ArchiveMaxBackup,
		ArchiveMaxDay:    models.Config.Log.ArchiveMaxDay,
		Compress:         models.Config.Log.Compress,
	})
	if models.Config.Log.AccessLogEnable {
		AccessLogger = logger.InitArchiveZapLogger(logger.LogConfig{
			Name:             "access",
			FilePath:         fmt.Sprintf("%s/wecmdb-access.log", baseLogDir),
			LogLevel:         models.Config.Log.Level,
			ArchiveMaxSize:   models.Config.Log.ArchiveMaxSize,
			ArchiveMaxBackup: models.Config.Log.ArchiveMaxBackup,
			ArchiveMaxDay:    models.Config.Log.ArchiveMaxDay,
			Compress:         models.Config.Log.Compress,
		})
	}
	if models.Config.Log.DbLogEnable {
		DatabaseLogger = logger.InitArchiveZapLogger(logger.LogConfig{
			Name:             "database",
			FilePath:         fmt.Sprintf("%s/wecmdb-db.log", baseLogDir),
			LogLevel:         models.Config.Log.Level,
			ArchiveMaxSize:   models.Config.Log.ArchiveMaxSize,
			ArchiveMaxBackup: models.Config.Log.ArchiveMaxBackup,
			ArchiveMaxDay:    models.Config.Log.ArchiveMaxDay,
			Compress:         models.Config.Log.Compress,
		})
	}
}

func Error(err error) zap.Field {
	return zap.Error(err)
}

func String(k, v string) zap.Field {
	return zap.String(k, v)
}

func Int(k string, v int) zap.Field {
	return zap.Int(k, v)
}

func Int64(k string, v int64) zap.Field {
	return zap.Int64(k, v)
}

func Float64(k string, v float64) zap.Field {
	return zap.Float64(k, v)
}

func JsonObj(k string, v interface{}) zap.Field {
	b, err := json.Marshal(v)
	if err == nil {
		return zap.String(k, string(b))
	} else {
		return zap.Error(err)
	}
}

func StringList(k string, v []string) zap.Field {
	return zap.Strings(k, v)
}

func Bool(k string, v bool) zap.Field {
	return zap.Bool(k, v)
}
