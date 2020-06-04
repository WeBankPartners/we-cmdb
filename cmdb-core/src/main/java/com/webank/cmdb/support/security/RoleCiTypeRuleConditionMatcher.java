package com.webank.cmdb.support.security;

import static java.util.Collections.emptySet;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.webank.cmdb.constant.AttrConditionType;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrExpression;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrSelect;
import com.webank.cmdb.service.RouteQueryExpressionService;
import com.webank.cmdb.util.ServiceRegistry;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;

import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

@Slf4j
class RoleCiTypeRuleConditionMatcher {

    private AdmRoleCiTypeCtrlAttrCondition condition;

    private String propertyName;

    @Autowired
    private RouteQueryExpressionService routeQueryExpressionService;

    RoleCiTypeRuleConditionMatcher(AdmRoleCiTypeCtrlAttrCondition condition) {
        this.condition = condition;
        this.propertyName = condition.getAdmCiTypeAttr().getPropertyName();
        routeQueryExpressionService = ServiceRegistry.getInstance().getService(RouteQueryExpressionService.SERVICE_NAME);
    }

    boolean match(Object data) {
        Object propertyValue = getProperty(data, propertyName);
        if (propertyValue == null)
            return false;

        Set<?> acceptableValues = getMatchedData();

        return acceptableValues.contains(propertyValue);
    }

    String getPropertyName() {
        return propertyName;
    }

    Set<?> getMatchedData() {
        String conditionValueType = condition.getConditionValueType();
        if (StringUtils.isEmpty(conditionValueType))
            return emptySet();

        if (AttrConditionType.Expression.codeEquals(conditionValueType)) {
            return evaluateExpression();
        }else if(AttrConditionType.Select.codeEquals(conditionValueType)){
            return evaluateSelect();
        }else{
            return emptySet();
        }
        /*else{
            if (fromCode(condition.getAdmCiTypeAttr().getPropertyType()) == FieldType.Int) {
                if (conditionValue.contains(",")) {
                    return Stream.of(conditionValue.split(",")).map(String::trim).map(Integer::valueOf).collect(Collectors.toSet());
                } else {
                    return Sets.newHashSet(Integer.valueOf(conditionValue.trim()));
                }
            } else {
                if (conditionValue.contains(",")) {
                    return Stream.of(conditionValue.split(",")).map(String::trim).collect(Collectors.toSet());
                } else {
                    return Sets.newHashSet(conditionValue.trim());
                }
            }
        }*/
    }

    /**
     * Get the intersection of all expression execution results.
     */
    private Set<String> evaluateExpression() {
        Set<String> resultGuids = new HashSet<>();
        Set<AdmRoleCiTypeCtrlAttrExpression> roleCiTypeCtrlAttrExpressions = condition.getAdmRoleCiTypeCtrlAttrExpressions();
        roleCiTypeCtrlAttrExpressions.forEach(ctrlAttrExpression -> {
            String expression = ctrlAttrExpression.getExpression();
            List result = routeQueryExpressionService.executeQuery(expression);
            if(resultGuids.size()==0){
                resultGuids.addAll(result);
            }else{
                resultGuids.retainAll(result);
            }
        });

        return resultGuids;
    }

    private Set<Integer> evaluateSelect() {
        Set<AdmRoleCiTypeCtrlAttrSelect> attrSelects = condition.getAdmRoleCiTypeCtrlAttrSelects();
        return attrSelects.stream().map(AdmRoleCiTypeCtrlAttrSelect::getIdAdmBaseKey)
                .collect(Collectors.toSet());
/*
        CiService ciService = ServiceRegistry.getInstance().getService(CiService.NAME);

        String propertyName = condition.getAdmCiTypeAttr().getPropertyName();
        List<Integer> selectIds = attrSelects.stream().map(AdmRoleCiTypeCtrlAttrSelect::getIdAdmBaseKey).collect(Collectors.toList());
        QueryRequest selectRequest = QueryRequest.defaultQueryObject().addInFilter(propertyName,selectIds);
        QueryResponse<CiData> response = ciService.query(condition.getAdmCiTypeAttr().getCiTypeId(), selectRequest);
        return response.getContents().stream().map(ciData -> {
                return (String)ciData.getData().get("guid");
            }).collect(Collectors.toSet());
*/

    }

    private Object getProperty(Object data, String propertyName) {
        try {
            return PropertyUtils.getProperty(data, propertyName);
        } catch (Exception e) {
            log.error(String.format("Permission validation failure. Validating rule condition [%s] on data [%s]", condition.getIdAdmRoleCiTypeCtrlAttrCondition(), data), e);
        }
        return null;
    }

}
