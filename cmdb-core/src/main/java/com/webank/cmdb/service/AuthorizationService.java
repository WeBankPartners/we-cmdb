package com.webank.cmdb.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface AuthorizationService extends CmdbService {
    @Override
    default String getName() {
        return "AuthorizationService";
    }

    void authorizeCiData(int ciTypeId, Object ciData, String action);

    boolean isCiTypePermitted(int ciTypeId, String action);

    boolean isCiDataPermitted(int ciTypeId, Object ciData, String action);

    List<Map<String, Set<?>>> getPermittedData(int ciTypeId, String action);

}
