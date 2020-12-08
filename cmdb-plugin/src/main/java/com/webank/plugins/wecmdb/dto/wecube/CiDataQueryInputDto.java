package com.webank.plugins.wecmdb.dto.wecube;

import lombok.*;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
@AllArgsConstructor
@Builder
public class CiDataQueryInputDto {
    String callbackParameter;
    String entityName;
    QueryRequest queryObject;
}
