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
 * The persistent class for the adm_integrate_template_alias_attr database
 * table.
 * 
 */
@Entity
@Table(name = "adm_integrate_template_alias_attr")
@NamedQuery(name = "AdmIntegrateTemplateAliasAttr.findAll", query = "SELECT a FROM AdmIntegrateTemplateAliasAttr a")
public class AdmIntegrateTemplateAliasAttr implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAttr;
    private String cnAlias;
    private String filter;
    private String isCondition;
    private String isDisplayed;
    private String mappingName;
    private Integer seqNo;
    private String sysAttr;
    private AdmCiTypeAttr admCiTypeAttr;
    private AdmIntegrateTemplateAlias admIntegrateTemplateAlias;
    private String keyName;

    private Integer ciTypeAttrId;

    public AdmIntegrateTemplateAliasAttr() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_attr")
    public Integer getIdAttr() {
        return this.idAttr;
    }

    public void setIdAttr(Integer idAttr) {
        this.idAttr = idAttr;
    }

    @Column(name = "cn_alias")
    public String getCnAlias() {
        return this.cnAlias;
    }

    public void setCnAlias(String cnAlias) {
        this.cnAlias = cnAlias;
    }

    public String getFilter() {
        return this.filter;
    }

    public void setFilter(String filter) {
        this.filter = filter;
    }

    @Column(name = "is_condition")
    public String getIsCondition() {
        return this.isCondition;
    }

    public void setIsCondition(String isCondition) {
        this.isCondition = isCondition;
    }

    @Column(name = "is_displayed")
    public String getIsDisplayed() {
        return this.isDisplayed;
    }

    public void setIsDisplayed(String isDisplayed) {
        this.isDisplayed = isDisplayed;
    }

    @Column(name = "mapping_name")
    public String getMappingName() {
        return this.mappingName;
    }

    public void setMappingName(String mappingName) {
        this.mappingName = mappingName;
    }

    @Column(name = "seq_no")
    public Integer getSeqNo() {
        return this.seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    @Column(name = "sys_attr")
    public String getSysAttr() {
        return this.sysAttr;
    }

    public void setSysAttr(String sysAttr) {
        this.sysAttr = sysAttr;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_ci_type_attr")
    public AdmCiTypeAttr getAdmCiTypeAttr() {
        return this.admCiTypeAttr;
    }

    public void setAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        this.admCiTypeAttr = admCiTypeAttr;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateAlia
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_alias")
    public AdmIntegrateTemplateAlias getAdmIntegrateTemplateAlias() {
        return this.admIntegrateTemplateAlias;
    }

    public void setAdmIntegrateTemplateAlias(AdmIntegrateTemplateAlias admIntegrateTemplateAlia) {
        this.admIntegrateTemplateAlias = admIntegrateTemplateAlia;
    }

    @Column(name = "id_ci_type_attr", insertable = false, updatable = false)
    public Integer getCiTypeAttrId() {
        return ciTypeAttrId;
    }

    public void setCiTypeAttrId(Integer ciTypeAttrId) {
        this.ciTypeAttrId = ciTypeAttrId;
    }

    @Column(name = "key_name")
    public String getKeyName() {
        return keyName;
    }

    public void setKeyName(String keyName) {
        this.keyName = keyName;
    }

}