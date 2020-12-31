package com.webank.plugins.wecmdb.dto.wecube;

import com.webank.cmdb.dto.CustomResponseDto;
import lombok.*;

import java.util.Collections;
import java.util.List;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
@AllArgsConstructor
@Builder
public class PluginResponseDto<TOutputData> implements CustomResponseDto {
    public final static String STATUS_OK = "0";
    public final static String STATUS_ERROR = "1";
    public static final String SUCCESS_RESULT_MSG = "Success";

    String resultCode;
    String resultMessage;
    @Builder.Default
    PluginResultData<TOutputData> results = new PluginResultData<>(Collections.emptyList());

    public static <TResult> PluginResponseDto<TResult> okay() {
        return PluginResponseDto.<TResult>builder()
                .resultCode(STATUS_OK)
                .resultMessage(SUCCESS_RESULT_MSG)
                .build();
    }

    public static <TResult> PluginResponseDto<TResult> okayWithData(List<TResult> data) {
        return PluginResponseDto.<TResult>builder()
                .resultCode(STATUS_OK)
                .resultMessage(SUCCESS_RESULT_MSG)
                .results(PluginResultData.<TResult>builder().outputs(data).build())
                .build();
    }

    public static <TResult> PluginResponseDto<TResult> error(String errorMessage) {
        return PluginResponseDto.<TResult>builder()
                .resultCode(STATUS_ERROR)
                .resultMessage(errorMessage)
                .build();
    }

    public static <TResult> PluginResponseDto<TResult> errorWithData(String errorMessage, List<TResult> results) {
        return PluginResponseDto.<TResult>builder()
                .resultCode(STATUS_ERROR)
                .resultMessage(errorMessage)
                .results(PluginResultData.<TResult>builder().outputs(results).build())
                .build();
    }
}
