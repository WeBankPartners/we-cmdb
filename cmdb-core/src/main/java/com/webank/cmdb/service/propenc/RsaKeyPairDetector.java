package com.webank.cmdb.service.propenc;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.CodeSource;
import java.util.Collections;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * @author gavin
 *
 */
public class RsaKeyPairDetector {
    private static final Logger log = LoggerFactory.getLogger(RsaKeyPairDetector.class);

    private static final String DEF_RSA_KEY_FILENAME = "rsa_key";
    private static final String DEF_RSA_PUB_KEY_FILENAME = "rsa_key.pub";

    private File publicKeyFile;
    private File privateKeyFile;

    protected FileSystem fileSystem;

    public RsaKeyPairDetector() {

    }

    public RsaKeyPairDetector(String rsaPubKey, String rsaKey) {
        File pubKeyFile = null;
        if (!StringUtils.isBlank(rsaPubKey)) {
            pubKeyFile = new File(rsaPubKey.trim());
        }

        File privKeyFile = null;
        if (!StringUtils.isBlank(rsaKey)) {
            privKeyFile = new File(rsaKey.trim());
        }

        this.publicKeyFile = pubKeyFile;
        this.privateKeyFile = privKeyFile;
    }

    public RsaKeyPairDetector(File rsaPublicKeyFile, File rsaPrivateKeyFile) {
        super();
        this.publicKeyFile = rsaPublicKeyFile;
        this.privateKeyFile = rsaPrivateKeyFile;
    }

    public RsaKeyPair detectRsaKeyPair() {
        try {
            return doDetectRsaKeyPair();
        } finally {
            if (fileSystem != null) {
                try {
                    fileSystem.close();
                } catch (IOException e) {
                    log.info("Errors to close fileSystem", e.getMessage());
                }
            }
        }
    }

    private RsaKeyPair doDetectRsaKeyPair() {
        log.info("try to detect rsa key");
        if (privateKeyFile != null && publicKeyFile != null) {
            String privKey = tryFindPrivateKeyFromExternal();
            String pubKey = tryFindPublicKeyFromExternal();
            return RsaKeyPairBuilder.withPublicKey(pubKey).withPrivateKey(privKey).build();
        } else if (privateKeyFile != null && publicKeyFile == null) {
            String privKey = tryFindPrivateKeyFromExternal();
            return RsaKeyPairBuilder.withPublicKey(null).withPrivateKey(privKey).build();
        } else if (privateKeyFile == null && publicKeyFile != null) {
            String pubKey = tryFindPublicKeyFromExternal();
            return RsaKeyPairBuilder.withPublicKey(pubKey).withPrivateKey(null).build();
        } else {
            String privKey = tryFindPrivateKeyFromDefault();
            String pubKey = tryFindPublicKeyFromDefault();
            return RsaKeyPairBuilder.withPublicKey(pubKey).withPrivateKey(privKey).build();
        }
    }

    private String tryFindPrivateKeyFromDefault() {
        log.info("try to find private key from default.");
        Path privKeyPath = null;
        try {
            privKeyPath = findOutRsaDefaultKey(DEF_RSA_KEY_FILENAME);
        } catch (IOException | URISyntaxException e1) {
            String msg = "Failed to deduce private key path.";
            log.error(msg);
            throw new EncryptionException(msg);
        } catch (Exception e) {
            log.error("errors", e);
            throw new EncryptionException();
        }

        try (InputStream input = Files.newInputStream(privKeyPath)) {
            return readInputStream(input);
        } catch (IOException e) {
            String msg = "Failed to read default private key";
            log.error(msg, e);
            throw new EncryptionException(msg);
        }
    }

    private String tryFindPrivateKeyFromExternal() {
        if (!this.privateKeyFile.exists()) {
            log.error("Private key does not exist,filepath={}", this.privateKeyFile.getAbsolutePath());
            String msg = String.format("Private key {%s} does not exist.", this.privateKeyFile.getAbsolutePath());
            throw new EncryptionException(msg);
        }

        try (FileInputStream input = new FileInputStream(privateKeyFile)) {
            return readInputStream(input);
        } catch (IOException e) {
            log.error("errors while reading private key", e);
            String msg = String.format("Failed to read private key {%s}.", this.privateKeyFile.getAbsolutePath());
            throw new EncryptionException(msg);
        }
    }

    private String tryFindPublicKeyFromDefault() {
        log.info("try to find public key from default.");
        Path pubKeyPath = null;
        try {
            pubKeyPath = findOutRsaDefaultKey(DEF_RSA_PUB_KEY_FILENAME);
        } catch (IOException | URISyntaxException e1) {
            String msg = "Failed to deduce public key path.";
            log.error(msg);
            throw new EncryptionException(msg);
        } catch (Exception e) {
            log.error("errors", e);
            throw new EncryptionException();
        }

        try (InputStream input = Files.newInputStream(pubKeyPath)) {
            return readInputStream(input);
        } catch (IOException e) {
            String msg = "Failed to read default public key";
            log.error(msg, e);
            throw new EncryptionException(msg);
        }
    }

    private String tryFindPublicKeyFromExternal() {
        if (!this.publicKeyFile.exists()) {
            log.error("Public key does not exist,filepath={}", this.publicKeyFile.getAbsolutePath());
            String msg = String.format("Public key {%s} does not exist.", this.publicKeyFile.getAbsolutePath());
            throw new EncryptionException(msg);
        }

        try (FileInputStream input = new FileInputStream(publicKeyFile)) {
            return readInputStream(input);
        } catch (IOException e) {
            log.error("errors while reading public key", e);
            String msg = String.format("Failed to read public key {%s}.", this.publicKeyFile.getAbsolutePath());
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

    protected Path findOutRsaDefaultKey(String filename) throws IOException, URISyntaxException {
        CodeSource src = RsaKeyPairDetector.class.getProtectionDomain().getCodeSource();

        if (src == null) {
            log.error("Failed to get code source.");
            return null;
        }

        URI uri = src.getLocation().toURI();
        Path myPath = null;
        if (uri.getScheme().equals("jar")) {
            if (fileSystem == null) {
                fileSystem = FileSystems.newFileSystem(uri, Collections.<String, Object>emptyMap());
            }
            myPath = fileSystem.getPath("/com/webank/cmdb/service/propenc/" + filename);

            if (!Files.exists(myPath)) {
                myPath = fileSystem.getPath("/BOOT-INF/classes/com/webank/cmdb/service/propenc/" + filename);
            }

        } else {
            URL dirUrl = RsaKeyPairDetector.class.getClassLoader()
                    .getResource("com/webank/cmdb/service/propenc/" + filename);
            if (dirUrl != null) {
                URI dirUri = dirUrl.toURI();
                myPath = Paths.get(dirUri);
            }
        }

        if (myPath != null) {
            log.info("RSA key path:{}", myPath.toAbsolutePath());
        } else {
            log.warn("Failed to find out RSA key.Filename:{}", filename);
        }

        return myPath;
    }
}
