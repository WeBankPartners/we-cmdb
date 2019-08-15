package com.webank.cmdb.config.log;

import static com.webank.cmdb.constant.LogOperation.CreationFailure;
import static com.webank.cmdb.constant.LogOperation.CreationSuccess;
import static com.webank.cmdb.constant.LogOperation.ImplementationFailure;
import static com.webank.cmdb.constant.LogOperation.ImplementationSuccess;
import static com.webank.cmdb.constant.LogOperation.ModificationFailure;
import static com.webank.cmdb.constant.LogOperation.ModificationSuccess;
import static com.webank.cmdb.constant.LogOperation.RemovalFailure;
import static com.webank.cmdb.constant.LogOperation.RemovalSuccess;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.webank.cmdb.constant.LogCategory;
import com.webank.cmdb.constant.LogOperation;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeAttrGroupDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrConditionDto;
import com.webank.cmdb.dto.RoleCiTypeCtrlAttrDto;
import com.webank.cmdb.dto.RoleCiTypeDto;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.dto.RoleMenuDto;
import com.webank.cmdb.dto.RoleUserDto;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.service.LogService;
import com.webank.cmdb.util.CmdbThreadLocal;

@Component
@Aspect
public class OperationLogAspect {

    private static final String LOG_CONTENT_FORMAT = "【%s】 %s";

    private static final Map<Class, LogCategory> classCategoryMap = new HashMap<>();

    static {
        classCategoryMap.put(RoleDto.class, LogCategory.PermissionManagement);
        classCategoryMap.put(RoleUserDto.class, LogCategory.PermissionManagement);
        classCategoryMap.put(RoleMenuDto.class, LogCategory.PermissionManagement);
        classCategoryMap.put(RoleCiTypeDto.class, LogCategory.PermissionManagement);
        classCategoryMap.put(RoleCiTypeCtrlAttrDto.class, LogCategory.PermissionManagement);
        classCategoryMap.put(RoleCiTypeCtrlAttrConditionDto.class, LogCategory.PermissionManagement);

        classCategoryMap.put(CatTypeDto.class, LogCategory.BaseDataManagement);
        classCategoryMap.put(CategoryDto.class, LogCategory.BaseDataManagement);
        classCategoryMap.put(CatCodeDto.class, LogCategory.BaseDataManagement);

        classCategoryMap.put(CiTypeDto.class, LogCategory.CiTypeManagement);
        classCategoryMap.put(CiTypeAttrDto.class, LogCategory.CiTypeManagement);
        classCategoryMap.put(CiTypeAttrGroupDto.class, LogCategory.CiTypeManagement);

        classCategoryMap.put(CiData.class, LogCategory.CiDataManagement);
    }

    @Autowired
    private LogService logService;

    @Pointcut("@annotation(com.webank.cmdb.config.log.OperationLogPointcut)")
    public void operationLogPointcut() {
    }

    @Around(value = "operationLogPointcut()")
    public Object operationLogAdvice(ProceedingJoinPoint pjp) throws Throwable {
        String user = CmdbThreadLocal.getIntance().getCurrentUser();
        MethodSignature methodSignature = (MethodSignature) pjp.getSignature();
        String method = methodSignature.getName();
        OperationLogPointcut annotation = methodSignature.getMethod().getAnnotation(OperationLogPointcut.class);
        Object[] args = pjp.getArgs();
        Object firstArgument = args.length > 0 ? args[0] : null;
        Class objectClass = deriveObjectClass(annotation, firstArgument);

        Integer ciTypeId = getCiTypeId(args, annotation);
        String ciTypeName = getCiTypeName(args, annotation);
        String ciGuid = getCiGuid(args, annotation);
        String ciName = getCiName(args, annotation);

        try {
            Object result = pjp.proceed();
            logService.log(logCategory(objectClass), user, successOps(annotation), logContent(objectClass, args, method), null, ciGuid, ciName, ciTypeId, ciTypeName);
            return result;
        } catch (Throwable throwable) {
            logService.log(logCategory(objectClass), user, failureOps(annotation), logContent(objectClass, args, method), errorMessage(throwable), ciGuid, ciName, ciTypeId, ciTypeName);
            throw throwable;
        }
    }

    private LogOperation successOps(OperationLogPointcut annotation) {
        return ops(annotation, true);
    }

    private LogOperation failureOps(OperationLogPointcut annotation) {
        return ops(annotation, false);
    }

    private LogOperation ops(OperationLogPointcut annotation, boolean success) {
        switch (annotation.operation()) {
        case Creation:
            return success ? CreationSuccess : CreationFailure;
        case Modification:
            return success ? ModificationSuccess : ModificationFailure;
        case Removal:
            return success ? RemovalSuccess : RemovalFailure;
        case Implementation:
            return success ? ImplementationSuccess : ImplementationFailure;
        }
        throw new CmdbException("Unsupported operation: " + annotation.operation());
    }

    private Class deriveObjectClass(OperationLogPointcut annotation, Object firstArgument) {
        if (annotation.objectClass() != Object.class) {
            return annotation.objectClass();
        }
        if (firstArgument == null) {
            throw new CmdbException("Object class is required for no argument methods.");
        }
        if (firstArgument instanceof Class) {
            return (Class) firstArgument;
        }
        return firstArgument.getClass();
    }

    private Object[] deriveDataArgument(Object[] args) {
        if (args.length == 0)
            return args;
        if (args[0] instanceof Class) {
            return Arrays.copyOfRange(args, 1, args.length);
        }
        return args;
    }

    private Integer getCiTypeId(Object[] args, OperationLogPointcut annotation) {
        return indexIntegerArguments(args, annotation.ciTypeIdArgumentIndex(), "ciTypeId");
    }

    private String getCiTypeName(Object[] args, OperationLogPointcut annotation) {
        return indexStringArguments(args, annotation.ciTypeNameArgumentIndex(), "name");
    }

    private String getCiGuid(Object[] args, OperationLogPointcut annotation) {
        return indexStringArguments(args, annotation.ciGuidArgumentIndex(), "guid");
    }

    private String getCiName(Object[] args, OperationLogPointcut annotation) {
        return indexStringArguments(args, annotation.ciNameArgumentIndex(), "key_name");
    }

    private String indexStringArguments(Object[] args, int index, String propertyName) {
        if (0 <= index && index < args.length) {
            Object arg = args[index];
            if (arg instanceof Map) {
                arg = ((Map) arg).get(propertyName);
            }
            return String.valueOf(arg);
        }
        return null;
    }

    private Integer indexIntegerArguments(Object[] args, int index, String propertyName) {
        if (0 <= index && index < args.length) {
            Object arg = args[index];
            if (arg instanceof Map) {
                arg = ((Map) arg).get(propertyName);
            }
            if (arg instanceof Integer) {
                return (Integer) arg;
            }
        }
        return null;
    }

    private LogCategory logCategory(Class objectClass) {
        LogCategory logCategory = classCategoryMap.get(objectClass);
        if (logCategory == null) {
            logCategory = LogCategory.Other;
        }
        return logCategory;
    }

    private String logContent(Class objectClass, Object[] arguments, String methodName) {
        String message;
        Object[] dataArguments = deriveDataArgument(arguments);
        if (dataArguments.length == 0) {
            message = methodName;
        } else if (dataArguments.length == 1) {
            message = String.valueOf(dataArguments[0]);
        } else {
            message = Arrays.toString(dataArguments);
        }
        return String.format(LOG_CONTENT_FORMAT, simplifyName(objectClass), message);
    }

    private String errorMessage(Throwable throwable) {
        if (throwable.getCause() != null) {
            return throwable.getMessage() + "\n" + errorMessage(throwable.getCause());
        } else {
            return throwable.getMessage();
        }
    }

    private String simplifyName(Object firstArgument) {
        String simplifiedName;
        if (firstArgument instanceof Class) {
            simplifiedName = ((Class) firstArgument).getSimpleName();
        } else {
            simplifiedName = String.valueOf(firstArgument);
        }
        if (simplifiedName.endsWith("Dto")) {
            simplifiedName = simplifiedName.substring(0, simplifiedName.length() - 3);
        }
        return simplifiedName;
    }
}
