package com.webank.cmdb.constant;

public enum StateOperation {
    None("none"), Insert("insert"), Delete("delete"), Update("update"), Discard("discard"), Confirm("confirm"), Startup("startup"), Stop("stop");

    private String code;

    private StateOperation(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get StateOperation from code
     * 
     * @param code The input StateAction code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public StateOperation fromCode(String code) {
        for (StateOperation operator : values()) {
            if (None.equals(operator))
                continue;

            if (operator.getCode().equals(code)) {
                return operator;
            }
        }
        return None;
    }
}
