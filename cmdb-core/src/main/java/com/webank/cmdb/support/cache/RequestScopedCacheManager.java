package com.webank.cmdb.support.cache;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.concurrent.ConcurrentMapCache;
import org.springframework.stereotype.Component;

@Component
public class RequestScopedCacheManager implements CacheManager {

    private static final ThreadLocal<Map<String, Cache>> threadLocalCache = new ThreadLocal<Map<String, Cache>>() {
        @Override
        protected Map<String, Cache> initialValue() {
            return new ConcurrentHashMap<String, Cache>();
        }
    };

    @Override
    public Cache getCache(String name) {
        final Map<String, Cache> cacheMap = threadLocalCache.get();
        Cache cache = cacheMap.get(name);
        if (cache == null) {
            cache = createCache(name);
            cacheMap.put(name, cache);
        }
        return cache;
    }

    private Cache createCache(String name) {
        return new ConcurrentMapCache(name);
    }

    @Override
    public Collection<String> getCacheNames() {
        return threadLocalCache.get().keySet();
    }

    public void clearCaches() {
        threadLocalCache.remove();
    }

}

