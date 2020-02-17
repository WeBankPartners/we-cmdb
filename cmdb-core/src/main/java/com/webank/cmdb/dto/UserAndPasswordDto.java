package com.webank.cmdb.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmUser;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

import javax.validation.constraints.NotEmpty;
import java.util.LinkedList;
import java.util.List;

@JsonInclude(Include.NON_NULL)
public class UserAndPasswordDto extends BasicResourceDto<UserAndPasswordDto, AdmUser> {
    @DtoId
    @DtoField(domainField = "idAdmUser")
    private Integer userId;
    @NotEmpty
    @DtoField(domainField = "code")
    private String username;
    @DtoField(domainField = "encryptedPassword")
    private String password;
    @DtoField(domainField = "name")
    private String fullName;
    private String description;
    @DtoField(domainField = "admRoleUsers", updatable = false)
    private List<RoleUserDto> roleUsers = new LinkedList<>();

    public UserAndPasswordDto() {
    }

    public UserAndPasswordDto(Integer userId, @NotEmpty String username, String fullName, String description, String password) {
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.description = description;
        this.password = password;
    }

    @Override
    public UserAndPasswordDto fromDomain(AdmUser domainObj, List<String> refResource) {
        UserAndPasswordDto dto = from(domainObj, false);

        if (refResource != null && refResource.contains("roleusers")) {
            List<String> userReses = CollectionUtils.filterCurrentResourceLevel(refResource, "roleusers");
            domainObj.getAdmRoleUsers().forEach(x -> {
                dto.roleUsers.add(new RoleUserDto().fromDomain(x, userReses));
            });
        }
        return dto;
    }

    @Override
    public Class<AdmUser> domainClazz() {
        return AdmUser.class;
    }

    public static UserAndPasswordDto from(AdmUser domain, boolean withChild) {
        UserAndPasswordDto dto = new UserAndPasswordDto(domain.getIdAdmUser(), domain.getCode(), domain.getName(), domain.getDescription(), domain.getEncryptedPassword());
        if (withChild) {
            domain.getAdmRoleUsers().forEach(x -> {
                dto.roleUsers.add(RoleUserDto.from(x, true));
            });
        }
        return dto;
    }

    public AdmUser toDomain() {
        AdmUser domain = new AdmUser();
        domain.setIdAdmUser(this.getUserId());
        domain.setCode(this.getUsername());
        domain.setName(this.getFullName());
        domain.setEncryptedPassword(this.password);
        domain.setDescription(this.getDescription());
        return domain;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
