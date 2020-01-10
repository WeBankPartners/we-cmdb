package com.webank.plugins.wecmdb.dto.wecube;

public enum DataType {
    None("none"), Ref("ref"), String("str"), Integer("int"), Timestamp("timestamp");

    private String code;

    private DataType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public DataType fromCode(String code) {
        for (DataType dataType : values()) {
            if (None.equals(dataType))
                continue;

            if (dataType.getCode().equals(code)) {
                return dataType;
            }
        }
        return None;
    }
}
