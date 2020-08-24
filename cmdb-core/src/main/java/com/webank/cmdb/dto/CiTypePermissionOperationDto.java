package com.webank.cmdb.dto;

public class CiTypePermissionOperationDto {
    private Integer ciTypeId;
    private String ciTypeName;// "节点类型"
    private String creationPermission; // "Y", "N"
    private String enquiryPermission; // "Y", "N"
    private String executionPermission; // "Y"
    private String modificationPermission; // "Y"
    private String removalPermission; // "Y"

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public String getCiTypeName() {
        return ciTypeName;
    }

    public void setCiTypeName(String ciTypeName) {
        this.ciTypeName = ciTypeName;
    }

    public String getCreationPermission() {
        return creationPermission;
    }

    public void setCreationPermission(String creationPermission) {
        this.creationPermission = creationPermission;
    }

    public String getEnquiryPermission() {
        return enquiryPermission;
    }

    public void setEnquiryPermission(String enquiryPermission) {
        this.enquiryPermission = enquiryPermission;
    }

    public String getExecutionPermission() {
        return executionPermission;
    }

    public void setExecutionPermission(String executionPermission) {
        this.executionPermission = executionPermission;
    }

    public String getModificationPermission() {
        return modificationPermission;
    }

    public void setModificationPermission(String modificationPermission) {
        this.modificationPermission = modificationPermission;
    }

    public String getRemovalPermission() {
        return removalPermission;
    }

    public void setRemovalPermission(String removalPermission) {
        this.removalPermission = removalPermission;
    }

}
