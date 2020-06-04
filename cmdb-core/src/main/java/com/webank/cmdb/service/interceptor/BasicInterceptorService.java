package com.webank.cmdb.service.interceptor;

import java.util.Map;

import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.service.StaticInterceptorService;
import com.webank.cmdb.util.ResourceDto;

public class BasicInterceptorService<T extends ResourceDto<T, D>, D> implements StaticInterceptorService<T, D> {

    @Override
    public void preUpdate(Integer id, Map<String, Object> vals) {

    }

    @Override
    public void postUpdate(Integer id, Map<String, Object> vals) {

    }

    @Override
    public void preDelete(Integer id) {

    }

    @Override
    public void postDelete(Integer id) {

    }

    @Override
    public void preCreate(T dto, D domainBean) {

    }

    @Override
    public void postCreate(T dto, D domainBean) {

    }

    @Override
    public QueryResponse<?> postQuery(QueryResponse<T> dtoResponse) {
        return dtoResponse;
    }

    @Override
    public String getName() {
        throw new ServiceException("The interceptor getName method should be override.");
    }

    @Override
    public void preQuery(QueryRequest ciRequest) {

    }

}
