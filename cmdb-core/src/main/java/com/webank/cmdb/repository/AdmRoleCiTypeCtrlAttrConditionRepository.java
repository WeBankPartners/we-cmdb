package com.webank.cmdb.repository;

import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AdmRoleCiTypeCtrlAttrConditionRepository   extends JpaRepository<AdmRoleCiTypeCtrlAttrCondition, Integer> {

    Optional<List<AdmRoleCiTypeCtrlAttrCondition>> findByCiTypeAttrIdAndRoleCiTypeCtrlAttrId(Integer ciTypeAttrId, Integer ctlAttrId);
}
