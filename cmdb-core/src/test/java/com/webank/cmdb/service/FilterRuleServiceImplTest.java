package com.webank.cmdb.service;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.FilterRuleDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.util.JsonUtil;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    public void whenExecuteSimpleFilterRuleWithoutAssociatedDataThenReturnEmptyResult() throws IOException {
        String filterRuleJson = readJsonFromFile("/json/filterrule/simple_rule.json");
        FilterRuleDto filterRuleDto = JsonUtil.toObject(filterRuleJson, FilterRuleDto.class);
        QueryRequest request = new QueryRequest();
        QueryResponse response = filterRuleService.queryReferenceData(filterRuleDto,request);
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(0));
    }

    @Test
    @Transactional
    public void whenExecuteSimpleFilterRuleWithAssociatedCiDataThenReturnProperResult() throws IOException{
        String filterRuleJson = readJsonFromFile("/json/filterrule/simple_rule.json");
        FilterRuleDto filterRuleDto = JsonUtil.toObject(filterRuleJson, FilterRuleDto.class);
        QueryRequest request = new QueryRequest();
        request.getDialect().setAssociatedData(ImmutableMap.of("network_segment_2","0021_0000000001"));
        QueryResponse response = filterRuleService.queryReferenceData(filterRuleDto,request);
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(3));
        List<String> resultGuids = ((List<Map<String,String>>)response.getContents()).stream()
                .flatMap(item-> Maps.filterKeys(item,(k)-> "guid".equalsIgnoreCase(k)).values().stream()).collect(Collectors.toList());

        assertThat(resultGuids,equalTo(Lists.newArrayList("0014_0000000001","0014_0000000003","0014_0000000004")));
    }

    @Test
    @Transactional
    public void whenExecuteFilterRuleWithVariedFilterOperatorThenReturnProperResult() {
        FilterRuleDto filterRule = new FilterRuleDto();
        FilterRuleDto.FilterUnit filterUnit = new FilterRuleDto.FilterUnit();
        FilterRuleDto.RuleUnit ruleUnit = new FilterRuleDto.RuleUnit("ip_addr.network_segment>network_segment:mask", FilterOperator.Equal.getCode(),
                new FilterRuleDto.RuleRight(FilterRuleDto.RightTypeEnum.Value.getCode(),16));
        filterUnit.put("filter_1",ruleUnit);
        filterRule.add(filterUnit);

        QueryResponse response = filterRuleService.queryReferenceData(filterRule,new QueryRequest());
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(1));
    }

    @Test
    @Transactional
    public void given2AndRelationShipFilterRulesWithOneReturnEmptyThenReturnEmptyResult(){
        FilterRuleDto filterRule = new FilterRuleDto();
        FilterRuleDto.FilterUnit filterUnit = new FilterRuleDto.FilterUnit();
        FilterRuleDto.RuleUnit ruleUnit = new FilterRuleDto.RuleUnit("ip_addr.network_segment>network_segment:mask", FilterOperator.Equal.getCode(),
                new FilterRuleDto.RuleRight(FilterRuleDto.RightTypeEnum.Value.getCode(),16));
        FilterRuleDto.RuleUnit ruleUnit2 = new FilterRuleDto.RuleUnit("ip_addr.network_segment>network_segment:name", FilterOperator.Null.getCode(), null);
        filterUnit.put("filter_1",ruleUnit);
        filterUnit.put("filter_2",ruleUnit2);
        filterRule.add(filterUnit);

        QueryResponse response = filterRuleService.queryReferenceData(filterRule,new QueryRequest());
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(0));

    }

    @Test
    @Transactional
    public void given2OrRelationShipFilterRulesThenReturnUnionResult(){
        FilterRuleDto filterRule = new FilterRuleDto();
        FilterRuleDto.FilterUnit filterUnit = new FilterRuleDto.FilterUnit();
        FilterRuleDto.RuleUnit ruleUnit = new FilterRuleDto.RuleUnit("ip_addr.network_segment>network_segment:mask", FilterOperator.Equal.getCode(),
                new FilterRuleDto.RuleRight(FilterRuleDto.RightTypeEnum.Value.getCode(),16));
        filterUnit.put("filter_1",ruleUnit);
        filterRule.add(filterUnit);

        FilterRuleDto.FilterUnit filterUnit2 = new FilterRuleDto.FilterUnit();
        FilterRuleDto.RuleUnit ruleUnit2 = new FilterRuleDto.RuleUnit("ip_addr.network_segment>network_segment:mask", FilterOperator.Equal.getCode(),
                new FilterRuleDto.RuleRight(FilterRuleDto.RightTypeEnum.Value.getCode(),0));
        filterUnit2.put("filter_1",ruleUnit2);
        filterRule.add(filterUnit2);

        QueryResponse response = filterRuleService.queryReferenceData(filterRule,new QueryRequest());
        assertThat(response.getContents(), notNullValue());
        assertThat(response.getContents().size(), equalTo(2));

    }
}
