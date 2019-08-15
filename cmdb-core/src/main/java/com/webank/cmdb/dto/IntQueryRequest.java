package com.webank.cmdb.dto;

import java.util.List;

public class IntQueryRequest extends QueryRequest {
    private List<String> resultColumns;

    public List<String> getResultColumns() {
        return resultColumns;
    }

    public void setResultColumns(List<String> resultColumns) {
        this.resultColumns = resultColumns;
    }

}
