package com.webank.plugins.wecmdb.dto.inhouse;

public enum Action {
    NONE("none"), SELECT("select");

    private String code;

    private Action(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    static public Action fromCode(String code) {
        for (Action value : values()) {
            if (NONE.equals(value))
                continue;

            if (value.getCode().equals(code)) {
                return value;
            }
        }
        return NONE;
    }
}
