package com.webank.plugins.wecmdb.controller;

import java.util.ArrayList;
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

import com.webank.cmdb.exception.BatchChangeException.ExceptionHolder;
import com.webank.plugins.wecmdb.dto.wecube.EntityDto;
import com.webank.plugins.wecmdb.dto.wecube.OperateCiDto;
import com.webank.plugins.wecmdb.dto.wecube.OperateCiDtoInputs;
import com.webank.plugins.wecmdb.dto.wecube.OperateCiJsonResponse;
import com.webank.plugins.wecmdb.service.WecubeAdapterService;

@RestController
public class WecubeAdapterController {

    @Autowired
    private WecubeAdapterService wecubeAdapterService;

    @GetMapping("/entities/{entity-name}")
    @ResponseBody
    public Object retrieveCiData(@PathVariable(value = "entity-name") String entityName,
            @RequestParam(value = "filter", required = false) String filter,
            @RequestParam(value = "sorting", required = false) String sorting,
            @RequestParam(value = "select", required = false) String select) {
        return wecubeAdapterService.getCiDataWithConditions(entityName, filter, sorting, select);
    }

    @PostMapping("/entities/{entity-name}/create")
    public List<Map<String, Object>> createCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return wecubeAdapterService.createCiData(entityName, request);
    }

    @PostMapping("/entities/{entity-name}/update")
    public List<Map<String, Object>> updateCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return wecubeAdapterService.updateCiData(entityName, request);
    }

    @PostMapping("/entities/{entity-name}/delete")
    public void deleteCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        wecubeAdapterService.deleteCiData(entityName, request);
    }

    @PostMapping("/data/confirm")
    @ResponseBody
    public OperateCiJsonResponse confirmBatchCiData(@RequestBody OperateCiDtoInputs inputs) {
        List<OperateCiDto> operateCiDtos = inputs.getInputs();
        OperateCiJsonResponse response = new OperateCiJsonResponse();
        List<ExceptionHolder> ExceptionHolders = new ArrayList<ExceptionHolder>();
        List<Map<String, Object>> results = wecubeAdapterService.confirmBatchCiData(operateCiDtos, ExceptionHolders);

        if (ExceptionHolders.size() > 0) {
            response = OperateCiJsonResponse.errorWithData(String.format("Fail to confirm [%s] CIs, detail error in the data block", inputs), results);
        } else {
            response = OperateCiJsonResponse.okayWithData(results);
        }

        return response;

    }

    @GetMapping("/data-model")
    @ResponseBody
    public List<EntityDto> getDataModel() {
        return wecubeAdapterService.getDataModel();
    }
}