package com.webank.cmdb.dynamicEntity;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.constant.EntityRelationship;
import com.webank.cmdb.constant.FieldType;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.support.exception.AttributeNotFoundException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import org.apache.logging.log4j.util.Strings;

/**
 * Hold meta information for dynamic entity
 * 
 * @author graychen
 *
 */

public class DynamicEntityMeta {
    private DynamicEntityType type = DynamicEntityType.CI;
    private Integer ciTypeId;
    private String qulifiedName;
    private String tableName;
    private SortedMap<String, FieldNode> fieldMap = new TreeMap<String, FieldNode>();

    //attribute id -> FieldNode, lazy creation
    private Map<Integer,FieldNode> attrIdfieldMap;
    private Class<?> entityClazz;
    private String name = Strings.EMPTY;

    DynamicEntityMeta() {
    }

    public static DynamicEntityMeta createForMultSel(AdmCiTypeAttr multiSelAttr) {
        if (!InputType.MultSelDroplist.getCode().equals(multiSelAttr.getInputType())) {
            throw new IllegalArgumentException(String.format("The given attribute [%d] is not multiple selection.", multiSelAttr.getIdAdmCiTypeAttr()));
        }

        Integer codeId = multiSelAttr.getReferenceId();
        if (codeId == null) {
            throw new ServiceException(String.format("Failed to create intermediate entity meta for attribute [%d], can not find out code [%d]", multiSelAttr.getIdAdmCiTypeAttr(), codeId));
        }

        DynamicEntityMeta meta = MultiValueFeildOperationUtils.createDynamicEntityMetaForMultiSelect(multiSelAttr);

        return meta;
    }

    public static DynamicEntityMeta createForMultRef(AdmCiTypeAttr multiSelAttr) {
        if (!InputType.MultRef.getCode().equals(multiSelAttr.getInputType())) {
            throw new IllegalArgumentException(String.format("The given attribute [%d] is not multiple reference.", multiSelAttr.getIdAdmCiTypeAttr()));
        }

        DynamicEntityMeta meta = MultiValueFeildOperationUtils.createDynamicEntityMetaForMultiReference(multiSelAttr);

        return meta;
    }

    public static DynamicEntityMeta create(AdmCiType ciType, Map<Integer, List<AdmCiTypeAttr>> referedAttrMap, AdmCiTypeRepository ciTypeRepository) {
        DynamicEntityMeta meta = new DynamicEntityMeta();
        meta.type = DynamicEntityType.CI;
        meta.qulifiedName = DynamicEntityUtils.getEntityQuanlifiedName(ciType.getTableName());
        meta.tableName = ciType.getTableName();
        meta.ciTypeId = ciType.getIdAdmCiType();
        meta.name = ciType.getName();

        final AtomicInteger curDisplaySeqNo = new AtomicInteger(-1);
        ciType.getAdmCiTypeAttrs().forEach(attr -> {
            if (!CiStatus.shouldBeLoadedForDynamicEntity(CiStatus.fromCode(attr.getStatus()))) {
                return;
            }

            String column = attr.getPropertyName();
            String propertyType = attr.getPropertyType();
            FieldType fieldType = FieldType.fromCode(propertyType);
            if (FieldType.None.equals(fieldType)) {
                throw new ServiceException(String.format("Can not find out class type of property type [%s] for CI type [%d]", propertyType, ciType.getIdAdmCiType()));
            }
            Class<?> typeClazz = fieldType.getType();
            FieldNode fieldNode;
            String fieldName;
            if (InputType.Reference.getCode().equals(attr.getInputType())) {// ManyToOne
                if (attr.getReferenceId() == null) {
                    throw new ServiceException(String.format("Internal error happen. (referenceId is null for attr [%d])", attr.getIdAdmCiTypeAttr()));
                }
                int ciTypeId = attr.getReferenceId();
                AdmCiType refCiType = ciTypeRepository.getOne(ciTypeId);
                fieldName = DynamicEntityUtils.getJoinFieldName(ciType, attr, true);
                String refCiTypeDesc = DynamicEntityUtils.getClassDesc(DynamicEntityUtils.getEntityQuanlifiedName(refCiType.getTableName()));
                fieldNode = new FieldNode(DynamicEntityType.CI, attr.getIdAdmCiTypeAttr(), fieldName, column, true, refCiTypeDesc, EntityRelationship.ManyToOne, null);
                meta.fieldMap.put(fieldName, fieldNode);

                fieldName = column;
                fieldNode = new FieldNode(DynamicEntityType.CI, attr.getIdAdmCiTypeAttr(), fieldName, typeClazz, column);
                if (CmdbConstants.DEFAULT_FIELD_GUID.equals(column)) {
                    fieldNode.setId(true);
                }
                meta.fieldMap.put(fieldName, fieldNode);
            } else if (InputType.MultSelDroplist.getCode().equals(attr.getInputType())) {
                String intermediaTableName = attr.retrieveJoinTalbeName();
                String qulifiedName = DynamicEntityUtils.getEntityQuanlifiedName(intermediaTableName);
                String refCiTypeDesc = DynamicEntityUtils.getClassDesc(qulifiedName);

                fieldNode = new FieldNode(DynamicEntityType.MultiSelection, attr.getIdAdmCiTypeAttr(), column, column, true, refCiTypeDesc, EntityRelationship.OneToMany, "from_guid_guid");
                meta.fieldMap.put(column, fieldNode);
            } else if (InputType.MultRef.getCode().equals(attr.getInputType())) {
                int ciTypeId = attr.getReferenceId();
                AdmCiType refCiType = ciTypeRepository.getOne(ciTypeId);
                String refCiTypeDesc = DynamicEntityUtils.getClassDesc(DynamicEntityUtils.getEntityQuanlifiedName(refCiType.getTableName()));
                fieldName = DynamicEntityUtils.getJoinFieldName(ciType, attr, true);
                fieldNode = new FieldNode(DynamicEntityType.MultiReference, attr.getIdAdmCiTypeAttr(), fieldName, column, true, refCiTypeDesc, EntityRelationship.ManyToMany, null);
                fieldNode.setJoinTable(attr.retrieveJoinTalbeName());
                meta.fieldMap.put(fieldName, fieldNode);
            } else {
                fieldName = column;
                fieldNode = new FieldNode(DynamicEntityType.CI, attr.getIdAdmCiTypeAttr(), fieldName, typeClazz, column);
                if (CmdbConstants.DEFAULT_FIELD_GUID.equals(column)) {
                    fieldNode.setId(true);
                }
                meta.fieldMap.put(fieldName, fieldNode);
            }

            if (attr.getDisplayType() != null && attr.getDisplayType() == 1 && (curDisplaySeqNo.get() == -1 || curDisplaySeqNo.get() > attr.getDisplaySeqNo())) {
                curDisplaySeqNo.set(attr.getDisplaySeqNo());
            }
        });

        // OneToMany field
        if (referedAttrMap.get(ciType.getIdAdmCiType()) != null) {
            List<AdmCiTypeAttr> attrs = referedAttrMap.get(ciType.getIdAdmCiType());
            attrs.forEach(attr -> {
                if (!CiStatus.shouldBeLoadedForDynamicEntity(CiStatus.fromCode(attr.getStatus()))) {
                    return;
                }
                if (InputType.Reference.getCode().equals(attr.getInputType())) {
                    String fieldName = DynamicEntityUtils.getJoinFieldName(ciType, attr, false);
                    String mapperByField = DynamicEntityUtils.getJoinMapperByFieldName(attr);
                    FieldNode fieldNode = new FieldNode(DynamicEntityType.CI, attr.getIdAdmCiTypeAttr(), fieldName, null, true, DynamicEntityUtils.getClassDesc(DynamicEntityUtils.getEntityQuanlifiedName(attr.getAdmCiType().getTableName())),
                            EntityRelationship.OneToMany, mapperByField);
                    meta.fieldMap.put(fieldName, fieldNode);
                } else if (InputType.MultRef.getCode().equals(attr.getInputType())) {
                    String fieldName = DynamicEntityUtils.getJoinFieldName(ciType, attr, false);
                    String mapperByField = DynamicEntityUtils.getJoinMapperByFieldName(attr);
                    FieldNode fieldNode = new FieldNode(DynamicEntityType.MultiReference, attr.getIdAdmCiTypeAttr(), fieldName, null, true,
                            DynamicEntityUtils.getClassDesc(DynamicEntityUtils.getEntityQuanlifiedName(attr.getAdmCiType().getTableName())), EntityRelationship.ManyToMany, mapperByField);
                    meta.fieldMap.put(fieldName, fieldNode);
                }
            });
        }

        return meta;
    }

    public static class ColumnInfo {
        private String name;
        private String type;

        public ColumnInfo(String name, String type) {
            this.name = name;
            this.type = type;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

    }

    public List<String> getAttrs() {
        List<String> attrs = new LinkedList<>();
        fieldMap.forEach((k, v) -> {
            if (!v.isJoinNode() || DynamicEntityType.MultiReference.equals(v.getEntityType()) || DynamicEntityType.MultiSelection.equals(v.getEntityType())) {
                attrs.add(k);
            }
        });

        return attrs;
    }

    public FieldNode getFieldNode(String fieldName) {
        return fieldMap.get(fieldName);
    }

    public FieldNode getFieldNode(int attrId){
        if(attrIdfieldMap == null){
            attrIdfieldMap = new HashMap<>();
            fieldMap.forEach((name,node)->{
                attrIdfieldMap.put(node.getAttrId(),node);
            });
        }
        return attrIdfieldMap.get(attrId);
    }

    public Collection<FieldNode> getAllFieldNodes(boolean includeJoinNode) {
        List<FieldNode> fieldNodes = new LinkedList<>();
        fieldMap.values().forEach(x -> {
            if (DynamicEntityType.MultiSelection.equals(x.getEntityType()) || DynamicEntityType.MultiReference.equals(x.getEntityType())) {
                fieldNodes.add(x);
            } else if (!includeJoinNode && x.isJoinNode()) {
                return;
            } else {
                fieldNodes.add(x);
            }
        });
        return fieldNodes;

    }

    public Collection<String> getFieldNames() {
        return fieldMap.keySet();
    }

    public boolean hasField(String field) {
        return fieldMap.containsKey(field);
    }

    public String getQulifiedName() {
        return qulifiedName;
    }

    public void setQulifiedName(String qulifiedName) {
        this.qulifiedName = qulifiedName;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Class<?> getEntityClazz() {
        return entityClazz;
    }

    public void setEntityClazz(Class<?> entityClazz) {
        this.entityClazz = entityClazz;
    }

    public Class<?> getAttrType(String attrName) {
        FieldNode fieldNode = fieldMap.get(attrName);
        if (fieldNode != null)
            return fieldNode.getType();
        else
            throw new AttributeNotFoundException(String.format("Attribute:[%s] can not be found for %s", attrName, qulifiedName));
    }

    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public DynamicEntityType getType() {
        return type;
    }

    public void setType(DynamicEntityType type) {
        this.type = type;
    }

    public void setFieldMap(SortedMap<String, FieldNode> fieldMap) {
        this.fieldMap = fieldMap;
    }

    public String getName() {
        if(Strings.isNotEmpty(name)){
            return name;
        }else{
            return tableName;
        }
    }

    public void setName(String name) {
        this.name = name;
    }
}
