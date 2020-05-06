package com.webank.cmdb.service.impl;

import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.expression.RouteQueryExpressionParser;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.RouteQueryExpressionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class RouteQueryExpressionServiceImpl implements RouteQueryExpressionService {
    private final static Logger logger = LoggerFactory.getLogger(RouteQueryExpressionServiceImpl.class);

    @Autowired
    private CiService ciService;

    @Override
    public List executeQuery(String expression) {
        RouteQueryExpressionParser expressionParser = new RouteQueryExpressionParser(ciService.getTableDynamicEntityMetaMap());
        AdhocIntegrationQueryDto adhocIntegrationQuery = expressionParser.parse(expression);
        QueryResponse response = ciService.adhocIntegrateQuery(adhocIntegrationQuery);
        return response.getContents();
    }
}
