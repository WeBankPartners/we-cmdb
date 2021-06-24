package middleware

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

func ReturnPageData(c *gin.Context, pageInfo models.PageInfo, contents interface{}) {
	if contents == nil {
		contents = []string{}
	}
	c.JSON(http.StatusOK, models.ResponseJson{StatusCode: "OK", Data: models.ResponsePageData{PageInfo: pageInfo, Contents: contents}})
}

func ReturnEmptyPageData(c *gin.Context) {
	c.JSON(http.StatusOK, models.ResponseJson{StatusCode: "OK", Data: models.ResponsePageData{PageInfo: models.PageInfo{StartIndex: 0, PageSize: 0, TotalRows: 0}, Contents: []string{}}})
}

func ReturnData(c *gin.Context, data interface{}) {
	c.JSON(http.StatusOK, models.ResponseJson{StatusCode: "OK", Data: data})
}

func ReturnSuccess(c *gin.Context) {
	c.JSON(http.StatusOK, models.ResponseJson{StatusCode: "OK", Data: []string{}})
}

func ReturnError(c *gin.Context, statusCode, statusMessage string, data interface{}) {
	if data == nil {
		data = []string{}
	}
	log.Logger.Error("Handle error", log.String("statusCode", statusCode), log.String("message", statusMessage))
	c.JSON(http.StatusOK, models.ResponseErrorJson{StatusCode: statusCode, StatusMessage: statusMessage, Data: data})
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
