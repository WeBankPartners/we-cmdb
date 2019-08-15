package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_user_favorite database table.
 * 
 */
@Entity
@Table(name = "adm_user_favorite")
@NamedQuery(name = "AdmUserFavorite.findAll", query = "SELECT a FROM AdmUserFavorite a")
public class AdmUserFavorite implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer id;
    private String name;
    private String url;
    private String userId;

    public AdmUserFavorite() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return this.url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Column(name = "user_id")
    public String getUserId() {
        return this.userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

}