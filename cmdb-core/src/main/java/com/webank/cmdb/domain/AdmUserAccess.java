package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * The persistent class for the adm_user_access database table.
 * 
 */
@Entity
@Table(name = "adm_user_access")
@NamedQuery(name = "AdmUserAccess.findAll", query = "SELECT a FROM AdmUserAccess a")
public class AdmUserAccess implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private Date accTime;
    private String accUrl;
    private String userId;

    public AdmUserAccess() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "acc_time")
    public Date getAccTime() {
        return this.accTime;
    }

    public void setAccTime(Date accTime) {
        this.accTime = accTime;
    }

    @Column(name = "acc_url")
    public String getAccUrl() {
        return this.accUrl;
    }

    public void setAccUrl(String accUrl) {
        this.accUrl = accUrl;
    }

    @Column(name = "user_id")
    public String getUserId() {
        return this.userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

}