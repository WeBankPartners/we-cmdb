package com.webank.plugins.wecmdb.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.webank.plugins.wecmdb.dto.inhouse.InhouseCmdbRequest;
import com.webank.plugins.wecmdb.dto.inhouse.InhouseCmdbResponse;
import com.webank.plugins.wecmdb.service.InhouseCmdbAdapterService;

@RestController
@RequestMapping("/inhouse")
public class InhouseCmdbAdapterController {

    @Autowired
    private InhouseCmdbAdapterService inhouseCmdbAdapterService;

    @PostMapping("/customizationReport/retrieve")
    public InhouseCmdbResponse queryCustomizationReport(@RequestBody(required = true) InhouseCmdbRequest request) {
        return inhouseCmdbAdapterService.queryCustomizationReport(request);
    }
}
