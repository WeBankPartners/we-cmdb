package com.webank.cmdb.controller.apiv2;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.List;

import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerRoleTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateRoleShouldReturnRoleId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleName", "mock_role_name_1")
                        .put("roleType", "mock_role_type_1")
                        .put("description", "mock_description_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/roles/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleId", greaterThanOrEqualTo(1)));
    }

    @Test
    public void whenUpdateRoleShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleId", 1)
                        .put("roleName", "updated_role_name")
                        .put("roleType", "updated_role_type")
                        .put("description", "updated_description")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/roles/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleId", is(1)))
                .andExpect(jsonPath("$.data[0].roleName", is("updated_role_name")))
                .andExpect(jsonPath("$.data[0].roleType", is("updated_role_type")))
                .andExpect(jsonPath("$.data[0].description", is("updated_description")));
    }

    @Test
    public void whenQueryRoleShouldSuccess() throws Exception {
        mvc.perform(post("/api/v2/roles/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[1:5].roleName", contains("CMDB_ADMIN", "PLUGIN_ADMIN", "IDC_ARCHITECT", "NETWORK_ARCHITECT")));
    }

    @Test
    public void whenDeleteRoleShouldSuccess() throws Exception {
        QueryRequest queryRequest = new QueryRequest();
        queryRequest.getFilters()
                .add(new Filter("roleId", "in", Lists.newArrayList(9, 10, 11)));
        String reqJson = JsonUtil.toJsonString(queryRequest);
        mvc.perform(post("/api/v2/roles/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleName", contains("DEVELOPER", "REGULAR", "READONLY")));

        mvc.perform(post("/api/v2/roles/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[10,11]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/roles/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleName", contains("DEVELOPER")));
    }

    @Test
    public void whenDeleteSystemRoleShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleName", "mock_super_admin")
                        .put("roleType", "mock_role_type")
                        .put("description", "mock_super_admin")
                        .put("isSystem",true)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        MvcResult mvcResult = mvc.perform(post("/api/v2/roles/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleId", greaterThanOrEqualTo(1)))
                .andReturn();
        String retContent = mvcResult.getResponse().getContentAsString();
        Integer roleId = JsonUtil.asNodeByPath(retContent, "/data/0/roleId").asInt();

        mvc.perform(post("/api/v2/roles/delete").contentType(MediaType.APPLICATION_JSON)
                .content("["+roleId+"]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

}
