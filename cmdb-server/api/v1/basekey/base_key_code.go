package basekey

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
)

func GetCodesByCat(c *gin.Context) {
	catId := c.Param("catId")
	if catId == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param catId can not empty "))
		return
	}
	param := models.QueryRequestParam{Paging: false, Sorting: &models.QueryRequestSorting{Asc: true, Field: "seqNo"}}
	param.Filters = []*models.QueryRequestFilterObj{&models.QueryRequestFilterObj{Name: "catId", Operator: "eq", Value: catId}}
	//Query database
	_, rowData, err := db.BaseKeyCodeQuery(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

// 查询基础数据 (获取图层列表) (查询层级列表)
// POST /base-key/codes/query
func CodesQuery(c *gin.Context) {
	//Param validate
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	//Query database
	pageInfo, rowData, err := db.BaseKeyCodeQuery(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnPageData(c, pageInfo, rowData)
	}
}

// 新增基础数据 (创建图层) (新增层级)
// POST /base-key/codes
func CodesCreate(c *gin.Context) {
	//Param validate
	var param []*models.BaseKeyCodeCreateObj
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if len(param) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param empty"))
		return
	}
	//Update database
	rowData, err := db.BaseKeyCodeCreate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

// 修改基础数据
// PUT /base-key/codes/{{codeId}}
func CodesUpdate(c *gin.Context) {
	//Param validate
	var param []*models.BaseKeyCodeCreateObj
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if len(param) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param empty"))
		return
	}
	defaultCodeId := c.Param("codeId")
	for _, v := range param {
		if v.CodeId == "" {
			v.CodeId = defaultCodeId
		}
	}
	//Update database
	rowData, err := db.BaseKeyCodeUpdate(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

// 删除基础数据 (删除层级)
// DELETE /base-key/codes/{{codeId}}
func CodesDelete(c *gin.Context) {
	var param []*models.BaseKeyCodeCreateObj
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if len(param) == 0 {
		middleware.ReturnParamValidateError(c, fmt.Errorf("param empty"))
		return
	}
	err := db.BaseKeyCodeDelete(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

// 调整基础数据排列
// POST /base-key/codes/swap-position
func CodesPositionSwap(c *gin.Context) {
	//Param validate
	var param models.BaseKeyCodeSwapPositionParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.BaseKeyCodeSwapPosition(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

// 查询基础数据 (获取图层列表) (查询层级列表)
// POST /referenceEnumCodes/:ciAttr/query
func ReferenceEnumCodes(c *gin.Context) {
	ciAttr := c.Param("ciAttr")
	if ciAttr == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("path param ciAttr can not empty"))
		return
	}
	//Param validate
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	//Query database
	result, err := db.ReferenceEnumCodes(ciAttr)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}
