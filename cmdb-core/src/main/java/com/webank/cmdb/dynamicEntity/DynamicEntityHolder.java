package com.webank.cmdb.dynamicEntity;

import java.lang.reflect.Constructor;
import java.sql.Timestamp;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

import javax.persistence.EntityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cglib.beans.BeanMap;

import com.google.common.base.Strings;
import com.google.common.collect.Sets;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.util.ClassUtils;

public class DynamicEntityHolder {
    private static final long serialVersionUID = 1L;
    private static Logger logger = LoggerFactory.getLogger(DynamicEntityHolder.class);
    private static Set<String> DEFAULT_FIELDS = Sets.newHashSet(CmdbConstants.DEFAULT_FIELD_GUID, CmdbConstants.DEFAULT_FIELD_ROOT_GUID, CmdbConstants.DEFAULT_FIELD_CREATED_DATE, CmdbConstants.DEFAULT_FIELD_UPDATED_DATE,
            CmdbConstants.DEFAULT_FIELD_CREATED_BY, CmdbConstants.DEFAULT_FIELD_UPDATED_BY, CmdbConstants.DEFAULT_FIELD_KEY_NAME);

    private DynamicEntityMeta entityMeta;

    private Object entityObj;
    private BeanMap entityBeanMap;

    private DynamicEntityHolder(DynamicEntityMeta entityMeta) {
        this.entityMeta = entityMeta;
        try {
            Constructor<?> entityConst = entityMeta.getEntityClazz().getConstructor();
            entityObj = entityConst.newInstance();
            entityBeanMap = BeanMap.create(entityObj);
        } catch (Exception e) {
            throw new ServiceException(String.format("Failed to create CI entity bean for CI type (%s)", entityMeta.getQulifiedName()));
        }

    }

    public DynamicEntityHolder(DynamicEntityMeta entityMeta, Object entityObj) {
        this.entityMeta = entityMeta;
        this.entityObj = entityObj;
        entityBeanMap = BeanMap.create(entityObj);
    }

    public void put(Object key, Object val) {
        entityBeanMap.put(key, val);
    }

    public Object get(Object key) {
        return entityBeanMap.get(key);
    }

    public void update(Map<String, ?> ciData, String user, EntityManager entityManager) {
        if (ciData != null) {
            ciData.forEach((updField, updVal) -> {
                if (CmdbConstants.DEFAULT_FIELD_GUID.equals(updField))
                    return;
                FieldNode fn = entityMeta.getFieldNode(updField);
                Object value = updVal;
                if (Set.class.equals(fn.getType())) {
                    // remove existing entity
                    if (fn.getEntityType().equals(DynamicEntityType.MultiSelection)) {
                        Set setVal = (Set) get(updField);
                        for (Object entityBean : setVal) {
                            entityManager.remove(entityBean);
                        }
                        setVal.clear();
                    }
                } else {
                    value = ClassUtils.toObject(fn.getType(), value);
                }

                put(updField, value);
            });
        }
        put(CmdbConstants.DEFAULT_FIELD_UPDATED_DATE, new Timestamp(System.currentTimeMillis()));
        put(CmdbConstants.DEFAULT_FIELD_UPDATED_BY, user);
    }

    public static DynamicEntityHolder createDynamicEntityBean(DynamicEntityMeta entityMeta, Map<String, Object> ciData) {
        DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta);
        ciData.forEach((k, v) -> {
            if (v == null || DEFAULT_FIELDS.contains(v))
                return;

            Class<?> type = entityMeta.getAttrType(k);
            FieldNode fieldNode = entityMeta.getFieldNode(k);
            /*
             * if(DynamicEntityType.MultiSelection.equals(fieldNode.getEntityType())) {
             * List<Integer> codes = (List<Integer>)v; Set<Integer> codeSet = new
             * HashSet(codes); AdmCiTypeAttr attr =
             * attrRepository.getOne(fieldNode.getAttrId()); String intermediaTableName =
             * attr.retrieveJoinTalbeName(); String qulifiedName =
             * DynamicEntityUtils.getEntityQuanlifiedName(intermediaTableName);
             * Class.forName(qulifiedName).newInstance(); entityHolder.put(k,codeSet); }else
             */ {
                if (type.isAssignableFrom(v.getClass())) {
                    entityHolder.put(k, v);
                } else {
                    try {
                        entityHolder.put(k, ClassUtils.toObject(type, String.valueOf(v)));
                    } catch (NumberFormatException ex) {
                        throw new InvalidArgumentException(String.format("Failed to convert value [%s] to number for field [%s]", String.valueOf(v), k));
                    }
                }
            }
        });

        return entityHolder;
    }

    /**
     * Clone given ci data attribute to new one include default fields
     * 
     * @param entityMeta
     * @param fromCiBean
     * @return
     */
    public static DynamicEntityHolder cloneDynamicEntityBean(DynamicEntityMeta entityMeta, Object fromCiBean) {
        org.apache.commons.beanutils.BeanMap fromBeanMap = new org.apache.commons.beanutils.BeanMap(fromCiBean);
        DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta);
        for (String attr : entityHolder.getEntityMeta().getAttrs()) {
            FieldNode fieldNode = entityHolder.getEntityMeta().getFieldNode(attr);
            if (fieldNode.isId()) {
                continue;
            }
            /*
             * if(DynamicEntityType.MultiReference.equals(fieldNode.getEntityType())){
             * continue; }
             */
            entityHolder.put(attr, fromBeanMap.get(attr));
        }
        return entityHolder;
    }

    public void fillAutoFieldsWithDefaultValue(String nextGuid, String rGuid, Integer state, String user) {
        put(CmdbConstants.DEFAULT_FIELD_GUID, nextGuid);
        put(CmdbConstants.DEFAULT_FIELD_ROOT_GUID, Strings.isNullOrEmpty(rGuid) ? nextGuid : rGuid);
        put(CmdbConstants.DEFAULT_FIELD_CREATED_DATE, new Timestamp(System.currentTimeMillis()));
        put(CmdbConstants.DEFAULT_FIELD_UPDATED_DATE, new Timestamp(System.currentTimeMillis()));
        put(CmdbConstants.DEFAULT_FIELD_CREATED_BY, user);
        put(CmdbConstants.DEFAULT_FIELD_UPDATED_BY, user);
        if (state != null) {
            put(CmdbConstants.DEFAULT_FIELD_STATE, state);
        }
        put(CmdbConstants.DEFAULT_FIELD_KEY_NAME, "key_" + nextGuid);
    }

    public static DynamicEntityHolder createDynamicEntityBean(DynamicEntityMeta entityMeta, Object[] data) {
        DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta);
        final AtomicInteger i = new AtomicInteger(0);

        entityMeta.getAllFieldNodes(false).forEach(x -> {
            // String attrName = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL,
            // x.getColumn());
            String attrName = x.getColumn();
            Class<?> attrType = x.getType();
            Object obj = data[i.getAndIncrement()];
            if (obj == null) {
                return;
            } else {
                if (attrType.equals(obj.getClass())) {
                    entityHolder.put(attrName, obj);
                } else {

                }
            }
        });
        return entityHolder;
    }

    public DynamicEntityMeta getEntityMeta() {
        return entityMeta;
    }

    public void setEntityMeta(DynamicEntityMeta entityMeta) {
        this.entityMeta = entityMeta;
    }

    public Object getEntityObj() {
        return entityObj;
    }

    public BeanMap getEntityBeanMap() {
        return entityBeanMap;
    }

    public void setEntityBeanMap(BeanMap entityBeanMap) {
        this.entityBeanMap = entityBeanMap;
    }

}
