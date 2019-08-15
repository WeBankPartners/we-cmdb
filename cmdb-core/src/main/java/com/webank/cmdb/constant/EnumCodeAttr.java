package com.webank.cmdb.constant;

public enum EnumCodeAttr {
    None("none"), Id("id"), Code("code"), Value("value"), GroupCodeId("groupCodeId");

    private String code;

    private EnumCodeAttr(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public EnumCodeAttr fromCode(String code) {
        for (EnumCodeAttr codeAttr : values()) {
            if (None.equals(codeAttr))
                continue;

            if (codeAttr.getCode().equals(code)) {
                return codeAttr;
            }
        }
        return None;
    }
}