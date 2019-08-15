package com.webank.cmdb.controller.apiv2;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.List;

import org.junit.Test;
import org.springframework.http.MediaType;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerRoleCiTypeTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateRoleCiTypeShouldReturnRoleId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 9)
                        .put("ciTypeName", "mockCiType")
                        .put("creationPermission", "Y")
                        .put("enquiryPermission", "Y")
                        .put("executionPermission", "Y")
                        .put("grantPermission", "N")
                        .put("modificationPermission", "Y")
                        .put("removalPermission", "Y")
                        .put("roleId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-citypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleCiTypeId", greaterThanOrEqualTo(1)));
    }

    @Test
    public void whenUpdateRoleCiTypeShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleCiTypeId", 1)
                        .put("ciTypeName", "updatedCiTypeName")
                        .put("creationPermission", "Y")
                        .put("enquiryPermission", "Y")
                        .put("executionPermission", "Y")
                        .put("grantPermission", "N")
                        .put("modificationPermission", "Y")
                        .put("removalPermission", "Y")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-citypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleCiTypeId", is(1)))
                .andExpect(jsonPath("$.data[0].ciTypeName", is("updatedCiTypeName")))
                .andExpect(jsonPath("$.data[0].creationPermission", is("Y")))
                .andExpect(jsonPath("$.data[0].grantPermission", is("N")));
    }

    @Test
    public void whenDeleteRoleCiTypeShouldSuccess() throws Exception {
        QueryRequest queryRequest = new QueryRequest();
        queryRequest.getFilters()
                .add(new Filter("roleCiTypeId", "in", Lists.newArrayList(1, 2, 3)));
        String reqJson = JsonUtil.toJsonString(queryRequest);
        mvc.perform(post("/api/v2/role-citypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleCiTypeId", contains(1, 2, 3)));

        mvc.perform(post("/api/v2/role-citypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2,3]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/role-citypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleCiTypeId", contains(1)));
    }
}
