package ci

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"strings"
)

func GetActionQueryData(c *gin.Context) {
	operation := c.Param("operation")
	ciType := c.Param("ciType")
	rowGuid := c.Param("guid")
	if operation == "" || ciType == "" || rowGuid == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param illegal "))
		return
	}
	var err error
	result := models.CiDataActionQuery{}
	tmpOperation := strings.ToLower(operation)
	if tmpOperation == models.RollbackAction {
		queryData, title, rollbackErr := db.DataRollbackList(rowGuid)
		if rollbackErr != nil {
			middleware.ReturnServerHandleError(c, rollbackErr)
			return
		}
		result.Data = queryData
		result.Title = title
	} else {
		result, err = db.GetCallbackQueryData(ciType, rowGuid, c.GetHeader("Authorization"))
		if err != nil {
			middleware.ReturnServerHandleError(c, err)
			return
		}
	}
	middleware.ReturnData(c, result)
}
