package com.webank.cmdb.config;

import static com.google.common.collect.Lists.newArrayList;

import java.math.BigInteger;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.sql.DataSource;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;

public class TestDatabase {

    static public void prepareDatabase(DataSource dataSource) {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.setContinueOnError(false);
        populator.setIgnoreFailedDrops(false);
        populator.setSeparator(";");
        populator.addScript(new ClassPathResource("/db/data_model.sql"));
        populator.execute(dataSource);
    }

    static public void prepareDatabaseOfLegacyModel(DataSource dataSource) {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.setContinueOnError(false);
        populator.setIgnoreFailedDrops(false);
        populator.setSeparator(";");
        populator.addScript(new ClassPathResource("/db/legacy/1.init.schema.sql"));
        populator.addScript(new ClassPathResource("/db/legacy/2.init.static.data.sys.sql"));
        populator.addScript(new ClassPathResource("/db/legacy/3.init.static.data.ci.sql"));
        populator.addScript(new ClassPathResource("/db/legacy/4.init.data.ci.sql"));
        populator.execute(dataSource);
    }

    static public void cleanUpDatabase(DataSource dataSource) {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.setContinueOnError(false);
        populator.setIgnoreFailedDrops(false);
        populator.setSeparator(";");
        populator.addScript(new ClassPathResource("/db/drop.all.sql"));
        populator.execute(dataSource);
    }

    static public void executeSql(DataSource dataSource, String sql) {
        executeSqlScripts(dataSource, newArrayList(new ByteArrayResource(sql.getBytes())));
    }

    static public void executeSqlScript(DataSource dataSource, String sqlScript) {
        executeSqlScripts(dataSource, newArrayList(new ClassPathResource(sqlScript)));
    }

    static private void executeSqlScripts(DataSource dataSource, List<Resource> scipts) {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.setContinueOnError(false);
        populator.setIgnoreFailedDrops(false);
        populator.setSeparator(";");
        scipts.forEach(populator::addScript);
        populator.execute(dataSource);
    }

    static public int getCmdbQueryCount(EntityManager em) {
        Query query = em.createNativeQuery("SELECT count(1) FROM INFORMATION_SCHEMA.QUERY_STATISTICS where SQL_STATEMENT  like '%cmdb_test.%'", Integer.class);
        int count = query.getFirstResult();
        return count;
    }

    static public void enableH2Statistics(EntityManager em) {
        Query query = em.createNativeQuery("SET QUERY_STATISTICS True");
        query.executeUpdate();
    }

    static public void disableH2Statistics(EntityManager em) {
        Query query = em.createNativeQuery("SET QUERY_STATISTICS False");
        query.executeUpdate();
    }

    static public int getQueryCount(EntityManager em) {
        Query query = em.createNativeQuery("SELECT count(1) FROM INFORMATION_SCHEMA.QUERY_STATISTICS  where SQL_STATEMENT  like '%cmdb_test.%'");
        return ((BigInteger) query.getResultList()
                .get(0)).intValue();
    }

    static public List<?> debug(EntityManager em, String sql) {
        Query query = em.createNativeQuery(sql);
        return query.getResultList();
    }
}
