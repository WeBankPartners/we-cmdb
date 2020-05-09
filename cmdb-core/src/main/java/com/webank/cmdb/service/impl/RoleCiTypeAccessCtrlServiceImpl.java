package com.webank.cmdb.service.impl;

import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrExpression;
import com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrSelect;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.repository.AdmRoleCiTypeAttrSelectRepository;
import com.webank.cmdb.repository.AdmRoleCiTypeCtrlAttrConditionRepository;
import com.webank.cmdb.repository.AdmRoleCiTypeCtrlAttrExpressionRepository;
import com.webank.cmdb.service.RoleCiTypeAccessCtrlService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

@Service
public class RoleCiTypeAccessCtrlServiceImpl implements RoleCiTypeAccessCtrlService {

    @Autowired
    private AdmRoleCiTypeCtrlAttrConditionRepository roleCiTypeCtrlAttrConditionRepository;
    @Autowired
    private AdmRoleCiTypeCtrlAttrExpressionRepository roleCiTypeCtrlAttrExpressionRepository;
    @Autowired
    private AdmRoleCiTypeAttrSelectRepository roleCiTypeAttrSelectRepository;

    @Override
    public String getName() {
        return RoleCiTypeAccessCtrlService.NAME;
    }

    @Transactional
    @Override
    public List<RoleCiTypeCtrlAttrConditionDto> createRoleCiTypeCtrlAttrConditions(List<RoleCiTypeCtrlAttrConditionDto> attrConditions) {
        for (RoleCiTypeCtrlAttrConditionDto attrCondition : attrConditions) {
            AdmRoleCiTypeCtrlAttrCondition admAttrCondition = new AdmRoleCiTypeCtrlAttrCondition();
            updateConditionWithDto(attrCondition, admAttrCondition);
            roleCiTypeCtrlAttrConditionRepository.save(admAttrCondition);
            attrCondition.setConditionId(admAttrCondition.getIdAdmRoleCiTypeCtrlAttrCondition());

            createConditionValues(attrCondition, admAttrCondition);
        }
        return attrConditions;
    }

    private void updateConditionWithDto(RoleCiTypeCtrlAttrConditionDto attrCondition, AdmRoleCiTypeCtrlAttrCondition admAttrCondition) {
        admAttrCondition.setCiTypeAttrName(attrCondition.getCiTypeAttrName());
        admAttrCondition.setRoleCiTypeCtrlAttrId(attrCondition.getRoleCiTypeCtrlAttrId());
        admAttrCondition.setCiTypeAttrId(attrCondition.getCiTypeAttrId());
        admAttrCondition.setConditionValueType(attrCondition.getConditionType());
    }

    private void createConditionValues(RoleCiTypeCtrlAttrConditionDto attrCondition, AdmRoleCiTypeCtrlAttrCondition admAttrCondition) {
        String conditionType = admAttrCondition.getConditionValueType();

        if("Expression".equalsIgnoreCase(conditionType)){
            for (String conditionValueExpr : attrCondition.getConditionValueExprs()) {
                AdmRoleCiTypeCtrlAttrExpression admAttrExpression = new AdmRoleCiTypeCtrlAttrExpression();
                admAttrExpression.setIdAdmRoleCiTypeCtrlAttrCondition(admAttrCondition.getIdAdmRoleCiTypeCtrlAttrCondition());
                admAttrExpression.setExpression(conditionValueExpr);
                roleCiTypeCtrlAttrExpressionRepository.save(admAttrExpression);
            }
        }else if("Select".equalsIgnoreCase(conditionType)){
            List<Integer> catCodes = attrCondition.getConditionValueEnums();
            for (Integer catCode : catCodes) {
                AdmRoleCiTypeCtrlAttrSelect attrSelect = new AdmRoleCiTypeCtrlAttrSelect();
                attrSelect.setIdAdmRoleCiTypeCtrlAttrCondition(admAttrCondition.getIdAdmRoleCiTypeCtrlAttrCondition());
                attrSelect.setIdAdmBaseKey(catCode);
                roleCiTypeAttrSelectRepository.save(attrSelect);
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
        if("Expression".equalsIgnoreCase(admCondition.getConditionValueType())){
            for (AdmRoleCiTypeCtrlAttrExpression admExpression : admCondition.getAdmRoleCiTypeCtrlAttrExpressions()) {
                roleCiTypeCtrlAttrExpressionRepository.delete(admExpression);
            }
        }else if("Select".equalsIgnoreCase(admCondition.getConditionValueType())){
            for (AdmRoleCiTypeCtrlAttrSelect admSelect : admCondition.getAdmRoleCiTypeCtrlAttrSelects()) {
                roleCiTypeAttrSelectRepository.delete(admSelect);
            }
        }
    }

    @Transactional
    @Override
    public void deleteRoleCiTypeCtrlAttrConditions(List<Integer> attrConditionIds){
        for (Integer conditionId : attrConditionIds) {
            Optional<AdmRoleCiTypeCtrlAttrCondition> conditionOpt = roleCiTypeCtrlAttrConditionRepository.findById(conditionId);
            if(!conditionOpt.isPresent()){
                throw new CmdbException(String.format("AdmRoleCiTypeCtrlAttrCondition is not existed for id (%d).",conditionId));
            }

            deleteConditionValues(conditionOpt.get());
            roleCiTypeCtrlAttrConditionRepository.deleteById(conditionId);
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
