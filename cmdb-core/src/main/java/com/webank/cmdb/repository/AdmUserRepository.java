package com.webank.cmdb.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmUser;

public interface AdmUserRepository extends JpaRepository<AdmUser, Integer> {

    AdmUser findByCode(String code);
}
