package com.webank.cmdb.service;

import java.util.List;
import java.util.Map;

import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.util.ResourceDto;

public interface StaticDtoService extends CmdbService {
    public static String NAME = "StaticDtoService";

    <T extends ResourceDto<T, D>, D> QueryResponse<T> query(Class<T> dtoClzz, QueryRequest ciRequest);

    <T extends ResourceDto<T, D>, D> T getOne(Class<T> dtoClzz, int id);

    <T extends ResourceDto<T, D>, D> void delete(Class<T> dtoClzz, int id);

    <T extends ResourceDto<T, D>, D> void delete(Class<T> dtoClzz, List<Integer> ids);

    <T extends ResourceDto<T, D>, D> List<T> create(Class<T> dtoClazz, List<T> dtoObjs);

    <T extends ResourceDto<T, D>, D> D update(Class<T> dtoClazz, int id, Map<String, Object> vals);

    <T extends ResourceDto<T, D>, D> List<T> update(Class<T> dtoClazz, List<Map<String, Object>> updateRequest);

    void registerInterceptor(String name, StaticInterceptorService interceptor);

    <T extends ResourceDto<T, D>, D> List<T> create(Class<T> dtoClzz, List<T> dtoObjs, boolean isNotCreateAttr, boolean isCustomGenerator);
}
