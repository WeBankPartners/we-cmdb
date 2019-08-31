package com.webank.cmdb.controller.browser;

import static com.webank.cmdb.controller.browser.helper.JsonResponse.okay;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.okayWithData;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_PERMISSION_MANAGEMENT;

import java.util.List;
import java.util.Map;

import javax.annotation.security.RolesAllowed;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.controller.browser.helper.BrowserWrapperService;
import com.webank.cmdb.controller.browser.helper.JsonResponse;
import com.webank.cmdb.controller.browser.helper.BrowserUserManagerService;
import com.webank.cmdb.dto.MenuDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;

import lombok.AllArgsConstructor;
import lombok.Data;

@RestController
@RequestMapping("/admin")
@RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
public class BrowserUserManagementController {

    @Data
    @AllArgsConstructor
    class Permissions {
        List<String> menuPermissions;
        List<RoleCiTypeDto> ciTypePermissions;
    }

    @Autowired
    private BrowserUserManagerService userManagerService;

    @Autowired
    private BrowserWrapperService wrapperService;

    @GetMapping("/users")
    @ResponseBody
    public JsonResponse getAllUsers() {
        return okayWithData(wrapperService.getAllUsers());
    }

    @GetMapping("/roles")
    @ResponseBody
    public JsonResponse getAllRoles() {
        return okayWithData(wrapperService.getAllRoles());
    }

    @GetMapping("/menus")
    @ResponseBody
    public JsonResponse getAllMenuDtos() {
        List<MenuDto> allMenuDtos = userManagerService.getAllMenus();
        return okayWithData(allMenuDtos);
    }

    @GetMapping("/users/{username}/roles")
    @ResponseBody
    public JsonResponse getRolesByUsername(@PathVariable(value = "username") String username) {
        return okayWithData(wrapperService.getRolesByUsername(username));
    }

    @GetMapping("/roles/{role-id}/users")
    @ResponseBody
    public JsonResponse getUsersByRoleId(@PathVariable(value = "role-id") int roleId) {
        return okayWithData(wrapperService.getUsersByRoleId(roleId));
    }

    @GetMapping("/roles/{role-id}/permissions")
    @ResponseBody
    public JsonResponse getPermissionsByRoleId(@PathVariable(value = "role-id") int roleId) {
        List<String> menuPermissions = userManagerService.getMenuDtosByRoleId(roleId);
        List<RoleCiTypeDto> ciTypePermissions = userManagerService.getRoleCiTypesByRoleId(roleId);
        return okayWithData(new Permissions(menuPermissions, ciTypePermissions));
    }

    @GetMapping("/roles/{role-id}/menu-permissions")
    @ResponseBody
    public JsonResponse getMenuPermissionsByRoleId(@PathVariable(value = "role-id") int roleId) {
        return okayWithData(userManagerService.getMenuDtosByRoleId(roleId));
    }

    @GetMapping("/roles/{role-id}/citype-permissions")
    @ResponseBody
    public JsonResponse getCiTypePermissionsByRoleId(@PathVariable(value = "role-id") int roleId) {
        return okayWithData(userManagerService.getRoleCiTypesByRoleId(roleId));
    }

    @GetMapping("/users/{username}/permissions")
    @ResponseBody
    public JsonResponse getPermissionsByUsername(@PathVariable(value = "username") String username) {
        List<String> menuPermissions = userManagerService.getMenuDtoCodesByUsername(username);
        List<RoleCiTypeDto> ciTypePermissions = userManagerService.getRoleCiTypesByUsername(username);
        return okayWithData(new Permissions(menuPermissions, ciTypePermissions));
    }

    @GetMapping("/users/{username}/menu-permissions")
    @ResponseBody
    public JsonResponse getMenuPermissionsByUsername(@PathVariable(value = "username") String username) {
        return okayWithData(userManagerService.getMenuDtoCodesByUsername(username));
    }

    @GetMapping("/users/{username}/citype-permissions")
    @ResponseBody
    public JsonResponse getCiTypePermissionsByUsername(@PathVariable(value = "username") String username) {
        return okayWithData(userManagerService.getRoleCiTypesByUsername(username));
    }

    @PostMapping("/roles/create")
    @ResponseBody
    public JsonResponse createNewRole(@RequestBody RoleDto role) {
        return okayWithData(wrapperService.createRoles(role));
    }

    @DeleteMapping("/roles/{role-id}")
    @ResponseBody
    public JsonResponse deleteRole(@PathVariable(value = "role-id") int roleId) {
        userManagerService.deleteRole(roleId);
        return okay();
    }

    @PostMapping("/roles/{role-id}/users")
    @ResponseBody
    public JsonResponse grantRoleForUser(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> userIds) {
        userManagerService.grantRoleForUsers(roleId, userIds);
        return okay();
    }

    @DeleteMapping("/roles/{role-id}/users")
    @ResponseBody
    public JsonResponse revokeRoleForUser(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> usernames) {
        userManagerService.revokeRoleForUsers(roleId, usernames);
        return okay();
    }

    @PostMapping("/roles/{role-id}/menu-permissions")
    @ResponseBody
    public JsonResponse assignMenuPermissionForRole(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> menuCodes) {
        userManagerService.assignMenuPermissionForRoles(roleId, menuCodes);
        return okay();
    }

    @DeleteMapping("/roles/{role-id}/menu-permissions")
    @ResponseBody
    public JsonResponse removeMenuPermissionForRole(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> menuCodes) {
        userManagerService.removeMenuPermissionForRoles(roleId, menuCodes);
        return okay();
    }

    @PostMapping("/roles/{role-id}/citypes/{citype-id}/actions/{action-code}")
    @ResponseBody
    public JsonResponse assignCiTypePermissionForRole(@PathVariable(value = "role-id") int roleId, @PathVariable(value = "citype-id") int ciTypeId, @PathVariable(value = "action-code") String actionCode) {
        userManagerService.assignCiTypePermissionForRole(roleId, ciTypeId, actionCode);
        return okay();
    }

    @DeleteMapping("/roles/{role-id}/citypes/{citype-id}/actions/{action-code}")
    @ResponseBody
    public JsonResponse removeCiTypePermissionForRole(@PathVariable(value = "role-id") int roleId, @PathVariable(value = "citype-id") int ciTypeId, @PathVariable(value = "action-code") String actionCode) {
        userManagerService.removeCiTypePermissionForRole(roleId, ciTypeId, actionCode);
        return okay();
    }

    @GetMapping("/role-citypes/{role-citype-id}/ctrl-attributes")
    @ResponseBody
    public JsonResponse getRoleCiTypeCtrlAttributesByRoleCiTypeId(@PathVariable(value = "role-citype-id") int roleCiTypeId) {
        return okayWithData(userManagerService.getRoleCiTypeCtrlAttributesByRoleCiTypeId(roleCiTypeId));
    }

    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/create")
    @ResponseBody
    public JsonResponse createRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        return okayWithData(userManagerService.createRoleCiTypeCtrlAttributes(roleCiTypeId, roleCiTypeCtrlAttributes));
    }

    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/update")
    @ResponseBody
    public JsonResponse updateRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        return okayWithData(userManagerService.updateRoleCiTypeCtrlAttributes(roleCiTypeId, roleCiTypeCtrlAttributes));
    }

    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/delete")
    @ResponseBody
    public JsonResponse deleteRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody Integer[] roleCiTypeCtrlAttrIds) {
        wrapperService.deleteRoleCiTypeCtrlAttributes(roleCiTypeCtrlAttrIds);
        return okay();
    }

}
