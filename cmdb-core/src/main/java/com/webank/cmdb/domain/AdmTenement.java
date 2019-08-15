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
 * The persistent class for the adm_tenement database table.
 * 
 */
@Entity
@Table(name = "adm_tenement")
@NamedQuery(name = "AdmTenement.findAll", query = "SELECT a FROM AdmTenement a")
public class AdmTenement implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmTenement;
    private String description;
    private String enShortName;
    private String name;
    private List<AdmRole> admRoles;
    private List<AdmUser> admUsers;

    public AdmTenement() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_tenement")
    public Integer getIdAdmTenement() {
        return this.idAdmTenement;
    }

    public void setIdAdmTenement(Integer idAdmTenement) {
        this.idAdmTenement = idAdmTenement;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "en_short_name")
    public String getEnShortName() {
        return this.enShortName;
    }

    public void setEnShortName(String enSortName) {
        this.enShortName = enSortName;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // bi-directional many-to-one association to AdmRole
    @OneToMany(mappedBy = "admTenement")
    public List<AdmRole> getAdmRoles() {
        return this.admRoles;
    }

    public void setAdmRoles(List<AdmRole> admRoles) {
        this.admRoles = admRoles;
    }

    public AdmRole addAdmRole(AdmRole admRole) {
        getAdmRoles().add(admRole);
        admRole.setAdmTenement(this);

        return admRole;
    }

    public AdmRole removeAdmRole(AdmRole admRole) {
        getAdmRoles().remove(admRole);
        admRole.setAdmTenement(null);

        return admRole;
    }

    // bi-directional many-to-one association to AdmUser
    @OneToMany(mappedBy = "admTenement")
    public List<AdmUser> getAdmUsers() {
        return this.admUsers;
    }

    public void setAdmUsers(List<AdmUser> admUsers) {
        this.admUsers = admUsers;
    }

    public AdmUser addAdmUser(AdmUser admUser) {
        getAdmUsers().add(admUser);
        admUser.setAdmTenement(this);

        return admUser;
    }

    public AdmUser removeAdmUser(AdmUser admUser) {
        getAdmUsers().remove(admUser);
        admUser.setAdmTenement(null);

        return admUser;
    }

}