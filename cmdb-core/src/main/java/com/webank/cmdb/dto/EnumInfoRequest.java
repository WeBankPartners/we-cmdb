package com.webank.cmdb.dto;

import com.webank.cmdb.util.Pageable;
import com.webank.cmdb.util.Sorting;

public class EnumInfoRequest {
    private boolean paging;
    private Pageable pageable = new Pageable();
    private Filter filters = new Filter();
    private Sorting sorting = new Sorting();

    public class Filter {
        private String catName;
        private String code;
        private String value;
        private String groupName;
        private String description;

        public String getCatName() {
            return catName;
        }

        public void setCatName(String name) {
            this.catName = name;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public String getGroupName() {
            return groupName;
        }

        public void setGroupName(String group) {
            this.groupName = group;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String desc) {
            this.description = desc;
        }
    }

    public Pageable getPageable() {
        return pageable;
    }

    public void setPageable(Pageable pageable) {
        this.pageable = pageable;
    }

    public boolean isPaging() {
        return paging;
    }

    public void setPaging(boolean paging) {
        this.paging = paging;
    }

    public Filter getFilters() {
        return filters;
    }

    public void setFilters(Filter filters) {
        this.filters = filters;
    }

    public Sorting getSorting() {
        return sorting;
    }

    public void setSorting(Sorting sorting) {
        this.sorting = sorting;
    }

}
