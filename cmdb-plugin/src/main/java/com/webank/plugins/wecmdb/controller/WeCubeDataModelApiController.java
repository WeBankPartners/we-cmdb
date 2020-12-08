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
        return DataModelResponseDto.<List<EntityDto>>builder()
                .status(DataModelResponseDto.STATUS_OK)
                .message(DataModelResponseDto.MESSAGE_SUCCESS)
                .data(dataModelEntities)
                .build();
    }

    @PostMapping("/entities/{entity-name}/query")
    @ResponseBody
    public DataModelResponseDto<List<Map<String, Object>>> query(
            @PathVariable("entity-name") String entityName, @RequestBody QueryRequest queryRequest) {
        List<Map<String, Object>> results = wecubeAdapterService.getCiDataWithConditions(entityName, queryRequest);
        return DataModelResponseDto.<List<Map<String, Object>>>builder()
                .status(DataModelResponseDto.STATUS_OK)
                .message(DataModelResponseDto.MESSAGE_SUCCESS)
                .data(results)
                .build();
    }

    @PostMapping("/entities/{entity-name}/update")
    @ResponseBody
    public DataModelResponseDto<List<Map<String, Object>>> update(
            @PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> ciDataList) {
        List<Map<String, Object>> results = wecubeAdapterService.batchUpdateCiData(entityName, ciDataList);
        return DataModelResponseDto.<List<Map<String, Object>>>builder()
                .status(DataModelResponseDto.STATUS_OK)
                .message(DataModelResponseDto.MESSAGE_SUCCESS)
                .data(results)
                .build();
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
