package com.webank.cmdb.service;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import java.util.Collections;

public class CiTypeServiceImplTest extends AbstractBaseControllerTest {
    @Autowired
    CiTypeService ciTypeService;
    @Autowired
    StaticDtoService staticDtoService;
    @Autowired
    private EntityManager entityManager;

    private int appliedCiTypeId;
    private int appliedAttrId;
    private int unappliedCiTypeId;
    private int refAttrId;

    @Transactional
    @Test
    public void testCreateCiDataShouldIgnoreAutoFillRuleForNotCreatedCiAttr() {
        givenAppliedCiTypeAndAttr();
        givenUnappliedCiTypeAndRef();
        givenAutoFillRuleForUnappliedAttrReferencingAppliedCiAttr();

        String guid = ciService.create(appliedCiTypeId, new ImmutableMap.Builder<String, Object>()
                .put("code", "code")
                .put("appliedAttr", "appliedAttr")
                .build());

        Assert.assertNotNull(guid);
    }

    private void givenAppliedCiTypeAndAttr() {
        appliedCiTypeId = givenCiType("appliedCiTypeName");
        appliedAttrId = givenCiAttrForType(appliedCiTypeId, "appliedAttr", null);
        applyCiType(appliedCiTypeId);
    }

    private void givenUnappliedCiTypeAndRef() {
        unappliedCiTypeId = givenCiType("unappliedCiTypeName");
        refAttrId = givenCiRefForType(unappliedCiTypeId, "ref", appliedCiTypeId);
    }

    private void givenAutoFillRuleForUnappliedAttrReferencingAppliedCiAttr() {
        String autoFillRuleFromUnappliedCiAttrToAppliedCiType = buildAutoFillRule();
        givenCiAttrForType(unappliedCiTypeId, "unappliedAttr", autoFillRuleFromUnappliedCiAttrToAppliedCiType);
    }

    private int givenCiType(String name) {
        CiTypeDto ciTypeDto = new CiTypeDto();
        ciTypeDto.setName(name);
        ciTypeDto.setTableName(name);
        ciTypeDto.setStatus(CiStatus.NotCreated.getCode());

        CiTypeDto result = ciTypeService.addCiType(ciTypeDto);
        entityManager.clear();

        return result.getCiTypeId();
    }

    private int givenCiAttrForType(int ciTypeId, String name, String autoFillRule) {
        CiTypeAttrDto attrDto = new CiTypeAttrDto();
        attrDto.setCiTypeId(ciTypeId);
        attrDto.setName(name);
        attrDto.setPropertyName(name);
        attrDto.setStatus(CiStatus.NotCreated.getCode());
        attrDto.setInputType("text");
        attrDto.setPropertyType("varchar");
        attrDto.setLength(32);
        attrDto.setIsSystem(false);
        attrDto.setIsNullable(true);
        attrDto.setIsAuto(autoFillRule != null);
        attrDto.setAutoFillRule(autoFillRule);

        CiTypeAttrDto result = staticDtoService.create(CiTypeAttrDto.class, Collections.singletonList(attrDto)).get(0);
        entityManager.clear();

        return result.getCiTypeAttrId();
    }

    private int givenCiRefForType(int ciTypeId, String name, int referenceTypeId) {
        CiTypeAttrDto attrDto = new CiTypeAttrDto();
        attrDto.setCiTypeId(ciTypeId);
        attrDto.setName(name);
        attrDto.setPropertyName(name);
        attrDto.setStatus(CiStatus.NotCreated.getCode());
        attrDto.setInputType("ref");
        attrDto.setPropertyType("varchar");
        attrDto.setLength(15);
        attrDto.setReferenceId(referenceTypeId);
        attrDto.setReferenceType(27);
        attrDto.setReferenceName("属于");
        attrDto.setIsSystem(false);
        attrDto.setIsNullable(true);

        CiTypeAttrDto result = staticDtoService.create(CiTypeAttrDto.class, Collections.singletonList(attrDto)).get(0);
        entityManager.clear();

        return result.getCiTypeAttrId();
    }

    private void applyCiType(int ciTypeId) {
        ciTypeService.applyCiType(Collections.singletonList(ciTypeId));
        entityManager.clear();
    }

    private String buildAutoFillRule() {
        return "[{\"type\":\"rule\",\"value\":\"[" +
                "{\\\"ciTypeId\\\":" + unappliedCiTypeId + "}," +
                "{\\\"ciTypeId\\\":" + appliedCiTypeId + ",\\\"parentRs\\\":{\\\"attrId\\\":" + refAttrId + ",\\\"isReferedFromParent\\\":1}}," +
                "{\\\"ciTypeId\\\":" + appliedCiTypeId + ",\\\"parentRs\\\":{\\\"attrId\\\":" + appliedAttrId + ",\\\"isReferedFromParent\\\":1}}" +
                "]\"}]";
    }
}
