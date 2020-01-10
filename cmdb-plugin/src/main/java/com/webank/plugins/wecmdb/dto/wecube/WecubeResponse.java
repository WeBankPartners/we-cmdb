package com.webank.plugins.wecmdb.dto.wecube;

import com.webank.cmdb.dto.CustomResponseDto;

public class WecubeResponse implements CustomResponseDto{
    public final static String STATUS_OK = "OK";
    public final static String STATUS_ERROR = "ERROR";

    private String status;
    private String message;
    private Object data;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public WecubeResponse withData(Object data) {
        this.data = data;
        return this;
    }

    public static WecubeResponse okay() {
        WecubeResponse result = new WecubeResponse();
        result.setStatus(STATUS_OK);
        result.setMessage("Success");
        return result;
    }

    public static WecubeResponse okayWithData(Object data) {
        return okay().withData(data);
    }

    public static WecubeResponse error(String errorMessage) {
        WecubeResponse result = new WecubeResponse();
        result.setStatus(STATUS_ERROR);
        result.setMessage(errorMessage);
        return result;
    }
}
