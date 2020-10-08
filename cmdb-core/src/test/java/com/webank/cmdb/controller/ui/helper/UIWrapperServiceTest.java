package com.webank.cmdb.controller.ui.helper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;

@RunWith(SpringRunner.class)
@SpringBootTest
public class UIWrapperServiceTest {
    
    @Autowired
    private UIWrapperService uiWrapperService;

    @Test
    public void test_queryCiDataByType() {
        Integer ciTypeId = 32;
        QueryRequest queryObject = new QueryRequest();
        QueryResponse<CiData> response = uiWrapperService.queryCiData( ciTypeId,  queryObject);
        
        System.out.println(response.getContents().size());
    }
    
    @Test
    public void test_updateCiData(){
        
        Integer ciTypeId = 32;
        List<Map<String, Object>> ciDatas = new ArrayList<>();
        Map<String, Object> ciData = new HashMap<>();
        ciData.put("guid", "0032_0000000002");
        ciData.put("description", "test");
        
        ciDatas.add(ciData);
        
        List<Map<String, Object>> result = uiWrapperService.updateCiData( ciTypeId, ciDatas);
        
        System.out.println(result);
    }

}
