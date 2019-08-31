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
    private Integer id;
    private String classPath;
    private Integer isActive;
    private String code;
    private String otherName;
    private Integer parentId;
    private String decription;
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
        dto.setId(domain.getIdAdmMenu());
        dto.setClassPath(domain.getClassPath());
        dto.setIsActive(domain.getIsActive());
        dto.setCode(domain.getName());
        dto.setOtherName(domain.getOtherName());
        dto.setParentId(domain.getParentIdAdmMenu());
        dto.setDecription(domain.getRemark());
        dto.setSeqNo(domain.getSeqNo());
        dto.setUrl(domain.getUrl());
        if (withChild) {
        }
        return dto;
    }

    public AdmMenu toDomain() {
        AdmMenu domain = new AdmMenu();
        domain.setIdAdmMenu(this.id);
        domain.setClassPath(this.classPath);
        domain.setIsActive(this.isActive);
        domain.setName(this.code);
        domain.setOtherName(this.otherName);
        domain.setParentIdAdmMenu(this.parentId);
        domain.setRemark(this.decription);
        domain.setSeqNo(this.seqNo);
        domain.setUrl(this.url);
        return domain;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public String getCode() {
        return code;
    }

    public void setCode(String name) {
        this.code = name;
    }

    public String getOtherName() {
        return otherName;
    }

    public void setOtherName(String otherName) {
        this.otherName = otherName;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getDescription() {
        return decription;
    }

    public void setDecription(String decription) {
        this.decription = decription;
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
