package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmMenu;

public interface AdmMenusRepository extends JpaRepository<AdmMenu, Integer> {
    @Query(value = "SELECT DISTINCT d.* FROM ((adm_user a LEFT JOIN adm_role_user b ON a.id_adm_user = b.id_adm_user) LEFT JOIN adm_role_menu c ON b.id_adm_role = c.id_adm_role) LEFT JOIN adm_menu d ON c.id_adm_menu = d.id_adm_menu WHERE a.code = :username AND d.id_adm_menu IS NOT NULL", nativeQuery = true)
    List<AdmMenu> findMenusByUserName(@Param("username") String username);

    @Query(value = "SELECT * FROM adm_menu menu, adm_role_menu role WHERE menu.id_adm_menu = role.id_adm_menu and role.id_adm_role IN :roleIds", nativeQuery = true)
    List<AdmMenu> findAdmMenusByRoles(Integer... roleIds);

    AdmMenu findByName(String name);
}
