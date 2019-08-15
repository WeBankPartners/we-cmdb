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
 * The persistent class for the adm_template_ci_type_attr database table.
 * 
 */
@Entity
@Table(name = "adm_template_ci_type_attr")
@NamedQuery(name = "AdmTemplateCiTypeAttr.findAll", query = "SELECT a FROM AdmTemplateCiTypeAttr a")
public class AdmTemplateCiTypeAttr implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmTemplateCiTypeAttr;
    private String cnAlias;
    private Integer idAdmTemplateCiTypeAlias;
    private String isDisplayed;
    private String isImported;
    private String mappingName;
    private Integer seqNo;
    private AdmCiTypeAttr admCiTypeAttr;

    public AdmTemplateCiTypeAttr() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_template_ci_type_attr")
    public Integer getIdAdmTemplateCiTypeAttr() {
        return this.idAdmTemplateCiTypeAttr;
    }

    public void setIdAdmTemplateCiTypeAttr(Integer idAdmTemplateCiTypeAttr) {
        this.idAdmTemplateCiTypeAttr = idAdmTemplateCiTypeAttr;
    }

    @Column(name = "cn_alias")
    public String getCnAlias() {
        return this.cnAlias;
    }

    public void setCnAlias(String cnAlias) {
        this.cnAlias = cnAlias;
    }

    @Column(name = "id_adm_template_ci_type_alias")
    public Integer getIdAdmTemplateCiTypeAlias() {
        return this.idAdmTemplateCiTypeAlias;
    }

    public void setIdAdmTemplateCiTypeAlias(Integer idAdmTemplateCiTypeAlias) {
        this.idAdmTemplateCiTypeAlias = idAdmTemplateCiTypeAlias;
    }

    @Column(name = "is_displayed")
    public String getIsDisplayed() {
        return this.isDisplayed;
    }

    public void setIsDisplayed(String isDisplayed) {
        this.isDisplayed = isDisplayed;
    }

    @Column(name = "is_imported")
    public String getIsImported() {
        return this.isImported;
    }

    public void setIsImported(String isImported) {
        this.isImported = isImported;
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