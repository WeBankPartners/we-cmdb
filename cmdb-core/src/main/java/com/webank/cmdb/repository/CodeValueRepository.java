package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmCodeValue;
public interface CodeValueRepository extends JpaRepository<AdmCodeValue, Integer>{
    List<AdmCodeValue> findAll();
}
