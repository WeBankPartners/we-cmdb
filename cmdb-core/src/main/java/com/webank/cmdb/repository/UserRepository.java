package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.webank.cmdb.domain.AdmRole;
import com.webank.cmdb.domain.AdmUser;

public interface UserRepository extends JpaRepository<AdmUser, String> {
    AdmUser findByName(String name);

    @Cacheable("user-roles")
    @Query("SELECT DISTINCT role FROM AdmUser user JOIN user.admRoleUsers ru JOIN ru.admRole role WHERE user.name = :username")
    List<AdmRole> findRolesByUserName(String username);
    Boolean existsByCode(String code);
}
