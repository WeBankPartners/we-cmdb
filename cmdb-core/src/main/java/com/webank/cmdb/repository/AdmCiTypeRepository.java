package com.webank.cmdb.repository;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;

import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.webank.cmdb.domain.AdmCiType;

@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "admCiTypeRepository")
public interface AdmCiTypeRepository extends JpaRepository<AdmCiType, Integer> {
    List<AdmCiType> findAll();

    AdmCiType findTop1ByOrderByIdAdmCiType();

    AdmCiType findByIdAdmCiType(int admCiTypeId);

    AdmCiType findByTableName(String tableName);

    boolean existsByCatalogId(int catologId);

    boolean existsByLayerId(int layerId);

    boolean existsByZoomLevelId(int zoomLevelId);

    boolean existsByCiStateTypeId(int ciStateTypeId);

    static String SQL_SELECT = "SELECT DISTINCT " + "c.id_adm_basekey AS idAdmBasekey," + "c.id_adm_basekey_cat AS idAdmBasekeyCat," + "c.CODE AS CODE," + "c.VALUE AS VALUE," + "IFNULL(c.code_description, '') AS codeDescription,"
            + "IFNULL(c.seq_no, 0) AS seqNo," + "t.id_adm_ci_type AS ctIdAdmCiType," + "t.NAME AS ctNAME," + "t.description AS ctDescription," + "t.id_adm_tenement AS ctIdAdmTenement," + "t.table_name AS ctTableName,"
            + "t.status AS ctStatus," + "t.catalog_id AS ctCiType," + "t.layer_id as ctLayerId," + "t.zoom_level_id ctZoomLevelId," + "t.ci_global_unique_id AS ctCiGlobalUniqueId," + "t.seq_no ctCiTypeSeqNo,"
            + "t.image_file_id AS ctImageFileId " + "FROM " + "adm_basekey_code c ";

    static String SQL_WHERE = "LEFT JOIN adm_role_ci_type rct ON t.id_adm_ci_type = rct.id_adm_ci_type " + "WHERE c.id_adm_basekey_cat = :catId";

    @Query(value = SQL_SELECT + "LEFT JOIN adm_ci_type t ON c.id_adm_basekey = t.catalog_id " + SQL_WHERE, nativeQuery = true)
    List<BasekeyInfo> findCatalogCiTypes(@Param("catId") int catId);

    @Query(value = SQL_SELECT + "LEFT JOIN adm_ci_type t ON c.id_adm_basekey = t.layer_id and t.id_adm_tenement = :idAdmTenement " + SQL_WHERE, nativeQuery = true)
    List<BasekeyInfo> findLayerCiTypes(@Param("idAdmTenement") int idAdmTenement, @Param("catId") int catId);

    public static interface BasekeyInfo {
        Integer getIdAdmBasekey();

        Integer getIdAdmBasekeyCat();

        String getCode();

        String getValue();

        String getCodeDescription();

        Integer getSeqNo();

        Integer getCtIdAdmCiType();

        String getCtName();

        String getCtDescription();

        Integer getCtIdAdmTenement();

        String getCtTableName();

        String getCtStatus();

        Integer getCtCiType();

        Integer getCtLayerId();

        Integer getCtZoomLevelId();

        Integer getCtCiGlobalUniqueId();

        Integer getCtCiTypeSeqNo();

        Integer getCtImageFileId();
    }

    /**
     * Find the ci type which has same catalog id and closest number less than the
     * given seqNo
     */
    AdmCiType findFirstByCatalogIdAndSeqNoLessThanOrderBySeqNoDesc(int catalogId, int seqNo);

    /**
     * Find the ci type which has same catalog id and closest number larger than the
     * given seqNo
     */
    AdmCiType findFirstByCatalogIdAndSeqNoGreaterThanOrderBySeqNoAsc(int catalogId, int seqNo);

    AdmCiType findFirstByCatalogIdOrderBySeqNoDesc(Integer catalogId);

    static String SQL_GET_REF_CI = "SELECT citype.table_name " + "FROM ( " + "select reference_id from ( " + "SELECT " + " src.reference_id,  "
            + " IF(FIND_IN_SET(reference_id, @pids) > 0, @pids\\:=CONCAT(@pids, ',', id_adm_ci_type), 0) AS isend " + "FROM ( " + " SELECT attr.id_adm_ci_type,attr.reference_id,attr.property_name " + " FROM adm_ci_type_attr attr "
            + " WHERE attr.input_type in ('ref','muti_ref') " + " ORDER BY attr.reference_id, attr.id_adm_ci_type " + ") src, " + " ( " + "SELECT @pids\\:=:ciTypeId) var " + ") target WHERE isend != 0) result, " + "adm_ci_type citype "
            + "where result.reference_id = citype.id_adm_ci_type;";

    @Query(value = SQL_GET_REF_CI, nativeQuery = true)
    HashSet<String> findAllRefCiTableFrom(int ciTypeId);

    boolean existsByName(String name);
    
    //for cache
    @Cacheable("ciType-findById")
    @Override
    Optional<AdmCiType> findById(Integer id);
}
