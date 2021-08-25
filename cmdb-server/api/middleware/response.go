package middleware

import (
	"encoding/json"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/gin-gonic/gin"
	"net/http"
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
	c.Set("responseBody", "{\"statusCode\":\"OK\",\"data\":[]}")
	c.JSON(http.StatusOK, models.ResponseJson{StatusCode: "OK", Data: []string{}})
}

func ReturnError(c *gin.Context, statusCode, statusMessage string, data interface{}) {
	if data == nil {
		data = []string{}
	}
	log.Logger.Error("Handle error", log.String("statusCode", statusCode), log.String("message", statusMessage))
	obj := models.ResponseErrorJson{StatusCode: statusCode, StatusMessage: statusMessage, Data: data}
	bodyBytes, _ := json.Marshal(obj)
	c.Set("responseBody", string(bodyBytes))
	c.JSON(http.StatusOK, obj)
}

func ReturnBatchUpdateError(c *gin.Context, data []*models.ResponseErrorObj) {
	ReturnError(c, "ERR_BATCH_CHANGE", "message", data)
}

func ReturnParamValidateError(c *gin.Context, err error) {
	ReturnError(c, "PARAM_VALIDATE_ERROR", err.Error(), nil)
}

func ReturnParamEmptyError(c *gin.Context, paramName string) {
	ReturnError(c, "PARAM_EMPTY_ERROR", paramName, nil)
}

func ReturnServerHandleError(c *gin.Context, err error) {
	log.Logger.Error("Request server handle error", log.Error(err))
	ReturnError(c, "SERVER_HANDLE_ERROR", err.Error(), nil)
}

func ReturnTokenValidateError(c *gin.Context, err error) {
	c.JSON(http.StatusUnauthorized, models.ResponseErrorJson{StatusCode: "TOKEN_VALIDATE_ERROR", StatusMessage: err.Error(), Data: nil})
}

func ReturnDataPermissionError(c *gin.Context, err error) {
	ReturnError(c, "DATA_PERMISSION_ERROR", err.Error(), nil)
}

func ReturnDataPermissionDenyError(c *gin.Context) {
	ReturnError(c, "DATA_PERMISSION_DENY", "permission deny", nil)
}

func ReturnApiPermissionError(c *gin.Context) {
	ReturnError(c, "API_PERMISSION_ERROR", "api permission deny", nil)
}
