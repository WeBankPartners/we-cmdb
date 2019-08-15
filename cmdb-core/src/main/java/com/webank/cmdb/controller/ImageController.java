package com.webank.cmdb.controller;

import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.webank.cmdb.dto.ImageInfoDto;
import com.webank.cmdb.exception.ServiceException;
import com.webank.cmdb.service.ImageService;

@RestController
public class ImageController {
    private static final Logger logger = LoggerFactory.getLogger(ImageController.class);

    @Autowired
    private ImageService imageService;

    @PostMapping("/image/upload")
    public ImageInfoDto upload(@RequestParam(value = "img", required = false) MultipartFile file, HttpServletRequest request) {
        try {
            String contentType = file.getContentType();
            return imageService.upload(file.getName(), contentType, file.getBytes());
        } catch (IOException e) {
            String msg = String.format("Failed to upload image file. (fileName:%s)", file.getName());
            logger.warn(msg, e);
            throw new ServiceException(msg);
        }
    }

    @RequestMapping("/image/{imageId}")
    public void getImage(@PathVariable("imageId") int imageId, HttpServletResponse response) {
        ServletOutputStream out;
        try {
            out = response.getOutputStream();
            response.setCharacterEncoding("utf-8");
            ImageInfoDto imageInfo = imageService.getImage(imageId);
            response.setContentType(imageInfo.getContentType());
            out.write(imageInfo.getContent());
            out.flush();
            out.close();
        } catch (IOException e) {
            String msg = String.format("Failed to get image file. (imageId:%s)", imageId);
            logger.warn(msg, e);
            throw new ServiceException(msg);
        }
    }
}
