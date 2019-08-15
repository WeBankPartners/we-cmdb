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

/**
 * The persistent class for the adm_role_ci_type database table.
 */
@Entity
@Table(name = "adm_role_ci_type")
@NamedQuery(name = "AdmRoleCiType.findAll", query = "SELECT a FROM AdmRoleCiType a")
public class AdmRoleCiType implements AdmRoleCiTypeActionPermissions, Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmRoleCiType;
    private AdmCiType admCiType;
    private Integer ciTypeId;
    private String ciTypeName;
    private AdmRole admRole;
    private Integer roleId;

    private String creationPermission;
    private String removalPermission;
    private String modificationPermission;
    private String enquiryPermission;
    private String executionPermission;
    private String grantPermission;

    private Set<AdmRoleCiTypeCtrlAttr> admRoleCiTypeCtrlAttrs = new LinkedHashSet<>();

    public AdmRoleCiType() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_ci_type")
    public Integer getIdAdmRoleCiType() {
        return this.idAdmRoleCiType;
    }

    public void setIdAdmRoleCiType(Integer idAdmRoleCiType) {
        this.idAdmRoleCiType = idAdmRoleCiType;
    }

    @Column(name = "id_adm_ci_type")
    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    @Column(name = "ci_type_name")
    public String getCiTypeName() {
        return ciTypeName;
    }

    public void setCiTypeName(String ciTypeName) {
        this.ciTypeName = ciTypeName;
    }

    @Column(name = "id_adm_role")
    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
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

    // bi-directional many-to-one association to AdmRole
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role", insertable = false, updatable = false)
    public AdmRole getAdmRole() {
        return this.admRole;
    }

    public void setAdmRole(AdmRole admRole) {
        this.admRole = admRole;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_ci_type", insertable = false, updatable = false)
    public AdmCiType getAdmCiType() {
        return admCiType;
    }

    public void setAdmCiType(AdmCiType admCiType) {
        this.admCiType = admCiType;
    }

    // bi-directional many-to-one association to AdmRoleCiTypeAttr
    @OneToMany(mappedBy = "admRoleCiType")
    public Set<AdmRoleCiTypeCtrlAttr> getAdmRoleCiTypeCtrlAttrs() {
        return this.admRoleCiTypeCtrlAttrs;
    }

    public void setAdmRoleCiTypeCtrlAttrs(Set<AdmRoleCiTypeCtrlAttr> admRoleCiTypeCtrlAttrs) {
        this.admRoleCiTypeCtrlAttrs = admRoleCiTypeCtrlAttrs;
    }

    public AdmRoleCiTypeCtrlAttr addAdmRoleCiTypeCtrlAttr(AdmRoleCiTypeCtrlAttr admRoleCiTypeCtrlAttr) {
        getAdmRoleCiTypeCtrlAttrs().add(admRoleCiTypeCtrlAttr);
        admRoleCiTypeCtrlAttr.setAdmRoleCiType(this);

        return admRoleCiTypeCtrlAttr;
    }

    public AdmRoleCiTypeCtrlAttr removeAdmRoleCiTypeCtrlAttr(AdmRoleCiTypeCtrlAttr admRoleCiTypeCtrlAttr) {
        getAdmRoleCiTypeCtrlAttrs().remove(admRoleCiTypeCtrlAttr);
        admRoleCiTypeCtrlAttr.setAdmRoleCiType(null);

        return admRoleCiTypeCtrlAttr;
    }

}
