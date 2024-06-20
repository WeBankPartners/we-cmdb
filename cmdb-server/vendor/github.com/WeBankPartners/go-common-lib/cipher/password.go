package cipher

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"math/rand"
	"strings"
	"time"
)

var (
	passwordLength = 12
	digitalBytes   = []byte("0123456789")
	lettersBytes   = []byte("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	DEFALT_CIPHER  = "CIPHER_A"
	CIPHER_MAP     = map[string]string{"CIPHER_A": "{cipher_a}"}
)

func Md5Encode(rawData string) string {
	data := []byte(rawData)
	return fmt.Sprintf("%x", md5.Sum(data))
}

func PKCS7Padding(ciphertext []byte, blockSize int) []byte {
	padding := blockSize - len(ciphertext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(ciphertext, padtext...)
}

func PKCS7UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	if length > unpadding {
		return origData[:(length - unpadding)]
	}
	return []byte{}
}

func AesEncode(key string, rawData string) (string, error) {
	bytesRawKey := []byte(key)
	block, err := aes.NewCipher(bytesRawKey)
	if err != nil {
		return "", err
	}
	blockSize := block.BlockSize()
	origData := PKCS7Padding([]byte(rawData), blockSize)
	blockMode := cipher.NewCBCEncrypter(block, bytesRawKey[:blockSize])
	crypted := make([]byte, len([]byte(origData)))
	blockMode.CryptBlocks(crypted, origData)
	return hex.EncodeToString(crypted), nil
}

func AesEncodeWithIV(key string, rawData, iv string) (string, error) {
	bytesRawKey := []byte(key)
	block, err := aes.NewCipher(bytesRawKey)
	if err != nil {
		return "", err
	}
	blockSize := block.BlockSize()
	ivBytes := []byte(iv)
	if len(ivBytes) != blockSize {
		err = fmt.Errorf("iv len:%d illegal,should be %d ", len(ivBytes), blockSize)
		return "", err
	}
	origData := PKCS7Padding([]byte(rawData), blockSize)
	blockMode := cipher.NewCBCEncrypter(block, ivBytes)
	crypted := make([]byte, len([]byte(origData)))
	blockMode.CryptBlocks(crypted, origData)
	return hex.EncodeToString(crypted), nil
}

func AesDecode(key string, encryptData string) (password string, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("%v", r)
		}
	}()

	bytesRawKey := []byte(key)
	bytesRawData, _ := hex.DecodeString(encryptData)
	block, err := aes.NewCipher(bytesRawKey)
	if err != nil {
		return
	}
	blockSize := block.BlockSize()
	blockMode := cipher.NewCBCDecrypter(block, bytesRawKey[:blockSize])
	origData := make([]byte, len(bytesRawData))
	blockMode.CryptBlocks(origData, bytesRawData)
	origData = PKCS7UnPadding(origData)
	if len(origData) == 0 {
		err = fmt.Errorf("password wrong")
		return
	}

	password = string(origData)
	return
}

func AesDecodeWithIV(key string, encryptData, iv string) (password string, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("%v", r)
		}
	}()
	bytesRawKey := []byte(key)
	bytesRawData, _ := hex.DecodeString(encryptData)
	block, err := aes.NewCipher(bytesRawKey)
	if err != nil {
		return
	}
	blockSize := block.BlockSize()
	ivBytes := []byte(iv)
	if len(ivBytes) != blockSize {
		err = fmt.Errorf("iv len:%d illegal,should be %d ", len(ivBytes), blockSize)
		return
	}
	blockMode := cipher.NewCBCDecrypter(block, ivBytes)
	origData := make([]byte, len(bytesRawData))
	blockMode.CryptBlocks(origData, bytesRawData)
	origData = PKCS7UnPadding(origData)
	if len(origData) == 0 {
		err = fmt.Errorf("password wrong")
		return
	}
	password = string(origData)
	return
}

func CreateRandomPassword() string {
	var result []byte
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < passwordLength-4; i++ {
		result = append(result, lettersBytes[r.Intn(len(lettersBytes))])
	}
	for i := 0; i < 4; i++ {
		result = append(result, digitalBytes[r.Intn(len(digitalBytes))])
	}
	return string(result)
}

func AesEnPassword(seed, password string) (string, error) {
	md5sum := Md5Encode(seed)
	enPassword, err := AesEncode(md5sum[0:16], password)
	if err != nil {
		return "", err
	}
	return enPassword, nil
}

func AesEnPasswordWithIV(seed, password, iv string) (string, error) {
	md5sum := Md5Encode(seed)
	enPassword, err := AesEncodeWithIV(md5sum[0:16], password, iv)
	if err != nil {
		return "", err
	}
	return enPassword, nil
}

func AesDePassword(seed, password string) (string, error) {
	md5sum := Md5Encode(seed)
	dePassword, err := AesDecode(md5sum[0:16], password)
	if err != nil {
		return "", err
	}
	return dePassword, nil
}

func AesDePasswordWithIV(seed, password, iv string) (string, error) {
	md5sum := Md5Encode(seed)
	dePassword, err := AesDecodeWithIV(md5sum[0:16], password, iv)
	if err != nil {
		return "", err
	}
	return dePassword, nil
}

func AesEnPasswordByGuid(guid, seed, password, cipher string) (string, error) {
	if seed == "" {
		return password, nil
	}
	for _, _cipher := range CIPHER_MAP {
		if strings.HasPrefix(password, _cipher) {
			return password, nil
		}
	}
	if cipher == "" {
		cipher = DEFALT_CIPHER
	}
	md5sum := Md5Encode(guid + seed)
	enPassword, err := AesEncode(md5sum[0:16], password)
	if err != nil {
		return "", err
	}
	return CIPHER_MAP[cipher] + enPassword, nil
}

func AesDePasswordByGuid(guid, seed, password string) (string, error) {
	var cipher string
	for _, _cipher := range CIPHER_MAP {
		if strings.HasPrefix(password, _cipher) {
			cipher = _cipher
			break
		}
	}
	if cipher == "" {
		return password, nil
	}
	password = password[len(cipher):]
	md5sum := Md5Encode(guid + seed)
	dePassword, err := AesDecode(md5sum[0:16], password)
	if err != nil {
		return "", err
	}
	return dePassword, nil
}
