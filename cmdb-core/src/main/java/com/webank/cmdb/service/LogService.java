package com.webank.cmdb.service;

import java.util.List;

import com.webank.cmdb.constant.LogCategory;
import com.webank.cmdb.constant.LogOperation;
import com.webank.cmdb.domain.AdmLog;
import com.webank.cmdb.dto.LogDto;
import com.webank.cmdb.dto.QueryHeader;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;

public interface LogService extends CmdbService {
    String NAME = "LogService";

    QueryResponse<LogDto> query(QueryRequest ciRequest);

    List<QueryHeader> queryHeader();

    AdmLog log(LogCategory category, String user, LogOperation operation, String logContent, String remark);

    AdmLog log(LogCategory category, String user, LogOperation operation, String logContent, String remark, String requestUrl, String ciGuid, String ciName, Integer ciTypeId, String ciTypeName, String clientHost);
}
