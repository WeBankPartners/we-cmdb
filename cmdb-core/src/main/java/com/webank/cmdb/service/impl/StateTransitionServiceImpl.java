package com.webank.cmdb.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Lists;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.repository.AdmStateTransitionRepository;
import com.webank.cmdb.service.StateTransitionService;

@Service
public class StateTransitionServiceImpl implements StateTransitionService {
    @Autowired
    private AdmStateTransitionRepository stateTransitionRepository;

    @Override
    public List<String> queryOperation(Integer curState, Integer targetState, Boolean isConfirmed) {
        int isConfirmedFlag = isConfirmed == null ? 0 : (isConfirmed ? 1 : 0);
        List<AdmStateTransition> stateTransitions = stateTransitionRepository.findByCurrentStateAndCurrentStateIsConfirmedAndTargetState(curState, isConfirmedFlag, targetState);

        List<String> operations = Lists.newLinkedList();
        stateTransitions.forEach(trans -> {
            if (trans.getOperationCode() != null) {
                operations.add(trans.getOperationCode().getCode());
            }
        });
        return operations;
    }

}
