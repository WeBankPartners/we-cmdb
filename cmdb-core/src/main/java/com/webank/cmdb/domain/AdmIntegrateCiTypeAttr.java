package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_integrate_ci_type_attr database table.
 * 
 */
@Entity
@Table(name = "adm_integrate_ci_type_attr")
@NamedQuery(name = "AdmIntegrateCiTypeAttr.findAll", query = "SELECT a FROM AdmIntegrateCiTypeAttr a")
public class AdmIntegrateCiTypeAttr implements Serializable {
    private static final long serialVersionUID = 1L;
    private AdmIntegrateCiTypeAttrPK id;
    private byte isQueryCondition;
    private byte isResultField;
    private String propertyName;

    public AdmIntegrateCiTypeAttr() {
    }

    @EmbeddedId
    public AdmIntegrateCiTypeAttrPK getId() {
        return this.id;
    }

    public void setId(AdmIntegrateCiTypeAttrPK id) {
        this.id = id;
    }

    @Column(name = "is_query_condition")
    public byte getIsQueryCondition() {
        return this.isQueryCondition;
    }

    public void setIsQueryCondition(byte isQueryCondition) {
        this.isQueryCondition = isQueryCondition;
    }

    @Column(name = "is_result_field")
    public byte getIsResultField() {
        return this.isResultField;
    }

    public void setIsResultField(byte isResultField) {
        this.isResultField = isResultField;
    }

    @Column(name = "property_name")
    public String getPropertyName() {
        return this.propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

}