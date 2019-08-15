package com.webank.cmdb.domain;

import java.io.Serializable;
import java.math.BigInteger;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the version_field database table.
 * 
 */
@Entity
@Table(name = "version_field")
@NamedQuery(name = "VersionField.findAll", query = "SELECT v FROM VersionField v")
public class VersionField implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String columnKey;
    private String columnType;
    private String extra;
    private String fieldName;
    private String isNullabled;
    private BigInteger tableId;

    public VersionField() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Column(name = "column_key")
    public String getColumnKey() {
        return this.columnKey;
    }

    public void setColumnKey(String columnKey) {
        this.columnKey = columnKey;
    }

    @Column(name = "column_type")
    public String getColumnType() {
        return this.columnType;
    }

    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }

    public String getExtra() {
        return this.extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    @Column(name = "field_name")
    public String getFieldName() {
        return this.fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    @Column(name = "is_nullabled")
    public String getIsNullabled() {
        return this.isNullabled;
    }

    public void setIsNullabled(String isNullabled) {
        this.isNullabled = isNullabled;
    }

    @Column(name = "table_id")
    public BigInteger getTableId() {
        return this.tableId;
    }

    public void setTableId(BigInteger tableId) {
        this.tableId = tableId;
    }

}