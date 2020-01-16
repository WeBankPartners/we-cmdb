package com.webank.cmdb.controller.apiv2;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.springframework.http.MediaType;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryRequest.Dialect;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerFilterRuleTest extends AbstractBaseControllerTest {

    @Test
    public void whenRuleReferToEnumGroupFromOtherCodesThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 362;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_group_from_other_codes.json"));

        QueryRequest request = new QueryRequest();
        Map<String, Object> ciData = new HashMap<String, Object>();
        ciData.put("dcn", "0019_0000000001");
        Dialect dialect = new Dialect();
        dialect.setData(ciData);
        request.setDialect(dialect);
        String jsonReq = JsonUtil.toJsonString(request);

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content(jsonReq))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].code", is("PRD")));
    }

    @Test
    public void whenRuleReferToEnumAndRelationShipCrossAttrThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 271;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_and_relationship_cross_attr.json"));

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].code", is("4")));
    }

    @Test
    public void whenRuleReferToEnumFromOtherCiThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 439;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_from_other_ci.json"));

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].code", is("deposit_group")));
    }

    @Test
    public void whenRuleReferToEnumHardcodeIdByGroupCodeIdThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 439;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_hardcode_by_group_code_id.json"));

        QueryRequest request = new QueryRequest();
        request.setFilters(Lists.newArrayList(new Filter("code", "eq", "STGi")));
        String jsonReq = JsonUtil.toJsonString(request);

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content(jsonReq))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(equalTo(1))));
    }

    @Test
    public void whenRuleReferToEnumHardcodeIdThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 110;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_hardcode_ids.json"));

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].code", is("PRD")));
    }

    @Test
    public void whenRuleReferToEnumHardcodeCodesThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 439;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_hardcode_codes.json"));

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].code", is("deposit_group")));
    }

    @Test
    public void whenRuleReferToEnumOrRelationshipThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 439;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_enum_or_relationship.json"));

        mvc.perform(post("/api/v2/enum/codes/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(equalTo(3))));
    }

    @Test
    public void whenRuleReferToRefHardcodeDatasThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 265;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_ref_hardcode_datas.json"));

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].key_name", is("MGMT_APP_01-10.0.16.200")));
    }

    @Test
    public void whenRuleReferToMixEnumAndRefThenShouldSuccess() throws Exception {
        int referenceAttrId = 264;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_mix_enum_and_ci_datas.json"));

        QueryRequest request = new QueryRequest();
        Map<String, Object> ciData = new HashMap<String, Object>();
        ciData.put("state", "");
        ciData.put("unit", "");
        Dialect dialect = new Dialect();
        dialect.setData(ciData);
        request.setDialect(dialect);
        String jsonReq = JsonUtil.toJsonString(request);

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content(jsonReq))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    @Test
    public void whenRuleReferToRefValuesThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 265;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_ref_ci_datas.json"));

        QueryRequest request = new QueryRequest();
        Map<String, Object> ciData = new HashMap<String, Object>();
        ciData.put("unit", "0008_0000000001");
        Dialect dialect = new Dialect();
        dialect.setData(ciData);
        request.setDialect(dialect);
        request.setFilters(Lists.newArrayList(new Filter("key_name", "eq", "MGMT_APP_01-10.0.16.200")));

        String jsonReq = JsonUtil.toJsonString(request);

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content(jsonReq))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(equalTo(1))))
                .andExpect(jsonPath("$.data.contents[0].key_name", is("MGMT_APP_01-10.0.16.200")));
    }

    @Test
    public void whenRequiredValueIsMissingThenShouldReturnNull() throws Exception {
        int referenceAttrId = 265;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_ref_ci_datas.json"));

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void whenRuleReferToRefAndRelationshipThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 265;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_ref_and_relationship.json"));

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[0].key_name", is("MGMT_APP_01-10.0.16.200")));
    }

    @Test
    public void whenRuleReferToRefOrRelationshipThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 265;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_ref_or_relationship.json"));

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(equalTo(2))))
                .andExpect(jsonPath("$.data.contents[0].key_name", is("MGMT_APP_01-10.0.16.200")))
                .andExpect(jsonPath("$.data.contents[1].key_name", is("MGMT_APP_02-10.0.16.239")));
    }

    @Test
    public void whenRuleReferToRefEnumHardcodeValuesThenShouldReturnExpectResults() throws Exception {
        int referenceAttrId = 265;
        setUpFilterRule(referenceAttrId, readJsonFromFile("json/filterrule/refer_to_ref_enum_values.json"));

        mvc.perform(post("/api/v2/ci/referenceDatas/{reference-attr-id}/query", referenceAttrId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(equalTo(4))))
                .andExpect(jsonPath("$.data.contents[0].key_name", is("MGMT_APP_01-10.0.16.200")))
                .andExpect(jsonPath("$.data.contents[1].key_name", is("MGMT_APP_02-10.0.16.239")));
    }

    private void setUpFilterRule(int referenceAttrId, String referenceFilterRule) throws Exception {
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("ciTypeAttrId", referenceAttrId)
                .put("filterRule", referenceFilterRule)
                .build();
        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        mvc.perform(post("/api/v2/ciTypeAttrs/update").contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(equalTo(1))))
                .andExpect(jsonPath("$.data[0].status", is("created")))
                .andExpect(jsonPath("$.data[0].filterRule", is(referenceFilterRule)));
    }

}
