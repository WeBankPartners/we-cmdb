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
public class UserCiTypeAuthority implements Authority {

    private String username;
    private int ciTypeId;

    private List<RoleCiTypeAuthority> roleAuthorities;

    public UserCiTypeAuthority(String username, int ciTypeId, List<AdmRoleCiType> roleCiTypes) {
        this.username = username;
        if (username == null)
            throw new CmdbException("3035", "username could not be null.");
        this.ciTypeId = ciTypeId;

        if (isNotEmpty(roleCiTypes)) {
            roleAuthorities = roleCiTypes.stream().map(RoleCiTypeAuthority::new).collect(Collectors.toList());
        }
    }

    @Override
    public Decision authorize(String action, Object dataObject) {
        if (isNotEmpty(roleAuthorities)) {
            for (RoleCiTypeAuthority roleAuthority : roleAuthorities) {
                if (roleAuthority.authorize(action, dataObject).isAccessGranted()) {
                    log.info("[{}] permission granted on ci-type[{}] for [{}] as per {} ", action, ciTypeId, username, roleAuthority.getName());
                    return ACCESS_GRANTED;
                } else {
                    log.debug("No [{}] permission setup on ci-type[{}] for [{}] as per {} - ignored and skipped.", action, ciTypeId, username, roleAuthority.getName());
                }
            }
        }
        return ACCESS_DENIED;
    }

    @Override
    public boolean isCiTypePermitted(String action) {
        if (isNotEmpty(roleAuthorities)) {
            for (RoleCiTypeAuthority roleAuthority : roleAuthorities) {
                if (roleAuthority.isCiTypePermitted(action))
                    return true;
            }
        }
        return false;
    }

    public List<Map<String, Set<?>>> getPermittedData(String action) {
        List<Map<String, Set<?>>> permittedData = Lists.newArrayList();
        if (isNotEmpty(roleAuthorities)) {
            for (RoleCiTypeAuthority roleAuthority : roleAuthorities) {
                permittedData.addAll(roleAuthority.getPermittedData(action));
            }
        }
        return permittedData;
    }

    @Override
    public String getName() {
        return "User-" + username;
    }
}
