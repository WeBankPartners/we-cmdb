package com.webank.cmdb.controller.ui;

import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_CMDB_MODEL_MANAGEMENT;

import java.io.IOException;

import javax.annotation.security.RolesAllowed;
import javax.naming.SizeLimitExceededException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.webank.cmdb.config.ApplicationProperties;
import com.webank.cmdb.dto.ImageInfoDto;
import com.webank.cmdb.support.exception.CmdbException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.service.ImageService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/ui/v2")
public class UIFileManagementController {

    @Autowired
    private ApplicationProperties applicationProperties;

    @Autowired
    private ImageService imageService;

    @RolesAllowed({ MENU_ADMIN_CMDB_MODEL_MANAGEMENT })
    @PostMapping("/files/upload")
    @ResponseBody
    public Object uploadFile(@RequestParam(value = "file", required = false) MultipartFile file) throws SizeLimitExceededException {
        if (file.getSize() > applicationProperties.getMaxFileSize().toBytes()) {
            String errorMessage = String.format("Upload file failed due to file size (%s bytes) exceeded limitation (%s KB).", file.getSize(), applicationProperties.getMaxFileSize().toKilobytes());
            log.warn(errorMessage);
            throw new CmdbException("3036", errorMessage, file.getSize(), applicationProperties.getMaxFileSize().toKilobytes());
        }

        try {
            String contentType = file.getContentType();
            return imageService.upload(file.getName(), contentType, file.getBytes());
        } catch (IOException e) {
            String msg = String.format("Failed to upload image file. (fileName:%s)", file.getName());
            log.warn(msg, e);
            throw new CmdbException("3037", msg, file.getName());
        }
    }

    @GetMapping("/files/{file-id}")
    public void downloadFile(@PathVariable(value = "file-id") int fileId, HttpServletResponse response) {
        ServletOutputStream out;
        try {
            out = response.getOutputStream();
            response.setCharacterEncoding("utf-8");
            ImageInfoDto imageInfo = imageService.getImage(fileId);
            response.setContentType(imageInfo.getContentType());
            out.write(imageInfo.getContent());
            out.flush();
            out.close();
        } catch (IOException e) {
            String msg = String.format("Failed to get image file. (imageId:%s)", fileId);
            log.warn(msg, e);
            throw new ServiceException("3038",msg, fileId);
        }
    }
}
