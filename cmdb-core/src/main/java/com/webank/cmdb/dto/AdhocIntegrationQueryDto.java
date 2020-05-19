package com.webank.cmdb.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Query will not be persisted
 * 
 * @author graychen
 *
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdhocIntegrationQueryDto {
    private IntegrationQueryDto criteria;
    private QueryRequest queryRequest = new QueryRequest();
}
