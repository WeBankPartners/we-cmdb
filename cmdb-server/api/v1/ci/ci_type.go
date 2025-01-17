package ci

import (
	"encoding/base64"
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"strings"
)

// 查询CI
// GET /ci-types
func CiTypesQuery(c *gin.Context) {
	param := models.CiTypeQuery{CiTypeId: c.Query("id")}
	if c.Query("status") != "" {
		param.Status = strings.Split(c.Query("status"), ",")
	}
	if c.Query("group") != "" {
		param.Group = strings.Split(c.Query("group"), ",")
	}
	if c.Query("layer") != "" {
		param.Layer = strings.Split(c.Query("layer"), ",")
	}
	if c.Query("attr-input-type") != "" {
		param.AttrInputType = strings.Split(c.Query("attr-input-type"), ",")
	}
	if c.Query("attr-type-status") != "" {
		param.AttrTypeStatus = strings.Split(c.Query("attr-type-status"), ",")
	}
	param.GroupBy = c.Query("group-by")
	param.WithAttributes = c.Query("with-attributes")
	err := db.CiTypesQuery(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if param.GroupBy == "group" {
			middleware.ReturnData(c, param.GroupData)
		} else {
			middleware.ReturnData(c, param.CiTypeListData)
		}
	}
}

// 新增CI
// POST /ci-types
func CiTypesCreate(c *gin.Context) {
	//Param validate
	var param models.SysCiTypeTable
	var err error
	if err = c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	if models.ValidateNormalString(param.Id) == false {
		middleware.ReturnParamValidateError(c, fmt.Errorf("ciTypeId:%s is illegal", param.Id))
		return
	}
	if db.CheckIfCiTypesNameExists(param.Id) {
		middleware.ReturnParamValidateError(c, fmt.Errorf("CiTypes name %s already exists", param.Id))
		return
	}
	if param.CiTemplate == "" {
		middleware.ReturnParamEmptyError(c, "ciTemplate")
		return
	}
	var imageGuid, imageFileName string
	if param.FileName != "" {
		//Save image file
		imageGuid, imageFileName, err = saveImageFile(param.ImageFile, param.FileName)
		if err != nil {
			middleware.ReturnParamValidateError(c, err)
			return
		}
		param.ImageFile = imageGuid
	}
	// Save ci types row data
	err = db.CiTypesCreate(&param)
	if err != nil {
		if imageGuid != "" {
			db.CiTypesImageDelete(imageGuid, imageFileName)
		}
		middleware.ReturnServerHandleError(c, err)
		return
	}
	middleware.ReturnData(c, models.SysCiTypeTable{Id: param.Id, FileName: imageFileName})
}

// 修改CI
// PUT /ci-types/{{ciType}}
func CiTypesUpdate(c *gin.Context) {
	var param models.SysCiTypeTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	var err error
	var newImageGuid, imageFileName string
	if param.FileName != "" {
		newImageGuid, imageFileName, err = saveImageFile(param.ImageFile, param.FileName)
		if err != nil {
			middleware.ReturnParamValidateError(c, err)
			return
		}
	}
	nowImageFileName, err := db.CiTypesUpdate(&param, newImageGuid)
	if err != nil {
		if newImageGuid != "" {
			db.CiTypesImageDelete(newImageGuid, imageFileName)
		}
		middleware.ReturnServerHandleError(c, err)
	} else {
		if imageFileName != "" {
			nowImageFileName = imageFileName
		}
		middleware.ReturnData(c, models.SysCiTypeTable{Id: param.Id, FileName: nowImageFileName})
	}
}

func CiTypesDelete(c *gin.Context) {
	ciTypeId := c.Param("ciType")
	err := db.CiTypesDelete(ciTypeId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

func CiTypesApply(c *gin.Context) {
	var param models.SysCiTypeTable
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	var err error
	var newImageGuid, imageFileName string
	if param.FileName != "" {
		newImageGuid, imageFileName, err = saveImageFile(param.ImageFile, param.FileName)
		if err != nil {
			middleware.ReturnParamValidateError(c, err)
			return
		}
	}
	nowImageFileName, err := db.CiTypesUpdate(&param, newImageGuid)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if imageFileName != "" {
		nowImageFileName = imageFileName
	}

	ciTypeStatus := "created"
	ciTypeId := c.Param("ciType")
	ciRow, err := db.GetCiTypeById(ciTypeId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	if ciRow.Status == ciTypeStatus {
		middleware.ReturnData(c, models.SysCiTypeTable{Id: param.Id, FileName: nowImageFileName})
		return
	}
	err = db.CreateCiTable(ciTypeId)
	if err != nil {
		log.Logger.Error("Ci apply fail,create ci table error", log.Error(err))
	} else {
		db.UpdateCiTypesStatus(ciTypeId, ciTypeStatus)
	}
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		db.AutoCreateRoleCiTypeDataByCiType(ciTypeId)
		db.AutoCreateRoleCiTypeAttrPermission(ciTypeId)
		middleware.ReturnData(c, models.SysCiTypeTable{Id: param.Id, FileName: nowImageFileName})
	}
}

func CiTypesRollback(c *gin.Context) {
	ciTypeId := c.Param("ciType")
	err := db.CiTypesRollback(ciTypeId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

func CiTypesReferences(c *gin.Context) {
	ciTypeId := c.Param("ciType")
	result, err := db.GetCiTypesReference(ciTypeId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func GetCiTemplate(c *gin.Context) {
	result, err := db.GetCiTemplate()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func GetStateMachine(c *gin.Context) {
	var machineList []string
	if c.Query("machine") != "" {
		machineList = strings.Split(c.Query("machine"), ",")
	}
	if len(machineList) == 0 {
		middleware.ReturnParamEmptyError(c, "machine")
		return
	}
	result, err := db.GetStateMachineStateList(machineList)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func GetStateTransition(c *gin.Context) {
	ciTypeId := c.Param("ciType")
	var result []*models.SysStateTransitionTable
	var err error
	if c.Query("mode") == "all" {
		result, err = db.GetStateTransitionByCiType(ciTypeId, false)
	} else {
		result, err = db.GetStateTransitionByCiType(ciTypeId, true)
	}
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func saveImageFile(imageString, imageType string) (imageGuid, imageFileName string, err error) {
	if len(imageString) > 204800 {
		err = fmt.Errorf("Image file too big,max size is 200KB ")
		return
	}
	imageFileBytes, err := base64.StdEncoding.DecodeString(imageString)
	if err != nil {
		err = fmt.Errorf("Try to get image file bytes fail,%s ", err.Error())
		return
	}
	if strings.Contains(imageType, ".") {
		imageType = imageType[strings.LastIndex(imageType, ".")+1:]
	} else {
		imageType = "png"
	}
	imageGuid, err = db.CiTypesImageSave(imageFileBytes, imageType)
	if err != nil {
		err = fmt.Errorf("Save image file to database fail,%s ", err.Error())
		return
	}
	imageFileName = fmt.Sprintf("%s.%s", imageGuid, imageType)
	err = ioutil.WriteFile(fmt.Sprintf("public%s/fonts/%s", models.UrlPrefix, imageFileName), imageFileBytes, 0666)
	if err != nil {
		err = fmt.Errorf("Save image file to static resource fail,%s ", err.Error())
	}
	return
}

func checkCiStatusIllegal(status string) bool {
	statusIllegal := true
	for _, v := range models.CiStatusList {
		if v == status {
			statusIllegal = false
			break
		}
	}
	return statusIllegal
}

func GetExtendModelList(c *gin.Context) {
	result, err := db.GetExtendModelList(c.GetHeader(models.HeaderAuthorization))
	if err != nil {
		log.Logger.Warn("Try to get extendModel list fail", log.Error(err))
		result = []*models.OptionItemObj{}
		middleware.ReturnData(c, result)
	} else {
		middleware.ReturnData(c, result)
	}
}

func QueryIdAndName(c *gin.Context) {
	ciTypeTable, err := db.QueryIdAndName()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	}
	//
	var result map[string]string
	if ciTypeTable != nil {
		result = make(map[string]string)
		for _, row := range ciTypeTable {
			result[row.Id] = row.DisplayName
		}
	}
	middleware.ReturnData(c, result)
}
