package com.webank.cmdb.service;

import java.util.List;

import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;

import com.webank.cmdb.constant.PriorityUpdateOper;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CategoryDto;

@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "baseKeyInfoService")
public interface BaseKeyInfoService extends CmdbService {
    static public String NAME = "BaseKeyInfoService";

    List<CategoryDto> listAllBasekeyCat(boolean withCodeInfo);

    List<CatCodeDto> listBaseKeyCodeWithCatName(String catName);

    List<CatTypeDto> listAllBasekeyCatTypeOverview();

    List<CatTypeDto> listAllBasekeyCatTypes();

    void addBasekeyCatType(CatTypeDto baseKeyCatTypeDto);

    boolean checkCatTypeName(String catTypeName);

    int addCategory(CategoryDto catDto, int catTypeId);

    int addCode(int catId, CatCodeDto codeDto);

    void deleteCode(int codeId);

    void updateCode(int codeId, CatCodeDto codeDto);

    void updateCodePriority(int codeId, PriorityUpdateOper up);

    void deleteCategory(int catTypeId);

    List<CatCodeDto> listCodes(int catTypeId);

    void updateCategory(int catId, CategoryDto catDto);

    void deleteCatType(int catTypeId);

    List<CategoryDto> listCommonCats();

    @Cacheable("baseKeyInfoService-listCiTypeCats")
    List<CategoryDto> listCiTypeCats(int ciTypeId);

    @Cacheable("baseKeyInfoService-getCode-codeId")
    CatCodeDto getCode(int CodeId);

    @Cacheable("baseKeyInfoService-getCode-catId_code")
    CatCodeDto getCode(int catId, String code);
}
