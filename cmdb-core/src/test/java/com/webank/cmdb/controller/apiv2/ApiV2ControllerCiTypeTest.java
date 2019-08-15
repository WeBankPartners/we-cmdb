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
import java.util.Map;

import org.junit.Ignore;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerCiTypeTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void createCiTypesThenAllDefautAttrsHasDesplaySeqNo() throws Exception {
        String reqJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1")));
        MvcResult result = mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        String retContent = result.getResponse()
                .getContentAsString();
        int ciTypeId = JsonUtil.asNodeByPath(retContent, "/data/0/ciTypeId")
                .asInt();

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.setFilterRs("and");
        queryObject.addEqualsFilter("ciTypeId", ciTypeId);
        queryObject.addEqualsFilter("propertyName", "code");
        reqJson = JsonUtil.toJsonString(queryObject);

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].displaySeqNo", is(5)));
    }

    @Test
    public void whenCreateCiTypeWithInvalidCharacterTableNameThenShouldFail() throws Exception {
        String reqJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1*")));
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void createCiTypesThenReturnSuccess() throws Exception {
        String reqJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1")));
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].ciTypeId", greaterThan(0)));
    }

    @Test
    public void queryCiTypesWithoutArgumentThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1")));
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson));

        mvc.perform(post("/api/v2/ciTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data.contents[?(@.name=='testCiTypeName1')].tableName").value(is(Arrays.asList("testTableName1"))));
    }

    @Test
    public void queryCiTypesWithFilterArgumentThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1")));
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("name", "testCiTypeName1");
        String reqJson = JsonUtil.toJsonString(queryObject);

        mvc.perform(post("/api/v2/ciTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data.contents[?(@.name=='testCiTypeName1')].tableName").value(is(Arrays.asList("testTableName1"))));
    }

    @Test
    public void queryCiTypesByPagingThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1"), mockCiTypeDtoWithName("Name2"), mockCiTypeDtoWithName("Name3"), mockCiTypeDtoWithName("Name4"), mockCiTypeDtoWithName("Name5"),
                mockCiTypeDtoWithName("Name6"), mockCiTypeDtoWithName("Name7"), mockCiTypeDtoWithName("Name8"), mockCiTypeDtoWithName("Name9"), mockCiTypeDtoWithName("Name10"), mockCiTypeDtoWithName("Name11")));
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.withPagable(0, 10);
        String reqJson = JsonUtil.toJsonString(queryObject);
        MvcResult mvcResult = mvc.perform(post("/api/v2/ciTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        int contentsLength = JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size();
        assertThat(contentsLength, equalTo(10));

        int total = JsonUtil.asNodeByPath(retContent, "/data/pageInfo/totalRows")
                .asInt();
        assertThat(total, greaterThanOrEqualTo(11));
    }

    @Test
    public void updateCiTypesThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1")));

        MvcResult mvcResult = mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        int ciTypeId = 0;
        JsonNode dataNode = new ObjectMapper().readTree(mvcResult.getResponse()
                .getContentAsString())
                .get("data");
        if (dataNode.isArray()) {
            ciTypeId = dataNode.get(0)
                    .get("ciTypeId")
                    .asInt();
        }

        System.out.println("ciTypeId= " + ciTypeId);
        int newCatalogId = 2;
        int newLayerId = 5;
        int newSeqNo = 2;
        String newName = "testName2";
        // String newDescription = "des2";

        Map<String, ?> jsonMap = ImmutableMap.of("ciTypeId", ciTypeId, "catalogId", newCatalogId, "seqNo", newSeqNo, "layerId", newLayerId, "name", newName);
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        MvcResult updateResult = mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(equalTo(1))))
                .andReturn();

        JsonNode updateResultDataNode = new ObjectMapper().readTree(updateResult.getResponse()
                .getContentAsString())
                .get("data");

        if (updateResultDataNode.isArray()) {
            assertThat(updateResultDataNode.get(0)
                    .get("catalogId")
                    .asInt(), equalTo(newCatalogId));
            assertThat(updateResultDataNode.get(0)
                    .get("layerId")
                    .asInt(), equalTo(newLayerId));
            assertThat(updateResultDataNode.get(0)
                    .get("seqNo")
                    .asInt(), equalTo(newSeqNo));
            assertThat(updateResultDataNode.get(0)
                    .get("name")
                    .asText(), equalTo(newName));
        }
    }

    @Test
    // TODO - remove @Ignore after support: delete related records with foreign key
    // if request to delete a CI record.
    @Ignore
    public void deleteCiTypesThenReturnSuccess() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTypeDtoWithName("Name1")));
        MvcResult mvcResult = mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        int ciTypeId = 0;
        JsonNode dataNode = new ObjectMapper().readTree(mvcResult.getResponse()
                .getContentAsString())
                .get("data");
        if (dataNode.isArray()) {
            ciTypeId = dataNode.get(0)
                    .get("ciTypeId")
                    .asInt();
        }
        System.out.println("ciTypeId= " + ciTypeId);

        String reqJson = JsonUtil.toJson(ImmutableList.of(ciTypeId));
        System.out.println("reqJson= " + reqJson);
        mvc.perform(post("/api/v2/ciTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private Map<?, ?> mockCiTypeDtoWithName(String name) {
        return ImmutableMap.builder()
                .put("description", "des")
                .put("catalogId", 1)
                .put("imageFileId", 1)
                .put("layerId", 5)
                .put("name", "testCiType" + name)
                .put("tableName", "testTable" + name)
                .build();
    }

    @Test
    public void whenCreateCiTypeWithDuplicateNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("tableName", "mock_table_name_1")
                        .put("name", "mock_ci_type")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("tableName", "mock_table_name_2")
                        .put("name", "mock_ci_type")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateDuplicateCiTypeTableNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_name_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeWithoutTableNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeTableNameLongerThan64ThenShouldFail() throws Exception {
        String invalidTableName = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB";
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", invalidTableName)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeWithInvalidCatalogIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("catalogId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeWithInvalidLayerIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("layerId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeWithInvalidCiStateTypeThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("ciStateTypeId", 9999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeWithvalidCiStateTypeThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("ciStateTypeId", 558)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenCreateCiTypeWithvalidImageFileIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("imageFileId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeThenShouldCreateThePrivateCatType() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_name_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        MvcResult result = mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        int ciTypeId = JsonUtil.asNodeByPath(retContent, "/data/0/ciTypeId")
                .asInt();

        reqJson = JsonUtil.toJsonString(defaultQueryObject().addEqualsFilter("ciTypeId", ciTypeId));
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenUpdateDuplicateCiTypeNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCreatedCiTypeNameThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 2)
                        .put("name", "mock_name")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateCiTypeWithInvalidCatalogIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("catalogId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeWithInvalidLayerIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("layerId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeWithInvalidCiStateTypeThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_1")
                        .put("ciStateTypeId", 999)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeNotCreatedTableNameThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("tableName", "mock_table_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateCiTypeCreatedTableNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 2)
                        .put("tableName", "mock_table_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypes/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDeleteCreatedCiTypeThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteNotCreatedCiTypeThenShouldDeleteItsPrivateCatTypeTogether() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("name", "mock_ci_type_1")
                        .put("tableName", "mock_table_name_1")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        MvcResult result = mvc.perform(post("/api/v2/ciTypes/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        int ciTypeId = JsonUtil.asNodeByPath(retContent, "/data/0/ciTypeId")
                .asInt();
        mvc.perform(post("/api/v2/ciTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[" + ciTypeId + "]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        reqJson = JsonUtil.toJsonString(defaultQueryObject().addEqualsFilter("ciTypeId", ciTypeId));
        mvc.perform(post("/api/v2/enum/catTypes/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(0)));
    }

    @Test
    public void whenDeleteNotCreatedCiTypeThenShouldSuccessAndItsAttrsShouldBeAllDeleted() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("filters", ImmutableList.builder()
                        .add(ImmutableMap.builder()
                                .put("name", "ciTypeId")
                                .put("operator", "eq")
                                .put("value", 1)
                                .build())
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonMap);

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(6)));

        mvc.perform(post("/api/v2/ciTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[1]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(0)));
    }

    @Test
    public void whenDeleteNotCreatedCiTypeButUsedForIntegrateTemplateThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[21]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

}
