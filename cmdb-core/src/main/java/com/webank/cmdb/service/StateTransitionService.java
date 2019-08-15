package com.webank.cmdb.service;

import java.util.List;

public interface StateTransitionService {

    List<String> queryOperation(Integer curState, Integer targetState, Boolean isConfirmed);

}
