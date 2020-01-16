package com.webank.cmdb.util;

import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.google.common.collect.Maps;

public class CmdbThreadLocal extends ThreadLocal<Map<String, Object>> {
    private static final String CURRENT_USER = "current_user";
    private Set<String> grantedAuthorities = new HashSet<String>();

    private static CmdbThreadLocal instance = new CmdbThreadLocal();

    public static CmdbThreadLocal getIntance() {
        return instance;
    }

    private CmdbThreadLocal() {
    }

    public String getCurrentUser() {
        return (String) getOrCreate().get(CURRENT_USER);
    }

    public void putCurrentUser(String username) {
        getOrCreate().put(CURRENT_USER, username);
    }

    public void cleanCurrentUser() {
        getOrCreate().remove(CURRENT_USER);
    }

    private Map<String, Object> getOrCreate() {
        if (get() == null) {
            set(Maps.newHashMap());
        }
        return get();
    }

    public Set<String> getAuthorities() {
        return Collections.unmodifiableSet(this.grantedAuthorities);
    }

    public CmdbThreadLocal withAuthorities(String... authorities) {
        for (String authority : authorities) {
            if (!grantedAuthorities.contains(authority)) {
                grantedAuthorities.add(authority);
            }
        }

        return this;
    }
}
