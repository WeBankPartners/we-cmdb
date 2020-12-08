package com.webank.plugins.wecmdb.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;
import org.junit.Test;
import org.springframework.http.MediaType;

import javax.transaction.Transactional;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


public class WeCubePluginServiceEntityQueryApiTest extends AbstractBaseWeCubePluginServiceApiTest {
    private static final String ENTITIES_QUERY_URL = "/entities/query";

    @Test
    public void ci_data_query_should_succeed_and_return_empty_outputs_for_empty_input_list() throws Exception {
        assertReturnSuccessForEmptyInputList(ENTITIES_QUERY_URL);
    }

    @Transactional
    @Test
    public void ci_data_query_should_succeed_and_return_matched_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        String expectedCode = "code";
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", expectedCode));
        String guid = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> inputParamMap1 = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("entityName", ciTypeName)
                .build();
        List<Map<String, Object>> inputList = Collections.singletonList(inputParamMap1);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputList));

        mvc.perform(post(ENTITIES_QUERY_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs.length()").value(1))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults.length()").value(1))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults[0].guid").value(guid))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults[0].code").value(expectedCode))
        ;
    }

    @Transactional
    @Test
    public void ci_data_query_should_succeed_and_return_empty_result_set_for_missed_query() throws Exception {
        String ciTypeName = generateCiTypeName();
        givenAppliedCiType(ciTypeName);

        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("entityName", ciTypeName)
                .build();
        List<Map<String, Object>> inputList = Collections.singletonList(inputParamMap);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputList));

        mvc.perform(post(ENTITIES_QUERY_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs.length()").value(1))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults").isEmpty())
        ;
    }

    @Transactional
    @Test
    public void ci_data_query_should_fail_and_return_results_or_errors_for_each_input_in_batch() throws Exception {
        String ciTypeName1 = generateCiTypeName();
        int ciTypeId1 = givenAppliedCiType(ciTypeName1);
        String expectedCode = "code";
        Map<String, Object> createdCiData = givenCiData(ciTypeId1, ImmutableMap.of("code", expectedCode));
        String guid = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("entityName", ciTypeName1)
                .build();
        Map<String, Object> invalidInput = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "2")
                .build();
        List<Map<String, Object>> inputList = Arrays.asList(inputParamMap, invalidInput);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputList));

        mvc.perform(post(ENTITIES_QUERY_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resultCode").value(ERROR_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(not(SUCCESS_RESULT_MESSAGE)))
                .andExpect(jsonPath("$.results.outputs.length()").value(2))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults.length()").value(1))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults[0].guid").value(guid))
                .andExpect(jsonPath("$.results.outputs[0].matchedResults[0].code").value(expectedCode))
                .andExpect(jsonPath("$.results.outputs[1].callbackParameter").value("2"))
                .andExpect(jsonPath("$.results.outputs[1].errorCode").value("1"))
                .andExpect(jsonPath("$.results.outputs[1].errorMessage").value(not("ok")))
                .andExpect(jsonPath("$.results.outputs[1].matchedResults").doesNotExist())
        ;
    }

    @Test
    public void ci_data_query_should_return_error_for_input_as_empty_string() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(ENTITIES_QUERY_URL, "");
    }

    @Test
    public void ci_data_query_should_return_error_for_input_as_empty_json_object() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(ENTITIES_QUERY_URL, "{}");
    }

    @Test
    public void ci_data_query_should_return_error_for_input_with_missing_entity_name() throws Exception {
        assertErrorOutputForInvalidRequestInput(ENTITIES_QUERY_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1"
        ));
    }
}
