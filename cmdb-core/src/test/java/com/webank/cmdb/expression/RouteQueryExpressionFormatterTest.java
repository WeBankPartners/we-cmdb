package com.webank.cmdb.expression;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
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
    private RouteQueryExpressionFormatter routeQueryExpressionFormatter;

    @Before
    public void setup() {
        routeQueryExpressionFormatter = new RouteQueryExpressionFormatter(ciService.getDynamicEntityMetaMap());
    }

    @Test
    @Transactional
    public void testOneNodeFormat(){
        AdhocIntegrationQueryDto adhocIntegrationQuery = new AdhocIntegrationQueryDto();
        adhocIntegrationQuery.setCriteria(new IntegrationQueryDto("system_design",1, ImmutableList.of(1),
                ImmutableList.of("system_design:guid"),null));
        adhocIntegrationQuery.setQueryRequest(new QueryRequest().withResultColumns(ImmutableList.of("system_design:guid")));
        String expression = routeQueryExpressionFormatter.format(adhocIntegrationQuery);
        assertThat(expression, equalTo("system_design.[system_design:guid]"));

        //with one filter
        adhocIntegrationQuery.setCriteria(new IntegrationQueryDto("system_design",1, ImmutableList.of(1,8),
                null)
                .withAttrKeyNames(ImmutableList.of("system_design:guid","system_design:key_name")));
        adhocIntegrationQuery.setQueryRequest(new QueryRequest()
                .withResultColumns(ImmutableList.of("system_design:guid"))
                .addEqualsFilter("system_design:key_name","EDP"));
        expression = routeQueryExpressionFormatter.format(adhocIntegrationQuery);
        assertThat(expression, equalTo("system_design[{key_name eq 'EDP'}].[system_design:guid]"));

        //with tow filters
        adhocIntegrationQuery.setCriteria(new IntegrationQueryDto("system_design",1, ImmutableList.of(1,8,11),
                null)
                .withAttrKeyNames(ImmutableList.of("system_design:guid","system_design:key_name","system_design:code")));
        adhocIntegrationQuery.setQueryRequest(new QueryRequest()
                .withResultColumns(ImmutableList.of("system_design:guid"))
                .addEqualsFilter("system_design:key_name","EDP")
                .addEqualsFilter("system_design:code","HATS"));
        expression = routeQueryExpressionFormatter.format(adhocIntegrationQuery);
        assertThat(expression, equalTo("system_design[{key_name eq 'EDP'}{code eq 'HATS'}].[system_design:guid]"));

    }


}
