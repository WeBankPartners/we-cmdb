package com.webank.cmdb.domain;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_integrate_query database table.
 * 
 */
@Entity
@Table(name = "adm_integrate_query")
@NamedQuery(name = "AdmIntegrateQuery.findAll", query = "SELECT a FROM AdmIntegrateQuery a")
public class AdmIntegrateQuery implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer queryId;
    private Integer ciTypeId;
    private Timestamp creatTime;
    private String creator;
    private String queryName;
    private Timestamp updateTime;
    private String updator;

    public AdmIntegrateQuery() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "query_id")
    public Integer getQueryId() {
        return this.queryId;
    }

    public void setQueryId(Integer queryId) {
        this.queryId = queryId;
    }

    @Column(name = "ci_type_id")
    public Integer getCiTypeId() {
        return this.ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    @Column(name = "creat_time")
    public Timestamp getCreatTime() {
        return this.creatTime;
    }

    public void setCreatTime(Timestamp creatTime) {
        this.creatTime = creatTime;
    }

    public String getCreator() {
        return this.creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    @Column(name = "query_name")
    public String getQueryName() {
        return this.queryName;
    }

    public void setQueryName(String queryName) {
        this.queryName = queryName;
    }

    @Column(name = "update_time")
    public Timestamp getUpdateTime() {
        return this.updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdator() {
        return this.updator;
    }

    public void setUpdator(String updator) {
        this.updator = updator;
    }

}