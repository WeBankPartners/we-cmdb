package com.webank.cmdb.support.exception;

import org.apache.commons.lang3.builder.ToStringBuilder;

public class InvalidArgumentException extends CmdbException {
    private static final long serialVersionUID = -356908320825630449L;

    private String argumentName;
    private Object argumentValue;
    private Object causeData;

    public InvalidArgumentException(String message) {
        super(message);
    }

    public InvalidArgumentException(String message, Object causeData) {
        super(message);
        this.causeData = causeData;
    }

    public InvalidArgumentException(String message, Exception e) {
        super(message, e);
    }

    public InvalidArgumentException(String message, String argName, Object argVal) {
        super(String.format("%s (%s:%s)", message, argName, argVal == null ? null : String.valueOf(argVal)));
        this.argumentName = argName;
        this.argumentValue = argVal;
    }

    public String getArgumentName() {
        return argumentName;
    }

    public Object getArgumentValue() {
        return argumentValue;
    }

    public Object getCauseData() {
        return causeData;
    }

    public void setCauseData(Object causeData) {
        this.causeData = causeData;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

}
