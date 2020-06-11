package com.webank.cmdb.constant;

import com.webank.cmdb.support.exception.ServiceException;

public enum FieldType {
    None("none", null), Varchar("varchar", String.class), Int("int", Integer.class), DateTime("datetime", java.util.Date.class), Date("date", java.util.Date.class);

    private String code;
    private Class<?> type;

    private FieldType(String code, Class<?> type) {
        this.code = code;
        this.type = type;
    }

    public String getCode() {
        return code;
    }

    public Class<?> getType() {
        return type;
    }

    static public FieldType fromCode(String code) {
        for (FieldType propertyType : values()) {
            if (None.equals(propertyType))
                continue;

            if (propertyType.getCode().equalsIgnoreCase(code)) {
                return propertyType;
            }
        }
        return None;
    }

    static public Class<?> getTypeFromCode(String code) {
        FieldType fieldType = fromCode(code);
        if (None.equals(fieldType)) {
            throw new ServiceException(String.format("Can not find out type for code [%s].", code));
        }
        return fieldType.getType();
    }
}
