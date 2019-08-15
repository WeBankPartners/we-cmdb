package com.webank.cmdb.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.domain.AdmFile;
import com.webank.cmdb.dto.ImageInfoDto;
import com.webank.cmdb.repository.AdmFileRepository;
import com.webank.cmdb.service.ImageService;

@Service
public class ImageServiceImpl implements ImageService {
    private static final Logger logger = LoggerFactory.getLogger(ImageServiceImpl.class);

    @Override
    public String getName() {
        return ImageService.NAME;
    }

    @Autowired
    private AdmFileRepository admFileRepository;

    @Override
    public ImageInfoDto upload(String fileName, String contentType, byte[] content) {
        AdmFile admFile = new AdmFile();
        admFile.setName(fileName);
        admFile.setContent(content);
        admFile.setType(contentType);
        admFile = admFileRepository.saveAndFlush(admFile);

        logger.info(String.format("Upload image file sucessfully.(name:%s, fileId:%d)", admFile.getName(), admFile.getIdAdmFile()));
        return new ImageInfoDto(admFile.getIdAdmFile());
    }

    @Override
    public ImageInfoDto getImage(int imageId) {
        AdmFile admFile = admFileRepository.getOne(imageId);
        if (admFile == null) {
            return null;
        } else {
            return ImageInfoDto.from(admFile);
        }
    }

}
