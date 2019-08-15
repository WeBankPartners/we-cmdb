package com.webank.cmdb.dto;

import com.webank.cmdb.util.Pageable;

public class PageInfo extends Pageable {
    private int totalRows;

    public PageInfo() {
    }

    public PageInfo(int totalRows, int startIndex, int pageSize) {
        super(startIndex, pageSize);
        this.totalRows = totalRows;
    }

    public int getTotalRows() {
        return totalRows;
    }

    public void setTotalRows(int totalRows) {
        this.totalRows = totalRows;
    }
}
