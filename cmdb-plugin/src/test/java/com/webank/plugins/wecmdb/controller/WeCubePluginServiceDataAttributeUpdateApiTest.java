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


public class WeCubePluginServiceDataAttributeUpdateApiTest extends AbstractBaseWeCubePluginServiceApiTest {
    private static final String DATA_ATTRIBUTE_UPDATE_URL = "/data/update";


    @Test
    public void ci_data_attribute_update_should_return_success_for_empty_inputs_list() throws Exception {
        assertReturnSuccessForEmptyInputList(DATA_ATTRIBUTE_UPDATE_URL);
    }

    @Transactional
    @Test
    public void ci_data_attribute_update_should_return_guid_of_updated_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        String attrName = "code";
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of(attrName, "code"));
        String guidToUpdate = String.valueOf(createdCiData.get("guid"));

        String updatedCode = "updatedCode";
        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put("entityName", ciTypeName)
                .put("guid", guidToUpdate)
                .put("attrName", attrName)
                .put("attrVal", updatedCode)
                .build();
        Map<String, List<Map<String, Object>>> requestMap = ImmutableMap.of("inputs", Collections.singletonList(inputParamMap));
        String requestBodyJson = new ObjectMapper().writeValueAsString(requestMap);

        mvc.perform(post(DATA_ATTRIBUTE_UPDATE_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(SUCCESS_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(SUCCESS_RESULT_MESSAGE))
                .andExpect(jsonPath("$.results.outputs").isNotEmpty())
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("ok"))
                .andExpect(jsonPath("$.results.outputs[0].guid").value(guidToUpdate))
        ;
        Map<String, Object> ciDataSafe = getCiDataSafe(ciTypeId, guidToUpdate);
        assertThat(ciDataSafe, notNullValue());
        assertThat(ciDataSafe.get(attrName), equalTo(updatedCode));
    }

    @Transactional
    @Test
    public void ci_data_attribute_update_should_fail_and_return_rollbacks_or_errors_for_each_input_in_batch() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        String attrName = "code";
        String originalCode = "originalCode";
        Map<String, Object> createdCiData1 = givenCiData(ciTypeId, ImmutableMap.of(attrName, originalCode));
        String guidToUpdate = String.valueOf(createdCiData1.get("guid"));
        String updatedCode = "updatedCode";
        Map<String, Object> inputParamMap = ImmutableMap.<String, Object>builder()
                .put("callbackParameter", "1")
                .put("entityName", ciTypeName)
                .put("guid", guidToUpdate)
                .put("attrName", attrName)
                .put("attrVal", updatedCode)
                .build();
        Map<String, Object> invalidInput = ImmutableMap.of("callbackParameter", "2");
        List<Map<String, Object>> inputList = Arrays.asList(inputParamMap, invalidInput);
        String requestBodyJson = new ObjectMapper().writeValueAsString(ImmutableMap.of("inputs", inputList));

        mvc.perform(post(DATA_ATTRIBUTE_UPDATE_URL).contentType(MediaType.APPLICATION_JSON).content(requestBodyJson))
                .andExpect(jsonPath("$.resultCode").value(ERROR_RESULT_CODE))
                .andExpect(jsonPath("$.resultMessage").value(not(SUCCESS_RESULT_MESSAGE)))
                .andExpect(jsonPath("$.results.outputs.length()").value(2))
                .andExpect(jsonPath("$.results.outputs[0].callbackParameter").value("1"))
                .andExpect(jsonPath("$.results.outputs[0].errorCode").value("0"))
                .andExpect(jsonPath("$.results.outputs[0].errorMessage").value("rollbacked"))
                .andExpect(jsonPath("$.results.outputs[0].guid").doesNotExist())
                .andExpect(jsonPath("$.results.outputs[1].callbackParameter").value("2"))
                .andExpect(jsonPath("$.results.outputs[1].errorCode").value("1"))
                .andExpect(jsonPath("$.results.outputs[1].errorMessage").value(not("ok")))
                .andExpect(jsonPath("$.results.outputs[1].guid").doesNotExist())
        ;
        Map<String, Object> ciData1 = getCiDataSafe(ciTypeId, guidToUpdate);
        assertThat(ciData1, notNullValue());
        assertThat(ciData1.get(attrName), equalTo(originalCode));
    }

    @Test
    public void ci_data_attribute_update_should_return_error_for_input_as_empty_string() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(DATA_ATTRIBUTE_UPDATE_URL, "");
    }

    @Test
    public void ci_data_attribute_update_should_return_error_for_input_as_empty_json_object() throws Exception {
        assertErrorWithEmptyOutputsForInvalidRequestBody(DATA_ATTRIBUTE_UPDATE_URL, "{}");
    }

    @Test
    public void ci_data_attribute_update_should_return_error_for_input_with_invalid_entity_name() throws Exception {
        assertErrorOutputForInvalidRequestInput(DATA_ATTRIBUTE_UPDATE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", "invalidEntityName"
        ));
    }

    @Transactional
    @Test
    public void ci_data_attribute_update_should_return_error_for_input_with_missing_guid() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        givenCiData(ciTypeId, ImmutableMap.of("code", "code"));

        assertErrorOutputForInvalidRequestInput(DATA_ATTRIBUTE_UPDATE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", ciTypeName,
                "attrName", "code",
                "attrVal", "code"
        ));
    }

    @Transactional
    @Test
    public void ci_data_attribute_update_should_return_error_for_input_with_missing_attr_name() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guid = String.valueOf(createdCiData.get("guid"));

        assertErrorOutputForInvalidRequestInput(DATA_ATTRIBUTE_UPDATE_URL, ImmutableMap.of(
                CALLBACK_PARAMETER_KEY, "1",
                "entityName", ciTypeName,
                "guid", guid,
                "attrVal", "updatedCode"
        ));
    }
}
