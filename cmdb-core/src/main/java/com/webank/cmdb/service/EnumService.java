package com.webank.cmdb.service;

import java.util.List;

import com.webank.cmdb.dto.CreationRtnDto;
import com.webank.cmdb.dto.EnumCat;
import com.webank.cmdb.dto.EnumInfo;
import com.webank.cmdb.dto.EnumInfoRequest;
import com.webank.cmdb.dto.EnumInfoResponse;
import com.webank.cmdb.dto.EnumPair;

public interface EnumService extends CmdbService {

    public static String NAME = "EnumService";

    EnumInfoResponse queryEnumsInfo(EnumInfoRequest enumInfoReq);

    List<EnumPair> queryEnumPairs(int catId);

    List<EnumCat> listAllEnumCats();

    void update(int codeId, EnumInfo enumInfo);

    void delete(int codeId);

    CreationRtnDto addEnumInfo(int catId, EnumInfo enumInfo);

}
