package com.webank.plugins.wecmdb;

import javax.servlet.Filter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Import;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import com.ulisesbocchio.jasyptspringboot.annotation.EnableEncryptableProperties;
import com.webank.cmdb.config.ApplicationProperties;
import com.webank.cmdb.config.DatabaseConfig;
import com.webank.cmdb.config.SpringAppConfig;
import com.webank.cmdb.config.SpringWebConfig;
import com.webank.plugins.wecmdb.config.PluginApplicationProperties;

import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableSwagger2
@EnableConfigurationProperties({PluginApplicationProperties.class,ApplicationProperties.class})
@EnableEncryptableProperties
@EnableAspectJAutoProxy
@ComponentScan({ "com.webank.plugins.wecmdb.propenc", "com.webank.plugins.wecmdb.service", "com.webank.plugins.wecmdb.aop", "com.webank.plugins.wecmdb.controller", "com.webank.plugins.wecmdb.mvc", "com.webank.cmdb.config", "com.webank.cmdb.repository" })
@Import({ DatabaseConfig.class })
public class Application extends AbstractAnnotationConfigDispatcherServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] { SpringAppConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[] { SpringWebConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }

    @Override
    protected Filter[] getServletFilters() {
        return new Filter[] { };
    }
}