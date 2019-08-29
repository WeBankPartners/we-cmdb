package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;

import java.util.List;

import javax.annotation.security.RolesAllowed;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.PriorityUpdateOper;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.dto.CreationRtnDto;
import com.webank.cmdb.service.BaseKeyInfoService;

@RestController
public class BaseKeyController {
    @Autowired
    private BaseKeyInfoService baseKeyInfoService;

    @RolesAllowed({MENU_QUERY_CONFIG, MENU_OVERVIEW})
    @GetMapping("/baseKey/ciLayers")
    public List<CatCodeDto> listCILayers() {
        return baseKeyInfoService.listBaseKeyCodeWithCatName(CmdbConstants.CI_TYPE_LAYER);
    }

    @RolesAllowed({MENU_QUERY_CONFIG, MENU_OVERVIEW})
    @GetMapping("/baseKey/catalogs")
    public List<CatCodeDto> listCITypes() {
        return baseKeyInfoService.listBaseKeyCodeWithCatName(CmdbConstants.CI_TYPE_CATALOG);
    }

    @RolesAllowed({MENU_QUERY_CONFIG, MENU_OVERVIEW})
    @GetMapping("/baseKey/zoomLevels")
    public List<CatCodeDto> listZoomLevels() {
        return baseKeyInfoService.listBaseKeyCodeWithCatName(CmdbConstants.CI_TYPE_ZOOM_LEVEL);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @GetMapping("/baseKey/catType/overview")
    public List<CatTypeDto> listBaseKeyTypeOverview() {
        return baseKeyInfoService.listAllBasekeyCatTypeOverview();
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/catType/{catTypeId}/category/add")
    public CategoryDto addBaseKeyCat(@Valid @RequestBody CategoryDto catDto, @PathVariable("catTypeId") int catTypeId) {
        int catId = baseKeyInfoService.addCategory(catDto, catTypeId);
        return new CategoryDto(catId);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY, MENU_OVERVIEW, MENU_QUERY_CONFIG})
    @GetMapping("/baseKey/catType/categories")
    public List<CategoryDto> listAllCategories() {
        return baseKeyInfoService.listAllBasekeyCat(false);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/catType/category/{catId}/update")
    public void updateBaseKeyCat(@PathVariable("catId") int catId, @Valid @RequestBody CategoryDto catDto) {
        baseKeyInfoService.updateCategory(catId, catDto);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @GetMapping("/baseKey/category/{catId}/codes")
    public List<CatCodeDto> listCodeForCat(@PathVariable("catId") int catTypeId) {
        return baseKeyInfoService.listCodes(catTypeId);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/category/{catId}/code/add")
    public CreationRtnDto addBaseKeyCode(@Valid @RequestBody CatCodeDto codeDto, @PathVariable("catId") int catId) {
        return new CreationRtnDto(baseKeyInfoService.addCode(catId, codeDto));
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/category/code/{codeId}/delete")
    public void deleteBaseKeyCode(@PathVariable("codeId") int codeId) {
        baseKeyInfoService.deleteCode(codeId);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/category/code/{codeId}/update")
    public void updateBaseKeyCode(@Valid @RequestBody CatCodeDto codeDto, @PathVariable("codeId") int codeId) {
        baseKeyInfoService.updateCode(codeId, codeDto);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/category/code/{codeId}/up")
    public void moveUpBaseKeyCode(@PathVariable("codeId") int codeId) {
        baseKeyInfoService.updateCodePriority(codeId, PriorityUpdateOper.Up);
    }

    @RolesAllowed({MENU_BASIC_CONFIG_QUERY})
    @PostMapping("/baseKey/category/code/{codeId}/down")
    public void moveDownBaseKeyCode(@PathVariable("codeId") int codeId) {
        baseKeyInfoService.updateCodePriority(codeId, PriorityUpdateOper.Down);
    }
}
