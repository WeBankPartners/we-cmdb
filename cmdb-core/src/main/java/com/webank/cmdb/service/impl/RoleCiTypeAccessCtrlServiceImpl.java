package com.webank.cmdb.service.impl;

import com.webank.cmdb.constant.AttrConditionType;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.*;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.expression.CmdbExpressException;
import com.webank.cmdb.repository.*;
import com.webank.cmdb.service.RoleCiTypeAccessCtrlService;
import com.webank.cmdb.service.RouteQueryExpressionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.*;

@Service
public class RoleCiTypeAccessCtrlServiceImpl implements RoleCiTypeAccessCtrlService {

    @Autowired
    private AdmRoleCiTypeCtrlAttrConditionRepository roleCiTypeCtrlAttrConditionRepository;
    @Autowired
    private AdmRoleCiTypeCtrlAttrExpressionRepository roleCiTypeCtrlAttrExpressionRepository;
    @Autowired
    private AdmRoleCiTypeAttrSelectRepository roleCiTypeAttrSelectRepository;
    @Autowired
    private AdmRoleCiTypeAttrRepository roleCiTypeAttrRepository;
    @Autowired
    private RouteQueryExpressionService routeQueryExpressionService;
    @Autowired
    private AdmCiTypeAttrRepository admCiTypeAttrRepository;
    @Autowired
    private AdmCiTypeRepository admCiTypeRepository;

    @Override
    public String getName() {
        return RoleCiTypeAccessCtrlService.NAME;
    }

    @Transactional
    @Override
    public List<RoleCiTypeCtrlAttrConditionDto> createRoleCiTypeCtrlAttrConditions(List<RoleCiTypeCtrlAttrConditionDto> attrConditions) {
        validateCondition(attrConditions);

        List<RoleCiTypeCtrlAttrConditionDto> addedConditions = new LinkedList<>();
        for (RoleCiTypeCtrlAttrConditionDto attrCondition : attrConditions) {
            AdmRoleCiTypeCtrlAttrCondition admAttrCondition = new AdmRoleCiTypeCtrlAttrCondition();
            updateConditionWithDto(attrCondition, admAttrCondition);
            roleCiTypeCtrlAttrConditionRepository.save(admAttrCondition);
            attrCondition.setConditionId(admAttrCondition.getIdAdmRoleCiTypeCtrlAttrCondition());

            createConditionValues(attrCondition, admAttrCondition);
            RoleCiTypeCtrlAttrConditionDto conditionDto = RoleCiTypeCtrlAttrConditionDto.from(admAttrCondition,false);
            addedConditions.add(conditionDto);
        }
        return addedConditions;
    }

    private void validateCondition(List<RoleCiTypeCtrlAttrConditionDto> attrConditions) {
        if(attrConditions == null || attrConditions.size()==0)
            return;

        for (RoleCiTypeCtrlAttrConditionDto attrCondition : attrConditions) {
            if(AttrConditionType.Expression.codeEquals(attrCondition.getConditionType())){
                Optional<AdmCiTypeAttr> ciTypeAttrOpt = admCiTypeAttrRepository.findById(attrCondition.getCiTypeAttrId());
                if(!ciTypeAttrOpt.isPresent()){
                    throw new CmdbException(String.format("CiType attribute (id:%d) is not exited.",attrCondition.getCiTypeAttrId()));
                }
                if(! new Integer(1).equals(ciTypeAttrOpt.get().getIsAccessControlled())){
                    throw new CmdbException(String.format("Attribute (%d) is not access controlled.",attrCondition.getCiTypeAttrId()));
                }
                if(!InputType.Reference.codeEquals(ciTypeAttrOpt.get().getInputType())){
                    throw new CmdbException(String.format("Attribute (%d) is not refrence type.",attrCondition.getCiTypeAttrId()));
                }
                Integer referencedCiTypeId = ciTypeAttrOpt.get().getReferenceId();

                for (String conditionValueExpr : attrCondition.getConditionValueExprs()) {
                    AdhocIntegrationQueryDto adhocIntegrationQuery = null;
                    try {
                        adhocIntegrationQuery = routeQueryExpressionService.parseRouteExpression(conditionValueExpr);
                    }catch (CmdbExpressException ex){
                        throw new CmdbException(String.format("Route expression is invalid (%s). (%s)",conditionValueExpr, ex.getMessage()),ex);
                    }

                    List<String> resultColumns = adhocIntegrationQuery.getQueryRequest().getResultColumns();
                    if(resultColumns==null || resultColumns.size()!=1){
                        throw  new CmdbException(String.format("Expression (%s) must have one result column.",conditionValueExpr));
                    }

                    int resultAttrId = getResultAttrId(adhocIntegrationQuery.getCriteria(),resultColumns.get(0));
                    Optional<AdmCiTypeAttr> resultAttrOpt = admCiTypeAttrRepository.findById(resultAttrId);
                    if(referenceCiTypeNotMatched(referencedCiTypeId, resultAttrOpt)){
                        Optional<AdmCiType> referedCiTypeOpt = admCiTypeRepository.findById(referencedCiTypeId);
                        throw new CmdbException(String.format("Result column (%s) dose not reference to CiType (%s)",resultColumns.get(0),
                                referedCiTypeOpt.get().getTableName()));
                    }

                    String resultPropertyName = resultAttrOpt.get().getPropertyName();
                    if(!"guid".equalsIgnoreCase(resultPropertyName)){
                        throw new CmdbException(String.format("Result column (%s) is not guid.",resultPropertyName));
                    }
                }

            }
        }
    }

    private boolean referenceCiTypeNotMatched(Integer referencedCiTypeId, Optional<AdmCiTypeAttr> resultAttrOpt) {
        return !resultAttrOpt.isPresent() || resultAttrOpt.get().getAdmCiType() == null ||
                !referencedCiTypeId.equals(resultAttrOpt.get().getAdmCiType().getIdAdmCiType());
    }

    private int getResultAttrId(IntegrationQueryDto integrationQuery,String resultColumn){
        List<String> attrKeyNames = integrationQuery.getAttrKeyNames();
        int i=0;
        for(;i<attrKeyNames.size();i++){
            if(resultColumn.equalsIgnoreCase(attrKeyNames.get(i)))
                break;
        }

        if(i<attrKeyNames.size()) {
            int attrId = integrationQuery.getAttrs().get(i);
            return attrId;
        }else{
            for (IntegrationQueryDto child : integrationQuery.getChildren()) {
                return getResultAttrId(child,resultColumn);
            }
            throw new CmdbException(String.format("Can not find out result column (%s) attribute id.",resultColumn));
        }
    }

    private void updateConditionWithDto(RoleCiTypeCtrlAttrConditionDto attrCondition, AdmRoleCiTypeCtrlAttrCondition admAttrCondition) {
        admAttrCondition.setCiTypeAttrName(attrCondition.getCiTypeAttrName());
        admAttrCondition.setRoleCiTypeCtrlAttrId(attrCondition.getRoleCiTypeCtrlAttrId());
        admAttrCondition.setCiTypeAttrId(attrCondition.getCiTypeAttrId());
        admAttrCondition.setConditionValueType(attrCondition.getConditionType());
    }

    private void createConditionValues(RoleCiTypeCtrlAttrConditionDto attrCondition, AdmRoleCiTypeCtrlAttrCondition admAttrCondition) {
        String conditionType = admAttrCondition.getConditionValueType();

        if(AttrConditionType.Expression.codeEquals(conditionType)){
            for (String conditionValueExpr : attrCondition.getConditionValueExprs()) {
                AdmRoleCiTypeCtrlAttrExpression admAttrExpression = new AdmRoleCiTypeCtrlAttrExpression();
                admAttrExpression.setIdAdmRoleCiTypeCtrlAttrCondition(admAttrCondition.getIdAdmRoleCiTypeCtrlAttrCondition());
                admAttrExpression.setExpression(conditionValueExpr);
                admAttrExpression.setAdmRoleCiTypeCtrlAttrCondition(admAttrCondition);
                roleCiTypeCtrlAttrExpressionRepository.save(admAttrExpression);
            }
        }else if(AttrConditionType.Select.codeEquals(conditionType)){
            List<?> catCodes = attrCondition.getConditionValueSelects();
            for (Object catCode : catCodes) {
                AdmRoleCiTypeCtrlAttrSelect admAttrSelect = new AdmRoleCiTypeCtrlAttrSelect();
                admAttrSelect.setIdAdmRoleCiTypeCtrlAttrCondition(admAttrCondition.getIdAdmRoleCiTypeCtrlAttrCondition());
                admAttrSelect.setIdAdmBaseKey((Integer) catCode);
                admAttrSelect.setAdmRoleCiTypeCtrlAttrCondition(admAttrCondition);
                roleCiTypeAttrSelectRepository.save(admAttrSelect);
            }
        }
    }

    @Transactional
    @Override
    public List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(List<RoleCiTypeCtrlAttrConditionDto> attrConditions){
        for (RoleCiTypeCtrlAttrConditionDto attrCondition : attrConditions) {
            Integer conditionId = attrCondition.getConditionId();
            if(conditionId == null){
                throw new CmdbException("Condition id is missed.");
            }

            Optional<AdmRoleCiTypeCtrlAttrCondition> conditionOpt = roleCiTypeCtrlAttrConditionRepository.findById(conditionId);
            if(!conditionOpt.isPresent()){
                throw new CmdbException(String.format("AdmRoleCiTypeCtrlAttrCondition is not existed for id (%d).",conditionId));
            }

            AdmRoleCiTypeCtrlAttrCondition admCondition = conditionOpt.get();
            deleteConditionValues(admCondition);

            createConditionValues(attrCondition,admCondition);
            updateConditionWithDto(attrCondition,admCondition);
        }
        return attrConditions;
    }

    private void deleteConditionValues(AdmRoleCiTypeCtrlAttrCondition admCondition) {
        if(AttrConditionType.Expression.codeEquals(admCondition.getConditionValueType())){
            for (AdmRoleCiTypeCtrlAttrExpression admExpression : admCondition.getAdmRoleCiTypeCtrlAttrExpressions()) {
                roleCiTypeCtrlAttrExpressionRepository.delete(admExpression);
            }
        }else if(AttrConditionType.Select.codeEquals(admCondition.getConditionValueType())){
            for (AdmRoleCiTypeCtrlAttrSelect admSelect : admCondition.getAdmRoleCiTypeCtrlAttrSelects()) {
                roleCiTypeAttrSelectRepository.delete(admSelect);
            }
        }
    }

    public void deleteRoleCiTypeCtrlAttrConditions(Set<AdmRoleCiTypeCtrlAttrCondition> attrConditions){
        for (AdmRoleCiTypeCtrlAttrCondition attrCondition : attrConditions) {
            deleteConditionValues(attrCondition);
            roleCiTypeCtrlAttrConditionRepository.delete(attrCondition);
        }
    }

    @Transactional
    @Override
    public void deleteRoleCiTypeCtrlAttributes(List<Integer> attrIds){
        if(attrIds == null){
            return;
        }

        for (Integer id : attrIds) {
            Optional<AdmRoleCiTypeCtrlAttr> admRoleCiTypeAttr = roleCiTypeAttrRepository.findById(id);
            if(!admRoleCiTypeAttr.isPresent()){
                throw new CmdbException(String.format("RoleCiTypeCtrlAttr (id:%d) is not existed.",id));
            }
            deleteRoleCiTypeCtrlAttrConditions(admRoleCiTypeAttr.get().getAdmRoleCiTypeCtrlAttrConditions());
            roleCiTypeAttrRepository.delete(admRoleCiTypeAttr.get());
        }

    }

    @Override
    public RoleCiTypeCtrlAttrConditionDto queryRoleCiTypeCtrlAttrCondition(Integer ctlAttrId, Integer ciTypeAttrId){
        Optional<List<AdmRoleCiTypeCtrlAttrCondition>> conditions = roleCiTypeCtrlAttrConditionRepository.findByCiTypeAttrIdAndRoleCiTypeCtrlAttrId(ciTypeAttrId,ctlAttrId);
        if(!conditions.isPresent()){
            return null;
        }

        if(conditions.get().size()>1){
            throw new CmdbException(String.format("Found more than one CtrlAttrCondition record. (ctlAttrId:%d,ciTypeAttrId:%d)",
                    ctlAttrId,ciTypeAttrId));
        }
        List<RoleCiTypeCtrlAttrConditionDto> conditionDtos = new LinkedList<>();
        AdmRoleCiTypeCtrlAttrCondition admCondition = conditions.get().get(0);
        RoleCiTypeCtrlAttrConditionDto conditionDto = RoleCiTypeCtrlAttrConditionDto.from(admCondition,false);
        return conditionDto;
    }
}
