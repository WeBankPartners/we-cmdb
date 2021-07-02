package basekey

import (
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"strconv"
)

func CategoriesQuery(c *gin.Context) {
	//Param validate
	page, _ := strconv.Atoi(c.Query("page"))
	pageSize, _ := strconv.Atoi(c.Query("pageSize"))
	if page < 0 {
		middleware.ReturnParamEmptyError(c, "page")
		return
	}
	if pageSize <= 0 {
		middleware.ReturnParamEmptyError(c, "pageSize")
		return
	}
	//Query database
	pageInfo, rowData, err := db.BaseKeyCatQuery(page, pageSize)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnPageData(c, pageInfo, rowData)
	}
}

func CategoriesCreate(c *gin.Context) {
	var param models.SysBaseKeyCatTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.BaseKeyCatCreate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}
