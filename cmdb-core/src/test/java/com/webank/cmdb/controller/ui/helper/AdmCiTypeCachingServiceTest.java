package com.webank.cmdb.controller.ui.helper;

import java.util.List;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;

@Ignore
@RunWith(SpringRunner.class)
@SpringBootTest
public class AdmCiTypeCachingServiceTest {

    @Autowired
    AdmCiTypeCachingService dataService;
    
    @Autowired
    AdmCiTypeRepository repo;
    
    @Autowired
    AdmCiTypeAttrRepository attrRepo;
    
    @Ignore
    @Test
    public void testFindMatchAttr(){
        String v = "\\\\\"attrId\\\\\":927";
        List<AdmCiTypeAttr> attrs = attrRepo.findAllByMatchAutoFillRule(v);
        System.out.println("size:"+attrs.size());
    }
    
    @Test
    public void testFindMatchAttrFromCache(){
        String v = "\\\"attrId\\\":927";
        List<AdmCiTypeAttr> attrs = dataService.findAllByMatchAutoFillRule(v);
        System.out.println("size:"+attrs.size());
    }
    
    @Test
    public void testFindById(){
        Integer ciTypeId = 50;
        AdmCiType admCiType = repo.findAdmCiTypeAndAttrsById(ciTypeId);
        
        System.out.println(admCiType.getAdmCiTypeAttrs().size());
    }

    @Test
    public void testFindAllByCiTypeId() {

        Integer ciTypeId = 50;

        for (int i = 0; i < 10; i++) {
            List<AdmCiTypeAttr> attrs = dataService.findAllByCiTypeId(ciTypeId);
            System.out.println(attrs.size());
        }
    }

}
