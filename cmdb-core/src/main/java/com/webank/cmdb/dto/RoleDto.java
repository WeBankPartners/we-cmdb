package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmRole;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class RoleDto extends BasicResourceDto<RoleDto, AdmRole> {
    @DtoId
    @DtoField(domainField = "idAdmRole")
    private Integer roleId;
    private String roleName;
    private String roleType;
    private String description;
    private Boolean isSystem;
    @DtoField(domainField = "admRoleUsers", updatable = false)
    private List<RoleUserDto> roleUsers = new LinkedList<>();
    @DtoField(domainField = "admRoleMenus", updatable = false)
    private List<RoleMenuDto> roleMenus = new LinkedList<>();

    public RoleDto() {
    }

    public RoleDto(Integer roleId, String roleName, String roleType, String description, Boolean isSystem) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.roleType = roleType;
        this.description = description;
        this.isSystem = isSystem;
    }

    @Override
    public RoleDto fromDomain(AdmRole domainObj, List<String> refResource) {
        RoleDto dto = from(domainObj, false);

        if (refResource != null && refResource.contains("roleUsers")) {
            List<String> userReses = CollectionUtils.filterCurrentResourceLevel(refResource, "roleUsers");
            domainObj.getAdmRoleUsers().forEach(x -> {
                dto.roleUsers.add(new RoleUserDto().fromDomain(x, userReses));
            });
        }

        if (refResource != null && refResource.contains("roleMenus")) {
            List<String> menuReses = CollectionUtils.filterCurrentResourceLevel(refResource, "roleMenus");
            domainObj.getAdmRoleMenus().forEach(x -> {
                dto.roleMenus.add(new RoleMenuDto().fromDomain(x, menuReses));
            });
        }

        return dto;
    }

    @Override
    public Class<AdmRole> domainClazz() {
        return AdmRole.class;
    }

    public static RoleDto from(AdmRole domain, boolean withChild) {
        RoleDto dto = new RoleDto(domain.getIdAdmRole(), domain.getRoleName(), domain.getRoleType(), domain.getDescription(), domain.getIsSystem() == null ? false : domain.getIsSystem() != 0);
        if (withChild) {
            domain.getAdmRoleUsers().forEach(x -> dto.roleUsers.add(RoleUserDto.from(x, true)));
            domain.getAdmRoleMenus().forEach(x -> dto.roleMenus.add(RoleMenuDto.from(x, true)));
        }
        return dto;
    }

    public AdmRole toDomain() {
        AdmRole domain = new AdmRole();
        domain.setIdAdmRole(this.getRoleId());
        domain.setRoleName(this.getRoleName());
        domain.setRoleType(this.getRoleType());
        domain.setDescription(this.getDescription());
        domain.setIsSystem(Boolean.TRUE.equals(this.isSystem) ? 1 : 0);
        return domain;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getRoleType() {
        return roleType;
    }

    public void setRoleType(String roleType) {
        this.roleType = roleType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<RoleUserDto> getRoleUsers() {
        return roleUsers;
    }

    public void setRoleUsers(List<RoleUserDto> roleUsers) {
        this.roleUsers = roleUsers;
    }

    public List<RoleMenuDto> getRoleMenus() {
        return roleMenus;
    }

    public void setRoleMenus(List<RoleMenuDto> roleMenus) {
        this.roleMenus = roleMenus;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("roleId", roleId).add("roleName", roleName).add("roleType", roleType).add("description", description).toString();
    }

    public Boolean getIsSystem() {
        return isSystem;
    }

    public void setIsSystem(Boolean isSystem) {
        this.isSystem = isSystem;
    }
}
