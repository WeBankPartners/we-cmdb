package com.webank.cmdb.dto;

import javax.validation.constraints.NotNull;

public class Relationship {
    // @NotNull
    // private Integer ciTypeId;
    @NotNull
    private Integer attrId = null;
    private Boolean isReferedFromParent = true;

    public Relationship() {
    }

    public Relationship(Integer attrId, boolean isReferedFromParent) {
        this.attrId = attrId;
        this.isReferedFromParent = isReferedFromParent;
    }

    public Integer getAttrId() {
        return attrId;
    }

    public void setAttrId(Integer attrId) {
        this.attrId = attrId;
    }

    public Boolean getIsReferedFromParent() {
        return isReferedFromParent;
    }

    public void setIsReferedFromParent(Boolean isReferedFromParent) {
        this.isReferedFromParent = isReferedFromParent;
    }
}