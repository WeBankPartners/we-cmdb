package com.webank.cmdb.dto;

import java.util.HashMap;

import org.apache.commons.beanutils.BeanMap;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class CiBean extends HashMap {
    private static final long serialVersionUID = 1L;

    public CiBean(Object ciObj) {
        super(new BeanMap(ciObj));
    }
}
