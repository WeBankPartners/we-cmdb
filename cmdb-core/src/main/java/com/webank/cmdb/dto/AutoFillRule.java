package com.webank.cmdb.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AutoFillRule {
    private List<AutoFillItem> autoFillItems;
}
