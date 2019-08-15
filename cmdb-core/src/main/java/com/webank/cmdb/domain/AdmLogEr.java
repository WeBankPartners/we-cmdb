package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_log_er database table.
 * 
 */
@Entity
@Table(name = "adm_log_er")
@NamedQuery(name = "AdmLogEr.findAll", query = "SELECT a FROM AdmLogEr a")
public class AdmLogEr implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String ciTypeInstanceGuid;
    private Integer idAdmCiType;
    private String operation;

    public AdmLogEr() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Column(name = "ci_type_instance_guid")
    public String getCiTypeInstanceGuid() {
        return this.ciTypeInstanceGuid;
    }

    public void setCiTypeInstanceGuid(String ciTypeInstanceGuid) {
        this.ciTypeInstanceGuid = ciTypeInstanceGuid;
    }

    @Column(name = "id_adm_ci_type")
    public Integer getIdAdmCiType() {
        return this.idAdmCiType;
    }

    public void setIdAdmCiType(Integer idAdmCiType) {
        this.idAdmCiType = idAdmCiType;
    }

    public String getOperation() {
        return this.operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

}