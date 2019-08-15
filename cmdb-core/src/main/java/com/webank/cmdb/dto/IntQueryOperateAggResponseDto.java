package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

public class IntQueryOperateAggResponseDto {
    private String queryName;
    private Integer queryId;
    private List<AggBranch> branchs = new LinkedList<>();

    public static class AggBranch {
        private String branchId;
        private String alias;

        public AggBranch() {
        }

        public AggBranch(String branchId, String alias) {
            this.branchId = branchId;
            this.alias = alias;
        }

        public String getBranchId() {
            return branchId;
        }

        public void setBranchId(String branchId) {
            this.branchId = branchId;
        }

        public String getAlias() {
            return alias;
        }

        public void setAlias(String alias) {
            this.alias = alias;
        }

    }

    public String getQueryName() {
        return queryName;
    }

    public void setQueryName(String queryName) {
        this.queryName = queryName;
    }

    public Integer getQueryId() {
        return queryId;
    }

    public void setQueryId(Integer queryId) {
        this.queryId = queryId;
    }

    public List<AggBranch> getBranchs() {
        return branchs;
    }

    public void setBranchs(List<AggBranch> branchs) {
        this.branchs = branchs;
    }

}
