package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_EMPTY)
public class CiTypeDto extends BasicResourceDto<CiTypeDto, AdmCiType> {
    @DtoId
    @DtoField(domainField = "idAdmCiType")
    private Integer ciTypeId;
    private Integer ciGlobalUniqueId;
    @NotNull
    private Integer catalogId;
    private String description;
    private Integer tenementId;
    private Integer layerId;
    private Integer ciStateTypeId;
    @NotNull
    private String name;
    private Integer seqNo;
    @DtoField(updatable = false)
    private String tableName;
    @DtoField(updatable = false)
    private String status;
    private Integer zoomLevelId;
    private Integer imageFileId;
    // refer resource
    @DtoField(domainField = "layerCode", updatable = false)
    private CatCodeDto layerCode = new CatCodeDto();
    @DtoField(domainField = "catalogCode", updatable = false)
    private CatCodeDto catalogCode = new CatCodeDto();
    @DtoField(domainField = "ciStateType", updatable = false)
    private CatCodeDto ciStateType = new CatCodeDto();
    @DtoField(domainField = "admCiTypeAttrs", updatable = false)
    private List<CiTypeAttrDto> attributes = new LinkedList<>();

    @Override
    public CiTypeDto fromDomain(AdmCiType admCiType, List<String> refResource) {
        if (admCiType == null)
            return null;

        CiTypeDto ciType = new CiTypeDto();
        ciType.setCatalogId(admCiType.getCatalogId());
        ciType.setCiTypeId(admCiType.getIdAdmCiType());
        ciType.setCiGlobalUniqueId(admCiType.getCiGlobalUniqueId());
        ciType.setDescription(admCiType.getDescription());
        // ciType.setTenementId(admCiType.getIdAdmTenement());
        ciType.setLayerId(admCiType.getLayerId());
        ciType.setName(admCiType.getName());
        ciType.setSeqNo(admCiType.getSeqNo());
        ciType.setTableName(admCiType.getTableName());
        ciType.setStatus(admCiType.getStatus());
        ciType.setZoomLevelId(admCiType.getZoomLevelId());
        ciType.setImageFileId(admCiType.getImageFileId());
        ciType.setCiStateTypeId(admCiType.getCiStateTypeId());

        if (refResource != null && refResource.contains("layerCode")) {
            ciType.layerCode = new CatCodeDto().fromDomain(admCiType.getLayerCode(), Lists.newArrayList());
        }
        if (refResource != null && refResource.contains("catalogCode")) {
            ciType.catalogCode = new CatCodeDto().fromDomain(admCiType.getLayerCode(), Lists.newArrayList());
        }
        if (refResource != null && refResource.contains("ciStateType")) {
            ciType.setCiStateType(new CatCodeDto().fromDomain(admCiType.getCiStateType(), Lists.newArrayList()));
        }
        if (refResource != null && refResource.contains("attributes")) {
            admCiType.getAdmCiTypeAttrs().forEach(x -> {
                ciType.attributes.add(new CiTypeAttrDto().fromDomain(x, Lists.newArrayList()));
            });
        }
        return ciType;
    }

    @Override
    public Class<AdmCiType> domainClazz() {
        return AdmCiType.class;
    }

    public static CiTypeDto fromAdmCIType(AdmCiType admCiType) {
        if (admCiType == null)
            return null;

        CiTypeDto ciType = new CiTypeDto();
        ciType.setCatalogId(admCiType.getCatalogId());
        ciType.setCiTypeId(admCiType.getIdAdmCiType());
        ciType.setCiGlobalUniqueId(admCiType.getCiGlobalUniqueId());
        ciType.setDescription(admCiType.getDescription());
        // ciType.setTenementId(admCiType.getIdAdmTenement());
        ciType.setLayerId(admCiType.getLayerId());
        ciType.setName(admCiType.getName());
        ciType.setSeqNo(admCiType.getSeqNo());
        ciType.setTableName(admCiType.getTableName());
        ciType.setStatus(admCiType.getStatus());
        ciType.setZoomLevelId(admCiType.getZoomLevelId());
        ciType.setImageFileId(admCiType.getImageFileId());
        ciType.setCiStateTypeId(admCiType.getCiStateTypeId());
        return ciType;
    }

    public AdmCiType toAdmCiType() {
        AdmCiType admCiType = new AdmCiType();
        admCiType.setCatalogId(catalogId);
        admCiType.setLayerId(layerId);
        admCiType.setZoomLevelId(zoomLevelId);
        admCiType.setName(name);
        admCiType.setDescription(description);
        admCiType.setCiGlobalUniqueId(ciGlobalUniqueId);
        admCiType.setSeqNo(seqNo);
        admCiType.setStatus(status);
        admCiType.setImageFileId(imageFileId);
        admCiType.setCiStateTypeId(ciStateTypeId);
        return admCiType;
    }

    static public Map<String, String> getDomainFeildMapping() {
        return ImmutableMap.<String, String>builder().put("name", "name").put("ciTypeId", "idAdmCiType").build();
    }

    /**
     * Update dto value to domain object, exclude tableName which can not be updated
     * after created.
     *
     * @param toUpdAdmCiType: the domain object to be updated
     * @return
     */
    public AdmCiType updateTo(AdmCiType toUpdAdmCiType) {
        toUpdAdmCiType.setCatalogId(catalogId);
        toUpdAdmCiType.setLayerId(layerId);
        toUpdAdmCiType.setZoomLevelId(zoomLevelId);
        toUpdAdmCiType.setName(name);
        toUpdAdmCiType.setDescription(description);
        toUpdAdmCiType.setCiGlobalUniqueId(ciGlobalUniqueId);
        toUpdAdmCiType.setSeqNo(seqNo);
        toUpdAdmCiType.setImageFileId(imageFileId);
        toUpdAdmCiType.setImageFileId(ciStateTypeId);
        return toUpdAdmCiType;
    }

    public static CiTypeDto fromAdmCITypeWithAttr(AdmCiType admCiType) {
        CiTypeDto ciType = fromAdmCIType(admCiType);
        if (ciType == null)
            return null;

        admCiType.getAdmCiTypeAttrs().forEach(x -> {
            ciType.attributes.add(CiTypeAttrDto.fromAdmCiTypeAttrs(x));
        });

        ciType.attributes.sort((a, b) -> {
            if (a.getDisplaySeqNo() != null) {
                if (b.getDisplaySeqNo() != null) {
                    return a.getDisplaySeqNo() - b.getDisplaySeqNo();
                } else {
                    return 1;
                }
            } else {
                if (b.getDisplaySeqNo() != null) {
                    return -1;
                } else {
                    return 0;
                }
            }
        });
        return ciType;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public Integer getCiGlobalUniqueId() {
        return ciGlobalUniqueId;
    }

    public void setCiGlobalUniqueId(Integer ciGlobalUniqueId) {
        this.ciGlobalUniqueId = ciGlobalUniqueId;
    }

    public Integer getCatalogId() {
        return catalogId;
    }

    public void setCatalogId(Integer ciType) {
        this.catalogId = ciType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getTenementId() {
        return tenementId;
    }

    public void setTenementId(Integer idTenement) {
        this.tenementId = idTenement;
    }

    public Integer getLayerId() {
        return layerId;
    }

    public void setLayerId(Integer layerId) {
        this.layerId = layerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSeqNo() {
        return seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getZoomLevelId() {
        return zoomLevelId;
    }

    public void setZoomLevelId(Integer zoomLevelId) {
        this.zoomLevelId = zoomLevelId;
    }

    public List<CiTypeAttrDto> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<CiTypeAttrDto> attributes) {
        this.attributes = attributes;
    }

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public Integer getImageFileId() {
        return imageFileId;
    }

    public void setImageFileId(Integer imageFileId) {
        this.imageFileId = imageFileId;
    }

    public CatCodeDto getLayerCode() {
        return layerCode;
    }

    public void setLayerCode(CatCodeDto layerCode) {
        this.layerCode = layerCode;
    }

    public CatCodeDto getCatalogCode() {
        return catalogCode;
    }

    public void setCatalogCode(CatCodeDto catalogCode) {
        this.catalogCode = catalogCode;
    }

    public CatCodeDto getCiStateType() {
        return ciStateType;
    }

    public void setCiStateType(CatCodeDto ciStateType) {
        this.ciStateType = ciStateType;
    }

    public Integer getCiStateTypeId() {
        return ciStateTypeId;
    }

    public void setCiStateTypeId(Integer ciStateTypeId) {
        this.ciStateTypeId = ciStateTypeId;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("ciTypeId", ciTypeId)
                .add("ciGlobalUniqueId", ciGlobalUniqueId)
                .add("catalogId", catalogId)
                .add("description", description)
                .add("tenementId", tenementId)
                .add("layerId", layerId)
                .add("ciStateTypeId", ciStateTypeId)
                .add("name", name)
                .add("seqNo", seqNo)
                .add("tableName", tableName)
                .add("status", status)
                .add("zoomLevelId", zoomLevelId)
                .add("imageFileId", imageFileId)
                .toString();
    }
}
