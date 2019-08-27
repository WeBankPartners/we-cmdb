package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.ResponseDto;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.JsonUtil;

@WithMockUser(username = "test", authorities = {
        ROLE_PREFIX + MENU_QUERY_CONFIG,
        ROLE_PREFIX + MENU_OVERVIEW ,
        ROLE_PREFIX + MENU_COMMON_INTERFACE_CONFIG ,
        ROLE_PREFIX + MENU_COMMON_INTERFACE_RUNNER ,
        ROLE_PREFIX + MENU_BASIC_CONFIG_QUERY})
public class CiTypeControllerTest extends LegacyAbstractBaseControllerTest {
    @Test
    public void listAllCiTypesThenReturnListSizeLargeThen0() throws Exception {
        mvc.perform(get("/ciTypes"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(26)));
    }

    @Test
    public void listAllCatalogWithCiTypesThenReturnSortedCatalog() throws Exception {
        mvc.perform(get("/catalog/ciTypes"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].code", is("Catalog 1")))
                .andExpect(jsonPath("$.data[0].seqNo", is(1)))
                .andExpect(jsonPath("$.data[1].seqNo", is(2)))
                .andExpect(jsonPath("$.data[2].seqNo", is(3)))
                .andExpect(jsonPath("$.data[3].seqNo", is(4)));
    }

    @Test
    public void getCiTypeAndAttrThenReturnCiTypeWithAttr() throws Exception {
        mvc.perform(get("/ciType/ciTypeAndAttr/2"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.ciTypeId", is(2)))
                .andExpect(jsonPath("$.data.attributes", hasSize(14)));
    }

    @Test
    public void addNewCiTypeWhenTalbeIsNotExistedThenReturnStatusOk() throws Exception {
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(false);

        CiTypeDto ciTypeDto = getNewCiTypeDto();

        mvc.perform(post("/ciType/add").contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(ciTypeDto)))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private CiTypeDto getNewCiTypeDto() {
        CiTypeDto ciTypeDto = new CiTypeDto();
        ciTypeDto.setCatalogId(1);
        ciTypeDto.setName("Test Type");
        ciTypeDto.setLayerId(5);
        ciTypeDto.setTableName("test_type");
        ciTypeDto.setZoomLevelId(11);
        ciTypeDto.setImageFileId(1);
        return ciTypeDto;
    }

    @Test
    public void addNewCiTypeWhenTalbeIsExistedThenReturnStatusError() throws Exception {
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(true);

        CiTypeDto ciTypeDto = getNewCiTypeDto();

        mvc.perform(post("/ciType/add").contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(ciTypeDto)))
                .andExpect(jsonPath("$.statusCode", is("ERR_BATCH_CHANGE")));
    }

    @Test
    public void createTableForNewCiTypeWhenTableIsNotExistThenReturnOk() throws Exception {
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(false);

        // Add a new CI type
        CiTypeDto ciTypeDto = getNewCiTypeDto();
        MvcResult mvcResult = mvc.perform(post("/ciType/add").contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(ciTypeDto)))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        // create table for the new CI type
        int ciTypeId = getCiTypeIdFromResponse(mvcResult);
        mvc.perform(post("/ciType/{ciTypeId}/createTable", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")));
    }

    private int getCiTypeIdFromResponse(MvcResult mvcResult) throws UnsupportedEncodingException, IOException {
        String retContent = mvcResult.getResponse()
                .getContentAsString();
        int ciTypeId = JsonUtil.asNodeByPath(retContent, "/data/ciTypeId")
                .asInt();
        return ciTypeId;
    }

    @Test
    public void updateCiTypeThenReturnOk() throws Exception {
        CiTypeDto ciTypeDto = getNewCiTypeDto();
        MvcResult mvcResult = mvc.perform(post("/ciType/add").contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(ciTypeDto)))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        int ciTypeId = getCiTypeIdFromResponse(mvcResult);

        Map<?, ?> jsonMap = CollectionUtils.toImmutableMap("catalogId", 2, "name", "New Test Type", "layerId", 2, "seqNo", 2, "zoomLevelId", 3, "imageFileId", 2, "description", "Update desc", "tableName", "new_ci_type");// table name should
                                                                                                                                                                                                                            // not be update

        mvc.perform(post("/ciType/{ciTypeId}/update", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(jsonMap)))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        MvcResult mvcResultUpdated = mvc.perform(get(String.format("/ciType/%d", ciTypeId)))
                .andReturn();
        String retContent = mvcResultUpdated.getResponse()
                .getContentAsString();

        ResponseDto<CiTypeDto> updatedResult = JsonUtil.toResponseResult(retContent, CiTypeDto.class);
        Assert.assertThat(updatedResult.getData()
                .getCatalogId(), equalTo(jsonMap.get("catalogId")));
        Assert.assertThat(updatedResult.getData()
                .getName(), equalTo(jsonMap.get("name")));
        Assert.assertThat(updatedResult.getData()
                .getLayerId(), equalTo(jsonMap.get("layerId")));
        Assert.assertThat(updatedResult.getData()
                .getSeqNo(), equalTo(jsonMap.get("seqNo")));
        Assert.assertThat(updatedResult.getData()
                .getZoomLevelId(), equalTo(jsonMap.get("zoomLevelId")));
        Assert.assertThat(updatedResult.getData()
                .getImageFileId(), equalTo(jsonMap.get("imageFileId")));
        Assert.assertThat(updatedResult.getData()
                .getDescription(), equalTo(jsonMap.get("description")));
        // table name should not be updated
        Assert.assertThat(updatedResult.getData()
                .getTableName(), equalTo(ciTypeDto.getTableName()));
    }

    @Test
    public void moveDownSystemCiTypeThenSeqNoIs2() throws Exception {
        int ciTypeId = 2;
        mvc.perform(post("/ciType/{ciTypeId}/down", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        MvcResult mvcResultUpdated = mvc.perform(get("/ciType/{ciTypeId}", ciTypeId))
                .andReturn();
        String retContent = mvcResultUpdated.getResponse()
                .getContentAsString();

        int updatedSeqNo = JsonUtil.asNodeByPath(retContent, "/data/seqNo")
                .asInt();
        Assert.assertThat(updatedSeqNo, equalTo(2));
    }

    @Test
    public void moveUpSubSystemCiTypeThenSeqNoIs1() throws Exception {
        int ciTypeId = 3;
        mvc.perform(post("/ciType/{ciTypeId}/up", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        MvcResult mvcResultUpdated = mvc.perform(get("/ciType/{ciTypeId}", ciTypeId))
                .andReturn();
        String retContent = mvcResultUpdated.getResponse()
                .getContentAsString();

        int updatedSeqNo = JsonUtil.asNodeByPath(retContent, "/data/seqNo")
                .asInt();
        Assert.assertThat(updatedSeqNo, equalTo(1));
    }

    @Test
    public void moveUpSystemCiTypeOrMoveDownSubSystemThenReturnError() throws Exception {
        mvc.perform(post("/ciType/2/up"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
        mvc.perform(post("/ciType/3/down"))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void addNewValidCiTypeAttributeThenReturnOk() throws Exception {
        Integer ciTypeId = 2;
        CiTypeAttrDto newAttrDto = genNewCiTypeAttribute(ciTypeId);

        Map<?, ?> jsonMap = ImmutableMap.builder()
                .put("ciTypeId", ciTypeId)
                .put("description", "CI type attribute descption")
                .put("displaySeqNo", 1)
                .put("isDisplayed", true)
                .put("isEditable", true)
                .put("isHidden", false)
                .put("isNullable", false)
                .put("isUnique", false)
                .put("inputType", "text")
                .put("length", 32)
                .put("name", "attrName")
                .put("propertyName", "propertyName")
                .put("propertyType", "int")
                .put("searchSeqNo", 1)
                .put("referenceName", "ReferenceName")
                // TODO: conver to refrenceType to integer (codeId)
                // .put("referenceType", "Composite")
                .put("isAccessControlled", true)
                .put("referenceId", 1)
                .build();

        String reqJson = JsonUtil.toJson(jsonMap);
        MvcResult mvcResult = mvc.perform(post("/ciType/{ciTypeId}/attr/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();

        String retContent = mvcResult.getResponse()
                .getContentAsString();
        int ciTypeAttrId = JsonUtil.asNodeByPath(retContent, "/data/ciTypeAttrId")
                .asInt();

        MvcResult mvcResultUpdated = mvc.perform(get("/ciType/attr/{ciTypeAttrId}", ciTypeAttrId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retAttrContent = mvcResultUpdated.getResponse()
                .getContentAsString();

        ResponseDto<CiTypeAttrDto> updatedResult = JsonUtil.toResponseResult(retAttrContent, CiTypeAttrDto.class);
        Assert.assertThat(updatedResult.getData()
                .getDescription(), equalTo(newAttrDto.getDescription()));
        Assert.assertThat(updatedResult.getData()
                .getDisplaySeqNo(), equalTo(newAttrDto.getDisplaySeqNo()));
        Assert.assertThat(updatedResult.getData()
                .getIsDisplayed(), equalTo(newAttrDto.getIsDisplayed()));
        Assert.assertThat(updatedResult.getData()
                .getIsEditable(), equalTo(newAttrDto.getIsEditable()));
        Assert.assertThat(updatedResult.getData()
                .getIsHidden(), equalTo(newAttrDto.getIsHidden()));
        Assert.assertThat(updatedResult.getData()
                .getIsNullable(), equalTo(newAttrDto.getIsNullable()));
        Assert.assertThat(updatedResult.getData()
                .getIsUnique(), equalTo(newAttrDto.getIsUnique()));
        Assert.assertThat(updatedResult.getData()
                .getInputType(), equalTo(newAttrDto.getInputType()));
        Assert.assertThat(updatedResult.getData()
                .getLength(), equalTo(newAttrDto.getLength()));
        Assert.assertThat(updatedResult.getData()
                .getName(), equalTo(newAttrDto.getName()));
        Assert.assertThat(updatedResult.getData()
                .getPropertyName(), equalTo(newAttrDto.getPropertyName()));
        Assert.assertThat(updatedResult.getData()
                .getPropertyType(), equalTo(newAttrDto.getPropertyType()));
        Assert.assertThat(updatedResult.getData()
                .getReferenceId(), equalTo(newAttrDto.getReferenceId()));
        Assert.assertThat(updatedResult.getData()
                .getSearchSeqNo(), equalTo(newAttrDto.getSearchSeqNo()));
        Assert.assertThat(updatedResult.getData()
                .getReferenceName(), equalTo(newAttrDto.getReferenceName()));
        // Assert.assertThat(updatedResult.getData().getReferenceType(),
        // equalTo(newAttrDto.getReferenceType()));
        Assert.assertThat(updatedResult.getData()
                .getIsAccessControlled(), equalTo(newAttrDto.getIsAccessControlled()));
    }

    @Test
    public void updateExistingAttributeThenReturnOk() throws Exception {
        int ciTypeId = 2;
        int ciTypeAttrId = 7;
        CiTypeAttrDto newAttrDto = genNewCiTypeAttribute(ciTypeId);
        mvc.perform(post("/ciType/{ciTypeId}/attr/{ciTypeAttrId}/update", ciTypeId, ciTypeAttrId).contentType(MediaType.APPLICATION_JSON)
                .content(JsonUtil.toJson(newAttrDto)))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        MvcResult mvcResultUpdated = mvc.perform(get("/ciType/attr/{ciTypeAttrId}", ciTypeAttrId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andReturn();
        String retAttrContent = mvcResultUpdated.getResponse()
                .getContentAsString();

        ResponseDto<CiTypeAttrDto> updatedResult = JsonUtil.toResponseResult(retAttrContent, CiTypeAttrDto.class);
        Assert.assertThat(updatedResult.getData()
                .getDescription(), equalTo(newAttrDto.getDescription()));
        Assert.assertThat(updatedResult.getData()
                .getDisplaySeqNo(), equalTo(newAttrDto.getDisplaySeqNo()));
        Assert.assertThat(updatedResult.getData()
                .getIsDisplayed(), equalTo(newAttrDto.getIsDisplayed()));
        Assert.assertThat(updatedResult.getData()
                .getIsEditable(), equalTo(newAttrDto.getIsEditable()));
        Assert.assertThat(updatedResult.getData()
                .getIsHidden(), equalTo(newAttrDto.getIsHidden()));
        Assert.assertThat(updatedResult.getData()
                .getIsNullable(), equalTo(newAttrDto.getIsNullable()));
        Assert.assertThat(updatedResult.getData()
                .getIsUnique(), equalTo(newAttrDto.getIsUnique()));
        Assert.assertThat(updatedResult.getData()
                .getInputType(), equalTo(newAttrDto.getInputType()));
        Assert.assertThat(updatedResult.getData()
                .getLength(), equalTo(newAttrDto.getLength()));
        Assert.assertThat(updatedResult.getData()
                .getName(), equalTo(newAttrDto.getName()));
        Assert.assertThat(updatedResult.getData()
                .getPropertyName(), equalTo(newAttrDto.getPropertyName()));
        Assert.assertThat(updatedResult.getData()
                .getPropertyType(), equalTo(newAttrDto.getPropertyType()));
        Assert.assertThat(updatedResult.getData()
                .getReferenceId(), equalTo(newAttrDto.getReferenceId()));
        Assert.assertThat(updatedResult.getData()
                .getSearchSeqNo(), equalTo(newAttrDto.getSearchSeqNo()));
        Assert.assertThat(updatedResult.getData()
                .getReferenceName(), equalTo(newAttrDto.getReferenceName()));
        // Assert.assertThat(updatedResult.getData().getReferenceType(),
        // equalTo(newAttrDto.getReferenceType()));
        Assert.assertThat(updatedResult.getData()
                .getIsAccessControlled(), equalTo(newAttrDto.getIsAccessControlled()));
    }

    private CiTypeAttrDto genNewCiTypeAttribute(Integer ciTypeId) {
        CiTypeAttrDto newAttrDto = new CiTypeAttrDto();
        newAttrDto.setCiTypeId(ciTypeId);
        ;
        newAttrDto.setDescription("CI type attribute descption");
        newAttrDto.setDisplaySeqNo(1);
        newAttrDto.setIsDisplayed(true);
        newAttrDto.setIsEditable(true);
        newAttrDto.setIsHidden(false);
        newAttrDto.setIsNullable(false);
        newAttrDto.setIsUnique(false);
        newAttrDto.setInputType(InputType.Text.getCode());
        newAttrDto.setLength(32);
        newAttrDto.setName("attrName");
        newAttrDto.setPropertyName("propertyName");
        newAttrDto.setPropertyType("int");
        newAttrDto.setReferenceId(1);
        newAttrDto.setSearchSeqNo(1);
        newAttrDto.setReferenceName("ReferenceName");
        newAttrDto.setReferenceType(27);
        newAttrDto.setIsAccessControlled(true);
        return newAttrDto;
    }

    @Test
    public void deleteExistingCiTypeAttrThenTheAttrIsNotExisted() throws Exception {
        int ciTypeId = 2;
        int ciTypeAttrId = 1;
        mvc.perform(post("/ciType/{ciTypeId}/attr/{ciTypeAttrId}/delete", ciTypeId, ciTypeAttrId))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        mvc.perform(get(String.format("/ciType/attr/%d", ciTypeAttrId)))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));
    }

    @Test
    public void addCiTypeAttrUniqueGroupThenNewOneCanBeQueried() throws Exception {
        int ciTypeId = 4;
        Map<String, ?> jsonMap = ImmutableMap.of("ciTypeId", ciTypeId, "name", "Test unique key", "ciTypeAttrs", Arrays.asList(ImmutableMap.of("ciTypeAttrId", 34), ImmutableMap.of("ciTypeAttrId", 35)));
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/ciType/{ciTypeId}/attrUniqueGroup/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(get("/ciType/{ciTypeId}/attrUniqueGroups", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].name", is(jsonMap.get("name"))));
    }

    @Test
    public void addDuplicatedCiTypeAttrUniqueGroupThenReturnError() throws Exception {
        int ciTypeId = 4;
        Map<String, ?> jsonMap = ImmutableMap.of("ciTypeId", ciTypeId, "name", "Test unique key", "ciTypeAttrs", Arrays.asList(ImmutableMap.of("ciTypeAttrId", 12), ImmutableMap.of("ciTypeAttrId", 13)));
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/ciType/{ciTypeId}/attrUniqueGroup/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        mvc.perform(post("/ciType/{ciTypeId}/attrUniqueGroup/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERR_INVALID_ARGUMENT")));

    }

    @Test
    public void addAndDeleteCiTypeAttrUniqueGroupThenSuccess() throws Exception {
        int ciTypeId = 4;
        Map<String, ?> jsonMap = ImmutableMap.of("ciTypeId", ciTypeId, "name", "Test unique key", "ciTypeAttrs", Arrays.asList(ImmutableMap.of("ciTypeAttrId", 34), ImmutableMap.of("ciTypeAttrId", 35)));
        String reqJson = JsonUtil.toJson(jsonMap);
        mvc.perform(post("/ciType/{ciTypeId}/attrUniqueGroup/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        MvcResult mvcResultUpdated = mvc.perform(get("/ciType/{ciTypeId}/attrUniqueGroups", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.length()", is(1)))
                .andReturn();
        String retContent = mvcResultUpdated.getResponse()
                .getContentAsString();
        int uniqueAttGroupId = JsonUtil.asNodeByPath(retContent, "/data/0/attrGroupId")
                .asInt();

        mvc.perform(post("/ciType/attrUniqueGroup/{attrGroupId}/delete", uniqueAttGroupId))
                .andExpect(jsonPath("$.statusCode", is("OK")));
        mvc.perform(get("/ciType/{ciTypeId}/attrUniqueGroups", ciTypeId))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.length()", is(0)));

    }
    
    @Test
    public void getCiTypeHeaderThenReturnHeaderValueProperly() throws Exception {
        mvc.perform(get("/ciType/3/header"))
        .andExpect(jsonPath("$.statusCode", is("OK")))
        .andExpect(jsonPath("$.data", hasSize(14)))
        .andExpect(jsonPath("$.data[10].vals", hasSize(2)))//system id
        .andExpect(jsonPath("$.data[10].vals[0].guid", is("0002_0000000002")))
        .andExpect(jsonPath("$.data[10].vals[0].keyName", is("public system")));
    }
}
