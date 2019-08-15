package com.webank.cmdb.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmRoleMenu;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class RoleMenuDto extends BasicResourceDto<RoleMenuDto, AdmRoleMenu> {
    @DtoId
    @DtoField(domainField = "idAdmRoleMenu")
    private Integer roleMenuId;
    @DtoField(domainField = "idAdmRole")
    private Integer roleId;
    @DtoField(domainField = "idAdmMenu")
    private Integer menuId;

    @DtoField(domainField = "admRole", updatable = false)
    private RoleDto role;
    @DtoField(domainField = "admMenu", updatable = false)
    private MenuDto menu;

    public RoleMenuDto() {
    }

    public RoleMenuDto(Integer roleMenuId, Integer roleId, Integer menuId) {
        this.roleMenuId = roleMenuId;
        this.roleId = roleId;
        this.menuId = menuId;
    }

    @Override
    public RoleMenuDto fromDomain(AdmRoleMenu domainObj, List<String> refResource) {
        RoleMenuDto dto = from(domainObj, false);

        if (refResource != null && refResource.contains("role")) {
            List<String> roleRes = CollectionUtils.filterCurrentResourceLevel(refResource, "role");
            dto.role = new RoleDto().fromDomain(domainObj.getAdmRole(), roleRes);
        }

        if (refResource != null && refResource.contains("menu")) {
            List<String> menuRes = CollectionUtils.filterCurrentResourceLevel(refResource, "menu");
            dto.menu = new MenuDto().fromDomain(domainObj.getAdmMenu(), menuRes);
        }

        return dto;
    }

    @Override
    public Class<AdmRoleMenu> domainClazz() {
        return AdmRoleMenu.class;
    }

    public static RoleMenuDto from(AdmRoleMenu domain, boolean withChild) {
        RoleMenuDto dto = new RoleMenuDto(domain.getIdAdmRoleMenu(), domain.getIdAdmRole(), domain.getIdAdmMenu());
        if (withChild) {
            dto.menu = MenuDto.from(domain.getAdmMenu(), false);
            dto.role = RoleDto.from(domain.getAdmRole(), false);
        }
        return dto;
    }

    public AdmRoleMenu toDomain() {
        AdmRoleMenu domain = new AdmRoleMenu();
        domain.setIdAdmRoleMenu(this.roleMenuId);
        domain.setAdmRole(this.role.toDomain());
        domain.setAdmMenu(this.menu.toDomain());
        domain.setIdAdmRole(this.roleId);
        domain.setIdAdmMenu(this.menuId);
        return domain;
    }

    public Integer getRoleMenuId() {
        return roleMenuId;
    }

    public void setRoleMenuId(Integer roleMenuId) {
        this.roleMenuId = roleMenuId;
    }

    public RoleDto getRole() {
        return role;
    }

    public void setRole(RoleDto role) {
        this.role = role;
    }

    public MenuDto getMenu() {
        return menu;
    }

    public void setMenu(MenuDto menu) {
        this.menu = menu;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public Integer getMenuId() {
        return menuId;
    }

    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("roleMenuId", roleMenuId).add("roleId", roleId).add("menuId", menuId).toString();
    }
}
