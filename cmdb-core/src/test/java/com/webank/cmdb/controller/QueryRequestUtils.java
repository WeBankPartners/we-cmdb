package com.webank.cmdb.controller;

import java.util.List;
import java.util.Map;

import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.util.Pageable;
import com.webank.cmdb.util.Sorting;

public class QueryRequestUtils extends QueryRequest {

    public QueryRequestUtils addEqualsFilter(String name, Object value) {
        getFilters().add(new Filter(name, "eq", value));
        return this;
    }

    public QueryRequestUtils addEqualsFilters(Map<String, Object> filterObject) {
        getFilters().forEach(entry -> filters.add(new Filter(entry.getName(), "eq", entry.getValue())));
        return this;
    }

    public QueryRequestUtils addInFilters(Map<String, Object> filterObject) {
        filterObject.entrySet()
                .forEach(entry -> filters.add(new Filter(entry.getKey(), "in", entry.getValue())));
        return this;
    }

    public QueryRequestUtils addNotEqualsFilter(String name, Object value) {
        filters.add(new Filter(name, "ne", value));
        return this;
    }

    public QueryRequestUtils addInFilter(String name, List values) {
        filters.add(new Filter(name, "in", values));
        return this;
    }

    public QueryRequestUtils addContainsFilter(String name, String value) {
        filters.add(new Filter(name, "contains", value));
        return this;
    }

    public QueryRequestUtils addNotNullFilter(String name) {
        filters.add(new Filter(name, "notNull", null));
        return this;
    }

    public QueryRequestUtils addNullFilter(String name) {
        filters.add(new Filter(name, "null", null));
        return this;
    }

    public QueryRequestUtils ascendingSortBy(String field) {
        sorting = new Sorting(true, field);
        return this;
    }

    public QueryRequestUtils descendingSortBy(String field) {
        sorting = new Sorting(false, field);
        return this;
    }

    public QueryRequestUtils withReferenceResource(String refResource) {
        refResources.add(refResource);
        return this;
    }

    public QueryRequestUtils withResultColumns(List<String> resultColumns) {
        this.resultColumns = resultColumns;
        return this;
    }

    public QueryRequestUtils withPaging(boolean isPaging) {
        this.paging = isPaging;
        return this;
    }

    public QueryRequestUtils withPagable(int startIndex, int pageSize) {
        Pageable pageable = new Pageable();
        pageable.setPageSize(pageSize);
        pageable.setStartIndex(startIndex);

        this.pageable = pageable;
        this.paging = true;
        return this;
    }

    public static QueryRequestUtils defaultQueryObject() {
        return new QueryRequestUtils();
    }

    public static QueryRequestUtils defaultQueryObject(String name, Object value) {
        return defaultQueryObject().addEqualsFilter(name, value);
    }

}
