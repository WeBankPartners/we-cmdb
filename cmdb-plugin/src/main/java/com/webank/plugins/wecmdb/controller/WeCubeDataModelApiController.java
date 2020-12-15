package com.webank.plugins.wecmdb.controller;

import com.webank.cmdb.support.exception.CmdbException;
import com.webank.plugins.wecmdb.dto.wecube.DataModelResponseDto;
import com.webank.plugins.wecmdb.dto.wecube.EntityDto;
import com.webank.plugins.wecmdb.dto.wecube.QueryRequest;
import com.webank.plugins.wecmdb.service.I18nMessageConverter;
import com.webank.plugins.wecmdb.service.WecubeAdapterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@SuppressWarnings("rawtypes")
@RestController
public class WeCubeDataModelApiController {
    @Autowired
    private WecubeAdapterService wecubeAdapterService;
    @Autowired
    I18nMessageConverter i18nMessageConverter;

    @GetMapping("/data-model")
    @ResponseBody
    public DataModelResponseDto<List<EntityDto>> getDataModel() {
        List<EntityDto> dataModelEntities = wecubeAdapterService.getDataModel();
        return DataModelResponseDto.okWithData(dataModelEntities);
    }

    @GetMapping("/entities/{entity-name}")
    @ResponseBody
    public DataModelResponseDto<List<Map<String, Object>>> retrieveCiData(@PathVariable(value = "entity-name") String entityName,
                                 @RequestParam(value = "filter", required = false) String filter,
                                 @RequestParam(value = "sorting", required = false) String sorting,
                                 @RequestParam(value = "select", required = false) String select) {
        List<Map<String, Object>> results = wecubeAdapterService.retrieveCiData(entityName, filter, sorting, select);
        return DataModelResponseDto.okWithData(results);
    }

    @PostMapping("/entities/{entity-name}/query")
    @ResponseBody
    public DataModelResponseDto<List<Map<String, Object>>> query(
            @PathVariable("entity-name") String entityName, @RequestBody QueryRequest queryRequest) {
        List<Map<String, Object>> results = wecubeAdapterService.getCiDataWithConditions(entityName, queryRequest);
        return DataModelResponseDto.okWithData(results);
    }

    @PostMapping("/entities/{entity-name}/update")
    @ResponseBody
    public DataModelResponseDto<List<Map<String, Object>>> update(
            @PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> ciDataList) {
        List<Map<String, Object>> results = wecubeAdapterService.batchUpdateCiData(entityName, ciDataList);
        return DataModelResponseDto.okWithData(results);
    }

    @PostMapping("/entities/{entity-name}/create")
    @ResponseBody
    public DataModelResponseDto<List<Map<String, Object>>> create(
            @PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> ciDataList) {
        List<Map<String, Object>> results = wecubeAdapterService.batchCreateCiData(entityName, ciDataList);
        return DataModelResponseDto.okWithData(results);
    }

    @PostMapping("/entities/{entity-name}/delete")
    @ResponseBody
    public DataModelResponseDto delete(
            @PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> ciDataList) {
        List<String> idList = ciDataList.stream()
                .map(ciData -> String.valueOf(ciData.get("id")))
                .collect(Collectors.toList());
        wecubeAdapterService.batchDeleteCiData(entityName, idList);
        return DataModelResponseDto.ok();
    }

    @ExceptionHandler
    public DataModelResponseDto handleException(Exception e, Locale locale) {
        String errorMessage = e instanceof CmdbException
                ? i18nMessageConverter.translateExceptionMessage((CmdbException) e, locale)
                : e.getMessage();
        return DataModelResponseDto.builder()
                .status(DataModelResponseDto.STATUS_ERROR)
                .message(errorMessage)
                .build();
    }
}
