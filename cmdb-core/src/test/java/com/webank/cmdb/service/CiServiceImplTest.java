package com.webank.cmdb.service;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;

import javax.transaction.Transactional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.Lists;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.exception.InvalidArgumentException;

import java.util.Map;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class CiServiceImplTest extends AbstractBaseControllerTest {
    @Autowired
    private CiService ciService;

    @Transactional
    @Test(expected = InvalidArgumentException.class)
    public void whenCreateIntQueryWithNotCreatedCiTypeShouldFail() {
        IntegrationQueryDto queryDto = new IntegrationQueryDto("muti_ref_ci_a");
        queryDto.setCiTypeId(50);
        queryDto.setAttrs(Lists.newArrayList(810));
        queryDto.setAttrKeyNames(Lists.newArrayList("muti_ref_ci_a.description"));

        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto();
        adhocQuery.setCriteria(queryDto);
        adhocQuery.setQueryRequest(new QueryRequest());
        ciService.adhocIntegrateQuery(adhocQuery);
    }

    @Transactional
    @Test
    public void executeIntegrateQueryForMultiReferCiThroughReferenceByRSThenReturnResultSucessfully() {
        IntegrationQueryDto child = new IntegrationQueryDto("invoke_sequence_design");
        child.setCiTypeId(6);
        child.setAttrs(Lists.newArrayList(92));
        child.setAttrKeyNames(Lists.newArrayList("invoke_sequence_design.code"));
        child.setParentRs(new Relationship(96, false));

        IntegrationQueryDto parent = new IntegrationQueryDto("invoke_design");
        parent.setCiTypeId(5);
        parent.setAttrs(Lists.newArrayList(76));
        parent.setAttrKeyNames(Lists.newArrayList("invoke_design.code"));
        parent.setChildren(Lists.newArrayList(child));
        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto();
        adhocQuery.setCriteria(parent);
        adhocQuery.setQueryRequest(new QueryRequest());

        QueryResponse response = ciService.adhocIntegrateQuery(adhocQuery);
        assertThat(response.getContents()
                .size(), equalTo(10));
    }

    @Transactional
    @Test
    public void executeIntegrateQueryForMultiReferCiThroughReferenceRSThenReturnResultSucessfully() {
        IntegrationQueryDto child = new IntegrationQueryDto("invoke_design");
        child.setCiTypeId(5);
        child.setAttrs(Lists.newArrayList(76));
        child.setAttrKeyNames(Lists.newArrayList("invoke_design.code"));
        child.setParentRs(new Relationship(96, true));

        IntegrationQueryDto parent = new IntegrationQueryDto("invoke_sequence_design");
        parent.setCiTypeId(6);
        parent.setAttrs(Lists.newArrayList(92));
        parent.setAttrKeyNames(Lists.newArrayList("invoke_sequence_design.code"));
        parent.setChildren(Lists.newArrayList(child));

        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto();
        adhocQuery.setCriteria(parent);
        adhocQuery.setQueryRequest(new QueryRequest());

        QueryResponse response = ciService.adhocIntegrateQuery(adhocQuery);
        assertThat(response.getContents()
                .size(), equalTo(1));
    }

    @Transactional
    @Test
    public void executeAdhocIntegrateQueryWithoutResultColumnsThenReturnAllIntegrateAttributes(){
        IntegrationQueryDto subSystemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(2)
                .withAttrs(Lists.newArrayList(15,22))
                .withAttrKeyNames(Lists.newArrayList("subsys_design:guid","subsys_design:key_name"))
                .withParentRs(new Relationship(27,false));

        IntegrationQueryDto systemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(1)
                .withAttrs(Lists.newArrayList(1,8,11))
                .withAttrKeyNames(Lists.newArrayList("system_design:guid","system_design:key_name","system_design:code"))
                .withChildren(Lists.newArrayList(subSystemDesignQuery));

        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto(systemDesignQuery,new QueryRequest());
        QueryResponse<Map> response = ciService.adhocIntegrateQuery(adhocQuery);
        assertThat(response, notNullValue());
        assertThat(response.getContents().size(),equalTo(14));
        assertThat(response.getContents().get(0).size(),equalTo(5));
    }

    @Transactional
    @Test
    public void executeAdhocIntegrateQueryWithResultColumnsThenReturnSpecifiedAttributes(){
        IntegrationQueryDto subSystemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(2)
                .withAttrs(Lists.newArrayList(15,22))
                .withAttrKeyNames(Lists.newArrayList("subsys_design:guid","subsys_design:key_name"))
                .withParentRs(new Relationship(27,false));

        IntegrationQueryDto systemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(1)
                .withAttrs(Lists.newArrayList(1,8,11))
                .withAttrKeyNames(Lists.newArrayList("system_design:guid","system_design:key_name","system_design:code"))
                .withChildren(Lists.newArrayList(subSystemDesignQuery));

        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto(systemDesignQuery,
                new QueryRequest().withResultColumns(Lists.newArrayList("system_design:key_name","subsys_design:key_name")));
        QueryResponse<Map> response = ciService.adhocIntegrateQuery(adhocQuery);
        assertThat(response, notNullValue());
        assertThat(response.getContents().size(),equalTo(14));
        assertThat(response.getContents().get(0).size(),equalTo(2));
    }
}
