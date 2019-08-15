package com.webank.cmdb.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.dto.CreationRtnDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.service.CiService;

@RestController
public class CiController {
    @Autowired
    private CiService ciService;

    @PostMapping("/ciType/{ciTypeId}/cis")
    public QueryResponse listAllCis(@PathVariable("ciTypeId") int ciTypeId, @RequestBody(required = false) QueryRequest ciRequest) {
        if (ciRequest == null) {
            ciRequest = new QueryRequest();
        }

        return ciService.query(ciTypeId, ciRequest);
    }

    @GetMapping("/ciType/{ciTypeId}/ci/{guid}")
    public Object getCi(@PathVariable("ciTypeId") int ciTypeId, @PathVariable("guid") String guid) {
        return ciService.getCi(ciTypeId, guid);
    }

    @PostMapping("/ciType/{ciTypeId}/ci/add")
    public CreationRtnDto addCi(@PathVariable("ciTypeId") int ciTypeId, @RequestBody Map<String, Object> ciData) {
        return new CreationRtnDto(ciService.create(ciTypeId, ciData));
    }

    @PostMapping("/ciType/{ciTypeId}/ci/{guid}/update")
    public void updateCi(@PathVariable("ciTypeId") int ciTypeId, @PathVariable("guid") String guid, @RequestBody Map<String, Object> ciData) {
        ciService.update(ciTypeId, guid, ciData);
    }

    @PostMapping("/ciType/{ciTypeId}/ci/{guid}/delete")
    public void deleteCi(@PathVariable("ciTypeId") int ciTypeId, @PathVariable("guid") String guid) {
        ciService.deleteCi(ciTypeId, guid);
    }
}
