package com.webank.cmdb.controller.browser;

import static com.webank.cmdb.controller.browser.helper.JsonResponse.okay;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.okayWithData;
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

import com.webank.cmdb.controller.browser.helper.BrowserWrapperService;
import com.webank.cmdb.controller.browser.helper.JsonResponse;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;

@RestController
@RequestMapping("/browser/v2")
public class BrowserIntegrationQueryController {

    @Autowired
    private BrowserWrapperService wrapperService;

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION, })
    @GetMapping("/intQuery/{queryId}/header")
    @ResponseBody
    public JsonResponse queryIntHeader(@PathVariable(name = "queryId") int queryId) {
        return okayWithData(wrapperService.queryIntHeader(queryId));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @PostMapping("/intQuery/{queryId}/update")
    @ResponseBody
    public JsonResponse updateIntQuery(@PathVariable("queryId") int queryId, @RequestBody IntegrationQueryDto intQueryDto) {
        wrapperService.updateIntQuery(queryId, intQueryDto);
        return okay();
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryId}/delete")
    public JsonResponse deleteQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryId") int queryId) {
        wrapperService.deleteQuery(ciTypeId, queryId);
        return okay();
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryName}/save")
    public JsonResponse saveIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryName") String queryName, @RequestBody IntegrationQueryDto intQueryDto) {
        return okayWithData(wrapperService.saveIntQuery(ciTypeId, queryName, intQueryDto));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/intQuery/ciType/{ciTypeId}/search")
    public JsonResponse searchIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @RequestParam(value = "name", required = false) String name) {
        return okayWithData(wrapperService.searchIntQuery(ciTypeId, name));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/intQuery/ciType/{ciTypeId}/{queryId}")
    public JsonResponse getIntQueryByName(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable(value = "queryId") Integer queryId) {
        return okayWithData(wrapperService.getIntQueryByName(ciTypeId, queryId));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION })
    @PostMapping("/intQuery/{queryId}/execute")
    public JsonResponse excuteIntQuery(@PathVariable("queryId") int queryId, @RequestBody QueryRequest aggRequest) {
        return okayWithData(wrapperService.excuteIntQuery(queryId, aggRequest));
    }

}
