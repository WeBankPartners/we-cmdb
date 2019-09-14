package com.webank.cmdb.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.util.unit.DataSize;

import lombok.Data;

@Data
@ConfigurationProperties(prefix = "cmdb")
public class ApplicationProperties {
    private DataSize maxFileSize = DataSize.ofKilobytes(64);

    @Data
    @ConfigurationProperties(prefix = "cmdb.datasource")
    public class DatasourceProperties {
        private String schema;
    }

    @Data
    @ConfigurationProperties(prefix = "cmdb.ui")
    public class UIProperties {
        private Integer enumCategoryTypeSystem = 1;
        private Integer enumCategoryTypeCommon = 2;
        private String enumCategoryCiTypeLayer = "ci_layer";
        private String enumCategoryCiTypeCatalog = "ci_catalog";
        private String enumCategoryCiTypeZoomLevels = "ci_zoom_level";
        private String statusAttributeName = "status";
    }

    @Data
    @ConfigurationProperties(prefix = "cmdb.security")
    public class SecurityProperties {
        private boolean enabled;
        private String authenticationProvider;
        private String casServerUrl;
        private String casRedirectAppAddr;
        private String whitelistIpAddress;
    }
}