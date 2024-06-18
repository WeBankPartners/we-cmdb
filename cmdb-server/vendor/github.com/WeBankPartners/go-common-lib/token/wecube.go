package token

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"github.com/WeBankPartners/go-common-lib/cipher"
	"github.com/dgrijalva/jwt-go"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"
)

var (
	coreRefreshToken        string
	coreRefreshTokenExpTime time.Time
	coreRequestToken        string
	coreRequestTokenExpTime time.Time
	requestCoreNonce        = "monitor"
	defaultSignedKey        = "Platform+Auth+Server+Secret"
)

type requestToken struct {
	Password   string `json:"password"`
	Username   string `json:"username"`
	Nonce      string `json:"nonce"`
	ClientType string `json:"clientType"`
}

type responseObj struct {
	Status  string             `json:"status"`
	Message string             `json:"message"`
	Data    []*responseDataObj `json:"data"`
}

type responseDataObj struct {
	Expiration string `json:"expiration"`
	Token      string `json:"token"`
	TokenType  string `json:"tokenType"`
}

type CoreToken struct {
	BaseUrl       string
	JwtSigningKey string
	SubSystemCode string
	SubSystemKey  string
}

func (c *CoreToken) refreshToken() error {
	req, err := http.NewRequest(http.MethodGet, c.BaseUrl+"/auth/v1/api/token", strings.NewReader(""))
	if err != nil {
		return fmt.Errorf("http new request fail,%s ", err.Error())
	}
	req.Header.Set("Authorization", coreRefreshToken)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("http response fail,%s ", err.Error())
	}
	var respObj responseObj
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	err = json.Unmarshal(bodyBytes, &respObj)
	if err != nil {
		return fmt.Errorf("http response body json unmarshal fail,%s ", err.Error())
	}
	for _, v := range respObj.Data {
		if len(v.Expiration) > 10 {
			v.Expiration = v.Expiration[:10]
		}
		expInt, _ := strconv.ParseInt(v.Expiration, 10, 64)
		if v.TokenType == "refreshToken" {
			coreRefreshToken = "Bearer " + v.Token
			coreRefreshTokenExpTime = time.Unix(expInt, 0)
		}
		if v.TokenType == "accessToken" {
			coreRequestToken = "Bearer " + v.Token
			coreRequestTokenExpTime = time.Unix(expInt, 0)
		}
	}
	return nil
}

func (c *CoreToken) requestCoreToken(rsaKey string) error {
	encryptBytes, err := cipher.RSAEncryptByPrivate([]byte(fmt.Sprintf("%s:%s", c.SubSystemCode, requestCoreNonce)), []byte(rsaKey))
	encryptString := base64.StdEncoding.EncodeToString(encryptBytes)
	if err != nil {
		return err
	}
	postParam := requestToken{Username: c.SubSystemCode, Nonce: requestCoreNonce, ClientType: "SUB_SYSTEM", Password: encryptString}
	postBytes, _ := json.Marshal(postParam)
	fmt.Printf("param: %s \n", string(postBytes))
	req, err := http.NewRequest(http.MethodPost, c.BaseUrl+"/auth/v1/api/login", bytes.NewReader(postBytes))
	if err != nil {
		return fmt.Errorf("http new request fail,%s ", err.Error())
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("http response fail, %s ", err.Error())
	}
	var respObj responseObj
	bodyBytes, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	err = json.Unmarshal(bodyBytes, &respObj)
	if err != nil {
		return fmt.Errorf("http response body read fail,%s ", err.Error())
	}
	for _, v := range respObj.Data {
		if len(v.Expiration) > 10 {
			v.Expiration = v.Expiration[:10]
		}
		expInt, _ := strconv.ParseInt(v.Expiration, 10, 64)
		if v.TokenType == "refreshToken" {
			coreRefreshToken = "Bearer " + v.Token
			coreRefreshTokenExpTime = time.Unix(expInt, 0)
		}
		if v.TokenType == "accessToken" {
			coreRequestToken = "Bearer " + v.Token
			coreRequestTokenExpTime = time.Unix(expInt, 0)
		}
	}
	return nil
}

func (c *CoreToken) InitCoreToken() {
	err := c.requestCoreToken(c.SubSystemKey)
	if err != nil {
		log.Printf("Init core token fail,error: %s ", err.Error())
	} else {
		log.Println("Init core token success")
	}
}

func (c *CoreToken) GetCoreToken() string {
	if c.BaseUrl == "" {
		return ""
	}
	if coreRequestTokenExpTime.Unix() > time.Now().Unix() && coreRequestToken != "" {
		return coreRequestToken
	}
	if coreRefreshTokenExpTime.Unix() > time.Now().Unix() && coreRefreshToken != "" {
		err := c.refreshToken()
		if err != nil {
			log.Printf("Refresh token fail,%s ", err.Error())
		} else {
			return coreRequestToken
		}
	}
	err := c.requestCoreToken(c.SubSystemKey)
	if err != nil {
		log.Printf("Try to init core token fail,%s ", err.Error())
	}
	return coreRefreshToken
}

type JwtToken struct {
	User   string   `json:"user"`
	Expire int64    `json:"expire"`
	Roles  []string `json:"roles"`
}

func DecodeJwtToken(token, key string) (result JwtToken, err error) {
	if strings.HasPrefix(token, "Bearer") {
		token = token[7:]
	}
	if key == "" || strings.HasPrefix(key, "{{") {
		key = defaultSignedKey
	}
	keyBytes, err := ioutil.ReadAll(base64.NewDecoder(base64.RawStdEncoding, bytes.NewBufferString(key)))
	if err != nil {
		return result, fmt.Errorf("Decode core token fail,base64 decode error,%s ", err.Error())
	}
	pToken, err := jwt.Parse(token, func(*jwt.Token) (interface{}, error) {
		return keyBytes, nil
	})
	if err != nil {
		return result, fmt.Errorf("Decode core token fail,jwt parse error,%s ", err.Error())
	}
	claimMap, ok := pToken.Claims.(jwt.MapClaims)
	if !ok {
		return result, fmt.Errorf("Decode core token fail,claims to map error,%s ", err.Error())
	}
	result.User = fmt.Sprintf("%s", claimMap["sub"])
	result.Expire, err = strconv.ParseInt(fmt.Sprintf("%.0f", claimMap["exp"]), 10, 64)
	if err != nil {
		return result, fmt.Errorf("Decode core token fail,parse expire to int64 error,%s ", err.Error())
	}
	roleListString := fmt.Sprintf("%s", claimMap["authority"])
	roleListString = roleListString[1 : len(roleListString)-1]
	if strings.Contains(roleListString, ",") {
		result.Roles = strings.Split(roleListString, ",")
	} else if strings.Contains(roleListString, " ") {
		result.Roles = strings.Split(roleListString, " ")
	} else {
		result.Roles = []string{roleListString}
	}
	return result, nil
}

type AuthClaims struct {
	Authority []string `json:"authority"`
	jwt.StandardClaims
}

func CreateJwtToken(user, key string, expire int64, permission []string) (signedToken string, err error) {
	var keyBytes []byte
	if key == "" || strings.HasPrefix(key, "{{") {
		key = defaultSignedKey
	}
	keyBytes, err = ioutil.ReadAll(base64.NewDecoder(base64.RawStdEncoding, bytes.NewBufferString("Platform+Auth+Server+Secret")))
	if err != nil {
		err = fmt.Errorf("Create token error with decode sign key:%s \n", err.Error())
		return
	}
	newClaims := AuthClaims{StandardClaims: jwt.StandardClaims{ExpiresAt: expire, Subject: user}, Authority: permission}
	newToken := jwt.NewWithClaims(jwt.SigningMethodHS256, newClaims)
	signedToken, err = newToken.SignedString(keyBytes)
	if err != nil {
		err = fmt.Errorf("Create token error with sign in key:%s \n", err.Error())
	}
	return
}
