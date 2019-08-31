package com.webank.cmdb.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.webank.cmdb.exception.CmdbException;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@JsonInclude(Include.NON_EMPTY)
public abstract class CiTypePermissions<T, D> extends BasicResourceDto<T, D> {
    public static final String ENABLED = "Y";
    public static final String DISABLED = "N";
    public static final String PARTIAL = "P";

    public static final String ACTION_CREATION = "Creation";
    public static final String ACTION_REMOVAL = "Removal";
    public static final String ACTION_MODIFICATION = "Modification";
    public static final String ACTION_ENQUIRY = "Enquiry";
    public static final String ACTION_EXECUTION = "Execution";
    public static final String ACTION_GRANT = "Grant";

    private String creationPermission = DISABLED;
    private String removalPermission = DISABLED;
    private String modificationPermission = DISABLED;
    private String enquiryPermission = DISABLED;
    private String executionPermission = DISABLED;
    private String grantPermission = DISABLED;

    public void enableActionPermission(String action) {
        setActionPermission(action, ENABLED);
    }

    public void disableActionPermission(String action) {
        setActionPermission(action, DISABLED);
    }

    public void enablePartialActionPermission(String action) {
        setActionPermission(action, PARTIAL);
    }

    public boolean isActionPermissionEnabled(String action) {
        return ENABLED.equalsIgnoreCase(getActionPermission(action));
    }

    private void setActionPermission(String action, String value) {
        if (ACTION_CREATION.equalsIgnoreCase(action)) {
            creationPermission = value;
        } else if (ACTION_REMOVAL.equalsIgnoreCase(action)) {
            removalPermission = value;
        } else if (ACTION_MODIFICATION.equalsIgnoreCase(action)) {
            modificationPermission = value;
        } else if (ACTION_ENQUIRY.equalsIgnoreCase(action)) {
            enquiryPermission = value;
        } else if (ACTION_EXECUTION.equalsIgnoreCase(action)) {
            executionPermission = value;
        } else if (ACTION_GRANT.equalsIgnoreCase(action)) {
            grantPermission = value;
        } else {
            throw new CmdbException("Unsupported action code: " + action);
        }
    }

    private String getActionPermission(String action) {
        if (ACTION_CREATION.equalsIgnoreCase(action)) {
            return creationPermission;
        } else if (ACTION_REMOVAL.equalsIgnoreCase(action)) {
            return removalPermission;
        } else if (ACTION_MODIFICATION.equalsIgnoreCase(action)) {
            return modificationPermission;
        } else if (ACTION_ENQUIRY.equalsIgnoreCase(action)) {
            return enquiryPermission;
        } else if (ACTION_EXECUTION.equalsIgnoreCase(action)) {
            return executionPermission;
        } else if (ACTION_GRANT.equalsIgnoreCase(action)) {
            return grantPermission;
        } else {
            throw new CmdbException("Unsupported action code: " + action);
        }
    }

}
