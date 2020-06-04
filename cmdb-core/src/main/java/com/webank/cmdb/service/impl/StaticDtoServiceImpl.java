package com.webank.cmdb.service.impl;

import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Creation;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Modification;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Removal;
import static com.webank.cmdb.constant.CmdbConstants.CALLBACK_ID;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import com.webank.cmdb.config.log.CiTypeId;
import org.apache.commons.beanutils.BeanMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.webank.cmdb.config.log.OperationLogPointcut;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.support.exception.BatchChangeException;
import com.webank.cmdb.support.exception.BatchChangeException.ExceptionHolder;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.FilterPath;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.service.StaticInterceptorService;
import com.webank.cmdb.util.ClassUtils;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.JsonUtil;
import com.webank.cmdb.util.QueryConverter;
import com.webank.cmdb.util.ResourceDto;

@Service
@SuppressWarnings({ "unchecked", "rawtypes" })
public class StaticDtoServiceImpl implements StaticDtoService {

    @Override
    public String getName() {
        return StaticDtoService.NAME;
    }

    private static Logger logger = LoggerFactory.getLogger(StaticDtoServiceImpl.class);
    @Autowired
    private StaticEntityRepository staticEntityRepository;

    @Autowired
    private CiService ciService;

    private Map<String, StaticInterceptorService> interceptors = new HashMap<String, StaticInterceptorService>();

    @Override
    public void registerInterceptor(String name, StaticInterceptorService interceptor) {
        if (name == null) {
            throw new InvalidArgumentException(String.format("Interceptor name can't be null"));
        }
        interceptors.put(name, interceptor);
    }

    @Override
    public <T extends ResourceDto<T, D>, D> QueryResponse<T> query(Class<T> dtoClzz, QueryRequest ciRequest) {
        if (logger.isDebugEnabled()) {
            logger.debug("Get dto {} query request:{}", dtoClzz.toString(), JsonUtil.toJsonString(ciRequest));
        }

        StaticInterceptorService interceptor = interceptors.get(dtoClzz.getName());
        if (interceptor != null) {
            interceptor.preQuery(ciRequest);
        }

        QueryResponse<T> dtoResponse = null;
        if (ciRequest.getRefResources() == null || ciRequest.getRefResources().size() == 0) {
            dtoResponse = querySingleRes(dtoClzz, ciRequest);

        } else {// Cross resources query
            ResourceDto<T, D> resDto = getResDtoInstance(dtoClzz);
            Class<D> domainClzz = resDto.domainClazz();
            FilterPath rootFilterPath = QueryConverter.convertFilter(dtoClzz, ciRequest.getRefResources(), ciRequest.getFilters());
            QueryResponse<D> domainResponse = staticEntityRepository.<D>queryCrossRes(domainClzz, ciRequest, rootFilterPath);
            List<T> dtos = new LinkedList<>();
            domainResponse.getContents().forEach(x -> {
                T dto = resDto.fromDomain(x, ciRequest.getRefResources());
                if (dto != null) {
                    dtos.add(dto);
                }
            });

            dtoResponse = new QueryResponse();
            dtoResponse.setPageInfo(domainResponse.getPageInfo());
            dtoResponse.setContents(dtos);
        }

        if (interceptor != null) {
            dtoResponse = interceptor.postQuery(dtoResponse);
        }

        if (logger.isDebugEnabled()) {
            logger.debug("Return response:{}", JsonUtil.toJsonString(dtoResponse));
        }
        return dtoResponse;
    }

    private <T extends ResourceDto<T, D>, D> QueryResponse<T> querySingleRes(Class<T> dtoClzz, QueryRequest ciRequest) {
        final Map<String, String> dtoToDomainFieldMap = ClassUtils.getDtoToDomainFieldMap(dtoClzz);

        convertFilterToDomainName(ciRequest, dtoToDomainFieldMap);

        ResourceDto<T, D> resDto = getResDtoInstance(dtoClzz);
        Class<D> domainClzz = resDto.domainClazz();
        QueryResponse<D> domainResponse = staticEntityRepository.<D>query(domainClzz, ciRequest);
        List<T> dtos = new LinkedList<>();
        domainResponse.getContents().forEach(x -> {
            dtos.add(resDto.fromDomain(x, Lists.newArrayList()));
        });

        QueryResponse<T> dtoResponse = new QueryResponse();
        dtoResponse.setPageInfo(domainResponse.getPageInfo());
        dtoResponse.setContents(dtos);
        return dtoResponse;
    }

    private void convertFilterToDomainName(QueryRequest ciRequest, final Map<String, String> dtoToDomainFieldMap) {
        List<Filter> filters = ciRequest.getFilters();
        filters.forEach(x -> {
            String dtoName = x.getName();
            String domainField = dtoToDomainFieldMap.get(dtoName);
            if (Strings.isNullOrEmpty(domainField))
                throw new InvalidArgumentException(String.format("Can not find out field [%s] for domain .", domainField));
            x.setName(domainField);
        });
    }

    private <T extends ResourceDto<T, D>, D> T getResDtoInstance(Class<T> dtoClzz) {
        try {
            return dtoClzz.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            throw new ServiceException(String.format("Fail to create dto [%s] bean.", dtoClzz.toString()));
        }
    }

    @OperationLogPointcut(operation = Removal)
    @Override
    public <T extends ResourceDto<T, D>, D> void delete(Class<T> dtoClzz, int id) {
        if (logger.isDebugEnabled()) {
            logger.debug("Delete request dto class:{} id:{}", dtoClzz, id);
        }

        ResourceDto<T, D> resDto = getResDtoInstance(dtoClzz);
        Class<D> domainClzz = resDto.domainClazz();
        staticEntityRepository.delete(domainClzz, id);
    }

    @OperationLogPointcut(operation = Creation)
    @Transactional
    @Override
    public <T extends ResourceDto<T, D>, D> List<T> create(Class<T> dtoClzz, List<T> dtoObjs) {
        if (logger.isDebugEnabled()) {
            logger.debug("Get create request, dtoClass:{}, objects:{}", dtoClzz, JsonUtil.toJson(dtoObjs));
        }

        List<T> rtnDtos = new LinkedList<T>();
        List<ExceptionHolder> exceptionHolders = new LinkedList<>();

        StaticInterceptorService interceptor = interceptors.get(dtoClzz.getName());

        for (T dtoObj : dtoObjs) {
            T rtnDto = getResDtoInstance(dtoClzz);
            try {
                final Map<String, String> dtoToDomainFieldMap = ClassUtils.getDtoToDomainFieldMap(dtoObj.getClass());

                Class<D> domainClzz = dtoObj.domainClazz();

                D domainBean = domainClzz.newInstance();

                Map<String, Field> domainFieldMap = getDomainFieldMap(domainClzz);

                BeanMap domainBeanMap = new BeanMap(domainBean);
                BeanMap dtoBeanMap = new BeanMap(dtoObj);
                String dtoIdField = ClassUtils.getDtoIdField(dtoClzz);

                dtoBeanMap.forEach((name, value) -> {
                    if (value == null || value instanceof List) {
                        return;
                    }
                    if (dtoIdField != null && dtoIdField.equals(name)) {

                        return;
                    }

                    if (value.getClass().getPackage().equals(Integer.class.getPackage())) {
                        updateDomainField(dtoToDomainFieldMap, domainClzz, domainFieldMap, domainBeanMap, name, value);
                    }
                });

                if (interceptor != null) {
                    interceptor.preCreate(dtoObj, domainBean);
                }
                ;
                D rtnDomainBean = staticEntityRepository.create(domainBean);
                if (interceptor != null) {
                    interceptor.postCreate(dtoObj, domainBean);
                }
                ;

                rtnDto = rtnDto.fromDomain(rtnDomainBean, null);
                rtnDto.setCallbackId(dtoObj.getCallbackId());
                rtnDtos.add(rtnDto);
            } catch (Exception e) {
                logger.warn("Failed to create DTO resource.", e);
                String errorMsg = String.format("Fail to create record with callbackId = [%s], error = [%s]", dtoObj.getCallbackId(), ExceptionHolder.extractExceptionMessage(e));
                exceptionHolders.add(new ExceptionHolder(dtoObj.getCallbackId(), dtoObj, errorMsg, e));
                continue;
            }
        }

        if (exceptionHolders.size() > 0) {
            throw new BatchChangeException(String.format("Fail to create [%d] records, detail error in the data block", exceptionHolders.size()), exceptionHolders);
        }
        return rtnDtos;
    }

    private void updateDomainField(final Map<String, String> dtoToDomainFieldMap, Class domainClzz, Map<String, Field> domainFieldMap, Map domainBeanMap, Object name, Object value) {
        Object domainFieldName = dtoToDomainFieldMap.get(name);
        if (domainFieldName != null) {
            Field domainField = domainFieldMap.get(domainFieldName);
            if (domainField == null) {
                throw new ServiceException(String.format("Can not find field [%s] for domain class [%s].", domainFieldName, domainClzz.toString()));
            }
            if (value != null) {
                value = convertToDomainValue(value, domainField);
            }
            domainBeanMap.put(domainFieldName, value);
        }
    }

    private Object convertToDomainValue(Object value, Field domainField) {
        if (domainField.getType().equals(Integer.class)) {
            if (value.getClass().equals(Boolean.class)) {
                value = (Boolean) value ? 1 : 0;
            }
        }
        return value;
    }

    private Map<String, Field> getDomainFieldMap(Class domainClzz) {
        Field[] domainFields = domainClzz.getDeclaredFields();
        Map<String, Field> domainFieldMap = new HashMap<>();
        for (Field field : domainFields) {
            domainFieldMap.put(field.getName(), field);
        }
        return domainFieldMap;
    }

    @OperationLogPointcut(operation = Modification)
    @Transactional
    @Override
    public <T extends ResourceDto<T, D>, D> D update(Class<T> dtoClazz, int id, Map<String, Object> vals) {
        if (logger.isDebugEnabled()) {
            logger.debug("Update request, dto class:{}, id:{}, values:{}", dtoClazz, id, JsonUtil.toJson(vals));
        }

        ResourceDto<T, D> resDto = getResDtoInstance(dtoClazz);
        Class<D> domainClzz = resDto.domainClazz();

        final Map<String, String> dtoToDomainFieldMap = ClassUtils.getDtoToDomainFieldMap(dtoClazz);

        Map<String, Field> domainFieldMap = getDomainFieldMap(domainClzz);
        Map<String, Object> domainVals = new HashMap<>();
        Iterator<Map.Entry<String, Object>> valIterator = vals.entrySet().iterator();
        while (valIterator.hasNext()) {
            Map.Entry<String, Object> kv = valIterator.next();
            DtoField dtoField;
            try {
                dtoField = dtoClazz.getDeclaredField(kv.getKey()).getAnnotation(DtoField.class);
                if (dtoField != null && !dtoField.updatable()) {
                    // throw new InvalidArgumentException(String.format("Field [%s] is not allow to
                    // update.", k));
                    logger.warn("Field [{}] is not allow to update, ignore it.", kv.getKey());
                    valIterator.remove();
                    continue;
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new ServiceException(String.format("Service error [%s].", e.getMessage()));
            }

            String domainField = dtoToDomainFieldMap.get(kv.getKey());
            if (domainField != null) {
                domainVals.put(domainField, kv.getValue());
            } else {
                throw new InvalidArgumentException(String.format("Can not map dto attribute [%s] to domain.", kv.getKey()));
            }

        }

        vals.forEach((name, value) -> {
            if (value == null || value instanceof List) {
                return;
            }

            if (value.getClass().getPackage().equals(Integer.class.getPackage())) {
                updateDomainField(dtoToDomainFieldMap, domainClzz, domainFieldMap, domainVals, name, value);
            }
        });

        return staticEntityRepository.update(domainClzz, id, domainVals);
    }

    @OperationLogPointcut(operation = Modification)
    @Transactional
    @Override
    public <T extends ResourceDto<T, D>, D> List<T> update(Class<T> dtoClzz, @CiTypeId List<Map<String, Object>> updateRequests) {
        if (logger.isDebugEnabled()) {
            logger.debug("Update request list, dto class:{}, values:{}", dtoClzz, JsonUtil.toJson(updateRequests));
        }

        List<T> rtnDtos = new LinkedList<>();
        List<ExceptionHolder> ExceptionHolders = new LinkedList<>();

        StaticInterceptorService interceptor = interceptors.get(dtoClzz.getName());

        for (Map<String, Object> request : updateRequests) {
            String callbackId = null;
            if (request.get(CALLBACK_ID) != null) {
                callbackId = request.get(CALLBACK_ID).toString();
            }

            T rtnDto = getResDtoInstance(dtoClzz);

            try {
                Map<String, Object> vals = Maps.newHashMap(request);
                vals.remove(CALLBACK_ID);
                String idField = ClassUtils.getDtoIdField(dtoClzz);
                Integer id = (Integer) request.get(idField);

                if (interceptor != null) {
                    interceptor.preUpdate(id, vals);
                }
                D rtnDomain = update(dtoClzz, id, vals);
                if (interceptor != null) {
                    interceptor.postUpdate(id, vals);
                }

                rtnDto = rtnDto.fromDomain(rtnDomain, null);
                rtnDto.setCallbackId(callbackId);
                rtnDtos.add(rtnDto);
            } catch (Exception e) {
                e.printStackTrace();
                logger.warn(String.format("Error happened when updated DTO class [%s]", dtoClzz.toString()), e);
                String errorMsg = String.format("Fail to update record with %s = [%s], error = [%s]", CALLBACK_ID, callbackId, ExceptionHolder.extractExceptionMessage(e));
                ExceptionHolders.add(new ExceptionHolder(callbackId, request, errorMsg, e));
                continue;
            }
        }

        if (ExceptionHolders.size() > 0) {
            throw new BatchChangeException(String.format("Fail to update [%s] records, detail error in the data block", ExceptionHolders.size()), ExceptionHolders);
        }
        return rtnDtos;
    }

    @OperationLogPointcut(operation = Removal)
    @Transactional
    @Override
    public <T extends ResourceDto<T, D>, D> void delete(Class<T> dtoClzz, List<Integer> ids) {
        if (logger.isDebugEnabled()) {
            logger.debug("Delete request, dto class:{}, ids:{}", dtoClzz, ids);
        }

        StaticInterceptorService interceptor = interceptors.get(dtoClzz.getName());
        List<T> rtnDtos = new LinkedList<>();
        List<ExceptionHolder> ExceptionHolders = new LinkedList<>();

        ids.forEach(x -> {
            if (interceptor != null) {
                interceptor.preDelete(x);
            }
            try {
                delete(dtoClzz, x);
            } catch (Exception e) {
                logger.warn(String.format("Error happened when deleting DTO class [%s]", dtoClzz.toString()), e);
                String errorMsg = String.format("Fail to delete record with id = [%d], error = [%s]", x, ExceptionHolder.extractExceptionMessage(e));
                ExceptionHolders.add(new ExceptionHolder(String.valueOf(x), x, errorMsg, e));
            }
            if (interceptor != null) {
                interceptor.postDelete(x);
            }
        });

        if (ExceptionHolders.size() > 0) {
            throw new BatchChangeException(String.format("Fail to delete [%s] records, detail error in the data block", ExceptionHolders.size()), ExceptionHolders);
        }

    }

    @Override
    public <T extends ResourceDto<T, D>, D> T getOne(Class<T> dtoClzz, int id) {
        ResourceDto<T, D> resDto = getResDtoInstance(dtoClzz);
        Class<D> domainClzz = resDto.domainClazz();
        D result = staticEntityRepository.findEntityById(domainClzz, id);
        if (result != null) {
            return resDto.fromDomain(result, Lists.newArrayList());
        } else {
            return null;
        }
    }
}
