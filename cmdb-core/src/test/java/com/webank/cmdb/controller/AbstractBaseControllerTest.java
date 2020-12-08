package com.webank.cmdb.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.persistence.EntityManager;
import javax.sql.DataSource;

import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import org.apache.commons.io.IOUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import com.webank.cmdb.support.cache.CacheHandlerInterceptor;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.DatabaseService;
import com.webank.cmdb.util.CmdbThreadLocal;

@SpringBootTest
@RunWith(SpringRunner.class)
@AutoConfigureMockMvc
@ActiveProfiles("test")
public abstract class AbstractBaseControllerTest {
    private static final AtomicInteger ciTypeSeqNo = new AtomicInteger();

    @Autowired
    protected DataSource dataSource;
    @Autowired
    protected MockMvc mvc;
    @Autowired
    protected CiService ciService;
    @Autowired
    CiTypeService ciTypeService;
    @Autowired
    EntityManager entityManager;
    @Autowired
    private CacheHandlerInterceptor cacheHandlerInterceptor;
    @MockBean
    protected DatabaseService databaseService;

    public void reload() {
        ciService.invalidate();
        ciService.reload();
    }

    @Before
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabase(dataSource);
        reload();
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(false);
        CmdbThreadLocal.getIntance()
                .putCurrentUser("mock_user1");
    }

    @After
    public void cleanUp() {
        TestDatabase.cleanUpDatabase(dataSource);
        try {
            cacheHandlerInterceptor.postHandle(null, null, null, null);
        } catch (Exception e) {
            System.out.print(e.toString());
        }
    }

    public String readJsonFromFile(String filePath) throws IOException {
        ClassPathResource resource = new ClassPathResource(filePath);
        if (resource.exists()) {
            return new String(IOUtils.toString(resource.getInputStream()));
        }
        return null;
    }

    protected int givenAppliedCiType() {
        return givenAppliedCiType(generateCiTypeName());
    }

    protected int givenAppliedCiType(String name) {
        CiTypeDto ciTypeDto = new CiTypeDto();
        ciTypeDto.setName(name);
        ciTypeDto.setTableName(name);
        ciTypeDto.setStatus(CiStatus.NotCreated.getCode());

        CiTypeDto result = ciTypeService.addCiType(ciTypeDto);
        Integer createdCiTypeId = result.getCiTypeId();
        entityManager.clear();

        ciTypeService.applyCiType(Collections.singletonList(createdCiTypeId));
        entityManager.clear();

        return createdCiTypeId;
    }

    protected int givenAppliedCiAttrForType(int ciTypeId, String name, String autoFillRule) {
        CiTypeAttrDto attrDto = new CiTypeAttrDto();
        attrDto.setCiTypeId(ciTypeId);
        attrDto.setName(name);
        attrDto.setPropertyName(name);
        attrDto.setStatus(CiStatus.NotCreated.getCode());
        attrDto.setInputType("text");
        attrDto.setPropertyType("varchar");
        attrDto.setLength(32);
        attrDto.setIsSystem(false);
        attrDto.setIsEditable(true);
        attrDto.setIsNullable(true);
        attrDto.setIsAuto(autoFillRule != null);
        attrDto.setAutoFillRule(autoFillRule);

        CiTypeAttrDto result = ciTypeService.addCiTypeAttribute(ciTypeId, attrDto);
        entityManager.clear();
        Integer ciTypeAttrId = result.getCiTypeAttrId();
        ciTypeService.applyCiTypeAttr(Collections.singletonList(ciTypeAttrId));
        entityManager.clear();

        return ciTypeAttrId;
    }

    protected Map<String, Object> givenCiData(int ciTypeId, Map<String, Object> ciData) {
        String guid = ciService.create(ciTypeId, ciData);
        return getCiDataSafe(ciTypeId, guid);
    }

    protected Map<String, Object> getCiDataSafe(int ciTypeId, String guid) {
        try {
            return ciService.getCi(ciTypeId, guid);
        } catch(InvalidArgumentException e) {
            return null;
        }
    }

    protected String generateCiTypeName() {
        return "ciTypeName" + ciTypeSeqNo.incrementAndGet();
    }
}
