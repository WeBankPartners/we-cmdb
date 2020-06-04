package com.webank.cmdb.dto;

import static com.webank.cmdb.dto.CiTypePermissions.ACTION_CREATION;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_ENQUIRY;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_EXECUTION;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_GRANT;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_MODIFICATION;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_REMOVAL;
import static com.webank.cmdb.dto.CiTypePermissions.DISABLED;
import static com.webank.cmdb.dto.CiTypePermissions.ENABLED;
import static com.webank.cmdb.dto.CiTypePermissions.PARTIAL;

import java.util.LinkedList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttr;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_EMPTY)
public class RoleCiTypeCtrlAttrDto extends BasicResourceDto<RoleCiTypeCtrlAttrDto, AdmRoleCiTypeCtrlAttr> {

    @DtoId
    @DtoField(domainField = "idAdmRoleCiTypeCtrlAttr")
    private Integer roleCiTypeCtrlAttrId;
    private Integer roleCiTypeId;
    private String creationPermission = DISABLED;
    private String removalPermission = DISABLED;
    private String modificationPermission = DISABLED;
    private String enquiryPermission = DISABLED;
    private String executionPermission = DISABLED;
    private String grantPermission = DISABLED;

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
        }
        return dto;
    }

    public void enableActionPermission(String action) {
        setActionPermission(action, ENABLED);
    }

    public void disableActionPermission(String action) {
        setActionPermission(action, DISABLED);
    }

    public void enablePartialActionPermission(String action) {
        setActionPermission(action, PARTIAL);
    }

    public boolean isActionPermissionEnabled(String action) {
        return ENABLED.equalsIgnoreCase(getActionPermission(action));
    }

    private void setActionPermission(String action, String value) {
        if (ACTION_CREATION.equalsIgnoreCase(action)) {
            creationPermission = value;
        } else if (ACTION_REMOVAL.equalsIgnoreCase(action)) {
            removalPermission = value;
        } else if (ACTION_MODIFICATION.equalsIgnoreCase(action)) {
            modificationPermission = value;
        } else if (ACTION_ENQUIRY.equalsIgnoreCase(action)) {
            enquiryPermission = value;
        } else if (ACTION_EXECUTION.equalsIgnoreCase(action)) {
            executionPermission = value;
        } else if (ACTION_GRANT.equalsIgnoreCase(action)) {
            grantPermission = value;
        } else {
            throw new CmdbException("Unsupported action code: " + action);
        }
    }

    private String getActionPermission(String action) {
        if (ACTION_CREATION.equalsIgnoreCase(action)) {
            return creationPermission;
        } else if (ACTION_REMOVAL.equalsIgnoreCase(action)) {
            return removalPermission;
        } else if (ACTION_MODIFICATION.equalsIgnoreCase(action)) {
            return modificationPermission;
        } else if (ACTION_ENQUIRY.equalsIgnoreCase(action)) {
            return enquiryPermission;
        } else if (ACTION_EXECUTION.equalsIgnoreCase(action)) {
            return executionPermission;
        } else if (ACTION_GRANT.equalsIgnoreCase(action)) {
            return grantPermission;
        } else {
            throw new CmdbException("Unsupported action code: " + action);
        }
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
