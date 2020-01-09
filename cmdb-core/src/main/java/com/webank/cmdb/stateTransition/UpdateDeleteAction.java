package com.webank.cmdb.stateTransition;

import java.util.Collection;
import java.util.Date;
import java.util.Map;

import javax.persistence.EntityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.StateAction;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.dynamicEntity.MultiValueFeildOperationUtils;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.CmdbThreadLocal;

/**
 * 1. Update parent ci fields to current ci record 2. Delete parent ci
 * 
 * @author graychen
 *
 */
@Service
public class UpdateDeleteAction implements Action {
    private static Logger logger = LoggerFactory.getLogger(UpdateDeleteAction.class);

    @Autowired
    private CiService ciService;

    @Override
    public String getName() {
        return StateAction.UpdateDelete.getCode();
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    public Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder ciHolder, Date date) {
        if (ciHolder == null) {
            ciHolder = ciService.getCiHolder(ciTypeId, guid);
        }

        DynamicEntityMeta meta = ciHolder.getEntityMeta();
        Collection<FieldNode> fieldNodes = MultiValueFeildOperationUtils.ClearMultValueFieldsForDiscard(entityManager, ciHolder, meta);

        String pGuid = (String) ciHolder.get(CmdbConstants.DEFAULT_FIELD_PARENT_GUID);
        if (Strings.isNullOrEmpty(pGuid)) {
            throw new InvalidArgumentException(String.format("Can not find parent guid for ci [%d:%s]", ciTypeId, guid));
        }
        DynamicEntityHolder pCiHolder = ciService.getCiHolder(ciTypeId, pGuid);
        MultiValueFeildOperationUtils.rollbackMultValueFieldsForDiscard(entityManager, guid, ciHolder, fieldNodes, pCiHolder);

        Map<String, Object> pCiMap = ClassUtils.convertBeanToMap(pCiHolder.getEntityObj(), pCiHolder.getEntityMeta(), true);
        ciHolder.update(pCiMap, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);

        entityManager.merge(ciHolder.getEntityObj());
        // entityManager.remove(pCiHolder.getEntityObj());
        Object pCi = entityManager.find(ciHolder.getEntityMeta().getEntityClazz(), pGuid);
        if (pCi != null) {
            entityManager.remove(pCi);
        }
        return ClassUtils.convertBeanToMap(ciHolder.getEntityObj(), ciHolder.getEntityMeta(), false);
    }

}
