package com.webank.cmdb.controller.ui.helper;

import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.dto.QueryRequest;

//@Ignore
@RunWith(SpringRunner.class)
@SpringBootTest
public class UIWrapperServiceTest {
    
    @Autowired
    UIWrapperService service;

    
    @Ignore
    //http://localhost:19090/wecmdb/ui/v2/trees/all-design-trees/from-system-design?system-design-guid=0037_0000000002
    @Test
    public void testGetAllDesignTreesFromSystemDesign() {
        //fail("Not yet implemented");
        
        String systemDesignGuid= "0037_0000000002";
        
        List<ResourceTreeDto> results = service.getAllDesignTreesFromSystemDesign(systemDesignGuid);
        Assert.assertNotNull(results);
        
    }
    
    @Ignore
    //http://localhost:19090/wecmdb/ui/v2/architecture-designs/tabs/ci-data?code-id=151&system-design-guid=0037_0000000002&r-guid=0037_0000000002
    @Test
    public void testGetArchitectureCiData() {
        
        Integer codeId=151;
        String systemDesignGuid="0037_0000000002";
        String rGuid="0037_0000000002";
        QueryRequest queryObject = new QueryRequest();
        
        Object result = service.getArchitectureCiData(codeId,systemDesignGuid,queryObject, rGuid);
        
        Assert.assertNotNull(result);
    }
    
    
    //http://localhost:19090/wecmdb/ui/v2/ci-types/39/ci-data/batch-delete
    @Ignore
    @Test
    public void testDeleteCiData() {
        Integer ciTypeId = 39;
         List<String> ids = new ArrayList<>();
         ids.add("0039_0000000006");
         
         service.deleteCiData(ciTypeId, ids);
         
         System.out.println("Succ");
    }

}
