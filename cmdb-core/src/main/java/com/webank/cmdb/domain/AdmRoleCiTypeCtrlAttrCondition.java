package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.persistence.*;

import com.google.common.base.MoreObjects;

/**
 * The persistent class for the adm_role_ci_type_ctrl_attr_condition database
 * table.
 */
@Entity
@Table(name = "adm_role_ci_type_ctrl_attr_condition")
@NamedQuery(name = "AdmRoleCiTypeCtrlAttrCondition.findAll", query = "SELECT a FROM AdmRoleCiTypeCtrlAttrCondition a")
public class AdmRoleCiTypeCtrlAttrCondition implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String TYPE_ID = "ID";
    public static final String TYPE_GUID = "GUID";
    public static final String TYPE_EXPRESSION = "Expression";

    private Integer idAdmRoleCiTypeCtrlAttrCondition;
    private AdmRoleCiTypeCtrlAttr admRoleCiTypeCtrlAttr;
    private AdmCiTypeAttr admCiTypeAttr;
    private Integer roleCiTypeCtrlAttrId;
    private Integer ciTypeAttrId;
    private String ciTypeAttrName;
    private String conditionValue;
    private String conditionValueType;

    private Set<AdmRoleCiTypeCtrlAttrExpression> admRoleCiTypeCtrlAttrExpressions = new LinkedHashSet<>();

    public AdmRoleCiTypeCtrlAttrCondition() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_role_ci_type_ctrl_attr_condition")
    public Integer getIdAdmRoleCiTypeCtrlAttrCondition() {
        return this.idAdmRoleCiTypeCtrlAttrCondition;
    }

    public void setIdAdmRoleCiTypeCtrlAttrCondition(Integer idAdmRoleCiTypeCtrlAttrCondition) {
        this.idAdmRoleCiTypeCtrlAttrCondition = idAdmRoleCiTypeCtrlAttrCondition;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_ci_type_attr", insertable = false, updatable = false)
    public AdmCiTypeAttr getAdmCiTypeAttr() {
        return this.admCiTypeAttr;
    }

    public void setAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        this.admCiTypeAttr = admCiTypeAttr;
    }

    // bi-directional many-to-one association to AdmRoleCiType
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_role_ci_type_ctrl_attr", insertable = false, updatable = false)
    public AdmRoleCiTypeCtrlAttr getAdmRoleCiTypeCtrlAttr() {
        return this.admRoleCiTypeCtrlAttr;
    }

    public void setAdmRoleCiTypeCtrlAttr(AdmRoleCiTypeCtrlAttr admRoleCiTypeCtrlAttr) {
        this.admRoleCiTypeCtrlAttr = admRoleCiTypeCtrlAttr;
    }

    @Column(name = "condition_value")
    public String getConditionValue() {
        return conditionValue;
    }

    public void setConditionValue(String conditionValue) {
        this.conditionValue = conditionValue;
    }

    @Column(name = "id_adm_role_ci_type_ctrl_attr")
    public Integer getRoleCiTypeCtrlAttrId() {
        return roleCiTypeCtrlAttrId;
    }

    public void setRoleCiTypeCtrlAttrId(Integer roleCiTypeCtrlAttrId) {
        this.roleCiTypeCtrlAttrId = roleCiTypeCtrlAttrId;
    }

    @Column(name = "id_adm_ci_type_attr")
    public Integer getCiTypeAttrId() {
        return ciTypeAttrId;
    }

    public void setCiTypeAttrId(Integer ciTypeAttrId) {
        this.ciTypeAttrId = ciTypeAttrId;
    }

    @Column(name = "ci_type_attr_name")
    public String getCiTypeAttrName() {
        return ciTypeAttrName;
    }

    public void setCiTypeAttrName(String ciTypeAttrName) {
        this.ciTypeAttrName = ciTypeAttrName;
    }

    @Column(name = "condition_value_type")
    public String getConditionValueType() {
        return conditionValueType;
    }

    public void setConditionValueType(String conditionValueType) {
        this.conditionValueType = conditionValueType;
    }

    @OneToMany(mappedBy = "admRoleCiTypeCtrlAttrCondition")
    public Set<AdmRoleCiTypeCtrlAttrExpression> getAdmRoleCiTypeCtrlAttrExpressions() {
        return admRoleCiTypeCtrlAttrExpressions;
    }

    public void setAdmRoleCiTypeCtrlAttrExpressions(Set<AdmRoleCiTypeCtrlAttrExpression> admRoleCiTypeCtrlAttrExpressions) {
        this.admRoleCiTypeCtrlAttrExpressions = admRoleCiTypeCtrlAttrExpressions;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("conditionId", idAdmRoleCiTypeCtrlAttrCondition)
                .add("ciTypeAttrId", ciTypeAttrId)
                .add("ciTypeAttrName", ciTypeAttrName)
                .add("conditionValue", conditionValue)
                .add("conditionValueType", conditionValueType)
                .add("admRoleCiTypeCtrlAttrExpressions", admRoleCiTypeCtrlAttrExpressions)
                .toString();
    }
}
