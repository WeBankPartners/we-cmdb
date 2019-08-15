package com.webank.cmdb.dynamicEntity;

import java.net.URL;

import org.hibernate.boot.registry.classloading.internal.ClassLoaderServiceImpl;

public class CiClassLoaderService extends ClassLoaderServiceImpl {
    private static final long serialVersionUID = 1L;

    private ClassLoader classLoader;

    public CiClassLoaderService(ClassLoader classLoader) {
        super(classLoader);
        this.classLoader = classLoader;
    }

    @Override
    public URL locateResource(String name) {
        return classLoader.getResource(name);
    }
}
