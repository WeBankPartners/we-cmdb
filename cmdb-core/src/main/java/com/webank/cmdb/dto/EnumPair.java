package com.webank.cmdb.dto;

public class EnumPair {
    private int codeId;
    private String code;
    private String name;

    public EnumPair() {
    }

    public EnumPair(int codeId, String code, String name) {
        this.codeId = codeId;
        this.code = code;
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCodeId() {
        return codeId;
    }

    public void setCodeId(int codeId) {
        this.codeId = codeId;
    }
}
