package com.webank.cmdb.dynamicEntity;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.persistence.EntityManager;

import org.apache.commons.beanutils.BeanMap;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.constant.EntityRelationship;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.service.CiService;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class MultiValueFeildOperationUtils {

    public static DynamicEntityMeta createDynamicEntityMetaForMultiSelect(AdmCiTypeAttr multiSelAttr) {
        DynamicEntityMeta meta = new DynamicEntityMeta();
        AdmCiType ciType = multiSelAttr.getAdmCiType();
        meta.setType(DynamicEntityType.MultiSelIntermedia);
        String intermediaTableName = multiSelAttr.retrieveJoinTalbeName();
        meta.setQulifiedName(DynamicEntityUtils.getEntityQuanlifiedName(intermediaTableName));
        meta.setTableName(intermediaTableName);
        meta.setCiTypeId(ciType.getIdAdmCiType());

        SortedMap<String, FieldNode> fieldNodeMap = new TreeMap<String, FieldNode>();
        FieldNode fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "id", Integer.class, "id", true);
        fieldNodeMap.put("id", fieldNode);

        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "from_guid", String.class, "from_guid");
        fieldNodeMap.put("from_guid", fieldNode);

        String refCiTypeDesc = DynamicEntityUtils.getClassDesc(DynamicEntityUtils.getEntityQuanlifiedName(ciType.getTableName()));
        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "from_guid_guid", "from_guid", true, refCiTypeDesc, EntityRelationship.ManyToOne, null);
        fieldNodeMap.put("from_guid_guid", fieldNode);

        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "to_code", Integer.class, "to_code");
        fieldNodeMap.put("to_code", fieldNode);

        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "seq_no", Integer.class, "seq_no");
        fieldNodeMap.put("seq_no", fieldNode);
        meta.setFieldMap(fieldNodeMap);
        return meta;
    }

    public static DynamicEntityMeta createDynamicEntityMetaForMultiReference(AdmCiTypeAttr multiSelAttr) {
        DynamicEntityMeta meta = new DynamicEntityMeta();
        AdmCiType ciType = multiSelAttr.getAdmCiType();
        meta.setType(DynamicEntityType.MultiRefIntermedia);
        String intermediaTableName = multiSelAttr.retrieveJoinTalbeName();
        meta.setQulifiedName(DynamicEntityUtils.getEntityQuanlifiedName(intermediaTableName));
        meta.setTableName(intermediaTableName);
        meta.setCiTypeId(ciType.getIdAdmCiType());

        SortedMap<String, FieldNode> fieldNodeMap = new TreeMap<String, FieldNode>();
        FieldNode fieldNode = new FieldNode(DynamicEntityType.MultiRefIntermedia, null, "id", Integer.class, "id", true);
        fieldNodeMap.put("id", fieldNode);

        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "from_guid", String.class, "from_guid");
        fieldNodeMap.put("from_guid", fieldNode);

        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "to_guid", String.class, "to_guid");
        fieldNodeMap.put("to_guid", fieldNode);

        fieldNode = new FieldNode(DynamicEntityType.MultiSelIntermedia, null, "seq_no", Integer.class, "seq_no");
        fieldNodeMap.put("seq_no", fieldNode);
        meta.setFieldMap(fieldNodeMap);
        return meta;
    }

    public static Map<String, Object> convertMultiValueFieldsForCICreation(EntityManager entityManager, int ciTypeId, Map<String, Object> ci, String guid, AdmCiTypeAttrRepository ciTypeAttrRepository, CiService ciService) {
        Map<String, Object> convertedCi = new HashMap<>();
        ci.forEach((name, value) -> {
            if (value instanceof List) {
                AdmCiTypeAttr attr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(ciTypeId, name);
                if (InputType.MultSelDroplist.getCode().equals(attr.getInputType())) {
                    List codes = (List) value;
                    DynamicEntityMeta multiSelMeta = ciService.getMultSelectMetaMap().get(attr.getIdAdmCiTypeAttr());

                    Set multValSet = new HashSet();
                    for (int i = 0; i < codes.size(); i++) {
                        Integer codeId = (Integer) codes.get(i);
                        ImmutableMap multSelData = ImmutableMap.<String, Object>builder().put("from_guid", guid).put("to_code", codeId).put("seq_no", i + 1).build();
                        DynamicEntityHolder multSelectEntityHolder = DynamicEntityHolder.createDynamicEntityBean(multiSelMeta, multSelData);
                        multValSet.add(multSelectEntityHolder.getEntityObj());
                    }
                    convertedCi.put(name, multValSet);
                } else if (InputType.MultRef.getCode().equals(attr.getInputType())) {
                    List cis = (List) value;

                    Set multValSet = new HashSet();
                    for (int i = 0; i < cis.size(); i++) {
                        String refGuid = (String) cis.get(i);
                        Object refEntityBean = ciService.getCiBeanObject(entityManager, attr.getReferenceId(), refGuid);
                        multValSet.add(refEntityBean);
                    }
                    convertedCi.put(name, multValSet);
                }
            } else {
                convertedCi.put(name, value);
            }
        });
        return convertedCi;
    }

    public static void processMultValueFieldsForCloneCi(EntityManager entityManager, DynamicEntityMeta entityMeta, String newGuid, BeanMap fromBeanMap, DynamicEntityHolder toEntityHolder, CiService ciService) {
        Collection<FieldNode> fieldNodes = entityMeta.getAllFieldNodes(true);
        fieldNodes.forEach(fn -> {
            if (DynamicEntityType.MultiSelection.equals(fn.getEntityType())) {
                int attrId = fn.getAttrId();
                DynamicEntityMeta multSelMeta = ciService.getMultSelectMetaMap().get(attrId);
                Set multSelSet = (Set) fromBeanMap.get(fn.getName());
                if (multSelSet != null ) {
                    Set newMultiSet = new HashSet();
                    multSelSet.forEach(item -> {
                        DynamicEntityHolder newMultiSelItem = DynamicEntityHolder.cloneDynamicEntityBean(multSelMeta, item);
                        newMultiSelItem.put("from_guid", newGuid);
                        // newMultiSelItem.put("from_guid_guid", toEntityHolder.getEntityObj());
                        entityManager.persist(newMultiSelItem.getEntityObj());
                        newMultiSet.add(newMultiSelItem.getEntityObj());
                    });
                    toEntityHolder.put(fn.getName(), newMultiSet);
                }
            } else if (DynamicEntityType.MultiReference.equals(fn.getEntityType())) {
                Set newMultiRefSet = new HashSet();
                Set fromMultiRefSet = (Set) fromBeanMap.get(fn.getName());
                if (fromMultiRefSet != null && !fromMultiRefSet.isEmpty()) {
                    newMultiRefSet.addAll(fromMultiRefSet);
                }

                toEntityHolder.put(fn.getName(), newMultiRefSet);
            }
        });
    }

    public static Collection<FieldNode> ClearMultValueFieldsForDiscard(EntityManager entityManager, DynamicEntityHolder ciHolder, DynamicEntityMeta meta) {
        Collection<FieldNode> fieldNodes = meta.getAllFieldNodes(true);
        for (FieldNode fn : fieldNodes) {
            if (DynamicEntityType.MultiSelection.equals(fn.getEntityType())) {
                Set multSelSet = (Set) ciHolder.get(fn.getName());
                if (multSelSet != null && !multSelSet.isEmpty()) {
                    multSelSet.forEach(item -> {
                        entityManager.remove(item);
                    });
                }
                
                if(multSelSet != null) {
                    multSelSet.clear();
                }
            }
        }
        return fieldNodes;
    }

    public static void rollbackMultValueFieldsForDiscard(EntityManager entityManager, String guid, DynamicEntityHolder ciHolder, Collection<FieldNode> fieldNodes, DynamicEntityHolder parentCiHolder) {
        for (FieldNode fn : fieldNodes) {
            if (DynamicEntityType.MultiSelection.equals(fn.getEntityType())) {
                Set multSelSet = (Set) parentCiHolder.get(fn.getName());
                if (multSelSet != null && !multSelSet.isEmpty()) {
                    for (Object item : multSelSet) {
                        BeanMap mulSelItemMap = new BeanMap(item);
                        mulSelItemMap.put("from_guid", guid);
                        mulSelItemMap.put("from_guid_guid", ciHolder.getEntityObj());
                        entityManager.merge(item);
                    }
                }
            } 
        }
    }

}
