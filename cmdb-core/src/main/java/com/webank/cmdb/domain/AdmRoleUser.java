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
 * The persistent class for the adm_role_user database table.
 */
@Entity
@Table(name = "adm_role_user")
@NamedQuery(name = "AdmRoleUser.findAll", query = "SELECT a FROM AdmRoleUser a")
public class AdmRoleUser implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmRoleUser;
    private Integer roleId;
    private String userId;
    private Integer isSystem;
    private AdmRole admRole;
    private AdmUser admUser;

    public AdmRoleUser() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_user")
    public Integer getIdAdmRoleUser() {
        return this.idAdmRoleUser;
    }

    public void setIdAdmRoleUser(Integer idAdmRoleUser) {
        this.idAdmRoleUser = idAdmRoleUser;
    }

    // bi-directional many-to-one association to AdmRole
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role", insertable = false, updatable = false)
    public AdmRole getAdmRole() {
        return this.admRole;
    }

    public void setAdmRole(AdmRole admRole) {
        this.admRole = admRole;
    }

    // bi-directional many-to-one association to AdmUser
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_user", insertable = false, updatable = false)
    public AdmUser getAdmUser() {
        return this.admUser;
    }

    public void setAdmUser(AdmUser admUser) {
        this.admUser = admUser;
    }

    @Column(name = "id_adm_role")
    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    @Column(name = "id_adm_user")
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Column(name = "is_system")
    public Integer getIsSystem() {
        return this.isSystem;
    }

    public void setIsSystem(Integer isSystem) {
        this.isSystem = isSystem;
    }
}
