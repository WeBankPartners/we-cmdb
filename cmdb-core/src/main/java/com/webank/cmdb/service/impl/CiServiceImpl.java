package com.webank.cmdb.service.impl;

import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Creation;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Modification;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Removal;
import static com.webank.cmdb.constant.CmdbConstants.CALLBACK_ID;
import static com.webank.cmdb.constant.CmdbConstants.GUID;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_ENQUIRY;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_MODIFICATION;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_REMOVAL;
import static org.apache.commons.collections.CollectionUtils.isEmpty;
import static org.apache.commons.collections.CollectionUtils.isNotEmpty;

import java.lang.reflect.Array;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.Stack;
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.From;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.sql.DataSource;
import javax.transaction.Transactional;

import com.webank.cmdb.domain.*;
import com.webank.cmdb.repository.*;
import org.apache.commons.beanutils.BeanMap;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.proxy.HibernateProxy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.google.common.base.CaseFormat;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.webank.cmdb.config.ApplicationProperties.DatasourceProperties;
import com.webank.cmdb.config.log.OperationLogPointcut;
import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.constant.FieldType;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.FilterRelationship;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.StateOperation;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.CiDataTreeDto;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeHeaderDto.CiKeyPair;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntQueryResponseHeader;
import com.webank.cmdb.dto.IntQueryResponseHeader.AttrUnit;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.PageInfo;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dynamicEntity.DynamicEntityClassLoader;
import com.webank.cmdb.dynamicEntity.DynamicEntityGenerator;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.dynamicEntity.DynamicEntityManagerFactory;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.DynamicEntityUtils;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.dynamicEntity.MultiValueFeildOperationUtils;
import com.webank.cmdb.exception.BatchChangeException;
import com.webank.cmdb.exception.BatchChangeException.ExceptionHolder;
import com.webank.cmdb.exception.CmdbAccessDeniedException;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.exception.ServiceException;
import com.webank.cmdb.service.AuthorizationService;
import com.webank.cmdb.service.BaseKeyInfoService;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.IntegrationQueryService;
import com.webank.cmdb.service.SequenceService;
import com.webank.cmdb.service.interceptor.CiDataInterceptorService;
import com.webank.cmdb.stateTransition.Engine;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.CmdbThreadLocal;
import com.webank.cmdb.util.CollectionUtils;
import com.webank.cmdb.util.FilterInfo;
import com.webank.cmdb.util.JpaQueryUtils;
import com.webank.cmdb.util.JsonUtil;
import com.webank.cmdb.util.Pageable;
import com.webank.cmdb.util.PriorityEntityManager;
import com.webank.cmdb.util.Sorting;

@Service
@SuppressWarnings({ "rawtypes", "unchecked" })
@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "ciServiceImpl")
public class CiServiceImpl implements CiService {
    private static Logger logger = LoggerFactory.getLogger(CiServiceImpl.class);

    private static final String ACCESS_CONTROL_ATTRIBUTE_PREFIX = "access-control-attribute/";
    private static final String ACCESS_CONTROL_ATTRIBUTE_FORMAT = ACCESS_CONTROL_ATTRIBUTE_PREFIX + "%d/%s";

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private SequenceService sequenceService;
    @Autowired
    private IntegrationQueryService intQueryService;
    @Autowired
    private BaseKeyInfoService basekeyInfoService;
    @Autowired
    private CiDataInterceptorService ciDataInterceptorService;
    @Autowired
    private AuthorizationService authorizationService;
    @Autowired
    private Engine stateTransEngine;
    @Autowired
    private AdmStateTransitionRepository stateTransitionRepository;
    @Autowired
    private AdmBasekeyCatRepository cateRepository;
    @Autowired
    private AdmIntegrateTemplateRepository intTempRepository;

    @Autowired
    @Value("${spring.jpa.show-sql}")
    private String showSql;

    private DynamicEntityManagerFactory dynamicEntityManagerFactory;
    // private EntityManager entityManager;
    private EntityManagerFactory entityManagerFactory;
    private Map<Integer, DynamicEntityMeta> dynamicEntityMetaMap;
    // Map attribute id -> entity meta
    private Map<Integer, DynamicEntityMeta> multSelectMetaMap;
    private Map<Integer, DynamicEntityMeta> multRefMetaMap;
    private DynamicEntityClassLoader dyClassLoader;
    private volatile boolean isLoaded = false;

    private static final Map<String, String> finalStates = new HashMap<>();
    static {
        finalStates.put(CmdbConstants.CI_STATE_DESIGN, "delete");
        finalStates.put(CmdbConstants.CI_STATE_CREATE, "destroyed");
        finalStates.put(CmdbConstants.CI_STATE_START_STOP, "destroyed");
    }

    public CiServiceImpl(DataSource dataSource, DatasourceProperties datasourceProperties) {
        dynamicEntityManagerFactory = new DynamicEntityManagerFactory(dataSource, datasourceProperties.getSchema());
    }

    @Override
    public String getName() {
        return CiService.NAME;
    }

    // To resolve entity management session close issue.
    @Transactional
    @Override
    public synchronized void reload() {
        if (isLoaded) {
            logger.info("Dynamic entity meta data have been reloaded.");
            return;
        }

        logger.info("Dynamic entity meta data reloading...");

        dynamicEntityMetaMap = new HashMap<>();
        multSelectMetaMap = new HashMap<>();
        multRefMetaMap = new HashMap<>();

        List<AdmCiType> ciTypes = ciTypeRepository.findAll();
        List<DynamicEntityMeta> entityHolders = new LinkedList<>();

        Map<Integer, String> ciTypeIdToClassName = new HashMap<>();
        Map<Integer, List<AdmCiTypeAttr>> referedAttrMap = new HashMap<>();
        ciTypes.forEach(ciType -> {
            if (!CiStatus.shouldBeLoadedForDynamicEntity(CiStatus.fromCode(ciType.getStatus()))) {
                logger.warn("CiType [{}] status is {} , ignore ...", ciType.getName(), ciType.getStatus());
                return;
            }

            List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Reference.getCode(), ciType.getIdAdmCiType());
            attrs.addAll(ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.MultRef.getCode(), ciType.getIdAdmCiType()));

            referedAttrMap.put(ciType.getIdAdmCiType(), attrs);
        });

        Map<String, byte[]> entityClassBufMap = new HashMap<>();

        ciTypes.forEach(ciType -> {
            if (!CiStatus.shouldBeLoadedForDynamicEntity(CiStatus.fromCode(ciType.getStatus()))) {
                return;
            }

            List<AdmCiTypeAttr> multSelectAttrs = ciType.retrieveMultSelectionAttrs();
            for (AdmCiTypeAttr attr : multSelectAttrs) {
                DynamicEntityMeta multSelMeta = DynamicEntityMeta.createForMultSel(attr);
                initDynamicEnitityMeta(entityHolders, ciTypeIdToClassName, entityClassBufMap, ciType, multSelMeta, true);
                multSelectMetaMap.put(attr.getIdAdmCiTypeAttr(), multSelMeta);
            }

            List<AdmCiTypeAttr> multReferenceAttrs = ciType.retrieveMultReferenceAttrs();
            for (AdmCiTypeAttr attr : multReferenceAttrs) {
                DynamicEntityMeta multRefMeta = DynamicEntityMeta.createForMultRef(attr);
                initDynamicEnitityMeta(entityHolders, ciTypeIdToClassName, entityClassBufMap, ciType, multRefMeta, true);
                multRefMetaMap.put(attr.getIdAdmCiTypeAttr(), multRefMeta);
            }

            DynamicEntityMeta entityMeta = DynamicEntityMeta.create(ciType, referedAttrMap, ciTypeRepository);
            initDynamicEnitityMeta(entityHolders, ciTypeIdToClassName, entityClassBufMap, ciType, entityMeta, false);
        });

        dyClassLoader = new DynamicEntityClassLoader(this.getClass().getClassLoader(), entityClassBufMap);
        for (DynamicEntityMeta meta : entityHolders) {
            try {
                meta.setEntityClazz(dyClassLoader.loadClass(meta.getQulifiedName()));
            } catch (ClassNotFoundException e) {
                throw new ServiceException(String.format("Can not load class [%s].", meta.getQulifiedName()), e);
            }
        }
        /*
         * dynamicEntityMetaMap.forEach((k,v)->{ try {
         * v.setEntityClazz(dyClassLoader.loadClass(ciTypeIdToClassName.get(k))); }
         * catch (ClassNotFoundException e) { throw new
         * ServiceException(String.format("Can not load class [%s].",ciTypeIdToClassName
         * .get(k)),e); } });
         */
        dynamicEntityManagerFactory.setShowSql(showSql);
        entityManagerFactory = dynamicEntityManagerFactory.getEntityManagerFactory(entityHolders, dyClassLoader).getEntityManagerFactory();
        isLoaded = true;
        logger.info("Dynamic entity meta data loaded.");
    }

    private void initDynamicEnitityMeta(List<DynamicEntityMeta> entityHolders, Map<Integer, String> ciTypeIdToClassName, Map<String, byte[]> entityClassBufMap, AdmCiType ciType, DynamicEntityMeta entityMeta, boolean derivedEntity) {
        if (entityMeta.getAttrs() == null || entityMeta.getAttrs().size() == 0) {
            logger.warn("There is not valid attribute of CiType [{}], ignore it.", ciType.getIdAdmCiType());
            return;
        }
        byte[] classBuf = DynamicEntityGenerator.generate(entityMeta.getQulifiedName(), entityMeta.getTableName(), entityMeta.getAllFieldNodes(true));
        entityClassBufMap.put(entityMeta.getQulifiedName(), classBuf);
        ciTypeIdToClassName.put(ciType.getIdAdmCiType(), entityMeta.getQulifiedName());

        entityHolders.add(entityMeta);
        if (!derivedEntity) {
            dynamicEntityMetaMap.put(ciType.getIdAdmCiType(), entityMeta);
        }
    }

    private PriorityEntityManager getEntityManager() {
        if (!isLoaded) {
            reload();
        }
        // return entityManagerFactory.createEntityManager();
        return new PriorityEntityManager(entityManagerFactory);
    }
    /*
     * private Class<?> convertClass(DynamicEntityMeta entityMeta,
     * List<AdmCiTypeAttr> referedAttrs) { byte[] classBuf =
     * DynamicEntityGenerator.generate(entityMeta.getQulifiedName(),
     * entityMeta.getTableName(), entityMeta.getAllFieldNodes(), referedAttrs);
     * Class<?> entityClazz = dyClassLoader.getClass(classBuf); return entityClazz;
     * }
     */

    public Map<Integer, DynamicEntityMeta> getDynamicEntityMetaMap() {
        if (!isLoaded) {
            reload();
        }
        return dynamicEntityMetaMap;
    }

    @Override
    public synchronized Map<Integer, DynamicEntityMeta> getMultSelectMetaMap() {
        if (!isLoaded) {
            reload();
        }
        return multSelectMetaMap;
    }

    public void invalidate() {
        isLoaded = false;
    }

    private void validateDynamicEntityManager() {
        if (!isLoaded) {
            reload();
        }
    }

    @Override
    public QueryResponse<CiData> query(int ciTypeId, QueryRequest ciRequest) {
        if (logger.isDebugEnabled()) {
            logger.debug("CI query request, ciTypeId:{}, query request:{}", ciTypeId, JsonUtil.toJsonString(ciRequest));
        }

        validateCiType(ciTypeId);
        validateRequest(ciTypeId, ciRequest);

        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        List<Object> results = null;
        int totalCount = 0;
        QueryResponse<CiData> ciInfoResp = new QueryResponse<>();
        try {
            results = doQuery(ciRequest, entityMeta, true);
            totalCount = convertResultToInteger(results);

            results = doQuery(ciRequest, entityMeta, false);
            if (ciRequest.getAggregationFuction() != null &&
                    ciRequest.getAggregationFuction().size() > 0) {
                if (results != null && results.size() > 0) {
                    Map<String, Object> enhacedMap = Maps.newHashMap();
                    enhacedMap.put("fixed_date", results);
                    ciInfoResp.addContent(new CiData(enhacedMap, null));
                }
            } else {
                results.forEach(x -> {
                    Map<String, Object> entityBeanMap = null;

                    entityBeanMap = ClassUtils.convertBeanToMap(x, entityMeta, true, ciRequest.getResultColumns());

                    Map<String, Object> enhacedMap = enrichCiObject(entityMeta, entityBeanMap, entityManager);
                    List<String> nextOperations = getNextOperations(entityBeanMap);
                    CiData ciData = new CiData(enhacedMap, nextOperations);

                    ciInfoResp.addContent(ciData);
                });
            }
        } finally {
            priEntityManager.close();
        }

        setupPageInfo(ciRequest, totalCount, ciInfoResp);

        if (logger.isDebugEnabled()) {
            logger.debug("Return ci response:{}", JsonUtil.toJsonString(ciInfoResp));
        }

        return ciInfoResp;
    }

    private List<Filter> convertFilterForMultiValueField(EntityManager entityManager, Integer ciTypeId, List<Filter> filters) {
        for (Filter filter : filters) {
            String field = filter.getName();
            List convertedValues = Lists.newLinkedList();
            AdmCiTypeAttr attr = this.ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(ciTypeId, field);
            if (InputType.MultRef.getCode().equals(attr.getInputType())) {
                List<String> guids = (List<String>) filter.getValue();
                int refCiTypeId = attr.getReferenceId();
                for (String guid : guids) {
                    Object ciBean = this.getCiBeanObject(entityManager, refCiTypeId, guid);
                    convertedValues.add(ciBean);
                }
            }
            filter.setValue(convertedValues);
        }
        return filters;
    }

    private void validateRequest(Integer ciTypeId, QueryRequest ciRequest) {
        if (ciRequest.getFilters() != null && ciRequest.getFilters().size() > 0) {
            for (Filter filter : ciRequest.getFilters()) {
                if (Strings.isNullOrEmpty(filter.getName())) {
                    throw new InvalidArgumentException("Filter name can not be null or empty.");
                }
                if (Strings.isNullOrEmpty(filter.getOperator())) {
                    throw new InvalidArgumentException("Filter operator can not be null or empty.");
                }
            }
        }
        if (ciRequest.getSorting() != null && !Strings.isNullOrEmpty(ciRequest.getSorting().getField())) {
            AdmCiTypeAttr attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(ciTypeId, ciRequest.getSorting().getField());
            if (attr != null) {
                if (InputType.MultRef.getCode().equals(attr.getInputType()) || InputType.MultSelDroplist.getCode().equals(attr.getInputType())) {
                    throw new InvalidArgumentException(String.format("Multiple reference and multiple selection feild [%s] don't support sorting.", ciRequest.getSorting().getField()));
                }
            }

        }
    }

    public List<String> getNextOperations(Map<String, Object> enhacedMap) {
        if (enhacedMap.get(CmdbConstants.DEFAULT_FIELD_STATE) == null) {
            return Lists.newArrayList();
        }

        Integer stateId = (Integer) enhacedMap.get(CmdbConstants.DEFAULT_FIELD_STATE);

        String fixedDate = (String) enhacedMap.get(CmdbConstants.DEFAULT_FIELD_FIXED_DATE);
        List<AdmStateTransition> transitions = this.stateTransitionRepository.findDistinctOperationByCurrentStateAndCurrentStateIsConfirmed(stateId, Strings.isNullOrEmpty(fixedDate) ? 0 : 1);
        List<String> nextOperations = Lists.newLinkedList();
        for (AdmStateTransition transition : transitions) {
            String operation = transition.getOperationCode().getCode();
            nextOperations.add(operation);
        }
        return nextOperations;
    }

    private List<Object> doQuery(QueryRequest ciRequest, DynamicEntityMeta entityMeta, boolean isSelRowCount) {
        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();

            CriteriaQuery query = null;
            if (isSelRowCount) {
                query = cb.createQuery();
            } else {
                query = cb.createQuery(entityMeta.getEntityClazz());
            }

            Set<String> filterNames = getFilterNameSet(ciRequest);

            Root root = query.from(entityMeta.getEntityClazz());

            Map<String, Expression> selectionMap = new LinkedHashMap<>();
            entityMeta.getAttrs().forEach(x -> {

                AdmCiTypeAttr attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(entityMeta.getCiTypeId(), x);
                if (attr == null) {
                    return;
                }

                if (filterNames.contains(x) && InputType.MultRef.getCode().equals(attr.getInputType())) {
                    Join join = root.join(x);
                    selectionMap.put(x, join.get("guid"));
                } else if (filterNames.contains(x) && InputType.MultSelDroplist.getCode().equals(attr.getInputType())) {
                    Join join = root.join(x);
                    selectionMap.put(x, join.get("to_code"));
                } else {
                    selectionMap.put(x, root.get(x));
                }
            });

            if (isSelRowCount) {
                query.select(cb.count(root));
            } else {
                // query.multiselect(selectionMap.values().toArray(new Expression[0]));
                query.select(root);
            }

            Map<String, Class<?>> fieldTypeMap = new HashMap<>();
            entityMeta.getAllFieldNodes(false).forEach(x -> {
                fieldTypeMap.put(x.getName(), x.getType());
            });

            if (ciRequest != null) {
                List<Predicate> predicates = Lists.newLinkedList();
                if (!ciRequest.getDialect().getShowCiHistory()) {
                    predicates.add(cb.equal(selectionMap.get(CmdbConstants.DEFAULT_FIELD_GUID), selectionMap.get(CmdbConstants.DEFAULT_FIELD_ROOT_GUID)));
                }

                Predicate accessControlPredicate = buildAccessControlPredicate(entityMeta.getCiTypeId(), cb, selectionMap, false);

                JpaQueryUtils.applyFilter(cb, query, ciRequest.getFilters(), selectionMap, fieldTypeMap, FilterRelationship.fromCode(ciRequest.getFilterRs()), predicates, accessControlPredicate);

                if (!isSelRowCount) {
                    JpaQueryUtils.applySorting(ciRequest.getSorting(), cb, query, selectionMap);
                    if(ciRequest.getGroupBys()!=null && ciRequest.getGroupBys().size()>0) {
                        JpaQueryUtils.applyGroupBy(ciRequest.getGroupBys(),query,selectionMap);
                    }
                    if(ciRequest.getAggregationFuction()!=null &&ciRequest.getAggregationFuction().size()>0) {
                        JpaQueryUtils.applyAggregation(ciRequest.getAggregationFuction(), cb, query, selectionMap, root);
                    }
                }
            }
            
            TypedQuery<?> typedQuery = entityManager.createQuery(query);

            if (ciRequest != null && !isSelRowCount) {
                JpaQueryUtils.applyPaging(ciRequest.isPaging(), ciRequest.getPageable(), typedQuery);
            }

            List<Object> results = (List<Object>) typedQuery.getResultList();
            return results;
        } finally {
            priEntityManager.close();
        }

    }

    private Set<String> getFilterNameSet(QueryRequest ciRequest) {
        Set<String> filterNames = new HashSet<>();
        if (ciRequest.getFilters() != null) {
            for (Filter filter : ciRequest.getFilters()) {
                filterNames.add(filter.getName());
            }
        }
        return filterNames;
    }

    private Predicate buildAccessControlPredicate(int ciTypeId, CriteriaBuilder criteriaBuilder, Map<String, Expression> attributeMap, boolean isIntQuery) {
        if (authorizationService.isCiTypePermitted(ciTypeId, ACTION_ENQUIRY)) {
            return criteriaBuilder.conjunction();
        }
        Predicate[] rulePredicates;
        List<Map<String, Set<?>>> permittedData = authorizationService.getPermittedData(ciTypeId, ACTION_ENQUIRY);
        if (isEmpty(permittedData)) {
            rulePredicates = new Predicate[0];
        } else {
            rulePredicates = permittedData.stream().map(permittedDataByRule -> {
                Predicate[] inPredicates = permittedDataByRule.entrySet().stream().map(permittedDataByCondition -> {
                    String columnName = permittedDataByCondition.getKey();
                    Set<?> values = permittedDataByCondition.getValue();
                    Expression expression;
                    if (isIntQuery) {
                        String keyName = String.format(ACCESS_CONTROL_ATTRIBUTE_FORMAT, ciTypeId, columnName);
                        expression = attributeMap.get(keyName);
                    } else {
                        expression = attributeMap.get(columnName);
                    }
                    if (expression == null) {
                        throw new CmdbException(String.format("Attribute[%s] not found.", columnName));
                    }
                    CriteriaBuilder.In inPredicate = criteriaBuilder.in(expression);
                    values.forEach(inPredicate::value);
                    return inPredicate;
                }).toArray(Predicate[]::new);
                return criteriaBuilder.and(inPredicates);
            }).toArray(Predicate[]::new);
        }
        return criteriaBuilder.or(rulePredicates);
    }

    private Map<String, Object> enrichCiObject(DynamicEntityMeta entityMeta, Map<String, Object> ciObjMap, EntityManager entityManager) {
        Map<String, Object> ciMap = new HashMap<>();
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByCiTypeId(entityMeta.getCiTypeId());

        Map<Integer, AdmCiTypeAttr> attrMap = new HashMap<>();
        for (AdmCiTypeAttr attr : attrs) {
            attrMap.put(attr.getIdAdmCiTypeAttr(), attr);
        }

        for (Map.Entry kv : ciObjMap.entrySet()) {
            String fieldName = kv.getKey().toString();
            Object value = kv.getValue();
            FieldNode fieldNode = entityMeta.getFieldNode(fieldName);
            if (fieldNode != null) {
                int attrId = fieldNode.getAttrId();
                if (!attrMap.containsKey(attrId)) {
                    continue;
                }
                AdmCiTypeAttr attr = attrMap.get(attrId);
                // Don't return the field if editIsHidden is enable
                if (CiStatus.Decommissioned.getCode().equals(attr.getStatus()) || (attr.getEditIsHiden() != null && attr.getEditIsHiden() != 0)) {
                    continue;
                }
                
                if(!fieldNode.isJoinNode()) {
                    value = convertFieldValue(fieldName, value, attrMap.get(attrId));
                    ciMap.put(fieldName, value);
                } else if (fieldNode.isJoinNode() && DynamicEntityType.MultiSelection.equals(fieldNode.getEntityType())) {
                    Set codeImSet = (Set) value;
                    List codeImList = Lists.newLinkedList(codeImSet);
                    codeImList.sort((a, b) -> {
                        return (Integer) new BeanMap(a).get("seq_no") - (Integer) new BeanMap(b).get("seq_no");
                    });
    
                    List enrichMulSels = Lists.newLinkedList();
                    for (Object im : codeImList) {
                        BeanMap imBeanMap = new BeanMap(im);
                        Integer codeId = (Integer) imBeanMap.get("to_code");
                        try {
                            CatCodeDto codeDto = basekeyInfoService.getCode(codeId);
                            enrichMulSels.add(codeDto);
                        } catch (InvalidArgumentException ex) {
                            logger.warn("Failed to get cat code for codeId [{}].", codeId);
                        }
                    }
                    ciMap.put(fieldName, enrichMulSels);
                } else if (fieldNode.isJoinNode() && DynamicEntityType.MultiReference.equals(fieldNode.getEntityType()) && Strings.isNullOrEmpty(fieldNode.getMappedBy())) {
                    Set<Object> referCis = (Set<Object>) value;
                    attr = attrMap.get(attrId);
                    if(InputType.MultRef.getCode().equals(attr.getInputType())) {
                        referCis = fetchCiDomainObjForMultRef(attr, referCis);
                    }
                    
                    DynamicEntityMeta multRefMeta = multRefMetaMap.get(attrId);
                    Map<String, Integer> sortMap = JpaQueryUtils.getSortedMapForMultiRef(entityManager, attr, multRefMeta);
    
                    List ciList = getSortedMultRefList(referCis, sortMap);
    
                    ciMap.put(fieldName, ciList);
                }
            } else {
                logger.warn("Failed to get field node for field name [{}] in dynamic entity [{}].", fieldName, entityMeta.getEntityClazz().toString());
            }
        }
        return ciMap;
    }

    private Set<Object> fetchCiDomainObjForMultRef(AdmCiTypeAttr attr, Set<Object> referCis) {
        Integer refCiTypeId = attr.getReferenceId();
        DynamicEntityMeta refEntityMeta = dynamicEntityMetaMap.get(refCiTypeId);
        Class refEntityClzz = refEntityMeta.getEntityClazz();
        if(refEntityClzz != null) {
            Set<Object> realReferCis = new HashSet<Object>();
            referCis.forEach(elem -> {
                if(elem instanceof HibernateProxy) {
                    Object domainObj = ((HibernateProxy) elem).getHibernateLazyInitializer().getImplementation();
                    realReferCis.add(domainObj);
                }else {
                    realReferCis.add(elem);
                }
            });
            referCis = realReferCis;
        }
        return referCis;
    }

    private List getSortedMultRefList(Set<Object> referCis, Map<String, Integer> sortMap) {
        List ciList = Lists.newLinkedList();
        for (Object ci : referCis) {
            ciList.add(ci);
        }
        ciList.sort((ci1, ci2) -> {
            String refGuid1 = (String) new BeanMap(ci1).get("guid");
            String refGuid2 = (String) new BeanMap(ci2).get("guid");

            return sortMap.get(refGuid1) - sortMap.get(refGuid2);
        });
        return ciList;
    }

    private Object convertFieldValue(String fieldName, Object value, AdmCiTypeAttr attr) {
        if (attr == null)
            return value;

        InputType inputType = InputType.fromCode(attr.getInputType());
        if (InputType.Droplist.equals(inputType) ) {
            value = convertCodeValue(fieldName, value);
        } else if (InputType.Reference.equals(inputType)) {
            int ciTypeId = attr.getReferenceId();
            if (value != null) {
                String guid = value.toString();
                if (!StringUtils.isBlank(guid)) {
                    Object childCi = null;
                    try {
                        childCi = getCacheableCi(ciTypeId, guid);
                    } catch (Exception ex) {
                        throw new ServiceException(String.format("Failed to get ci data [ciType:%d, guid:%s]", ciTypeId, guid), ex);
                    }
                    value = childCi;
                }
            }
        } else if (InputType.Date.equals(inputType) || value instanceof Timestamp) {
            if (value == null) {
                value = "";
            } else if (value instanceof Timestamp) {
                SimpleDateFormat dateFmt = new SimpleDateFormat(CmdbConstants.DATE_FORMAT_YYYY_MM_DD_HH_MM_SS);
                dateFmt.setTimeZone(TimeZone.getTimeZone("UTC"));
                String dateTxt = dateFmt.format((Timestamp) value);
                value = dateTxt;
            }
        }else if(InputType.MultSelDroplist.equals(inputType)) {
        	String guid = String.valueOf(value);
            PriorityEntityManager priEntityManager = getEntityManager();
            EntityManager entityManager = priEntityManager.getEntityManager();
            List codeIds = Lists.newLinkedList();

            try {
            	CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            	Class joinEntityClzz = multSelectMetaMap.get(attr.getIdAdmCiTypeAttr()).getEntityClazz();
            	CriteriaQuery query = cb.createQuery(joinEntityClzz);
            	Root root = query.from(joinEntityClzz);
            	query.select(root);
            	query.where(cb.equal(root.get("from_guid"), guid));
            	TypedQuery typedQuery = entityManager.createQuery(query);
            	List results = typedQuery.getResultList();
            	if(results != null && results.size()>0) {
            		for(Object record:results) {
            			BeanMap map = new BeanMap(record);
            			Integer codeId = (Integer)(map.get("to_code"));
            			Object code = convertCodeValue(fieldName, codeId);
            			codeIds.add(code);
            		}
            	}
            	return codeIds;
            }finally {
            	priEntityManager.close();
            }
        }else if(InputType.MultRef.equals(inputType)) {
        	String guid = String.valueOf(value);
            PriorityEntityManager priEntityManager = getEntityManager();
            EntityManager entityManager = priEntityManager.getEntityManager();
            List ciObjs = Lists.newLinkedList();

            try {
            	CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            	Integer toCiTypeId = attr.getReferenceId();
            	Class joinEntityClzz = multRefMetaMap.get(attr.getIdAdmCiTypeAttr()).getEntityClazz();
            	CriteriaQuery query = cb.createQuery(joinEntityClzz);
            	Root root = query.from(joinEntityClzz);
            	query.select(root);
            	query.where(cb.equal(root.get("from_guid"), guid));
            	TypedQuery typedQuery = entityManager.createQuery(query);
            	List results = typedQuery.getResultList();
            	if(results != null && results.size()>0) {
            		for(Object record:results) {
            			BeanMap map = new BeanMap(record);
            			String to_guid = (String)(map.get("to_guid"));
            			Object toCiObj = getCi(toCiTypeId, to_guid);
            			ciObjs.add(toCiObj);
            		}
            	}
            	return ciObjs;
            }finally {
            	priEntityManager.close();
            }
        	
        }
        /*
         * else if (value == null) { value = ""; }
         */
        return value;
    }

	private Object convertCodeValue(String fieldName, Object value) {
		Integer codeId = null;
		try {
		    codeId = Integer.valueOf(String.valueOf(value));
		} catch (NumberFormatException ex) {
		    logger.warn("Failed to get codeId from value:[{}], field:[{}]", value, fieldName);
		}
		if (codeId != null) {
		    CatCodeDto codeDto = null;
		    try {
		        codeDto = basekeyInfoService.getCode(codeId);
		    } catch (InvalidArgumentException ex) {
		        logger.warn("Failed to get cat code for codeId [{}].", codeId);
		    }
		    value = codeDto;
		}
		return value;
	}

    @Override
    public List<DynamicEntityHolder> filterBy(int ciType, List<FilterInfo> filterInfos, Pageable pageable, Sorting sorting) {
        return null;
    }

    private void validateCiData(int ciTypeId, Map<String, ?> ciData, boolean isUpdateReq) {
        AdmCiType ciType = ciTypeRepository.getOne(ciTypeId);
        // check attributes to be added, will throw exception if it dose not exist in CI
        // meta
        List<AdmCiTypeAttr> attrs = ciType.getAdmCiTypeAttrs();
        Map<String, AdmCiTypeAttr> atrMap = convertAttrMap(attrs);

        Iterator<String> fieldIter = ciData.keySet().iterator();
        while (fieldIter.hasNext()) {
            String fieldName = fieldIter.next();
            AdmCiTypeAttr attr = atrMap.get(fieldName);
            if (attr == null) {
                throw new InvalidArgumentException(String.format("Invalid attribute name (%s) for ciTypeId: %d", fieldName, ciTypeId));
            }
            // system field should not be updated, remove them
            else if ((CmdbConstants.IS_AUTO_YES.equals(attr.getIsAuto()) || CmdbConstants.IS_EDITABLE_NO.equals(attr.getEditIsEditable())) && !CmdbConstants.GUID.equals(fieldName)) {
                fieldIter.remove();
                logger.info("Is auto field or not editable [{}] has been removed.", fieldName);
            }
        }

        // check if all not null field has value
        /*
         * attrs.forEach(x -> { if (CmdbConstants.IS_SYSTEM_NO.equals(x.getIsSystem())
         * && x.getEditIsNull() != null && x.getEditIsNull() == 0 &&
         * ciData.get(x.getPropertyName()) == null) { if(isUpdateReq == false) { throw
         * new InvalidArgumentException(String.format("Attribute [%s] can not be null.",
         * x.getPropertyName())); } else if(ciData.containsKey(x.getPropertyName())) {
         * //update requst contain no allow null field throw new
         * InvalidArgumentException(String.format("Attribute [%s] can not be null.",
         * x.getPropertyName())); } } });
         */
    }

    private Map<String, AdmCiTypeAttr> convertAttrMap(List<AdmCiTypeAttr> attrs) {
        Map<String, AdmCiTypeAttr> attrMap = new HashMap<>();
        attrs.forEach(x -> {
            // attrMap.put(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL,
            // x.getPropertyName()), x);
            attrMap.put(x.getPropertyName(), x);
        });
        return attrMap;
    }

    private void validateCiType(int ciTypeId) {
        Optional<AdmCiType> optCiType = ciTypeRepository.findById(ciTypeId);
        if (!optCiType.isPresent()) {
            throw new InvalidArgumentException("Can not find out CiType with given argument.", "ciTypeId", ciTypeId);
        }

        AdmCiType ciType = optCiType.get();
        CiStatus status = CiStatus.fromCode(ciType.getStatus());
        if (!status.supportCiDataOperation()) {
            throw new InvalidArgumentException(String.format("The Ci type [%d] status is %s.", ciTypeId, status.getCode()));
        }
    }

    @Override
    public Map<String, Object> getCi(int ciTypeId, String guid) {
        validateCiType(ciTypeId);
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        // Object entityBean = entityManager.find(entityMeta.getEntityClazz(), guid);
        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            Object entityBean = JpaQueryUtils.findEager(entityManager, entityMeta.getEntityClazz(), guid);
            if (entityBean == null) {
                throw new InvalidArgumentException(String.format("Can not find CI (ciTypeId:%d, guid:%s)", ciTypeId, guid));
            }
            Map<String, Object> resultMap = Maps.newHashMap();
            BeanMap ciObjMap = new BeanMap(entityBean);
            for (Map.Entry kv : ciObjMap.entrySet()) {
                String fieldName = kv.getKey().toString();
                FieldNode fieldNode = entityMeta.getFieldNode(fieldName);
                Object value = kv.getValue();
                if (fieldNode != null) {
                    if (!fieldNode.isJoinNode()) {
                        resultMap.put(fieldName, value);
                    }
                }
            }
            if (!authorizationService.isCiDataPermitted(ciTypeId, entityBean, ACTION_ENQUIRY)) {
                resultMap = CollectionUtils.retainsEntries(resultMap, Sets.newHashSet("guid", "key_name"));
                logger.info("Access denied - {}, returns guid and key_name only.", resultMap);
            }
            return resultMap;
        } finally {
            priEntityManager.close();
        }
    }
    
    @Cacheable("ciServiceImpl-getCacheableCi")
    private Map<String, Object> getCacheableCi(int ciTypeId, String guid) {
        return getCi(ciTypeId,guid);
    }

    @OperationLogPointcut(operation = Removal, objectClass = CiData.class, ciTypeIdArgumentIndex = 0, ciGuidArgumentIndex = 1)
    @Override
    public void deleteCi(int ciTypeId, String guid) {
        validateCiType(ciTypeId);
        validateDynamicEntityManager();
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            Object entityBean = validateCi(ciTypeId, guid, entityMeta, entityManager, ACTION_REMOVAL);
            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                entityManager.remove(entityBean);
                entityManager.flush();
                transaction.commit();
            } catch (Exception ex) {
                transaction.rollback();
                throw new ServiceException(ex.toString());
            }
        } finally {
            priEntityManager.close();
        }
    }

    private Object validateCi(int ciTypeId, String guid, DynamicEntityMeta entityMeta, EntityManager entityManager, String action) {
        Object entityBean = entityManager.find(entityMeta.getEntityClazz(), guid);
        if (entityBean == null) {
            throw new InvalidArgumentException(String.format("Can not find CI (ciTypeId:%d, guid:%s)", ciTypeId, guid));
        }
        if (action != null) {
            authorizationService.authorizeCiData(ciTypeId, entityBean, action);
        }
        return entityBean;
    }

    @OperationLogPointcut(operation = Modification, objectClass = CiData.class, ciTypeIdArgumentIndex = 0, ciGuidArgumentIndex = 1, ciNameArgumentIndex = 2)
    @Override
    public void update(int ciTypeId, String guid, Map<String, Object> ciData) {
        validateCiType(ciTypeId);
        validateCiData(ciTypeId, ciData, true);
        validateDynamicEntityManager();
        authorizationService.authorizeCiData(ciTypeId, ciData, ACTION_MODIFICATION);

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                doUpdate(entityManager, ciTypeId, ciData, true);
                entityManager.flush();
                transaction.commit();
            } catch (CmdbAccessDeniedException accEx) {
                transaction.rollback();
                throw accEx;
            } catch (Exception ex) {
                transaction.rollback();
                throw new ServiceException(ex.toString());
            }
        } finally {
            priEntityManager.close();
        }

    }

    @Override
    public void update(EntityManager entityManager, int ciTypeId, String guid, Map<String, Object> ciData) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        Object entityBean = validateCi(ciTypeId, guid, entityMeta, entityManager, null);

        DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta, entityBean);
        entityHolder.update(ciData, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);
        entityManager.merge(entityHolder.getEntityObj());
        entityManager.flush();
    }

    @OperationLogPointcut(operation = Modification, objectClass = CiData.class, ciTypeIdArgumentIndex = 0)
    @Override
    public List<Map<String, Object>> update(int ciTypeId, List<Map<String, Object>> cis) {
        if (logger.isDebugEnabled()) {
            logger.debug("CIs update request, ciTypeId:{}, query request:{}", ciTypeId, JsonUtil.toJsonString(cis));
        }

        validateDynamicEntityManager();
        List<Map<String, Object>> rtnCis = new LinkedList<>();
        List<ExceptionHolder> exceptionHolders = new LinkedList<>();

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                for (Map<String, Object> ci : cis) {
                    String callbackId = null;
                    if (ci.get(CALLBACK_ID) != null) {
                        callbackId = ci.get(CALLBACK_ID).toString();
                    }

                    try {
                        ci.remove(CALLBACK_ID);

                        validateCiType(ciTypeId);
                        validateUpdateCiData(ciTypeId, ci);
                        validateCiData(ciTypeId, ci, true);

                        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

                        Map<String, Object> updatedDomainMap = doUpdate(entityManager, ciTypeId, ci, true);

                        Map<String, Object> enhacedMap = enrichCiObject(entityMeta, updatedDomainMap, entityManager);

                        enhacedMap.put(CALLBACK_ID, callbackId);
                        rtnCis.add(enhacedMap);
                    } catch (Exception e) {
                        String errorMessage = String.format("Fail to update ci data ciTypeId [%s], error [%s]", ciTypeId, ExceptionHolder.extractExceptionMessage(e));
                        logger.warn(errorMessage, e);
                        ci.put(CALLBACK_ID, callbackId);
                        exceptionHolders.add(new ExceptionHolder(callbackId, ci, errorMessage, e));
                    }
                }

                if (exceptionHolders.size() == 0) {
                    transaction.commit();
                } else {
                    transaction.rollback();
                    throw new BatchChangeException(String.format("Fail to update [%d] records, detail error in the data block", exceptionHolders.size()), exceptionHolders);
                }
            } catch (Exception exc) {
                if (exc instanceof BatchChangeException) {
                    throw exc;
                } else {
                    transaction.rollback();
                    throw new ServiceException("Failed to update ci data.", exc);
                }
            }
        } finally {
            priEntityManager.close();
        }

        if (logger.isDebugEnabled()) {
            logger.debug("Return ci response:{}", JsonUtil.toJsonString(rtnCis));
        }

        return rtnCis;
    }

    private Map<String, Object> doUpdate(EntityManager entityManager, int ciTypeId, Map<String, Object> ci, boolean enableStateTransition) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        String guid = ci.get(GUID).toString();
        Object entityBean = validateCi(ciTypeId, guid, entityMeta, entityManager, ACTION_MODIFICATION);
        DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta, entityBean);

        ciDataInterceptorService.preUpdate(entityHolder, ci);
        Map<String, Object> convertedCi = MultiValueFeildOperationUtils.convertMultiValueFieldsForCICreation(entityManager, ciTypeId, ci, (String) ci.get(CmdbConstants.DEFAULT_FIELD_GUID), ciTypeAttrRepository, this);
        Map<String, Object> updatedMap = null;
        if (onlyIncludeRefreshableFields(ciTypeId, convertedCi.keySet()) || !enableStateTransition) {
            entityHolder.update(convertedCi, CmdbThreadLocal.getIntance().getCurrentUser(), entityManager);
            entityManager.merge(entityHolder.getEntityObj());
        } else {
            updatedMap = stateTransEngine.process(entityManager, ciTypeId, guid, StateOperation.Update.getCode(), convertedCi, entityHolder);
        }

        ciDataInterceptorService.postUpdate(entityHolder, entityManager, ci);
        updatedMap = ClassUtils.convertBeanToMap(entityHolder.getEntityObj(), entityHolder.getEntityMeta(), false);
        return updatedMap;
    }

    private boolean onlyIncludeRefreshableFields(int ciTypeId, Set<String> fields) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        List<Integer> attrIds = Lists.transform(Lists.newLinkedList(fields), (field) -> {
            int attrId = entityMeta.getFieldNode(field).getAttrId();
            return attrId;
        });
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByIdAdmCiTypeAttrIn(attrIds);
        for (AdmCiTypeAttr attr : attrs) {
            if (CmdbConstants.DEFAULT_FIELD_GUID.equals(attr.getPropertyName())) {
                continue;
            }
            if (attr.getIsRefreshable() == 0) {
                return false;
            }
        }
        return true;
    }

    private void validateUpdateCiData(int ciTypeId, Map<String, Object> ci) {
        if (ci.get(GUID) == null) {
            throw new InvalidArgumentException(String.format("Required field 'guid' is missing for updating ciTypeId [%s]", ciTypeId));
        }
    }

    @OperationLogPointcut(operation = Creation, objectClass = CiData.class, ciTypeIdArgumentIndex = 0, ciNameArgumentIndex = 1)
    @Override
    public String create(int ciTypeId, Map<String, Object> ciData) {

        validateCiType(ciTypeId);
        validateCiData(ciTypeId, ciData, false);
        validateDynamicEntityManager();

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                DynamicEntityHolder entityHolder = doCreate(entityManager, ciTypeId, null, null, ciData, true);
                entityManager.flush();
                transaction.commit();
                return (String) entityHolder.get(CmdbConstants.DEFAULT_FIELD_GUID);
            } catch (CmdbException ex) {
                transaction.rollback();
                throw ex;
            } catch (Exception ex) {
                transaction.rollback();
                throw new ServiceException("Failed to create ci.", ex);
            }
        } finally {
            priEntityManager.close();
        }
    }

    @OperationLogPointcut(operation = Creation, objectClass = CiData.class, ciTypeIdArgumentIndex = 0)
    @Override
    public List<Map<String, Object>> create(int ciTypeId, List<Map<String, Object>> cis) {
        List<Map<String, Object>> rtnCis = new LinkedList<Map<String, Object>>();
        // List<Map<String, Object>> failedRtnCis = new LinkedList<Map<String,
        // Object>>();
        List<ExceptionHolder> exceptionHolders = new LinkedList<>();
        validateDynamicEntityManager();

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                for (Map<String, Object> ci : cis) {
                    String callbackId = null;
                    if (ci.get(CALLBACK_ID) != null) {
                        callbackId = ci.get(CALLBACK_ID).toString();
                    }

                    try {
                        ci.remove(CALLBACK_ID);

                        validateCiType(ciTypeId);
                        // validateCiData(ciTypeId, ci, false);
                        // TODO: get operate user

                        DynamicEntityHolder entityHolder = doCreate(entityManager, ciTypeId, null, null, ci, true);

                        String guid = (String) entityHolder.get(CmdbConstants.DEFAULT_FIELD_GUID);

                        ci.put(CALLBACK_ID, callbackId);
                        ci.put("guid", guid);
                        rtnCis.add(ci);
                    } catch (Exception e) {
                        String errorMessage = String.format("Fail to create ci data ciTypeId [%s], error [%s]", ciTypeId, ExceptionHolder.extractExceptionMessage(e));
                        logger.warn(errorMessage, e);
                        ci.put(CALLBACK_ID, callbackId);
                        // ci.put("errorMessage", errorMessage);
                        exceptionHolders.add(new ExceptionHolder(callbackId, ci, errorMessage, e));
                    }
                }
                if (exceptionHolders.size() == 0) {
                    transaction.commit();
                } else {
                    transaction.rollback();
                    throw new BatchChangeException(String.format("Fail to create [%s] records, detail error in the data block", exceptionHolders.size()), exceptionHolders);
                }
            } catch (Exception exc) {
                if (exc instanceof BatchChangeException) {
                    throw exc;
                } else {
                    transaction.rollback();
                    throw new ServiceException("Exception happen for Ci creation.", exc);
                }
            }

            return rtnCis;
        } finally {
            priEntityManager.close();
        }
    }

    public Object getCiBeanObject(EntityManager entityManager, int ciTypeId, String guid) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        Object entityBean = entityManager.find(entityMeta.getEntityClazz(), guid);
        return entityBean;
    }

    private DynamicEntityHolder doCreate(EntityManager entityManager, int ciTypeId, String rGuid, Integer state, Map<String, Object> ci, boolean enableStateTransition) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        if (entityMeta == null) {
            throw new InvalidArgumentException(String.format("CiType [%d] is not valid in dynamic entity meta.", ciTypeId));
        }

        String nextGuid = sequenceService.getNextGuid(entityMeta.getTableName(), entityMeta.getCiTypeId());

        Map<String, Object> convertedCi = MultiValueFeildOperationUtils.convertMultiValueFieldsForCICreation(entityManager, ciTypeId, ci, nextGuid, this.ciTypeAttrRepository, this);

        DynamicEntityHolder entityHolder = DynamicEntityHolder.createDynamicEntityBean(entityMeta, convertedCi);

        ciDataInterceptorService.preCreate(entityHolder, convertedCi);
        entityHolder.fillAutoFieldsWithDefaultValue(nextGuid, rGuid, state, CmdbThreadLocal.getIntance().getCurrentUser());
        if (enableStateTransition) {
            stateTransEngine.process(entityManager, entityMeta.getCiTypeId(), null, StateOperation.Insert.getCode(), entityHolder.getEntityBeanMap(), entityHolder);
        }
        entityManager.persist(entityHolder.getEntityObj());
        // entityManager.flush();
        ciDataInterceptorService.postCreate(entityHolder, ci, multRefMetaMap, entityManager);
        return entityHolder;
    }
    @OperationLogPointcut(operation = Removal, objectClass = CiData.class, ciTypeIdArgumentIndex = 0)
    @Override
    public void delete(int ciTypeId, List<String> ids) {
        List<String> rtnIds = new LinkedList<String>();
        List<ExceptionHolder> exceptionHolders = new LinkedList<ExceptionHolder>();

        validateDynamicEntityManager();
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                for (String guid : ids) {
                    try {
                        validateCiType(ciTypeId);

                        doDelete(entityManager, ciTypeId, guid, true);
                        rtnIds.add(guid);
                    } catch (Exception e) {
                        String errorMessage = String.format("Fail to delete ci data ciTypeId [%s] for guid [%s], error [%s]", ciTypeId, guid, ExceptionHolder.extractExceptionMessage(e));
                        logger.warn(errorMessage, e);
                        exceptionHolders.add(new ExceptionHolder(null, guid, errorMessage, e));
                    }
                }
                if (exceptionHolders.size() == 0) {
                    transaction.commit();
                } else {
                    transaction.rollback();
                    throw new BatchChangeException(String.format("Fail to delete [%d] records, detail error in the data block", exceptionHolders.size()), exceptionHolders);
                }
            } catch (Exception ex) {
                if (ex instanceof BatchChangeException) {
                    throw ex;
                } else {
                    transaction.rollback();
                    throw new ServiceException("Failed to delete ci data.", ex);
                }
            }
        } finally {
            priEntityManager.close();
        }
    }

    public void doDelete(EntityManager entityManager, int ciTypeId, String guid, boolean enableStateTransition) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        Object entityBean = validateCi(ciTypeId, guid, entityMeta, entityManager, ACTION_REMOVAL);
        DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta, entityBean);
        if (enableStateTransition) {
            ciDataInterceptorService.preDelete(ciTypeId, guid, true, entityMeta);
            this.stateTransEngine.process(entityManager, ciTypeId, guid, StateOperation.Delete.getCode(), null, entityHolder);
        } else {
            ciDataInterceptorService.preDelete(ciTypeId, guid, false, entityMeta);
            entityManager.remove(entityBean);
        }
        ciDataInterceptorService.postDelete(entityHolder, entityManager, ciTypeId, guid, entityMeta);
    }

    @Override
    public QueryResponse integrateQuery(int intQueryId, QueryRequest intQueryReq) {
        if (logger.isDebugEnabled()) {
            logger.debug("Integate query request, intQuerId:{}, query request:{}", intQueryId, JsonUtil.toJsonString(intQueryReq));
        }

        List<FieldInfo> selectedFields = new LinkedList<>();
        List<Filter> srcFilters = null;
        try {
            srcFilters = CollectionUtils.clone(intQueryReq.getFilters(), Lists.newLinkedList());
        } catch (CloneNotSupportedException e) {
            throw new ServiceException("Failed to clone int query filters.", e);
        }

        IntegrationQueryDto intQueryDto = intQueryService.getIntegrationQuery(intQueryId);
        if (logger.isDebugEnabled()) {
            logger.debug("Integration query [{}] integrate query Dto:{}, queryReq:{}", intQueryId, JsonUtil.toJsonString(intQueryDto), JsonUtil.toJsonString(intQueryReq));
        }

        List resultList = doIntegrateQuery(intQueryDto, intQueryReq, true, selectedFields);
        int totalCount = convertResultToInteger(resultList);

        intQueryReq.setFilters(srcFilters);
        resultList = doIntegrateQuery(intQueryDto, intQueryReq, false, selectedFields);

        List<Expression> selections = new LinkedList<>();
        selectedFields.forEach(x -> {
        	if(!selections.contains(x.getExpression())) {
        		selections.add(x.getExpression());
        	}
        });

        List<Map<String, Object>> results = new LinkedList<>();
        // muti columns result
        if (selections.size() > 1) {
            List<Object[]> rows = resultList;
            for (int i = 0; i < rows.size(); i++) {
                Object[] obj = rows.get(i);
                results.add(convertResponse(selections, obj, selectedFields));
            }
        } else {
            List<Object> rows = resultList;
            if (rows.size() > 0) {
                for (Object val : rows) {
                    Object[] singleVal = new Object[] { val };
                    results.add(convertResponse(selections, singleVal, selectedFields));
                }
            } else {
                results.add(convertResponse(selections, rows.toArray(), selectedFields));
            }
            /*
             * rows.forEach(x -> { Map<String,Object> rowMap = new HashMap<>();
             * rowMap.put(selections.get(0).getAlias(), x); results.add(rowMap); });
             */
        }

        QueryResponse response = new QueryResponse(null, results);
        setupPageInfo(intQueryReq, totalCount, response);

        if (logger.isDebugEnabled()) {
            logger.debug("Return integrate response:{}", JsonUtil.toJsonString(response));
        }
        return response;
    }

    @Override
    public QueryResponse integrateQuery(String queryName, QueryRequest intQueryReq) {
        List<AdmIntegrateTemplate> intQueryTempls = intTempRepository.findAllByName(queryName);
        if(intQueryTempls!=null && intQueryTempls.size()==0){
            throw new InvalidArgumentException(String.format("Can not find out AdmIntegrateTemplate by given query name [%s].", queryName));
        }else{
            return  integrateQuery(intQueryTempls.get(0).getIdAdmIntegrateTemplate(),intQueryReq);
        }
    }

    private void setupPageInfo(QueryRequest intQueryReq, int totalCount, QueryResponse headerResponse) {
        if (intQueryReq != null && intQueryReq.getPageable() != null) {
            headerResponse.setPageInfo(new PageInfo(totalCount, intQueryReq.getPageable().getStartIndex(), intQueryReq.getPageable().getPageSize()));
        } else {
            headerResponse.setPageInfo(new PageInfo(totalCount, 0, totalCount));
        }
    }

    private int convertResultToInteger(List rawResults) {
        String strVal = rawResults.get(0).toString();
        return Integer.valueOf(strVal);
    }

    private List doIntegrateQuery(IntegrationQueryDto intQueryDto, QueryRequest intQueryReq, boolean isSelRowCount, List<FieldInfo> selectedFields) {

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();

        try {
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaQuery query = cb.createQuery();

            Map<String, FieldInfo> selFieldMap = new LinkedHashMap<>();

            boolean enableBiz = false;

            // TODO, enable Bizkey & status logic should be removed
            enableBiz = checkBizEnable(intQueryReq);
            logger.info("enable biz:{}", enableBiz);
            buildIntQuery(null, null, intQueryDto, query, selFieldMap, enableBiz, null);
            validateIntQueryFilter(intQueryReq, selFieldMap, enableBiz);
            List<Expression> selections = new LinkedList<>();

            if (isSelRowCount) {
                Expression root = selFieldMap.get("root").getExpression();
                query.select(cb.count(root));
            } else {
                selFieldMap.remove("root");
                for (Map.Entry<String, FieldInfo> kv : selFieldMap.entrySet()) {
                    if (isRequestField(intQueryReq, kv)) {
                        if (enableBiz) {
                            if (kv.getKey().endsWith(".biz_key") || kv.getKey().endsWith(".state")) {
                                continue;
                            }
                        }
                        if (kv.getKey().startsWith(ACCESS_CONTROL_ATTRIBUTE_PREFIX)) {
                            continue;
                        }
                        if (kv.getKey().endsWith(".guid") || kv.getKey().endsWith(".r_guid")) {
                            continue;
                        }
                        selectedFields.add(kv.getValue());
                        if (!selections.contains(kv.getValue().getExpression())) {
                            selections.add(kv.getValue().getExpression());
                        }
                    }
                }
                query.multiselect(selections);
            }

            Map<String, Expression> selectionMap = new HashMap<>();
            Map<String, Class<?>> fieldTypeMap = new HashMap<>();
            selFieldMap.forEach((k, v) -> {
                fieldTypeMap.put(k, v.getType());
                selectionMap.put(k, v.getExpression());
            });

            if (!isSelRowCount && intQueryReq.getSorting() != null) {
                JpaQueryUtils.applySorting(intQueryReq.getSorting(), cb, query, selectionMap);
            }

            // TODO: enable biz logic should be removed
            if (enableBiz) {
                processBizFilters(intQueryReq, selectionMap);
            }

            List<Predicate> predicates = buildHistoryDataControlPredicate(intQueryReq, cb, selectionMap);

            Predicate accessControlPredicate = buildAccessControlPredicate(cb, selFieldMap, selectionMap);

            JpaQueryUtils.applyFilter(cb, query, intQueryReq.getFilters(), selectionMap, fieldTypeMap, FilterRelationship.fromCode(intQueryReq.getFilterRs()), predicates, accessControlPredicate);

            TypedQuery typedQuery = entityManager.createQuery(query);
            if (!isSelRowCount && intQueryReq.isPaging()) {
                JpaQueryUtils.applyPaging(intQueryReq.isPaging(), intQueryReq.getPageable(), typedQuery);
            }

            List resultList = typedQuery.getResultList();

            return resultList;
        } finally {
            priEntityManager.close();
        }
    }

    private boolean isRequestField(QueryRequest intQueryReq, Map.Entry<String, FieldInfo> kv) {
        return intQueryReq.getResultColumns() == null || intQueryReq.getResultColumns().isEmpty() || intQueryReq.getResultColumns().contains(kv.getKey());
    }

    private List<Predicate> buildHistoryDataControlPredicate(QueryRequest intQueryReq, CriteriaBuilder cb, Map<String, Expression> selectionMap) {
        List<Predicate> predicates = Lists.newLinkedList();
        if (!intQueryReq.getDialect().getShowCiHistory()) {
            Map<String, Map<String, Expression>> guidRguidPair = new HashMap<>();
            for (Map.Entry<String, Expression> kv : selectionMap.entrySet()) {
                extractGuidKvPair(guidRguidPair, kv, ".guid");
                extractGuidKvPair(guidRguidPair, kv, ".r_guid");
            }
            for (Map.Entry<String, Map<String, Expression>> kv : guidRguidPair.entrySet()) {
                Predicate equalPredicate = cb.equal(kv.getValue().get(".guid"), kv.getValue().get(".r_guid"));
                Predicate guidIsNullPredicate = cb.isNull(kv.getValue().get(".guid"));
                Predicate rGuidIsNullPredicate = cb.isNull(kv.getValue().get(".r_guid"));
                predicates.add(cb.or(equalPredicate, guidIsNullPredicate, rGuidIsNullPredicate));
            }
        }
        return predicates;
    }

    private void extractGuidKvPair(Map<String, Map<String, Expression>> guidRguidPair, Map.Entry<String, Expression> kv, String postFix) {
        if (kv.getKey().endsWith(postFix)) {
            String keyPrefix = kv.getKey().substring(0, kv.getKey().indexOf(postFix));
            if (guidRguidPair.get(keyPrefix) == null) {
                Map<String, Expression> keyMap = new HashMap<>();
                guidRguidPair.put(keyPrefix, keyMap);
            }
            guidRguidPair.get(keyPrefix).put(postFix, kv.getValue());
        }
    }

    private Predicate buildAccessControlPredicate(CriteriaBuilder criteriaBuilder, Map<String, FieldInfo> selFieldMap, Map<String, Expression> attributeMap) {
        if (selFieldMap.isEmpty())
            return criteriaBuilder.conjunction();

        Set<Integer> processedCiTypeIds = Sets.newHashSet();
        List<Predicate> predicates = selFieldMap.entrySet().stream().map(entry -> {
            FieldInfo fieldInfo = entry.getValue();
            int ciTypeId = fieldInfo.getCiTypeId();
            if (processedCiTypeIds.contains(ciTypeId))
                return null;
            processedCiTypeIds.add(ciTypeId);

            return buildAccessControlPredicate(ciTypeId, criteriaBuilder, attributeMap, true);
        }).filter(predicate -> predicate != null).collect(Collectors.toList());

        return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
    }

    private void processBizFilters(QueryRequest intQueryReq, Map<String, Expression> selectionMap) {
        Filter bizKeyFilter = null;
        Filter statusFilter = null;
        for (Filter filter : intQueryReq.getFilters()) {
            if ("biz_key".equals(filter.getName())) {
                bizKeyFilter = filter;
            }

            if ("state".equals(filter.getName())) {
                statusFilter = filter;
            }
        }
        intQueryReq.getFilters().remove(bizKeyFilter);
        intQueryReq.getFilters().remove(statusFilter);

        if (statusFilter == null || bizKeyFilter == null)
            throw new InvalidArgumentException("biz_key and state filters should be existed together.");

        for (Map.Entry<String, Expression> kv : selectionMap.entrySet()) {
            if (kv.getKey().endsWith(".biz_key")) {
                intQueryReq.getFilters().add(new Filter(kv.getKey(), bizKeyFilter.getOperator(), bizKeyFilter.getValue()));
            } else if (kv.getKey().endsWith(".state")) {
                intQueryReq.getFilters().add(new Filter(kv.getKey(), statusFilter.getOperator(), statusFilter.getValue()));
            }
        }
    }

    private boolean checkBizEnable(QueryRequest intQueryReq) {
        boolean enableBiz = false;
        ;
        boolean filterBizKey = false;
        boolean filterStatus = false;
        if (intQueryReq.getFilters() != null && intQueryReq.getFilters().size() > 0) {
            for (Filter filter : intQueryReq.getFilters()) {
                if ("biz_key".equals(filter.getName())) {
                    filterBizKey = true;
                }
                if ("state".equals(filter.getName())) {
                    filterStatus = true;
                }
            }
        }
        if (filterBizKey && filterStatus) {
            enableBiz = true;
        }

        return enableBiz;
    }

    private void validateIntQueryFilter(QueryRequest intQueryReq, Map<String, FieldInfo> selFieldMap, boolean enableBiz) {
        intQueryReq.getFilters().forEach(x -> {
            if (enableBiz) {
                if ("biz_key".equals(x.getName()) || "state".equals(x.getName())) {
                    return;
                }
            }

            if (!selFieldMap.containsKey(x.getName())) {
                throw new InvalidArgumentException(String.format("The given fileter name [%s] can not be found out in integration query criteria. ", x.getName()));
            }
        });
    }

    private class FieldInfo {
        private Expression expression;
        private Class<?> type;
        private int ciTypeId;
        private String inputType;
        private String name;
        private Integer attrId;
        private String alias;

        public FieldInfo(Expression selection, Class<?> type, int ciTypeId, String inputType, String name, Integer attrId, String alias) {
            this.expression = selection;
            this.type = type;
            this.ciTypeId = ciTypeId;
            this.name = name;
            this.inputType = inputType;
            this.attrId = attrId;
            this.alias = alias;
        }

        public Expression getExpression() {
            return expression;
        }

        public void setExpression(Expression selection) {
            this.expression = selection;
        }

        public Class<?> getType() {
            return type;
        }

        public void setType(Class<?> type) {
            this.type = type;
        }

        public int getCiTypeId() {
            return ciTypeId;
        }

        public void setCiTypeId(int ciTypeId) {
            this.ciTypeId = ciTypeId;
        }

        public String getInputType() {
            return inputType;
        }

        public void setInputType(String inputType) {
            this.inputType = inputType;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public Integer getAttrId() {
            return attrId;
        }

        public void setAttrId(Integer attrId) {
            this.attrId = attrId;
        }

		public String getAlias() {
			return alias;
		}

		public void setAlias(String alias) {
			this.alias = alias;
		}

    }

    private Map<String, Object> convertResponse(List<Expression> selections, Object[] response, List<FieldInfo> fieldInfos) {
        if (selections.size() > fieldInfos.size()) {
            throw new ServiceException("Selections size should not be larger than field infor size.");
        }
        
        Map<Expression,Integer> exprIndexMap = new HashMap<>();
        for(int i=0;i<selections.size();i++) {
        	exprIndexMap.put(selections.get(i), i);
        }

        Map<String, Object> rowMap = new HashMap<>();
        
        for(FieldInfo fieldInfo:fieldInfos) {
        	Expression expr = fieldInfo.getExpression();
            AdmCiTypeAttr attr = null;
            if (fieldInfo.getAttrId() != null) {
                attr = ciTypeAttrRepository.getOne(fieldInfo.getAttrId());
            }
            Object convertedObj = convertFieldValue(expr.getAlias(), response[exprIndexMap.get(expr)], attr);
            rowMap.put(fieldInfo.getAlias(), convertedObj);
        }
        
        return rowMap;
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

    private Map<String, FieldInfo> buildIntQuery(From parentPath, AdmCiType parentCiType, IntegrationQueryDto curQuery, CriteriaQuery query, Map<String, FieldInfo> attrExprMap, boolean enableBiz, Stack<String> path) {
        if (path == null) {
            path = new Stack<>();
        }

        int curCiTypeId = curQuery.getCiTypeId();
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(curCiTypeId);
        AdmCiType curCiType = ciTypeRepository.getOne(curCiTypeId);
        if (CiStatus.NotCreated.getCode().equals(curCiType.getStatus())) {
            throw new InvalidArgumentException(String.format("Can not build integration as the given CiType [%s], status is [%s].", curCiType.getName(), curCiType.getStatus()));
        }
        path.push(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, curCiType.getTableName()));

        Map<String, FieldInfo> currentCiTypeAttrExprMap = new HashMap<>();
        From curFrom = null;
        if (parentPath == null) {// root query
            curFrom = query.from(entityMeta.getEntityClazz());
            attrExprMap.put("root", new FieldInfo(curFrom, entityMeta.getEntityClazz(), curCiTypeId, null, "root", null,null));

            List<Integer> attrIds = curQuery.getAttrs();
            for (int i = 0; i < attrIds.size(); i++) {
                AdmCiTypeAttr attr = ciTypeAttrRepository.getOne(attrIds.get(i));
                validateStatusOfCiTypeAttr(attr);
                // String alias = curQuery.getAttrAliases().get(i);
                String keyName = curQuery.getAttrKeyNames().get(i);
                Expression attrExpression = null;
                if(InputType.MultSelDroplist.getCode().equals(attr.getInputType())) {
                	attrExpression = curFrom.get("guid");//need guid to fetch mult selection value
                	//attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(curCiTypeId,"guid");
                }else if(InputType.MultRef.getCode().equals(attr.getInputType())){
                	attrExpression = curFrom.get("guid");//need guid to fetch mult ref value
                }else {
                    attrExpression = curFrom.get(attr.getPropertyName());
                }
                attrExpression.alias(keyName);
                if (attrExprMap.containsKey(keyName)) {
                    throw new ServiceException(String.format("There are duplicated alias [%s] for integrate query [%s].", keyName, curQuery.getName()));
                }
                attrExprMap.put(keyName, new FieldInfo(attrExpression, FieldType.getTypeFromCode(attr.getPropertyType()), attr.getCiTypeId(), attr.getInputType(), attr.getName(), attr.getIdAdmCiTypeAttr(),keyName));
                currentCiTypeAttrExprMap.put(attr.getPropertyName(), attrExprMap.get(keyName));
            }
        } else {
            Relationship relt = curQuery.getParentRs();
            if (relt == null) {
                throw new InvalidArgumentException(String.format("There is not parent relationship for CiType [%d]", curQuery.getCiTypeId()));
            }
            int reltAttrId = relt.getAttrId();
            AdmCiTypeAttr reltAttr = ciTypeAttrRepository.getOne(reltAttrId);
            validateStatusOfCiTypeAttr(reltAttr);
            String joinField = null;
            // if(relt.getIsReferedFromParent()) {
            if (reltAttr.getCiTypeId().equals(parentCiType.getIdAdmCiType())) {
                joinField = DynamicEntityUtils.getJoinFieldName(parentCiType, reltAttr, true);
                curFrom = parentPath.join(joinField, JoinType.LEFT);
            } else {
                joinField = DynamicEntityUtils.getJoinFieldName(parentCiType, reltAttr, false);
                curFrom = parentPath.join(joinField, JoinType.LEFT);
            }

            List<Integer> attrIds = curQuery.getAttrs();
            for (int i = 0; i < attrIds.size(); i++) {
                AdmCiTypeAttr attr = ciTypeAttrRepository.getOne(attrIds.get(i));
                validateStatusOfCiTypeAttr(attr);
                // String alias = curQuery.getAttrAliases().get(i);
                String keyName = curQuery.getAttrKeyNames().get(i);
                Expression attrExpression = null;
                
                if(InputType.MultSelDroplist.getCode().equals(attr.getInputType())) {
                	attrExpression = curFrom.get("guid");//need guid to fetch mult selection value
                }else if(InputType.MultRef.getCode().equals(attr.getInputType())){
                	attrExpression = curFrom.get("guid");//need guid to fetch mult ref value
                }else {
                	attrExpression = curFrom.get(attr.getPropertyName());
                }

                attrExpression.alias(keyName);
                if (attrExprMap.containsKey(keyName)) {
                    throw new ServiceException(String.format("There are duplicated alias [%s] for integrate query [%s].", keyName, curQuery.getName()));
                }
                attrExprMap.put(keyName, new FieldInfo(attrExpression, FieldType.getTypeFromCode(attr.getPropertyType()), attr.getCiTypeId(), attr.getInputType(), attr.getName(), attr.getIdAdmCiTypeAttr(),keyName));
                currentCiTypeAttrExprMap.put(attr.getPropertyName(), attrExprMap.get(keyName));
            }
        }

        attachAdditionalAttr(attrExprMap, path, curCiTypeId, curFrom, "guid");
        attachAdditionalAttr(attrExprMap, path, curCiTypeId, curFrom, "r_guid");
     
        if (enableBiz) {
            attachAdditionalAttr(attrExprMap, path, curCiTypeId, curFrom, "biz_key");
            attachAdditionalAttr(attrExprMap, path, curCiTypeId, curFrom, "state");
        }

        List<AdmCiTypeAttr> accessControlledAttributes = ciTypeAttrRepository.findAllByCiTypeIdAndIsAccessControlled(curCiTypeId, 1);
        if (isNotEmpty(accessControlledAttributes)) {
            for (AdmCiTypeAttr attr : accessControlledAttributes) {
                String propertyName = attr.getPropertyName();
                String keyName = String.format(ACCESS_CONTROL_ATTRIBUTE_FORMAT, curCiTypeId, propertyName);
                FieldInfo fieldInfo = currentCiTypeAttrExprMap.get(propertyName);
                if (fieldInfo == null) {
                    Expression attrExpression = curFrom.get(propertyName);
                    attrExpression.alias(keyName);
                    fieldInfo = new FieldInfo(attrExpression, FieldType.getTypeFromCode(attr.getPropertyType()), attr.getCiTypeId(), attr.getInputType(), attr.getName(), attr.getIdAdmCiTypeAttr(),keyName);
                }
                attrExprMap.put(keyName, fieldInfo);
            }
        }

        for (IntegrationQueryDto child : curQuery.getChildren()) {
            buildIntQuery(curFrom, curCiType, child, query, attrExprMap, false, path);
        }

        path.pop();
        return attrExprMap;
    }

    private void validateStatusOfCiTypeAttr(AdmCiTypeAttr attr) {
        if (CiStatus.NotCreated.getCode().equals(attr.getStatus())) {
            throw new InvalidArgumentException(String.format("Can not build integration as the given ci type attr [%s], status is [%s].", attr.getName(), attr.getStatus()));
        }
    }

    private void attachAdditionalAttr(Map<String, FieldInfo> attrExprMap, Stack<String> path, int curCiTypeId, From curFrom, String propertyName) {
        AdmCiTypeAttr attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(curCiTypeId, propertyName);
        validateStatusOfCiTypeAttr(attr);
        if (attr == null) {
            throw new ServiceException(String.format("Can not find out [%s] for CI Type [%d].", propertyName, curCiTypeId));
        }

        String alias = getTemplAlias(path) + "." + propertyName;
        Expression expression = curFrom.get(attr.getPropertyName());
        if (expression.getAlias() == null) {
            expression.alias(alias);
        }
        attrExprMap.put(alias, new FieldInfo(expression, FieldType.getTypeFromCode(attr.getPropertyType()), attr.getCiTypeId(), attr.getInputType(), attr.getName(), null,alias));
    }

    @Override
    public List<IntQueryResponseHeader> integrateQueryHeader(int intQueryId) {
        IntegrationQueryDto intQueryDto = intQueryService.getIntegrationQuery(intQueryId);

        List<IntQueryResponseHeader> headers = new LinkedList<>();
        return buildIntQuerHeader(intQueryDto, headers);
    }

    private List<IntQueryResponseHeader> buildIntQuerHeader(IntegrationQueryDto curQuery, List<IntQueryResponseHeader> headers) {
        List<Integer> attrIds = curQuery.getAttrs();
        IntQueryResponseHeader header = new IntQueryResponseHeader(curQuery.getName());
        for (int i = 0; i < attrIds.size(); i++) {
            AdmCiTypeAttr attr = ciTypeAttrRepository.getOne(attrIds.get(i));
            String alias = curQuery.getAttrKeyNames().get(i);
            header.getAttrUnits().add(new AttrUnit(alias, CiTypeAttrDto.fromAdmCiTypeAttrs(attr)));
        }
        headers.add(header);

        for (IntegrationQueryDto child : curQuery.getChildren()) {
            buildIntQuerHeader(child, headers);
        }

        return headers;
    }

    @Override
    public HashSet<String> retrieveVersions(int ciTypeId) {
        getDynamicEntityMetaMap();

        HashSet<String> refCiTables = ciTypeRepository.findAllRefCiTableFrom(ciTypeId);
        String combinedSql = genCombinedSql(refCiTables);

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            return new HashSet<String>(entityManager.createNativeQuery(combinedSql).getResultList());
        } finally {
            priEntityManager.close();
        }
    }

    private String genCombinedSql(HashSet<String> refCiTables) {
        String sql = "SELECT fixed_date FROM %s ci WHERE ci.guid = ci.r_guid and ci.fixed_date is not null";

        List<String> sqls = new ArrayList<String>();
        for (String tableName : refCiTables) {
            sqls.add(String.format(sql, tableName));
        }

        return StringUtils.join(sqls, " union all ");
    }

    @Override
    public List<CiDataTreeDto> retrieveVersionDetail(int fromCiTypeId, int toCiTypeId, String version) {
        getDynamicEntityMetaMap();

        List<CiDataTreeDto> versionDetails = new LinkedList<CiDataTreeDto>();

        attachCiWithVersion(versionDetails, fromCiTypeId, toCiTypeId, version, null, null);

        return versionDetails;
    }

    private void attachCiWithVersion(List<CiDataTreeDto> versionDetails, int fromCiTypeId, int toCiTypeId, String version, String parentColumnName, Object parentGuid) {
        List<CiDataTreeDto> cis = new LinkedList<CiDataTreeDto>();

        String tableName = ciTypeRepository.findByIdAdmCiType(fromCiTypeId).getTableName();
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("SELECT guid, name,r_guid from %s where (r_guid,fixed_date) in (SELECT ci.r_guid, max(ci.fixed_date) as fixed_date from %s ci, adm_basekey_code code " + "where ci.state = code.id_adm_basekey "
                + "and ci.fixed_date is not null " + "and ((ci.fixed_date < '%s' and code.code != '%s' ) or (ci.fixed_date = '%s'))", tableName, tableName, version, "delete", version, version));

        if (parentColumnName != null) {
            sb.append(String.format(" and %s = '%s'", parentColumnName, parentGuid));
        }

        sb.append(" group by ci.r_guid)");

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            List<Object[]> results = entityManager.createNativeQuery(sb.toString()).getResultList();

            results.forEach(x -> {
                CiDataTreeDto ci = conductCi(fromCiTypeId, cis, x);
                List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId("ref", fromCiTypeId);
                if (attrs != null && !attrs.isEmpty()) {
                    List<CiDataTreeDto> ciChildren = new LinkedList<>();
                    ci.setChildren(ciChildren);
                    for (AdmCiTypeAttr attr : attrs) {
                        if (attr.getCiTypeId() > toCiTypeId) {
                            return;
                        }
                        attachCiWithVersion(ciChildren, attr.getCiTypeId(), toCiTypeId, version, attr.getPropertyName(), ci.getRootGuid());
                    }
                }
            });
        } finally {
            priEntityManager.close();
        }

        versionDetails.addAll(cis);
    }

    private CiDataTreeDto conductCi(int fromCiTypeId, List<CiDataTreeDto> cis, Object[] x) {
        Map<String, Object> data = new HashMap<>();
        data.put("guid", x[0]);
        data.put("name", x[1]);
        data.put("r_guid", x[2]);

        CiDataTreeDto ci = new CiDataTreeDto();
        ci.setCiTypeId(fromCiTypeId);
        ci.setGuid((String) data.get("guid"));
        ci.setRootGuid((String) data.get("r_guid"));
        ci.setData(data);
        cis.add(ci);
        return ci;
    }

    @Override
    public QueryResponse adhocIntegrateQuery(AdhocIntegrationQueryDto adhocQueryRequest) {
        if (logger.isDebugEnabled()) {
            logger.debug("Got adhoc integrate request:{}", JsonUtil.toJsonString(adhocQueryRequest));
        }
        IntegrationQueryDto intQueryDto = adhocQueryRequest.getCriteria();
        QueryRequest queryRequest = adhocQueryRequest.getQueryRequest();
        validateForQuery(intQueryDto);

        List<FieldInfo> selectedFields = new LinkedList<>();
        List<Filter> srcFilters = null;
        try {
            srcFilters = CollectionUtils.clone(queryRequest.getFilters(), Lists.newLinkedList());
        } catch (CloneNotSupportedException e) {
            throw new ServiceException("Failed to clone int query filters.", e);
        }

        List resultList = doIntegrateQuery(intQueryDto, queryRequest, true, selectedFields);
        int totalCount = convertResultToInteger(resultList);

        queryRequest.setFilters(srcFilters);
        resultList = doIntegrateQuery(intQueryDto, queryRequest, false, selectedFields);

        List<Expression> selections = new LinkedList<>();
        selectedFields.forEach(field -> {
        	if(!selections.contains(field.getExpression())) {
        		selections.add(field.getExpression());
        	}
        });

        List<Map<String, Object>> results = new LinkedList<>();
        // muti columns result
        if (selections.size() > 1) {
            List<Object[]> rows = resultList;
            for (int i = 0; i < rows.size(); i++) {
                Object[] obj = rows.get(i);
                results.add(convertResponse(selections, obj, selectedFields));
            }
        } else {
            List<Object> rows = resultList;
            if (rows != null && rows.size() > 0) {
                results.add(convertResponse(selections, rows.toArray(), selectedFields));
            }
        }

        QueryResponse response = new QueryResponse(null, results);
        setupPageInfo(queryRequest, totalCount, response);

        if (logger.isDebugEnabled()) {
            logger.debug("Return integrate response:{}", JsonUtil.toJsonString(response));
        }
        return response;
    }

    private void validateForQuery(IntegrationQueryDto intQueryDto) {
        Integer ciTypeId = intQueryDto.getCiTypeId();
        if (!ciTypeRepository.existsById(ciTypeId)) {
            throw new InvalidArgumentException(String.format("CiType [%d] is not existed.", ciTypeId));
        }

        if ((intQueryDto.getAttrs() == null || intQueryDto.getAttrs().size() == 0)) {// attr list is empty
            if (intQueryDto.getAttrKeyNames() != null && intQueryDto.getAttrKeyNames().size() > 0) {
                throw new InvalidArgumentException(String.format("Attribute list is empty but attr key name list has values for citype [%d]", ciTypeId));
            }
        } else {// attr list is not empty
            if (intQueryDto.getAttrKeyNames() == null || intQueryDto.getAttrKeyNames().size() == 0) {
                throw new InvalidArgumentException(String.format("Attribute list is not empty while attr key name list is empty for citype [%d]", ciTypeId));
            }
        }

        for (int attrId : intQueryDto.getAttrs()) {
            if (!ciTypeAttrRepository.existsById(attrId)) {
                throw new InvalidArgumentException(String.format("CiType attr [%d] is not existed.", attrId));
            }
        }

    }

    @Override
    public List<Map<String, Object>> queryWithFilters(int ciTypeId, List<Filter> filters) {
        return queryWithFilters(ciTypeId, filters, true);
    }

    private List<Map<String, Object>> queryWithFilters(int ciTypeId, List<Filter> filters, boolean needValidate) {
        if (logger.isDebugEnabled()) {
            logger.debug("CI query by id request, ciTypeId:{}, filters:{}", ciTypeId, JsonUtil.toJson(filters));
        }

        if (needValidate) {
            validateCiType(ciTypeId);
        }

        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        QueryRequest request = new QueryRequest();
        request.getFilters().addAll(filters);
        List<Object> results = doQuery(request, entityMeta, false);

        List<Map<String, Object>> resultList = Lists.newLinkedList();
        results.forEach(x -> {
            // DynamicEntityHolder entityBean =
            // DynamicEntityHolder.createDynamicEntityBean(entityMeta, x);
            Map<String, Object> entityBeanMap = ClassUtils.convertBeanToMap(x, entityMeta, false);

            PriorityEntityManager priEntityManager = getEntityManager();
            EntityManager entityManager = priEntityManager.getEntityManager();
            try {
                Map<String, Object> enhacedMap = enrichCiObject(entityMeta, entityBeanMap, entityManager);
                resultList.add(enhacedMap);
            } finally {
                priEntityManager.close();
            }

        });
        return resultList;
    }
    @OperationLogPointcut(operation = Modification, objectClass = CiData.class, ciTypeIdArgumentIndex = 0)
    @Override
    public List<Map<String, Object>> operateState(List<CiIndentity> ciIds, String operation) {
        StateOperation stateOperation = StateOperation.fromCode(operation);

        if (StateOperation.Confirm.equals(stateOperation) || StateOperation.Discard.equals(stateOperation) || StateOperation.Startup.equals(stateOperation) || StateOperation.Stop.equals(stateOperation)) {
            List<Map<String, Object>> results = Lists.newLinkedList();
            PriorityEntityManager priEntityManager = getEntityManager();
            EntityManager entityManager = priEntityManager.getEntityManager();

            EntityTransaction transaction = entityManager.getTransaction();
            transaction.begin();
            try {
                Date date = new Date();
                for (CiIndentity ciId : ciIds) {
                    DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciId.getCiTypeId());
                    Object entityBean = validateCi(ciId.getCiTypeId(), ciId.getGuid(), entityMeta, entityManager, ACTION_MODIFICATION);
                    DynamicEntityHolder entityHolder = new DynamicEntityHolder(entityMeta, entityBean);

                    Map<String, Object> result = stateTransEngine.process(entityManager, ciId.getCiTypeId(), ciId.getGuid(), operation, null, entityHolder, date);
                    Map<String, Object> enhacedMap = enrichCiObject(entityMeta, result, entityManager);
                    results.add(enhacedMap);
                }
                transaction.commit();
            } catch (Exception ex) {
                transaction.rollback();
                // String errorMessage = String.format("Failed to operate [%s]
                // status.",operation);
                // logger.warn(errorMessage, ex);
                throw ex;
            } finally {
                priEntityManager.close();
            }
            return results;
        } else {
            throw new InvalidArgumentException("Operation [%s] is not supported.", operation);
        }
    }

    @Override
    public DynamicEntityMeta getDynamicEntityMeta(int ciTypeId) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        return entityMeta;
    }

    /**
     * 1. clone current ci to a new one and assign a new guid to it 2. assign the
     * new guid as pguid to current ci
     */
    @Override
    public Object cloneCiAsParent(EntityManager entityManager, int ciTypeId, String guid) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        Object fromBean = JpaQueryUtils.findEager(entityManager, entityMeta.getEntityClazz(), guid);
        if (fromBean == null) {
            throw new InvalidArgumentException(String.format("Can not find CI (ciTypeId:%d, guid:%s)", ciTypeId, guid));
        }
        String newGuid = sequenceService.getNextGuid(entityMeta.getTableName(), ciTypeId);

        BeanMap fromBeanMap = new BeanMap(fromBean);
        DynamicEntityHolder toEntityHolder = DynamicEntityHolder.cloneDynamicEntityBean(entityMeta, fromBean);
        MultiValueFeildOperationUtils.processMultValueFieldsForCloneCi(entityManager, entityMeta, newGuid, fromBeanMap, toEntityHolder, this);

        toEntityHolder.put(CmdbConstants.DEFAULT_FIELD_GUID, newGuid);

        List<AdmCiTypeAttr> refreshableAttrs = ciTypeAttrRepository.findByCiTypeIdAndIsRefreshable(ciTypeId, 1);
        refreshableAttrs.forEach(attr -> {
            fromBeanMap.put(attr.getPropertyName(), null);
        });
	fromBeanMap.put(CmdbConstants.DEFAULT_FIELD_PARENT_GUID, newGuid);
	
        entityManager.merge(fromBean);
        entityManager.persist(toEntityHolder.getEntityObj());
        return fromBean;
    }

    @Override
    public DynamicEntityHolder getCiHolder(int ciTypeId, String guid) {
        validateCiType(ciTypeId);
        validateCiType(ciTypeId);
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);

        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        try {
            Object entityBean = JpaQueryUtils.findEager(entityManager, entityMeta.getEntityClazz(), guid);
            if (entityBean == null) {
                throw new InvalidArgumentException(String.format("Can not find CI (ciTypeId:%d, guid:%s)", ciTypeId, guid));
            }
            return new DynamicEntityHolder(entityMeta, entityBean);
        } finally {
            priEntityManager.close();
        }
    }

    @Override
    public List<Map<String, Object>> lookupReferenceByCis(int ciTypeId, String guid, boolean checkFinalState) {
        List<Map<String, Object>> dependentCis = Lists.newLinkedList();
        List<AdmCiTypeAttr> referredAttrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Reference.getCode(), ciTypeId);
        referredAttrs.addAll(ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.MultRef.getCode(), ciTypeId));
	referredAttrs.forEach(attr -> {
            List<Map<String, Object>> ciData = queryWithFilters(attr.getCiTypeId(), Lists.newArrayList(new Filter(attr.getPropertyName(), FilterOperator.Equal.getCode(), guid)), false);
            if (ciData != null && ciData.size() > 0) {
                ciData.forEach(data -> {
                    if (checkFinalState && isFinalStateCi(attr, data)) {
                        return;
                    };

                    Map ciMap = Maps.newHashMap();
                    MapUtils.putAll(ciMap, new Object[] { "ciTypeId", attr.getCiTypeId(), "guid", data.get("guid"), "propertyName", attr.getPropertyName() });
                    dependentCis.add(ciMap);
                });
            }
        });
        return dependentCis;
    }

    private boolean isFinalStateCi(AdmCiTypeAttr attr, Map<String, Object> data) {
        Object state = data.get(CmdbConstants.DEFAULT_FIELD_STATE);
        if (state instanceof CatCodeDto) {
            CatCodeDto codeDto = (CatCodeDto) state;
            AdmBasekeyCat cat = cateRepository.getOne(codeDto.getCatId());
            if (codeDto.getCode().equals(finalStates.get(cat.getCatName()))) {
                return true;
            }
        }
        return false;
    }

    @Override
    public List<Map<String, Object>> lookupReferenceToCis(int ciTypeId, String guid) {
        List<Map<String, Object>> dependentCis = Lists.newLinkedList();
        List<AdmCiTypeAttr> referredAttrs = ciTypeAttrRepository.findByInputTypeAndCiTypeId(InputType.Reference.getCode(), ciTypeId);
        Map<String, Object> ci = getCi(ciTypeId, guid);
        ;
        referredAttrs.forEach(attr -> {
            if (attr.getReferenceId() != null && ci.get(attr.getPropertyName()) != null) {
                List<Map<String, Object>> ciData = queryWithFilters(attr.getReferenceId(), Lists.newArrayList(new Filter("guid", FilterOperator.Equal.getCode(), ci.get(attr.getPropertyName()))));
                if (ciData != null && ciData.size() > 0) {
                    ciData.forEach(data -> {
                        Map ciMap = Maps.newHashMap();
                        MapUtils.putAll(ciMap, new Object[] { "ciTypeId", attr.getReferenceId(), "guid", data.get("guid"), "propertyName", attr.getPropertyName() });
                        dependentCis.add(ciMap);
                    });
                }
            }
        });
        return dependentCis;
    }

    @Override
    public List<Map<String, Object>> lookupReferenceByCisWithFullData(int ciTypeId, String guid) {
        List<Map<String, Object>> dependentCis = Lists.newLinkedList();
        List<AdmCiTypeAttr> referredAttrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Reference.getCode(), ciTypeId);
        referredAttrs.forEach(attr -> {
            if (!CiStatus.Created.getCode().equals(attr.getStatus())) {
                return;
            }
            List<Map<String, Object>> ciData = queryWithFilters(attr.getCiTypeId(), Lists.newArrayList(new Filter(attr.getPropertyName(), FilterOperator.Equal.getCode(), guid)));
            if (ciData != null && !ciData.isEmpty()) {
                ciData.forEach(data -> {
                    Map ciMap = Maps.newLinkedHashMap();
                    ciMap.put("ciTypeId", attr.getCiTypeId());
                    ciMap.put("ciLayerCode", attr.getAdmCiType().getLayerCode().getCode());
                    ciMap.put("ciLayerValue", attr.getAdmCiType().getLayerCode().getValue());
                    ciMap.putAll(data);
                    dependentCis.add(ciMap);
                });
            }
        });
        return dependentCis;
    }

    @Override
    public Map<String, Object> recursiveGetCisTree(Integer ciTypeId, String guid, Map<String, Object> parentCi) {
        List<Map<String, Object>> cis = lookupReferenceByCisWithFullData(ciTypeId, guid);
        if (cis.isEmpty()) {
            return parentCi;
        }

        if (parentCi != null) {
            parentCi.put("ciTypeId", ciTypeId);
            parentCi.put("guid", guid);
            parentCi.put("children", cis);
            cis.forEach(ci -> recursiveGetCisTree((Integer) ci.get("ciTypeId"), (String) ci.get("guid"), ci));
        }
        return parentCi;
    }

    @Override
    public List<CiKeyPair> retrieveKeyPairs(int ciTypeId) {
        DynamicEntityMeta entityMeta = getDynamicEntityMetaMap().get(ciTypeId);
        PriorityEntityManager priEntityManager = getEntityManager();
        EntityManager entityManager = priEntityManager.getEntityManager();
        List<CiKeyPair> ciKeyPairs = new LinkedList<>();
        try {
            CriteriaBuilder cb = entityManager.getCriteriaBuilder();
            CriteriaQuery query = cb.createQuery();
            Root root = query.from(entityMeta.getEntityClazz());
            Path guid = root.get(CmdbConstants.DEFAULT_FIELD_GUID);
            Path keyName = root.get(CmdbConstants.DEFAULT_FIELD_KEY_NAME);
            query.multiselect(guid,keyName).distinct(true);
            TypedQuery guidQuery =  entityManager.createQuery(query);
            List results = guidQuery.getResultList();
            ciKeyPairs = Lists.transform(results, (item) -> {
            	Object[] row = (Object[]) item;
            	CiKeyPair ciKeyPair = new CiKeyPair(String.valueOf(row[0]),String.valueOf(row[1]));
            	return ciKeyPair;
            });
            return ciKeyPairs;
        }
        catch(Exception ex) {
            throw new ServiceException(String.format("Failed to query guids for CI type [%d]", ciTypeId),ex);
        }finally {
            priEntityManager.close();
        }
    }

    @Override
    public List<IntQueryResponseHeader> integrateQueryHeader(String queryName) {
        IntegrationQueryDto intQueryDto = intQueryService.getIntegrationQueryByName(queryName);

        List<IntQueryResponseHeader> headers = new LinkedList<>();
        return buildIntQuerHeader(intQueryDto, headers);
    }
}
