package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_menu database table.
 * 
 */
@Entity
@Table(name = "adm_menu")
@NamedQuery(name = "AdmMenu.findAll", query = "SELECT a FROM AdmMenu a")
public class AdmMenu implements Serializable {
    private static final long serialVersionUID = 1L;
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

}