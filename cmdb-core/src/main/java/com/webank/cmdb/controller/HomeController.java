package com.webank.cmdb.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.RoleMenuDto;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.service.StaticDtoService;

@Controller
public class HomeController {

    @Autowired
    private StaticDtoService staticDtoService;

    @GetMapping(value = { "/", "index.html" })
    public String index() {
        return "index.html";
    }

    @GetMapping(value = { "/home" })
    public String home(Model model, Principal principal) {
        model.addAttribute("system_name", "CMDB Core");
        model.addAttribute("login_user", principal.getName());
        return "home.html";
    }
    
    @GetMapping(value = { "login.html" })
    public String loginPage() {
        return "login.html";
    }

    @GetMapping("/browser/v2/my-menus")
    @ResponseBody
    public QueryResponse<RoleMenuDto> retrieveRoleMenus(Principal principal) {
        if (principal == null) throw new CmdbException("Logon user not found.");
        QueryRequest request = new QueryRequest();
        request.setFilters(Lists.newArrayList(new Filter("role.roleUsers.user.username", "eq", principal.getName())));
        request.setRefResources(Lists.newArrayList("role","role.roleUsers","role.roleUsers.user"));
        return staticDtoService.query(RoleMenuDto.class, request);
    }
}