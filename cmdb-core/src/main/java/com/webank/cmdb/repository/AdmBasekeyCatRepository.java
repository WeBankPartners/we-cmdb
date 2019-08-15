package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmBasekeyCat;

public interface AdmBasekeyCatRepository extends JpaRepository<AdmBasekeyCat, Integer> {
    AdmBasekeyCat findAllByCatName(String catName);

    List<AdmBasekeyCat> findAllByGroupTypeId(Integer groupTypeId);

    List<AdmBasekeyCat> findAllByIdAdmBasekeyCatType(Integer idAdmBasekeyCatType);

    @Query(value = "select count(1) from adm_basekey_cat where cat_name = :catName and id_adm_basekey_cat_type = :catTypeId", nativeQuery = true)
    int countByCatNameAndCatType(@Param("catName") String catName, @Param("catTypeId") int catTypeId);

    boolean existsByCatNameAndIdAdmBasekeyCatType(String catName, int idAdmBasekeyCatType);

    boolean existsByCatNameAndIdAdmBasekeyCatTypeAndIdAdmBasekeyCatNot(String catName, int idAdmBasekeyCatType, int idAdmBasekeyCat);
}
