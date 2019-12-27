package com.webank.cmdb.controller.ui;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.service.impl.ConstantService;

@RestController
@RequestMapping("/ui/v2")
public class UIStaticDataController {
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
    
	@GetMapping("/static-data/filter-operator")
	@ResponseBody
	public Object getFilterOperator() {
		return constantService.getFilterOperator();
	}
	
	@GetMapping("/static-data/special-connector")
	@ResponseBody
	public Object getSpecialConnector() {
		return constantService.getSpecialConnector();
	}


}
