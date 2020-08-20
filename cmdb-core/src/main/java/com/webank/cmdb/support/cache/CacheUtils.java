package com.webank.cmdb.support.cache;

import com.webank.cmdb.support.exception.CmdbException;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;

import java.util.concurrent.Callable;

public class CacheUtils {
    public static Object cacheLocaleCall(CacheManager cacheManager, String cacheName,Object key, Callable process){
        Cache cache = cacheManager.getCache(cacheName);
        Cache.ValueWrapper vw = cache.get(key);
        if(vw!=null && vw.get() != null){
            return vw.get();
        }

        Object result = null;
        try {
            result = process.call();
        }catch(Exception ex){
            throw new CmdbException("Exception happen ",ex);
        }

        cache.put(key,result);
        return result;
    }
}
