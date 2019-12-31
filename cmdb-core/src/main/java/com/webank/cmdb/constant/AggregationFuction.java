package com.webank.cmdb.constant;

public enum AggregationFuction {
    None("none"), MAX("max"), MIN("min"), AVG("avg"), SUM("sum"), COUNT("count");

    private String code;

    private AggregationFuction(String code) {
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
    static public AggregationFuction fromCode(String code) {
        for (AggregationFuction operator : values()) {
            if (None.equals(operator))
                continue;

            if (operator.getCode().equals(code)) {
                return operator;
            }
        }
        return None;
    }
}
