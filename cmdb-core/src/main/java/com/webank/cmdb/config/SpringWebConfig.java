package com.webank.cmdb.config;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.jasig.cas.client.validation.Cas20ServiceTicketValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.web.ServerProperties;
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
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.webank.cmdb.controller.interceptor.HttpAccessUsernameInterceptor;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.mvc.CustomRolesPrefixPostProcessor;

import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableWebMvc
@EnableSwagger2
@EnableWebSecurity
@EnableGlobalMethodSecurity(jsr250Enabled = true)
@ComponentScan({ "com.webank.cmdb.controller", "com.webank.cmdb.mvc", "com.webank.cmdb.stateTransition" })
public class SpringWebConfig extends WebSecurityConfigurerAdapter implements WebMvcConfigurer {

    private static final int SECENDS_OF_1_WEEK = 604800;
    
    private static final String AUTH_PROVIDER_LOCAL = "local";
    private static final String AUTH_PROVIDER_CAS = "CAS";

    @Autowired
    private ServerProperties serverProperties;
    
    @Value("${cmdb.authentication-provider}")
    private String authenticationProvider;

    @Value("${cas-server.url}")
    private String casServerUrl;

    @Value("${cas-server.enabled}")
    private boolean enabled;

    @Value("${cas-server.redirect-app-addr}")
    private String casRedirectAppAddr;

    @Value("#{'${cas-server.whitelist-ipaddress}'.split(',')}")
    private List<String> whitelistIpaddress;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private HttpAccessUsernameInterceptor cookieHandlerInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(cookieHandlerInterceptor).addPathPatterns("/**");
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
        if (AUTH_PROVIDER_LOCAL.equalsIgnoreCase(authenticationProvider)) {
            configureLocalAuthentication(http);
        } else if (AUTH_PROVIDER_CAS.equalsIgnoreCase(authenticationProvider)) {
            configureCasAuthentication(http);
        } else {
            throw new CmdbException("Unsupported authentication-provider: " + authenticationProvider);
        }
    }
    
    protected void configureLocalAuthentication(HttpSecurity http) throws Exception {
        http.csrf().disable()
            .authorizeRequests()
                .antMatchers("/login*").permitAll()
                .antMatchers("/logout*").permitAll()
                .antMatchers("/api/**").permitAll()
                .anyRequest().authenticated()
            .and()
                .formLogin()
                .loginPage("/login.html")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/index.html", true)
                .failureUrl("/login.html?error=true")
            .and()
                .logout()
                .logoutUrl("/logout")
                .deleteCookies("JSESSIONID")
                .logoutSuccessUrl("/login.html");
    }
    
    protected void configureCasAuthentication(HttpSecurity http) throws Exception {
        if (enabled) {
            List<String> convertedList = new ArrayList<String>();
            for (String ipAddress : whitelistIpaddress) {
                convertedList.add(String.format("hasIpAddress('%s')", ipAddress));
            }

            http.authorizeRequests()
                    .antMatchers("/api/**")
                    .access(StringUtils.join(convertedList, " or "))
                    .and()
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
                    .rememberMe()
                    .tokenValiditySeconds(SECENDS_OF_1_WEEK)
                    // .and().csrf().csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse());
                    .and()
                    .csrf()
                    .disable();
        } else {
            http.csrf().disable().antMatcher("/**").anonymous();
        }
    }

    
    @Override
    protected void configure(final AuthenticationManagerBuilder auth) throws Exception {
        if (AUTH_PROVIDER_LOCAL.equalsIgnoreCase(authenticationProvider)) {
            auth.userDetailsService(userDetailsService).passwordEncoder(new BypassPasswordEncoder());
        } else {
            super.configure(auth);
        }
    }
    
    public AuthenticationEntryPoint casAuthenticationEntryPoint() {
        CasAuthenticationEntryPoint point = new CasAuthenticationEntryPoint();
        point.setLoginUrl(casServerUrl + "/login");
        point.setServiceProperties(serviceProperties());
        return point;
    }

    public CasAuthenticationFilter casAuthenticationFilter() throws Exception {
        CasAuthenticationFilter filter = new CasAuthenticationFilter();
        filter.setAuthenticationManager(authenticationManager());
        return filter;
    }

    public LogoutFilter logoutFilter() {
        return new LogoutFilter(casServerUrl + "/logout?service=" + getServerUrl(), new SecurityContextLogoutHandler());
    }

    @Bean
    public CasAuthenticationProvider casAuthenticationProvider() {
        CasAuthenticationProvider provider = new CasAuthenticationProvider();
        provider.setTicketValidator(new Cas20ServiceTicketValidator(casServerUrl));
        provider.setServiceProperties(serviceProperties());
        provider.setKey("casAuthProviderKey");
        provider.setUserDetailsService(userDetailsService);
        return provider;
    }

    @Bean
    public static CustomRolesPrefixPostProcessor customRolesPrefixPostProcessor() {
        return new CustomRolesPrefixPostProcessor();
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
			serverUrl = String.format("http://%s%s", casRedirectAppAddr, serverProperties.getServlet().getContextPath());
		} else {
			serverUrl = String.format("http://%s", casRedirectAppAddr);
		}
		return serverUrl;
	}
	
	private class BypassPasswordEncoder implements PasswordEncoder{
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
