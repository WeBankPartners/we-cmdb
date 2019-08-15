package com.webank.cmdb.repository;

import java.math.BigInteger;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmCiTypeAttrGroup;

public interface AdmCiTypeAttrGroupRepository extends JpaRepository<AdmCiTypeAttrGroup, Integer> {
    @Query(value = "select count(1) from adm_ci_type_attr_group where id_adm_ci_type_attr in :attrIds GROUP BY id_adm_attr_group", nativeQuery = true)
    List<BigInteger> countByCiTypeAttrIds(@Param("attrIds") List<Integer> attrIds);

    void deleteByAdmAttrGroup_idAdmAttrGroup(int attrGroupId);

    Integer countByAdmAttrGroup_idAdmAttrGroup(int attrGroupId);

    boolean existsByCiTypeAttrId(Integer ciTypeAttrId);
}
