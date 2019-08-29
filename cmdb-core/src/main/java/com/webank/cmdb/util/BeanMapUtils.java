package com.webank.cmdb.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanMap;
import org.apache.commons.beanutils.BeanUtils;

import com.webank.cmdb.exception.CmdbException;

public class BeanMapUtils {
    public static Map<String, Object> convertBeanToMap(Object bean) {
        Map<String, Object> map = new HashMap<>();
        try {
            BeanUtils.populate(new BeanMap(bean), map);
        } catch (Exception e) {
            throw new CmdbException(String.format("Populate bean[%s] to map error.", bean));
        }
        return map;
    }

    public static List<Map<String, Object>> convertBeanToMap(List<Object> beans) {
        List<Map<String, Object>> maps = new ArrayList<>();
        beans.forEach(bean -> {
            maps.add(convertBeanToMap(bean));
        });
        return maps;
    }
}
