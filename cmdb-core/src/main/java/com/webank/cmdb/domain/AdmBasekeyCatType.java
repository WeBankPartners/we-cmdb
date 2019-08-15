package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * The persistent class for the adm_basekey_cat_type database table.
 * 
 */
@Entity
@Table(name = "adm_basekey_cat_type")
@NamedQuery(name = "AdmBasekeyCatType.findAll", query = "SELECT a FROM AdmBasekeyCatType a")
public class AdmBasekeyCatType implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmBasekeyCatType;
    private String description;
    private String name;
    private Integer ciTypeId;
    private Integer type;
    private Set<AdmBasekeyCat> admBasekeyCats;

    public AdmBasekeyCatType() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_basekey_cat_type")
    public Integer getIdAdmBasekeyCatType() {
        return this.idAdmBasekeyCatType;
    }

    public void setIdAdmBasekeyCatType(Integer idAdmBasekeyCatType) {
        this.idAdmBasekeyCatType = idAdmBasekeyCatType;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @OneToMany(mappedBy = "admBasekeyCatType")
    public Set<AdmBasekeyCat> getAdmBasekeyCats() {
        return this.admBasekeyCats;
    }

    public void setAdmBasekeyCats(Set<AdmBasekeyCat> admBasekeyCats) {
        this.admBasekeyCats = admBasekeyCats;
    }

    public AdmBasekeyCat addAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        getAdmBasekeyCats().add(admBasekeyCat);
        admBasekeyCat.setAdmBasekeyCatType(this);

        return admBasekeyCat;
    }

    public AdmBasekeyCat removeAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        getAdmBasekeyCats().remove(admBasekeyCat);
        admBasekeyCat.setAdmBasekeyCatType(null);

        return admBasekeyCat;
    }

    @Column(name = "ci_type_id")
    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

}