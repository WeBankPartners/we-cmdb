package com.webank.cmdb.controller.ui;

import static com.webank.cmdb.domain.AdmMenu.MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_CMDB_MODEL_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_PERMISSION_MANAGEMENT;
import static com.webank.cmdb.domain.AdmMenu.MENU_APPLICATION_DEPLOYMENT_DESIGN;
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
import com.webank.cmdb.controller.ui.helper.UIWrapperService;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;

@RestController
@RequestMapping("/ui/v2")
public class UIEnumManagementController {

    @Autowired
    private UIWrapperService wrapperService;

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types")
    @ResponseBody
    public Object getAllEnumCategoryTypes() {
        return wrapperService.getAllEnumCategoryTypes();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/enum/category-types/{category-type-id}/categories/create")
    @ResponseBody
    public Object createEnumCategory(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId, @RequestBody CategoryDto categoryDto) {
        return wrapperService.createEnumCategories(categoryDto);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types/categories")
    @ResponseBody
    public Object getAllEnumCategories() {
        return wrapperService.getAllEnumCategories();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types/{category-type-id}/categories")
    @ResponseBody
    public Object getEnumCategoriesByTypeId(@PathVariable(value = "category-type-id") Integer categoryTypeId) {
        return wrapperService.getEnumCategoriesByTypeId(categoryTypeId).getContents();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @GetMapping("/enum/category-types/categories/query-by-multiple-types")
    @ResponseBody
    public Object getEnumCategoriesByTypes(@RequestParam(name = "types") String types, @RequestParam(name = "ci-type-id", required = false) Integer ciTypeId) {
        return wrapperService.getEnumCategoryByMultipleTypes(types, ciTypeId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PutMapping("/enum/category-types/{category-type-id}/categories/{category-id}")
    @ResponseBody
    public void updateEnumCategory(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId,
            @PathVariable(value = "category-id", required = false) Integer categoryId,
            @RequestBody Map<String, Object> categoryDto) {
        wrapperService.updateEnumCategories(Lists.newArrayList(categoryDto));
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/category-types/{category-type-id}/categories/{category-id}/codes/create")
    @ResponseBody
    public Object createEnumCode(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId,
            @PathVariable(value = "category-id", required = false) Integer categoryId,
            @RequestBody CatCodeDto catCodeDto) {
        return wrapperService.createEnumCodes(catCodeDto);
    }

    @RolesAllowed({ MENU_ADMIN_PERMISSION_MANAGEMENT, MENU_DESIGNING_CI_DATA_MANAGEMENT, MENU_DESIGNING_CI_DATA_ENQUIRY, MENU_DESIGNING_CI_INTEGRATED_QUERY_EXECUTION })
    @GetMapping("/enum/category-types/{category-type-id}/categories/{category-id}/codes")
    @ResponseBody
    public Object getEnumCodesByCategoryId(@PathVariable(value = "category-type-id") Integer categoryTypeId,
            @PathVariable(value = "category-id") Integer categoryId) {
        return wrapperService.getEnumCodesByCategoryId(categoryId);
    }

    @GetMapping("/ci-type-layers")
    public Object getCiTypeLayers() {
        return wrapperService.getAllLayers();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-type-layers/create")
    @ResponseBody
    public Object createCiTypeLayer(@RequestBody CatCodeDto catCodeDto) {
        return wrapperService.createLayer(catCodeDto);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/ci-type-layers/{layer-id}/swap-position")
    @ResponseBody
    public void swapCiTypeLayerPosition(@PathVariable(value = "layer-id") int layerId, @RequestParam(value = "target-layer-id") int targetLayerId) {
        wrapperService.swapCiTypeLayerPosition(layerId, targetLayerId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @DeleteMapping("/ci-type-layers/{layer-id}")
    @ResponseBody
    public void deleteCiTypeLayer(@PathVariable(value = "layer-id") int layerId) {
        wrapperService.deleteEnumCodes(layerId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/system/codes")
    @ResponseBody
    public Object querySystemEnumCodesWithRefResources(@RequestBody QueryRequest queryObject) {
        return wrapperService.querySystemEnumCodesWithRefResources(queryObject);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/non-system/codes")
    @ResponseBody
    public Object queryNonSystemEnumCodesWithRefResources(@RequestBody QueryRequest queryObject) {
        return wrapperService.queryNonSystemEnumCodesWithRefResources(queryObject);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @GetMapping("/enum/system-categories")
    @ResponseBody
    public Object getSystemCategories() {
        return wrapperService.getAllSystemEnumCategories().getContents();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @GetMapping("/enum/non-system-categories")
    @ResponseBody
    public Object getNonSystemCategories() {
        return wrapperService.getAllNonSystemEnumCategories().getContents();
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @GetMapping("/enum/categories/{category-id}/group-list")
    @ResponseBody
    public Object getGroupListByCategoryId(@PathVariable(value = "category-id") int categoryId) {
        return wrapperService.getGroupListByCatId(categoryId);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/codes/create")
    @ResponseBody
    public Object createEnumCodes(@RequestBody List<CatCodeDto> catCodeDto) {
        return wrapperService.createEnumCodes(catCodeDto);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/codes/update")
    @ResponseBody
    public Object updateEnumCodes(@RequestBody List<Map<String, Object>> catCodeDtos) {
        return wrapperService.updateEnumCodes(catCodeDtos);
    }

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT, MENU_CMDB_ADMIN_BASE_DATA_MANAGEMENT })
    @PostMapping("/enum/codes/delete")
    @ResponseBody
    public void deleteEnumCodes(@RequestBody List<Integer> codeIds) {
        wrapperService.deleteEnumCodes(codeIds.toArray(new Integer[codeIds.size()]));
    }

    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @PostMapping("/enum/categories/query")
    @ResponseBody
    public QueryResponse<CategoryDto> queryEnumCategories(@RequestBody QueryRequest queryObject) {
        return wrapperService.queryEnumCategories(queryObject);
    }

    @RolesAllowed({ MENU_APPLICATION_DEPLOYMENT_DESIGN })
    @PostMapping("/enum/category-types/{category-type-id}/categories/{category-id}/codes/query")
    @ResponseBody
    public QueryResponse<CatCodeDto> queryEnumCodes(@PathVariable(value = "category-type-id", required = false) Integer categoryTypeId,
            @PathVariable(value = "category-id") Integer categoryId,
            @RequestBody QueryRequest queryObject) {
        return wrapperService.queryEnumCodes(queryObject.addEqualsFilter("catId", categoryId));
    }
}
