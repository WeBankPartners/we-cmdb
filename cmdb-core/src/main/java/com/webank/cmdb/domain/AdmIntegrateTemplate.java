package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.LinkedList;
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
 * The persistent class for the adm_integrate_template database table.
 * 
 */
@Entity
@Table(name = "adm_integrate_template")
@NamedQuery(name = "AdmIntegrateTemplate.findAll", query = "SELECT a FROM AdmIntegrateTemplate a")
public class AdmIntegrateTemplate implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmIntegrateTemplate;
    private String des;
    private String name;
    private List<AdmIntegrateTemplateAlias> admIntegrateTemplateAlias = new LinkedList<>();
    private List<AdmUserIntegrateTemplate> admUserIntegrateTemplates = new LinkedList<>();
    private Integer ciTypeId;

    public AdmIntegrateTemplate() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_integrate_template")
    public Integer getIdAdmIntegrateTemplate() {
        return this.idAdmIntegrateTemplate;
    }

    public void setIdAdmIntegrateTemplate(Integer idAdmIntegrateTemplate) {
        this.idAdmIntegrateTemplate = idAdmIntegrateTemplate;
    }

    public String getDes() {
        return this.des;
    }

    public void setDes(String des) {
        this.des = des;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateAlia
    @OneToMany(mappedBy = "admIntegrateTemplate")
    public List<AdmIntegrateTemplateAlias> getAdmIntegrateTemplateAlias() {
        return this.admIntegrateTemplateAlias;
    }

    public void setAdmIntegrateTemplateAlias(List<AdmIntegrateTemplateAlias> admIntegrateTemplateAlias) {
        this.admIntegrateTemplateAlias = admIntegrateTemplateAlias;
    }

    public AdmIntegrateTemplateAlias addAdmIntegrateTemplateAlia(AdmIntegrateTemplateAlias admIntegrateTemplateAlia) {
        getAdmIntegrateTemplateAlias().add(admIntegrateTemplateAlia);
        admIntegrateTemplateAlia.setAdmIntegrateTemplate(this);

        return admIntegrateTemplateAlia;
    }

    public AdmIntegrateTemplateAlias removeAdmIntegrateTemplateAlia(AdmIntegrateTemplateAlias admIntegrateTemplateAlia) {
        getAdmIntegrateTemplateAlias().remove(admIntegrateTemplateAlia);
        admIntegrateTemplateAlia.setAdmIntegrateTemplate(null);

        return admIntegrateTemplateAlia;
    }

    // bi-directional many-to-one association to AdmUserIntegrateTemplate
    @OneToMany(mappedBy = "admIntegrateTemplate")
    public List<AdmUserIntegrateTemplate> getAdmUserIntegrateTemplates() {
        return this.admUserIntegrateTemplates;
    }

    public void setAdmUserIntegrateTemplates(List<AdmUserIntegrateTemplate> admUserIntegrateTemplates) {
        this.admUserIntegrateTemplates = admUserIntegrateTemplates;
    }

    public AdmUserIntegrateTemplate addAdmUserIntegrateTemplate(AdmUserIntegrateTemplate admUserIntegrateTemplate) {
        getAdmUserIntegrateTemplates().add(admUserIntegrateTemplate);
        admUserIntegrateTemplate.setAdmIntegrateTemplate(this);

        return admUserIntegrateTemplate;
    }

    public AdmUserIntegrateTemplate removeAdmUserIntegrateTemplate(AdmUserIntegrateTemplate admUserIntegrateTemplate) {
        getAdmUserIntegrateTemplates().remove(admUserIntegrateTemplate);
        admUserIntegrateTemplate.setAdmIntegrateTemplate(null);

        return admUserIntegrateTemplate;
    }

    @Column(name = "ci_type_id")
    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

}