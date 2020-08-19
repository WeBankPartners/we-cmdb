package com.webank.cmdb.service.propenc;

/**
 * 
 * @author gavin
 *
 */
public class RsaKeyPair {

    private final String privateKey;

    private final String publicKey;

    RsaKeyPair(String publicKey, String privateKey) {
        super();
        this.privateKey = privateKey;
        this.publicKey = publicKey;
    }

    public String getPrivateKey() {
        return privateKey;
    }

    public String getPublicKey() {
        return publicKey;
    }
}
