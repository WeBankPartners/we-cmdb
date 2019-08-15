package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_template_ci_type_alias database table.
 * 
 */
@Entity
@Table(name = "adm_template_ci_type_alias")
@NamedQuery(name = "AdmTemplateCiTypeAlia.findAll", query = "SELECT a FROM AdmTemplateCiTypeAlia a")
public class AdmTemplateCiTypeAlia implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmTemplateCiTypeAlias;
    private String alias;
    private Integer idAdmCiType;
    private Integer idAdmTemplate;

    public AdmTemplateCiTypeAlia() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_template_ci_type_alias")
    public Integer getIdAdmTemplateCiTypeAlias() {
        return this.idAdmTemplateCiTypeAlias;
    }

    public void setIdAdmTemplateCiTypeAlias(Integer idAdmTemplateCiTypeAlias) {
        this.idAdmTemplateCiTypeAlias = idAdmTemplateCiTypeAlias;
    }

    public String getAlias() {
        return this.alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    @Column(name = "id_adm_ci_type")
    public Integer getIdAdmCiType() {
        return this.idAdmCiType;
    }

    public void setIdAdmCiType(Integer idAdmCiType) {
        this.idAdmCiType = idAdmCiType;
    }

    @Column(name = "id_adm_template")
    public Integer getIdAdmTemplate() {
        return this.idAdmTemplate;
    }

    public void setIdAdmTemplate(Integer idAdmTemplate) {
        this.idAdmTemplate = idAdmTemplate;
    }

}