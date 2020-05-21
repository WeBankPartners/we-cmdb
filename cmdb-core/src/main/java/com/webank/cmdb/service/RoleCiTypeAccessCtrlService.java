package com.webank.cmdb.service;

import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;

import java.util.List;
import java.util.Set;

public interface RoleCiTypeAccessCtrlService extends CmdbService {
    public static String NAME = "RoleCiTypeAccessCtrlService";

    List<RoleCiTypeCtrlAttrConditionDto> createRoleCiTypeCtrlAttrConditions(List<RoleCiTypeCtrlAttrConditionDto> attrConditions);

    List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(List<RoleCiTypeCtrlAttrConditionDto> attrConditions);

    void deleteRoleCiTypeCtrlAttributes(List<Integer> attrIds);

    RoleCiTypeCtrlAttrConditionDto queryRoleCiTypeCtrlAttrCondition(Integer ctlAttrId, Integer ciTypeAttrId);

    void deleteRoleCiTypeCtrlAttrConditions(Set<AdmRoleCiTypeCtrlAttrCondition> attrConditions);
}
