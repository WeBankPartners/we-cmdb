package com.webank.cmdb.service.impl;

import static com.webank.cmdb.domain.AdmMenu.ROLE_PREFIX;
import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;

import java.util.List;

import javax.transaction.Transactional;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.webank.cmdb.config.ApplicationProperties.SecurityProperties;
import com.webank.cmdb.domain.AdmMenu;
import com.webank.cmdb.domain.AdmUser;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.repository.AdmMenusRepository;
import com.webank.cmdb.repository.AdmUserRepository;

@Service
public class CmdbUserDetailService implements UserDetailsService {
    private static Logger logger = LoggerFactory.getLogger(CmdbUserDetailService.class);

    @Autowired
    private AdmMenusRepository admMenusRepository;

    @Autowired
    private AdmUserRepository admUserRepository;

    @Autowired
    private SecurityProperties securityProperties;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        List<AdmMenu> admMenus = admMenusRepository.findMenusByUserName(username);
        String password = getPassword(username);

        if (CollectionUtils.isNotEmpty(admMenus)) {
            List<GrantedAuthority> authorities = admMenus.stream()
                    .map(AdmMenu::getName)
                    .map(menuName -> new SimpleGrantedAuthority(ROLE_PREFIX + menuName))
                    .collect(toList());
            logger.info("Menu permissions {} found for user {}", authorities, username);
            return new User(username, password, authorities);
        } else {
            logger.warn("No accessible menu found for user {}", username);
            return new User(username, password, emptyList());
        }
    }

    private String getPassword(String username) {
        String password;
        if (securityProperties.isEnabled()) {
            AdmUser user = admUserRepository.findByCode(username);
            if (user == null) {
                throw new CmdbException(String.format("Username [%s] not found.", username)).withErrorCode("3079", username);
            }
            if (StringUtils.isBlank(user.getEncryptedPassword())) {
                throw new CmdbException(String.format("Can not authenticate the user [%s] as password not found.", username))
                .withErrorCode("3080", username);
            }
            password = user.getEncryptedPassword();
        } else {
            password = "";
        }
        return password;
    }

}
