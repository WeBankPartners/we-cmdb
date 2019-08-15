package com.webank.cmdb.dto;

public class EnumInfo {
    private int catId;
    private String catName;
    private int codeId;
    private String code;
    private String value;
    private Integer groupCodeId;
    private String groupCode;
    private String groupName;
    private String description;

    public EnumInfo() {
    }

    public EnumInfo(int codeId) {
        setCodeId(codeId);
    }

    public CatCodeDto toBaseKeyCodeDto() {
        CatCodeDto codeDto = new CatCodeDto();
        codeDto.setCode(code);
        codeDto.setCodeDescription(description);
        codeDto.setCodeId(codeId);
        codeDto.setGroupCodeId(groupCodeId);
        codeDto.setGroupName(groupName);
        codeDto.setCatId(catId);
        return codeDto;
    }

    public String getCatName() {
        return catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
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

    public String getGroupCode() {
        return groupCode;
    }

    public void setGroupCode(String groupCode) {
        this.groupCode = groupCode;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCatId() {
        return catId;
    }

    public void setCatId(int catId) {
        this.catId = catId;
    }

    public int getCodeId() {
        return codeId;
    }

    public void setCodeId(int codeId) {
        this.codeId = codeId;
    }

    public Integer getGroupCodeId() {
        return groupCodeId;
    }

    public void setGroupCodeId(Integer groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

}
