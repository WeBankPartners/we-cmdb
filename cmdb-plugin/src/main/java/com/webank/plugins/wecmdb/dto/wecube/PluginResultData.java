package com.webank.plugins.wecmdb.dto.wecube;

import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Value
@Builder
public class PluginResultData<TOutputData> {
    @Builder.Default
    List<TOutputData> outputs = new ArrayList<>();
}
