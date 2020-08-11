package com.webank.cmdb.service.propenc;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.apache.commons.codec.binary.Base64;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

/**
 * 512 PKCS#8
 * @author gavin
 *
 */
public final class RsaEncryptor {

    public static final String KEY_ALGORITHM = "RSA";
    
    public static final String DEF_ENCODING = "UTF-8";
    public static final Charset DEF_CHARSET = Charset.forName(DEF_ENCODING);

    private static final int KEY_SIZE = 512;

    private static final RsaEncryptor _INSTANCE = new RsaEncryptor();

    private boolean useExternalProvider = true;

    private RsaEncryptor() {
    }
    
    public static String encodeBase64String(byte[] data){
        return Base64.encodeBase64String(data);
    }
    
    public static byte[] decodeBase64(String base64String){
        return Base64.decodeBase64(base64String);
    }

    public static RsaKeyPair initKey() {
        try {
           return _INSTANCE.doInitKey();
        } catch (NoSuchAlgorithmException e) {
            throw new EncryptionException(e.getMessage());
        } catch (UnsupportedEncodingException e) {
            throw new EncryptionException(e.getMessage());
        }
    }
    
    public static byte[] decryptByPrivateKey(byte[] data, String base64KeyVal){
        return decryptByPrivateKey(data, decodeBase64(base64KeyVal));
    }

    public static byte[] decryptByPrivateKey(byte[] data, byte[] key) {
        try {
            return _INSTANCE.doDecryptByPrivateKey(data, key);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException | NoSuchPaddingException | InvalidKeyException
                | IllegalBlockSizeException | BadPaddingException e) {
            throw new EncryptionException(e.getMessage());
        }

    }
    
    public static byte[] encryptByPrivateKey(byte[] data, String base64KeyVal){
        return encryptByPrivateKey(data,decodeBase64(base64KeyVal));
    }

    public static byte[] encryptByPrivateKey(byte[] data, byte[] key) {
        try {
            return _INSTANCE.doEncryptByPrivateKey(data, key);
        } catch (InvalidKeyException | NoSuchAlgorithmException | InvalidKeySpecException | NoSuchPaddingException
                | IllegalBlockSizeException | BadPaddingException e) {
            throw new EncryptionException(e.getMessage());
        }
    }
    
    public static byte[] decryptByPublicKey(byte[] data, String base64KeyVal){
        return decryptByPublicKey(data, decodeBase64(base64KeyVal));
    }

    public static byte[] decryptByPublicKey(byte[] data, byte[] key) {
        try {
            return _INSTANCE.doDecryptByPublicKey(data, key);
        } catch (InvalidKeyException | NoSuchAlgorithmException | InvalidKeySpecException | NoSuchPaddingException
                | IllegalBlockSizeException | BadPaddingException e) {
            throw new EncryptionException(e.getMessage());
        }
    }
    
    public static byte[] encryptByPublicKey(byte[] data, String base64KeyVal){
        return encryptByPublicKey(data, decodeBase64(base64KeyVal));
    }

    public static byte[] encryptByPublicKey(byte[] data, byte[] key) {
        try {
            return _INSTANCE.doEncryptByPublicKey(data, key);
        } catch (InvalidKeyException | NoSuchAlgorithmException | InvalidKeySpecException | NoSuchPaddingException
                | IllegalBlockSizeException | BadPaddingException e) {
            throw new EncryptionException(e.getMessage());
        }
    }

    private byte[] doEncryptByPublicKey(byte[] data, byte[] key)
            throws NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException {
        initProvider();
        X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(key);

        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);

        PublicKey publicKey = keyFactory.generatePublic(x509KeySpec);

        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());

        cipher.init(Cipher.ENCRYPT_MODE, publicKey);

        return cipher.doFinal(data);
    }

    private byte[] doDecryptByPublicKey(byte[] data, byte[] key)
            throws NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException {
        initProvider();
        X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(key);

        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);

        PublicKey publicKey = keyFactory.generatePublic(x509KeySpec);

        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());

        cipher.init(Cipher.DECRYPT_MODE, publicKey);

        return cipher.doFinal(data);
    }

    private byte[] doEncryptByPrivateKey(byte[] data, byte[] key)
            throws NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException {
        initProvider();
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(key);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);

        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8KeySpec);

        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());

        cipher.init(Cipher.ENCRYPT_MODE, privateKey);

        return cipher.doFinal(data);
    }

    private byte[] doDecryptByPrivateKey(byte[] data, byte[] key)
            throws NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException {
        initProvider();
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(key);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);

        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8KeySpec);

        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());

        cipher.init(Cipher.DECRYPT_MODE, privateKey);

        return cipher.doFinal(data);

    }

    private RsaKeyPair doInitKey() throws NoSuchAlgorithmException, UnsupportedEncodingException {
        initProvider();
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance(KEY_ALGORITHM);
        keyPairGen.initialize(KEY_SIZE);
        KeyPair keyPair = keyPairGen.generateKeyPair();

        RSAPublicKey publicKey = (RSAPublicKey) keyPair.getPublic();
        RSAPrivateKey privateKey = (RSAPrivateKey) keyPair.getPrivate();

        RsaKeyPair aKeyPair = RsaKeyPairBuilder
                .withPublicKey(encodeBase64String((publicKey.getEncoded())))
                .withPrivateKey(encodeBase64String(privateKey.getEncoded())).build();

        return aKeyPair;
    }

    private void initProvider() {
        if (useExternalProvider && Security.getProvider(BouncyCastleProvider.PROVIDER_NAME) == null) {
            Security.addProvider(new BouncyCastleProvider());
        }
    }
    
    
}
