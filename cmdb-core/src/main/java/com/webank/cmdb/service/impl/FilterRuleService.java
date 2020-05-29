package com.webank.cmdb.service.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.common.base.Strings;
import org.apache.commons.beanutils.BeanMap;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Lists;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.AutoFillIntegrationQueryDto;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.FilterRuleExpression;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.PageInfo;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.util.JsonUtil;

import javax.persistence.criteria.CriteriaBuilder;

@Service
public class FilterRuleService {
    @Autowired
    AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    AdmBasekeyCodeRepository codeRepository;
    @Autowired
    StaticDtoServiceImpl staticDtoServiceImpl;
    @Autowired
    CiServiceImpl ciService;

    private static final String TARGET_NAME = "targetKeyName";

    public QueryResponse queryReferenceData(AdmCiTypeAttr attrWithFilterRule, QueryRequest request) {
        Map<String, Object> ciData = new HashMap<>();
        if (request.getDialect() != null) {
            ciData = request.getDialect().getData();
        }

        List<Object> results = new LinkedList<>();
        try {
            List<Object> filters = JsonUtil.toList(attrWithFilterRule.getFilterRule(), Object.class);
            queryValuesWithFilters(filters, request, ciData, attrWithFilterRule, results);
        } catch (IOException e) {
            throw new InvalidArgumentException(String.format("Failed to parse the filter rule [%s]", attrWithFilterRule.getFilterRule()));
        }

        return getResultWithPaging(request, results);
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

    private List<Object> queryValuesWithFilters(Object filterRule, QueryRequest request, Map<String, Object> ciData, AdmCiTypeAttr attrWithFilterRule, List<Object> finalValues) {
        if (filterRule instanceof List) {
            return handleAsOrRelationShip(filterRule, request, ciData, attrWithFilterRule, finalValues);
        } else if (filterRule instanceof Map) {
            Map<String, Object> ruleMap = (Map<String, Object>) filterRule;
            try {
                return executeSingleFilterRule(attrWithFilterRule, request, ciData, ruleMap);
            } catch (IOException e) {
                return handleAsAndRelationShip(request, ciData, attrWithFilterRule, ruleMap);
            }
        }
        return finalValues;
    }

    private List<Object> handleAsAndRelationShip(QueryRequest request, Map<String, Object> ciData, AdmCiTypeAttr attrWithFilterRule, Map<String, Object> ruleMap) {
        List<Object> values = new LinkedList<>();
        int index = 0;
        for (String key : ruleMap.keySet()) {
            List<Object> newValues = queryValuesWithFilters(ruleMap.get(key), request, ciData, attrWithFilterRule, values);
            if (index == 0) {
                values.addAll(newValues);
            } else {
                values = handleRetainAll(values, newValues);
            }
            index++;
        }
        return values;
    }

    private List<Object> executeSingleFilterRule(AdmCiTypeAttr attrWithFilterRule, QueryRequest request, Map<String, Object> ciData, Map<String, Object> ruleMap) throws IOException {
        FilterRuleExpression ruleExpr = JsonUtil.toObject(JsonUtil.toJsonString(ruleMap), FilterRuleExpression.class);
        List<Object> rightValues = new LinkedList<>();
        if (ruleExpr.getRight() instanceof String) {
            rightValues = executeFilterRule((String) ruleExpr.getRight(), ciData);
        } else if (ruleExpr.getRight() instanceof List) {
            rightValues = (List) ruleExpr.getRight();
        }

        if (rightValues.isEmpty()) {
            return Lists.newLinkedList();
        }

        List<AutoFillIntegrationQueryDto> leftRoutines = parseRoutine(ruleExpr.getLeft());
        AdmCiTypeAttr leftAttr = ciTypeAttrRepository.getOne(leftRoutines.get(1).getParentRs().getAttrId());
        switch (InputType.fromCode(attrWithFilterRule.getInputType())) {
        case Droplist:
            return querySelectDatas(leftAttr, ruleExpr, request, rightValues, leftRoutines);
        case MultSelDroplist:
            return querySelectDatas(leftAttr, ruleExpr, request, rightValues, leftRoutines);
        default:
            return queryCiDataDatas(leftAttr, ruleExpr, request, rightValues, leftRoutines);
        }
    }

    private List<Object> handleAsOrRelationShip(Object filterRule, QueryRequest request, Map<String, Object> ciData, AdmCiTypeAttr attrWithFilterRule, List<Object> finalValues) {
        List<Object> values = new LinkedList<>();
        List<Object> rules = (List<Object>) filterRule;
        rules.forEach(x -> values.addAll(queryValuesWithFilters(x, request, ciData, attrWithFilterRule, values)));
        finalValues.addAll(values);
        return values;
    }

    private List<Object> handleRetainAll(List<Object> originalValues, List<Object> newValues) {
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
            } else if (value instanceof CatCodeDto) {
                CatCodeDto code = (CatCodeDto) value;
                newValues.forEach(newValue -> {
                    CatCodeDto newCode = (CatCodeDto) newValue;
                    if (newCode.getCodeId() == code.getCodeId()) {
                        finalValues.add(value);
                    }
                });
            }
        });
        return finalValues;
    }

    private List<Object> querySelectDatas(AdmCiTypeAttr lastLeftAttr, FilterRuleExpression ruleExpr, QueryRequest orignRequest, List<Object> rightValues, List<AutoFillIntegrationQueryDto> leftRoutines) {
        List<Object> results = new LinkedList<>();
        rightValues.forEach(value -> {
            if (value != null) {
                if (value instanceof Map) {
                    results.add(value);
                } else {
                    String leftEnumCodeAttr = leftRoutines.get(leftRoutines.size() - 1).getEnumCodeAttr();

                    List<Filter> filters = new ArrayList<>();
                    filters.add(new Filter("catId", "eq", lastLeftAttr.getReferenceId()));
                    List<Object> values = extractValuesFromEnum(value, leftEnumCodeAttr, ruleExpr);
                    if (!values.isEmpty()) {
                        filters.add(new Filter(leftEnumCodeAttr, "in", values));
                    }
                    filters.addAll(orignRequest.getFilters());

                    QueryRequest request = new QueryRequest();
                    request.setFilterRs("and");
                    request.setFilters(filters);
                    results.addAll(staticDtoServiceImpl.query(CatCodeDto.class, request).getContents());
                }
            }
        });
        return results;
    }

    private List<Object> extractValuesFromEnum(Object value, String leftEnumCodeAttr, FilterRuleExpression ruleExpr) {
        List<Object> values = new ArrayList<>();
        if (value instanceof CatCodeDto) {
            values.add(extractedSingleEnumValue(value, leftEnumCodeAttr, ruleExpr));
        } else if (value instanceof List) {
            List<CatCodeDto> items = (List)value;
            items.forEach(item->{
                values.add(extractedSingleEnumValue(item, leftEnumCodeAttr, ruleExpr));
            });
        } else {
            values.add(value);
        }
        return values;
    }

    private Object extractedSingleEnumValue(Object value, String leftEnumCodeAttr, FilterRuleExpression ruleExpr) {
        String rightEnumCodeAttr = leftEnumCodeAttr;
        if (ruleExpr.getRight() instanceof String) {
            try {
                List<AutoFillIntegrationQueryDto> routines = JsonUtil.toList((String) ruleExpr.getRight(), AutoFillIntegrationQueryDto.class);
                rightEnumCodeAttr = routines.get(routines.size() - 1).getEnumCodeAttr();
            } catch (IOException e) {
                throw new InvalidArgumentException(String.format("Failed to parse right filter rule [%s]", ruleExpr.getRight()), e);
            }
        }
        BeanMap beanMap = new BeanMap(value);
        return beanMap.get(rightEnumCodeAttr);
    }


    private List<Object> queryCiDataDatas(AdmCiTypeAttr lastLeftAttr, FilterRuleExpression ruleExpr, QueryRequest orignRequest, List<Object> rightValues, List<AutoFillIntegrationQueryDto> leftRoutines) {
        IntegrationQueryDto rootIntQuery = new IntegrationQueryDto();
        rootIntQuery.setCiTypeId(leftRoutines.get(0).getCiTypeId());
        IntegrationQueryDto lastIntQuery = rootIntQuery;

        AdhocIntegrationQueryDto adhocIntegrationQuery = new AdhocIntegrationQueryDto();
        adhocIntegrationQuery.setCriteria(rootIntQuery);
        Integer rootGuidAttrId = getGuidAttrIdByCiTypeId(rootIntQuery.getCiTypeId());
        rootIntQuery.getAttrs().add(rootGuidAttrId);
        rootIntQuery.getAttrKeyNames().add("root$guid");
        adhocIntegrationQuery.getQueryRequest().getResultColumns().add("root$guid");

        int i=1;
        for (;i<leftRoutines.size();i++){
            AutoFillIntegrationQueryDto autoFillIntQuery = leftRoutines.get(i);
            IntegrationQueryDto childQuery = new IntegrationQueryDto();
            childQuery.setCiTypeId(autoFillIntQuery.getCiTypeId());
            lastIntQuery.getChildren().add(childQuery);
            lastIntQuery = childQuery;
        }

        Integer lastGuidAttrId = getGuidAttrIdByCiTypeId(lastIntQuery.getCiTypeId());
        lastIntQuery.getAttrs().add(lastGuidAttrId);
        lastIntQuery.getAttrKeyNames().add("last$guid");


        List<Object> results = new LinkedList<>();

        List<Filter> filters = new ArrayList<>();
        switch (ruleExpr.getOperator()) {
        case "in":
            filters.add(new Filter("last$guid", FilterOperator.In.getCode(), convertRightValues(lastLeftAttr, ruleExpr, rightValues)));
            break;
        default:
            break;
        }
        adhocIntegrationQuery.getQueryRequest().getFilters().addAll(filters);
        QueryResponse adhocResponse = ciService.adhocIntegrateQuery(adhocIntegrationQuery);
        List guids = adhocResponse.getContents();

        List<Filter> targetCiFilters = Lists.newLinkedList();
        targetCiFilters.add(new Filter("guid",FilterOperator.In.getCode(),guids));
        //filters.addAll(orignRequest.getFilters());
        List<Map<String, Object>> ciDatas = ciService.queryWithFilters(leftRoutines.get(0).getCiTypeId(), targetCiFilters);
        results.addAll(ciDatas);
        return results;
    }

    private Object convertRightValues(AdmCiTypeAttr lastLeftAttr, FilterRuleExpression ruleExpr, List<Object> rightValues) {
        try {
            List<AutoFillIntegrationQueryDto> routines = JsonUtil.toList(ruleExpr.getLeft(), AutoFillIntegrationQueryDto.class);
            String enumCodeAttr = routines.get(routines.size() - 1).getEnumCodeAttr();
            if (enumCodeAttr != null) {
                List<Object> convertedValues = new ArrayList<>();
                rightValues.forEach(value -> {
                    List<Filter> filters = new ArrayList<>();
                    filters.add(new Filter("catId", "eq", lastLeftAttr.getReferenceId()));
                    List<Object> values = extractValuesFromEnum(value, enumCodeAttr, ruleExpr);
                    if (!values.isEmpty()) {
                        filters.add(new Filter(enumCodeAttr, "in", values));
                    }

                    QueryRequest request = new QueryRequest();
                    request.setFilterRs("and");
                    request.setFilters(filters);
                    List<?> codes = staticDtoServiceImpl.query(CatCodeDto.class, request).getContents();
                    if (codes != null && codes.size() > 0) {
                        if (codes.get(0) instanceof Map) {
                            List<Map> mapList = (List<Map>) codes;
                            convertedValues.addAll(mapList.stream().map(m -> m.get("codeId")).collect(Collectors.toList()));
                        } else {
                            List<CatCodeDto> codeList = (List<CatCodeDto>) codes;
                            convertedValues.addAll(codeList.stream().map(CatCodeDto::getCodeId).collect(Collectors.toList()));
                        }
                    }
                });
                return convertedValues;
            }
        } catch (IOException e) {
            throw new InvalidArgumentException(String.format("Failed to parse left routine [%s].", ruleExpr.getLeft()), e);
        }
        return rightValues;
    }

    private List<AutoFillIntegrationQueryDto> parseRoutine(String leftRoutine) {
        try {
            return JsonUtil.toList(leftRoutine, AutoFillIntegrationQueryDto.class);
        } catch (Exception e) {
            throw new InvalidArgumentException(String.format("Failed to extract target ciTypeId from leftRoutine [%s] ", leftRoutine), e);
        }
    }

    private List<Object> executeFilterRule(String routine, Map<String, Object> ciData) {
        List<Object> results = new LinkedList<>();
        List<Map<String, Object>> ret;
        try {
            ret = doIntQueryWithRoutine(routine, ciData);
            results = ret.stream().map(item -> item.get(TARGET_NAME)).collect(Collectors.toList());
        } catch (IOException e) {
            throw new InvalidArgumentException(String.format("Failed to do integration query with routine [%s] ", routine), e);
        }
        return results.stream().distinct().collect(Collectors.toList());
    }

    private List<Map<String, Object>> doIntQueryWithRoutine(String routine, Map<String, Object> ciData) throws IOException {
        List<Map<String, Object>> contents = new LinkedList<>();
        List<AutoFillIntegrationQueryDto> routines = JsonUtil.toList(routine, AutoFillIntegrationQueryDto.class);

        if (routines.size() < 1) {
            throw new InvalidArgumentException(String.format("Invalid routine of filter rule [%s], the routine must have leave attr.", routines));
        }

        AdhocIntegrationQueryDto adhocDto = buildRootDto(routines, ciData);
        //travelFillQueryDto(routines, adhocDto.getCriteria(), 2);
        QueryResponse ret = ciService.adhocIntegrateQuery(adhocDto);
        if (ret != null) {
            contents = ret.getContents();
        }
        return contents;
    }

    private IntegrationQueryDto travelFillQueryDto(List<AutoFillIntegrationQueryDto> routines, IntegrationQueryDto parentDto, int position) {
        if (position >= routines.size()) {
            return null;
        }

        IntegrationQueryDto item = routines.get(position);
        Relationship parentRs = new Relationship();
        parentRs.setAttrId(item.getParentRs().getAttrId());
        parentRs.setIsReferedFromParent(item.getParentRs().getIsReferedFromParent());

        IntegrationQueryDto dto = new IntegrationQueryDto();
        dto.setName("index" + position);
        dto.setCiTypeId(item.getCiTypeId());
        dto.setParentRs(parentRs);
        dto.setAttrs(Arrays.asList(getGuidAttrIdByCiTypeId(item.getCiTypeId())));
        dto.setAttrKeyNames(Arrays.asList(item.getCiTypeId() + "$guid"));

        IntegrationQueryDto childDto = travelFillQueryDto(routines, dto, ++position);

        if (childDto == null) {
            if (parentDto.getAttrs().contains(parentRs.getAttrId())) {
                replaceKeyNameWithTargetName(parentDto);
            } else {
                addTargetName(parentDto, parentRs);
            }
        } else {
            parentDto.setChildren(Arrays.asList(childDto));
        }

        return parentDto;
    }

    private void addTargetName(IntegrationQueryDto parentDto, Relationship parentRs) {
        List<Integer> attrs = new ArrayList<>();
        attrs.add(parentRs.getAttrId());
        attrs.addAll(parentDto.getAttrs());

        List<String> attrKeyNames = new ArrayList<>();
        attrKeyNames.add(TARGET_NAME);
        attrKeyNames.addAll(parentDto.getAttrKeyNames());

        parentDto.setAttrs(attrs);
        parentDto.setAttrKeyNames(attrKeyNames);
    }

    private void replaceKeyNameWithTargetName(IntegrationQueryDto parentDto) {
        List<String> attrKeyNames = new ArrayList<>();
        parentDto.getAttrKeyNames().forEach(x -> {
            if (x.equals(parentDto.getCiTypeId() + "$guid")) {
                attrKeyNames.add(TARGET_NAME);
            } else {
                attrKeyNames.add(x);
            }
        });
        parentDto.setAttrKeyNames(attrKeyNames);
    }

    private AdhocIntegrationQueryDto buildRootDto(List<AutoFillIntegrationQueryDto> routines, Map<String, Object> ciData) {
        AdhocIntegrationQueryDto adhocDto = new AdhocIntegrationQueryDto();
        IntegrationQueryDto rootDto = new IntegrationQueryDto();

        AutoFillIntegrationQueryDto rootRoutine = routines.get(0);
        rootDto.setCiTypeId(rootRoutine.getCiTypeId());
        rootDto.getAttrs().add(getGuidAttrIdByCiTypeId(rootRoutine.getCiTypeId()));
        rootDto.getAttrKeyNames().add("root$guid");

        IntegrationQueryDto lastIntQuery = rootDto;
        int i=1;
        for(;i<routines.size();i++){
            AutoFillIntegrationQueryDto autoFillIntQuery = routines.get(i);
            IntegrationQueryDto curIntQuery = new IntegrationQueryDto();
            curIntQuery.setCiTypeId(autoFillIntQuery.getCiTypeId());
            curIntQuery.setParentRs(new Relationship(autoFillIntQuery.getParentRs().getAttrId(),
                    autoFillIntQuery.getParentRs().getIsReferedFromParent()));
            lastIntQuery.getChildren().add(curIntQuery);
            lastIntQuery = curIntQuery;
        }


        QueryRequest queryRequest = new QueryRequest();
        ciData.forEach((name,value) ->{
            if(value == null|| (value instanceof String && Strings.isNullOrEmpty((String) value))
                || (value instanceof List && ((List)value).size()==0)){
                return;
            }

            AdmCiTypeAttr attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(rootDto.getCiTypeId(),name);
            if(!rootDto.getAttrs().contains(attr.getIdAdmCiTypeAttr())){
                rootDto.getAttrs().add(attr.getIdAdmCiTypeAttr());
                String attKeyName = "root$"+attr.getPropertyName();
                rootDto.getAttrKeyNames().add(attKeyName);
                queryRequest.getFilters().add(new Filter(attKeyName,FilterOperator.Equal.getCode(),value));
            }
        });

        adhocDto.setCriteria(rootDto);
        adhocDto.setQueryRequest(queryRequest);
        return adhocDto;
    }

    private Integer getGuidAttrIdByCiTypeId(int ciTypeId) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        for (AdmCiTypeAttr attr : attrs) {
            if ("guid".equalsIgnoreCase(attr.getPropertyName())) {
                return attr.getIdAdmCiTypeAttr();
            }
        }
        return null;
    }

    public QueryResponse queryReferenceCiData(int referenceAttrId, QueryRequest request) {
        AdmCiTypeAttr attrWithFilterRule = ciTypeAttrRepository.getOne(referenceAttrId);
        if (attrWithFilterRule == null) {
            throw new InvalidArgumentException(String.format("Can not find ciTypeAttr by given attr id [%s].", referenceAttrId));
        }

        if (!(InputType.Reference.getCode().equals(attrWithFilterRule.getInputType()) || InputType.MultRef.getCode().equals(attrWithFilterRule.getInputType()))) {
            throw new InvalidArgumentException(String.format("The given attr is invalid as it's input type is [%s], required input type must be 'ref' or 'multiRef'.", attrWithFilterRule.getInputType()));
        }

        if (StringUtils.isBlank(attrWithFilterRule.getFilterRule())) {
            return ciService.query(attrWithFilterRule.getCiTypeId(), request);
        } else {
            return queryReferenceData(attrWithFilterRule, request);
        }
    }

    public QueryResponse queryReferenceEnumCodes(int referenceAttrId, QueryRequest request) {
        AdmCiTypeAttr attrWithFilterRule = ciTypeAttrRepository.getOne(referenceAttrId);
        if (attrWithFilterRule == null) {
            throw new InvalidArgumentException(String.format("Can not find ciTypeAttr by given attr id [%s].", referenceAttrId));
        }

        if (!(InputType.Droplist.getCode().equals(attrWithFilterRule.getInputType()) || InputType.MultSelDroplist.getCode().equals(attrWithFilterRule.getInputType()))) {
            throw new InvalidArgumentException(String.format("The given attr is invalid as it's input type is [%s], required input type must be 'select' or 'multiSelect'.", attrWithFilterRule.getInputType()));
        }

        if (StringUtils.isBlank(attrWithFilterRule.getFilterRule())) {
            request.getFilters().add(new Filter("catId", "eq", attrWithFilterRule.getReferenceId()));
            return staticDtoServiceImpl.query(CatCodeDto.class, request);
        } else {
            return queryReferenceData(attrWithFilterRule, request);
        }
    }
}
