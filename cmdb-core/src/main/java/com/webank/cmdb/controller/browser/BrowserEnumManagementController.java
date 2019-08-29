package com.webank.cmdb.controller.browser;

import static com.webank.cmdb.controller.browser.helper.JsonResponse.error;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.okay;
import static com.webank.cmdb.controller.browser.helper.JsonResponse.okayWithData;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_BASE_DATA_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_CMDB_MODEL_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_PERMISSION_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_ENQUIRY;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_DATA_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION;

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

import com.google.common.collect.Lists;
import com.webank.cmdb.controller.browser.helper.BrowserWrapperService;
import com.webank.cmdb.controller.browser.helper.JsonResponse;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.dto.QueryRequest;

@RestController
@RequestMapping("/browser/v2")
public class BrowserEnumManagementController {

    @Autowired
    private BrowserWrapperService wrapperService;

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types")
    @ResponseBody
    public JsonResponse getAllEnumCategoryTypes() {
        return okayWithData(wrapperService.getAllEnumCategoryTypes());
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/enum/category-types/{category-type-id}/categories/create")
    @ResponseBody
    public JsonResponse createEnumCategory(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId, @RequestBody CategoryDto categoryDto) {
        return okayWithData(wrapperService.createEnumCategories(categoryDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types/categories")
    @ResponseBody
    public JsonResponse getAllEnumCategories() {
        return okayWithData(wrapperService.getAllEnumCategories());
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types/{category-type-id}/categories")
    @ResponseBody
    public JsonResponse getEnumCategoriesByTypeId(@PathVariable(value = "category-type-id") Integer categoryTypeId) {
        return okayWithData(wrapperService.getEnumCategoriesByTypeId(categoryTypeId).getContents());
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types/categories/query-by-multiple-types")
    @ResponseBody
    public JsonResponse getEnumCategoriesByTypes(@RequestParam(name = "types") String types, @RequestParam(name = "ci-type-id", required = false) Integer ciTypeId) {
        return okayWithData(wrapperService.getEnumCategoryByMultipleTypes(types, ciTypeId));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PutMapping("/enum/category-types/{category-type-id}/categories/{category-id}")
    @ResponseBody
    public JsonResponse updateEnumCategory(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId,
            @PathVariable(value = "category-id", required = false) Integer categoryId,
            @RequestBody Map<String, Object> categoryDto) {
        wrapperService.updateEnumCategories(Lists.newArrayList(categoryDto));
        return okay();
    }

    // TO DO: Unused by UI, to be discarded?
    @DeleteMapping("/enum/category-types/{category-type-id}/categories/{category-id}")
    @ResponseBody
    public JsonResponse deleteEnumCategory(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId, @PathVariable(value = "category-id") int categoryId) {
        // cmdbResourceService.deleteEnumCategories(categoryId);
        // return okay();
        return error("This API will be discarded as never used.");
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/category-types/{category-type-id}/categories/{category-id}/codes/create")
    @ResponseBody
    public JsonResponse createEnumCode(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId,
            @PathVariable(value = "category-id", required = false) Integer categoryId,
            @RequestBody CatCodeDto catCodeDto) {
        return okayWithData(wrapperService.createEnumCodes(catCodeDto));
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY, MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION })
    @GetMapping("/enum/category-types/{category-type-id}/categories/{category-id}/codes")
    @ResponseBody
    public JsonResponse getEnumCodesByCategoryId(@PathVariable(value = "category-type-id") Integer categoryTypeId,
            @PathVariable(value = "category-id") Integer categoryId) {
        return okayWithData(wrapperService.getEnumCodesByCategoryId(categoryId));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY })
    @GetMapping("/ci-type-layers")
    public JsonResponse getCiTypeLayers() {
        return okayWithData(wrapperService.getAllLayers());
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-type-layers/create")
    @ResponseBody
    public JsonResponse createCiTypeLayer(@RequestBody CatCodeDto catCodeDto) {
        return okayWithData(wrapperService.createLayer(catCodeDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-type-layers/{layer-id}/swap-position")
    @ResponseBody
    public JsonResponse swapCiTypeLayerPosition(@PathVariable(value = "layer-id") int layerId, @RequestParam(value = "target-layer-id") int targetLayerId) {
        wrapperService.swapCiTypeLayerPosition(layerId, targetLayerId);
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @DeleteMapping("/ci-type-layers/{layer-id}")
    @ResponseBody
    public JsonResponse deleteCiTypeLayer(@PathVariable(value = "layer-id") int layerId) {
        wrapperService.deleteEnumCodes(layerId);
        return okay();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/system/codes")
    @ResponseBody
    public JsonResponse querySystemEnumCodesWithRefResources(@RequestBody QueryRequest queryObject) {
        return okayWithData(wrapperService.querySystemEnumCodesWithRefResources(queryObject));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/non-system/codes")
    @ResponseBody
    public JsonResponse queryNonSystemEnumCodesWithRefResources(@RequestBody QueryRequest queryObject) {
        return okayWithData(wrapperService.queryNonSystemEnumCodesWithRefResources(queryObject));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @GetMapping("/enum/system-categories")
    @ResponseBody
    public JsonResponse getSystemCategories() {
        return okayWithData(wrapperService.getAllSystemEnumCategories().getContents());
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @GetMapping("/enum/non-system-categories")
    @ResponseBody
    public JsonResponse getNonSystemCategories() {
        return okayWithData(wrapperService.getAllNonSystemEnumCategories().getContents());
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @GetMapping("/enum/categories/{category-id}/group-list")
    @ResponseBody
    public JsonResponse getGroupListByCategoryId(@PathVariable(value = "category-id") int categoryId) {
        return okayWithData(wrapperService.getGroupListByCatId(categoryId));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/codes/update")
    @ResponseBody
    public JsonResponse updateEnumCodes(@RequestBody List<Map<String, Object>> catCodeDtos) {
        return okayWithData(wrapperService.updateEnumCodes(catCodeDtos));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/codes/delete")
    @ResponseBody
    public JsonResponse deleteEnumCodes(@RequestBody List<Integer> codeIds) {
        wrapperService.deleteEnumCodes(codeIds.toArray(new Integer[codeIds.size()]));
        return okay();
    }
}
