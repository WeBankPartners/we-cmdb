package com.webank.cmdb.service;

import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;

import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.CiDataTreeDto;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeHeaderDto.CiKeyPair;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntQueryResponseHeader;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.util.FilterInfo;
import com.webank.cmdb.util.Pageable;
import com.webank.cmdb.util.Sorting;

public interface CiService extends CmdbService {
    public static String NAME = "CiService";

    void invalidate();

    void reload();

    String create(int ciTypeId, Map<String, Object> ciData);

    QueryResponse<CiData> query(int ciType, QueryRequest ciRequest);

    Map<String, Object> getCi(int ciType, String guid);

    DynamicEntityMeta getDynamicEntityMeta(int ciTypeId);

    DynamicEntityHolder getCiHolder(int ciType, String guid);

    List<DynamicEntityHolder> filterBy(int ciType, List<FilterInfo> filterInfos, Pageable pageable, Sorting sorting);

    void deleteCi(int ciTypeId, String ciId);

    void update(int ciTypeId, String guid, Map<String, Object> ciData);

    void update(EntityManager entityManager, int ciTypeId, String guid, Map<String, Object> ciData);

    List<Map<String, Object>> update(int ciTypeId, List<Map<String, Object>> cis);

    List<Map<String, Object>> create(int ciTypeId, List<Map<String, Object>> cis);

    void delete(int ciTypeId, List<String> ids);

    QueryResponse integrateQuery(int intQueryId, QueryRequest intQueryReq);

    QueryResponse integrateQuery(String queryName, QueryRequest intQueryReq);

    List<IntQueryResponseHeader> integrateQueryHeader(int queryId);

    HashSet<String> retrieveVersions(int ciTypeId);

    List<CiDataTreeDto> retrieveVersionDetail(int fromCiTypeId, int toCiTypeId, String version);

    QueryResponse adhocIntegrateQuery(AdhocIntegrationQueryDto adhocQueryRequest);

    List<Map<String, Object>> queryWithFilters(int ciType, List<Filter> filters);

    List<Map<String, Object>> operateState(List<CiIndentity> ciIds, String operation);

    void doDelete(EntityManager entityManager, int ciTypeId, String guid, boolean enableStateTransition);

    Object cloneCiAsParent(EntityManager entityManager, int ciTypeId, String guid);

    List<Map<String, Object>> lookupReferenceByCis(int ciTypeId, String guid, boolean checkFinalState);

    List<Map<String, Object>> lookupReferenceToCis(int ciTypeId, String guid);

    List<Map<String, Object>> lookupReferenceByCisWithFullData(int ciTypeId, String guid);

    Map<String, Object> recursiveGetCisTree(Integer ciTypeId, String guid, Map<String, Object> parentCi);

    Map<Integer, DynamicEntityMeta> getMultSelectMetaMap();

    Object getCiBeanObject(EntityManager entityManager, int ciTypeId, String guid);
    
    List<CiKeyPair> retrieveKeyPairs(int ciTypeId);

    List<IntQueryResponseHeader> integrateQueryHeader(String queryName);
}
