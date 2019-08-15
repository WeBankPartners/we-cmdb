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
 * The persistent class for the adm_sequence database table.
 * 
 */
@Entity
@Table(name = "adm_sequence")
@NamedQuery(name = "AdmSequence.findAll", query = "SELECT a FROM AdmSequence a")
public class AdmSequence implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idAdmSequence;
    private Integer currentVal;
    private Integer incrementVal;
    private String leftZeroPadding;
    private Integer lengthLimitation;
    private String seqName;

    public AdmSequence() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_sequence")
    public int getIdAdmSequence() {
        return this.idAdmSequence;
    }

    public void setIdAdmSequence(int idAdmSequence) {
        this.idAdmSequence = idAdmSequence;
    }

    @Column(name = "current_val")
    public Integer getCurrentVal() {
        return this.currentVal;
    }

    public void setCurrentVal(Integer currentVal) {
        this.currentVal = currentVal;
    }

    @Column(name = "increment_val")
    public Integer getIncrementVal() {
        return this.incrementVal;
    }

    public void setIncrementVal(Integer incrementVal) {
        this.incrementVal = incrementVal;
    }

    @Column(name = "left_zero_padding")
    public String getLeftZeroPadding() {
        return this.leftZeroPadding;
    }

    public void setLeftZeroPadding(String leftZeroPadding) {
        this.leftZeroPadding = leftZeroPadding;
    }

    @Column(name = "length_limitation")
    public Integer getLengthLimitation() {
        return this.lengthLimitation;
    }

    public void setLengthLimitation(Integer lengthLimitation) {
        this.lengthLimitation = lengthLimitation;
    }

    @Column(name = "seq_name")
    public String getSeqName() {
        return this.seqName;
    }

    public void setSeqName(String seqName) {
        this.seqName = seqName;
    }

}