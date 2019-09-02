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

import javax.transaction.Transactional;

import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerCiTypeAttrTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void whenCreateCiAttrPropertyNameStartWithUppercaseLetterThenShouldFail() throws Exception {
        Map<?, ?> map = ImmutableMap.builder()
                .put("ciTypeId", 1)
                .put("description", "des")
                .put("inputType", "text")
                .put("isAccessControlled", false)
                .put("isDefunct", false)
                .put("isEditable", false)
                .put("isHidden", false)
                .put("isNullable", true)
                .put("isSystem", false)
                .put("length", 10)
                .put("name", "test1")
                .put("propertyName", "Test1")
                .put("propertyType", "varchar")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(map));
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiAttrWithInvalidCharacterInPropertyNameThenShouldFail() throws Exception {
        String reqJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1*")));
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void createCiAttrsThenReturnSuccess() throws Exception {
        String reqJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1")));
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].ciTypeId", greaterThan(0)));
    }

    @Test
    public void queryCiAttrsWithoutArgumentThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1")));
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson));

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data.contents[?(@.name=='testName1')].name").value(is(Arrays.asList("testName1"))));
    }

    @Test
    public void queryCiAttrsWithFilterArgumentThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1")));
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("name", "testName1");
        String reqJson = JsonUtil.toJsonString(queryObject);

        mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data.contents[?(@.name=='testName1')].name").value(is(Arrays.asList("testName1"))));
    }

    @Test
    public void queryCiAttrsByPagingThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1"), mockCiTextAttrDtoWithName("Name2"), mockCiTextAttrDtoWithName("Name3"), mockCiTextAttrDtoWithName("Name4"),
                mockCiTextAttrDtoWithName("Name5"), mockCiTextAttrDtoWithName("Name6"), mockCiTextAttrDtoWithName("Name7"), mockCiTextAttrDtoWithName("Name8"), mockCiTextAttrDtoWithName("Name9"), mockCiTextAttrDtoWithName("Name10"),
                mockCiTextAttrDtoWithName("Name11")));
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.withPagable(0, 10);
        String reqJson = JsonUtil.toJsonString(queryObject);
        MvcResult mvcResult = mvc.perform(post("/api/v2/ciTypeAttrs/retrieve").contentType(MediaType.APPLICATION_JSON)
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
    public void updateCiAttrsThenReturnData() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1")));

        MvcResult mvcResult = mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        int ciTypeAttrId = 0;
        JsonNode dataNode = new ObjectMapper().readTree(mvcResult.getResponse()
                .getContentAsString())
                .get("data");
        if (dataNode.isArray()) {
            ciTypeAttrId = dataNode.get(0)
                    .get("ciTypeAttrId")
                    .asInt();
        }

        System.out.println("ciTypeAttrId= " + ciTypeAttrId);
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("ciTypeAttrId", ciTypeAttrId)
                .put("description", "update desc")
                .put("isEditable", 1)
                .put("isHidden", 1)
                .put("isNullable", 1)
                .put("isUnique", 1)
                .put("isDefunct", 1)
                .put("isSystem", 1)
                .put("length", 20)
                .put("name", "updateName")
                .put("propertyName", "updateName")
                .put("propertyType", "varchar")
// TODO - After support input 'status', need to test it (expect: input 'status', but it will be ignore.)
//                .put("status", "created")
                .put("isAccessControlled", 1)
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        MvcResult updateResult = mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(equalTo(1))))
                .andReturn();

        JsonNode updateResultDataNode = new ObjectMapper().readTree(updateResult.getResponse()
                .getContentAsString())
                .get("data");
        if (updateResultDataNode.isArray()) {
            assertThat(updateResultDataNode.get(0)
                    .get("name")
                    .asText(), equalTo("updateName"));
            assertThat(updateResultDataNode.get(0)
                    .get("propertyName")
                    .asText(), equalTo("updateName"));
            assertThat(updateResultDataNode.get(0)
                    .get("length")
                    .asInt(), equalTo(20));
            assertThat(updateResultDataNode.get(0)
                    .get("isEditable")
                    .asInt(), equalTo(1));
        }
    }

    @Test
    public void whenUpdateCreatedAttrWithoutChangeTableStructureThenAttrStatusShouldStillBeCreated() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[1]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Integer attrId = 1;
        mvc.perform(post("/api/v2/ciTypeAttrs/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[" + attrId + "]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("ciTypeAttrId", attrId)
                .put("isAuto", true)
                .put("isNullable", false)
                .put("autoFillRule", "balabala...")
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(equalTo(1))))
                .andExpect(jsonPath("$.data[0].status", is("created")));
    }

    @Test
    @Transactional
    public void deleteCiAttrsThenReturnSuccess() throws Exception {
        String mockDataJson = JsonUtil.toJson(ImmutableList.of(mockCiTextAttrDtoWithName("Name1")));
        MvcResult mvcResult = mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(mockDataJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        int ciTypeAttrId = 0;
        JsonNode dataNode = new ObjectMapper().readTree(mvcResult.getResponse()
                .getContentAsString())
                .get("data");
        if (dataNode.isArray()) {
            ciTypeAttrId = dataNode.get(0)
                    .get("ciTypeAttrId")
                    .asInt();
        }
        System.out.println("ciTypeAttrId= " + ciTypeAttrId);

        String reqJson = JsonUtil.toJson(ImmutableList.of(ciTypeAttrId));
        System.out.println("reqJson= " + reqJson);
        mvc.perform(post("/api/v2/ciTypeAttrs/delete").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private Map<?, ?> mockCiTextAttrDtoWithName(String name) {
        return ImmutableMap.builder()
                .put("ciTypeId", 1)
                .put("description", "des")
                .put("inputType", "text")
                .put("isAccessControlled", false)
                .put("isDefunct", false)
                .put("isEditable", false)
                .put("isHidden", false)
                .put("isNullable", true)
                .put("isSystem", false)
                .put("length", 10)
                .put("name", "test" + name)
                .put("propertyName", "test" + name)
                .put("propertyType", "varchar")
                .build();
    }

    @Test
    public void whenCreateCiTypeWithRefWithoutRefIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "ref")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("isNullable", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeIsAutoTrueWithAutoFillRuleThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "ref")
                        .put("referenceId", 2)
                        .put("referenceName", "refName")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("isNullable", 1)
                        .put("isAuto", true)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithoutPropertyNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 2)
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithInvalidCiTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 9999)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithDuplicatePropertyNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .put("isNullable", 0)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithLongerThan64ThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithPropertyTypeIsVarcharWithoutLengthThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithPropertyTypeIsVarcharWithLengthLessThanZeroThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", -1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithPropertyTypeIsIntWithoutLengthThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "int")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithPropertyTypeIsIntWithLengthLessThanZeroThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "int")
                        .put("length", -1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiTypeAttrWithInputTypeIsRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfGUID() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "ref")
                        .put("referenceId", 2)
                        .put("referenceName", "refName")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("isNullable", 1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_GUID)));
    }

    @Test
    public void whenCreateCiTypeAttrWithInputTypeIsOrchestrationRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfGUID() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "orchestration_ref")
                        .put("referenceName", "refName")
                        .put("referenceId", 2)
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("isNullable", 0)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_GUID)));
    }

    @Test
    public void whenCreateCiTypeAttrWithInputTypeIsMultiRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfMultipleSelect() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "multiRef")
                        .put("referenceName", "refName")
                        .put("referenceId", 2)
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("isNullable", 0)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_MULTIPLE_REF)));
    }

    @Test
    public void whenCreateCiTypeAttrWithInputTypeIsMultiOrchestrationRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfMultipleSelect() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 1)
                        .put("name", "mock_name")
                        .put("inputType", "orchestration_multi_ref")
                        .put("referenceName", "refName")
                        .put("referenceId", 2)
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("isNullable", 0)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_MULTIPLE_REF)));
    }

    @Test
    public void whenCreateCiTypeAttrWithCiTypeHaveBeenDecommissionedThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/23/implement").param("operation", "deco")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeId", 23)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .put("isNullable", 0)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    // Update

    @Test
    public void whenUpdateCiTypeAttrWithInvalidCiTypeIdThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 228)
                        .put("ciTypeId", 9999)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateNotCreatedCiTypeAttrPropertyNameMultipleTimesThenShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 268)
                        .put("propertyName", "columnA")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 268)
                        .put("propertyName", "columnB")
                        .build())
                .build();
        reqJson = JsonUtil.toJson(jsonList);

        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithLongerThan64ThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 228)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithPropertyTypeIsVarcharWithoutLengthThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 228)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithPropertyTypeIsVarcharWithLengthLessThanZeroThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 228)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", -1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithPropertyTypeIsIntWithoutLengthThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 228)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "int")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithPropertyTypeIsIntWithLengthLessThanZeroThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 228)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "int")
                        .put("length", -1)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithInputTypeIsRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfGUID() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 268)
                        .put("ciTypeId", 22)
                        .put("name", "mock_name")
                        .put("inputType", "ref")
                        .put("referenceName", "refName")
                        .put("referenceId", 2)
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_GUID)));
    }

    @Test
    public void whenUpdateCiTypeAttrWithInputTypeIsOrchestrationRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfGUID() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 261)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "orchestration_ref")
                        .put("referenceId", 2)
                        .put("referenceName", "refName")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_GUID)));
    }

    @Test
    public void whenUpdateCiTypeAttrWithInputTypeIsMultiRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfMultipleSelect() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 261)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "multiRef")
                        .put("referenceName", "refName")
                        .put("referenceId", 2)
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_MULTIPLE_REF)));
    }

    @Test
    public void whenUpdateCiTypeAttrWithInputTypeIsMultiOrchestrationRefThenTheLengthShouldBeAutoFilledAsDefaultLengthOfMultipleSelect() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 261)
                        .put("ciTypeId", 21)
                        .put("name", "mock_name")
                        .put("inputType", "orchestration_multi_ref")
                        .put("referenceName", "refName")
                        .put("referenceId", 2)
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].length", is(CmdbConstants.DEFAULT_LENGTH_OF_MULTIPLE_REF)));
    }

    @Test
    public void whenUpdateCreatedCiTypeAttrPropertyNameThenShouldFail() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 7)
                        .put("ciTypeId", 2)
                        .put("name", "mock_name")
                        .put("propertyName", "columnA")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenUpdateCiTypeAttrWithCiTypeHaveBeenDecommissionedThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/23/implement").param("operation", "deco")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("ciTypeAttrId", 280)
                        .put("ciTypeId", 23)
                        .put("name", "mock_name")
                        .put("inputType", "text")
                        .put("propertyName", "columnA")
                        .put("propertyType", "varchar")
                        .put("length", 10)
                        .put("isNullable", 0)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenDeleteCiTypeAttrIsNotExistThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypeAttrs/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[999]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCiTypeAttrIsSystemThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypeAttrs/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[1]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCiTypeAttrIsUsedForIntegrateTemplateThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypeAttrs/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[235]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenDeleteCiTypeAttrIsUsedForIntegrateTemplateRelationThenShouldFail() throws Exception {
        mvc.perform(post("/api/v2/ciTypeAttrs/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[236]"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }
    
    @Test
    public void applyNoCreatedSelfRefCiTypeThenCreateSuccessfully() throws Exception{
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[84]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    	
    }
}
