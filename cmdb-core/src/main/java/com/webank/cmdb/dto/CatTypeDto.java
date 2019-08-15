package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import javax.validation.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmBasekeyCatType;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class CatTypeDto extends BasicResourceDto<CatTypeDto, AdmBasekeyCatType> {
    @DtoId
    @DtoField(domainField = "idAdmBasekeyCatType")
    private Integer catTypeId;
    @NotEmpty
    @DtoField(domainField = "name")
    private String catTypeName;
    private Integer ciTypeId;
    private Integer type;
    @DtoField
    private String description;
    @DtoField(domainField = "admBasekeyCats", updatable = false)
    private List<CategoryDto> cats = new LinkedList<>();

    public CatTypeDto() {

    }

    @Override
    public CatTypeDto fromDomain(AdmBasekeyCatType domainObj, List<String> refResource) {
        CatTypeDto dto = new CatTypeDto();
        dto.setCatTypeId(domainObj.getIdAdmBasekeyCatType());
        dto.setCatTypeName(domainObj.getName());
        dto.setDescription(domainObj.getDescription());
        dto.setCiTypeId(domainObj.getCiTypeId());
        dto.setType(domainObj.getType());

        if (refResource != null && refResource.contains("cats")) {
            List<String> catReses = CollectionUtils.filterCurrentResourceLevel(refResource, "cats");
            domainObj.getAdmBasekeyCats().forEach(x -> {
                dto.cats.add(new CategoryDto().fromDomain(x, catReses));
            });
        }
        return dto;
    }

    @Override
    public Class<AdmBasekeyCatType> domainClazz() {
        return AdmBasekeyCatType.class;
    }

    public CatTypeDto(int baseKeyCatTypeId, String catTypeName, String description) {
        this.catTypeId = baseKeyCatTypeId;
        this.catTypeName = catTypeName;
        this.description = description;
    }

    public static CatTypeDto from(AdmBasekeyCatType domain, boolean withChild) {
        CatTypeDto dto = new CatTypeDto(domain.getIdAdmBasekeyCatType(), domain.getName(), domain.getDescription());
        if (withChild) {
            domain.getAdmBasekeyCats().forEach(x -> {
                dto.cats.add(CategoryDto.fromAdmBasekeyCat(x, false));
            });
        }
        return dto;
    }

    public AdmBasekeyCatType toDomain() {
        AdmBasekeyCatType domain = new AdmBasekeyCatType();
        domain.setName(this.getCatTypeName());
        domain.setDescription(this.getDescription());
        domain.setCiTypeId(this.getCiTypeId());
        domain.setType(this.getType());
        return domain;
    }

    public Integer getCatTypeId() {
        return catTypeId;
    }

    public void setCatTypeId(Integer catTypeId) {
        this.catTypeId = catTypeId;
    }

    public String getCatTypeName() {
        return catTypeName;
    }

    public void setCatTypeName(String catTypeName) {
        this.catTypeName = catTypeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public List<CategoryDto> getCats() {
        return cats;
    }

    public void setCats(List<CategoryDto> cats) {
        this.cats = cats;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("catTypeId", catTypeId).add("catTypeName", catTypeName).add("ciTypeId", ciTypeId).add("type", type).add("description", description).add("cats", cats).toString();
    }
}
