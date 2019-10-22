package com.webank.cmdb.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 * The persistent class for the adm_state_transition database table.
 * 
 */
@Entity
@Table(name = "adm_state_transition")
@NamedQuery(name = "AdmStateTransition.findAll", query = "SELECT a FROM AdmStateTransition a")
public class AdmStateTransition implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmStateTransition;
    private Integer action;
    private Integer currentState;
    private Integer currentStateIsConfirmed;
    private AdmBasekeyCode operationCode;
    private Integer operation;
    private String status;
    private AdmBasekeyCode targetStateCode;
    private Integer targetState;
    private Integer targetStateIsConfirmed;

    public AdmStateTransition() {
    }

    @Id
    @Column(name = "id_adm_state_transition")
    public Integer getIdAdmStateTransition() {
        return this.idAdmStateTransition;
    }

    public void setIdAdmStateTransition(Integer idAdmStateTransition) {
        this.idAdmStateTransition = idAdmStateTransition;
    }

    @Column(name = "action")
    public Integer getAction() {
        return this.action;
    }

    public void setAction(Integer action) {
        this.action = action;
    }

    @Column(name = "current_state")
    public Integer getCurrentState() {
        return this.currentState;
    }

    public void setCurrentState(Integer currentState) {
        this.currentState = currentState;
    }

    @Column(name = "current_state_is_confirmed")
    public Integer getCurrentStateIsConfirmed() {
        return this.currentStateIsConfirmed;
    }

    public void setCurrentStateIsConfirmed(Integer currentStateIsConfirmed) {
        this.currentStateIsConfirmed = currentStateIsConfirmed;
    }

    @Column(name = "operation")
    public Integer getOperation() {
        return this.operation;
    }

    public void setOperation(Integer operation) {
        this.operation = operation;
    }

    @Column(name = "status")
    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Column(name = "target_state")
    public Integer getTargetState() {
        return this.targetState;
    }

    public void setTargetState(Integer targetState) {
        this.targetState = targetState;
    }

    @Column(name = "target_state_is_confirmed")
    public Integer getTargetStateIsConfirmed() {
        return this.targetStateIsConfirmed;
    }

    public void setTargetStateIsConfirmed(Integer targetStateIsConfirmed) {
        this.targetStateIsConfirmed = targetStateIsConfirmed;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_state", insertable = false, updatable = false)
    public AdmBasekeyCode getTargetStateCode() {
        return targetStateCode;
    }

    public void setTargetStateCode(AdmBasekeyCode targetStateCode) {
        this.targetStateCode = targetStateCode;
    }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "operation", insertable = false, updatable = false)
    public AdmBasekeyCode getOperationCode() {
        return operationCode;
    }

    public void setOperationCode(AdmBasekeyCode operationCode) {
        this.operationCode = operationCode;
    }

}