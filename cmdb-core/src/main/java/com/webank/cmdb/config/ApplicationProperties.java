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
        private Integer ciTypeIdOfSystemDesign = 1;
        private Integer ciTypeIdOfSubsystemDesign = 2;
        private Integer ciTypeIdOfUnitDesign = 3;
        private Integer ciTypeIdOfUnit = 8;
        private Integer ciTypeIdOfSubsys = 7;
        private String ciTypeCodeOfSubsys = "subsys";
        private Integer ciTypeIdOfHost = 12;
        private Integer ciTypeIdOfInstance = 15;
        private Integer ciTypeIdOfIdc = 16;
        private Integer ciTypeIdOfZone = 17;
        private Integer ciTypeIdOfZoneLink = 18;
        private Integer ciTypeIdOfIdcDesign = 22;
        private Integer ciTypeIdOfZoneDesign = 23;
        private Integer ciTypeIdOfZoneLinkDesign = 24;
        private String enumCategoryCiTypeLayer = "ci_layer";
        private String enumCategoryCiTypeCatalog = "ci_catalog";
        private String enumCategoryCiTypeZoomLevels = "ci_zoom_level";
        private String statusAttributeName = "status";
        private String referenceCodeOfBelong = "belong";
        private String referenceCodeOfRunning = "running";
        private String referenceCodeOfRealize = "realize";
        private String referenceCodeOfRelate = "relation";
        private String propertyNameOfState = "state";
        private String enumCodeOfStateDelete = "delete";
        private String propertyNameOfFixedDate = "fixed_date";
        private String enumCategoryNameOfEnv = "env";
        private String catNameOfArchitectureDesign = "tab_of_architecture_design";
        private String catNameOfDeployDesign = "tab_of_deploy_design";
        private String catNameOfQueryDeployDesign = "tab_query_of_deploy_design";
        private String catNameOfPlanningDesign = "tab_of_planning_design";
        private String catNameOfResoursePlanning = "tab_of_resourse_planning";
        private String codeOfDeployDetail = "guid_of_deploy_detail";
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