package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * The primary key class for the adm_integrate_ci_type_attr database table.
 * 
 */
@Embeddable
public class AdmIntegrateCiTypeAttrPK implements Serializable {
    // default serial version id, required for serializable classes.
    private static final long serialVersionUID = 1L;
    private Integer queryId;
    private Integer ciTypeId;
    private Integer ciTypeAttrId;
    private Integer ciTypeSortNo;

    public AdmIntegrateCiTypeAttrPK() {
    }

    @Column(name = "query_id")
    public Integer getQueryId() {
        return this.queryId;
    }

    public void setQueryId(Integer queryId) {
        this.queryId = queryId;
    }

    @Column(name = "ci_type_id")
    public Integer getCiTypeId() {
        return this.ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    @Column(name = "ci_type_attr_id")
    public Integer getCiTypeAttrId() {
        return this.ciTypeAttrId;
    }

    public void setCiTypeAttrId(Integer ciTypeAttrId) {
        this.ciTypeAttrId = ciTypeAttrId;
    }

    @Column(name = "ci_type_sort_no")
    public Integer getCiTypeSortNo() {
        return this.ciTypeSortNo;
    }

    public void setCiTypeSortNo(Integer ciTypeSortNo) {
        this.ciTypeSortNo = ciTypeSortNo;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AdmIntegrateCiTypeAttrPK)) {
            return false;
        }
        AdmIntegrateCiTypeAttrPK castOther = (AdmIntegrateCiTypeAttrPK) other;
        return (this.queryId == castOther.queryId) && (this.ciTypeId == castOther.ciTypeId) && (this.ciTypeAttrId == castOther.ciTypeAttrId) && (this.ciTypeSortNo == castOther.ciTypeSortNo);
    }

    public int hashCode() {
        final Integer prime = 31;
        Integer hash = 17;
        hash = hash * prime + this.queryId;
        hash = hash * prime + this.ciTypeId;
        hash = hash * prime + this.ciTypeAttrId;
        hash = hash * prime + this.ciTypeSortNo;

        return hash;
    }
}