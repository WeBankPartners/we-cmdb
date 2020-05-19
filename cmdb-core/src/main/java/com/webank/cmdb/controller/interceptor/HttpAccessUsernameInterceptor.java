package com.webank.cmdb.controller.interceptor;

import java.security.Principal;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.webank.cmdb.util.CmdbThreadLocal;

@Component
public class HttpAccessUsernameInterceptor implements HandlerInterceptor {
    private static final String KEY_USERNAME = "username";
    private static Logger logger = LoggerFactory.getLogger(HttpAccessUsernameInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String username = request.getHeader(KEY_USERNAME);
        String[] authorities = new String[0];
        Principal userPrincipal = request.getUserPrincipal();
        if (userPrincipal != null) {
            username = userPrincipal.getName();
            if (userPrincipal instanceof UsernamePasswordAuthenticationToken) {
                authorities = ((UsernamePasswordAuthenticationToken) userPrincipal).getAuthorities()
                        .stream()
                        .map(GrantedAuthority::toString)
                        .toArray(String[]::new);
            }
        }

        if (StringUtils.isNotBlank(username)) {
            if (Pattern.matches("[a-zA-Z0-9_]+", username)) {
                response.setHeader(KEY_USERNAME, username);
                CmdbThreadLocal.getIntance().putCurrentUser(username);
            } else {
                logger.warn(String.format(("The username [%s] contains invalid character, can not set to response header."), username));
            }
        }

        CmdbThreadLocal.getIntance().setAuthorities(authorities);
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        CmdbThreadLocal.getIntance().cleanCurrentUser();
    }
}
