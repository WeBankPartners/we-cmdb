package models

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"strings"

	"github.com/WeBankPartners/go-common-lib/cipher"
	"github.com/WeBankPartners/go-common-lib/token"
)

type HttpServerConfig struct {
	Port  string `json:"port"`
	Cross bool   `json:"cross"`
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
	Enable bool   `json:"enable"`
	File   string `json:"file"`
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
	DefaultReportObjAttr []*DefaultReportObjAttrConfig `json:"default_report_obj_attr"`
	// default json
}

type DefaultReportObjAttrConfig struct {
	Id        string `json:"id"`
	Title     string `json:"title"`
	Querialbe string `json:"querialbe"`
}

var (
	Config            *GlobalConfig
	PluginRunningMode bool
	CoreToken         *token.CoreToken
	MenuApiGlobalList []*MenuApiMapObj
	ProcessFetchTabs  string
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
	if Config.MenuApiMap.Enable {
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
	}
	return
}
