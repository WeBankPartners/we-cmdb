package com.webank.cmdb.dynamicEntity;

import java.util.LinkedList;
import java.util.List;

import javax.sql.DataSource;

public class DynamicEntityManagerFactory {

    private DataSource dataSource;

    private String defaultSchema;

    private String showSql = "false";

    public DynamicEntityManagerFactory(DataSource dataSource, String defaultSchema) {
        this.dataSource = dataSource;
        this.defaultSchema = defaultSchema;
    }

    public HibernateJpaEntityManagerFactory getEntityManagerFactory(List<DynamicEntityMeta> dynamicEntityHolders, ClassLoader classLoader) {

        List<Class<?>> clazzes = new LinkedList<>();
        dynamicEntityHolders.forEach(x -> {

            clazzes.add(x.getEntityClazz());
        });

        HibernateJpaEntityManagerFactory entityManagerFactory = new HibernateJpaEntityManagerFactory(clazzes, dataSource, classLoader, defaultSchema);
        entityManagerFactory.setShowSql(showSql);
        // return entityManagerFactory.getEntityManager();
        return entityManagerFactory;
    }

    public void setShowSql(String showSql) {
        this.showSql = showSql;
    }

}
