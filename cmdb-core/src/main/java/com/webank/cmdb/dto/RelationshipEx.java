package com.webank.cmdb.dto;

import javax.validation.constraints.NotNull;

public class RelationshipEx {
    // @NotNull
    // private Integer ciTypeId;
    @NotNull
    private String attrId = null;
    private Boolean isReferedFromParent = true;

    public RelationshipEx() {
    }

    public RelationshipEx(String attrId, boolean isReferedFromParent) {
        this.attrId = attrId;
        this.isReferedFromParent = isReferedFromParent;
    }

    public String getAttrId() {
        return attrId;
    }

    public void setAttrId(String attrId) {
        this.attrId = attrId;
    }

    public Boolean getIsReferedFromParent() {
        return isReferedFromParent;
    }

    public void setIsReferedFromParent(Boolean isReferedFromParent) {
        this.isReferedFromParent = isReferedFromParent;
    }
}