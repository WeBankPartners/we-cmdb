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
import com.webank.cmdb.domain.AdmRoleCiType;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_EMPTY)
public class RoleCiTypeDto extends BasicResourceDto<RoleCiTypeDto, AdmRoleCiType> {
    @DtoId
    @DtoField(domainField = "idAdmRoleCiType")
    private Integer roleCiTypeId;

    private Integer ciTypeId;
    private Integer roleId;
    private String ciTypeName;

    private String creationPermission = DISABLED;
    private String removalPermission = DISABLED;
    private String modificationPermission = DISABLED;
    private String enquiryPermission = DISABLED;
    private String executionPermission = DISABLED;
    private String grantPermission = DISABLED;

    @DtoField(domainField = "admCiType", updatable = false)
    private CiTypeDto ciType = new CiTypeDto();

    @DtoField(domainField = "admRole", updatable = false)
    private RoleDto role = new RoleDto();

    @DtoField(domainField = "admRoleCiTypeCtrlAttrs", updatable = false)
    private List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs = new LinkedList<>();

    public RoleCiTypeDto() {
    }

    public RoleCiTypeDto(Integer roleId, Integer ciTypeId, String ciTypeName) {
        this.ciTypeId = ciTypeId;
        this.roleId = roleId;
        this.ciTypeName = ciTypeName;
    }

    @Override
    public RoleCiTypeDto fromDomain(AdmRoleCiType domain, List<String> refResource) {
        RoleCiTypeDto dto = from(domain, false);

        if (refResource != null) {
            if (refResource.contains("ciType")) {
                List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "ciType");
                dto.ciType = new CiTypeDto().fromDomain(domain.getAdmCiType(), fields);
            }
            if (refResource.contains("role")) {
                List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "role");
                dto.role = new RoleDto().fromDomain(domain.getAdmRole(), fields);
            }
            if (refResource.contains("roleCiTypeCtrlAttrs")) {
                List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "roleCiTypeCtrlAttrs");
                domain.getAdmRoleCiTypeCtrlAttrs().forEach(x -> {
                    dto.roleCiTypeCtrlAttrs.add(new RoleCiTypeCtrlAttrDto().fromDomain(x, fields));
                });
            }
        }
        return dto;
    }

    @Override
    public Class<AdmRoleCiType> domainClazz() {
        return AdmRoleCiType.class;
    }

    public static RoleCiTypeDto from(AdmRoleCiType domain, boolean withChild) {
        RoleCiTypeDto dto = new RoleCiTypeDto();
        dto.setRoleCiTypeId(domain.getIdAdmRoleCiType());
        dto.setCiTypeId(domain.getCiTypeId());
        dto.setRoleId(domain.getRoleId());
        dto.setCiTypeName(domain.getCiTypeName());

        dto.setCreationPermission(domain.getCreationPermission());
        dto.setRemovalPermission(domain.getRemovalPermission());
        dto.setModificationPermission(domain.getModificationPermission());
        dto.setEnquiryPermission(domain.getEnquiryPermission());
        dto.setExecutionPermission(domain.getExecutionPermission());
        dto.setGrantPermission(domain.getGrantPermission());

        if (withChild) {
            dto.ciType = CiTypeDto.fromAdmCIType(domain.getAdmCiType());
            dto.role = RoleDto.from(domain.getAdmRole(), false);
            domain.getAdmRoleCiTypeCtrlAttrs().forEach(x -> {
                dto.roleCiTypeCtrlAttrs.add(RoleCiTypeCtrlAttrDto.from(x, false));
            });
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
            throw new CmdbException("Unsupported action code: " + action).withErrorCode("3054", action);
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
            throw new CmdbException("Unsupported action code: " + action).withErrorCode("3054", action);
        }
    }

    public Integer getRoleCiTypeId() {
        return roleCiTypeId;
    }

    public void setRoleCiTypeId(Integer roleCiTypeId) {
        this.roleCiTypeId = roleCiTypeId;
    }

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public String getCiTypeName() {
        return ciTypeName;
    }

    public void setCiTypeName(String ciTypeName) {
        this.ciTypeName = ciTypeName;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
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

    public CiTypeDto getCiType() {
        return ciType;
    }

    public void setCiType(CiTypeDto ciType) {
        this.ciType = ciType;
    }

    public RoleDto getRole() {
        return role;
    }

    public void setRole(RoleDto role) {
        this.role = role;
    }

    public List<RoleCiTypeCtrlAttrDto> getRoleCiTypeCtrlAttrs() {
        return roleCiTypeCtrlAttrs;
    }

    public void setRoleCiTypeCtrlAttrs(List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs) {
        this.roleCiTypeCtrlAttrs = roleCiTypeCtrlAttrs;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("roleCiTypeId", roleCiTypeId)
                .add("ciTypeId", ciTypeId)
                .add("roleId", roleId)
                .add("ciTypeName", ciTypeName)
                .add("creationPermission", creationPermission)
                .add("removalPermission", removalPermission)
                .add("modificationPermission", modificationPermission)
                .add("enquiryPermission", enquiryPermission)
                .add("executionPermission", executionPermission)
                .add("grantPermission", grantPermission)
                .toString();
    }
}
