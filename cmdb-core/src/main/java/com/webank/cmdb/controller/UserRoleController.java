package com.webank.cmdb.controller;

import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.dto.MenuDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.RoleMenuDto;
import com.webank.cmdb.dto.RoleUserDto;
import com.webank.cmdb.dto.UserDto;
import com.webank.cmdb.service.StaticDtoService;

@RestController
public class UserRoleController {

    @Autowired
    private StaticDtoService staticDtoService;

    @PostMapping("/users/retrieve")
    public QueryResponse<UserDto> retrieveUsers(@RequestBody QueryRequest request) {
        return staticDtoService.query(UserDto.class, request);
    }

    @PostMapping("/roles/retrieve")
    public QueryResponse<RoleDto> retrieveRoles(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleDto.class, request);
    }

    @PostMapping("/roles/update")
    public List<RoleDto> updateRoles(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleDto.class, request);
    }

    @PostMapping("/roles/delete")
    public void deleteRoles(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleDto.class, requestIds);
    }

    @PostMapping("/roles/create")
    public List<RoleDto> createRoles(@Valid @RequestBody List<RoleDto> roleDtos) {
        return staticDtoService.create(RoleDto.class, roleDtos);
    }

    @PostMapping("/role-users/retrieve")
    public QueryResponse<RoleUserDto> retrieveRoleUsers(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleUserDto.class, request);
    }

    @PostMapping("/role-users/create")
    public List<RoleUserDto> createRoleUsers(@Valid @RequestBody List<RoleUserDto> roleUsers) {
        return staticDtoService.create(RoleUserDto.class, roleUsers);
    }

    @PostMapping("/role-users/delete")
    public void deleteRoleUsers(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleUserDto.class, requestIds);
    }

    @PostMapping("/role-citypes/retrieve")
    public QueryResponse<RoleCiTypeDto> retrieveRoleCiTypes(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleCiTypeDto.class, request);
    }

    @PostMapping("/role-citypes/create")
    public List<RoleCiTypeDto> createRoleCiTypes(@Valid @RequestBody List<RoleCiTypeDto> roleCiTypes) {
        return staticDtoService.create(RoleCiTypeDto.class, roleCiTypes);
    }

    @PostMapping("/role-citypes/update")
    public List<RoleCiTypeDto> updateRoleCiTypes(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleCiTypeDto.class, request);
    }

    @PostMapping("/role-citypes/delete")
    public void deleteRoleCiTypes(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleCiTypeDto.class, requestIds);
    }

    @PostMapping("/role-citype-ctrl-attrs/retrieve")
    public QueryResponse<RoleCiTypeCtrlAttrDto> retrieveRoleCiTypeCtrlAttrs(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleCiTypeCtrlAttrDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attrs/create")
    public List<RoleCiTypeCtrlAttrDto> createRoleCiTypeCtrlAttrs(@Valid @RequestBody List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs) {
        return staticDtoService.create(RoleCiTypeCtrlAttrDto.class, roleCiTypeCtrlAttrs);
    }

    @PostMapping("/role-citype-ctrl-attrs/update")
    public List<RoleCiTypeCtrlAttrDto> updateRoleCiTypeAttrs(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleCiTypeCtrlAttrDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attrs/delete")
    public void deleteRoleCiTypeCtrlAttrs(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleCiTypeCtrlAttrDto.class, requestIds);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/retrieve")
    public QueryResponse<RoleCiTypeCtrlAttrConditionDto> retrieveRoleCiTypeCtrlAttrConditions(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleCiTypeCtrlAttrConditionDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/create")
    public List<RoleCiTypeCtrlAttrConditionDto> createRoleCiTypeCtrlAttrConditions(@Valid @RequestBody List<RoleCiTypeCtrlAttrConditionDto> roleCiTypeCtrlAttrConditions) {
        return staticDtoService.create(RoleCiTypeCtrlAttrConditionDto.class, roleCiTypeCtrlAttrConditions);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/update")
    public List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleCiTypeCtrlAttrConditionDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/delete")
    public void deleteRoleCiTypeCtrlAttrConditions(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleCiTypeCtrlAttrConditionDto.class, requestIds);
    }

    @PostMapping("/menus/retrieve")
    public QueryResponse<MenuDto> retrieveMenus(@RequestBody QueryRequest request) {
        return staticDtoService.query(MenuDto.class, request);
    }

    @PostMapping("/role-menus/retrieve")
    public QueryResponse<RoleMenuDto> retrieveRoleMenus(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleMenuDto.class, request);
    }

    @PostMapping("/role-menus/create")
    public List<RoleMenuDto> createRoleMenus(@Valid @RequestBody List<RoleMenuDto> roleCiTypes) {
        return staticDtoService.create(RoleMenuDto.class, roleCiTypes);
    }

    @PostMapping("/role-menus/update")
    public List<RoleMenuDto> updateRoleMenus(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleMenuDto.class, request);
    }

    @PostMapping("/role-menus/delete")
    public void deleteRoleMenus(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleMenuDto.class, requestIds);
    }
}
