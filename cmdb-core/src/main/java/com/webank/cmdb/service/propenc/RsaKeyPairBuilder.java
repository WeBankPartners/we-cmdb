package com.webank.cmdb.service.propenc;

/**
 * 
 * @author gavin
 *
 */
public class RsaKeyPairBuilder {

    private String privateKey;
    private String publicKey;

    public static RsaKeyPairBuilder withPublicKey(String publicKey) {
        RsaKeyPairBuilder b = new RsaKeyPairBuilder();
        b.setPublicKey(publicKey);

        return b;
    }

    public RsaKeyPairBuilder withPrivateKey(String privateKey) {
        this.setPrivateKey(privateKey);
        return this;
    }

    public RsaKeyPair build() {
        return new RsaKeyPair(this.publicKey, this.privateKey);
    }

    private void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    private void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

}
