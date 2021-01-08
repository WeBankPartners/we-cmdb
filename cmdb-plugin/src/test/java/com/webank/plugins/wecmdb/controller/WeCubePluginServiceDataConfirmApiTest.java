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
import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;


public class WeCubePluginServiceDataConfirmApiTest extends AbstractBaseWeCubePluginServiceApiTest {
    private static final String DATA_CONFIRM_URL = "/data/confirm";


    @Test
    public void ci_data_confirm_should_return_success_for_empty_inputs_list() throws Exception {
        assertReturnSuccessForEmptyInputList(DATA_CONFIRM_URL);
    }

    @Transactional
    @Test
    public void ci_data_confirm_should_succeed_and_return_confirmed_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guidToConfirm = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put(CALLBACK_PARAMETER_KEY, "1")
                .put("guid", guidToConfirm)
                .build();
        Map<String, List<Map<String, Object>>> requestMap = ImmutableMap.of("inputs", Collections.singletonList(inputParamMap));
        String requestBodyJson = new ObjectMapper().writeValueAsString(requestMap);

        mvc.perform(post(DATA_CONFIRM_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].guid").value(guidToConfirm))
                .andExpect(jsonPath("$.results.outputs[0].fixed_date").isNotEmpty())
        ;
    }

    @Transactional
    @Test
    public void ci_data_confirm_should_ALWAYS_SUCCEED_even_empty_guid_exists_in_batch() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guidToConfirm = String.valueOf(createdCiData.get("guid"));

        List<Map<String, Object>> inputList = Arrays.asList(
                ImmutableMap.of(CALLBACK_PARAMETER_KEY, "1", "guid", guidToConfirm),
                ImmutableMap.of(CALLBACK_PARAMETER_KEY, "2"),
                ImmutableMap.of(CALLBACK_PARAMETER_KEY, "3", "guid", "")
        );
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputList));

        mvc.perform(post(DATA_CONFIRM_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs.length()").value(3))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].fixed_date").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[1].callbackParameter").value("2"))
                .andExpect(jsonPath("$.results.outputs[1].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[1].errorMessage").value(not("ok")))
                .andExpect(jsonPath("$.results.outputs[1].fixed_date").doesNotExist())
                .andExpect(jsonPath("$.results.outputs[2].callbackParameter").value("3"))
                .andExpect(jsonPath("$.results.outputs[2].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[2].errorMessage").value(not("ok")))
                .andExpect(jsonPath("$.results.outputs[2].fixed_date").doesNotExist())
        ;
    }

    @Test
    public void ci_data_confirm_should_return_error_for_input_as_empty_string() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(DATA_CONFIRM_URL, "");
    }

    @Test
    public void ci_data_confirm_should_return_error_for_input_as_empty_json_object() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(DATA_CONFIRM_URL, "{}");
    }
}
