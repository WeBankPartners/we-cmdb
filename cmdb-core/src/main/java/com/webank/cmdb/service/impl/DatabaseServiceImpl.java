package com.webank.cmdb.service.impl;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
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
        int executeUpdate = query.executeUpdate();
    }
    @Transactional
    @Override
    public List<Object> executeQuerySQl(String ddlSql) {
        Query query = entityManager.createNativeQuery(ddlSql);
        @SuppressWarnings("unchecked")
		List<Object> resultList = query.getResultList();
		return resultList;
    }
    
    @SuppressWarnings("unchecked")
	@Transactional
    @Override
    public <T> List<T> queryProxyEntity(EntityManager entityManager,Class<T> t, String tableName) {
		/*
		 * CriteriaQuery<T> createQuery =
		 * entityManager.getCriteriaBuilder().createQuery(t); Root<T> root =
		 * createQuery.from(t); createQuery.select(root); TypedQuery<?> typedQuery =
		 * entityManager.createQuery(createQuery);
		 */

    	//List<?> resultList = typedQuery.getResultList();
    	Query createNativeQuery = entityManager.createNativeQuery("select * from  `"+tableName+"`", t);
    	List resultList2 = createNativeQuery.getResultList();
		return (List<T>) resultList2;
    }
    
}
