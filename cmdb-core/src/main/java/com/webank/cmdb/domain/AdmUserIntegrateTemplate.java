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
 * The persistent class for the adm_user_integrate_template database table.
 * 
 */
@Entity
@Table(name = "adm_user_integrate_template")
@NamedQuery(name = "AdmUserIntegrateTemplate.findAll", query = "SELECT a FROM AdmUserIntegrateTemplate a")
public class AdmUserIntegrateTemplate implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmUserIntegrateTemplate;
    private AdmIntegrateTemplate admIntegrateTemplate;
    private AdmUser admUser;

    public AdmUserIntegrateTemplate() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_user_integrate_template")
    public Integer getIdAdmUserIntegrateTemplate() {
        return this.idAdmUserIntegrateTemplate;
    }

    public void setIdAdmUserIntegrateTemplate(Integer idAdmUserIntegrateTemplate) {
        this.idAdmUserIntegrateTemplate = idAdmUserIntegrateTemplate;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplate
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_integrate_template")
    public AdmIntegrateTemplate getAdmIntegrateTemplate() {
        return this.admIntegrateTemplate;
    }

    public void setAdmIntegrateTemplate(AdmIntegrateTemplate admIntegrateTemplate) {
        this.admIntegrateTemplate = admIntegrateTemplate;
    }

    // bi-directional many-to-one association to AdmUser
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_user")
    public AdmUser getAdmUser() {
        return this.admUser;
    }

    public void setAdmUser(AdmUser admUser) {
        this.admUser = admUser;
    }

}