package com.webank.plugins.wecmdb.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.util.BeanMapUtils;
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
import com.webank.plugins.wecmdb.dto.wecube.EntityDto;
import com.webank.plugins.wecmdb.dto.wecube.OperateCiDto;
import com.webank.plugins.wecmdb.dto.wecube.OperateCiDtoInputs;
import com.webank.plugins.wecmdb.dto.wecube.OperateCiJsonResponse;
import com.webank.plugins.wecmdb.service.WecubeAdapterService;

import javax.servlet.http.HttpServletRequest;


@RestController
public class WecubeAdapterController {

    @Autowired
    private WecubeAdapterService wecubeAdapterService;
    @Autowired
    private HttpServletRequest request;


    @PostMapping("/entities")
    @ResponseBody
    public Object retrieveCiDataSend(@RequestParam(value = "entity-name") String entityName,@RequestBody QueryRequest queryObject) throws Exception {
        StringBuffer url=request.getRequestURL().append("/").append(entityName);
        Map<String, Object> paramMap = BeanMapUtils.convertBeanToMap(queryObject);
        try {
            return HttpUtils.post(paramMap, url.toString());
        } catch (IOException e) {
            throw new Exception(e.getMessage());
        }
    }

    @PostMapping("/entities/{entity-name}")
    @ResponseBody
    public Object retrieveCiData(@PathVariable(value = "entity-name") String entityName,@RequestBody QueryRequest queryObject) {
        return wecubeAdapterService.getCiDataWithConditions(entityName, queryObject);
    }

    @PostMapping("/entities/{entity-name}/create")
    public List<Map<String, Object>> createCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return wecubeAdapterService.createCiData(entityName, request);
    }


    @PostMapping("/entities/create")
    @ResponseBody
    public Object createCiDataSend(@RequestParam(value = "entity-name") String entityName, @RequestBody List<Map<String, Object>> cidata) {
        StringBuffer url=request.getRequestURL().append("/entities").append("/").append(entityName).append("/create");
        Map<String, Object> paramMap = BeanMapUtils.convertBeanToMap(cidata);
        try {
            return HttpUtils.post(paramMap, url.toString());
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/entities/{entity-name}/update")
    public List<Map<String, Object>> updateCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        return wecubeAdapterService.updateCiData(entityName, request);
    }



    @PostMapping("/entities/update")
    @ResponseBody
    public Object updateCiDataSend(@RequestParam(value = "entity-name") String entityName, @RequestBody List<Map<String, Object>> cidata) {
        StringBuffer url=request.getRequestURL().append("/entities").append("/").append(entityName).append("/update");
        Map<String, Object> paramMap = BeanMapUtils.convertBeanToMap(cidata);
        try {
            return HttpUtils.post(paramMap, url.toString());
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping("/entities/{entity-name}/delete")
    public void deleteCiData(@PathVariable("entity-name") String entityName, @RequestBody List<Map<String, Object>> request) {
        wecubeAdapterService.deleteCiData(entityName, request);
    }

    @PostMapping("/entities/delete")
    @ResponseBody
    public Object deleteCiDataSend(@RequestParam(value = "entity-name") String entityName, @RequestBody List<Map<String, Object>> cidata) {
        StringBuffer url=request.getRequestURL().append("/entities").append("/").append(entityName).append("/delete");
        Map<String, Object> paramMap = BeanMapUtils.convertBeanToMap(cidata);
        try {
            return HttpUtils.post(paramMap, url.toString());
        } catch (IOException e) {
            e.printStackTrace();
            return null;
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
}