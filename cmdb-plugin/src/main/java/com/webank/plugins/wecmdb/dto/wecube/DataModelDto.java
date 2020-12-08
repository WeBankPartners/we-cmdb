package com.webank.plugins.wecmdb.dto.wecube;

import lombok.Data;

import java.util.List;

@Data
public class DataModelDto {
    private String id;
    private Boolean dynamic;
    private String packageName;
    private List<EntityDto> pluginPackageEntities;
    private String updateMethod;
    private String updatePath;
    private String updateSource;
    private Long updateTime;
    private Long version;
}
