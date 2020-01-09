package com.webank.plugins.wecmdb.dto.inhouse;

import java.util.List;
import java.util.Map;

import com.webank.cmdb.dto.CustomResponseDto;

public class InhouseCmdbResponse implements CustomResponseDto {
    public static final int RET_CODE_OF_ERROR = 1;
    public static final int RET_CODE_OF_SUCCESS = 0;
    private Object data;
    private Headers headers;

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Headers getHeaders() {
        return headers;
    }

    public void setHeaders(Headers headers) {
        this.headers = headers;
    }

    public static class Headers {
        private Object startIndex;
        private Object pageSize;
        private Integer totalRows;
        private String msg;
        private Integer retCode;
        private String permissionType;

        public Integer getTotalRows() {
            return totalRows;
        }

        public void setTotalRows(Integer totalRows) {
            this.totalRows = totalRows;
        }

        public String getMsg() {
            return msg;
        }

        public void setMsg(String msg) {
            this.msg = msg;
        }

        public Integer getRetCode() {
            return retCode;
        }

        public void setRetCode(Integer retCode) {
            this.retCode = retCode;
        }

        public String getPermissionType() {
            return permissionType;
        }

        public void setPermissionType(String permissionType) {
            this.permissionType = permissionType;
        }

        public Object getStartIndex() {
            return startIndex;
        }

        public void setStartIndex(Object startIndex) {
            this.startIndex = startIndex;
        }

        public Object getPageSize() {
            return pageSize;
        }

        public void setPageSize(Object pageSize) {
            this.pageSize = pageSize;
        }

    }

    public static class Data {
        private List<Map<String, Object>> header;
        private List<Map<String, Object>> content;

        public List<Map<String, Object>> getHeader() {
            return header;
        }

        public void setHeader(List<Map<String, Object>> header) {
            this.header = header;
        }

        public List<Map<String, Object>> getContent() {
            return content;
        }

        public void setContent(List<Map<String, Object>> content) {
            this.content = content;
        }

    }

    public static InhouseCmdbResponse error(String message) {
        InhouseCmdbResponse inhouseCmdbResponse = new InhouseCmdbResponse();
        Headers headers = new Headers();
        headers.setRetCode(RET_CODE_OF_ERROR);
        headers.setMsg(message);
        inhouseCmdbResponse.setHeaders(headers);
        return inhouseCmdbResponse;
    }

    public InhouseCmdbResponse withData(Object data) {
        this.data = data;
        return this;
    }

    public static InhouseCmdbResponse okay() {
        InhouseCmdbResponse inhouseCmdbResponse = new InhouseCmdbResponse();
        Headers headers = new Headers();
        headers.setRetCode(RET_CODE_OF_SUCCESS);
        headers.setMsg("Success");
        inhouseCmdbResponse.setHeaders(headers);
        return inhouseCmdbResponse;
    }

    public static InhouseCmdbResponse okayWithData(Object data) {
        return okay().withData(data);
    }
}
