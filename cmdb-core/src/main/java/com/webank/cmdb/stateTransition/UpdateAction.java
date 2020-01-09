package com.webank.cmdb.stateTransition;

import java.util.Date;
import java.util.Map;

import javax.persistence.EntityManager;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Maps;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.StateAction;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.CmdbThreadLocal;

@Service
public class UpdateAction implements Action {
    private static Logger logger = LoggerFactory.getLogger(UpdateAction.class);

    @Autowired
    private CiService ciService;

    @Override
    public String getName() {
        return StateAction.Update.getCode();
    }

    @Override
    public Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder entityHolder, Date date) {
        Map<String, Object> updateMap = Maps.newHashMap(ciData);
        MapUtils.putAll(updateMap, new Object[] { CmdbConstants.DEFAULT_FIELD_STATE, transition.getTargetState() });

        if (entityHolder == null) {
            entityHolder = ciService.getCiHolder(ciTypeId, guid);
        }
        entityHolder.update(updateMap, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);
        Object mergedObj = entityManager.merge(entityHolder.getEntityObj());
        return ClassUtils.convertBeanToMap(mergedObj, entityHolder.getEntityMeta(), false);
    }

}
