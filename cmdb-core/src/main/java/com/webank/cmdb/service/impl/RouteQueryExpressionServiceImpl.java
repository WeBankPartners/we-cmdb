package com.webank.cmdb.service.impl;

import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.expression.RouteQueryExpressionParser;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.RouteQueryExpressionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Service
public class RouteQueryExpressionServiceImpl implements RouteQueryExpressionService {
    private final static Logger logger = LoggerFactory.getLogger(RouteQueryExpressionServiceImpl.class);

    @Autowired
    private CiService ciService;

    @Override
    public List executeQuery(String expression) {
        List queryResult = new LinkedList();
        RouteQueryExpressionParser expressionParser = new RouteQueryExpressionParser(ciService.getTableDynamicEntityMetaMap());
        AdhocIntegrationQueryDto adhocIntegrationQuery = expressionParser.parse(expression);
        QueryResponse response = ciService.adhocIntegrateQuery(adhocIntegrationQuery);
        List<Map> result = (List)response.getContents();
        if(result != null){
            result.forEach(valMap ->{
                valMap.forEach((name,value)->
                {
                    queryResult.add(value);
                });
            });
        }
        return queryResult;
    }

    @Override
    public AdhocIntegrationQueryDto parseRouteExpression(String routeExpression){
        RouteQueryExpressionParser expressionParser = new RouteQueryExpressionParser(ciService.getTableDynamicEntityMetaMap());
        AdhocIntegrationQueryDto adhocIntegrationQuery = expressionParser.parse(routeExpression);
        return adhocIntegrationQuery;
    }
}
