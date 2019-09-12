package com.webank.cmdb.controller.ui;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.webank.cmdb.controller.ui.helper.UIUserManagerService;
import com.webank.cmdb.exception.CmdbException;

@Controller
public class UIHomeController {

    @Autowired
    private UIUserManagerService userManagerService;

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

    @GetMapping("/ui/v2/my-menus")
    @ResponseBody
    public Object retrieveRoleMenus(Principal principal) {
        if (principal == null)
            throw new CmdbException("Logon user not found.");
        return userManagerService.getMenuDtosByUsername(principal.getName(), true);
    }
}