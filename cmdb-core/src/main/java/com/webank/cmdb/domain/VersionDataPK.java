package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * The primary key class for the version_data database table.
 * 
 */
@Embeddable
public class VersionDataPK implements Serializable {
    // default serial version id, required for serializable classes.
    private static final long serialVersionUID = 1L;
    private String tableName;
    private String uniqueKey;
    private java.util.Date versionDate;

    public VersionDataPK() {
    }

    @Column(name = "table_name")
    public String getTableName() {
        return this.tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    @Column(name = "unique_key")
    public String getUniqueKey() {
        return this.uniqueKey;
    }

    public void setUniqueKey(String uniqueKey) {
        this.uniqueKey = uniqueKey;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "version_date")
    public java.util.Date getVersionDate() {
        return this.versionDate;
    }

    public void setVersionDate(java.util.Date versionDate) {
        this.versionDate = versionDate;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof VersionDataPK)) {
            return false;
        }
        VersionDataPK castOther = (VersionDataPK) other;
        return this.tableName.equals(castOther.tableName) && this.uniqueKey.equals(castOther.uniqueKey) && this.versionDate.equals(castOther.versionDate);
    }

    public int hashCode() {
        final Integer prime = 31;
        Integer hash = 17;
        hash = hash * prime + this.tableName.hashCode();
        hash = hash * prime + this.uniqueKey.hashCode();
        hash = hash * prime + this.versionDate.hashCode();

        return hash;
    }
}