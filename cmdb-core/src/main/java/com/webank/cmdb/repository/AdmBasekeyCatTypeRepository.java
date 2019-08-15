package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmBasekeyCatType;

public interface AdmBasekeyCatTypeRepository extends JpaRepository<AdmBasekeyCatType, Integer> {
    boolean existsByName(String name);

    boolean existsByCiTypeId(int ciTypeId);

    List<AdmBasekeyCatType> findAllByCiTypeId(int ciTypeId);
}
