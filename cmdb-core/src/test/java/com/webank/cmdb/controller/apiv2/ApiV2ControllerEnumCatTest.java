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
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerEnumCatTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateDuplicateCatWithSameCatTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 3)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCatWithoutNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catTypeId", 3)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCatWithoutCatTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCatWithInvalidCatTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCatForSYSCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCatWithInvalidGroupTypeIdThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 3)
                        .put("groupTypeId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCatWithoutCatIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCatWithInvalidCatTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 29)
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCatForSYSCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 29)
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateDuplicateCatWithoutChangeThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 3)
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 4)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateCatWithEmptyNameThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 3)
                        .put("catName", "")
                        .put("catTypeId", 4)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCatWithInvalidGroupTypeIdThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 3)
                        .put("groupTypeId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDeleteCatOfSYSCatTypeThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[1]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCatAsGroupForOtherCatThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[157]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCatWithCodesUnderItThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[159]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCatWithoutCodesUnderItThenShouldAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[161]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void createCatForSYSCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void createCatForCommonCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 2)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void createCatForPrivateCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 22)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void queryCatWithoutArgumentThenShouldReturnData() throws Exception {
        mvc.perform(post("/api/v2/enum/cats/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))));
    }

    @Test
    public void queryCatWithFilterArgumentThenShouldReturnData() throws Exception {
        String reqJson = JsonUtil.toJsonString(defaultQueryObject().addEqualsFilter("catName", "ci_layer"));

        mvc.perform(post("/api/v2/enum/cats/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))));
    }

    @Test
    public void queryCatByPagingThenShouldReturnData() throws Exception {
        String reqJson = JsonUtil.toJsonString(defaultQueryObject().withPaging(true)
                .withPagable(0, 10));

        MvcResult mvcResult = mvc.perform(post("/api/v2/enum/cats/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(is(10))))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size(), equalTo(10));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/pageInfo/totalRows")
                .asInt(), greaterThanOrEqualTo(10));
    }

    @Test
    public void updateCatForSYSCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 991)
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void updateCatForCommonCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 992)
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 2)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void updateCatForPrivateCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 159)
                        .put("catName", "mock_cat_name")
                        .put("catTypeId", 22)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/cats/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void deleteCatForSYSCatTypeThenShouldNotAllow() throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(991));
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void deleteCatForCommonCatTypeThenShouldBeOk() throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(9922));
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void deleteCatForPrivateCatTypeThenShouldBeOk() throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(994, 995));
        mvc.perform(post("/api/v2/enum/cats/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }
}
