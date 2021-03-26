package com.webank.cmdb.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.webank.cmdb.controller.MaintainController;
import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.AutoFillIntegrationQueryDto;
import com.webank.cmdb.dto.AutoFillIntegrationQueryExDto;
import com.webank.cmdb.dto.AutoFillItem;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dto.RelationshipEx;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.support.cache.CacheHandlerInterceptor;
import com.webank.cmdb.util.CmdbThreadLocal;
import com.webank.cmdb.util.JsonUtil;

@Ignore
@RunWith(SpringRunner.class)
@SpringBootTest
public class CiServiceImplTest {

    @Autowired
    CiTypeService ciTypeService;
    @Autowired
    EntityManager entityManager;
    
    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;

    @Autowired
    CiService ciService;

    @Autowired
    CacheHandlerInterceptor cacheHandlerInterceptor;
    
    @Autowired
    MaintainController controller;
    
    @Autowired
    private UIWrapperService wrapperService;
    
    ObjectMapper objectMapper = new ObjectMapper();

    @Before
    public void setUp() {
        ciService.invalidate();
        ciService.reload();
        CmdbThreadLocal.getIntance().putCurrentUser("mock_user1");
    }
    
    @Test
    public void testController() throws IOException{
        controller.upgradeAutoFillRule();
    }
    
    
    //http://localhost:19090/wecmdb/ui/v2/ci-types/48/ci-data/batch-update
    @Test
    public void testBatchUpdate() throws IOException {
        String filename = "testBatchUpdate.json";
        String filepath = this.getClass().getResource(filename).getFile();
        String json = FileUtils.readFileToString(new File(filepath), "UTF-8");
        
        int ciTypeId = 48;
        
        List<Map<String,Object>> rawCiDatas = (List<Map<String, Object>>) objectMapper.readValue(json, Object.class);
        
        System.out.println("json:"+json);
        
        System.out.println(rawCiDatas);
        
        wrapperService.updateCiData(ciTypeId, rawCiDatas);
    }
    
    
    //http://localhost:19090/wecmdb/ui/v2/ci-types/38/ci-data/batch-create
    //{"statusCode":"ERR_BATCH_CHANGE","statusMessage":"(CN)Fail to create [1] records, detail error in the data block.","data":[{"errorMessage":"Fail to create ci data ciTypeId [38], error [Data truncation: Data too long for column 'qwer1234' at row 1]"}]}
    @Test
    public void testBatchCreate() throws IOException {
        String filename = "testBatchCreate.json";
        String filepath = this.getClass().getResource(filename).getFile();
        String json = FileUtils.readFileToString(new File(filepath), "UTF-8");
        
        int ciTypeId = 38;
        
        List<Map<String,Object>> rawCiDatas = (List<Map<String, Object>>) objectMapper.readValue(json, Object.class);
        
        System.out.println("json:"+json);
        
        List<Map<String, Object>> ret = wrapperService.createCiData(ciTypeId, rawCiDatas);
        
        System.out.println(ret);
    }

    @Transactional
    @Test
    public void testUpdateIntListOfMapOfStringObject() {
        int ciTypeId = 2;
        String guid = "0002_0000000001";

        Map<String, Object> ciData = mockCiDataToUpdate(guid);

        ciService.update(ciTypeId, guid, ciData);
    }
    
    @Test
    public void testReg(){
        String reg = "\"ciTypeId\":\\d+[},]";
        Pattern r = Pattern.compile(reg);
        String json = "[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":13,\\\"parentRs\\\":{\\\"attrId\\\":190,\\\"isReferedFromParent\\\":1}}]\"},{\"type\":\"delimiter\",\"value\":\"__\"},{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":13,\\\"parentRs\\\":{\\\"attrId\\\":192,\\\"isReferedFromParent\\\":1}}]\"},{\"type\":\"delimiter\",\"value\":\"__\"},{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":12,\\\"parentRs\\\":{\\\"attrId\\\":193,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":12,\\\"parentRs\\\":{\\\"attrId\\\":176,\\\"isReferedFromParent\\\":1}}]\"},{\"type\":\"delimiter\",\"value\":\"_\"},{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":13,\\\"parentRs\\\":{\\\"attrId\\\":191,\\\"isReferedFromParent\\\":1}}]\"}]";
        
        Matcher m = r.matcher(json);
        if(m.find()){
            System.out.println("true");
        }else{
            System.out.println("false");
        }
    }

    @Test
    public void testAutoFillRule() throws IOException {
        String reg = "\"ciTypeId\":\\d+[},]";
        Pattern r = Pattern.compile(reg);
        String json = "[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":13,\\\"parentRs\\\":{\\\"attrId\\\":190,\\\"isReferedFromParent\\\":1}}]\"},{\"type\":\"delimiter\",\"value\":\"__\"},{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":13,\\\"parentRs\\\":{\\\"attrId\\\":192,\\\"isReferedFromParent\\\":1}}]\"},{\"type\":\"delimiter\",\"value\":\"__\"},{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":12,\\\"parentRs\\\":{\\\"attrId\\\":193,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":12,\\\"parentRs\\\":{\\\"attrId\\\":176,\\\"isReferedFromParent\\\":1}}]\"},{\"type\":\"delimiter\",\"value\":\"_\"},{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":13},{\\\"ciTypeId\\\":13,\\\"parentRs\\\":{\\\"attrId\\\":191,\\\"isReferedFromParent\\\":1}}]\"}]";
        List<AutoFillItem> autoFillItems = JsonUtil.toList(json, AutoFillItem.class);
        List<AutoFillItem> exAutoFillItems = new ArrayList<>();
        for (AutoFillItem autoFillItem : autoFillItems) {
            System.out.println(autoFillItem.getValue());
            AutoFillItem exAutoFillItem = new AutoFillItem();
            exAutoFillItem.setType(autoFillItem.getType());
            if (!autoFillItem.getType().equals("rule")) {
                exAutoFillItem.setValue(autoFillItem.getValue());
            } else {
                Matcher m = r.matcher(autoFillItem.getValue());
                System.out.println(m.find());
                List<AutoFillIntegrationQueryDto> intDtos = JsonUtil.toList(autoFillItem.getValue(),
                        AutoFillIntegrationQueryDto.class);

                List<AutoFillIntegrationQueryExDto> exIntDtos = new ArrayList<>();
                for (AutoFillIntegrationQueryDto intDto : intDtos) {
                    AutoFillIntegrationQueryExDto exIntDto = convert(intDto);
                    exIntDtos.add(exIntDto);
                }

                String itemJsonValue = JsonUtil.toJson(exIntDtos);
                exAutoFillItem.setValue(itemJsonValue);
                System.out.println("toJson:" + itemJsonValue);
            }

            exAutoFillItems.add(exAutoFillItem);
        }
        
        System.out.println("FIN:"+JsonUtil.toJson(exAutoFillItems));
    }

    private AutoFillIntegrationQueryExDto convert(IntegrationQueryDto intDto) {
        AutoFillIntegrationQueryExDto exIntDto = new AutoFillIntegrationQueryExDto();
        exIntDto.setName(intDto.getName());
        exIntDto.setKeyName(intDto.getKeyName());
        // TODO
        AdmCiType admCiType = ciTypeRepository.findAdmCiTypeAndAttrsById(intDto.getCiTypeId());
        exIntDto.setCiTypeId(admCiType.getTableName());
        exIntDto.setAttrs(intDto.getAttrs());
        exIntDto.setAttrAliases(intDto.getAttrAliases());
        exIntDto.setAggKeyNames(intDto.getAggKeyNames());
        exIntDto.setAttrKeyNames(intDto.getAttrKeyNames());

        if (intDto instanceof AutoFillIntegrationQueryDto) {
            AutoFillIntegrationQueryDto af = (AutoFillIntegrationQueryDto) intDto;
            exIntDto.setEnumCodeAttr(af.getEnumCodeAttr());
        }

        // relation with parent node, it is not needed in root node.
        if (intDto.getParentRs() != null) {
            Relationship rs = intDto.getParentRs();
            RelationshipEx exRs = new RelationshipEx();
            
            
            Optional<AdmCiTypeAttr> admCiTypeAttrOpt = ciTypeAttrRepository.findById(rs.getAttrId());
            AdmCiTypeAttr  exAttr = admCiTypeAttrOpt.get();
            String exAttrId = String.format("%s#%s", exAttr.getAdmCiType().getTableName(), exAttr.getPropertyName());
            exRs.setAttrId(exAttrId);
            exRs.setIsReferedFromParent(rs.getIsReferedFromParent());
            exIntDto.setParentRs(exRs);
        }

        exIntDto.setFilters(intDto.getFilters());
        for (IntegrationQueryDto c : intDto.getChildren()) {
            AutoFillIntegrationQueryExDto exC = convert(c);

            exIntDto.addChild(exC);
        }

        return exIntDto;

    }

    private Map<String, Object> mockCiDataToUpdate(String guid) {
        Map<String, Object> ciData = new HashMap<>();
        String description = "JAVA应用3";
        ciData.put("description", description);
        ciData.put("guid", guid);
        return ciData;
    }

}
