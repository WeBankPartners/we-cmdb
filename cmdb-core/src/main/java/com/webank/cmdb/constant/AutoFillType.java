package com.webank.cmdb.constant;

public enum AutoFillType {
    None("none"), Rule("rule"), Delimiter("delimiter");

    private String code;

    private AutoFillType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public AutoFillType fromCode(String code) {
        for (AutoFillType AutoFillType : values()) {
            if (None.equals(AutoFillType))
                continue;

            if (AutoFillType.getCode().equals(code)) {
                return AutoFillType;
            }
        }
        return None;
    }
}
