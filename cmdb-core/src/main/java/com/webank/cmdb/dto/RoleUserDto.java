package com.webank.cmdb.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmRoleUser;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class RoleUserDto extends BasicResourceDto<RoleUserDto, AdmRoleUser> {
    @DtoId
    @DtoField(domainField = "idAdmRoleUser")
    private Integer roleUserId;

    private Integer roleId;
    private String userId;

    @DtoField(domainField = "admRole", updatable = false)
    private RoleDto role;
    @DtoField(domainField = "admUser", updatable = false)
    private UserDto user;

    public RoleUserDto() {
    }

    public RoleUserDto(Integer roleUserId, Integer roleId, String userId) {
        this.roleUserId = roleUserId;
        this.roleId = roleId;
        this.userId = userId;
    }

    public RoleUserDto(Integer roleId, String userId) {
        this.roleId = roleId;
        this.userId = userId;
    }

    @Override
    public RoleUserDto fromDomain(AdmRoleUser domainObj, List<String> refResource) {
        RoleUserDto dto = from(domainObj, false);

        if (refResource != null && refResource.contains("role")) {
            List<String> roleRes = CollectionUtils.filterCurrentResourceLevel(refResource, "role");
            dto.role = new RoleDto().fromDomain(domainObj.getAdmRole(), roleRes);
        }

        if (refResource != null && refResource.contains("user")) {
            List<String> userRes = CollectionUtils.filterCurrentResourceLevel(refResource, "user");
            dto.user = new UserDto().fromDomain(domainObj.getAdmUser(), userRes);
        }

        return dto;
    }

    @Override
    public Class<AdmRoleUser> domainClazz() {
        return AdmRoleUser.class;
    }

    public static RoleUserDto from(AdmRoleUser domain, boolean withChild) {
        RoleUserDto dto = new RoleUserDto(domain.getIdAdmRoleUser(), domain.getRoleId(), domain.getUserId());
        if (withChild) {
            dto.user = UserDto.from(domain.getAdmUser(), false);
            dto.role = RoleDto.from(domain.getAdmRole(), false);
        }
        return dto;
    }

    public AdmRoleUser toDomain() {
        AdmRoleUser domain = new AdmRoleUser();
        domain.setIdAdmRoleUser(this.roleUserId);
        domain.setAdmRole(this.role.toDomain());
        domain.setAdmUser(this.user.toDomain());
        domain.setRoleId(this.roleId);
        domain.setUserId(this.userId);
        return domain;
    }

    public Integer getRoleUserId() {
        return roleUserId;
    }

    public void setRoleUserId(Integer roleUserId) {
        this.roleUserId = roleUserId;
    }

    public RoleDto getRole() {
        return role;
    }

    public void setRole(RoleDto role) {
        this.role = role;
    }

    public UserDto getUser() {
        return user;
    }

    public void setUser(UserDto user) {
        this.user = user;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("roleUserId", roleUserId).add("roleId", roleId).add("userId", userId).toString();
    }
}
