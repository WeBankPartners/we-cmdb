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
 * The persistent class for the adm_attr_group database table.
 * 
 */
@Entity
@Table(name = "adm_attr_group")
@NamedQuery(name = "AdmAttrGroup.findAll", query = "SELECT a FROM AdmAttrGroup a")
public class AdmAttrGroup implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmAttrGroup;
    private String name;
    private List<AdmCiTypeAttrGroup> admCiTypeAttrGroups;
    private List<AdmTemplateCiTypeAliasUniq> admTemplateCiTypeAliasUniqs;

    public AdmAttrGroup() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_attr_group")
    public Integer getIdAdmAttrGroup() {
        return this.idAdmAttrGroup;
    }

    public void setIdAdmAttrGroup(Integer idAdmAttrGroup) {
        this.idAdmAttrGroup = idAdmAttrGroup;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // bi-directional many-to-one association to AdmCiTypeAttrGroup
    @OneToMany(mappedBy = "admAttrGroup")
    public List<AdmCiTypeAttrGroup> getAdmCiTypeAttrGroups() {
        return this.admCiTypeAttrGroups;
    }

    public void setAdmCiTypeAttrGroups(List<AdmCiTypeAttrGroup> admCiTypeAttrGroups) {
        this.admCiTypeAttrGroups = admCiTypeAttrGroups;
    }

    public AdmCiTypeAttrGroup addAdmCiTypeAttrGroup(AdmCiTypeAttrGroup admCiTypeAttrGroup) {
        getAdmCiTypeAttrGroups().add(admCiTypeAttrGroup);
        admCiTypeAttrGroup.setAdmAttrGroup(this);

        return admCiTypeAttrGroup;
    }

    public AdmCiTypeAttrGroup removeAdmCiTypeAttrGroup(AdmCiTypeAttrGroup admCiTypeAttrGroup) {
        getAdmCiTypeAttrGroups().remove(admCiTypeAttrGroup);
        admCiTypeAttrGroup.setAdmAttrGroup(null);

        return admCiTypeAttrGroup;
    }

    // bi-directional many-to-one association to AdmTemplateCiTypeAliasUniq
    @OneToMany(mappedBy = "admAttrGroup")
    public List<AdmTemplateCiTypeAliasUniq> getAdmTemplateCiTypeAliasUniqs() {
        return this.admTemplateCiTypeAliasUniqs;
    }

    public void setAdmTemplateCiTypeAliasUniqs(List<AdmTemplateCiTypeAliasUniq> admTemplateCiTypeAliasUniqs) {
        this.admTemplateCiTypeAliasUniqs = admTemplateCiTypeAliasUniqs;
    }

    public AdmTemplateCiTypeAliasUniq addAdmTemplateCiTypeAliasUniq(AdmTemplateCiTypeAliasUniq admTemplateCiTypeAliasUniq) {
        getAdmTemplateCiTypeAliasUniqs().add(admTemplateCiTypeAliasUniq);
        admTemplateCiTypeAliasUniq.setAdmAttrGroup(this);

        return admTemplateCiTypeAliasUniq;
    }

    public AdmTemplateCiTypeAliasUniq removeAdmTemplateCiTypeAliasUniq(AdmTemplateCiTypeAliasUniq admTemplateCiTypeAliasUniq) {
        getAdmTemplateCiTypeAliasUniqs().remove(admTemplateCiTypeAliasUniq);
        admTemplateCiTypeAliasUniq.setAdmAttrGroup(null);

        return admTemplateCiTypeAliasUniq;
    }
}