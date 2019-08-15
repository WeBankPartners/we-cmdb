package com.webank.cmdb.constant;

public enum FilterRelationship {
    None("none"), And("and"), Or("or");

    private String code;

    private FilterRelationship(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get FilterRelationship from code
     * 
     * @param code The input FilterRelationship code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public FilterRelationship fromCode(String code) {
        for (FilterRelationship filterRs : values()) {
            if (None.equals(filterRs))
                continue;

            if (filterRs.getCode().equals(code)) {
                return filterRs;
            }
        }
        return None;
    }
}
