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
    public static class UIProperties {
        private Integer enumCategoryTypeSystem = 1;
        private String enumCodeofView = "view_ci_type_id";
        private Integer enumCategoryTypeCommon = 2;
        private Integer ciTypeIdOfSystemDesign = 37;
        private Integer ciTypeIdOfSubsystemDesign = 38;
        private Integer ciTypeIdOfUnitDesign = 39;
        private Integer ciTypeIdOfUnit = 48;
        private Integer ciTypeIdOfSubsys = 47;
        private Integer ciTypeIdOfSystem = 46;
        private String ciTypeCodeOfSubsys = "subsys";
        private Integer ciTypeIdOfHost = 32;
        private Integer ciTypeIdOfInstance = 50;
        private Integer ciTypeIdOfIdc = 22;
        private Integer ciTypeIdOfZone = 24;
        private Integer ciTypeIdOfZoneLink = 26;
        private Integer ciTypeIdOfIdcDesign = 12;
        private Integer ciTypeIdOfZoneDesign = 14;
        private Integer ciTypeIdOfZoneLinkDesign = 16;
        private String enumCategoryCiTypeLayer = "ci_layer";
        private String enumCategoryCiTypeCatalog = "ci_catalog";
        private String enumCategoryCiTypeZoomLevels = "ci_zoom_level";
        private String statusAttributeName = "status";
        private String referenceCodeOfBelong = "belong";
        private String referenceCodeOfRunning = "running";
        private String referenceCodeOfRealize = "realize";
        private String referenceCodeOfRelate = "relation";
        private String referenceCodeOfUse = "use";
        private String propertyNameOfState = "state";
        private String enumCodeOfStateDelete = "delete";
        private Integer enumIdOfStateDelete = 36;
        private String propertyNameOfFixedDate = "fixed_date";
        private String enumCategoryNameOfEnv = "deploy_environment";
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
