package com.webank.cmdb.service.propenc;

/**
 * 
 * @author gavin
 *
 */
public class EncryptionException extends RuntimeException {

    /**
     * 
     */
    private static final long serialVersionUID = 115523361878991641L;

    public EncryptionException() {
        super();
    }

    public EncryptionException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }

    public EncryptionException(String message, Throwable cause) {
        super(message, cause);
    }

    public EncryptionException(String message) {
        super(message);
    }

    public EncryptionException(Throwable cause) {
        super(cause);
    }
    
    

}
