package com.webank.cmdb.constant;

public enum ReferRelationship {
    None(-1), ReferencedBy(0), ReferenceTo(1);

    private int code;

    private ReferRelationship(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    static public ReferRelationship fromCode(int code) {
        for (ReferRelationship relationship : values()) {
            if (None.equals(relationship))
                continue;

            if (relationship.getCode() == code) {
                return relationship;
            }
        }
        return None;
    }
}
