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

import org.easetech.easytest.annotation.DataLoader;
import org.easetech.easytest.annotation.Param;
import org.easetech.easytest.loader.LoaderType;
import org.easetech.easytest.runner.SpringTestRunner;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.util.JsonUtil;

@Ignore
@RunWith(SpringTestRunner.class)
@DataLoader(filePaths = { "/TestData.csv" }, loaderType = LoaderType.CSV, writeData = false)
public class StateMachineTest extends LegacyAbstractBaseControllerTest {

    ArrayList<String> newOperationList = Lists.newArrayList("discard", "confirm", "startup", "stop");

    @Test
    public void testMethod(@Param(name = "ciTypeId") int ciTypeId, @Param(name = "guid") String guid, @Param(name = "operation") String operation, @Param(name = "expectedState") String expectedState,
            @Param(name = "expectedFixDateHasValue") boolean expectedFixDateHasValue) throws Exception {
        if (ciTypeId == 0 || guid.equals("") || operation.equals("") || expectedState.equals("")) {
            throw new Exception("Invalid test data");
        }

        runStateTransition(ciTypeId, guid, operation);
        queryCiDataShouldBeSuccessful(ciTypeId, guid, expectedState, expectedFixDateHasValue);
    }

    private void runStateTransition(int ciTypeId, String guid, String operation) throws Exception {
        if (newOperationList.contains(operation)) {
            String url = formatUrlPathVariables("/api/v2/ci/%d/%s/state/operate", ciTypeId, guid) + "?operation=" + operation;
            System.out.println("url= " + url);
            mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON)
                    .content("{}"))
                    .andExpect(jsonPath("$.statusCode", is("OK")));
        } else if (operation.equals("delete")) {
            deleteCiData(ciTypeId, guid);
        } else if (operation.equals("update")) {
            updateCiData(ciTypeId, guid);
        } else if (operation.equals("insert")) {
            insertCiData(ciTypeId);
        }
    }

    private void deleteCiData(int ciTypeId, String guid) throws Exception {
        String reqJson = JsonUtil.toJson(Arrays.asList(guid));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private void updateCiData(int ciTypeId, String guid) throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("guid", guid)
                .put("description", "update desc")
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        MvcResult updateResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
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
        }
    }

    private void insertCiData(int ciTypeId) throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "insert desc")
                .put("name", String.valueOf(System.currentTimeMillis()))
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));
    }

    private void queryCiDataShouldBeSuccessful(int ciTypeId, String guid, String expectedState, boolean fixedDataHasValue) throws Exception {
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("guid", guid)
                .withPaging(false);
        String reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)))
                .andExpect(jsonPath("$.data.contents[0].state.code", is(expectedState)))
                .andExpect(jsonPath("$.data.contents[0].fixed_date", fixedDataHasValue ? notNullValue() : nullValue()));
    }

    private String formatUrlPathVariables(String path, Object... pathVariables) {
        if (pathVariables != null && pathVariables.length > 0) {
            path = String.format(path, pathVariables);
        }
        return path;
    }

}