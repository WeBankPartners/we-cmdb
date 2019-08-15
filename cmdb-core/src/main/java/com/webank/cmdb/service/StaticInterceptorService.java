package com.webank.cmdb.service;

import java.util.Map;

import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.util.ResourceDto;

public interface StaticInterceptorService<T extends ResourceDto<T, D>, D> extends CmdbService {
    void preCreate(T dto, D domainObj);

    void postCreate(T dto, D domainObj);

    void preUpdate(Integer id, Map<String, Object> vals);

    void postUpdate(Integer id, Map<String, Object> vals);

    void preDelete(Integer id);

    void postDelete(Integer id);

    void preQuery(QueryRequest ciRequest);

    QueryResponse<?> postQuery(QueryResponse<T> dtoResponse);
}
