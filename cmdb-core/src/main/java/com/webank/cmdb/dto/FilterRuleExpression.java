package com.webank.cmdb.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FilterRuleExpression {
    private String left;
    private String operator;
    private Object right;
}