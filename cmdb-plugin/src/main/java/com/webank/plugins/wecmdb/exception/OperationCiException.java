package com.webank.plugins.wecmdb.exception;

public class OperationCiException extends RuntimeException {
    private static final long serialVersionUID = -6705726821703229173L;

    public OperationCiException(String message) {
        super(message);
    }

    public OperationCiException(String message, Throwable cause) {
        super(message, cause);
    }
}
