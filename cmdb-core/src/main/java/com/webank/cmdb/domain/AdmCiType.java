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
    @OneToMany(mappedBy = "admCiType",fetch = FetchType.EAGER)
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

    public List<AdmCiTypeAttr> retrieveMultSelectionAttrs() {
        return this.admCiTypeAttrs.stream().filter(x -> InputType.MultSelDroplist.getCode().equals(x.getInputType())).collect(Collectors.toList());
    }

    public List<AdmCiTypeAttr> retrieveMultReferenceAttrs() {
        return this.admCiTypeAttrs.stream().filter(x -> {
            return InputType.MultRef.getCode().equals(x.getInputType());
        }).collect(Collectors.toList());
    }
}