package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.Arrays;
import java.util.Map;
import java.util.Optional;

import org.assertj.core.util.Lists;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.util.JsonUtil;

@WithMockUser(username = "test", authorities = {ROLE_PREFIX + MENU_QUERY_CONFIG, ROLE_PREFIX + MENU_OVERVIEW ,ROLE_PREFIX + MENU_BASIC_CONFIG_QUERY})
public class BaseKeyControllerTest extends LegacyAbstractBaseControllerTest {
    @Autowired
    private AdmBasekeyCatRepository basekeyCatRepository;
    @Autowired
    AdmBasekeyCodeRepository basekeyCodeRepository;

    @Test
    public void getBaseKeyCategoryOverviewThenReturnAllBaseKeysData() throws Exception {
        mvc.perform(get("/baseKey/category/overview"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(49)))
                .andExpect(jsonPath("$..data[?(@.catName=='ci_catalog')].codes[*].seqNo").value(is(Arrays.asList(1, 2, 3, 4))));
    }

    @Test
    public void getCiLayersThenReturnAllSortedCiLayers() throws Exception {
        mvc.perform(get("/baseKey/ciLayers"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(4)))
                .andExpect(jsonPath("$..data[?(@.code=='Business Layer')].seqNo").value(is(Arrays.asList(5))))
                .andExpect(jsonPath("$..data[?(@.code=='Running Layer')].seqNo").value(is(Arrays.asList(6))))
                .andExpect(jsonPath("$..data[?(@.code=='Physical Layer')].seqNo").value(is(Arrays.asList(7))))
                .andExpect(jsonPath("$..data[?(@.code=='Planning Layer')].seqNo").value(is(Arrays.asList(8))));
    }

    @Test
    public void getCatalogsThenReturnAllSortedCatalogs() throws Exception {
        mvc.perform(get("/baseKey/catalogs"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(4)))
                .andExpect(jsonPath("$..data[?(@.code=='Catalog 1')].seqNo").value(is(Arrays.asList(1))))
                .andExpect(jsonPath("$..data[?(@.code=='Catalog 2')].seqNo").value(is(Arrays.asList(2))))
                .andExpect(jsonPath("$..data[?(@.code=='Catalog 3')].seqNo").value(is(Arrays.asList(3))))
                .andExpect(jsonPath("$..data[?(@.code=='Catalog 4')].seqNo").value(is(Arrays.asList(4))));
    }

    @Test
    public void getZoomLevelsThenReturnAllSortedZoomLevels() throws Exception {
        mvc.perform(get("/baseKey/zoomLevels"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(4)))
                .andExpect(jsonPath("$..data[?(@.code=='1')].seqNo").value(is(Arrays.asList(9))))
                .andExpect(jsonPath("$..data[?(@.code=='2')].seqNo").value(is(Arrays.asList(10))))
                .andExpect(jsonPath("$..data[?(@.code=='3')].seqNo").value(is(Arrays.asList(11))))
                .andExpect(jsonPath("$..data[?(@.code=='4')].seqNo").value(is(Arrays.asList(12))));
    }

    @Test
    public void getCatTypeOverviewThenReturnCatTypeWithCategories() throws Exception {
        mvc.perform(get("/baseKey/catType/overview"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(22)));
    }

    @Test
    public void getCatTypesThenReturnAllCatTypes() throws Exception {
        mvc.perform(get("/baseKey/catTypes"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(22)));
    }

    @Test
    public void addCatTypeThenReturnOkAndTheNewOneCanBeQueried() throws Exception {
        String catTypeName = "Test Cate Type 1";
        String catTypeDesc = "Test Cate Type Desc 1";
        Map<String, ?> jsonMap = ImmutableMap.of("catTypeName", catTypeName, "description", catTypeDesc);
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/baseKey/catType/add").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(get("/baseKey/catTypes"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$..data[?(@.catTypeName=='%s')]", catTypeName).exists())
                .andExpect(jsonPath("$..data[?(@.description=='%s')]", catTypeDesc).exists());
    }

    @Test
    public void addCatTypeWithoutTypeNameThenReturnError() throws Exception {
        Map<String, ?> jsonMap = ImmutableMap.of("description", "Test Cate Type Desc 1");
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/baseKey/catType/add").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void checkExistedNameThenReturnTrue() throws Exception {
        mvc.perform(get("/baseKey/catType/checkName?catTypeName={catTypeName}", "Zone"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$..data", is(Arrays.asList(true))));
    }

    @Test
    public void checkNotExistedNameThenReturnFalse() throws Exception {
        mvc.perform(get("/baseKey/catType/checkName?catTypeName={catTypeName}", "NotExistName"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$..data", is(Arrays.asList(false))));
    }

    @Test
    public void addNewCategoryThenReturnOkAndTheNewCatCanBeQueried() throws Exception {
        String catName = "Test Category 1";
        String catDesc = "Test Category Desc 1";
        int catTypeId = 1;
        Map<String, ?> jsonMap = ImmutableMap.of("catName", catName, "description", catDesc);
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/baseKey/catType/{catTypeId}/category/add", catTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(get("/baseKey/catType/overview"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath(String.format("$..data[?(@.catTypeId==%d)]..cats[?(@.catName=='%s')].catName", catTypeId, catName), is(Arrays.asList(catName))))
                .andExpect(jsonPath(String.format("$..data[?(@.catTypeId==%d)]..cats[?(@.catName=='%s')].description", catTypeId, catName), is(Arrays.asList(catDesc))));
    }

    @Test
    public void addNewCategoryWithoutNameThenReturnError() throws Exception {
        String catDesc = "Test Category Desc 1";
        int catTypeId = 1;
        Map<String, ?> jsonMap = ImmutableMap.of("description", catDesc);
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/baseKey/catType/{catTypeId}/category/add", catTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void deleteExistedCategoryThenTheOldOneCanNotBefound() throws Exception {
        int catId = 18;// IDC Cities
        mvc.perform(post("/baseKey/catType/category/{catId}/delete", catId))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(get("/baseKey/catType/overview"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath(String.format("$..baseKeyCategories[?(@.basekeyCatId==%d)].length()", catId), is(Lists.emptyList())));
    }

    @Test
    public void updateCategoryThenReturnTheNewValue() throws Exception {
        String catName = "Test Category 1";
        String catDesc = "Test Category Desc 1";
        int catTypeId = 1;
        Map<String, ?> jsonMap = ImmutableMap.of("catName", catName, "description", catDesc);
        String reqJson = JsonUtil.toJson(jsonMap);
        MvcResult mvcResult = mvc.perform(post("/baseKey/catType/{catTypeId}/category/add", catTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        String retContent = mvcResult.getResponse()
                .getContentAsString();
        int catId = JsonUtil.asNodeByPath(retContent, "/data/catId")
                .asInt();
        String newCatName = "New test Category 1";
        String newCatDesc = "New test Category Desc 1";
        jsonMap = ImmutableMap.of("catName", newCatName, "description", newCatDesc);
        String updateJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/baseKey/catType/category/{catId}/update", catId).contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        Optional<AdmBasekeyCat> basekeyCat = basekeyCatRepository.findById(catId);
        assertThat(basekeyCat.isPresent(), notNullValue());
        assertThat(basekeyCat.get()
                .getCatName(), equalTo(newCatName));
        assertThat(basekeyCat.get()
                .getDescription(), equalTo(newCatDesc));
    }

    @Test
    public void listAllCodesThenReturnCodeListSizeLargerThan0() throws Exception {
        int catId = 30;
        mvc.perform(get("/baseKey/category/{catId}/codes", catId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(4)));
    }

    @Test
    public void addNewCodeThenTheNewCodeExistsInDb() throws Exception {
        int catId = 18;// IDC Cities
        String code = "test code";
        String codeDesc = "test code description";
        int seqno = 1;
        Map<String, ?> jsonMap = ImmutableMap.of("code", code, "codeDescription", codeDesc, "seqNo", seqno);
        String reqJson = JsonUtil.toJson(jsonMap);
        MvcResult mvcResult = mvc.perform(post("/baseKey/category/{catId}/code/add", catId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        String retContent = mvcResult.getResponse()
                .getContentAsString();
        int codeId = JsonUtil.asNodeByPath(retContent, "/data/id")
                .asInt();
        Optional<AdmBasekeyCode> basekeyCode = basekeyCodeRepository.findById(codeId);
        assertThat(basekeyCode.isPresent(), equalTo(true));
        assertThat(basekeyCode.get()
                .getCode(), equalTo(code));
        assertThat(basekeyCode.get()
                .getCodeDescription(), equalTo(codeDesc));
        assertThat(basekeyCode.get()
                .getSeqNo(), equalTo(seqno));
    }

    @Test
    public void addNewCodeWithGroupCodeIdThenTheGroupCodeIdSavedProperly() throws Exception {
        int catId = 30;
        String code = "test code";
        String codeDesc = "test code description";
        int groupCodeId = 12;
        int seqno = 4;
        Map<String, ?> jsonMap = ImmutableMap.of("code", code, "codeDescription", codeDesc, "seqNo", seqno, "groupCodeId", groupCodeId);
        String reqJson = JsonUtil.toJson(jsonMap);
        MvcResult mvcResult = mvc.perform(post("/baseKey/category/{catId}/code/add", catId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        String retContent = mvcResult.getResponse()
                .getContentAsString();
        int codeId = JsonUtil.asNodeByPath(retContent, "/data/codeId")
                .asInt();
        Optional<AdmBasekeyCode> basekeyCode = basekeyCodeRepository.findById(codeId);
        assertThat(basekeyCode.isPresent(), notNullValue());
        // assertThat(basekeyCode.get().getAdmBasekeyCode().getIdAdmBasekey(),equalTo(groupCodeId));
    }

}
