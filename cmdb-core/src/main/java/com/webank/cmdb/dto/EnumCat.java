package com.webank.cmdb.dto;

import javax.validation.constraints.NotNull;

public class EnumCat {
    private int catId;
    @NotNull
    private String catName;

    public EnumCat(int catId, String catName) {
        this.catId = catId;
        this.catName = catName;
    }

    public int getCatId() {
        return catId;
    }

    public void setCatId(int catId) {
        this.catId = catId;
    }

    public String getCatName() {
        return catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
    }

}
