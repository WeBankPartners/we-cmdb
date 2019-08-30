package com.webank.cmdb.controller.browser;

import static com.google.common.collect.Lists.newArrayList;
import static com.webank.cmdb.controller.browser.helper.BooleanUtils.isTrue;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.error;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.okay;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.okayWithData;
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
import com.webank.cmdb.controller.browser.helper.BrowserWrapperService;
import com.webank.cmdb.controller.browser.helper.JsonResponse;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.service.ImageService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/browser/v2")
public class BrowserCiDataManagementController {

    @Autowired
    private ApplicationProperties applicationProperties;
    @Autowired
    private ImageService imageService;
    @Autowired
    private BrowserWrapperService wrapperService;

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @GetMapping("/ci-types")
    @ResponseBody
    public JsonResponse getCiTypes(@RequestParam(name = "group-by", required = false) String groupBy, @RequestParam(name = "with-attributes", required = false) String withAttributes,
            @RequestParam(name = "status", required = false) String status) {
        if ("catalog".equalsIgnoreCase(groupBy)) {
            return okayWithData(wrapperService.getCiTypesGroupByCatalogs(isTrue(withAttributes), status));
        } else if ("layer".equalsIgnoreCase(groupBy)) {
            return okayWithData(wrapperService.getCiTypesGroupByLayers(isTrue(withAttributes), status));
        } else {
            return okayWithData(wrapperService.getAllCiTypes(isTrue(withAttributes), status));
        }
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/create")
    @ResponseBody
    public JsonResponse createCiType(@RequestBody CiTypeDto ciTypeDto) {
        return okayWithData(wrapperService.createCiTypes(ciTypeDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PutMapping("/ci-types/{ci-type-id}")
    @ResponseBody
    public JsonResponse updateCiType(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody Map<String, Object> ciTypeDto) {
        wrapperService.updateCiTypes(Lists.newArrayList(ciTypeDto));
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @DeleteMapping("/ci-types/{ci-type-id}")
    @ResponseBody
    public JsonResponse deleteCiType(@PathVariable(value = "ci-type-id") int ciTypeId) {
        wrapperService.deleteCiTypes(ciTypeId);
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/icon")
    @ResponseBody
    public JsonResponse uploadCiTypeIcon(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestParam(value = "file", required = false) MultipartFile file) throws CmdbException {
        if (file.getSize() > applicationProperties.getMaxFileSize().toBytes()) {
            String errorMessage = String.format("Upload image icon for CiType (%s) failed due to file size (%s bytes) exceeded limitation (%s KB).", ciTypeId, file.getSize(), applicationProperties.getMaxFileSize().toKilobytes());
            log.warn(errorMessage);
            throw new CmdbException(errorMessage);
        }

        try {
            String contentType = file.getContentType();
            return okayWithData(imageService.upload(file.getName(), contentType, file.getBytes()));
        } catch (IOException e) {
            String msg = String.format("Failed to upload image file. (fileName:%s)", file.getName());
            log.warn(msg, e);
            return error(msg);
        }
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/apply")
    @ResponseBody
    public JsonResponse applyCiType(@PathVariable(value = "ci-type-id") Integer ciTypeId) {
        Integer[] ciTypeIdArray = { ciTypeId };
        wrapperService.applyCiType(ciTypeIdArray);
        return okay();
    }

    @PostMapping("/ci-types/apply")
    @ResponseBody
    public JsonResponse applyCiTypes() {
        wrapperService.applyCiTypes();
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/ci-types/{ci-type-id}/references/by")
    @ResponseBody
    public JsonResponse getCiTypeReferenceBy(@PathVariable(value = "ci-type-id") int ciTypeId) {
        return okayWithData(wrapperService.getCiTypeReferenceBy(ciTypeId));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT })
    @GetMapping("/ci-types/{ci-type-id}/references/to")
    @ResponseBody
    public JsonResponse getCiTypeReferenceTo(@PathVariable(value = "ci-type-id") int ciTypeId) {
        return okayWithData(wrapperService.getCiTypeReferenceTo(ciTypeId));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/attributes/create")
    @ResponseBody
    public JsonResponse createCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody CiTypeAttrDto ciTypeAttrDto) {
        ciTypeAttrDto.setCiTypeId(ciTypeId);
        return okayWithData(wrapperService.createCiTypeAttribute(ciTypeAttrDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @GetMapping("/ci-types/{ci-type-id}/attributes")
    @ResponseBody
    public JsonResponse getCiTypeAttributes(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestParam(name = "accept-input-types", required = false) String acceptInputTypes) {
        if (isNotEmpty(acceptInputTypes)) {
            return okayWithData(wrapperService.queryCiTypeAttributes(defaultQueryObject("ciTypeId", ciTypeId).addInFilter("inputType", newArrayList(acceptInputTypes.split(",")))));
        } else {
            return okayWithData(wrapperService.getCiTypeAttributesByCiTypeId(ciTypeId));
        }
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PutMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}")
    @ResponseBody
    public JsonResponse updateCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId, @RequestBody List<Map<String, Object>> ciTypeAttrDto) {
        return okayWithData(wrapperService.updateCiTypeAttributes(ciTypeAttrDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @DeleteMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}")
    @ResponseBody
    public JsonResponse deleteCiTypeAttribute(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId) {
        wrapperService.deleteCiTypeAttributes(attributeId);
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-type-attributes/apply")
    @ResponseBody
    public JsonResponse applyCiTypeAttributes(@PathVariable(value = "ci-type-id") Integer ciTypeId, @RequestBody Integer[] ciTypeAttrIds) {
        wrapperService.applyCiTypeAttributes(ciTypeAttrIds);
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/attributes/{attribute-id}/swap-position")
    @ResponseBody
    public JsonResponse swapCiTypeAttributePosition(@PathVariable(value = "ci-type-id") int ciTypeId, @PathVariable(value = "attribute-id") int attributeId, @RequestParam(value = "target-attribute-id") int targetAttributeId) {
        wrapperService.swapCiTypeAttributePosition(attributeId, targetAttributeId);
        return okay();
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/batch-create")
    @ResponseBody
    public JsonResponse createCiData(@PathVariable(value = "ci-type-id") int ciTypeId,
            @RequestBody List<Map<String, Object>> ciDataDtos) {
        return okayWithData(wrapperService.createCiData(ciTypeId, ciDataDtos));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/query")
    @ResponseBody
    public JsonResponse queryCiData(@PathVariable(value = "ci-type-id") int ciTypeId,
            @RequestBody QueryRequest queryObject) {
        return okayWithData(wrapperService.queryCiData(ciTypeId, queryObject));
    }

    @PostMapping("/referenceCiData/{reference-attr-id}/query")
    @ResponseBody
    public JsonResponse queryReferenceCiData(@PathVariable(value = "reference-attr-id") int referenceAttrId,
            @RequestBody QueryRequest queryObject) {
        return okayWithData(wrapperService.queryReferenceCiData(referenceAttrId, queryObject));
    }

    @PostMapping("/referenceEnumCodes/{reference-attr-id}/query")
    @ResponseBody
    public JsonResponse queryReferenceEnumCodes(@PathVariable(value = "reference-attr-id") int referenceAttrId,
            @RequestBody QueryRequest queryObject) {
        return okayWithData(wrapperService.queryReferenceEnumCodes(referenceAttrId, queryObject));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/batch-update")
    @ResponseBody
    public JsonResponse updateCiData(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody List<Map<String, Object>> ciDatas) {
        return okayWithData(wrapperService.updateCiData(ciTypeId, ciDatas));
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci-types/{ci-type-id}/ci-data/batch-delete")
    @ResponseBody
    public JsonResponse deleteCiData(@PathVariable(value = "ci-type-id") int ciTypeId, @RequestBody List<String> ciDataIds) {
        wrapperService.deleteCiData(ciTypeId, ciDataIds);
        return okay();
    }

    @RolesAllowed({ MENU_DESIGNING_CI_DATA_MANAGEMENT })
    @PostMapping("/ci/state/operate")
    @ResponseBody
    public JsonResponse operateCiForState(@RequestParam("operation") String operation,
            @RequestBody List<CiIndentity> operateCiObject) {
        return okayWithData(wrapperService.operateCiForState(operateCiObject, operation));
    }
}
