package com.webank.cmdb.controller;

import javax.sql.DataSource;

import org.junit.After;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import com.webank.cmdb.support.cache.CacheHandlerInterceptor;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.DatabaseService;

@SpringBootTest
@RunWith(SpringRunner.class)
@AutoConfigureMockMvc
@ActiveProfiles("test")
public abstract class LegacyAbstractBaseControllerTest {
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
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
        doSetup(dataSource);
        reload();
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(false);
    }

    protected void doSetup(DataSource dataSource){

    }

    @After
    public void cleanUp() {
        TestDatabase.cleanUpDatabase(dataSource);
        doCleanUp(dataSource);
        try {
            cacheHandlerInterceptor.postHandle(null, null, null, null);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    protected void doCleanUp(DataSource dataSource){

    }
}
