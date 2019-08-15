package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_template database table.
 * 
 */
@Entity
@Table(name = "adm_template")
@NamedQuery(name = "AdmTemplate.findAll", query = "SELECT a FROM AdmTemplate a")
public class AdmTemplate implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmTemplate;
    private Integer isActive;
    private String name;
    private AdmCiType admCiType;

    public AdmTemplate() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_template")
    public Integer getIdAdmTemplate() {
        return this.idAdmTemplate;
    }

    public void setIdAdmTemplate(Integer idAdmTemplate) {
        this.idAdmTemplate = idAdmTemplate;
    }

    public Integer getIsActive() {
        return this.isActive;
    }

    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // bi-directional many-to-one association to AdmCiType
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_ci_type")
    public AdmCiType getAdmCiType() {
        return this.admCiType;
    }

    public void setAdmCiType(AdmCiType admCiType) {
        this.admCiType = admCiType;
    }

}