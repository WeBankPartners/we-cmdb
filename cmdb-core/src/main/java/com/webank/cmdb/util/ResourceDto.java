package com.webank.cmdb.util;

import java.util.List;

public interface ResourceDto<T, D> {
    T fromDomain(D domainObj, List<String> refResource);

    Class<D> domainClazz();

    void setCallbackId(String callbackId);

    String getCallbackId();

    void setErrorMessage(String errorMessage);

    String getErrorMessage();
}
