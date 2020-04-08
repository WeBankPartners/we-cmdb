package com.webank.cmdb.service;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class SequenceServiceImplTest  extends LegacyAbstractBaseControllerTest{
    @Autowired
    private SequenceService sequenceService;

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
