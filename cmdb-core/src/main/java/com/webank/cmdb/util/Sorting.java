package com.webank.cmdb.util;

public class Sorting {
    private boolean asc = true;
    private String field;

    public Sorting() {
    }

    public Sorting(Boolean asc, String field) {
        this.asc = asc;
        this.field = field;
    }

    public boolean getAsc() {
        return asc;
    }

    public void setAsc(boolean asc) {
        this.asc = asc;
    }

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }
}
