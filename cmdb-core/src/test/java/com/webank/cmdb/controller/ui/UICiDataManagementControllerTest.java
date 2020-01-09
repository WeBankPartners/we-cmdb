package com.webank.cmdb.controller.ui;

import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_APPLICATION_DEPLOYMENT_DESIGN;
import static com.webank.cmdb.domain.AdmMenu.ROLE_PREFIX;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.empty;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.Map;

import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.util.JsonUtil;

@WithMockUser(username = "test", authorities = { ROLE_PREFIX + MENU_DESIGNING_CI_DATA_MANAGEMENT ,ROLE_PREFIX + MENU_APPLICATION_DEPLOYMENT_DESIGN })
public class UICiDataManagementControllerTest extends AbstractBaseControllerTest {

    private static final int SYSTEM_DESIGN = 1;
    private static final int SUB_SYSTEM_DESIGN = 2;
    private static final int ciTypeId = 3;

    @Test
    public void whenDeleteCiWithDependencyCiAtFinalStateShouldSuccess() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("code", "mock_code")
                .put("name", "mock_name")
                .put("description", "mock_desc")
                .put("business_group", 42)
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult result = mvc.perform(post("/ui/v2/ci-types/{ci-type-id}/ci-data/batch-create", SYSTEM_DESIGN).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();

        String retContent = result.getResponse().getContentAsString();
        String system_design_guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid").asText();

        jsonMap = ImmutableMap.builder()
                .put("code", "mock_code")
                .put("name", "mock_name")
                .put("description", "mock_desc")
                .put("system_design", system_design_guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        result = mvc.perform(post("/ui/v2/ci-types/{ci-type-id}/ci-data/batch-create", SUB_SYSTEM_DESIGN).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        retContent = result.getResponse().getContentAsString();
        String sub_system_design_guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid").asText();

        mvc.perform(post("/ui/v2/ci/state/operate?operation=confirm").contentType(MediaType.APPLICATION_JSON)
                .content("[{\"ciTypeId\":\"" + SUB_SYSTEM_DESIGN + "\",\"guid\":\"" + sub_system_design_guid + "\"}]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/ci/state/operate?operation=confirm").contentType(MediaType.APPLICATION_JSON)
                .content("[{\"ciTypeId\":\"" + SYSTEM_DESIGN + "\",\"guid\":\"" + system_design_guid + "\"}]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/ci-types/{ci-type-id}/ci-data/batch-delete", SUB_SYSTEM_DESIGN).contentType(MediaType.APPLICATION_JSON)
                .content("[\"" + sub_system_design_guid + "\"]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/ci/state/operate?operation=confirm").contentType(MediaType.APPLICATION_JSON)
                .content("[{\"ciTypeId\":\"" + SYSTEM_DESIGN + "\",\"guid\":\"" + system_design_guid + "\"}]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/ci-types/{ci-type-id}/ci-data/batch-delete", SYSTEM_DESIGN).contentType(MediaType.APPLICATION_JSON)
                .content("[\"" + system_design_guid + "\"]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/ci/state/operate?operation=confirm").contentType(MediaType.APPLICATION_JSON)
                .content("[{\"ciTypeId\":\"" + SUB_SYSTEM_DESIGN + "\",\"guid\":\"" + sub_system_design_guid + "\"}]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

    }

    @Test
    public void deploymentDesignQuery() throws Exception {
       
        mvc.perform(post("/ui/v2/deploy-designs/tabs/ci-data?code-id=102&system-guid=0007_0000000004")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/deploy-designs/tabs/ci-data?code-id=102&system-guid=0007_0000000004")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    } 
    
    @Test
    public void physicalDeploymentDesignQuery() throws Exception {
        String systemDesignGuid="0007_0000000004";
        mvc.perform(get("/ui/v2/data-tree/application-deployment?system-guid={system-guid}"
                ,systemDesignGuid)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        
        mvc.perform(get("/ui/v2/data-tree/application-deployment?system-guid={system-guid}"
                ,systemDesignGuid)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    } 
}
