package com.webank.cmdb.constant;

import java.util.LinkedList;
import java.util.List;

public enum LogCategory {
    PermissionManagement("Permission Management"), BaseDataManagement("Base Data Management"), CiTypeManagement("CI Type Management"), CiDataManagement("CI Data Management"), Other("Other");

    private String code;

    private LogCategory(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public LogCategory fromCode(String code) {
        for (LogCategory logCategory : values()) {
            if (logCategory.getCode().equals(code)) {
                return logCategory;
            }
        }
        return Other;
    }

    public static List<String> codes() {
        List<String> codes = new LinkedList<>();
        for (LogCategory logCategory : values()) {
            if (Other.equals(logCategory))
                continue;
            codes.add(logCategory.getCode());
        }
        return codes;
    }
}
