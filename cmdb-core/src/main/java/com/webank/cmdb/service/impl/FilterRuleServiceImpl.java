package com.webank.cmdb.service.impl;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.*;
import com.webank.cmdb.dto.FilterRuleDto.FilterUnit;
import com.webank.cmdb.dto.FilterRuleDto.RuleRight;
import com.webank.cmdb.dto.FilterRuleDto.RuleUnit;
import com.webank.cmdb.expression.RouteQueryExpressionFormatter;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.service.FilterRuleService;
import com.webank.cmdb.service.RouteQueryExpressionService;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.util.JsonUtil;
import io.swagger.models.auth.In;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;

@Service
public class FilterRuleServiceImpl implements FilterRuleService {
    private final static Logger logger = LoggerFactory.getLogger(FilterRuleServiceImpl.class);

    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;

    @Autowired
    private CiServiceImpl ciService;

    @Autowired
    private RouteQueryExpressionService routeQueryExpressionService;

    @Override
    public QueryResponse<?> queryReferenceCiData(int referenceAttrId, QueryRequest request) {
        AdmCiTypeAttr attrWithFilterRule = ciTypeAttrRepository.getOne(referenceAttrId);
        if (attrWithFilterRule == null) {
            throw new InvalidArgumentException(String.format("Can not find ciTypeAttr by given attr id [%s].", referenceAttrId));
        }

        if (!(InputType.Reference.getCode().equals(attrWithFilterRule.getInputType()) || InputType.MultRef.getCode().equals(attrWithFilterRule.getInputType()))) {
            throw new InvalidArgumentException(String.format("The given attr is invalid as it's input type is [%s], required input type must be 'ref' or 'multiRef'.", attrWithFilterRule.getInputType()));
        }

        String filterRuleString = attrWithFilterRule.getFilterRule();
        if (StringUtils.isBlank(filterRuleString)) {
            return ciService.query(attrWithFilterRule.getCiTypeId(), request);
        } else {
            FilterRuleDto filterRuleDto = null;
            try {
                filterRuleDto = JsonUtil.toObject(filterRuleString,FilterRuleDto.class);
            } catch (IOException e) {
                throw new CmdbException("Can not parse filter rule json.",e);
            }
            return queryReferenceData(filterRuleDto, request);
        }
    }

    public QueryResponse queryReferenceData(FilterRuleDto filterRule, QueryRequest request) {
        Map<String, Object> associatedCiData = new HashMap<>();
        if (request.getDialect() != null) {
            //TODO: rename data
            associatedCiData = request.getDialect().getAssociatedData();
        }

        List<Object> results = handleAsOrRelationship(filterRule, request, associatedCiData);

        return getResultWithPaging(request, results);
    }

    @Override
    public void validateJsonString(String filterRuleJson) {
        if(Strings.isNullOrEmpty(filterRuleJson))
            return;

        FilterRuleDto filterRule = null;
        try {
            filterRule = JsonUtil.toObject(filterRuleJson,FilterRuleDto.class);
        } catch (IOException e) {
            throw new CmdbException("Filter rule json string is invalid.",e);
        }

        for (FilterUnit filterUnit : filterRule) {
            filterUnit.forEach((name,ruleUnit)->{
                String leftExpr = ruleUnit.getLeft();
                AdhocIntegrationQueryDto leftIntegrationQuery;
                try {
                    leftIntegrationQuery = routeQueryExpressionService.parseRouteExpression(leftExpr);
                    List<String> resultColumns = leftIntegrationQuery.getQueryRequest().getResultColumns();
                    if(resultColumns.size() != 1){
                        throw new CmdbException(String.format("Left expression should contain only one result column. (%s)",leftExpr));
                    }
                }catch (Exception ex){
                    throw new CmdbException(String.format("Left expression is invalid. (%s)",leftExpr),ex);
                }
                String filterOperatorCode = ruleUnit.getOperator();
                FilterOperator filterOperator = FilterOperator.fromCode(filterOperatorCode);
                if(filterOperator == FilterOperator.None){
                    throw new CmdbException(String.format("Filter operator is invalid. (%s)",filterOperatorCode));
                }

                validateRuleRight(ruleUnit,leftIntegrationQuery);
            });
        }

    }

    @Override
    public FilterRuleDto convertLegacyFilterRule(String legacyRule) {
        RouteQueryExpressionFormatter routeQueryExpressionFormatter = new RouteQueryExpressionFormatter(ciService.getDynamicEntityMetaMap());
        try {
            List<Map> ruleList = JsonUtil.toList(legacyRule,Map.class);
            FilterRuleDto filterRuleDto = new FilterRuleDto();
            for (Map map : ruleList) {
                FilterUnit filterUnit = new FilterUnit();
                Map<String,Map> ruleMap = (Map<String,Map>)map;
                for(Map.Entry<String,Map> kv : ruleMap.entrySet()){
                    String name = kv.getKey();
                    Map valueMap = kv.getValue();

                    RuleUnit ruleUnit = new RuleUnit();
                    Map legacyUnitMap = (Map)valueMap;
                    String leftExprs = (String) legacyUnitMap.get("left");
                    List<Map> leftQueryChain = JsonUtil.toList(leftExprs,Map.class);
                    AdhocIntegrationQueryDto leftAdhocIntegrationQuery = convertLegacyQueryChain(leftQueryChain);
                    String leftRouteQueryExpr = routeQueryExpressionFormatter.format(leftAdhocIntegrationQuery);
                    ruleUnit.setLeft(leftRouteQueryExpr);
                    ruleUnit.setOperator("in");

                    String legacyOperator = (String)legacyUnitMap.get("operator");
                    Object rightValue = legacyUnitMap.get("right");
                    if(rightValue instanceof String){
                        String rightExpr = (String)rightValue;
                        List<Map> rightQueryChain = JsonUtil.toList(rightExpr,Map.class);
                        AdhocIntegrationQueryDto rightAdhocIntegrationQuery = convertLegacyQueryChain(rightQueryChain);
                        String rightRouteQueryExpr = routeQueryExpressionFormatter.format(rightAdhocIntegrationQuery);
                        ruleUnit.setRight(new RuleRight(FilterRuleDto.RightTypeEnum.Expression.getCode(),rightRouteQueryExpr));
                    }else if(rightValue instanceof List){
                        ruleUnit.setRight(new RuleRight(FilterRuleDto.RightTypeEnum.Array.getCode(),rightValue));
                    }
                    filterUnit.put(name,ruleUnit);
                }
                filterRuleDto.add(filterUnit);
            }
            return filterRuleDto;
        } catch (IOException e) {
            logger.warn(String.format("Fail to convert legacy filter rule: (%s)",legacyRule),e);
            return null;
        }
    }

    private AdhocIntegrationQueryDto convertLegacyQueryChain(List<Map> legacyQueryChain){
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = new AdhocIntegrationQueryDto();
        IntegrationQueryDto rootIntegrationQuery = null;
        IntegrationQueryDto prevIntegrationQuery = null;
        for (int i=0;i<legacyQueryChain.size();i++) {
            IntegrationQueryDto curIntegrationQuery = new IntegrationQueryDto();
            Map curQuery = (Map)legacyQueryChain.get(i);
            Integer ciTypeId = (Integer) curQuery.get("ciTypeId");
            curIntegrationQuery.setCiTypeId(ciTypeId);
            Map parentRs = (Map)curQuery.get("parentRs");
            if(parentRs != null){
                Integer attrId = (Integer) parentRs.get("attrId");
                Integer isReferedFromParent = (Integer) parentRs.get("isReferedFromParent");
                if(i < legacyQueryChain.size()-1) {
                    curIntegrationQuery.setParentRs(new Relationship(attrId, new Integer(1).equals(isReferedFromParent)));
                }else{//last query in chain
                    AdmCiTypeAttr ciTypeAttr = ciTypeAttrRepository.getOne(attrId);
                    String attrName = ciTypeAttr.getPropertyName();
                    prevIntegrationQuery.getAttrs().add(attrId);
                    prevIntegrationQuery.getAttrKeyNames().add(attrName);
                    adhocIntegrationQueryDto.getQueryRequest().getResultColumns().add(attrName);
                }
            }

            if(i==0){
                rootIntegrationQuery = curIntegrationQuery;
                prevIntegrationQuery = curIntegrationQuery;
            }else if(i< legacyQueryChain.size()-1){
                prevIntegrationQuery.getChildren().add(curIntegrationQuery);
                prevIntegrationQuery = curIntegrationQuery;
            }
        }
        adhocIntegrationQueryDto.setCriteria(rootIntegrationQuery);
        return adhocIntegrationQueryDto;
    }

    private Integer getLastNodeCiTypeId(AdhocIntegrationQueryDto adhocIntegrationQuery){
        IntegrationQueryDto integrationQuery = adhocIntegrationQuery.getCriteria();
        Integer ciTypeId = integrationQuery.getCiTypeId();
        while(integrationQuery.getChildren().size()>0){
            integrationQuery = integrationQuery.getChildren().get(0);
            ciTypeId = integrationQuery.getCiTypeId();
        }
        return ciTypeId;
    }

    private Integer getLastNodeAttrId(AdhocIntegrationQueryDto adhocIntegrationQuery){
        IntegrationQueryDto integrationQuery = adhocIntegrationQuery.getCriteria();
        String resultColumn = adhocIntegrationQuery.getQueryRequest().getResultColumns().get(0);

        while(integrationQuery.getChildren().size()>0){
            integrationQuery = integrationQuery.getChildren().get(0);
        }

        for (int i=0;i<integrationQuery.getAttrKeyNames().size();i++){
            String attrKeyName = integrationQuery.getAttrKeyNames().get(i);
            if(attrKeyName.equalsIgnoreCase(resultColumn)){
                return integrationQuery.getAttrs().get(i);
            }

        }
        throw new CmdbException("Can not find out last node attr id.");
    }

    private void validateRuleRight(RuleUnit ruleUnit,AdhocIntegrationQueryDto leftIntegrationQuery) {
        RuleRight ruleRight = ruleUnit.getRight();
        String typeCode = ruleRight.getType();
        FilterRuleDto.RightTypeEnum rightType = FilterRuleDto.RightTypeEnum.fromCode(typeCode);
        Object rightValue = ruleRight.getValue();
        if(rightType == FilterRuleDto.RightTypeEnum.None){
            throw new CmdbException(String.format("Type (%s) is invalid.",typeCode));
        }else if(rightType == FilterRuleDto.RightTypeEnum.Expression){
            if(!(rightValue instanceof  String)){
                throw new CmdbException("Right value should be String for expression type.");
            }
            String rightExpression = (String)rightValue;
            try {
                AdhocIntegrationQueryDto rightAdhocIntegrationQuery = routeQueryExpressionService.parseRouteExpression(rightExpression);
                List<String> resultColumns = rightAdhocIntegrationQuery.getQueryRequest().getResultColumns();
                if(resultColumns.size() != 1){
                    throw new CmdbException(String.format("Right expression should contain only one result column. (%s)",rightExpression));
                }
                Integer leftLastCiTypeId = getLastNodeCiTypeId(leftIntegrationQuery);
                Integer rightLastCiTypeId = getLastNodeCiTypeId(rightAdhocIntegrationQuery);
                if(!leftLastCiTypeId.equals(rightLastCiTypeId)){
                    throw new CmdbException("The last node CI type is not matched for left and right expression");
                }

                Integer leftResultAttrId = getLastNodeAttrId(leftIntegrationQuery);
                Integer rightResultAttrId = getLastNodeAttrId(rightAdhocIntegrationQuery);
                if(!leftResultAttrId.equals(rightResultAttrId)){
                    throw new CmdbException("The last node result attribute is not matched for left and right expression.");
                }

            }catch(Exception ex){
                throw new CmdbException(String.format("Right expression is invalid. (%s)",rightExpression),ex);
            }
        }else if(rightType == FilterRuleDto.RightTypeEnum.Array){
            if(!(rightValue instanceof List)){
                throw new CmdbException(String.format("Right value should be list."));
            }
        }else if(rightType == FilterRuleDto.RightTypeEnum.Value){
            if(!(rightValue instanceof  String || rightValue instanceof Number)){
                throw new CmdbException("Right value should be String or Number for value type.");
            }
        }
    }

    private QueryResponse<?> getResultWithPaging(QueryRequest request, List<Object> results) {
        QueryResponse<Object> response = new QueryResponse<>();
        if (request.getPageable() != null) {
            int startIndex = request.getPageable().getStartIndex();
            int pageSize = request.getPageable().getPageSize();
            List<Object> pageableResults = results.subList(startIndex * pageSize, (startIndex + 1) * pageSize > results.size() ? results.size() : (startIndex + 1) * pageSize);
            response.setPageInfo(new PageInfo(results.size(), startIndex, pageSize));
            response.setContents(pageableResults);
        } else {
            response.setPageInfo(new PageInfo(results.size(), 0, results.size()));
            response.setContents(results);
        }
        return response;
    }

    private List<Object> handleAsOrRelationship(FilterRuleDto filterRule, QueryRequest request, Map<String, Object> associatedCiData){
        List<Object> resultValues = new ArrayList<>();

        for (FilterUnit filterUnit : filterRule) {
            List ruleResults = handleAsAndRelationship(filterUnit, request, associatedCiData);
            resultValues = unionResult(resultValues,ruleResults);
        }
        return resultValues;
    }

    private List<Object> unionResult(List<Object> originalValues, List<Object> newValues) {
        List<Object> finalValues = new LinkedList<>();
        if(originalValues.size()>0){
            originalValues.forEach(value -> {
                if (value instanceof Map) {
                    Map<String, Object> map = (Map) value;
                    newValues.forEach(newValue -> {
                        Map<String, Object> newMap = (Map) newValue;
                        if (!newMap.values().contains(map.get("key_name"))) {
                            finalValues.add(value);
                        }
                    });
                }
            });
        }else{
            finalValues.addAll(newValues);
        }
        return finalValues;
    }

    private List<Object> intersetResult(List<Object> originalValues, List<Object> newValues) {
        List<Object> finalValues = new LinkedList<>();
        originalValues.forEach(value -> {
            if (value instanceof Map) {
                Map<String, Object> map = (Map) value;
                newValues.forEach(newValue -> {
                    Map<String, Object> newMap = (Map) newValue;
                    if (newMap.values().contains(map.get("key_name"))) {
                        finalValues.add(value);
                    }
                });
            }
        });
        return finalValues;
    }

    private List<Object> handleAsAndRelationship(FilterUnit filterUnit, QueryRequest request, Map<String, Object> associatedCiData){
        List<Object> result = Lists.newLinkedList();
        for(Map.Entry<String,RuleUnit> entry : filterUnit.entrySet()){
            String filterName = entry.getKey();
            RuleUnit ruleUnit = entry.getValue();

            List<Object> filterUnitResult = processRuleUnit(ruleUnit, request, associatedCiData);
            if(result.size()==0){
                result.addAll(filterUnitResult);
            }else {
                result = intersetResult(result,filterUnitResult);
            }
        }

        return result;
    }

    private List<Object> processRuleUnit(RuleUnit ruleUnit, QueryRequest request, Map<String, Object> associatedCiData){
        String leftExpression = ruleUnit.getLeft();
        AdhocIntegrationQueryDto leftAdhocIntegrationQuery = routeQueryExpressionService.parseRouteExpression(leftExpression);


        IntegrationQueryDto integrationQuery = leftAdhocIntegrationQuery.getCriteria();
        QueryRequest leftQueryRequest = leftAdhocIntegrationQuery.getQueryRequest();
        List<String> resultColumns = leftQueryRequest.getResultColumns();
        if(resultColumns == null || resultColumns.size()!=1){
            throw new CmdbException(String.format("Result columns list size is not 1. (%s) ",leftExpression));
        }

        String exprResultColumn = resultColumns.get(0);
        //clean existing result filed, which will be filter with right result values
        resultColumns.clear();
        updateResultColumnsForRootCiType(integrationQuery, resultColumns);

        List<Filter> filtersWithRightValues = buildQueryConditionWithRuleRight(ruleUnit, request, associatedCiData, leftQueryRequest, exprResultColumn);
        boolean emptyResultFilter = containEmptyResultFilter(filtersWithRightValues);
        if(emptyResultFilter){
            return Lists.newArrayList();
        }

        leftQueryRequest.setFilters(filtersWithRightValues);


        QueryResponse response = ciService.adhocIntegrateQuery(leftAdhocIntegrationQuery);
        return response.getContents();
    }

    private boolean containEmptyResultFilter(List<Filter> filtersWithRightValues) {
        boolean emptyResultFilter = false;
        if(filtersWithRightValues.size()>0){
            for (Filter filtersWithRightValue : filtersWithRightValues) {
                Object value = filtersWithRightValue.getValue();
                if(FilterOperator.In.getCode().equalsIgnoreCase(filtersWithRightValue.getOperator())){
                    if( value == null || ((List)value).size()==0){
                        emptyResultFilter = true;
                    }
                }
            }
        }
        return emptyResultFilter;
    }

    private List<Filter> buildQueryConditionWithRuleRight(RuleUnit ruleUnit, QueryRequest request, Map<String, Object> associatedCiData, QueryRequest queryRequest, String exprResultColumn) {
        List<Filter> filters = Lists.newLinkedList();
        Filter rightValFilter = null;

        RuleRight ruleRight = ruleUnit.getRight();
        String operator = ruleUnit.getOperator();
        FilterOperator filterOperator = FilterOperator.fromCode(operator);
        if(filterOperator == FilterOperator.None){
            throw new CmdbException(String.format("Filter operator (%s) is not supported.",operator));
        }

        switch (filterOperator){
            case Contains:
            case LIKE: {
                if (ruleRight.getType() != FilterRuleDto.RightTypeEnum.Value.getCode()) {
                    throw new CmdbException(String.format("Filter right type should be string. (%s)", ruleRight.getType()));
                }
                Object rightVal = processRuleRight(ruleRight, request, associatedCiData);
                if (!(rightVal instanceof String)) {
                    throw new CmdbException(String.format("Only support String (%s) for Contains and Like operator .", rightVal.getClass().toString()));
                }
                rightValFilter = new Filter(exprResultColumn, filterOperator.getCode(), rightVal);
            }
                break;
            case Empty:
            case Null:
            case NotNull:
            case NotEmpty:
                rightValFilter = new Filter(exprResultColumn,filterOperator.getCode(),null);
                break;
            case Equal:
            case NotEqual: {
                Object rightVal = processRuleRight(ruleRight, request, associatedCiData);
                if(!(rightVal instanceof String || rightVal instanceof Number)){
                    throw new CmdbException(String.format("Only support String and Number for Equal/NotEqual. current type is (%s)",rightVal.getClass().toString()));
                }
                rightValFilter = new Filter(exprResultColumn, filterOperator.getCode(),rightVal);
            }
                break;
            case Greater:
            case Less:
            case LessEqual:
            case GreaterEqual:{
                Object rightVal = processRuleRight(ruleRight, request, associatedCiData);
                if(!(rightVal instanceof Number)){
                    throw new CmdbException(String.format("Only support number for Greater/GreaterEqual/Less/LessEqual. Current type is (%s)",rightVal.getClass().toString()));
                }
                rightValFilter = new Filter(exprResultColumn, filterOperator.getCode(),rightVal);
            }
                break;
            case In:
                List<Map> rightValList = (List<Map>) processRuleRight(ruleRight,request,associatedCiData);
                List<Object> filterValues = Lists.newArrayList();

                rightValList.forEach(map -> {
                    Object value = map.values().toArray()[0];
                    if(!filterValues.contains(value)){
                        filterValues.add(value);
                    }
                });
                rightValFilter = new Filter(exprResultColumn,FilterOperator.In.getCode(),filterValues);
                break;
        }
        filters.add(rightValFilter);
        return filters;
    }

    /**
     * Need query guid and key name of root CiType
     * @param integrationQuery
     * @param resultColumns
     */
    private void updateResultColumnsForRootCiType(IntegrationQueryDto integrationQuery, List<String> resultColumns) {
        AdmCiTypeAttr guidAttr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(integrationQuery.getCiTypeId(),"guid");
        AdmCiTypeAttr keyNameAttr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(integrationQuery.getCiTypeId(),"key_name");
        if(!integrationQuery.getAttrs().contains(guidAttr.getIdAdmCiTypeAttr())){
            integrationQuery.getAttrs().add(guidAttr.getIdAdmCiTypeAttr());
            integrationQuery.getAttrKeyNames().add(guidAttr.getPropertyName());
        }
        resultColumns.add(guidAttr.getPropertyName());
        if(!integrationQuery.getAttrs().contains(keyNameAttr.getIdAdmCiTypeAttr())){
            integrationQuery.getAttrs().add(keyNameAttr.getIdAdmCiTypeAttr());
            integrationQuery.getAttrKeyNames().add(keyNameAttr.getPropertyName());
        }
        resultColumns.add(keyNameAttr.getPropertyName());
    }

    private Object processRuleRight(RuleRight ruleRight,QueryRequest request, Map<String, Object> associatedCiData){
        FilterRuleDto.RightTypeEnum rightTypeEnum = FilterRuleDto.RightTypeEnum.fromCode(ruleRight.getType());
        switch (rightTypeEnum){
            case Expression:
                return processRuleRightAsExpression((String) ruleRight.getValue(),request,associatedCiData);
            case Array:
                if(!(ruleRight.getValue() instanceof  List)){
                    throw new CmdbException(String.format("Right value is not list for type (%s).",ruleRight.getType()));
                }
                return ruleRight.getValue();
            case Value:
                if(!(ruleRight.getValue() instanceof  String || ruleRight.getValue() instanceof Number)){
                    throw new CmdbException(String.format("Right value is not String/Number for type (%s).",ruleRight.getType()));
                }
                return ruleRight.getValue();
            default:
                throw new CmdbException(String.format("Not support type of rule right (%s).",ruleRight.getType()));
        }
    }

    private List<Map<String, Object>> processRuleRightAsExpression(String expression, QueryRequest request, Map<String, Object> associatedCiData) {
        AdhocIntegrationQueryDto adhocIntegrationQuery = routeQueryExpressionService.parseRouteExpression(expression);
        IntegrationQueryDto integrationQuery = adhocIntegrationQuery.getCriteria();
        QueryRequest queryRequest = adhocIntegrationQuery.getQueryRequest();

        List<Map<String, Object>> contents = new LinkedList<>();
        String associatedFieldName = getAssociateFilterName(integrationQuery);
        if(Strings.isNullOrEmpty(associatedFieldName)){
            logger.error(String.format("Can not find out associated field name, please check. (%s)",expression));
            return Lists.newArrayList();
        }

        String associateValue = String.valueOf(associatedCiData.get(associatedFieldName));
        AdhocIntegrationQueryDto exprAdhocIntegrateQuery = getRightRuleExpressionQuery(adhocIntegrationQuery,associateValue);

        QueryResponse ret = ciService.adhocIntegrateQuery(exprAdhocIntegrateQuery);
        if (ret != null) {
            contents = ret.getContents();
        }
        return contents;
    }

    private AdhocIntegrationQueryDto getRightRuleExpressionQuery(AdhocIntegrationQueryDto adhocIntegrationQuery, String associateValue) {
        IntegrationQueryDto rootIntegrationQuery = adhocIntegrationQuery.getCriteria();
        QueryRequest queryRequest = adhocIntegrationQuery.getQueryRequest();

        if(rootIntegrationQuery.getChildren().size() != 1){
            throw new CmdbException("Invalid expression for filter rule. The children size is incorrect.");
        }

        IntegrationQueryDto integrationQueryDto = rootIntegrationQuery.getChildren().get(0);
        String rootKeyName = rootIntegrationQuery.getKeyName();
        List<Filter> filters = Lists.newLinkedList();
        for (Filter filter : queryRequest.getFilters()) {
            if(!filter.getName().startsWith(rootKeyName+".")){
                filters.add(filter);
            }
        }

        AdmCiTypeAttr attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(integrationQueryDto.getCiTypeId(),"guid");
        if(!integrationQueryDto.getAttrs().contains(attr.getIdAdmCiTypeAttr())){
            integrationQueryDto.getAttrs().add(attr.getIdAdmCiTypeAttr());
            integrationQueryDto.getAttrKeyNames().add(integrationQueryDto.getKeyName()+"."+attr.getPropertyName());
        }

        filters.add(new Filter(integrationQueryDto.getKeyName()+"."+"guid",FilterOperator.Equal.getCode(),associateValue));
        queryRequest.setFilters(filters);

        List<String> resultColumns = Lists.newLinkedList();
        for (String resultColumn : queryRequest.getResultColumns()) {
            if(!resultColumn.startsWith(rootKeyName+".")){
                resultColumns.add(resultColumn);
            }
        }
        queryRequest.setResultColumns(resultColumns);

        integrationQueryDto.setParentRs(null);
        AdhocIntegrationQueryDto rightRuleAdhocIntegrationQuery = new AdhocIntegrationQueryDto();
        rightRuleAdhocIntegrationQuery.setCriteria(integrationQueryDto);
        rightRuleAdhocIntegrationQuery.setQueryRequest(queryRequest);
        return rightRuleAdhocIntegrationQuery;
    }

    private String getAssociateFilterName(IntegrationQueryDto integrationQuery) {
        if(integrationQuery.getChildren().size()==0){
            return "";
        }

        IntegrationQueryDto childQuery = integrationQuery.getChildren().get(0);
        Relationship relationship = childQuery.getParentRs();
        if(relationship.getIsReferedFromParent()){
            Integer attrId = relationship.getAttrId();
            AdmCiTypeAttr attr = ciTypeAttrRepository.getOne(attrId);
            return attr.getPropertyName();
        }
        return "";
    }

}
