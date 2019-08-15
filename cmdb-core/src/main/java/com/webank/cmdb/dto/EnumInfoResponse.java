package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

public class EnumInfoResponse {
    private PageInfo pageInfo = null;
    private List<EnumInfo> enumInfos = new LinkedList<>();

    public PageInfo getPageInfo() {
        return pageInfo;
    }

    public void setPageInfo(PageInfo pageInfo) {
        this.pageInfo = pageInfo;
    }

    public List<EnumInfo> getEnumInfos() {
        return enumInfos;
    }

    public void setEnumInfos(List<EnumInfo> enumInfos) {
        this.enumInfos = enumInfos;
    }

}
