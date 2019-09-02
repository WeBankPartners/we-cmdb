package com.webank.cmdb.controller;

import static com.webank.cmdb.controller.browser.helper.JsonResponse.okayWithData;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.webank.cmdb.controller.browser.helper.BrowserUserManagerService;
import com.webank.cmdb.controller.browser.helper.JsonResponse;
import com.webank.cmdb.exception.CmdbException;

@Controller
public class HomeController {

    @Autowired
    private BrowserUserManagerService userManagerService;

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
    public JsonResponse retrieveRoleMenus(Principal principal) {
        if (principal == null)
            throw new CmdbException("Logon user not found.");
        return okayWithData(userManagerService.getMenuDtosByUsername(principal.getName(), true));
    }
}