package com.webank.cmdb.repository;

import java.util.List;
import java.util.Map;

import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.FilterPath;

public interface StaticEntityRepository {
    <T> QueryResponse<T> query(Class<T> domainClzz, QueryRequest ciRequest);

    <D> QueryResponse queryCrossRes(Class<D> domainClzz, QueryRequest ciRequest, FilterPath rootFilterPath);

    <T> void delete(Class<T> domainClazz, int id);

    <D> D create(D domainObj);

    <D> D update(Class<D> domainClzz, int id, Map<String, Object> vals);

    void applyCiTypeAttr(AdmCiTypeAttr admCiTypeAttr);

    int applyCiType(AdmCiType admCiType);
    
    <D> D findEntityById(Class<D> domainClzz, Integer id);

    Object update(Object domainObj);

    void createDefaultCiTypeAttrs(AdmCiType admCiType);

    List<AdmCiTypeAttr> retrieveDefaultAdmCiTypeAttrs(AdmCiType admCiType);
}
