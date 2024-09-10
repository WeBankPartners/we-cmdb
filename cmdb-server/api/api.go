package api

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/v1/basekey"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/v1/ci"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/v1/permission"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/v1/report"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/v1/view"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/gin-gonic/gin"
)

type handlerFuncObj struct {
	HandlerFunc  func(c *gin.Context)
	Method       string
	Url          string
	LogOperation bool
	PreHandle    func(c *gin.Context)
}

var (
	httpHandlerFuncList []*handlerFuncObj
)

func init() {
	// baseKey
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/base-key/categories", Method: "GET", HandlerFunc: basekey.CategoriesQuery},
		&handlerFuncObj{Url: "/base-key/categories/create", Method: "POST", HandlerFunc: basekey.CategoriesCreate},
		&handlerFuncObj{Url: "/base-key/categories/:catId", Method: "GET", HandlerFunc: basekey.GetCodesByCat},
		&handlerFuncObj{Url: "/base-key/codes/query", Method: "POST", HandlerFunc: basekey.CodesQuery},
		&handlerFuncObj{Url: "/base-key/codes", Method: "POST", HandlerFunc: basekey.CodesCreate, LogOperation: true},
		&handlerFuncObj{Url: "/base-key/codes/:codeId", Method: "PUT", HandlerFunc: basekey.CodesUpdate, LogOperation: true},
		&handlerFuncObj{Url: "/base-key/codes", Method: "DELETE", HandlerFunc: basekey.CodesDelete, LogOperation: true},
		&handlerFuncObj{Url: "/base-key/codes/swap-position", Method: "POST", HandlerFunc: basekey.CodesPositionSwap, LogOperation: true},
		&handlerFuncObj{Url: "/referenceEnumCodes/:ciAttr/query", Method: "POST", HandlerFunc: basekey.ReferenceEnumCodes, LogOperation: true},
	)
	// ciTypes
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/ci-types", Method: "GET", HandlerFunc: ci.CiTypesQuery},
		&handlerFuncObj{Url: "/ci-types", Method: "POST", HandlerFunc: ci.CiTypesCreate, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types/:ciType", Method: "PUT", HandlerFunc: ci.CiTypesUpdate, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types/:ciType", Method: "DELETE", HandlerFunc: ci.CiTypesDelete, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types/apply/:ciType", Method: "POST", HandlerFunc: ci.CiTypesApply, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types/rollback/:ciType", Method: "POST", HandlerFunc: ci.CiTypesRollback, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types/references/:ciType", Method: "GET", HandlerFunc: ci.CiTypesReferences},
		&handlerFuncObj{Url: "/ci-template", Method: "GET", HandlerFunc: ci.GetCiTemplate},
		&handlerFuncObj{Url: "/state-machine", Method: "GET", HandlerFunc: ci.GetStateMachine},
		&handlerFuncObj{Url: "/state-transition/:ciType", Method: "GET", HandlerFunc: ci.GetStateTransition},
	)
	// ciAttributes
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes", Method: "GET", HandlerFunc: ci.AttrQuery},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes", Method: "POST", HandlerFunc: ci.AttrCreate, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/:ciAttr", Method: "PUT", HandlerFunc: ci.AttrUpdate, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/:ciAttr", Method: "DELETE", HandlerFunc: ci.AttrDelete, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/apply/:ciAttr", Method: "POST", HandlerFunc: ci.AttrApply, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/rollback/:ciAttr", Method: "POST", HandlerFunc: ci.AttrRollback, LogOperation: true},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/swap-position", Method: "POST", HandlerFunc: ci.AttrPositionSwap, LogOperation: true},
	)
	// ciData
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/ci-data/query/:ciType", Method: "POST", HandlerFunc: ci.DataQuery},
		&handlerFuncObj{Url: "/ci-data/do/:operation/:ciType", Method: "POST", HandlerFunc: ci.DataOperation, LogOperation: true},
		&handlerFuncObj{Url: "/ci-data/reference-data/query/:ciAttr", Method: "POST", HandlerFunc: ci.DataReferenceQuery},
		&handlerFuncObj{Url: "/ci-data/rollback/query/:guid", Method: "GET", HandlerFunc: ci.DataRollbackList},
		&handlerFuncObj{Url: "/ci-data/query-password/:ciType/:guid/:field", Method: "GET", HandlerFunc: ci.DataPasswordQuery},
		&handlerFuncObj{Url: "/ci-data/action-query/:operation/:ciType/:guid", Method: "GET", HandlerFunc: ci.GetActionQueryData},
		&handlerFuncObj{Url: "/ci-data/import/:ciType", Method: "POST", HandlerFunc: ci.DataImport},
		&handlerFuncObj{Url: "/ci-data/simple/import/:ciType", Method: "POST", HandlerFunc: ci.SimpleCiDataImport},
		&handlerFuncObj{Url: "/ci-data/password/encrypt-key", Method: "GET", HandlerFunc: ci.GetCiPasswordAESKey},
	)
	// log
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/log/query", Method: "POST", HandlerFunc: ci.QueryOperationLog},
		&handlerFuncObj{Url: "/log/operation", Method: "GET", HandlerFunc: ci.GetAllLogOperation},
	)
	// permission
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/permissions/ci/:roleId", Method: "GET", HandlerFunc: permission.GetRoleCiPermission},
		&handlerFuncObj{Url: "/permissions/ci/:roleId", Method: "POST", HandlerFunc: permission.UpdateRoleCiPermission, LogOperation: true},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "GET", HandlerFunc: permission.GetRoleCiTypeCondition},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "POST", HandlerFunc: permission.AddRoleCiTypeCondition, LogOperation: true},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "PUT", HandlerFunc: permission.EditRoleCiTypeCondition, LogOperation: true},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "DELETE", HandlerFunc: permission.DeleteRoleCiTypeCondition, LogOperation: true},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "GET", HandlerFunc: permission.GetRoleCiTypeList},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "POST", HandlerFunc: permission.AddRoleCiTypeList, LogOperation: true},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "PUT", HandlerFunc: permission.EditRoleCiTypeList, LogOperation: true},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "DELETE", HandlerFunc: permission.DeleteRoleCiTypeList, LogOperation: true},
		&handlerFuncObj{Url: "/menus/list", Method: "GET", HandlerFunc: permission.GetMenuList},
		&handlerFuncObj{Url: "/roles/menus", Method: "GET", HandlerFunc: permission.GetRoleMenu},
		&handlerFuncObj{Url: "/roles/menus", Method: "POST", HandlerFunc: permission.UpdateRoleMenu, LogOperation: true},
		&handlerFuncObj{Url: "/roles", Method: "GET", HandlerFunc: permission.GetRoleList},
		&handlerFuncObj{Url: "/roles", Method: "POST", HandlerFunc: permission.RoleCreate, LogOperation: true},
		&handlerFuncObj{Url: "/roles", Method: "PUT", HandlerFunc: permission.RoleUpdate, LogOperation: true},
		&handlerFuncObj{Url: "/roles", Method: "DELETE", HandlerFunc: permission.RoleDelete, LogOperation: true},
		&handlerFuncObj{Url: "/roles/user", Method: "GET", HandlerFunc: permission.GetRoleUser},
		&handlerFuncObj{Url: "/roles/user", Method: "POST", HandlerFunc: permission.UpdateRoleUser, LogOperation: true},
		&handlerFuncObj{Url: "/user", Method: "GET", HandlerFunc: permission.GetUserList},
		&handlerFuncObj{Url: "/user", Method: "POST", HandlerFunc: permission.UserCreate, LogOperation: true},
		&handlerFuncObj{Url: "/user", Method: "PUT", HandlerFunc: permission.UserUpdate, LogOperation: true},
		&handlerFuncObj{Url: "/user", Method: "DELETE", HandlerFunc: permission.UserDelete, LogOperation: true},
		&handlerFuncObj{Url: "/user/menus", Method: "GET", HandlerFunc: permission.GetUserMenu},
		&handlerFuncObj{Url: "/user/roles", Method: "GET", HandlerFunc: permission.GetUserRole},
		&handlerFuncObj{Url: "/user/password/reset", Method: "POST", HandlerFunc: permission.UserPasswordReset, LogOperation: true},
		&handlerFuncObj{Url: "/user/password/update", Method: "POST", HandlerFunc: permission.UserPasswordUpdate, LogOperation: true},
	)

	// view
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/views", Method: "GET", HandlerFunc: view.GetViewList},
		&handlerFuncObj{Url: "/view/:viewId", Method: "GET", HandlerFunc: view.GetView},
		&handlerFuncObj{Url: "/view-data", Method: "POST", HandlerFunc: view.GetViewData},
		&handlerFuncObj{Url: "/view-graph-data", Method: "POST", HandlerFunc: view.GetGraphViewData},
		&handlerFuncObj{Url: "/view-confirm", Method: "POST", HandlerFunc: view.ConfirmView},
	)

	// report
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/reports", Method: "GET", HandlerFunc: report.QueryReport},
		&handlerFuncObj{Url: "/reports", Method: "POST", HandlerFunc: report.CreateReport},
		&handlerFuncObj{Url: "/reports", Method: "PUT", HandlerFunc: report.UpdateReport},
		&handlerFuncObj{Url: "/report-message/:reportId", Method: "GET", HandlerFunc: report.GetReport},
		&handlerFuncObj{Url: "/report/:reportId", Method: "DELETE", HandlerFunc: report.DeleteReport},
		&handlerFuncObj{Url: "/report-struct/:reportId", Method: "GET", HandlerFunc: report.QueryReportStruct},
		&handlerFuncObj{Url: "/report-flat-struct/:reportId", Method: "GET", HandlerFunc: report.QueryReportFlatStruct},
		&handlerFuncObj{Url: "/report-data/:reportId", Method: "POST", HandlerFunc: report.QueryReportData},
		&handlerFuncObj{Url: "/report-objects", Method: "POST", HandlerFunc: report.ModifyReportObject},
		&handlerFuncObj{Url: "/report-objects/query", Method: "POST", HandlerFunc: report.QueryReportObject},
		&handlerFuncObj{Url: "/report-objects-attr/query", Method: "POST", HandlerFunc: report.QueryReportAttr},
		&handlerFuncObj{Url: "/report/export", Method: "POST", HandlerFunc: report.ExportReportData},
	)
}

func InitHttpServer() {
	urlPrefix := models.UrlPrefix
	r := gin.New()
	if !models.PluginRunningMode {
		// reflect ui resource
		r.LoadHTMLGlob("public/*.html")
		r.Static(fmt.Sprintf("%s/js", urlPrefix), fmt.Sprintf("public%s/js", urlPrefix))
		r.Static(fmt.Sprintf("%s/css", urlPrefix), fmt.Sprintf("public%s/css", urlPrefix))
		r.Static(fmt.Sprintf("%s/img", urlPrefix), fmt.Sprintf("public%s/img", urlPrefix))
		//r.Static(fmt.Sprintf("%s/fonts", urlPrefix), fmt.Sprintf("public%s/fonts", urlPrefix))
		r.GET(fmt.Sprintf("%s/", urlPrefix), func(c *gin.Context) {
			c.HTML(http.StatusOK, "index.html", gin.H{})
		})
		// allow cross request
		if models.Config.HttpServer.Cross {
			crossHandler(r)
		}
	}
	r.Static(fmt.Sprintf("%s/fonts", urlPrefix), fmt.Sprintf("public%s/fonts", urlPrefix))
	// access log
	if models.Config.Log.AccessLogEnable {
		r.Use(httpLogHandle())
	}
	// const handler func
	r.POST(urlPrefix+"/api/v1/login", permission.Login)
	// register handler func with auth
	authRouter := r.Group(urlPrefix+"/api/v1", middleware.AuthToken())
	authRouter.GET("/refresh-token", permission.RefreshToken)
	for _, funcObj := range httpHandlerFuncList {
		handleFuncList := []gin.HandlerFunc{funcObj.HandlerFunc}
		if funcObj.PreHandle != nil {
			log.Logger.Info("Append pre handle", log.String("url", funcObj.Url))
			handleFuncList = append([]gin.HandlerFunc{funcObj.PreHandle}, funcObj.HandlerFunc)
		}
		if funcObj.LogOperation {
			handleFuncList = append(handleFuncList, ci.HandleOperationLog)
		}
		switch funcObj.Method {
		case "GET":
			authRouter.GET(funcObj.Url, handleFuncList...)
			break
		case "POST":
			authRouter.POST(funcObj.Url, handleFuncList...)
			break
		case "PUT":
			authRouter.PUT(funcObj.Url, handleFuncList...)
			break
		case "DELETE":
			authRouter.DELETE(funcObj.Url, handleFuncList...)
			break
		}
	}
	r.POST(urlPrefix+"/entities/:ciType/query", middleware.AuthToken(), ci.HandleCiModelRequest)
	r.POST(urlPrefix+"/entities/:ciType/create", middleware.AuthCoreRequestToken(), ci.HandleCiModelRequest, ci.HandleOperationLog)
	r.POST(urlPrefix+"/entities/:ciType/update", middleware.AuthCoreRequestToken(), ci.HandleCiModelRequest, ci.HandleOperationLog)
	r.POST(urlPrefix+"/entities/:ciType/delete", middleware.AuthCoreRequestToken(), ci.HandleCiModelRequest, ci.HandleOperationLog)
	r.GET(urlPrefix+"/data-model", middleware.AuthToken(), ci.GetAllDataModel)
	r.POST(urlPrefix+"/plugin/ci-data/operation", middleware.AuthCorePluginToken(), ci.PluginCiDataOperationHandle, ci.HandleOperationLog)
	r.POST(urlPrefix+"/plugin/ci-data/attr-value", middleware.AuthCorePluginToken(), ci.PluginCiDataAttrValueHandle, ci.HandleOperationLog)
	r.POST(urlPrefix+"/plugin/view/confirm", middleware.AuthCorePluginToken(), ci.PluginViewConfirmHandle, ci.HandleOperationLog)
	r.Run(":" + models.Config.HttpServer.Port)
}

func crossHandler(r *gin.Engine) {
	r.Use(func(c *gin.Context) {
		if c.GetHeader("Origin") != "" {
			c.Header("Access-Control-Allow-Origin", c.GetHeader("Origin"))
		}
	})
}

func httpLogHandle() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		bodyBytes, _ := ioutil.ReadAll(c.Request.Body)
		c.Request.Body.Close()
		c.Request.Body = ioutil.NopCloser(bytes.NewReader(bodyBytes))
		c.Set("requestBody", string(bodyBytes))
		c.Next()
		log.AccessLogger.Info("request", log.String("url", c.Request.RequestURI), log.String("method", c.Request.Method), log.Int("code", c.Writer.Status()), log.String("operator", c.GetString("user")), log.String("ip", middleware.GetRemoteIp(c)), log.Float64("cost_ms", time.Now().Sub(start).Seconds()*1000), log.String("body", c.GetString("requestBody")))
	}
}
