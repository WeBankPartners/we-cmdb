package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * The persistent class for the adm_basekey_code database table.
 * 
 */
@Entity
@Table(name = "adm_basekey_code")
@NamedQuery(name = "AdmBasekeyCode.findAll", query = "SELECT a FROM AdmBasekeyCode a")
public class AdmBasekeyCode implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idAdmBasekey;
    private String code;
    private String codeDescription;
    private Integer seqNo;
    private String value;
    private String status;
    private AdmBasekeyCat admBasekeyCat;
    private AdmBasekeyCode groupBasekeyCode;
    private Set<AdmBasekeyCode> memberBasekeyCodes;
    private Integer catId;
    private Integer groupCodeId;

    public AdmBasekeyCode() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_basekey")
    public int getIdAdmBasekey() {
        return this.idAdmBasekey;
    }

    public void setIdAdmBasekey(int idAdmBasekey) {
        this.idAdmBasekey = idAdmBasekey;
    }

    public String getCode() {
        return this.code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Column(name = "code_description")
    public String getCodeDescription() {
        return this.codeDescription;
    }

    public void setCodeDescription(String codeDescription) {
        this.codeDescription = codeDescription;
    }

    @Column(name = "seq_no")
    public Integer getSeqNo() {
        return this.seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    public String getValue() {
        return this.value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_basekey_cat", insertable = false, updatable = false)
    public AdmBasekeyCat getAdmBasekeyCat() {
        return this.admBasekeyCat;
    }

    public void setAdmBasekeyCat(AdmBasekeyCat admBasekeyCat) {
        this.admBasekeyCat = admBasekeyCat;
        if (admBasekeyCat != null) {
            this.catId = admBasekeyCat.getIdAdmBasekeyCat();
        }
    }

    // bi-directional many-to-one association to AdmBasekeyCode
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_code_id", insertable = false, updatable = false)
    public AdmBasekeyCode getGroupBasekeyCode() {
        return this.groupBasekeyCode;
    }

    public void setGroupBasekeyCode(AdmBasekeyCode admBasekeyCode) {
        this.groupBasekeyCode = admBasekeyCode;
        if (admBasekeyCode != null) {
            this.groupCodeId = admBasekeyCode.getIdAdmBasekey();
        }
    }

    // bi-directional many-to-one association to AdmBasekeyCode
    @OneToMany(mappedBy = "groupBasekeyCode")
    public Set<AdmBasekeyCode> getMemberBasekeyCodes() {
        return this.memberBasekeyCodes;
    }

    public void setMemberBasekeyCodes(Set<AdmBasekeyCode> admBasekeyCodes) {
        this.memberBasekeyCodes = admBasekeyCodes;
    }

    public AdmBasekeyCode addAdmBasekeyCode(AdmBasekeyCode admBasekeyCode) {
        getMemberBasekeyCodes().add(admBasekeyCode);
        admBasekeyCode.setGroupBasekeyCode(this);

        return admBasekeyCode;
    }

    public AdmBasekeyCode removeAdmBasekeyCode(AdmBasekeyCode admBasekeyCode) {
        getMemberBasekeyCodes().remove(admBasekeyCode);
        admBasekeyCode.setGroupBasekeyCode(null);

        return admBasekeyCode;
    }

    @Column(name = "id_adm_basekey_cat")
    public Integer getCatId() {
        return catId;
    }

    public void setCatId(Integer catId) {
        this.catId = catId;
    }

    @Column(name = "group_code_id")
    public Integer getGroupCodeId() {
        return groupCodeId;
    }

    public void setGroupCodeId(Integer groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}