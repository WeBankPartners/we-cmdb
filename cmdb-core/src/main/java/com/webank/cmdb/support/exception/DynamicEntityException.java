package com.webank.cmdb.support.exception;

public class DynamicEntityException extends CmdbException {
    private static final long serialVersionUID = 1L;

    public DynamicEntityException(String message) {
        super(message);
    }

    public DynamicEntityException(String message, Throwable cause) {
        super(message, cause);
    }

}
