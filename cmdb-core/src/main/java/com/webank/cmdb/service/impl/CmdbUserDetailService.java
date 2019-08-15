package com.webank.cmdb.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.webank.cmdb.domain.AdmRoleUser;
import com.webank.cmdb.domain.AdmUser;
import com.webank.cmdb.repository.UserRepository;

@Service
public class CmdbUserDetailService implements UserDetailsService {
    private static Logger logger = LoggerFactory.getLogger(CmdbUserDetailService.class);

    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        AdmUser user = userRepository.findByName(username);

        if (user == null) {
            throw new UsernameNotFoundException("Can not load AdmUser for user:" + username);
        } else {
            List<AdmRoleUser> roleUsers = user.getAdmRoleUsers();
            List<SimpleGrantedAuthority> authorities = new ArrayList<>(roleUsers.size());
            if (roleUsers != null && roleUsers.size() > 0) {
                user.getAdmRoleUsers().forEach(x -> {
                    authorities.add(new SimpleGrantedAuthority(x.getAdmRole().getRoleName()));
                });
            }
            UserDetails userDetails = new User(username, "", authorities);
            logger.info("Loaded user:{} roles:{}", authorities.size(), username, authorities);
            return userDetails;
        }
    }

}
