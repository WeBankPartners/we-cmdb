package com.webank.cmdb.service;

import com.webank.cmdb.dto.ImageInfoDto;

public interface ImageService extends CmdbService {
    static public String NAME = "ImageService";

    public ImageInfoDto upload(String fileName, String contentType, byte[] content);

    public ImageInfoDto getImage(int imageId);
}
