package com.webank.cmdb.service;

import java.util.List;

import javax.persistence.EntityManager;

public interface DatabaseService extends CmdbService {
    public static String NAME = "DatabaseService";

    boolean isTableExisted(String tableName);
    
    void executeSQl(String ddlSql);
    
    public List<Object> executeQuerySQl(String ddlSql);
    
    public <T> List<T> queryProxyEntity(EntityManager a,Class<T> t, String tableName);

}
