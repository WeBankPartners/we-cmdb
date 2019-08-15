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
 * The persistent class for the adm_integrate_template_relation database table.
 * 
 */
@Entity
@Table(name = "adm_integrate_template_relation")
@NamedQuery(name = "AdmIntegrateTemplateRelation.findAll", query = "SELECT a FROM AdmIntegrateTemplateRelation a")
public class AdmIntegrateTemplateRelation implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idRelation;
    private AdmCiTypeAttr admCiTypeAttr;
    private AdmIntegrateTemplateAlias childIntegrateTemplateAlias;
    private AdmIntegrateTemplateAlias parentIntegrateTemplateAlias;
    private Integer isReferedFromParent;

    private Integer childRefAttrId;

    public AdmIntegrateTemplateRelation() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_relation")
    public Integer getIdRelation() {
        return this.idRelation;
    }

    public void setIdRelation(Integer idRelation) {
        this.idRelation = idRelation;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "child_ref_attr_id")
    public AdmCiTypeAttr getAdmCiTypeAttr() {
        return this.admCiTypeAttr;
    }

    public void setAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        this.admCiTypeAttr = admCiTypeAttr;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateAlia
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "child_alias_id")
    public AdmIntegrateTemplateAlias getChildIntegrateTemplateAlias() {
        return this.childIntegrateTemplateAlias;
    }

    public void setChildIntegrateTemplateAlias(AdmIntegrateTemplateAlias childIntegrateTemplateAlias) {
        if (this.childIntegrateTemplateAlias == childIntegrateTemplateAlias)
            return;

        this.childIntegrateTemplateAlias = childIntegrateTemplateAlias;
        this.childIntegrateTemplateAlias.setParentIntegrateTemplateRelation(this);
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateAlia
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_alias_id")
    public AdmIntegrateTemplateAlias getParentIntegrateTemplateAlias() {
        return this.parentIntegrateTemplateAlias;
    }

    public void setParentIntegrateTemplateAlias(AdmIntegrateTemplateAlias parentIntegrateTemplateAlias) {
        this.parentIntegrateTemplateAlias = parentIntegrateTemplateAlias;
    }

    @Column(name = "child_ref_attr_id", updatable = false, insertable = false)
    public Integer getChildRefAttrId() {
        return childRefAttrId;
    }

    public void setChildRefAttrId(Integer childRefAttrId) {
        this.childRefAttrId = childRefAttrId;
    }

    @Column(name = "is_refered_from_parent")
    public Integer getIsReferedFromParent() {
        return isReferedFromParent;
    }

    public void setIsReferedFromParent(Integer isReferedFromParent) {
        this.isReferedFromParent = isReferedFromParent;
    }

}