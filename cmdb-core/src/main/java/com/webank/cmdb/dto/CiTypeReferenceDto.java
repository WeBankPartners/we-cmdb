package com.webank.cmdb.dto;

import com.google.common.base.MoreObjects;

public class CiTypeReferenceDto {
    private int ciTypeId;
    private String name;
    private String refInputType;
    private String refName;
    private Integer refPropertyId;
    private String refPropertyName;
    private int relationship;

    public int getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(int ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRefInputType() {
        return refInputType;
    }

    public void setRefInputType(String refInputType) {
        this.refInputType = refInputType;
    }

    public String getRefName() {
        return refName;
    }

    public void setRefName(String refName) {
        this.refName = refName;
    }

    public Integer getRefPropertyId() {
        return refPropertyId;
    }

    public void setRefPropertyId(Integer refPropertyId) {
        this.refPropertyId = refPropertyId;
    }

    public String getRefPropertyName() {
        return refPropertyName;
    }

    public void setRefPropertyName(String refPropertyName) {
        this.refPropertyName = refPropertyName;
    }

    public int getRelationship() {
        return relationship;
    }

    public void setRelationship(int relationship) {
        this.relationship = relationship;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("ciTypeId", ciTypeId)
                .add("name", name)
                .add("refInputType", refInputType)
                .add("refName", refName)
                .add("refPropertyId", refPropertyId)
                .add("refPropertyName", refPropertyName)
                .add("relationship", relationship)
                .toString();
    }
}
