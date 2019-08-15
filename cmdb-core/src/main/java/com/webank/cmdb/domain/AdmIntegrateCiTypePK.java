package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * The primary key class for the adm_integrate_ci_type database table.
 * 
 */
@Embeddable
public class AdmIntegrateCiTypePK implements Serializable {
    // default serial version id, required for serializable classes.
    private static final long serialVersionUID = 1L;
    private Integer queryId;
    private Integer ciTypeId;
    private Integer sortNo;

    public AdmIntegrateCiTypePK() {
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

    @Column(name = "sort_no")
    public Integer getSortNo() {
        return this.sortNo;
    }

    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AdmIntegrateCiTypePK)) {
            return false;
        }
        AdmIntegrateCiTypePK castOther = (AdmIntegrateCiTypePK) other;
        return (this.queryId == castOther.queryId) && (this.ciTypeId == castOther.ciTypeId) && (this.sortNo == castOther.sortNo);
    }

    public int hashCode() {
        final Integer prime = 31;
        Integer hash = 17;
        hash = hash * prime + this.queryId;
        hash = hash * prime + this.ciTypeId;
        hash = hash * prime + this.sortNo;

        return hash;
    }
}