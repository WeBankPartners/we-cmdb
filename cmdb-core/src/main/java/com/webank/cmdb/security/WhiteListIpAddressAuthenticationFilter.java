package com.webank.cmdb.security;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.event.InteractiveAuthenticationSuccessEvent;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;

public class WhiteListIpAddressAuthenticationFilter extends AbstractAuthenticationProcessingFilter {

    public WhiteListIpAddressAuthenticationFilter() {
        super("/*/v2/**");
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException, IOException, ServletException {
        if (request.getSession() != null && request.getSession().getAttribute("SPRING_SECURITY_CONTEXT") != null) {
            return ((SecurityContextImpl)request.getSession().getAttribute("SPRING_SECURITY_CONTEXT")).getAuthentication();
        }

        String username = request.getHeader("username");
        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(
                username, username);
        setDetails(request, authRequest);
        return this.getAuthenticationManager().authenticate(authRequest);
    }

    protected void setDetails(HttpServletRequest request,
            UsernamePasswordAuthenticationToken authRequest) {
        authRequest.setDetails(authenticationDetailsSource.buildDetails(request));
    }

    @Override
    protected final void successfulAuthentication(HttpServletRequest request,
            HttpServletResponse response, FilterChain chain, Authentication authResult)
            throws IOException, ServletException {
        SecurityContextHolder.getContext().setAuthentication(authResult);

        // Fire event
        if (this.eventPublisher != null) {
            eventPublisher.publishEvent(new InteractiveAuthenticationSuccessEvent(
                    authResult, this.getClass()));
        }

        chain.doFilter(request, response);
    }
}
