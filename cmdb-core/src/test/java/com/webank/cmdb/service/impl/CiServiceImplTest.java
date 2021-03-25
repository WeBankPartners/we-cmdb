package com.webank.cmdb.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.support.cache.CacheHandlerInterceptor;
import com.webank.cmdb.util.CmdbThreadLocal;

@Ignore
@RunWith(SpringRunner.class)
@SpringBootTest
public class CiServiceImplTest {
    
    @Autowired
    CiTypeService ciTypeService;
    @Autowired
    EntityManager entityManager;
    
    @Autowired
    CiService ciService;
    
    @Autowired
    CacheHandlerInterceptor cacheHandlerInterceptor;
    
    @Before
    public void setUp(){
        ciService.invalidate();
        ciService.reload();
        CmdbThreadLocal.getIntance()
        .putCurrentUser("mock_user1");
    }
    @Transactional
    @Test
    public void testUpdateIntListOfMapOfStringObject() {
        int ciTypeId = 2;
        String guid = "0002_0000000001";
        
        Map<String, Object> ciData = mockCiDataToUpdate(guid);
        
        ciService.update(ciTypeId, guid, ciData);
    }
    
    private Map<String, Object> mockCiDataToUpdate(String guid){
        Map<String, Object> ciData = new HashMap<>();
        String description = "JAVA应用3";
        ciData.put("description", description);
        ciData.put("guid", guid);
        return ciData;
    }

}
