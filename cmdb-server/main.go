package main

import (
	"flag"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/v1/ci"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
)

// @title Wecmdb Server New
// @version 1.0
// @description 配置管理系统后台服务
func main() {
	configFile := flag.String("c", "conf/default.json", "config file path")
	flag.Parse()
	if initConfigMessage := models.InitConfig(*configFile); initConfigMessage != "" {
		fmt.Printf("Init config file error,%s \n", initConfigMessage)
		return
	}
	if err := log.InitLogger(); err != nil {
		fmt.Printf("Server  init loggers failed, err: %v\n", err)
		return
	}
	defer log.SyncLoggers()
	if initDbError := db.InitDatabase(); initDbError != nil {
		return
	}
	//start cron job
	go ci.StartConsumeOperationLog()
	go db.StartSyncImageFile()
	go db.StartConsumeAffectGuidMap()
	go db.StartConsumeAffectCiType()
	go db.StartConsumeUniquePathHandle()
	//start http
	api.InitHttpServer()
}
