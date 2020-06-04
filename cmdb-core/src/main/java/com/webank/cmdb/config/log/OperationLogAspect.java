package com.webank.cmdb.config.log;

import static com.webank.cmdb.constant.LogOperation.CreationFailure;
import static com.webank.cmdb.constant.LogOperation.CreationSuccess;
import static com.webank.cmdb.constant.LogOperation.ImplementationFailure;
import static com.webank.cmdb.constant.LogOperation.ImplementationSuccess;
import static com.webank.cmdb.constant.LogOperation.ModificationFailure;
import static com.webank.cmdb.constant.LogOperation.ModificationSuccess;
import static com.webank.cmdb.constant.LogOperation.RemovalFailure;
import static com.webank.cmdb.constant.LogOperation.RemovalSuccess;

import java.lang.annotation.Annotation;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.dto.*;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.service.CiService;
import org.apache.logging.log4j.util.Strings;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.webank.cmdb.constant.LogCategory;
import com.webank.cmdb.constant.LogOperation;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.service.LogService;
import com.webank.cmdb.util.CmdbThreadLocal;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

@Component
@Aspect
public class OperationLogAspect {
    private static final Logger logger = LoggerFactory.getLogger(OperationLogAspect.class);

    private static final String LOG_CONTENT_FORMAT = "【%s】 %s";

    private static final Map<Class, LogCategory> classCategoryMap = ImmutableMap.<Class, LogCategory> builder()
                .put(RoleDto.class, LogCategory.PermissionManagement)
                .put(RoleUserDto.class, LogCategory.PermissionManagement)
                .put(RoleMenuDto.class, LogCategory.PermissionManagement)
                .put(RoleCiTypeDto.class, LogCategory.PermissionManagement)
                .put(RoleCiTypeCtrlAttrDto.class, LogCategory.PermissionManagement)
                .put(RoleCiTypeCtrlAttrConditionDto.class, LogCategory.PermissionManagement)
                .put(CatTypeDto.class, LogCategory.BaseDataManagement)
                .put(CategoryDto.class, LogCategory.BaseDataManagement)
                .put(CatCodeDto.class, LogCategory.BaseDataManagement)
                .put(CiTypeDto.class, LogCategory.CiTypeManagement)
                .put(CiTypeAttrDto.class, LogCategory.CiTypeManagement)
                .put(CiTypeAttrGroupDto.class, LogCategory.CiTypeManagement)
                .put(CiData.class, LogCategory.CiDataManagement).build();

    @Autowired
    private LogService logService;

    @Autowired
    private CiService ciService;

    @Pointcut("@annotation(com.webank.cmdb.config.log.OperationLogPointcut)")
    public void operationLogPointcut() {
    }

    @Around(value = "operationLogPointcut()")
    public Object operationLogAdvice(ProceedingJoinPoint pjp) throws Throwable {
        String user = CmdbThreadLocal.getIntance().getCurrentUser();
        MethodSignature methodSignature = (MethodSignature) pjp.getSignature();
        String method = methodSignature.getName();
        Object[] args = pjp.getArgs();
        OperationLogPointcut annotation = methodSignature.getMethod().getAnnotation(OperationLogPointcut.class);
        Object firstArgument = args.length > 0 ? args[0] : null;
        Class objectClass = deriveObjectClass(annotation, firstArgument);

        Annotation[][] methodAnnotations = methodSignature.getMethod().getParameterAnnotations();

        List<Integer> ciTypeIds = getCiTypeId(methodAnnotations,args);


        String requestUrl = getRequestUrl();
        String clientHost = getClientHost();

        List<String> ciGuids = Lists.newArrayList();
        if(OperationLogPointcut.Operation.Creation.equals(annotation.operation())){
            Object result = pjp.proceed();
            if(result instanceof List){
                ciGuids = getGuidFromList((List) result);
            }
                doLog(user, method, args, annotation, objectClass, ciTypeIds, requestUrl, clientHost, ciGuids);
            return result;
        }else{
            ciGuids = getCiGuid(methodAnnotations, args);
            doLog(user, method, args, annotation, objectClass, ciTypeIds, requestUrl, clientHost, ciGuids);

            try {
                Object result = pjp.proceed();
                return result;
            } catch (Throwable throwable) {
                Integer ciTypeId = null;
                if(ciTypeIds.size()>0){
                    ciTypeId = ciTypeIds.get(0);
                }
                String ciTypeName = getCiTypeName(ciTypeId);
                logService.log(logCategory(objectClass), user, failureOps(annotation), logContent(objectClass, args, method),
                        errorMessage(throwable), requestUrl,Strings.EMPTY, Strings.EMPTY, ciTypeId, ciTypeName,clientHost);
                throw throwable;
            }
        }

    }

    private void doLog(String user, String method, Object[] args, OperationLogPointcut annotation, Class objectClass, List<Integer> ciTypeIds,
                       String requestUrl, String clientHost, List<String> ciGuids) {
        if(ciTypeIds.size()>1) {
            for (Integer ciTypeId : ciTypeIds) {
                String ciTypeName = Strings.EMPTY;
                if (ciTypeId != null) {
                    ciTypeName = getCiTypeName(ciTypeId);
                }
                logService.log(logCategory(objectClass), user, successOps(annotation), logContent(objectClass, args, method),
                        null, requestUrl, Strings.EMPTY, Strings.EMPTY, ciTypeId, ciTypeName, clientHost);
            }
        }else if(ciTypeIds.size()==1){
            Integer ciTypeId = ciTypeIds.get(0);
            String ciTypeName = getCiTypeName(ciTypeId);

            for (String ciGuid : ciGuids) {
                if (Strings.isEmpty(ciGuid))
                    continue;
                String keyName = getKeyName(ciTypeId, ciGuid);
                logService.log(logCategory(objectClass), user, successOps(annotation), logContent(objectClass, args, method),
                        null, requestUrl, ciGuid, keyName, ciTypeId, ciTypeName, clientHost);
            }
        }else{
            logService.log(logCategory(objectClass), user, successOps(annotation), logContent(objectClass, args, method),
                    null, requestUrl, Strings.EMPTY, Strings.EMPTY, null, Strings.EMPTY, clientHost);
        }
    }

    private String getCiTypeName(Integer ciTypeId) {
        if(ciTypeId == null)
            return Strings.EMPTY;

        DynamicEntityMeta meta = ciService.getDynamicEntityMeta(ciTypeId);
        if (meta != null){
            return meta.getName();
        }else{
            return Strings.EMPTY;
        }
    }

    private String getKeyName(Integer ciTypeId, String ciGuid) {
        String keyName = Strings.EMPTY;
        Map<String,Object> ciData = ciService.getCi(ciTypeId,ciGuid);
        keyName = String.valueOf(ciData.get("key_name"));
        return keyName;
    }

    private String getRequestUrl(){
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        if(request == null){
            return Strings.EMPTY;
        }

        return request.getRequestURL().toString();
    }

    private String getClientHost(){
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        if(request == null){
            return Strings.EMPTY;
        }

        return request.getRemoteHost();
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

    private List<Integer> getCiTypeId(Annotation[][] methodParamAnnotations,Object[] args) {
        List<Integer> ciTypeIds = Lists.newArrayList();
        if(args == null)
            return ciTypeIds;

        int index = getIndexOf(methodParamAnnotations,CiTypeId.class);
        if(index >=0 ){
            Class argClazz = args[index].getClass();
            if( argClazz == Integer.class){
                ciTypeIds.add((Integer) args[index]);
            }else if(args[index].getClass() == int.class){
                ciTypeIds.add((int)args[index]);
            }else if(args[index] instanceof List){
                List vals = (List)args[index];
                for (Object val : vals) {
                    if(val instanceof  Map){
                        Map valMap = (Map)val;
                        Object ciTypeIdObj = valMap.get("ciTypeId");
                        if(ciTypeIdObj != null && ciTypeIdObj instanceof  Integer) {
                            ciTypeIds.add((Integer) ciTypeIdObj);
                        }
                    }else if(val instanceof Integer){
                        Integer ciTypeId = (Integer) val;
                        ciTypeIds.add(ciTypeId);
                    }else{
                        logger.warn("Can not get ciTypeId from {}",val);
                    }
                }
            }
        }
        return ciTypeIds;
    }

    private int getIndexOf(Annotation[][] methodParamAnnotations, Class targetAnnClazz){
        for (int i=0;i<methodParamAnnotations.length;i++){
            Annotation[] paramAnnotations = methodParamAnnotations[i];
            if(paramAnnotations != null){
                for (Annotation paramAnnotation : paramAnnotations) {
                    if(paramAnnotation != null && paramAnnotation.annotationType() == targetAnnClazz){
                        return i;
                    }
                }
            }
        }
        return -1;
    }

    private List<String> getCiGuid(Annotation[][] methodParamAnnotations, Object[] args) {
        if(args == null)
            return Lists.newArrayList();
        List<String> guids = Lists.newArrayList();

        int index = getIndexOf(methodParamAnnotations,Guid.class);
        if(index >=0 ){
            Object value = args[index];
            if(value instanceof  String){
                return Lists.newArrayList((String) value);
            }else if(value instanceof  List){
                guids = getGuidFromList((List) value);
            }else{
                guids = Lists.newArrayList();
            }
        }else{
            index = getIndexOf(methodParamAnnotations,CiDataType.class);
            if(index >=0 ) {
                Object value = args[index];
                if(value instanceof List){
                    guids = getGuidFromMapList((List) value);
                }else if(value instanceof Map){
                    guids.add((String) (((Map) value).get("guid")));
                }
            }
        }
        return guids;
    }

    private List<String> getGuidFromMapList(List value) {
        List<String> guids;
        guids = (List<String>) value.stream().map(e -> {
            if (e instanceof Map) {
                return (String) ((Map) e).get("guid");
            } else {
                return Strings.EMPTY;
            }
        }).collect(Collectors.toList());
        return guids;
    }

    private List<String> getGuidFromList(List values) {
        List<String> guids;
        guids = (List) values.stream().map(val -> {
            if(val instanceof CiIndentity){
                return ((CiIndentity)val).getGuid();
            }else if(val instanceof String){
                return val;
            }else if(val instanceof Map){
                return (String)((Map) val).get("guid");
            }
            else{
                return Strings.EMPTY;
            }
        }).collect(Collectors.toList());
        return guids;
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
