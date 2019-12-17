package com.webank.plugins.wecmdb.dto;

import java.util.List;

public class PluginResponse<DATATYPE> extends JsonResponse {
    public static class DefaultResponse extends PluginResponse<Object> {
    }

    public static class IntegerResponse extends PluginResponse<Integer> {
    }

    public static class StringResponse extends PluginResponse<String> {
    }

    public static class ListDataResponse extends PluginResponse<List<?>> {
    }
}
