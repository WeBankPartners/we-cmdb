package com.webank.cmdb.controller.apiv2;

import static com.webank.cmdb.controller.QueryRequestUtils.defaultQueryObject;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.Matchers.nullValue;
import static org.junit.Assert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;
import java.util.Optional;

import org.assertj.core.util.Strings;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.StateOperation;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmStateTransitionRepository;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerStateTransitionTest extends LegacyAbstractBaseControllerTest {

    @Autowired
    private AdmStateTransitionRepository stateTransitionRepository;
    @Autowired
    private AdmBasekeyCodeRepository admBasekeyCodeRepository;
    @Autowired
    private CiService ciService;

    ArrayList<String> newOperationList = Lists.newArrayList("discard", "confirm", "startup", "stop");

    @Test
    public void operateDiscardsThenAllFieldRollbackIncludePGuid() throws Exception {
        int ciTypeId = 81;
        String guid = "0081_00000001";
        operateState(ciTypeId, guid, StateOperation.Confirm);
        updateCiData(ciTypeId, guid);
        String pGuid = getFieldValue(ciTypeId, guid, "p_guid", false);
        String p_pGuid = getFieldValue(ciTypeId, pGuid, "p_guid", true);
        String p_desc = getFieldValue(ciTypeId, pGuid, "description", true);
        operateState(ciTypeId, guid, StateOperation.Discard);
        String c_pGuid = getFieldValue(ciTypeId, guid, "p_guid", false);
        String c_desc = getFieldValue(ciTypeId, guid, "description", false);
        assertThat(p_pGuid, equalTo(c_pGuid));
        assertThat(p_desc, equalTo(c_desc));
    }

    // Create Type
    // null -> created pending
    @Test
    public void runCreateTypeShortLifecycleWhenSuccessful() throws Exception {
        int ciTypeId = 81;
        ArrayList<Integer> stateTransitionList = Lists.newArrayList(2);
        String expectedState = "created";
        boolean fixedDateHasValue = false;

        runStateTransitionFlow(ciTypeId, null, stateTransitionList);
    }

    // created pending -> null
    @Test
    public void runCreateTypeShortLifecycle2WhenSuccessful() throws Exception {
        int ciTypeId = 81;
        String guid = "0081_00000001";
        ArrayList<Integer> stateTransitionList = Lists.newArrayList(1);

        runStateTransitionFlow(ciTypeId, guid, stateTransitionList);
        queryCiDataShouldBeNotFound(ciTypeId, guid);
    }

    @Test
    public void runCreateTypeStateTransitionLongLifecycleWhenSuccessful() throws Exception {
        int ciTypeId = 81;
        String guid = "0081_00000001";
        ArrayList<Integer> stateTransitionLongLifecycle = Lists.newArrayList(3, 4, 5, 6, 7, 8, 5, 10, 11, 12, 13, 14, 13, 15);
        String expectedState = "destroyed";
        boolean fixedDateHasValue = true;

        runStateTransitionFlow(ciTypeId, guid, stateTransitionLongLifecycle);
        queryCiDataShouldBeSuccessful(ciTypeId, guid, expectedState, fixedDateHasValue);
    }

    // Startup Type
    // null -> created pending
    @Test
    public void runStartupTypeShortLifecycleWhenSuccessful() throws Exception {
        int ciTypeId = 82;
        ArrayList<Integer> stateTransitionList = Lists.newArrayList(17);
        String expectedState = "created";
        boolean fixedDateHasValue = false;

        runStateTransitionFlow(ciTypeId, null, stateTransitionList);
    }

    // created pending -> null
    @Test
    public void runStartupTypeShortLifecycle2WhenSuccessful() throws Exception {
        int ciTypeId = 82;
        String guid = "0082_00000001";
        ArrayList<Integer> stateTransitionList = Lists.newArrayList(16);

        runStateTransitionFlow(ciTypeId, guid, stateTransitionList);
        queryCiDataShouldBeNotFound(ciTypeId, guid);
    }

    @Test
    public void runStartupTypeStateTransitionLongLifecycleWhenSuccessful() throws Exception {
        int ciTypeId = 82;
        String guid = "0082_00000001";
        ArrayList<Integer> stateTransitionLongLifecycle = Lists.newArrayList(18, 19, 20, 21, 23, 24, 20, 22, 26, 27, 30, 31, 30, 34, 35, 36, 37, 38, 39, 36, 25, 28, 29, 32, 33, 40, 41, 40, 42);
        String expectedState = "destroyed";
        boolean fixedDateHasValue = true;

        runStateTransitionFlow(ciTypeId, guid, stateTransitionLongLifecycle);
        queryCiDataShouldBeSuccessful(ciTypeId, guid, expectedState, fixedDateHasValue);
    }

    // DesignType
    // null -> created pending
    @Test
    public void runDesignTypeShortLifecycleWhenSuccessful() throws Exception {
        int ciTypeId = 83;
        ArrayList<Integer> stateTransitionList = Lists.newArrayList(44);
        String expectedState = "created";
        boolean fixedDateHasValue = false;

        runStateTransitionFlow(ciTypeId, null, stateTransitionList);
    }

    // created pending -> null
    @Test
    public void runDesignTypeShortLifecycle2WhenSuccessful() throws Exception {
        int ciTypeId = 83;
        String guid = "0083_00000001";
        ArrayList<Integer> stateTransitionList = Lists.newArrayList(43);

        runStateTransitionFlow(ciTypeId, guid, stateTransitionList);
        queryCiDataShouldBeNotFound(ciTypeId, guid);
    }

    @Test
    public void runDesignTypeStateTransitionLongLifecycleWhenSuccessful() throws Exception {
        int ciTypeId = 83;
        String guid = "0083_00000001";
        ArrayList<Integer> stateTransitionLongLifecycle = Lists.newArrayList(45, 46, 49, 50, 47, 48, 47, 51, 52, 53, 54, 55, 56, 55, 57);
        String expectedState = "delete";
        boolean fixedDateHasValue = true;

        runStateTransitionFlow(ciTypeId, guid, stateTransitionLongLifecycle);
        queryCiDataShouldBeSuccessful(ciTypeId, guid, expectedState, fixedDateHasValue);
    }

    private void runStateTransitionFlow(int ciTypeId, String guid, ArrayList<Integer> stateTransitionIdList) throws Exception {
        for (int i = 0; i < stateTransitionIdList.size(); i++) {
            runStateTransitionCaseByIdShouldBeSuccessful(ciTypeId, guid, stateTransitionIdList.get(i));
        }
    }

    private void runStateTransitionCaseByIdShouldBeSuccessful(int ciTypeId, String guid, Integer stateTransitionId) throws Exception {
        Optional<AdmStateTransition> stateTransitionData = stateTransitionRepository.findById(stateTransitionId);
        Optional<AdmBasekeyCode> enumData = admBasekeyCodeRepository.findById(stateTransitionData.get()
                .getOperation());
        String operation = enumData.get()
                .getCode();

        System.out.println("operation=" + operation + " (" + stateTransitionId + ")");
        if (newOperationList.contains(operation)) {
            operateState(ciTypeId, guid, StateOperation.fromCode(operation));
        } else if (operation.equals("delete")) {
            deleteCiData(ciTypeId, guid);
        } else if (operation.equals("update")) {
            updateCiData(ciTypeId, guid);
        } else if (operation.equals("insert")) {
            System.out.println("Insert CI Data");
            if (ciTypeId == 83) {
                insertDesignTypeCiData(ciTypeId);
            } else {
                insertNonDesignTypeCiData(ciTypeId);
            }
        }
    }

    private void operateState(int ciTypeId, String guid, StateOperation operation) throws Exception {
        String url = formatUrlPathVariables("/api/v2/ci/state/operate", ciTypeId, guid) + "?operation=" + operation.getCode();
        System.out.println("url= " + url);
        mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(Lists.newArrayList(new CiIndentity(ciTypeId, guid)))))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private void deleteCiData(int ciTypeId, String guid) throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(guid));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private void updateCiData(int ciTypeId, String guid) throws Exception {
        // get existing description
        com.webank.cmdb.dto.QueryRequest request;
        String existingDesc = getFieldValue(ciTypeId, guid, "description", false);

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("guid", guid)
                .put("description", "update desc new")
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        MvcResult updateResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(equalTo(1))))
                .andReturn();

        String updatedRet = updateResult.getResponse()
                .getContentAsString();
        JsonNode updateResultDataNode = new ObjectMapper().readTree(updatedRet)
                .get("data");
        if (updateResultDataNode.isArray()) {
            assertThat(updateResultDataNode.get(0)
                    .get("description")
                    .asText(), equalTo("update desc new"));
        }

        String parentGuid = JsonUtil.asNodeByPath(updatedRet, "/data/0/p_guid")
                .asText();
        if (!Strings.isNullOrEmpty(parentGuid)) {
            // compare the description from parent ci with existing description
            request = new com.webank.cmdb.dto.QueryRequest();
            request.getDialect()
                    .setShowCiHistory(true);
            request.setFilters(Lists.newArrayList(new Filter("guid", FilterOperator.Equal.getCode(), parentGuid)));
            MvcResult parentResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                    .content(JsonUtil.toJson(request)))
                    .andReturn();
            String parentRetContent = parentResult.getResponse()
                    .getContentAsString();
            String parentDesc = JsonUtil.asNodeByPath(parentRetContent, "/data/contents/0/data/description")
                    .asText();
            assertThat(parentDesc, equalTo(existingDesc));
        }

    }

    private String getFieldValue(int ciTypeId, String guid, String field, boolean showHisData) throws Exception {
        com.webank.cmdb.dto.QueryRequest request = new com.webank.cmdb.dto.QueryRequest();
        request.setFilters(Lists.newArrayList(new Filter("guid", FilterOperator.Equal.getCode(), guid)));
        if (showHisData) {
            request.getDialect()
                    .setShowCiHistory(true);
        }
        MvcResult existingResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(request)))
                .andReturn();

        String retContent = existingResult.getResponse()
                .getContentAsString();
        String existingDesc = JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/" + field)
                .asText();
        return existingDesc;
    }

    private void insertNonDesignTypeCiData(int ciTypeId) throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "insert desc")
                .put("name", String.valueOf(System.currentTimeMillis()))
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();
        queryCiDataShouldBeSuccessful(ciTypeId, guid, "created", false);
    }

    private void insertDesignTypeCiData(int ciTypeId) throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "insert desc")
                .put("state", 141)
                .put("name", String.valueOf(System.currentTimeMillis()))
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();
        queryCiDataShouldBeSuccessful(ciTypeId, guid, "new", false);
    }

    /*
     * private void runStateTransitionCaseByIdShouldBeFailed(int ciTypeId, String
     * guid, int stateTransitionId) throws Exception { String operation = ""; //get
     * operation from DB adm_state_transition by stateTransitionId;
     * 
     * mvc.perform(post(formatUrlPathVariables("/ci/%d/%d/state/operate", ciTypeId,
     * guid) + "?operation=" + operation)
     * .contentType(MediaType.APPLICATION_JSON).content("{}"))
     * .andExpect(jsonPath("$.statusCode", is("ERROR"))); }
     */

    private void queryCiDataShouldBeSuccessful(int ciTypeId, String guid, String expectedState, boolean fixedDataHasValue) throws Exception {
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("guid", guid)
                .withPaging(false);
        String reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].data.state.code", is(expectedState)))
                .andExpect(jsonPath("$.data.contents[0].data.fixed_date", fixedDataHasValue ? notNullValue() : nullValue()));
    }

    private void queryCiDataShouldBeNotFound(int ciTypeId, String guid) throws Exception {
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("guid", guid)
                .withPaging(false);
        String reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(0)));
    }

    private String formatUrlPathVariables(String path, Object... pathVariables) {
        if (pathVariables != null && pathVariables.length > 0) {
            path = String.format(path, pathVariables);
        }
        return path;
    }
}
