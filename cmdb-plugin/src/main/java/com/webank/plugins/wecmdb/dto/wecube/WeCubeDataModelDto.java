package com.webank.plugins.wecmdb.dto.wecube;

import com.webank.cmdb.dto.CustomResponseDto;
import lombok.*;

import java.util.List;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
@AllArgsConstructor
@Builder
public class WeCubeDataModelDto implements CustomResponseDto {
    String id;
    String version;
    String packageName;
    String updatePath;
    String updateMethod;
    String updateSource;
    String updateTime;
    List<EntityDto> pluginPackageEntities;
}
