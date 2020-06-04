package com.webank.cmdb.dto;

import java.util.ArrayList;
import java.util.HashMap;

public class FilterRuleDto extends ArrayList<FilterRuleDto.FilterUnit> {
    public static final String RULE_RIGHT_TYPE_EXPRESSION = "expression";
    public static final String RULE_RIGHT_TYPE_VALUE = "value";
    public static final String RULE_RIGHT_TYPE_ARRAY = "array";

    static public class FilterUnit extends HashMap<String,RuleUnit>{
    }

    static public class RuleUnit{
        private String left;
        private String operator;
        private RuleRight right;

        public RuleUnit(){
        }

        public RuleUnit(String left,String operator,RuleRight right){
            this.left = left;
            this.operator = operator;
            this.right = right;
        }

        public String getLeft() {
            return left;
        }

        public void setLeft(String left) {
            this.left = left;
        }

        public String getOperator() {
            return operator;
        }

        public void setOperator(String operator) {
            this.operator = operator;
        }

        public RuleRight getRight() {
            return right;
        }

        public void setRight(RuleRight right) {
            this.right = right;
        }
    }

    static public class RuleRight{
        private String type;
        private Object value;

        public RuleRight(){
        }

        public RuleRight(String type,Object value){
            this.type = type;
            this.value = value;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public Object getValue() {
            return value;
        }

        public void setValue(Object value) {
            this.value = value;
        }
    }
}