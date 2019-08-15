package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.webank.cmdb.domain.AdmRoleCiType;

public interface RoleCiTypeRepository extends JpaRepository<AdmRoleCiType, Integer> {

    @Cacheable("role-citypes")
    @Query("SELECT DISTINCT rct FROM AdmRoleCiType rct " + " LEFT JOIN FETCH rct.admRole r" + " LEFT JOIN FETCH rct.admRoleCiTypeCtrlAttrs rcta " + " LEFT JOIN FETCH rcta.admRoleCiTypeCtrlAttrConditions c "
            + " LEFT JOIN FETCH c.admCiTypeAttr cta" + " WHERE rct.ciTypeId=:ciTypeId and rct.roleId in :roleIds")
    List<AdmRoleCiType> findAdmRoleCiTypesByCiTypeIdAndRoleIds(Integer ciTypeId, List<Integer> roleIds);
}
