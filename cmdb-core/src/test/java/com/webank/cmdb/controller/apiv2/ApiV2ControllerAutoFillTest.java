package com.webank.cmdb.controller.apiv2;

import static com.webank.cmdb.controller.QueryRequestUtils.defaultQueryObject;
import static com.webank.cmdb.util.SpecialSymbolUtils.getAfterSpecialSymbol;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerAutoFillTest extends AbstractBaseControllerTest {
    private static final int ciTypeIdOfSubsysDesign = 2;
    private static final int ciTypeIdOfSystemDesign = 1;

    @Test
    public void whenAutoFillWithoutFilterShouldSuccess() throws Exception {
        Integer keyNameAttrIdOfSystemDesign = 8;
        updateCiAttrWithAutoFillRule(keyNameAttrIdOfSystemDesign, readJsonFromFile("json/autofillrule/rule_without_filter.json"));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "Desc of System design A")
                .put("code", "system_design_a")
                .put("name", "System design A")
                .put("business_group", 43)
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult result = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSystemDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid").asText();

        jsonMap = ImmutableMap.builder()
                .put("description", "Desc of Subsys design A1")
                .put("code", "subsys_design_a1")
                .put("name", "Subsys design A1")
                .put("system_design", guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSubsysDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        
        jsonMap = ImmutableMap.builder()
                .put("description", "Desc of Subsys design A2")
                .put("code", "subsys_design_a2")
                .put("name", "Subsys design A2")
                .put("system_design", guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSubsysDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        String separator = getAfterSpecialSymbol(",");
        String expectedKeyNameOfSystemDesign = "subsys_design_a1,subsys_design_a2".replace(",", separator);
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyNameOfSystemDesign)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeIdOfSystemDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }
    
    @Test
    public void whenAutoFillWithOneFilterAt2ndNodeShouldSuccess() throws Exception {
        Integer keyNameAttrIdOfSystemDesign = 8;
        updateCiAttrWithAutoFillRule(keyNameAttrIdOfSystemDesign, readJsonFromFile("json/autofillrule/rule_with_filter_at_2nd_node.json"));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "Desc of System design A")
                .put("code", "system_design_a")
                .put("name", "System design A")
                .put("business_group", 43)
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult result = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSystemDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid").asText();

        jsonMap = ImmutableMap.builder()
                .put("description", "Desc of Subsys design A1")
                .put("code", "subsys_design_a1")
                .put("name", "Subsys design A1")
                .put("system_design", guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSubsysDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        
        jsonMap = ImmutableMap.builder()
                .put("description", "Desc of Subsys design A2")
                .put("code", "subsys_design_a2")
                .put("name", "Subsys design A2")
                .put("system_design", guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSubsysDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        String expectedKeyNameOfSystemDesign = "subsys_design_a1";
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyNameOfSystemDesign)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeIdOfSystemDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }
    
    @Test
    public void whenAutoFillWithOneFilterSameAsTargetValueShouldSuccess() throws Exception {
        Integer keyNameAttrIdOfSystemDesign = 8;
        updateCiAttrWithAutoFillRule(keyNameAttrIdOfSystemDesign, readJsonFromFile("json/autofillrule/rule_with_filter_same_as_target_value.json"));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "Desc of System design A")
                .put("code", "system_design_a")
                .put("name", "System design A")
                .put("business_group", 43)
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        MvcResult result = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSystemDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = result.getResponse()
                .getContentAsString();
        String guid = JsonUtil.asNodeByPath(retContent, "/data/0/guid").asText();

        jsonMap = ImmutableMap.builder()
                .put("description", "Desc of Subsys design A1")
                .put("code", "subsys_design_a1")
                .put("name", "Subsys design A1")
                .put("system_design", guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSubsysDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        
        jsonMap = ImmutableMap.builder()
                .put("description", "Desc of Subsys design A2")
                .put("code", "subsys_design_a2")
                .put("name", "Subsys design A2")
                .put("system_design", guid)
                .put("dcn_design_type", 63)
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdOfSubsysDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        String expectedKeyNameOfSystemDesign = "subsys_design_a1";
        QueryRequestUtils queryObject = defaultQueryObject();
        queryObject.addEqualsFilter("key_name", expectedKeyNameOfSystemDesign)
                .withPaging(false);
        reqJson = JsonUtil.toJsonString(queryObject);
        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeIdOfSystemDesign).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(1)));
    }

    private void updateCiAttrWithAutoFillRule(Integer attrId, String autoFillRule) throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("ciTypeAttrId", attrId)
                        .put("isAuto", true)
                        .put("autoFillRule", autoFillRule)
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }
}
