package com.webank.cmdb.security;

import static com.webank.cmdb.security.Authority.Decision.ACCESS_DENIED;
import static com.webank.cmdb.security.Authority.Decision.ACCESS_GRANTED;
import static org.apache.commons.collections.CollectionUtils.isNotEmpty;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.google.common.collect.Collections2;
import com.google.common.collect.Maps;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttr;
import com.webank.cmdb.exception.CmdbException;

import io.jsonwebtoken.lang.Collections;
import lombok.extern.slf4j.Slf4j;

@Slf4j
class RoleCiTypeRuleAuthority implements Authority {

    private AdmRoleCiTypeCtrlAttr roleCiTypeRule;

    private List<RoleCiTypeRuleConditionMatcher> conditionMatchers;

    RoleCiTypeRuleAuthority(AdmRoleCiTypeCtrlAttr roleCiTypeRule) {
        this.roleCiTypeRule = roleCiTypeRule;
        if (roleCiTypeRule == null)
            throw new CmdbException("roleCiTypeRule could not be null.");
        if (isNotEmpty(roleCiTypeRule.getAdmRoleCiTypeCtrlAttrConditions())) {
            conditionMatchers = roleCiTypeRule.getAdmRoleCiTypeCtrlAttrConditions().stream().map(RoleCiTypeRuleConditionMatcher::new).collect(Collectors.toList());
        }
    }

    @Override
    public Decision authorize(String action, Object data) {
        log.debug("[{}] permission validation on RoleCiTypeRule {} ", action, this.roleCiTypeRule.getIdAdmRoleCiTypeCtrlAttr());
        if (matchConditions(data) && roleCiTypeRule.isActionPermissionEnabled(action)) {
            return ACCESS_GRANTED;
        }

        return ACCESS_DENIED;
    }

    private boolean matchConditions(Object data) {
        if (isNotEmpty(conditionMatchers)) {
            for (RoleCiTypeRuleConditionMatcher conditionMatcher : conditionMatchers) {
                if (!conditionMatcher.match(data))
                    return false;
            }
        }
        return true;
    }

    @Override
    public String getName() {
        return "Rule-" + roleCiTypeRule.getIdAdmRoleCiTypeCtrlAttr();
    }

    @Override
    public boolean isCiTypePermitted(String action) {
        return false;
    }

    Map<String, Set<?>> getPermittedData(String action) {
        Map<String, Set<?>> permittedData = Maps.newHashMap();
        if (roleCiTypeRule.isActionPermissionEnabled(action)) {
            if (isNotEmpty(conditionMatchers)) {
                for (RoleCiTypeRuleConditionMatcher conditionMatcher : conditionMatchers) {
                    Set matchedData = conditionMatcher.getMatchedData();
                    if(!Collections.isEmpty(matchedData)) {
                        permittedData.put(conditionMatcher.getPropertyName(), matchedData);
                    }
                }
            }
        }
        return permittedData;
    }
}
