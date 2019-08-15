package com.webank.cmdb.dto;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.repository.AdmCiTypeRepository;

@JsonInclude(Include.NON_EMPTY)
public class CiTypeCategoryDto {
    private Integer codeId;
    private String code;
    private String value;
    private Integer seqNo;
    private String codeDescription;

    private List<CiTypeDto> ciTypes = new LinkedList<>();

    public static CiTypeCategoryDto from(AdmCiTypeRepository.BasekeyInfo basekeyInfo) {
        CiTypeCategoryDto info = new CiTypeCategoryDto();
        info.setCode(basekeyInfo.getCode());
        info.setValue(basekeyInfo.getValue());
        info.setCodeId(basekeyInfo.getIdAdmBasekey());
        info.setSeqNo(basekeyInfo.getSeqNo());
        info.setCodeDescription(basekeyInfo.getCodeDescription());
        return info;
    }

    public static class Builder {
        static public List<CiTypeCategoryDto> build(List<AdmCiTypeRepository.BasekeyInfo> basekeyInfo, Map<Integer, List<AdmCiTypeAttr>> ciTypeIdToAttrMap) {
            if (basekeyInfo == null) {
                return null;
            }

            Map<CiTypeCatalogInfoKey, CiTypeCategoryDto> infoMap = new TreeMap<>((x, y) -> {
                return x.getSeqNo() - y.getSeqNo();
            });
            basekeyInfo.forEach(x -> {
                CiTypeCatalogInfoKey infoKey = new CiTypeCatalogInfoKey(x);
                if (infoMap.containsKey(infoKey)) {
                    CiTypeCategoryDto catalog = infoMap.get(infoKey);
                    catalog.getCiTypes().add(convertCiType(x, ciTypeIdToAttrMap == null ? null : ciTypeIdToAttrMap.get(x.getCtIdAdmCiType())));
                } else {
                    CiTypeDto ciType = convertCiType(x, ciTypeIdToAttrMap == null ? null : ciTypeIdToAttrMap.get(x.getCtIdAdmCiType()));
                    CiTypeCategoryDto ciTypeLayerInfo = CiTypeCategoryDto.from(x);
                    ciTypeLayerInfo.getCiTypes().add(ciType);
                    infoMap.put(infoKey, ciTypeLayerInfo);
                }
            });

            List<CiTypeCategoryDto> ciTypeLayerInfos = new ArrayList<>(infoMap.size());
            infoMap.forEach((k, v) -> {
                ciTypeLayerInfos.add(v);
            });
            return ciTypeLayerInfos;
        }

        static public List<CiTypeCategoryDto> build(List<AdmCiTypeRepository.BasekeyInfo> basekeyInfo) {
            return build(basekeyInfo, null);
        }

        static CiTypeDto convertCiType(AdmCiTypeRepository.BasekeyInfo basekeyInfo, List<AdmCiTypeAttr> admCiTypeAttrs) {
            CiTypeDto ciType = new CiTypeDto();
            ciType.setCiTypeId(basekeyInfo.getCtIdAdmCiType());
            ciType.setCiGlobalUniqueId(basekeyInfo.getCtCiGlobalUniqueId());
            ciType.setTenementId(basekeyInfo.getCtIdAdmTenement());
            ciType.setLayerId(basekeyInfo.getCtLayerId());
            ciType.setSeqNo(basekeyInfo.getCtCiTypeSeqNo());
            ciType.setName(basekeyInfo.getCtName());
            ciType.setDescription(basekeyInfo.getCtDescription());
            ciType.setStatus(basekeyInfo.getCtStatus());
            ciType.setZoomLevelId(basekeyInfo.getCtZoomLevelId());
            ciType.setTableName(basekeyInfo.getCtTableName());
            ciType.setCatalogId(basekeyInfo.getCtCiType());
            ciType.setImageFileId(basekeyInfo.getCtImageFileId());

            if (admCiTypeAttrs != null) {
                admCiTypeAttrs.forEach(x -> {
                    CiTypeAttrDto attrDto = CiTypeAttrDto.fromAdmCiTypeAttrs(x);
                    ciType.getAttributes().add(attrDto);
                });
            }
            return ciType;
        }

        static class CiTypeCatalogInfoKey {
            private Integer admBasekeyId;
            private Integer admBasekeyCatId;
            private String code;
            private String value;
            private Integer seqNo;
            private String codeDescription;

            public CiTypeCatalogInfoKey(AdmCiTypeRepository.BasekeyInfo basekeyInfo) {
                this.admBasekeyId = basekeyInfo.getIdAdmBasekey();
                this.admBasekeyCatId = basekeyInfo.getIdAdmBasekeyCat();
                this.code = basekeyInfo.getCode();
                this.value = basekeyInfo.getValue();
                this.seqNo = basekeyInfo.getSeqNo();
                this.codeDescription = basekeyInfo.getCodeDescription();
            }

            @Override
            public boolean equals(Object obj) {
                return EqualsBuilder.reflectionEquals(this, obj);
            }

            @Override
            public int hashCode() {
                return HashCodeBuilder.reflectionHashCode(this);
            }

            public Integer getAdmBasekeyId() {
                return admBasekeyId;
            }

            public void setAdmBasekeyId(Integer admBasekeyId) {
                this.admBasekeyId = admBasekeyId;
            }

            public Integer getAdmBasekeyCatId() {
                return admBasekeyCatId;
            }

            public void setAdmBasekeyCatId(Integer admBasekeyCatId) {
                this.admBasekeyCatId = admBasekeyCatId;
            }

            public String getCode() {
                return code;
            }

            public void setCode(String code) {
                this.code = code;
            }

            public Integer getSeqNo() {
                return seqNo;
            }

            public void setSeqNo(Integer seqNo) {
                this.seqNo = seqNo;
            }

            public String getCodeDescription() {
                return codeDescription;
            }

            public void setCodeDescription(String codeDescription) {
                this.codeDescription = codeDescription;
            }

            public String getValue() {
                return value;
            }

            public void setValue(String value) {
                this.value = value;
            }

        }
    }

    public Integer getCodeId() {
        return codeId;
    }

    public void setCodeId(Integer codeId) {
        this.codeId = codeId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public List<CiTypeDto> getCiTypes() {
        return ciTypes;
    }

    public void setCiTypes(List<CiTypeDto> ciTypes) {
        this.ciTypes = ciTypes;
    }

    public Integer getSeqNo() {
        return seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    public String getCodeDescription() {
        return codeDescription;
    }

    public void setCodeDescription(String codeDescription) {
        this.codeDescription = codeDescription;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("codeId", codeId).add("code", code).add("value", value).add("seqNo", seqNo).add("codeDescription", codeDescription).add("ciTypes", ciTypes).toString();
    }
}
