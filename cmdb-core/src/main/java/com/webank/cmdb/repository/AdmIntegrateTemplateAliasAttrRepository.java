package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmIntegrateTemplateAliasAttr;

public interface AdmIntegrateTemplateAliasAttrRepository extends JpaRepository<AdmIntegrateTemplateAliasAttr, Integer> {

    List<AdmIntegrateTemplateAliasAttr> findByCiTypeAttrId(int id);
}
