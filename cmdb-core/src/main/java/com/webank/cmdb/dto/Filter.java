package com.webank.cmdb.dto;

import javax.validation.constraints.NotNull;

public class Filter {
    @NotNull
    private String name = null;
    @NotNull
    private String operator = null;
    @NotNull
    private Object value = null;

    private Object type = null;


    public Filter() {
    }

    public Filter(String name, String operator, Object value,String... type) {
        this.name = name;
        this.operator = operator;
        this.value = value;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public Object getType() {
        return type;
    }

    public void setType(Object type) {
        this.type = type;
    }
}
