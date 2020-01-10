package com.webank.plugins.wecmdb.dto.wecube;

import java.util.List;

public class OperateCiDtoInputs {
    private List<OperateCiDto> inputs;

    public List<OperateCiDto> getInputs() {
        return inputs;
    }

    public void setInputs(List<OperateCiDto> inputs) {
        this.inputs = inputs;
    }

    @Override
    public String toString() {
        return "OperateCiDtoInputs [inputs=" + inputs + "]";
    }
}
