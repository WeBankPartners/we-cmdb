package com.webank.plugins.wecmdb.dto.wecube;


import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class QueryRequest {
    protected List<Filter> additionalFilters = new LinkedList<>();
    protected Criteria criteria = new Criteria();

    public List<Filter> getAdditionalFilters() {
        return additionalFilters;
    }

    public void setAdditionalFilters(List<Filter> additionalFilters) {
        this.additionalFilters = additionalFilters;
    }

    public Criteria getCriteria() {
        return criteria;
    }

    public void setCriteria(Criteria criteria) {
        this.criteria = criteria;
    }

    public class Criteria {
        private String attrName;
        private String condition;

        public Criteria() {
        }

        public Criteria(String attrName, String condition) {
            this.attrName = attrName;
            this.condition = condition;
        }

        public String getAttrName() {
            return attrName;
        }

        public void setAttrName(String attrName) {
            this.attrName = attrName;
        }

        public String getCondition() {
            return condition;
        }

        public void setCondition(String condition) {
            this.condition = condition;
        }
    }

    public QueryRequest addEqualsFilter(String name, Object value) {
        additionalFilters.add(new Filter(name, "eq", value));
        return this;
    }

    public QueryRequest addEqualsFilters(Map<String, Object> filterObject) {
        filterObject.entrySet().forEach(entry -> additionalFilters.add(new Filter(entry.getKey(), "eq", entry.getValue())));
        return this;
    }

    public QueryRequest addInFilters(Map<String, Object> filterObject) {
        filterObject.entrySet().forEach(entry -> additionalFilters.add(new Filter(entry.getKey(), "in", entry.getValue())));
        return this;
    }

    public QueryRequest addNotEqualsFilter(String name, Object value) {
        additionalFilters.add(new Filter(name, "ne", value));
        return this;
    }

    public QueryRequest addInFilter(String name, List values) {
        additionalFilters.add(new Filter(name, "in", values));
        return this;
    }

    public QueryRequest addContainsFilter(String name, String value) {
        additionalFilters.add(new Filter(name, "contains", value));
        return this;
    }

    public QueryRequest addNotNullFilter(String name) {
        additionalFilters.add(new Filter(name, "notNull", null));
        return this;
    }

    public QueryRequest addNullFilter(String name) {
        additionalFilters.add(new Filter(name, "null", null));
        return this;
    }
    
    public QueryRequest addNotEmptyFilter(String name) {
        additionalFilters.add(new Filter(name, "notEmpty", null));
        return this;
    }
    
    public QueryRequest addEmptyFilter(String name) {
        additionalFilters.add(new Filter(name, "empty", null));
        return this;
    }

    public static QueryRequest defaultQueryObject() {
        return new QueryRequest();
    }

    public static QueryRequest defaultQueryObject(String name, Object value) {
        return defaultQueryObject().addEqualsFilter(name, value);
    }
}
