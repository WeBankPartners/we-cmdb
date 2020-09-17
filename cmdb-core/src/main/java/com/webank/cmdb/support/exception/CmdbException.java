package com.webank.cmdb.support.exception;

public class CmdbException extends RuntimeException {
    private static final long serialVersionUID = 9201888252462356192L;
    
    private String errorCode;
    private String messageKey;
    private boolean applyMessage = false;
    private Object[] args;

    public CmdbException(String message) {
        super(message);
        this.applyMessage = true;
    }

    public CmdbException(String message, Throwable cause) {
        super(message, cause);
        this.applyMessage = true;
    }

    public CmdbException(String errorCode, String message, Object... objects) {
        this(errorCode, null, message, null, false, objects);
    }

    private CmdbException(String errorCode, String messageKey, String message, Throwable cause,
            boolean applyMessage, Object... objects) {
        super(message, cause);
        this.errorCode = errorCode;
        this.messageKey = messageKey;
        if (objects != null && (this.args == null)) {
            this.args = new Object[objects.length];
            int index = 0;
            for (Object object : objects) {
                this.args[index] = object;
                index++;
            }
        }
        this.applyMessage = applyMessage;
    }

    public CmdbException withErrorCode(String errorCode) {
        this.errorCode = errorCode;
        return this;
    }

    public CmdbException withErrorCode(String errorCode, Object... objects) {
        this.errorCode = errorCode;
        if (objects != null && (this.args == null)) {
            this.args = new Object[objects.length];
            int index = 0;
            for (Object object : objects) {
                this.args[index] = object;
                index++;
            }
        }
        return this;
    }

    public CmdbException withErrorCodeAndArgs(String errorCode, Object[] objects) {
        this.errorCode = errorCode;
        if (objects != null && (this.args == null)) {
            this.args = new Object[objects.length];
            int index = 0;
            for (Object object : objects) {
                this.args[index] = object;
                index++;
            }
        }
        return this;
    }

    public CmdbException withMessageKey(String msgKey) {
        this.messageKey = msgKey;
        return this;
    }

    public CmdbException withMessageKey(String msgKey, Object... objects) {
        this.messageKey = msgKey;
        if (objects != null && (this.args == null)) {
            this.args = new Object[objects.length];
            int index = 0;
            for (Object object : objects) {
                this.args[index] = object;
                index++;
            }
        }

        return this;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public String getMessageKey() {
        return messageKey;
    }

    public boolean isApplyMessage() {
        return applyMessage;
    }

    public Object[] getArgs() {
        return args;
    }
}
