package com.webank.cmdb.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_EMPTY)
public class AutoFillIntegrationQueryExDto extends IntegrationQueryExDto {
    private String enumCodeAttr;

    public String getEnumCodeAttr() {
        return enumCodeAttr;
    }

    public void setEnumCodeAttr(String enumCodeAttr) {
        this.enumCodeAttr = enumCodeAttr;
    }
}
