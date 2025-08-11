package models

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
	"strings"

	"github.com/WeBankPartners/go-common-lib/cipher"
	"github.com/WeBankPartners/go-common-lib/token"
)

type HttpServerConfig struct {
	Port              string `json:"port"`
	Cross             bool   `json:"cross"`
	ErrorTemplateDir  string `json:"error_template_dir"`
	ErrorDetailReturn bool   `json:"error_detail_return"`
}

type LogConfig struct {
	Level            string `json:"level"`
	LogDir           string `json:"log_dir"`
	AccessLogEnable  bool   `json:"access_log_enable"`
	DbLogEnable      bool   `json:"db_log_enable"`
	ArchiveMaxSize   int    `json:"archive_max_size"`
	ArchiveMaxBackup int    `json:"archive_max_backup"`
	ArchiveMaxDay    int    `json:"archive_max_day"`
	Compress         bool   `json:"compress"`
}

type DatabaseConfig struct {
	Server   string `json:"server"`
	Port     string `json:"port"`
	User     string `json:"user"`
	Password string `json:"password"`
	DataBase string `json:"database"`
	MaxOpen  int    `json:"maxOpen"`
	MaxIdle  int    `json:"maxIdle"`
	Timeout  int    `json:"timeout"`
}

type WecubeConfig struct {
	BaseUrl       string `json:"base_url"`
	JwtSigningKey string `json:"jwt_signing_key"`
	SubSystemCode string `json:"sub_system_code"`
	SubSystemKey  string `json:"sub_system_key"`
	EncryptSeed   string `json:"encrypt_seed"`
}

type AuthConfig struct {
	Enable           bool   `json:"enable"`
	PasswordSeed     string `json:"password_seed"`
	ExpireSec        int64  `json:"expire_sec"`
	FreshTokenExpire int64  `json:"fresh_token_expire"`
}

type MenuApiMapConfig struct {
	Enable string `json:"enable"`
	File   string `json:"file"`
}

type SyncConfig struct {
	Enable       string `json:"enable"`
	Type         string `json:"type"`
	Source       string `json:"source"`
	Target       string `json:"target"`
	NexusAddress string `json:"nexus_address"`
	NexusUser    string `json:"nexus_user"`
	NexusPwd     string `json:"nexus_pwd"`
	NexusRepo    string `json:"nexus_repo"`
	HostIp       string `json:"host_ip"`
	StartId      string `json:"start_id"`
	MasterEnable bool   `json:"-"`
	SlaveEnable  bool   `json:"-"`
}

type GlobalConfig struct {
	IsPluginMode         string                        `json:"is_plugin_mode"`
	DefaultLanguage      string                        `json:"default_language"`
	HttpServer           HttpServerConfig              `json:"http_server"`
	Log                  LogConfig                     `json:"log"`
	Database             DatabaseConfig                `json:"database"`
	RsaKeyPath           string                        `json:"rsa_key_path"`
	Wecube               WecubeConfig                  `json:"wecube"`
	Auth                 AuthConfig                    `json:"auth"`
	MenuApiMap           MenuApiMapConfig              `json:"menu_api_map"`
	Sync                 SyncConfig                    `json:"sync"`
	DefaultReportObjAttr []*DefaultReportObjAttrConfig `json:"default_report_obj_attr"`
	AutoFillWithoutList  string                        `json:"auto_fill_without_list"`
	// default json
}

type DefaultReportObjAttrConfig struct {
	Id        string `json:"id"`
	Title     string `json:"title"`
	Querialbe string `json:"querialbe"`
}

var (
	Config                  *GlobalConfig
	PluginRunningMode       bool
	CoreToken               *token.CoreToken
	MenuApiGlobalList       []*MenuApiMapObj
	ProcessFetchTabs        string
	AutoFillWithoutListFlag bool
)

func InitConfig(configFile string) (errMessage string) {
	if configFile == "" {
		errMessage = "config file empty,use -c to specify configuration file"
		return
	}
	_, err := os.Stat(configFile)
	if os.IsExist(err) {
		errMessage = "config file not found," + err.Error()
		return
	}
	b, err := ioutil.ReadFile(configFile)
	if err != nil {
		errMessage = "read config file fail," + err.Error()
		return
	}
	var c GlobalConfig
	err = json.Unmarshal(b, &c)
	if err != nil {
		errMessage = "parse file to json fail," + err.Error()
		return
	}
	c.Database.Password, err = cipher.DecryptRsa(c.Database.Password, c.RsaKeyPath)
	if err != nil {
		errMessage = "init database password fail,%s " + err.Error()
		return
	}
	syncEnable := strings.ToLower(c.Sync.Enable)
	if syncEnable == "yes" || syncEnable == "y" || syncEnable == "true" {
		syncType := strings.ToLower(c.Sync.Type)
		if syncType == "master" {
			c.Sync.MasterEnable = true
		} else if syncType == "slave" {
			c.Sync.SlaveEnable = true
		}
	}
	Config = &c
	c.IsPluginMode = strings.ToLower(c.IsPluginMode)
	if c.IsPluginMode == "yes" || c.IsPluginMode == "y" || c.IsPluginMode == "true" {
		tmpCoreToken := token.CoreToken{}
		PluginRunningMode = true
		tmpCoreToken.BaseUrl = Config.Wecube.BaseUrl
		tmpCoreToken.JwtSigningKey = Config.Wecube.JwtSigningKey
		tmpCoreToken.SubSystemCode = Config.Wecube.SubSystemCode
		tmpCoreToken.SubSystemKey = Config.Wecube.SubSystemKey
		tmpCoreToken.InitCoreToken()
		CoreToken = &tmpCoreToken
		ProcessFetchTabs = os.Getenv("WECMDB_PROCESS_TAGS")
	} else {
		CoreToken = &token.CoreToken{BaseUrl: ""}
		PluginRunningMode = false
	}
	c.AutoFillWithoutList = strings.ToLower(c.AutoFillWithoutList)
	if c.AutoFillWithoutList == "yes" || c.AutoFillWithoutList == "y" || c.AutoFillWithoutList == "true" {
		AutoFillWithoutListFlag = true
	} else {
		AutoFillWithoutListFlag = false
	}
	if c.MenuApiMap.Enable == "true" || strings.TrimSpace(c.MenuApiMap.Enable) == "" || strings.ToUpper(c.MenuApiMap.Enable) == "Y" {
		maBytes, err := ioutil.ReadFile(Config.MenuApiMap.File)
		if err != nil {
			errMessage = "read menu api map file fail," + err.Error()
			return
		}
		err = json.Unmarshal(maBytes, &MenuApiGlobalList)
		if err != nil {
			errMessage = "json unmarshal menu api map content fail," + err.Error()
			return
		}
		// 后台 url 兜底,必须以 /开头
		for _, menuApi := range MenuApiGlobalList {
			for _, item := range menuApi.Urls {
				if !strings.HasPrefix(item.Url, "/") {
					item.Url = "/" + item.Url
				}
			}
		}
		log.Println("enable menu api permission success")
	} else {
		log.Println("disable menu api permission success")
	}
	return
}
