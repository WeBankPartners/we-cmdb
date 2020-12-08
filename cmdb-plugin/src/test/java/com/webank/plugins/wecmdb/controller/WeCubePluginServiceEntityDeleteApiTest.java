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

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;


public class WeCubePluginServiceEntityDeleteApiTest extends AbstractBaseWeCubePluginServiceApiTest {
    private static final String ENTITIES_DELETE_URL = "/entities/delete";


    @Test
    public void ci_data_delete_should_return_success_for_empty_inputs_list() throws Exception {
        assertReturnSuccessForEmptyInputList(ENTITIES_DELETE_URL);
    }

    @Transactional
    @Test
    public void ci_data_delete_should_succeed_and_delete_specified_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guidToDelete = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("entityName", ciTypeName)
                .put("guid", guidToDelete)
                .build();
        Map<String, List<Map<String, Object>>> requestMap = ImmutableMap.of("inputs", Collections.singletonList(inputParamMap));
        String requestBodyJson = new ObjectMapper().writeValueAsString(requestMap);

        mvc.perform(post(ENTITIES_DELETE_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs.length()").value(1))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
        ;
        assertThat(getCiDataSafe(ciTypeId, guidToDelete), nullValue());
    }

    @Transactional
    @Test
    public void ci_data_delete_should_fail_and_return_rollbacks_or_errors_for_each_input_in_batch() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guidToDelete = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("entityName", ciTypeName)
                .put("guid", guidToDelete)
                .build();
        Map<String, Object> invalidInput = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "2")
                .build();
        List<Map<String, Object>> inputs = Arrays.asList(inputParamMap, invalidInput);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputs));

        mvc.perform(post(ENTITIES_DELETE_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(ERROR_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(not(SUCCESS_RESULT_MESSAGE)))
                .andExpect(jsonPath("$.results.outputs.length()").value(2))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("rollbacked"))
                .andExpect(jsonPath("$.results.outputs[1].callbackParameter").value("2"))
                .andExpect(jsonPath("$.results.outputs[1].errorCode").value("1"))
                .andExpect(jsonPath("$.results.outputs[1].errorMessage").value(not("ok")))
        ;
        assertThat(getCiDataSafe(ciTypeId, guidToDelete), not(nullValue()));
    }

    @Test
    public void ci_data_delete_should_return_error_for_input_as_empty_string() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(ENTITIES_DELETE_URL, "");
    }

    @Test
    public void ci_data_delete_should_return_error_for_input_as_empty_json_object() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(ENTITIES_DELETE_URL, "{}");
    }

    @Test
    public void ci_data_delete_should_return_error_for_input_with_invalid_entity_name() throws Exception {
        assertErrorOutputForInvalidRequestInput(ENTITIES_DELETE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", "invalidEntityName",
                "guid", "guid"
        ));
    }

    @Transactional
    @Test
    public void ci_data_delete_should_return_error_for_input_with_missing_guid() throws Exception {
        String ciTypeName = generateCiTypeName();
        givenAppliedCiType(ciTypeName);
        assertErrorOutputForInvalidRequestInput(ENTITIES_DELETE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", ciTypeName
        ));
    }
}
