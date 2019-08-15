package com.webank.cmdb.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class ResponseDto<T> {
    public final static String STATUS_OK = "OK";
    public final static String STATUS_ERROR = "ERROR";
    public final static String STATUS_ERROR_INVALID_ARGUMENT = "ERR_INVALID_ARGUMENT";
    public final static String STATUS_ERROR_INVALID_MESSAGE = "ERR_INVALID_MSG";
    public final static String STATUS_ERROR_BATCH_CHANGE = "ERR_BATCH_CHANGE";

    private String statusCode;
    private String statusMessage;
    private T data;

    public ResponseDto() {
    }

    public ResponseDto(String statusCode, T data) {
        this.statusCode = statusCode;
        this.data = data;
    }

    public ResponseDto(String statusCode, T data, String statusMessage) {
        this.statusCode = statusCode;
        this.statusMessage = statusMessage;
        this.data = data;
    }

    public String getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getStatusMessage() {
        return statusMessage;
    }

    public void setStatusMessage(String statusMessage) {
        this.statusMessage = statusMessage;
    }

}
