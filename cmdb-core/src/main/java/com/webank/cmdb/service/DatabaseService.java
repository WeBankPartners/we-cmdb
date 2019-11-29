package com.webank.cmdb.service;

import java.util.List;
import java.util.Map;

import com.webank.cmdb.dto.ColumnInfo;

public interface DatabaseService extends CmdbService {
    public static String NAME = "DatabaseService";

    boolean isTableExisted(String tableName);

    void executeSQl(String ddlSql);

	List getDataByTableName(String tableName);

	List<ColumnInfo> getColumnDetailByTableName(String tableName, String schema);
}
