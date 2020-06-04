package com.webank.cmdb.repository.impl;

import static java.lang.reflect.Modifier.isStatic;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

import javax.persistence.EntityGraph;
import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.persistence.Subgraph;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.From;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.transaction.Transactional;

import org.apache.commons.beanutils.BeanMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableSet;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.FilterRelationship;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.PageInfo;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.JpaQueryUtils;
import com.webank.cmdb.util.Pageable;
import com.webank.cmdb.util.Sorting;

@SuppressWarnings({ "rawtypes", "unchecked" })
@Repository
public class StaticEntityRepositoryImpl implements StaticEntityRepository {
    private Logger logger = LoggerFactory.getLogger(StaticEntityRepositoryImpl.class);

    @Autowired
    private EntityManager entityManager;

    @Override
    public <T> QueryResponse query(Class<T> domainClzz, QueryRequest ciRequest) {

        List<Field> fieldList = getDomainAttrFields(domainClzz);
        List<Object> countResult = doQuery(domainClzz, ciRequest, true, fieldList);
        int totalRow = convertResultToInteger(countResult);

        List<Object> resultObjs = doQuery(domainClzz, ciRequest, false, fieldList);

        List<Object> domainObjs = new LinkedList<>();

        resultObjs.forEach(x -> {
            domainObjs.add(x);
        });

        QueryResponse ciInfoResp = new QueryResponse<>();
        ciInfoResp.setContents(domainObjs);

        if (ciRequest != null && ciRequest.getPageable() != null) {
            ciInfoResp.setPageInfo(new PageInfo(totalRow, ciRequest.getPageable().getStartIndex(), ciRequest.getPageable().getPageSize()));
        } else {
            ciInfoResp.setPageInfo(new PageInfo(totalRow, 0, totalRow));
        }

        return ciInfoResp;
    }

    private List<Field> getDomainAttrFields(Class domainClazz) {
        Field[] fields = domainClazz.getDeclaredFields();
        List<Field> fieldList = new LinkedList<>();
        Set<String> ignoredFields = ImmutableSet.<String>of("serialVersionUID", "logger");
        for (Field field : fields) {
            if (isStatic(field.getModifiers())) {
                continue;
            }
            if (ignoredFields.contains(field.getName())) {
                continue;
            }
            if (field.getType().equals(List.class)) {
                continue;
            }
            fieldList.add(field);
        }
        return fieldList;
    }

    private int convertResultToInteger(List rawResults) {
        String strVal = rawResults.get(0).toString();
        return Integer.valueOf(strVal);
    }

    @Override
    public <D> QueryResponse queryCrossRes(Class<D> domainClazz, QueryRequest ciRequest, FilterPath rootFilterPath) {
        QueryResponse ciInfoResp = new QueryResponse<>();
        CrossResRequest corssResReq = new CrossResRequest(ciRequest);
        corssResReq.setRootFilterPath(rootFilterPath);

        TypedQuery typedQuery = doQueryCrossRes(domainClazz, corssResReq, true);
        List<?> results = typedQuery.getResultList();
        int totalRow = convertResultToInteger(results);

        typedQuery = doQueryCrossRes(domainClazz, corssResReq, false);
        if (ciRequest != null) {
            JpaQueryUtils.applyPaging(ciRequest.isPaging(), ciRequest.getPageable(), typedQuery);
        }
        results = typedQuery.getResultList();

        ciInfoResp.setContents(results);

        if (ciRequest != null && ciRequest.getPageable() != null) {
            ciInfoResp.setPageInfo(new PageInfo(totalRow, ciRequest.getPageable().getStartIndex(), ciRequest.getPageable().getPageSize()));
        } else {
            ciInfoResp.setPageInfo(new PageInfo(totalRow, 0, totalRow - 1));
        }

        return ciInfoResp;
    }

    private <T> TypedQuery<T> doQueryCrossRes(Class<T> domainClazz, CrossResRequest request, boolean selectCount) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        EntityGraph<T> rootEg = entityManager.createEntityGraph(domainClazz);

        CriteriaQuery query = cb.createQuery(domainClazz);
        Root<T> root = query.from(domainClazz);
        if (selectCount) {
            query.select(cb.count(root));
        }
        List<Predicate> predicates = new LinkedList<>();
        queryJoin(cb, query, root, request.getRootFilterPath(), rootEg, null, predicates);

        if (predicates.size() > 0) {
            if (FilterRelationship.Or.equals(request.getFilterRs())) {
                query.where(cb.or(predicates.toArray(new Predicate[0])));
            } else {
                query.where(cb.and(predicates.toArray(new Predicate[0])));
            }
        }
        TypedQuery<T> typedQuery = entityManager.createQuery(query);
        if (!selectCount) {
            typedQuery.setHint("javax.persistence.fetchgraph", rootEg);
        }
        return typedQuery;
    }

    public static class CrossResRequest {
        private boolean isPaging = false;
        private Pageable pageable = new Pageable();
        private Sorting sorting = new Sorting();
        private List<String> groupBys = new LinkedList<>();
        private List<String> refResource = new LinkedList<>();
        private FilterPath rootFilterPath;
        private FilterRelationship filterRs;

        public CrossResRequest() {
        }

        public CrossResRequest(QueryRequest queryReq) {
            this.isPaging = queryReq.isPaging();
            this.pageable = queryReq.getPageable();
            this.sorting = queryReq.getSorting();
            this.groupBys = queryReq.getGroupBys();
            this.refResource = queryReq.getRefResources();
            this.filterRs = FilterRelationship.fromCode(queryReq.getFilterRs());
        }

        public boolean isPaging() {
            return isPaging;
        }

        public void setPaging(boolean isPaging) {
            this.isPaging = isPaging;
        }

        public Pageable getPageable() {
            return pageable;
        }

        public void setPageable(Pageable pageable) {
            this.pageable = pageable;
        }

        public Sorting getSorting() {
            return sorting;
        }

        public void setSorting(Sorting sorting) {
            this.sorting = sorting;
        }

        public List<String> getGroupBys() {
            return groupBys;
        }

        public void setGroupBys(List<String> groupBys) {
            this.groupBys = groupBys;
        }

        public List<String> getRefResource() {
            return refResource;
        }

        public void setRefResource(List<String> refResource) {
            this.refResource = refResource;
        }

        public FilterPath getRootFilterPath() {
            return rootFilterPath;
        }

        public void setRootFilterPath(FilterPath rootFilterPath) {
            this.rootFilterPath = rootFilterPath;
        }

        public FilterRelationship getFilterRs() {
            return filterRs;
        }

        public void setFilterRs(FilterRelationship filterRs) {
            this.filterRs = filterRs;
        }

    }

    public static class JoinFilter {
        private String field;
        private FilterOperator operator;
        private Object value;

        public JoinFilter() {
        }

        public JoinFilter(String field, FilterOperator operator, Object value) {
            this.field = field;
            this.operator = operator;
            this.value = value;
        }

        public String getField() {
            return field;
        }

        public void setField(String field) {
            this.field = field;
        }

        public FilterOperator getOperator() {
            return operator;
        }

        public void setOperator(FilterOperator operator) {
            this.operator = operator;
        }

        public Object getValue() {
            return value;
        }

        public void setValue(Object value) {
            this.value = value;
        }
    }

    public static class FilterPath {
        private String joinAttr;
        private List<JoinFilter> filters;
        private List<FilterPath> joinChildren = new LinkedList<>();

        public FilterPath() {
        }

        public FilterPath(String joinAttr, List<JoinFilter> filters, List<FilterPath> joinChildren) {
            this.joinAttr = joinAttr;
            this.filters = filters;
            this.joinChildren = joinChildren;
        }

        public String getJoinAttr() {
            return joinAttr;
        }

        public void setJoinAttr(String joinAttr) {
            this.joinAttr = joinAttr;
        }

        public List<FilterPath> getJoinChildren() {
            return joinChildren;
        }

        public void setJoinChildren(List<FilterPath> joinChildren) {
            this.joinChildren = joinChildren;
        }

        public List<JoinFilter> getFilters() {
            return filters;
        }

        public void setFilters(List<JoinFilter> filters) {
            this.filters = filters;
        }
    }

    private void queryJoin(CriteriaBuilder cb, CriteriaQuery query, From from, FilterPath path, EntityGraph<?> eg, Subgraph sg, List<Predicate> predicates) {
        String joinAttr = path.getJoinAttr();
        From joinPath = null;
        if (".".equals(joinAttr)) {
            joinPath = from;
        } else {
            if (sg == null) {
                sg = eg.addSubgraph(path.getJoinAttr());
            } else {
                sg = sg.addSubgraph(path.getJoinAttr());
            }
            joinPath = from.join(path.getJoinAttr());
        }
        applyFilter(cb, query, path.getFilters(), joinPath, predicates);
        if (path.getJoinChildren() != null && path.getJoinChildren().size() > 0) {
            for (FilterPath fp : path.getJoinChildren()) {
                queryJoin(cb, query, joinPath, fp, eg, sg, predicates);
            }
        }
    }

    private void applyFilter(CriteriaBuilder cb, CriteriaQuery query, List<JoinFilter> filters, Path path, List<Predicate> predicates) {

        filters.forEach((filter) -> {
            Filter curFilter = new Filter(filter.getField(), filter.getOperator().getCode(), filter.getValue());
            switch (filter.getOperator()) {
            case In:
                JpaQueryUtils.processInOperator(cb, predicates, curFilter, path.get(filter.getField()));
                break;
            case Equal:
                JpaQueryUtils.processEqualsOperator(cb, predicates, curFilter, path.get(filter.getField()));
                break;
            case NotEqual:
                JpaQueryUtils.processNotEqualsOperator(cb, predicates, curFilter, path.get(filter.getField()));
                break;
            case Contains:
                JpaQueryUtils.processContainsOperator(cb, predicates, curFilter, path.get(filter.getField()));
                break;
            case Greater:
                JpaQueryUtils.processGreaterOperator(cb, predicates, curFilter, path.get(filter.getField()));
                break;
            case Less:
                JpaQueryUtils.processLessOperator(cb, predicates, curFilter, path.get(filter.getField()));
                break;
            }
        });

    }

    private static void processEqualsOperator(CriteriaBuilder cb, List<Predicate> predicates, String filed, Object value, Path path) {
        Expression filterExpr = path.get(filed);
        if (value instanceof String) {
            predicates.add(cb.equal(cb.upper(filterExpr), (String) value.toString().toUpperCase()));
        } else {
            predicates.add(cb.equal(filterExpr, value));
        }

    }

    private <T> List<Object> doQuery(Class<T> domainClazz, QueryRequest ciRequest, boolean isSelRowCount, List<Field> fieldList) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();

        CriteriaQuery query = cb.createQuery(domainClazz);
        Root<T> root = query.from(domainClazz);

        Map<String, Expression> selectionMap = new LinkedHashMap<>();
        for (Field field : fieldList) {
            selectionMap.put(field.getName(), root.get(field.getName()));
        }

        if (isSelRowCount) {
            query.select(cb.count(root));
        } else {
            query.select(root);
        }

        Map<String, Class<?>> fieldTypeMap = new HashMap<>();
        for (Field field : fieldList) {
            fieldTypeMap.put(field.getName(), field.getType());
        }

        if (ciRequest != null) {
            if (ciRequest.getFilters() != null && ciRequest.getFilters().size() > 0) {
                JpaQueryUtils.applyFilter(cb, query, ciRequest.getFilters(), selectionMap, fieldTypeMap, FilterRelationship.fromCode(ciRequest.getFilterRs()), null, null);
            }

            if (isSelRowCount == false) {
                JpaQueryUtils.applySorting(ciRequest.getSorting(), cb, query, selectionMap);
            }
        }

        TypedQuery typedQuery = entityManager.createQuery(query);

        if (isSelRowCount == false && ciRequest != null) {
            JpaQueryUtils.applyPaging(ciRequest.isPaging(), ciRequest.getPageable(), typedQuery);
        }

        List<Object> resultObjs = typedQuery.getResultList();
        return resultObjs;
    }

    public <T> T createDynamicEntityBean(Class<T> domainClazz, List<Field> fields, Object[] attrVals) {
        if (fields.size() != attrVals.length) {
            throw new IllegalArgumentException("Domain class properties and attribute values should be same count.");
        }

        T entityBean;
        try {
            entityBean = domainClazz.newInstance();
        } catch (Exception e) {
            throw new ServiceException(String.format("Fail to create domain [%s] entity bean.", domainClazz.toString()));
        }
        BeanMap beanMap = new BeanMap(entityBean);

        final AtomicInteger i = new AtomicInteger(0);
        fields.forEach(x -> {
            String attrName = x.getName();
            Class<?> attrType = x.getType();
            beanMap.put(attrName, ClassUtils.toObject(attrType, attrVals[i.getAndIncrement()]));
        });

        return entityBean;
    }

    @Transactional
    @Override
    public <T> void delete(Class<T> domainClazz, int id) {
        T entity = validateDomain(domainClazz, id);
        entityManager.remove(entity);
        entityManager.flush();
    }

    private <T> T validateDomain(Class<T> domainClazz, int id) {
        T entity = entityManager.find(domainClazz, id);
        if (entity == null) {
            throw new InvalidArgumentException(String.format("Can not find out record for given Id [%d] and domain class [%s].", id, domainClazz.toString()));
        }
        return entity;
    }

    @Transactional
    @Override
    public Object create(Object domainObj) {
        entityManager.persist(domainObj);
        entityManager.flush();
        return domainObj;
    }

    @Transactional
    @Override
    public Object update(Object domainObj) {
        entityManager.merge(domainObj);
        entityManager.flush();
        return domainObj;
    }

    @Transactional
    @Override
    public <D> D update(Class<D> domainClzz, int id, Map<String, Object> domainVals) {

        D domainBean = validateDomain(domainClzz, id);

        BeanMap domainBeanMap = new BeanMap(domainBean);

        domainVals.forEach((name, value) -> {
            domainBeanMap.put(name, value);
        });

        D updatedBean = entityManager.merge(domainBean);
        entityManager.flush();

        return updatedBean;
    }

    @Transactional
    @Override
    public void applyCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        // create intermediate table for multiple select/ref attribute
        InputType inputType = InputType.fromCode(admCiTypeAttr.getInputType());
        if (InputType.MultRef.equals(inputType) || InputType.MultSelDroplist.equals(inputType)) {
            String multInTableSql = admCiTypeAttr.retrieveJoinTableCreationSql();
            if (logger.isDebugEnabled()) {
                logger.debug(String.format("The applying CiTypeAttr muti intermedia table creation DDL SQL [%s]", multInTableSql));
            }
            entityManager.createNativeQuery(multInTableSql).executeUpdate();
        } else {
            String sql = admCiTypeAttr.genAlterSql();
            if (logger.isDebugEnabled()) {
                logger.debug(String.format("The applying CiTypeAttr DDL SQL [%s]", sql));
            }

            if (Strings.isNullOrEmpty(sql)) {
                return;
            }

            entityManager.createNativeQuery(sql).executeUpdate();
        }
    }

    @Transactional
    @Override
    public int applyCiType(AdmCiType admCiType) {
        String sql = genCreateCiTypeWithDefaultAttrSQL(admCiType);
        if (Strings.isNullOrEmpty(sql))
            return 0;
        if (logger.isDebugEnabled()) {
            logger.debug("The applying CiType DDL SQL [%s]", sql);
        }
        return entityManager.createNativeQuery(sql).executeUpdate();
    }

    @Transactional
    @Override
    public <D> D findEntityById(Class<D> domainClzz, Integer id) {
        return entityManager.find(domainClzz, id);
    }

    @Transactional
    @Override
    public void createDefaultCiTypeAttrs(AdmCiType admCiType) {
        for (AdmCiTypeAttr attr : retrieveDefaultAdmCiTypeAttrs(admCiType)) {
            create(attr);
        }
    }

    public String genCreateCiTypeWithDefaultAttrSQL(AdmCiType admCiType) {
        StringBuffer sb = new StringBuffer("CREATE TABLE ");
        sb.append(admCiType.getTableName()).append(" (");
        for (AdmCiTypeAttr attr : retrieveDefaultAdmCiTypeAttrs(admCiType)) {
            sb.append("`").append(attr.getPropertyName()).append("`").append(" ").append(attr.getPropertyType()).append(" ");
            if (!("datetime".equals(attr.getPropertyType()) || "date".equals(attr.getPropertyType()) || "text".equals(attr.getPropertyType()) || "longtext".equals(attr.getPropertyType()))) {
                sb.append("(").append(attr.getLength()).append(")").append(" ");
            }
            if ("guid".equals(attr.getPropertyName())) {
                sb.append(" NOT NULL ");
            } else {
                sb.append(" DEFAULT NULL ");
            }
            if (admCiType.getDescription() != null) {
                sb.append("COMMENT '").append(attr.getDescription()).append("'");
            }
            sb.append(", ");
        }
        sb.append("PRIMARY KEY (`guid`)");
        sb.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8");
        return sb.toString();
    }
    @Override
    public List<AdmCiTypeAttr> retrieveDefaultAdmCiTypeAttrs(AdmCiType admCiType) {
        Query createNativeQuery = entityManager.createNativeQuery("SELECT * FROM adm_ci_type_attr_base ");
        List baseAttrs = createNativeQuery.getResultList();
        List<AdmCiTypeAttr> ciTypeAttrs = retrieveBaseAttrs(baseAttrs, admCiType);
        return ciTypeAttrs;
    }

    public List<AdmCiTypeAttr> retrieveBaseAttrs(List<Object[]> baseAttrs, AdmCiType admCiType) {
        List<AdmCiTypeAttr> ciTypeAttrs = new ArrayList<AdmCiTypeAttr>();
        baseAttrs.stream().forEach(arr -> {
            AdmCiTypeAttr ciType = objectToCiTypeAttr(arr, admCiType);
            ciTypeAttrs.add(ciType);
        });
        return ciTypeAttrs;
    }

    public AdmCiTypeAttr objectToCiTypeAttr(Object[] arr, AdmCiType admCiType) {
        AdmCiTypeAttr admCiTypeAttr = new AdmCiTypeAttr();
        admCiTypeAttr.setCiTypeId(admCiType.getIdAdmCiType());
        admCiTypeAttr.setName((String) arr[2]);
        admCiTypeAttr.setDescription((String) arr[3]);
        admCiTypeAttr.setInputType((String) arr[4]);
        admCiTypeAttr.setPropertyName((String) arr[5]);
        admCiTypeAttr.setPropertyType((String) arr[6]);
        admCiTypeAttr.setLength((Integer) arr[7]);
        admCiTypeAttr.setReferenceId((Integer) arr[8]);
        admCiTypeAttr.setReferenceName((String) arr[9]);
        admCiTypeAttr.setReferenceType((Integer) arr[10]);
        admCiTypeAttr.setFilterRule((String) arr[11]);
        admCiTypeAttr.setSearchSeqNo((Integer) arr[12]);
        admCiTypeAttr.setDisplayType((Integer) arr[13]);
        admCiTypeAttr.setDisplaySeqNo((Integer) arr[14]);
        admCiTypeAttr.setEditIsNull((Integer) arr[15]);
        admCiTypeAttr.setEditIsOnly((Integer) arr[16]);
        admCiTypeAttr.setEditIsHiden((Integer) arr[17]);
        admCiTypeAttr.setEditIsEditable((Integer) arr[18]);
        admCiTypeAttr.setIsDefunct((Integer) arr[19]);
        admCiTypeAttr.setSpecialLogic((String) arr[20]);
        admCiTypeAttr.setStatus((String) arr[21]);
        admCiTypeAttr.setIsSystem((Integer) arr[22]);
        admCiTypeAttr.setIsAccessControlled((Integer) arr[23]);
        admCiTypeAttr.setIsAuto((Integer) arr[24]);
        admCiTypeAttr.setAutoFillRule((String) arr[25]);
        admCiTypeAttr.setRegularExpressionRule((String) arr[26]);
        admCiTypeAttr.setIsRefreshable(((Integer) arr[27]));
        return admCiTypeAttr;
    }
}
