package com.webank.cmdb.controller.ui;

import static com.google.common.collect.Lists.newArrayList;
import static com.webank.cmdb.controller.ui.helper.BooleanUtils.isTrue;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_CMDB_MODEL_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_APPLICATION_ARCHITECTURE_DESIGN;
import static com.webank.cmdb.domain.AdmMenu.MENU_APPLICATION_ARCHITECTURE_QUERY;
import static com.webank.cmdb.domain.AdmMenu.MENU_APPLICATION_DEPLOYMENT_DESIGN;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_ENQUIRY;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_IDC_PLANNING_DESIGN;
import static com.webank.cmdb.domain.AdmMenu.MENU_IDC_RESOURCE_PLANNING;
import static com.webank.cmdb.dto.QueryRequest.defaultQueryObject;
import static org.apache.commons.lang3.StringUtils.isNotEmpty;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.security.RolesAllowed;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.Lists;
import com.webank.cmdb.config.ApplicationProperties;
import com.webank.cmdb.controller.ui.helper.ResourceTreeDto;
import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.controller.ui.helper.ZoneLinkDto;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.service.ImageService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/ui/v2")
public class UICiDataManagementController {

    @Autowired
    private ApplicationProperties applicationProperties;
    @Autowired
    private ImageService imageService;
    @Autowired
    private UIWrapperService wrapperService;

    @GetMapping("/ci-types")
    @ResponseBody
    public Object getCiTypes(@RequestParam(name = "group-by", required = false) String groupBy, @RequestParam(name = "with-attributes", required = false) String withAttributes,
            @RequestParam(name = "status", required = false) String status) {
        if ("catalog".equalsIgnoreCase(groupBy)) {
            return wrapperService.getCiTypesGroupByCatalogs(isTrue(withAttributes), status);
        } else if ("layer".equalsIgnoreCase(groupBy)) {
            return wrapperService.getCiTypesGroupByLayers(isTrue(withAttributes), status);
        } else {
            return wrapperService.getAllCiTypes(isTrue(withAttributes), status);
        }
    }

    @PostMapping("/ci-types/retrieve")
    @ResponseBody
    public QueryResponse<CiTypeDto> retrieveCiTypes(@RequestBody QueryRequest request) {
        return wrapperService.query(CiTypeDto.class, request);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/create")
    @ResponseBody
    public Object createCiType(@RequestBody CiTypeDto ciTypeDto) {
        return wrapperService.createCiTypes(ciTypeDto);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PutMapping("/ci-types/{ci-type-id}")
    @ResponseBody
    public void updateCiType(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody Map<String, Object> ciTypeDto) {
        wrapperService.updateCiTypes(Lists.newArrayList(ciTypeDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @DeleteMapping("/ci-types/{ci-type-id}")
    @ResponseBody
    public void deleteCiType(@PathVariable(value = "ci-type-id") int ciTypeId) {
        wrapperService.deleteCiTypes(ciTypeId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/icon")
    @ResponseBody
    public Object uploadCiTypeIcon(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestParam(value = "file", required = false) MultipartFile file) throws CmdbException {
        if (file.getSize() > applicationProperties.getMaxFileSize().toBytes()) {
            String errorMessage = String.format("Upload image icon for CiType (%s) failed due to file size (%s bytes) exceeded limitation (%s KB).", ciTypeId, file.getSize(), applicationProperties.getMaxFileSize().toKilobytes());
            log.warn(errorMessage);
            throw new CmdbException("3039", errorMessage,ciTypeId, file.getSize(), applicationProperties.getMaxFileSize().toKilobytes() );
        }

        try {
            String contentType = file.getContentType();
            return imageService.upload(file.getName(), contentType, file.getBytes());
        } catch (IOException e) {
            String msg = String.format("Failed to upload image file. (fileName:%s)", file.getName());
            log.warn(msg, e);
            throw new CmdbException("3040", msg, file.getName());
        }
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/apply")
    @ResponseBody
    public void applyCiType(@PathVariable(value = "ci-type-id") Integer ciTypeId) {
        Integer[] ciTypeIdArray = { ciTypeId };
        wrapperService.applyCiType(ciTypeIdArray);
    }

    @PostMapping("/ci-types/apply")
    @ResponseBody
    public void applyCiTypes() {
        wrapperService.applyCiTypes();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/ci-types/{ci-type-id}/references/by")
    @ResponseBody
    public Object getCiTypeReferenceBy(@PathVariable(value = "ci-type-id") int ciTypeId) {
        return wrapperService.getCiTypeReferenceBy(ciTypeId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/ci-types/{ci-type-id}/references/to")
    @ResponseBody
    public Object getCiTypeReferenceTo(@PathVariable(value = "ci-type-id") int ciTypeId) {
        return wrapperService.getCiTypeReferenceTo(ciTypeId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/attributes/create")
    @ResponseBody
    public Object createCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody CiTypeAttrDto ciTypeAttrDto) {
        ciTypeAttrDto.setCiTypeId(ciTypeId);
        return wrapperService.createCiTypeAttribute(ciTypeAttrDto);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @GetMapping("/ci-types/{ci-type-id}/attributes")
    @ResponseBody
    public Object getCiTypeAttributes(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestParam(name = "accept-input-types", required = false) String acceptInputTypes) {
        if (isNotEmpty(acceptInputTypes)) {
            return wrapperService.queryCiTypeAttributes(defaultQueryObject("ciTypeId", ciTypeId).addInFilter("inputType", newArrayList(acceptInputTypes.split(","))));
        } else {
            return wrapperService.getCiTypeAttributesByCiTypeId(ciTypeId);
        }
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PutMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}")
    @ResponseBody
    public Object updateCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId, @RequestBody Map<String, Object> ciTypeAttrDto) {
        return wrapperService.updateCiTypeAttributes(Arrays.asList(ciTypeAttrDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @DeleteMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}")
    @ResponseBody
    public void deleteCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId) {
        wrapperService.deleteCiTypeAttributes(attributeId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-type-attributes/apply")
    @ResponseBody
    public void applyCiTypeAttributes(@PathVariable(value = "ci-type-id") Integer ciTypeId, @RequestBody Integer[] ciTypeAttrIds) {
        wrapperService.applyCiTypeAttributes(ciTypeAttrIds);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}/swap-position")
    @ResponseBody
    public void swapCiTypeAttributePosition(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId, @RequestParam(value = "target-attribute-id") int targetAttributeId) {
        wrapperService.swapCiTypeAttributePosition(attributeId, targetAttributeId);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/batch-create")
    @ResponseBody
    public Object createCiData(@PathVariable(value = "ci-type-id") int ciTypeId,
            @RequestBody List<Map<String, Object>> ciDataDtos) {
        return wrapperService.createCiData(ciTypeId, ciDataDtos);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/query")
    @ResponseBody
    public Object queryCiData(@PathVariable(value = "ci-type-id") int ciTypeId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryCiData(ciTypeId, queryObject);
    }
    
    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/query-by-type")
    @ResponseBody
    public Object queryCiDataByType(@PathVariable(value = "ci-type-id") int ciTypeId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryCiDataByType(ciTypeId, queryObject);
    }
    
    @PostMapping("/referenceCiData/{reference-attr-id}/query")
    @ResponseBody
    public Object queryReferenceCiData(@PathVariable(value = "reference-attr-id") int referenceAttrId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryReferenceCiData(referenceAttrId, queryObject);
    }

/*
    @PostMapping("/referenceEnumCodes/{reference-attr-id}/query")
    @ResponseBody
    public Object queryReferenceEnumCodes(@PathVariable(value = "reference-attr-id") int referenceAttrId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryReferenceEnumCodes(referenceAttrId, queryObject);
    }
*/

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/batch-update")
    @ResponseBody
    public Object updateCiData(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody List<Map<String, Object>> ciDatas) {
        
        return wrapperService.updateCiData(ciTypeId, ciDatas);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/batch-delete")
    @ResponseBody
    public void deleteCiData(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody List<String> ciDataIds) {
        wrapperService.deleteCiData(ciTypeId, ciDataIds);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci/state/operate")
    @ResponseBody
    public Object operateCiForState(@RequestParam("operation") String operation,
            @RequestBody List<CiIndentity> operateCiObject) {
        return wrapperService.operateCiForState(operateCiObject, operation);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/implement")
    @ResponseBody
    public void implementCiType(@PathVariable(value = "ci-type-id") Integer ciTypeId, @RequestParam(value = "operation") String operation) {
        wrapperService.implementCiType(ciTypeId, operation);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}/implement")
    @ResponseBody
    public void implementCiTypeAttribute(@PathVariable(value = "ci-type-id") Integer ciTypeId, @PathVariable(value = "attribute-id") Integer attributeId, @RequestParam(value = "operation") String operation) {
        wrapperService.implementCiTypeAttribute(attributeId, operation);
    }

    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @GetMapping("/ci-data/all-idc-design")
    @ResponseBody
    public List<CiData> getAllIdcDesignData() {
        return wrapperService.getAllIdcDesignData();
    }
    
    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @PostMapping("/planning-designs/ci-data")
    @ResponseBody
    public Object getPlanningDesignsCiData(@RequestParam(value = "code-id") int codeId,@RequestParam(value = "idcs-guid") String idcGuid,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.getPlanningDesignsCiData(codeId,idcGuid, queryObject);
    }
    
    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @GetMapping("/planning-designs/tabs")
    @ResponseBody
    public Object getPlanningDesignTabs() {
        return wrapperService.getPlanningDesignTabs();
    }
    
    @RolesAllowed({ MENU_IDC_RESOURCE_PLANNING })
    @PostMapping("/resource-planning/ci-data")
    @ResponseBody
    public Object getResourcePlanningCiData(@RequestParam(value = "code-id") int codeId,@RequestParam(value = "idcs-guid") String idcGuid,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.getResourcePlanningCiData(codeId,idcGuid, queryObject);
    }
    
    @RolesAllowed({ MENU_IDC_RESOURCE_PLANNING })
    @GetMapping("/resource-planning/tabs")
    @ResponseBody
    public Object getResourcePlanningTabs() {
        return wrapperService.getResourcePlanningTabs();
    }

    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @PostMapping("/data-tree/query-idc-design-tree")
    @ResponseBody
    public List<ResourceTreeDto> getIdcDesignTreeByGuid(@RequestBody List<String> idcDesignGuids) {
        return wrapperService.getIdcDesignTreesByGuid(idcDesignGuids);
    }

    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @PostMapping("/data-tree/{citype_id}/query")
    @ResponseBody
    public List<ResourceTreeDto> getTree(@PathVariable("citype_id") Integer ciTypeId,@RequestBody List<String> guids) {
        return wrapperService.getTreeData(ciTypeId,guids);
    }

    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN, MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY})
    @GetMapping("/all-zone-link-design")
    @ResponseBody
    public List<ZoneLinkDto> getAllZoneLinkDesignGroupByIdcDesign() {
        return wrapperService.getAllZoneLinkDesignGroupByIdcDesign();
    }

    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @GetMapping("/ci-data/all-idc")
    @ResponseBody
    public List<CiData> getAllIdcData() {
        return wrapperService.getAllIdcData();
    }
    
    @RolesAllowed({ MENU_IDC_PLANNING_DESIGN })
    @PostMapping("/ci-data/idc")
    @ResponseBody
    public List<CiData> getIdcDataByGuid(@RequestBody List<String> idcGuids) {
        return wrapperService.getIdcDataByGuid(idcGuids);
    }

    @RolesAllowed({ MENU_IDC_RESOURCE_PLANNING })
    @PostMapping("/data-tree/query-idc-tree")
    @ResponseBody
    public List<ResourceTreeDto> getIdcImplementTreeByGuid(@RequestBody List<String> idcGuids) {
        return wrapperService.getIdcTreeByGuid(idcGuids);
    }

    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN, MENU_IDC_RESOURCE_PLANNING })
    @GetMapping("/all-zone-link")
    @ResponseBody
    public List<ZoneLinkDto> getAllZoneLinkGroupByIdc() {
        return wrapperService.getAllZoneLinkGroupByIdc();
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_DEPLOYMENT_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY })
    @GetMapping("/system-designs")
    @ResponseBody
    public Object getSystemDesigns() {
        return wrapperService.getSystemDesigns();
    }
    
    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_DEPLOYMENT_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY })
    @GetMapping("/system")
    @ResponseBody
    public Object getSystems() {
        return wrapperService.getSystems();
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN })
    @PutMapping("/ci-types/{ci-type-id}/ci-data/{ci-data-id}")
    @ResponseBody
    public List<Map<String, Object>> updateCiData(@PathVariable(value = "ci-type-id") int ciTypeId,
            @PathVariable(value = "ci-data-id") String ciDataId, @RequestBody Map<String, Object> ciData) {
        return wrapperService.updateCiData(ciTypeId, Arrays.asList(ciData));
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY })
    @GetMapping("/trees/all-design-trees/from-system-design")
    @ResponseBody
    public List<ResourceTreeDto> getAllDesignTreesFromSystemDesign(@RequestParam(value = "system-design-guid") String systemDesignGuid) {
        return wrapperService.getAllDesignTreesFromSystemDesign(systemDesignGuid);
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN })
    @PostMapping("/trees/all-design-trees/from-system-design/save")
    @ResponseBody
    public void saveAllDesignTreesFromSystemDesign(@RequestParam(value = "system-design-guid") String systemDesignGuid) {
        wrapperService.saveAllDesignTreesFromSystemDesign(systemDesignGuid);
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY })
    @GetMapping("/architecture-designs/tabs")
    @ResponseBody
    public Object getArchitectureDesignTabs() {
        return wrapperService.getArchitectureDesignTabs();
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY })
    @PostMapping("/architecture-designs/tabs/ci-data")
    @ResponseBody
    public Object getArchitectureCiData(@RequestParam(value = "code-id") Integer codeId,
            @RequestParam(value = "system-design-guid") String systemDesignGuid,@RequestParam(value = "r-guid") String rGuid,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.getArchitectureCiData(codeId, systemDesignGuid, queryObject,rGuid);
    }

    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @PostMapping("/deploy-designs/tabs/ci-data")
    @ResponseBody
    public Object getDeployCiData(@RequestParam(value = "code-id") Integer codeId,
            @RequestParam(value = "system-guid") String systemGuid,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.getDeployCiData(codeId, null, systemGuid, queryObject);
    }
    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @PostMapping("/deploy-designs/tabs/update-system-design")
    @ResponseBody
    public Object updateSystemDesign(@RequestParam(value = "system-guid") String systemGuid) {
        return wrapperService.updateSystemDesign(systemGuid);
    }

    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @GetMapping("/deploy-designs/tabs")
    @ResponseBody
    public Object getDeployDesignTabs() {
        return wrapperService.getDeployDesignTabs();
    }
    
    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @GetMapping("/trees/all-deploy-trees/from-system")
    @ResponseBody
    public List<ResourceTreeDto> getAllDeployTreesFromSystem(@RequestParam(value = "system-guid") String systemGuid) {
        return wrapperService.getAllDeployTreesFromSystem(systemGuid);
    }

    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @GetMapping("/data-tree/application-deployment")
    @ResponseBody
    public List<ResourceTreeDto> getApplicationDeploymentDataTree(@RequestParam(value = "system-guid") String systemGuid) {
        return wrapperService.getApplicationDeploymentDesignDataTreeBySystemDesignGuidAndEnvCode(systemGuid);
    }

    @RolesAllowed({ MENU_APPLICATION_ARCHITECTURE_DESIGN, MENU_APPLICATION_ARCHITECTURE_QUERY })
    @GetMapping("/data-tree/application-framework-design")
    @ResponseBody
    public List<ResourceTreeDto> getApplicationFrameworkDesignDataTree(@RequestParam(value = "system-design-guid") String systemDesignGuid) {
        return wrapperService.getApplicationFrameworkDesignDataTreeBySystemDesignGuid(systemDesignGuid);
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @GetMapping("/ci-data/{ci-type-id}/query-password/{guid}/{field}")
    @ResponseBody
    public ResponseDto queryPassword(@PathVariable(value = "ci-type-id") int ciTypeId,@PathVariable(value = "guid") String guid,@PathVariable(value = "field") String field) {
        QueryResponse<CiData> ciData = wrapperService.queryCiDataShowPassword(ciTypeId, defaultQueryObject(CmdbConstants.GUID, guid),true);
        ResponseDto responseDto = new ResponseDto();
        if(ciData.getContents().size()>0){
            responseDto.setStatusCode(ResponseDto.STATUS_OK);
            responseDto.setData(ciData.getContents().get(0).getData().get(field));
        }else{
            responseDto.setStatusCode(ResponseDto.STATUS_ERROR);
            responseDto.setStatusMessage(String.format("Can not find field [%s] value for guid [%s].", field, guid));
        }
        return responseDto;
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @PostMapping("/ci-data/{ci-type-id}/change-password")
    @ResponseBody
    public ResponseDto<?> updatePassword(@PathVariable(value = "ci-type-id") int ciTypeId,@RequestBody Map<String, Object> param) {
        ResponseDto<?> responseDto = new ResponseDto();
        try {
            wrapperService.updateCiDataForPassword(ciTypeId, param);
            responseDto.setStatusCode(ResponseDto.STATUS_OK);
        } catch (Exception e) {
            e.printStackTrace();
            responseDto.setStatusCode(ResponseDto.STATUS_ERROR);
            responseDto.setStatusMessage(e.getMessage());
        }
        return responseDto;
    }
}
