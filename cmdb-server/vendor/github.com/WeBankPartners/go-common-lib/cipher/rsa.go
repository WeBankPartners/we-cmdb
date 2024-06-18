package cipher

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"math/big"
	"strings"
)

const rsaPrefix = "RSA@"

func DecryptRsa(inputString, privateKeyContent string) (string, error) {
	if !strings.HasPrefix(inputString, rsaPrefix) {
		return inputString, nil
	}
	inputString = inputString[4:]
	result := inputString
	inputBytes, err := base64.StdEncoding.DecodeString(inputString)
	if err != nil {
		err = fmt.Errorf("Input string format to base64 fail,%s ", err.Error())
		return inputString, err
	}
	block, _ := pem.Decode([]byte(privateKeyContent))
	privateKeyInterface, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		err = fmt.Errorf("Parse private key fail,%s ", err.Error())
		return result, err
	}
	privateKey := privateKeyInterface.(*rsa.PrivateKey)
	decodeBytes, err := rsa.DecryptPKCS1v15(rand.Reader, privateKey, inputBytes)
	if err != nil {
		err = fmt.Errorf("Decode fail,%s ", err.Error())
		return result, err
	}
	result = string(decodeBytes)
	return result, nil
}

func EncryptRsa(inputString, publicKeyContent string) (string, error) {
	var result string
	block, _ := pem.Decode([]byte(publicKeyContent))
	privateKeyInterface, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		err = fmt.Errorf("Parse public key fail,%s ", err.Error())
		return result, err
	}
	publicKey := privateKeyInterface.(*rsa.PublicKey)
	encodeBytes, err := rsa.EncryptPKCS1v15(rand.Reader, publicKey, []byte(inputString))
	if err != nil {
		err = fmt.Errorf("Encode fail,%s ", err.Error())
		return result, err
	}
	result = rsaPrefix + base64.StdEncoding.EncodeToString(encodeBytes)
	return result, nil
}

func RSADecryptByPublic(encryptData, publicKeyContent []byte) ([]byte, error) {
	encryptString := string(encryptData)
	encryptBytes, err := base64.StdEncoding.DecodeString(encryptString)
	if err != nil {
		err = fmt.Errorf("EncryptData decode from base64 fail,%s ", err.Error())
		return nil, err
	}

	block, _ := pem.Decode(publicKeyContent)
	if block == nil {
		return nil, fmt.Errorf("public key illegal, pem decode fail")
	}
	publicKeyInterface, parsePubErr := x509.ParsePKIXPublicKey(block.Bytes)
	if parsePubErr != nil {
		return nil, fmt.Errorf("x509 parse public key error:%s ", parsePubErr.Error())
	}
	publicKey := publicKeyInterface.(*rsa.PublicKey)
	c := new(big.Int)
	m := new(big.Int)
	m.SetBytes(encryptBytes)
	e := big.NewInt(int64(publicKey.E))
	c.Exp(m, e, publicKey.N)
	out := c.Bytes()
	skip := 0
	for i := 2; i < len(out); i++ {
		if i+1 >= len(out) {
			break
		}
		if out[i] == 0xff && out[i+1] == 0 {
			skip = i + 2
			break
		}
	}
	return out[skip:], nil
}

func RSAEncryptByPrivate(sourceData, privateKeyContent []byte) ([]byte, error) {
	privateKeyString := string(privateKeyContent)
	if strings.HasPrefix(privateKeyString, "-----") {
		tmpSplitList := strings.Split(privateKeyString, "-----")
		if len(tmpSplitList) == 5 {
			privateKeyString = tmpSplitList[2]
		}
	}
	decodeBytes, err := base64.StdEncoding.DecodeString(privateKeyString)
	if err != nil {
		return nil, fmt.Errorf("RSASign private key is bad")
	}
	privateInterface, parsePrivateErr := x509.ParsePKCS8PrivateKey(decodeBytes)
	if parsePrivateErr != nil {
		return nil, fmt.Errorf("x509 parse private key error:%s ", parsePrivateErr.Error())
	}
	privateKey := privateInterface.(*rsa.PrivateKey)
	k := (privateKey.N.BitLen() + 7) / 8
	tLen := len(sourceData)
	em := make([]byte, k)
	em[1] = 1
	for i := 2; i < k-tLen-1; i++ {
		em[i] = 0xff
	}
	copy(em[k-tLen:k], sourceData)
	c := new(big.Int).SetBytes(em)
	if c.Cmp(privateKey.N) > 0 {
		return nil, nil
	}
	var m *big.Int
	if privateKey.Precomputed.Dp == nil {
		m = new(big.Int).Exp(c, privateKey.D, privateKey.N)
	} else {
		m = new(big.Int).Exp(c, privateKey.Precomputed.Dp, privateKey.Primes[0])
		m2 := new(big.Int).Exp(c, privateKey.Precomputed.Dq, privateKey.Primes[1])
		m.Sub(m, m2)
		if m.Sign() < 0 {
			m.Add(m, privateKey.Primes[0])
		}
		m.Mul(m, privateKey.Precomputed.Qinv)
		m.Mod(m, privateKey.Primes[0])
		m.Mul(m, privateKey.Primes[1])
		m.Add(m, m2)
		for i, values := range privateKey.Precomputed.CRTValues {
			prime := privateKey.Primes[2+i]
			m2.Exp(c, values.Exp, prime)
			m2.Sub(m2, m)
			m2.Mul(m2, values.Coeff)
			m2.Mod(m2, prime)
			if m2.Sign() < 0 {
				m2.Add(m2, prime)
			}
			m2.Mul(m2, values.R)
			m.Add(m, m2)
		}
	}
	return m.Bytes(), nil
}
