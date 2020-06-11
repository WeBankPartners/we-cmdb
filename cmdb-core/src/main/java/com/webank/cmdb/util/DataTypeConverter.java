package com.webank.cmdb.util;

import com.webank.cmdb.support.exception.InvalidArgumentException;

public class DataTypeConverter {
    public static Integer convertToInteger(Object object) {
        if (object instanceof Boolean) {
            return ((Boolean) object) ? 1 : 0;
        }
        if (object instanceof Integer) {
            return (Integer) object;
        } else {
            throw new InvalidArgumentException(String.format("Can not convert to Integer for invalid input [%s]", object));
        }
    }
}
