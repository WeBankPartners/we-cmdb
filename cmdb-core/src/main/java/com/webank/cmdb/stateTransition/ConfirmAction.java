package com.webank.cmdb.stateTransition;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.persistence.EntityManager;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.StateAction;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.CmdbThreadLocal;

/**
 * Update fixed_date from null to date string (confirmed state) One ci record
 * just can be confirmed for one time.
 * 
 * @author graychen
 *
 */

@Service
public class ConfirmAction implements Action {
    private static Logger logger = LoggerFactory.getLogger(ConfirmAction.class);

    @Autowired
    private CiService ciService;

    @Override
    public String getName() {
        return StateAction.Confirm.getCode();
    }

    @Override
    public Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder ciHolder, Date date) {
        SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (ciHolder == null) {
            ciHolder = ciService.getCiHolder(ciTypeId, guid);
        }
        String fixedDate = (String) ciHolder.get(CmdbConstants.DEFAULT_FIELD_FIXED_DATE);
        if (!Strings.isNullOrEmpty(fixedDate)) {
            throw new InvalidArgumentException(String.format("The Ci [%s] has been confirmed, can not be confirmed again.", guid));
        }
        if(date != null) {
            fixedDate = dateFmt.format(date);
            
        }else {
            fixedDate = dateFmt.format(new Date());
            
        }
        Map<String, Object> updateMap = Maps.newHashMap();
        int targetState = transition.getTargetState();
        MapUtils.putAll(updateMap, new Object[] { CmdbConstants.GUID, guid, CmdbConstants.DEFAULT_FIELD_FIXED_DATE, fixedDate, CmdbConstants.DEFAULT_FIELD_STATE, targetState });

        ciHolder.update(updateMap, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);

        entityManager.merge(ciHolder.getEntityObj());
        logger.info("Update fixed_date to {} on ci [{}:{}]", fixedDate, ciTypeId, guid);
        return ClassUtils.convertBeanToMap(ciHolder.getEntityObj(), ciHolder.getEntityMeta(), false);
    }
}
