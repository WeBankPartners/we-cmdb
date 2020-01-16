package com.webank.cmdb.constant;

public enum AuthenticationType {
    NONE("NONE"), lOCAL("LOCAL"), CAS("CAS"), PLATFORM_AUTH("PLATFORM-AUTH");

    private String code;

    private AuthenticationType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public AuthenticationType fromCode(String code) {
        for (AuthenticationType value : values()) {
            if (NONE.equals(value))
                continue;

            if (value.getCode().equals(code)) {
                return value;
            }
        }
        return NONE;
    }
}
