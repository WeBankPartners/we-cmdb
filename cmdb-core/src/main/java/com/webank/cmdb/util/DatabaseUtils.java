package com.webank.cmdb.util;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;

public class DatabaseUtils {
    @Autowired
    private EntityManager entityManager;

    public boolean isTableExisted(String tableName) {
        Query query = entityManager.createNativeQuery(String.format("select 1 from %s limit 1", tableName));
        try {
            query.getResultList();
        } catch (Exception ex) {
            return false;
        }
        return true;
    }
}
