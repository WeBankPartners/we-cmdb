package com.webank.cmdb.controller.apiv2;

import static com.webank.cmdb.controller.QueryRequestUtils.defaultQueryObject;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasSize;
import static org.junit.Assert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.Arrays;
import java.util.List;

import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerEnumCatTypeTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateEnumCatTypeWithDuplicateCiTypeIdThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("catTypeName", "mock_cat_type_name_1")
                        .put("description", "mock_description_1")
                        .build())
                .build();

        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("catTypeName", "mock_cat_type_name_2")
                        .put("description", "mock_description_2")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateDuplicateEnumCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("catTypeName", "mock_cat_type_name_new")
                        .put("description", "mock_description_new")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateEnumCatTypeWithoutNameThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("description", "mock_description_new")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateEnumCatTypeWithInvalidCiTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 9999)
                        .put("catTypeName", "mock_cat_type_name_new")
                        .put("description", "mock_description_new")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCommonEnumCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 2)
                        .put("catTypeName", "mock_cat_type_name_update")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateEnumCatTypeWithInvalidCiTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 3)
                        .put("ciTypeId", 999)
                        .put("catTypeName", "mock_cat_type_name_update")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDeleteSYSEnumCatTypeThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/catTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[1]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCommonEnumCatTypeThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/catTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void queryCatTypesWithoutArgumentThenReturnData() throws Exception {
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data.contents[?(@.catTypeName=='System')].description").value(is(Arrays.asList("System"))));
    }

    @Test
    public void queryCatTypesByFilterThenReturnData() throws Exception {
        String reqJson = JsonUtil.toJsonString(defaultQueryObject().addEqualsFilter("catTypeName", "System"));
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))));
    }

    @Test
    public void queryCatTypesByPagingThenReturnData() throws Exception {
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.withPagable(0, 10);
        String reqJson = JsonUtil.toJsonString(queryObject);
        MvcResult mvcResult = mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size(), equalTo(10));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/pageInfo/totalRows")
                .asInt(), greaterThanOrEqualTo(10));
    }

    @Test
    public void whenUpdateSYSEnumCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 1)
                        .put("catTypeName", "mock_cat_type_name_update")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateDuplicateCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 3)
                        .put("catTypeName", "mock_cat_type_name_update")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 4)
                        .put("catTypeName", "mock_cat_type_name_update")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateDuplicateCatTypeWithoutChangeThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 3)
                        .put("catTypeName", "mock_cat_type_name_update")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateCatTypeNameToEmptyThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 3)
                        .put("catTypeName", "")
                        .put("description", "mock_description_update")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDeleteEnumCatTypeWhichHaveCatsThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/catTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[3]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

}
