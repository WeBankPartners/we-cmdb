package com.webank.cmdb.service.impl;

import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Modification;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.Stack;
import java.util.concurrent.atomic.AtomicInteger;

import javax.transaction.Transactional;
import javax.transaction.Transactional.TxType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.CaseFormat;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.webank.cmdb.config.log.OperationLogPointcut;
import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.IntQueryAggOperation;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplate;
import com.webank.cmdb.domain.AdmIntegrateTemplateAlias;
import com.webank.cmdb.domain.AdmIntegrateTemplateAliasAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplateRelation;
import com.webank.cmdb.dto.IdNamePairDto;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto.Criteria;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto.CriteriaNode;
import com.webank.cmdb.dto.IntQueryOperateAggResponseDto;
import com.webank.cmdb.dto.IntQueryOperateAggResponseDto.AggBranch;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.exception.ServiceException;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateAliasAttrRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateAliasRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateRelationRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateRepository;
import com.webank.cmdb.service.IntegrationQueryService;
import com.webank.cmdb.util.JsonUtil;

@Service
public class IntegrationQueryServiceImpl implements IntegrationQueryService {
    private static Logger logger = LoggerFactory.getLogger(IntegrationQueryServiceImpl.class);

    @Autowired
    private AdmIntegrateTemplateRepository intTempRepository;
    @Autowired
    private AdmIntegrateTemplateAliasRepository intTemplAliasRepository;
    @Autowired
    private AdmIntegrateTemplateAliasAttrRepository intTemplAliasAttrRepository;
    @Autowired
    private AdmIntegrateTemplateRelationRepository intTemplRltRepository;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private AdmCiTypeRepository ciTypeRepository;

    @Override
    public String getName() {
        return IntegrationQueryService.NAME;
    }

    @Transactional(TxType.REQUIRES_NEW)
    @Override
    public int createIntegrationQuery(int ciTypeId, String queryName, IntegrationQueryDto intQueryDto) {
        if (logger.isDebugEnabled()) {
            logger.debug("Creating integrate query for ciTypeId [{}] queryName:{} intQueryDto:{}", ciTypeId, queryName, JsonUtil.toJsonString(intQueryDto));
        }
        intQueryDto.validate();

        List<AdmIntegrateTemplate> intQuerys = intTempRepository.findAllByName(queryName);
        if(intQuerys != null && intQuerys.size()>0){
            throw new InvalidArgumentException(String.format("The given integration name (%s) is existed.",queryName));
        }

        AdmIntegrateTemplate intTemplate = new AdmIntegrateTemplate();
        intTemplate.setName(queryName);
        intTemplate.setDes(queryName);
        intTemplate.setCiTypeId(ciTypeId);

        intTemplate = buildIntegrateTempl(intQueryDto, intTemplate, null, null);

        // validate selection
        if (intTemplate.getAdmIntegrateTemplateAlias().size() == 0) {
            throw new InvalidArgumentException("Please select at leaset one CI.");
        }

        AtomicInteger attrCount = new AtomicInteger(0);
        intTemplate.getAdmIntegrateTemplateAlias().forEach(x -> {
            attrCount.addAndGet(x.getAdmIntegrateTemplateAliasAttrs().size());
        });
        if (attrCount.get() == 0) {
            throw new InvalidArgumentException("Please select at least one attribute.");
        }

        intTempRepository.save(intTemplate);
        intTemplAliasRepository.saveAll(intTemplate.getAdmIntegrateTemplateAlias());
        intTemplate.getAdmIntegrateTemplateAlias().forEach(x -> {
            intTemplAliasAttrRepository.saveAll(x.getAdmIntegrateTemplateAliasAttrs());
            intTemplRltRepository.saveAll(x.getChildIntegrateTemplateRelations());
        });
        logger.info("Created integrate template:{}", intTemplate.getIdAdmIntegrateTemplate());
        return intTemplate.getIdAdmIntegrateTemplate();
    }

    private AdmIntegrateTemplate buildIntegrateTempl(IntegrationQueryDto intQueryDto, AdmIntegrateTemplate intTemplate, Stack<String> path, AdmIntegrateTemplateAlias parentTemplAlias) {
        if (path == null) {
            path = new Stack<>();
        }

        int ciTypeId = intQueryDto.getCiTypeId();
        Optional<AdmCiType> ciTypeOpt = ciTypeRepository.findById(ciTypeId);
        if (!ciTypeOpt.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out given CIType [%d].", ciTypeId));
        }

        if (CiStatus.NotCreated.getCode().equals(ciTypeOpt.get().getStatus())) {
            throw new InvalidArgumentException(String.format("Can not build integration as the given CiType [%s], status is [%s].", ciTypeOpt.get().getName(), ciTypeOpt.get().getStatus()));
        }

        // String curCiTypeName = ciTypeOpt.get().getName();
        path.push(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, ciTypeOpt.get().getTableName()));
        // create current alias
        AdmIntegrateTemplateAlias templAlias = new AdmIntegrateTemplateAlias();
        templAlias.setAdmCiType(ciTypeOpt.get());
        templAlias.setAdmIntegrateTemplate(intTemplate);
        if (!Strings.isNullOrEmpty(intQueryDto.getName())) {
            templAlias.setAlias(intQueryDto.getName());
        } else {
            templAlias.setAlias(getTemplAlias(path));
        }
        if (logger.isDebugEnabled()) {
            logger.debug("Integrate template alias [ciTypeId:{},alias:{}] is generated.", templAlias.getAdmCiType().getIdAdmCiType(), templAlias.getAlias());
        }
        intTemplate.addAdmIntegrateTemplateAlia(templAlias);

        if (intQueryDto.getAttrAliases() != null && intQueryDto.getAttrAliases().size() > 0 && intQueryDto.getAttrs().size() != intQueryDto.getAttrAliases().size()) {
            throw new InvalidArgumentException(String.format("Attribute alias size [%s] and attrbute alias size [%s] are not matched.", intQueryDto.getAttrs().toString(), intQueryDto.getAttrAliases().toString()));
        }

        if (intQueryDto.getAggKeyNames().size() > 0 && intQueryDto.getAggKeyNames().size() != intQueryDto.getAttrs().size()) {
            throw new InvalidArgumentException(String.format("Attribute alias size [%s] and key name size [%s] are not matched.", intQueryDto.getAttrs().toString(), intQueryDto.getAttrAliases().toString()));
        }

        // add attributes
        for (int i = 0; i < intQueryDto.getAttrs().size(); i++) {
            int attrId = intQueryDto.getAttrs().get(i);
            Optional<AdmCiTypeAttr> attrOpt = ciTypeAttrRepository.findById(attrId);
            if (!attrOpt.isPresent()) {
                throw new InvalidArgumentException(String.format("Can not find out given attribute [%d] for CIType [%d].", attrId, ciTypeId));
            }

            validateStatusOfCiTypeAttr(attrOpt.get());

            // user attr alias if it is existed in dto obj otherwise alias will be generated
            // by path
            String attrAlias;
            String keyName = getTemplAlias(path) + "$" + CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, attrOpt.get().getPropertyName());
            ;
            if (intQueryDto.getAttrAliases() != null && intQueryDto.getAttrAliases().size() > 0) {
                attrAlias = intQueryDto.getAttrAliases().get(i);
            } else {
                attrAlias = keyName;
            }

            AdmIntegrateTemplateAliasAttr templAttr = new AdmIntegrateTemplateAliasAttr();
            templAttr.setAdmCiTypeAttr(attrOpt.get());
            templAttr.setAdmIntegrateTemplateAlias(templAlias);
            templAttr.setIsCondition("1");
            templAttr.setIsDisplayed("1");
            templAttr.setMappingName(attrAlias);
            templAttr.setSeqNo(1);
            if (intQueryDto.getAggKeyNames().size() > 0 && !Strings.isNullOrEmpty(intQueryDto.getAggKeyNames().get(i))) {
                templAttr.setKeyName(intQueryDto.getAggKeyNames().get(i));
            } else if(intQueryDto.getAttrKeyNames().size() > 0){
                templAttr.setKeyName(intQueryDto.getAttrKeyNames().get(i));
            }
            else {
                templAttr.setKeyName(keyName);
            }
            // templAttr.setSysAttr(attrAlias);
            templAlias.addAdmIntegrateTemplateAliasAttr(templAttr);
        }

        Relationship relationship = intQueryDto.getParentRs();
        if (relationship == null) {
            if (parentTemplAlias != null) {
                throw new InvalidArgumentException(String.format("parentRs is missed for ciType [%d].", intQueryDto.getCiTypeId()));
            }
        } else {
            if (relationship.getAttrId() == null) {
                throw new InvalidArgumentException("AttrId is missed for parentRs.");
            }
            if (relationship.getIsReferedFromParent() == null) {
                throw new InvalidArgumentException(String.format("isReferedFromParent is missed for parentRs [attrId:%d].", relationship.getAttrId()));
            }

            // referenced by parent's attr
            Optional<AdmCiTypeAttr> ciTypeAttrOpt = ciTypeAttrRepository.findById(relationship.getAttrId());
            if (!ciTypeAttrOpt.isPresent()) {
                throw new InvalidArgumentException(String.format("Can not find attribute [%d] for relationship.", relationship.getAttrId()));
            }

            validateStatusOfCiTypeAttr(ciTypeAttrOpt.get());

            if (!(InputType.Reference.getCode().equals(ciTypeAttrOpt.get().getInputType()) || InputType.MultRef.getCode().equals(ciTypeAttrOpt.get().getInputType()))) {
                throw new InvalidArgumentException(String.format("AttrId [%d] is not reference type, can not be used to join different Ci type.", relationship.getAttrId()));
            } else {
                int refAttCiTypeId = ciTypeAttrOpt.get().getCiTypeId();
                if (refAttCiTypeId != parentTemplAlias.getCiTypeId() && refAttCiTypeId != intQueryDto.getCiTypeId()) {
                    throw new InvalidArgumentException(String.format("AttrId [%d] dose not belong to parent ci type [%d] or current ci type [%d]", relationship.getAttrId(), parentTemplAlias.getCiTypeId(), intQueryDto.getCiTypeId()));
                }
            }

            if ((parentTemplAlias != null && !ciTypeAttrOpt.get().getCiTypeId().equals(parentTemplAlias.getAdmCiType().getIdAdmCiType())) && !ciTypeAttrOpt.get().getCiTypeId().equals(ciTypeId)) {
                throw new InvalidArgumentException(
                        String.format("The attribute's CiTypeId [%d] of relationship dose not equal to parent [%d] or child [%d].", ciTypeAttrOpt.get().getCiTypeId(), parentTemplAlias.getAdmCiType().getIdAdmCiType(), ciTypeId));
            }

            AdmIntegrateTemplateRelation templRelation = new AdmIntegrateTemplateRelation();
            templRelation.setAdmCiTypeAttr(ciTypeAttrOpt.get());
            if (parentTemplAlias != null) {
                templRelation.setParentIntegrateTemplateAlias(parentTemplAlias);
                if (parentTemplAlias.getCiTypeId() == ciTypeId) {
                    templRelation.setIsReferedFromParent(relationship.getIsReferedFromParent() ? 1 : 0);
                } else {
                    if (ciTypeAttrOpt.get().getCiTypeId() != parentTemplAlias.getCiTypeId()) {
                        templRelation.setIsReferedFromParent(0);
                    } else {
                        templRelation.setIsReferedFromParent(1);
                    }
                }
            }
            templRelation.setChildIntegrateTemplateAlias(templAlias);
            parentTemplAlias.addChildIntegrateTemplateRelation(templRelation);
        }

        for (IntegrationQueryDto child : intQueryDto.getChildren()) {
            buildIntegrateTempl(child, intTemplate, path, templAlias);

        }

        path.pop();
        return intTemplate;
    }

    private void validateStatusOfCiTypeAttr(AdmCiTypeAttr attr) {
        if (CiStatus.NotCreated.getCode().equals(attr.getStatus())) {
            throw new InvalidArgumentException(String.format("Can not build integration as the given ci type attr [%s], status is [%s].", attr.getName(), attr.getStatus()));
        }
    }

    private String getTemplAlias(List<String> path) {
        if (path == null || path.size() == 0) {
            return "";
        }

        StringBuilder sb = new StringBuilder(path.get(0));
        for (int i = 1; i < path.size(); i++) {
            sb.append("-").append(path.get(i));
        }
        return sb.toString();
    }

    @Override
    public IntegrationQueryDto getIntegrationQueryByName(String intQueryName) {
        List<AdmIntegrateTemplate> intQueryTempls = intTempRepository.findAllByName(intQueryName);
        if(intQueryTempls!=null && intQueryTempls.size()==0){
            throw new InvalidArgumentException(String.format("Can not find out AdmIntegrateTemplate by given query name [%s].", intQueryName));
        }else{
            return IntegrationQueryDto.fromDomain(intQueryTempls.get(0));
        }
    }

    @Transactional
    @Override
    public IntegrationQueryDto getIntegrationQuery(int queryId) {
        Optional<AdmIntegrateTemplate> intTemplateOpt = validateIntTemplateId(queryId);

        return IntegrationQueryDto.fromDomain(intTemplateOpt.get());
    }

    private Optional<AdmIntegrateTemplate> validateIntTemplateId(int queryId) {
        Optional<AdmIntegrateTemplate> intTemplateOpt = intTempRepository.findById(queryId);
        if (!intTemplateOpt.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out AdmIntegrateTemplate by given queryId [%d].", queryId));
        }
        return intTemplateOpt;
    }

    @Transactional
    @Override
    public int duplicateIntegrationQuery(int queryId) {
        Optional<AdmIntegrateTemplate> intTemplateOpt = validateIntTemplateId(queryId);
        AdmIntegrateTemplate integrateTemplate = intTemplateOpt.get();

        AdmIntegrateTemplate cloneIntegrateTemplate = new IntegrationTemplateCloneHelper().deepClone(integrateTemplate);

        intTempRepository.save(cloneIntegrateTemplate);
        intTemplAliasRepository.saveAll(cloneIntegrateTemplate.getAdmIntegrateTemplateAlias());
        cloneIntegrateTemplate.getAdmIntegrateTemplateAlias().forEach(x -> {
            intTemplAliasAttrRepository.saveAll(x.getAdmIntegrateTemplateAliasAttrs());
            intTemplRltRepository.saveAll(x.getChildIntegrateTemplateRelations());
        });
        return cloneIntegrateTemplate.getIdAdmIntegrateTemplate();
    }

    @Transactional
    @Override
    public void deleteIntegrationQuery(int queryId) {
        validateIntTemplateId(queryId);
        Optional<AdmIntegrateTemplate> intTemplateOpt = validateIntTemplateId(queryId);
        AdmIntegrateTemplate intTempl = intTemplateOpt.get();
        intTempl.getAdmIntegrateTemplateAlias().forEach(x -> {
            intTemplRltRepository.deleteAll(x.getChildIntegrateTemplateRelations());
            intTemplAliasAttrRepository.deleteAll(x.getAdmIntegrateTemplateAliasAttrs());
        });
        intTemplAliasRepository.deleteAll(intTempl.getAdmIntegrateTemplateAlias());
        intTempRepository.deleteById(queryId);
    }
    
    @OperationLogPointcut(operation = Modification)
    @Transactional
    @Override
    public void updateIntegrationQuery(int queryId, IntegrationQueryDto intQueryDto) {
        validateIntTemplateId(queryId);
        Optional<AdmIntegrateTemplate> intTemplateOpt = validateIntTemplateId(queryId);
        AdmIntegrateTemplate intTempl = intTemplateOpt.get();
        intTempl.getAdmIntegrateTemplateAlias().forEach(x -> {
            intTemplRltRepository.deleteAll(x.getChildIntegrateTemplateRelations());
            intTemplAliasAttrRepository.deleteAll(x.getAdmIntegrateTemplateAliasAttrs());
        });
        intTemplAliasRepository.deleteAll(intTempl.getAdmIntegrateTemplateAlias());

        intTempl.setAdmIntegrateTemplateAlias(new LinkedList<AdmIntegrateTemplateAlias>());
        intTempl = buildIntegrateTempl(intQueryDto, intTempl, null, null);
        if (intTempl.getAdmIntegrateTemplateAlias() == null) {
            throw new InvalidArgumentException("There is not selected ci Type.");
        }
        int attrCount = 0;
        for (AdmIntegrateTemplateAlias alias : intTempl.getAdmIntegrateTemplateAlias()) {
            attrCount += alias.getAdmIntegrateTemplateAliasAttrs().size();
        }
        if (attrCount == 0) {
            throw new InvalidArgumentException("There is not selected Ci type attribute.");
        }

        intTemplAliasRepository.saveAll(intTempl.getAdmIntegrateTemplateAlias());
        intTempRepository.save(intTempl);
        intTempl.getAdmIntegrateTemplateAlias().forEach(x -> {
            intTemplAliasAttrRepository.saveAll(x.getAdmIntegrateTemplateAliasAttrs());
            intTemplRltRepository.saveAll(x.getChildIntegrateTemplateRelations());
        });

    }

    @Override
    public List<IdNamePairDto> findAll(int ciTypeId, String name, Integer attrId) {
        List<AdmIntegrateTemplate> templs = null;
        if (attrId != null) {
            templs = intTempRepository.findAllByCiTypeIdAndTailAttrId(ciTypeId, attrId);
        } else if (Strings.isNullOrEmpty(name)) {
            templs = intTempRepository.findAllByCiTypeId(ciTypeId);
        } else {
            templs = intTempRepository.findAllByCiTypeIdAndNameContaining(ciTypeId, name);
        }

        return Lists.transform(templs, (x) -> {
            return new IdNamePairDto(x.getIdAdmIntegrateTemplate(), x.getName());
        });
    }

    @Transactional(TxType.REQUIRES_NEW)
    @Override
    public List<IntQueryOperateAggResponseDto> operateAggregationQuery(int ciTypeId, List<IntQueryOperateAggRequetDto> aggRequests) {
        if (logger.isDebugEnabled()) {
            logger.debug("operateAggregationQuery with ciTypeId:{}, aggRequests: {}", ciTypeId, JsonUtil.toJson(aggRequests));
        }

        List<IntQueryOperateAggResponseDto> responseDtos = new ArrayList<>(aggRequests.size());
        aggRequests.forEach(x -> {
            IntQueryAggOperation operation = IntQueryAggOperation.fromCode(x.getOperation());
            if (IntQueryAggOperation.None.equals(operation)) {
                throw new InvalidArgumentException(String.format("Wrong operation [%s] for integration aggreation query request.", x.getOperation()));
            }
            responseDtos.add(operateAggregationQueryUnit(ciTypeId, x, operation));
        });

        if (logger.isDebugEnabled()) {
            logger.debug("operateAggregationQuery response: {}", JsonUtil.toJson(responseDtos));
        }
        return responseDtos;
    }

    private IntQueryOperateAggResponseDto operateAggregationQueryUnit(int ciTypeId, IntQueryOperateAggRequetDto aggRequest, IntQueryAggOperation aggOperation) {
        IntegrationQueryDto rootIntQuery = new IntegrationQueryDto();
        IntQueryOperateAggResponseDto responseDto = new IntQueryOperateAggResponseDto();
        rootIntQuery.setCiTypeId(ciTypeId);
        aggRequest.getCriterias().forEach(x -> {
            String alias = mergeAggToIntQuery(rootIntQuery, x);
            AggBranch aggBranch = new AggBranch(x.getBranchId(), alias);
            responseDto.getBranchs().add(aggBranch);
        });

        if (aggOperation.equals(IntQueryAggOperation.Create)) {
            int queryId = createIntegrationQuery(ciTypeId, aggRequest.getQueryName(), rootIntQuery);
            responseDto.setQueryId(queryId);
        } else { // update
            updateIntegrationQuery(aggRequest.getQueryId(), rootIntQuery);
            responseDto.setQueryId(aggRequest.getQueryId());
        }
        responseDto.setQueryName(aggRequest.getQueryName());
        return responseDto;
    }

    private String mergeAggToIntQuery(IntegrationQueryDto rootIntQuery, Criteria criteria) {
        List<CriteriaNode> routine = criteria.getRoutine();

        // int destCiTypeId = criteria.getCiTypeId();
        // Optional<AdmCiType> destCiTypeOpt = validateCiType(destCiTypeId);

        List<String> path = new LinkedList<>();
        IntegrationQueryDto parentQuery = null;
        IntegrationQueryDto curQuery = rootIntQuery;

        AdmCiType parentCiType = null;
        AdmCiType curCiType = null;
        AdmCiTypeAttr ciTypeAttr = null;
        for (int i = 0; i < routine.size(); i++) {
            CriteriaNode node = routine.get(i);
            Optional<AdmCiType> ciTypeOpt = validateCiType(node.getCiTypeId());
            curCiType = ciTypeOpt.get();
            path.add(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, curCiType.getTableName()));
            if (i == 0) {// root
                parentQuery = rootIntQuery;
            } else {// root (the first one) node dose not have relationship
                Relationship parentRs = node.getParentRs();
                ciTypeAttr = validateAttrbute(parentRs.getAttrId());
                if (ciTypeAttr.getCiTypeId() != curCiType.getIdAdmCiType() && ciTypeAttr.getCiTypeId() != parentCiType.getIdAdmCiType()) {
                    throw new InvalidArgumentException(
                            String.format("Attribute [%d] dose not belong to parent ciType [%d] or current ciType [%d]", ciTypeAttr.getIdAdmCiTypeAttr(), curCiType.getIdAdmCiType(), parentCiType.getIdAdmCiType()));
                }

                // get or create child query node
                curQuery = getChildQueryNode(parentQuery, path, curCiType, ciTypeAttr);
                parentQuery = curQuery;

                path.add(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, ciTypeAttr.getPropertyName()));
            }
            parentCiType = curCiType;

        }

        // get or create destination query node
        // curQuery = getChildQueryNode(parentQuery, path,
        // destCiTypeOpt.get(),ciTypeAttr);
        // path.add(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL,destCiTypeOpt.get().getTableName()));

        if(curCiType == null) {
            throw new ServiceException("Can not find out current CI type");
        }
        
        Integer destAttrId = criteria.getAttribute().getAttrId();
        AdmCiTypeAttr destCiTypeAttr = validateAttrbute(destAttrId);
        if (destCiTypeAttr.getCiTypeId() != curCiType.getIdAdmCiType()) {
            throw new InvalidArgumentException(String.format("Attribute [%d] dose not belong to CiType [%d]", destAttrId, curCiType.getIdAdmCiType()));
        }

        curQuery.getAttrs().add(destAttrId);
        String attrAlias = genIntQueryNodeName(path) + "$" + destCiTypeAttr.getPropertyName();
        curQuery.getAttrAliases().add(attrAlias);
        curQuery.getAggKeyNames().add(attrAlias);
        return attrAlias;
    }

    private Optional<AdmCiType> validateCiType(int ciTypeId) {
        Optional<AdmCiType> ciTypeOpt = ciTypeRepository.findById(ciTypeId);
        if (!ciTypeOpt.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out CI type [%d].", ciTypeId));
        }
        return ciTypeOpt;
    }

    private AdmCiTypeAttr validateAttrbute(int node) {
        Optional<AdmCiTypeAttr> ciTypeAttrOpt = ciTypeAttrRepository.findById(node);
        if (!ciTypeAttrOpt.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out CI type attr [%d].", node));
        }
        return ciTypeAttrOpt.get();
    }

    private IntegrationQueryDto getChildQueryNode(IntegrationQueryDto parentQuery, List<String> path, AdmCiType ciType, AdmCiTypeAttr ciTypeAttr) {
        IntegrationQueryDto curQuery;
        curQuery = null;
        for (IntegrationQueryDto query : parentQuery.getChildren()) {
            if (query.getCiTypeId().equals(ciType.getIdAdmCiType()) && query.getParentRs().getAttrId().equals(ciTypeAttr.getIdAdmCiTypeAttr())) {
                curQuery = query;
            }
        }
        if (curQuery == null) {
            curQuery = new IntegrationQueryDto();
            curQuery.setCiTypeId(ciType.getIdAdmCiType());
            curQuery.setName(genIntQueryNodeName(path));
            parentQuery.addChild(curQuery);
//TODO: fix relationship (reference from parent)
            Relationship rela = new Relationship(ciTypeAttr.getIdAdmCiTypeAttr(), ciTypeAttr.getCiTypeId() != ciType.getIdAdmCiType());
            curQuery.setParentRs(rela);
        }
        return curQuery;
    }

    private String genIntQueryNodeName(List<String> path) {
        StringBuilder sb = new StringBuilder(path.get(0));
        for (int i = 1; i < path.size(); i++) {
            sb.append("-").append(path.get(i));
        }
        return sb.toString();
    }

    /*
     * @Override public List<IntQueryOperateAggResponseDto>
     * updateAggregationQuery(int ciTypeId, List<IntQueryOperateAggRequetDto>
     * aggRequests) { List<IntQueryOperateAggResponseDto> responseDtos = new
     * ArrayList<>(aggRequests.size()); aggRequests.forEach(x -> {
     * responseDtos.add(operateAggregationQueryUnit(ciTypeId,
     * x,IntQueryAggOperation.Update)); }); return responseDtos; }
     */
}
