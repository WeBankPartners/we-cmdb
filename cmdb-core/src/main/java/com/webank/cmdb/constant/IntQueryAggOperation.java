package com.webank.cmdb.constant;

public enum IntQueryAggOperation {
    None("none"), Create("create"), Update("update");

    private String code;

    private IntQueryAggOperation(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get IntQueryAggOperation from code
     * 
     * @param code The input type code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public IntQueryAggOperation fromCode(String code) {
        for (IntQueryAggOperation aggOperation : values()) {
            if (None.equals(aggOperation))
                continue;

            if (aggOperation.getCode().equals(code)) {
                return aggOperation;
            }
        }
        return None;
    }
}
