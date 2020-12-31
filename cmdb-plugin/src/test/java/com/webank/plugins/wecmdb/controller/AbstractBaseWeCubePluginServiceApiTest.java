package com.webank.plugins.wecmdb.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import org.springframework.http.MediaType;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


public abstract class AbstractBaseWeCubePluginServiceApiTest extends AbstractBaseControllerTest {
    protected static final String CALLBACK_PARAMETER_KEY = "callbackParameter";
    protected static final String SUCCESS_RESULT_CODE = "0";
    protected static final String ERROR_RESULT_CODE = "1";
    protected static final String SUCCESS_RESULT_MESSAGE = "Success";

    protected void assertReturnSuccessForEmptyInputList(String url) throws Exception {
        String requestBody = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", Collections.emptyList()));
        mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs").isEmpty());
    }

    protected void assertErrorWithEmptyOutputsForInvalidRequestBody(String url, String requestBody) throws Exception {
        mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resultCode").value(ERROR_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(not(SUCCESS_RESULT_MESSAGE)))
                .andExpect(jsonPath("$.results.outputs").isEmpty());
    }

    protected void assertErrorOutputForInvalidRequestInput(String url, Map<String, Object> input) throws Exception {
        String expectedCallbackParameter = String.valueOf(input.get(CALLBACK_PARAMETER_KEY));
        List<Map<String, Object>> inputs = Collections.singletonList(input);
        String requestBody = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputs));
        mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resultCode").value(ERROR_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(not(SUCCESS_RESULT_MESSAGE)))
                .andExpect(jsonPath("$.results.outputs.length()").value(1))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value(expectedCallbackParameter))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value(not("ok")));
    }
}
