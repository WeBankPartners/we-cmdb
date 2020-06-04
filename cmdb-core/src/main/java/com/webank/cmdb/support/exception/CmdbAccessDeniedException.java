package com.webank.cmdb.support.exception;

public class CmdbAccessDeniedException extends CmdbException {

    public CmdbAccessDeniedException(String message) {
        super(message);
    }

    public CmdbAccessDeniedException(String message, Throwable cause) {
        super(message, cause);
    }
}
