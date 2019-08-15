package com.webank.cmdb.service;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import javax.sql.DataSource;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.config.TestDatabase;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class SequenceServiceImplTest {
    @Autowired
    private SequenceService sequenceService;

    @Autowired
    private DataSource dataSource;

    @Before
    public void setup() {
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
    }

    @Before
    public void cleanUp() {
        TestDatabase.cleanUpDatabase(dataSource);
    }

    @Test
    public void retrieveFirstGuidOfACiTypeThenShouldReturnTheInitGuid() {
        String ciTypeName = "wb_sub_system";
        Integer ciTypeId = 3;
        String expected = "0003_0000000013";
        String actual = sequenceService.getNextGuid(ciTypeName, ciTypeId);
        assertThat(actual, equalTo(expected));
    }

    @Test
    public void retrieveNextGuidWithCiTypeIdOutOfLimitationThenShouldReturnTheOriginCiTypeIdAsPrefix() {
        String ciTypeName = "wb_sub_system";
        Integer ciTypeId = 99999;
        String expected = "99999_0000000013";
        String actual = sequenceService.getNextGuid(ciTypeName, ciTypeId);
        assertThat(actual, equalTo(expected));
    }
}
