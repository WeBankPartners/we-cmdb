package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class QueryHeader {
    private String name;
    private String inputType;
    private List<?> vals = new LinkedList<>();

    public QueryHeader(String name, String inputType) {
        this(name, inputType, null);
    }

    public QueryHeader(String name, String inputType, List<?> vals) {
        this.name = name;
        this.inputType = inputType;
        this.vals = vals;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getInputType() {
        return inputType;
    }

    public void setInputType(String inputType) {
        this.inputType = inputType;
    }

    public List<?> getVals() {
        return vals;
    }

    public void setVals(List<?> vals) {
        this.vals = vals;
    }

}
