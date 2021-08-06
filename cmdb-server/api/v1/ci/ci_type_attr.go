package ci

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
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
	if err := validateAttrParam(param); err != nil {
		middleware.ReturnParamValidateError(c, err)
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

func validateAttrParam(param models.SysCiTypeAttrTable) error {
	if strings.ToLower(param.Id) == "id" {
		return fmt.Errorf("Attribute name:%s is illegal ", param.Id)
	}
	if param.Name == "" {
		return fmt.Errorf("Param attrbuteId can not empty ")
	}
	if param.DisplayName == "" {
		return fmt.Errorf("Param displayName can not empty ")
	}
	if param.InputType == "" {
		return fmt.Errorf("Param inputType can not empty ")
	}
	if param.DataType == "" {
		return fmt.Errorf("Param dataType can not empty ")
	}
	return nil
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
