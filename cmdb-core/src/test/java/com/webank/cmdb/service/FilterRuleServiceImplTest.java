package com.webank.cmdb.service;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.FilterRuleDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.util.JsonUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.Map;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.assertThat;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class FilterRuleServiceImplTest  extends AbstractBaseControllerTest {
    @Autowired
    private FilterRuleService filterRuleService;

    @Test
    @Transactional
    public void whenExecuteSimpleFilterRuleThenReturnProperResult() throws IOException {
        String filterRuleJson = readJsonFromFile("/json/filterrule/simple_rule.json");
        FilterRuleDto filterRuleDto = JsonUtil.toObject(filterRuleJson, FilterRuleDto.class);
        QueryRequest request = new QueryRequest();
        QueryResponse response = filterRuleService.queryReferenceData(filterRuleDto,request);
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(13));
    }

    @Test
    @Transactional
    public void whenExecuteSimpleFilterRuleWithAssociatedCiDataThenReturnProperResult() throws IOException{
        String filterRuleJson = readJsonFromFile("/json/filterrule/simple_rule.json");
        FilterRuleDto filterRuleDto = JsonUtil.toObject(filterRuleJson, FilterRuleDto.class);
        QueryRequest request = new QueryRequest();
        request.getDialect().setAssociatedCiData(ImmutableMap.of("mask",0));
        QueryResponse response = filterRuleService.queryReferenceData(filterRuleDto,request);
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(1));
        Map<String,Object> dataMap = (Map)response.getContents().get(0);
        assertThat(dataMap.get("guid"),equalTo("0014_0000000005"));
    }

    @Test
    @Transactional
    public void whenExecuteFilterRuleWithVariedFilterOperatorThenReturnProperResult() {
        FilterRuleDto filterRule = new FilterRuleDto();
        FilterRuleDto.FilterUnit filterUnit = new FilterRuleDto.FilterUnit();
        FilterRuleDto.RuleUnit ruleUnit = new FilterRuleDto.RuleUnit("ip_addr.network_segment>network_segment:mask", FilterOperator.Equal.getCode(),
                new FilterRuleDto.RuleRight(FilterRuleDto.RULE_RIGHT_TYPE_VALUE,16));
        filterUnit.put("filter_1",ruleUnit);
        filterRule.add(filterUnit);

        QueryResponse response = filterRuleService.queryReferenceData(filterRule,new QueryRequest());
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(1));
    }
}
