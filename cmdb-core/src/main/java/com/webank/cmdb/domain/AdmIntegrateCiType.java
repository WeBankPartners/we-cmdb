package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_integrate_ci_type database table.
 * 
 */
@Entity
@Table(name = "adm_integrate_ci_type")
@NamedQuery(name = "AdmIntegrateCiType.findAll", query = "SELECT a FROM AdmIntegrateCiType a")
public class AdmIntegrateCiType implements Serializable {
    private static final long serialVersionUID = 1L;
    private AdmIntegrateCiTypePK id;
    private Integer childCiTypeId;
    private Integer parentCiTypeId;
    private String refPropertyName;
    private Byte relationship;
    private String tableName;

    public AdmIntegrateCiType() {
    }

    @EmbeddedId
    public AdmIntegrateCiTypePK getId() {
        return this.id;
    }

    public void setId(AdmIntegrateCiTypePK id) {
        this.id = id;
    }

    @Column(name = "child_ci_type_id")
    public Integer getChildCiTypeId() {
        return this.childCiTypeId;
    }

    public void setChildCiTypeId(Integer childCiTypeId) {
        this.childCiTypeId = childCiTypeId;
    }

    @Column(name = "parent_ci_type_id")
    public Integer getParentCiTypeId() {
        return this.parentCiTypeId;
    }

    public void setParentCiTypeId(Integer parentCiTypeId) {
        this.parentCiTypeId = parentCiTypeId;
    }

    @Column(name = "ref_property_name")
    public String getRefPropertyName() {
        return this.refPropertyName;
    }

    public void setRefPropertyName(String refPropertyName) {
        this.refPropertyName = refPropertyName;
    }

    public Byte getRelationship() {
        return this.relationship;
    }

    public void setRelationship(Byte relationship) {
        this.relationship = relationship;
    }

    @Column(name = "table_name")
    public String getTableName() {
        return this.tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

}