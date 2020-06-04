package com.webank.cmdb.service;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;

import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.transaction.Transactional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.domain.AdmIntegrateTemplate;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto.Criteria;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto.CriteriaCiTypeAttr;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto.CriteriaNode;
import com.webank.cmdb.dto.IntQueryOperateAggResponseDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmIntegrateTemplateRepository;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class IntegrationQueryServiceImplTest extends LegacyAbstractBaseControllerTest {
    @Autowired
    private IntegrationQueryService integrationQueryService;
    @Autowired
    private AdmIntegrateTemplateRepository intTempRepository;
    @Autowired
    private CiService ciService;
    @Autowired
    private CiTypeService ciTypeService;

    @Test(expected = InvalidArgumentException.class)
    public void whenCreateIntQueryWithNotCreatedCiTypeShouldFail() {
        IntegrationQueryDto admLog = new IntegrationQueryDto("admLog", 1, Arrays.asList(1), null);
        int queryId = integrationQueryService.createIntegrationQuery(1, "Test query log", admLog);
        intTempRepository.getOne(queryId);
    }

    @Test
    public void whenCreateIntQueryWithCreatedCiTypeShouldSuccess() {
        ciTypeService.applyCiType(Lists.newArrayList(1));
        IntegrationQueryDto admLog = new IntegrationQueryDto("admLog", 1, Arrays.asList(1), null);
        int queryId = integrationQueryService.createIntegrationQuery(1, "Test query log", admLog);
        AdmIntegrateTemplate intTemplate = intTempRepository.getOne(queryId);
        assertThat(intTemplate, notNullValue());
    }

    @Test
    @Transactional
    public void createIntegrationQueryThenReturnQueryId() {
        IntegrationQueryDto unitQuery = new IntegrationQueryDto("Unit", 5, Arrays.asList(21), new Relationship(50, true));
        IntegrationQueryDto subSysQuery = new IntegrationQueryDto("Subsystem Query", 3, Arrays.asList(18), null);
        subSysQuery.addChild(unitQuery);

        int queryId = integrationQueryService.createIntegrationQuery(5, "Test query", subSysQuery);
        AdmIntegrateTemplate intTemplate = intTempRepository.getOne(queryId);

        assertThat(intTemplate, notNullValue());
        assertThat(intTemplate.getCiTypeId(), equalTo(5));
        assertThat(intTemplate.getAdmIntegrateTemplateAlias()
                .get(0)
                .getCiTypeId(), equalTo(3));
    }

    @Test
    public void getIntegrationQueryByIdThenReturnProperDto() {
        IntegrationQueryDto grandson1 = new IntegrationQueryDto("3-1-System-null", 2, Arrays.asList(7), new Relationship(9, false));
        IntegrationQueryDto grandson2 = new IntegrationQueryDto("3-2-Sub System-System ID", 3, Arrays.asList(11), new Relationship(23, false));

        IntegrationQueryDto child = new IntegrationQueryDto("2-1-System-null", 2, new LinkedList(), new Relationship(9, false));
        child.addChild(grandson1);
        child.addChild(grandson2);

        IntegrationQueryDto query = new IntegrationQueryDto("1-System", 2, new LinkedList(), null);
        query.addChild(child);
        int queryId = integrationQueryService.createIntegrationQuery(2, "Test query", query);
        IntegrationQueryDto dto = integrationQueryService.getIntegrationQuery(queryId);
        assertThat(dto, notNullValue());
        assertThat(dto.getChildren()
                .get(0)
                .getChildren()
                .get(0)
                .getName(), equalTo("3-1-System-null"));
        assertThat(dto.getChildren()
                .get(0)
                .getChildren()
                .get(1)
                .getName(), equalTo("3-2-Sub System-System ID"));
        assertThat(dto.getChildren()
                .get(0)
                .getChildren()
                .get(1)
                .getParentRs()
                .getIsReferedFromParent(), equalTo(false));
        assertThat(dto.getChildren()
                .get(0)
                .getChildren()
                .get(0)
                .getAttrAliases()
                .get(0)
                .length(), greaterThan(0));
        Set<String> attrAliases = new HashSet<>();
        assertThat(getAllAttrAlias(dto, attrAliases).size(), greaterThan(0));
    }

    private Set<String> getAllAttrAlias(IntegrationQueryDto queryDto, Set<String> attrAliases) {
        queryDto.getAttrAliases()
                .forEach(x -> {
                    attrAliases.add(x);
                });

        for (IntegrationQueryDto child : queryDto.getChildren()) {
            return getAllAttrAlias(child, attrAliases);
        }
        return attrAliases;
    }

    @Transactional
    @Test
    public void createAggregationQueryThenReturnProperResponse() {
        CriteriaCiTypeAttr attr = new CriteriaCiTypeAttr();
        attr.setAttrId(35);
        attr.setCondition(true);
        attr.setDisplayed(true);

        Criteria criteria = new Criteria();
        criteria.setBranchId("100");
        criteria.setAttribute(attr);
        // criteria.setCiTypeId(5);
        // criteria.setCiTypeName("Unit");

        List<CriteriaNode> routine = ImmutableList.<CriteriaNode>of(new CriteriaNode(3), new CriteriaNode(4, new Relationship(24, true)));

        criteria.setRoutine(routine);

        IntQueryOperateAggRequetDto aggRequest = new IntQueryOperateAggRequetDto();
        aggRequest.setOperation("create");
        aggRequest.setQueryDesc("Plugin test");
        aggRequest.setQueryName("Plugin query");
        aggRequest.getCriterias()
                .add(criteria);
        System.out.println("aggRequest= " + aggRequest.toString());

        List<IntQueryOperateAggResponseDto> response = integrationQueryService.operateAggregationQuery(3, Arrays.asList(aggRequest));

        assertThat(response.size(), greaterThan(0));
        assertThat(response.get(0)
                .getBranchs()
                .size(), greaterThan(0));
        assertThat(response.get(0)
                .getBranchs()
                .get(0)
                .getBranchId(), notNullValue());
        System.out.println("response= " + response.toString());

        QueryResponse queryResp = ciService.integrateQuery(response.get(0)
                .getQueryId(), new QueryRequest());
        assertThat(queryResp.getContents(), notNullValue());

    }

    @Test
    @Transactional
    public void create1LevelAggIntegrationQueryThenReturnQueryId() {
        CriteriaCiTypeAttr attr = new CriteriaCiTypeAttr();
        attr.setAttrId(48);
        attr.setCondition(true);
        attr.setDisplayed(true);

        Criteria criteria = new Criteria();
        criteria.setBranchId("100");
        criteria.setAttribute(attr);
        // criteria.setCiTypeId(5);
        criteria.setCiTypeName("Unit");
        criteria.setRoutine(Lists.newArrayList(new CriteriaNode(5)));

        IntQueryOperateAggRequetDto aggRequest = new IntQueryOperateAggRequetDto();
        aggRequest.setOperation("create");
        aggRequest.setQueryDesc("Plugin test");
        aggRequest.setQueryName("Plugin query");
        aggRequest.getCriterias()
                .add(criteria);

        List<IntQueryOperateAggResponseDto> response = integrationQueryService.operateAggregationQuery(5, Arrays.asList(aggRequest));
        assertThat(response.size(), greaterThan(0));
    }

}
