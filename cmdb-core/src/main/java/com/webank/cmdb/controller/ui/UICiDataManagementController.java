package com.webank.cmdb.controller.ui;

import static com.google.common.collect.Lists.newArrayList;
import static com.webank.cmdb.controller.ui.helper.BooleanUtils.isTrue;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_CMDB_MODEL_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_ENQUIRY;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT;
import static com.webank.cmdb.dto.QueryRequest.defaultQueryObject;
import static org.apache.commons.lang3.StringUtils.isNotEmpty;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.security.RolesAllowed;

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
import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.exception.CmdbException;
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

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
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
            throw new CmdbException(errorMessage);
        }

        try {
            String contentType = file.getContentType();
            return imageService.upload(file.getName(), contentType, file.getBytes());
        } catch (IOException e) {
            String msg = String.format("Failed to upload image file. (fileName:%s)", file.getName());
            log.warn(msg, e);
            throw new CmdbException(msg);
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
    public Object updateCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId, @RequestBody List<Map<String, Object>> ciTypeAttrDto) {
        return wrapperService.updateCiTypeAttributes(ciTypeAttrDto);
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

    @PostMapping("/referenceCiData/{reference-attr-id}/query")
    @ResponseBody
    public Object queryReferenceCiData(@PathVariable(value = "reference-attr-id") int referenceAttrId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryReferenceCiData(referenceAttrId, queryObject);
    }

    @PostMapping("/referenceEnumCodes/{reference-attr-id}/query")
    @ResponseBody
    public Object queryReferenceEnumCodes(@PathVariable(value = "reference-attr-id") int referenceAttrId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryReferenceEnumCodes(referenceAttrId, queryObject);
    }

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
}
