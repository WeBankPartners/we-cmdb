package com.webank.cmdb.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class WhiteListIpAddressAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    UserDetailsService userDetailsService;

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        if (authentication.getCredentials() == null) {
            log.warn("Authentication failed : no credentials provided.");
            throw new BadCredentialsException(messages.getMessage("WhiteListIpAddressAuthenticationProvider authentication checking failed", "No credentials provided"));
        }

        String providedPassword = authentication.getCredentials().toString();

        if (!passwordEncoder.matches(providedPassword, userDetails.getPassword())) {
            logger.debug("Authentication failed: password does not match the stored password");
            throw new BadCredentialsException(messages.getMessage("WhiteListIpAddressAuthenticationProvider authentication checking failed", "Password incorrect"));
        }
    }

    @Override
    protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        if (userDetails == null) {
            throw new InternalAuthenticationServiceException("Interface contract violation : No UserDetailsService found");
        }
        return userDetails;
    }

}
