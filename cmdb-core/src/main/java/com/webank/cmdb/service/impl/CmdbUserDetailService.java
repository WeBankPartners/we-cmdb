package com.webank.cmdb.service.impl;

import static com.webank.cmdb.domain.AdmMenu.ROLE_PREFIX;
import static java.util.stream.Collectors.toList;
import static java.util.Collections.emptyList;

import java.util.List;

import javax.transaction.Transactional;

import org.apache.commons.collections.CollectionUtils;
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

import com.webank.cmdb.domain.AdmMenu;
import com.webank.cmdb.repository.AdmMenusRepository;

@Service
public class CmdbUserDetailService implements UserDetailsService {
    private static Logger logger = LoggerFactory.getLogger(CmdbUserDetailService.class);

    @Autowired
    private AdmMenusRepository admMenusRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        List<AdmMenu> admMenus = admMenusRepository.findMenusByUserName(username);

        if (CollectionUtils.isNotEmpty(admMenus)) {
            List<GrantedAuthority> authorities = admMenus.stream()
                    .map(AdmMenu::getName)
                    .map(menuName -> new SimpleGrantedAuthority(ROLE_PREFIX + menuName))
                    .collect(toList());
            logger.info("Menu permissions {} found for user {}", authorities, username);
            return new User(username, "", authorities);
        } else {
            logger.warn("No accessible menu found for user {}", username);
            return new User(username, "", emptyList());
        }
    }

}
