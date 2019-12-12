package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * The persistent class for the adm_files database table.
 * 
 */
@Entity
@Table(name = "adm_files")
@NamedQuery(name = "AdmFile.findAll", query = "SELECT a FROM AdmFile a")
public class AdmFile implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmFile;
    private byte[] content;
    private String name;
    private String type;

    public AdmFile() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_file")
    public Integer getIdAdmFile() {
        return this.idAdmFile;
    }

    public void setIdAdmFile(Integer idAdmFile) {
        this.idAdmFile = idAdmFile;
    }

    @Lob
    public byte[] getContent() {
        return this.content;
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

}