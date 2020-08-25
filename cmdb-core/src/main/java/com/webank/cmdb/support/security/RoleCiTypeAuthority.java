package com.webank.cmdb.support.security;

import static com.webank.cmdb.support.security.Authority.Decision.ACCESS_DENIED;
import static com.webank.cmdb.support.security.Authority.Decision.ACCESS_GRANTED;
import static org.apache.commons.collections.CollectionUtils.isNotEmpty;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.google.common.collect.Lists;
import com.webank.cmdb.domain.AdmRoleCiType;
import com.webank.cmdb.support.exception.CmdbException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class RoleCiTypeAuthority implements Authority {

    private String role;
    private AdmRoleCiType roleCiType;

    private List<RoleCiTypeRuleAuthority> ruleAuthorities;

    public RoleCiTypeAuthority(AdmRoleCiType roleCiType) {
        this.roleCiType = roleCiType;
        if (roleCiType == null)
            throw new CmdbException("3056", "roleCiType could not be null.");
        this.role = (roleCiType.getAdmRole() == null) ? String.valueOf(roleCiType.getRoleId()) : roleCiType.getAdmRole().getRoleName();
        if (isNotEmpty(roleCiType.getAdmRoleCiTypeCtrlAttrs())) {
            ruleAuthorities = roleCiType.getAdmRoleCiTypeCtrlAttrs().stream().map(RoleCiTypeRuleAuthority::new).collect(Collectors.toList());
        }
    }

    @Override
    public Decision authorize(String action, Object dataObject) {
        log.debug("[{}] permission validation on RoleCiType {} ", action, this.roleCiType.getIdAdmRoleCiType());
        if (isCiTypePermitted(action)) {
            return ACCESS_GRANTED;
        }

        if (isNotEmpty(ruleAuthorities)) {
            for (RoleCiTypeRuleAuthority ruleAuthority : ruleAuthorities) {
                if (ruleAuthority.authorize(action, dataObject).isAccessGranted()) {
                    log.info("[{}] permission granted on ci-type[{}] for Role[{}] as per {} ", action, roleCiType.getCiTypeId(), role, ruleAuthority.getName());
                    return ACCESS_GRANTED;
                } else {
                    log.debug("No [{}] permission setup on ci-type[{}] for Role[{}] as per {} - ignored and skipped.", action, roleCiType.getCiTypeId(), role, ruleAuthority.getName());
                }
            }
        }

        return ACCESS_DENIED;
    }

    @Override
    public boolean isCiTypePermitted(String action) {
        return this.roleCiType.isActionPermissionEnabled(action);
    }

    List<Map<String, Set<?>>> getPermittedData(String action) {
        List<Map<String, Set<?>>> permittedData = Lists.newArrayList();
        if (isNotEmpty(ruleAuthorities)) {
            for (RoleCiTypeRuleAuthority ruleAuthority : ruleAuthorities) {
                Map<String, Set<?>> rulePermittedData = ruleAuthority.getPermittedData(action);
                if (!rulePermittedData.isEmpty()) {
                    permittedData.add(rulePermittedData);
                }
            }
        }
        return permittedData;
    }

    @Override
    public String getName() {
        return "Role-" + role;
    }

}
