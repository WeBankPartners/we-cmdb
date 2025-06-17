package middleware

import (
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"github.com/WeBankPartners/go-common-lib/token"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

var (
	whitePathMap = map[string]string{
		"/wecmdb/entities/${ciType}/query":              "POST",
		"/wecmdb/data-model":                            "GET",
		"/wecmdb/api/v1/ci-data/sensitive-attr/query":   "POST",
		"/wecmdb/api/v1/ci-data/rollback/query/${guid}": "GET",
		"/wecmdb/api/v1/sync/query":                     "GET",
	}
	ApiMenuMap = make(map[string][]string) // key -> apiCode  value -> menuList
)

func GetRequestUser(c *gin.Context) string {
	return c.GetString("user")
}

func GetRequestRoles(c *gin.Context) []string {
	return c.GetStringSlice("roles")
}

func AuthToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := authRequest(c)
		if err != nil {
			ReturnTokenValidateError(c, err)
			c.Abort()
		} else {
			if !models.PluginRunningMode {
				c.Next()
				return
			}
			// 白名单URL直接放行
			for path, method := range whitePathMap {
				if strings.ToLower(method) != strings.ToLower(c.Request.Method) {
					continue
				}
				re := regexp.MustCompile(db.BuildRegexPattern(path))
				if re.MatchString(c.Request.URL.Path) {
					c.Next()
					return
				}
			}

			if _, ok := whitePathMap[c.Request.URL.Path]; ok {
				c.Next()
				return
			}
			// 子系统直接放行
			if strings.Contains(strings.Join(GetRequestRoles(c), ","), "SUB_SYSTEM") {
				c.Next()
				return
			}
			if models.Config.MenuApiMap.Enable == "true" || strings.TrimSpace(models.Config.MenuApiMap.Enable) == "" || strings.ToUpper(models.Config.MenuApiMap.Enable) == "Y" {
				legal := false
				if allowMenuList, ok := ApiMenuMap[c.GetString(models.ContextApiCode)]; ok {
					legal = compareStringList(GetRequestRoles(c), allowMenuList)
				} else {
					legal = db.ValidateMenuApi(GetRequestRoles(c), c.Request.URL.Path, c.Request.Method)
				}
				if legal {
					c.Next()
				} else {
					ReturnApiPermissionError(c)
					c.Abort()
				}
			} else {
				c.Next()
			}
		}
	}
}

func authRequest(c *gin.Context) error {
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		return fmt.Errorf("Can not find Request Header Authorization ")
	}
	authToken, err := token.DecodeJwtToken(authHeader, models.Config.Wecube.JwtSigningKey)
	if err != nil {
		return err
	}
	if authToken.User == "" {
		return fmt.Errorf("Token content is illegal,main message is empty ")
	}
	c.Set("user", authToken.User)
	c.Set("roles", authToken.Roles)
	return nil
}

func AuthCoreRequestToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := authCoreRequest(c)
		if err != nil {
			log.Error(nil, log.LOGGER_APP, "Validate core token fail", zap.Error(err))
			c.JSON(http.StatusOK, models.EntityResponse{Status: "ERROR", Message: "Core token validate fail "})
			c.Abort()
		} else {
			c.Next()
		}
	}
}

func InitApiMenuMap(apiMenuCodeMap map[string]string) {
	var exist bool
	matchUrlMap := make(map[string]int)
	for k, code := range apiMenuCodeMap {
		exist = false
		re := regexp.MustCompile("^" + regexp.MustCompile(":[\\w\\-]+").ReplaceAllString(strings.ToLower(k), "([\\w\\.\\-\\$\\{\\}:\\[\\]]+)") + "$")
		for _, menuApi := range models.MenuApiGlobalList {
			for _, item := range menuApi.Urls {
				key := strings.ToLower(item.Method + "_" + item.Url)
				if re.MatchString(key) {
					exist = true
					if existList, existFlag := ApiMenuMap[code]; existFlag {
						ApiMenuMap[code] = append(existList, menuApi.Menu)
					} else {
						ApiMenuMap[code] = []string{menuApi.Menu}
					}
					matchUrlMap[item.Method+"_"+item.Url] = 1
				}
			}
		}
		if !exist {
			log.Info(nil, log.LOGGER_APP, "InitApiMenuMap menu-api-json lack url", zap.String("path", k))
		}
	}
	for _, menuApi := range models.MenuApiGlobalList {
		for _, item := range menuApi.Urls {
			if _, ok := matchUrlMap[item.Method+"_"+item.Url]; !ok {
				log.Info(nil, log.LOGGER_APP, "InitApiMenuMap can not match menuUrl", zap.String("menu", menuApi.Menu), zap.String("method", item.Method), zap.String("url", item.Url))
			}
		}
	}
	for k, v := range ApiMenuMap {
		if len(v) > 1 {
			ApiMenuMap[k] = models.DistinctStringList(v, []string{})
		}
	}
	log.Debug(nil, log.LOGGER_APP, "InitApiMenuMap done", log.JsonObj("ApiMenuMap", ApiMenuMap))
}

func AuthCorePluginToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := authCoreRequest(c)
		if err != nil {
			log.Error(nil, log.LOGGER_APP, "Validate core token fail", zap.Error(err))
			c.JSON(http.StatusOK, pluginInterfaceResultObj{ResultCode: "1", ResultMessage: "Token authority validate fail", Results: pluginInterfaceResultOutput{Outputs: []string{}}})
			c.Abort()
		} else {
			c.Next()
		}
	}
}

type pluginInterfaceResultObj struct {
	ResultCode    string                      `json:"resultCode"`
	ResultMessage string                      `json:"resultMessage"`
	Results       pluginInterfaceResultOutput `json:"results"`
}

type pluginInterfaceResultOutput struct {
	Outputs []string `json:"outputs"`
}

func authCoreRequest(c *gin.Context) error {
	if !models.Config.Auth.Enable {
		return nil
	}
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		return fmt.Errorf("Can not find Request Header Authorization ")
	}
	authToken, err := token.DecodeJwtToken(authHeader, models.Config.Wecube.JwtSigningKey)
	if err != nil {
		return err
	}
	if authToken.User == "" {
		return fmt.Errorf("Token content is illegal,main message is empty ")
	}
	c.Set("user", authToken.User)
	c.Set("roles", authToken.Roles)
	return nil
}

func compareStringList(from, target []string) bool {
	match := false
	for _, f := range from {
		for _, t := range target {
			if f == t {
				match = true
				break
			}
		}
		if match {
			break
		}
	}
	return match
}
