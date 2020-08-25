package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.support.exception.ServiceException;

/**
 * The persistent class for the adm_ci_type_attr database table.
 *
 */
@Entity
@Table(name = "adm_ci_type_attr")
@NamedQuery(name = "AdmCiTypeAttr.findAll", query = "SELECT a FROM AdmCiTypeAttr a")
public class AdmCiTypeAttr implements Serializable {
    private static Logger logger = LoggerFactory.getLogger(AdmCiTypeAttr.class);

    private static final long serialVersionUID = 1L;
    private Integer idAdmCiTypeAttr;
    private String description;
    private Integer displaySeqNo;
    private Integer displayType;
    private Integer editIsEditable;
    private Integer editIsHiden;
    @NotNull
    private Integer editIsNull;
    private Integer editIsOnly;
    @NotNull
    private String inputType;
    private Integer isAccessControlled;
    private Integer isDefunct;
    private Integer isSystem;
    private Integer length;
    private Integer isRefreshable;
    @NotNull
    private String name;
    @NotNull
    private String propertyName;
    @NotNull
    private String propertyType;
    private Integer referenceId;
    private String referenceName;
    private Integer referenceType;
    private Integer searchSeqNo;
    private String specialLogic;
    private Integer isAuto;
    private String autoFillRule;
    private String filterRule;
    private String regularExpressionRule;
    private String status = CiStatus.NotCreated.getCode();
    private AdmCiType admCiType;
    private List<AdmCiTypeAttrGroup> admCiTypeAttrGroups;
    private List<AdmIntegrateTemplateAliasAttr> admIntegrateTemplateAliasAttrs;
    private List<AdmIntegrateTemplateRelation> admIntegrateTemplateRelations;
    private List<AdmTemplateCiType> admTemplateCiTypes;
    private List<AdmTemplateCiTypeAliasUniq> admTemplateCiTypeAliasUniqs;
    private List<AdmTemplateCiTypeAttr> admTemplateCiTypeAttrs;
    @NotNull
    private Integer ciTypeId;
    //for reference type
    private Integer isDeleteValidate;

    public AdmCiTypeAttr() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_ci_type_attr")
    public Integer getIdAdmCiTypeAttr() {
        return this.idAdmCiTypeAttr;
    }

    public void setIdAdmCiTypeAttr(Integer idAdmCiTypeAttr) {
        this.idAdmCiTypeAttr = idAdmCiTypeAttr;
    }

    public String genAlterSql() {
        if (isDefaultField(this.getPropertyName())) {
            return null;
        }

        StringBuilder sb = new StringBuilder();
        sb.append("ALTER TABLE ").append(this.getAdmCiType().getTableName());

        if (CiStatus.NotCreated == CiStatus.fromCode(this.status)) {
            sb.append(" ADD COLUMN ");
        } else if (CiStatus.Dirty == CiStatus.fromCode(this.status)) {
            sb.append(" MODIFY COLUMN ");
        }

        sb.append("`" + this.getPropertyName() + "`").append(" ").append(this.getPropertyType());
        if (!("text".equals(this.getPropertyType()) || "longtext".equals(this.getPropertyType()) || "datetime".equals(this.getPropertyType()))) {
            sb.append("(").append(this.getLength()).append(") ");
        }

        sb.append(" DEFAULT NULL ");
        if (this.getDescription() != null) {
            sb.append("COMMENT '").append(this.getDescription()).append("'");
        }

        if (logger.isDebugEnabled()) {
            logger.debug("Generated alter sql:{}", sb.toString());
        }
        return sb.toString();
    }

    public String retrieveJoinTalbeName() {
        if (InputType.MultRef.getCode().equals(inputType) || InputType.MultSelDroplist.getCode().equals(inputType)) {
            return this.admCiType.getTableName() + "$" + getPropertyName();
        } else {
            throw new ServiceException(String.format("Cmdb internal error, attribute [%d] is not multiple reference or multiple list.", idAdmCiTypeAttr))
            .withErrorCode("3101", idAdmCiTypeAttr);
        }
    }

    public String retrieveJoinTableCreationSql() {
        if (InputType.MultRef.getCode().equals(inputType)) {
            return new StringBuilder().append("CREATE table ")
                    .append(retrieveJoinTalbeName())
                    .append("( ")
                    .append(" `id` INT(11) NOT NULL AUTO_INCREMENT, ")
                    .append("`from_guid` VARCHAR(15) NOT NULL, ")
                    .append("`to_guid` VARCHAR(15) NOT NULL,")
                    .append("`seq_no` INT(5) DEFAULT 0,")
                    .append("PRIMARY KEY (`id`) )")
                    .toString();
        } else if (InputType.MultSelDroplist.getCode().equals(inputType)) {
            String joinTable = retrieveJoinTalbeName();
            return new StringBuilder().append("CREATE table ")
                    .append(joinTable)
                    .append("( ")
                    .append(" `id` INT(11) NOT NULL AUTO_INCREMENT, ")
                    .append("`from_guid` VARCHAR(15) NOT NULL, ")
                    .append(" `to_code` INT(11) NOT NULL,")
                    .append("`seq_no` INT(5) DEFAULT 0,")
                    .append("PRIMARY KEY (`id`),")
                    .append("CONSTRAINT `")
                    .append(joinTable)
                    .append("_fk_code` FOREIGN KEY (`to_code`) REFERENCES `adm_basekey_code` (`id_adm_basekey`)")
                    .append(")")
                    .toString();
        }
        return "";
    }

    private boolean isDefaultField(String propertyName) {
        for (String fields : CmdbConstants.DEFAULT_FIELDS) {
            if (propertyName != null && propertyName.equals(fields)) {
                return true;
            }
        }
        return false;
    }

    @Column(name = "description")
    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "display_seq_no")
    public Integer getDisplaySeqNo() {
        return this.displaySeqNo;
    }

    public void setDisplaySeqNo(Integer displaySeqNo) {
        this.displaySeqNo = displaySeqNo;
    }

    @Column(name = "display_type")
    public Integer getDisplayType() {
        return this.displayType;
    }

    public void setDisplayType(Integer displayType) {
        this.displayType = displayType;
    }

    @Column(name = "edit_is_editable")
    public Integer getEditIsEditable() {
        return this.editIsEditable;
    }

    public void setEditIsEditable(Integer editIsEditable) {
        this.editIsEditable = editIsEditable;
    }

    @Column(name = "edit_is_hiden")
    public Integer getEditIsHiden() {
        return this.editIsHiden;
    }

    public void setEditIsHiden(Integer editIsHiden) {
        this.editIsHiden = editIsHiden;
    }

    @Column(name = "edit_is_null")
    public Integer getEditIsNull() {
        return this.editIsNull;
    }

    public void setEditIsNull(Integer editIsNull) {
        this.editIsNull = editIsNull;
    }

    @Column(name = "edit_is_only")
    public Integer getEditIsOnly() {
        return this.editIsOnly;
    }

    public void setEditIsOnly(Integer editIsOnly) {
        this.editIsOnly = editIsOnly;
    }

    @Column(name = "input_type")
    public String getInputType() {
        return this.inputType;
    }

    public void setInputType(String inputType) {
        this.inputType = inputType;
    }

    @Column(name = "is_access_controlled")
    public Integer getIsAccessControlled() {
        return this.isAccessControlled;
    }

    public void setIsAccessControlled(Integer isAccessControlled) {
        this.isAccessControlled = isAccessControlled;
    }

    @Column(name = "is_defunct")
    public Integer getIsDefunct() {
        return this.isDefunct;
    }

    public void setIsDefunct(Integer isDefunct) {
        this.isDefunct = isDefunct;
    }

    @Column(name = "is_system")
    public Integer getIsSystem() {
        return this.isSystem;
    }

    public void setIsSystem(Integer isSystem) {
        this.isSystem = isSystem;
    }

    @Column(name="length")
    public Integer getLength() {
        return this.length;
    }

    public void setLength(Integer length) {
        this.length = length;
    }

    @Column(name = "name")
    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "property_name")
    public String getPropertyName() {
        return this.propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    @Column(name = "property_type")
    public String getPropertyType() {
        return this.propertyType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    @Column(name = "reference_id")
    public Integer getReferenceId() {
        return this.referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    @Column(name = "reference_name")
    public String getReferenceName() {
        return this.referenceName;
    }

    public void setReferenceName(String referenceName) {
        this.referenceName = referenceName;
    }

    @Column(name = "reference_type")
    public Integer getReferenceType() {
        return this.referenceType;
    }

    public void setReferenceType(Integer referenceType) {
        this.referenceType = referenceType;
    }

    @Column(name = "search_seq_no")
    public Integer getSearchSeqNo() {
        return this.searchSeqNo;
    }

    public void setSearchSeqNo(Integer searchSeqNo) {
        this.searchSeqNo = searchSeqNo;
    }

    @Column(name = "special_logic")
    public String getSpecialLogic() {
        return this.specialLogic;
    }

    public void setSpecialLogic(String specialLogic) {
        this.specialLogic = specialLogic;
    }

    @Column(name = "status")
    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // bi-directional many-to-one association to AdmCiType
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_adm_ci_type", insertable = false, updatable = false)
    public AdmCiType getAdmCiType() {
        return this.admCiType;
    }

    public void setAdmCiType(AdmCiType admCiType) {
        this.admCiType = admCiType;
    }

    // bi-directional many-to-one association to AdmCiTypeAttrGroup
    @OneToMany(mappedBy = "admCiTypeAttr")
    public List<AdmCiTypeAttrGroup> getAdmCiTypeAttrGroups() {
        return this.admCiTypeAttrGroups;
    }

    public void setAdmCiTypeAttrGroups(List<AdmCiTypeAttrGroup> admCiTypeAttrGroups) {
        this.admCiTypeAttrGroups = admCiTypeAttrGroups;
    }

    public AdmCiTypeAttrGroup addAdmCiTypeAttrGroup(AdmCiTypeAttrGroup admCiTypeAttrGroup) {
        getAdmCiTypeAttrGroups().add(admCiTypeAttrGroup);
        admCiTypeAttrGroup.setAdmCiTypeAttr(this);

        return admCiTypeAttrGroup;
    }

    public AdmCiTypeAttrGroup removeAdmCiTypeAttrGroup(AdmCiTypeAttrGroup admCiTypeAttrGroup) {
        getAdmCiTypeAttrGroups().remove(admCiTypeAttrGroup);
        admCiTypeAttrGroup.setAdmCiTypeAttr(null);

        return admCiTypeAttrGroup;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateAliasAttr
    @OneToMany(mappedBy = "admCiTypeAttr")
    public List<AdmIntegrateTemplateAliasAttr> getAdmIntegrateTemplateAliasAttrs() {
        return this.admIntegrateTemplateAliasAttrs;
    }

    public void setAdmIntegrateTemplateAliasAttrs(List<AdmIntegrateTemplateAliasAttr> admIntegrateTemplateAliasAttrs) {
        this.admIntegrateTemplateAliasAttrs = admIntegrateTemplateAliasAttrs;
    }

    public AdmIntegrateTemplateAliasAttr addAdmIntegrateTemplateAliasAttr(AdmIntegrateTemplateAliasAttr admIntegrateTemplateAliasAttr) {
        getAdmIntegrateTemplateAliasAttrs().add(admIntegrateTemplateAliasAttr);
        admIntegrateTemplateAliasAttr.setAdmCiTypeAttr(this);

        return admIntegrateTemplateAliasAttr;
    }

    public AdmIntegrateTemplateAliasAttr removeAdmIntegrateTemplateAliasAttr(AdmIntegrateTemplateAliasAttr admIntegrateTemplateAliasAttr) {
        getAdmIntegrateTemplateAliasAttrs().remove(admIntegrateTemplateAliasAttr);
        admIntegrateTemplateAliasAttr.setAdmCiTypeAttr(null);

        return admIntegrateTemplateAliasAttr;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateRelation
    @OneToMany(mappedBy = "admCiTypeAttr")
    public List<AdmIntegrateTemplateRelation> getAdmIntegrateTemplateRelations() {
        return this.admIntegrateTemplateRelations;
    }

    public void setAdmIntegrateTemplateRelations(List<AdmIntegrateTemplateRelation> admIntegrateTemplateRelations) {
        this.admIntegrateTemplateRelations = admIntegrateTemplateRelations;
    }

    public AdmIntegrateTemplateRelation addAdmIntegrateTemplateRelation(AdmIntegrateTemplateRelation admIntegrateTemplateRelation) {
        getAdmIntegrateTemplateRelations().add(admIntegrateTemplateRelation);
        admIntegrateTemplateRelation.setAdmCiTypeAttr(this);

        return admIntegrateTemplateRelation;
    }

    public AdmIntegrateTemplateRelation removeAdmIntegrateTemplateRelation(AdmIntegrateTemplateRelation admIntegrateTemplateRelation) {
        getAdmIntegrateTemplateRelations().remove(admIntegrateTemplateRelation);
        admIntegrateTemplateRelation.setAdmCiTypeAttr(null);

        return admIntegrateTemplateRelation;
    }

    // bi-directional many-to-one association to AdmTemplateCiType
    @OneToMany(mappedBy = "admCiTypeAttr")
    public List<AdmTemplateCiType> getAdmTemplateCiTypes() {
        return this.admTemplateCiTypes;
    }

    public void setAdmTemplateCiTypes(List<AdmTemplateCiType> admTemplateCiTypes) {
        this.admTemplateCiTypes = admTemplateCiTypes;
    }

    public AdmTemplateCiType addAdmTemplateCiType(AdmTemplateCiType admTemplateCiType) {
        getAdmTemplateCiTypes().add(admTemplateCiType);
        admTemplateCiType.setAdmCiTypeAttr(this);

        return admTemplateCiType;
    }

    public AdmTemplateCiType removeAdmTemplateCiType(AdmTemplateCiType admTemplateCiType) {
        getAdmTemplateCiTypes().remove(admTemplateCiType);
        admTemplateCiType.setAdmCiTypeAttr(null);

        return admTemplateCiType;
    }

    // bi-directional many-to-one association to AdmTemplateCiTypeAliasUniq
    @OneToMany(mappedBy = "admCiTypeAttr")
    public List<AdmTemplateCiTypeAliasUniq> getAdmTemplateCiTypeAliasUniqs() {
        return this.admTemplateCiTypeAliasUniqs;
    }

    public void setAdmTemplateCiTypeAliasUniqs(List<AdmTemplateCiTypeAliasUniq> admTemplateCiTypeAliasUniqs) {
        this.admTemplateCiTypeAliasUniqs = admTemplateCiTypeAliasUniqs;
    }

    public AdmTemplateCiTypeAliasUniq addAdmTemplateCiTypeAliasUniq(AdmTemplateCiTypeAliasUniq admTemplateCiTypeAliasUniq) {
        getAdmTemplateCiTypeAliasUniqs().add(admTemplateCiTypeAliasUniq);
        admTemplateCiTypeAliasUniq.setAdmCiTypeAttr(this);

        return admTemplateCiTypeAliasUniq;
    }

    public AdmTemplateCiTypeAliasUniq removeAdmTemplateCiTypeAliasUniq(AdmTemplateCiTypeAliasUniq admTemplateCiTypeAliasUniq) {
        getAdmTemplateCiTypeAliasUniqs().remove(admTemplateCiTypeAliasUniq);
        admTemplateCiTypeAliasUniq.setAdmCiTypeAttr(null);

        return admTemplateCiTypeAliasUniq;
    }

    // bi-directional many-to-one association to AdmTemplateCiTypeAttr
    @OneToMany(mappedBy = "admCiTypeAttr")
    public List<AdmTemplateCiTypeAttr> getAdmTemplateCiTypeAttrs() {
        return this.admTemplateCiTypeAttrs;
    }

    public void setAdmTemplateCiTypeAttrs(List<AdmTemplateCiTypeAttr> admTemplateCiTypeAttrs) {
        this.admTemplateCiTypeAttrs = admTemplateCiTypeAttrs;
    }

    public AdmTemplateCiTypeAttr addAdmTemplateCiTypeAttr(AdmTemplateCiTypeAttr admTemplateCiTypeAttr) {
        getAdmTemplateCiTypeAttrs().add(admTemplateCiTypeAttr);
        admTemplateCiTypeAttr.setAdmCiTypeAttr(this);

        return admTemplateCiTypeAttr;
    }

    public AdmTemplateCiTypeAttr removeAdmTemplateCiTypeAttr(AdmTemplateCiTypeAttr admTemplateCiTypeAttr) {
        getAdmTemplateCiTypeAttrs().remove(admTemplateCiTypeAttr);
        admTemplateCiTypeAttr.setAdmCiTypeAttr(null);

        return admTemplateCiTypeAttr;
    }

    @Column(name = "id_adm_ci_type")
    public Integer getCiTypeId() {
        return ciTypeId;
    }

    public void setCiTypeId(Integer ciTypeId) {
        this.ciTypeId = ciTypeId;
    }

    @Column(name = "is_auto")
    public Integer getIsAuto() {
        return isAuto;
    }

    public void setIsAuto(Integer isAuto) {
        this.isAuto = isAuto;
    }

    @Column(name = "auto_fill_rule")
    public String getAutoFillRule() {
        return autoFillRule;
    }

    public void setAutoFillRule(String autoFillRule) {
        this.autoFillRule = autoFillRule;
    }

    @Column(name = "filter_rule")
    public String getFilterRule() {
        return filterRule;
    }

    public void setFilterRule(String filterRule) {
        this.filterRule = filterRule;
    }

    @Column(name = "is_refreshable")
    public Integer getIsRefreshable() {
        return isRefreshable;
    }

    public void setIsRefreshable(Integer isRefreshable) {
        this.isRefreshable = isRefreshable;
    }

    @Column(name = "regular_expression_rule")
    public String getRegularExpressionRule() {
        return regularExpressionRule;
    }

    public void setRegularExpressionRule(String regularExpressionRule) {
        this.regularExpressionRule = regularExpressionRule;
    }

    @Column(name = "is_delete_validate")
    public Integer getIsDeleteValidate() {
        return isDeleteValidate;
    }

    public void setIsDeleteValidate(Integer is_delete_validate) {
        this.isDeleteValidate = is_delete_validate;
    }
}
