package db

import (
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/tools"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"go.uber.org/zap"
)

func SyncPush(inputData *models.SysSyncRecordTable) {
	if !models.Config.Sync.MasterEnable {
		return
	}
	inputData.ID = fmt.Sprintf("cmdb_sync_%s", strings.ReplaceAll(time.Now().Format("20060102150405.99999"), ".", ""))
	inputData.SourceID = inputData.ID
	inputData.SyncType = models.Config.Sync.Type
	inputData.Source = models.Config.Sync.Source
	inputData.Target = models.Config.Sync.Target
	inputData.RemoteRepo = fmt.Sprintf("%s__%s", models.Config.Sync.NexusAddress, models.Config.Sync.NexusRepo)
	inputData.CreateTime = time.Now()
	inputData.Status = "ok"
	defer AddSyncRecord(inputData)
	contentBytes, err := json.Marshal(inputData.ContentData)
	if err != nil {
		inputData.Status = "fail"
		inputData.ErrorMsg = fmt.Sprintf("json marshal content param fail,%s ", err.Error())
		return
	}
	inputData.Content = string(contentBytes)
	inputDataBytes, _ := json.Marshal(inputData)
	tmpFileName := fmt.Sprintf("%s.json", inputData.ID)
	tmpFilePath := models.TmpSyncDir + tmpFileName
	err = os.WriteFile(tmpFilePath, inputDataBytes, 0644)
	if err != nil {
		inputData.Status = "fail"
		inputData.ErrorMsg = fmt.Sprintf("write tmp file:%s fail,%s ", tmpFilePath, err.Error())
		return
	}
	nexusParam := tools.NexusReqParam{
		UserName:   models.Config.Sync.NexusUser,
		Password:   models.Config.Sync.NexusPwd,
		RepoUrl:    models.Config.Sync.NexusAddress,
		Repository: models.Config.Sync.NexusRepo,
		TimeoutSec: 30,
		FileParams: []*tools.NexusFileParam{{SourceFilePath: tmpFilePath, DestFilePath: models.SyncNexusDir + tmpFileName}},
	}
	_, err = tools.UploadFile(&nexusParam)
	if err != nil {
		inputData.Status = "fail"
		inputData.ErrorMsg = fmt.Sprintf("upload sync file:%s to nexus fail,%s ", tmpFilePath, err.Error())
		return
	}
	os.Remove(tmpFilePath)
}

func SyncPushConfirmView(param *models.ViewData, confirmOutput []models.CiDataMapObj) {
	if !models.Config.Sync.MasterEnable || len(confirmOutput) == 0 {
		return
	}
	var ciTypeList, enableCiTypeList []string
	var errorMsg string
	ciTypeDistMap := make(map[string]string)
	for _, v := range confirmOutput {
		tmpRowGuid := fmt.Sprintf("%s", v["guid"])
		if lIndex := strings.LastIndex(tmpRowGuid, "_"); lIndex > 0 {
			tmpRowGuid = tmpRowGuid[:lIndex]
		}
		if tmpRowGuid == "" {
			continue
		}
		if _, b := ciTypeDistMap[tmpRowGuid]; b {
			continue
		}
		ciTypeList = append(ciTypeList, tmpRowGuid)
		ciTypeDistMap[tmpRowGuid] = tmpRowGuid
	}
	ciTypeRows, getCiTypeErr := GetCiTypeRows(ciTypeList)
	if getCiTypeErr != nil {
		log.Error(nil, log.LOGGER_APP, "SyncPushConfirmView get ciType rows fail", zap.Error(getCiTypeErr))
		return
	}
	for _, row := range ciTypeRows {
		if row.SyncEnable == "yes" {
			enableCiTypeList = append(enableCiTypeList, row.Id)
		}
	}
	if len(enableCiTypeList) != len(ciTypeList) {
		time.Now().Format(time.RFC3339Nano)
		errorMsg = fmt.Sprintf("SyncPushConfirmView enableCiType len:%d not equal ciType len:%d", len(enableCiTypeList), len(ciTypeList))
		AddSyncRecord(&models.SysSyncRecordTable{
			ID:           fmt.Sprintf("cmdb_sync_%s", strings.ReplaceAll(time.Now().Format("20060102150405.99999"), ".", "")),
			SyncType:     models.Config.Sync.Type,
			ErrorMsg:     errorMsg,
			Status:       "fail",
			Operator:     "SYSTEM",
			ActionFunc:   "ConfirmView",
			DataCategory: "ciData",
			DataType:     param.ViewId,
			CreateTime:   time.Now(),
		})
		log.Error(nil, log.LOGGER_APP, errorMsg, log.JsonObj("param", param), zap.String("detail", fmt.Sprintf("enableCiTypeList:%s  ciTypeList:%s", enableCiTypeList, ciTypeList)))
		return
	}
	SyncPush(&models.SysSyncRecordTable{ContentData: param, Operator: "SYSTEM", ActionFunc: "ConfirmView", DataCategory: "ciData", DataType: param.ViewId})
	return
}

func AddSyncRecord(inputData *models.SysSyncRecordTable) {
	_, err := x.Exec("INSERT INTO sys_sync_record (id,sync_type,remote_repo,action_func,data_category,data_type,content,source,source_id,target,status,retry_count,error_msg,create_time,operator) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
		inputData.ID, inputData.SyncType, inputData.RemoteRepo, inputData.ActionFunc, inputData.DataCategory, inputData.DataType, inputData.Content, inputData.Source, inputData.SourceID, inputData.Target, inputData.Status, inputData.RetryCount, inputData.ErrorMsg, inputData.CreateTime, inputData.Operator)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "addSyncRecord fail", zap.Error(err))
	} else {
		if len(inputData.SyncDataIds) > 0 {
			_, err = x.Exec(fmt.Sprintf("update sys_sync_data set sync_record=? where id in (%s)", strings.Join(inputData.SyncDataIds, ",")), inputData.ID)
			if err != nil {
				log.Error(nil, log.LOGGER_APP, "udpate sync data record fail", zap.Error(err))
			}
		}
	}
}

func GetSyncRows() (result []*models.SysSyncRecordTable, err error) {
	result = []*models.SysSyncRecordTable{}
	err = x.SQL("select * from sys_sync_record order by id desc").Find(&result)
	if err != nil {
		err = fmt.Errorf("query sync record table fail,%s ", err.Error())
	}
	return
}

func GetMaxSucSyncSourceId() (sourceId string, err error) {
	var syncRows []*models.SysSyncRecordTable
	err = x.SQL("select max(source_id) as 'source_id' from sys_sync_record").Find(&syncRows)
	if err != nil {
		err = fmt.Errorf("query sync max source id fail,%s ", err.Error())
	} else {
		if len(syncRows) > 0 {
			sourceId = syncRows[0].SourceID
		}
	}
	return
}

func HandleSyncDataWithoutConfirm(syncSlaveData models.HandleCiDataParam) (err error) {
	log.Debug(nil, log.LOGGER_APP, "HandleSyncDataWithoutConfirm start", log.JsonObj("syncSlaveData", syncSlaveData))
	if len(syncSlaveData.InputData) == 0 {
		return
	}
	dataList := []*models.SysSyncDataTable{}
	nowTime := time.Now()
	for _, inputRowData := range syncSlaveData.InputData {
		dataObj := models.SysSyncDataTable{
			DataId:     fmt.Sprintf("%s", inputRowData["guid"]),
			Action:     syncSlaveData.BareAction,
			Operation:  syncSlaveData.Operation,
			HandleTime: syncSlaveData.NowTime,
			CreateTime: nowTime,
		}
		inputRowBytes, _ := json.Marshal(inputRowData)
		dataObj.DataContent = string(inputRowBytes)
		dataList = append(dataList, &dataObj)
	}
	if err = AddSyncData(dataList); err != nil {
		log.Error(nil, log.LOGGER_APP, "HandleSyncDataWithoutConfirm fail", zap.Error(err))
	}
	return
}

func HandleSyncDataWithConfirm(syncSlaveData models.HandleCiDataParam) {
	log.Debug(nil, log.LOGGER_APP, "HandleSyncDataWithConfirm start", log.JsonObj("syncSlaveData", syncSlaveData))
	if len(syncSlaveData.InputData) == 0 {
		return
	}
	if err := HandleSyncDataWithoutConfirm(syncSlaveData); err != nil {
		log.Error(nil, log.LOGGER_APP, "HandleSyncDataWithConfirm fail with add sync data", zap.Error(err))
		return
	}
	var syncDataIds []string
	dataList := []*models.SysSyncDataTable{}
	for _, inputRowData := range syncSlaveData.InputData {
		tmpDataGuid := fmt.Sprintf("%s", inputRowData["guid"])
		tmpDataList, tmpErr := getSyncDataWithGuid(tmpDataGuid)
		if tmpErr != nil {
			log.Error(nil, log.LOGGER_APP, "HandleSyncDataWithConfirm error with inputData", zap.String("dataGuid", tmpDataGuid), zap.Error(tmpErr))
			continue
		}
		for _, v := range tmpDataList {
			syncDataIds = append(syncDataIds, strconv.Itoa(v.ID))
		}
		dataList = append(dataList, tmpDataList...)
	}
	SyncPush(&models.SysSyncRecordTable{ContentData: dataList, Operator: syncSlaveData.Operator, ActionFunc: "HandleCiDataOperation", DataCategory: "ciData", DataType: syncSlaveData.Operation, SyncDataIds: syncDataIds})
}

func AddSyncData(dataList []*models.SysSyncDataTable) (err error) {
	session := x.NewSession()
	err = session.Begin()
	for _, v := range dataList {
		if v.ID > 0 {
			_, err = session.Exec("INSERT INTO sys_sync_data (id,sync_record,data_id,data_content,`action`,operation,status,handle_time,create_time) values (?,?,?,?,?,?,?,?,?)",
				v.ID, v.SyncRecord, v.DataId, v.DataContent, v.Action, v.Operation, v.Status, v.HandleTime, v.CreateTime)
		} else {
			execResult, execErr := session.Exec("INSERT INTO sys_sync_data (data_id,data_content,`action`,operation,status,handle_time,create_time) values (?,?,?,?,?,?,?)",
				v.DataId, v.DataContent, v.Action, v.Operation, "ok", v.HandleTime, v.CreateTime)
			if execErr != nil {
				err = execErr
			} else {
				lastNewId, _ := execResult.LastInsertId()
				v.ID = int(lastNewId)
			}
		}
		if err != nil {
			session.Rollback()
			break
		}
	}
	if err == nil {
		err = session.Commit()
	}
	session.Close()
	return
}

func UpdateSyncData(syncDataId int, handleErr error) {
	status := "ok"
	var errorMsg string
	if handleErr != nil {
		status = "fail"
		errorMsg = handleErr.Error()
	}
	updateTime := time.Now()
	_, err := x.Exec("update sys_sync_data set status=?,error_msg=?,update_time=? where id=?", status, errorMsg, updateTime, syncDataId)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "UpdateSyncData fail", zap.Int("syncDataId", syncDataId), zap.Error(err))
	}
}

func UpdateSyncRecord(syncRecordId string, retryCount int, handleErr error) {
	status := "ok"
	var errorMsg string
	if handleErr != nil {
		status = "fail"
		errorMsg = handleErr.Error()
	}
	retryCount = retryCount + 1
	updateTime := time.Now()
	_, err := x.Exec("update sys_sync_record set status=?,retry_count=?,error_msg=?,update_time=? where id=?", status, retryCount, errorMsg, updateTime, syncRecordId)
	if err != nil {
		log.Error(nil, log.LOGGER_APP, "Update sync record fail", zap.String("syncRecordId", syncRecordId), zap.Error(err))
	}
}

func getSyncDataWithGuid(guid string) (dataList []*models.SysSyncDataTable, err error) {
	dataList = []*models.SysSyncDataTable{}
	err = x.SQL("select * from sys_sync_data where data_id=? and sync_record is null order by id", guid).Find(&dataList)
	if err != nil {
		err = fmt.Errorf("getSyncDataWithGuid fail:%s ", err.Error())
	}
	return
}

func GetMatchSyncDataRecord() (syncRecord *models.SysSyncRecordTable, dataList []*models.SysSyncDataTable, err error) {
	var syncRecordRows []*models.SysSyncRecordTable
	err = x.SQL("select id,action_func,data_category,data_type,status,retry_count,operator from sys_sync_record where data_category='ciData' and status<>'ok' order by id asc limit 1").Find(&syncRecordRows)
	if err != nil {
		err = fmt.Errorf("query sync record row fail,%s ", err.Error())
		return
	}
	if len(syncRecordRows) == 0 {
		return
	}
	syncRecord = syncRecordRows[0]
	err = x.SQL("select * from sys_sync_data where sync_record=? order by id", syncRecord.ID).Find(&dataList)
	if err != nil {
		err = fmt.Errorf("query sync data row fail,%s ", err.Error())
		return
	}
	return
}
