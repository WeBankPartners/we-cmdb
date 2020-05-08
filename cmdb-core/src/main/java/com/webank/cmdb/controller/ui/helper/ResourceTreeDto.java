package com.webank.cmdb.controller.ui.helper;

import java.util.LinkedList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.webank.cmdb.dto.CiTypeAttrDto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@NoArgsConstructor
@AllArgsConstructor
public class ResourceTreeDto {
    private Integer ciTypeId;
    private String guid;
    private String flag;
    private Object attrs;
    private Object data;
    private Integer imageFileId;

    private List<CiTypeAttrDto> referenceByAttributesWithBelongType;

    private List<ResourceTreeDto> children = new LinkedList<>();
}

