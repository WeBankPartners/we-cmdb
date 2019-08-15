package com.webank.cmdb.repository;

import java.util.List;

import com.webank.cmdb.dto.EnumInfo;
import com.webank.cmdb.dto.EnumInfoRequest;

public interface EnumInfoRepository {
    List<EnumInfo> queryEnumInfo(EnumInfoRequest request);

    int getTotalRowCount(EnumInfoRequest request);
}
