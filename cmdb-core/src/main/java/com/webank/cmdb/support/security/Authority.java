package com.webank.cmdb.support.security;

public interface Authority {

    enum Decision {
        ACCESS_GRANTED, ACCESS_DENIED;

        public boolean isAccessGranted() {
            return this == ACCESS_GRANTED;
        }

        public boolean isAccessDenied() {
            return this == ACCESS_DENIED;
        }
    }

    Decision authorize(String action, Object dataObject);

    boolean isCiTypePermitted(String action);

    String getName();

}
