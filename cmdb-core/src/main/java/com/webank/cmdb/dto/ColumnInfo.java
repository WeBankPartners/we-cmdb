package com.webank.cmdb.dto;

import lombok.Data;

@Data
public class ColumnInfo {
	private String columnName;
	private String columnType;
	private String columnKey;
	private String isNullable;
	private String columnComent;
}