package com.webank.cmdb.security;

import static com.webank.cmdb.constant.FieldType.fromCode;
import static com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition.TYPE_EXPRESSION;
import static java.util.Collections.emptySet;

import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Sets;
import com.webank.cmdb.constant.FieldType;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition;

import lombok.extern.slf4j.Slf4j;

@Slf4j
class RoleCiTypeRuleConditionMatcher {

    private AdmRoleCiTypeCtrlAttrCondition condition;

    private String propertyName;

    RoleCiTypeRuleConditionMatcher(AdmRoleCiTypeCtrlAttrCondition condition) {
        this.condition = condition;
        this.propertyName = condition.getAdmCiTypeAttr().getPropertyName();
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
            return evaluateExpression(conditionValue);
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

    // TODO: to evaluate expression
    private Set<String> evaluateExpression(String expression) {
        System.out.println("TODO: to evaluate the expression - " + expression);
        return Sets.newHashSet();
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
