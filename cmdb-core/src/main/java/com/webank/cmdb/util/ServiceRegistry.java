package com.webank.cmdb.util;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.webank.cmdb.service.CmdbService;

public class ServiceRegistry {
    private static ServiceRegistry instance = new ServiceRegistry();
    private Map<String, CmdbService> services = new ConcurrentHashMap<>();

    public static ServiceRegistry getInstance() {
        return instance;
    }

    public void registe(CmdbService service) {
        services.put(service.getName(), service);
    }

    public <T extends CmdbService> T getService(String serviceName) {
        return (T) services.get(serviceName);
    }
}
