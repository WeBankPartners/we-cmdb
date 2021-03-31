package com.webank.cmdb.dto;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.google.common.base.MoreObjects;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplate;
import com.webank.cmdb.domain.AdmIntegrateTemplateAlias;
import com.webank.cmdb.domain.AdmIntegrateTemplateRelation;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.support.exception.ServiceException;

@JsonInclude(Include.NON_EMPTY)
public class IntegrationQueryExDto {
    private String name;
    private String keyName;
    private String ciTypeId;  //table name instead
    private List<Integer> attrs = new LinkedList<>();
    // to display attribute names in cmdb gui (can be duplicated)
    private List<String> attrAliases = new ArrayList<>();
    @JsonIgnore
    // to identify agg attribute ( don't need pass value from cmdb gui), only
    // internal usage.
    private List<String> aggKeyNames = new ArrayList<>();
    // cmdb gui will use attrKeyNames to save and display attribute name
    private List<String> attrKeyNames = new ArrayList<>();

    // relation with parent node, it is not needed in root node.
    private RelationshipEx parentRs;
    private List<IntegrationQueryExDto> children = new LinkedList<>();
    private List<Filter> filters = new ArrayList<Filter>();
    public List<Filter> getFilters() {
		return filters;
	}

	public void setFilters(List<Filter> filters) {
		this.filters = filters;
	}

	public IntegrationQueryExDto() {
    }

    public IntegrationQueryExDto(String name) {
        this.name = name;
    }

    public static IntegrationQueryExDto fromDomain(AdmIntegrateTemplate intTemplate) {
        AdmIntegrateTemplateAlias rootAlias = null;
        // find out root alias which dose not has parent relationship
        List<AdmIntegrateTemplateAlias> aliases = intTemplate.getAdmIntegrateTemplateAlias();
        for (AdmIntegrateTemplateAlias alias : aliases) {
            if (alias.getParentIntegrateTemplateRelation() == null) {
                if (rootAlias != null) {
                    throw new ServiceException(String.format("There are more then 1 root aliase for integrate template [%d].", intTemplate.getIdAdmIntegrateTemplate()))
                    .withErrorCode("3110", intTemplate.getIdAdmIntegrateTemplate());
                } else {
                    rootAlias = alias;
                }
            }
        }
        
        if(rootAlias == null) {
            throw new ServiceException(String.format("Can not find out root alias for integrate template [%d].", intTemplate.getIdAdmIntegrateTemplate()))
            .withErrorCode("3111", intTemplate.getIdAdmIntegrateTemplate());
        }

        return buildDtoTree(rootAlias, null, null);
    }

    public void validate(){
        if(children.size()>0){
            for(IntegrationQueryExDto child:children){
                child.validate();
            }
        }else{
            if(attrKeyNames.size()>0 && attrs.size() != attrKeyNames.size()){
                throw new InvalidArgumentException("Attribute list should have same size of attrKeyName.");
            }

            if(attrKeyNames!=null && attrKeyNames.size()>0){
                Set<String> nameSet = new HashSet<>();
                for(String keyName:attrKeyNames){
                    if(nameSet.contains(keyName)){
                        throw new InvalidArgumentException(String.format("Attribute key name (%s) can not be duplicated.",keyName));
                    }else{
                        nameSet.add(keyName);
                    }
                }
            }
        }
    }

    private static IntegrationQueryExDto buildDtoTree(AdmIntegrateTemplateAlias alias, AdmIntegrateTemplateAlias parentAlias, AdmIntegrateTemplateRelation parentRelation) {
        IntegrationQueryExDto curDto = new IntegrationQueryExDto();
        AdmCiType ciType = alias.getAdmCiType();
        curDto.setCiTypeId(ciType.getTableName());
        curDto.setName(alias.getAlias());
        alias.getAdmIntegrateTemplateAliasAttrs().forEach(x -> {
            curDto.attrs.add(x.getCiTypeAttrId());
            curDto.attrAliases.add(x.getMappingName());
            curDto.attrKeyNames.add(x.getKeyName());
        });

        if (parentRelation != null) {
            AdmCiTypeAttr attr = parentRelation.getAdmCiTypeAttr();
            int ciTypeId = attr.getCiTypeId();
            int relationshipCiTypeId = 0;
            // boolean isReferedFromParent = true;
            // child and parent CiType are same
            if (ciType.getIdAdmCiType() == parentAlias.getCiTypeId()) {
                relationshipCiTypeId = ciTypeId;
                // isReferedFromParent = parentRelation.getIsReferedFromParent() == 1;
            } else {
                if (ciTypeId == ciType.getIdAdmCiType()) {
                    relationshipCiTypeId = ciTypeId;
                    // isReferedFromParent = false;
                } else {
                    relationshipCiTypeId = parentAlias.getCiTypeId();
                    // isReferedFromParent = true;
                }
            }
            String attrId = String.format("%s#%s", attr.getAdmCiType().getTableName(), attr.getPropertyName())
;            RelationshipEx parentRs = new RelationshipEx(attrId, parentRelation.getIsReferedFromParent() == 1);
            curDto.setParentRs(parentRs);
        }
        if (alias.getChildIntegrateTemplateRelations() != null && alias.getChildIntegrateTemplateRelations().size() > 0) {
            for (AdmIntegrateTemplateRelation tempRelation : alias.getChildIntegrateTemplateRelations()) {
                curDto.addChild(buildDtoTree(tempRelation.getChildIntegrateTemplateAlias(), alias, tempRelation));
            }
        }
        return curDto;
    }

    public IntegrationQueryExDto(String name, String ciTypeId, List<Integer> attrs, RelationshipEx rs) {
        this(name, ciTypeId, attrs, null, rs);
    }

    public IntegrationQueryExDto(String name, String ciTypeId, List<Integer> attrs, List<String> attrAliases, RelationshipEx rs) {
        this.name = name;
        this.ciTypeId = ciTypeId;
        this.attrs = attrs;
        this.attrAliases = attrAliases;
        this.parentRs = rs;
    }

    public String getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(String ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    public IntegrationQueryExDto withCiTypeId(String ciTypeId){
        setCiTypeId(ciTypeId);
        return this;
    }

    public List<Integer> getAttrs() {
        return attrs;
    }

    public void setAttrs(List<Integer> attrs) {
        this.attrs = attrs;
    }

    public IntegrationQueryExDto withAttrs(List<Integer> attrs){
        setAttrs(attrs);
        return this;
    }

    public RelationshipEx getParentRs() {
        return parentRs;
    }

    public void setParentRs(RelationshipEx parentRs) {
        this.parentRs = parentRs;
    }

    public IntegrationQueryExDto withParentRs(RelationshipEx parentRs){
        setParentRs(parentRs);
        return this;
    }

    public List<IntegrationQueryExDto> getChildren() {
        return children;
    }

    public void setChildren(List<IntegrationQueryExDto> children) {
        this.children = children;
    }

    public IntegrationQueryExDto withChildren(List<IntegrationQueryExDto> children){
        setChildren(children);
        return this;
    }

    public void addChild(IntegrationQueryExDto child) {
        this.children.add(child);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<String> getAttrAliases() {
        return attrAliases;
    }

    public void setAttrAliases(List<String> attrAliases) {
        this.attrAliases = attrAliases;
    }

    public List<String> getAttrKeyNames() {
        return attrKeyNames;
    }

    public void setAttrKeyNames(List<String> attrKeyNames) {
        this.attrKeyNames = attrKeyNames;
    }

    public IntegrationQueryExDto withAttrKeyNames(List<String> attrKeyNames){
        setAttrKeyNames(attrKeyNames);
        return this;
    }

    public List<String> getAggKeyNames() {
        return aggKeyNames;
    }

    public void setAggKeyNames(List<String> aggKeyNames) {
        this.aggKeyNames = aggKeyNames;
    }

    public String getKeyName() {
        return keyName;
    }

    public void setKeyName(String keyName) {
        this.keyName = keyName;
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("ciTypeId", ciTypeId)
                .add("attrs", attrs)
                .add("attrAliases", attrAliases)
                .add("parentRs", parentRs)
                .toString();
    }
}
