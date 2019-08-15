package com.webank.cmdb.service;

import java.util.List;

import com.webank.cmdb.constant.ImplementOperation;
import com.webank.cmdb.constant.PriorityUpdateOper;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeAttrGroupDto;
import com.webank.cmdb.dto.CiTypeCategoryDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.CiTypeHeaderDto;
import com.webank.cmdb.dto.CiTypeReferenceDto;
import com.webank.cmdb.dto.QueryRequest;

public interface CiTypeService extends CmdbService {
    public static String NAME = "CiTypeService";

    CiTypeDto addCiType(CiTypeDto ciType);

    void updateCiType(int ciTypeId, CiTypeDto ciType);

    CiTypeAttrDto addCiTypeAttribute(int ciTypeId, CiTypeAttrDto ciTypeAttr);

    List<CiTypeAttrDto> listAllAttributes(int ciTypeId);

    void updateCiTypeAttribute(int ciTypeId, int ciTypeAttrId, CiTypeAttrDto ciTypeAttr);

    void deleteCiTypeAttribute(int ciTypeId, int ciTypeAttrId);

    void createCiTypeTable(int ciTypeId);

    List<CiTypeAttrGroupDto> getAttrGroup(int ciTypeId);

    void addAttrGroup(CiTypeAttrGroupDto attrGroup);

    void deleteAttrGroup(int attrGroupId);

    void updateCiTypePriority(int ciTypeId, PriorityUpdateOper down);

    CiTypeDto getCiType(int ciTypeId);

    CiTypeAttrDto getCiTypeAttribute(int ciTypeAttrId);

    List<CiTypeHeaderDto> getCiTypeHeader(int ciTypeId);

    List<CiTypeDto> listAllCiTypes(QueryRequest ciRequest);

    List<CiTypeCategoryDto> listCiTypeWithAttrsLayerInfo();

    List<CiTypeReferenceDto> queryReferencedBy(int ciTypeId);

    List<CiTypeReferenceDto> queryReferenceTo(int ciTypeId);

    void implementCiType(int ciTypeId, ImplementOperation operation);

    void implementCiTypeAttr(int ciTypeAttrId, ImplementOperation operation);

    void applyCiType(List<Integer> ids);

    void applyAllCiType();

    void applyCiTypeAttr(List<Integer> ids);

}
