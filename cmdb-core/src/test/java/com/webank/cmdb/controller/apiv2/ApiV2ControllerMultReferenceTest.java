package com.webank.cmdb.controller.apiv2;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import org.apache.commons.collections.MapUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.webank.cmdb.constant.StateOperation;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.controller.QueryRequestUtils;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.util.JsonUtil;

public class ApiV2ControllerMultReferenceTest extends AbstractBaseControllerTest {

    @Autowired
    private EntityManager entityManager;
    @Autowired
    private AdmCiTypeAttrRepository attrRepository;

    @Transactional
    @Test
    public void applyMultRefCiTypeThenCreateJoinTableSucessfully() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        AdmCiTypeAttr multSelAttr = attrRepository.getOne(812);
        String joinTable = multSelAttr.retrieveJoinTalbeName();
        BigInteger result = (BigInteger) entityManager.createNativeQuery("select count(1) from " + joinTable)
                .getSingleResult();
        assertThat(result.intValue(), equalTo(0));
    }

    @Test
    public void createCiDataForMultSelectionCiTypeThenReturnSucessfully() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "multi selection ci data")
                .put("mul_select", Lists.newArrayList(47, 48))
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        int ciTypeId = 50;
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));

        QueryRequestUtils queryObject = new QueryRequestUtils();
        queryObject.withPagable(0, 10);
        reqJson = JsonUtil.toJsonString(queryObject);

        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size(), equalTo(1));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/mul_select")
                .size(), equalTo(2));

    }

    @Test
    public void createAndUpdateCiDataForMultSelectionCiTypeThenReturnSucessfully() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "multi selection ci data")
                .put("mul_select", Lists.newArrayList(47, 48))
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        int ciTypeId = 50;
        // creation
        mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()));

        QueryRequestUtils queryObject = new QueryRequestUtils();
        queryObject.withPagable(0, 10);
        reqJson = JsonUtil.toJsonString(queryObject);

        // query
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size(), equalTo(1));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/mul_select")
                .size(), equalTo(2));
        String guidA = JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/guid")
                .asText();

        // update
        jsonMap = Maps.newHashMap();
        MapUtils.putAll(jsonMap, new Object[] { "guid", guidA, "mul_select", Lists.newArrayList(47) });

        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));

        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/mul_select")
                .size(), equalTo(1));
    }

    @Test
    public void createAndUpdateCiDataForMultReferenceCiTypeThenReturnSucessfully() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        String reqJson;
        int ciTypeId;
        MvcResult mvcResult;
        List<String> ciBs = createCIDataB();
        String guidB1 = ciBs.get(0);
        String guidB2 = ciBs.get(1);

        // create Ci A which refer to guidB
        ciTypeId = 50;
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "multi reference A ci data")
                .put("mul_reference", Lists.newArrayList(guidB1, guidB2))
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        String guidA = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();

        // retrieve ci data for guid A
        queryMultiReferenceAndVerify(ciTypeId, "mul_reference", 2);

        // update
        jsonMap = Maps.newHashMap();
        MapUtils.putAll(jsonMap, new Object[] { "guid", guidA, "mul_reference", Lists.newArrayList(guidB1) });

        String updateJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        queryMultiReferenceAndVerify(ciTypeId, "mul_reference", 1);

    }

    private List<String> createCIDataB() throws Exception, UnsupportedEncodingException {
        // create CI B 1
        Map<?, ?> jsonMapB1 = ImmutableMap.builder()
                .put("description", "multi reference B ci data 1")
                .build();
        Map<?, ?> jsonMapB2 = ImmutableMap.builder()
                .put("description", "multi reference B ci data 2")
                .build();

        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMapB1, jsonMapB2));
        int ciTypeId = 51;
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();

        String guidB1 = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();
        String guidB2 = JsonUtil.asNodeByPath(retContent, "/data/1/guid")
                .asText();
        assertThat(guidB1, notNullValue());
        assertThat(guidB2, notNullValue());
        return Lists.newArrayList(guidB1, guidB2);
    }

    private void queryMultiReferenceAndVerify(int ciTypeId, String refField, int expectReferenceCount) throws Exception, UnsupportedEncodingException, IOException {
        MvcResult mvcResult;
        String retContent;
        mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        retContent = mvcResult.getResponse()
                .getContentAsString();
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents")
                .size(), equalTo(1));
        assertThat(JsonUtil.asNodeByPath(retContent, "/data/contents/0/data/" + refField)
                .size(), equalTo(expectReferenceCount));
    }

    @Test
    public void updateCiAfterConfirmThenMultSelectionFieldWillNotContainDuplicatedValue() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "multi selection ci data")
                .put("mul_select", Lists.newArrayList(47))
                .build();
        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        int ciTypeId = 50;
        // creation
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();

        String retContent = mvcResult.getResponse()
                .getContentAsString();
        String guidA = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();
        queryMultiReferenceAndVerify(ciTypeId, "mul_select", 1);

        operateState(ciTypeId, guidA, StateOperation.Confirm);

        jsonMap = ImmutableMap.builder()
                .put("description", "multi selection ci data")
                .put("mul_select", Lists.newArrayList(47, 48))
                .put("guid", guidA)
                .build();

        mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(ImmutableList.of(jsonMap))))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].mul_select", hasSize(equalTo(2))))
                .andReturn();

        queryMultiReferenceAndVerify(ciTypeId, "mul_select", 2);

    }

    @Test
    public void operateDiscardThenThePreviousMultiSelectValueShouldBeReverted() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        List<String> ciBs = createCIDataB();
        String guidB1 = ciBs.get(0);
        String guidB2 = ciBs.get(1);

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "multi selection ci data")
                .put("mul_select", Lists.newArrayList(47))
                .put("mul_reference", Lists.newArrayList(guidB1))
                .build();

        String reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        int ciTypeId = 50;
        // creation
        MvcResult mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();

        String retContent = mvcResult.getResponse()
                .getContentAsString();
        String guidA = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();

        operateState(ciTypeId, guidA, StateOperation.Confirm);

        jsonMap = ImmutableMap.builder()
                .put("description", "multi selection ci data")
                .put("mul_select", Lists.newArrayList(48))
                .put("mul_reference", Lists.newArrayList(guidB1, guidB2))
                .put("guid", guidA)
                .build();

        mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(ImmutableList.of(jsonMap))))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].mul_select", hasSize(equalTo(1))))
                .andExpect(jsonPath("$.data[0].mul_reference", hasSize(equalTo(2))))
                .andReturn();

        queryMultiReferenceAndVerify(ciTypeId, "mul_select", 1);
        queryMultiReferenceAndVerify(ciTypeId, "mul_reference", 2);

        operateState(ciTypeId, guidA, StateOperation.Discard);

        queryMultiReferenceAndVerify(ciTypeId, "mul_select", 1);
        queryMultiReferenceAndVerify(ciTypeId, "mul_reference", 1);
    }

    @Test
    public void deleteCiShouldNotDeleteItReferenceCis() throws Exception {
        mvc.perform(post("/api/v2/ciTypes/apply").contentType(MediaType.APPLICATION_JSON)
                .content("[51,50]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        String reqJson;
        int ciTypeIdA = 50;
        int ciTypeIdB = 51;
        MvcResult mvcResult;
        List<String> ciBs = createCIDataB();
        String guidB1 = ciBs.get(0);
        String guidB2 = ciBs.get(1);

        // create Ci A which refer to guidB
        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("description", "multi reference A ci data")
                .put("mul_reference", Lists.newArrayList(guidB1, guidB2))
                .build();
        reqJson = JsonUtil.toJson(ImmutableList.of(jsonMap));
        mvcResult = mvc.perform(post("/api/v2/ci/{ciTypeId}/create", ciTypeIdA).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].guid", notNullValue()))
                .andReturn();
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        String guidA = JsonUtil.asNodeByPath(retContent, "/data/0/guid")
                .asText();

        // retrieve ci data for guid A
        queryMultiReferenceAndVerify(ciTypeIdA, "mul_reference", 2);

        // delete
        String deleteJson = JsonUtil.toJson(ImmutableList.of(guidA));
        mvc.perform(post("/api/v2/ci/{ciTypeId}/delete", ciTypeIdA).contentType(MediaType.APPLICATION_JSON)
                .content(deleteJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/ci/{ciTypeId}/retrieve", ciTypeIdB).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents", hasSize(2)));
    }

    private void operateState(int ciTypeId, String guid, StateOperation operation) throws Exception {
        String url = "/api/v2/ci/state/operate?operation=" + operation.getCode();
        mvc.perform(post(url).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(Lists.newArrayList(new CiIndentity(ciTypeId, guid)))))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

}
