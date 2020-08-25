package com.webank.cmdb.util;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

import com.google.common.collect.Maps;
import com.webank.cmdb.support.exception.ServiceException;

public class PriorityEntityManager {
    private static final String ENTITY_MANAGE = "em";

    private EntityManagerFactory entityManagerFactory;
    private boolean isEmCreated = false;
    private EntityManager entityManager;

    public PriorityEntityManager(EntityManagerFactory entityManagerFactory) {
        this.entityManagerFactory = entityManagerFactory;
    }

    public EntityManager getEntityManager() {
        Map<String, Object> threadMap = CmdbThreadLocal.getIntance().get();
        if (threadMap == null) {
            threadMap = Maps.newHashMap();
            CmdbThreadLocal.getIntance().set(threadMap);
        } else {
            entityManager = (EntityManager) threadMap.get(ENTITY_MANAGE);
        }

        if (entityManager == null) {
            entityManager = entityManagerFactory.createEntityManager();
            isEmCreated = true;
            threadMap.put(ENTITY_MANAGE, entityManager);
        }
        return getProxy(entityManager);
    }

    private EntityManager getProxy(EntityManager entityManager) {
        Object proxy = Proxy.newProxyInstance(this.getClass().getClassLoader(), new Class[] { EntityManager.class }, new InvocationHandler() {

            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                if (method.getName() == "close" && void.class.equals(method.getReturnType())) {
                    throw new ServiceException("3103", "EntityManager close method should not be called directly.");
                } else {
                    return method.invoke(entityManager, args);
                }
            }

        });
        return (EntityManager) proxy;
    }

    public void close() {
        if (isEmCreated) {
            entityManager.close();

            Map<String, Object> threadMap = CmdbThreadLocal.getIntance().get();
            if (threadMap != null) {
                threadMap.remove(ENTITY_MANAGE);
            }
        }

    }
}
