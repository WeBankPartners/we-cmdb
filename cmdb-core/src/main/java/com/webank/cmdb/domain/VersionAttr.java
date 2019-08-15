package com.webank.cmdb.domain;

import java.io.Serializable;
import java.math.BigInteger;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the version_attr database table.
 * 
 */
@Entity
@Table(name = "version_attr")
@NamedQuery(name = "VersionAttr.findAll", query = "SELECT v FROM VersionAttr v")
public class VersionAttr implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String k;
    private BigInteger parentId;
    private short type;
    private String v;

    public VersionAttr() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getK() {
        return this.k;
    }

    public void setK(String k) {
        this.k = k;
    }

    @Column(name = "parent_id")
    public BigInteger getParentId() {
        return this.parentId;
    }

    public void setParentId(BigInteger parentId) {
        this.parentId = parentId;
    }

    public short getType() {
        return this.type;
    }

    public void setType(short type) {
        this.type = type;
    }

    @Lob
    public String getV() {
        return this.v;
    }

    public void setV(String v) {
        this.v = v;
    }

}