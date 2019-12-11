package com.webank.plugins.wecmdb.dto;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

public class OperateCiJsonResponse{
    public final static String STATUS_OK = "0";
    public final static String STATUS_ERROR = "1";

    @JsonProperty(value = "result_code")
    private String resultCode;
    @JsonProperty(value = "result_message")
    private String resultMessage;
    @JsonProperty(value = "results")
    private OperateCiDtoOutputs results;

    public String getResultCode() {
        return resultCode;
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public String getResultMessage() {
        return resultMessage;
    }

    public void setResultMessage(String resultMessage) {
        this.resultMessage = resultMessage;
    }

    public Object getResults() {
        return results;
    }

    public void setResults(List<Map<String,Object>> data) {
        OperateCiDtoOutputs outputs = new OperateCiDtoOutputs();
        outputs.setOutputs(data);
        this.results = outputs;
    }

    public OperateCiJsonResponse withData(List<Map<String,Object>> data) {
        setResults(data);
        return this;
    }

    public static OperateCiJsonResponse okay() {
        OperateCiJsonResponse result = new OperateCiJsonResponse();
        result.setResultCode(STATUS_OK);
        result.setResultMessage("Success");
        return result;
    }

    public static OperateCiJsonResponse okayWithData(List<Map<String,Object>> data) {
        return okay().withData(data);
    }

    public static OperateCiJsonResponse error(String errorMessage) {
        OperateCiJsonResponse result = new OperateCiJsonResponse();
        result.setResultCode(STATUS_ERROR);
        result.setResultMessage(errorMessage);
        return result;
    }
}
