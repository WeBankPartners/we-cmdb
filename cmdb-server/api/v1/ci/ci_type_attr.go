package ci

import (
	"fmt"
	"github.com/WeBankPartners/wecmdb-pro/cmdb-server/api/middleware"
	"github.com/WeBankPartners/wecmdb-pro/cmdb-server/models"
	"github.com/WeBankPartners/wecmdb-pro/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"strings"
)

func AttrQuery(c *gin.Context) {
	//Param validate
	ciTypeGuid := c.Param("ciType")
	if ciTypeGuid == "" {
		middleware.ReturnParamEmptyError(c, "ciType")
		return
	}
	status := c.Query("status")
	isCreated := true
	if status == "all" {
		isCreated = false
	}
	//Query database
	rowData, err := db.GetCiAttrByCiType(ciTypeGuid, isCreated)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func AttrCreate(c *gin.Context) {
	//Param validate
	ciTypeGuid := c.Param("ciType")
	if ciTypeGuid == "" {
		middleware.ReturnParamEmptyError(c, "ciType")
		return
	}
	var param models.SysCiTypeAttrTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if strings.ToLower(param.Id) == "id" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Attribute name:%s is illegal ", param.Id))
		return
	}
	param.CiType = ciTypeGuid
	//Update database
	err := db.CiAttrCreate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []*models.SysCiTypeAttrTable{&param})
	}
}

func AttrUpdate(c *gin.Context) {
	//Param validate
	ciTypeGuid := c.Param("ciType")
	if ciTypeGuid == "" {
		middleware.ReturnParamEmptyError(c, "ciType")
		return
	}
	ciAttrId := c.Param("ciAttr")
	if ciAttrId == "" {
		middleware.ReturnParamEmptyError(c, "ciAttr")
		return
	}
	var param models.SysCiTypeAttrTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	param.Id = ciAttrId
	param.CiType = ciTypeGuid
	//Update database
	_, err := db.CiAttrUpdate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []*models.SysCiTypeAttrTable{&param})
	}
}

func AttrDelete(c *gin.Context) {
	//Param validate
	ciAttrId := c.Param("ciAttr")
	if ciAttrId == "" {
		middleware.ReturnParamEmptyError(c, "ciAttr")
		return
	}
	//Update database
	err := db.CiAttrDelete(ciAttrId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

func AttrApply(c *gin.Context) {
	//Param validate
	ciTypeGuid := c.Param("ciType")
	if ciTypeGuid == "" {
		middleware.ReturnParamEmptyError(c, "ciType")
		return
	}
	ciAttrId := c.Param("ciAttr")
	if ciAttrId == "" {
		middleware.ReturnParamEmptyError(c, "ciAttr")
		return
	}
	var param models.SysCiTypeAttrTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	param.Id = ciAttrId
	param.CiType = ciTypeGuid
	//Update database
	updateAutofill, err := db.CiAttrUpdate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	err = db.CiAttrApply(ciTypeGuid, ciAttrId, updateAutofill)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

func AttrRollback(c *gin.Context) {
	//Param validate
	ciAttrId := c.Param("ciAttr")
	if ciAttrId == "" {
		middleware.ReturnParamEmptyError(c, "ciAttr")
		return
	}
	//Update database
	err := db.CiAttrRollback(ciAttrId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

func AttrPositionSwap(c *gin.Context) {
	ciTypeGuid := c.Param("ciType")
	if ciTypeGuid == "" {
		middleware.ReturnParamEmptyError(c, "ciType")
		return
	}
	var param []*models.CiAttrSwapPositionParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	err := db.CiAttrSwapPositionByUi(param, ciTypeGuid)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}
