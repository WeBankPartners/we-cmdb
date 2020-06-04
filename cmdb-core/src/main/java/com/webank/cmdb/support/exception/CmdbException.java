package com.webank.cmdb.support.exception;

public class CmdbException extends RuntimeException {
    private static final long serialVersionUID = 9201888252462356192L;

    public CmdbException(String message) {
        super(message);
    }

    public CmdbException(String message, Throwable cause) {
        super(message, cause);
    }
}
