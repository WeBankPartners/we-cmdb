package com.webank.plugins.wecmdb.service;

import com.webank.cmdb.support.exception.CmdbException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import sun.plugin2.message.Message;

import java.util.Locale;

@Service
public class I18nMessageConverter {
    private static final String MSG_ERR_CODE_PREFIX = "cmdb.core.msg.errorcode.";
    private static final Locale DEF_LOCALE = Locale.ENGLISH;

    @Autowired
    MessageSource messageSource;

    public String translateExceptionMessage(CmdbException e, Locale locale) {
        if (locale == null) {
            locale = DEF_LOCALE;
        }
        String errorCode = e.getErrorCode();
        if (StringUtils.isNoneBlank(errorCode)) {
            String msgCode = MSG_ERR_CODE_PREFIX + errorCode;
            return messageSource.getMessage(msgCode, e.getArgs(), locale);
        } else {
            return e.getMessage();
        }
    }
}
