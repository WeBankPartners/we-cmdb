package com.webank.cmdb.service;

import java.util.List;

import com.webank.cmdb.dto.IdNamePairDto;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto;
import com.webank.cmdb.dto.IntQueryOperateAggResponseDto;
import com.webank.cmdb.dto.IntegrationQueryDto;

public interface IntegrationQueryService extends CmdbService {
    public static String NAME = "IntegrationQueryService";

    int createIntegrationQuery(int ciTypeId, String queryName, IntegrationQueryDto intQueryDto);

    IntegrationQueryDto getIntegrationQuery(int queryId);

    IntegrationQueryDto getIntegrationQueryByName(String intQueryName);

    int duplicateIntegrationQuery(int queryId);

    void deleteIntegrationQuery(int queryId);

    void updateIntegrationQuery(int queryId, IntegrationQueryDto intQueryDto);

    List<IdNamePairDto> findAll(int ciTypeId, String name, Integer attrId);

    List<IntQueryOperateAggResponseDto> operateAggregationQuery(int ciTypeId, List<IntQueryOperateAggRequetDto> aggRequest);

    // List<IntQueryOperateAggResponseDto> updateAggregationQuery(int ciTypeId,
    // List<IntQueryOperateAggRequetDto> aggRequest);

}
