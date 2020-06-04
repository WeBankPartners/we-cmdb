package com.webank.cmdb.support.exception;

public class ServiceException extends CmdbException {
    private static final long serialVersionUID = 2829464363135608132L;

    public ServiceException(String message) {
        super(message);
    }

    public ServiceException(String message, Exception ex) {
        super(message, ex);
    }
}
