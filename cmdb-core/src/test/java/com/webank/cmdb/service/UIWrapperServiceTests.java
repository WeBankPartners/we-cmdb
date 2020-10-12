package com.webank.cmdb.service;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.dto.QueryRequest;

@Ignore
@RunWith(SpringRunner.class)
@SpringBootTest
public class UIWrapperServiceTests {
    
    String filename = "testQueryReferenceData.json";
    
    @Autowired
    private UIWrapperService wrapperService;
    
    @Test
    public void testQueryReferenceData() throws IOException {
        File inputFile = FileUtils.toFile(UIWrapperServiceTests.class.getResource(filename));
        String inputJson = FileUtils.readFileToString(inputFile);
        
        System.out.println("inputJson:"+inputJson);
        int referenceAttrId = 933;
        QueryRequest queryObject = new QueryRequest();
        Object result = wrapperService.queryReferenceCiData(referenceAttrId, queryObject);
        
        System.out.println("result:"+result);
    }

}
