package com.webank.plugins.wecmdb.dto;

public class OperateCiDto {
    private String guid;

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    @Override
    public String toString() {
        return "OperateCiDto [guid=" + guid + "]";
    }
}
