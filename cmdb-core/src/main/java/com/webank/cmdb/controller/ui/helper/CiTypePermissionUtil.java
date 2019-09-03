package com.webank.cmdb.controller.ui.helper;

import static com.webank.cmdb.dto.CiTypePermissions.ACTION_CREATION;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_ENQUIRY;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_EXECUTION;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_GRANT;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_MODIFICATION;
import static com.webank.cmdb.dto.CiTypePermissions.ACTION_REMOVAL;
import static org.apache.commons.collections4.CollectionUtils.isNotEmpty;

import java.util.List;

import com.webank.cmdb.dto.RoleCiTypeCtrlAttrDto;
import com.webank.cmdb.dto.RoleCiTypeDto;

public class CiTypePermissionUtil {

    public static void mergeActionPermissions(RoleCiTypeDto roleCiType, RoleCiTypeDto additionalRoleCiType) {
        roleCiType.getRoleCiTypeCtrlAttrs().addAll(additionalRoleCiType.getRoleCiTypeCtrlAttrs());

        mergeActionPermission(roleCiType, additionalRoleCiType, ACTION_CREATION);
        mergeActionPermission(roleCiType, additionalRoleCiType, ACTION_REMOVAL);
        mergeActionPermission(roleCiType, additionalRoleCiType, ACTION_MODIFICATION);
        mergeActionPermission(roleCiType, additionalRoleCiType, ACTION_ENQUIRY);
        mergeActionPermission(roleCiType, additionalRoleCiType, ACTION_EXECUTION);
        mergeActionPermission(roleCiType, additionalRoleCiType, ACTION_GRANT);
    }

    private static void mergeActionPermission(RoleCiTypeDto roleCiType, RoleCiTypeDto additionalRoleCiType, String action) {
        if (roleCiType.isActionPermissionEnabled(action))
            return;

        if (additionalRoleCiType.isActionPermissionEnabled(action)) {
            roleCiType.enableActionPermission(action);
        }
    }

    public static void evaluatePartialActionPermissions(List<RoleCiTypeDto> roleCiTypes) {
        for (RoleCiTypeDto roleCiType : roleCiTypes) {
            evaluatePartialActionPermission(roleCiType, ACTION_CREATION);
            evaluatePartialActionPermission(roleCiType, ACTION_REMOVAL);
            evaluatePartialActionPermission(roleCiType, ACTION_MODIFICATION);
            evaluatePartialActionPermission(roleCiType, ACTION_ENQUIRY);
            evaluatePartialActionPermission(roleCiType, ACTION_EXECUTION);
            evaluatePartialActionPermission(roleCiType, ACTION_GRANT);
        }
    }

    private static void evaluatePartialActionPermission(RoleCiTypeDto permission, String action) {
        if (permission.isActionPermissionEnabled(action))
            return;

        if (isCtrlAttributeActionPermissionEnabled(permission, action)) {
            permission.enablePartialActionPermission(action);
        }
    }

    private static boolean isCtrlAttributeActionPermissionEnabled(RoleCiTypeDto permission, String action) {
        if (isNotEmpty(permission.getRoleCiTypeCtrlAttrs())) {
            for (RoleCiTypeCtrlAttrDto ctrlAttrDto : permission.getRoleCiTypeCtrlAttrs()) {
                if (ctrlAttrDto.isActionPermissionEnabled(action))
                    return true;
            }
        }
        return false;
    }

}
