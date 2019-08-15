package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import javax.validation.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class CategoryDto extends BasicResourceDto<CategoryDto, AdmBasekeyCat> {
    @DtoId
    @DtoField(domainField = "idAdmBasekeyCat")
    private Integer catId;
    @NotEmpty
    private String catName;
    private String description;
    private Integer groupTypeId;
    @DtoField(domainField = "idAdmBasekeyCatType")
    private Integer catTypeId;

    @DtoField(domainField = "admBasekeyCatType", updatable = false)
    private CatTypeDto catType;

    @DtoField(domainField = "admBasekeyCodes", updatable = false)
    private List<CatCodeDto> codes = new LinkedList<>();

    public CategoryDto() {
    }

    public CategoryDto(int catId) {
        this.catId = catId;
    }

    @Override
    public CategoryDto fromDomain(AdmBasekeyCat admBasekeyCat, List<String> refResource) {
        CategoryDto baseKeyInfo = new CategoryDto();
        baseKeyInfo.setCatId(admBasekeyCat.getIdAdmBasekeyCat());
        baseKeyInfo.setCatName(admBasekeyCat.getCatName());
        baseKeyInfo.setDescription(admBasekeyCat.getDescription());
        baseKeyInfo.setCatTypeId(admBasekeyCat.getIdAdmBasekeyCatType());
        if (admBasekeyCat.getGroupBasekeyCat() != null) {
            baseKeyInfo.setGroupTypeId(admBasekeyCat.getGroupBasekeyCat().getIdAdmBasekeyCat());
        }

        if (refResource != null && refResource.contains("catType")) {
            List<String> catType = CollectionUtils.filterCurrentResourceLevel(refResource, "catType");
            baseKeyInfo.catType = new CatTypeDto().fromDomain(admBasekeyCat.getAdmBasekeyCatType(), catType);
        }

        if (refResource != null && refResource.contains("codes")) {
            List<String> codeLevelReses = CollectionUtils.filterCurrentResourceLevel(refResource, "codes");
            admBasekeyCat.getAdmBasekeyCodes().forEach(x -> {
                baseKeyInfo.codes.add(new CatCodeDto().fromDomain(x, codeLevelReses));
            });
        }
        baseKeyInfo.setGroupTypeId(admBasekeyCat.getGroupTypeId());
        return baseKeyInfo;
    }

    @Override
    public Class<AdmBasekeyCat> domainClazz() {
        return AdmBasekeyCat.class;
    }

    public static CategoryDto fromAdmBasekeyCat(AdmBasekeyCat admBasekeyCat, boolean withChildHierarchy) {
        CategoryDto baseKeyInfo = new CategoryDto();
        baseKeyInfo.setCatId(admBasekeyCat.getIdAdmBasekeyCat());
        baseKeyInfo.setCatName(admBasekeyCat.getCatName());
        baseKeyInfo.setDescription(admBasekeyCat.getDescription());
        baseKeyInfo.setGroupTypeId(admBasekeyCat.getGroupTypeId());
        if (withChildHierarchy) {
            admBasekeyCat.getAdmBasekeyCodes().forEach(c -> {
                baseKeyInfo.getCodes().add(CatCodeDto.fromAdmBasekeyCode(c));
            });
            baseKeyInfo.getCodes().sort((x, y) -> {
                return x.getSeqNo() - y.getSeqNo();
            });
        }
        return baseKeyInfo;
    }

    public AdmBasekeyCat updateTo(AdmBasekeyCat domain) {
        domain.setCatName(catName);
        domain.setDescription(description);
        return domain;
    }

    public AdmBasekeyCat toDomain(AdmBasekeyCat groupBasekeyCat) {
        AdmBasekeyCat domain = new AdmBasekeyCat();
        domain.setCatName(this.getCatName());
        domain.setDescription(this.getDescription());
        domain.setGroupBasekeyCat(groupBasekeyCat);
        return domain;
    }

    public Integer getCatId() {
        return catId;
    }

    public void setCatId(Integer catId) {
        this.catId = catId;
    }

    public String getCatName() {
        return catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String descritpion) {
        this.description = descritpion;
    }

    public Integer getGroupTypeId() {
        return groupTypeId;
    }

    public void setGroupTypeId(Integer groupTypeId) {
        this.groupTypeId = groupTypeId;
    }

    public Integer getCatTypeId() {
        return catTypeId;
    }

    public void setCatTypeId(Integer catTypeId) {
        this.catTypeId = catTypeId;
    }

    public List<CatCodeDto> getCodes() {
        return codes;
    }

    public void setCodes(List<CatCodeDto> codes) {
        this.codes = codes;
    }

    public CatTypeDto getCatType() {
        return catType;
    }

    public void setCatType(CatTypeDto catType) {
        this.catType = catType;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("catId", catId).add("catName", catName).add("description", description).add("groupTypeId", groupTypeId).add("catTypeId", catTypeId).add("codes", codes).toString();
    }
}
