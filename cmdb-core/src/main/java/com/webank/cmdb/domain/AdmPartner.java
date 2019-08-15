package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * The persistent class for the adm_partner database table.
 * 
 */
@Entity
@Table(name = "adm_partner")
@NamedQuery(name = "AdmPartner.findAll", query = "SELECT a FROM AdmPartner a")
public class AdmPartner implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmPartner;
    private String description;
    private String ip;
    private List<AdmUserPartner> admUserPartners;

    public AdmPartner() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_partner")
    public Integer getIdAdmPartner() {
        return this.idAdmPartner;
    }

    public void setIdAdmPartner(Integer idAdmPartner) {
        this.idAdmPartner = idAdmPartner;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIp() {
        return this.ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    // bi-directional many-to-one association to AdmUserPartner
    @OneToMany(mappedBy = "admPartner")
    public List<AdmUserPartner> getAdmUserPartners() {
        return this.admUserPartners;
    }

    public void setAdmUserPartners(List<AdmUserPartner> admUserPartners) {
        this.admUserPartners = admUserPartners;
    }

    public AdmUserPartner addAdmUserPartner(AdmUserPartner admUserPartner) {
        getAdmUserPartners().add(admUserPartner);
        admUserPartner.setAdmPartner(this);

        return admUserPartner;
    }

    public AdmUserPartner removeAdmUserPartner(AdmUserPartner admUserPartner) {
        getAdmUserPartners().remove(admUserPartner);
        admUserPartner.setAdmPartner(null);

        return admUserPartner;
    }

}