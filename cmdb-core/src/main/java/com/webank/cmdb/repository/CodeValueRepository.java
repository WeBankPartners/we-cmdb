package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.webank.cmdb.domain.AdmCodeValue;

public interface CodeValueRepository extends JpaRepository<AdmCodeValue, Integer>{
    //@Query("SELECT *  FROM AdmCodeValue")
    List<AdmCodeValue> findAll();
}
