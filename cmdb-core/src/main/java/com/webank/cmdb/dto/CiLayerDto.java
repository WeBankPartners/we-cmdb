package com.webank.cmdb.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmBasekeyCode;

@JsonInclude(Include.NON_EMPTY)
public class CiLayerDto {
    private String code;
    private String codeDescription;
    private Integer admBasekeyId;
    private Integer admBasekeyCat;
    private Integer seqNo;

    public static CiLayerDto fromAdmBasekeyCat(AdmBasekeyCode admBasekeyCode) {
        CiLayerDto ciLayer = new CiLayerDto();
        ciLayer.setCode(admBasekeyCode.getCode());
        ciLayer.setAdmBAsekeyId(admBasekeyCode.getIdAdmBasekey());
        ciLayer.setCodeDescription(admBasekeyCode.getCodeDescription());
        ciLayer.setSeqNo(admBasekeyCode.getSeqNo());
        return ciLayer;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCodeDescription() {
        return codeDescription;
    }

    public void setCodeDescription(String codeDescription) {
        this.codeDescription = codeDescription;
    }

    public Integer getAdmBasekeyId() {
        return admBasekeyId;
    }

    public void setAdmBAsekeyId(Integer admBAsekeyId) {
        this.admBasekeyId = admBAsekeyId;
    }

    public Integer getAdmBasekeyCat() {
        return admBasekeyCat;
    }

    public void setAdmBasekeyCat(Integer admBasekeyCat) {
        this.admBasekeyCat = admBasekeyCat;
    }

    public Integer getSeqNo() {
        return seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("code", code).add("codeDescription", codeDescription).add("admBasekeyId", admBasekeyId).add("admBasekeyCat", admBasekeyCat).add("seqNo", seqNo).toString();
    }
}
