package com.webank.cmdb.controller;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
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

    @GetMapping("/baseKey/category/overview")
    public List<CategoryDto> listBaseKeyInfo() {
        return baseKeyInfoService.listAllBasekeyCat(true);
    }

    @GetMapping("/baseKey/ciLayers")
    public List<CatCodeDto> listCILayers() {
        return baseKeyInfoService.listBaseKeyCodeWithCatName(CmdbConstants.CI_TYPE_LAYER);
    }

    @GetMapping("/baseKey/catalogs")
    public List<CatCodeDto> listCITypes() {
        return baseKeyInfoService.listBaseKeyCodeWithCatName(CmdbConstants.CI_TYPE_CATALOG);
    }

    @GetMapping("/baseKey/zoomLevels")
    public List<CatCodeDto> listZoomLevels() {
        return baseKeyInfoService.listBaseKeyCodeWithCatName(CmdbConstants.CI_TYPE_ZOOM_LEVEL);
    }

    @GetMapping("/baseKey/catType/overview")
    public List<CatTypeDto> listBaseKeyTypeOverview() {
        return baseKeyInfoService.listAllBasekeyCatTypeOverview();
    }

    @GetMapping("/baseKey/catTypes")
    public List<CatTypeDto> listBaseKeyTypes() {
        return baseKeyInfoService.listAllBasekeyCatTypes();
    }

    @PostMapping("/baseKey/catType/add")
    public void addBaseKeyType(@Valid @RequestBody CatTypeDto catTypeDto) {
        baseKeyInfoService.addBasekeyCatType(catTypeDto);
    }

    @GetMapping("/baseKey/catType/checkName")
    public boolean checkBaseKeyCateType(@RequestParam("catTypeName") String catTypeName) {
        return baseKeyInfoService.checkCatTypeName(catTypeName);
    }

    @PostMapping("/baseKey/catType/{catTypeId}/category/add")
    public CategoryDto addBaseKeyCat(@Valid @RequestBody CategoryDto catDto, @PathVariable("catTypeId") int catTypeId) {
        int catId = baseKeyInfoService.addCategory(catDto, catTypeId);
        return new CategoryDto(catId);
    }

    @PostMapping("/baseKey/catType/category/{catId}/delete")
    public void deleteBaseKeyCat(@PathVariable("catId") int catId) {
        baseKeyInfoService.deleteCategory(catId);
    }

    @GetMapping("/baseKey/catType/categories")
    public List<CategoryDto> listAllCategories() {
        return baseKeyInfoService.listAllBasekeyCat(false);
    }

    @PostMapping("/baseKey/catType/category/{catId}/update")
    public void updateBaseKeyCat(@PathVariable("catId") int catId, @Valid @RequestBody CategoryDto catDto) {
        baseKeyInfoService.updateCategory(catId, catDto);
    }

    @GetMapping("/baseKey/category/{catId}/codes")
    public List<CatCodeDto> listCodeForCat(@PathVariable("catId") int catTypeId) {
        return baseKeyInfoService.listCodes(catTypeId);
    }

    @PostMapping("/baseKey/category/{catId}/code/add")
    public CreationRtnDto addBaseKeyCode(@Valid @RequestBody CatCodeDto codeDto, @PathVariable("catId") int catId) {
        return new CreationRtnDto(baseKeyInfoService.addCode(catId, codeDto));
    }

    @PostMapping("/baseKey/category/code/{codeId}/delete")
    public void deleteBaseKeyCode(@PathVariable("codeId") int codeId) {
        baseKeyInfoService.deleteCode(codeId);
    }

    @PostMapping("/baseKey/category/code/{codeId}/update")
    public void updateBaseKeyCode(@Valid @RequestBody CatCodeDto codeDto, @PathVariable("codeId") int codeId) {
        baseKeyInfoService.updateCode(codeId, codeDto);
    }

    @PostMapping("/baseKey/category/code/{codeId}/up")
    public void moveUpBaseKeyCode(@PathVariable("codeId") int codeId) {
        baseKeyInfoService.updateCodePriority(codeId, PriorityUpdateOper.Up);
    }

    @PostMapping("/baseKey/category/code/{codeId}/down")
    public void moveDownBaseKeyCode(@PathVariable("codeId") int codeId) {
        baseKeyInfoService.updateCodePriority(codeId, PriorityUpdateOper.Down);
    }
}
