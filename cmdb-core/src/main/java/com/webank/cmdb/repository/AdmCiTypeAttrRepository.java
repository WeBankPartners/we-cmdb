package com.webank.cmdb.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import org.apache.commons.beanutils.BeanMap;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmCiTypeAttr;

import javax.persistence.EntityManager;

@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "admCiTypeAttrRepository")
public interface AdmCiTypeAttrRepository extends JpaRepository<AdmCiTypeAttr, Integer> {
    @Cacheable("admCiTypeAttrRepository-findAllByCiTypeId")
    List<AdmCiTypeAttr> findAllByCiTypeId(Integer ciTypeId);

    @Cacheable("admCiTypeAttrRepository-findAllByAdmCiType_idAdmCiTypeAndStatus")
    List<AdmCiTypeAttr> findAllByAdmCiType_idAdmCiTypeAndStatus(Integer ciTypeId, List<String> statuses);

    /**
     * Find out the CI types which are referenced by given ciTypeId
     * 
     * @param ciTypeId
     * @param inputType
     * @return
     */
    List<AdmCiTypeAttr> findByAdmCiType_idAdmCiTypeAndInputTypeAndReferenceIdNotNull(Integer ciTypeId, String inputType);

    /**
     * Find out the CI types which reference to given ciTypeId
     * 
     * @param inputType
     * @param ciTypeId
     * @return
     */

    List<AdmCiTypeAttr> findByInputTypeAndReferenceId(String inputType, Integer referenceId);

    List<AdmCiTypeAttr> findByInputTypeAndReferenceIdAndStatusAndIsDeleteValidate(String inputType, Integer referenceId,
                                                                                  String status,Integer isDeleteValidate);

    List<AdmCiTypeAttr> findByInputTypeAndCiTypeId(String inputType, Integer ciTypeId);

    @Cacheable("admCiTypeAttrRepository-findFirstByCiTypeIdAndPropertyName")
    AdmCiTypeAttr findFirstByCiTypeIdAndPropertyName(int ciTypeId, String propertyName);

    @Query(value = "SELECT * FROM adm_ci_type_attr WHERE id_adm_ci_type = :ciTypeId and edit_is_null =:isNullable AND is_auto = :isAuto", nativeQuery = true)
    List<AdmCiTypeAttr> findWithNullableAndIsAuto(@Param("ciTypeId") int ciTypeId, @Param("isNullable") int isNullable, @Param("isAuto") int isAuto);

    List<AdmCiTypeAttr> findByCiTypeIdAndInputTypeIn(int ciTypeId, List<String> inputTypes);

    List<AdmCiTypeAttr> findByCiTypeIdAndEditIsOnly(int ciTypeId, int isUnique);

    List<AdmCiTypeAttr> findByCiTypeIdAndEditIsEditable(int ciTypeId, int isEditable);

    @Query(value = "SELECT * FROM adm_ci_type_attr WHERE id_adm_ci_type = :ciTypeId and edit_is_null = 0", nativeQuery = true)
    List<AdmCiTypeAttr> findNotNullableAttrs(@Param("ciTypeId") int ciTypeId);

    List<AdmCiTypeAttr> findByCiTypeIdAndIsAuto(int ciTypeId, int isAuto);

    boolean existsByNameAndCiTypeId(String name, int ciTypeId);

    boolean existsByPropertyNameAndCiTypeId(String propertyName, int ciTypeId);

    @Query(value = "SELECT * FROM adm_ci_type_attr WHERE is_auto = 1 and auto_fill_rule like CONCAT('%',:value,'%')", nativeQuery = true)
    List<AdmCiTypeAttr> findAllByMatchAutoFillRule(String value);

    AdmCiTypeAttr findFirstByCiTypeIdOrderByDisplaySeqNoDesc(Integer ciTypeId);

    List<AdmCiTypeAttr> findAllByCiTypeIdAndIsAccessControlled(Integer ciTypeId, Integer isAccessControlled);

    List<AdmCiTypeAttr> findByIdAdmCiTypeAttrIn(List<Integer> ids);

    List<AdmCiTypeAttr> findByCiTypeIdAndIsRefreshable(int ciTypeId, int isRefreshable);
    
    //for cache purpose
    @Cacheable("admCiTypeAttrRepository-getOne")
    AdmCiTypeAttr getOne(Integer id);

    List<AdmCiTypeAttr> findAllByFilterRuleNotNull();


    @Cacheable(value="admCiTypeAttrRepository-getSortedMapForMultiRef",key = "#attr.idAdmCiTypeAttr")
    default Map<String, Integer> getSortedMapForMultiRef(EntityManager entityManager, AdmCiTypeAttr attr, DynamicEntityMeta multRefMeta) {
        Map<String, Integer> sortMap = new HashMap<>();
        String joinTable = attr.retrieveJoinTalbeName();
        String querySql = "select id,from_guid,to_guid, seq_no from " + joinTable;
        javax.persistence.Query query = entityManager.createNativeQuery(querySql, multRefMeta.getEntityClazz());
        List results = query.getResultList();

        for (Object bean : results) {
            BeanMap beanMap = new BeanMap(bean);
            sortMap.put((String) beanMap.get("to_guid"), (Integer) beanMap.get("seq_no"));
        }
        return sortMap;
    }

}
