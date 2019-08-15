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

import org.junit.Ignore;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerEnumCodeTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateMultipleCodeUnderSameCatThenSeqNoShouldIncreaseCorrectly() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 3)
                        .put("code", "mock_code_name_1")
                        .put("value", "mock_value_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].seqNo", is(2)));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("catId", 3)
                        .put("code", "mock_code_name_2")
                        .put("value", "mock_value_2")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].seqNo", is(3)));
    }

    @Test
    public void whenCreateCodeWithoutCatIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code_name")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCodeWithInvalidCatIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code_name")
                        .put("catId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDuplidateCreateCodeThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code_name")
                        .put("value", "mock_value")
                        .put("catId", 2)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code_name")
                        .put("catId", 2)
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCodeWithoutCodeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code_name")
                        .put("catId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCodeWithInvalidCatIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("code", "mock_code_name")
                        .put("catId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCodeWithInvalidGroupCodeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("code", "mock_code_name")
                        .put("groupCodeId", 9999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCodeDuplicateWithoutChangeThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("code", "Catalog 1")
                        .put("catId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateCodeDuplicateWithExistCodeThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("code", "Catalog 2")
                        .put("catId", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateWithValidStatusThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("status", "inactive")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("status", "active")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateWithInvalidStatusThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 1)
                        .put("status", "activeXXX")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDeleteCodeAsGroupForOtherCodeThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[556]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCodeUsedForCiTypeAsCatalogIdThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[1]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCodeUsedForCiTypeAsLayerIdThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[5]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCodeNotUsedForCiTypeAsLayerIdThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[8]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenDeleteCodeUsedForCiTypeAsZoomLevelIdThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[9]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCodeUsedForCiTypeAsCiTypeStateThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[558]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCodeUsedForCiDataWbSystemThenShouldNotAllow() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[554]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void createCodeForSYSCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code")
                        .put("value", "mock_value")
                        .put("catId", 991)
                        .put("status", "active")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void createCodeForCommonCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code")
                        .put("value", "mock_value")
                        .put("catId", 992)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void createCodeForPrivateCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("code", "mock_code")
                        .put("value", "mock_value")
                        .put("catId", 993)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void queryCodeWithoutArgumentThenShouldReturnData() throws Exception {
        mvc.perform(post("/api/v2/enum/codes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))));
    }

    @Test
    public void queryCatWithFilterArgumentThenShouldReturnData() throws Exception {
        String reqJson = JsonUtil.toJsonString(defaultQueryObject().addEqualsFilter("code", "PrivateEnumCode1"));

        mvc.perform(post("/api/v2/enum/codes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))));
    }

    @Test
    public void queryCodeByPagingThenShouldReturnData() throws Exception {
        String reqJson = JsonUtil.toJsonString(defaultQueryObject().withPaging(true)
                .withPagable(0, 10));

        MvcResult mvcResult = mvc.perform(post("/api/v2/enum/codes/retrieve").contentType(MediaType.APPLICATION_JSON)
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
    public void updateCodeForSYSCatTypeThenShouldNotAllow() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 881)
                        .put("code", "mock_code_name")
                        .put("value", "mock_value")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void updateCodeForCommonCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 882)
                        .put("code", "mock_code_name")
                        .put("value", "mock_value")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void updateCodeForPrivateCatTypeThenShouldBeOk() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("codeId", 883)
                        .put("code", "mock_code_name")
                        .put("value", "mock_value")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/codes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void deleteCodeForSYSCatTypeThenShouldNotAllow() throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(881));
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void deleteCodeForCommonCatTypeThenShouldBeOk() throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(882));
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void deleteCodeForPrivateCatTypeThenShouldBeOk() throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(883, 884));
        mvc.perform(post("/api/v2/enum/codes/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }
    
    @Test
    @Ignore
    public void queryCodeWithCatRerencedResourceAndSortingThenResultShouldBeSortedProperly() throws Exception{
        String reqJson = JsonUtil.toJsonString(defaultQueryObject().withReferenceResource("cat").ascendingSortBy("cat.catName"));

        MvcResult mvcResult = mvc.perform(post("/api/v2/enum/codes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))))
                .andReturn();
        
        String retContent = mvcResult.getResponse().getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents").size(), equalTo(76));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents/0/cat/catName")
                .asText(), is("City"));
        
        
    }

}
