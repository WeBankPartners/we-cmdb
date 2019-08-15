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

public class ApiV2ControllerRoleCiTypeCtrlAttrTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateRoleCiTypeCtrlAttrShouldReturnRoleId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleCiTypeId", 1)
                        .put("creationPermission", "Y")
                        .put("enquiryPermission", "Y")
                        .put("executionPermission", "Y")
                        .put("grantPermission", "N")
                        .put("modificationPermission", "Y")
                        .put("removalPermission", "Y")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-citype-ctrl-attrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleCiTypeCtrlAttrId", greaterThanOrEqualTo(1)));
    }

    @Test
    public void whenUpdateRoleCiTypeCtrlAttrShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleCiTypeCtrlAttrId", 1)
                        .put("roleCiTypeId", 1)
                        .put("creationPermission", "Y")
                        .put("enquiryPermission", "Y")
                        .put("executionPermission", "Y")
                        .put("grantPermission", "N")
                        .put("modificationPermission", "Y")
                        .put("removalPermission", "Y")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-citype-ctrl-attrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleCiTypeCtrlAttrId", is(1)))
                .andExpect(jsonPath("$.data[0].creationPermission", is("Y")))
                .andExpect(jsonPath("$.data[0].grantPermission", is("N")));
    }

    @Test
    public void whenDeleteRoleCiTypeCtrlAttrShouldSuccess() throws Exception {
        QueryRequest queryRequest = new QueryRequest();
        queryRequest.getFilters()
                .add(new Filter("roleCiTypeCtrlAttrId", "in", Lists.newArrayList(1, 2, 3)));
        String reqJson = JsonUtil.toJsonString(queryRequest);
        mvc.perform(post("/api/v2/role-citype-ctrl-attrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleCiTypeCtrlAttrId", contains(1, 2, 3)));

        mvc.perform(post("/api/v2/role-citype-ctrl-attrs/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2,3]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/role-citype-ctrl-attrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleCiTypeCtrlAttrId", contains(1)));
    }
}
