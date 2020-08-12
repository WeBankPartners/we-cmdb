package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@NoArgsConstructor
@AllArgsConstructor
public class CiDataTreeDto {
    private Integer ciTypeId;
    private String rootGuid;
    private String guid;
    private String fixedDate;
    private String stateCode;
    private String description;
    private String code;
    private Object data;
    private List<CiDataTreeDto> children = new LinkedList<>();
}
