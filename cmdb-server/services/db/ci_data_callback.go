package db

import (
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/guid"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"io/ioutil"
	"net/http"
	"strings"
)

func GetCiDataCallbackHistory(ciType, rowGuid string) {
	processTable := []*models.SysWecubeProcessTable{}
	err := x.SQL("select * from sys_wecube_process where ci_data_guid=? and status='InProgress'", rowGuid).Find(&processTable)
	if err != nil {
		err = fmt.Errorf("Try to query table fail,%s ", err.Error())
		return
	}
	if len(processTable) == 0 {
		return
	}
}

func GetCallbackQueryData(ciType, rowGuid string) (result models.CiDataActionQuery, err error) {
	inProgressList, checkErr := CheckCiDataCallbackStatus(rowGuid)
	if checkErr != nil {
		err = fmt.Errorf("Check if exist inProgress instance fail,%s ", checkErr.Error())
		return
	}
	rowData := []map[string]interface{}{}
	title := []*models.CiDataActionQueryTitle{}
	if len(inProgressList) > 0 {
		title = append(title, &models.CiDataActionQueryTitle{Id: "procDefName", Name: "编排名称"})
		title = append(title, &models.CiDataActionQueryTitle{Id: "procDefKey", Name: "编排Key"})
		title = append(title, &models.CiDataActionQueryTitle{Id: "status", Name: "状态"})
		title = append(title, &models.CiDataActionQueryTitle{Id: "time", Name: "开始时间"})
		for _, v := range inProgressList {
			tmpRow := make(map[string]interface{})
			tmpRow["procDefName"] = v.WecubeProcDefine
			tmpRow["procDefKey"] = v.WecubeProcInstanceTmp
			tmpRow["status"] = v.Status
			tmpRow["time"] = v.UpdateTime
			rowData = append(rowData, tmpRow)
		}
		result.Title = title
		result.Data = rowData
		result.Selectable = false
		return
	}
	processList, queryErr := ListCiDataVariableCallback(ciType, rowGuid)
	if queryErr != nil {
		err = fmt.Errorf("Query core process list fail,%s ", queryErr.Error())
		return
	}
	title = append(title, &models.CiDataActionQueryTitle{Id: "procDefName", Name: "编排名称"})
	title = append(title, &models.CiDataActionQueryTitle{Id: "procDefKey", Name: "编排Key"})
	title = append(title, &models.CiDataActionQueryTitle{Id: "version", Name: "版本"})
	title = append(title, &models.CiDataActionQueryTitle{Id: "time", Name: "创建时间"})
	for _, v := range processList {
		tmpRow := make(map[string]interface{})
		tmpRow["procDefName"] = v.ProcDefName
		tmpRow["procDefKey"] = v.ProcDefKey
		tmpRow["version"] = v.ProcDefVersion
		tmpRow["time"] = v.CreatedTime
		rowData = append(rowData, tmpRow)
	}
	result.Title = title
	result.Data = rowData
	result.Selectable = true
	return
}

func ListCiDataVariableCallback(ciType, rowGuid string) (processList []*models.CodeProcessQueryObj, err error) {
	processList = []*models.CodeProcessQueryObj{}
	if !models.PluginRunningMode {
		return
	}
	coreProcessList, coreErr := getCoreProcessList()
	if coreErr != nil {
		err = coreErr
		return
	}
	for _, tmpProcess := range coreProcessList {
		tmpRootCi := tmpProcess.RootEntity
		tmpFilter := ""
		if strings.Contains(tmpRootCi, "{") {
			tmpFilter = tmpRootCi[strings.Index(tmpRootCi, "{")+1 : len(tmpRootCi)-1]
			tmpRootCi = tmpRootCi[:strings.Index(tmpRootCi, "{")]
		}
		if tmpRootCi != fmt.Sprintf("wecmdb:%s", ciType) {
			continue
		}
		if tmpFilter != "" {
			if !ifCiDataProcessMatch(ciType, rowGuid, tmpFilter) {
				continue
			}
		}
		processList = append(processList, tmpProcess)
	}
	return
}

func getCoreProcessList() (processList []*models.CodeProcessQueryObj, err error) {
	models.CoreToken.GetCoreToken()
	req, reqErr := http.NewRequest(http.MethodGet, models.Config.Wecube.BaseUrl+"/platform/v1/process/definitions?includeDraft=0&permission=USE", nil)
	if reqErr != nil {
		err = fmt.Errorf("Try to new http request to core fail,%s ", reqErr.Error())
		return
	}
	req.Header.Set("Authorization", models.CoreToken.GetCoreToken())
	http.DefaultClient.CloseIdleConnections()
	resp, respErr := http.DefaultClient.Do(req)
	if respErr != nil {
		err = fmt.Errorf("Try to do request to core fail,%s ", respErr.Error())
		return
	}
	var respObj models.CoreProcessQueryResponse
	respBytes, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	err = json.Unmarshal(respBytes, &respObj)
	log.Logger.Debug("Get core process list", log.String("body", string(respBytes)))
	if err != nil {
		err = fmt.Errorf("Try to json unmarshal response body fail,%s ", err.Error())
		return
	}
	processList = respObj.Data
	return
}

func ifCiDataProcessMatch(ciType, rowGuid, filter string) bool {
	filterSqlList := []string{fmt.Sprintf("guid='%s'", rowGuid)}
	for _, v := range strings.Split(filter, "}{") {
		tmpSplit := strings.Split(v, " ")
		if len(tmpSplit) < 3 {
			continue
		}
		tmpValue := strings.ReplaceAll(v, fmt.Sprintf("%s %s ", tmpSplit[0], tmpSplit[1]), "")
		if strings.HasPrefix(tmpValue, "[") {
			// check if multi ref
			tmpValue = tmpValue[2 : len(tmpValue)-2]
		} else if tmpSplit[1] == "in" {
			tmpValue = tmpValue[1 : len(tmpValue)-1]
			tmpValue = strings.ReplaceAll(tmpValue, ",", "','")
		} else if strings.HasPrefix(tmpValue, "'") {
			tmpValue = tmpValue[1 : len(tmpValue)-1]
		}
		filterSqlList = append(filterSqlList, joinSqlFilter(tmpSplit[0], tmpSplit[1], tmpValue))
	}
	queryRows, err := x.QueryString("select guid from " + ciType + " where " + strings.Join(filterSqlList, " and "))
	if err != nil {
		log.Logger.Error("Try to query ci data table fail", log.String("ciType", ciType), log.String("guid", rowGuid), log.Error(err))
	}
	if len(queryRows) > 0 {
		return true
	}
	return false
}

func joinSqlFilter(column, condition, value string) string {
	var sql string
	switch condition {
	case "in":
		sql = fmt.Sprintf("%s IN ('%s')", column, value)
		break
	case "like":
		sql = fmt.Sprintf("%s LIKE '%%%s%%'", column, value)
		break
	case "eq":
		sql = fmt.Sprintf("%s='%s'", column, value)
		break
	case "gt":
		sql = fmt.Sprintf("%s>'%s'", column, value)
		break
	case "lt":
		sql = fmt.Sprintf("%s<'%s'", column, value)
		break
	case "neq":
		sql = fmt.Sprintf("%s!='%s'", column, value)
		break
	case "isnot":
		sql = fmt.Sprintf("%s IS NOT NULL", column)
		break
	case "is":
		sql = fmt.Sprintf("%s IS NULL", column)
		break
	}
	return sql
}

func StartCiDataCallback(param models.CiDataCallbackParam) error {
	var requestParam models.CoreProcessRequest
	requestParam.EventSeqNo = "wecmdb_" + guid.CreateGuid()
	requestParam.EventType = "wecmdb"
	requestParam.SourceSubSystem = models.Config.Wecube.SubSystemCode
	requestParam.OperationKey = param.ProcessKey
	requestParam.OperationData = param.RowGuid
	requestParam.OperationUser = param.OperationUser
	requestParam.OperationMode = "instant"
	log.Logger.Info(fmt.Sprintf("callback request data --> eventSeqNo:%s operationKey:%s operationData:%s", requestParam.EventSeqNo, requestParam.OperationKey, requestParam.OperationData))
	b, _ := json.Marshal(requestParam)
	request, err := http.NewRequest(http.MethodPost, fmt.Sprintf("%s/platform/v1/operation-events", models.Config.Wecube.BaseUrl), strings.NewReader(string(b)))
	if err != nil {
		return fmt.Errorf("Start callback new request fail:%s ", err.Error())
	}
	request.Header.Set("Authorization", models.CoreToken.GetCoreToken())
	request.Header.Set("Content-Type", "application/json")
	res, err := http.DefaultClient.Do(request)
	if err != nil {
		return fmt.Errorf("Start callback do request fail:%s ", err.Error())
	}
	resultBody, _ := ioutil.ReadAll(res.Body)
	res.Body.Close()
	var resultObj models.CoreProcessResult
	err = json.Unmarshal(resultBody, &resultObj)
	log.Logger.Debug("Callback core process result", log.String("body", string(resultBody)))
	if err != nil {
		return fmt.Errorf("Start callback unmarshal json body fail:%s ", err.Error())
	}
	if resultObj.Status != "OK" {
		return fmt.Errorf("Start core process fail,%s ", resultObj.Message)
	}
	_, err = x.Exec("insert into sys_wecube_process(guid,ci_data_guid,wecube_proc_instance_tmp,wecube_proc_instance,wecube_proc_define,status) value (?,?,?,?,?,?)",
		"ci_process_"+guid.CreateGuid(), param.RowGuid, param.ProcessKey, resultObj.Data.ProcInstId, param.ProcessName, resultObj.Data.Status)
	return err
}

func CheckCiDataCallbackStatus(rowGuid string) (inProgressList []*models.SysWecubeProcessTable, err error) {
	inProgressList = []*models.SysWecubeProcessTable{}
	var processTable []*models.SysWecubeProcessTable
	err = x.SQL("select * from sys_wecube_process where ci_data_guid=?", rowGuid).Find(&processTable)
	if err != nil {
		err = fmt.Errorf("Try to query table fail,%s ", err.Error())
		return
	}
	if len(processTable) == 0 {
		return
	}
	var updateProcessActions []*execAction
	for _, process := range processTable {
		if process.Status == "InProgress" {
			nowStatus, tmpErr := getCoreProcessRunningStatus(process.WecubeProcInstance)
			if tmpErr != nil {
				err = tmpErr
				break
			}
			updateProcessActions = append(updateProcessActions, &execAction{Sql: "update sys_wecube_process set status=? where guid=?", Param: []interface{}{nowStatus, process.Guid}})
			if nowStatus == "InProgress" {
				inProgressList = append(inProgressList, process)
			}
		}
	}
	if err != nil {
		return
	}
	if len(updateProcessActions) > 0 {
		err = transaction(updateProcessActions)
	}
	return
}

func getCoreProcessRunningStatus(instanceId string) (status string, err error) {
	request, reqErr := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/platform/v1/process/instances/%s", models.Config.Wecube.BaseUrl, instanceId), nil)
	if reqErr != nil {
		err = fmt.Errorf("Query process new request fail:%s ", reqErr.Error())
		return
	}
	request.Header.Set("Authorization", models.CoreToken.GetCoreToken())
	request.Header.Set("Content-Type", "application/json")
	res, respErr := http.DefaultClient.Do(request)
	if respErr != nil {
		err = fmt.Errorf("Query process do request fail:%s ", respErr.Error())
		return
	}
	resultBody, _ := ioutil.ReadAll(res.Body)
	res.Body.Close()
	var resultObj models.CoreProcessResult
	err = json.Unmarshal(resultBody, &resultObj)
	if err != nil {
		err = fmt.Errorf("Query process unmarshal json body fail:%s ", err.Error())
		return
	}
	if resultObj.Status != "OK" {
		err = fmt.Errorf("Query process fail,%s ", resultObj.Message)
		return
	}
	status = resultObj.Data.Status
	return
}
