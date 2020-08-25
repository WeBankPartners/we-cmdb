package com.webank.cmdb.dynamicEntity;

import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.support.exception.ServiceException;

public class DynamicEntityUtils {
    public static String getEntityQuanlifiedName(String tableName) {
        return "dynamic.entity." + tableName;
    }

    // TODO: remove replacing '.' to '/'
    public static String getClassByCodeName(String quanlifiedClass) {
        String classDesc = quanlifiedClass.replace('.', '/');
        String className = classDesc.substring(classDesc.lastIndexOf('/') + 1);
        return className;
    }

    public static String getClassDesc(String qualifiedClass) {
        return "L" + qualifiedClass.replace('.', '/') + ";";
    }

    public static String getJoinFieldName(AdmCiType ownCiType, AdmCiTypeAttr attr, boolean isReferTo) {
        if (attr.getInputType().equals(InputType.Reference.getCode())) {
            if (ownCiType.getIdAdmCiType().equals(attr.getCiTypeId())) {// citype may have attribute refer to itself
                if (isReferTo) {
                    return attr.getAdmCiType().getTableName() + "_" + attr.getPropertyName();
                } else {
                    return attr.getAdmCiType().getTableName() + "$" + attr.getPropertyName();
                }
            } else if (ownCiType.getIdAdmCiType().equals(attr.getReferenceId())) {// own ci type is referenced by attr
                return attr.getAdmCiType().getTableName() + "$" + attr.getPropertyName();
            } else {
                throw new ServiceException(String.format("There is no relationship between citype [%d] and ci type attr [%d]", ownCiType.getIdAdmCiType(), attr.getIdAdmCiTypeAttr()))
                .withErrorCode("3106", ownCiType.getIdAdmCiType(), attr.getIdAdmCiTypeAttr());
            }
        } else if (attr.getInputType().equals(InputType.MultRef.getCode())) {
            if (attr.getCiTypeId().equals(ownCiType.getIdAdmCiType())) {
                return attr.getPropertyName();
            } else if (ownCiType.getIdAdmCiType().equals(attr.getReferenceId())) {// own ci type is referenced by attr
                return attr.getAdmCiType().getTableName() + "$" + attr.getPropertyName();
            } else {
                throw new ServiceException(String.format("There is no relationship between citype [%d] and ci type attr [%d]", ownCiType.getIdAdmCiType(), attr.getIdAdmCiTypeAttr()))
                .withErrorCode("3106", ownCiType.getIdAdmCiType(), attr.getIdAdmCiTypeAttr());
            }
        } else {// multiReference & multiSelection
            if (attr.getCiTypeId().equals(ownCiType.getIdAdmCiType())) {
                return attr.getPropertyName();
            } else {
                throw new ServiceException(String.format("There is no relationship between citype [%d] and ci type attr [%d]", ownCiType.getIdAdmCiType(), attr.getIdAdmCiTypeAttr()))
                .withErrorCode("3106", ownCiType.getIdAdmCiType(), attr.getIdAdmCiTypeAttr());
            }

        }
    }

    public static String getJoinMapperByFieldName(AdmCiTypeAttr attr) {
        if (InputType.MultRef.getCode().equals(attr.getInputType())) {
            return attr.getPropertyName();
        } else {
            return getJoinMapperByFieldName(attr.getAdmCiType().getTableName(), attr.getPropertyName());
        }
    }

    public static String getJoinMapperByFieldName(String tableName, String propertyName) {
        return tableName + "_" + propertyName;
    }

}
