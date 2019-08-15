package com.webank.cmdb.controller.apiv2;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.List;
import java.util.Map;

import org.junit.Ignore;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerTest extends LegacyAbstractBaseControllerTest {
    @Test
    public void retrieveAllCateTypesThenReturnAllCatTypes() throws Exception {
        String reqJson = "{}";
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(22)));
    }

    @Test
    public void retrieveCatTypesWithFilterThenReturnFilteredCatTypes() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "catTypeName")
                                .put("operator", "eq")
                                .put("value", "CMDB Commons")
                                .build())
                        .build())
                .build();

        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void retrieveCiZoomLevelsFromCatsCrossResourceReferenceToCodes() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(new Filter("catName", "eq", "ci_zoom_level"))
                        .build())
                .put("refResources", ImmutableList.builder()
                        .add("codes")
                        .build())
                .build();

        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/enum/cats/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].codes", hasSize(4)));
    }

    @Test
    public void retrieveCiLayersFromCatsCrossResourceReferenceToCodes() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(new Filter("catName", "eq", "ci_layer"))
                        .build())
                .put("refResources", ImmutableList.builder()
                        .add("codes")
                        .build())
                // TO DO : sorting is not suppport for such case.
                // .put("sorting",ImmutableMap.builder().put("asc",true).put("field","codes.code").build())
                .build();

        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/enum/cats/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].codes", hasSize(4)));
    }

    @Test
    public void retrieveCiLayersFromCodesCrossResourceReferenceToCat() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(new Filter("cat.catName", "eq", "ci_layer"))
                        .build())
                .put("refResources", ImmutableList.builder()
                        .add("cat")
                        .build())
                .put("sorting", ImmutableMap.builder()
                        .put("asc", true)
                        .put("field", "code")
                        .build())
                .build();

        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/enum/codes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(4)));
    }

    @Test
    public void createACatTypeThenReturnCatTypeWithId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(genCatTypeCreateRequest("mock_callback_id_1", "mock_cat_type_name", 22))
                .build();

        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].callbackId", is("mock_callback_id_1")))
                .andExpect(jsonPath("$.data[0].catTypeId", notNullValue()));
    }

    @Test
    public void createMultipleCatTypesThenReturnMultipleCatTypeWithIds() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(genCatTypeCreateRequest("mock_callback_id_1", "mockCatTypeName1", 1))
                .add(genCatTypeCreateRequest("mock_callback_id_2", "mockCatTypeName2", 22))
                .build();

        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(2)))
                .andExpect(jsonPath("$.data[0].callbackId", is("mock_callback_id_1")))
                .andExpect(jsonPath("$.data[0].catTypeId", notNullValue()))
                .andExpect(jsonPath("$.data[1].callbackId", is("mock_callback_id_2")))
                .andExpect(jsonPath("$.data[1].catTypeId", notNullValue()));

    }

    @Test
    public void createMultipleCatTypesWithInvalidArgmentsThenReturnTheInvalidCatTypesWithErrorMessage() throws Exception {
        int invalidCiTypeId = 99999;
        List<?> jsonList = ImmutableList.builder()
                .add(genCatTypeCreateRequest("mock_callback_id_1", "mockCatTypeName1", invalidCiTypeId))
                .add(genCatTypeCreateRequest("mock_callback_id_2", "mockCatTypeName2", 22))
                .build();

        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].callbackId", is("mock_callback_id_1")))
                .andExpect(jsonPath("$.data[0].errorMessage", notNullValue()));
    }

    @Test
    public void updateMultipleCatTypesThenReturnMultipleCatTypeResults() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(genCatTypeUpdateRequest("mock_callback_id_1", "mock_cat_name_1", 3))
                .add(genCatTypeUpdateRequest("mock_callback_id_2", "mock_cat_name_2", 4))
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(2)))
                .andExpect(jsonPath("$.data[0].callbackId", is("mock_callback_id_1")))
                .andExpect(jsonPath("$.data[0].catTypeId", is(3)))
                .andExpect(jsonPath("$.data[1].callbackId", is("mock_callback_id_2")))
                .andExpect(jsonPath("$.data[1].catTypeId", is(4)));
    }

    @Test
    public void updateMultipleCatTypesWithInvalidArgmentsThenReturnTheInvalidCatTypesWithErrorMessage() throws Exception {
        int invalidCatTypeId = 9999;
        List<?> jsonList = ImmutableList.builder()
                .add(genCatTypeUpdateRequest("mock_callback_id_1", "mock_cat_name_1", invalidCatTypeId))
                .add(genCatTypeUpdateRequest("mock_callback_id_2", "mock_cat_name_2", 4))
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/enum/catTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].callbackId", is("mock_callback_id_1")))
                .andExpect(jsonPath("$.data[0].errorMessage", notNullValue()));
    }

    @Test
    @Ignore
    public void deleteACatTypeThenShouldNotBeRetrieved() throws Exception {
        String reqJson = "[3]";
        mvc.perform(post("/api/v2/enum/catTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "catTypeName")
                                .put("operator", "eq")
                                .put("value", "CMDB Commons")
                                .build())
                        .build())
                .build();

        reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(0)));
    }

    @Test
    public void createANewCiTypeThenItShouldBeRetrieved() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "mock_callback_id_1")
                        .put("name", "mock_ci_type_1")
                        .put("description", "mock_ci_type_desc_1")
                        .put("tableName", "mock_table_1")
                        .put("catalogId", 1)
                        .put("seqNo", "1")
                        .put("layerId", "5")
                        .put("zoomLevelId", "9")
                        .put("imageFileId", "1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "name")
                                .put("operator", "eq")
                                .put("value", "mock_ci_type_1")
                                .build())
                        .build())
                .build();

        reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/ciTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].ciTypeId", notNullValue()));
    }

    @Test
    public void applyCiTypeWithAttrsThenTheCiStatusShouldBeCreatedAndCanBeRetrievedWithoutException() throws Exception {
        int ciTypeId = 21;
        mvc.perform(post("/api/v2/ci/" + ciTypeId + "/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));

        mvc.perform(post("/api/v2/ciTypes/applyAll").contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        this.reload();

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "name")
                                .put("operator", "eq")
                                .put("value", "Mock_Ci_Type_A")
                                .build())
                        .build())
                .build();

        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/api/v2/ciTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].status", is("created")));

        mvc.perform(post("/api/v2/ci/" + ciTypeId + "/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void applyDirtyAttrsThenTheAttrStatusShouldBeCreatedAndCanBeRetrievedWithoutException() throws Exception {
        int ciTypeId = 21;
        mvc.perform(post("/api/v2/ciTypes/applyAll").contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> retrieveJsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "ciTypeId")
                                .put("operator", "eq")
                                .put("value", ciTypeId)
                                .build())
                        .add(ImmutableMap.builder()
                                .put("name", "propertyName")
                                .put("operator", "eq")
                                .put("value", "mock_attr_a")
                                .build())
                        .build())
                .build();

        String retrieveReqJson = JsonUtil.toJson(retrieveJsonMap);
        MvcResult result = mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(retrieveReqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].status", is("created")))
                .andExpect(jsonPath("$.data.contents[0].name", is("Mock_Attr_A")))
                .andExpect(jsonPath("$.data.contents[0].length", is(10)))
                .andReturn();

        String retContent = result.getResponse()
                .getContentAsString();
        int ciTypeAttrId = JsonUtil.asNodeByPath(retContent, "/data/contents/0/ciTypeAttrId")
                .asInt();

        List<?> updateJsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("ciTypeId", ciTypeId)
                        .put("ciTypeAttrId", ciTypeAttrId)
                        .put("length", 20)
                        .build())
                .build();

        String updateReqJson = JsonUtil.toJson(updateJsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(updateReqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(retrieveReqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].status", is("dirty")));

        mvc.perform(post("/api/v2/ciTypeAttrs/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[" + ciTypeAttrId + "]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(retrieveReqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].status", is("created")))
                .andExpect(jsonPath("$.data.contents[0].length", is(20)));

        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "mock_callback_id_1")
                        .put("mock_attr_a", "value_longer_than_10")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);

        this.reload();

        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));
    }

    @Test
    public void retrieveCiWithFilterThenReturnFilteredCiData() throws Exception {
        int ciTypeId = 2;
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "name_en")
                                .put("operator", "eq")
                                .put("value", "Bank system")
                                .build())
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonMap);

        mvc.perform(post("/api/v2/ci/" + ciTypeId + "/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].data.name_en", is("Bank system")));
    }

    @Test
    public void createACiThenItShouldBeRetrieved() throws Exception {
        int ciTypeId = 2;
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "mock_callback_id_1")
                        .put("name_en", "mock_en_name")
                        .put("name_cn", "mock_cn_name")
                        .put("description", "mock_desc")
                        .put("system_type", 554)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);

        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "name_en")
                                .put("operator", "eq")
                                .put("value", "mock_en_name")
                                .build())
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonMap);

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].data.name_en", is("mock_en_name")));
    }

    @Test
    public void createMutipleCisThenTheyShouldBeRetrieved() throws Exception {
        int ciTypeId = 2;
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "mock_callback_id_1")
                        .put("name_en", "mock_en_name_1")
                        .put("name_cn", "mock_cn_name_1")
                        .put("description", "mock_desc_1")
                        .put("system_type", 554)
                        .build())
                .add(ImmutableMap.builder()
                        .put("callbackId", "mock_callback_id_2")
                        .put("name_en", "mock_en_name_2")
                        .put("name_cn", "mock_cn_name_2")
                        .put("description", "mock_desc_2")
                        .put("system_type", 554)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);

        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(2)))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andExpect(jsonPath("$.data[1].guid", notNullValue()));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "name_en")
                                .put("operator", "contains")
                                .put("value", "mock_en_name")
                                .build())
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonMap);

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].data.name_en", is("mock_en_name_1")))
                .andExpect(jsonPath("$.data.contents[1].data.name_en", is("mock_en_name_2")));
    }

    @Test
    public void updateMutipleCisThenTheUpdatedCisShouldBeRetrieved() throws Exception {
        int ciTypeId = 2;
        String changeToDesc1 = "test desc 1";
        String changeToDesc2 = "test desc 2";

        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "234567")
                        .put("name_en", "test name")
                        .put("description", changeToDesc1)
                        .put("guid", "0002_0000000001")
                        .put("system_type", 554)
                        .build())
                .add(ImmutableMap.builder()
                        .put("callbackId", "234567")
                        .put("name_en", "test name2")
                        .put("description", changeToDesc2)
                        .put("guid", "0002_0000000002")
                        .put("system_type", 554)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(2)))
                .andExpect(jsonPath("$.data[0].description", is(changeToDesc1)))
                .andExpect(jsonPath("$.data[1].description", is(changeToDesc2)));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "description")
                                .put("operator", "in")
                                .put("value", ImmutableList.builder()
                                        .add(changeToDesc1)
                                        .add(changeToDesc2)
                                        .build())
                                .build())
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonMap);

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].data.description", is(changeToDesc1)))
                .andExpect(jsonPath("$.data.contents[1].data.description", is(changeToDesc2)));
    }

    @Test
    public void deleteMutipleCisThenTheCisShouldNotBeRetrieved() throws Exception {
        int ciTypeId = 2;

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(2)));

        List<?> jsonList = ImmutableList.builder()
                .add("0002_0000000002")
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    private ImmutableMap<Object, Object> genCatTypeCreateRequest(String callbackId, String mockCatTypeName, int ciTypeId) {
        return ImmutableMap.builder()
                .put("callbackId", callbackId)
                .put("catTypeName", mockCatTypeName)
                .put("description", "mock_description")
                .put("ciTypeId", ciTypeId)
                .build();
    }

    private ImmutableMap<Object, Object> genCatTypeUpdateRequest(String callbackId, String catName, int catTypeId) {
        return ImmutableMap.builder()
                .put("callbackId", callbackId)
                .put("catTypeId", catTypeId)
                .put("catTypeName", catName)
                .put("description", "mock_description_update")
                .build();
    }
}
