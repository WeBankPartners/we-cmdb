package com.webank.cmdb.constant;

public enum ImplementOperation {
    None("none"), Apply("apply"), Decommission("deco"), Revert("revert"), Update("update");

    private String code;

    private ImplementOperation(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get ImplementOperation from code
     * 
     * @param code The input ImplementOperation code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public ImplementOperation fromCode(String code) {
        for (ImplementOperation ciStatus : values()) {
            if (None.equals(ciStatus))
                continue;

            if (ciStatus.getCode().equals(code)) {
                return ciStatus;
            }
        }
        return None;
    }
}
