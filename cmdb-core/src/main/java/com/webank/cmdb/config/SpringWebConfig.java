package com.webank.cmdb.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.ServletRequestListener;

import org.apache.commons.lang3.StringUtils;
import org.jasig.cas.client.validation.Cas20ServiceTicketValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.boot.web.servlet.ServletListenerRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.cas.ServiceProperties;
import org.springframework.security.cas.authentication.CasAuthenticationProvider;
import org.springframework.security.cas.web.CasAuthenticationEntryPoint;
import org.springframework.security.cas.web.CasAuthenticationFilter;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.web.context.request.RequestContextListener;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.webank.cmdb.support.cache.CacheHandlerInterceptor;
import com.webank.cmdb.config.ApplicationProperties.SecurityProperties;
import com.webank.cmdb.constant.AuthenticationType;
import com.webank.cmdb.controller.interceptor.HttpAccessUsernameInterceptor;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.support.mvc.CustomRolesPrefixPostProcessor;
import com.webank.wecube.platform.auth.client.filter.Http401AuthenticationEntryPoint;
import com.webank.wecube.platform.auth.client.filter.JwtSsoBasedAuthenticationFilter;

import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableWebMvc
@EnableSwagger2
@EnableWebSecurity
@EnableGlobalMethodSecurity(jsr250Enabled = true)
@ComponentScan({ "com.webank.cmdb.controller", "com.webank.cmdb.support.mvc", "com.webank.cmdb.stateTransition" })
public class SpringWebConfig extends WebSecurityConfigurerAdapter implements WebMvcConfigurer {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Autowired
    private ServerProperties serverProperties;
    
    @Autowired
    private SecurityProperties securityProperties;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private HttpAccessUsernameInterceptor cookieHandlerInterceptor;
    
    @Autowired
    private CacheHandlerInterceptor cacheHandlerInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(cookieHandlerInterceptor).addPathPatterns("/**");
        registry.addInterceptor(cacheHandlerInterceptor).addPathPatterns("/**");
        WebMvcConfigurer.super.addInterceptors(registry);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/swagger-ui.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");

        registry.addResourceHandler("/css/**").addResourceLocations("classpath:/static/css/");
        registry.addResourceHandler("/fonts/**").addResourceLocations("classpath:/static/fonts/");
        registry.addResourceHandler("/img/**").addResourceLocations("classpath:/static/img/");
        registry.addResourceHandler("/js/**").addResourceLocations("classpath:/static/js/");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry = http.authorizeRequests();
        if (securityProperties.isEnabled()) {
            registry = configureWhiteListAuthentication(registry, true);
            if (AuthenticationType.lOCAL.getCode().equalsIgnoreCase(securityProperties.getAuthenticationProvider())) {
                configureLocalAuthentication(registry);
            } else if (AuthenticationType.CAS.getCode().equalsIgnoreCase(securityProperties.getAuthenticationProvider())) {
                configureCasAuthentication(registry);
            } else if (AuthenticationType.PLATFORM_AUTH.getCode().equalsIgnoreCase(securityProperties.getAuthenticationProvider())) {
                configurePlatformAuthentication(registry);
            } else {
                throw new CmdbException("Unsupported authentication-provider: " + securityProperties.getAuthenticationProvider());
            }
        } else {
            registry = configureWhiteListAuthentication(registry, false);
            configurePrivacyFreeAuthentication(registry);
        }
    }
     
    protected void configureLocalAuthentication(ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry) throws Exception {
        registry.antMatchers("/login-with-password*").permitAll()
                .antMatchers("/logout*").permitAll()
                .antMatchers("/ui/v2/**").permitAll()
                .antMatchers("/maintain/**").permitAll()
                .anyRequest().authenticated()
            .and()
                .formLogin()
                .loginPage("/login-with-password.html")
                .loginProcessingUrl("/login-with-password")
                .defaultSuccessUrl("/index.html")
                .failureUrl("/login-with-password.html?error=true")
            .and()
                .logout()
                .logoutUrl("/logout")
                .deleteCookies("JSESSIONID")
                .logoutSuccessUrl("/login-with-password.html")
            .and()
                .csrf()
                .disable();
    }
    
    protected void configurePrivacyFreeAuthentication(ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry) throws Exception {
        registry.antMatchers("/login-privacy-free*").permitAll()
                .antMatchers("/logout*").permitAll()
                .antMatchers("/ui/v2/**").permitAll()
                .antMatchers("/maintain/**").permitAll()
                .anyRequest().authenticated()
            .and()
                .formLogin()
                .loginPage("/login-privacy-free.html")
                .loginProcessingUrl("/login-privacy-free")
                .defaultSuccessUrl("/index.html")
                .failureUrl("/login-privacy-free.html?error=true")
            .and()
                .logout()
                .logoutUrl("/logout")
                .deleteCookies("JSESSIONID")
                .logoutSuccessUrl("/login-privacy-free.html")
            .and()
                .csrf()
                .disable();
    }

    protected ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry configureWhiteListAuthentication(ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry,
            boolean checkRequired) throws Exception {
        List<String> convertedList = new ArrayList<String>();
        if (checkRequired) {
            if (StringUtils.isNotBlank(securityProperties.getWhitelistIpAddress())) {
                List<String> whiteListIpAddress = Arrays.asList(securityProperties.getWhitelistIpAddress().split(","));
                for (String ipAddress : whiteListIpAddress) {
                    convertedList.add(String.format("hasIpAddress('%s')", ipAddress));
                }

                return registry.antMatchers("/**")
                        .access(StringUtils.join(convertedList, " or "));
            }
        } else {
            return registry.antMatchers("/**").permitAll();
        }
        return registry;
    }

    protected ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry configurePlatformAuthentication(ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry) throws Exception {
        registry.antMatchers("/index.html").permitAll()
                .antMatchers("/swagger-ui.html/**", "/swagger-resources/**").permitAll()
                .antMatchers("/webjars/**").permitAll()
                .antMatchers("/v2/api-docs").permitAll()
                .antMatchers("/csrf").permitAll()
                .antMatchers("/**/*.png").permitAll()
                .antMatchers("/maintain/**").permitAll()
                .anyRequest()
                .authenticated()
                .and()
                .addFilter(jwtSsoBasedAuthenticationFilter())
                .csrf()
                .disable()
                .exceptionHandling()
                .authenticationEntryPoint(new Http401AuthenticationEntryPoint());
        return registry;
    }

    protected Filter jwtSsoBasedAuthenticationFilter() throws Exception {
        JwtSsoBasedAuthenticationFilter filter = new JwtSsoBasedAuthenticationFilter(authenticationManager());
        return (Filter) filter;
    }

    protected void configureCasAuthentication(ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry) throws Exception {
        registry.and()
                .exceptionHandling()
                .authenticationEntryPoint(casAuthenticationEntryPoint())
                .and()
                .addFilter(casAuthenticationFilter())
                .addFilterBefore(logoutFilter(), LogoutFilter.class)
                .authorizeRequests()
                .anyRequest()
                .authenticated()
                .and()
                .logout()
                .permitAll()
                .and()
                .csrf()
                .disable();
                //.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse());
    }

    @Override
    protected void configure(final AuthenticationManagerBuilder auth) throws Exception {
        if (!securityProperties.isEnabled()) {
            auth.userDetailsService(userDetailsService).passwordEncoder(new BypassPasswordEncoder());
        } else if (AuthenticationType.lOCAL.getCode().equalsIgnoreCase(securityProperties.getAuthenticationProvider())) {
            auth.userDetailsService(userDetailsService);
        } else {
            super.configure(auth);
        }
    }

    public AuthenticationEntryPoint casAuthenticationEntryPoint() {
        CasAuthenticationEntryPoint point = new CasAuthenticationEntryPoint();
        point.setLoginUrl(securityProperties.getCasServerUrl() + "/login");
        point.setServiceProperties(serviceProperties());
        return point;
    }

    public CasAuthenticationFilter casAuthenticationFilter() throws Exception {
        CasAuthenticationFilter filter = new CasAuthenticationFilter();
        filter.setAuthenticationManager(authenticationManager());
        return filter;
    }

    public LogoutFilter logoutFilter() {
        return new LogoutFilter(securityProperties.getCasServerUrl() + "/logout?service=" + getServerUrl(), new SecurityContextLogoutHandler());
    }

    @Bean
    public CasAuthenticationProvider casAuthenticationProvider() {
        CasAuthenticationProvider provider = new CasAuthenticationProvider();
        provider.setTicketValidator(new Cas20ServiceTicketValidator(securityProperties.getCasServerUrl()));
        provider.setServiceProperties(serviceProperties());
        provider.setKey("casAuthProviderKey");
        provider.setUserDetailsService(userDetailsService);
        return provider;
    }

    @Bean
    public static CustomRolesPrefixPostProcessor customRolesPrefixPostProcessor() {
        return new CustomRolesPrefixPostProcessor();
    }

    @Bean
    public ServletListenerRegistrationBean<ServletRequestListener> registerRequestListener() {
        ServletListenerRegistrationBean<ServletRequestListener> servletListenerRegistrationBean = new ServletListenerRegistrationBean<>();
        servletListenerRegistrationBean.setListener(new RequestContextListener());
        return servletListenerRegistrationBean;
    }
    private ServiceProperties serviceProperties() {
        ServiceProperties properties = new ServiceProperties();
        properties.setService(getServerUrl() + "/login/cas");
        properties.setSendRenew(false);
        return properties;
    }

    private String getServerUrl() {
        String serverUrl = null;
        if (serverProperties.getServlet().getContextPath() != null) {
            serverUrl = String.format("http://%s%s", securityProperties.getCasRedirectAppAddr(), serverProperties.getServlet().getContextPath());
        } else {
            serverUrl = String.format("http://%s", securityProperties.getCasRedirectAppAddr());
        }
        return serverUrl;
    }

    private class BypassPasswordEncoder implements PasswordEncoder {
        @Override
        public boolean matches(CharSequence rawPassword, String encodedPassword) {
            return true;
        }

        @Override
        public String encode(CharSequence rawPassword) {
            return String.valueOf(rawPassword);
        }
    }

}
