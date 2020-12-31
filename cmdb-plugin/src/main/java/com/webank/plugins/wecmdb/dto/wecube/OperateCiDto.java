package com.webank.plugins.wecmdb.dto.wecube;

import lombok.Data;

@Data
public class OperateCiDto {
    private String callbackParameter;
    private String entityName;
    private String guid;

    @Override
    public String toString() {
        return "OperateCiDto [callbackParameter=" + callbackParameter + ", guid=" + guid + "]";
    }
}
