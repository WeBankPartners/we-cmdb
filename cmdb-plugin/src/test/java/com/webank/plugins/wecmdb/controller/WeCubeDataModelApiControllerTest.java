package com.webank.plugins.wecmdb.controller;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import org.codehaus.jackson.map.ObjectMapper;
import org.junit.Test;
import org.springframework.http.MediaType;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.Map;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class WeCubeDataModelApiControllerTest extends AbstractBaseControllerTest {
    private static final String SUCCESS_STATUS = "OK";
    private static final String SUCCESS_MESSAGE = "Success";

    @Test
    public void ci_data_model_should_return_ci_entities() throws Exception {
        mvc.perform(get("/data-model"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(SUCCESS_STATUS))
                .andExpect(jsonPath("$.message").value(SUCCESS_MESSAGE))
                .andExpect(jsonPath("$.data").isNotEmpty());
    }

    @Transactional
    @Test
    public void ci_data_query_should_succeed_and_return_matched_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        String expectedCode = "code";
        Map<String, Object> createdDataMap = givenCiData(ciTypeId, ImmutableMap.of("code", expectedCode));
        String guidToQuery = String.valueOf(createdDataMap.get("guid"));

        Map<String, Object> criteriaMap = ImmutableMap.of("attrName", "guid", "condition", guidToQuery);
        Map<String, Object> querySpecMap = ImmutableMap.of("criteria", criteriaMap);
        String requestBody = new ObjectMapper().writeValueAsString(querySpecMap);
        mvc.perform(post("/entities/{entity-name}/query", ciTypeName)
                .contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(SUCCESS_STATUS))
                .andExpect(jsonPath("$.message").value(SUCCESS_MESSAGE))
                .andExpect(jsonPath("$.data.length()").value(1))
                .andExpect(jsonPath("$.data[0].id").value(guidToQuery))
                .andExpect(jsonPath("$.data[0].guid").value(guidToQuery))
                .andExpect(jsonPath("$.data[0].code").value(expectedCode));
    }

    @Transactional
    @Test
    public void ci_data_update_should_succeed_and_return_updated_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdDataMap = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guidToUpdate = String.valueOf(createdDataMap.get("guid"));

        String expectedCode = "expectedCode";
        Map<String, Object> ciDataMap = ImmutableMap.of("id", guidToUpdate, "code", expectedCode);
        String requestBody = new ObjectMapper().writeValueAsString(Collections.singletonList(ciDataMap));
        mvc.perform(post("/entities/{entity-name}/update", ciTypeName)
                .contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(SUCCESS_STATUS))
                .andExpect(jsonPath("$.message").value(SUCCESS_MESSAGE))
                .andExpect(jsonPath("$.data").isNotEmpty())
                .andExpect(jsonPath("$.data[0].id").value(guidToUpdate))
                .andExpect(jsonPath("$.data[0].guid").value(guidToUpdate))
                .andExpect(jsonPath("$.data[0].code").value(expectedCode));
    }

    @Transactional
    @Test
    public void ci_data_create_should_succeed_and_return_created_ci_data() throws Exception {
        String ciTypeName = generateCiTypeName();
        givenAppliedCiType(ciTypeName);

        String expectedCode = "expectedCode";
        Map<String, Object> ciDataMap = ImmutableMap.of("code", expectedCode);
        String requestBody = new ObjectMapper().writeValueAsString(Collections.singletonList(ciDataMap));
        mvc.perform(post("/entities/{entity-name}/create", ciTypeName)
                .contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(SUCCESS_STATUS))
                .andExpect(jsonPath("$.message").value(SUCCESS_MESSAGE))
                .andExpect(jsonPath("$.data").isNotEmpty())
                .andExpect(jsonPath("$.data[0].id").isNotEmpty())
                .andExpect(jsonPath("$.data[0].guid").isNotEmpty())
                .andExpect(jsonPath("$.data[0].code").value(expectedCode));
    }

    @Transactional
    @Test
    public void ci_data_delete_should_succeed() throws Exception {
        String ciTypeName = generateCiTypeName();
        int ciTypeId = givenAppliedCiType(ciTypeName);
        Map<String, Object> createdCiData = givenCiData(ciTypeId, ImmutableMap.of("code", "code"));
        String guid = String.valueOf(createdCiData.get("guid"));

        Map<String, Object> ciDataMap = ImmutableMap.of("id", guid);
        String requestBody = new ObjectMapper().writeValueAsString(Collections.singletonList(ciDataMap));
        mvc.perform(post("/entities/{entity-name}/delete", ciTypeName)
                .contentType(MediaType.APPLICATION_JSON).content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value(SUCCESS_STATUS))
                .andExpect(jsonPath("$.message").value(SUCCESS_MESSAGE));
    }
}
