package com.webank.cmdb.controller.ui.helper;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;

@Ignore
@RunWith(SpringRunner.class)
@SpringBootTest
public class UIWrapperServiceTest {

    @Autowired
    private UIWrapperService service;

    ObjectMapper objectMapper = new ObjectMapper();

    @Ignore
    @Test
    public void testQueryCiData() throws JsonParseException, JsonMappingException, IOException {
        long st = System.currentTimeMillis();
        int ciTypeId = 45;
        String requestJson = "{\"dialect\":{\"showCiHistory\":false},\"filters\":[],\"pageable\":{\"pageSize\":10,\"startIndex\":0},\"paging\":true}";

        QueryRequest queryObject = objectMapper.readValue(requestJson, QueryRequest.class);
        
        Assert.assertNotNull(queryObject);
        Assert.assertEquals(10, queryObject.getPageable().getPageSize());


        QueryResponse<CiData> ciDataResp = service.queryCiData(ciTypeId, queryObject);
        
        Assert.assertNotNull(ciDataResp);
        Assert.assertNotNull(ciDataResp.getContents());
        Assert.assertEquals(10, ciDataResp.getContents().size());

        System.out.println(System.currentTimeMillis() - st);
    }

    @Ignore
    @Test
    public void testBatchUpdate() throws Exception {
        int ciTypeId = 50;
        String requestJson = FileUtils
                .readFileToString(new File(UIWrapperServiceTest.class.getResource("jsondata.txt").getFile()));
        List<Map<String, Object>> ciDatas = objectMapper.readValue(requestJson, List.class);
        
//        System.in.read();

        for (int i = 0; i < 1; i++) {
            List<Map<String, Object>> results = service.updateCiData(ciTypeId, ciDatas);
            System.out.println(results.size());
        }
        
//        System.in.read();
    }

}
