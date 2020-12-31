package com.webank.plugins.wecmdb.dto.wecube;

import lombok.*;

import java.util.Map;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
@AllArgsConstructor
@Builder
public class CiDataInputDto {
    String callbackParameter;
    String entityName;
    Map<String, Object> ciData;
}
