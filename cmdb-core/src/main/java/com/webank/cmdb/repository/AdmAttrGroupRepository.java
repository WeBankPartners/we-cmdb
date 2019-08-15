package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmAttrGroup;

public interface AdmAttrGroupRepository extends JpaRepository<AdmAttrGroup, Integer> {
    public interface AttGroup {
        int getAttrGroupId();
    }

    @Query(value = "SELECT DISTINCT g.id_adm_attr_group \r\n" + "	FROM adm_ci_type_attr_group ag \r\n" + "	JOIN adm_attr_group g ON g.id_adm_attr_group = ag.id_adm_attr_group \r\n"
            + "	JOIN  adm_ci_type_attr a ON ag.id_adm_ci_type_attr=a.id_adm_ci_type_attr\r\n" + "	JOIN adm_ci_type t ON t.id_adm_ci_type = a.id_adm_ci_type \r\n" + "	WHERE t.id_adm_ci_type = :admCiTypeId", nativeQuery = true)
    List<Integer> findAdmAttrGroupId(@Param("admCiTypeId") int admCiTypeId);

    @Query(value = "select count(`name`) from adm_attr_group where `name` = :name", nativeQuery = true)
    int countByName(String name);
}
