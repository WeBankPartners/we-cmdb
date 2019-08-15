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
 * The persistent class for the adm_template_ci_type_alias_uniq database table.
 * 
 */
@Entity
@Table(name = "adm_template_ci_type_alias_uniq")
@NamedQuery(name = "AdmTemplateCiTypeAliasUniq.findAll", query = "SELECT a FROM AdmTemplateCiTypeAliasUniq a")
public class AdmTemplateCiTypeAliasUniq implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idUniq;
    private Integer idAdmTemplateCiTypeAlias;
    private AdmAttrGroup admAttrGroup;
    private AdmCiTypeAttr admCiTypeAttr;

    public AdmTemplateCiTypeAliasUniq() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_uniq")
    public Integer getIdUniq() {
        return this.idUniq;
    }

    public void setIdUniq(Integer idUniq) {
        this.idUniq = idUniq;
    }

    @Column(name = "id_adm_template_ci_type_alias")
    public Integer getIdAdmTemplateCiTypeAlias() {
        return this.idAdmTemplateCiTypeAlias;
    }

    public void setIdAdmTemplateCiTypeAlias(Integer idAdmTemplateCiTypeAlias) {
        this.idAdmTemplateCiTypeAlias = idAdmTemplateCiTypeAlias;
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

}