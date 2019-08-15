package com.webank.cmdb.repository;

import java.util.LinkedList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.transaction.Transactional;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmCiType;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class EntityTest {
    @Autowired
    private EntityManager entityManager;

    @Transactional
    @Test
    @Ignore
    public void queryEntity() {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<AdmCiType> query = cb.createQuery(AdmCiType.class);
        Root<AdmCiType> root = query.from(AdmCiType.class);
        Join<AdmCiType, AdmBasekeyCode> layer = root.<AdmCiType, AdmBasekeyCode>join("layerCode");
        List<Predicate> predicates = new LinkedList<>();

        predicates.add(cb.equal(layer.get("code"), "Running Layer"));
        query.where(predicates.toArray(new Predicate[0]));
        TypedQuery<AdmCiType> typedQuery = entityManager.createQuery(query);
        List<AdmCiType> ciTypes = typedQuery.getResultList();
        System.out.println(ciTypes.get(1)
                .getSeqNo());

    }
}
