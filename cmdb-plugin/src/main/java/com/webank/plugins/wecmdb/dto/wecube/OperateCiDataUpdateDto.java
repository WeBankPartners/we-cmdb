package com.webank.plugins.wecmdb.dto.wecube;

public class OperateCiDataUpdateDto {
    private String callbackParameter;
    private String entityName;
    private String guid;
    private String attrName;
    private Object attrVal;
    public String getCallbackParameter() {
        return callbackParameter;
    }
    public void setCallbackParameter(String callbackParameter) {
        this.callbackParameter = callbackParameter;
    }
    
    public String getEntityName() {
        return entityName;
    }
    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }
    public String getGuid() {
        return guid;
    }
    public void setGuid(String guid) {
        this.guid = guid;
    }
    public String getAttrName() {
        return attrName;
    }
    public void setAttrName(String attrName) {
        this.attrName = attrName;
    }
    public Object getAttrVal() {
        return attrVal;
    }
    public void setAttrVal(Object attrVal) {
        this.attrVal = attrVal;
    }
    
    

}
