package com.webank.cmdb.constant;

public enum ReferenceType {
    None("none"), Association("association"), Composition("composition"), Aggregation("aggregation"), Dependence("dependence");

    private String code;

    private ReferenceType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get ReferenceType from code
     * 
     * @param code The input ReferenceType code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public ReferenceType fromCode(String code) {
        for (ReferenceType referenceType : values()) {
            if (None.equals(referenceType))
                continue;

            if (referenceType.getCode().equals(code)) {
                return referenceType;
            }
        }
        return None;
    }
}
