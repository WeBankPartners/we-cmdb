package com.webank.cmdb.service.impl;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
        Query tableQuery = entityManager.createNativeQuery(String.format("show tables like '%s'", tableName));
        List<?> results = tableQuery.getResultList();
        return results.size() > 0;
    }

    @Transactional
    @Override
    public void executeSQl(String ddlSql) {
        Query query = entityManager.createNativeQuery(ddlSql);
        query.executeUpdate();
    }

}
