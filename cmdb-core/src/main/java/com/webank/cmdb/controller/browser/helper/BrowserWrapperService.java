package com.webank.cmdb.controller.browser.helper;

import static com.webank.cmdb.controller.browser.helper.CollectionUtils.groupUp;
import static com.webank.cmdb.dto.QueryRequest.defaultQueryObject;
import static org.apache.commons.collections4.CollectionUtils.isEmpty;
import static org.apache.commons.collections4.CollectionUtils.isNotEmpty;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.webank.cmdb.config.ApplicationProperties.BrowserAccessProperties;
import com.webank.cmdb.constant.FilterOperator;
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
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.RoleUserDto;
import com.webank.cmdb.dto.UserDto;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.service.IntegrationQueryService;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.service.impl.FilterRuleService;
import com.webank.cmdb.util.BeanMapUtils;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional
public class BrowserWrapperService {

    private static final String CONSTANT_CAT_TYPE_ID = "catTypeId";
    private static final String CONSTANT_CI_TYPE = "ciType";
    private static final String CONSTANT_CAT_CAT_TYPE = "cat.catType";
    private static final String CONSTANT_INPUT_TYPE = "inputType";
    private static final String CONSTANT_CI_TYPE_ID = "ciTypeId";
    private static final String CONSTANT_ATTRIBUTES = "attributes";
    private static final String CONSTANT_CAT_ID = "catId";
    private static final String CONSTANT_SEQ_NO = "seqNo";

    @Autowired
    BrowserAccessProperties cmdbDataProperties;
    @Autowired
    private CiService ciService;
    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private CiTypeService ciTypeService;
    @Autowired
    private IntegrationQueryService intQueryService;
    @Autowired
    private FilterRuleService filterRuleService;

    public void swapCiTypeLayerPosition(int layerId, int targetLayerId) {
        CatCodeDto enumCode = getEnumCodeById(layerId);
        CatCodeDto targetEnumCode = getEnumCodeById(targetLayerId);

        Integer seqNo = enumCode.getSeqNo();
        enumCode.setSeqNo(targetEnumCode.getSeqNo());
        targetEnumCode.setSeqNo(seqNo);

        updateEnumCodes(Lists.newArrayList(BeanMapUtils.convertBeanToMap(enumCode), BeanMapUtils.convertBeanToMap(targetEnumCode)));
    }

    public void swapCiTypeAttributePosition(int attributeId, int targetAttributeId) {
        CiTypeAttrDto attribute = getCiTypeAttribute(attributeId);
        CiTypeAttrDto targetAttribute = getCiTypeAttribute(targetAttributeId);

        CiTypeAttrDto updateSourceAttribute = new CiTypeAttrDto();
        updateSourceAttribute.setCiTypeAttrId(attribute.getCiTypeAttrId());
        updateSourceAttribute.setDisplaySeqNo(targetAttribute.getDisplaySeqNo());

        CiTypeAttrDto updateTargetAttribute = new CiTypeAttrDto();
        updateTargetAttribute.setCiTypeAttrId(targetAttribute.getCiTypeAttrId());
        updateTargetAttribute.setDisplaySeqNo(attribute.getDisplaySeqNo());

        updateCiTypeAttributes(BeanMapUtils.convertBeanToMap(Lists.newArrayList(updateSourceAttribute, updateTargetAttribute)));
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
        queryObject.addEqualsFilter(CONSTANT_CAT_TYPE_ID, cmdbDataProperties.getEnumCategoryTypeSystem());
        return queryEnumCategories(queryObject);
    }

    public QueryResponse<CategoryDto> getAllCommonEnumCategories() {
        QueryRequest queryObject = new QueryRequest();
        queryObject.addEqualsFilter(CONSTANT_CAT_TYPE_ID, cmdbDataProperties.getEnumCategoryTypeCommon());
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
        return getCiTypesInGroups(cmdbDataProperties.getEnumCategoryCiTypeLayer(), withAttributes, status, CiTypeDto::getLayerId);
    }

    public List<CatCodeDto> getCiTypesGroupByCatalogs(boolean withAttributes, String status) {
        return getCiTypesInGroups(cmdbDataProperties.getEnumCategoryCiTypeCatalog(), withAttributes, status, CiTypeDto::getCatalogId);
    }

    public List<CatCodeDto> getAllLayers() {
        return getEnumCodesByCategoryName(cmdbDataProperties.getEnumCategoryCiTypeLayer());
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
        CategoryDto cat = getEnumCategoryByName(cmdbDataProperties.getEnumCategoryCiTypeZoomLevels());
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
        List<CatCodeDto> catCodesResult = getEnumCodesByCategoryName(cmdbDataProperties.getEnumCategoryCiTypeLayer());
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
        return createEnumCodes(catCode);
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
        return getEnumCategoryByName(cmdbDataProperties.getEnumCategoryCiTypeLayer()).getCatId();
    }

    public QueryResponse<CatCodeDto> querySystemEnumCodesWithRefResources(QueryRequest queryObject) {
        queryObject.addEqualsFilter(CONSTANT_CAT_CAT_TYPE, cmdbDataProperties.getEnumCategoryTypeSystem());
        queryObject.addReferenceResource("cat");
        queryObject.addReferenceResource(CONSTANT_CAT_CAT_TYPE);
        return queryEnumCodes(queryObject);
    }

    public QueryResponse<CatCodeDto> queryNonSystemEnumCodesWithRefResources(QueryRequest queryObject) {
        queryObject.addNotEqualsFilter("cat.catTypeId", cmdbDataProperties.getEnumCategoryTypeSystem());
        queryObject.addReferenceResource("cat");
        queryObject.addReferenceResource(CONSTANT_CAT_CAT_TYPE);
        return queryEnumCodes(queryObject);
    }

    public QueryResponse<CategoryDto> getAllNonSystemEnumCategories() {
        QueryRequest queryObject = new QueryRequest();
        queryObject.addNotEqualsFilter(CONSTANT_CAT_TYPE_ID, cmdbDataProperties.getEnumCategoryTypeSystem());
        return queryEnumCategories(queryObject);
    }

    public List<CatCodeDto> getGroupListByCatId(int categoryId) {
        return getEnumCodesByCategoryId(getEnumCategoryByCatId(categoryId).getGroupTypeId());
    }

    public List<CatCodeDto> getCiTypeStatusOptions(int ciTypeId) {
        List<CiTypeAttrDto> statusCiTypeAttributes = queryCiTypeAttributes(
                defaultQueryObject(CONSTANT_CI_TYPE_ID, ciTypeId)
                        .addEqualsFilter("propertyName", cmdbDataProperties.getStatusAttributeName()));
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

    public List<CatCodeDto> createEnumCodes(CatCodeDto... catCodeDtos) {
        return staticDtoService.create(CatCodeDto.class, Arrays.asList(catCodeDtos));
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

    public CiTypeAttrDto getCiTypeAttribute(Integer ciTypeAttributeId) {
        QueryRequest queryObject = defaultQueryObject().addEqualsFilter("ciTypeAttrId", ciTypeAttributeId);
        QueryResponse<CiTypeAttrDto> response = staticDtoService.query(CiTypeAttrDto.class, queryObject);
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

    public QueryResponse<?> queryCiData(Integer ciTypeId, QueryRequest queryObject) {
        return ciService.query(ciTypeId, queryObject);
    }

    public List<Map<String, Object>> updateCiData(Integer ciTypeId, List<Map<String, Object>> ciData) {
        return ciService.update(ciTypeId, ciData);
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

    public QueryResponse<?> queryReferenceEnumCodes(int referenceAttrId, QueryRequest queryObject) {
        return filterRuleService.queryReferenceEnumCodes(referenceAttrId, queryObject);
    }

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
        if (isEmpty(roleCiTypeCtrlAttrs))
            throw new CmdbException("Create role CiType ctrl attr failure.");
        return roleCiTypeCtrlAttrs.get(0);
    }

    public List<RoleCiTypeCtrlAttrDto> updateRoleCiTypeCtrlAttributes(List<Map<String, Object>> roleCiTypeCtrlAttrs) {
        return staticDtoService.update(RoleCiTypeCtrlAttrDto.class, roleCiTypeCtrlAttrs);
    }

    public void deleteRoleCiTypeCtrlAttributes(Integer... ids) {
        staticDtoService.delete(RoleCiTypeCtrlAttrDto.class, Arrays.asList(ids));
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
        if (isEmpty(roleCiTypeCtrlAttrConditions))
            throw new CmdbException("Create role CiType ctrl attr condition failure.");
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
        QueryResponse<CiData> response = ciService.query(ciTypeId, defaultQueryObject().addInFilter("guid", guidList));
        return response != null ? response.getContents() : null;
    }

    public RoleCiTypeCtrlAttrDto updateRoleCiTypeCtrlAttribute(RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr) {
        List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs = updateRoleCiTypeCtrlAttributes(Lists.newArrayList(BeanMapUtils.convertBeanToMap(roleCiTypeCtrlAttr)));
        if (isEmpty(roleCiTypeCtrlAttrs))
            throw new CmdbException("Update role CiType ctrl attr failure.");
        return roleCiTypeCtrlAttrs.get(0);
    }

    public List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(RoleCiTypeCtrlAttrConditionDto... roleCiTypeCtrlAttrConditions) {
        return staticDtoService.update(RoleCiTypeCtrlAttrConditionDto.class, Lists.newArrayList(BeanMapUtils.convertBeanToMap(roleCiTypeCtrlAttrConditions)));
    }

    public List<RoleCiTypeDto> updateRoleCiTypes(RoleCiTypeDto... roleCiTypes) {
        return staticDtoService.update(RoleCiTypeDto.class, Lists.newArrayList(BeanMapUtils.convertBeanToMap(roleCiTypes)));
    }
}
