package com.webank.cmdb.config;

import java.sql.Connection;
import java.sql.SQLException;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import org.h2.tools.Server;
import org.mockito.Mockito;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.datasource.embedded.ConnectionProperties;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseConfigurer;

import com.webank.cmdb.util.CmdbThreadLocal;

@Configuration
@Import(DatabaseConfig.class)
public class TestConfig {
    private static Logger logger = LoggerFactory.getLogger(TestConfig.class);

    @Bean(name = "h2server", destroyMethod = "stop")
    public Server getH2Server() {
        Server h2Server;
        try {
            h2Server = Server.createWebServer("-web", "-webAllowOthers", "-webPort", "8082");
            h2Server.start();
            return h2Server;
        } catch (SQLException e) {
            logger.info("Fail to start H2 server.", e);
        }
        return null;
    }

    class H2EmbeddedDatabaseConfigure implements EmbeddedDatabaseConfigurer {
        @Override
        public void configureConnectionProperties(ConnectionProperties properties, String databaseName) {
            properties.setDriverClass(org.h2.Driver.class);
            properties.setUrl(
                    String.format("jdbc:h2:~/%s;MODE=MYSQL;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=false", databaseName));
            properties.setUsername("sa");
            properties.setPassword("");
        }

        @Override
        public void shutdown(DataSource dataSource, String databaseName) {
            Connection con = null;
            try {
                con = dataSource.getConnection();
                if (con != null) {
                    con.createStatement()
                            .execute("SHUTDOWN");
                }
            } catch (SQLException ex) {
                // logger.info("Could not shut down embedded database", ex);
            } finally {
                if (con != null) {
                    try {
                        con.close();
                    } catch (Throwable ex) {
                        // logger.debug("Could not close JDBC Connection on shutdown", ex);
                    }
                }
            }
        }
    }
    @Autowired
    protected DataSource dataSource;
    @PostConstruct
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabase(dataSource);
    }

}
