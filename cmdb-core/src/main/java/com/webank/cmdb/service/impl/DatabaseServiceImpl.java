package com.webank.cmdb.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.transaction.Transactional;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.dto.ColumnInfo;
import com.webank.cmdb.service.DatabaseService;

@Service
public class DatabaseServiceImpl implements DatabaseService {
    @Autowired
    private EntityManager entityManager;

    @Override
    public String getName() {
        return DatabaseService.NAME;
    }

    @Override
    public boolean isTableExisted(String tableName) {
        Query query = entityManager.createNativeQuery(String.format("select 1 from %s limit 1", tableName));
        try {
            query.getResultList();
        } catch (Exception ex) {
            return false;
        }
        return true;    
    }

    @Transactional
    @Override
    public void executeSQl(String ddlSql) {
        Query query = entityManager.createNativeQuery(ddlSql);
        query.executeUpdate();
    }
    

    @Override
    public List getDataByTableName(String tableName) {
        Query query = entityManager.createNativeQuery(String.format("select * from %s ", tableName));
        try {
        	return query.getResultList();
        } catch (Exception ex) {
            return null;
        }
    }
    
    @SuppressWarnings("unchecked")
	@Override
    public List<ColumnInfo> getColumnDetailByTableName(String tableName,String schema) {
    	if (StringUtils.isBlank(tableName)||StringUtils.isBlank(schema))
    	return null;
    	String sql = formartSql(tableName,schema);
    	Query query = entityManager.createNativeQuery(sql);
		return query.getResultList();
    }
    
    

    private String formartSql(String tableName,String schema) {
    	if(StringUtils.isNoneBlank(tableName)&&StringUtils.isNoneBlank(schema)) {
	    	StringBuilder sb = new StringBuilder();
	    	sb.append("select COLUMN_NAME, COLUMN_TYPE, ")
	    	  .append(" IF(EXTRA='auto_increment',CONCAT(COLUMN_KEY,'(', IF(EXTRA='auto_increment','auto_increment',EXTRA),')'),COLUMN_KEY), ")
			  .append(" IS_NULLABLE, ")
			  .append(" COLUMN_COMMENT ")
			  .append(" FROM information_schema.COLUMNS  ")
			  .append(" WHERE TABLE_SCHEMA = '").append(schema)
			  .append("' AND TABLE_NAME = '").append(tableName).append("'");
	    	return sb.toString();
    	}
    	return null;
	}

}
