package com.webank.cmdb.service.propenc;

import org.springframework.stereotype.Component;

import com.ulisesbocchio.jasyptspringboot.EncryptablePropertyDetector;

/**
 * 
 * @author gavin
 *
 */
@Component("encryptablePropertyDetector")
public class RsaEncryptablePropertyDetector implements EncryptablePropertyDetector {
    public static final String DEF_ENC_PREFIX = "RSA@";

    @Override
    public boolean isEncrypted(String value) {
        if (value != null) {
            return value.startsWith(DEF_ENC_PREFIX);
        }
        return false;
    }

    @Override
    public String unwrapEncryptedValue(String value) {
        return value.trim().substring(DEF_ENC_PREFIX.length());
    }

}
