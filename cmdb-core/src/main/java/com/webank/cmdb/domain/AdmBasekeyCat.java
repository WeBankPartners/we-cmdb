package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

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
import javax.persistence.Table;

/**
 * The persistent class for the adm_basekey_cat database table.
 * 
 */
@Entity
@Table(name = "adm_basekey_cat")
@NamedQuery(name = "AdmBasekeyCat.findAll", query = "SELECT a FROM AdmBasekeyCat a")
public class AdmBasekeyCat implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idAdmBasekeyCat;
    private String catName;
    private String description;
    private AdmBasekeyCat groupBasekeyCat;
    private List<AdmBasekeyCat> memberBasekeyCats;
    private AdmBasekeyCatType admBasekeyCatType;
    private AdmRole admRole;
    private Set<AdmBasekeyCode> admBasekeyCodes;
    private Integer groupTypeId;
    private Integer idAdmBasekeyCatType;

    public AdmBasekeyCat() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_basekey_cat")
    public int getIdAdmBasekeyCat() {
        return this.idAdmBasekeyCat;
    }

    public void setIdAdmBasekeyCat(int idAdmBasekeyCat) {
        this.idAdmBasekeyCat = idAdmBasekeyCat;
    }

    @Column(name = "cat_name")
    public String getCatName() {
        return this.catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "group_type_id")
    public Integer getGroupTypeId() {
        return groupTypeId;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_type_id", insertable = false, updatable = false)
    public AdmBasekeyCat getGroupBasekeyCat() {
        return this.groupBasekeyCat;
    }

    public void setGroupBasekeyCat(AdmBasekeyCat groupBasekeyCat) {
        this.groupBasekeyCat = groupBasekeyCat;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @OneToMany(mappedBy = "groupBasekeyCat")
    public List<AdmBasekeyCat> getMemberBasekeyCats() {
        return this.memberBasekeyCats;
    }

    public void setMemberBasekeyCats(List<AdmBasekeyCat> memberBasekeyCats) {
        this.memberBasekeyCats = memberBasekeyCats;
    }

    public AdmBasekeyCat addAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        getMemberBasekeyCats().add(admBasekeyCat);
        admBasekeyCat.setGroupBasekeyCat(this);

        return admBasekeyCat;
    }

    public AdmBasekeyCat removeAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        getMemberBasekeyCats().remove(admBasekeyCat);
        admBasekeyCat.setGroupBasekeyCat(null);

        return admBasekeyCat;
    }

    // bi-directional many-to-one association to AdmBasekeyCatType
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_basekey_cat_type", insertable = false, updatable = false)
    public AdmBasekeyCatType getAdmBasekeyCatType() {
        return this.admBasekeyCatType;
    }

    public void setAdmBasekeyCatType(AdmBasekeyCatType admBasekeyCatType) {
        this.admBasekeyCatType = admBasekeyCatType;
    }

    // bi-directional many-to-one association to AdmRole
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role")
    public AdmRole getAdmRole() {
        return this.admRole;
    }

    public void setAdmRole(AdmRole admRole) {
        this.admRole = admRole;
    }

    // bi-directional many-to-one association to AdmBasekeyCode
    @OneToMany(mappedBy = "admBasekeyCat")
    public Set<AdmBasekeyCode> getAdmBasekeyCodes() {
        return this.admBasekeyCodes;
    }

    public void setAdmBasekeyCodes(Set<AdmBasekeyCode> admBasekeyCodes) {
        this.admBasekeyCodes = admBasekeyCodes;
    }

    public AdmBasekeyCode addAdmBasekeyCode(AdmBasekeyCode admBasekeyCode) {
        getAdmBasekeyCodes().add(admBasekeyCode);
        admBasekeyCode.setAdmBasekeyCat(this);

        return admBasekeyCode;
    }

    public AdmBasekeyCode removeAdmBasekeyCode(AdmBasekeyCode admBasekeyCode) {
        getAdmBasekeyCodes().remove(admBasekeyCode);
        admBasekeyCode.setAdmBasekeyCat(null);

        return admBasekeyCode;
    }

    public void setGroupTypeId(Integer groupTypeId) {
        this.groupTypeId = groupTypeId;
    }

    @Column(name = "id_adm_basekey_cat_type")
    public Integer getIdAdmBasekeyCatType() {
        return idAdmBasekeyCatType;
    }

    public void setIdAdmBasekeyCatType(Integer idAdmBasekeyCatType) {
        this.idAdmBasekeyCatType = idAdmBasekeyCatType;
    }

}