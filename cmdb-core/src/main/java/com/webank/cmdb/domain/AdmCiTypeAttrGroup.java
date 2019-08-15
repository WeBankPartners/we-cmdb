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
 * The persistent class for the adm_ci_type_attr_group database table.
 * 
 */
@Entity
@Table(name = "adm_ci_type_attr_group")
@NamedQuery(name = "AdmCiTypeAttrGroup.findAll", query = "SELECT a FROM AdmCiTypeAttrGroup a")
public class AdmCiTypeAttrGroup implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmCiTypeAttrGroup;
    private AdmAttrGroup admAttrGroup;
    private AdmCiTypeAttr admCiTypeAttr;
    private Integer ciTypeAttrId;

    public AdmCiTypeAttrGroup() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_ci_type_attr_group")
    public Integer getIdAdmCiTypeAttrGroup() {
        return this.idAdmCiTypeAttrGroup;
    }

    public void setIdAdmCiTypeAttrGroup(Integer idAdmCiTypeAttrGroup) {
        this.idAdmCiTypeAttrGroup = idAdmCiTypeAttrGroup;
    }

    // bi-directional many-to-one association to AdmAttrGroup
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_attr_group")
    public AdmAttrGroup getAdmAttrGroup() {
        return this.admAttrGroup;
    }

    public void setAdmAttrGroup(AdmAttrGroup admAttrGroup) {
        this.admAttrGroup = admAttrGroup;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_ci_type_attr")
    public AdmCiTypeAttr getAdmCiTypeAttr() {
        return this.admCiTypeAttr;
    }

    public void setAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        this.admCiTypeAttr = admCiTypeAttr;
    }

    @Column(name = "id_adm_ci_type_attr", insertable = false, updatable = false)
    public Integer getCiTypeAttrId() {
        return ciTypeAttrId;
    }

    public void setCiTypeAttrId(Integer ciTypeAttrId) {
        this.ciTypeAttrId = ciTypeAttrId;
    }

}