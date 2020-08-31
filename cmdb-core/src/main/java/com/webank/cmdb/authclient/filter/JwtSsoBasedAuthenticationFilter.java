package com.webank.cmdb.authclient.filter;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;

public class JwtSsoBasedAuthenticationFilter extends BasicAuthenticationFilter {
    private static final Logger log = LoggerFactory.getLogger(JwtSsoBasedAuthenticationFilter.class);
    
    private String HEADER_AUTHORIZATION = "Authorization";
    private String PREFIX_BEARER_TOKEN = "Bearer ";
    private String CLAIM_KEY_TYPE = "type";
    private String CLAIM_KEY_AUTHORITIES = "authority";
    private String TOKEN_TYPE_ACCESS = "accessToken";

    private JwtSsoTokenParser jwtParser = null;

    private boolean ignoreFailure = false;

    public JwtSsoBasedAuthenticationFilter(AuthenticationManager authenticationManager, JwtClientConfig jwtClientConfig) {
        super(authenticationManager);
        this.ignoreFailure = true;
        this.jwtParser = new DefaultJwtSsoTokenParser(jwtClientConfig.getSigningKey());
    }

    public JwtSsoBasedAuthenticationFilter(AuthenticationManager authenticationManager,
            AuthenticationEntryPoint authenticationEntryPoint, JwtClientConfig jwtClientConfig) {
        super(authenticationManager, authenticationEntryPoint);
        this.jwtParser = new DefaultJwtSsoTokenParser(jwtClientConfig.getSigningKey());
    }

    @Override
    public void afterPropertiesSet() {
        super.afterPropertiesSet();

        if (log.isInfoEnabled()) {
            log.info("Filter:{} applied", this.getClass().getSimpleName());
        }
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (log.isDebugEnabled()) {
            log.debug("===  doFilterInternal  ===");
        }
        SecurityContextHolder.clearContext();

        String header = request.getHeader(HEADER_AUTHORIZATION);
        if (header == null || !header.startsWith(PREFIX_BEARER_TOKEN)) {

            log.debug("bearer token does not exist");

            chain.doFilter(request, response);

            return;
        }

        if (log.isDebugEnabled()) {
            log.debug("start to authenticate with bearer token");
        }

        try {
            UsernamePasswordAuthenticationToken authentication = getAuthentication(request);
            if (authentication != null && authentication.isAuthenticated()) {
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (AuthenticationException failed) {
            log.debug("authentication failed");

            SecurityContextHolder.clearContext();

            onUnsuccessfulAuthentication(request, response, failed);

            if (this.ignoreFailure) {
                chain.doFilter(request, response);
            } else {
                this.getAuthenticationEntryPoint().commence(request, response, failed);
            }

            return;

        }
        executeFilter(request, response, chain);
    }

    protected void executeFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } finally {
            SecurityContextHolder.clearContext();
        }
    }

    protected boolean isIgnoreFailure() {
        return this.ignoreFailure;
    }

    protected void onUnsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException failed) throws IOException {
    }

    protected void validateRequestHeader(HttpServletRequest request) {
        String header = request.getHeader(HEADER_AUTHORIZATION);
        if (header == null || !header.startsWith(PREFIX_BEARER_TOKEN)) {
            throw new BadCredentialsException("Access token is required.");
        }
    }

    protected UsernamePasswordAuthenticationToken getAuthentication(HttpServletRequest request) {
        validateRequestHeader(request);

        String sAccessTokenHeader = request.getHeader(HEADER_AUTHORIZATION);

        String sAccessToken = sAccessTokenHeader.substring(PREFIX_BEARER_TOKEN.length()).trim();

        if (StringUtils.isBlank(sAccessToken)) {
            throw new AuthenticationCredentialsNotFoundException("Access token is blank.");
        }

        Jws<Claims> jwt = null;
        try {
            jwt = jwtParser.parseJwt(sAccessToken);
        } catch (ExpiredJwtException e) {
            throw new BadCredentialsException("Access token has expired.");
        } catch (JwtException e) {
            throw new BadCredentialsException("Access token is not available.");
        }

        Claims claims = jwt.getBody();

        String sAuthorities = claims.get(CLAIM_KEY_AUTHORITIES, String.class);

        String username = claims.getSubject();

        log.info("subject:{}", username);

        String tokenType = claims.get(CLAIM_KEY_TYPE, String.class);

        if (!TOKEN_TYPE_ACCESS.equals(tokenType)) {
            throw new AccessDeniedException("Access token is required.");
        }

        if (sAuthorities.length() >= 2) {
            sAuthorities = sAuthorities.substring(1);
            sAuthorities = sAuthorities.substring(0, sAuthorities.length() - 1);
        }

        log.info("Authority String:{}", sAuthorities);

        ArrayList<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();

        if (StringUtils.isNotBlank(sAuthorities)) {
            String[] aAuthParts = sAuthorities.split(",");
            for (String s : aAuthParts) {
                GrantedAuthority ga = new SimpleGrantedAuthority(s.trim());
                authorities.add(ga);
            }
        }

        log.info("Authorities:{}", authorities);

        return new UsernamePasswordAuthenticationToken(username, sAccessTokenHeader, authorities);

    }

}
