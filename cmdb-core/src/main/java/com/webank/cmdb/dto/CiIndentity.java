package com.webank.cmdb.dto;

public class CiIndentity {
    private int ciTypeId;
    private String guid;

    public CiIndentity() {
    }

    public CiIndentity(int ciTypeId, String guid) {
        this.ciTypeId = ciTypeId;
        this.guid = guid;
    }

    public int getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(int ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    @Override
    public String toString() {
        return "[" + ciTypeId + ":" + guid + "]";
    }
}
