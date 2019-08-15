package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import javax.validation.constraints.NotNull;

import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmAttrGroup;

public class CiTypeAttrGroupDto {
    private Integer attrGroupId;
    @NotNull
    private Integer ciTypeId;
    @NotNull
    private String name;
    private List<UniqueGroupAttr> ciTypeAttrs = new LinkedList<>();

    public static CiTypeAttrGroupDto from(AdmAttrGroup fromGroup, Integer ciTypeId) {
        CiTypeAttrGroupDto attrGroup = new CiTypeAttrGroupDto();
        attrGroup.setAttrGroupId(fromGroup.getIdAdmAttrGroup());
        attrGroup.setName(fromGroup.getName());
        fromGroup.getAdmCiTypeAttrGroups().forEach(x -> {
            UniqueGroupAttr attr = new UniqueGroupAttr();
            attr.setPropertyName(x.getAdmCiTypeAttr().getPropertyName());
            attr.setCiTypeAttrId(x.getAdmCiTypeAttr().getIdAdmCiTypeAttr());
            attr.setPropertyType(x.getAdmCiTypeAttr().getPropertyType());
            attr.setName(x.getAdmCiTypeAttr().getName());
            attr.setDescription(x.getAdmCiTypeAttr().getDescription());
            attr.setReferenceId(x.getAdmCiTypeAttr().getReferenceId());
            attr.setIsUnique(x.getAdmCiTypeAttr().getEditIsOnly());
            attr.setStatus(x.getAdmCiTypeAttr().getStatus());
            attrGroup.getCiTypeAttrs().add(attr);
        });
        attrGroup.setCiTypeId(ciTypeId);
        return attrGroup;
    }

    static public class UniqueGroupAttr {
        @NotNull
        private Integer ciTypeAttrId;
        private String propertyName;
        private String propertyType;
        private String name;
        private String description;
        private Integer referenceId;
        private Integer isUnique;
        private String status;

        public String getPropertyName() {
            return propertyName;
        }

        public void setPropertyName(String propertyName) {
            this.propertyName = propertyName;
        }

        public String getPropertyType() {
            return propertyType;
        }

        public void setPropertyType(String propertyType) {
            this.propertyType = propertyType;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public Integer getReferenceId() {
            return referenceId;
        }

        public void setReferenceId(Integer referenceId) {
            this.referenceId = referenceId;
        }

        public Integer getIsUnique() {
            return isUnique;
        }

        public void setIsUnique(Integer isUnique) {
            this.isUnique = isUnique;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Integer getCiTypeAttrId() {
            return ciTypeAttrId;
        }

        public void setCiTypeAttrId(Integer ciTypeAttrId) {
            this.ciTypeAttrId = ciTypeAttrId;
        }

        @Override
        public String toString() {
            return MoreObjects.toStringHelper(this)
                    .add("ciTypeAttrId", ciTypeAttrId)
                    .add("propertyName", propertyName)
                    .add("propertyType", propertyType)
                    .add("name", name)
                    .add("description", description)
                    .add("referenceId", referenceId)
                    .add("isUnique", isUnique)
                    .add("status", status)
                    .toString();
        }
    }

    public Integer getAttrGroupId() {
        return attrGroupId;
    }

    public void setAttrGroupId(Integer attrGroupId) {
        this.attrGroupId = attrGroupId;
    }

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<UniqueGroupAttr> getCiTypeAttrs() {
        return ciTypeAttrs;
    }

    public void setCiTypeAttrs(List<UniqueGroupAttr> ciTypeAttrs) {
        this.ciTypeAttrs = ciTypeAttrs;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("attrGroupId", attrGroupId).add("ciTypeId", ciTypeId).add("name", name).add("ciTypeAttrs", ciTypeAttrs).toString();
    }
}
