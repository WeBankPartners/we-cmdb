package com.webank.cmdb.expression;

import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.*;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import javax.management.Query;
import javax.transaction.Transactional;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;
import static org.junit.Assert.assertThat;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class RouteQueryExpressListenerTest extends AbstractBaseControllerTest {
    private RouteQueryExpressionParser expressParser = null;

    @Before
    public void setup() {
        super.setup();
        expressParser = new RouteQueryExpressionParser(ciService.getTableDynamicEntityMetaMap());
    }

    @Test
    @Transactional
    public void testRouteQueryParseForOneNode() {
        String expression = "system_design:code";
        IntegrationQueryDto intQuery = expressParser.parse(expression).getCriteria();
        assertThat(intQuery,notNullValue());
        assertThat(intQuery.getAttrs().size(),equalTo(1));

        expression = "system_design:[code,key_name]";
        intQuery = expressParser.parse(expression).getCriteria();
        assertThat(intQuery,notNullValue());
        assertThat(intQuery.getAttrs().size(),equalTo(2));

    }

    @Test
    @Transactional
    public void testRoutQueryParseWithCondition(){
        String expression = "subsys_design{key_name eq 'UM_CLIENT'}:guid";
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = expressParser.parse(expression);
        IntegrationQueryDto intQuery = adhocIntegrationQueryDto.getCriteria();
        assertThat(intQuery,notNullValue());
        assertThat(intQuery.getAttrs().size(),equalTo(2));
        assertThat(adhocIntegrationQueryDto.getQueryRequest().getFilters().size(),equalTo(1));
    }

    @Test
    @Transactional
    public void testRouteQueryParseForMultiConditions() {
        String expression = "system_design[{key_name eq 'EDP'},{state eq 'start'}]:code";
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = expressParser.parse(expression);
        IntegrationQueryDto intQuery = adhocIntegrationQueryDto.getCriteria();
        assertNotNull(intQuery);
        assertThat(adhocIntegrationQueryDto.getQueryRequest().getFilters().size(),equalTo(2));
        assertThat(adhocIntegrationQueryDto.getQueryRequest().getFilters().get(1),equalTo(new Filter("0_system_design.key_name","eq","EDP")));
    }

    @Test
    @Transactional
    public void testRouteQueryParseForFwdChain() {
        String expression = "subsys_design{key_name eq 'EDP'}:[key_name].system_design>system_design:guid";
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = expressParser.parse(expression);
        IntegrationQueryDto intQuery = adhocIntegrationQueryDto.getCriteria();
        QueryRequest queryRequest = adhocIntegrationQueryDto.getQueryRequest();
        assertNotNull(intQuery);
        assertTrue(intQuery.getChildren().size() > 0);
        assertTrue(intQuery.getChildren().get(0).getCiTypeId() == 1);
        assertThat(queryRequest.getResultColumns().size(), equalTo(2));

        expression = "unit_design{key_name eq 'EDP'}.subsys_design>subsys_design.system_design>system_design:state";
        adhocIntegrationQueryDto = expressParser.parse(expression);
        intQuery = adhocIntegrationQueryDto.getCriteria();
        assertNotNull(intQuery);
        assertThat(intQuery.getCiTypeId(),equalTo(3));
        assertThat(intQuery.getChildren().get(0),notNullValue());
        assertThat(intQuery.getChildren().get(0).getCiTypeId() ,equalTo(2));
        assertThat(intQuery.getChildren().get(0).getChildren().get(0),notNullValue());
        assertThat(intQuery.getChildren().get(0).getChildren().get(0).getCiTypeId(),equalTo(1));
    }

    @Test
    @Transactional
    public void testRouteQueryParseForBwdChain() {
        String expression = "system_design~(system_design)subsys_design:key_name";
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = expressParser.parse(expression);
        IntegrationQueryDto intQuery = adhocIntegrationQueryDto.getCriteria();
        assertThat(intQuery, notNullValue());
        assertThat(intQuery.getChildren().size(), equalTo(1));
        IntegrationQueryDto query_l2 = intQuery.getChildren().get(0);
        assertThat(query_l2.getCiTypeId(), equalTo(2));
        assertThat(query_l2.getParentRs(), notNullValue());
        assertThat(query_l2.getParentRs().getAttrId(), equalTo(27));
        assertThat(query_l2.getParentRs().getIsReferedFromParent(), is(false));


        expression = "system_design~(system_design)subsys_design~(subsys_design)unit_design:key_name";
        adhocIntegrationQueryDto = expressParser.parse(expression);
        intQuery = adhocIntegrationQueryDto.getCriteria();
        assertThat(intQuery, notNullValue());
        assertThat(intQuery.getChildren().size(), equalTo(1));
        query_l2 = intQuery.getChildren().get(0);
        assertThat(query_l2.getCiTypeId(), equalTo(2));
        assertThat(query_l2.getParentRs(), notNullValue());
        assertThat(query_l2.getParentRs().getAttrId(), equalTo(27));
        assertThat(query_l2.getParentRs().getIsReferedFromParent(), is(false));
        IntegrationQueryDto query_l3 = query_l2.getChildren().get(0);
        assertThat(query_l3.getCiTypeId(), equalTo(3));
        assertThat(query_l3.getParentRs(), notNullValue());
        assertThat(query_l3.getParentRs().getAttrId(), equalTo(43));
        assertThat(query_l3.getParentRs().getIsReferedFromParent(), is(false));

    }

    @Test
    @Transactional
    public void testRouteQueryParseForMixedChain() {
        String expression = "system_design~(system_design)subsys_design.system_design>system_design:key_name";
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = expressParser.parse(expression);
        IntegrationQueryDto intQuery = adhocIntegrationQueryDto.getCriteria();
        assertThat(intQuery, notNullValue());
        assertThat(intQuery.getChildren().size(),equalTo(1));
        IntegrationQueryDto query_l2 = intQuery.getChildren().get(0);
        assertThat(query_l2.getParentRs(),notNullValue());
        assertThat(query_l2.getParentRs().getIsReferedFromParent(),equalTo(false));
        assertThat(query_l2.getChildren().size(),equalTo(1));
        IntegrationQueryDto query_l3 = query_l2.getChildren().get(0);
        assertThat(query_l3.getParentRs(),notNullValue());
        assertThat(query_l3.getParentRs().getIsReferedFromParent(),equalTo(true));
        assertThat(query_l3.getChildren().size(),equalTo(0));
    }

    @Test
    @Transactional
    public void testRouteQueryParseForChainWithTailedCondition(){
        String expression = "subsys_design:guid.system_design>system_design[{guid eq '0001_0000000001'}]:key_name";
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = expressParser.parse(expression);
        IntegrationQueryDto query_l2 = adhocIntegrationQueryDto.getCriteria();;
        assertThat(query_l2.getParentRs(),nullValue());
        assertThat(query_l2.getChildren().size(),equalTo(1));
        IntegrationQueryDto query_l3 = query_l2.getChildren().get(0);
        assertThat(query_l3.getParentRs(),notNullValue());
        assertThat(query_l3.getParentRs().getIsReferedFromParent(),equalTo(true));
        assertThat(query_l3.getParentRs().getAttrId(),equalTo(27));
        assertThat(query_l3.getChildren().size(),equalTo(0));

        assertThat(query_l2.getAttrKeyNames().size(),equalTo(1));
        assertThat(query_l2.getAttrKeyNames().get(0),equalTo("0_subsys_design.guid"));
        assertThat(query_l3.getAttrKeyNames().size(),equalTo(2));
        assertThat(query_l3.getAttrKeyNames().get(0),equalTo("1_system_design.guid"));
        assertThat(query_l3.getAttrKeyNames().get(1),equalTo("1_system_design.key_name"));

        QueryRequest request = adhocIntegrationQueryDto.getQueryRequest();
        assertThat(request.getFilters().size(),equalTo(1));
        assertThat(request.getFilters().get(0).getName(),equalTo("1_system_design.guid"));
        assertThat(request.getFilters().get(0).getValue(),equalTo("0001_0000000001"));
    }

    @Ignore
    @Test
    @Transactional
    public void testQueryWithExpression(){
        String expression = "subsys_design{key_name eq 'UM_CLIENT'}:guid";
        AdhocIntegrationQueryDto adhocQuery = expressParser.parse(expression);
        QueryResponse response = ciService.adhocIntegrateQuery(adhocQuery);
        assertThat(response, notNullValue());
    }
}