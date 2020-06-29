package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * The persistent class for the adm_menu database table.
 * 
 */
@Entity
@Table(name = "adm_menu")
@NamedQuery(name = "AdmMenu.findAll", query = "SELECT a FROM AdmMenu a")
public class AdmMenu implements Serializable {

    private static final long serialVersionUID = 1L;
    public final static String ROLE_PREFIX = "MENU_";

    public final static String MENU_DESIGNING_CI_DATA_MANAGEMENT = "DESIGNING_CI_DATA_MANAGEMENT";
    public final static String MENU_DESIGNING_CI_DATA_ENQUIRY = "DESIGNING_CI_DATA_ENQUIRY";
    public final static String MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT = "DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT";
    public final static String MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION = "DESIGNING_CI_INTEGRATED_QUERY_EXECUTION";

    public final static String MENU_IDC_PLANNING_DESIGN = "IDC_PLANNING_DESIGN";
    public final static String MENU_IDC_RESOURCE_PLANNING = "IDC_RESOURCE_PLANNING";
    public final static String MENU_APPLICATION_ARCHITECTURE_DESIGN = "APPLICATION_ARCHITECTURE_DESIGN";
    public final static String MENU_APPLICATION_ARCHITECTURE_QUERY = "APPLICATION_ARCHITECTURE_QUERY";
    public final static String MENU_APPLICATION_DEPLOYMENT_DESIGN = "APPLICATION_DEPLOYMENT_DESIGN";

    public final static String MENU_CMDB_DESIGNING_ENUM_MANAGEMENT = "CMDB_DESIGNING_ENUM_MANAGEMENT";
    public final static String MENU_CMDB_DESIGNING_ENUM_ENQUIRY = "CMDB_DESIGNING_ENUM_ENQUIRY";

    public final static String MENU_ADMIN_CMDB_MODEL_MANAGEMENT = "ADMIN_CMDB_MODEL_MANAGEMENT";
    public final static String MENU_ADMIN_PERMISSION_MANAGEMENT = "ADMIN_PERMISSION_MANAGEMENT";
    public final static String MENU_ADMIN_USER_PASSWORD_MANAGEMENT = "ADMIN_USER_PASSWORD_MANAGEMENT";
    public final static String MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT = "CMDB_ADMIN_BASE_DATA_MANAGEMENT";
    public final static String MENU_ADMIN_QUERY_LOG = "ADMIN_QUERY_LOG";

    private Integer idAdmMenu;
    private String classPath;
    private Integer isActive;
    private String name;
    private String otherName;
    private Integer parentIdAdmMenu;
    private String remark;
    private Integer seqNo;
    private String url;

    public AdmMenu() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_menu")
    public Integer getIdAdmMenu() {
        return this.idAdmMenu;
    }

    public void setIdAdmMenu(Integer idAdmMenu) {
        this.idAdmMenu = idAdmMenu;
    }

    @Column(name = "class_path")
    public String getClassPath() {
        return this.classPath;
    }

    public void setClassPath(String classPath) {
        this.classPath = classPath;
    }

    @Column(name = "is_active")
    public Integer getIsActive() {
        return this.isActive;
    }

    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "other_name")
    public String getOtherName() {
        return this.otherName;
    }

    public void setOtherName(String otherName) {
        this.otherName = otherName;
    }

    @Column(name = "parent_id_adm_menu")
    public Integer getParentIdAdmMenu() {
        return this.parentIdAdmMenu;
    }

    public void setParentIdAdmMenu(Integer parentIdAdmMenu) {
        this.parentIdAdmMenu = parentIdAdmMenu;
    }

    public String getRemark() {
        return this.remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Column(name = "seq_no")
    public Integer getSeqNo() {
        return this.seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    public String getUrl() {
        return this.url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @OneToMany(mappedBy = "admMenu", cascade = CascadeType.ALL, orphanRemoval = true)
    public List<AdmRoleMenu> getAssignedRoles() {
        return assignedRoles;
    }

    public void setAssignedRoles(List<AdmRoleMenu> assignedRoles) {
        this.assignedRoles = assignedRoles;
    }

    @EqualsAndHashCode.Exclude @ToString.Exclude
    private List<AdmRoleMenu> assignedRoles = new ArrayList<>();

}