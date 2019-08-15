package com.webank.cmdb.dynamicEntity;

import java.util.Set;

import org.apache.commons.lang3.builder.ToStringBuilder;

import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.constant.EntityRelationship;

public class FieldNode {
    DynamicEntityType entityType = DynamicEntityType.CI;
    /*
     * For not join field, name is the column name For ManyToOne field, name is the
     * column name For OneToMany field, name is owner table name + '_' + column name
     * ( List type )
     */
    private String name;
    // be null for join field
    private Class<?> type;
    // column will be null for OneToMany join
    private String column;
    private boolean isId = false;
    private boolean isJoinNode = false;
    // the type desc of dynamic entity class (for joining operation)
    private String typeDesc;
    // there are ManyToOne or OneToMany relationship for join node
//	private boolean isManyToOne = true;
    // for OneToMany join
    private String mappedBy;
    // Intermediate table field node dose not have attrId
    private Integer attrId;
    private EntityRelationship entityRelationship;
    // joinTable for ManyToMany relationship
    private String joinTable;

    public FieldNode(DynamicEntityType entityType, Integer attrId, String name, Class<?> type, String column) {
        this(entityType, attrId, name, type, column, false);
    }

    public FieldNode(DynamicEntityType entityType, Integer attrId, String name, Class<?> type, String column, boolean isId) {
        this.entityType = entityType;
        this.attrId = attrId;
        this.name = name;
        this.type = type;
        this.column = column;
        this.isId = isId;
    }

    public FieldNode(DynamicEntityType entityType, Integer attrId, String name, String column, boolean isJoinNode, String typeDesc, EntityRelationship entityRelationship, String mappedBy) {
        this.entityType = entityType;
        this.attrId = attrId;
        this.name = name;
        this.column = column;
        this.typeDesc = typeDesc;
        this.isJoinNode = isJoinNode;
        // this.isManyToOne = isManyToOne;
        this.entityRelationship = entityRelationship;
        this.mappedBy = mappedBy;
        this.type = Set.class;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Class<?> getType() {
        return type;
    }

    public void setType(Class<?> type) {
        this.type = type;
    }

    public String getColumn() {
        return column;
    }

    public void setColumn(String column) {
        this.column = column;
    }

    public boolean isId() {
        return isId;
    }

    public void setId(boolean isId) {
        this.isId = isId;
    }

    public String getTypeDesc() {
        return typeDesc;
    }

    public void setTypeDesc(String typeDesc) {
        this.typeDesc = typeDesc;
    }

    public boolean isJoinNode() {
        return isJoinNode;
    }

    public void setJoinNode(boolean isJoinNode) {
        this.isJoinNode = isJoinNode;
    }

    /*
     * public boolean isManyToOne() { return isManyToOne; } public void
     * setManyToOne(boolean isManyToOne) { this.isManyToOne = isManyToOne; }
     */
    public String getMappedBy() {
        return mappedBy;
    }

    public void setMappedBy(String mappedBy) {
        this.mappedBy = mappedBy;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    public Integer getAttrId() {
        return attrId;
    }

    public void setAttrId(Integer attrId) {
        this.attrId = attrId;
    }

    public DynamicEntityType getEntityType() {
        return entityType;
    }

    public void setEntityType(DynamicEntityType entityType) {
        this.entityType = entityType;
    }

    public EntityRelationship getEntityRelationship() {
        return entityRelationship;
    }

    public void setEntityRelationship(EntityRelationship entityRelationship) {
        this.entityRelationship = entityRelationship;
    }

    public String getJoinTable() {
        return joinTable;
    }

    public void setJoinTable(String joinTable) {
        this.joinTable = joinTable;
    }
}
