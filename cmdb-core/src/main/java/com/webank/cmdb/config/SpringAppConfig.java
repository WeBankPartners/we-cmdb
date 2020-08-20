package com.webank.cmdb.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

import com.webank.cmdb.config.ApplicationProperties.DatasourceProperties;
import com.webank.cmdb.config.ApplicationProperties.SecurityProperties;
import com.webank.cmdb.config.ApplicationProperties.UIProperties;

@Configuration
@EnableCaching
@ComponentScan({ "com.webank.cmdb.service", "com.webank.cmdb.support.mvc", "com.webank.cmdb.util",
        "com.webank.cmdb.support.cache" })
@Import({ DatabaseConfig.class })
@EnableConfigurationProperties({ ApplicationProperties.class, DatasourceProperties.class, UIProperties.class,
        SecurityProperties.class })
public class SpringAppConfig {
}
