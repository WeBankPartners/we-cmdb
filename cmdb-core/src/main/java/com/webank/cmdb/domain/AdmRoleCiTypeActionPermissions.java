package com.webank.cmdb.domain;

import com.webank.cmdb.support.exception.CmdbException;

public interface AdmRoleCiTypeActionPermissions {
    String ENABLED = "Y";

    String ACTION_CREATION = "Creation";
    String ACTION_REMOVAL = "Removal";
    String ACTION_MODIFICATION = "Modification";
    String ACTION_ENQUIRY = "Enquiry";
    String ACTION_EXECUTION = "Execution";
    String ACTION_GRANT = "Grant";

    String getCreationPermission();

    String getRemovalPermission();

    String getModificationPermission();

    String getEnquiryPermission();

    String getExecutionPermission();

    String getGrantPermission();

    default String getActionPermission(String action) {
        if (ACTION_CREATION.equalsIgnoreCase(action)) {
            return getCreationPermission();
        } else if (ACTION_REMOVAL.equalsIgnoreCase(action)) {
            return getRemovalPermission();
        } else if (ACTION_MODIFICATION.equalsIgnoreCase(action)) {
            return getModificationPermission();
        } else if (ACTION_ENQUIRY.equalsIgnoreCase(action)) {
            return getEnquiryPermission();
        } else if (ACTION_EXECUTION.equalsIgnoreCase(action)) {
            return getExecutionPermission();
        } else if (ACTION_GRANT.equalsIgnoreCase(action)) {
            return getGrantPermission();
        } else {
            throw new CmdbException("Unsupported action code: " + action);
        }
    }

    default boolean isActionPermissionEnabled(String action) {
        return ENABLED.equalsIgnoreCase(getActionPermission(action));
    }
}
