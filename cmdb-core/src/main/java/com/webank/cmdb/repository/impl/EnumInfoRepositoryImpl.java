package com.webank.cmdb.repository.impl;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Expression;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.JoinType;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.dto.EnumInfo;
import com.webank.cmdb.dto.EnumInfoRequest;
import com.webank.cmdb.repository.EnumInfoRepository;
import com.webank.cmdb.util.JpaQueryUtils;

@Repository
@SuppressWarnings("unchecked")
public class EnumInfoRepositoryImpl implements EnumInfoRepository {
    private static final String SEL_DESCRIPTION = "description";
    private static final String SEL_GROUP_NAME = "groupName";
    private static final String SEL_GROUP_CODE = "groupCode";
    private static final String SEL_GROUP_CODE_ID = "groupCodeId";
    private static final String SEL_VALUE = "value";
    private static final String SEL_CODE = "code";
    private static final String SEL_CODE_ID = "codeId";
    private static final String SEL_CAT_NAME = "catName";
    private static final String SEL_CAT_ID = "catId";
    @Autowired
    private EntityManager entityManager;

    @Override
    public int getTotalRowCount(EnumInfoRequest request) {
        List<Object[]> rawResults = doQuery(request, true);
        return convertResultToInteger(rawResults);
    }

    private int convertResultToInteger(List rawResults) {
        String strVal = rawResults.get(0).toString();
        return Integer.valueOf(strVal);
    }

    @Override
    public List<EnumInfo> queryEnumInfo(EnumInfoRequest request) {
        List<Object[]> rawResults = doQuery(request, false);
        return convertResultToEnumInfos(rawResults);

    }

    private List<Object[]> doQuery(EnumInfoRequest request, boolean isSelRowCount) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery query = cb.createQuery();
        Root<AdmBasekeyCode> codeRoot = query.from(AdmBasekeyCode.class);
        Join grp = codeRoot.join("groupBasekeyCode", JoinType.LEFT);
        Join cat = codeRoot.join("admBasekeyCat", JoinType.LEFT);
        Map<String, Expression> selectionMap = ImmutableMap.<String, Expression>builder()
                .put(SEL_CAT_ID, cat.get("idAdmBasekeyCat"))
                .put(SEL_CAT_NAME, cat.get("catName"))
                .put(SEL_CODE_ID, codeRoot.get("idAdmBasekey"))
                .put(SEL_CODE, codeRoot.get(SEL_CODE))
                .put(SEL_VALUE, codeRoot.get(SEL_VALUE))
                .put(SEL_GROUP_CODE_ID, grp.get("idAdmBasekey"))
                .put(SEL_GROUP_CODE, grp.get(SEL_CODE))
                .put(SEL_GROUP_NAME, grp.get(SEL_VALUE))
                .put(SEL_DESCRIPTION, codeRoot.get("codeDescription"))
                .build();

        if (!isSelRowCount) {
            selectForEnumInfo(query, selectionMap);
        } else {
            query.select(cb.count(codeRoot));
        }

        List<Predicate> predicates = new LinkedList<>();
        if (!Strings.isNullOrEmpty(request.getFilters().getDescription())) {
            predicates.add(cb.like(cb.upper(selectionMap.get(SEL_DESCRIPTION)), "%" + request.getFilters().getDescription().toUpperCase() + "%"));
        }
        if (!Strings.isNullOrEmpty(request.getFilters().getGroupName())) {
            predicates.add(cb.like(cb.upper(selectionMap.get(SEL_GROUP_NAME)), "%" + request.getFilters().getGroupName().toUpperCase() + "%"));
        }
        if (!Strings.isNullOrEmpty(request.getFilters().getCode())) {
            predicates.add(cb.like(cb.upper(selectionMap.get(SEL_CODE)), "%" + request.getFilters().getCode().toUpperCase() + "%"));
        }
        if (!Strings.isNullOrEmpty(request.getFilters().getCatName())) {
            predicates.add(cb.like(cb.upper(selectionMap.get(SEL_CAT_NAME)), "%" + request.getFilters().getCatName().toUpperCase() + "%"));
        }
        if (!Strings.isNullOrEmpty(request.getFilters().getValue())) {
            predicates.add(cb.like(cb.upper(selectionMap.get(SEL_VALUE)), "%" + request.getFilters().getValue().toUpperCase() + "%"));
        }

        if (predicates.size() > 0) {
            query.where(cb.and(predicates.toArray(new Predicate[0])));
        }

        if (!isSelRowCount) {
            JpaQueryUtils.applySorting(request.getSorting(), cb, query, selectionMap);
        }

        TypedQuery typedQuery = entityManager.createQuery(query);

        if (!isSelRowCount && request.isPaging()) {
            JpaQueryUtils.applyPaging(request.isPaging(), request.getPageable(), typedQuery);
        }

        List<Object[]> result = typedQuery.getResultList();

        return result;
    }

    private void selectForEnumInfo(CriteriaQuery query, Map<String, Expression> selectionMap) {
        query.multiselect(selectionMap.get(SEL_CAT_ID), selectionMap.get(SEL_CAT_NAME), selectionMap.get(SEL_CODE_ID), selectionMap.get(SEL_CODE), selectionMap.get(SEL_VALUE), selectionMap.get(SEL_GROUP_CODE_ID),
                selectionMap.get(SEL_GROUP_CODE), selectionMap.get(SEL_GROUP_NAME), selectionMap.get(SEL_DESCRIPTION));
    }

    private List<EnumInfo> convertResultToEnumInfos(List<Object[]> result) {
        List<EnumInfo> enumInfos = new LinkedList<>();
        result.forEach(x -> {
            EnumInfo ei = new EnumInfo();
            ei.setCatId(Integer.valueOf(x[0].toString()));
            ei.setCatName(x[1] != null ? String.valueOf(x[1]) : null);
            ei.setCodeId(Integer.valueOf(x[2].toString()));
            ei.setCode(x[3] != null ? String.valueOf(x[3]) : null);
            ei.setValue(x[4] != null ? String.valueOf(x[4]) : null);
            ei.setGroupCodeId(x[5] != null ? Integer.valueOf(x[5].toString()) : null);
            ei.setGroupCode(x[6] != null ? String.valueOf(x[6]) : null);
            ei.setGroupName(x[7] != null ? String.valueOf(x[7]) : null);
            ei.setDescription(x[8] != null ? String.valueOf(x[8]) : null);
            enumInfos.add(ei);
        });
        return enumInfos;
    }

}
