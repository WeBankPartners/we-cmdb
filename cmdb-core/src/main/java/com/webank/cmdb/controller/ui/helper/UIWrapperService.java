package com.webank.cmdb.controller.ui.helper;

import static com.webank.cmdb.controller.ui.helper.CollectionUtils.groupUp;
import static com.webank.cmdb.dto.QueryRequest.defaultQueryObject;
import static org.apache.commons.collections4.CollectionUtils.isEmpty;
import static org.apache.commons.collections4.CollectionUtils.isNotEmpty;

import java.io.IOException;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import com.webank.cmdb.domain.*;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.service.*;
import com.webank.cmdb.util.JsonUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.CaseFormat;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.webank.cmdb.config.ApplicationProperties.UIProperties;
import com.webank.cmdb.constant.AggregationFuction;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.ImplementOperation;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.RoleUserDto;
import com.webank.cmdb.dto.UserDto;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.repository.AdmRoleRepository;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.util.BeanMapUtils;
import com.webank.cmdb.util.ResourceDto;
import com.webank.cmdb.util.Sorting;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import javax.annotation.PostConstruct;

@Service
@Slf4j
@Transactional
public class UIWrapperService {

    private static final String CONSTANT_CAT_TYPE_ID = "catTypeId";
    private static final String CONSTANT_CI_TYPE = "ciType";
    private static final String CONSTANT_CAT_CAT_TYPE = "cat.catType";
    private static final String CONSTANT_INPUT_TYPE = "inputType";
    private static final String CONSTANT_CI_TYPE_ID = "ciTypeId";
    private static final String CONSTANT_ATTRIBUTES = "attributes";
    private static final String CONSTANT_CAT_ID = "catId";
    private static final String CONSTANT_SEQ_NO = "seqNo";
    private static final String CONSTANT_SELECT = "select";
    private static final String CONSTANT_GUID_PATH = "root$guid";
    private static final String CONSTANT_R_GUID_PATH = "r_guid";
    private static final String CONSTANT_FIXED_DATE = "fixed_date";
    private static final String List = null;

    @Autowired
    private UIProperties uiProperties;
    @Autowired
    private CiService ciService;
    @Autowired
    private StaticDtoService staticDtoService;

    @Autowired
    private StaticEntityRepository staticEntityRepository;

    @Autowired
    private CiTypeService ciTypeService;
    @Autowired
    private IntegrationQueryService intQueryService;
    @Autowired
    private FilterRuleService filterRuleService;
    @Autowired
    private BaseKeyInfoService baseKeyInfoService;
    @Autowired
    private AdmRoleRepository admRoleRepository;
    @Autowired
    private AdmCiTypeAttrRepository admCiTypeAttrRepository;
    @Autowired
    private RoleCiTypeAccessCtrlService roleCiTypeAccessCtrlService;

    @PostConstruct
    public void initCiTypeId() throws IOException {
        CategoryDto categoryDto = getEnumCategoryByName(uiProperties.getEnumCodeofView());
        if (categoryDto == null) {
            throw new CmdbException(String.format("The enum category name [%s] not found.", uiProperties.getEnumCodeofView()));
        }
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter(CONSTANT_CAT_ID, categoryDto.getCatId());

        QueryResponse<CatCodeDto> response = staticDtoService.query(CatCodeDto.class, queryObject);
        propertiesAssignment(response);
    }

    public void swapCiTypeLayerPosition(int layerId, int targetLayerId) {
        CatCodeDto enumCode = getEnumCodeById(layerId);
        CatCodeDto targetEnumCode = getEnumCodeById(targetLayerId);

        Integer seqNo = enumCode.getSeqNo();
        enumCode.setSeqNo(targetEnumCode.getSeqNo());
        targetEnumCode.setSeqNo(seqNo);

        updateEnumCodes(Lists.newArrayList(BeanMapUtils.convertBeanToMap(enumCode), BeanMapUtils.convertBeanToMap(targetEnumCode)));
    }

    public void swapCiTypeAttributePosition(int attributeId, int targetAttributeId) {
        AdmCiTypeAttr attribute = getCiTypeAttribute(attributeId);
        AdmCiTypeAttr targetAttribute = getCiTypeAttribute(targetAttributeId);

        CiTypeAttrDto updateSourceAttribute = new CiTypeAttrDto();
        updateSourceAttribute.setCiTypeAttrId(attribute.getIdAdmCiTypeAttr());
        updateSourceAttribute.setDisplaySeqNo(targetAttribute.getDisplaySeqNo());

        CiTypeAttrDto updateTargetAttribute = new CiTypeAttrDto();
        updateTargetAttribute.setCiTypeAttrId(targetAttribute.getIdAdmCiTypeAttr());
        updateTargetAttribute.setDisplaySeqNo(attribute.getDisplaySeqNo());

        updateCiTypeAttributes(BeanMapUtils.convertBeansToMaps(Lists.newArrayList(updateSourceAttribute, updateTargetAttribute)));
    }

    public LinkedHashMap<String, Object> getEnumCategoryByMultipleTypes(String types, Integer ciTypeId) {
        LinkedHashMap<String, Object> enumData = new LinkedHashMap<>();
        if (types.contains("system")) {
            enumData.put("system", getAllSystemEnumCategories().getContents());
        }
        if (types.contains("common")) {
            enumData.put("common", getAllCommonEnumCategories().getContents());
        }
        if (types.contains("private")) {
            try {
                enumData.put("private", getPrivateEnumByCiTypeId(ciTypeId).getContents());
            } catch (DataNotFoundException e) {
                log.warn(e.getMessage());
            }
        }
        return enumData;
    }

    public QueryResponse<CategoryDto> getAllSystemEnumCategories() {
        QueryRequest queryObject = new QueryRequest();
        queryObject.addEqualsFilter(CONSTANT_CAT_TYPE_ID, uiProperties.getEnumCategoryTypeSystem());
        return queryEnumCategories(queryObject);
    }

    public QueryResponse<CategoryDto> getAllCommonEnumCategories() {
        QueryRequest queryObject = new QueryRequest();
        queryObject.addEqualsFilter(CONSTANT_CAT_TYPE_ID, uiProperties.getEnumCategoryTypeCommon());
        return queryEnumCategories(queryObject);
    }

    public QueryResponse<CategoryDto> getPrivateEnumByCiTypeId(Integer ciTypeId) {
        if (ciTypeId == null) {
            throw new CmdbException("'ciTypeId' is required");
        }
        CatTypeDto catType = getEnumCategoryTypeByCiTypeId(ciTypeId);
        if (catType == null) {
            throw new CmdbException(String.format("Can not found CategoryType by CiTypeId(%d)", ciTypeId));
        }
        if (catType.getCatTypeId() == null) {
            throw new CmdbException(String.format("Can not found CategoryTypeId by CiTypeId(%d)", ciTypeId));
        }
        return getEnumCategoriesByTypeId(catType.getCatTypeId());
    }

    public List<CatCodeDto> getCiTypesGroupByLayers(boolean withAttributes, String status) {
        return getCiTypesInGroups(uiProperties.getEnumCategoryCiTypeLayer(), withAttributes, status, CiTypeDto::getLayerId);
    }

    public List<CatCodeDto> getCiTypesGroupByCatalogs(boolean withAttributes, String status) {
        return getCiTypesInGroups(uiProperties.getEnumCategoryCiTypeCatalog(), withAttributes, status, CiTypeDto::getCatalogId);
    }

    public List<CatCodeDto> getAllLayers() {
        return getEnumCodesByCategoryName(uiProperties.getEnumCategoryCiTypeLayer());
    }

    public List<CiTypeAttrDto> getCiTypeReferenceBy(Integer ciTypeId) {
        QueryRequest queryObject = new QueryRequest().addEqualsFilter("referenceId", ciTypeId).addInFilter(CONSTANT_INPUT_TYPE, Arrays.asList("ref", "multiRef")).addReferenceResource(CONSTANT_CI_TYPE);
        queryObject.addReferenceResource(CONSTANT_CI_TYPE);
        return queryCiTypeAttributes(queryObject);
    }

    public List<CiTypeAttrDto> getCiTypeReferenceTo(Integer ciTypeId) {
        QueryRequest queryObject = new QueryRequest().addEqualsFilter(CONSTANT_CI_TYPE_ID, ciTypeId).addInFilter(CONSTANT_INPUT_TYPE, Arrays.asList("ref", "multiRef"));
        queryObject.addReferenceResource(CONSTANT_CI_TYPE);
        return queryCiTypeAttributes(queryObject);
    }

    public List<String> getAvailableCiTypeZoomLevels() {
        CategoryDto cat = getEnumCategoryByName(uiProperties.getEnumCategoryCiTypeZoomLevels());
        List<CatCodeDto> catCodes = getEnumCodesByCategoryId(cat.getCatId());
        List<String> zoomLevels = new ArrayList<>();
        for (CatCodeDto catCode : catCodes) {
            zoomLevels.add(catCode.getCode());
        }
        return zoomLevels;
    }

    public List<CatCodeDto> createLayer(CatCodeDto catCode) {
        catCode.setCatId(getLayerCategoryId());
        catCode.setSeqNo(getMaxLayerSeqNumber() + 1);
        return createEnumCodes(catCode);
    }

    private int getMaxLayerSeqNumber() {
        List<CatCodeDto> catCodesResult = getEnumCodesByCategoryName(uiProperties.getEnumCategoryCiTypeLayer());
        Integer maxSeq = 0;
        for (CatCodeDto code : catCodesResult) {
            if (code.getSeqNo() > maxSeq) {
                maxSeq = code.getSeqNo();
            }
        }
        return maxSeq;
    }

    public List<CatCodeDto> createEnumCodes(CatCodeDto catCode) {

        if (catCode == null || catCode.getCatId().equals(0)) {
            throw new CmdbException("Category Id is required");
        }
        if (catCode.getCatId().equals(getLayerCategoryId())) {
            catCode.setSeqNo(getMaxLayerSeqNumber() + 1);
        }

        if (catCode.getGroupCodeId() != null && !(catCode.getGroupCodeId() instanceof Integer)) {
            catCode.setGroupCodeId(null);
        }

        return staticDtoService.create(CatCodeDto.class, Arrays.asList(catCode));
    }
    public List<CatCodeDto> createEnumCodes(List<CatCodeDto> catCodes) {
        catCodes.stream().forEach(catCode -> {
            if (catCode == null || catCode.getCatId().equals(0)) {
                throw new CmdbException("Category Id is required");
            }
            if (catCode.getCatId().equals(getLayerCategoryId())) {
                catCode.setSeqNo(getMaxLayerSeqNumber() + 1);
            }
            if (catCode.getGroupCodeId() != null && !(catCode.getGroupCodeId() instanceof Integer)) {
                catCode.setGroupCodeId(null);
            }
        });

        return staticDtoService.create(CatCodeDto.class, catCodes);
    }

    private List<CatCodeDto> getCiTypesInGroups(String categoryName, boolean withAttributes, String status, Function<CiTypeDto, Object> parentMapperOfElement) {
        List<CatCodeDto> ciTypeGroups = getEnumCodesByCategoryName(categoryName);
        List<CiTypeDto> ciTypes = getAllCiTypes(withAttributes, status);

        return groupUp(ciTypeGroups, ciTypes, CatCodeDto::getCodeId, CatCodeDto::getCiTypes, parentMapperOfElement);
    }

    private List<CatCodeDto> getEnumCodesByCategoryName(String categoryName) {
        CategoryDto categories = getEnumCategoryByName(categoryName);
        if (categories == null)
            throw new CmdbException("Category not found.");
        return getEnumCodesByCategoryId(categories.getCatId());
    }

    private Integer getLayerCategoryId() {
        return getEnumCategoryByName(uiProperties.getEnumCategoryCiTypeLayer()).getCatId();
    }

    public QueryResponse<CatCodeDto> querySystemEnumCodesWithRefResources(QueryRequest queryObject) {
        queryObject.addEqualsFilter(CONSTANT_CAT_CAT_TYPE, uiProperties.getEnumCategoryTypeSystem());
        queryObject.addReferenceResource("cat");
        queryObject.addReferenceResource(CONSTANT_CAT_CAT_TYPE);
        return queryEnumCodes(queryObject);
    }

    public QueryResponse<CatCodeDto> queryNonSystemEnumCodesWithRefResources(QueryRequest queryObject) {
        queryObject.addNotEqualsFilter("cat.catTypeId", uiProperties.getEnumCategoryTypeSystem());
        queryObject.addReferenceResource("cat");
        queryObject.addReferenceResource(CONSTANT_CAT_CAT_TYPE);
        return queryEnumCodes(queryObject);
    }

    public QueryResponse<CategoryDto> getAllNonSystemEnumCategories() {
        QueryRequest queryObject = new QueryRequest();
        queryObject.addNotEqualsFilter(CONSTANT_CAT_TYPE_ID, uiProperties.getEnumCategoryTypeSystem());
        return queryEnumCategories(queryObject);
    }

    public List<CatCodeDto> getGroupListByCatId(int categoryId) {
        return getEnumCodesByCategoryId(getEnumCategoryByCatId(categoryId).getGroupTypeId());
    }

    public List<CatCodeDto> getCiTypeStatusOptions(int ciTypeId) {
        List<CiTypeAttrDto> statusCiTypeAttributes = queryCiTypeAttributes(
                defaultQueryObject(CONSTANT_CI_TYPE_ID, ciTypeId)
                        .addEqualsFilter("propertyName", uiProperties.getStatusAttributeName()));
        if (isNotEmpty(statusCiTypeAttributes)) {
            return getEnumCodesByCategoryId(statusCiTypeAttributes.get(0).getReferenceId());
        }
        return Lists.newArrayList();
    }

    public QueryResponse<?> getCiDataByCiTypeId(Integer ciTypeId) {
        return queryCiData(ciTypeId, defaultQueryObject());
    }

    public List<CatTypeDto> createEnumCategoryTypes(CatTypeDto... catTypeDtos) {
        return staticDtoService.create(CatTypeDto.class, Arrays.asList(catTypeDtos));
    }

    public List<CatTypeDto> getAllEnumCategoryTypes() {
        QueryResponse<CatTypeDto> response = staticDtoService.query(CatTypeDto.class, defaultQueryObject());
        return response != null ? response.getContents() : null;
    }

    public CatTypeDto getEnumCategoryTypeByCiTypeId(Integer ciTypeId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter(CONSTANT_CI_TYPE_ID, ciTypeId);
        QueryResponse<CatTypeDto> response = staticDtoService.query(CatTypeDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<CategoryDto> createEnumCategories(CategoryDto... categoryDtos) {
        return staticDtoService.create(CategoryDto.class, Arrays.asList(categoryDtos));
    }

    public QueryResponse<CategoryDto> queryEnumCategories(QueryRequest queryObject) {
        return staticDtoService.query(CategoryDto.class, queryObject);
    }

    public QueryResponse<CategoryDto> getAllEnumCategories() {
        return staticDtoService.query(CategoryDto.class, defaultQueryObject());
    }

    public QueryResponse<CategoryDto> getEnumCategoriesByTypeId(Integer enumCategoryTypeId) {
        return staticDtoService.query(CategoryDto.class, defaultQueryObject("catTypeId", enumCategoryTypeId));
    }

    public CategoryDto getEnumCategoryByName(String categoryName) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("catName", categoryName);
        QueryResponse<CategoryDto> response = staticDtoService.query(CategoryDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public CategoryDto getEnumCategoryByCatId(int catId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter(CONSTANT_CAT_ID, catId);
        QueryResponse<CategoryDto> response = staticDtoService.query(CategoryDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<CategoryDto> updateEnumCategories(List<Map<String, Object>> categoryDtos) {
        return staticDtoService.update(CategoryDto.class, categoryDtos);
    }

    public void deleteEnumCategories(Integer... ids) {
        staticDtoService.delete(CategoryDto.class, Arrays.asList(ids));
    }

    public QueryResponse<CatCodeDto> queryEnumCodes(QueryRequest queryObject) {
        return staticDtoService.query(CatCodeDto.class, queryObject);
    }

    public List<CatCodeDto> getEnumCodesByCategoryId(Integer categoryId) {
        QueryResponse<CatCodeDto> response = staticDtoService.query(CatCodeDto.class, defaultQueryObject(CONSTANT_CAT_ID, categoryId).ascendingSortBy(CONSTANT_SEQ_NO));
        return response != null ? response.getContents() : null;
    }

    public List<CatCodeDto> getEnumCodesByFieldNameWithValueAndCatId(String fieldName, Object value, Integer catId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter(CONSTANT_CAT_ID, catId)
                .addEqualsFilter(fieldName, value);
        QueryResponse<CatCodeDto> response = staticDtoService.query(CatCodeDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public CatCodeDto getEnumCodeById(Integer id) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("codeId", id);
        QueryResponse<CatCodeDto> response = staticDtoService.query(CatCodeDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<CatCodeDto> updateEnumCodes(List<Map<String, Object>> catCodeDtos) {
        catCodeDtos.forEach(dto -> {
            dto.remove("ciTypes");
            Object groupCodeId = dto.get("groupCodeId");
            if (groupCodeId != null && !(groupCodeId instanceof Integer)) {
                dto.remove("groupCodeId");
            }
        });
        return staticDtoService.update(CatCodeDto.class, catCodeDtos);
    }

    public void deleteEnumCodes(Integer... ids) {
        staticDtoService.delete(CatCodeDto.class, Arrays.asList(ids));
    }

    public List<CiTypeDto> createCiTypes(CiTypeDto... ciTypes) {
        return staticDtoService.create(CiTypeDto.class, Arrays.asList(ciTypes));
    }

    public List<CiTypeDto> updateCiTypes(List<Map<String, Object>> ciTypes) {
        return staticDtoService.update(CiTypeDto.class, ciTypes);
    }

    public List<CiTypeDto> getAllCiTypes(boolean withAttributes, String status) {
        QueryRequest request = new QueryRequest();

        if (status != null) {
            request.getFilters().add(new Filter("status", FilterOperator.In.getCode(), Arrays.asList(status.split(","))));
        }

        if (withAttributes) {
            request.getRefResources().add(CONSTANT_ATTRIBUTES);
            if (status != null) {
                request.getFilters().add(new Filter("attributes.status", FilterOperator.In.getCode(), Arrays.asList(status.split(","))));
            }
        }

        QueryResponse<CiTypeDto> response = staticDtoService.query(CiTypeDto.class, request);
        return response.getContents();
    }

    public void deleteCiTypes(Integer... ids) {
        staticDtoService.delete(CiTypeDto.class, Arrays.asList(ids));
    }

    public List<CiTypeAttrDto> createCiTypeAttribute(CiTypeAttrDto ciTypeAttribute) {
        return staticDtoService.create(CiTypeAttrDto.class, Lists.newArrayList(ciTypeAttribute));
    }

    public List<CiTypeAttrDto> getCiTypeAttributesByCiTypeId(Integer ciTypeId) {
        return queryCiTypeAttributes(defaultQueryObject(CONSTANT_CI_TYPE_ID, ciTypeId).ascendingSortBy("displaySeqNo"));
    }

    public List<CiTypeAttrDto> queryCiTypeAttributes(QueryRequest queryObject) {
        QueryResponse<CiTypeAttrDto> response = staticDtoService.query(CiTypeAttrDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public AdmCiTypeAttr getCiTypeAttribute(Integer ciTypeAttributeId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("idAdmCiTypeAttr", ciTypeAttributeId);
        QueryResponse<AdmCiTypeAttr> response = staticEntityRepository.query(AdmCiTypeAttr.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<CiTypeAttrDto> updateCiTypeAttributes(List<Map<String, Object>> ciTypeAttributes) {
        return staticDtoService.update(CiTypeAttrDto.class, ciTypeAttributes);
    }

    public void deleteCiTypeAttributes(Integer... ids) {
        staticDtoService.delete(CiTypeAttrDto.class, Arrays.asList(ids));
    }

    public void applyCiType(Integer... ids) {
        ciTypeService.applyCiType(Arrays.asList(ids));
    }

    public void applyCiTypes() {
        ciTypeService.applyAllCiType();
    }

    public void applyCiTypeAttributes(Integer... applyObject) {
        ciTypeService.applyCiTypeAttr(Arrays.asList(applyObject));
    }

    public List<Map<String, Object>> createCiData(Integer ciTypeId, List<Map<String, Object>> ciDatas) {
        return ciService.create(ciTypeId, ciDatas);
    }

    public QueryResponse<CiData> queryCiDataShowPassword(Integer ciTypeId, QueryRequest queryObject,boolean showPassword) {
        if (queryObject == null) {
            queryObject = QueryRequest.defaultQueryObject().descendingSortBy(CmdbConstants.DEFAULT_FIELD_CREATED_DATE);
        } else if (queryObject.getSorting() == null || queryObject.getSorting().getField() == null) {
            queryObject.setSorting(new Sorting(false, CmdbConstants.DEFAULT_FIELD_CREATED_DATE));
        }
        QueryResponse<CiData> queryData = ciService.query(ciTypeId, queryObject);
        if(showPassword){
            return queryData;
        }
        return changePasswordView(ciTypeId, queryObject,queryData);
    }

    public QueryResponse<CiData> queryCiData(Integer ciTypeId, QueryRequest queryObject) {
        return queryCiDataShowPassword(ciTypeId,queryObject,false);
    }

    private QueryResponse<CiData> changePasswordView(Integer ciTypeId, QueryRequest queryObject,QueryResponse<CiData> queryData) {
        List<AdmCiTypeAttr> ciAttrs = admCiTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        List<String> passwordField = new ArrayList<>();
        for (AdmCiTypeAttr ciTypeAttrs:ciAttrs) {
            if(CmdbConstants.PASSWORD.equalsIgnoreCase(ciTypeAttrs.getInputType())){
                passwordField.add(ciTypeAttrs.getPropertyName());
            }
        }
        for (CiData cidata:queryData.getContents()) {
            for (String key:passwordField) {
                if (cidata.getData().containsKey(key)) {
                    cidata.getData().put(key, CmdbConstants.PASSWORD_SHOW);
                }
            }
        }
        return queryData;
    }

    public QueryResponse<CiData> queryCiDataByType(Integer ciTypeId, QueryRequest queryObject) {
        if (queryObject == null) {
            queryObject = QueryRequest.defaultQueryObject().descendingSortBy(CmdbConstants.DEFAULT_FIELD_CREATED_DATE);
        } else if (queryObject.getSorting() == null || queryObject.getSorting().getField() == null) {
            queryObject.getDialect().setShowCiHistory(false);
            queryObject.setSorting(new Sorting(false, CmdbConstants.DEFAULT_FIELD_CREATED_DATE));
        }
        queryObject.addNotEqualsFilter("state", uiProperties.getEnumIdOfStateDelete());
        QueryResponse<CiData> query = ciService.query(ciTypeId, queryObject);
        List<String> ciDataIds = new ArrayList<>();
        if (query.getContents() == null || query.getContents().size() <= 0) {
            return query;
        }
        query.getContents().forEach(cidata -> {
            String fixedDate = (String) cidata.getData().get(CONSTANT_FIXED_DATE);
            if (StringUtils.isBlank(fixedDate)) {
                String pGuid = (String) cidata.getData().get(CmdbConstants.DEFAULT_FIELD_PARENT_GUID);
                if (StringUtils.isNotBlank(pGuid)) {
                    ciDataIds.add(pGuid);
                }
            } else {
                ciDataIds.add((String) cidata.getData().get(CmdbConstants.DEFAULT_FIELD_GUID));
            }
        });
        if (ciDataIds.size() <= 0) {
            return new QueryResponse<CiData>();
        }
        queryObject.addInFilter(CmdbConstants.DEFAULT_FIELD_GUID, ciDataIds);
        queryObject.getDialect().setShowCiHistory(true);
        return ciService.query(ciTypeId, queryObject);
    }

    public List<Map<String, Object>> updateCiData(Integer ciTypeId, List<Map<String, Object>> ciData) {
        List<Map<String,Object>> filterOfPassword = ciService.filterOfPassword(ciTypeId,ciData);
        return ciService.update(ciTypeId, filterOfPassword);
    }

    public void deleteCiData(Integer ciTypeId, List<String> ids) {
        ciService.delete(ciTypeId, ids);
    }

    public Object operateCiForState(List<CiIndentity> operateCiObject, String operation) {
        return ciService.operateState(operateCiObject, operation);
    }

    public Object getIntegrationQuery(int queryId) {
        return intQueryService.getIntegrationQuery(queryId);
    }

    public Object queryIntHeader(int queryId) {
        return ciService.integrateQueryHeader(queryId);
    }

    public void updateIntQuery(int queryId, IntegrationQueryDto integrationQueryDto) {
        intQueryService.updateIntegrationQuery(queryId, integrationQueryDto);
    }

    public void deleteQuery(int ciTypeId, int queryId) {
        intQueryService.deleteIntegrationQuery(queryId);
    }

    public Object saveIntQuery(int queryId, String queryName, IntegrationQueryDto integrationQueryDto) {
        return intQueryService.createIntegrationQuery(queryId, queryName, integrationQueryDto);
    }

    public Object searchIntQuery(int ciTypeId, String name) {
        if (name == null) {
            return intQueryService.findAll(ciTypeId, null, null);
        } else {
            return intQueryService.findAll(ciTypeId, name, null);
        }
    }

    public IntegrationQueryDto getIntQueryByName(int ciTypeId, int queryId) {
        return intQueryService.getIntegrationQuery(queryId);
    }

    public Object excuteIntQuery(int queryTemplateId, QueryRequest queryObject) {
        return ciService.integrateQuery(queryTemplateId, queryObject);
    }

    public QueryResponse<?> queryReferenceCiData(int referenceAttrId, QueryRequest queryObject) {
        return filterRuleService.queryReferenceCiData(referenceAttrId, queryObject);
    }

//    public QueryResponse<?> queryReferenceEnumCodes(int referenceAttrId, QueryRequest queryObject) {
//        return filterRuleService.queryReferenceEnumCodes(referenceAttrId, queryObject);
//    }

    public List<UserDto> getAllUsers() {
        QueryResponse<UserDto> response = staticDtoService.query(UserDto.class, defaultQueryObject());
        return response != null ? response.getContents() : null;
    }

    public List<RoleDto> getAllRoles() {
        QueryResponse<RoleDto> response = staticDtoService.query(RoleDto.class, defaultQueryObject());
        return response != null ? response.getContents() : null;
    }

    public List<RoleDto> getRolesByUsername(String username) {
        QueryRequest queryObject = defaultQueryObject()
                .addReferenceResource("roleUsers")
                .addReferenceResource("roleUsers.user")
                .addEqualsFilter("roleUsers.user.username", username);
        QueryResponse<RoleDto> response = staticDtoService.query(RoleDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public List<UserDto> getUsersByRoleId(int roleId) {
        QueryRequest queryObject = defaultQueryObject()
                .addReferenceResource("roleUsers")
                .addReferenceResource("roleUsers.role")
                .addEqualsFilter("roleUsers.role.roleId", roleId);
        QueryResponse<UserDto> response = staticDtoService.query(UserDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public List<RoleDto> createRoles(RoleDto... roles) {
        return staticDtoService.create(RoleDto.class, Arrays.asList(roles));
    }

    public List<CiTypeDto> updateRoles(List<Map<String, Object>> roles) {
        return staticDtoService.update(CiTypeDto.class, roles);
    }

    public void deleteRoles(Integer... ids) {
        staticDtoService.delete(RoleDto.class, Arrays.asList(ids));
    }

    public List<RoleUserDto> getRoleUsers(QueryRequest queryObject) {
        QueryResponse<RoleUserDto> response = staticDtoService.query(RoleUserDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public List<RoleUserDto> createRoleUsers(RoleUserDto... roleUsers) {
        return staticDtoService.create(RoleUserDto.class, Arrays.asList(roleUsers));
    }

    public void deleteRoleUsers(Integer... ids) {
        staticDtoService.delete(RoleUserDto.class, Arrays.asList(ids));
    }

    public List<RoleCiTypeDto> queryRoleCiTypes(QueryRequest queryObject) {
        QueryResponse<RoleCiTypeDto> response = staticDtoService.query(RoleCiTypeDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public List<RoleCiTypeDto> getRoleCiTypeByRoleId(int roleId) {
        return queryRoleCiTypes(defaultQueryObject()
                .addReferenceResource("roleCiTypeCtrlAttrs")
                .addEqualsFilter("roleId", roleId));
    }

    public List<RoleCiTypeDto> getRoleCiTypeByUsername(String username) {
        return queryRoleCiTypes(defaultQueryObject()
                .addReferenceResource("role")
                .addReferenceResource("role.roleUsers")
                .addReferenceResource("role.roleUsers.user")
                .addReferenceResource("roleCiTypeCtrlAttrs")
                .addEqualsFilter("role.roleUsers.user.username", username));
    }

    public RoleCiTypeDto getRoleCiTypeByRoleIdAndCiTypeId(int roleId, int ciTypeId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("roleId", roleId).addEqualsFilter(CONSTANT_CI_TYPE_ID, ciTypeId);
        QueryResponse<RoleCiTypeDto> response = staticDtoService.query(RoleCiTypeDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public RoleCiTypeDto getRoleCiTypeById(Integer roleCiTypeId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("roleCiTypeId", roleCiTypeId);
        QueryResponse<RoleCiTypeDto> response = staticDtoService.query(RoleCiTypeDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<RoleCiTypeDto> createRoleCiTypes(RoleCiTypeDto... roleCiTypes) {
        return staticDtoService.create(RoleCiTypeDto.class, Arrays.asList(roleCiTypes));
    }

    public List<RoleCiTypeDto> updateRoleCiTypes(List<Map<String, Object>> roleCiTypes) {
        return staticDtoService.update(RoleCiTypeDto.class, roleCiTypes);
    }

    public List<RoleCiTypeCtrlAttrDto> queryRoleCiTypeCtrlAttributes(QueryRequest queryObject) {
        QueryResponse<RoleCiTypeCtrlAttrDto> response = staticDtoService.query(RoleCiTypeCtrlAttrDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public List<RoleCiTypeCtrlAttrDto> getRoleCiTypeCtrlAttributesByRoleCiTypeId(int roleCiTypeId) {
        return queryRoleCiTypeCtrlAttributes(defaultQueryObject()
                .addReferenceResource("conditions")
                .addEqualsFilter("roleCiTypeId", roleCiTypeId));
    }

    public RoleCiTypeCtrlAttrDto getRoleCiTypeCtrlAttributeById(Integer roleCiTypeCtrlAttrId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("roleCiTypeCtrlAttrId", roleCiTypeCtrlAttrId);
        QueryResponse<RoleCiTypeCtrlAttrDto> response = staticDtoService.query(RoleCiTypeCtrlAttrDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<RoleCiTypeCtrlAttrDto> createRoleCiTypeCtrlAttributes(RoleCiTypeCtrlAttrDto... roleCiTypeCtrlAttrs) {
        return staticDtoService.create(RoleCiTypeCtrlAttrDto.class, Arrays.asList(roleCiTypeCtrlAttrs));
    }

    public RoleCiTypeCtrlAttrDto createRoleCiTypeCtrlAttribute(RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr) {
        List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs = createRoleCiTypeCtrlAttributes(roleCiTypeCtrlAttr);
        if (isEmpty(roleCiTypeCtrlAttrs)) {
            throw new CmdbException("Create role CiType ctrl attr failure.");
        }
        return roleCiTypeCtrlAttrs.get(0);
    }

    public List<RoleCiTypeCtrlAttrDto> updateRoleCiTypeCtrlAttributes(List<Map<String, Object>> roleCiTypeCtrlAttrs) {
        return staticDtoService.update(RoleCiTypeCtrlAttrDto.class, roleCiTypeCtrlAttrs);
    }

    @Transactional
    public void deleteRoleCiTypeCtrlAttributes(List<Integer> ids) {
        roleCiTypeAccessCtrlService.deleteRoleCiTypeCtrlAttributes(ids);
    }

    public RoleCiTypeCtrlAttrConditionDto getRoleCiTypeCtrlAttributeConditionById(Integer conditionId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("conditionId", conditionId);
        QueryResponse<RoleCiTypeCtrlAttrConditionDto> response = staticDtoService.query(RoleCiTypeCtrlAttrConditionDto.class, queryObject);
        if (response != null && !response.getContents().isEmpty()) {
            return response.getContents().get(0);
        }
        return null;
    }

    public List<RoleCiTypeCtrlAttrConditionDto> createRoleCiTypeCtrlAttrConditions(RoleCiTypeCtrlAttrConditionDto... roleCiTypeCtrlAttrConditions) {
        return staticDtoService.create(RoleCiTypeCtrlAttrConditionDto.class, Arrays.asList(roleCiTypeCtrlAttrConditions));
    }

    public RoleCiTypeCtrlAttrConditionDto createRoleCiTypeCtrlAttrCondition(RoleCiTypeCtrlAttrConditionDto roleCiTypeCtrlAttrCondition) {
        List<RoleCiTypeCtrlAttrConditionDto> roleCiTypeCtrlAttrConditions = createRoleCiTypeCtrlAttrConditions(roleCiTypeCtrlAttrCondition);
        if (isEmpty(roleCiTypeCtrlAttrConditions)) {
            throw new CmdbException("Create role CiType ctrl attr condition failure.");
        }
        return roleCiTypeCtrlAttrConditions.get(0);
    }

    public List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(List<Map<String, Object>> roleCiTypeCtrlAttrConditions) {
        return staticDtoService.update(RoleCiTypeCtrlAttrConditionDto.class, roleCiTypeCtrlAttrConditions);
    }

    public List<CiTypeAttrDto> getCiTypeAccessControlAttributesByCiTypeId(Integer ciTypeId) {
        QueryRequest request = defaultQueryObject(CONSTANT_CI_TYPE_ID, ciTypeId).addEqualsFilter("isAccessControlled", 1).ascendingSortBy("displaySeqNo");
        QueryResponse<CiTypeAttrDto> queryResult = staticDtoService.query(CiTypeAttrDto.class, request);
        return queryResult != null ? queryResult.getContents() : null;
    }

    public List<CatCodeDto> getEnumCodesByIds(List<Integer> ids) {
        QueryResponse<CatCodeDto> queryResult = staticDtoService.query(CatCodeDto.class, defaultQueryObject().addInFilter("codeId", ids));
        return queryResult != null ? queryResult.getContents() : null;
    }

    public List<CiData> getCiDataByGuid(Integer ciTypeId, List<String> guidList) {
        QueryResponse<CiData> response = ciService.query(ciTypeId, defaultQueryObject().addInFilter(CmdbConstants.GUID, guidList));
        return response != null ? response.getContents() : null;
    }

    public RoleCiTypeCtrlAttrDto updateRoleCiTypeCtrlAttribute(RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr) {
        List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs = updateRoleCiTypeCtrlAttributes(Lists.newArrayList(BeanMapUtils.convertBeanToMap(roleCiTypeCtrlAttr)));
        if (isEmpty(roleCiTypeCtrlAttrs))
            throw new CmdbException("Update role CiType ctrl attr failure.");
        return roleCiTypeCtrlAttrs.get(0);
    }

    public List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(RoleCiTypeCtrlAttrConditionDto... roleCiTypeCtrlAttrConditions) {
        return staticDtoService.update(RoleCiTypeCtrlAttrConditionDto.class, BeanMapUtils.convertBeansToMaps(Arrays.asList(roleCiTypeCtrlAttrConditions)));
    }

    public List<RoleCiTypeDto> updateRoleCiTypes(RoleCiTypeDto... roleCiTypes) {
        return staticDtoService.update(RoleCiTypeDto.class, BeanMapUtils.convertBeansToMaps(Arrays.asList(roleCiTypes)));
    }

    public void implementCiType(Integer ciTypeId, String operation) {
        ciTypeService.implementCiType(ciTypeId, ImplementOperation.fromCode(operation));
    }

    public void implementCiTypeAttribute(Integer attributeId, String operation) {
        ciTypeService.implementCiTypeAttr(attributeId, ImplementOperation.fromCode(operation));
    }

    public List<CiData> getAllIdcDesignData() {
        QueryResponse<CiData> response = ciService.query(uiProperties.getCiTypeIdOfIdcDesign(), defaultQueryObject());
        return response != null ? response.getContents() : null;
    }

    public List<ResourceTreeDto> getIdcDesignTreesByGuid(List<String> idcDesignGuids) {
        return getDataTreesByCiTypeIdAndGuid(uiProperties.getCiTypeIdOfIdcDesign(), idcDesignGuids);
    }

    public void recursiveGetChildrenData(Integer ciTypeId, List<Integer> limitedCiTypes, List<ResourceTreeDto> resourceTrees, Map<String, Object> inputFilters) {
        List<CiData> ciDatas = queryCiData(ciTypeId, buildQueryObjectWithEqualsFilter(inputFilters)).getContents();
        for (int i = 0; i < ciDatas.size(); i++) {
            CiData ciData = ciDatas.get(i);
            Map<String, Object> ciDataMap = ciData.getData();
            resourceTrees.add(buildNewResourceTreeDto(ciData, ciTypeId));

            List<CiTypeAttrDto> childrenCiTypeRelativeAttributes = findChildrenCiTypeRelativeAttributes(ciTypeId, uiProperties.getReferenceCodeOfBelong());

            if (childrenCiTypeRelativeAttributes.size() != 0) {
                recursiveGetChildrenDataByRelativeAttributes(childrenCiTypeRelativeAttributes, limitedCiTypes, ciDataMap.get(CmdbConstants.GUID).toString(), resourceTrees.get(i).getChildren());
                continue;
            }

            List<CiTypeAttrDto> runningCiTypeRelativeAttributes = findChildrenCiTypeRelativeAttributes(ciTypeId, uiProperties.getReferenceCodeOfRunning());
            if (runningCiTypeRelativeAttributes.size() != 0) {
                recursiveGetChildrenDataByRelativeAttributes(runningCiTypeRelativeAttributes, limitedCiTypes, ciDataMap.get(CmdbConstants.GUID).toString(), resourceTrees.get(i).getChildren());
            }
        }
    }

    private List<ResourceTreeDto> getDataTreesByCiTypeIdAndGuid(int ciTypeId, List<String> guids) {
        List<Integer> sameLayerCiTypes = getSameCiTypesByCiTypeId(ciTypeId);
        List<ResourceTreeDto> resourceTrees = new ArrayList<>();
        QueryResponse<CiData> response = ciService.query(ciTypeId, defaultQueryObject().addInFilter(CmdbConstants.GUID, guids));

        if (response == null || response.getContents() == null || response.getContents().size() == 0) {
            return null;
        }

        List<CiData> ciDatas = response.getContents();

        for (int i = 0; i < ciDatas.size(); i++) {
            CiData ciData = ciDatas.get(i);
            resourceTrees.add(buildNewResourceTreeDto(ciData, ciTypeId));
            Map<String, Object> ciDataMap = ciData.getData();
            List<CiTypeAttrDto> childrenCiTypeRelativeAttributes = findChildrenCiTypeRelativeAttributes(ciTypeId, uiProperties.getReferenceCodeOfBelong());

            if (childrenCiTypeRelativeAttributes.size() == 0) {
                return resourceTrees;
            }

            for (CiTypeAttrDto childrenCiTypeRelativeAttribute : childrenCiTypeRelativeAttributes) {
                Map<String, Object> filter = new HashMap<>();
                if (!sameLayerCiTypes.contains(childrenCiTypeRelativeAttribute.getCiTypeId())) {
                    continue;
                }
                filter.put(childrenCiTypeRelativeAttribute.getPropertyName(), ciDataMap.get(CmdbConstants.GUID).toString());
                recursiveGetChildrenData(childrenCiTypeRelativeAttribute.getCiTypeId(), sameLayerCiTypes, resourceTrees.get(i).getChildren(), filter);
            }
        }
        return resourceTrees;
    }

    private List<Integer> getSameCiTypesByCiTypeId(Integer ciTypeId) {
        List<Integer> ciTypeIds = new ArrayList<>();

        AdmCiType admCiType = staticEntityRepository.findEntityById(AdmCiType.class, ciTypeId);
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("layerId", admCiType.getLayerId());

        QueryResponse<CiTypeDto> ciTypeDtos = staticDtoService.query(CiTypeDto.class, queryObject);
        if (ciTypeDtos != null && ciTypeDtos.getContents() != null) {
            for (CiTypeDto ciType : ciTypeDtos.getContents()) {
                ciTypeIds.add(ciType.getCiTypeId());
            }
        }

        return ciTypeIds;
    }

    private ResourceTreeDto buildNewResourceTreeDto(CiData ciData, Integer ciTypeId) {
        ResourceTreeDto resourceTree = new ResourceTreeDto();
        Map<String, Object> data = ciData.getData();
        resourceTree.setGuid(data.get(CmdbConstants.GUID).toString());
        resourceTree.setCiTypeId(ciTypeId);
        resourceTree.setData(data);

        return resourceTree;
    }

    private List<CiTypeAttrDto> findChildrenCiTypeRelativeAttributes(Integer ciTypeId, String referenceCode) {
        List<CiTypeAttrDto> ChildrenCiTypeRelativeAttributes = new ArrayList<>();
        List<CiTypeAttrDto> referenceByList = getCiTypeReferenceBy(ciTypeId);
        for (CiTypeAttrDto attrDto : referenceByList) {
            if (attrDto.getReferenceType() != null && baseKeyInfoService.getCode(attrDto.getReferenceType()).getCode() != null
                    && baseKeyInfoService.getCode(attrDto.getReferenceType()).getCode().equals(referenceCode)) {
                ChildrenCiTypeRelativeAttributes.add(attrDto);
            }
        }
        return ChildrenCiTypeRelativeAttributes;
    }

    private QueryRequest buildQueryObjectWithEqualsFilter(Map<String, Object> filters) {
        QueryRequest queryObject = defaultQueryObject();
        if (filters != null) {
            for (Map.Entry<String, Object> entry : filters.entrySet()) {
                queryObject.addEqualsFilter(entry.getKey(), entry.getValue());
            }
        }
        return queryObject;
    }

    private void recursiveGetChildrenDataByRelativeAttributes(List<CiTypeAttrDto> childrenCiTypeRelativeAttributes, List<Integer> limitedCiTypes, String guid, List<ResourceTreeDto> children) {
        for (int j = 0; j < childrenCiTypeRelativeAttributes.size(); j++) {
            Map<String, Object> filter = new HashMap<>();
            if (!limitedCiTypes.contains(childrenCiTypeRelativeAttributes.get(j).getCiTypeId())) {
                continue;
            }
            filter.put(childrenCiTypeRelativeAttributes.get(j).getPropertyName(), guid);
            recursiveGetChildrenData(childrenCiTypeRelativeAttributes.get(j).getCiTypeId(), limitedCiTypes, children, filter);
        }
    }

    private void recursiveGetChildrenDataByRelativeAttributes(List<CiTypeAttrDto> childrenCiTypeRelativeAttributes, String stateEnumCode, String guid, List<ResourceTreeDto> children, Filter fixDate) {
        if (childrenCiTypeRelativeAttributes.size() != 0) {

            for (CiTypeAttrDto childrenCiTypeRelativeAttribute : childrenCiTypeRelativeAttributes) {
                QueryRequest defaultQueryObject = QueryRequest.defaultQueryObject();
                defaultQueryObject.addEqualsFilter(childrenCiTypeRelativeAttribute.getPropertyName(), guid);
                List<CiTypeAttrDto> attr = getCiTypeAttributesByCiTypeIdAndPropertyName(childrenCiTypeRelativeAttribute.getCiTypeId(), uiProperties.getPropertyNameOfState());
                if (attr.size() == 0) {
                    continue;
                }

                int stateEnumCatOfChildren = attr.get(0).getReferenceId();
                recursiveGetChildrenDataFilterState(childrenCiTypeRelativeAttribute.getCiTypeId(), stateEnumCatOfChildren, stateEnumCode, children, defaultQueryObject, fixDate);
            }
        }
    }

    public List<ZoneLinkDto> getAllZoneLinkDesignGroupByIdcDesign() {
        List<ZoneLinkDto> results = new ArrayList<>();

        List<CiData> idcDesignData = queryCiData(uiProperties.getCiTypeIdOfIdcDesign(), defaultQueryObject()).getContents();
        if (idcDesignData == null) {
            return results;
        }

        for (CiData idcDesign : idcDesignData) {
            String idcDesignGuid = idcDesign.getData().get(CmdbConstants.GUID).toString();

            ZoneLinkDto result = new ZoneLinkDto();
            result.setIdcGuid(idcDesignGuid);

            List<CiData> zoneDesignData = queryCiData(uiProperties.getCiTypeIdOfZoneDesign(), defaultQueryObject().addEqualsFilter("data_center_design", idcDesignGuid)).getContents();
            List<String> zoneDesignList = new ArrayList<>();
            for (Object zoneDesign : zoneDesignData) {
                zoneDesignList.add(idcDesign.getData().get(CmdbConstants.GUID).toString());
            }

            if (zoneDesignList.size() != 0) {
                List<CiData> zoneDesignLinkData = queryCiData(uiProperties.getCiTypeIdOfZoneLinkDesign(),
                        defaultQueryObject()
                                .addInFilter("network_zone_design_1", zoneDesignList)
                                .addInFilter("network_zone_design_2", zoneDesignList)
                                .setFiltersRelationship("or")).getContents();
                result.setLinkList(zoneDesignLinkData);
            }
            results.add(result);
        }
        return results;
    }

    public List<CiData> getAllIdcData() {
        return queryCiData(uiProperties.getCiTypeIdOfIdc(), defaultQueryObject()).getContents();
    }

    public List<ResourceTreeDto> getIdcTreeByGuid(List<String> idcGuids) {
        return getDataTreesByCiTypeIdAndGuid(uiProperties.getCiTypeIdOfIdc(), idcGuids);
    }

    public List<ZoneLinkDto> getAllZoneLinkGroupByIdc() {
        List<ZoneLinkDto> results = new ArrayList<>();

        List<CiData> idcData = queryCiData(uiProperties.getCiTypeIdOfIdc(), defaultQueryObject()).getContents();
        for (CiData idc : idcData) {
            String idcGuid = idc.getData().get(CmdbConstants.GUID).toString();

            ZoneLinkDto result = new ZoneLinkDto();
            result.setIdcGuid(idcGuid);

            List<CiData> zoneData = queryCiData(uiProperties.getCiTypeIdOfZone(), defaultQueryObject().addEqualsFilter("data_center", idcGuid)).getContents();
            List<String> zoneList = new ArrayList<>();
            for (CiData zone : zoneData) {
                zoneList.add(zone.getData().get(CmdbConstants.GUID).toString());
            }
            if (zoneList.size() != 0) {
                QueryRequest setFiltersRelationship = defaultQueryObject()
                .addInFilter("network_zone_1", zoneList)
                .addInFilter("network_zone_2", zoneList)
                .setFiltersRelationship("or");
                setFiltersRelationship.getDialect().setShowCiHistory(true);
                List<CiData> zoneLinkData = queryCiData(uiProperties.getCiTypeIdOfZoneLink(),setFiltersRelationship)
                                        .getContents();
                result.setLinkList(zoneLinkData);
            }
            results.add(result);
        }
        return results;
    }

    public Object getSystemDesigns() {
        QueryRequest defaultQueryObject = defaultQueryObject();
        defaultQueryObject.getDialect().setShowCiHistory(true);
        return queryCiData(uiProperties.getCiTypeIdOfSystemDesign(), defaultQueryObject);
    }

    public Object getSystems() {
        return queryCiData(uiProperties.getCiTypeIdOfSystem(), defaultQueryObject());
    }

    public List<ResourceTreeDto> getAllDesignTreesFromSystemDesign(String systemDesignGuid) {
        List<ResourceTreeDto> designTrees = new ArrayList<>();
        int systemDesignCiTypeId = uiProperties.getCiTypeIdOfSystemDesign();
        List<CiTypeAttrDto> attr = getCiTypeAttributesByCiTypeIdAndPropertyName(systemDesignCiTypeId, uiProperties.getPropertyNameOfState());
        if (attr.size() == 0) {
            return null;
        }

        int stateEnumCat = attr.get(0).getReferenceId();
        String stateEnumCode = uiProperties.getEnumCodeOfStateDelete();
        QueryRequest defaultQueryRequest = QueryRequest.defaultQueryObject();
        defaultQueryRequest.addEqualsFilter(CmdbConstants.GUID, systemDesignGuid);
        Filter fixDateFilter = getFixDateFilter(systemDesignCiTypeId, systemDesignGuid);

        recursiveGetChildrenDataFilterState(systemDesignCiTypeId, stateEnumCat, stateEnumCode, designTrees, defaultQueryRequest, fixDateFilter);

        return designTrees;
    }

    private Filter getFixDateFilter(int systemDesignCiTypeId, String systemDesignGuid) {
        Map<String, Object> ciData = ciService.getCi(systemDesignCiTypeId, systemDesignGuid);

        String fixDate = (String) ciData.get(CONSTANT_FIXED_DATE);

        Filter fixDateFilter = null;
        if (StringUtils.isNotBlank(fixDate)) {
            fixDateFilter = new Filter(CONSTANT_FIXED_DATE, FilterOperator.LessEqual.getCode(), fixDate);
        }
        return fixDateFilter;
    }

    public List<CiTypeAttrDto> getCiTypeAttributesByCiTypeIdAndPropertyName(int ciTypId, String propertyName) {
        QueryRequest queryObject = new QueryRequest();
        queryObject.setFilterRs("and");
        queryObject.addEqualsFilter(CONSTANT_CI_TYPE_ID, ciTypId);
        queryObject.addEqualsFilter("propertyName", propertyName);
        return queryCiTypeAttributes(queryObject);
    }

    public void recursiveGetChildrenDataFilterState(Integer ciTypeId, int stateEnumCat, String stateEnumCode, List<ResourceTreeDto> resourceTrees, QueryRequest inputFilters, Filter fixDate) {
        inputFilters = setQueryRequest(inputFilters, fixDate, ciTypeId);

        List<CiData> ciDatas = queryCiData(ciTypeId, inputFilters).getContents();

        for (int i = 0; i < ciDatas.size(); i++) {
            CiData ciData = ciDatas.get(i);
            Map<String, Object> ciDataMap = ciData.getData();
            ResourceTreeDto resourceTreeDto = buildNewResourceTreeDto(ciData, ciTypeId);

            /*
             * List<CiTypeAttrDto> ciTypeAttributes = (List<CiTypeAttrDto>)
             * resourceTreeDto.getAttrs();
             * 
             * if (checkCiTypeAttributes(ciTypeAttributes, stateEnumCat, stateEnumCode,
             * ciDataMap)) { continue; }
             */

            resourceTrees.add(resourceTreeDto);
            List<CiTypeAttrDto> childrenCiTypeRelativeAttributes = findChildrenCiTypeRelativeAttributes(ciTypeId, uiProperties.getReferenceCodeOfBelong());
            recursiveGetChildrenDataByRelativeAttributes(childrenCiTypeRelativeAttributes, stateEnumCode, ciDataMap.get(CmdbConstants.DEFAULT_FIELD_ROOT_GUID).toString(), resourceTrees.get(i).getChildren(), fixDate);
        }
    }

    private QueryRequest setQueryRequest(QueryRequest inputFilters, Filter fixDate, Integer ciTypeId) {
        if (fixDate == null) {
            return inputFilters;
        }
        QueryRequest queryData = defaultQueryObject();
        
        if (inputFilters.getFilters().size() == 1) {
            queryData.getFilters().add(inputFilters.getFilters().get(0));
        }
        inputFilters.getDialect().setShowCiHistory(true);
        inputFilters.setGroupBys(Arrays.asList(CONSTANT_R_GUID_PATH));
        inputFilters.getFilters().add(fixDate);
        inputFilters.addNotEmptyFilter(CONSTANT_FIXED_DATE);
        inputFilters.setSorting(new Sorting(false, CmdbConstants.DEFAULT_FIELD_ROOT_GUID));
        List<CiData> ciDatas = queryCiData(ciTypeId, inputFilters).getContents();
        if (ciDatas == null || ciDatas.size() <= 0) {
            return inputFilters;
        }
        List<String> guids = ciDatas.stream().map(ciData ->{
            return ciData.getData().get(CmdbConstants.GUID).toString();
        }).collect(Collectors.toList());
        queryData.addInFilter(CmdbConstants.GUID, guids);
        queryData.getDialect().setShowCiHistory(true);
        return queryData;
    }

    private boolean checkCiTypeAttributes(List<CiTypeAttrDto> ciTypeAttributes, int stateEnumCat, String stateEnumCode, Map ciDataMap) {
        boolean delconFlag = true;
        for (CiTypeAttrDto ciTypeAttribute : ciTypeAttributes) {
            if (ciTypeAttribute.getInputType().equals(CONSTANT_SELECT) && ciTypeAttribute.getReferenceId() == stateEnumCat) {
                delconFlag = false;
                try {
                    Map catCodeData = (Map) ciDataMap.get(ciTypeAttribute.getPropertyName());
                    String fixedDate = ciDataMap.get(CONSTANT_FIXED_DATE).toString();
                    if (stateEnumCode.equalsIgnoreCase(catCodeData.get("code").toString()) && fixedDate != null && fixedDate.length() > 0) {
                        delconFlag = true;
                        break;
                    }
                } catch (Exception e) {
                    log.error("check state & fixed_date error:" + e.getMessage());
                }
            }
        }
        return delconFlag;
    }

    public void saveAllDesignTreesFromSystemDesign(String systemDesignGuid) {
        List<ResourceTreeDto> designTrees = getAllDesignTreesFromSystemDesign(systemDesignGuid);
        List<CiIndentity> operateCiDtos = Lists.newArrayList();
        recursiveUpdateChildrenFixedDate(designTrees, operateCiDtos);
        ciService.operateState(operateCiDtos, "confirm");
    }

    public void recursiveUpdateChildrenFixedDate(List<ResourceTreeDto> designTrees, List<CiIndentity> operateCiDtos) {
        for (ResourceTreeDto treeDto : designTrees) {
            Object fixedDate = ((Map) treeDto.getData()).get(uiProperties.getPropertyNameOfFixedDate());
            if (fixedDate == null || ((String) fixedDate).length() == 0) {
                operateCiDtos.add(new CiIndentity(treeDto.getCiTypeId(), treeDto.getGuid()));
            }
            if (treeDto.getChildren() != null) {
                recursiveUpdateChildrenFixedDate(treeDto.getChildren(), operateCiDtos);
            }
        }
    }

    public Object getArchitectureDesignTabs() {
        return getEnumCodesByCategoryName(uiProperties.getCatNameOfArchitectureDesign());
    }

    public Object getPlanningDesignTabs() {
        return getEnumCodesByCategoryName(uiProperties.getCatNameOfPlanningDesign());
    }

    public Object getResourcePlanningTabs() {
        return getEnumCodesByCategoryName(uiProperties.getCatNameOfResoursePlanning());
    }

    public Object getArchitectureCiData(Integer codeId, String systemDesignGuid, QueryRequest queryObject,String rGuid) {
        Integer systemDesignCiTypeId = uiProperties.getCiTypeIdOfSystemDesign();
        Filter fixDateFilter = getFixDateFilter(systemDesignCiTypeId, systemDesignGuid);
        CatCodeDto code = getEnumCodeById(codeId);
        Integer ciTypeId = Integer.parseInt(code.getCode());
        queryObject = setQueryRequest(queryObject, fixDateFilter, ciTypeId);
        
        return getCiDataHistory(codeId, null, rGuid, queryObject, systemDesignCiTypeId,true);
    }
    private Object getCiData(Integer codeId, String envCode, String systemDesignGuid, QueryRequest queryObject, int systemDesignCiTypeId) {
        return getCiDataHistory(codeId, envCode, systemDesignGuid, queryObject, systemDesignCiTypeId,false);
    }
    private Object getCiDataHistory(Integer codeId, String envCode, String systemDesignGuid, QueryRequest queryObject, int systemDesignCiTypeId,boolean showHistory) {
        List<String> guid = Arrays.asList(systemDesignGuid.split(","));
        CatCodeDto code = getEnumCodeById(codeId);
        Integer ciTypeId = Integer.parseInt(code.getCode());
        CategoryDto enumCategoryByName = getEnumCategoryByName(uiProperties.getEnumCategoryNameOfEnv());
        Integer envEnumCat = null;
        if (enumCategoryByName != null){
            envEnumCat = enumCategoryByName.getCatId();

        }
        List<CatCodeDto> codeOfRoutines = getEnumCodesByGroupId(code.getCodeId());
        String routineForGetingSystemDesignGuid = null;
        if (codeOfRoutines.size() > 0) {
            routineForGetingSystemDesignGuid = codeOfRoutines.get(0).getValue();
        }

        if (routineForGetingSystemDesignGuid == null) {
            queryObject.addInFilter(CmdbConstants.GUID, guid);
            return queryCiData(ciTypeId, queryObject);
        }

        List<Map<String, Object>> ciDatas = this.getAllCiDataOfRootCi(ciTypeId, envEnumCat, envCode, systemDesignCiTypeId,
                guid, routineForGetingSystemDesignGuid, showHistory);
        if (queryObject == null) {
            queryObject = QueryRequest.defaultQueryObject();
        }

        List<Object> guids = ciDatas.stream().map(item -> item.get(CONSTANT_GUID_PATH)).collect(Collectors.toList());
        if (guids.size() == 0) {
            return new QueryResponse<CiData>();
        }

        queryObject.addInFilter(CmdbConstants.GUID, guids);
        return queryCiData(ciTypeId, queryObject);
    }

    public List<CatCodeDto> getEnumCodesByGroupId(Integer groupId) {
        QueryResponse<CatCodeDto> queryResult = staticDtoService.query(CatCodeDto.class, defaultQueryObject("groupCodeId", groupId).ascendingSortBy(CONSTANT_SEQ_NO));
        return queryResult.getContents();
    }
   
    private List<Map<String, Object>> getAllCiDataOfRootCi(int rootCiTypeId, Integer envEnumCat, String envEnumCode, int filterCiTypeId, List<String> guid, String routine, boolean showHistory) {
        List<CiRoutineItem> routineItems = new ArrayList<>();
        try {
            ObjectMapper mapper = new ObjectMapper();
            JavaType javaType = mapper.getTypeFactory().constructCollectionType(ArrayList.class, CiRoutineItem.class);
            routineItems = (List<CiRoutineItem>) mapper.readValue(routine.getBytes(), javaType);
        } catch (Exception e) {
            throw new CmdbException(String.format("Failed to parse the routine [%s]", routine));
        }

        AdhocIntegrationQueryDto rootDto = new AdhocIntegrationQueryDto();

        QueryRequest queryRequest = new QueryRequest();
        List<Filter> filters = new ArrayList<Filter>();
        String enumPorpertyNameOfEnv = getEnumPropertyNameByCiTypeId(rootCiTypeId, envEnumCat);

        if (envEnumCode != null && enumPorpertyNameOfEnv != null) {
            Filter rootCifilter = new Filter("root$" + enumPorpertyNameOfEnv, "eq", getEnumCodeIdByCode(envEnumCat, envEnumCode));
            filters.add(rootCifilter);
        }
        Filter targetRifilter = new Filter("tail$r_guid", "in", guid);
        filters.add(targetRifilter);
        queryRequest.setFilters(filters);

        IntegrationQueryDto rootNode = new IntegrationQueryDto();
        rootNode.setName("root");
        rootNode.setCiTypeId(rootCiTypeId);

        List<Integer> attrs = new ArrayList<Integer>();
        List<String> attrKeyNames = new ArrayList<String>();

        attrs.add(getAttrIdByCiTypeId(rootCiTypeId, CmdbConstants.GUID));
        attrKeyNames.add(CONSTANT_GUID_PATH);

        if (envEnumCode != null && enumPorpertyNameOfEnv != null) {
            attrs.add(getAttrIdByCiTypeId(rootCiTypeId, enumPorpertyNameOfEnv));
            attrKeyNames.add("root$" + enumPorpertyNameOfEnv);
        }

        rootNode.setAttrs(attrs);
        rootNode.setAttrKeyNames(attrKeyNames);

        rootDto.setCriteria(rootNode);
        rootDto.setQueryRequest(queryRequest);

        IntegrationQueryDto childQueryDto = travelRoutine(routineItems, filterCiTypeId, rootDto, 1, "", envEnumCat, envEnumCode);
        if (childQueryDto != null) {
            rootDto.getCriteria().setChildren(Arrays.asList(childQueryDto));
        }
        if (showHistory) {
            rootDto.getQueryRequest().getDialect().setShowCiHistory(true);
        }
        return ciService.adhocIntegrateQuery(rootDto).getContents();
    }

    private String getEnumPropertyNameByCiTypeId(int ciTypeId, Integer enumCat) {
        List<CiTypeAttrDto> ciTypeAttributes = getCiTypeAttributesByCiTypeId(ciTypeId);
        for (int j = 0; j < ciTypeAttributes.size(); j++) {
            if (ciTypeAttributes.get(j).getInputType().equals(CONSTANT_SELECT) && ciTypeAttributes.get(j).getReferenceId() == enumCat) {
                return ciTypeAttributes.get(j).getPropertyName();
            }
        }

        return null;
    }

    private int getEnumCodeIdByCode(Integer enumCat, String enumCode) {
        List<CatCodeDto> catCodeList = getEnumCodesByCategoryId(enumCat);
        for (CatCodeDto catCodeDto : catCodeList) {
            if (enumCode.equalsIgnoreCase(catCodeDto.getCode())) {
                return catCodeDto.getCodeId();
            }
        }
        return -1;
    }

    private Integer getAttrIdByCiTypeId(int ciTypeId, String PropertyName) {
        List<CiTypeAttrDto> ciTypeAttributes = getCiTypeAttributesByCiTypeId(ciTypeId);
        for (int j = 0; j < ciTypeAttributes.size(); j++) {
            if (PropertyName.equalsIgnoreCase(ciTypeAttributes.get(j).getPropertyName())) {
                return ciTypeAttributes.get(j).getCiTypeAttrId();
            }
        }

        return null;
    }

    private IntegrationQueryDto travelRoutine(List<CiRoutineItem> routines, int filterCiTypeId, AdhocIntegrationQueryDto rootDto, int position, String key, Integer envEnumCat, String envEnumCode) {
        if (position >= routines.size()) {
            return null;
        }
        CiRoutineItem item = routines.get(position);

        IntegrationQueryDto dto = new IntegrationQueryDto();
        dto.setName("index-" + position);
        dto.setCiTypeId(item.getCiTypeId());

        Relationship parentRs = new Relationship();
        parentRs.setAttrId(item.getParentRs().getAttrId());
        parentRs.setIsReferedFromParent(item.getParentRs().getIsReferedFromParent() == 1);
        dto.setParentRs(parentRs);

        AdmCiType ciType = staticEntityRepository.findEntityById(AdmCiType.class, item.getCiTypeId());
        String tableName = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, ciType.getTableName());
        key = key + "-" + tableName;
        String enumPorpertyNameOfEnv = getEnumPropertyNameByCiTypeId(item.getCiTypeId(), envEnumCat);
        if (envEnumCode != null && enumPorpertyNameOfEnv != null) {
            List<Integer> attrs = new ArrayList<Integer>();
            List<String> attrKeyNames = new ArrayList<String>();
            if (key.startsWith("-"))
                key = key.substring(1);
            Filter cifilter = new Filter(key + "." + enumPorpertyNameOfEnv, "eq",
                    getEnumCodeIdByCode(envEnumCat, envEnumCode));

            rootDto.getQueryRequest().getFilters().add(cifilter);
            attrs.add(getAttrIdByCiTypeId(item.getCiTypeId(), enumPorpertyNameOfEnv));
            attrKeyNames.add(key + "." + enumPorpertyNameOfEnv);
            dto.setAttrs(attrs);
            dto.setAttrKeyNames(attrKeyNames);
        }
        IntegrationQueryDto childDto = travelRoutine(routines, filterCiTypeId, rootDto, ++position, "", envEnumCat, envEnumCode);
        if (childDto == null) {
            if (filterCiTypeId != item.getCiTypeId()) {
                log.error("routine tail ciType not right!!!");
                return null;
            }

            dto.setAttrs(Arrays.asList(getAttrIdByCiTypeId(item.getCiTypeId(), CmdbConstants.GUID), getAttrIdByCiTypeId(item.getCiTypeId(), CONSTANT_R_GUID_PATH)));
            dto.setAttrKeyNames(Arrays.asList("tail$guid", "tail$r_guid"));
        } else {
            dto.setChildren(Arrays.asList(childDto));
        }

        return dto;
    }

    public Object getDeployCiData(Integer codeId, String envCode, String systemGuid, QueryRequest queryObject) {
        int systemDesignCiTypeId = uiProperties.getCiTypeIdOfSystem();
        return getCiData(codeId, envCode, systemGuid, queryObject, systemDesignCiTypeId);
    }

    public Object getDeployDesignTabs() {
        return getEnumCodesByCategoryName(uiProperties.getCatNameOfDeployDesign());
    }

    public List<ResourceTreeDto> getAllDeployTreesFromSystem(String systemGuid) {
        List<ResourceTreeDto> deployTrees = new ArrayList<>();
        int subsysCiTypeId = uiProperties.getCiTypeIdOfSubsys();

        String stateEnumCode = uiProperties.getEnumCodeOfStateDelete();

        String routine = null;
        List<CatCodeDto> codeOfRoutines = getEnumCodeByCodeAndCategoryName(
                uiProperties.getCodeOfDeployDetail(), uiProperties.getCatNameOfQueryDeployDesign());
        if (codeOfRoutines.size() > 0) {
            routine = codeOfRoutines.get(0).getValue();
        }

        if (routine == null) {
            return null;
        }

        Map<String, Object> ciData = ciService.getCi(uiProperties.getCiTypeIdOfSystem(), systemGuid);
        List<CiTypeAttrDto> attrOfSubsys = getCiTypeAttributesByCiTypeIdAndPropertyName(subsysCiTypeId, uiProperties.getPropertyNameOfState());
        if (attrOfSubsys.size() == 0) {
            return null;
        }

        int stateEnumCatOfSubsys = attrOfSubsys.get(0).getReferenceId();

        Map ciDataMap = (Map) ciData;

        QueryRequest defaultQueryRequest = QueryRequest.defaultQueryObject();
        defaultQueryRequest.addEqualsFilter(CmdbConstants.GUID, ciDataMap.get(CmdbConstants.DEFAULT_FIELD_GUID).toString());

        List<ResourceTreeDto> resourceTrees = new ArrayList<>();
        recursiveGetChildrenDataFilterState(uiProperties.getCiTypeIdOfSystem(), stateEnumCatOfSubsys, stateEnumCode, resourceTrees, defaultQueryRequest, null);
        deployTrees.addAll(resourceTrees);

        enrichResourceTree(deployTrees);
        return deployTrees;
    }

    private void enrichResourceTree(List<ResourceTreeDto> resourceTrees){
        if(resourceTrees == null || resourceTrees.size()==0){
            return;
        }

        resourceTrees.forEach(tree -> {
            CiTypeDto ciTypeDto =  ciTypeService.getCiType(tree.getCiTypeId());
            Integer imageFieldId = ciTypeDto.getImageFileId();
            tree.setImageFileId(imageFieldId);
            enrichResourceTree(tree.getChildren());
        });
    }

    private List<CatCodeDto> getEnumCodeByCodeAndCategoryName(String code, String categoryName) {
        CategoryDto categoryDto = getEnumCategoryByName(categoryName);
        if (categoryDto == null) {
            throw new CmdbException(String.format("The enum category name [%s] not found.", categoryName));
        }

        QueryRequest queryObject = defaultQueryObject().addEqualsFilter(CONSTANT_CAT_ID, categoryDto.getCatId())
                .addEqualsFilter("code", code);

        QueryResponse<CatCodeDto> response = staticDtoService.query(CatCodeDto.class, queryObject);
        return response != null ? response.getContents() : null;
    }

    public List<ResourceTreeDto> getApplicationDeploymentDesignDataTreeBySystemDesignGuidAndEnvCode(String systemGuid) {
        List<ResourceTreeDto> instanceData = new ArrayList<>();

        QueryRequest systemDesignfilter = QueryRequest.defaultQueryObject();

        List<Integer> limitedCiTypeIdsOfGetInstanceData = Lists.newArrayList(uiProperties.getCiTypeIdOfSystem(),
                uiProperties.getCiTypeIdOfSubsystemDesign(),
                uiProperties.getCiTypeIdOfSubsys(),
                uiProperties.getCiTypeIdOfUnit(),
                uiProperties.getCiTypeIdOfInstance());

        systemDesignfilter.addEqualsFilter(CmdbConstants.GUID, systemGuid);
        getBottomChildrenDataByBottomCiTypeId(uiProperties.getCiTypeIdOfSystem(),
                uiProperties.getCiTypeIdOfInstance(),
                instanceData,
                limitedCiTypeIdsOfGetInstanceData,
                systemDesignfilter,
                null);

        List<CiTypeAttrDto> relateCiAttrDtoList = getRefToAttrByCiTypeIdAndRefName(uiProperties.getCiTypeIdOfInstance(), uiProperties.getReferenceCodeOfUse());
        if (relateCiAttrDtoList.size() == 0 || relateCiAttrDtoList.get(0) == null) {
            return new ArrayList<>();
        }

        List<ResourceTreeDto> instanceDataAfterGroup = groupByAttr(instanceData, relateCiAttrDtoList.get(0));
        if (instanceDataAfterGroup.size() == 0) {
            return new ArrayList<>();
        }

        Integer rootCiTypeId = uiProperties.getCiTypeIdOfIdc();
        List<ResourceTreeDto> idcDataTree = new ArrayList<>();
        List<Integer> limitedCiTypeIdsOfGetIdcData = getSameCiTypesByCiTypeId(rootCiTypeId);
        limitedCiTypeIdsOfGetIdcData.add(uiProperties.getCiTypeIdOfHost());

        recursiveGetChildrenData(rootCiTypeId, limitedCiTypeIdsOfGetIdcData, idcDataTree, null);
        if (idcDataTree.size() == 0) {
            return new ArrayList<>();
        }

        mergeDataToDataTree(idcDataTree, instanceDataAfterGroup);
        return idcDataTree;
    }

    private void getBottomChildrenDataByBottomCiTypeId(Integer ciTypeId, Integer bottomCiTypeId, List<ResourceTreeDto> bottomChildrenData, List<Integer> limitedCiTypeIds, QueryRequest queryRequest,
            Filter fixDateFilter) {
        queryRequest = setQueryRequest(queryRequest, fixDateFilter, ciTypeId);
        List<CiData> ciDatas = queryCiData(ciTypeId, queryRequest).getContents();

        if (ciTypeId.equals(bottomCiTypeId)) {
            for (CiData ciData : ciDatas) {
                ResourceTreeDto ci = buildNewResourceTreeDto(ciData, ciTypeId);
                bottomChildrenData.add(ci);
            }
            return;
        }

        boolean findBelongCi = false;
        for (CiData ciData : ciDatas) {
            Map<String, Object> ciDataMap = ciData.getData();
            List<CiTypeAttrDto> childrenCiTypeRelativeAttributes = findChildrenCiTypeRelativeAttributes(ciTypeId, uiProperties.getReferenceCodeOfBelong());
            if (childrenCiTypeRelativeAttributes.size() != 0 && ciDataMap.get(CmdbConstants.GUID) != null) {
                findBelongCi = getBottomChildrenDataByRelativeAttributes(childrenCiTypeRelativeAttributes, limitedCiTypeIds, ciDataMap.get(CmdbConstants.GUID).toString(), bottomChildrenData, bottomCiTypeId, fixDateFilter);
            }

            if (!findBelongCi) {
                List<CiTypeAttrDto> realizeCiTypeRelativeAttributes = findRealizeCiAttributesByCiTypeId(ciTypeId);
                if (realizeCiTypeRelativeAttributes.size() != 0 && ciDataMap.get(CmdbConstants.GUID) != null) {
                    getBottomChildrenDataByRealizeAttributes(realizeCiTypeRelativeAttributes, limitedCiTypeIds, ciDataMap.get(CmdbConstants.GUID).toString(), bottomChildrenData, bottomCiTypeId, fixDateFilter);
                }
            }
        }
    }

    private void getBottomChildrenDataByRealizeAttributes(List<CiTypeAttrDto> realizeCiTypeRelativeAttributes, List<Integer> limitedCiTypeIds, String guid, List<ResourceTreeDto> bottomChildrenData, Integer bottomCiTypeId,
            Filter fixDateFilter) {
        for (CiTypeAttrDto realizeCiTypeRelativeAttribute : realizeCiTypeRelativeAttributes) {
            if (!limitedCiTypeIds.contains(realizeCiTypeRelativeAttribute.getCiTypeId())) {
                continue;
            }

            QueryRequest filter = QueryRequest.defaultQueryObject();
            filter.addEqualsFilter(realizeCiTypeRelativeAttribute.getPropertyName(), guid);
            getBottomChildrenDataByBottomCiTypeId(realizeCiTypeRelativeAttribute.getCiTypeId(), bottomCiTypeId, bottomChildrenData, limitedCiTypeIds, filter, fixDateFilter);
        }
    }

    private List<CiTypeAttrDto> findRealizeCiAttributesByCiTypeId(Integer ciTypeId) {
        List<CiTypeAttrDto> ChildrenCiTypeRelativeAttributes = new ArrayList<>();
        List<CiTypeAttrDto> referenceByList = getCiTypeReferenceBy(ciTypeId);
        for (CiTypeAttrDto attrDto : referenceByList) {
            if (attrDto.getReferenceType() != null && baseKeyInfoService.getCode(attrDto.getReferenceType()).getCode() != null
                    && baseKeyInfoService.getCode(attrDto.getReferenceType()).getCode().equals(uiProperties.getReferenceCodeOfRealize())) {
                ChildrenCiTypeRelativeAttributes.add(attrDto);
            }
        }
        return ChildrenCiTypeRelativeAttributes;
    }

    private boolean getBottomChildrenDataByRelativeAttributes(List<CiTypeAttrDto> childrenCiTypeRelativeAttributes, List<Integer> limitedCiTypeIds, String guid, List<ResourceTreeDto> bottomChildrenData, Integer bottomCiTypeId,
            Filter fixDateFilter) {
        for (CiTypeAttrDto childrenCiTypeRelativeAttribute : childrenCiTypeRelativeAttributes) {
            QueryRequest filter = QueryRequest.defaultQueryObject();
            if (!limitedCiTypeIds.contains(childrenCiTypeRelativeAttribute.getCiTypeId())) {
                continue;
            }
            filter.addEqualsFilter(childrenCiTypeRelativeAttribute.getPropertyName(), guid);
            getBottomChildrenDataByBottomCiTypeId(childrenCiTypeRelativeAttribute.getCiTypeId(), bottomCiTypeId, bottomChildrenData, limitedCiTypeIds, filter, fixDateFilter);
            return true;
        }
        return false;
    }

    private List<CiTypeAttrDto> getRefToAttrByCiTypeIdAndRefName(Integer ciTypeId, String refCode) {
        List<CiTypeAttrDto> relateCiAttrs = new ArrayList<>();
        List<CiTypeAttrDto> referenceByList = getCiTypeReferenceTo(ciTypeId);
        for (CiTypeAttrDto attrDto : referenceByList) {
            if (attrDto.getReferenceType() != null && baseKeyInfoService.getCode(attrDto.getReferenceType()).getCode() != null
                    && baseKeyInfoService.getCode(attrDto.getReferenceType()).getCode().equals(refCode)) {
                relateCiAttrs.add(attrDto);
            }
        }
        return relateCiAttrs;
    }

    private List<ResourceTreeDto> groupByAttr(List<ResourceTreeDto> toBeGroupData, CiTypeAttrDto relateCiAttrDto) {
        List<ResourceTreeDto> returnData = new ArrayList<>();
        for (ResourceTreeDto singleData : toBeGroupData) {
            boolean continueFlag = false;
            Map ciMap = (Map) singleData.getData();
            Object relateCiTypeDto = ciMap.get(relateCiAttrDto.getPropertyName());
            if (relateCiTypeDto == null || "".equals(relateCiTypeDto)) {
                continue;
            }

            String relateCiAttrValue = ((Map) relateCiTypeDto).get(CmdbConstants.GUID).toString();

            if (returnData.size() != 0) {
                for (ResourceTreeDto returnDatum : returnData) {
                    if (returnDatum.getGuid().equals(relateCiAttrValue)) {
                        returnDatum.getChildren().add(singleData);
                        continueFlag = true;
                    }
                }
            }
            if (continueFlag) {
                continue;
            }
            ResourceTreeDto data = new ResourceTreeDto();
            List<ResourceTreeDto> newChildrenData = Lists.newArrayList(singleData);
            data.setCiTypeId(relateCiAttrDto.getReferenceId());
            data.setGuid(relateCiAttrValue);
            data.setChildren(newChildrenData);
            returnData.add(data);
        }
        return returnData;
    }

    private void mergeDataToDataTree(List<ResourceTreeDto> dataTree, List<ResourceTreeDto> toBeMergeDatas) {
        for (int i = 0; i < dataTree.size(); i++) {
            MergeDataResult mergeDataResult = mergeData(dataTree, i, toBeMergeDatas);
            if (mergeDataResult.isEndOfData()) {
                break;
            }
            if (mergeDataResult.isContinueFlag()) {
                continue;
            }

            if (dataTree.get(i).getChildren().size() != 0) {
                mergeDataToDataTree(dataTree.get(i).getChildren(), toBeMergeDatas);
                if (dataTree.get(i).getChildren().size() != 0) {
                    continue;
                }
            }

            dataTree.remove(i);
            if (dataTree.size() == 0) {
                break;
            }
            i--;
        }
    }

    private MergeDataResult mergeData(List<ResourceTreeDto> dataTree, int index, List<ResourceTreeDto> toBeMergeDatas) {
        MergeDataResult returnFlags = new MergeDataResult();
        ResourceTreeDto childData = dataTree.get(index);
        if (childData.getCiTypeId().equals(toBeMergeDatas.get(0).getCiTypeId())) {
            boolean mergedFlag = false;
            for (ResourceTreeDto toBeMergeData : toBeMergeDatas) {
                if (childData.getGuid().equals(toBeMergeData.getGuid())) {
                    dataTree.get(index).setChildren(toBeMergeData.getChildren());
                    mergedFlag = true;
                }
            }
            if (!mergedFlag) {
                dataTree.remove(index);
                if (dataTree.size() == 0) {
                    returnFlags.setEndOfData(true);
                }
                index--;
            }
            returnFlags.setContinueFlag(true);
        }

        return returnFlags;
    }

    public List<ResourceTreeDto> getTreeData(Integer ciTypeId, java.util.List<String> guids) {
        return getDataTreesByCiTypeIdAndGuid(ciTypeId, guids);
    }

    @Data
    private static class MergeDataResult {
        private boolean isEndOfData;
        private boolean continueFlag;
    }

    public List<ResourceTreeDto> getApplicationFrameworkDesignDataTreeBySystemDesignGuid(String systemDesignGuid) {
        List<ResourceTreeDto> unitDesignDatas = new ArrayList<>();
        QueryRequest defaultQueryObject = QueryRequest.defaultQueryObject();
        defaultQueryObject.addEqualsFilter(CmdbConstants.GUID, systemDesignGuid);
        Filter fixDateFilter = getFixDateFilter(uiProperties.getCiTypeIdOfSystemDesign(), systemDesignGuid);
        getBottomChildrenDataByBottomCiTypeId(uiProperties.getCiTypeIdOfSystemDesign(),
                uiProperties.getCiTypeIdOfUnitDesign(),
                unitDesignDatas,
                getSameCiTypesByCiTypeId(uiProperties.getCiTypeIdOfSystemDesign()),
                defaultQueryObject,
                fixDateFilter);

        List<ResourceTreeDto> allIdcDesignDatas = getAllIdcDesignTrees();

        List<CiTypeAttrDto> relateCiAttrDtoList = getRelateCiTypeAttrByCiTypeId(uiProperties.getCiTypeIdOfUnitDesign());
        if (relateCiAttrDtoList.size() == 0) {
            return unitDesignDatas;
        }

        List<ResourceTreeDto> unitDesignDatasAfterGroup = groupByAttr(unitDesignDatas, relateCiAttrDtoList.get(0));
        if (unitDesignDatasAfterGroup.size() == 0) {
            return unitDesignDatas;
        }

        mergeDataToDataTree(allIdcDesignDatas, unitDesignDatasAfterGroup);
        return allIdcDesignDatas;
    }

    private List<ResourceTreeDto> getAllIdcDesignTrees() {
        Integer rootCiTypeId = uiProperties.getCiTypeIdOfIdcDesign();
        List<ResourceTreeDto> resourceTrees = new ArrayList<>();

        recursiveGetChildrenData(rootCiTypeId, getSameCiTypesByCiTypeId(rootCiTypeId), resourceTrees, null);

        return resourceTrees;
    }

    private List<CiTypeAttrDto> getRelateCiTypeAttrByCiTypeId(Integer ciTypeId) {
        List<CiTypeAttrDto> relateCiAttrs = new ArrayList<>();
        List<CiTypeAttrDto> referenceByList = getCiTypeReferenceTo(ciTypeId);
        for (CiTypeAttrDto attrDto : referenceByList) {
            if (attrDto.getReferenceType().equals(uiProperties.getReferenceCodeOfRelate())) {
                relateCiAttrs.add(attrDto);
            }
        }
        return relateCiAttrs;
    }

    public <T extends ResourceDto<T, D>, D> QueryResponse<T> query(Class<T> dtoClzz, QueryRequest request) {
        return staticDtoService.query(dtoClzz, request);
    }

    public Object getPlanningDesignsCiData(int codeId, String systemDesignGuid, QueryRequest queryObject) {
        Integer systemDesignCiTypeId = uiProperties.getCiTypeIdOfIdcDesign();
        return getCiData(codeId, null, systemDesignGuid, queryObject, systemDesignCiTypeId);
    }

    public List<CiData> getIdcDataByGuid(List<String> idcGuids) {
        QueryRequest defaultQueryObject = defaultQueryObject();
        defaultQueryObject.addInFilter(CmdbConstants.GUID, idcGuids);
        QueryResponse<CiData> queryCiData = queryCiData(uiProperties.getCiTypeIdOfIdc(), defaultQueryObject);
        return queryCiData.getContents();

    }

    public Object getResourcePlanningCiData(int codeId, String systemDesignGuid, QueryRequest queryObject) {
        Integer systemDesignCiTypeId = uiProperties.getCiTypeIdOfIdc();
        return getCiData(codeId, null, systemDesignGuid, queryObject, systemDesignCiTypeId);
    }

    public int getRoleIdByRoleName(String roleName) {
        return getRoleIdByRoleName(roleName, false);
    }

    public int getRoleIdByRoleName(String roleName, boolean createIfNotExist) {
        AdmRole role = admRoleRepository.findByRoleName(roleName);
        if (role == null) {
            if (createIfNotExist) {
                RoleDto roleDto = new RoleDto();
                roleDto.setRoleName(roleName);
                List<RoleDto> roles = createRoles(roleDto);
                role = roles.get(0).toDomain();
            } else {
                throw new CmdbException(String.format("Can not found Role by name (%s)", roleName));
            }
        }
        return role.getIdAdmRole();
    }

    public List<Map<String, Object>> updateSystemDesign(String systemGuid) {
        Map<String, Object> ciDataMap = ciService.getCi(uiProperties.getCiTypeIdOfSystemDesign(), systemGuid);
        List<Map<String,Object>> ystemDesignData = new ArrayList<Map<String,Object>>();
        if(StringUtils.isNotBlank((String)ciDataMap.get(CONSTANT_FIXED_DATE)) &&((String)ciDataMap.get(CmdbConstants.GUID)).equals((String)ciDataMap.get(CmdbConstants.DEFAULT_FIELD_ROOT_GUID))) {
            ystemDesignData = ciService.update(uiProperties.getCiTypeIdOfSystemDesign(), Arrays.asList(ciDataMap));
        }
        return ystemDesignData;
    }

    private void propertiesAssignment(QueryResponse<CatCodeDto> response) throws IOException {
        if(response != null) {
            StringBuilder sb = new StringBuilder("{");
            response.getContents().stream().forEach(catCodeDto -> sb.append("\""+catCodeDto.getCode()).append("\":\"").append(catCodeDto.getValue()+"\"").append(","));
            sb.deleteCharAt(sb.lastIndexOf(","));
            sb.append("}");
            UIProperties uiPropertiesFromDB = JsonUtil.toObject(sb.toString(), UIProperties.class);
            this.uiProperties.setCiTypeIdOfSystemDesign(uiPropertiesFromDB.getCiTypeIdOfSystemDesign());
            this.uiProperties.setCiTypeIdOfSubsystemDesign(uiPropertiesFromDB.getCiTypeIdOfSubsystemDesign());
            this.uiProperties.setCiTypeIdOfUnitDesign(uiPropertiesFromDB.getCiTypeIdOfUnitDesign());
            this.uiProperties.setCiTypeIdOfUnit(uiPropertiesFromDB.getCiTypeIdOfUnit());
            this.uiProperties.setCiTypeIdOfSubsys(uiPropertiesFromDB.getCiTypeIdOfSubsys());
            this.uiProperties.setCiTypeIdOfSystem(uiPropertiesFromDB.getCiTypeIdOfSystem());
            this.uiProperties.setCiTypeIdOfHost(uiPropertiesFromDB.getCiTypeIdOfHost());
            this.uiProperties.setCiTypeIdOfInstance(uiPropertiesFromDB.getCiTypeIdOfInstance());
            this.uiProperties.setCiTypeIdOfIdc(uiPropertiesFromDB.getCiTypeIdOfIdc());
            this.uiProperties.setCiTypeIdOfZone(uiPropertiesFromDB.getCiTypeIdOfZone());
            this.uiProperties.setCiTypeIdOfZoneLink(uiPropertiesFromDB.getCiTypeIdOfZoneLink());
            this.uiProperties.setCiTypeIdOfIdcDesign(uiPropertiesFromDB.getCiTypeIdOfIdcDesign());
            this.uiProperties.setCiTypeIdOfZoneDesign(uiPropertiesFromDB.getCiTypeIdOfZoneDesign());
            this.uiProperties.setCiTypeIdOfZoneLinkDesign(uiPropertiesFromDB.getCiTypeIdOfZoneLinkDesign());
        }
    }


    public List<Map<String, Object>> updateCiDataForPassword(int ciTypeId, Map<String, Object> param) {
        Map<String, Object> data = new HashMap<String, Object>();
        data.put(param.get("field").toString(), param.get("value"));
        data.put(CmdbConstants.GUID, param.get(CmdbConstants.GUID));

        Map<String, Object> ciDataMap = ciService.getCi(ciTypeId, param.get(CmdbConstants.GUID).toString());
        if(param.get("originalValue")==null||ciDataMap.get(param.get("field"))==null) {
            throw new CmdbException(String.format("Password is null"));
        }
        if(!param.get("originalValue").toString().equals(ciDataMap.get(param.get("field")).toString())) {
            throw new CmdbException(String.format("Password mistake"));
        }
        return ciService.update(ciTypeId, Arrays.asList(data));        
    }
}
