package com.webank.cmdb.controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.webank.cmdb.constant.ImplementOperation;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.dto.CiDataTreeDto;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.IdNamePairDto;
import com.webank.cmdb.dto.ImageInfoDto;
import com.webank.cmdb.dto.IntQueryOperateAggRequetDto;
import com.webank.cmdb.dto.IntQueryOperateAggResponseDto;
import com.webank.cmdb.dto.IntQueryResponseHeader;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.RoleUserDto;
import com.webank.cmdb.dto.UserDto;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.exception.ServiceException;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.service.ImageService;
import com.webank.cmdb.service.IntegrationQueryService;
import com.webank.cmdb.service.StateTransitionService;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.service.impl.ConstantService;
import com.webank.cmdb.service.impl.FilterRuleService;
import com.webank.cmdb.util.JsonUtil;

@RestController
@RequestMapping("/api/v2")
public class ApiV2Controller {
    private static final Logger logger = LoggerFactory.getLogger(ApiV2Controller.class);

    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private CiService ciService;
    @Autowired
    private ImageService imageService;
    @Autowired
    private IntegrationQueryService intQueryService;
    @Autowired
    private CiTypeService ciTypeService;
    @Autowired
    private FilterRuleService filterRuleService;
    @Autowired
    private StateTransitionService stateTransitionService;
    @Autowired
    private ConstantService constantService;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // Enum code
    @PostMapping("/enum/codes/retrieve")
    public QueryResponse<CatCodeDto> retrieveEnumCodes(@Valid @RequestBody QueryRequest request) {
        return staticDtoService.query(CatCodeDto.class, request);
    }

    @PostMapping("/enum/codes/referenceDatas/{reference-attr-id}/query")
    public QueryResponse<?> queryReferenceEnumCodes(@PathVariable("reference-attr-id") int referenceAttrId, @RequestBody QueryRequest request) {
        return filterRuleService.queryReferenceEnumCodes(referenceAttrId, request);
    }

    @PostMapping("/enum/codes/update")
    public List<CatCodeDto> updateEnumCodes(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(CatCodeDto.class, request);
    }

    @PostMapping("/enum/codes/delete")
    public void deleteEnumCodes(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(CatCodeDto.class, requestIds);
    }

    @PostMapping("/enum/codes/create")
    public List<CatCodeDto> createEnumCodes(@Valid @RequestBody List<CatCodeDto> catCodeDtos) {
        return staticDtoService.create(CatCodeDto.class, catCodeDtos);
    }

    // Cat type
    @PostMapping("/enum/catTypes/retrieve")
    public QueryResponse<CatTypeDto> retrieveEnumCatTypes(@RequestBody QueryRequest request) {
        return staticDtoService.query(CatTypeDto.class, request);
    }

    @PostMapping("/enum/catTypes/update")
    public List<CatTypeDto> updateEnumCatTypes(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(CatTypeDto.class, request);
    }

    @PostMapping("/enum/catTypes/delete")
    public void deleteEnumCatTypes(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(CatTypeDto.class, requestIds);
    }

    @PostMapping("/enum/catTypes/create")
    public List<CatTypeDto> createEnumCatTypes(@Valid @RequestBody List<CatTypeDto> catTypeDtos) {
        return staticDtoService.create(CatTypeDto.class, catTypeDtos);
    }

    // Cat
    @PostMapping("/enum/cats/retrieve")
    public QueryResponse<CategoryDto> retrieveEnumCats(@RequestBody QueryRequest request) {
        return staticDtoService.query(CategoryDto.class, request);
    }

    @PostMapping("/enum/cats/update")
    public List<CategoryDto> updateEnumCats(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(CategoryDto.class, request);
    }

    @PostMapping("/enum/cats/delete")
    public void deleteEnumCats(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(CategoryDto.class, requestIds);
    }

    @PostMapping("/enum/cats/create")
    public List<CategoryDto> createEnumCats(@Valid @RequestBody List<CategoryDto> categoryDtos) {
        return staticDtoService.create(CategoryDto.class, categoryDtos);
    }

    // Ci Type
    @PostMapping("/ciTypes/retrieve")
    public QueryResponse<CiTypeDto> retrieveCiTypes(@RequestBody QueryRequest request) {
        return staticDtoService.query(CiTypeDto.class, request);
    }

    @PostMapping("/ciTypes/update")
    public List<CiTypeDto> updateCiTypes(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(CiTypeDto.class, request);
    }

    @PostMapping("/ciTypes/delete")
    public void deleteCiTypes(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(CiTypeDto.class, requestIds);
    }

    @PostMapping("/ciTypes/create")
    public List<CiTypeDto> createCiTypes(@Valid @RequestBody List<CiTypeDto> ciTypeDtos) {
        return staticDtoService.create(CiTypeDto.class, ciTypeDtos);
    }

    @PostMapping("/ciTypes/apply")
    public void applyCiTypes(@Valid @RequestBody List<Integer> ciTypeIds) {
        ciTypeService.applyCiType(ciTypeIds);
    }

    @PostMapping("/ciTypes/applyAll")
    public void applyAllCiType() {
        ciTypeService.applyAllCiType();
    }

    @PostMapping("/ciTypes/{ciTypeId}/implement")
    public void implementCiType(@PathVariable("ciTypeId") int ciTypeId, @RequestParam("operation") String operaCode) {
        ImplementOperation operation = ImplementOperation.fromCode(operaCode);
        if (ImplementOperation.None.equals(operation)) {
            throw new InvalidArgumentException(String.format("Operation code [%s] is not supported", operaCode));
        }

        ciTypeService.implementCiType(ciTypeId, operation);
    }

    // Ci type attribute
    @PostMapping("/ciTypeAttrs/retrieve")
    public QueryResponse<CiTypeAttrDto> retrieveCiTypeAttrs(@RequestBody QueryRequest request) {
        return staticDtoService.query(CiTypeAttrDto.class, request);
    }

    @PostMapping("/ciTypeAttrs/update")
    public List<CiTypeAttrDto> updateCiTypeAttrs(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(CiTypeAttrDto.class, request);
    }

    @PostMapping("/ciTypeAttrs/delete")
    public void deleteCiTypeAttrs(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(CiTypeAttrDto.class, requestIds);
    }

    @PostMapping("/ciTypeAttrs/create")
    public List<CiTypeAttrDto> createCiTypesAttrs(@Valid @RequestBody List<CiTypeAttrDto> ciTypeAttrDtos) {
        return staticDtoService.create(CiTypeAttrDto.class, ciTypeAttrDtos);
    }

    @PostMapping("/ciTypeAttrs/apply")
    public void applyCiTypeAttrs(@Valid @RequestBody List<Integer> ciTypeAttrIds) {
        ciTypeService.applyCiTypeAttr(ciTypeAttrIds);
    }

    @PostMapping("/ciTypeAttrs/{ciTypeAttrId}/implement")
    public void implementCiTypeAttr(@PathVariable("ciTypeAttrId") int ciTypeAttrId, @RequestParam("operation") String operaCode) {
        ImplementOperation operation = ImplementOperation.fromCode(operaCode);
        if (ImplementOperation.None.equals(operation)) {
            throw new InvalidArgumentException(String.format("Operation code [%s] is not supported", operaCode));
        }

        ciTypeService.implementCiTypeAttr(ciTypeAttrId, operation);
    }

    // CI
    @PostMapping("/ci/{ciTypeId}/retrieve")
    public QueryResponse<?> retrieveCis(@PathVariable("ciTypeId") int ciTypeId, @RequestBody QueryRequest request) {
        return ciService.query(ciTypeId, request);
    }

    @PostMapping("/ci/{ciTypeId}/update")
    public List<Map<String, Object>> updateCis(@PathVariable("ciTypeId") int ciTypeId, @RequestBody List<Map<String, Object>> request) {
        return ciService.update(ciTypeId, request);
    }

    @PostMapping("/ci/{ciTypeId}/create")
    public List<Map<String, Object>> createCis(@PathVariable("ciTypeId") int ciTypeId, @RequestBody List<Map<String, Object>> request) {
        return ciService.create(ciTypeId, request);
    }

    @PostMapping("/ci/{ciTypeId}/delete")
    public void deleteCis(@PathVariable("ciTypeId") int ciTypeId, @RequestBody List<String> ids) {
        ciService.delete(ciTypeId, ids);
    }

    @PostMapping("/ci/referenceDatas/{reference-attr-id}/query")
    public QueryResponse<?> queryReferenceCiDatas(@PathVariable("reference-attr-id") int referenceAttrId, @RequestBody QueryRequest request) {
        return filterRuleService.queryReferenceCiData(referenceAttrId, request);
    }

    @PostMapping("/ci/{ciTypeId}/{guid}/tree")
    public Map<String, Object> retrieveCiDataTree(@PathVariable("ciTypeId") int ciTypeId, @PathVariable("guid") String guid) {
        return ciService.recursiveGetCisTree(ciTypeId, guid, new LinkedHashMap<String, Object>());
    }

    @PostMapping("/ci/{ciTypeId}/versions/retrieve")
    public HashSet<String> retrieveVersions(@PathVariable("ciTypeId") int ciTypeId) {
        return ciService.retrieveVersions(ciTypeId);
    }

    @PostMapping("/ci/state/operate")
    public List<Map<String, Object>> operateCiForState(@RequestBody List<CiIndentity> ciIds, @RequestParam("operation") String operation) {
        return ciService.operateState(ciIds, operation);
    }

    @GetMapping("/ci/state/operation")
    public List<String> queryOperation(@RequestParam("curState") Integer curState, @RequestParam("targetState") Integer targetState, @RequestParam("isConfirmed") Boolean isConfirmed) {
        return stateTransitionService.queryOperation(curState, targetState, isConfirmed);
    }

    @PostMapping("/ci/from/{from_ciTypeId}/to/{to_ciTypeId}/versions/{version}/retrieve")
    public List<CiDataTreeDto> retrieveVersionDetail(@PathVariable("from_ciTypeId") int fromCiTypeId, @PathVariable("to_ciTypeId") int toCiTypeId, @PathVariable("version") String version) {
        return ciService.retrieveVersionDetail(fromCiTypeId, toCiTypeId, version);
    }

    // Constants
    @PostMapping("/constants/ciStatus/retrieve")
    public List<String> retrieveConstantsOfCiStatus() {
        return constantService.getCiStatus();
    }

    @PostMapping("/constants/referenceTypes/retrieve")
    public List<String> retrieveConstantsOfReferenceTypes() {
        return constantService.getReferenceTypes();
    }

    @PostMapping("/constants/inputTypes/retrieve")
    public List<String> retrieveConstantsOfInputTypes() {
        return constantService.getInputTypes();
    }

    @PostMapping("/constants/effectiveStatus/retrieve")
    public List<String> retrieveConstantsOfEffectiveStatus() {
        return constantService.getEffectiveStatus();
    }

    // Images
    @PostMapping("/image/upload")
    public ImageInfoDto upload(@RequestParam(value = "img", required = false) MultipartFile file, HttpServletRequest request) {
        try {
            String contentType = file.getContentType();
            return imageService.upload(file.getName(), contentType, file.getBytes());
        } catch (IOException e) {
            String msg = String.format("Failed to upload image file. (fileName:%s)", file.getName());
            logger.warn(msg, e);
            throw new ServiceException(msg);
        }
    }

    @GetMapping("/image/{imageId}")
    public void getImage(@PathVariable("imageId") int imageId, HttpServletResponse response) {
        ServletOutputStream out;
        try {
            out = response.getOutputStream();
            response.setCharacterEncoding("utf-8");
            ImageInfoDto imageInfo = imageService.getImage(imageId);
            response.setContentType(imageInfo.getContentType());
            out.write(imageInfo.getContent());
            out.flush();
            out.close();
        } catch (IOException e) {
            String msg = String.format("Failed to get image file. (imageId:%s)", imageId);
            logger.warn(msg, e);
            throw new ServiceException(msg);
        }
    }

    @GetMapping("/intQuery/{queryId}")
    public IntegrationQueryDto getIntegrationQuery(@PathVariable("queryId") int queryId) {
        return intQueryService.getIntegrationQuery(queryId);
    }

    @PostMapping("/intQuery/{queryId}/duplicate")
    public int duplicateIntegrationQuery(@PathVariable("queryId") int queryId) {
        return intQueryService.duplicateIntegrationQuery(queryId);
    }

    @PostMapping("/intQuery/ciType/{ciTypeId}/aggQueries/operate")
    public List<IntQueryOperateAggResponseDto> operateIntegrationOperateAggregation(@PathVariable("ciTypeId") int ciTypeId, @RequestBody List<IntQueryOperateAggRequetDto> aggRequest) {
        System.out.println(JsonUtil.toJson(aggRequest));
        return intQueryService.operateAggregationQuery(ciTypeId, aggRequest);
    }

    @PostMapping("/intQuery/ciType/{ciTypeId}/aggQueries/delete")
    public List<IntQueryOperateAggResponseDto> deleteIntegrationOperateAggregation(@PathVariable("ciTypeId") int ciTypeId, @RequestBody List<IntQueryOperateAggRequetDto> aggRequest) {
        return intQueryService.operateAggregationQuery(ciTypeId, aggRequest);
    }

    @PostMapping("/intQuery/{queryId}/execute")
    public QueryResponse queryInt(@PathVariable("queryId") int queryId, @RequestBody QueryRequest queryRequest) {
        return ciService.integrateQuery(queryId, queryRequest);
    }

    @PostMapping("/intQuery/executeByName/{queryName}")
    public QueryResponse queryIntByName(@PathVariable("queryName") String queryName, @RequestBody QueryRequest queryRequest) {
        return ciService.integrateQuery(queryName, queryRequest);
    }

    @PostMapping("/intQuery/adhoc/execute")
    public QueryResponse queryAdhocInt(@RequestBody AdhocIntegrationQueryDto adhocQueryRequest) {
        return ciService.adhocIntegrateQuery(adhocQueryRequest);
    }

    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryName}/save")
    public int saveIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryName") String queryName, @RequestBody IntegrationQueryDto intQueryDto) {
        return intQueryService.createIntegrationQuery(ciTypeId, queryName, intQueryDto);
    }

    @PostMapping("/intQuery/{queryId}/update")
    public void updateIntQuery(@PathVariable("queryId") int queryId, @RequestBody IntegrationQueryDto intQueryDto) {
        intQueryService.updateIntegrationQuery(queryId, intQueryDto);
    }

    @PostMapping("/intQuery/ciType/{ciTypeId}/{queryId}/delete")
    public void deleteQuery(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryId") int queryId) {
        intQueryService.deleteIntegrationQuery(queryId);
    }

    @GetMapping("/intQuery/ciType/{ciTypeId}/search")
    public List<IdNamePairDto> searchIntQuery(@PathVariable("ciTypeId") Integer ciTypeId, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "tailAttrId", required = false) Integer tailAttrId) {
        return intQueryService.findAll(ciTypeId, name, tailAttrId);
    }

    @GetMapping("/intQuery/{queryId}/header")
    public List<IntQueryResponseHeader> queryIntHeader(@PathVariable("queryId") int queryId) {
        return ciService.integrateQueryHeader(queryId);
    }

    @GetMapping("/intQuery/headerByName")
    public List<IntQueryResponseHeader> queryIntHeader(@RequestParam("queryName") String queryName) {
        return ciService.integrateQueryHeader(queryName);
    }

    @GetMapping("/intQuery/ciType/{ciTypeId}/{queryId}")
    public IntegrationQueryDto getIntQueryById(@PathVariable("ciTypeId") Integer ciTypeId, @PathVariable("queryId") int queryId) {
        return intQueryService.getIntegrationQuery(queryId);
    }

    @GetMapping("/intQuery")
    public IntegrationQueryDto getIntQueryByName(@RequestParam("name")String queryName) {
        return intQueryService.getIntegrationQueryByName(queryName);
    }

    @PostMapping("/users/retrieve")
    public QueryResponse<UserDto> retrieveUsers(@RequestBody QueryRequest request) {
        return staticDtoService.query(UserDto.class, request);
    }

    @PostMapping("/users/create")
    public List<UserDto> createUsers(@Valid @RequestBody List<UserDto> userDtos) {
        userDtos.forEach(userDto->{
            if (StringUtils.isBlank(userDto.getPassword())) {
                userDto.setPassword(passwordEncoder.encode(userDto.getUsername()));
            } else {
                userDto.setPassword(passwordEncoder.encode(userDto.getPassword()));
            }
        });
        return staticDtoService.create(UserDto.class, userDtos);
    }

    @PostMapping("/roles/retrieve")
    public QueryResponse<RoleDto> retrieveRoles(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleDto.class, request);
    }

    @PostMapping("/roles/update")
    public List<RoleDto> updateRoles(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleDto.class, request);
    }

    @PostMapping("/roles/delete")
    public void deleteRoles(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleDto.class, requestIds);
    }

    @PostMapping("/roles/create")
    public List<RoleDto> createRoles(@Valid @RequestBody List<RoleDto> roleDtos) {
        return staticDtoService.create(RoleDto.class, roleDtos);
    }

    @PostMapping("/role-users/retrieve")
    public QueryResponse<RoleUserDto> retrieveRoleUsers(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleUserDto.class, request);
    }

    @PostMapping("/role-users/create")
    public List<RoleUserDto> createRoleUsers(@Valid @RequestBody List<RoleUserDto> roleUsers) {
        return staticDtoService.create(RoleUserDto.class, roleUsers);
    }

    @PostMapping("/role-users/delete")
    public void deleteRoleUsers(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleUserDto.class, requestIds);
    }

    @PostMapping("/role-citypes/retrieve")
    public QueryResponse<RoleCiTypeDto> retrieveRoleCiTypes(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleCiTypeDto.class, request);
    }

    @PostMapping("/role-citypes/create")
    public List<RoleCiTypeDto> createRoleCiTypes(@Valid @RequestBody List<RoleCiTypeDto> roleCiTypes) {
        return staticDtoService.create(RoleCiTypeDto.class, roleCiTypes);
    }

    @PostMapping("/role-citypes/update")
    public List<RoleCiTypeDto> updateRoleCiTypes(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleCiTypeDto.class, request);
    }

    @PostMapping("/role-citypes/delete")
    public void deleteRoleCiTypes(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleCiTypeDto.class, requestIds);
    }

    @PostMapping("/role-citype-ctrl-attrs/retrieve")
    public QueryResponse<RoleCiTypeCtrlAttrDto> retrieveRoleCiTypeCtrlAttrs(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleCiTypeCtrlAttrDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attrs/create")
    public List<RoleCiTypeCtrlAttrDto> createRoleCiTypeCtrlAttrs(@Valid @RequestBody List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs) {
        return staticDtoService.create(RoleCiTypeCtrlAttrDto.class, roleCiTypeCtrlAttrs);
    }

    @PostMapping("/role-citype-ctrl-attrs/update")
    public List<RoleCiTypeCtrlAttrDto> updateRoleCiTypeAttrs(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleCiTypeCtrlAttrDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attrs/delete")
    public void deleteRoleCiTypeCtrlAttrs(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleCiTypeCtrlAttrDto.class, requestIds);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/retrieve")
    public QueryResponse<RoleCiTypeCtrlAttrConditionDto> retrieveRoleCiTypeCtrlAttrConditions(@RequestBody QueryRequest request) {
        return staticDtoService.query(RoleCiTypeCtrlAttrConditionDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/create")
    public List<RoleCiTypeCtrlAttrConditionDto> createRoleCiTypeCtrlAttrConditions(@Valid @RequestBody List<RoleCiTypeCtrlAttrConditionDto> roleCiTypeCtrlAttrConditions) {
        return staticDtoService.create(RoleCiTypeCtrlAttrConditionDto.class, roleCiTypeCtrlAttrConditions);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/update")
    public List<RoleCiTypeCtrlAttrConditionDto> updateRoleCiTypeCtrlAttrConditions(@Valid @RequestBody List<Map<String, Object>> request) {
        return staticDtoService.update(RoleCiTypeCtrlAttrConditionDto.class, request);
    }

    @PostMapping("/role-citype-ctrl-attr-conditions/delete")
    public void deleteRoleCiTypeCtrlAttrConditions(@Valid @RequestBody List<Integer> requestIds) {
        staticDtoService.delete(RoleCiTypeCtrlAttrConditionDto.class, requestIds);
    }
    
    @GetMapping("/static-data/special-connector")
    public Object getSpecialConnector() {
        return constantService.getSpecialConnector();
    }
}
