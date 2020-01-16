package com.webank.cmdb.constant;

public enum FilterOperator {
    None("none"), In("in"), Contains("contains"), Equal("eq"), Greater("gt"), Less("lt"), NotEqual("ne"), NotNull("notNull"), Null("null"), GreaterEqual("gteq"), LessEqual("lteq"), NotEmpty("notEmpty"), Empty("empty");

    private String code;

    private FilterOperator(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get FilterOperator from code
     * 
     * @param code The input FilterOperator code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public FilterOperator fromCode(String code) {
        for (FilterOperator operator : values()) {
            if (None.equals(operator))
                continue;

            if (operator.getCode().equals(code)) {
                return operator;
            }
        }
        return None;
    }
}
