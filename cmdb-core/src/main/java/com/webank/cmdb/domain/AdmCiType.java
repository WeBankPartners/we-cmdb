package com.webank.cmdb.domain;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

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

import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.InputType;

/**
 * The persistent class for the adm_ci_type database table.
 */
@Entity
@Table(name = "adm_ci_type")
@NamedQuery(name = "AdmCiType.findAll", query = "SELECT a FROM AdmCiType a")
public class AdmCiType implements Serializable {
    private static final long serialVersionUID = 1L;
    private Integer idAdmCiType;
    private Integer catalogId;
    private Integer ciGlobalUniqueId;
    private String description;
    private Integer idAdmTenement;
    private Integer imageFileId;
    private Integer layerId;
    private Integer ciStateTypeId;
    private String name;
    private Integer seqNo;
    private String tableName;
    private String status = CiStatus.NotCreated.getCode();
    private Integer zoomLevelId;
    private List<AdmCiTypeAttr> admCiTypeAttrs;
    private List<AdmIntegrateTemplateAlias> admIntegrateTemplateAlias;
    private List<AdmTemplate> admTemplates;
    private AdmBasekeyCode layerCode;
    private AdmBasekeyCode catalogCode;
    private AdmBasekeyCode ciStateType;

    public AdmCiType() {
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adm_ci_type")
    public Integer getIdAdmCiType() {
        return this.idAdmCiType;
    }

    public void setIdAdmCiType(Integer idAdmCiType) {
        this.idAdmCiType = idAdmCiType;
    }

    @Column(name = "catalog_id")
    public Integer getCatalogId() {
        return this.catalogId;
    }

    public void setCatalogId(Integer catalogId) {
        this.catalogId = catalogId;
    }

    @Column(name = "ci_global_unique_id")
    public Integer getCiGlobalUniqueId() {
        return this.ciGlobalUniqueId;
    }

    public void setCiGlobalUniqueId(Integer ciGlobalUniqueId) {
        this.ciGlobalUniqueId = ciGlobalUniqueId;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "id_adm_tenement")
    public Integer getIdAdmTenement() {
        return this.idAdmTenement;
    }

    public void setIdAdmTenement(Integer idAdmTenement) {
        this.idAdmTenement = idAdmTenement;
    }

    @Column(name = "image_file_id")
    public Integer getImageFileId() {
        return this.imageFileId;
    }

    public void setImageFileId(Integer imageFileId) {
        this.imageFileId = imageFileId;
    }

    @Column(name = "layer_id")
    public Integer getLayerId() {
        return this.layerId;
    }

    public void setLayerId(Integer layerId) {
        this.layerId = layerId;
    }

    @Column(name = "ci_state_type")
    public Integer getCiStateTypeId() {
        return ciStateTypeId;
    }

    public void setCiStateTypeId(Integer ciStateTypeId) {
        this.ciStateTypeId = ciStateTypeId;
    }

    @Column(name = "name")
    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "seq_no")
    public Integer getSeqNo() {
        return this.seqNo;
    }

    public void setSeqNo(Integer seqNo) {
        this.seqNo = seqNo;
    }

    @Column(name = "table_name")
    public String getTableName() {
        return this.tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    @Column(name = "status")
    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Column(name = "zoom_level_id")
    public Integer getZoomLevelId() {
        return this.zoomLevelId;
    }

    public void setZoomLevelId(Integer zoomLevelId) {
        this.zoomLevelId = zoomLevelId;
    }

    // bi-directional many-to-one association to AdmCiTypeAttr
    @OneToMany(mappedBy = "admCiType")
    public List<AdmCiTypeAttr> getAdmCiTypeAttrs() {
        return this.admCiTypeAttrs;
    }

    public void setAdmCiTypeAttrs(List<AdmCiTypeAttr> admCiTypeAttrs) {
        this.admCiTypeAttrs = admCiTypeAttrs;
    }

    public AdmCiTypeAttr addAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        getAdmCiTypeAttrs().add(admCiTypeAttr);
        admCiTypeAttr.setAdmCiType(this);

        return admCiTypeAttr;
    }

    public AdmCiTypeAttr removeAdmCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        getAdmCiTypeAttrs().remove(admCiTypeAttr);
        admCiTypeAttr.setAdmCiType(null);

        return admCiTypeAttr;
    }

    // bi-directional many-to-one association to AdmIntegrateTemplateAlia
    @OneToMany(mappedBy = "admCiType")
    public List<AdmIntegrateTemplateAlias> getAdmIntegrateTemplateAlias() {
        return this.admIntegrateTemplateAlias;
    }

    public void setAdmIntegrateTemplateAlias(List<AdmIntegrateTemplateAlias> admIntegrateTemplateAlias) {
        this.admIntegrateTemplateAlias = admIntegrateTemplateAlias;
    }

    public AdmIntegrateTemplateAlias addAdmIntegrateTemplateAlia(AdmIntegrateTemplateAlias admIntegrateTemplateAlia) {
        getAdmIntegrateTemplateAlias().add(admIntegrateTemplateAlia);
        admIntegrateTemplateAlia.setAdmCiType(this);

        return admIntegrateTemplateAlia;
    }

    public AdmIntegrateTemplateAlias removeAdmIntegrateTemplateAlia(AdmIntegrateTemplateAlias admIntegrateTemplateAlia) {
        getAdmIntegrateTemplateAlias().remove(admIntegrateTemplateAlia);
        admIntegrateTemplateAlia.setAdmCiType(null);

        return admIntegrateTemplateAlia;
    }

    // bi-directional many-to-one association to AdmTemplate
    @OneToMany(mappedBy = "admCiType")
    public List<AdmTemplate> getAdmTemplates() {
        return this.admTemplates;
    }

    public void setAdmTemplates(List<AdmTemplate> admTemplates) {
        this.admTemplates = admTemplates;
    }

    public AdmTemplate addAdmTemplate(AdmTemplate admTemplate) {
        getAdmTemplates().add(admTemplate);
        admTemplate.setAdmCiType(this);

        return admTemplate;
    }

    public AdmTemplate removeAdmTemplate(AdmTemplate admTemplate) {
        getAdmTemplates().remove(admTemplate);
        admTemplate.setAdmCiType(null);

        return admTemplate;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "layer_id", insertable = false, updatable = false)
    public AdmBasekeyCode getLayerCode() {
        return layerCode;
    }

    public void setLayerCode(AdmBasekeyCode layerCode) {
        this.layerCode = layerCode;
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ci_state_type", insertable = false, updatable = false)
    public AdmBasekeyCode getCiStateType() {
        return ciStateType;
    }

    public void setCiStateType(AdmBasekeyCode ciStateType) {
        this.ciStateType = ciStateType;
    }

    // bi-directional many-to-one association to AdmBasekeyCat
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "catalog_id", insertable = false, updatable = false)
    public AdmBasekeyCode getCatalogCode() {
        return catalogCode;
    }

    public void setCatalogCode(AdmBasekeyCode catalogCode) {
        this.catalogCode = catalogCode;
    }

    public String genCreateCiTypeWithDefaultAttrSQL() {
        StringBuffer sb = new StringBuffer("CREATE TABLE ");
        sb.append(this.tableName).append(" (");
        for (AdmCiTypeAttr attr : retrieveDefaultAdmCiTypeAttrs()) {
            sb.append("`").append(attr.getPropertyName()).append("`").append(" ").append(attr.getPropertyType()).append(" ");
            if (!("datetime".equals(attr.getPropertyType()) || "date".equals(attr.getPropertyType()) || "text".equals(attr.getPropertyType()) || "longtext".equals(attr.getPropertyType()))) {
                sb.append("(").append(attr.getLength()).append(")").append(" ");
            }
            if ("guid".equals(attr.getPropertyName())) {
                sb.append(" NOT NULL ");
            } else {
                sb.append(" DEFAULT NULL ");
            }
            if (this.getDescription() != null) {
                sb.append("COMMENT '").append(attr.getDescription()).append("'");
            }
            sb.append(", ");
        }
        sb.append("PRIMARY KEY (`guid`)");
        sb.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8");
        return sb.toString();
    }

    public List<AdmCiTypeAttr> retrieveDefaultAdmCiTypeAttrs() {
        List<AdmCiTypeAttr> attrs = new LinkedList<AdmCiTypeAttr>();
        AdmCiTypeAttr guid = new AdmCiTypeAttr();
        guid.setCiTypeId(this.idAdmCiType);
        guid.setPropertyName(CmdbConstants.DEFAULT_FIELD_GUID);
        guid.setPropertyType("varchar");
        guid.setInputType("text");
        guid.setLength(CmdbConstants.DEFAULT_LENGTH_OF_GUID);
        guid.setName("全局唯一ID");
        guid.setDescription("全局唯一ID");
        guid.setIsAccessControlled(0);
        guid.setEditIsOnly(1);
        guid.setEditIsHiden(0);
        guid.setIsDefunct(0);
        guid.setIsAuto(0);
        guid.setEditIsNull(0);
        guid.setEditIsEditable(0);
        guid.setSearchSeqNo(0);
        guid.setDisplayType(0);
        guid.setDisplaySeqNo(1);
        guid.setIsRefreshable(0);
        guid.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        guid.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(guid);

        AdmCiTypeAttr p_guid = new AdmCiTypeAttr();
        p_guid.setCiTypeId(this.idAdmCiType);
        p_guid.setPropertyName(CmdbConstants.DEFAULT_FIELD_PARENT_GUID);
        p_guid.setPropertyType("varchar");
        p_guid.setInputType("text");
        p_guid.setLength(15);
        p_guid.setName("前全局唯一ID");
        p_guid.setDescription("前全局唯一ID");
        p_guid.setIsAccessControlled(0);
        p_guid.setEditIsOnly(0);
        p_guid.setEditIsHiden(1);
        p_guid.setIsDefunct(0);
        p_guid.setIsAuto(0);
        p_guid.setEditIsNull(1);
        p_guid.setEditIsEditable(0);
        p_guid.setSearchSeqNo(0);
        p_guid.setDisplayType(0);
        p_guid.setDisplaySeqNo(0);
        p_guid.setIsRefreshable(0);
        p_guid.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        p_guid.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(p_guid);

        AdmCiTypeAttr r_guid = new AdmCiTypeAttr();
        r_guid.setCiTypeId(this.idAdmCiType);
        r_guid.setPropertyName(CmdbConstants.DEFAULT_FIELD_ROOT_GUID);
        r_guid.setPropertyType("varchar");
        r_guid.setInputType("text");
        r_guid.setLength(15);
        r_guid.setName("根全局唯一ID");
        r_guid.setDescription("根全局唯一ID");
        r_guid.setIsAccessControlled(0);
        r_guid.setEditIsOnly(0);
        r_guid.setEditIsHiden(0);
        r_guid.setIsDefunct(0);
        r_guid.setIsAuto(0);
        r_guid.setEditIsNull(0);
        r_guid.setEditIsEditable(0);
        r_guid.setSearchSeqNo(0);
        r_guid.setDisplayType(0);
        r_guid.setDisplaySeqNo(0);
        r_guid.setIsRefreshable(0);
        r_guid.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        r_guid.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(r_guid);

        AdmCiTypeAttr updatedBy = new AdmCiTypeAttr();
        updatedBy.setCiTypeId(this.idAdmCiType);
        updatedBy.setPropertyName(CmdbConstants.DEFAULT_FIELD_UPDATED_BY);
        updatedBy.setPropertyType("varchar");
        updatedBy.setInputType("text");
        updatedBy.setLength(50);
        updatedBy.setName("更新用户");
        updatedBy.setDescription("更新用户");
        updatedBy.setIsAccessControlled(0);
        updatedBy.setEditIsOnly(0);
        updatedBy.setEditIsHiden(1);
        updatedBy.setIsDefunct(0);
        updatedBy.setIsAuto(0);
        updatedBy.setEditIsNull(0);
        updatedBy.setEditIsEditable(0);
        updatedBy.setSearchSeqNo(0);
        updatedBy.setDisplayType(0);
        updatedBy.setDisplaySeqNo(0);
        updatedBy.setIsRefreshable(0);
        updatedBy.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        updatedBy.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(updatedBy);

        AdmCiTypeAttr updatedDate = new AdmCiTypeAttr();
        updatedDate.setCiTypeId(this.idAdmCiType);
        updatedDate.setPropertyName(CmdbConstants.DEFAULT_FIELD_UPDATED_DATE);
        updatedDate.setPropertyType("datetime");
        updatedDate.setInputType("date");
        updatedDate.setLength(64);
        updatedDate.setName("更新日期");
        updatedDate.setDescription("更新日期");
        updatedDate.setIsAccessControlled(0);
        updatedDate.setEditIsOnly(0);
        updatedDate.setEditIsHiden(1);
        updatedDate.setIsDefunct(0);
        updatedDate.setIsAuto(0);
        updatedDate.setEditIsNull(0);
        updatedDate.setEditIsEditable(0);
        updatedDate.setSearchSeqNo(0);
        updatedDate.setDisplayType(0);
        updatedDate.setDisplaySeqNo(0);
        updatedDate.setIsRefreshable(0);
        updatedDate.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        updatedDate.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(updatedDate);

        AdmCiTypeAttr createdBy = new AdmCiTypeAttr();
        createdBy.setCiTypeId(this.idAdmCiType);
        createdBy.setPropertyName(CmdbConstants.DEFAULT_FIELD_CREATED_BY);
        createdBy.setInputType("text");
        createdBy.setPropertyType("varchar");
        createdBy.setLength(50);
        createdBy.setName("创建用户");
        createdBy.setDescription("创建用户");
        createdBy.setIsAccessControlled(0);
        createdBy.setEditIsOnly(0);
        createdBy.setEditIsHiden(1);
        createdBy.setIsDefunct(0);
        createdBy.setIsAuto(0);
        createdBy.setEditIsNull(0);
        createdBy.setEditIsEditable(0);
        createdBy.setSearchSeqNo(0);
        createdBy.setDisplayType(0);
        createdBy.setDisplaySeqNo(0);
        createdBy.setIsRefreshable(0);
        createdBy.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        createdBy.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(createdBy);

        AdmCiTypeAttr createdDate = new AdmCiTypeAttr();
        createdDate.setCiTypeId(this.idAdmCiType);
        createdDate.setPropertyName(CmdbConstants.DEFAULT_FIELD_CREATED_DATE);
        createdDate.setPropertyType("datetime");
        createdDate.setInputType("date");
        createdDate.setLength(64);
        createdDate.setName("创建日期");
        createdDate.setDescription("创建日期");
        createdDate.setIsAccessControlled(0);
        createdDate.setEditIsOnly(0);
        createdDate.setEditIsHiden(1);
        createdDate.setIsDefunct(0);
        createdDate.setIsAuto(0);
        createdDate.setEditIsNull(0);
        createdDate.setEditIsEditable(0);
        createdDate.setSearchSeqNo(0);
        createdDate.setDisplayType(0);
        createdDate.setDisplaySeqNo(0);
        createdDate.setIsRefreshable(0);
        createdDate.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        createdDate.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(createdDate);

        AdmCiTypeAttr keyName = new AdmCiTypeAttr();
        keyName.setCiTypeId(this.idAdmCiType);
        keyName.setInputType("text");
        keyName.setPropertyName(CmdbConstants.DEFAULT_FIELD_KEY_NAME);
        keyName.setPropertyType("varchar");
        keyName.setLength(200);
        keyName.setName("唯一名称");
        keyName.setDescription("唯一名称");
        keyName.setIsAccessControlled(0);
        keyName.setEditIsOnly(1);
        keyName.setEditIsHiden(0);
        keyName.setIsDefunct(0);
        keyName.setIsAuto(1);
        keyName.setEditIsNull(0);
        keyName.setEditIsEditable(0);
        keyName.setSearchSeqNo(1);
        keyName.setDisplayType(1);
        keyName.setDisplaySeqNo(1);
        keyName.setIsRefreshable(0);
        keyName.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        keyName.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(keyName);

        AdmCiTypeAttr state = new AdmCiTypeAttr();
        state.setCiTypeId(this.idAdmCiType);
        state.setPropertyName(CmdbConstants.DEFAULT_FIELD_STATE);
        state.setPropertyType("int");
        state.setInputType("select");
        state.setLength(15);
        state.setName("状态");
        state.setDescription("状态");
        state.setIsAccessControlled(0);
        state.setEditIsOnly(0);
        state.setEditIsHiden(0);
        state.setIsDefunct(0);
        state.setIsAuto(0);
        state.setEditIsNull(0);
        state.setEditIsEditable(0);
        state.setSearchSeqNo(2);
        state.setDisplayType(1);
        state.setDisplaySeqNo(2);
        state.setIsRefreshable(0);
        state.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        state.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(state);

        AdmCiTypeAttr fixedDate = new AdmCiTypeAttr();
        fixedDate.setCiTypeId(this.idAdmCiType);
        fixedDate.setPropertyName(CmdbConstants.DEFAULT_FIELD_FIXED_DATE);
        fixedDate.setPropertyType("varchar");
        fixedDate.setInputType("text");
        fixedDate.setLength(19);
        fixedDate.setName("确认日期");
        fixedDate.setDescription("确认日期");
        fixedDate.setIsAccessControlled(0);
        fixedDate.setEditIsOnly(0);
        fixedDate.setEditIsHiden(0);
        fixedDate.setIsDefunct(0);
        fixedDate.setIsAuto(0);
        fixedDate.setEditIsNull(1);
        fixedDate.setEditIsEditable(0);
        fixedDate.setSearchSeqNo(3);
        fixedDate.setDisplayType(1);
        fixedDate.setDisplaySeqNo(3);
        fixedDate.setIsRefreshable(0);
        fixedDate.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        fixedDate.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(fixedDate);

        AdmCiTypeAttr code = new AdmCiTypeAttr();
        code.setCiTypeId(this.idAdmCiType);
        code.setPropertyName(CmdbConstants.DEFAULT_FIELD_CODE);
        code.setPropertyType("varchar");
        code.setInputType("text");
        code.setLength(50);
        code.setName("编码");
        code.setDescription("编码");
        code.setIsAccessControlled(0);
        code.setEditIsOnly(0);
        code.setEditIsHiden(0);
        code.setIsDefunct(0);
        code.setIsAuto(0);
        code.setEditIsNull(0);
        code.setEditIsEditable(1);
        code.setSearchSeqNo(5);
        code.setDisplayType(1);
        code.setDisplaySeqNo(5);
        code.setIsRefreshable(0);
        code.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        code.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(code);

        AdmCiTypeAttr desc = new AdmCiTypeAttr();
        desc.setCiTypeId(this.idAdmCiType);
        desc.setPropertyName(CmdbConstants.DEFAULT_FIELD_DESCRIPTION);
        desc.setPropertyType("varchar");
        desc.setInputType("textArea");
        desc.setLength(1000);
        desc.setName("描述说明");
        desc.setDescription("描述说明");
        desc.setIsAccessControlled(0);
        desc.setEditIsOnly(0);
        desc.setEditIsHiden(0);
        desc.setIsDefunct(0);
        desc.setIsAuto(0);
        desc.setEditIsNull(1);
        desc.setEditIsEditable(1);
        desc.setSearchSeqNo(4);
        desc.setDisplayType(1);
        desc.setDisplaySeqNo(4);
        desc.setIsRefreshable(0);
        desc.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        desc.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(desc);

        AdmCiTypeAttr orchestration = new AdmCiTypeAttr();
        orchestration.setCiTypeId(this.idAdmCiType);
        orchestration.setPropertyName(CmdbConstants.DEFAULT_FIELD_ORCHESTRATION);
        orchestration.setPropertyType("int");
        orchestration.setInputType("select");
        orchestration.setLength(15);
        orchestration.setName("编排");
        orchestration.setDescription("编排");
        orchestration.setIsAccessControlled(0);
        orchestration.setEditIsOnly(0);
        orchestration.setEditIsHiden(0);
        orchestration.setIsDefunct(0);
        orchestration.setIsAuto(0);
        orchestration.setEditIsNull(1);
        orchestration.setEditIsEditable(1);
        orchestration.setSearchSeqNo(0);
        orchestration.setDisplayType(1);
        orchestration.setDisplaySeqNo(6);
        orchestration.setIsRefreshable(1);
        orchestration.setIsSystem(CmdbConstants.IS_SYSTEM_NO);
        orchestration.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(orchestration);

        AdmCiTypeAttr bizKey = new AdmCiTypeAttr();
        bizKey.setCiTypeId(this.idAdmCiType);
        bizKey.setPropertyName(CmdbConstants.DEFAULT_FIELD_BIZ_KEY);
        bizKey.setPropertyType("varchar");
        bizKey.setInputType("text");
        bizKey.setLength(50);
        bizKey.setName("编排实例ID");
        bizKey.setDescription("编排实例ID");
        bizKey.setIsAccessControlled(0);
        bizKey.setEditIsOnly(0);
        bizKey.setEditIsHiden(0);
        bizKey.setIsDefunct(0);
        bizKey.setIsAuto(0);
        bizKey.setEditIsNull(1);
        bizKey.setEditIsEditable(0);
        bizKey.setSearchSeqNo(0);
        bizKey.setDisplayType(0);
        bizKey.setDisplaySeqNo(0);
        bizKey.setIsRefreshable(1);
        bizKey.setIsSystem(CmdbConstants.IS_SYSTEM_YES);
        bizKey.setStatus(CiStatus.NotCreated.getCode());
        attrs.add(bizKey);

        return attrs;
    }

    public List<AdmCiTypeAttr> retrieveMultSelectionAttrs() {
        return this.admCiTypeAttrs.stream().filter(x -> {
            return InputType.MultSelDroplist.getCode().equals(x.getInputType());
        }).collect(Collectors.toList());
    }

    public List<AdmCiTypeAttr> retrieveMultReferenceAttrs() {
        return this.admCiTypeAttrs.stream().filter(x -> {
            return InputType.MultRef.getCode().equals(x.getInputType());
        }).collect(Collectors.toList());
    }
}