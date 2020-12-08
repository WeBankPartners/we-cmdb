package com.webank.plugins.wecmdb.dto.wecube;

import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Value
@NoArgsConstructor(force = true, access = AccessLevel.PRIVATE)
@AllArgsConstructor
@Builder
public class PluginRequestDto<TInputData> {
    String requestId;
    String dueDate;
    List<String> allowedOptions;
    List<TInputData> inputs;
}
