package com.webank.cmdb.dynamicEntity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;

import javax.persistence.EntityManagerFactory;
import javax.persistence.spi.PersistenceUnitInfo;
import javax.sql.DataSource;

import org.hibernate.jpa.boot.internal.EntityManagerFactoryBuilderImpl;
import org.hibernate.jpa.boot.internal.PersistenceUnitInfoDescriptor;

public class HibernateJpaEntityManagerFactory {

    private String defaultSchema;

    private final List<Class<?>> entityClasses;
    private DataSource dataSource;
    private final ClassLoader classLoader;
    private String showSql = "false";

    public HibernateJpaEntityManagerFactory(List<Class<?>> entityClasses, DataSource dataSource, ClassLoader classLoader, String defaultSchema) {
        this.entityClasses = entityClasses;
        this.dataSource = dataSource;
        this.classLoader = classLoader;
        this.defaultSchema = defaultSchema;
    }

    public EntityManagerFactory getEntityManagerFactory() {
        PersistenceUnitInfo persistenceUnitInfo = getPersistenceUnitInfo(getClass().getSimpleName());
        Map<String, Object> configuration = new HashMap<>();
        return new EntityManagerFactoryBuilderImpl(new PersistenceUnitInfoDescriptor(persistenceUnitInfo), configuration, new CiClassLoaderService(classLoader)).build();
    }

    protected DynamicEntityUnitInfo getPersistenceUnitInfo(String name) {
        DynamicEntityUnitInfo unitInfo = new DynamicEntityUnitInfo(name, getEntityClassNames(), getProperties(), classLoader);
        unitInfo.setClassLoader(classLoader);
        return unitInfo;
    }

    protected List<String> getEntityClassNames() {
        return getEntities().stream().map(Class::getName).collect(Collectors.toList());
    }

    protected Properties getProperties() {
        Properties properties = new Properties();
        properties.put("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
        properties.put("hibernate.id.new_generator_mappings", false);
        properties.put("hibernate.connection.datasource", dataSource);
        properties.put("hibernate.hbm2ddl.auto", "none");
        properties.put("hibernate.default_schema", defaultSchema);
        properties.put("hibernate.show_sql", showSql);
        return properties;
    }

    protected List<Class<?>> getEntities() {
        return entityClasses;
    }

    public void setShowSql(String showSql) {
        this.showSql = showSql;
    }

}
