package ci

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"sort"
	"strings"
	"time"

	"github.com/WeBankPartners/we-cmdb/cmdb-server/api/middleware"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/log"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/common/tools"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/models"
	"github.com/WeBankPartners/we-cmdb/cmdb-server/services/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func GetSyncRecord(c *gin.Context) {
	rowList, err := db.GetSyncRows()
	if err != nil {
		middleware.ReturnServerHandleError(c, err)
		return
	}
	result := models.SyncRecordQuery{List: rowList, Config: &models.Config.Sync}
	middleware.ReturnData(c, result)
}

func StartSyncCron() {
	if !models.Config.Sync.SlaveEnable {
		return
	}
	if models.Config.Sync.Target != models.Config.Sync.HostIp {
		return
	}
	t := time.NewTicker(10 * time.Second).C
	for {
		<-t
		if err := SyncPull(); err != nil {
			log.Error(nil, log.LOGGER_APP, "SyncPull job fail", zap.Error(err))
		}
		if err := handleSyncCiData(); err != nil {
			log.Error(nil, log.LOGGER_APP, "handleSyncCiData job fail", zap.Error(err))
		}
	}
}

func SyncPull() (err error) {
	nexusParam := tools.NexusReqParam{
		UserName:   models.Config.Sync.NexusUser,
		Password:   models.Config.Sync.NexusPwd,
		RepoUrl:    models.Config.Sync.NexusAddress,
		Repository: models.Config.Sync.NexusRepo,
		TimeoutSec: 30,
		DirPath:    models.SyncNexusDir,
	}
	fileNameList, listFileErr := tools.ListFilesInRepo(&nexusParam)
	if listFileErr != nil {
		err = fmt.Errorf("list file from nexus fail,%s ", listFileErr.Error())
		return
	}
	if len(fileNameList) == 0 {
		log.Debug(nil, log.LOGGER_APP, "SyncPull done with empty nexus file list")
		return
	}
	sort.Strings(fileNameList)
	curMaxSourceId, getMaxIdErr := db.GetMaxSucSyncSourceId()
	if getMaxIdErr != nil {
		err = getMaxIdErr
		return
	}
	var consumeFileNameList []string
	if curMaxSourceId == "" {
		consumeFileNameList = fileNameList
	} else {
		matchMaxSourceId := false
		for _, fileName := range fileNameList {
			if strings.HasPrefix(fileName, curMaxSourceId) {
				matchMaxSourceId = true
				continue
			}
			if !matchMaxSourceId {
				continue
			}
			consumeFileNameList = append(consumeFileNameList, fileName)
		}
	}
	if len(consumeFileNameList) == 0 {
		log.Debug(nil, log.LOGGER_APP, "SyncPull done with empty consume file list", zap.String("curMaxSourceId", curMaxSourceId))
		return
	}
	nexusParam.FileParams = []*tools.NexusFileParam{}
	for _, fileName := range consumeFileNameList {
		nexusParam.FileParams = append(nexusParam.FileParams, &tools.NexusFileParam{SourceFilePath: nexusParam.RepoUrl + "/repository/" + nexusParam.Repository + models.SyncNexusDir + fileName, DestFilePath: models.TmpSyncDir + fileName})
	}
	err = tools.DownloadFile(&nexusParam)
	if err != nil {
		err = fmt.Errorf("download file from nexus fail,%s ", err.Error())
		return
	}
	for _, fileName := range consumeFileNameList {
		tmpData, tmpErr := handleSyncSlaveData(models.TmpSyncDir + fileName)
		if tmpErr != nil {
			tmpData.Status = "fail"
			log.Error(nil, log.LOGGER_APP, "handle slave data fail", zap.String("file", fileName), zap.Error(tmpErr))
		}
		if tmpData.ID != "" {
			tmpData.SourceID = tmpData.ID
			tmpData.CreateTime = time.Now()
			if tmpData.Status != "fail" {
				if tmpData.DataCategory == "ciData" {
					tmpData.Status = "wait"
				} else {
					tmpData.Status = "ok"
				}
			}
			tmpData.SyncType = models.Config.Sync.Type
			tmpData.Source = models.Config.Sync.Source
			tmpData.Target = models.Config.Sync.Target
			tmpData.RemoteRepo = fmt.Sprintf("%s__%s", models.Config.Sync.NexusAddress, models.Config.Sync.NexusRepo)
			db.AddSyncRecord(&tmpData)
		}
		os.Remove(models.TmpSyncDir + fileName)
	}
	return
}

func handleSyncSlaveData(inputFile string) (inputData models.SysSyncRecordTable, err error) {
	inputData = models.SysSyncRecordTable{}
	tmpFileBytes, readErr := os.ReadFile(inputFile)
	if readErr != nil {
		err = fmt.Errorf("read sync file fail,%s ", readErr.Error())
		return
	}
	if err = json.Unmarshal(tmpFileBytes, &inputData); err != nil {
		err = fmt.Errorf("json unmarshal sync file to struct fail,%s ", err.Error())
		return
	}
	req := httptest.NewRequest(http.MethodPost, "/syncSlave", bytes.NewBuffer([]byte(inputData.Content)))
	req.Header.Set("Content-Type", "application/json")
	recorder := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(recorder) // 创建测试上下文
	c.Request = req                         // 将模拟的请求赋值给上下文
	c.Set("fromSync", "yes")
	if inputData.DataCategory == "model" {
		switch inputData.ActionFunc {
		case "AttrApply":
			AttrApply(c)
		case "AttrCreate":
			AttrCreate(c)
		case "AttrUpdate":
			AttrUpdate(c)
		case "AttrDelete":
			c.AddParam("ciAttr", inputData.DataType)
			AttrDelete(c)
		case "AttrRollback":
			c.AddParam("ciAttr", inputData.DataType)
			AttrRollback(c)
		case "AttrPositionSwap":
			c.AddParam("ciType", inputData.DataType)
			AttrPositionSwap(c)
		case "CiTypesCreate":
			CiTypesCreate(c)
		case "CiTypesUpdate":
			CiTypesUpdate(c)
		case "CiTypesDelete":
			c.AddParam("ciType", inputData.DataType)
			CiTypesDelete(c)
		case "CiTypesApply":
			c.AddParam("ciType", inputData.DataType)
			CiTypesApply(c)
		case "CiTypesRollback":
			c.AddParam("ciType", inputData.DataType)
			CiTypesRollback(c)
		}
	} else if inputData.DataCategory == "ciData" {
		switch inputData.ActionFunc {
		case "HandleCiDataOperation":
			c.AddParam("syncRecordId", inputData.ID)
			AddSyncCiDataRecord(c)
		}
	}
	var response models.ResponseErrorJson
	log.Debug(nil, log.LOGGER_APP, "handleSyncSlaveData func done", zap.String("response", string(recorder.Body.Bytes())))
	if err = json.Unmarshal(recorder.Body.Bytes(), &response); err != nil {
		err = fmt.Errorf("json unmarshal gin reponse fail,%s ", err.Error())
		return
	}
	if response.StatusCode != "OK" {
		err = fmt.Errorf(response.StatusMessage)
	}
	return
}

func AddSyncCiDataRecord(c *gin.Context) {
	log.Debug(nil, log.LOGGER_APP, "AddSyncCiDataRecord start")
	var dataList []*models.SysSyncDataTable
	if err := c.ShouldBindJSON(&dataList); err != nil {
		middleware.ReturnParamValidateError(c, err)
		return
	}
	syncRecordId := c.Param("syncRecordId")
	for _, v := range dataList {
		v.SyncRecord = syncRecordId
		v.Status = "wait"
	}
	err := db.AddSyncData(dataList)
	if err != nil {
		err = fmt.Errorf("handleSyncCiData add sync data fail,%s ", err.Error())
		middleware.ReturnServerHandleError(c, err)
	} else {
		middleware.ReturnSuccess(c)
	}
}

func handleSyncCiData() (err error) {
	syncRecord, dataList, getErr := db.GetMatchSyncDataRecord()
	if getErr != nil {
		err = fmt.Errorf("GetMatchSyncDataRecord fail,%s ", getErr.Error())
		return
	}
	if syncRecord == nil {
		log.Debug(nil, log.LOGGER_APP, "handleSyncCiData with empty syncRecord")
		return
	}
	for _, data := range dataList {
		if data.Status == "ok" {
			continue
		}
		tmpInputData := models.CiDataMapObj{}
		tmpErr := json.Unmarshal([]byte(data.DataContent), &tmpInputData)
		if tmpErr != nil {
			err = fmt.Errorf("json unmarshal data content fail,%s ", tmpErr.Error())
			db.UpdateSyncData(data.ID, err)
			break
		}
		handleParam := models.HandleCiDataParam{
			InputData:  []models.CiDataMapObj{tmpInputData},
			CiTypeId:   data.DataId[:strings.LastIndex(data.DataId, "_")],
			Operation:  data.Operation,
			BareAction: data.Action,
			Operator:   syncRecord.Operator,
			NowTime:    data.HandleTime,
			FromSync:   true,
		}
		log.Debug(nil, log.LOGGER_APP, "handleSyncCiData data", log.JsonObj("handleParam", handleParam))
		_, _, tmpErr = db.HandleCiDataOperation(handleParam)
		if tmpErr != nil {
			err = fmt.Errorf("handleCiDataOperation fail,%s ", tmpErr.Error())
			db.UpdateSyncData(data.ID, err)
			break
		}
		db.UpdateSyncData(data.ID, nil)
	}
	db.UpdateSyncRecord(syncRecord.ID, syncRecord.RetryCount, err)
	return
}
