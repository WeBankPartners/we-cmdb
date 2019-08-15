package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.LinkedHashSet;
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

import com.google.common.base.MoreObjects;

/**
 * The persistent class for the adm_role_ci_type_attr database table.
 */
@Entity
@Table(name = "adm_role_ci_type_ctrl_attr")
@NamedQuery(name = "AdmRoleCiTypeCtrlAttr.findAll", query = "SELECT a FROM AdmRoleCiTypeCtrlAttr a")
public class AdmRoleCiTypeCtrlAttr implements AdmRoleCiTypeActionPermissions, Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmRoleCiTypeCtrlAttr;
    private AdmRoleCiType admRoleCiType;
    private Integer roleCiTypeId;
    private String creationPermission;
    private String removalPermission;
    private String modificationPermission;
    private String enquiryPermission;
    private String executionPermission;
    private String grantPermission;

    private Set<AdmRoleCiTypeCtrlAttrCondition> admRoleCiTypeCtrlAttrConditions = new LinkedHashSet<>();

    public AdmRoleCiTypeCtrlAttr() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_ci_type_ctrl_attr")
    public Integer getIdAdmRoleCiTypeCtrlAttr() {
        return this.idAdmRoleCiTypeCtrlAttr;
    }

    public void setIdAdmRoleCiTypeCtrlAttr(Integer idAdmRoleCiTypeCtrlAttr) {
        this.idAdmRoleCiTypeCtrlAttr = idAdmRoleCiTypeCtrlAttr;
    }

    // bi-directional many-to-one association to AdmRoleCiType
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role_ci_type", insertable = false, updatable = false)
    public AdmRoleCiType getAdmRoleCiType() {
        return this.admRoleCiType;
    }

    public void setAdmRoleCiType(AdmRoleCiType admRoleCiType) {
        this.admRoleCiType = admRoleCiType;
    }

    @OneToMany(mappedBy = "admRoleCiTypeCtrlAttr")
    public Set<AdmRoleCiTypeCtrlAttrCondition> getAdmRoleCiTypeCtrlAttrConditions() {
        return admRoleCiTypeCtrlAttrConditions;
    }

    public void setAdmRoleCiTypeCtrlAttrConditions(Set<AdmRoleCiTypeCtrlAttrCondition> admRoleCiTypeCtrlAttrConditions) {
        this.admRoleCiTypeCtrlAttrConditions = admRoleCiTypeCtrlAttrConditions;
    }

    @Override
    @Column(name = "creation_permission")
    public String getCreationPermission() {
        return creationPermission;
    }

    public void setCreationPermission(String creationPermission) {
        this.creationPermission = creationPermission;
    }

    @Override
    @Column(name = "removal_permission")
    public String getRemovalPermission() {
        return removalPermission;
    }

    public void setRemovalPermission(String removalPermission) {
        this.removalPermission = removalPermission;
    }

    @Override
    @Column(name = "modification_permission")
    public String getModificationPermission() {
        return modificationPermission;
    }

    public void setModificationPermission(String modificationPermission) {
        this.modificationPermission = modificationPermission;
    }

    @Override
    @Column(name = "enquiry_permission")
    public String getEnquiryPermission() {
        return enquiryPermission;
    }

    public void setEnquiryPermission(String enquiryPermission) {
        this.enquiryPermission = enquiryPermission;
    }

    @Override
    @Column(name = "execution_permission")
    public String getExecutionPermission() {
        return executionPermission;
    }

    public void setExecutionPermission(String executionPermission) {
        this.executionPermission = executionPermission;
    }

    @Override
    @Column(name = "grant_permission")
    public String getGrantPermission() {
        return grantPermission;
    }

    public void setGrantPermission(String grantPermission) {
        this.grantPermission = grantPermission;
    }

    @Column(name = "id_adm_role_ci_type")
    public Integer getRoleCiTypeId() {
        return roleCiTypeId;
    }

    public void setRoleCiTypeId(Integer roleCiTypeId) {
        this.roleCiTypeId = roleCiTypeId;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("idAdmRoleCiTypeCtrlAttr", idAdmRoleCiTypeCtrlAttr)
                .add("conditions", admRoleCiTypeCtrlAttrConditions)
                .add("creationPermission", creationPermission)
                .add("removalPermission", removalPermission)
                .add("modificationPermission", modificationPermission)
                .add("enquiryPermission", enquiryPermission)
                .add("executionPermission", executionPermission)
                .add("grantPermission", grantPermission)
                .toString();
    }

}
