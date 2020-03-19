package com.webank.plugins.wecmdb.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.util.BeanMapUtils;
import com.webank.plugins.wecmdb.dto.wecube.*;
import com.webank.plugins.wecmdb.helper.HttpUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.webank.cmdb.exception.BatchChangeException.ExceptionHolder;
import com.webank.plugins.wecmdb.service.WecubeAdapterService;

import javax.servlet.http.HttpServletRequest;


@RestController
public class WecubeAdapterController {

    @Autowired
    private WecubeAdapterService wecubeAdapterService;
    @Autowired
    private HttpServletRequest request;
    
    @GetMapping("/entities/{entity-name}")
    @ResponseBody
    public Object retrieveCiData(@PathVariable(value = "entity-name") String entityName,
                                 @RequestParam(value = "filter", required = false) String filter,
                                 @RequestParam(value = "sorting", required = false) String sorting,
                                 @RequestParam(value = "select", required = false) String select) {
        com.webank.cmdb.dto.QueryRequest queryRequest = com.webank.cmdb.dto.QueryRequest.defaultQueryObject();
        return wecubeAdapterService.retrieveCiData(entityName, filter, sorting, select);
    }
    @PostMapping("/entities")
    @ResponseBody
    public OperateCiJsonResponse retrieveCiDataSend(@RequestParam(value = "entity-name") String entityName,@RequestBody QueryRequest queryObject) {
        StringBuffer url=request.getRequestURL().append("/").append(entityName);
        return getCiDataResponse(url, BeanMapUtils.convertBeanToMap(queryObject));
    }

    @PostMapping("/entities/{entity-name}/query")
    @ResponseBody
    public List<Map<String, Object>> retrieveCiData(@PathVariable(value = "entity-name") String entityName,@RequestBody QueryRequest queryObject) {
        return wecubeAdapterService.getCiDataWithConditions(entityName, queryObject);
    }

    @PostMapping("/entities/{entity-name}/create")
    public List<Map<String, Object>> createCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return wecubeAdapterService.createCiData(entityName, request);
    }

    @PostMapping("/entities/create")
    @ResponseBody
    public OperateCiJsonResponse createCiDataSend(@RequestParam(value = "entity-name") String entityName, @RequestBody List<Map<String, Object>> cidata) {
        StringBuffer url=request.getRequestURL().append("/entities").append("/").append(entityName).append("/create");
        return getCiDataResponse(url, BeanMapUtils.convertBeanToMap(cidata));
    }

    @PostMapping("/entities/{entity-name}/update")
    public List<Map<String, Object>> updateCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return wecubeAdapterService.updateCiData(entityName, request);
    }

    @PostMapping("/entities/update")
    @ResponseBody
    public OperateCiJsonResponse updateCiDataSend(@RequestParam(value = "entity-name") String entityName, @RequestBody List<Map<String, Object>> cidata) {
        StringBuffer url=request.getRequestURL().append("/entities").append("/").append(entityName).append("/update");
        return getCiDataResponse(url, BeanMapUtils.convertBeanToMap(cidata));
    }

    @PostMapping("/entities/{entity-name}/delete")
    public void deleteCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        wecubeAdapterService.deleteCiData(entityName, request);
    }

    @PostMapping("/entities/delete")
    @ResponseBody
    public void deleteCiDataSend(@RequestParam(value = "entity-name") String entityName, @RequestBody List<Map<String, Object>> cidata) {
        StringBuffer url=request.getRequestURL().append("/entities").append("/").append(entityName).append("/delete");
        Map<String, Object> paramMap = BeanMapUtils.convertBeanToMap(cidata);
        try {
            HttpUtils.post(paramMap, url.toString());
        } catch (IOException e) {
            throw new CmdbException(e.getMessage());
        }
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

    private OperateCiJsonResponse getCiDataResponse(StringBuffer url, Map<String, Object> stringObjectMap) {
        OperateCiJsonResponse response = new OperateCiJsonResponse();
        try {
            String results = HttpUtils.post(stringObjectMap, url.toString());
            List<Map<String, Object>> listObjectSec = JSONArray.parseObject(results, List.class);
            response = OperateCiJsonResponse.okayWithData(listObjectSec);
        } catch (IOException e) {
            response = OperateCiJsonResponse.errorWithData(e.getMessage(), null);
        }
        return response;
    }
}