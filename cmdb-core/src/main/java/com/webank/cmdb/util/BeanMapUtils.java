package com.webank.cmdb.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.cglib.beans.BeanMap;

import com.google.common.collect.Maps;

public class BeanMapUtils {
    public static <T> Map<String, Object> convertBeanToMap(T bean) {
        Map<String, Object> map = Maps.newHashMap();
        if (bean != null) {
            BeanMap beanMap = BeanMap.create(bean);
            for (Object key : beanMap.keySet()) {
                if (beanMap.get(key) != null) {
                    map.put(key.toString(), beanMap.get(key));
                }
            }
        }
        return map;
    }

    public static <T> List<Map<String, Object>> convertBeansToMaps(List<T> beans) {
        List<Map<String, Object>> maps = new ArrayList<>();
        beans.forEach(bean -> {
            maps.add(convertBeanToMap(bean));
        });
        return maps;
    }
}
