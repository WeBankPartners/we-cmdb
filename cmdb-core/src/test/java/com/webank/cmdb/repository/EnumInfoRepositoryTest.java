package com.webank.cmdb.repository;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import java.util.List;

import javax.sql.DataSource;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.dto.EnumInfo;
import com.webank.cmdb.dto.EnumInfoRequest;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class EnumInfoRepositoryTest {
    @Autowired
    private EnumInfoRepository enumInfoRepository;
    @Autowired
    private DataSource dataSource;

    @Before
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
    }

    @Test
    public void queryEnumInfoWithoutFilterThenReturnAllEnumInfo() {
        EnumInfoRequest request = new EnumInfoRequest();
        List<EnumInfo> enumInfos = enumInfoRepository.queryEnumInfo(request);
        assertThat(enumInfos.size(), equalTo(76));
    }

    @Test
    public void queryEnumInfoForChinaGroupThenReturn2EnumInfo() {
        EnumInfoRequest request = new EnumInfoRequest();
        request.getFilters()
                .setGroupName("china");
        List<EnumInfo> enumInfos = enumInfoRepository.queryEnumInfo(request);
        assertThat(enumInfos.size(), equalTo(2));
    }

    @Test
    public void queryEnumInfoForSpecificCatNameThenReturnProperEnumInfo() {
        EnumInfoRequest request = new EnumInfoRequest();
        request.getFilters()
                .setCatName("Country");
        List<EnumInfo> enumInfos = enumInfoRepository.queryEnumInfo(request);
        assertThat(enumInfos.size(), equalTo(2));
    }

    @Test
    public void queryEnumInfoForSpecificCodeThenReturnProperEnumInfo() {
        EnumInfoRequest request = new EnumInfoRequest();
        request.getFilters()
                .setCode("Shenzhen");
        List<EnumInfo> enumInfos = enumInfoRepository.queryEnumInfo(request);
        assertThat(enumInfos.size(), equalTo(1));
        assertThat(enumInfos.get(0)
                .getCode(), equalTo("Shenzhen"));
    }

    @Test
    public void queryEnumInfoAndTotalRowCountThenBothReturnCountShouldBeSame() {
        int expectedResultCount = 4;
        EnumInfoRequest request = new EnumInfoRequest();
        request.getFilters()
                .setDescription("layer");
        List<EnumInfo> enumInfos = enumInfoRepository.queryEnumInfo(request);
        assertThat(enumInfos.size(), equalTo(expectedResultCount));

        int totalCount = enumInfoRepository.getTotalRowCount(request);
        assertThat(totalCount, equalTo(expectedResultCount));
    }

    @Test
    public void queryTotalRowCountThenReturnTotalNumber() {
        EnumInfoRequest request = new EnumInfoRequest();
        int totalCount = enumInfoRepository.getTotalRowCount(request);
        assertThat(totalCount, equalTo(76));
    }
}
