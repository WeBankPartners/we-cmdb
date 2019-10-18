package com.webank.cmdb.domain;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;


@Entity
@NamedQuery(name = "AdmCodeValue.findAll", query = "SELECT a FROM AdmCodeValue a")
@Table(name = "adm_code_value")
public class AdmCodeValue {
    private Integer id;
    private String code;
    private String value;
    private String description;
    @Id
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }
    public String getValue() {
        return value;
    }
    public void setValue(String value) {
        this.value = value;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    

}
