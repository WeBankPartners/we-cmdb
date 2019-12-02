package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmBasekeyCode;

@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "admBasekeyCodeRepository")
public interface AdmBasekeyCodeRepository extends JpaRepository<AdmBasekeyCode, Integer> {
    @Query(value = "select max(seq_no) from adm_basekey_code where id_adm_basekey_cat = :catId", nativeQuery = true)
    Integer getMaxSeqNoByCatId(@Param("catId") int catId);

    @Query(value = "select count(1) from adm_basekey_code where id_adm_basekey_cat = :catId and code = :code", nativeQuery = true)
    int countByCatIdAndCode(@Param("catId") int catId, @Param("code") String code);

    @Query(value = "select count(1) from adm_basekey_code where id_adm_basekey_cat = :catId and id_adm_basekey != :codeId and code = :code", nativeQuery = true)
    int countForSameCatAndCode(@Param("catId") int catId, @Param("codeId") int codeId, @Param("code") String code);

    @Query(value = "select * from adm_basekey_code where id_adm_basekey_cat = :catId and seq_no < :seqNo order by seq_no desc limit 1", nativeQuery = true)
    AdmBasekeyCode getForLessSeq(@Param("catId") int catId, @Param("seqNo") int seqNo);

    @Query(value = "select * from adm_basekey_code where id_adm_basekey_cat = :catId and seq_no > :seqNo order by seq_no asc limit 1", nativeQuery = true)
    AdmBasekeyCode getForLargerSeq(@Param("catId") int catId, @Param("seqNo") int seqNo);

    List<AdmBasekeyCode> findByAdmBasekeyCat_idAdmBasekeyCat(int catId);

    AdmBasekeyCode findFirstByAdmBasekeyCat_catNameAndCode(String catName, String code);

    public static interface EnumInfo {
        String getCatName();

        String getCode();

        String getValue();

        String getGroupCode();

        String getGroupName();

        String getDescription();
    }

    Page<EnumInfo> findAll(Specification<AdmBasekeyCode> spec, Pageable pageable);

    AdmBasekeyCode findByCatIdAndCode(int catId, String code);

    List<AdmBasekeyCode> findByGroupCodeId(int groupCodeId);

    AdmBasekeyCode findFirstByCatIdOrderBySeqNoDesc(Integer catId);

    boolean existsByCatIdAndValueAndGroupCodeId(Integer catId, String value, Integer groupCodeId);
    
    boolean existsByCatIdAndValue(Integer catId, String value);

    boolean existsByCatIdAndValueAndIdAdmBasekeyNot(Integer catId, String value, Integer codeId);
    
    boolean existsByCatIdAndValueAndGroupCodeIdAndIdAdmBasekeyNot(Integer catId, String code, Integer groupCodeId, Integer codeId);
  
    boolean existsByCatIdAndCodeAndGroupCodeId(Integer catId, String code, Integer groupCodeId);

    boolean existsByCatIdAndCode(Integer catId, String code);

    boolean existsByCatIdAndCodeAndIdAdmBasekeyNot(Integer catId, String code, Integer codeId);
    
    boolean existsByCatIdAndCodeAndGroupCodeIdAndIdAdmBasekeyNot(Integer catId, String code, Integer groupCodeId, Integer codeId);

    boolean existsByCatIdAndIdAdmBasekey(Integer catId, Integer codeId);

    @Query(value = "select * from adm_basekey_code where id_adm_basekey_cat = :catId and :fieldName = :value", nativeQuery = true)
    List<AdmBasekeyCode> findByCatIdAndFieldName(Integer catId, String fieldName, Object value);

    //for cache purpose
    @Cacheable("basekeyCode-getOne")
    AdmBasekeyCode getOne(Integer id);
    
    @Cacheable("basekeyCode-existsById")
    boolean existsById(Integer id);

}
