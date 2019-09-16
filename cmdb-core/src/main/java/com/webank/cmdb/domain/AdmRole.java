package com.webank.cmdb.domain;

import java.io.Serializable;
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
import javax.persistence.Table;

/**
 * The persistent class for the adm_role database table.
 *
 */
@Entity
@Table(name = "adm_role")
@NamedQuery(name = "AdmRole.findAll", query = "SELECT a FROM AdmRole a")
public class AdmRole implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmRole;
    private String description;
    private String roleName;
    private String roleType;
    private List<AdmBasekeyCat> admBasekeyCats;
    private AdmRole admRole;
    private List<AdmRole> admRoles;
    private AdmTenement admTenement;
    private Integer isSystem;
    private List<AdmRoleCiType> admRoleCiTypes;
    private List<AdmRoleUser> admRoleUsers;
    private List<AdmRoleMenu> admRoleMenus;

    public AdmRole() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role")
    public Integer getIdAdmRole() {
        return this.idAdmRole;
    }

    public void setIdAdmRole(Integer idAdmRole) {
        this.idAdmRole = idAdmRole;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "role_name")
    public String getRoleName() {
        return this.roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    @Column(name = "role_type")
    public String getRoleType() {
        return this.roleType;
    }

    public void setRoleType(String roleType) {
        this.roleType = roleType;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @OneToMany(mappedBy = "admRole")
    public List<AdmBasekeyCat> getAdmBasekeyCats() {
        return this.admBasekeyCats;
    }

    public void setAdmBasekeyCats(List<AdmBasekeyCat> admBasekeyCats) {
        this.admBasekeyCats = admBasekeyCats;
    }

    public AdmBasekeyCat addAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        getAdmBasekeyCats().add(admBasekeyCat);
        admBasekeyCat.setAdmRole(this);

        return admBasekeyCat;
    }

    public AdmBasekeyCat removeAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        getAdmBasekeyCats().remove(admBasekeyCat);
        admBasekeyCat.setAdmRole(null);

        return admBasekeyCat;
    }

    // bi-directional many-to-one association to AdmRole
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id_adm_role")
    public AdmRole getAdmRole() {
        return this.admRole;
    }

    public void setAdmRole(AdmRole admRole) {
        this.admRole = admRole;
    }

    // bi-directional many-to-one association to AdmRole
    @OneToMany(mappedBy = "admRole")
    public List<AdmRole> getAdmRoles() {
        return this.admRoles;
    }

    public void setAdmRoles(List<AdmRole> admRoles) {
        this.admRoles = admRoles;
    }

    public AdmRole addAdmRole(AdmRole admRole) {
        getAdmRoles().add(admRole);
        admRole.setAdmRole(this);

        return admRole;
    }

    public AdmRole removeAdmRole(AdmRole admRole) {
        getAdmRoles().remove(admRole);
        admRole.setAdmRole(null);

        return admRole;
    }

    // bi-directional many-to-one association to AdmTenement
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_tenement")
    public AdmTenement getAdmTenement() {
        return this.admTenement;
    }

    public void setAdmTenement(AdmTenement admTenement) {
        this.admTenement = admTenement;
    }

    @Column(name = "is_system")
    public Integer getIsSystem() {
        return this.isSystem;
    }

    public void setIsSystem(Integer isSystem) {
        this.isSystem = isSystem;
    }

    // bi-directional many-to-one association to AdmRoleCiType
    @OneToMany(mappedBy = "admRole")
    public List<AdmRoleCiType> getAdmRoleCiTypes() {
        return this.admRoleCiTypes;
    }

    public void setAdmRoleCiTypes(List<AdmRoleCiType> admRoleCiTypes) {
        this.admRoleCiTypes = admRoleCiTypes;
    }

    public AdmRoleCiType addAdmRoleCiType(AdmRoleCiType admRoleCiType) {
        getAdmRoleCiTypes().add(admRoleCiType);
        admRoleCiType.setAdmRole(this);

        return admRoleCiType;
    }

    public AdmRoleCiType removeAdmRoleCiType(AdmRoleCiType admRoleCiType) {
        getAdmRoleCiTypes().remove(admRoleCiType);
        admRoleCiType.setAdmRole(null);

        return admRoleCiType;
    }

    // bi-directional many-to-one association to AdmRoleUser
    @OneToMany(mappedBy = "admRole")
    public List<AdmRoleUser> getAdmRoleUsers() {
        return this.admRoleUsers;
    }

    public void setAdmRoleUsers(List<AdmRoleUser> admRoleUsers) {
        this.admRoleUsers = admRoleUsers;
    }

    @OneToMany(mappedBy = "admRole")
    public List<AdmRoleMenu> getAdmRoleMenus() {
        return admRoleMenus;
    }

    public void setAdmRoleMenus(List<AdmRoleMenu> admRoleMenus) {
        this.admRoleMenus = admRoleMenus;
    }

    public AdmRoleUser addAdmRoleUser(AdmRoleUser admRoleUser) {
        getAdmRoleUsers().add(admRoleUser);
        admRoleUser.setAdmRole(this);

        return admRoleUser;
    }

    public AdmRoleUser removeAdmRoleUser(AdmRoleUser admRoleUser) {
        getAdmRoleUsers().remove(admRoleUser);
        admRoleUser.setAdmRole(null);

        return admRoleUser;
    }

}
