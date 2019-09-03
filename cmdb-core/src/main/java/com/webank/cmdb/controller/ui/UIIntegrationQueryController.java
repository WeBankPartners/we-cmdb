package com.webank.cmdb.controller.ui;

import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT;

import javax.annotation.security.RolesAllowed;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;

@RestController
@RequestMapping("/ui/v2")
public class UIIntegrationQueryController {

    @Autowired
    private UIWrapperService wrapperService;

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION, })
    @GetMapping("/intQuery/{queryId}/header")
    @ResponseBody
    public Object queryIntHeader(@PathVariable(name = "queryId") int queryId) {
        return wrapperService.queryIntHeader(queryId);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @PostMapping("/intQuery/{queryId}/update")
    @ResponseBody
    public void updateIntQuery(@PathVariable("queryId") int queryId, @RequestBody IntegrationQueryDto intQueryDto) {
        wrapperService.updateIntQuery(queryId, intQueryDto);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryId}/delete")
    public void deleteQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryId") int queryId) {
        wrapperService.deleteQuery(ciTypeId, queryId);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryName}/save")
    public Object saveIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryName") String queryName, @RequestBody IntegrationQueryDto intQueryDto) {
        return wrapperService.saveIntQuery(ciTypeId, queryName, intQueryDto);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/intQuery/ciType/{ciTypeId}/search")
    public Object searchIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @RequestParam(value = "name", required = false) String name) {
        return wrapperService.searchIntQuery(ciTypeId, name);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/intQuery/ciType/{ciTypeId}/{queryId}")
    public Object getIntQueryByName(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable(value = "queryId") Integer queryId) {
        return wrapperService.getIntQueryByName(ciTypeId, queryId);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION })
    @PostMapping("/intQuery/{queryId}/execute")
    public Object excuteIntQuery(@PathVariable("queryId") int queryId, @RequestBody QueryRequest aggRequest) {
        return wrapperService.excuteIntQuery(queryId, aggRequest);
    }

}
