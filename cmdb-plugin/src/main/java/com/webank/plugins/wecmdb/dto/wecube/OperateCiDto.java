package com.webank.plugins.wecmdb.dto.wecube;

public class OperateCiDto {
    private String callbackParameter;
    private String guid;

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    public String getCallbackParameter() {
        return callbackParameter;
    }

    public void setCallbackParameter(String callbackParameter) {
        this.callbackParameter = callbackParameter;
    }

    @Override
    public String toString() {
        return "OperateCiDto [callbackParameter=" + callbackParameter + ", guid=" + guid + "]";
    }

}
