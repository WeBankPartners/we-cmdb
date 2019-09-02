package com.webank.cmdb.controller.browser;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.service.impl.ConstantService;

@RestController
@RequestMapping("/browser/v2")
public class BrowserStaticDataController {
    @Autowired
    private ConstantService constantService;

    @GetMapping("/static-data/available-ci-type-table-status")
    @ResponseBody
    public Object getAvailableCiTypeTableStatus() {
        return constantService.getCiStatus();
    }

    @GetMapping("/static-data/available-ci-type-attribute-input-types")
    @ResponseBody
    public Object getAvailableCiTypeAttributeInputTypes() {
        return constantService.getInputTypes();
    }

    @GetMapping("/static-data/effective-status")
    @ResponseBody
    public Object getEffectiveStatus() {
        return constantService.getEffectiveStatus();
    }

}
