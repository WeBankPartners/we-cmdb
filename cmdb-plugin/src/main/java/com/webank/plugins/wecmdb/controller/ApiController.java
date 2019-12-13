package com.webank.plugins.wecmdb.controller;

import static com.webank.plugins.wecmdb.dto.JsonResponse.okay;
import static com.webank.plugins.wecmdb.dto.JsonResponse.okayWithData;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.plugins.wecmdb.dto.JsonResponse;
import com.webank.plugins.wecmdb.dto.OperateCiDto;
import com.webank.plugins.wecmdb.dto.OperateCiDtoInputs;
import com.webank.plugins.wecmdb.dto.OperateCiJsonResponse;
import com.webank.plugins.wecmdb.service.AdapterService;

@RestController
public class ApiController {

    @Autowired
    private AdapterService adapterService;

    @GetMapping("/entities/{entity-name}")
    @ResponseBody
    public JsonResponse retrieveCiData(@PathVariable(value = "entity-name") String entityName,
            @RequestParam(value = "filter", required = false) String filter,
            @RequestParam(value = "sorting", required = false) String sorting,
            @RequestParam(value = "select", required = false) String select) {
        return okayWithData(adapterService.getCiDataWithConditions(entityName, filter, sorting, select));
    }

    @PostMapping("/entities/{entity-name}/create")
    public JsonResponse createCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return okayWithData(adapterService.createCiData(entityName, request));
    }

    @PostMapping("/entities/{entity-name}/update")
    public JsonResponse updateCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return okayWithData(adapterService.updateCiData(entityName, request));
    }

    @PostMapping("/entities/{entity-name}/delete")
    public JsonResponse deleteCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        adapterService.deleteCiData(entityName, request);
        return okay();
    }

    @PostMapping("/data/confirm")
    @ResponseBody
    public OperateCiJsonResponse confirmBatchCiData(@RequestBody OperateCiDtoInputs inputs) {
        List<OperateCiDto> operateCiDtos = inputs.getInputs();
        OperateCiJsonResponse response = null;
        try {
            response = OperateCiJsonResponse.okayWithData(adapterService.confirmBatchCiData(operateCiDtos));
        } catch (Exception e) {
            response = OperateCiJsonResponse.error(String.format("Failed to confirm CI with request[%s], error [%s] ", inputs, e.getMessage()));
        }

        return response;
    }

    @GetMapping("/data-model")
    @ResponseBody
    public JsonResponse getDataModel() {
        return okayWithData(adapterService.getDataModel());
    }
}