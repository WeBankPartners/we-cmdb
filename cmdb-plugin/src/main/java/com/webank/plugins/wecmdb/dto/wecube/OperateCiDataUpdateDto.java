package com.webank.plugins.wecmdb.dto.wecube;

import lombok.Data;

@Data
public class OperateCiDataUpdateDto {
    private String callbackParameter;
    private String entityName;
    private String guid;
    private String attrName;
    private Object attrVal;
}
