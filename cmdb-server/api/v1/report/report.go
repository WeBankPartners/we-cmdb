package report

import (
	"fmt"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"strings"
)

func QueryReport(c *gin.Context) {
	roles := middleware.GetRequestRoles(c)
	permissionName := "permission"
	if c.Query(permissionName) == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param permission can not empty "))
		return
	}

	//Param validate
	paramsMap := make(map[string]interface{})
	if val, ok := c.GetQuery("ciType"); ok {
		paramsMap["ci_type"] = val
	}

	permissions := strings.Split(c.Query(permissionName), ",")
	permissiveReportIds, err := db.GetPermissiveReportId(permissions, roles, nil)
	if len(permissiveReportIds) == 0 {
		rowData := []string{}
		middleware.ReturnData(c, rowData)
		return
	}

	rowData, err := db.QueryReportList(paramsMap, permissiveReportIds)

	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if len(rowData) == 0 {
			rowData = []*models.SysReportTable{}
		}
		middleware.ReturnData(c, rowData)
	}
}

func QueryReportStruct(c *gin.Context) {
	reportId := c.Param("reportId")

	if reportId == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param reportId can not empty "))
		return
	}

	rowData, err := db.QueryReportStruct(reportId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if rowData == nil {
			middleware.ReturnData(c, []string{})
		} else {
			middleware.ReturnData(c, rowData)
		}
	}
	return
}

func QueryReportFlatStruct(c *gin.Context) {
	reportId := c.Param("reportId")

	if reportId == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param reportId can not empty "))
		return
	}

	rowData, err := db.QueryReportFlatStruct(reportId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if rowData == nil {
			middleware.ReturnData(c, []string{})
		} else {
			middleware.ReturnData(c, rowData)
		}
	}
	return
}

func QueryReportData(c *gin.Context) {
	reportId := c.Param("reportId")

	if reportId == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param reportId can not empty "))
		return
	}
	var queryParam models.QueryRequestParam
	if err := c.ShouldBindJSON(&queryParam); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}

	user := middleware.GetRequestUser(c)
	pageInfo, rowData, err := db.QueryReportData(reportId, &queryParam, user)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		if rowData == nil {
			middleware.ReturnPageData(c, pageInfo, []string{})
		} else {
			middleware.ReturnPageData(c, pageInfo, rowData)
		}
	}
	return
}

func GetReport(c *gin.Context) {
	reportId := c.Param("reportId")
	result, err := db.GetReport(reportId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, result)
	}
}

func CreateReport(c *gin.Context) {
	//Param validate
	var param models.ModifyReport
	var err error
	if err = c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	user := middleware.GetRequestUser(c)
	param.CreateUser = user
	//Update database
	rowData, err := db.CreateReport(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func UpdateReport(c *gin.Context) {
	var param models.ModifyReport
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	param.UpdateUser = middleware.GetRequestUser(c)
	rowData, err := db.UpdateReport(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, rowData)
	}
}

func DeleteReport(c *gin.Context) {
	reportId := c.Param("reportId")

	if reportId == "" {
		middleware.ReturnParamValidateError(c, fmt.Errorf("Url param reportId can not empty "))
		return
	}
	//Update database
	err := db.DeleteReport(reportId)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, nil)
	}
}

func ModifyReportObject(c *gin.Context) {
	//Param validate
	var param models.ModifyReportObject
	var err error
	if err = c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	//Update database
	err = db.ModifyReportObject(param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnData(c, []string{})
	}
}

func QueryReportObject(c *gin.Context) {
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	pageInfo, rowData, err := db.QueryReportObject(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnPageData(c, pageInfo, rowData)
	}
}

func QueryReportAttr(c *gin.Context) {
	var param models.QueryRequestParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	pageInfo, rowData, err := db.QueryReportAttr(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnPageData(c, pageInfo, rowData)
	}
}

func ExportReportData(c *gin.Context) {
	var param models.ExportReportParam
	if err := c.ShouldBindJSON(&param); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	result, err := db.ExportReportData(&param)
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	middleware.ReturnData(c, result)
}
