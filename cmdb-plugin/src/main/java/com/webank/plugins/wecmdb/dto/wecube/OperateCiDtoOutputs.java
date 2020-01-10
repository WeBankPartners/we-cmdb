package com.webank.plugins.wecmdb.dto.wecube;

import java.util.List;
import java.util.Map;

public class OperateCiDtoOutputs {
    private List<Map<String,Object>> outputs;

    public List<Map<String,Object>> getOutputs() {
        return outputs;
    }

    public void setOutputs(List<Map<String,Object>> outputs) {
        this.outputs = outputs;
    }

    @Override
    public String toString() {
        return "OperateCiDtoOutputs [outputs=" + outputs + "]";
    }
    
}
