package com.webank.cmdb.constant;

public enum DisplayType {
    None(-1), Display(1), Hidden(0);

    private int code;

    private DisplayType(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    static public DisplayType fromCode(int code) {
        for (DisplayType displayType : values()) {
            if (None.equals(displayType))
                continue;

            if (displayType.getCode() == code) {
                return displayType;
            }
        }
        return None;
    }
}
