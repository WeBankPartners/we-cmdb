package middleware

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/exterror"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
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
		log.Logger.Error("systemError", log.Int("errorCode", errorCode), log.String("errorKey", errorKey), log.String("message", errorMessage))
	} else {
		log.Logger.Error("businessError", log.Int("errorCode", errorCode), log.String("errorKey", errorKey), log.String("message", errorMessage))
	}
	//log.Logger.Error("Handle error", log.String("statusCode", statusCode), log.String("message", statusMessage))
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
	//log.Logger.Error("Request server handle error", log.Error(err))
	//ReturnError(c, "SERVER_HANDLE_ERROR", err.Error(), nil)
	err = exterror.Catch(exterror.New().ServerHandleError, err)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}

func ReturnTokenValidateError(c *gin.Context, err error) {
	err = exterror.Catch(exterror.New().RequestTokenValidateError, err)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), err, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
	//c.JSON(http.StatusUnauthorized, models.ResponseErrorJson{StatusCode: "TOKEN_VALIDATE_ERROR", StatusMessage: err.Error(), Data: nil})
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
	//ReturnError(c, "API_PERMISSION_ERROR", "api permission deny", nil)
	errorCode, errorKey, errorMessage := exterror.GetErrorResult(c.GetHeader(exterror.AcceptLanguageHeader), exterror.New().ApiPermissionDeny, -1)
	ReturnError(c, errorCode, errorKey, errorMessage, nil)
}
