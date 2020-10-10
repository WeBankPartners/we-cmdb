package com.webank.cmdb.util;

public class Pageable {
    private int startIndex;
    private int pageSize = 10000;
    private boolean paging = true;

    public Pageable() {
    }

    public Pageable(int startIndex, int pageSize) {
        this.startIndex = startIndex;
        this.pageSize = pageSize;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getStartIndex() {
        return startIndex;
    }

    public void setStartIndex(int startIndex) {
        this.startIndex = startIndex;
    }

    public boolean isPaging() {
        return paging;
    }

    public void setPaging(boolean paging) {
        this.paging = paging;
    }
}
