package com.webank.cmdb.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonPointer;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.webank.cmdb.dto.ResponseDto;

public class JsonUtil {
    static public byte[] toJson(Object object) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        return mapper.writeValueAsBytes(object);
    }

    static public String toJsonString(Object object) {
        if (object == null) {
            return String.valueOf(object);
        }

        ObjectMapper mapper = new ObjectMapper();
        mapper.setSerializationInclusion(JsonInclude.Include.ALWAYS);
        try {
            return mapper.writeValueAsString(object);
        } catch (JsonProcessingException e) {
            return String.valueOf(object);
        }
    }

    static public String toJson(Map<?, ?> jsonMap) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(jsonMap);
        } catch (JsonProcessingException e) {
            return String.valueOf(jsonMap);
        }
    }

    static public String toJson(List<?> jsonList) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(jsonList);
        } catch (JsonProcessingException e) {
            return String.valueOf(jsonList);
        }
    }

    static public <T> ResponseDto<T> toResponseResult(String json, Class<T> clzz) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        JavaType type = mapper.getTypeFactory().constructParametricType(ResponseDto.class, clzz);
        return mapper.readValue(json, type);
    }

    static public JsonNode asNodeByPath(String jsonContent, String path) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readTree(jsonContent).at(JsonPointer.valueOf(path));
    }

    static public <T> List<T> toList(String jsonContent, Class<T> clzz) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        JavaType javaType = mapper.getTypeFactory().constructCollectionType(ArrayList.class, clzz);
        return (List<T>) mapper.readValue(jsonContent.getBytes(), javaType);
    }

    static public <T> T toObject(String jsonContent, Class<T> clzz) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        JavaType javaType = mapper.getTypeFactory().constructType(clzz);
        return mapper.readValue(jsonContent.getBytes(), javaType);
    }

}
