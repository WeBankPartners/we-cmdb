package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class CiData {
    private Map<String, Object> data;
    private Meta meta = null;

    public CiData() {
    }

    public CiData(Map<String, Object> data, List<String> nextOperations) {
        this.data = data;
        this.meta = new Meta(nextOperations);
    }

    public static class Meta {
        private List<String> nextOperations = new LinkedList();

        public Meta() {
        }

        public Meta(List<String> nextOperations) {
            this.nextOperations = nextOperations;
        }

        public List<String> getNextOperations() {
            return nextOperations;
        }

        public void setNextOperations(List<String> nextOperations) {
            this.nextOperations = nextOperations;
        }
    }

    public Map<String, Object> getData() {
        return data;
    }

    public Object getValue(String name){
        return data.get(name);
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }

    public Meta getMeta() {
        return meta;
    }

    public void setMeta(Meta meta) {
        this.meta = meta;
    }

}
