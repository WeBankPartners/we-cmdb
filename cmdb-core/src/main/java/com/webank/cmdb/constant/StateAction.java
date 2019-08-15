package com.webank.cmdb.constant;

public enum StateAction {
    None("none"), Insert("insert"), InsertUpdate("insert-update"), Delete("delete"), UpdateDelete("update-delete"), Update("update"), Confirm("confirm");

    private String code;

    private StateAction(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get StateAction from code
     * 
     * @param code The input StateAction code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public StateAction fromCode(String code) {
        for (StateAction operator : values()) {
            if (None.equals(operator))
                continue;

            if (operator.getCode().equals(code)) {
                return operator;
            }
        }
        return None;
    }
}
