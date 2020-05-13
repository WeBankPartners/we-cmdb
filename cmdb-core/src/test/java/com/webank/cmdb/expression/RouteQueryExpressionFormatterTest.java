package com.webank.cmdb.expression;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.service.CiService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import javax.transaction.Transactional;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class RouteQueryExpressionFormatterTest extends AbstractBaseControllerTest {
    @Autowired
    private CiService ciService;
    
    private RouteQueryExpressionFormatter routeQueryExpressionFormatter;

//    @Before
    public void setup() {
        routeQueryExpressionFormatter = new RouteQueryExpressionFormatter(ciService.getDynamicEntityMetaMap());
    }

    @Test
    @Transactional
    public void testOneNodeFormat(){
        setup();
        AdhocIntegrationQueryDto adhocIntegrationQuery = new AdhocIntegrationQueryDto();
        adhocIntegrationQuery.setCriteria(new IntegrationQueryDto("system_design",1, ImmutableList.of(1),
                ImmutableList.of("system_design:guid"),null)
                .withAttrKeyNames(Lists.newArrayList("system_design:guid")));
        adhocIntegrationQuery.setQueryRequest(new QueryRequest().withResultColumns(ImmutableList.of("system_design:guid")));
        String expression = routeQueryExpressionFormatter.format(adhocIntegrationQuery);
        assertThat(expression, equalTo("system_design:[guid]"));

        //with one filter
        adhocIntegrationQuery.setCriteria(new IntegrationQueryDto("system_design",1, ImmutableList.of(1,8),
                null)
                .withAttrKeyNames(ImmutableList.of("system_design.guid","system_design.key_name")));
        adhocIntegrationQuery.setQueryRequest(new QueryRequest()
                .withResultColumns(ImmutableList.of("system_design.guid"))
                .addEqualsFilter("system_design.key_name","EDP"));
        expression = routeQueryExpressionFormatter.format(adhocIntegrationQuery);
        assertThat(expression, equalTo("system_design[{key_name eq 'EDP'}]:[guid]"));

        //with tow filters
        adhocIntegrationQuery.setCriteria(new IntegrationQueryDto("system_design",1, ImmutableList.of(1,8,11),
                null)
                .withAttrKeyNames(ImmutableList.of("system_design.guid","system_design.key_name","system_design.code")));
        adhocIntegrationQuery.setQueryRequest(new QueryRequest()
                .withResultColumns(ImmutableList.of("system_design.guid"))
                .addEqualsFilter("system_design.key_name","EDP")
                .addEqualsFilter("system_design.code","HATS"));
        expression = routeQueryExpressionFormatter.format(adhocIntegrationQuery);
        assertThat(expression, equalTo("system_design[{key_name eq 'EDP'}{code eq 'HATS'}]:[guid]"));

    }

    @Test
    @Transactional
    public void formatBackwardNodeIntegrateQuery(){
        setup();
        IntegrationQueryDto subSystemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(2)
                .withAttrs(Lists.newArrayList(15,22))
                .withAttrKeyNames(Lists.newArrayList("subsys_design.guid","subsys_design.key_name"))
                .withParentRs(new Relationship(27,false));

        IntegrationQueryDto systemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(1)
                .withAttrs(Lists.newArrayList(1,8,11))
                .withAttrKeyNames(Lists.newArrayList("system_design.guid","system_design.key_name","system_design.code"))
                .withChildren(Lists.newArrayList(subSystemDesignQuery));

        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto(systemDesignQuery,
                new QueryRequest().withResultColumns(Lists.newArrayList("subsys_design.key_name")));

        String expression = routeQueryExpressionFormatter.format(adhocQuery);
        assertThat(expression, equalTo("system_design~(system_design)subsys_design:[key_name]"));
    }

    @Test
    @Transactional
    public void formatForwardNodeIntegrateQuery(){
        setup();
        IntegrationQueryDto systemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(1)
                .withAttrs(Lists.newArrayList(1,8,11))
                .withAttrKeyNames(Lists.newArrayList("system_design.guid","system_design.key_name","system_design.code"))
                .withParentRs(new Relationship(27,true));

        IntegrationQueryDto subSystemDesignQuery = new IntegrationQueryDto()
                .withCiTypeId(2)
                .withAttrs(Lists.newArrayList(15,22))
                .withAttrKeyNames(Lists.newArrayList("subsys_design.guid","subsys_design.key_name"))
                .withChildren(Lists.newArrayList(systemDesignQuery));


        AdhocIntegrationQueryDto adhocQuery = new AdhocIntegrationQueryDto(subSystemDesignQuery,
                new QueryRequest().withResultColumns(Lists.newArrayList("subsys_design.key_name")));

        String expression = routeQueryExpressionFormatter.format(adhocQuery);
        assertThat(expression, equalTo("subsys_design:[key_name].system_design>system_design"));
    }

}
