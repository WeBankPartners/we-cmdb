package com.webank.cmdb.domain;

import com.webank.cmdb.dto.IntegrationQueryDto;

import javax.persistence.*;

@Entity
@Table(name = "adm_role_ci_type_ctrl_attr_select")
@NamedQuery(name = "AdmRoleCiTypeCtrlAttrSelect.findAll", query = "SELECT a FROM AdmRoleCiTypeCtrlAttrSelect a")
public class AdmRoleCiTypeCtrlAttrSelect {

    private Integer idAdmRoleCiTypeCtrlAttrSelect;
    private Integer idAdmRoleCiTypeCtrlAttrCondition;
    private Integer idAdmBaseKey;
    private AdmRoleCiTypeCtrlAttrCondition admRoleCiTypeCtrlAttrCondition;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_ci_type_ctrl_attr_select")
    public Integer getIdAdmRoleCiTypeCtrlAttrSelect() {
        return idAdmRoleCiTypeCtrlAttrSelect;
    }

    public void setIdAdmRoleCiTypeCtrlAttrSelect(Integer idAdmRoleCiTypeCtrlAttrSelect) {
        this.idAdmRoleCiTypeCtrlAttrSelect = idAdmRoleCiTypeCtrlAttrSelect;
    }

    @Column(name = "id_adm_role_ci_type_ctrl_attr_condition")
    public Integer getIdAdmRoleCiTypeCtrlAttrCondition() {
        return idAdmRoleCiTypeCtrlAttrCondition;
    }

    public void setIdAdmRoleCiTypeCtrlAttrCondition(Integer idAdmRoleCiTypeCtrlAttrCondition) {
        this.idAdmRoleCiTypeCtrlAttrCondition = idAdmRoleCiTypeCtrlAttrCondition;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role_ci_type_ctrl_attr_condition", insertable = false, updatable = false)
    public AdmRoleCiTypeCtrlAttrCondition getAdmRoleCiTypeCtrlAttrCondition() {
        return admRoleCiTypeCtrlAttrCondition;
    }

    public void setAdmRoleCiTypeCtrlAttrCondition(AdmRoleCiTypeCtrlAttrCondition admRoleCiTypeCtrlAttrCondition) {
        this.admRoleCiTypeCtrlAttrCondition = admRoleCiTypeCtrlAttrCondition;
    }

    @Column(name = "id_adm_basekey")
    public Integer getIdAdmBaseKey() {
        return idAdmBaseKey;
    }

    public void setIdAdmBaseKey(Integer idAdmBaseKey) {
        this.idAdmBaseKey = idAdmBaseKey;
    }
}
