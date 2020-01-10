package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmIntegrateTemplate;

public interface AdmIntegrateTemplateRepository extends JpaRepository<AdmIntegrateTemplate, Integer> {
    List<AdmIntegrateTemplate> findAllByCiTypeIdAndNameContaining(Integer ciType, String name);

    List<AdmIntegrateTemplate> findAllByCiTypeId(Integer ciType);

    @Query(value = "SELECT t.*  FROM adm_integrate_template t " + "INNER JOIN adm_integrate_template_alias al " + "ON t.id_adm_integrate_template = al.id_adm_integrate_template " + "INNER JOIN adm_integrate_template_alias_attr aa "
            + "ON al.id_alias = aa.id_alias " + "WHERE t.ci_type_id = :ciTypeId  AND aa.id_ci_type_attr = :tailAttrId AND aa.id_alias NOT IN " + "(SELECT parent_alias_id FROM adm_integrate_template_relation)", nativeQuery = true)
    List<AdmIntegrateTemplate> findAllByCiTypeIdAndTailAttrId(@Param("ciTypeId") Integer ciType, @Param("tailAttrId") Integer attrId);

    List<AdmIntegrateTemplate> findAllByName(String name);

}
