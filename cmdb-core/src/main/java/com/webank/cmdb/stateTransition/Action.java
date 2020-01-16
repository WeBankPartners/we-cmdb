package com.webank.cmdb.stateTransition;

import java.util.Date;
import java.util.Map;

import javax.persistence.EntityManager;

import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;

public interface Action {
    String getName();

    Map<String, Object> perform(EntityManager entityManager, int ciTypeId, String guid, AdmStateTransition transition, Map<String, Object> ciData, DynamicEntityHolder ciHolder, Date date);
}
