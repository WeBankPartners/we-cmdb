package com.webank.cmdb.controller.ui;

import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_PERMISSION_MANAGEMENT;

import java.util.List;
import java.util.Map;

import javax.annotation.security.RolesAllowed;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
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
import com.webank.cmdb.dto.MenuDto;
import com.webank.cmdb.dto.ResponseDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.UserDto;
import com.webank.cmdb.service.StaticDtoService;

import lombok.AllArgsConstructor;
import lombok.Data;

@RestController
@RequestMapping("/ui/v2/admin")
@RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT })
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

    @GetMapping("/users")
    @ResponseBody
    public Object getAllUsers() {
        return wrapperService.getAllUsers();
    }

    @PostMapping("/users/create")
    @ResponseBody
    public List<UserDto> createNewUser(@RequestBody UserDto userDto) {
        if (StringUtils.isBlank(userDto.getPassword())) {
            userDto.setPassword(passwordEncoder.encode(userDto.getUsername()));
        } else {
            userDto.setPassword(passwordEncoder.encode(userDto.getPassword()));
        }
        return userManagerService.createUser(userDto);
    }
    
    @PostMapping("/users/create")
    @ResponseBody
    public List<UserDto> createNewUser(@RequestBody List<UserDto> userDtos) {
    	//随机密码生成
    	String randomPassword = userManagerService.getRandomPassword();
        userDtos.forEach(userDto->{
            userDto.setPassword(passwordEncoder.encode(randomPassword));
        });
        List<UserDto> create = staticDtoService.create(UserDto.class, userDtos);
        create.forEach(userDto->{
        	userDto.setPassword(randomPassword);
        });
        return create;
    }
    
    @PostMapping("/users/update")
    public List<UserDto> updateUsers(@RequestBody List<Map<String, Object>> userDtos) {
		return userManagerService.updateUser(userDtos);
    }
    
    @PostMapping("/users/password/resert")
    public ResponseDto<?> resertPassword(@RequestBody List<Map<String, Object>> userDtos) {
		return userManagerService.resertPassword(userDtos);
    }

    @GetMapping("/roles")
    @ResponseBody
    public Object getAllRoles() {
        return wrapperService.getAllRoles();
    }

    @GetMapping("/menus")
    @ResponseBody
    public Object getAllMenuDtos() {
        List<MenuDto> allMenuDtos = userManagerService.getAllMenus();
        return allMenuDtos;
    }

    @GetMapping("/users/{username}/roles")
    @ResponseBody
    public Object getRolesByUsername(@PathVariable(value = "username") String username) {
        return wrapperService.getRolesByUsername(username);
    }

    @GetMapping("/roles/{role-id}/users")
    @ResponseBody
    public Object getUsersByRoleId(@PathVariable(value = "role-id") int roleId) {
        return wrapperService.getUsersByRoleId(roleId);
    }

    @GetMapping("/roles/{role-id}/permissions")
    @ResponseBody
    public Object getPermissionsByRoleId(@PathVariable(value = "role-id") int roleId) {
        List<String> menuPermissions = userManagerService.getMenuDtosByRoleId(roleId);
        List<RoleCiTypeDto> ciTypePermissions = userManagerService.getRoleCiTypesByRoleId(roleId);
        return new Permissions(menuPermissions, ciTypePermissions);
    }

    @GetMapping("/roles/{role-id}/menu-permissions")
    @ResponseBody
    public Object getMenuPermissionsByRoleId(@PathVariable(value = "role-id") int roleId) {
        return userManagerService.getMenuDtosByRoleId(roleId);
    }

    @GetMapping("/roles/{role-id}/citype-permissions")
    @ResponseBody
    public Object getCiTypePermissionsByRoleId(@PathVariable(value = "role-id") int roleId) {
        return userManagerService.getRoleCiTypesByRoleId(roleId);
    }

    @GetMapping("/users/{username}/permissions")
    @ResponseBody
    public Object getPermissionsByUsername(@PathVariable(value = "username") String username) {
        List<String> menuPermissions = userManagerService.getMenuDtoCodesByUsername(username);
        List<RoleCiTypeDto> ciTypePermissions = userManagerService.getRoleCiTypesByUsername(username);
        return new Permissions(menuPermissions, ciTypePermissions);
    }

    @GetMapping("/users/{username}/menu-permissions")
    @ResponseBody
    public Object getMenuPermissionsByUsername(@PathVariable(value = "username") String username) {
        return userManagerService.getMenuDtoCodesByUsername(username);
    }

    @GetMapping("/users/{username}/citype-permissions")
    @ResponseBody
    public Object getCiTypePermissionsByUsername(@PathVariable(value = "username") String username) {
        return userManagerService.getRoleCiTypesByUsername(username);
    }

    @PostMapping("/roles/create")
    @ResponseBody
    public Object createNewRole(@RequestBody RoleDto role) {
        return wrapperService.createRoles(role);
    }

    @DeleteMapping("/roles/{role-id}")
    @ResponseBody
    public void deleteRole(@PathVariable(value = "role-id") int roleId) {
        userManagerService.deleteRole(roleId);
    }

    @PostMapping("/roles/{role-id}/users")
    @ResponseBody
    public void grantRoleForUser(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> userIds) {
        userManagerService.grantRoleForUsers(roleId, userIds);
    }

    @DeleteMapping("/roles/{role-id}/users")
    @ResponseBody
    public void revokeRoleForUser(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> usernames) {
        userManagerService.revokeRoleForUsers(roleId, usernames);
    }

    @PostMapping("/roles/{role-id}/menu-permissions")
    @ResponseBody
    public void assignMenuPermissionForRole(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> menuCodes) {
        userManagerService.assignMenuPermissionForRoles(roleId, menuCodes);
    }

    @DeleteMapping("/roles/{role-id}/menu-permissions")
    @ResponseBody
    public void removeMenuPermissionForRole(@PathVariable(value = "role-id") int roleId, @RequestBody List<String> menuCodes) {
        userManagerService.removeMenuPermissionForRoles(roleId, menuCodes);
    }

    @PostMapping("/roles/{role-id}/citypes/{citype-id}/actions/{action-code}")
    @ResponseBody
    public void assignCiTypePermissionForRole(@PathVariable(value = "role-id") int roleId, @PathVariable(value = "citype-id") int ciTypeId, @PathVariable(value = "action-code") String actionCode) {
        userManagerService.assignCiTypePermissionForRole(roleId, ciTypeId, actionCode);
    }

    @DeleteMapping("/roles/{role-id}/citypes/{citype-id}/actions/{action-code}")
    @ResponseBody
    public void removeCiTypePermissionForRole(@PathVariable(value = "role-id") int roleId, @PathVariable(value = "citype-id") int ciTypeId, @PathVariable(value = "action-code") String actionCode) {
        userManagerService.removeCiTypePermissionForRole(roleId, ciTypeId, actionCode);
    }

    @GetMapping("/role-citypes/{role-citype-id}/ctrl-attributes")
    @ResponseBody
    public Object getRoleCiTypeCtrlAttributesByRoleCiTypeId(@PathVariable(value = "role-citype-id") int roleCiTypeId) {
        return userManagerService.getRoleCiTypeCtrlAttributesByRoleCiTypeId(roleCiTypeId);
    }

    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/create")
    @ResponseBody
    public Object createRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        return userManagerService.createRoleCiTypeCtrlAttributes(roleCiTypeId, roleCiTypeCtrlAttributes);
    }

    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/update")
    @ResponseBody
    public Object updateRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        return userManagerService.updateRoleCiTypeCtrlAttributes(roleCiTypeId, roleCiTypeCtrlAttributes);
    }

    @PostMapping("/role-citypes/{role-citype-id}/ctrl-attributes/delete")
    @ResponseBody
    public void deleteRoleCiTypeCtrlAttributes(@PathVariable(value = "role-citype-id") int roleCiTypeId, @RequestBody Integer[] roleCiTypeCtrlAttrIds) {
        wrapperService.deleteRoleCiTypeCtrlAttributes(roleCiTypeCtrlAttrIds);
    }

}
