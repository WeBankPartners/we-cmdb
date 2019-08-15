package com.webank.cmdb.service.impl;

import java.util.HashMap;
import java.util.Map;

import com.webank.cmdb.domain.AdmIntegrateTemplate;
import com.webank.cmdb.domain.AdmIntegrateTemplateAlias;
import com.webank.cmdb.domain.AdmIntegrateTemplateAliasAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplateRelation;

public class IntegrationTemplateCloneHelper {

    private Map<Object, Object> clonedMap = new HashMap<>();

    public AdmIntegrateTemplate deepClone(AdmIntegrateTemplate template) {
        AdmIntegrateTemplate cloneTemplate = new AdmIntegrateTemplate();
        clonedMap.put(template, cloneTemplate);

        cloneTemplate.setCiTypeId(template.getCiTypeId());
        cloneTemplate.setDes(template.getDes());
        cloneTemplate.setName(template.getName());
        if (template.getAdmIntegrateTemplateAlias() != null) {
            for (AdmIntegrateTemplateAlias alias : template.getAdmIntegrateTemplateAlias()) {
                cloneTemplate.addAdmIntegrateTemplateAlia(getOrClone(alias));
            }
        }
        return cloneTemplate;
    }

    private AdmIntegrateTemplateAlias deepClone(AdmIntegrateTemplateAlias alias) {
        AdmIntegrateTemplateAlias cloneAlias = new AdmIntegrateTemplateAlias();
        clonedMap.put(alias, cloneAlias);

        cloneAlias.setAdmCiType(alias.getAdmCiType());
        cloneAlias.setAlias(alias.getAlias());
        if (alias.getParentIntegrateTemplateRelation() != null) {
            cloneAlias.setParentIntegrateTemplateRelation(getOrClone(alias.getParentIntegrateTemplateRelation()));
        }
        if (alias.getChildIntegrateTemplateRelations() != null) {
            for (AdmIntegrateTemplateRelation relation : alias.getChildIntegrateTemplateRelations()) {
                cloneAlias.addChildIntegrateTemplateRelation(getOrClone(relation));
            }
        }
        if (alias.getAdmIntegrateTemplateAliasAttrs() != null) {
            for (AdmIntegrateTemplateAliasAttr attribute : alias.getAdmIntegrateTemplateAliasAttrs()) {
                cloneAlias.addAdmIntegrateTemplateAliasAttr(getOrClone(attribute));
            }
        }
        return cloneAlias;
    }

    private AdmIntegrateTemplateRelation deepClone(AdmIntegrateTemplateRelation relation) {
        AdmIntegrateTemplateRelation cloneRelation = new AdmIntegrateTemplateRelation();
        clonedMap.put(relation, cloneRelation);

        cloneRelation.setAdmCiTypeAttr(relation.getAdmCiTypeAttr());
        cloneRelation.setIsReferedFromParent(relation.getIsReferedFromParent());
        cloneRelation.setChildRefAttrId(relation.getChildRefAttrId());
        if (relation.getParentIntegrateTemplateAlias() != null) {
            cloneRelation.setParentIntegrateTemplateAlias(getOrClone(relation.getParentIntegrateTemplateAlias()));
        }
        if (relation.getChildIntegrateTemplateAlias() != null) {
            cloneRelation.setChildIntegrateTemplateAlias(getOrClone(relation.getChildIntegrateTemplateAlias()));
        }
        return cloneRelation;
    }

    private AdmIntegrateTemplateAliasAttr deepClone(AdmIntegrateTemplateAliasAttr attr) {
        AdmIntegrateTemplateAliasAttr cloneAttr = new AdmIntegrateTemplateAliasAttr();
        clonedMap.put(attr, cloneAttr);

        cloneAttr.setAdmCiTypeAttr(attr.getAdmCiTypeAttr());
        cloneAttr.setIsCondition(attr.getIsCondition());
        cloneAttr.setIsDisplayed(attr.getIsDisplayed());
        cloneAttr.setMappingName(attr.getMappingName());
        cloneAttr.setKeyName(attr.getKeyName());
        cloneAttr.setSeqNo(attr.getSeqNo());
        cloneAttr.setCiTypeAttrId(attr.getCiTypeAttrId());
        cloneAttr.setCnAlias(attr.getCnAlias());
        cloneAttr.setFilter(attr.getFilter());
        cloneAttr.setSysAttr(attr.getSysAttr());
        return cloneAttr;
    }

    @SuppressWarnings("unchecked")
    private <T> T getOrClone(T object) {
        if (clonedMap.containsKey(object)) {
            return (T) clonedMap.get(object);
        }
        if (object instanceof AdmIntegrateTemplate) {
            return (T) deepClone((AdmIntegrateTemplate) object);
        }
        if (object instanceof AdmIntegrateTemplateAlias) {
            return (T) deepClone((AdmIntegrateTemplateAlias) object);
        }
        if (object instanceof AdmIntegrateTemplateRelation) {
            return (T) deepClone((AdmIntegrateTemplateRelation) object);
        }
        if (object instanceof AdmIntegrateTemplateAliasAttr) {
            return (T) deepClone((AdmIntegrateTemplateAliasAttr) object);
        }
        throw new UnsupportedOperationException(String.format("Cloning %s is unsupported.", object.getClass()));
    }

}
