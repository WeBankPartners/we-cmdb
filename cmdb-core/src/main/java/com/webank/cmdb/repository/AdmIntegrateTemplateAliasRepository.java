package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmIntegrateTemplateAlias;

public interface AdmIntegrateTemplateAliasRepository extends JpaRepository<AdmIntegrateTemplateAlias, Integer> {

    List<AdmIntegrateTemplateAlias> findByCiTypeId(int id);
}
