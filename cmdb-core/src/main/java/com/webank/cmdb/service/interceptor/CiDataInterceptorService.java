package com.webank.cmdb.service.interceptor;

import static com.webank.cmdb.constant.CmdbConstants.GUID;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_CREATION;
import static com.webank.cmdb.util.SpecialSymbolUtils.getAfterSpecialSymbol;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Pattern;

import javax.persistence.EntityManager;

import org.apache.commons.beanutils.BeanMap;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.util.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Stopwatch;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.webank.cmdb.constant.AutoFillType;
import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.constant.EnumCodeAttr;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.StateOperation;
import com.webank.cmdb.controller.ui.helper.AdmCiTypeCachingService;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.AutoFillIntegrationQueryExDto;
import com.webank.cmdb.dto.AutoFillItem;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.IntegrationQueryExDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.service.AuthorizationService;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.CmdbThreadLocal;
import com.webank.cmdb.util.DateUtils;
import com.webank.cmdb.util.JpaQueryUtils;
import com.webank.cmdb.util.JsonUtil;

@Service
@SuppressWarnings({ "rawtypes", "unchecked" })
public class CiDataInterceptorService {
    private static final Logger logger = LoggerFactory.getLogger(CiDataInterceptorService.class);

    private static final String TARGET_DEFAULT_VALUE = "";
    private static final String TARGET_NAME = "targetName";

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private AdmBasekeyCodeRepository codeRepisotory;
    @Autowired
    private CiService ciService;
    @Autowired
    private AuthorizationService authorizationService;
    @Autowired
    private AdmCiTypeCachingService admCiTypeCachingService;

    private static final List<String> systemFillFields = new ArrayList<>();
    static {
        systemFillFields.add(GUID);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_STATE);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_FIXED_DATE);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_PARENT_GUID);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_ROOT_GUID);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_UPDATED_BY);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_UPDATED_DATE);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_CREATED_BY);
        systemFillFields.add(CmdbConstants.DEFAULT_FIELD_CREATED_DATE);
    }

    public void preCreate(DynamicEntityHolder entityHolder, Map<String, ?> ci) {
        Map cloneCi = Maps.newHashMap(ci);
        cloneCi.remove("guid");

        BeanMap ciBeanMap = new BeanMap(entityHolder.getEntityObj());

        validateCiTypeStatus(entityHolder);
        validateCiTypeAttrStatus(entityHolder, ciBeanMap);
        validateRequiredFieldForCreation(entityHolder, ciBeanMap);
        validateSelectInputType(entityHolder, cloneCi);
        validateRefInputType(entityHolder, cloneCi);
        validateUniqueField(entityHolder.getEntityMeta().getCiTypeId(), cloneCi);
        validateIsAutoField(entityHolder, cloneCi);
        validateRegularExpressionRule(entityHolder, ciBeanMap);

        authorizationService.authorizeCiData(entityHolder.getEntityMeta().getCiTypeId(), entityHolder.getEntityObj(),
                ACTION_CREATION);
    }

    private void validateRegularExpressionRule(DynamicEntityHolder entityHolder, Map ciBeanMap) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                if ((InputType.Text.getCode().equals(attr.getInputType())
                        || InputType.TextArea.getCode().equals(attr.getInputType()))
                        && !StringUtils.isBlank(attr.getRegularExpressionRule())) {
                    Object val = ciBeanMap.get(attr.getPropertyName());
                    if (val != null && StringUtils.isNotEmpty(val.toString())
                            && !Pattern.matches(attr.getRegularExpressionRule(), (String) val)) {
                        throw new InvalidArgumentException(
                                String.format("The input value [%s] is not match the regular expression rule [%s].",
                                        val, attr.getRegularExpressionRule())).withErrorCode("3237", val,
                                                attr.getRegularExpressionRule());
                    }
                }
            });
        }
    }

    private void validateCiTypeAttrStatus(DynamicEntityHolder entityHolder, BeanMap ciBeanMap) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object val = ciBeanMap.get(attr.getPropertyName());
                if (val == null || ((val instanceof String) && "".equals(val))) {
                    return;
                } else { // auto filled field should be rejected
                    CiStatus ciStatus = CiStatus.fromCode(attr.getStatus());
                    if (!(CiStatus.Created.equals(ciStatus) || CiStatus.Dirty.equals(ciStatus))) {
                        throw new InvalidArgumentException(String.format("The attribute [%s] status is [%s]",
                                attr.getPropertyName(), attr.getStatus())).withErrorCode("3238", attr.getPropertyName(),
                                        attr.getStatus());
                    }
                }
            });
        }

    }

    private void validateCiTypeStatus(DynamicEntityHolder entityHolder) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        Optional<AdmCiType> ciTypeOpt = ciTypeRepository.findById(ciTypeId);
        if (!ciTypeOpt.isPresent()) {
            String ciTypeName = getCiTypeName(ciTypeId);
            throw new InvalidArgumentException(
                    String.format("Can not find out given CiType [%s(%d)]", ciTypeName, ciTypeId)).withErrorCode("3239",
                            ciTypeName, ciTypeId);
        }

        CiStatus ciStatus = CiStatus.fromCode(ciTypeOpt.get().getStatus());
        if (CiStatus.None.equals(ciStatus) || !ciStatus.supportCiDataOperation()) {
            throw new InvalidArgumentException(
                    String.format("The given CiType status is not valid [%s]", ciTypeOpt.get().getStatus()))
                            .withErrorCode("3240", ciTypeOpt.get().getStatus());
        }
    }

    private String getCiTypeName(Integer ciTypeId) {
        if (ciTypeId != null) {
            AdmCiType ciType = ciTypeRepository.getOne(ciTypeId);
            if (ciType != null) {
                return ciType.getName();
            }
            return "";
        }
        return "";
    }

    private void validateIsAutoField(DynamicEntityHolder entityHolder, Map<String, Object> updatingCi) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        // 1219
        // List<AdmCiTypeAttr> attrs =
        // ciTypeAttrRepository.findByCiTypeIdAndIsAuto(ciTypeId, 1);
        List<AdmCiTypeAttr> attrs = this.admCiTypeCachingService.findByCiTypeIdAndIsAuto(ciTypeId, 1);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object val = updatingCi.get(attr.getPropertyName());
                if (val == null || ((val instanceof String) && "".equals(val))) {
                    return;
                } else { // auto filled field should be rejected
                    throw new InvalidArgumentException(
                            String.format("The given attribute [name:%s ,val:%s] is auto filled.",
                                    attr.getPropertyName(), String.valueOf(val)),
                            attr.getPropertyName(), val).withErrorCode("3241", attr.getPropertyName(),
                                    String.valueOf(val));
                }

            });
        }
    }

    private void validateUniqueField(Integer ciTypeId, Map ciData) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByCiTypeIdAndEditIsOnly(ciTypeId, 1);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object val = ciData.get(attr.getPropertyName());
                if (val == null || ((val instanceof String) && "".equals(val))) {
                    return;
                }

                if (!ciService.queryWithFilters(ciTypeId,
                        Lists.newArrayList(new Filter(attr.getPropertyName(), FilterOperator.Equal.getCode(), val)),
                        Lists.newArrayList(GUID)).isEmpty()) {
                    throw new InvalidArgumentException(
                            String.format("The given attribute [properyName:%s] val [%s] is not unique.",
                                    attr.getPropertyName(), String.valueOf(val))).withErrorCode("3242",
                                            attr.getPropertyName(), String.valueOf(val));
                }
            });
        }
    }

    private void validateUniqueFieldForUpdate(Integer ciTypeId, Map<String, Object> ciData) {
        //
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByCiTypeIdAndEditIsOnly(ciTypeId, 1);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object newValue = ciData.get(attr.getPropertyName());
                if (newValue == null || ((newValue instanceof String) && "".equals(newValue))) {
                    return;
                }

                if (ciData.get("guid") != null
                        && isValueExisted(ciTypeId, attr, newValue, ciData.get("guid").toString())) {
                    throw new InvalidArgumentException(
                            String.format("The given attribute [properyName:%s] val [%s] is not unique.",
                                    attr.getPropertyName(), String.valueOf(newValue))).withErrorCode("3242",
                                            attr.getPropertyName(), String.valueOf(newValue));
                }
            });
        }
    }

    private void validateUniqueFieldForUpdateAutoFill(Integer ciTypeId, Map<String, Object> ciData) {
        // #2129
        List<AdmCiTypeAttr> attrs = this.admCiTypeCachingService.findByCiTypeIdAndEditIsOnly(ciTypeId, 1);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object newValue = ciData.get(attr.getPropertyName());
                if (newValue == null || ((newValue instanceof String) && "".equals(newValue))) {
                    return;
                }

                if (ciData.get("guid") != null
                        && isValueExisted(ciTypeId, attr, newValue, ciData.get("guid").toString())) {
                    throw new InvalidArgumentException(
                            String.format("The given attribute [properyName:%s] val [%s] is not unique.",
                                    attr.getPropertyName(), String.valueOf(newValue))).withErrorCode("3242",
                                            attr.getPropertyName(), String.valueOf(newValue));
                }
            });
        }
    }

    private boolean isValueExisted(Integer ciTypeId, AdmCiTypeAttr attr, Object newValue, String guid) {
        List<Filter> filters = new ArrayList<>();
        filters.add(new Filter(attr.getPropertyName(), FilterOperator.Equal.getCode(), newValue));
        filters.add(new Filter("guid", FilterOperator.NotEqual.getCode(), guid));
        return !ciService.queryWithFilters(ciTypeId, filters, Lists.newArrayList(GUID)).isEmpty();
    }

    private void validateRefInputType(DynamicEntityHolder entityHolder, Map<String, Object> ci) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByCiTypeIdAndInputTypeIn(ciTypeId,
                Lists.newArrayList(InputType.Reference.getCode()));
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                int refCiTypeId = attr.getReferenceId();
                String guid = (String) ci.get(attr.getPropertyName());
                if (StringUtils.isBlank(guid)) {
                    return;
                }
                if (ciService.queryWithFilters(refCiTypeId,
                        Lists.newArrayList(new Filter(GUID, FilterOperator.Equal.getCode(), guid)),
                        Lists.newArrayList(GUID)).isEmpty()) {
                    String ciTypeName = getCiTypeName(refCiTypeId);
                    throw new InvalidArgumentException(String.format(
                            "The given guid [%s] can not be found for CiType [%s(%d)]", guid, ciTypeName, refCiTypeId))
                                    .withErrorCode("3243", guid, ciTypeName, refCiTypeId);
                }
            });
        }

    }

    // check codeId for the attribute which input_type is select
    private void validateSelectInputType(DynamicEntityHolder entityHolder, Map<String, Object> ci) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByCiTypeIdAndInputTypeIn(
                entityHolder.getEntityMeta().getCiTypeId(), Lists.newArrayList(InputType.Droplist.getCode()));
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object val = ci.get(attr.getPropertyName());
                if (val == null || ((val instanceof String) && "".equals(val))) {
                    return;
                }
                Integer codeId = (Integer) ClassUtils.toObject(Integer.class, val);
                if (!codeRepisotory.existsByCatIdAndIdAdmBasekey(attr.getReferenceId(), codeId)) {
                    throw new InvalidArgumentException(String.format("The given code Id [%d] is invalid.", codeId))
                            .withErrorCode("3244", codeId);
                }
            });
        }
    }

    // Attributes (isNull = 0 and isAuto = 0) are required for creation
    private void validateRequiredFieldForCreation(DynamicEntityHolder entityHolder, BeanMap ciBeanMap) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository
                .findWithNullableAndIsAuto(entityHolder.getEntityMeta().getCiTypeId(), 0, 0);
        for (AdmCiTypeAttr attr : attrs) {
            if (systemFillFields.contains(attr.getPropertyName())) {
                continue;
            }

            if (CiStatus.Decommissioned.getCode().equals(attr.getStatus())
                    || CiStatus.NotCreated.getCode().equals(attr.getStatus())) {
                continue;
            }

            Object val = ciBeanMap.get(attr.getPropertyName());
            if (val == null || ((val instanceof String) && Strings.isEmpty((String) val))
                    || ((val instanceof Set) && ((Set) val).size() == 0)
                    || ((val instanceof List) && ((List) val).size() == 0)) {
                Integer ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
                String ciTypeName = getCiTypeName(ciTypeId);
                throw new InvalidArgumentException(
                        String.format("Field [%s] is required for creation of CiType [%s(%d)].", attr.getPropertyName(),
                                ciTypeName, ciTypeId)).withErrorCode("3245", attr.getPropertyName(), ciTypeName,
                                        ciTypeId);
            }
        }
    }

    public void postCreate(DynamicEntityHolder entityHolder, Map<String, Object> updateCi,
            Map<Integer, DynamicEntityMeta> multRefMetaMap, EntityManager entityManager) {
        entityManager.flush();
        //  #1224
        handleAutoFill(entityHolder, entityManager);
        handleReferenceAutoFill(entityHolder, entityManager, updateCi);
        updateSeqNoForMultiReferenceFields(entityHolder, updateCi, entityManager);
    }

    public void refreshAutoFill(DynamicEntityHolder entityHolder, EntityManager entityManager,
            Map<String, Object> ciData) {
        Stopwatch stopwatch = Stopwatch.createStarted();
        //  #1224
        handleAutoFill(entityHolder, entityManager);
        handleReferenceAutoFill(entityHolder, entityManager, ciData);
        stopwatch.stop();
        logger.info("[Performance measure][refreshAutoFill]Elapsed time in refreshAutoFill:{}", stopwatch.toString());
    }

    private void updateSeqNoForMultiReferenceFields(DynamicEntityHolder entityHolder, Map<String, Object> updateCi,
            EntityManager entityManager) {
        DynamicEntityMeta entityMeta = entityHolder.getEntityMeta();
        String curGuid = (String) entityHolder.get(CmdbConstants.DEFAULT_FIELD_GUID);
        for (Map.Entry<String, Object> updateKv : updateCi.entrySet()) {
            String field = updateKv.getKey();
            FieldNode fieldNode = entityMeta.getFieldNode(field);
            String joinTable = fieldNode.getJoinTable();
            if (DynamicEntityType.MultiReference.equals(fieldNode.getEntityType())) {
                List<String> refGuids = (List<String>) updateKv.getValue();
                for (int i = 0; i < refGuids.size(); i++) {
                    String refGuid = refGuids.get(i);

                    JpaQueryUtils.updateSeqNoForMultiReference(entityManager, curGuid, joinTable, refGuids, i, refGuid);
                }
            }
        }
    }

    private void handleAutoFill(DynamicEntityHolder entityHolder, EntityManager entityManager) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        //  #1224
        // 1219
        // List<AdmCiTypeAttr> attrs =
        // ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        List<AdmCiTypeAttr> attrs = admCiTypeCachingService.findAllByCiTypeId(ciTypeId);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                if (attr.getIsAuto() == CmdbConstants.IS_AUTO_YES && !StringUtils.isBlank(attr.getAutoFillRule())) {
                    if (CiStatus.Created.getCode().equals(attr.getStatus())) {
                        executeAutoFill(entityHolder, entityManager, (String) entityHolder.get("guid"), attr, attr);
                    }
                }
            });
        }
    }

    private void executeAutoFill(DynamicEntityHolder entityHolder, EntityManager entityManager, String currentGuid,
            AdmCiTypeAttr currentAttr, AdmCiTypeAttr attrWithRule) {
        //  #1224
        if (currentAttr.getCiTypeId() == attrWithRule.getCiTypeId()) {
            queryValueFromRuleAndSave(entityHolder, entityManager, currentGuid, attrWithRule);
        } else {

            Set<String> rootGuids = getRootGuids(currentGuid, currentAttr, attrWithRule.getAutoFillRule());
            logger.info("Fetched root guids ({}) for attrWithRule ({}) with current attr ({}) and guid ({})",
                    Arrays.toString(rootGuids.toArray()), attrWithRule.getIdAdmCiTypeAttr(),
                    currentAttr.getIdAdmCiTypeAttr(), currentGuid);
            rootGuids.forEach(
                    rootGuid -> queryValueFromRuleAndSave(entityHolder, entityManager, rootGuid, attrWithRule));
        }
    }

    private void queryValueFromRuleAndSave(DynamicEntityHolder entityHolder, EntityManager entityManager,
            String currentGuid, AdmCiTypeAttr attrWithRule) {
        //  #1224
        Object value = null;
        logger.info("Query rule value for guid ({}) with attrWithRule ({})", currentGuid,
                attrWithRule.getIdAdmCiTypeAttr());
        String rawValue = queryValueByRule(currentGuid, null, attrWithRule.getAutoFillRule(), new StringBuilder());
        if (!StringUtils.isBlank(rawValue)) {
            switch (InputType.fromCode(attrWithRule.getInputType())) {
            case Droplist:
            case Number:
                value = Integer.valueOf(rawValue);
                break;
            case Date:
                value = DateUtils.convertToTimestamp(rawValue);
                break;
            case Reference:
            default:
                value = rawValue;
                break;
            }
        }

        Map<String, Object> ci = new HashMap<>();
        ci.put("guid", currentGuid);
        ci.put(attrWithRule.getPropertyName(), value);
        validateUniqueFieldForUpdateAutoFill(attrWithRule.getCiTypeId(), ci);

        if (entityHolder.getEntityMeta().getCiTypeId() == attrWithRule.getCiTypeId()) {
            entityHolder.update(ci, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);
            entityManager.merge(entityHolder.getEntityObj());
            entityManager.flush();
        } else {
            ciService.update(entityManager, attrWithRule.getCiTypeId(), currentGuid, ci);
        }
    }

    private List<AutoFillItem> parserRule(Object autoFillRuleValue) {
        String autoFillRule = (String) autoFillRuleValue;
        List<AutoFillItem> autoRuleItems = new ArrayList<>();
        try {
            autoRuleItems = JsonUtil.toList(autoFillRule, AutoFillItem.class);
        } catch (IOException e) {
            throw new InvalidArgumentException(String.format("Failed to parse autoFillRule [%s]. ", autoFillRule), e);
        }
        return autoRuleItems;
    }

    private String extractValueFromResponse(QueryResponse response, List<AutoFillIntegrationQueryExDto> routines) {
        List<String> targetValues = getValueFromResponse(response, routines);
        return StringUtils.join(targetValues, ",");
    }

    private List<String> getValueFromResponse(QueryResponse response, List<AutoFillIntegrationQueryExDto> routines) {
        List<Map<String, Object>> contents = response.getContents();
        List<String> targetValues = new ArrayList<>();
        contents.forEach(content -> {
            Object targetValue = content.get(TARGET_NAME) != null ? content.get(TARGET_NAME) : TARGET_DEFAULT_VALUE;
            if (targetValue != null) {
                if (targetValue instanceof CatCodeDto) {
                    targetValues.add(getValueFromEnumCode(routines, targetValue));
                } else {
                    targetValues.add(targetValue.toString());
                }
            }
        });
        return targetValues;
    }

    private String getValueFromEnumCode(List<AutoFillIntegrationQueryExDto> routines, Object targetValue) {
        String value = null;
        CatCodeDto code = (CatCodeDto) targetValue;
        if (!routines.isEmpty()) {
            String codeAttr = routines.get(routines.size() - 1).getEnumCodeAttr();
            if (codeAttr != null) {
                switch (EnumCodeAttr.fromCode(codeAttr)) {
                case Id:
                    value = code.getCodeId().toString();
                    break;
                case Code:
                    value = code.getCode();
                    break;
                case Value:
                    value = code.getValue();
                    break;
                case GroupCodeId:
                    value = code.getGroupCodeId().toString();
                    break;
                default:
                    value = code.getValue();
                    break;
                }
            } else {
                value = code.getValue();
            }
        }
        return value;
    }

    private String queryValueByRule(String rootGuid, AdmCiTypeAttr attrWithGuid, Object autoFillRuleValue,
            StringBuilder sb) {
        //  #1224
        List<AutoFillItem> autoRuleItems = parserRule(autoFillRuleValue);
        boolean isPreviousExpressionValue = true;
        for (AutoFillItem item : autoRuleItems) {
            if (AutoFillType.Rule.getCode().equals(item.getType())) {
                try {
                    List<AutoFillIntegrationQueryExDto> routines = JsonUtil.toList(item.getValue(),
                            AutoFillIntegrationQueryExDto.class);
                    routines.forEach(routine -> {
                        routine.getFilters().forEach(filter -> {
                            if ("autoFill".equals(filter.getType())) {
                                filter.setValue(queryValueByRule(rootGuid, attrWithGuid, filter.getValue(),
                                        new StringBuilder()));
                            }
                        });
                    });
                    QueryResponse response = queryIntegrateWithRoutines(rootGuid, attrWithGuid, routines);
                    List<String> targetValues = getValueFromResponse(response, routines);
                    if (isPreviousExpressionValue && targetValues.isEmpty()) {
                        return null;
                    }
                    for (int i = 0; i < targetValues.size(); i++) {
                        String value = targetValues.get(i);
                        if (checkExpression(value)) {
                            queryValueByRule(rootGuid, attrWithGuid, value, sb);
                        } else {
                            sb.append(value);
                        }
                        if (i < targetValues.size() - 1) {
                            sb.append(getAfterSpecialSymbol(CmdbConstants.SYMBOL_COMMA));
                        }
                    }
                } catch (IOException e) {
                    throw new InvalidArgumentException(String.format("Failed to convert auto fill rule [%s]. ", item),
                            e).withErrorCode("3246", item);
                }
            } else {
                sb.append(item.getValue());
                isPreviousExpressionValue = false;
            }
        }
        return sb.toString();
    }

    private boolean checkExpression(String targetValue) {
        if (targetValue.contains("isReferedFromParent")) {
            return true;
        }
        return false;
    }

    private QueryResponse queryIntegrateWithRoutines(String guid, AdmCiTypeAttr attrWithGuid,
            List<AutoFillIntegrationQueryExDto> routines) {
        //  #1224
        int attrIndex = getPositionInRoutine(routines, attrWithGuid);
        AdhocIntegrationQueryDto adhocDto = buildRootDto(routines.get(0), guid, attrWithGuid, attrIndex);
        travelFillQueryDto(routines, adhocDto.getCriteria(), adhocDto.getQueryRequest(), 1, attrWithGuid);

        return ciService.adhocIntegrateQuery(adhocDto);
    }

    private int getPositionInRoutine(List<AutoFillIntegrationQueryExDto> routines, AdmCiTypeAttr attrWithGuid) {
        if (attrWithGuid != null) {
            for (int i = 0; i < routines.size(); i++) {
                AutoFillIntegrationQueryExDto autoFillIntegrationQueryDto = routines.get(i);
                // #1224
                if (autoFillIntegrationQueryDto.getCiTypeId().equals(attrWithGuid.getAdmCiType().getTableName())) {
                    return i;
                }

//                if (autoFillIntegrationQueryDto.getCiTypeId() == attrWithGuid.getCiTypeId()) {
//                    return i;
//                }
            }
        }
        return -1;
    }

    private Set<String> getRootGuids(String guid, AdmCiTypeAttr attrWithGuid, Object autoFillRuleValue) {
        //  #1224
        Set<String> guids = new HashSet<>();
        List<AutoFillItem> autoRuleItems = parserRule(autoFillRuleValue);
        for (AutoFillItem item : autoRuleItems) {
            if (AutoFillType.Rule.getCode().equals(item.getType())) {
                try {
                    List<AutoFillIntegrationQueryExDto> routines = JsonUtil.toList(item.getValue(),
                            AutoFillIntegrationQueryExDto.class);
                    List<Integer> routinesAttrs = new ArrayList<>();
                    routines.forEach(routine -> {
                        if (routine.getParentRs() != null) {
                            // #1224
                            Integer parentRsAttrId = getAttrIdByPropertyNameAndCiTypeTableName(
                                    routine.getParentRs().getAttrId());
                            routinesAttrs.add(parentRsAttrId);
                        }
                    });
                    if (routinesAttrs.contains(attrWithGuid.getIdAdmCiTypeAttr())) {
                        QueryResponse response = queryIntegrateWithRoutines(guid, attrWithGuid, routines);
                        List<Map<String, Object>> contents = response.getContents();
                        contents.forEach(content -> {
                            String rootGuid = content.get("root$guid").toString();
                            if (!guids.contains(rootGuid)) {
                                guids.add(rootGuid);
                            }
                        });
                    }
                } catch (IOException e) {
                    throw new InvalidArgumentException(String.format("Failed to convert auto fill rule [%s]. ", item),
                            e).withErrorCode("3246", item);
                }
            }
        }
        return guids;
    }

    private IntegrationQueryDto travelFillQueryDto(List<AutoFillIntegrationQueryExDto> routines,
            IntegrationQueryDto parentDto, QueryRequest queryRequest, final int position, AdmCiTypeAttr attrWithGuid) {
        // #1224
        if (position >= routines.size()) {
            return null;
        }

        IntegrationQueryExDto item = routines.get(position);
        AdmCiType itemCiType = findCiTypeByTableName(item.getCiTypeId());
        Relationship parentRs = new Relationship();
        // #1224
        Integer parentRsAttrId = getAttrIdByPropertyNameAndCiTypeTableName(item.getParentRs().getAttrId());
        parentRs.setAttrId(parentRsAttrId);
//        parentRs.setAttrId(item.getParentRs().getAttrId());
        parentRs.setIsReferedFromParent(item.getParentRs().getIsReferedFromParent());

        IntegrationQueryDto dto = new IntegrationQueryDto();
        dto.setName("index" + position);
        dto.setCiTypeId(itemCiType.getIdAdmCiType());
        dto.setParentRs(parentRs);
        List<String> fileds = new ArrayList();
        List<Integer> attrs = new ArrayList();
        if (position < routines.size() - 1) {
            attrs.add(getAttrIdByPropertyNameAndCiTypeId(itemCiType.getIdAdmCiType(), "guid"));
            // #1224
            fileds.add(itemCiType.getIdAdmCiType() + "$guid_" + position);
//            fileds.add(item.getCiTypeId() + "$guid_" + position);
        }
        if (item.getFilters().size() > 0) {
            List<Filter> filters = new ArrayList<Filter>(queryRequest.getFilters());
            item.getFilters().stream().forEach(filter -> {
                attrs.add(getAttrIdByPropertyNameAndCiTypeId(itemCiType.getIdAdmCiType(), filter.getName()));
                String fixedFilterName = null;
                if ("guid".equals(filter.getName())) {
                    fixedFilterName = item.getCiTypeId() + "$guid_" + position;
                } else {
                    fixedFilterName = item.getCiTypeId() + "$" + filter.getName() + "_" + position;
                }
                filter.setName(fixedFilterName);
                filters.add(filter);
                fileds.add(filter.getName());
            });
            queryRequest.setFilters(filters);
        }
        dto.setAttrs(attrs);
        dto.setAttrKeyNames(fileds);
        IntegrationQueryDto childDto = travelFillQueryDto(routines, dto, queryRequest, position + 1, attrWithGuid);

        if (childDto == null) {
            addTargetName(parentDto, dto);
        } else {
            parentDto.setChildren(Arrays.asList(childDto));
        }
        return parentDto;
    }

    private void addTargetName(IntegrationQueryDto parentDto, IntegrationQueryDto dto) {
        List<Integer> attrs = new ArrayList<>();
        attrs.addAll(dto.getAttrs());
        attrs.addAll(parentDto.getAttrs());
        attrs.add(dto.getParentRs().getAttrId());

        List<String> attrKeyNames = new ArrayList<>();
        attrKeyNames.addAll(dto.getAttrKeyNames());
        attrKeyNames.addAll(parentDto.getAttrKeyNames());
        attrKeyNames.add(TARGET_NAME);

        parentDto.setAttrs(attrs);
        parentDto.setAttrKeyNames(attrKeyNames);
    }

    private AdhocIntegrationQueryDto buildRootDto(IntegrationQueryExDto routineDto, String guid,
            AdmCiTypeAttr attrWithGuid, int attrIndex) {
        AdhocIntegrationQueryDto adhocDto = new AdhocIntegrationQueryDto();

        AdmCiType admCiType = findCiTypeByTableName(routineDto.getCiTypeId());

        QueryRequest queryRequest = new QueryRequest();
        String aliasName = "root$guid";
        if (attrWithGuid != null && attrWithGuid.getCiTypeId() != admCiType.getIdAdmCiType()) {
            aliasName = attrWithGuid.getCiTypeId() + "$guid";
            if (attrIndex != -1) {
                aliasName = aliasName + "_" + attrIndex;
            }
        }

        Filter filter = new Filter(aliasName, "eq", guid);
        queryRequest.setFilters(Arrays.asList(filter));
        queryRequest.getPageable().setPaging(false);

        IntegrationQueryDto rootDto = new IntegrationQueryDto();
        rootDto.setName("root");
        // #1224
        rootDto.setCiTypeId(admCiType.getIdAdmCiType());
        rootDto.setAttrs(Arrays.asList(getAttrIdByPropertyNameAndCiTypeId(admCiType.getIdAdmCiType(), "guid")));

//        rootDto.setCiTypeId(routineDto.getCiTypeId());
//        rootDto.setAttrs(Arrays.asList(getAttrIdByPropertyNameAndCiTypeId(routineDto.getCiTypeId(), "guid")));
        rootDto.setAttrKeyNames(Arrays.asList("root$guid"));

        adhocDto.setCriteria(rootDto);
        adhocDto.setQueryRequest(queryRequest);

        return adhocDto;
    }

    private AdmCiType findCiTypeByTableName(String ciTypeIdStr) {
        if(StringUtils.isBlank(ciTypeIdStr)) {
            return null;
        }
        AdmCiType admCiType = null;
        if(StringUtils.isNumeric(ciTypeIdStr)) {
            int admCiTypeId = Integer.parseInt(ciTypeIdStr);
            admCiType = ciTypeRepository.findByIdAdmCiType(admCiTypeId);
        }else {
            admCiType = ciTypeRepository.findByTableName(ciTypeIdStr);
        }
        
        return admCiType;
    }

    // tableName#propertyName
    private Integer getAttrIdByPropertyNameAndCiTypeTableName(String attrIdStr) {
        // 1219
        // List<AdmCiTypeAttr> attrs =
        // ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        if (StringUtils.isBlank(attrIdStr)) {
            return null;
        }
        
        if(StringUtils.isNumeric(attrIdStr)) {
            return Integer.parseInt(attrIdStr);
        }

        if (!attrIdStr.contains("#")) {
            return null;
        }
        String[] tableNameAndPropNameParts = attrIdStr.split("#");
        String tableName = tableNameAndPropNameParts[0];
        String propName = tableNameAndPropNameParts[1];
        AdmCiType admCiType = findCiTypeByTableName(tableName);
        List<AdmCiTypeAttr> attrs = this.admCiTypeCachingService.findAllByCiTypeId(admCiType.getIdAdmCiType());
        for (AdmCiTypeAttr attr : attrs) {
            if (propName.equalsIgnoreCase(attr.getPropertyName())) {
                return attr.getIdAdmCiTypeAttr();
            }
        }
        return null;
    }

    private Integer getAttrIdByPropertyNameAndCiTypeId(int ciTypeId, String propertyName) {
        // 1219
        // List<AdmCiTypeAttr> attrs =
        // ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        List<AdmCiTypeAttr> attrs = this.admCiTypeCachingService.findAllByCiTypeId(ciTypeId);
        for (AdmCiTypeAttr attr : attrs) {
            if (propertyName.equalsIgnoreCase(attr.getPropertyName())) {
                return attr.getIdAdmCiTypeAttr();
            }
        }
        return null;
    }

    public void preUpdate(DynamicEntityHolder entityHolder, Map<String, Object> ci) {
        Map cloneCi = Maps.newHashMap(ci);
        cloneCi.remove("guid");

        validateSelectInputType(entityHolder, cloneCi);
        validateRefInputType(entityHolder, cloneCi);
        validateNotEditable(entityHolder, cloneCi);
        validateIsAutoField(entityHolder, cloneCi);
        validateNotNullable(entityHolder, cloneCi);
        validateUniqueFieldForUpdate(entityHolder.getEntityMeta().getCiTypeId(), ci);
        validateRegularExpressionRule(entityHolder, cloneCi);
        validateValueType(entityHolder, cloneCi);
    }

    private void validateValueType(DynamicEntityHolder entityHolder, Map cloneCi) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByCiTypeId(entityHolder.getEntityMeta().getCiTypeId());
        attrs.forEach(attr -> {
            String inputType = attr.getInputType();
            String name = attr.getPropertyName();
            Object value = cloneCi.get(name);
            if (value != null) {
                if (value instanceof Collection) {
                    if (!(InputType.MultRef.getCode().equals(inputType)
                            || InputType.MultSelDroplist.getCode().equals(inputType))) {
                        throw new InvalidArgumentException(String.format("Field [%s] shold not be list.", name))
                                .withErrorCode("3247", name);
                    }
                }
            }
        });
    }

    // can not update not editable field
    private void validateNotEditable(DynamicEntityHolder entityHolder, Map<String, Object> ci) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByCiTypeIdAndEditIsEditable(ciTypeId, 0);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                Object val = ci.get(attr.getPropertyName());
                if (val == null || ((val instanceof String) && "".equals(val))) {
                    return;
                }
                throw new InvalidArgumentException(
                        String.format("The given attribute [properyName:%s] val [%s] is not editable.",
                                attr.getPropertyName(), String.valueOf(val))).withErrorCode("3248",
                                        attr.getPropertyName(), String.valueOf(val));
            });
        }
    }

    private void validateNotNullable(DynamicEntityHolder entityHolder, Map<String, Object> ci) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findNotNullableAttrs(ciTypeId);
        if (attrs != null && !attrs.isEmpty()) {
            attrs.forEach(attr -> {
                if (systemFillFields.contains(attr.getPropertyName())) {
                    return;
                }

                if (CiStatus.Decommissioned.getCode().equals(attr.getStatus())) {
                    return;
                }

                if (ci.containsKey(attr.getPropertyName())) {
                    Object val = ci.get(attr.getPropertyName());
                    if (val == null || ((val instanceof String) && "".equals(val))) {
                        throw new InvalidArgumentException(
                                String.format("The given attribute [properyName:%s] can not be updated to null.",
                                        attr.getPropertyName()),
                                attr.getPropertyName(), val).withErrorCode("3249", attr.getPropertyName(),
                                        attr.getPropertyName(), val);
                    }
                }
            });
        }
    }

    public void postUpdate(DynamicEntityHolder entityHolder, EntityManager entityManager,
            Map<String, Object> updateCi) {
        entityManager.flush();
        //  #1224
        handleReferenceAutoFill(entityHolder, entityManager, updateCi);

        updateSeqNoForMultiReferenceFields(entityHolder, updateCi, entityManager);

    }

    public void handleReferenceAutoFill(DynamicEntityHolder entityHolder, EntityManager entityManager,
            Map<String, Object> ci) {
        int ciTypeId = entityHolder.getEntityMeta().getCiTypeId();
        // 1219
        // List<AdmCiTypeAttr> attrs =
        // ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        List<AdmCiTypeAttr> attrs = this.admCiTypeCachingService.findAllByCiTypeId(ciTypeId);
        attrs.forEach(attr -> {
            if (ci.containsKey(attr.getPropertyName())) {
                // 1219
                // List<AdmCiTypeAttr> attrsWithMatchRule = ciTypeAttrRepository
                // .findAllByMatchAutoFillRule("\\\\\\\"attrId\\\\\\\":" +
                // attr.getIdAdmCiTypeAttr());

                //  #1224
                logger.info("to calculate for {}-{}:{}-{}", attr.getAdmCiType().getIdAdmCiType(),
                        attr.getAdmCiType().getTableName(), attr.getCiTypeId(), attr.getPropertyName());
                String attrKeyWordToQuery = "\\\"attrId\\\":"
                        + String.format("\\\"%s#%s\\\"", attr.getAdmCiType().getTableName(), attr.getPropertyName());
                List<AdmCiTypeAttr> attrsWithMatchRule = this.admCiTypeCachingService
                        .findAllByMatchAutoFillRule(attrKeyWordToQuery);
                attrsWithMatchRule.forEach(attrWithMatchRule -> {
                    Integer isAutoFillEnabled = attrWithMatchRule.getIsAuto();
                    if (!CmdbConstants.IS_AUTO_YES.equals(isAutoFillEnabled)) {
                        return;
                    }

                    CiStatus attrCiStatus = CiStatus.fromCode(attrWithMatchRule.getStatus());
                    if (!attrCiStatus.supportCiDataOperation()) {
                        return;
                    }
                    
                    if(!CiStatus.Created.getCode().equals(attrWithMatchRule.getStatus())) {
                        return;
                    }

                    logger.info("Executing autofill on matched attr ({}) for attr ({})",
                            attrWithMatchRule.getIdAdmCiTypeAttr(), attr.getIdAdmCiTypeAttr());
                    //  #1224
                    executeAutoFill(entityHolder, entityManager, entityHolder.get("guid").toString(), attr,
                            attrWithMatchRule);
                });
            }
        });
    }

    public void preDelete(int ciTypeId, String guid, boolean checkFinalState, DynamicEntityMeta entityMeta) {
        List<Map<String, Object>> dependentCis = ciService.lookupReferenceByCis(ciTypeId, guid, checkFinalState);
        if (!dependentCis.isEmpty()) {
            Map<String, Object> depCiData = dependentCis.get(0);
            throw new InvalidArgumentException(String.format(
                    "Ci [%s] is referenced by other ci ( guid:%s, keyName:%s ) currently, can not be deleted.", guid,
                    depCiData.get("guid"), depCiData.get("key_name")), dependentCis).withErrorCode("3250", guid,
                            depCiData.get("guid"), depCiData.get("key_name"));
        }
    }

    public void postDelete(DynamicEntityHolder entityHolder, EntityManager entityManager, int ciTypeId, String guid,
            DynamicEntityMeta entityMeta) {
        try {
            // TODO: fix citype can not be found after deletion
            Map<String, Object> ciData = ciService.getCi(ciTypeId, guid);
            Map ci = new HashMap();
            ci.put(CmdbConstants.DEFAULT_FIELD_STATE, StateOperation.Delete);
            ci.put(GUID, guid);

            //  #1224
            handleReferenceAutoFill(entityHolder, entityManager, ci);
        } catch (Exception e) {
            String errorMessage = String.format("Exception happen for auto fill after ci type (%s) deletion.",
                    ciTypeId);
            logger.error(errorMessage, e);
        }
    }
}
