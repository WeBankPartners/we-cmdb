package com.webank.cmdb.controller.ui;

import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_PERMISSION_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_USER_PASSWORD_MANAGEMENT;

import java.util.List;
import java.util.Map;

import javax.annotation.security.RolesAllowed;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.controller.ui.helper.UIUserManagerService;
import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.dto.CiTypePermissionOperationDto;
import com.webank.cmdb.dto.MenuDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.UserDto;
import com.webank.cmdb.service.StaticDtoService;

import lombok.AllArgsConstructor;
import lombok.Data;

@RestController
@RequestMapping("/ui/v2/admin")
public class UIUserManagementController {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private StaticDtoService staticDtoService;

    @Data
    @AllArgsConstructor
    class Permissions {
        List<String> menuPermissions;
        List<RoleCiTypeDto> ciTypePermissions;
    }

    @Autowired
    private UIUserManagerService userManagerService;

    @Autowired
    private UIWrapperService wrapperService;

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/users")
    @ResponseBody
    public Object getAllUsers() {
        return wrapperService.getAllUsers();
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/users/retrieve")
    @ResponseBody
    public Object getUserByUsername(@RequestBody QueryRequest queryRequest) {
        QueryResponse<UserDto> query = staticDtoService.query(UserDto.class, queryRequest);
        return query;
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/users/create")
    @ResponseBody
    public Object createNewUser(@RequestBody List<UserDto> userDtos) {
        String randomPassword = userManagerService.getRandomPassword();
        userDtos.forEach(userDto -> {
            userDto.setPassword(passwordEncoder.encode(randomPassword));
        });
        List<UserDto> createdUsers = staticDtoService.create(UserDto.class, userDtos);
        createdUsers.forEach(userDto -> {
            userDto.setPassword(randomPassword);
        });
        return createdUsers;
    }

    @PostMapping("/users/password/change")
    public Object resertPassword(@RequestBody Map<String, Object> userDto) {
        return userManagerService.changePassword(userDto);
    }

    @RolesAllowed({ MENU_ADMIN_USER_PASSWORD_MANAGEMENT })
    @PostMapping("/users/password/reset")
    public Object adminResetPassword(@RequestBody Map<String, Object> userDto) {
        return userManagerService.adminResetPassword(userDto);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/roles")
    @ResponseBody
    public Object getAllRoles() {
        return wrapperService.getAllRoles();
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/menus")
    @ResponseBody
    public Object getAllMenuDtos() {
        List<MenuDto> allMenuDtos = userManagerService.getAllMenus();
        return allMenuDtos;
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/users/{username}/roles")
    @ResponseBody
    public Object getRolesByUsername(@PathVariable(value = "username") String username) {
        return wrapperService.getRolesByUsername(username);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/roles/{role-name}/users")
    @ResponseBody
    public Object getUsersByRoleId(@PathVariable(value = "role-name") String roleName) {
        return wrapperService.getUsersByRoleId(wrapperService.getRoleIdByRoleName(roleName));
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/roles/{role-name}/permissions")
    @ResponseBody
    public Object getPermissionsByRoleId(@PathVariable(value = "role-name") String roleName) {
        int roleId = wrapperService.getRoleIdByRoleName(roleName, true);
        List<String> menuPermissions = userManagerService.getMenuDtosByRoleId(roleId);
        List<RoleCiTypeDto> ciTypePermissions = userManagerService.getRoleCiTypesByRoleId(roleId);
        return new Permissions(menuPermissions, ciTypePermissions);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/roles/{role-name}/menu-permissions")
    @ResponseBody
    public Object getMenuPermissionsByRoleId(@PathVariable(value = "role-name") String roleName) {
        return userManagerService.getMenuDtosByRoleId(wrapperService.getRoleIdByRoleName(roleName));
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/roles/{role-name}/citype-permissions")
    @ResponseBody
    public Object getCiTypePermissionsByRoleId(@PathVariable(value = "role-name") String roleName) {
        return userManagerService.getRoleCiTypesByRoleId(wrapperService.getRoleIdByRoleName(roleName));
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/users/{username}/permissions")
    @ResponseBody
    public Object getPermissionsByUsername(@PathVariable(value = "username") String username) {
        List<String> menuPermissions = userManagerService.getMenuDtoCodesByUsername(username);
        List<RoleCiTypeDto> ciTypePermissions = userManagerService.getRoleCiTypesByUsername(username);
        return new Permissions(menuPermissions, ciTypePermissions);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/users/{username}/menu-permissions")
    @ResponseBody
    public Object getMenuPermissionsByUsername(@PathVariable(value = "username") String username) {
        return userManagerService.getMenuDtoCodesByUsername(username);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/users/{username}/citype-permissions")
    @ResponseBody
    public Object getCiTypePermissionsByUsername(@PathVariable(value = "username") String username) {
        return userManagerService.getRoleCiTypesByUsername(username);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/roles/create")
    @ResponseBody
    public Object createNewRole(@RequestBody RoleDto role) {
        return wrapperService.createRoles(role);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @DeleteMapping("/roles/{role-name}")
    @ResponseBody
    public void deleteRole(@PathVariable(value = "role-name") String roleName) {
        userManagerService.deleteRole(wrapperService.getRoleIdByRoleName(roleName));
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/roles/{role-name}/users")
    @ResponseBody
    public void grantRoleForUser(@PathVariable(value = "role-name") String roleName, @RequestBody List<String> userIds) {
        userManagerService.grantRoleForUsers(wrapperService.getRoleIdByRoleName(roleName), userIds);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @DeleteMapping("/roles/{role-name}/users")
    @ResponseBody
    public void revokeRoleForUser(@PathVariable(value = "role-name") String roleName, @RequestBody List<String> usernames) {
        userManagerService.revokeRoleForUsers(wrapperService.getRoleIdByRoleName(roleName), usernames);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/roles/{role-name}/menu-permissions")
    @ResponseBody
    public void assignMenuPermissionForRole(@PathVariable(value = "role-name") String roleName, @RequestBody List<String> menuCodes) {
        userManagerService.assignMenuPermissionForRoles(wrapperService.getRoleIdByRoleName(roleName), menuCodes);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @DeleteMapping("/roles/{role-name}/menu-permissions")
    @ResponseBody
    public void removeMenuPermissionForRole(@PathVariable(value = "role-name") String roleName, @RequestBody List<String> menuCodes) {
        userManagerService.removeMenuPermissionForRoles(wrapperService.getRoleIdByRoleName(roleName), menuCodes);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/roles/{role-name}/citypes/{citype-id}/actions/{action-code}")
    @ResponseBody
    public void assignCiTypePermissionForRole(@PathVariable(value = "role-name") String roleName, @PathVariable(value = "citype-id") int ciTypeId, @PathVariable(value = "action-code") String actionCode) {
        userManagerService.assignCiTypePermissionForRole(wrapperService.getRoleIdByRoleName(roleName), ciTypeId, actionCode);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @DeleteMapping("/roles/{role-name}/citypes/{citype-id}/actions/{action-code}")
    @ResponseBody
    public void removeCiTypePermissionForRole(@PathVariable(value = "role-name") String roleName, @PathVariable(value = "citype-id") int ciTypeId, @PathVariable(value = "action-code") String actionCode) {
        userManagerService.removeCiTypePermissionForRole(wrapperService.getRoleIdByRoleName(roleName), ciTypeId, actionCode);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @GetMapping("/role-citypes/{role-citype-id}/ctrl-attributes")
    @ResponseBody
    public Object getRoleCiTypeCtrlAttributesByRoleCiTypeId(@PathVariable(value = "role-citype-id") int roleCiTypeId) {
        return userManagerService.getRoleCiTypeCtrlAttributesByRoleCiTypeId(roleCiTypeId);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/create")
    @ResponseBody
    public Object createRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        return userManagerService.createRoleCiTypeCtrlAttributes(roleCiTypeId, roleCiTypeCtrlAttributes);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/update")
    @ResponseBody
    public Object updateRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        return userManagerService.updateRoleCiTypeCtrlAttributes(roleCiTypeId, roleCiTypeCtrlAttributes);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/delete")
    @ResponseBody
    public void deleteRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Integer> roleCiTypeCtrlAttrIds) {
        wrapperService.deleteRoleCiTypeCtrlAttributes(roleCiTypeCtrlAttrIds);
    }
    
    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
    @PostMapping("/roles/{role-name}/citypes/permissions")
    @ResponseBody
    public void assignCiTypePermissionForRoleInBatch(@PathVariable(value = "role-name") String roleName, @RequestBody List<CiTypePermissionOperationDto> permissionOperationDtos) {
        userManagerService.assignCiTypePermissionForRoleInBatch(roleName, permissionOperationDtos);
    }

}
