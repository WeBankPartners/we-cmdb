package com.webank.cmdb.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrExpression;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrSelect;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.DtoId;

@JsonInclude(Include.NON_EMPTY)
public class RoleCiTypeCtrlAttrConditionDto extends BasicResourceDto<RoleCiTypeCtrlAttrConditionDto, AdmRoleCiTypeCtrlAttrCondition> {
    @DtoId
    @DtoField(domainField = "idAdmRoleCiTypeCtrlAttrCondition")
    private Integer conditionId;
    private Integer roleCiTypeCtrlAttrId;
    private Integer ciTypeAttrId;
    private String ciTypeAttrName;
    private String conditionValue;
    @DtoField(domainField = "conditionValueType")
    private String conditionType;
    private Object conditionValueObject;
    private List<String> conditionValueExprs = new ArrayList<>();
    private List<Integer> conditionValueSelects = new ArrayList<>();

    @DtoField(domainField = "admRoleCiTypeCtrlAttr", updatable = false)
    private RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr = null;

    @DtoField(domainField = "admCiTypeAttr", updatable = false)
    private CiTypeAttrDto ciTypeAttr = null;

    public RoleCiTypeCtrlAttrConditionDto() {
    }

    public List<Integer> getConditionValueSelects() {
        return conditionValueSelects;
    }

    public void setConditionValueSelects(List<Integer> conditionValueSelects) {
        this.conditionValueSelects = conditionValueSelects;
    }

    public List<String> getConditionValueExprs() {
        return conditionValueExprs;
    }

    public void setConditionValueExprs(List<String> conditionValueExprs) {
        this.conditionValueExprs = conditionValueExprs;
    }

    @Override
    public RoleCiTypeCtrlAttrConditionDto fromDomain(AdmRoleCiTypeCtrlAttrCondition domain, List<String> refResource) {
        RoleCiTypeCtrlAttrConditionDto dto = from(domain, false);

        if (refResource != null && refResource.contains("roleCiTypeCtrlAttr")) {
            List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "roleCiTypeCtrlAttr");
            dto.roleCiTypeCtrlAttr = new RoleCiTypeCtrlAttrDto().fromDomain(domain.getAdmRoleCiTypeCtrlAttr(), fields);
        }

        if (refResource != null && refResource.contains("ciTypeAttr")) {
            List<String> fields = CollectionUtils.filterCurrentResourceLevel(refResource, "ciTypeAttr");
            dto.ciTypeAttr = new CiTypeAttrDto().fromDomain(domain.getAdmCiTypeAttr(), fields);
        }

        return dto;
    }

    @Override
    public Class<AdmRoleCiTypeCtrlAttrCondition> domainClazz() {
        return AdmRoleCiTypeCtrlAttrCondition.class;
    }

    public static RoleCiTypeCtrlAttrConditionDto from(AdmRoleCiTypeCtrlAttrCondition domain, boolean withChild) {
        RoleCiTypeCtrlAttrConditionDto dto = new RoleCiTypeCtrlAttrConditionDto();
        dto.setConditionId(domain.getIdAdmRoleCiTypeCtrlAttrCondition());
        dto.setRoleCiTypeCtrlAttrId(domain.getRoleCiTypeCtrlAttrId());
        dto.setCiTypeAttrId(domain.getCiTypeAttrId());
        dto.setCiTypeAttrName(domain.getCiTypeAttrName());
        dto.setConditionValue(domain.getConditionValue());
        dto.setConditionType(domain.getConditionValueType());
        if (withChild) {
            dto.roleCiTypeCtrlAttr = RoleCiTypeCtrlAttrDto.from(domain.getAdmRoleCiTypeCtrlAttr(), false);
            dto.ciTypeAttr = CiTypeAttrDto.fromAdmCiTypeAttrs(domain.getAdmCiTypeAttr());
        }
        if("Expression".equalsIgnoreCase(domain.getConditionValueType())){
            Set<AdmRoleCiTypeCtrlAttrExpression> expressions = domain.getAdmRoleCiTypeCtrlAttrExpressions();
            for (AdmRoleCiTypeCtrlAttrExpression expressionDomain : expressions) {
                dto.conditionValueExprs.add(expressionDomain.getExpression());
            }
        }else if("Select".equalsIgnoreCase(domain.getConditionValueType())){
            Set<AdmRoleCiTypeCtrlAttrSelect> selects = domain.getAdmRoleCiTypeCtrlAttrSelects();
            for (AdmRoleCiTypeCtrlAttrSelect select : selects) {
                dto.conditionValueSelects.add(select.getIdAdmBaseKey());
            }
        }
        return dto;
    }

    public Integer getConditionId() {
        return conditionId;
    }

    public void setConditionId(Integer conditionId) {
        this.conditionId = conditionId;
    }

    public Integer getRoleCiTypeCtrlAttrId() {
        return roleCiTypeCtrlAttrId;
    }

    public void setRoleCiTypeCtrlAttrId(Integer roleCiTypeCtrlAttrId) {
        this.roleCiTypeCtrlAttrId = roleCiTypeCtrlAttrId;
    }

    public Integer getCiTypeAttrId() {
        return ciTypeAttrId;
    }

    public void setCiTypeAttrId(Integer ciTypeAttrId) {
        this.ciTypeAttrId = ciTypeAttrId;
    }

    public String getConditionValue() {
        return conditionValue;
    }

    public void setConditionValue(String conditionValue) {
        this.conditionValue = conditionValue;
    }

    public RoleCiTypeCtrlAttrDto getRoleCiTypeCtrlAttr() {
        return roleCiTypeCtrlAttr;
    }

    public void setRoleCiTypeCtrlAttr(RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr) {
        this.roleCiTypeCtrlAttr = roleCiTypeCtrlAttr;
    }

    public CiTypeAttrDto getCiTypeAttr() {
        return ciTypeAttr;
    }

    public void setCiTypeAttr(CiTypeAttrDto ciTypeAttr) {
        this.ciTypeAttr = ciTypeAttr;
    }

    public String getCiTypeAttrName() {
        return ciTypeAttrName;
    }

    public void setCiTypeAttrName(String ciTypeAttrName) {
        this.ciTypeAttrName = ciTypeAttrName;
    }

    public String getConditionType() {
        return conditionType;
    }

    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("conditionId", conditionId)
                .add("roleCiTypeCtrlAttrId", roleCiTypeCtrlAttrId)
                .add("ciTypeAttrId", ciTypeAttrId)
                .add("ciTypeAttrName", ciTypeAttrName)
                .add("conditionValue", conditionValue)
                .add("conditionValueType", conditionType)
                .toString();
    }

    public Object getConditionValueObject() {
        return conditionValueObject;
    }

    public void setConditionValueObject(Object conditionValueObject) {
        this.conditionValueObject = conditionValueObject;
    }
}
