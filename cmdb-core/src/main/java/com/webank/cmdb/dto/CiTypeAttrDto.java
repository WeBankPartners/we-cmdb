package com.webank.cmdb.dto;

import java.util.List;

import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.sun.org.apache.xpath.internal.operations.Bool;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class CiTypeAttrDto extends BasicResourceDto<CiTypeAttrDto, AdmCiTypeAttr> {
    @DtoId
    @DtoField(domainField = "idAdmCiTypeAttr")
    private Integer ciTypeAttrId;
    @NotNull
    private Integer ciTypeId = null;
    private String description;
    private Integer displaySeqNo;

    @DtoField(domainField = "displayType")
    private Boolean isDisplayed;
    // TODO: check usage
    @DtoField(domainField = "editIsEditable")
    private Boolean isEditable;
    @DtoField(domainField = "editIsHiden")
    private Boolean isHidden;
    @NotNull
    @DtoField(domainField = "editIsNull")
    private Boolean isNullable = null;
    @NotNull
    @DtoField(domainField = "editIsOnly")
    private Boolean isUnique = null;
    @NotNull
    private String inputType = null;
    // TODO: check usage
    private Boolean isDefunct;
    // default to false for new created attribute
    private Boolean isSystem = false;
    private Integer length;
    @NotNull
    private String name =  null;
    @NotNull
    private String propertyName = null;
    @NotNull
    private String propertyType = null;
    private Integer referenceId;
    private Integer searchSeqNo;
    // TODO: check usage
    private String specialLogic;
    @DtoField(updatable = false)
    private String status;
    private String referenceName;
    private Integer referenceType;
    private Boolean isAccessControlled;
    private Boolean isAuto;
    private String autoFillRule;
    private String filterRule;
    private Boolean isRefreshable;
    private String regularExpressionRule;
    private Boolean isDeleteValidate;

    // reference resource
    @DtoField(domainField = "admCiType", updatable = false)
    private CiTypeDto ciType = new CiTypeDto();

    public CiTypeAttrDto() {
    }

    public CiTypeAttrDto(Integer ciTypeAttrId) {
        this.ciTypeAttrId = ciTypeAttrId;
    }

    @Override
    public CiTypeAttrDto fromDomain(AdmCiTypeAttr admCiTypeAttr, List<String> refResource) {
        CiTypeAttrDto ciTypeAttr = new CiTypeAttrDto();
        ciTypeAttr.setCiTypeId(admCiTypeAttr.getCiTypeId());
        ciTypeAttr.setCiTypeAttrId(admCiTypeAttr.getIdAdmCiTypeAttr());
        ciTypeAttr.setDescription(admCiTypeAttr.getDescription());
        ciTypeAttr.setDisplaySeqNo(admCiTypeAttr.getDisplaySeqNo());
        ciTypeAttr.setIsDisplayed(admCiTypeAttr.getDisplayType() == null ? false : admCiTypeAttr.getDisplayType() != 0);
        ciTypeAttr.setIsEditable(admCiTypeAttr.getEditIsEditable() == null ? false : admCiTypeAttr.getEditIsEditable() != 0);
        ciTypeAttr.setIsHidden(admCiTypeAttr.getEditIsHiden() == null ? false : admCiTypeAttr.getEditIsHiden() != 0);
        ciTypeAttr.setIsNullable(admCiTypeAttr.getEditIsNull() == null ? false : admCiTypeAttr.getEditIsNull() != 0);
        ciTypeAttr.setIsUnique(admCiTypeAttr.getEditIsOnly() == null ? false : admCiTypeAttr.getEditIsOnly() != 0);
        ciTypeAttr.setInputType(admCiTypeAttr.getInputType());
        ciTypeAttr.setIsDefunct(new Integer(1).equals(admCiTypeAttr.getIsDefunct()));
        ciTypeAttr.setIsSystem(admCiTypeAttr.getIsSystem() == 1);
        ciTypeAttr.setLength(admCiTypeAttr.getLength());
        ciTypeAttr.setName(admCiTypeAttr.getName());
        ciTypeAttr.setPropertyName(admCiTypeAttr.getPropertyName());
        ciTypeAttr.setPropertyType(admCiTypeAttr.getPropertyType());
        ciTypeAttr.setReferenceId(admCiTypeAttr.getReferenceId());
        ciTypeAttr.setSearchSeqNo(admCiTypeAttr.getSearchSeqNo());
        ciTypeAttr.setSpecialLogic(admCiTypeAttr.getSpecialLogic());
        ciTypeAttr.setStatus(admCiTypeAttr.getStatus());
        ciTypeAttr.setReferenceName(admCiTypeAttr.getReferenceName());
        // ciTypeAttr.setReferenceType(getCodeName(admCiTypeAttr.getReferenceType()));
        ciTypeAttr.setReferenceType(admCiTypeAttr.getReferenceType());
        ciTypeAttr.setIsAuto(admCiTypeAttr.getIsAuto() == null ? false : admCiTypeAttr.getIsAuto() != 0);
        ciTypeAttr.setIsAccessControlled(admCiTypeAttr.getIsAccessControlled() == null ? false : admCiTypeAttr.getIsAccessControlled() != 0);
        ciTypeAttr.setAutoFillRule(admCiTypeAttr.getAutoFillRule());
        ciTypeAttr.setFilterRule(admCiTypeAttr.getFilterRule());
        ciTypeAttr.setIsRefreshable(admCiTypeAttr.getIsRefreshable() == null ? false : admCiTypeAttr.getIsRefreshable() != 0);
        if (refResource != null && refResource.contains("ciType")) {
            ciTypeAttr.setCiType(CiTypeDto.fromAdmCIType(admCiTypeAttr.getAdmCiType()));
        }
        ciTypeAttr.setRegularExpressionRule(admCiTypeAttr.getRegularExpressionRule());
        ciTypeAttr.setIsDeleteValidate(admCiTypeAttr.getIsDeleteValidate() == null ? false : admCiTypeAttr.getIsDeleteValidate() != 0);

        return ciTypeAttr;
    }

    @Override
    public Class<AdmCiTypeAttr> domainClazz() {
        return AdmCiTypeAttr.class;
    }

    public static CiTypeAttrDto fromAdmCiTypeAttrs(AdmCiTypeAttr admCiTypeAttr) {
        CiTypeAttrDto ciTypeAttr = new CiTypeAttrDto();
        ciTypeAttr.setCiTypeId(admCiTypeAttr.getCiTypeId());
        ciTypeAttr.setCiTypeAttrId(admCiTypeAttr.getIdAdmCiTypeAttr());
        ciTypeAttr.setDescription(admCiTypeAttr.getDescription());
        ciTypeAttr.setDisplaySeqNo(admCiTypeAttr.getDisplaySeqNo());
        ciTypeAttr.setIsDisplayed(admCiTypeAttr.getDisplayType() == null ? false : admCiTypeAttr.getDisplayType() != 0);
        ciTypeAttr.setIsEditable(admCiTypeAttr.getEditIsEditable() == null ? false : admCiTypeAttr.getEditIsEditable() != 0);
        ciTypeAttr.setIsHidden(admCiTypeAttr.getEditIsHiden() == null ? false : admCiTypeAttr.getEditIsHiden() != 0);
        ciTypeAttr.setIsNullable(admCiTypeAttr.getEditIsNull() == null ? false : admCiTypeAttr.getEditIsNull() != 0);
        ciTypeAttr.setIsUnique(admCiTypeAttr.getEditIsOnly() == null ? false : admCiTypeAttr.getEditIsOnly() != 0);
        ciTypeAttr.setInputType(admCiTypeAttr.getInputType());
        ciTypeAttr.setIsDefunct(new Integer(1).equals(admCiTypeAttr.getIsDefunct()));
        ciTypeAttr.setIsSystem(admCiTypeAttr.getIsSystem() == 1);
        ciTypeAttr.setLength(admCiTypeAttr.getLength());
        ciTypeAttr.setName(admCiTypeAttr.getName());
        ciTypeAttr.setPropertyName(admCiTypeAttr.getPropertyName());
        ciTypeAttr.setPropertyType(admCiTypeAttr.getPropertyType());
        ciTypeAttr.setReferenceId(admCiTypeAttr.getReferenceId());
        ciTypeAttr.setSearchSeqNo(admCiTypeAttr.getSearchSeqNo());
        ciTypeAttr.setSpecialLogic(admCiTypeAttr.getSpecialLogic());
        ciTypeAttr.setStatus(admCiTypeAttr.getStatus());
        ciTypeAttr.setReferenceName(admCiTypeAttr.getReferenceName());
        // ciTypeAttr.setReferenceType(getCodeName(admCiTypeAttr.getReferenceType()));
        ciTypeAttr.setReferenceType(admCiTypeAttr.getReferenceType());
        ciTypeAttr.setIsAuto(admCiTypeAttr.getIsAuto() == null ? false : admCiTypeAttr.getIsAuto() != 0);
        ciTypeAttr.setIsAccessControlled(admCiTypeAttr.getIsAccessControlled() == null ? false : admCiTypeAttr.getIsAccessControlled() != 0);
        ciTypeAttr.setAutoFillRule(admCiTypeAttr.getAutoFillRule());
        ciTypeAttr.setFilterRule(admCiTypeAttr.getFilterRule());
        ciTypeAttr.setIsRefreshable(admCiTypeAttr.getIsRefreshable() == null ? false : admCiTypeAttr.getIsRefreshable() != 0);
        ciTypeAttr.setRegularExpressionRule(admCiTypeAttr.getRegularExpressionRule());
        ciTypeAttr.setIsDeleteValidate(admCiTypeAttr.getIsDeleteValidate() == null? false : admCiTypeAttr.getIsDeleteValidate() != 0);
        return ciTypeAttr;
    }

    public AdmCiTypeAttr toAdmCiTypeAttr() {
        AdmCiTypeAttr admCiTypeAttr = new AdmCiTypeAttr();
        admCiTypeAttr.setCiTypeId(this.getCiTypeId());
        admCiTypeAttr.setDescription(this.description);
        admCiTypeAttr.setDisplaySeqNo(this.displaySeqNo);
        admCiTypeAttr.setDisplayType(Boolean.TRUE.equals(this.isDisplayed) ? 1 : 0);
        admCiTypeAttr.setEditIsEditable(Boolean.TRUE.equals(this.isEditable) ? 1 : 0);
        admCiTypeAttr.setEditIsHiden(Boolean.TRUE.equals(this.isHidden) ? 1 : 0);
        admCiTypeAttr.setEditIsNull(Boolean.TRUE.equals(this.isNullable) ? 1 : 0);
        admCiTypeAttr.setEditIsOnly(Boolean.TRUE.equals(this.isUnique) ? 1 : 0);
        admCiTypeAttr.setInputType(this.inputType);
        admCiTypeAttr.setIsDefunct(Boolean.TRUE.equals(this.isDefunct) ? 1 : 0);
        admCiTypeAttr.setIsSystem(Boolean.TRUE.equals(this.isSystem) ? 1 : 0);
        admCiTypeAttr.setLength(this.length);
        admCiTypeAttr.setName(this.name);
        admCiTypeAttr.setPropertyName(this.propertyName);
        admCiTypeAttr.setPropertyType(this.propertyType);
        admCiTypeAttr.setReferenceId(this.referenceId);
        admCiTypeAttr.setSearchSeqNo(this.searchSeqNo);
        admCiTypeAttr.setSpecialLogic(this.specialLogic);
        admCiTypeAttr.setStatus(this.status);
        admCiTypeAttr.setReferenceName(this.referenceName);
        // admCiTypeAttr.setReferenceType(getReferenceTypeCode(this.referenceType));
        admCiTypeAttr.setReferenceType(this.referenceType);
        admCiTypeAttr.setIsAccessControlled(Boolean.TRUE.equals(this.isAccessControlled) ? 1 : 0);
        admCiTypeAttr.setIsAuto(Boolean.TRUE.equals(this.isAuto) ? 1 : 0);
        admCiTypeAttr.setAutoFillRule(this.autoFillRule);
        admCiTypeAttr.setFilterRule(this.getFilterRule());
        admCiTypeAttr.setIsRefreshable(Boolean.TRUE.equals(this.isRefreshable) ? 1 : 0);
        admCiTypeAttr.setRegularExpressionRule(this.getRegularExpressionRule());
        admCiTypeAttr.setIsDeleteValidate(Boolean.TRUE.equals(this.isDeleteValidate)? 1 : 0);
        return admCiTypeAttr;
    }

    public AdmCiTypeAttr updateToAdmCiTypeAttr(AdmCiTypeAttr toUpdateAttr) {
        // TO DO : Null field shouldn't override to domain object.
        toUpdateAttr.setCiTypeId(this.ciTypeId);
        toUpdateAttr.setDescription(this.description);
        toUpdateAttr.setDisplaySeqNo(this.displaySeqNo);
        toUpdateAttr.setDisplayType(Boolean.TRUE.equals(this.isDisplayed) ? 1 : 0);
        toUpdateAttr.setEditIsEditable(Boolean.TRUE.equals(this.isEditable) ? 1 : 0);
        toUpdateAttr.setEditIsHiden(Boolean.TRUE.equals(this.isHidden) ? 1 : 0);
        toUpdateAttr.setEditIsNull(Boolean.TRUE.equals(this.isNullable) ? 1 : 0);
        toUpdateAttr.setEditIsOnly(Boolean.TRUE.equals(this.isUnique) ? 1 : 0);
        toUpdateAttr.setInputType(this.inputType);
        toUpdateAttr.setIsDefunct(Boolean.TRUE.equals(this.isDefunct) ? 1 : 0);
        toUpdateAttr.setIsSystem(Boolean.TRUE.equals(this.isSystem) ? 1 : 0);
        toUpdateAttr.setLength(this.length);
        toUpdateAttr.setName(this.name);
        toUpdateAttr.setPropertyName(this.propertyName);
        toUpdateAttr.setPropertyType(this.propertyType);
        toUpdateAttr.setSearchSeqNo(this.searchSeqNo);
        toUpdateAttr.setSpecialLogic(this.specialLogic);
        toUpdateAttr.setStatus(this.status);
        toUpdateAttr.setReferenceName(this.referenceName);
        toUpdateAttr.setReferenceId(this.referenceId);
        // toUpdateAttr.setReferenceType(getReferenceTypeCode(this.referenceType));
        toUpdateAttr.setReferenceType(this.referenceType);
        toUpdateAttr.setIsAccessControlled(Boolean.TRUE.equals(this.isAccessControlled) ? 1 : 0);
        toUpdateAttr.setIsAuto(Boolean.TRUE.equals(this.isAuto) ? 1 : 0);
        toUpdateAttr.setAutoFillRule(this.autoFillRule);
        toUpdateAttr.setFilterRule(this.getFilterRule());
        toUpdateAttr.setIsRefreshable(Boolean.TRUE.equals(this.isRefreshable) ? 1 : 0);
        toUpdateAttr.setRegularExpressionRule(this.getRegularExpressionRule());
        toUpdateAttr.setIsDeleteValidate(Boolean.TRUE.equals(this.isDeleteValidate)? 1 : 0);
        return toUpdateAttr;

    }

    public Integer getCiTypeAttrId() {
        return ciTypeAttrId;
    }

    public void setCiTypeAttrId(Integer admCiTypeAttrId) {
        this.ciTypeAttrId = admCiTypeAttrId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDisplaySeqNo() {
        return displaySeqNo;
    }

    public void setDisplaySeqNo(Integer displaySeqNo) {
        this.displaySeqNo = displaySeqNo;
    }

    public Boolean getIsEditable() {
        return isEditable;
    }

    public void setIsEditable(Boolean isEditable) {
        this.isEditable = isEditable;
    }

    public Boolean getIsHidden() {
        return isHidden;
    }

    public void setIsHidden(Boolean isHidden) {
        this.isHidden = isHidden;
    }

    public Boolean getIsNullable() {
        return isNullable;
    }

    public void setIsNullable(Boolean isNullable) {
        this.isNullable = isNullable;
    }

    public Boolean getIsUnique() {
        return isUnique;
    }

    public void setIsUnique(Boolean isUnique) {
        this.isUnique = isUnique;
    }

    public String getInputType() {
        return inputType;
    }

    public void setInputType(String inputType) {
        this.inputType = inputType;
    }

    public Boolean getIsDefunct() {
        return isDefunct;
    }

    public void setIsDefunct(Boolean isDefunct) {
        this.isDefunct = isDefunct;
    }

    public Boolean getIsSystem() {
        return isSystem;
    }

    public void setIsSystem(Boolean isSystem) {
        this.isSystem = isSystem;
    }

    public Integer getLength() {
        return length;
    }

    public void setLength(Integer length) {
        this.length = length;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    public String getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public Integer getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public Integer getSearchSeqNo() {
        return searchSeqNo;
    }

    public void setSearchSeqNo(Integer searchSeqNo) {
        this.searchSeqNo = searchSeqNo;
    }

    public String getSpecialLogic() {
        return specialLogic;
    }

    public void setSpecialLogic(String specialLogic) {
        this.specialLogic = specialLogic;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReferenceName() {
        return referenceName;
    }

    public void setReferenceName(String referenceName) {
        this.referenceName = referenceName;
    }

    public Integer getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(Integer referenceType) {
        this.referenceType = referenceType;
    }

    public Boolean getIsAccessControlled() {
        return isAccessControlled;
    }

    public void setIsAccessControlled(Boolean isAccessControlled) {
        this.isAccessControlled = isAccessControlled;
    }

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public CiTypeDto getCiType() {
        return ciType;
    }

    public void setCiType(CiTypeDto ciType) {
        this.ciType = ciType;
    }

    public Boolean getIsAuto() {
        return isAuto;
    }

    public void setIsAuto(Boolean isAuto) {
        this.isAuto = isAuto;
    }

    public String getAutoFillRule() {
        return autoFillRule;
    }

    public void setAutoFillRule(String autoFillRule) {
        this.autoFillRule = autoFillRule;
    }

    public String getFilterRule() {
        return filterRule;
    }

    public void setFilterRule(String filterRule) {
        this.filterRule = filterRule;
    }

    public Boolean getIsRefreshable() {
        return isRefreshable;
    }

    public void setIsRefreshable(Boolean isRefreshable) {
        this.isRefreshable = isRefreshable;
    }

    public Boolean getIsDisplayed() {
        return isDisplayed;
    }

    public void setIsDisplayed(Boolean isDisplayed) {
        this.isDisplayed = isDisplayed;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("ciTypeAttrId", ciTypeAttrId)
                .add("ciTypeId", ciTypeId)
                .add("description", description)
                .add("displaySeqNo", displaySeqNo)
                .add("isDisplayed", isDisplayed)
                .add("isEditable", isEditable)
                .add("isHidden", isHidden)
                .add("isNullable", isNullable)
                .add("isUnique", isUnique)
                .add("inputType", inputType)
                .add("isDefunct", isDefunct)
                .add("isSystem", isSystem)
                .add("length", length)
                .add("name", name)
                .add("propertyName", propertyName)
                .add("propertyType", propertyType)
                .add("referenceId", referenceId)
                .add("searchSeqNo", searchSeqNo)
                .add("specialLogic", specialLogic)
                .add("status", status)
                .add("referenceName", referenceName)
                .add("referenceType", referenceType)
                .add("isAccessControlled", isAccessControlled)
                .add("isAuto", isAuto)
                .add("autoFillRule", autoFillRule)
                .add("filterRule", filterRule)
                .add("isRefreshable", isRefreshable)
                .add("regularExpressionRule", regularExpressionRule)
                .add("isDeleteValidate", isDeleteValidate)
                .toString();
    }

    public String getRegularExpressionRule() {
        return regularExpressionRule;
    }

    public void setRegularExpressionRule(String regularExpressionRule) {
        this.regularExpressionRule = regularExpressionRule;
    }

    public Boolean getIsDeleteValidate() {
        return isDeleteValidate;
    }

    public void setIsDeleteValidate(Boolean deleteValidate) {
        isDeleteValidate = deleteValidate;
    }
}
