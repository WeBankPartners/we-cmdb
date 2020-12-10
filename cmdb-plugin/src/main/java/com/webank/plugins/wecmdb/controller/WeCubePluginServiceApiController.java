package com.webank.plugins.wecmdb.controller;

import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.plugins.wecmdb.dto.wecube.*;
import com.webank.plugins.wecmdb.service.WecubeAdapterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;


@RestController
public class WeCubePluginServiceApiController {
    @Autowired
    private WecubeAdapterService wecubeAdapterService;

    @PostMapping("/entities/query")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> queryCiData(
            @RequestBody PluginRequestDto<CiDataQueryInputDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<CiDataQueryInputDto> inputs = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchQueryCiData(inputs);

        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (errorOccurred) {
            String errorMessage = String.format("Fail to query [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        } else {
            return PluginResponseDto.okayWithData(results);
        }
    }

    @PostMapping("/entities/create")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> createCiData(
            @RequestBody PluginRequestDto<CiDataInputDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<CiDataInputDto> inputs = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchCreateCiData(inputs);

        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (errorOccurred) {
            String errorMessage = String.format("Fail to create [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        } else {
            return PluginResponseDto.okayWithData(results);
        }
    }

    @PostMapping("/entities/update")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> updateCiData(
            @RequestBody(required = false) PluginRequestDto<CiDataInputDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<CiDataInputDto> inputs = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchUpdateCiData(inputs);

        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (errorOccurred) {
            String errorMessage = String.format("Fail to update [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        } else {
            return PluginResponseDto.okayWithData(results);
        }
    }

    @PostMapping("/entities/delete")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> deleteCiData(
            @RequestBody PluginRequestDto<OperateCiDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<OperateCiDto> inputs = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchDeleteCiData(inputs);

        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (!errorOccurred) {
            return PluginResponseDto.okayWithData(results);
        } else {
            String errorMessage = String.format("Fail to delete [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        }
    }

    @PostMapping("/data/confirm")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> confirmBatchCiData(
            @RequestBody PluginRequestDto<OperateCiDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<OperateCiDto> operateCiDtos = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchConfirmCiData(operateCiDtos);
        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (!errorOccurred) {
            return PluginResponseDto.okayWithData(results);
        } else {
            String errorMessage = String.format("Fail to confirm [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        }
    }

    @PostMapping("/data/update")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> updateCiDataAttributes(
            @RequestBody PluginRequestDto<OperateCiDataUpdateDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<OperateCiDataUpdateDto> operateCiDataUpdateDtos = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchPatchCiData(operateCiDataUpdateDtos);

        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (errorOccurred) {
            String errorMessage = String.format("Fail to update [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        } else {
            return PluginResponseDto.okayWithData(results);
        }
    }

    @PostMapping("/data/refresh")
    @ResponseBody
    public PluginResponseDto<Map<String, Object>> refreshBatchCiData(
            @RequestBody PluginRequestDto<OperateCiDto> pluginRequestDto) {
        assertValidInputs(pluginRequestDto);

        List<OperateCiDto> inputs = pluginRequestDto.getInputs();
        List<Map<String, Object>> results = wecubeAdapterService.batchRefreshCiData(inputs);

        boolean errorOccurred = results.stream().anyMatch(WecubeAdapterService::isErrorResult);
        if (errorOccurred) {
            String errorMessage = String.format("Fail to update [%s] CIs, detail error in the data block", pluginRequestDto);
            return PluginResponseDto.errorWithData(errorMessage, results);
        } else {
            return PluginResponseDto.okayWithData(results);
        }
    }

    private void assertValidInputs(@RequestBody PluginRequestDto pluginRequestDto) {
        if (pluginRequestDto == null || pluginRequestDto.getInputs() == null) {
            throw new InvalidArgumentException("Parameter \"inputs\" in request body should not be null");
        }
    }
}
