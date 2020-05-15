package com.webank.cmdb.dto;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.webank.cmdb.domain.AdmLog;
import com.webank.cmdb.util.DtoField;

public class LogDto extends BasicResourceDto<LogDto, AdmLog> {
    private String guid;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Shanghai")
    private Date createdDate;
    @DtoField(domainField = "idAdmUser")
    private String user;
    private String logCat;
    private String logContent;
    private String operation;
    private String remark;
    private int status;
    private String requestUrl;
    private String clientHost;
    private String ciName;

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getLogCat() {
        return logCat;
    }

    public void setLogCat(String logCat) {
        this.logCat = logCat;
    }

    public String getLogContent() {
        return logContent;
    }

    public void setLogContent(String logContent) {
        this.logContent = logContent;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getGuid() {
        return guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    public String getRequestUrl() {
        return requestUrl;
    }

    public void setRequestUrl(String requestUrl) {
        this.requestUrl = requestUrl;
    }

    public String getClientHost() {
        return clientHost;
    }

    public void setClientHost(String clientHost) {
        this.clientHost = clientHost;
    }

    public String getCiName() {
        return ciName;
    }

    public void setCiName(String ciName) {
        this.ciName = ciName;
    }

    @Override
    public LogDto fromDomain(AdmLog domain, List<String> refResource) {
        LogDto dto = new LogDto();
        dto.setCreatedDate(domain.getCreatedDate());
        dto.setGuid(domain.getGuid());
        dto.setLogCat(domain.getLogCat());
        dto.setLogContent(domain.getLogContent());
        dto.setOperation(domain.getOperation());
        dto.setRemark(domain.getRemark());
        dto.setStatus(domain.getStatus());
        dto.setUser(domain.getIdAdmUser());
        dto.setRequestUrl(domain.getRequestUrl());
        dto.setClientHost(domain.getClientHost());
        dto.setCiName(domain.getCiName());
        return dto;
    }

    @Override
    public Class<AdmLog> domainClazz() {
        return AdmLog.class;
    }
}
