package com.webank.cmdb.constant;

public enum IntegrateTemplateType {
    None("none"), ExternalIntegrate("externalIntegrate"), InternalIntegrate("internalIntegrate");

    private String code;

    private IntegrateTemplateType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public IntegrateTemplateType fromCode(String code) {
        for (IntegrateTemplateType ciStatus : values()) {
            if (None.equals(ciStatus))
                continue;

            if (ciStatus.getCode().equals(code)) {
                return ciStatus;
            }
        }
        return None;
    }
}
