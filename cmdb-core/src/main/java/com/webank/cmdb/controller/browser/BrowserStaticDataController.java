package com.webank.cmdb.controller.browser;

import static com.webank.cmdb.controller.browser.helper.JsonResponse.okayWithData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.controller.browser.helper.JsonResponse;
import com.webank.cmdb.service.impl.ConstantService;

@RestController
@RequestMapping("/browser/v2")
public class BrowserStaticDataController {
    @Autowired
    private ConstantService constantService;

    @GetMapping("/static-data/available-ci-type-table-status")
    @ResponseBody
    public JsonResponse getAvailableCiTypeTableStatus() {
        return okayWithData(constantService.getCiStatus());
    }

    @GetMapping("/static-data/available-ci-type-attribute-input-types")
    @ResponseBody
    public JsonResponse getAvailableCiTypeAttributeInputTypes() {
        return okayWithData(constantService.getInputTypes());
    }

    @GetMapping("/static-data/effective-status")
    @ResponseBody
    public JsonResponse getEffectiveStatus() {
        return okayWithData(constantService.getEffectiveStatus());
    }

}
