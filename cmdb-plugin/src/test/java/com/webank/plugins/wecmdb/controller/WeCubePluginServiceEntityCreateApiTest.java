package com.webank.plugins.wecmdb.controller;

import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.junit.Ignore;
import org.junit.Test;
import org.springframework.http.MediaType;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;


@Ignore
public class WeCubePluginServiceEntityCreateApiTest extends AbstractBaseWeCubePluginServiceApiTest {
    private static final String ENTITIES_CREATE_URL = "/entities/create";


    @Test
    public void ci_data_create_should_return_success_for_empty_inputs_list() throws Exception {
        assertReturnSuccessForEmptyInputList(ENTITIES_CREATE_URL);
    }

    @Transactional
    @Test
    public void ci_data_create_should_succeed_and_return_created_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        givenAppliedCiType(ciTypeName);

        String expectedCode = "expectedCode";
        Map<String, Object> ciDataMap = ImmutableMap.of("code", expectedCode);
        String callbackParameter = "1";
        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, callbackParameter)
                .put("entityName", ciTypeName)
                .put("ciData", ciDataMap)
                .build();
        Map<String, List<Map<String, Object>>> requestMap = ImmutableMap.of("inputs", Collections.singletonList(inputParamMap));
        String requestBodyJson = new ObjectMapper().writeValueAsString(requestMap);

        mvc.perform(post(ENTITIES_CREATE_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value(callbackParameter))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].ciData.id").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[0].ciData.guid").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[0].ciData.code").value(expectedCode))
        ;
    }

    @Transactional
    @Test
    public void ci_data_create_should_fail_and_return_rollbacks_or_errors_for_each_input_in_batch() throws Exception {
        String ciTypeName = generateCiTypeName();
        givenAppliedCiType(ciTypeName);

        String expectedCode = "expectedCode";
        Map<String, Object> ciDataMap = ImmutableMap.of("code", expectedCode);
        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("entityName", ciTypeName)
                .put("ciData", ciDataMap)
                .build();
        Map<String, Object> invalidInput = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "2")
                .build();
        List<Map<String, Object>> inputs = Arrays.asList(inputParamMap, invalidInput);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputs));

        mvc.perform(post(ENTITIES_CREATE_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
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
    public void ci_data_create_should_return_error_for_input_as_empty_string() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(ENTITIES_CREATE_URL, "");
    }

    @Test
    public void ci_data_create_should_return_error_for_input_as_empty_json_object() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(ENTITIES_CREATE_URL, "{}");
    }

    @Test
    public void ci_data_create_should_return_error_for_input_with_missing_entity_name() throws Exception {
        assertErrorOutputForInvalidRequestInput(ENTITIES_CREATE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1"
        ));
    }

    @Test
    public void ci_data_create_should_return_error_for_input_with_invalid_entity_name() throws Exception {
        assertErrorOutputForInvalidRequestInput(ENTITIES_CREATE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", "invalidEntityName",
                "ciData", ImmutableMap.of("code", "code")
        ));
    }

    @Transactional
    @Test
    public void ci_data_create_should_return_error_for_input_with_missing_data_entries() throws Exception {
        String ciTypeName = generateCiTypeName();
        givenAppliedCiType(ciTypeName);

        assertErrorOutputForInvalidRequestInput(ENTITIES_CREATE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", ciTypeName
        ));
    }
}
