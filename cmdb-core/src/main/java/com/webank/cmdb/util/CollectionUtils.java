package com.webank.cmdb.util;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanMap;
import org.apache.logging.log4j.util.Strings;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Sets;

public class CollectionUtils {
    @SuppressWarnings("unchecked")
    static public ImmutableMap<?, ?> toImmutableMap(Object... pairs) {
        if (pairs.length % 2 != 0) {
            throw new IllegalArgumentException("The length of pairs arrays should be even num.");
        }

        @SuppressWarnings("rawtypes")
        ImmutableMap.Builder builder = ImmutableMap.builder();
        for (int i = 0; i < pairs.length / 2; i++) {
            builder.put(pairs[2 * i], pairs[2 * i + 1]);
        }
        return builder.build();
    }

    static public List<String> filterCurrentResourceLevel(List<String> resources, String curRes) {
        List<String> nextLevelReses = new LinkedList<>();
        String dotRes = curRes + ".";
        resources.forEach(x -> {
            if (x.startsWith(curRes)) {
                String nextRes = x.substring(curRes.length());
                if (!Strings.isEmpty(nextRes)) {
                    nextLevelReses.add(nextRes);
                }
            }
            if (x.startsWith(dotRes)) {
                String nextRes = x.substring(dotRes.length());
                if (!Strings.isEmpty(nextRes)) {
                    nextLevelReses.add(nextRes);
                }
            }
        });
        return nextLevelReses;
    }

    static public <T> List<T> asLinkedList(T[] arr) {
        List<T> ll = new LinkedList<>();
        for (T t : arr) {
            ll.add(t);
        }
        return ll;
    }

    static public List clone(List src, List dest) throws CloneNotSupportedException {
        for (Object obj : src) {
            BeanMap cloneBM = (BeanMap) (new BeanMap(obj).clone());
            dest.add(cloneBM.getBean());
        }
        return dest;
    }

    static public <T> Map<String, T> retainsEntries(Map<String, T> map, Set<String> retainKeys) {
        Set<String> allKeys = Sets.newHashSet(map.keySet());
        allKeys.removeAll(retainKeys);
        allKeys.forEach(map::remove);
        return map;
    }

}
