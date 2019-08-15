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
 * The persistent class for the adm_role_menu database table.
 *
 */
@Entity
@Table(name = "adm_role_menu")
@NamedQuery(name = "AdmRoleMenu.findAll", query = "SELECT a FROM AdmRoleMenu a")
public class AdmRoleMenu implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmRoleMenu;
    private Integer idAdmMenu;
    private Integer idAdmRole;
    private AdmMenu admMenu;
    private AdmRole admRole;

    public AdmRoleMenu() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_menu")
    public Integer getIdAdmRoleMenu() {
        return this.idAdmRoleMenu;
    }

    public void setIdAdmRoleMenu(Integer idAdmRoleMenu) {
        this.idAdmRoleMenu = idAdmRoleMenu;
    }

    @Column(name = "id_adm_menu")
    public Integer getIdAdmMenu() {
        return this.idAdmMenu;
    }

    public void setIdAdmMenu(Integer idAdmMenu) {
        this.idAdmMenu = idAdmMenu;
    }

    @Column(name = "id_adm_role")
    public Integer getIdAdmRole() {
        return this.idAdmRole;
    }

    public void setIdAdmRole(Integer idAdmRole) {
        this.idAdmRole = idAdmRole;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_menu", insertable = false, updatable = false)
    public AdmMenu getAdmMenu() {
        return admMenu;
    }

    public void setAdmMenu(AdmMenu admMenu) {
        this.admMenu = admMenu;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role", insertable = false, updatable = false)
    public AdmRole getAdmRole() {
        return admRole;
    }

    public void setAdmRole(AdmRole admRole) {
        this.admRole = admRole;
    }
}
