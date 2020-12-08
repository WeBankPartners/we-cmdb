package com.webank.plugins.wecmdb.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import org.junit.Test;
import org.springframework.http.MediaType;

import javax.transaction.Transactional;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;


public class WeCubePluginServiceDataRefreshApiTest extends AbstractBaseWeCubePluginServiceApiTest {
    private static final String DATA_REFRESH_URL = "/data/refresh";


    @Test
    public void ci_data_refresh_should_return_success_for_empty_inputs_list() throws Exception {
        assertReturnSuccessForEmptyInputList(DATA_REFRESH_URL);
    }

    @Transactional
    @Test
    public void ci_data_refresh_should_refresh_data_with_cascaded_filing_rule_and_return_guid() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        String attrName1 = "attr";
        int ciTypeAttrId1 = givenAppliedCiAttrForType(ciTypeId, attrName1, null);
        String attrName2 = "attrAutoFill";
        int ciTypeAttrId2 = givenAppliedCiAttrForType(ciTypeId, attrName2, buildAutoFillRule(ciTypeId, ciTypeAttrId1));
        String attrName3 = "attrCascadedAutoFill";
        givenAppliedCiAttrForType(ciTypeId, attrName3, buildAutoFillRule(ciTypeId, ciTypeAttrId2));

        String oldValue = "oldValue";
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code", attrName1, oldValue));
        String guidToRefresh = String.valueOf(createdCiData.get("guid"));

        String expectedValue = "expectedValue";
        Map<String, Object> ciDataToUpdate = Maps.newHashMap(ImmutableMap.of("guid", guidToRefresh, attrName1, expectedValue));
        ciService.update(ciTypeId, guidToRefresh, ciDataToUpdate);
        final Map<String, Object> updatedCiDataMap = getCiDataSafe(ciTypeId, guidToRefresh);
        assertThat(updatedCiDataMap, notNullValue());
        assertThat(updatedCiDataMap.get(attrName3), equalTo(oldValue));

        Map<String, Object> inputParamMap = ImmutableMap.of("guid", guidToRefresh);
        Map<String, List<Map<String, Object>>> requestMap = ImmutableMap.of("inputs", Collections.singletonList(inputParamMap));
        String requestBodyJson = new ObjectMapper().writeValueAsString(requestMap);

        mvc.perform(post(DATA_REFRESH_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[0].guid").value(guidToRefresh))
        ;
        Map<String, Object> refreshedCiDataMap = getCiDataSafe(ciTypeId, guidToRefresh);
        assertThat(refreshedCiDataMap, notNullValue());
        assertThat(refreshedCiDataMap.get(attrName3), equalTo(expectedValue));
    }

    @Transactional
    @Test
    public void ci_data_refresh_should_fail_and_return_rollbacks_or_errors_for_each_input_in_batch() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guid = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("guid", guid)
                .build();
        Map<String, Object> invalidInput = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "2")
                .build();
        List<Map<String, Object>> inputs = Arrays.asList(inputParamMap, invalidInput);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputs));

        mvc.perform(post(DATA_REFRESH_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(ERROR_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(not(SUCCESS_RESULT_MESSAGE)))
                .andExpect(jsonPath("$.results.outputs.length()").value(2))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("rollbacked"))
                .andExpect(jsonPath("$.results.outputs[0].ciData").doesNotExist())
                .andExpect(jsonPath("$.results.outputs[1].callbackParameter").value("2"))
                .andExpect(jsonPath("$.results.outputs[1].errorCode").value("1"))
                .andExpect(jsonPath("$.results.outputs[1].errorMessage").value(not("ok")))
                .andExpect(jsonPath("$.results.outputs[1].ciData").doesNotExist())
        ;
    }

    @Test
    public void ci_data_refresh_should_return_error_for_input_as_empty_string() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(DATA_REFRESH_URL, "");
    }

    @Test
    public void ci_data_refresh_should_return_error_for_input_as_empty_json_object() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(DATA_REFRESH_URL, "{}");
    }

    private String buildAutoFillRule(int ciTypeId, int ciTypeAttrId) {
        return "[{\"type\":\"rule\",\"value\":\"[" +
                "{\\\"ciTypeId\\\":" + ciTypeId + "}," +
                "{\\\"ciTypeId\\\":" + ciTypeId + ",\\\"parentRs\\\":{\\\"attrId\\\":" + ciTypeAttrId + ",\\\"isReferedFromParent\\\":1}}" +
                "]\"}]";
    }
}
