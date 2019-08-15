package com.webank.cmdb.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.webank.cmdb.domain.AdmFile;

@JsonInclude(Include.NON_EMPTY)
public class ImageInfoDto {
    private Integer id;
    private String contentType;
    private byte[] content;

    public static ImageInfoDto from(AdmFile admImage) {
        ImageInfoDto imageInfo = new ImageInfoDto();
        imageInfo.setId(admImage.getIdAdmFile());
        imageInfo.setContentType(admImage.getType());
        imageInfo.setContent(admImage.getContent());
        return imageInfo;
    }

    public ImageInfoDto() {
    }

    public ImageInfoDto(int id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public byte[] getContent() {
        return content;
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

}
