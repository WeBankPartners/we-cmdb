package com.webank.cmdb.dto;

import java.util.List;

import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_NULL)
public class CatCodeDto extends BasicResourceDto<CatCodeDto, AdmBasekeyCode> {
    @NotNull
    private String code = null;
    private String value;
    private Integer seqNo;
    @DtoId
    @DtoField(domainField = "idAdmBasekey")
    private Integer codeId;
    private String codeDescription;
    private Integer groupCodeId;
    private String groupName;
    private Integer catId;
    @DtoField(domainField = "admBasekeyCat", updatable = false)
    private CategoryDto cat = new CategoryDto();
    private String status;

    public CategoryDto getCat() {
        return cat;
    }

    public void setCat(CategoryDto cat) {
        this.cat = cat;
    }

    public CatCodeDto() {
    }

    public CatCodeDto(int codeId) {
        this.codeId = codeId;
    }

    @Override
    public CatCodeDto fromDomain(AdmBasekeyCode admBasekeyCode, List<String> refResource) {
        CatCodeDto baseCode = new CatCodeDto();
        baseCode.setCode(admBasekeyCode.getCode());
        baseCode.setSeqNo(admBasekeyCode.getSeqNo());
        baseCode.setCodeId(admBasekeyCode.getIdAdmBasekey());
        baseCode.setCodeDescription(admBasekeyCode.getCodeDescription());
        baseCode.setValue(admBasekeyCode.getValue());
        baseCode.setStatus(admBasekeyCode.getStatus());
        if (admBasekeyCode.getGroupBasekeyCode() != null) {
            baseCode.setGroupCodeId(admBasekeyCode.getGroupBasekeyCode().getIdAdmBasekey());
        }
        baseCode.setCatId(admBasekeyCode.getCatId());

        if (refResource != null && refResource.contains("cat")) {
            List<String> catLevelReses = CollectionUtils.filterCurrentResourceLevel(refResource, "cat");
            baseCode.cat = new CategoryDto().fromDomain(admBasekeyCode.getAdmBasekeyCat(), catLevelReses);
        }

        return baseCode;
    }

    @Override
    public Class<AdmBasekeyCode> domainClazz() {
        return AdmBasekeyCode.class;
    }

    public static CatCodeDto fromAdmBasekeyCode(AdmBasekeyCode admBasekeyCode) {
        if (admBasekeyCode == null)
            return null;

        CatCodeDto baseCode = new CatCodeDto();
        baseCode.setCode(admBasekeyCode.getCode());
        baseCode.setSeqNo(admBasekeyCode.getSeqNo());
        baseCode.setCodeId(admBasekeyCode.getIdAdmBasekey());
        baseCode.setCodeDescription(admBasekeyCode.getCodeDescription());
        baseCode.setValue(admBasekeyCode.getValue());
        baseCode.setStatus(admBasekeyCode.getStatus());
        if (admBasekeyCode.getGroupBasekeyCode() != null) {
            baseCode.setGroupCodeId(admBasekeyCode.getGroupBasekeyCode().getIdAdmBasekey());
        }
        baseCode.setCatId(admBasekeyCode.getCatId());
        return baseCode;
    }

    public AdmBasekeyCode toDomain(AdmBasekeyCat admBasekeyCat) {
        return toDomain(null, admBasekeyCat);
    }

    public AdmBasekeyCode toDomain(AdmBasekeyCode groupCode, AdmBasekeyCat admBasekeyCat) {
        AdmBasekeyCode domain = new AdmBasekeyCode();
        domain.setCode(code);
        domain.setCodeDescription(codeDescription);
        domain.setSeqNo(seqNo);
        domain.setValue(value);
        domain.setStatus(status);
        domain.setAdmBasekeyCat(admBasekeyCat);
        if (groupCode != null) {
            domain.setGroupBasekeyCode(groupCode);
        }
        return domain;
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

    public Integer getCodeId() {
        return codeId;
    }

    public String getCodeDescription() {
        return codeDescription;
    }

    public void setCodeDescription(String codeDescription) {
        this.codeDescription = codeDescription;
    }

    public Integer getGroupCodeId() {
        return groupCodeId;
    }

    public void setGroupCodeId(Integer groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public void setCodeId(Integer codeId) {
        this.codeId = codeId;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Integer getCatId() {
        return catId;
    }

    public void setCatId(Integer catId) {
        this.catId = catId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("code", code)
                .add("value", value)
                .add("seqNo", seqNo)
                .add("codeId", codeId)
                .add("codeDescription", codeDescription)
                .add("groupCodeId", groupCodeId)
                .add("groupName", groupName)
                .add("catId", catId)
                .add("status", status)
                .toString();
    }
}
