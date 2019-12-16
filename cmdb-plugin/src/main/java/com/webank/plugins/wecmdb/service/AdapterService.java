package com.webank.plugins.wecmdb.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.FieldType;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CiData;
import com.webank.cmdb.dto.CiIndentity;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.util.BeanMapUtils;
import com.webank.cmdb.util.Sorting;
import com.webank.plugins.wecmdb.dto.AttributeDto;
import com.webank.plugins.wecmdb.dto.DataType;
import com.webank.plugins.wecmdb.dto.EntityDto;
import com.webank.plugins.wecmdb.dto.OperateCiDto;
import com.webank.plugins.wecmdb.exception.PluginException;
import com.webank.plugins.wecmdb.helper.ConfirmHelper;

@Service
public class AdapterService {
    private static final String CONFIRM = "confirm";
    private static final String CALLBACK_PARAMETER = "callbackParameter";
    private static final String PLUGIN_PACKAGE_NAME = "wecmdb";
    private static final String SORTING_DESC = "desc";
    private static final String SORTING_ASC = "asc";
    private static final String ID = "id";
    private static final String GUID = "guid";
    private static final Map<String, String> dataTypeMapping = new HashMap<>();
    static {
        dataTypeMapping.put(FieldType.Varchar.getCode(), DataType.String.getCode());
        dataTypeMapping.put(FieldType.Int.getCode(), DataType.Integer.getCode());
        dataTypeMapping.put(FieldType.Date.getCode(), DataType.Timestamp.getCode());
        dataTypeMapping.put(FieldType.DateTime.getCode(), DataType.Timestamp.getCode());
    }

    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private CiService ciService;

    private Integer retrieveCiTypeIdByTableName(String ciTypeTableName) {
        QueryRequest queryObject = QueryRequest.defaultQueryObject().addEqualsFilter("tableName", ciTypeTableName);
        QueryResponse<CiTypeDto> ciTypes = queryCiTypes(queryObject);
        if (ciTypes != null && ciTypes.getContents() != null && !ciTypes.getContents().isEmpty()) {
            return ciTypes.getContents().get(0).getCiTypeId();
        } else {
            throw new PluginException(String.format("Can not retrieve ciType with name [%s]", ciTypeTableName));
        }
    }

    public QueryResponse<CiTypeDto> queryCiTypes(QueryRequest queryObject) {
        return staticDtoService.query(CiTypeDto.class, queryObject);
    }

    public QueryResponse<CiTypeAttrDto> queryCiTypeAttrs(QueryRequest queryObject) {
        return staticDtoService.query(CiTypeAttrDto.class, queryObject);
    }

    public List<Map<String, Object>> confirmBatchCiData(List<OperateCiDto> operateCiDtos) {
        validateBeforeConfirm(operateCiDtos);

        List<Map<String, Object>> results = new ArrayList<>();
        operateCiDtos.forEach(operateCiDto -> {
            String callbackParameter = operateCiDto.getCallbackParameter();

            List<String> guids = ConfirmHelper.parseGuid(operateCiDto.getGuid());
            List<CiIndentity> ciIds = new ArrayList<>();
            guids.forEach(guid -> {
                ciIds.add(new CiIndentity(extractCiTypeIdFromGuid(guid), guid));
            });
            List<Map<String, Object>> confirmedCis = ciService.operateState(ciIds, CONFIRM);

            confirmedCis.forEach(confirmedCi -> {
                confirmedCi.put(CALLBACK_PARAMETER, callbackParameter);
            });

            results.addAll(confirmedCis);
        });
        return results;
    }

    private int extractCiTypeIdFromGuid(String guid) {
        String ciTypeId = guid.split("_")[0].replaceAll("^(0+)", "");
        return Integer.valueOf(ciTypeId).intValue();
    }

    private void validateBeforeConfirm(List<OperateCiDto> operateCiDtos) {
        operateCiDtos.forEach(operateCiDto -> {
            if (StringUtils.isBlank(operateCiDto.getGuid())) {
                throw new PluginException("Field 'guid' is required for ci data confirmation.");
            }
        });

    }

    public List<EntityDto> getDataModel() {
        QueryResponse<CiTypeDto> result = queryCiTypes(QueryRequest.defaultQueryObject());
        return convertDataModel(result);
    }

    private List<EntityDto> convertDataModel(QueryResponse<CiTypeDto> ciTypeDtoResponse) {
        List<EntityDto> entityDtos = new ArrayList<EntityDto>();
        if (ciTypeDtoResponse != null && ciTypeDtoResponse.getContents() != null && !ciTypeDtoResponse.getContents().isEmpty()) {
            List<CiTypeDto> ciTypeDtos = ciTypeDtoResponse.getContents();
            ciTypeDtos.forEach(ciTypeDto -> {
                EntityDto entityDto = new EntityDto();
                entityDto.setName(ciTypeDto.getTableName());
                entityDto.setDisplayName(ciTypeDto.getName());
                entityDto.setDescription(ciTypeDto.getDescription());

                QueryResponse<CiTypeAttrDto> ciTypeAttrResponse = queryCiTypeAttrs(QueryRequest.defaultQueryObject().addEqualsFilter("ciTypeId", ciTypeDto.getCiTypeId()));
                if (ciTypeAttrResponse != null && ciTypeAttrResponse.getContents() != null && !ciTypeAttrResponse.getContents().isEmpty()) {
                    List<CiTypeAttrDto> ciTypeAttrDtos = ciTypeAttrResponse.getContents();
                    List<AttributeDto> attributeDtos = new ArrayList<>();
                    ciTypeAttrDtos.forEach(ciTypeAttrDto -> {
                        AttributeDto attributeDto = new AttributeDto();
                        attributeDto.setEntityName(ciTypeDto.getTableName());
                        attributeDto.setDescription(ciTypeAttrDto.getDescription());
                        attributeDto.setName(GUID.equals(ciTypeAttrDto.getPropertyName()) ? ID : ciTypeAttrDto.getPropertyName());
                        switch (InputType.fromCode(ciTypeAttrDto.getInputType())) {
                        case Reference:
                        case MultRef: {
                            attributeDto.setDataType(DataType.Ref.getCode());
                            attributeDto.setRefPackageName(PLUGIN_PACKAGE_NAME);
                            attributeDto.setRefEntityName(getCiTypeNameById(ciTypeAttrDto.getReferenceId()));
                            attributeDto.setRefAttributeName(ID);
                            break;
                        }
                        default:
                            attributeDto.setDataType(mapToWecubeDataType(ciTypeAttrDto));
                            break;
                        }
                        attributeDtos.add(attributeDto);
                    });
                    entityDto.setAttributes(attributeDtos);
                }
                entityDtos.add(entityDto);
            });
        }
        return entityDtos;
    }

    private String getCiTypeNameById(Integer ciTypeId) {
        QueryRequest queryObject = QueryRequest.defaultQueryObject().addEqualsFilter("ciTypeId", ciTypeId);
        QueryResponse<CiTypeDto> ciTypes = queryCiTypes(queryObject);
        if (ciTypes != null && ciTypes.getContents() != null && !ciTypes.getContents().isEmpty()) {
            return ciTypes.getContents().get(0).getTableName();
        } else {
            throw new PluginException(String.format("Can not retrieve ciType with id [%s]", ciTypeId));
        }
    }

    private String mapToWecubeDataType(CiTypeAttrDto ciTypeAttrDto) {
        return dataTypeMapping.get(ciTypeAttrDto.getPropertyType());
    }

    public Object getCiDataWithConditions(String entityName, String filter, String sorting, String selectAttrs) {
        QueryRequest queryObject = QueryRequest.defaultQueryObject();

        applyFiltering(filter, queryObject);
        applySorting(sorting, queryObject);
        applySelectAttrs(selectAttrs, queryObject);

        return convertCiData(queryObject, retrieveCiTypeIdByTableName(entityName));
    }

    private void applySelectAttrs(String selectAttrs, QueryRequest queryObject) {
        if (!StringUtils.isBlank(selectAttrs)) {
            String[] attrs = selectAttrs.split(",");
            List<String> resultColumns = new ArrayList<>();
            for (String attr : attrs) {
                resultColumns.add(ID.equals(attr) ? GUID : attr.trim());
            }
            queryObject.setResultColumns(resultColumns);
        }
    }

    private void applySorting(String sorting, QueryRequest queryObject) {
        if (!StringUtils.isBlank(sorting)) {
            if (sorting.split(",").length != 2) {
                throw new PluginException("The given parameter 'sorting' must be format 'key," + SORTING_ASC + "/" + SORTING_DESC + "'");
            }
            String sortingAttr = sorting.split(",")[0].trim();
            String sortingValue = sorting.split(",")[1].trim();

            if (SORTING_ASC.equals(sortingValue) || SORTING_DESC.equals(sortingValue)) {
                queryObject.setSorting(new Sorting(sortingValue.equals(SORTING_ASC) ? true : false, ID.equals(sortingAttr) ? GUID : sortingAttr));
            } else {
                throw new PluginException("The given value of 'sorting' must be " + SORTING_ASC + " or " + SORTING_DESC + "'");
            }
        }
    }

    private void applyFiltering(String filter, QueryRequest queryObject) {
        if (!StringUtils.isBlank(filter)) {
            if (filter.split(",").length != 2) {
                throw new PluginException("The given parameter 'filter' must be format 'key,value'");
            }

            String filterAttr = filter.split(",")[0].trim();
            String filterValue = filter.split(",")[1].trim();
            queryObject.addEqualsFilter(ID.equals(filterAttr) ? GUID : filterAttr, filterValue);
        }
    }

    private List<Map<String, Object>> convertCiData(QueryRequest queryObject, Integer ciTypeId) {
        List<Map<String, Object>> convertedCiData = new ArrayList<>();

        QueryResponse ciDataResult = ciService.query(ciTypeId, queryObject);
        List<CiTypeAttrDto> ciTypeAttrDtos = getCiTypeAttrs(ciTypeId);
        if (ciDataResult != null && !ciDataResult.getContents().isEmpty()) {
            List<CiData> cis = ciDataResult.getContents();
            cis.forEach(ci -> {
                Map<String, Object> convertedMap = new HashMap<>();
                Map<String, Object> originCiData = ci.getData();

                originCiData.forEach((name, value) -> {
                    if (queryObject.getResultColumns() == null || queryObject.getResultColumns().contains(name)) {
                        populateSelectedAttrs(ciTypeAttrDtos, convertedMap, name, value);
                    }
                });
                convertedCiData.add(convertedMap);
            });
        }
        return convertedCiData;
    }

    private void populateSelectedAttrs(List<CiTypeAttrDto> ciTypeAttrDtos, Map<String, Object> convertedMap, String dataAttrName, Object value) {
        ciTypeAttrDtos.forEach(attr -> {
            String convertedAttrName = GUID.equals(attr.getPropertyName()) ? ID : attr.getPropertyName();
            String convertedDataAttrName = GUID.equals(dataAttrName) ? ID : dataAttrName;
            if (convertedAttrName.equals(convertedDataAttrName)) {
                if (value == null || (value instanceof String && "".equals(value))) {
                    convertedMap.put(convertedDataAttrName, value);
                } else if (InputType.fromCode(attr.getInputType()) == InputType.Droplist && value instanceof CatCodeDto) {
                    CatCodeDto singleSelect = (CatCodeDto) value;
                    convertedMap.put(convertedDataAttrName, singleSelect.getCode());
                } else if (InputType.fromCode(attr.getInputType()) == InputType.MultSelDroplist && value instanceof List) {
                    List<CatCodeDto> multiSelect = (List) value;
                    convertedMap.put(convertedDataAttrName, multiSelect.stream().map(item -> item.getCode()).collect(Collectors.toList()));
                } else if (convertedAttrName.equals(dataAttrName) && (InputType.fromCode(attr.getInputType()) == InputType.Reference)) {
                    Map singleRefObject = (Map) value;
                    convertedMap.put(convertedDataAttrName, value != null ? singleRefObject.get(GUID) : value);
                } else if (convertedAttrName.equals(convertedDataAttrName) && (InputType.fromCode(attr.getInputType()) == InputType.MultRef)) {
                    List<Object> originList = (List) value;
                    List<Map<String, Object>> multRefObjects = BeanMapUtils.convertBeansToMaps(originList);
                    convertedMap.put(convertedDataAttrName, multRefObjects.stream().map(item -> item.get(GUID)).collect(Collectors.toList()));
                } else {
                    convertedMap.put(convertedDataAttrName, value);
                }
            }
        });
    }

    private List<CiTypeAttrDto> getCiTypeAttrs(Integer ciTypeId) {
        QueryResponse<CiTypeAttrDto> ciTypeAttrResult = queryCiTypeAttrs(QueryRequest.defaultQueryObject().addEqualsFilter("ciTypeId", ciTypeId));
        if (ciTypeAttrResult != null && ciTypeAttrResult.getContents() != null && !ciTypeAttrResult.getContents().isEmpty()) {
            return ciTypeAttrResult.getContents();
        } else {
            throw new PluginException(String.format("Can not find attrs for ciType [%s]", ciTypeId));
        }
    }

    public List<Map<String, Object>> createCiData(String entityName, List<Map<String, Object>> request) {
        List<Map<String, Object>> createdCiData = ciService.create(retrieveCiTypeIdByTableName(entityName), request);
        QueryRequest queryObject = QueryRequest.defaultQueryObject().addInFilter("guid", createdCiData.stream().map(item -> item.get("guid")).collect(Collectors.toList()));
        return convertCiData(queryObject, retrieveCiTypeIdByTableName(entityName));
    }

    public List<Map<String, Object>> updateCiData(String entityName, List<Map<String, Object>> originRequest) {
        List<Map<String, Object>> convertedRequest = convertedRequest(originRequest);
        List<Map<String, Object>> updatedCiData = ciService.update(retrieveCiTypeIdByTableName(entityName), convertedRequest);
        QueryRequest queryObject = QueryRequest.defaultQueryObject().addInFilter("guid", updatedCiData.stream().map(item -> item.get("guid")).collect(Collectors.toList()));
        return convertCiData(queryObject, retrieveCiTypeIdByTableName(entityName));
    }

    private List<Map<String, Object>> convertedRequest(List<Map<String, Object>> originRequest) {
        List<Map<String, Object>> convertedRequest = new ArrayList<>();
        originRequest.forEach(origin -> {
            Map<String, Object> convertedMap = new HashMap<>();
            origin.forEach((name, value) -> {
                convertedMap.put(ID.equals(name) ? GUID : name, value);
            });
            convertedRequest.add(convertedMap);
        });
        return convertedRequest;
    }

    public void deleteCiData(String entityName, List<Map<String, Object>> request) {
        validateBeforeDeleteCiData(request);
        List<String> ids = request.stream().map(item -> item.get(ID).toString()).collect(Collectors.toList());
        ciService.delete(retrieveCiTypeIdByTableName(entityName), ids);
    }

    private void validateBeforeDeleteCiData(List<Map<String, Object>> request) {
        request.forEach(item -> {
            if (item.get(ID) == null || StringUtils.isBlank(item.get(ID).toString())) {
                throw new PluginException(String.format("Field 'id' is required for deletion, request [%s]", request));
            }
        });
    }
}
