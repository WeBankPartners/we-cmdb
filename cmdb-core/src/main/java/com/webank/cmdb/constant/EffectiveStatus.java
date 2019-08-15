package com.webank.cmdb.constant;

public enum EffectiveStatus {
    None("none"), Active("active"), Inactive("inactive");

    private String code;

    private EffectiveStatus(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public EffectiveStatus fromCode(String code) {
        for (EffectiveStatus status : values()) {
            if (None.equals(status))
                continue;

            if (status.getCode().equals(code)) {
                return status;
            }
        }
        return None;
    }
}
