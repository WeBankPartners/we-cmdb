package com.webank.cmdb.constant;

import java.util.LinkedList;
import java.util.List;

public enum LogOperation {
    CreationSuccess("Creation Success"), CreationFailure("Creation Failure"), ModificationSuccess("Modification Success"), ModificationFailure("Modification Failure"), RemovalSuccess("Removal Success"), RemovalFailure("Removal Failure"),
    ImplementationSuccess("Implementation Success"), ImplementationFailure("Implementation Failure"), None("none"),;

    private String code;

    private LogOperation(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public LogOperation fromCode(String code) {
        for (LogOperation logOperation : values()) {
            if (logOperation.getCode().equals(code)) {
                return logOperation;
            }
        }
        return None;
    }

    public static List<String> codes() {
        List<String> codes = new LinkedList<>();
        for (LogOperation logOperation : values()) {
            if (None.equals(logOperation))
                continue;
            codes.add(logOperation.getCode());
        }
        return codes;
    }
}
