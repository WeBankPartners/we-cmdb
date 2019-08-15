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

public class ApiV2ControllerRoleUserTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateRoleUserShouldReturnRoleUserId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleId", 1)
                        .put("userId", "1004")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-users/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleUserId", greaterThanOrEqualTo(1)));
    }

    @Test
    public void whenDeleteRoleUserShouldSuccess() throws Exception {
        QueryRequest queryRequest = new QueryRequest();
        queryRequest.getFilters()
                .add(new Filter("roleUserId", "in", Lists.newArrayList(1, 2, 3)));
        String reqJson = JsonUtil.toJsonString(queryRequest);
        mvc.perform(post("/api/v2/role-users/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleUserId", contains(1, 2, 3)));

        mvc.perform(post("/api/v2/role-users/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2,3]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/role-users/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleUserId", contains(1)));
    }
}
