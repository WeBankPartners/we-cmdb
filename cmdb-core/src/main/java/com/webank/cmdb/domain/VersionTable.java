package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * The persistent class for the version_table database table.
 * 
 */
@Entity
@Table(name = "version_table")
@NamedQuery(name = "VersionTable.findAll", query = "SELECT v FROM VersionTable v")
public class VersionTable implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String operator;
    private short status;
    private String tableName;
    private String uniqueField;
    private Date versionDate;

    public VersionTable() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOperator() {
        return this.operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public short getStatus() {
        return this.status;
    }

    public void setStatus(short status) {
        this.status = status;
    }

    @Column(name = "table_name")
    public String getTableName() {
        return this.tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    @Column(name = "unique_field")
    public String getUniqueField() {
        return this.uniqueField;
    }

    public void setUniqueField(String uniqueField) {
        this.uniqueField = uniqueField;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "version_date")
    public Date getVersionDate() {
        return this.versionDate;
    }

    public void setVersionDate(Date versionDate) {
        this.versionDate = versionDate;
    }

}