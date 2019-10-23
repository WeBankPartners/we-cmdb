package com.webank.cmdb.controller.ui.helper;

public class BooleanUtils {

    public static final boolean isTrue(String value) {
        Boolean booleanObject = org.apache.commons.lang3.BooleanUtils.toBooleanObject(value);
        if (booleanObject == null) {
            return false;
        } else {
            return booleanObject.booleanValue();
        }
    }

    public static final <T> T derive(String condition, T trueResult, T failResult) {
        return (isTrue(condition)) ? trueResult : failResult;
    }
}
