package com.webank.cmdb.controller.browser.helper;

import java.util.HashMap;

import org.apache.commons.beanutils.BeanMap;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class CiDataDto extends HashMap {
    private static final long serialVersionUID = 1L;

    public CiDataDto(Object ciObj) {
        super(new BeanMap(ciObj));
    }
}