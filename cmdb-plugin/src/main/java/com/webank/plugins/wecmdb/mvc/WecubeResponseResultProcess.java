package com.webank.plugins.wecmdb.mvc;

import com.webank.cmdb.support.exception.CmdbException;
import com.webank.plugins.wecmdb.controller.WeCubePluginServiceApiController;
import com.webank.plugins.wecmdb.dto.wecube.PluginResponseDto;
import com.webank.plugins.wecmdb.service.I18nMessageConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.util.Locale;

@RestControllerAdvice(assignableTypes = WeCubePluginServiceApiController.class)
public class WeCubeResponseResultProcess implements ResponseBodyAdvice<Object> {
    private final static Logger logger = LoggerFactory.getLogger(WeCubeResponseResultProcess.class);
    private static final String SUCCESS = "Success";

    @Autowired
    private MessageSource messageSource;
    @Autowired
    private I18nMessageConverter i18nMessageConverter;

    @ResponseBody
    @ExceptionHandler(Exception.class)
    public PluginResponseDto handleException(final Exception ex, Locale locale) {
        logger.error("Get exception:", ex);
        if(ex instanceof CmdbException){
            CmdbException cmdbEx = (CmdbException)ex;
            String errorMsg = i18nMessageConverter.translateExceptionMessage(cmdbEx, locale);
            PluginResponseDto.error(errorMsg);
        }
        return PluginResponseDto.error(ex.getMessage());
    }

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        return body;
    }

}