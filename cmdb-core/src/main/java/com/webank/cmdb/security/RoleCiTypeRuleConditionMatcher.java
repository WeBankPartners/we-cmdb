package com.webank.cmdb.security;

import static com.webank.cmdb.constant.FieldType.fromCode;
import static com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition.TYPE_EXPRESSION;
import static java.util.Collections.emptySet;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrExpression;
import com.webank.cmdb.service.RouteQueryExpressionService;
import com.webank.cmdb.util.ServiceRegistry;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Sets;
import com.webank.cmdb.constant.FieldType;
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
        String conditionValue = condition.getConditionValue();
        if (StringUtils.isEmpty(conditionValue))
            return emptySet();

        if (TYPE_EXPRESSION.equalsIgnoreCase(condition.getConditionValueType())) {
            return evaluateExpression();
        } else {
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
        }
    }

    private Set<String> evaluateExpression() {
        Set<String> resultGuids = new HashSet<>();
        Set<AdmRoleCiTypeCtrlAttrExpression> roleCiTypeCtrlAttrExpressions = condition.getAdmRoleCiTypeCtrlAttrExpressions();
        roleCiTypeCtrlAttrExpressions.forEach(ctrlAttrExpression -> {
            String expression = ctrlAttrExpression.getExpression();
            List result = routeQueryExpressionService.executeQuery(expression);
            resultGuids.addAll(result);
        });

        return resultGuids;
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
