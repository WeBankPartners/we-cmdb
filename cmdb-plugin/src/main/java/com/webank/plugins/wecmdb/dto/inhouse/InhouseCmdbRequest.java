package com.webank.plugins.wecmdb.dto.inhouse;

import java.util.List;
import java.util.Map;

public class InhouseCmdbRequest {

    private String type;
    private String userAuthKey;
    private String action;
    private Integer limitRowCount;
    private List<Object> filters;
    private Map<String, Object> filter;
    private List<Map<String, Object>> parameters;
    private Map<String, Object> parameter;
    private List<String> resultColumn;
    private Map<String, String> orderby;
    private Object isPaging;
    private Object startIndex;
    private Object pageSize;
    private Boolean isFaultTolerant;
    private List<String> upsertKey;
    private Map<String, Object> defaultFilter;
    private Map<String, Object> dropdownlist;
    private List<String> quickModeKey;
    private String quickModeType;
    private String refDataMode;
    private Boolean noContent;
    private String template;
    private Boolean enableDefaultTemplate;
    private String remark;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUserAuthKey() {
        return userAuthKey;
    }

    public void setUserAuthKey(String userAuthKey) {
        this.userAuthKey = userAuthKey;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Integer getLimitRowCount() {
        return limitRowCount;
    }

    public void setLimitRowCount(Integer limitRowCount) {
        this.limitRowCount = limitRowCount;
    }

    public List<Map<String, Object>> getParameters() {
        return parameters;
    }

    public void setParameters(List<Map<String, Object>> parameters) {
        this.parameters = parameters;
    }

    public Map<String, Object> getParameter() {
        return parameter;
    }

    public void setParameter(Map<String, Object> parameter) {
        this.parameter = parameter;
    }

    public List<String> getResultColumn() {
        return resultColumn;
    }

    public void setResultColumn(List<String> resultColumn) {
        this.resultColumn = resultColumn;
    }

    public Map<String, String> getOrderby() {
        return orderby;
    }

    public void setOrderby(Map<String, String> orderby) {
        this.orderby = orderby;
    }

    public Object getIsPaging() {
        return isPaging;
    }

    public void setIsPaging(Object isPaging) {
        this.isPaging = isPaging;
    }

    public Object getStartIndex() {
        return startIndex;
    }

    public void setStartIndex(Object startIndex) {
        this.startIndex = startIndex;
    }

    public Object getPageSize() {
        return pageSize;
    }

    public void setPageSize(Object pageSize) {
        this.pageSize = pageSize;
    }

    public Boolean getIsFaultTolerant() {
        return isFaultTolerant;
    }

    public void setIsFaultTolerant(Boolean isFaultTolerant) {
        this.isFaultTolerant = isFaultTolerant;
    }

    public List<String> getUpsertKey() {
        return upsertKey;
    }

    public void setUpsertKey(List<String> upsertKey) {
        this.upsertKey = upsertKey;
    }

    public Map<String, Object> getDefaultFilter() {
        return defaultFilter;
    }

    public void setDefaultFilter(Map<String, Object> defaultFilter) {
        this.defaultFilter = defaultFilter;
    }

    public Map<String, Object> getDropdownlist() {
        return dropdownlist;
    }

    public void setDropdownlist(Map<String, Object> dropdownlist) {
        this.dropdownlist = dropdownlist;
    }

    public List<String> getQuickModeKey() {
        return quickModeKey;
    }

    public void setQuickModeKey(List<String> quickModeKey) {
        this.quickModeKey = quickModeKey;
    }

    public String getQuickModeType() {
        return quickModeType;
    }

    public void setQuickModeType(String quickModeType) {
        this.quickModeType = quickModeType;
    }

    public String getRefDataMode() {
        return refDataMode;
    }

    public void setRefDataMode(String refDataMode) {
        this.refDataMode = refDataMode;
    }

    public Boolean getNoContent() {
        return noContent;
    }

    public void setNoContent(Boolean noContent) {
        this.noContent = noContent;
    }

    public String getTemplate() {
        return template;
    }

    public void setTemplate(String template) {
        this.template = template;
    }

    public Boolean getEnableDefaultTemplate() {
        return enableDefaultTemplate;
    }

    public void setEnableDefaultTemplate(Boolean enableDefaultTemplate) {
        this.enableDefaultTemplate = enableDefaultTemplate;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public List<Object> getFilters() {
        return filters;
    }

    public void setFilters(List<Object> filters) {
        this.filters = filters;
    }

    public Map<String, Object> getFilter() {
        return filter;
    }

    public void setFilter(Map<String, Object> filter) {
        this.filter = filter;
    }

}
