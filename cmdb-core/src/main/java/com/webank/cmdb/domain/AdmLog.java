package com.webank.cmdb.domain;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_log database table.
 * 
 */
@Entity
@Table(name = "adm_log")
@NamedQuery(name = "AdmLog.findAll", query = "SELECT a FROM AdmLog a")
public class AdmLog implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idLog;
    private String requestUrl;
    private String guid;
    private String ciName;
    private Integer ciTypeId;
    private String ciTypeInstanceGuid;
    private String ciTypeName;
    private String createdAt;
    private String createdBy;
    private Timestamp createdDate;
    private String idAdmUser;
    private String logCat;
    private String logContent;
    private String operation;
    private String remark;
    private Integer status;
    private String updatedBy;
    private String updatedDate;
    private String clientHost;

    public AdmLog() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_log")
    public Integer getIdLog() {
        return this.idLog;
    }

    public void setIdLog(Integer idLog) {
        this.idLog = idLog;
    }

    @Column(name = "guid")
    public String getGuid() {
        return this.guid;
    }

    public void setGuid(String guid) {
        this.guid = guid;
    }

    @Column(name = "ci_name")
    public String getCiName() {
        return this.ciName;
    }

    public void setCiName(String ciName) {
        this.ciName = ciName;
    }

    @Column(name = "ci_type_id")
    public Integer getCiTypeId() {
        return this.ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    @Column(name = "ci_type_instance_guid")
    public String getCiTypeInstanceGuid() {
        return this.ciTypeInstanceGuid;
    }

    public void setCiTypeInstanceGuid(String ciTypeInstanceGuid) {
        this.ciTypeInstanceGuid = ciTypeInstanceGuid;
    }

    @Column(name = "ci_type_name")
    public String getCiTypeName() {
        return this.ciTypeName;
    }

    public void setCiTypeName(String ciTypeName) {
        this.ciTypeName = ciTypeName;
    }

    @Column(name = "created_at")
    public String getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    @Column(name = "created_by")
    public String getCreatedBy() {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    @Column(name = "created_date")
    public Timestamp getCreatedDate() {
        return this.createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Column(name = "id_adm_user")
    public String getIdAdmUser() {
        return this.idAdmUser;
    }

    public void setIdAdmUser(String idAdmUser) {
        this.idAdmUser = idAdmUser;
    }

    @Column(name = "log_cat")
    public String getLogCat() {
        return this.logCat;
    }

    public void setLogCat(String logCat) {
        this.logCat = logCat;
    }

    @Lob
    @Column(name = "log_content")
    public String getLogContent() {
        return this.logContent;
    }

    public void setLogContent(String logContent) {
        this.logContent = logContent;
    }

    public String getOperation() {
        return this.operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getRemark() {
        return this.remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getStatus() {
        return this.status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Column(name = "updated_by")
    public String getUpdatedBy() {
        return this.updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    @Column(name = "updated_date")
    public String getUpdatedDate() {
        return this.updatedDate;
    }

    public void setUpdatedDate(String updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Column(name = "request_url")
    public String getRequestUrl() {
        return requestUrl;
    }

    public void setRequestUrl(String requestUrl) {
        this.requestUrl = requestUrl;
    }

    @Column(name = "client_host")
    public String getClientHost() {
        return clientHost;
    }

    public void setClientHost(String clientHost) {
        this.clientHost = clientHost;
    }
}