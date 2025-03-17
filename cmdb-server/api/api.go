package api

import (
	"bytes"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/exterror"
	"go.uber.org/zap"
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
	ApiCode      string
}

var (
	httpHandlerFuncList []*handlerFuncObj
	apiCodeMap          = make(map[string]string)
)

func init() {
	// baseKey
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/base-key/categories", Method: "GET", HandlerFunc: basekey.CategoriesQuery, ApiCode: "CategoriesQuery"},
		&handlerFuncObj{Url: "/base-key/categories/create", Method: "POST", HandlerFunc: basekey.CategoriesCreate, ApiCode: "CategoriesCreate"},
		&handlerFuncObj{Url: "/base-key/categories/:catId", Method: "GET", HandlerFunc: basekey.GetCodesByCat, ApiCode: "GetCodesByCat"},
		&handlerFuncObj{Url: "/base-key/codes/query", Method: "POST", HandlerFunc: basekey.CodesQuery, ApiCode: "CodesQuery"},
		&handlerFuncObj{Url: "/base-key/codes", Method: "POST", HandlerFunc: basekey.CodesCreate, LogOperation: true, ApiCode: "CodesCreate"},
		&handlerFuncObj{Url: "/base-key/codes/:codeId", Method: "PUT", HandlerFunc: basekey.CodesUpdate, LogOperation: true, ApiCode: "CodesUpdate"},
		&handlerFuncObj{Url: "/base-key/codes", Method: "DELETE", HandlerFunc: basekey.CodesDelete, LogOperation: true, ApiCode: "CodesDelete"},
		&handlerFuncObj{Url: "/base-key/codes/swap-position", Method: "POST", HandlerFunc: basekey.CodesPositionSwap, LogOperation: true, ApiCode: "CodesPositionSwap"},
		&handlerFuncObj{Url: "/referenceEnumCodes/:ciAttr/query", Method: "POST", HandlerFunc: basekey.ReferenceEnumCodes, LogOperation: true, ApiCode: "ReferenceEnumCodes"},
	)
	// ciTypes
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/ci-types", Method: "GET", HandlerFunc: ci.CiTypesQuery, ApiCode: "CiTypesQuery"},
		&handlerFuncObj{Url: "/ci-types", Method: "POST", HandlerFunc: ci.CiTypesCreate, LogOperation: true, ApiCode: "CiTypesCreate"},
		&handlerFuncObj{Url: "/ci-types/:ciType", Method: "PUT", HandlerFunc: ci.CiTypesUpdate, LogOperation: true, ApiCode: "CiTypesUpdate"},
		&handlerFuncObj{Url: "/ci-types/:ciType", Method: "DELETE", HandlerFunc: ci.CiTypesDelete, LogOperation: true, ApiCode: "CiTypesDelete"},
		&handlerFuncObj{Url: "/ci-types/apply/:ciType", Method: "POST", HandlerFunc: ci.CiTypesApply, LogOperation: true, ApiCode: "CiTypesApply"},
		&handlerFuncObj{Url: "/ci-types/rollback/:ciType", Method: "POST", HandlerFunc: ci.CiTypesRollback, LogOperation: true, ApiCode: "CiTypesRollback"},
		&handlerFuncObj{Url: "/ci-types/references/:ciType", Method: "GET", HandlerFunc: ci.CiTypesReferences, ApiCode: "CiTypesReferences"},
		&handlerFuncObj{Url: "/ci-template", Method: "GET", HandlerFunc: ci.GetCiTemplate, ApiCode: "GetCiTemplate"},
		&handlerFuncObj{Url: "/state-machine", Method: "GET", HandlerFunc: ci.GetStateMachine, ApiCode: "GetStateMachine"},
		&handlerFuncObj{Url: "/state-transition/:ciType", Method: "GET", HandlerFunc: ci.GetStateTransition, ApiCode: "GetStateTransition"},
		&handlerFuncObj{Url: "/extend/ci-types/model/list", Method: "GET", HandlerFunc: ci.GetExtendModelList, ApiCode: "GetExtendModelList"},
		&handlerFuncObj{Url: "/ci-types/query/id-and-name", Method: "GET", HandlerFunc: ci.QueryIdAndName, ApiCode: "QueryIdAndName"},
	)
	// ciAttributes
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes", Method: "GET", HandlerFunc: ci.AttrQuery, ApiCode: "AttrQuery"},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes", Method: "POST", HandlerFunc: ci.AttrCreate, LogOperation: true, ApiCode: "AttrCreate"},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/:ciAttr", Method: "PUT", HandlerFunc: ci.AttrUpdate, LogOperation: true, ApiCode: "AttrUpdate"},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/:ciAttr", Method: "DELETE", HandlerFunc: ci.AttrDelete, LogOperation: true, ApiCode: "AttrDelete"},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/apply/:ciAttr", Method: "POST", HandlerFunc: ci.AttrApply, LogOperation: true, ApiCode: "AttrApply"},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/rollback/:ciAttr", Method: "POST", HandlerFunc: ci.AttrRollback, LogOperation: true, ApiCode: "AttrRollback"},
		&handlerFuncObj{Url: "/ci-types-attr/:ciType/attributes/swap-position", Method: "POST", HandlerFunc: ci.AttrPositionSwap, LogOperation: true, ApiCode: "AttrPositionSwap"},
	)
	// ciData
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/ci-data/query/:ciType", Method: "POST", HandlerFunc: ci.DataQuery, ApiCode: "DataQuery"},
		&handlerFuncObj{Url: "/ci-data/do/:operation/:ciType", Method: "POST", HandlerFunc: ci.DataOperation, LogOperation: true, ApiCode: "DataOperation"},
		&handlerFuncObj{Url: "/ci-data/reference-data/query/:ciAttr", Method: "POST", HandlerFunc: ci.DataReferenceQuery, ApiCode: "DataReferenceQuery"},
		&handlerFuncObj{Url: "/ci-data/rollback/query/:guid", Method: "GET", HandlerFunc: ci.DataRollbackList, ApiCode: "DataRollbackList"},
		&handlerFuncObj{Url: "/ci-data/query-password/:ciType/:guid/:field", Method: "GET", HandlerFunc: ci.DataPasswordQuery, ApiCode: "DataPasswordQuery"},
		&handlerFuncObj{Url: "/ci-data/action-query/:operation/:ciType/:guid", Method: "GET", HandlerFunc: ci.GetActionQueryData, ApiCode: "GetActionQueryData"},
		&handlerFuncObj{Url: "/ci-data/import/:ciType", Method: "POST", HandlerFunc: ci.DataImport, ApiCode: "DataImport"},
		&handlerFuncObj{Url: "/ci-data/simple/import/:ciType", Method: "POST", HandlerFunc: ci.SimpleCiDataImport, ApiCode: "SimpleCiDataImport"},
		&handlerFuncObj{Url: "/ci-data/password/encrypt-key", Method: "GET", HandlerFunc: ci.GetCiPasswordAESKey, ApiCode: "GetCiPasswordAESKey"},
		&handlerFuncObj{Url: "/extend/ci-data/model/query/:ciAttr", Method: "POST", HandlerFunc: ci.GetExtendModelData, ApiCode: "GetExtendModelData"},
		&handlerFuncObj{Url: "/ci-data/sensitive-attr/query", Method: "POST", HandlerFunc: ci.AttrSensitiveDataQuery, ApiCode: "AttrSensitiveDataQuery"},
	)
	// log
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/log/query", Method: "POST", HandlerFunc: ci.QueryOperationLog, ApiCode: "QueryOperationLog"},
		&handlerFuncObj{Url: "/log/operation", Method: "GET", HandlerFunc: ci.GetAllLogOperation, ApiCode: "GetAllLogOperation"},
	)
	// permission
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/permissions/ci/:roleId", Method: "GET", HandlerFunc: permission.GetRoleCiPermission, ApiCode: "GetRoleCiPermission"},
		&handlerFuncObj{Url: "/permissions/ci/:roleId", Method: "POST", HandlerFunc: permission.UpdateRoleCiPermission, LogOperation: true, ApiCode: "UpdateRoleCiPermission"},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "GET", HandlerFunc: permission.GetRoleCiTypeCondition, ApiCode: "GetRoleCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "POST", HandlerFunc: permission.AddRoleCiTypeCondition, LogOperation: true, ApiCode: "AddRoleCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "PUT", HandlerFunc: permission.EditRoleCiTypeCondition, LogOperation: true, ApiCode: "EditRoleCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/condition/:roleCiType", Method: "DELETE", HandlerFunc: permission.DeleteRoleCiTypeCondition, LogOperation: true, ApiCode: "DeleteRoleCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "GET", HandlerFunc: permission.GetRoleCiTypeList, ApiCode: "GetRoleCiTypeList"},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "POST", HandlerFunc: permission.AddRoleCiTypeList, LogOperation: true, ApiCode: "AddRoleCiTypeList"},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "PUT", HandlerFunc: permission.EditRoleCiTypeList, LogOperation: true, ApiCode: "EditRoleCiTypeList"},
		&handlerFuncObj{Url: "/permissions/list/:roleCiType", Method: "DELETE", HandlerFunc: permission.DeleteRoleCiTypeList, LogOperation: true, ApiCode: "DeleteRoleCiTypeList"},
		&handlerFuncObj{Url: "/menus/list", Method: "GET", HandlerFunc: permission.GetMenuList, ApiCode: "GetMenuList"},
		&handlerFuncObj{Url: "/roles/menus", Method: "GET", HandlerFunc: permission.GetRoleMenu, ApiCode: "GetRoleMenu"},
		&handlerFuncObj{Url: "/roles/menus", Method: "POST", HandlerFunc: permission.UpdateRoleMenu, LogOperation: true, ApiCode: "UpdateRoleMenu"},
		&handlerFuncObj{Url: "/roles", Method: "GET", HandlerFunc: permission.GetRoleList, ApiCode: "GetRoleList"},
		&handlerFuncObj{Url: "/roles", Method: "POST", HandlerFunc: permission.RoleCreate, LogOperation: true, ApiCode: "RoleCreate"},
		&handlerFuncObj{Url: "/roles", Method: "PUT", HandlerFunc: permission.RoleUpdate, LogOperation: true, ApiCode: "RoleUpdate"},
		&handlerFuncObj{Url: "/roles", Method: "DELETE", HandlerFunc: permission.RoleDelete, LogOperation: true, ApiCode: "RoleDelete"},
		&handlerFuncObj{Url: "/roles/user", Method: "GET", HandlerFunc: permission.GetRoleUser, ApiCode: "GetRoleUser"},
		&handlerFuncObj{Url: "/roles/user", Method: "POST", HandlerFunc: permission.UpdateRoleUser, LogOperation: true, ApiCode: "UpdateRoleUser"},
		&handlerFuncObj{Url: "/user", Method: "GET", HandlerFunc: permission.GetUserList, ApiCode: "GetUserList"},
		&handlerFuncObj{Url: "/user", Method: "POST", HandlerFunc: permission.UserCreate, LogOperation: true, ApiCode: "UserCreate"},
		&handlerFuncObj{Url: "/user", Method: "PUT", HandlerFunc: permission.UserUpdate, LogOperation: true, ApiCode: "UserUpdate"},
		&handlerFuncObj{Url: "/user", Method: "DELETE", HandlerFunc: permission.UserDelete, LogOperation: true, ApiCode: "UserDelete"},
		&handlerFuncObj{Url: "/user/menus", Method: "GET", HandlerFunc: permission.GetUserMenu, ApiCode: "GetUserMenu"},
		&handlerFuncObj{Url: "/user/roles", Method: "GET", HandlerFunc: permission.GetUserRole, ApiCode: "GetUserRole"},
		&handlerFuncObj{Url: "/user/password/reset", Method: "POST", HandlerFunc: permission.UserPasswordReset, LogOperation: true, ApiCode: "UserPasswordReset"},
		&handlerFuncObj{Url: "/user/password/update", Method: "POST", HandlerFunc: permission.UserPasswordUpdate, LogOperation: true, ApiCode: "UserPasswordUpdate"},
		// template
		&handlerFuncObj{Url: "/permissions/tpl/list", Method: "GET", HandlerFunc: permission.ListTemplate, ApiCode: "ListTemplate"},
		&handlerFuncObj{Url: "/permissions/tpl/save", Method: "POST", HandlerFunc: permission.SaveTemplate, ApiCode: "SaveTemplate"},
		&handlerFuncObj{Url: "/permissions/tpl/get", Method: "GET", HandlerFunc: permission.GetTemplate, ApiCode: "GetTemplate"},
		&handlerFuncObj{Url: "/permissions/tpl/delete", Method: "DELETE", HandlerFunc: permission.DeleteTemplate, ApiCode: "DeleteTemplate"},
		&handlerFuncObj{Url: "/permissions/tpl/param", Method: "GET", HandlerFunc: permission.GetTemplateParam, ApiCode: "GetTemplateParam"},
		&handlerFuncObj{Url: "/permissions/tpl/param/save", Method: "POST", HandlerFunc: permission.SaveTemplateParam, ApiCode: "SaveTemplateParam"},
		&handlerFuncObj{Url: "/permissions/role/:roleId/tpl/get", Method: "GET", HandlerFunc: permission.GetRoleTemplate, ApiCode: "GetRoleTemplate"},
		&handlerFuncObj{Url: "/permissions/role/:roleId/tpl/save", Method: "POST", HandlerFunc: permission.SaveRoleTemplate, ApiCode: "SaveRoleTemplate"},
		&handlerFuncObj{Url: "/permissions/tpl/condition/:permissionCiTpl", Method: "GET", HandlerFunc: permission.GetTemplateCiTypeCondition, ApiCode: "GetTemplateCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/tpl/condition/:permissionCiTpl", Method: "POST", HandlerFunc: permission.AddTemplateCiTypeCondition, LogOperation: true, ApiCode: "AddTemplateCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/tpl/condition/:permissionCiTpl", Method: "PUT", HandlerFunc: permission.EditTemplateCiTypeCondition, LogOperation: true, ApiCode: "EditTemplateCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/tpl/condition/:permissionCiTpl", Method: "DELETE", HandlerFunc: permission.DeleteTemplateCiTypeCondition, LogOperation: true, ApiCode: "DeleteTemplateCiTypeCondition"},
		&handlerFuncObj{Url: "/permissions/tpl/list/:permissionCiTpl", Method: "GET", HandlerFunc: permission.GetTemplateCiTypeList, ApiCode: "GetTemplateCiTypeList"},
		&handlerFuncObj{Url: "/permissions/tpl/list/:permissionCiTpl", Method: "POST", HandlerFunc: permission.AddTemplateCiTypeList, LogOperation: true, ApiCode: "AddTemplateCiTypeList"},
		&handlerFuncObj{Url: "/permissions/tpl/list/:permissionCiTpl", Method: "PUT", HandlerFunc: permission.EditTemplateCiTypeList, LogOperation: true, ApiCode: "EditTemplateCiTypeList"},
		&handlerFuncObj{Url: "/permissions/tpl/list/:permissionCiTpl", Method: "DELETE", HandlerFunc: permission.DeleteTemplateCiTypeList, LogOperation: true, ApiCode: "DeleteTemplateCiTypeList"},
	)

	// view
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/views", Method: "GET", HandlerFunc: view.GetViewList, ApiCode: "GetViewList"},
		&handlerFuncObj{Url: "/view/:viewId", Method: "GET", HandlerFunc: view.GetView, ApiCode: "GetView"},
		&handlerFuncObj{Url: "/view-data", Method: "POST", HandlerFunc: view.GetViewData, ApiCode: "GetViewData"},
		&handlerFuncObj{Url: "/view-graph-data", Method: "POST", HandlerFunc: view.GetGraphViewData, ApiCode: "GetGraphViewData"},
		&handlerFuncObj{Url: "/view-confirm", Method: "POST", HandlerFunc: view.ConfirmView, ApiCode: "ConfirmView"},
	)

	// report
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/reports", Method: "GET", HandlerFunc: report.QueryReport, ApiCode: "QueryReport"},
		&handlerFuncObj{Url: "/reports", Method: "POST", HandlerFunc: report.CreateReport, ApiCode: "CreateReport"},
		&handlerFuncObj{Url: "/reports", Method: "PUT", HandlerFunc: report.UpdateReport, ApiCode: "UpdateReport"},
		&handlerFuncObj{Url: "/report-message/:reportId", Method: "GET", HandlerFunc: report.GetReport, ApiCode: "GetReport"},
		&handlerFuncObj{Url: "/report/:reportId", Method: "DELETE", HandlerFunc: report.DeleteReport, ApiCode: "DeleteReport"},
		&handlerFuncObj{Url: "/report-struct/:reportId", Method: "GET", HandlerFunc: report.QueryReportStruct, ApiCode: "QueryReportStruct"},
		&handlerFuncObj{Url: "/report-flat-struct/:reportId", Method: "GET", HandlerFunc: report.QueryReportFlatStruct, ApiCode: "QueryReportFlatStruct"},
		&handlerFuncObj{Url: "/report-data/:reportId", Method: "POST", HandlerFunc: report.QueryReportData, ApiCode: "QueryReportData"},
		&handlerFuncObj{Url: "/report-objects", Method: "POST", HandlerFunc: report.ModifyReportObject, ApiCode: "ModifyReportObject"},
		&handlerFuncObj{Url: "/report-objects/query", Method: "POST", HandlerFunc: report.QueryReportObject, ApiCode: "QueryReportObject"},
		&handlerFuncObj{Url: "/report-objects-attr/query", Method: "POST", HandlerFunc: report.QueryReportAttr, ApiCode: "QueryReportAttr"},
		&handlerFuncObj{Url: "/report/export", Method: "POST", HandlerFunc: report.ExportReportData, ApiCode: "ExportReportData"},
		&handlerFuncObj{Url: "/report/copy", Method: "POST", HandlerFunc: report.CopyReportData, ApiCode: "CopyReportData"},
	)

	// report import history
	httpHandlerFuncList = append(httpHandlerFuncList,
		&handlerFuncObj{Url: "/report-import-history/list", Method: "POST", HandlerFunc: report.QueryReportImportHistory, ApiCode: "QueryReportImportHistory"},
		&handlerFuncObj{Url: "/report-import-history/query", Method: "GET", HandlerFunc: report.QueryReportImportHistoryById, ApiCode: "QueryReportImportHistoryById"},
		&handlerFuncObj{Url: "/report-import-history/confirm-ci-data", Method: "POST", HandlerFunc: report.ConfirmReportImport, ApiCode: "ConfirmReportImport"},
		&handlerFuncObj{Url: "/report-import-history/cancel-ci-data", Method: "POST", HandlerFunc: report.CancelReportImport, ApiCode: "CancelReportImport"},
		&handlerFuncObj{Url: "/report-import-history/ci-types-attr/:ciType/attributes", Method: "GET", HandlerFunc: report.AttrQueryWithCheckResult, ApiCode: "AttrQueryWithCheckResult"},
		&handlerFuncObj{Url: "/report-import-history/ci-data/query/:ciType", Method: "POST", HandlerFunc: report.DataQueryWithCheckResult, ApiCode: "DataQueryWithCheckResult"},
		&handlerFuncObj{Url: "/report-import-history/user", Method: "GET", HandlerFunc: report.QueryReportImportUser, ApiCode: "QueryReportImportUser"},
		&handlerFuncObj{Url: "/report-import-history/refresh-check-result/list", Method: "GET", HandlerFunc: report.RefreshReportImportHistory, ApiCode: "RefreshReportImportHistory"},
		&handlerFuncObj{Url: "/report-import-history/refresh-check-result/query", Method: "GET", HandlerFunc: report.RefreshReportImportHistoryById, ApiCode: "RefreshReportImportHistoryById"},
	)
}

func InitHttpServer() {
	InitHttpError()
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
		apiCodeMap[fmt.Sprintf("%s_%s/api/v1%s", funcObj.Method, models.UrlPrefix, funcObj.Url)] = funcObj.ApiCode
		handleFuncList := []gin.HandlerFunc{funcObj.HandlerFunc}
		if funcObj.PreHandle != nil {
			log.Info(nil, log.LOGGER_APP, "Append pre handle", zap.String("url", funcObj.Url))
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
	middleware.InitApiMenuMap(apiCodeMap)
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
		apiCode := apiCodeMap[c.Request.Method+"_"+c.FullPath()]
		c.Writer.Header().Add("Api-Code", apiCode)
		c.Set(models.ContextApiCode, apiCode)
		c.Next()
		log.Info(nil, log.LOGGER_ACCESS, "request", zap.String("url", c.Request.RequestURI), zap.String("method", c.Request.Method), zap.Int("code", c.Writer.Status()), zap.String("operator", c.GetString("user")), zap.String("ip", middleware.GetRemoteIp(c)), zap.Float64("cost_ms", time.Now().Sub(start).Seconds()*1000), zap.String("body", c.GetString("requestBody")))
	}
}

func InitHttpError() {
	err := exterror.InitErrorTemplateList(models.Config.HttpServer.ErrorTemplateDir, models.Config.HttpServer.ErrorDetailReturn)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Init error template list fail", zap.Error(err))
	}
}
