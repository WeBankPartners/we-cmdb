package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;

import java.util.List;

import javax.annotation.security.RolesAllowed;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.dto.IdNamePairDto;
import com.webank.cmdb.dto.IntQueryResponseHeader;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.IntegrationQueryService;

@RestController
public class IntQueryController {
    @Autowired
    private IntegrationQueryService intQueryService;
    @Autowired
    private CiService ciService;

    @RolesAllowed({MENU_COMMON_INTERFACE_CONFIG})
    @GetMapping("/intQuery/ciType/{ciTypeId}/{queryId}")
    public IntegrationQueryDto getIntQueryByName(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryId") int queryId) {
        return intQueryService.getIntegrationQuery(queryId);
    }

    @RolesAllowed({MENU_COMMON_INTERFACE_CONFIG})
    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryName}/save")
    public int saveIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryName") String queryName, @RequestBody IntegrationQueryDto intQueryDto) {
        return intQueryService.createIntegrationQuery(ciTypeId, queryName, intQueryDto);
    }

    @RolesAllowed({MENU_COMMON_INTERFACE_RUNNER, MENU_COMMON_INTERFACE_CONFIG})
    @GetMapping("/intQuery/ciType/{ciTypeId}/search")
    public List<IdNamePairDto> searchIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "tailAttrId", required = false) Integer tailAttrId) {
        return intQueryService.findAll(ciTypeId, name, tailAttrId);
    }

    @RolesAllowed({MENU_COMMON_INTERFACE_RUNNER})
    @PostMapping("/intQuery/{queryId}/execute")
    public QueryResponse queryInt(@PathVariable("queryId") int queryId, @RequestBody QueryRequest queryRequest) {
        return ciService.integrateQuery(queryId, queryRequest);
    }

    @RolesAllowed({MENU_COMMON_INTERFACE_RUNNER})
    @GetMapping("/intQuery/{queryId}/header")
    public List<IntQueryResponseHeader> queryIntHeader(@PathVariable("queryId") int queryId) {
        return ciService.integrateQueryHeader(queryId);
    }
}
