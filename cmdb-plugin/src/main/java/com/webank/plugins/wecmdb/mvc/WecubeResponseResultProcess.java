package com.webank.plugins.wecmdb.mvc;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
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
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.plugins.wecmdb.dto.wecube.WecubeResponse;

@ControllerAdvice(assignableTypes = com.webank.plugins.wecmdb.controller.WecubeAdapterController.class)
public class WecubeResponseResultProcess implements ResponseBodyAdvice<Object> {
    private final static Logger logger = LoggerFactory.getLogger(WecubeResponseResultProcess.class);
    private static final String SUCCESS = "Success";
    
    public static final String MSG_ERR_CODE_PREFIX = "cmdb.core.msg.errorcode.";

    public static final Locale DEF_LOCALE = Locale.ENGLISH;

    @Autowired
    private MessageSource messageSource;

    @ResponseBody
    @ExceptionHandler(Exception.class)
    public WecubeResponse handleException(HttpServletRequest request, final Exception ex,
            HttpServletResponse response) {
        logger.warn("Get exception:", ex);
        if(ex instanceof CmdbException){
            CmdbException cmdbEx = (CmdbException)ex;
            String errorMsg = determineI18nErrorMessage(request, cmdbEx);
            WecubeResponse.error(errorMsg);
        }
        return WecubeResponse.error(ex.getMessage());
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
            return WecubeResponse.okayWithData(body);
        }
    }
    
    private String determineI18nErrorMessage(HttpServletRequest request, CmdbException e) {
        Locale locale = request.getLocale();
        if (locale == null) {
            locale = DEF_LOCALE;
        }
        if (StringUtils.isNoneBlank(e.getErrorCode())) {
            String msgCode = MSG_ERR_CODE_PREFIX + e.getErrorCode();
            String msg = messageSource.getMessage(msgCode, e.getArgs(), locale);
            return msg;
        } else {
            return e.getMessage();
        }
    }
}