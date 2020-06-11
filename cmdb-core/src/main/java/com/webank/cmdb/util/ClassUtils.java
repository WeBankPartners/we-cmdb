package com.webank.cmdb.util;

import java.lang.reflect.Field;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.base.Strings;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.support.exception.ServiceException;

import sun.reflect.generics.reflectiveObjects.ParameterizedTypeImpl;

public class ClassUtils {
    private static Logger logger = LoggerFactory.getLogger(ClassUtils.class);

    public static Object toObject(Class<?> clazz, Object value) {
        if (value == null)
            return null;
        if (clazz.equals(value.getClass()) || clazz.isAssignableFrom(value.getClass())) {
            return value;
        }
        String strVal = String.valueOf(value);
        if (Strings.isNullOrEmpty(strVal))
            return null;

        if (Boolean.class == clazz || boolean.class == clazz)
            return Boolean.parseBoolean(strVal);
        if (Byte.class == clazz || byte.class == clazz)
            return Byte.parseByte(strVal);
        if (Short.class == clazz || short.class == clazz)
            return Short.parseShort(strVal);
        if (Integer.class == clazz || int.class == clazz) {
            try {
                return Integer.parseInt(strVal);
            } catch (NumberFormatException numEx) {
                return Boolean.TRUE.equals(Boolean.parseBoolean(strVal)) ? 1 : 0;
            }
        }
        if (Long.class == clazz || long.class == clazz)
            return Long.parseLong(strVal);
        if (Float.class == clazz || float.class == clazz)
            return Float.parseFloat(strVal);
        if (Double.class == clazz || double.class == clazz)
            return Double.parseDouble(strVal);
        if (Timestamp.class == clazz || java.util.Date.class == clazz)
            return new Timestamp(DateUtils.convertToTimestamp((String) value).getTime());

        logger.warn("Can not conert from value [{}] to class [{}], just return value.", value, clazz.toString());
        // throw new ServiceException(String.format("Can not conver object (clazz:%s,
        // value:%s)",clazz.toString(),strVal));
        return value;
    }

    public static <T extends ResourceDto<T, ?>> Map<String, Class<?>> getAllDtoRefResources(Class<T> dtoClazz) {
        Map<String, Class<?>> refResourceMap = new HashMap<>();

        Field[] fields = dtoClazz.getDeclaredFields();
        for (Field field : fields) {
            Class<?> type = field.getType();
            String dtoFieldName = field.getName();
            if (!type.getPackage().equals(java.lang.Integer.class.getPackage())) {
                if (type.equals(java.util.List.class)) {
                    ParameterizedTypeImpl t = (ParameterizedTypeImpl) field.getGenericType();
                    Class argType = null;
                    try {
                        argType = Class.forName(t.getActualTypeArguments()[0].getTypeName());
                    } catch (ClassNotFoundException e) {
                    }
                    refResourceMap.put(dtoFieldName, argType);
                } else {
                    refResourceMap.put(dtoFieldName, type);
                }
            }
        }

        return refResourceMap;
    }

    public static Map<String, String> getDtoToDomainFieldMap(Class dtoClzz) {
        final Map<String, String> dtoToDomainFieldMap = new HashMap<>();
        Field[] fields = dtoClzz.getDeclaredFields();
        for (Field field : fields) {
            String dtoFieldName = field.getName();
            DtoField domainField = field.getAnnotation(DtoField.class);
            if (domainField != null) {
                String domainFieldName = domainField.domainField();
                if (Strings.isNullOrEmpty(domainFieldName))
                    dtoToDomainFieldMap.put(dtoFieldName, dtoFieldName);
                else
                    dtoToDomainFieldMap.put(dtoFieldName, domainFieldName);
            } else
                dtoToDomainFieldMap.put(dtoFieldName, dtoFieldName);
        }
        return dtoToDomainFieldMap;
    }

    public static <T extends ResourceDto> String getDtoIdField(Class<T> dtoClzz) {
        Field[] fields = dtoClzz.getDeclaredFields();
        for (Field field : fields) {
            DtoId id = field.getAnnotation(DtoId.class);
            if (id != null) {
                return field.getName();
            }
        }
        throw new ServiceException(String.format("Can not find out id field for the DTO class [%s]", dtoClzz.toString()));
    }

    public static Map<String, Object> convertBeanToMap(Object ciObj, DynamicEntityMeta entityMeta, boolean includeNullVal) {
        return convertBeanToMap(ciObj, entityMeta, includeNullVal, new ArrayList<>());
    }

    public static Map<String, Object> convertBeanToMap(Object ciObj, DynamicEntityMeta entityMeta, boolean includeNullVal, List<String> requestFields) {
        Map<String, Object> ciMap = new HashMap<>();
        BeanMap ciObjMap = new BeanMap(ciObj);
        Collection<FieldNode> nodes = entityMeta.getAllFieldNodes(false);
        for (FieldNode node : nodes) {
            String name = node.getName();
            if (isRequestField(requestFields, name)) {
                Object val = ciObjMap.get(name);
                if (includeNullVal) {
                    ciMap.put(name, val);
                } else {
                    if (val != null) {
                        ciMap.put(name, val);
                    }
                }
            }
        }
        return ciMap;
    }

    private static boolean isRequestField(List<String> requestFields, String name) {
        return requestFields == null || requestFields.isEmpty() || requestFields.contains(name);
    }
}
