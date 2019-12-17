package com.webank.plugins.wecmdb.mvc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import com.webank.cmdb.dto.CustomResponseDto;
import com.webank.plugins.wecmdb.dto.JsonResponse;

@ControllerAdvice(basePackages = {"com.webank.plugins.wecmdb.controller"})
public class PluginResponseResultProcess implements ResponseBodyAdvice<Object> {
    private final static Logger logger = LoggerFactory.getLogger(PluginResponseResultProcess.class);
    private static final String SUCCESS = "Success";

    @ResponseBody
    @ExceptionHandler(Exception.class)
    public JsonResponse handleException(Exception ex) {
        logger.warn("Get exception:", ex);
        return JsonResponse.error(ex.getMessage());
    }

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        if (body instanceof CustomResponseDto) {
            return body;
        } else {
            if (body == null) {
                body = SUCCESS;
            }
            return JsonResponse.okayWithData(body);
        }
    }
}