package com.webank.cmdb.config;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.webank.cmdb.config.ApplicationProperties.DatasourceProperties;
import com.webank.cmdb.util.DatabaseUtils;

@Configuration
@EnableJpaRepositories(basePackages = { "com.webank.cmdb.repository" })
@EnableTransactionManagement
public class DatabaseConfig {

    @Autowired
    DatasourceProperties datasourceProperties;

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(DataSource dataSource, JpaVendorAdapter jpaVendorAdapter) {
        LocalContainerEntityManagerFactoryBean emfb = new LocalContainerEntityManagerFactoryBean();
        emfb.setDataSource(dataSource);
        emfb.setJpaVendorAdapter(jpaVendorAdapter);
        emfb.setPackagesToScan("com.webank.cmdb.domain");
        emfb.setJpaPropertyMap(getCustomizedProperties());
        return emfb;
    }

    private Map getCustomizedProperties() {
        Map prop = new HashMap();
        prop.put("hibernate.default_schema", datasourceProperties.getSchema());
        return prop;
    }

    @Bean
    public PlatformTransactionManager transactionManager(EntityManagerFactory emf) {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(emf);
        return transactionManager;
    }

    @Bean
    public DatabaseUtils dataUtils() {
        return new DatabaseUtils();
    }
}
