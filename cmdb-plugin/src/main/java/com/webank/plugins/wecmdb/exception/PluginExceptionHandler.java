package com.webank.plugins.wecmdb.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import com.webank.plugins.wecmdb.dto.JsonResponse;

@ControllerAdvice
public class PluginExceptionHandler {
    private final static Logger logger = LoggerFactory.getLogger(PluginExceptionHandler.class);

    @ResponseBody
    @ExceptionHandler(Exception.class)
    public JsonResponse handleException(Exception ex) {
        logger.warn("Get exception:", ex);
        return JsonResponse.error(ex.getMessage());
    }

}
