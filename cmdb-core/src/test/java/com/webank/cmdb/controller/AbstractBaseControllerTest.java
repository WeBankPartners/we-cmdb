package com.webank.cmdb.controller;

import java.io.IOException;

import javax.sql.DataSource;

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

import com.webank.cmdb.cache.CacheHandlerInterceptor;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.DatabaseService;
import com.webank.cmdb.util.CmdbThreadLocal;

@SpringBootTest
@RunWith(SpringRunner.class)
@AutoConfigureMockMvc
@ActiveProfiles("test")
public abstract class AbstractBaseControllerTest {
    @Autowired
    protected DataSource dataSource;
    @Autowired
    protected MockMvc mvc;
    @Autowired
    protected CiService ciService;
    @MockBean
    protected DatabaseService databaseService;
    @Autowired
    private CacheHandlerInterceptor cacheHandlerInterceptor;

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
}
