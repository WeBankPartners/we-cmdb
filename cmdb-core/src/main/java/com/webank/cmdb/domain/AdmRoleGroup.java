package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_role_group database table.
 * 
 */
//@Entity
@Table(name = "adm_role_group")
@NamedQuery(name = "AdmRoleGroup.findAll", query = "SELECT a FROM AdmRoleGroup a")
public class AdmRoleGroup implements Serializable {
    private static final long serialVersionUID = 1L;
    private String belongDevOperGroup;
    private String belongOrg;
    private Integer idAdmRole;
    private String isDefault;

    public AdmRoleGroup() {
    }

    @Column(name = "belong_dev_oper_group")
    public String getBelongDevOperGroup() {
        return this.belongDevOperGroup;
    }

    public void setBelongDevOperGroup(String belongDevOperGroup) {
        this.belongDevOperGroup = belongDevOperGroup;
    }

    @Column(name = "belong_org")
    public String getBelongOrg() {
        return this.belongOrg;
    }

    public void setBelongOrg(String belongOrg) {
        this.belongOrg = belongOrg;
    }

    @Column(name = "id_adm_role")
    public Integer getIdAdmRole() {
        return this.idAdmRole;
    }

    public void setIdAdmRole(Integer idAdmRole) {
        this.idAdmRole = idAdmRole;
    }

    @Column(name = "is_default")
    public String getIsDefault() {
        return this.isDefault;
    }

    public void setIsDefault(String isDefault) {
        this.isDefault = isDefault;
    }

}