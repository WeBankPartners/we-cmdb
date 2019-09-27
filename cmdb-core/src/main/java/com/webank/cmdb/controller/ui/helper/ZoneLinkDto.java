package com.webank.cmdb.controller.ui.helper;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.webank.cmdb.dto.CiData;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@NoArgsConstructor
@AllArgsConstructor
public class ZoneLinkDto {
    private String idcGuid;
    private List<CiData> linkList;
}

