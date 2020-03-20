package com.webank.plugins.wecmdb.dto.wecube;

import javax.validation.constraints.NotNull;

public class Filter {
        @NotNull
        private String attrName = null;
        @NotNull
        private String op = null;
        private Object condition = null;

        public Filter() {
        }

        public Filter(@NotNull String attrName, @NotNull String op, Object condition) {
            this.attrName = attrName;
            this.op = op;
            this.condition = condition;
        }

        public String getAttrName() {
            return attrName;
        }

        public void setAttrName(String attrName) {
            this.attrName = attrName;
        }

        public String getOp() {
            return op;
        }

        public void setOp(String op) {
            this.op = op;
        }

        public Object getCondition() {
            return condition;
        }

        public void setCondition(Object condition) {
            this.condition = condition;
        }
    }