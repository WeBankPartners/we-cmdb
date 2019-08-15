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
 * The persistent class for the adm_template_ci_type database table.
 * 
 */
@Entity
@Table(name = "adm_template_ci_type")
@NamedQuery(name = "AdmTemplateCiType.findAll", query = "SELECT a FROM AdmTemplateCiType a")
public class AdmTemplateCiType implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmTemplateCitype;
    private Integer childCiTypeAliasId;
    private Integer idAdmTemplate;
    private Integer parentCiTypeAliasId;
    private AdmCiTypeAttr admCiTypeAttr;

    public AdmTemplateCiType() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_template_citype")
    public Integer getIdAdmTemplateCitype() {
        return this.idAdmTemplateCitype;
    }

    public void setIdAdmTemplateCitype(Integer idAdmTemplateCitype) {
        this.idAdmTemplateCitype = idAdmTemplateCitype;
    }

    @Column(name = "child_ci_type_alias_id")
    public Integer getChildCiTypeAliasId() {
        return this.childCiTypeAliasId;
    }

    public void setChildCiTypeAliasId(Integer childCiTypeAliasId) {
        this.childCiTypeAliasId = childCiTypeAliasId;
    }

    @Column(name = "id_adm_template")
    public Integer getIdAdmTemplate() {
        return this.idAdmTemplate;
    }

    public void setIdAdmTemplate(Integer idAdmTemplate) {
        this.idAdmTemplate = idAdmTemplate;
    }

    @Column(name = "parent_ci_type_alias_id")
    public Integer getParentCiTypeAliasId() {
        return this.parentCiTypeAliasId;
    }

    public void setParentCiTypeAliasId(Integer parentCiTypeAliasId) {
        this.parentCiTypeAliasId = parentCiTypeAliasId;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "child_ci_type_ref_attr_id")
    public AdmCiTypeAttr getAdmCiTypeAttr() {
        return this.admCiTypeAttr;
    }

    public void setAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        this.admCiTypeAttr = admCiTypeAttr;
    }

}