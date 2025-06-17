package ci

import (
	"fmt"
	"strings"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
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
	if !middleware.CheckModifyLegal(c) {
		middleware.ReturnSlaveModifyDenyError(c)
		return
	}
	var param models.SysCiTypeAttrTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	ciTypeGuid := c.Param("ciType")
	if param.CiType == "" {
		param.CiType = ciTypeGuid
	} else {
		ciTypeGuid = param.CiType
	}
	if err := validateAttrParam(param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	//Update database
	err := db.CiAttrCreate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		db.SyncPush(&models.SysSyncRecordTable{ContentData: param, Operator: middleware.GetRequestUser(c), ActionFunc: "AttrCreate", DataCategory: "model", DataType: param.Id})
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
	if param.CiType == "" {
		return fmt.Errorf("Param ciType can not empty")
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
	if param.AutofillAble == "yes" && param.AutofillRule != "" {
		return db.ValidateAutoFillRuleList(param.AutofillRule)
	}
	if param.RefFilter != "" && param.RefFilter != "[]" {
		return db.ValidateAttrRefFilter(param.RefFilter)
	}
	return nil
}

func AttrUpdate(c *gin.Context) {
	if !middleware.CheckModifyLegal(c) {
		middleware.ReturnSlaveModifyDenyError(c)
		return
	}
	var param models.SysCiTypeAttrTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	ciTypeGuid := c.Param("ciType")
	if param.CiType == "" {
		param.CiType = ciTypeGuid
	} else {
		ciTypeGuid = param.CiType
	}
	if err := validateAttrParam(param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	//Update database
	_, err := db.CiAttrUpdate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		db.SyncPush(&models.SysSyncRecordTable{ContentData: param, Operator: middleware.GetRequestUser(c), ActionFunc: "AttrUpdate", DataCategory: "model", DataType: param.Id})
		middleware.ReturnData(c, []*models.SysCiTypeAttrTable{&param})
	}
}

func AttrDelete(c *gin.Context) {
	if !middleware.CheckModifyLegal(c) {
		middleware.ReturnSlaveModifyDenyError(c)
		return
	}
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
		db.SyncPush(&models.SysSyncRecordTable{ContentData: map[string]string{"ciAttr": ciAttrId}, Operator: middleware.GetRequestUser(c), ActionFunc: "AttrDelete", DataCategory: "model", DataType: ciAttrId})
		middleware.ReturnData(c, []string{})
	}
}

func AttrApply(c *gin.Context) {
	log.Info(nil, log.LOGGER_APP, "Start attr apply")
	if !middleware.CheckModifyLegal(c) {
		middleware.ReturnSlaveModifyDenyError(c)
		return
	}
	var param models.SysCiTypeAttrTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	ciTypeGuid := c.Param("ciType")
	if param.CiType == "" {
		param.CiType = ciTypeGuid
	} else {
		ciTypeGuid = param.CiType
	}
	//Param validate
	if err := validateAttrParam(param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	ciAttrId := param.Id
	//Update database
	updateAutofill, err := db.CiAttrUpdate(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if err = db.CheckCiTypeSyncRef(ciTypeGuid); err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}

	err = db.CiAttrApply(ciTypeGuid, ciAttrId, updateAutofill)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		db.AutoCreateRoleCiTypeAttrPermission(ciTypeGuid)
		db.SyncPush(&models.SysSyncRecordTable{ContentData: param, Operator: middleware.GetRequestUser(c), ActionFunc: "AttrApply", DataCategory: "model", DataType: ciAttrId})
		middleware.ReturnData(c, []string{})
	}
}

func AttrRollback(c *gin.Context) {
	if !middleware.CheckModifyLegal(c) {
		middleware.ReturnSlaveModifyDenyError(c)
		return
	}
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
		db.SyncPush(&models.SysSyncRecordTable{ContentData: map[string]string{"ciAttr": ciAttrId}, Operator: middleware.GetRequestUser(c), ActionFunc: "AttrRollback", DataCategory: "model", DataType: ciAttrId})
		middleware.ReturnData(c, []string{})
	}
}

func AttrPositionSwap(c *gin.Context) {
	if !middleware.CheckModifyLegal(c) {
		middleware.ReturnSlaveModifyDenyError(c)
		return
	}
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
		db.SyncPush(&models.SysSyncRecordTable{ContentData: param, Operator: middleware.GetRequestUser(c), ActionFunc: "AttrPositionSwap", DataCategory: "model", DataType: ciTypeGuid})
		middleware.ReturnData(c, []string{})
	}
}
