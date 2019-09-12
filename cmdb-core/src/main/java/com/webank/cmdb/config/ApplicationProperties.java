package com.webank.cmdb.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.util.unit.DataSize;

import lombok.Data;

@Data
@ConfigurationProperties(prefix = "cmdb.datasource")
public class ApplicationProperties {

    private DataSize maxFileSize = DataSize.ofKilobytes(64);
    private String schema;

    public String getSchema() {
        return schema;
    }

    public void setSchema(String schema) {
        this.schema = schema;
    }

    @Data
    @ConfigurationProperties(prefix = "ui.access")
    public class UIAccessProperties {
        private Integer enumCategoryTypeSystem = 1;
        private Integer enumCategoryTypeCommon = 2;

        private String enumCategoryCiTypeLayer = "ci_layer";
        private String enumCategoryCiTypeCatalog = "ci_catalog";
        private String enumCategoryCiTypeZoomLevels = "ci_zoom_level";

        private String statusAttributeName = "status";
    }
}