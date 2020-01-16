package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.webank.cmdb.domain.AdmRole;

public interface AdmRoleRepository extends JpaRepository<AdmRole, Integer> {
    AdmRole findByRoleName(String roleName);
    @Query(value = "SELECT * FROM adm_role WHERE role_name IN :roleNames", nativeQuery = true)
    List<AdmRole> findByRoleNames(String... roleNames);
}
