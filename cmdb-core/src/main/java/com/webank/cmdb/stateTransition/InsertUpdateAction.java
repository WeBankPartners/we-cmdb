package com.webank.cmdb.stateTransition;

import java.util.Date;
import java.util.Map;
import java.util.Optional;

import javax.persistence.EntityManager;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Maps;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.StateAction;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.CmdbThreadLocal;

/**
 * 1. clone current ci record as parent 2. update current
 * 
 * @author graychen
 *
 */
@Service
public class InsertUpdateAction implements Action {
    private static Logger logger = LoggerFactory.getLogger(InsertUpdateAction.class);

    @Autowired
    private AdmBasekeyCodeRepository codeRepisotory;

    @Autowired
    private CiService ciService;

    @Override
    public Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder entityHolder, Date date) {
        Object ciBean = ciService.cloneCiAsParent(entityManager, ciTypeId, guid);
        entityHolder = new DynamicEntityHolder(entityHolder.getEntityMeta(), ciBean);

        entityHolder.update(ciData, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);
        Map<String, Object> updateMap = Maps.newHashMap();
        MapUtils.putAll(updateMap, new Object[] { CmdbConstants.DEFAULT_FIELD_STATE, transition.getTargetState(), CmdbConstants.DEFAULT_FIELD_FIXED_DATE, null });

        entityHolder.put(CmdbConstants.DEFAULT_FIELD_STATE, transition.getTargetState());
        entityHolder.put(CmdbConstants.DEFAULT_FIELD_FIXED_DATE, null);
        Object mergedObj = entityManager.merge(entityHolder.getEntityObj());

        entityManager.flush();
        Optional<AdmBasekeyCode> codeOpt = codeRepisotory.findById(transition.getTargetState());
        logger.info("Updating ci [{}] to state [{}({})]", guid, transition.getTargetState(), transition.getTargetState(), codeOpt.isPresent() ? codeOpt.get().getCode() : "");
        return ClassUtils.convertBeanToMap(mergedObj, ciService.getDynamicEntityMeta(ciTypeId), false);
    }

    @Override
    public String getName() {
        return StateAction.InsertUpdate.getCode();
    }

}
