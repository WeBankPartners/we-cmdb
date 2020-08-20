package com.webank.cmdb.service.impl;

import static org.apache.commons.collections.CollectionUtils.isEmpty;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.webank.cmdb.support.cache.CacheUtils;
import com.webank.cmdb.support.cache.RequestScopedCacheManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.webank.cmdb.config.ApplicationProperties.SecurityProperties;
import com.webank.cmdb.constant.AuthenticationType;
import com.webank.cmdb.domain.AdmRole;
import com.webank.cmdb.domain.AdmRoleCiType;
import com.webank.cmdb.support.exception.CmdbAccessDeniedException;
import com.webank.cmdb.repository.AdmRoleRepository;
import com.webank.cmdb.repository.RoleCiTypeRepository;
import com.webank.cmdb.repository.UserRepository;
import com.webank.cmdb.support.security.Authority;
import com.webank.cmdb.support.security.Authority.Decision;
import com.webank.cmdb.support.security.UserCiTypeAuthority;
import com.webank.cmdb.service.AuthorizationService;
import com.webank.cmdb.util.CmdbThreadLocal;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "authorizationServiceImpl")
public class AuthorizationServiceImpl implements AuthorizationService {

    @Autowired
    private SecurityProperties securityProperties;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleCiTypeRepository roleCiTypeRepository;
    @Autowired
    private AdmRoleRepository admRoleRepository;
    @Autowired
    private RequestScopedCacheManager requestScopedCacheManager;

    @Override
    public void authorizeCiData(int ciTypeId, Object ciData, String action) {
        if (!securityProperties.isEnabled()) {
            log.warn("Security authorization is disabled.");
            return;
        }
        String username = getCurrentUsername();
        if (!isCiDataPermitted(ciTypeId, ciData, action)) {
            throw new CmdbAccessDeniedException(String.format("Access denied. No %s permission on ci-type[%d] found for %s", action, ciTypeId, username));
        } else {
            log.info(String.format("Access granted. %s on ci-type[%d] permitted for %s", action, ciTypeId, username));
        }
    }

    @Override
    public boolean isCiDataPermitted(int ciTypeId, Object ciData, String action) {
        if (!securityProperties.isEnabled()) {
            log.warn("Security authorization is disabled.");
            return true;
        }
        Authority userAuthority = getUserAuthority(ciTypeId);
        Decision decision = userAuthority.authorize(action, ciData);
        return decision.isAccessGranted();
    }

    @Cacheable("authorizationService-isCiTypePermitted")
    @Override
    public boolean isCiTypePermitted(int ciTypeId, String action) {
        if (!securityProperties.isEnabled()) {
            log.warn("Security authorization is disabled.");
            return true;
        }
        Authority userAuthority = getUserAuthority(ciTypeId);
        boolean ciTypePermitted = userAuthority.isCiTypePermitted(action);
        log.info("Is [{}] on CiType[{}] permitted: {}", action, ciTypeId, ciTypePermitted);
        return ciTypePermitted;
    }

    @Cacheable("authorizationService-getPermittedData")
    @Override
    public List<Map<String, Set<?>>> getPermittedData(int ciTypeId, String action) {
        UserCiTypeAuthority userAuthority = getUserAuthority(ciTypeId);

        return userAuthority.getPermittedData(action);
    }

    private UserCiTypeAuthority getUserAuthority(int ciTypeId) {
        UserCiTypeAuthority result = (UserCiTypeAuthority)CacheUtils.cacheLocaleCall(requestScopedCacheManager,"authorizationService-getUserAuthority",ciTypeId,()->{
            String username = getCurrentUsername();
            List<AdmRole> roles = getRoles();
            if (isEmpty(roles))
                throw new CmdbAccessDeniedException("No role found for user: " + username);

            List<Integer> roleIds = roles.stream().map(AdmRole::getIdAdmRole).collect(Collectors.toList());
            List<AdmRoleCiType> roleCiTypes = roleCiTypeRepository.findAdmRoleCiTypesByCiTypeIdAndRoleIds(ciTypeId, roleIds);

            return new UserCiTypeAuthority(username, ciTypeId, roleCiTypes);
        });

        return result;
    }

    private List<AdmRole> getRoles() {
        if (AuthenticationType.PLATFORM_AUTH.getCode().equals(securityProperties.getAuthenticationProvider())) {
            return admRoleRepository.findByRoleNames(CmdbThreadLocal.getIntance().getAuthorities().toArray(new String[CmdbThreadLocal.getIntance().getAuthorities().size()]));
        } else {
            return userRepository.findRolesByUserName(getCurrentUsername());
        }
    }

    private String getCurrentUsername() {
        String username = CmdbThreadLocal.getIntance().getCurrentUser();
        return username;
    }

    public void setSecurityEnabled(boolean securityEnabled) {
        securityProperties.setEnabled(securityEnabled);
    }
}
