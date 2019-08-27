package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.util.JsonUtil;

@WithMockUser(username = "test", authorities = { ROLE_PREFIX + MENU_QUERY_CONFIG })
public class CiControllerTest extends LegacyAbstractBaseControllerTest {

    @Test
    public void listAllCiForSystemWithoutArgument() throws Exception {
        int ciTypeId = 2;
        mvc.perform(post("/ciType/{ciTypeId}/cis", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(2)));
    }

    @Test
    public void listAllCiWithFilterThenReturn1Ci() throws Exception {
        int ciTypeId = 2;
        Filter containsFilter = new Filter();
        containsFilter.setName("description");
        containsFilter.setOperator("contains");
        containsFilter.setValue("Bank");
        List<Filter> filters = new ArrayList<Filter>();
        filters.add(containsFilter);
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("isPaging", false)
                .put("filters", filters)
                .build();
        String reqJson = JsonUtil.toJson(jsonMap);

        mvc.perform(post("/ciType/{ciTypeId}/cis", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));

    }

    @Test
    public void addCiDataThenReturnNewGuid() throws Exception {
        int ciTypeId = 2;
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_en", "english name")
                .put("system_type", 554)
                .build();
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/ciType/{ciTypeId}/ci/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.id", notNullValue()));

    }

    @Test
    public void addCiDataWithoutEnNameThenGetInvalidArgumentError() throws Exception {
        int ciTypeId = 2;
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "test desc")
                .put("name_cn", "chinese name")
                .put("system_type", 1)
                .build();
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/ciType/{ciTypeId}/ci/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));

    }

}
