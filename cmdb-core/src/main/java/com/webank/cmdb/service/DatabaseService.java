package com.webank.cmdb.service;

public interface DatabaseService extends CmdbService {
    public static String NAME = "DatabaseService";

    boolean isTableExisted(String tableName);

    void executeSQl(String ddlSql);
}
