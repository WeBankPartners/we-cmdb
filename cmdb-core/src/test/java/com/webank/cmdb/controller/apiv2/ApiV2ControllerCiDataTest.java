package com.webank.cmdb.controller.apiv2;

import static com.webank.cmdb.controller.QueryRequestUtils.defaultQueryObject;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.isEmptyOrNullString;
import static org.hamcrest.Matchers.lessThanOrEqualTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static com.webank.cmdb.util.SpecialSymbolUtils.getAfterSpecialSymbol;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import org.junit.Ignore;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.constant.AutoFillType;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.dto.AutoFillItem;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerCiDataTest extends LegacyAbstractBaseControllerTest {

    @Autowired
    private EntityManager entityManager;

    private static final int ciTypeId = 3;

    @Test
    public void whenCreateCiDataWithoutValueForSystemFillFieldThenShouldBeSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("ciTypeAttrId", 30)
                        .put("isAuto", false)
                        .put("isNullable", false)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "enName")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));
    }

    @Test
    public void whenCreateCiDataWithEnumIsEmptyStringAndTargetFieldIsAllowNullThenShouldBeSuccess() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "enName")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .put("state", "")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));
    }

    @Test
    public void createCiDataThenReturnNewGuid() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "enName")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));
    }

    @Test
    public void createCiDataWithoutEnNameThenGetInvalidArgumentError() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_cn", "chinese name")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void queryCiDataWithoutArgument() throws Exception {
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(12)));
    }

    @Test
    public void queryCiDataThenTheDecommissionedFieldShouldNotBeReturned() throws Exception {
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", 4).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].name_cn").doesNotExist());
    }
    
    
    @Test
    public void queryCiDataWithFilterThenReturnCi() throws Exception {
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addContainsFilter("description", "Subsystem2")
                .withPaging(false);
        String reqJson = JsonUtil.toJsonString(queryObject);

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void queryCiDataByPagingThenReturnData() throws Exception {
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.withPagable(0, 10);
        String reqJson = JsonUtil.toJsonString(queryObject);
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size(), equalTo(10));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/created_date")
                .asText(), isEmptyOrNullString());

        int total = JsonUtil.asNodeByPath(retContent, "/data/pageInfo/totalRows")
                .asInt();
        assertThat(total, greaterThanOrEqualTo(11));
    }

    @Test
    public void updateCiDataThenReturnData() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("guid", "0002_0000000002")
                .put("description", "update desc")
                .put("name_cn", "测试系统update")
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        MvcResult updateResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/update", 2).contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(equalTo(1))))
                .andReturn();

        JsonNode updateResultDataNode = new ObjectMapper().readTree(updateResult.getResponse()
                .getContentAsString())
                .get("data");
        if (updateResultDataNode.isArray()) {
            assertThat(updateResultDataNode.get(0)
                    .get("description")
                    .asText(), equalTo("update desc"));
            assertThat(updateResultDataNode.get(0)
                    .get("name_cn")
                    .asText(), equalTo("测试系统update"));
        }
    }

    @Test
    @Transactional
    public void deleteCiDataWithoutReferenceThenReturnSuccess() throws Exception {
        List<String> Ids = Arrays.asList("0003_0000000002");
        String reqJson = JsonUtil.toJson(Ids);
        System.out.println("reqJson= " + reqJson);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    @Transactional
    public void deleteCiDataWithReferencedCiAndWithoutDeleteValidateThenReturnFailed() throws Exception {
        List<String> Ids = Arrays.asList("0002_0000000001");
        String reqJson = JsonUtil.toJson(Ids);
        System.out.println("reqJson= " + reqJson);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", 2).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    @Transactional
    public void deleteCiDataWithReferenceAndIsNotDeleteValidateThenReturnSuccess() throws Exception {
        List<String> Ids = Arrays.asList("0003_0000000001");
        String reqJson = JsonUtil.toJson(Ids);
        System.out.println("reqJson= " + reqJson);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void createCiDataWithoutRequriedFiledThenGetError() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_cn", "测试系统")
                .put("state", 556)
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void whenCreateCiDataWithAutoFillFromCiDataItselfThenShouldFillValueAsExpected() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":21,\"isReferedFromParent\":1}}]"));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        String expectedKeyName = "Test Sub System";
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenCreateCiDataWithAutoFillFromOtherCiDataThenShouldFillValueAsExpected() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":23,\"isReferedFromParent\":1}},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":7,\"isReferedFromParent\":1}}]"));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        String expectedKeyName = "Bank system";
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenCreateCiDataWithCombinedRuleThenShouldFillValueAsExpected() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":21,\"isReferedFromParent\":1}}]"));
        autoFillItems.add(new AutoFillItem(AutoFillType.Delimiter.getCode(), "-"));
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":23,\"isReferedFromParent\":1}},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":7,\"isReferedFromParent\":1}}]"));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        String expectedKeyName = "Test Sub System-Bank system";
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenCreateCiDataWithRuleToGetSelectFieldThenShouldFillValueAsExpected() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3}, {\"ciTypeId\":3,\"parentRs\":{\"attrId\":25,\"isReferedFromParent\":1},\"enumCodeAttr\":\"code\"}]"));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        String expectedKeyName = "created";
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenUpdateCiDataWithSingleRefThenShouldUpdateTheReferredAutoFillDataAccordingly() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        String rule = "[{\"ciTypeId\":3}, {\"ciTypeId\":3,\"parentRs\":{\"attrId\":26,\"isReferedFromParent\":1}}]";
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), rule));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult result = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();

        String expectedUpdateKeyName = "test desc update";
        jsonMap = ImmutableMap.builder()
                .put("guid", guid)
                .put("description", "test desc update")
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].key_name", is(expectedUpdateKeyName)));
    }

    @Test
    public void whenUpdateCiDataWithMultiRefThenShouldUpdateTheReferredAutoFillDataAccordingly() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":26,\"isReferedFromParent\":1}}]"));
        autoFillItems.add(new AutoFillItem(AutoFillType.Delimiter.getCode(), "-"));
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":23,\"isReferedFromParent\":1}},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":10,\"isReferedFromParent\":1}}]"));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "Subsys Desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult result = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();

        String expectedUpdateKeyName = "Subsys Desc update-Bank system";
        jsonMap = ImmutableMap.builder()
                .put("guid", guid)
                .put("description", "Subsys Desc update")
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].key_name", is(expectedUpdateKeyName)));

        expectedUpdateKeyName = "Subsys Desc update-Bank system desc update";
        jsonMap = ImmutableMap.builder()
                .put("guid", "0002_0000000001")
                .put("description", "Bank system desc update")
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", 2).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedUpdateKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenUpdateCiDataWithRuleOnItsGrandChildrenThenShouldUpdateTheReferredAutoFillDataAccordingly() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(),
                "[{\"ciTypeId\":5},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":50,\"isReferedFromParent\":1}},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":23,\"isReferedFromParent\":1}},{\"ciTypeId\":2,\"parentRs\":{\"attrId\":10,\"isReferedFromParent\":1}}]"));

        Integer attrIdOfKeyName = 58;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        String expectedUpdateKeyName = "Bank system desc update";
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("guid", "0002_0000000001")
                .put("description", "Bank system desc update")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", 2).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedUpdateKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", 5).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(2)));
    }

    @Test
    public void whenUpdateCiDataWithRuleReferToThenShouldAutoFillDataAccordingly() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":2},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":23,\"isReferedFromParent\":0}},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":26,\"isReferedFromParent\":1}}]"));

        Integer attrIdOfKeyName = 14;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));
        String separator = getAfterSpecialSymbol(",");
        
        String expectedUpdateKeyNameold = "Subsys Desc update,Subsystem1,Subsystem2,Subsystem3,Subsystem4,Subsystem5,Subsystem6,Subsystem7,Subsystem8,Subsystem9,Subsystem10,Subsystem11";
        String expectedUpdateKeyName = expectedUpdateKeyNameold.replace(",", separator);
        
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("guid", "0003_0000000001")
                .put("description", "Subsys Desc update")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedUpdateKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", 2).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    @Test
    public void whenCreateCiDataWithGuidAsAutoFillLeaveThenShouldFillValueAsExpected() throws Exception {
        List<AutoFillItem> autoFillItems = new ArrayList<AutoFillItem>();
        autoFillItems.add(new AutoFillItem(AutoFillType.Rule.getCode(), "[{\"ciTypeId\":3},{\"ciTypeId\":3,\"parentRs\":{\"attrId\":27,\"isReferedFromParent\":1}}]"));
        autoFillItems.add(new AutoFillItem(AutoFillType.Delimiter.getCode(), "_blank"));

        Integer attrIdOfKeyName = 28;
        updateCiAttrWithAutoFillRule(attrIdOfKeyName, JsonUtil.toJson(autoFillItems));

        String expectedKeyName = "0003_0000000013_blank";
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "Test Sub System")
                .put("name_cn", "测试系统")
                .put("system_id", "0002_0000000001")
                .put("zone_id", "1")
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyName)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    private void updateCiAttrWithAutoFillRule(Integer attrId, String autoFillRule) throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("ciTypeAttrId", attrId)
                        .put("isAuto", true)
                        .put("autoFillRule", autoFillRule)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Ignore
    @Transactional
    // TO DO : Need to investigate why it can pass in eclipse but fail in command
    // line running.
    public void whenQueryCiThenTheCallHibernateCountShouldLessThan() throws Exception {
        int ciTypeId = 8;
        TestDatabase.enableH2Statistics(entityManager);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        assertThat(TestDatabase.getQueryCount(entityManager), lessThanOrEqualTo(3));
        TestDatabase.disableH2Statistics(entityManager);
    }

    @Test
    public void whenCreateCiDataWithRegularExpressionRuleAndCreateWithValidValueThenShouldSuccess() throws Exception {
        validateValueWithRegularExpressionRule("[a-z]+", "lowercase", "OK");
    }

    @Test
    public void whenCreateCiDataWithRegularExpressionRuleAndCreateWithInvalidValueThenShouldFail() throws Exception {
        validateValueWithRegularExpressionRule("[a-z]+", "UPPERCASE", "ERR_BATCH_CHANGE");
    }

    @Test
    public void whenCreateCiDataWithEmptyRegularExpressionRuleAndCreateWithAnyValudThenShouldSuccess() throws Exception {
        validateValueWithRegularExpressionRule("", "UPPERCASElowercase", "OK");
    }

    private void validateValueWithRegularExpressionRule(String regularExpressionRule, String inputValue, String expectedStatusCode) throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("ciTypeAttrId", 7)
                        .put("regularExpressionRule", regularExpressionRule)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", inputValue)
                .put("system_type", 554)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", 2).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is(expectedStatusCode)));
    }

    @Test
    public void updateCiDataWithImproperListValueThenGetError() throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("guid", "0002_0000000002")
                .put("name_cn", Lists.newArrayList("name1","name2"))
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", 2).contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));

    }
    
}
