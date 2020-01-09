package com.webank.cmdb.stateTransition;

import java.util.Date;
import java.util.Map;

import javax.persistence.EntityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Maps;
import com.webank.cmdb.constant.StateAction;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.service.CiService;

@Service
public class DeleteAction implements Action {
    private static Logger logger = LoggerFactory.getLogger(DeleteAction.class);

    @Autowired
    private CiService ciService;

    @Override
    public String getName() {
        return StateAction.Delete.getCode();
    }

    @Override
    public Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder entityHolder,Date date) {
        // need call Ci service to delete for validation instead of delete directly
        ciService.doDelete(entityManager, ciTypeId, guid, false);
        logger.info("Deleted ci [{}:{}]", ciTypeId, guid);
        return Maps.newHashMap();
    }

}
