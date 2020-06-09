package com.webank.cmdb.support.exception;

public class AttributeNotFoundException extends DynamicEntityException {
    private static final long serialVersionUID = 1L;

    public AttributeNotFoundException(String message) {
        super(message);
    }

    public AttributeNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

}
