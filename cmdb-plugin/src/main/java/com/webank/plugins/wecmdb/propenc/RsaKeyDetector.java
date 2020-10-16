package com.webank.plugins.wecmdb.propenc;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * @author gavin
 *
 */
public class RsaKeyDetector {
    private static final Logger log = LoggerFactory.getLogger(RsaKeyDetector.class);


    private File rsaKeyFile;

    public RsaKeyDetector() {

    }

    public RsaKeyDetector(String rasKeyFilePath) {
        log.info("init {} with {}", RsaKeyDetector.class.getSimpleName(), rasKeyFilePath);
        if (rasKeyFilePath == null || rasKeyFilePath.trim().length() < 1) {
            rsaKeyFile = null;
            return;
        }

        rsaKeyFile = new File(rasKeyFilePath.trim());
    }

    public RsaKeyPair detectRsaKeyPair() {
        return doDetectRsaKeyPair();
    }

    private RsaKeyPair doDetectRsaKeyPair() {
        String rsaPrivKeyString = tryFindPrivateKeyFromExternal();
        if (StringUtils.isBlank(rsaPrivKeyString)) {
            return null;
        }

        return new RsaKeyPair(null, rsaPrivKeyString);
    }

    private String tryFindPrivateKeyFromExternal() {
        if (!this.rsaKeyFile.exists()) {
            log.info("Private key does not exist,filepath={}", this.rsaKeyFile.getAbsolutePath());
            return null;
        }

        try (FileInputStream input = new FileInputStream(rsaKeyFile)) {
            return readInputStream(input);
        } catch (IOException e) {
            log.error("errors while reading private key", e);
            String msg = String.format("Failed to read private key {%s}.", this.rsaKeyFile.getAbsolutePath());
            throw new EncryptionException(msg);
        }
    }

    private String readInputStream(InputStream inputStream) throws IOException {

        if (inputStream == null) {
            throw new IllegalArgumentException();
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, RsaEncryptor.DEF_CHARSET));
        String sLine = null;
        StringBuilder content = new StringBuilder();
        while ((sLine = br.readLine()) != null) {
            if (sLine.startsWith("-")) {
                continue;
            }

            content.append(sLine.trim());
        }

        return content.toString();
    }

}
