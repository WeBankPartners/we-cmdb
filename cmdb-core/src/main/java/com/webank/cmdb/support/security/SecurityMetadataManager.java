package com.webank.cmdb.support.security;

import java.util.Collection;
import java.util.LinkedHashMap;

import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.expression.SecurityExpressionHandler;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.expression.ExpressionBasedFilterInvocationSecurityMetadataSource;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.stereotype.Component;

@Component
public class SecurityMetadataManager {
    private FilterSecurityInterceptor filterSecurityInterceptor;
    private SecurityExpressionHandler<FilterInvocation> securityExpressionHandler;

    public void updateSecurityMetadataSource(LinkedHashMap<RequestMatcher, Collection<ConfigAttribute>> securityMetadataSource) {
        this.filterSecurityInterceptor.setSecurityMetadataSource(new ExpressionBasedFilterInvocationSecurityMetadataSource(securityMetadataSource, securityExpressionHandler));
    }

    public void setFilterSecurityInterceptor(FilterSecurityInterceptor filterSecurityInterceptor) {
        this.filterSecurityInterceptor = filterSecurityInterceptor;
    }

    public void setSecurityExpressionHandler(SecurityExpressionHandler<FilterInvocation> securityExpressionHandler) {
        this.securityExpressionHandler = securityExpressionHandler;
    }
}
