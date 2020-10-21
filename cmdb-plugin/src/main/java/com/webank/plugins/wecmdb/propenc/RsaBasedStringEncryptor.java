package com.webank.plugins.wecmdb.propenc;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.jasypt.encryption.StringEncryptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.webank.plugins.wecmdb.config.PluginApplicationProperties;

/**
 * 
 * @author gavin
 *
 */
@Component("jasyptStringEncryptor")
public class RsaBasedStringEncryptor implements StringEncryptor {
    private static final Logger log = LoggerFactory.getLogger(RsaBasedStringEncryptor.class);

    @Autowired
    private PluginApplicationProperties appConfigProperties;

    private RsaKeyPair propencRsaKeyPair;
    
    @PostConstruct
    public void afterPropertySet(){
        initPropencRsaKeyPair();
    }

    @Override
    public String decrypt(String cipherValue) {
        if(!isAvailable()) {
            return cipherValue;
        }
        
        try {
            byte[] data = RsaEncryptor.decryptByPrivateKey(RsaEncryptor.decodeBase64(cipherValue),
                    propencRsaKeyPair.getPrivateKey());
            String rawValue = new String(data, RsaEncryptor.DEF_CHARSET);

            return rawValue;
        } catch (Exception e) {
            log.error("errors while decrypt {} with private key:{}", cipherValue, e.getMessage());
            throw new EncryptionException("Failed to decrypt cipher text due to " + e.getMessage());
        }
    }

    @Override
    public String encrypt(String rawValue) {
        byte[] data = RsaEncryptor.encryptByPublicKey(rawValue.getBytes(RsaEncryptor.DEF_CHARSET),
                propencRsaKeyPair.getPublicKey());
        return RsaEncryptor.encodeBase64String(data);
    }

    protected void initPropencRsaKeyPair() {
        RsaKeyDetector keyDetector = new RsaKeyDetector(
                appConfigProperties.getPropertyEncryptKeyPath());
        RsaKeyPair keyPair = keyDetector.detectRsaKeyPair();
        if (keyPair != null) {
            log.info("Property encryption RSA key prepared!");
        }
        this.propencRsaKeyPair = keyPair;
    }
    
    public boolean isAvailable() {
        if(propencRsaKeyPair == null) {
            return false;
        }
        
        if(StringUtils.isBlank(propencRsaKeyPair.getPrivateKey())) {
            return false;
        }
        
        return true;
    }

}
