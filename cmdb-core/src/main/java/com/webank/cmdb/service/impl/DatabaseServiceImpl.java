package com.webank.cmdb.service.impl;

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
    
}
