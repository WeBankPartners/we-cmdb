package com.webank.cmdb.service;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.commons.collections.MapUtils;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.IntQueryResponseHeader;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.exception.BatchChangeException;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.util.JsonUtil;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class CiServiceImplLegacyModelTest extends LegacyAbstractBaseControllerTest {
    @Autowired
    private IntegrationQueryService integrationQueryService;
    @Autowired
    private CiService ciService;

    @Transactional
    @Test
    public void createSubSysToUnitIntegrationQueryAndExecuteThenReturnProperResult() {
        IntegrationQueryDto unitQuery = new IntegrationQueryDto("Unit", 5, Arrays.asList(45), new Relationship(50, false));
        IntegrationQueryDto subSysQuery = new IntegrationQueryDto("Subsystem Query", 3, Arrays.asList(12), Arrays.asList("Sub_system.englishName"), null);
        subSysQuery.addChild(unitQuery);

        int queryId = integrationQueryService.createIntegrationQuery(5, "Test query", subSysQuery);
        QueryResponse response = ciService.integrateQuery(queryId, new QueryRequest());
        assertThat(response.getContents()
                .size(), equalTo(13));
    }

    @Transactional
    @Test
    public void createUnitToSubSysIntegrationQueryAndExecuteThenReturnProperResult() {
        IntegrationQueryDto subSysQuery = new IntegrationQueryDto("Subsystem Query", 3, Arrays.asList(12), new Relationship(50, true));
        IntegrationQueryDto unitQuery = new IntegrationQueryDto("Unit", 5, Arrays.asList(45), null);
        unitQuery.addChild(subSysQuery);

        int queryId = integrationQueryService.createIntegrationQuery(3, "Test query", unitQuery);
        QueryResponse response = ciService.integrateQuery(queryId, new QueryRequest());
        assertThat(response.getContents()
                .size(), equalTo(2));
    }

    @Transactional
    @Test
    public void createIntegrationQueryAndExecuteFollowingHeaderThenReturnProperResult() {
        IntegrationQueryDto sysQuery = new IntegrationQueryDto("System Query", 2, Arrays.asList(10, 11, 7), new Relationship(23, true));
        IntegrationQueryDto subSysQuery = new IntegrationQueryDto("Subsystem Query", 3, Arrays.asList(12), new Relationship(50, true));
        subSysQuery.addChild(sysQuery);
        IntegrationQueryDto unitQuery = new IntegrationQueryDto("Unit", 5, Arrays.asList(45), null);
        unitQuery.addChild(subSysQuery);

        int queryId = integrationQueryService.createIntegrationQuery(3, "Test query", unitQuery);
        List<IntQueryResponseHeader> headers = ciService.integrateQueryHeader(queryId);
        QueryResponse response = ciService.integrateQuery(queryId, new QueryRequest());
        int headerAttrCount = 0;
        for (IntQueryResponseHeader header : headers) {
            headerAttrCount += header.getAttrUnits()
                    .size();
        }

        Map resultMap = (Map) response.getContents()
                .get(0);
        int respAttrCount = resultMap.size();
        assertThat(headerAttrCount, equalTo(respAttrCount));

        headers.forEach(x -> {
            x.getAttrUnits()
                    .forEach(y -> {
                        assertThat(resultMap.containsKey(y.getAttrKey()), equalTo(true));
                    });
        });
    }

    @Transactional
    @Test
    public void executeAdhocIntegrateQueryThenReturnProperResult() {
        IntegrationQueryDto systemQuery = new IntegrationQueryDto("system");
        systemQuery.setCiTypeId(2);
        systemQuery.setAttrs(Lists.newArrayList(8));
        systemQuery.setAttrKeyNames(Lists.newArrayList("system.name"));
        systemQuery.setParentRs(new Relationship(23, true));

        IntegrationQueryDto subsystemQuery = new IntegrationQueryDto("subsystem");
        subsystemQuery.setCiTypeId(3);
        subsystemQuery.setAttrs(Lists.newArrayList(18));
        subsystemQuery.setAttrKeyNames(Lists.newArrayList("subsystem.name"));
        subsystemQuery.setChildren(Lists.newArrayList(systemQuery));
        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto();
        adhocQuery.setCriteria(subsystemQuery);
        adhocQuery.setQueryRequest(new QueryRequest());

        QueryResponse response = ciService.adhocIntegrateQuery(adhocQuery);
        assertThat(response.getContents()
                .size(), equalTo(12));

    }

    @Transactional
    @Test
    public void addCiDataWithWrongCodeIdThenThrowException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "name_en", "new system", "description", "new system desc", "system_type", 999 });
        try {
            ciService.create(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Transactional
    @Test
    public void addCiDataToDecomissionedCiTypeThenThrowException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "capacity", 10 });
        try {
            ciService.create(18, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
        }
    }

    @Transactional
    @Test
    public void addCiDataWithWrongRefGuidThenThrowException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "name_en", "new sub system", "description", "new sub system desc", "system_id", "999_0000001" });
        try {
            ciService.create(3, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Transactional
    @Test
    public void addCiDataWithDuplicatedNameThenThrowException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "name_en", "Bank system", // duplicated
                "description", "duplicated name system", "system_type", 554 });
        try {
            ciService.create(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Transactional
    @Test
    public void addCiDataWithAutoFieldThenThrowException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "name_en", "new Bank system", "description", "duplicated name system", "system_type", 554, "key_name", "system_bank_system" // auto
                                                                                                                                                                                                                  // filled
                                                                                                                                                                                                                  // field
        });
        try {
            ciService.create(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(false);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
            Assert.assertThat(((InvalidArgumentException) ex.getExceptionHolders()
                    .get(0)
                    .getException()).getArgumentName(), equalTo("key_name"));
        }
    }

    @Test
    public void addCiDataWithNotCreatedCiTypeThenThrowException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "Mock_Attr_A", "mock system" });
        try {
            ciService.create(21, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Test(expected = BatchChangeException.class)
    public void addCiDataWithNotCreatedAttrThenGetException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "Mock_Attr_A", "mock system" });
        ciService.create(23, ImmutableList.of(ciDataMap));
    }

    @Test
    public void updateCiDataWithoutGuidThenGetException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "name_en", "new Bank system", "description", "duplicated name system", "system_type", 554, "key_name", "system_bank_system" // auto
                                                                                                                                                                                                                  // filled
                                                                                                                                                                                                                  // field
        });
        try {
            ciService.update(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Transactional
    @Test
    public void updateInvalidEnumCodeThenGetException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "guid", "0002_0000000001", "description", "test desc", "name_en", "enName", "name_cn", "测试系统", "system_type", 999 });
        try {
            ciService.update(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }

    }

    @Transactional
    @Test
    public void updateInvalidCiRefThenGetException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "guid", "0002_0000000002", "description", "test desc", "name_en", "enName", "name_cn", "测试系统", "system_id", "0002_0000000999" });
        try {
            ciService.update(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Transactional
    @Test
    @Ignore // isAuto field will be removed when updating
    public void updateIsAutoFieldThenGetException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "guid", "0002_0000000002", "key_name", "mock_key_name" });
        try {
            ciService.update(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
        }
    }

    @Transactional
    @Test
    public void updateIsNotNullableFieldThenGetException() {
        Map<String, Object> ciDataMap = MapUtils.putAll(new HashMap(), new Object[] { "guid", "0002_0000000002", "system_type", null });
        try {
            ciService.update(2, ImmutableList.of(ciDataMap));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
            Assert.assertThat(((InvalidArgumentException) ex.getExceptionHolders()
                    .get(0)
                    .getException()).getArgumentName(), equalTo("system_type"));
        }
    }

    @Transactional
    @Test
    public void deleteReferencedCiThenGetException() {
        try {
            // referenced by system and subSystem
            ciService.delete(2, Lists.newArrayList("0002_0000000001"));
            Assert.assertFalse(true);// should not be reached
        } catch (BatchChangeException ex) {
            Assert.assertThat(ex.getExceptionHolders()
                    .size(), greaterThan(0));
            Assert.assertThat(ex.getExceptionHolders()
                    .get(0)
                    .getException()
                    .getClass(), equalTo(InvalidArgumentException.class));
            InvalidArgumentException invalidExp = (InvalidArgumentException) ex.getExceptionHolders()
                    .get(0)
                    .getException();
            Assert.assertThat(invalidExp.getCauseData(), notNullValue());
            Assert.assertThat(((List) invalidExp.getCauseData()).size(), equalTo(13));
        }
    }

    @Transactional
    @Test
    public void queryReferenceByCis() {
        List<Map<String, Object>> cis = ciService.lookupReferenceByCis(2, "0002_0000000001", false);
        Assert.assertThat(cis.size(), equalTo(13));
    }

    @Transactional
    @Test
    public void queryReferenceToCis() {
        List<Map<String, Object>> cis = ciService.lookupReferenceToCis(3, "0003_0000000001");
        Assert.assertThat(cis.size(), equalTo(2));
    }

    @Transactional
    @Test
    public void queryReferenceByCisTree() {
        Map<String, Object> rootCi = ciService.recursiveGetCisTree(2, "0002_0000000001", null);
        System.out.println(JsonUtil.toJson(rootCi));
    }

}
