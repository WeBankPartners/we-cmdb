package com.webank.cmdb.domain;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "adm_role_ci_type_ctrl_attr_expression")
@NamedQuery(name = "AdmRoleCiTypeCtrlAttrExpression.findAll", query = "SELECT a FROM AdmRoleCiTypeCtrlAttrExpression a")
public class AdmRoleCiTypeCtrlAttrExpression implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer idAdmRoleCiTypeCtrlAttrExpression;
    private AdmRoleCiTypeCtrlAttrCondition admRoleCiTypeCtrlAttrCondition;
    private String expression;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_ci_type_ctrl_attr_expression")
    public Integer getIdAdmRoleCiTypeCtrlAttrExpression() {
        return idAdmRoleCiTypeCtrlAttrExpression;
    }

    public void setIdAdmRoleCiTypeCtrlAttrExpression(Integer idAdmRoleCiTypeCtrlAttrExpression) {
        this.idAdmRoleCiTypeCtrlAttrExpression = idAdmRoleCiTypeCtrlAttrExpression;
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

    @Column(name = "expression")
    public String getExpression() {
        return expression;
    }

    public void setExpression(String expression) {
        this.expression = expression;
    }
}
