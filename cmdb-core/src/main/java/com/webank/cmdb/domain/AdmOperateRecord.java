package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * The persistent class for the adm_operate_record database table.
 * 
 */
@Entity
@Table(name = "adm_operate_record")
@NamedQuery(name = "AdmOperateRecord.findAll", query = "SELECT a FROM AdmOperateRecord a")
public class AdmOperateRecord implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String action;
    private Integer contentBytes;
    private Integer contentRows;
    private String hostIp;
    private String ip;
    private String jsonObjStr;
    private Date recordTime;
    private Date startTime;
    private Integer timeSpend;
    private String type;
    private String uri;
    private String userId;

    public AdmOperateRecord() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAction() {
        return this.action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    @Column(name = "content_bytes")
    public Integer getContentBytes() {
        return this.contentBytes;
    }

    public void setContentBytes(Integer contentBytes) {
        this.contentBytes = contentBytes;
    }

    @Column(name = "content_rows")
    public Integer getContentRows() {
        return this.contentRows;
    }

    public void setContentRows(Integer contentRows) {
        this.contentRows = contentRows;
    }

    @Column(name = "host_ip")
    public String getHostIp() {
        return this.hostIp;
    }

    public void setHostIp(String hostIp) {
        this.hostIp = hostIp;
    }

    public String getIp() {
        return this.ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    @Lob
    @Column(name = "json_obj_str")
    public String getJsonObjStr() {
        return this.jsonObjStr;
    }

    public void setJsonObjStr(String jsonObjStr) {
        this.jsonObjStr = jsonObjStr;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "record_time")
    public Date getRecordTime() {
        return this.recordTime;
    }

    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time")
    public Date getStartTime() {
        return this.startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    @Column(name = "time_spend")
    public Integer getTimeSpend() {
        return this.timeSpend;
    }

    public void setTimeSpend(Integer timeSpend) {
        this.timeSpend = timeSpend;
    }

    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUri() {
        return this.uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    @Column(name = "user_id")
    public String getUserId() {
        return this.userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

}