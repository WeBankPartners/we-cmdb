package middleware

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/exterror"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func ReturnPageData(c *gin.Context, pageInfo models.PageInfo, contents interface{}) {
	if contents == nil {
		contents = []string{}
	}
	obj := models.ResponseJson{StatusCode: "OK", Data: models.ResponsePageData{PageInfo: pageInfo, Contents: contents}}
	bodyBytes, _ := json.Marshal(obj)
	c.Set("responseBody", string(bodyBytes))
	c.JSON(http.StatusOK, obj)
}

func ReturnEmptyPageData(c *gin.Context) {
	c.JSON(http.StatusOK, models.ResponseJson{StatusCode: "OK", Data: models.ResponsePageData{PageInfo: models.PageInfo{StartIndex: 0, PageSize: 0, TotalRows: 0}, Contents: []string{}}})
}

func ReturnData(c *gin.Context, data interface{}) {
	if data == nil {
		data = []string{}
	}
	obj := models.ResponseJson{StatusCode: "OK", Data: data}
	bodyBytes, _ := json.Marshal(obj)
	c.Set("responseBody", string(bodyBytes))
	c.JSON(http.StatusOK, obj)
}

func ReturnSuccess(c *gin.Context) {
	c.Set("responseBody", "{\"code\":0,\"statusCode\":\"OK\",\"data\":[]}")
	c.Writer.Header().Add("Error-Code", "0")
	c.JSON(http.StatusOK, models.ResponseJson{Code: 0, StatusCode: "OK", Data: []string{}})
}

func ReturnError(c *gin.Context, errorCode int, errorKey, errorMessage string, data interface{}) {
	if data == nil {
		data = []string{}
	}
	if !exterror.IsBusinessErrorCode(errorCode) {
		log.Error(nil, log.LOGGER_APP, "systemError", zap.Int("errorCode", errorCode), zap.String("errorKey", errorKey), zap.String("message", errorMessage))
	} else {
		log.Error(nil, log.LOGGER_APP, "businessError", zap.Int("errorCode", errorCode), zap.String("errorKey", errorKey), zap.String("message", errorMessage))
	}
	//log.Error(nil, log.LOGGER_APP, "Handle error", zap.String("statusCode", statusCode), zap.String("message", statusMessage))
	obj := models.ResponseErrorJson{Code: errorCode, StatusCode: errorKey, StatusMessage: errorMessage, Data: data}
	bodyBytes, _ := json.Marshal(obj)
	c.Set("responseBody", string(bodyBytes))
	c.Writer.Header().Add("Error-Code", strconv.Itoa(errorCode))
	c.JSON(http.StatusOK, obj)
}

func ReturnParamValidateError(c *gin.Context, err error) {
	//ReturnError(c, "PARAM_VALIDATE_ERROR", err.Error(), nil)
	err = exterror.Catch(exterror.New().RequestParamValidateError, err)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func ReturnParamEmptyError(c *gin.Context, paramName string) {
	err := exterror.Catch(exterror.New().RequestParamValidateError, fmt.Errorf("param:%s empty", paramName))
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
	//ReturnError(c, "PARAM_EMPTY_ERROR", paramName, nil)
}

func ReturnServerHandleError(c *gin.Context, err error) {
	//log.Error(nil, log.LOGGER_APP, "Request server handle error", zap.Error(err))
	//ReturnError(c, "SERVER_HANDLE_ERROR", err.Error(), nil)
	err = exterror.Catch(exterror.New().ServerHandleError, err)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func ReturnTokenValidateError(c *gin.Context, err error) {
	err = exterror.Catch(exterror.New().RequestTokenValidateError, err)
	_, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	// ReturnError(c, errorCode, errorKey, errorMessage, nil)
	c.JSON(http.StatusUnauthorized, models.ResponseErrorJson{StatusCode: errorKey, StatusMessage: errorMessage, Data: nil})
}

func ReturnDataPermissionError(c *gin.Context, err error) {
	err = exterror.Catch(exterror.New().ServerHandleError, err)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
	//ReturnError(c, "DATA_PERMISSION_ERROR", err.Error(), nil)
}

func ReturnDataPermissionDenyError(c *gin.Context) {
	//ReturnError(c, "DATA_PERMISSION_DENY", "permission deny", nil)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), exterror.New().DataPermissionDeny, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func ReturnDataPermissionDenyWithError(c *gin.Context, err error) {
	err = exterror.Catch(exterror.New().DataPermissionDeny, err)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func ReturnApiPermissionError(c *gin.Context) {
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), exterror.New().ApiPermissionDeny, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func ReturnSlaveModifyDenyError(c *gin.Context) {
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), exterror.New().SlaveModifyDeny, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func CheckModifyLegal(c *gin.Context) (ok bool) {
	if !models.Config.Sync.SlaveEnable {
		return true
	}
	if c.Request.Method == http.MethodGet {
		return true
	}
	if !strings.HasPrefix(c.Request.RequestURI, "/wecmdb/api/v1/ci-types") && !strings.HasPrefix(c.Request.RequestURI, "/wecmdb/api/v1/permissions") {
		return true
	}
	if c.GetString("fromSync") == "yes" {
		return true
	}
	return false
}
