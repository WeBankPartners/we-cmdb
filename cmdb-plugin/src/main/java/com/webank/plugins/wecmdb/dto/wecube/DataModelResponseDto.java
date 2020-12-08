package com.webank.plugins.wecmdb.dto.wecube;

import com.webank.cmdb.dto.CustomResponseDto;
import lombok.*;

import java.util.List;

@Data
@Builder
public class DataModelResponseDto<TData> implements CustomResponseDto {
    public final static String STATUS_OK = "OK";
    public final static String STATUS_ERROR = "ERROR";
    public final static String MESSAGE_SUCCESS = "Success";

    String status;
    String message;
    TData data;
}
