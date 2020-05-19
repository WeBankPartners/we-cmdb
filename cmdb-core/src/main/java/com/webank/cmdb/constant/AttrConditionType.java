package com.webank.cmdb.constant;

public enum AttrConditionType {
    Expression("Expression"), Select("Select"), None("none");

    private String code;

    private AttrConditionType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public AttrConditionType fromCode(String code) {
        for (AttrConditionType operator : values()) {
            if (None.equals(operator))
                continue;

            if (operator.getCode().equals(code)) {
                return operator;
            }
        }
        return None;
    }

    public boolean codeEquals(String anCode){
        return this.code.equalsIgnoreCase(anCode);
    }
}
