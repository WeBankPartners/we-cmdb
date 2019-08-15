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
 * The persistent class for the adm_user_partner database table.
 * 
 */
@Entity
@Table(name = "adm_user_partner")
@NamedQuery(name = "AdmUserPartner.findAll", query = "SELECT a FROM AdmUserPartner a")
public class AdmUserPartner implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmUserPartner;
    private AdmPartner admPartner;
    private AdmUser admUser;

    public AdmUserPartner() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_user_partner")
    public Integer getIdAdmUserPartner() {
        return this.idAdmUserPartner;
    }

    public void setIdAdmUserPartner(Integer idAdmUserPartner) {
        this.idAdmUserPartner = idAdmUserPartner;
    }

    // bi-directional many-to-one association to AdmPartner
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_partner")
    public AdmPartner getAdmPartner() {
        return this.admPartner;
    }

    public void setAdmPartner(AdmPartner admPartner) {
        this.admPartner = admPartner;
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