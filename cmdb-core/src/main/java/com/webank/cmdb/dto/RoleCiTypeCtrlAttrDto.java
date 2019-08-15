package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttr;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_EMPTY)
public class RoleCiTypeCtrlAttrDto extends BasicResourceDto<RoleCiTypeCtrlAttrDto, AdmRoleCiTypeCtrlAttr> {
    @DtoId
    @DtoField(domainField = "idAdmRoleCiTypeCtrlAttr")
    private Integer roleCiTypeCtrlAttrId;
    private Integer roleCiTypeId;
    private String creationPermission;
    private String removalPermission;
    private String modificationPermission;
    private String enquiryPermission;
    private String executionPermission;
    private String grantPermission;

    @DtoField(domainField = "admRoleCiType", updatable = false)
    private RoleCiTypeDto roleCiType = new RoleCiTypeDto();

    @DtoField(domainField = "admRoleCiTypeCtrlAttrConditions", updatable = false)
    private List<RoleCiTypeCtrlAttrConditionDto> conditions = new LinkedList<>();

    public RoleCiTypeCtrlAttrDto() {
    }

    @Override
    public RoleCiTypeCtrlAttrDto fromDomain(AdmRoleCiTypeCtrlAttr domain, List<String> refResource) {
        RoleCiTypeCtrlAttrDto dto = from(domain, false);

        if (refResource != null && refResource.contains("roleCiType")) {
            List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "roleCiType");
            dto.roleCiType = new RoleCiTypeDto().fromDomain(domain.getAdmRoleCiType(), fields);
        }

        if (refResource != null && refResource.contains("conditions")) {
            List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "conditions");
            domain.getAdmRoleCiTypeCtrlAttrConditions().forEach(x -> {
                dto.conditions.add(new RoleCiTypeCtrlAttrConditionDto().fromDomain(x, fields));
            });
        }
        return dto;
    }

    @Override
    public Class<AdmRoleCiTypeCtrlAttr> domainClazz() {
        return AdmRoleCiTypeCtrlAttr.class;
    }

    public static RoleCiTypeCtrlAttrDto from(AdmRoleCiTypeCtrlAttr domain, boolean withChild) {
        RoleCiTypeCtrlAttrDto dto = new RoleCiTypeCtrlAttrDto();
        dto.setRoleCiTypeCtrlAttrId(domain.getIdAdmRoleCiTypeCtrlAttr());
        dto.setRoleCiTypeId(domain.getRoleCiTypeId());
        dto.setCreationPermission(domain.getCreationPermission());
        dto.setRemovalPermission(domain.getRemovalPermission());
        dto.setModificationPermission(domain.getModificationPermission());
        dto.setEnquiryPermission(domain.getEnquiryPermission());
        dto.setExecutionPermission(domain.getExecutionPermission());
        dto.setGrantPermission(domain.getGrantPermission());

        if (withChild) {
            dto.roleCiType = RoleCiTypeDto.from(domain.getAdmRoleCiType(), false);
            domain.getAdmRoleCiTypeCtrlAttrConditions().forEach(x -> {
                dto.conditions.add(RoleCiTypeCtrlAttrConditionDto.from(x, false));
            });
        }
        return dto;
    }

    public Integer getRoleCiTypeCtrlAttrId() {
        return roleCiTypeCtrlAttrId;
    }

    public void setRoleCiTypeCtrlAttrId(Integer roleCiTypeCtrlAttrId) {
        this.roleCiTypeCtrlAttrId = roleCiTypeCtrlAttrId;
    }

    public Integer getRoleCiTypeId() {
        return roleCiTypeId;
    }

    public void setRoleCiTypeId(Integer roleCiTypeId) {
        this.roleCiTypeId = roleCiTypeId;
    }

    public String getCreationPermission() {
        return creationPermission;
    }

    public void setCreationPermission(String creationPermission) {
        this.creationPermission = creationPermission;
    }

    public String getRemovalPermission() {
        return removalPermission;
    }

    public void setRemovalPermission(String removalPermission) {
        this.removalPermission = removalPermission;
    }

    public String getModificationPermission() {
        return modificationPermission;
    }

    public void setModificationPermission(String modificationPermission) {
        this.modificationPermission = modificationPermission;
    }

    public String getEnquiryPermission() {
        return enquiryPermission;
    }

    public void setEnquiryPermission(String enquiryPermission) {
        this.enquiryPermission = enquiryPermission;
    }

    public String getExecutionPermission() {
        return executionPermission;
    }

    public void setExecutionPermission(String executionPermission) {
        this.executionPermission = executionPermission;
    }

    public String getGrantPermission() {
        return grantPermission;
    }

    public void setGrantPermission(String grantPermission) {
        this.grantPermission = grantPermission;
    }

    public RoleCiTypeDto getRoleCiType() {
        return roleCiType;
    }

    public void setRoleCiType(RoleCiTypeDto roleCiType) {
        this.roleCiType = roleCiType;
    }

    public List<RoleCiTypeCtrlAttrConditionDto> getConditions() {
        return conditions;
    }

    public void setConditions(List<RoleCiTypeCtrlAttrConditionDto> conditions) {
        this.conditions = conditions;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("roleCiTypeCtrlAttrId", roleCiTypeCtrlAttrId)
                .add("roleCiTypeId", roleCiTypeId)
                .add("creationPermission", creationPermission)
                .add("removalPermission", removalPermission)
                .add("modificationPermission", modificationPermission)
                .add("enquiryPermission", enquiryPermission)
                .add("executionPermission", executionPermission)
                .add("grantPermission", grantPermission)
                .add("conditions", conditions)
                .toString();
    }
}
