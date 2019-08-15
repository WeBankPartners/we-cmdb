package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmIntegrateTemplateRelation;

public interface AdmIntegrateTemplateRelationRepository extends JpaRepository<AdmIntegrateTemplateRelation, Integer> {

    List<AdmIntegrateTemplateRelation> findByChildRefAttrId(int id);
}
