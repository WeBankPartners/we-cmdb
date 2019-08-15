package com.webank.cmdb.constant;

public enum BooleanType {
    None(-1), True(1), False(0);

    private int code;

    private BooleanType(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    static public BooleanType fromCode(int code) {
        for (BooleanType displayType : values()) {
            if (None.equals(displayType))
                continue;

            if (displayType.getCode() == code) {
                return displayType;
            }
        }
        return None;
    }
}
