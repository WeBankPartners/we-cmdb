package com.webank.cmdb.service;

import com.webank.cmdb.dto.FilterRuleDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;

public interface FilterRuleService {
    QueryResponse<?>  queryReferenceCiData(int referenceAttrId, QueryRequest queryObject);

    QueryResponse queryReferenceData(FilterRuleDto filterRule, QueryRequest request);

    void validateJsonString(String filterRuleJson);
}
