package com.webank.plugins.wecmdb.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.domain.AdmIntegrateTemplate;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.repository.AdmIntegrateTemplateRepository;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.Pageable;
import com.webank.cmdb.util.Sorting;
import com.webank.plugins.wecmdb.dto.inhouse.InhouseCmdbRequest;
import com.webank.plugins.wecmdb.dto.inhouse.InhouseCmdbResponse;
import com.webank.plugins.wecmdb.dto.inhouse.InhouseCmdbResponse.Data;
import com.webank.plugins.wecmdb.dto.inhouse.InhouseCmdbResponse.Headers;
import com.webank.plugins.wecmdb.exception.PluginException;

@Service
public class InhouseCmdbAdapterService {
    @Autowired
    private AdmIntegrateTemplateRepository intTempRepository;
    @Autowired
    private CiService ciService;

    public InhouseCmdbResponse queryCustomizationReport(InhouseCmdbRequest inhouseCmdbQueryRequest) {
        if (!"select".equals(inhouseCmdbQueryRequest.getAction())) {
            throw new PluginException(String.format("Not support action [%s], only support 'select' action for customization report query.", inhouseCmdbQueryRequest.getAction()));
        }

        List<AdmIntegrateTemplate> templates = intTempRepository.findAllByName(inhouseCmdbQueryRequest.getType());
        if (templates.isEmpty()) {
            throw new PluginException(String.format("Can not find customization report by name [%s]", inhouseCmdbQueryRequest.getType()));
        }

        int queryId = templates.get(0).getIdAdmIntegrateTemplate();
        return convertResponse(ciService.integrateQuery(queryId, convertRequest(inhouseCmdbQueryRequest)));
    }

    private QueryRequest convertRequest(InhouseCmdbRequest inhouseCmdbQueryRequest) {
        QueryRequest request = new QueryRequest();
        request.setPaging(extractPaging(inhouseCmdbQueryRequest));
        request.setPageable(extractPageable(inhouseCmdbQueryRequest));
        request.setFilters(extractFilters(inhouseCmdbQueryRequest));
        request.setSorting(extractSorting(inhouseCmdbQueryRequest));
        request.setResultColumns(inhouseCmdbQueryRequest.getResultColumn());
        return request;
    }

    private Sorting extractSorting(InhouseCmdbRequest inhouseCmdbQueryRequest) {
        Sorting sorting = new Sorting();
        Map<String, String> orderby = inhouseCmdbQueryRequest.getOrderby();
        if (orderby != null) {
            orderby.forEach((key, value) -> {
                sorting.setField(key);
                sorting.setAsc("asc".equals(value));
            });
        }
        return sorting;
    }

    private List<Filter> extractFilters(InhouseCmdbRequest inhouseCmdbQueryRequest) {
        List<Filter> filters = new ArrayList<>();
        Map<String, Object> filter = inhouseCmdbQueryRequest.getFilter();
        if (filter != null) {
            filter.forEach((key, value) -> {
                filters.add(new Filter(key, FilterOperator.Equal.getCode(), value));
            });
        }
        return filters;
    }

    private Pageable extractPageable(InhouseCmdbRequest inhouseCmdbQueryRequest) {
        Object pageSize = inhouseCmdbQueryRequest.getPageSize();
        Object startIndex = inhouseCmdbQueryRequest.getStartIndex();
        Pageable pageable = new Pageable();
        if (pageSize != null) {
            if (pageSize instanceof String) {
                pageable.setPageSize(Integer.valueOf((String) pageSize));
            } else if (pageSize instanceof Integer) {
                pageable.setPageSize((Integer) pageSize);
            }
        }

        if (startIndex != null) {
            if (startIndex instanceof String) {
                pageable.setStartIndex(Integer.valueOf((String) startIndex));
            } else if (startIndex instanceof Integer) {
                pageable.setStartIndex((Integer) startIndex);
            }
        }
        return pageable;
    }

    private Boolean extractPaging(InhouseCmdbRequest inhouseCmdbQueryRequest) {
        Object isPaging = inhouseCmdbQueryRequest.getIsPaging();
        if (isPaging != null) {
            if (isPaging instanceof String) {
                return "true".equals(((String) isPaging).toLowerCase()) ? true : false;
            } else if (isPaging instanceof Boolean) {
                return (Boolean) isPaging;
            }
        }
        return false;
    }

    private InhouseCmdbResponse convertResponse(QueryResponse<?> response) {
        InhouseCmdbResponse inhouseCmdbQueryResponse = new InhouseCmdbResponse();
        inhouseCmdbQueryResponse.setData(convertData(response));
        inhouseCmdbQueryResponse.setHeaders(convertHeaders(response));
        return inhouseCmdbQueryResponse;
    }

    private Data convertData(QueryResponse<?> response) {
        Data data = new Data();
        data.setContent(convertContents(response.getContents()));
        data.setHeader(convertHeader(response.getContents()));
        return data;
    }

    private List<Map<String, Object>> convertHeader(List<?> contents) {
        // TODO will implement if need.
        return null;
    }

    private Headers convertHeaders(QueryResponse<?> response) {
        Headers headers = new Headers();
        headers.setRetCode(InhouseCmdbResponse.RET_CODE_OF_SUCCESS);
        headers.setPageSize(response.getPageInfo().getPageSize());
        headers.setStartIndex(response.getPageInfo().getStartIndex());
        headers.setTotalRows(response.getPageInfo().getTotalRows());
        return headers;
    }

    private List<Map<String, Object>> convertContents(List<?> contents) {
        List<Map<String, Object>> convertedContents = new ArrayList<>();
        if (contents != null && !contents.isEmpty()) {
            contents.forEach(content -> {
                Map<String, Object> convertedContent = new HashMap<>();
                if (content != null && content instanceof Map) {
                    Map<String, Object> originContent = (Map) content;
                    originContent.forEach((key, value) -> {
                        Object convertedValue = value;
                        if (value instanceof Map) {
                            convertedValue = extractedKVFromRefCi(value);
                        } else if (value instanceof CatCodeDto) {
                            convertedValue = ((CatCodeDto) value).getValue();
                        } else if (value instanceof List) {
                            List<Object> convertedItems = new ArrayList<>();
                            ((List) value).forEach(item -> {
                                if (item instanceof Map) {
                                    convertedItems.addAll(extractedKVFromRefCi(item));
                                }
                            });
                            convertedValue = convertedItems;
                        }
                        convertedContent.put(key, convertedValue);
                    });
                }
                convertedContents.add(convertedContent);
            });
        }
        return convertedContents;
    }

    private List<Object> extractedKVFromRefCi(Object value) {
        List<Object> convertedFields = new ArrayList<>();
        Map<String, Object> convertedField = new HashMap<>();
        convertedField.put("k", ((Map) value).get(CmdbConstants.GUID));
        convertedField.put("v", ((Map) value).get("key_name"));
        convertedFields.add(convertedField);
        return convertedFields;
    }

}
