package com.webank.cmdb.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.webank.cmdb.domain.AdmMenu;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class MenuDto extends BasicResourceDto<MenuDto, AdmMenu> {
    @DtoId
    @DtoField(domainField = "idAdmMenu")
    private Integer menuId;
    private String classPath;
    private Integer isActive;
    private String name;
    private String otherName;
    private Integer parentIdAdmMenu;
    private String remark;
    private Integer seqNo;
    private String url;

    public MenuDto() {
    }

    @Override
    public MenuDto fromDomain(AdmMenu domainObj, List<String> refResource) {
        MenuDto dto = from(domainObj, false);
        return dto;
    }

    @Override
    public Class<AdmMenu> domainClazz() {
        return AdmMenu.class;
    }

    public static MenuDto from(AdmMenu domain, boolean withChild) {
        MenuDto dto = new MenuDto();
        dto.setMenuId(domain.getIdAdmMenu());
        dto.setClassPath(domain.getClassPath());
        dto.setIsActive(domain.getIsActive());
        dto.setName(domain.getName());
        dto.setOtherName(domain.getOtherName());
        dto.setParentIdAdmMenu(domain.getParentIdAdmMenu());
        dto.setRemark(domain.getRemark());
        dto.setSeqNo(domain.getSeqNo());
        dto.setUrl(domain.getUrl());
        if (withChild) {
        }
        return dto;
    }

    public AdmMenu toDomain() {
        AdmMenu domain = new AdmMenu();
        domain.setIdAdmMenu(this.menuId);
        domain.setClassPath(this.classPath);
        domain.setIsActive(this.isActive);
        domain.setName(this.name);
        domain.setOtherName(this.otherName);
        domain.setParentIdAdmMenu(this.parentIdAdmMenu);
        domain.setRemark(this.remark);
        domain.setSeqNo(this.seqNo);
        domain.setUrl(this.url);
        return domain;
    }

    public Integer getMenuId() {
        return menuId;
    }

    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }

    public String getClassPath() {
        return classPath;
    }

    public void setClassPath(String classPath) {
        this.classPath = classPath;
    }

    public Integer getIsActive() {
        return isActive;
    }

    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOtherName() {
        return otherName;
    }

    public void setOtherName(String otherName) {
        this.otherName = otherName;
    }

    public Integer getParentIdAdmMenu() {
        return parentIdAdmMenu;
    }

    public void setParentIdAdmMenu(Integer parentIdAdmMenu) {
        this.parentIdAdmMenu = parentIdAdmMenu;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Integer getSeqNo() {
        return seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
