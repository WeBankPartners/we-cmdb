package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasItems;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.util.CmdbThreadLocal;
import com.webank.cmdb.util.JsonUtil;

@WithMockUser(username = "test", authorities = {ROLE_PREFIX + MENU_ADMIN_PERMISSION_MANAGEMENT})
public class UserRoleControllerTest extends AbstractBaseControllerTest {

    @Before
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
        reload();
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(false);
        CmdbThreadLocal.getIntance()
                .putCurrentUser("mock_user1");
    }

    @Test
    public void whenQueryMenusShouldReturnProperResult() throws Exception {
        mvc.perform(post("/ui/v2/menus/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].name", hasItems("menuA", "menuB", "menuC")));
    }

    @Test
    public void whenCreateRoleMenuShouldReturnRoleMenuId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleId", 1)
                        .put("menuId", 4)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/ui/v2/role-menus/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].roleMenuId", greaterThanOrEqualTo(1)));
    }

    @Test
    public void whenDeleteRoleMenuShouldSuccess() throws Exception {
        QueryRequest queryRequest = new QueryRequest();
        queryRequest.getFilters()
                .add(new Filter("roleMenuId", "in", Lists.newArrayList(1, 2, 3)));
        String reqJson = JsonUtil.toJsonString(queryRequest);
        mvc.perform(post("/ui/v2/role-menus/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleMenuId", contains(1, 2, 3)));

        mvc.perform(post("/ui/v2/role-menus/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2,3]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/ui/v2/role-menus/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].roleMenuId", contains(1)));
    }
}
