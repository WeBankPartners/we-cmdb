package com.webank.cmdb.stateTransition;

import java.util.Date;
import java.util.Map;

import javax.persistence.EntityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.StateAction;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.service.CiService;

@Service
public class InsertAction implements Action {
    private static Logger logger = LoggerFactory.getLogger(InsertAction.class);

    @Autowired
    private CiService ciService;

    @Override
    public String getName() {
        return StateAction.Insert.getCode();
    }

    @Override
    public Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder entityHolder, Date date) {
//        DynamicEntityHolder createdEntityHolder = ciService.doCreate(entityManager, ciTypeId, null,transition.getTargetState(), ciData, false);
        ciData.put(CmdbConstants.DEFAULT_FIELD_STATE, transition.getTargetState());
        return ciData;
    }

}
