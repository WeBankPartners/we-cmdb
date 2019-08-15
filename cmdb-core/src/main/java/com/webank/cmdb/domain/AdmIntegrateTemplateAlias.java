package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 * The persistent class for the adm_integrate_template_alias database table.
 * 
 */
@Entity
@Table(name = "adm_integrate_template_alias")
@NamedQuery(name = "AdmIntegrateTemplateAlia.findAll", query = "SELECT a FROM AdmIntegrateTemplateAlias a")
public class AdmIntegrateTemplateAlias implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAlias;
    private String alias;
    private AdmCiType admCiType;
    private AdmIntegrateTemplate admIntegrateTemplate;
    private List<AdmIntegrateTemplateAliasAttr> admIntegrateTemplateAliasAttrs = new LinkedList<>();
    private List<AdmIntegrateTemplateRelation> childIntegrateTemplateRelations = new LinkedList<>();
    private AdmIntegrateTemplateRelation parentIntegrateTemplateRelation;
    private Integer ciTypeId;

    public AdmIntegrateTemplateAlias() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_alias")
    public Integer getIdAlias() {
        return this.idAlias;
    }

    public void setIdAlias(Integer idAlias) {
        this.idAlias = idAlias;
    }

    public String getAlias() {
        return this.alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    // bi-directional many-to-one association to AdmCiType
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_ci_type")
    public AdmCiType getAdmCiType() {
        return this.admCiType;
    }

    public void setAdmCiType(AdmCiType admCiType) {
        this.admCiType = admCiType;
        if (admCiType != null) {
            this.ciTypeId = admCiType.getIdAdmCiType();
        }
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

    // bi-directional many-to-one association to AdmIntegrateTemplateAliasAttr
    @OneToMany(mappedBy = "admIntegrateTemplateAlias")
    public List<AdmIntegrateTemplateAliasAttr> getAdmIntegrateTemplateAliasAttrs() {
        return this.admIntegrateTemplateAliasAttrs;
    }

    public void setAdmIntegrateTemplateAliasAttrs(List<AdmIntegrateTemplateAliasAttr> admIntegrateTemplateAliasAttrs) {
        this.admIntegrateTemplateAliasAttrs = admIntegrateTemplateAliasAttrs;
    }

    public AdmIntegrateTemplateAliasAttr addAdmIntegrateTemplateAliasAttr(AdmIntegrateTemplateAliasAttr admIntegrateTemplateAliasAttr) {
        getAdmIntegrateTemplateAliasAttrs().add(admIntegrateTemplateAliasAttr);
        admIntegrateTemplateAliasAttr.setAdmIntegrateTemplateAlias(this);

        return admIntegrateTemplateAliasAttr;
    }

    public AdmIntegrateTemplateAliasAttr removeAdmIntegrateTemplateAliasAttr(AdmIntegrateTemplateAliasAttr admIntegrateTemplateAliasAttr) {
        getAdmIntegrateTemplateAliasAttrs().remove(admIntegrateTemplateAliasAttr);
        admIntegrateTemplateAliasAttr.setAdmIntegrateTemplateAlias(null);

        return admIntegrateTemplateAliasAttr;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateRelation
    @OneToMany(mappedBy = "parentIntegrateTemplateAlias")
    public List<AdmIntegrateTemplateRelation> getChildIntegrateTemplateRelations() {
        return this.childIntegrateTemplateRelations;
    }

    public void setChildIntegrateTemplateRelations(List<AdmIntegrateTemplateRelation> childIntegrateTemplateRelations) {
        this.childIntegrateTemplateRelations = childIntegrateTemplateRelations;
    }

    public AdmIntegrateTemplateRelation addChildIntegrateTemplateRelation(AdmIntegrateTemplateRelation childIntegrateTemplateRelation) {
        getChildIntegrateTemplateRelations().add(childIntegrateTemplateRelation);
        childIntegrateTemplateRelation.setParentIntegrateTemplateAlias(this);

        return childIntegrateTemplateRelation;
    }

    public AdmIntegrateTemplateRelation removeChildIntegrateTemplateRelation(AdmIntegrateTemplateRelation childIntegrateTemplateRelation) {
        getChildIntegrateTemplateRelations().remove(childIntegrateTemplateRelation);
        childIntegrateTemplateRelation.setParentIntegrateTemplateAlias(null);

        return childIntegrateTemplateRelation;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateRelation
    @OneToOne(mappedBy = "childIntegrateTemplateAlias")
    public AdmIntegrateTemplateRelation getParentIntegrateTemplateRelation() {
        return this.parentIntegrateTemplateRelation;
    }

    public void setParentIntegrateTemplateRelation(AdmIntegrateTemplateRelation parentIntegrateTemplateRelation) {
        if (this.parentIntegrateTemplateRelation == parentIntegrateTemplateRelation) {
            return;
        }
        this.parentIntegrateTemplateRelation = parentIntegrateTemplateRelation;
        if (parentIntegrateTemplateRelation != null) {
            parentIntegrateTemplateRelation.setChildIntegrateTemplateAlias(this);
        }
    }

    @Column(name = "id_adm_ci_type", updatable = false, insertable = false)
    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    /*
     * public AdmIntegrateTemplateRelation
     * addParentIntegrateTemplateRelation(AdmIntegrateTemplateRelation
     * parentIntegrateTemplateRelation) {
     * getParentIntegrateTemplateRelations().add(parentIntegrateTemplateRelation);
     * parentIntegrateTemplateRelation.setChildIntegrateTemplateAlias(this);
     * 
     * return parentIntegrateTemplateRelation; }
     * 
     * public AdmIntegrateTemplateRelation
     * removeParentIntegrateTemplateRelation(AdmIntegrateTemplateRelation
     * parentIntegrateTemplateRelation) {
     * getParentIntegrateTemplateRelations().remove(parentIntegrateTemplateRelation)
     * ; parentIntegrateTemplateRelation.setChildIntegrateTemplateAlias(null);
     * 
     * return parentIntegrateTemplateRelation; }
     */

}