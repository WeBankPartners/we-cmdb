package tools

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"
)

type NexusReqParam struct {
	UserName   string            `json:"userName"`   // 用户名
	Password   string            `json:"password"`   // 密码
	RepoUrl    string            `json:"repoUrl"`    // repo 的 url: http://127.0.0.1:8081
	Repository string            `json:"repository"` // repo 名称: test
	TimeoutSec int64             `json:"timeoutSec"` // 超时时间, 单位:s
	FileParams []*NexusFileParam `json:"fileParams"` // 文件的参数列表
	DirPath    string            `json:"dirPath"`    // 查询文件列表的目录路径: /test/t1
}

type NexusFileParam struct {
	SourceFilePath string `json:"sourceFilePath"` // 源文件的路径
	DestFilePath   string `json:"destFilePath"`   // 目标文件的路径
}

type NexusUploadFileRet struct {
	SourceFilePath string `json:"sourceFilePath"` // 源文件的路径
	DestFilePath   string `json:"destFilePath"`   // 目标文件的路径
	StorePath      string `json:"storePath"`      // 文件存储的地址
}

type AssetChecksum struct {
	Sha1 string `json:"sha1"`
	Md5  string `json:"md5"`
}

type AssetItem struct {
	DownloadUrl  string         `json:"downloadUrl"`
	Path         string         `json:"path"`
	Id           string         `json:"id"`
	Repository   string         `json:"repository"`
	Checksum     *AssetChecksum `json:"checksum"`
	ContentType  string         `json:"contentType"`
	LastModified string         `json:"lastModified"`
}

type SearchAssetsResp struct {
	Items             []*AssetItem `json:"items"`
	ContinuationToken string       `json:"continuationToken"` // 分页 token
}

func validateNexusReqParam(reqParam *NexusReqParam, isUploadFile bool) (err error) {
	if isUploadFile {
		if reqParam.RepoUrl == "" {
			err = fmt.Errorf("repoUrl should not be empty")
			return
		}
		if reqParam.Repository == "" {
			err = fmt.Errorf("repository should not be empty")
			return
		}
	}

	if reqParam.UserName == "" {
		err = fmt.Errorf("userName should not be empty")
		return
	}
	if reqParam.Password == "" {
		err = fmt.Errorf("password should not be empty")
		return
	}
	if reqParam.TimeoutSec <= 0 {
		err = fmt.Errorf("timeoutSec should > 0")
		return
	}

	if len(reqParam.FileParams) == 0 {
		err = fmt.Errorf("fileParams should not be empty")
		return
	}
	for i, fileParam := range reqParam.FileParams {
		if fileParam.SourceFilePath == "" {
			err = fmt.Errorf("%d th fileParam.SourceFilePath should not be empty", i+1)
			return
		}
		if fileParam.DestFilePath == "" {
			err = fmt.Errorf("%d th fileParam.DestFilePath should not be empty", i+1)
			return
		}
	}
	return
}

// UploadFile nexus 上传
func UploadFile(reqParam *NexusReqParam) (result []*NexusUploadFileRet, err error) {
	err = validateNexusReqParam(reqParam, true)
	if err != nil {
		err = fmt.Errorf("validate nexus req param failed: %s", err.Error())
		return
	}

	for _, uploadFileParam := range reqParam.FileParams {
		storePath, tmpErr := doUploadFile(reqParam, uploadFileParam)
		if tmpErr != nil {
			err = fmt.Errorf("doUploadFile for %s failed: %s", uploadFileParam.SourceFilePath, tmpErr.Error())
			return
		}

		result = append(result, &NexusUploadFileRet{
			SourceFilePath: uploadFileParam.SourceFilePath,
			DestFilePath:   uploadFileParam.DestFilePath,
			StorePath:      storePath,
		})
	}
	return
}

// DownloadFile nexus 下载
func DownloadFile(reqParam *NexusReqParam) (err error) {
	err = validateNexusReqParam(reqParam, false)
	if err != nil {
		err = fmt.Errorf("validate nexus req param failed: %s", err.Error())
		return
	}

	for _, downloadFileParam := range reqParam.FileParams {
		tmpErr := doDownloadFile(reqParam, downloadFileParam)
		if tmpErr != nil {
			err = fmt.Errorf("doDownloadFile for %s failed: %s", downloadFileParam.SourceFilePath, tmpErr.Error())
			return
		}
	}
	return
}

func doUploadFile(reqParam *NexusReqParam, uploadFileParam *NexusFileParam) (storePath string, err error) {
	srcFilePath := uploadFileParam.SourceFilePath

	// 打开文件
	file, tmpErr := os.Open(srcFilePath)
	if tmpErr != nil {
		err = fmt.Errorf("open file: %s failed: %s", srcFilePath, tmpErr.Error())
		return
	}
	defer file.Close()

	// 创建 HTTP 请求
	reqUrl := fmt.Sprintf("%s/repository/%s/%s", reqParam.RepoUrl, reqParam.Repository, uploadFileParam.DestFilePath)
	ctx, cancelFunc := context.WithTimeout(context.Background(), time.Duration(reqParam.TimeoutSec)*time.Second)
	defer cancelFunc()

	req, tmpErr := http.NewRequestWithContext(ctx, http.MethodPut, reqUrl, file)
	if tmpErr != nil {
		err = fmt.Errorf("create request for reqUrl: %s failed: %s", reqUrl, tmpErr.Error())
		return
	}

	req.SetBasicAuth(reqParam.UserName, reqParam.Password)
	req.Header.Set("Content-Type", "application/octet-stream") // 设置内容类型

	// 发送请求
	resp, tmpErr := http.DefaultClient.Do(req)
	if tmpErr != nil {
		err = fmt.Errorf("do request: %s failed: %s", reqUrl, tmpErr.Error())
		return
	}
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// 检查响应状态
	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		err = fmt.Errorf("upload file: %s failed, resp.Status: %s", srcFilePath, resp.Status)
		return
	}
	fmt.Printf("upload file: %s successfully: %s\n", srcFilePath, bodyBytes)
	storePath = fmt.Sprintf("%s/repository/%s/%s", reqParam.RepoUrl, reqParam.Repository, uploadFileParam.DestFilePath)
	return
}

func doDownloadFile(reqParam *NexusReqParam, downloadFileParam *NexusFileParam) (err error) {
	srcFilePath := downloadFileParam.SourceFilePath
	//log.Info(nil, log.LOGGER_APP, fmt.Sprintf("start to download file: %s", srcFilePath))

	// 创建 HTTP 请求
	ctx, cancelFunc := context.WithTimeout(context.Background(), time.Duration(reqParam.TimeoutSec)*time.Second)
	defer cancelFunc()

	reqUrl := srcFilePath
	req, tmpErr := http.NewRequestWithContext(ctx, http.MethodGet, reqUrl, nil)
	if tmpErr != nil {
		err = fmt.Errorf("create request for reqUrl: %s failed: %s", reqUrl, tmpErr.Error())
		return
	}

	req.SetBasicAuth(reqParam.UserName, reqParam.Password)

	// 发送请求
	resp, tmpErr := http.DefaultClient.Do(req)
	if tmpErr != nil {
		err = fmt.Errorf("do request: %s failed: %s", reqUrl, tmpErr.Error())
		return
	}
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// 检查响应状态
	if resp.StatusCode != http.StatusOK {
		err = fmt.Errorf("download file: %s failed, resp.Status: %s", srcFilePath, resp.Status)
		return
	}

	// 创建本地文件
	destFilePath := downloadFileParam.DestFilePath
	out, tmpErr := os.Create(destFilePath)
	if tmpErr != nil {
		err = fmt.Errorf("create output file: %s failed: %s", destFilePath, tmpErr.Error())
		return
	}
	defer out.Close()

	// 将响应内容写入本地文件
	_, tmpErr = io.Copy(out, bytes.NewReader(bodyBytes))
	if tmpErr != nil {
		err = fmt.Errorf("copy content to output file: %s failed: %s", destFilePath, tmpErr.Error())
		return
	}

	//log.Info(nil, log.LOGGER_APP, fmt.Sprintf("download file: %s successfully", srcFilePath))
	return
}

func validateListFilesInRepoParams(reqParam *NexusReqParam) (err error) {
	if reqParam.UserName == "" {
		err = fmt.Errorf("userName should not be empty")
		return
	}
	if reqParam.Password == "" {
		err = fmt.Errorf("password should not be empty")
		return
	}
	if reqParam.TimeoutSec <= 0 {
		err = fmt.Errorf("timeoutSec should > 0")
		return
	}

	if reqParam.RepoUrl == "" {
		err = fmt.Errorf("repoUrl should not be empty")
		return
	}

	if reqParam.Repository == "" {
		err = fmt.Errorf("repository should not be empty")
		return
	}

	if reqParam.DirPath == "" {
		err = fmt.Errorf("dirPath should not be empty")
		return
	}

	if !strings.HasPrefix(reqParam.DirPath, "/") {
		err = fmt.Errorf("dirPath should start with /")
		return
	}

	if strings.HasSuffix(reqParam.DirPath, "/") && reqParam.DirPath != "/" {
		reqParam.DirPath = strings.TrimRight(reqParam.DirPath, "/")
	}
	return
}

// ListFilesInRepo 列出 nexus 仓库中特定目录下的所有文件
func ListFilesInRepo(reqParam *NexusReqParam) (fileNameList []string, err error) {
	err = validateListFilesInRepoParams(reqParam)
	if err != nil {
		err = fmt.Errorf("validate ListFilesInRepo params failed: %s", err.Error())
		return
	}

	continuationToken := ""
	for {
		queryParams := make(map[string]string)
		queryParams["repository"] = reqParam.Repository
		queryParams["group"] = reqParam.DirPath
		if continuationToken != "" {
			queryParams["continuationToken"] = continuationToken
		}

		assetResponse, tmpErr := searchAssets(reqParam, queryParams)
		if tmpErr != nil {
			err = fmt.Errorf("list files in repo: %s, dirPath: %s failed: %s", reqParam.Repository, reqParam.DirPath, tmpErr.Error())
			return
		}

		for _, item := range assetResponse.Items {
			if item.Path != "" {
				tmpList := strings.Split(item.Path, "/")
				if len(tmpList) > 0 {
					fileName := tmpList[len(tmpList)-1]
					fileNameList = append(fileNameList, fileName)
				}
			}
		}

		if assetResponse.ContinuationToken != "" {
			continuationToken = assetResponse.ContinuationToken
		} else {
			break
		}
	}
	return
}

// searchAssets 查找 assets
func searchAssets(reqParam *NexusReqParam, queryParams map[string]string) (respData *SearchAssetsResp, err error) {
	ctx, cancelFunc := context.WithTimeout(context.Background(), time.Duration(reqParam.TimeoutSec)*time.Second)
	defer cancelFunc()

	reqUrl := fmt.Sprintf("%s/service/rest/v1/search/assets", reqParam.RepoUrl)
	req, tmpErr := http.NewRequestWithContext(ctx, http.MethodGet, reqUrl, nil)
	if tmpErr != nil {
		err = fmt.Errorf("create request for reqUrl: %s failed: %s", reqUrl, tmpErr.Error())
		return
	}

	for k, v := range queryParams {
		q := req.URL.Query()
		q.Add(k, v)
		req.URL.RawQuery = q.Encode()
	}

	req.SetBasicAuth(reqParam.UserName, reqParam.Password)

	// 发送请求
	resp, tmpErr := http.DefaultClient.Do(req)
	if tmpErr != nil {
		err = fmt.Errorf("do request: %s failed: %s", reqUrl, tmpErr.Error())
		return
	}
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// 检查响应状态
	if resp.StatusCode != http.StatusOK {
		err = fmt.Errorf("search assets failed, resp.Status: %s", resp.Status)
		return
	}

	respData = &SearchAssetsResp{}
	err = json.Unmarshal(bodyBytes, respData)
	if err != nil {
		err = fmt.Errorf("unmarshal response body data failed: %s", err.Error())
		return
	}
	return
}
