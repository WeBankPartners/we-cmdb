package com.webank.cmdb.service.interceptor;

import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.domain.AdmBasekeyCatType;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCatTypeRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.service.StaticDtoService;

@Service
public class EnumCatTypesInterceptorService extends BasicInterceptorService<CatTypeDto, AdmBasekeyCatType> {
    public static final String NAME = "CatTypesInterceptorService";

    @Autowired
    private AdmBasekeyCatTypeRepository catTypeRepository;

    @Autowired
    private AdmBasekeyCatRepository catRepository;

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;

    @Autowired
    private StaticDtoService staticDtoService;

    @Override
    public String getName() {
        return NAME;
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(CatTypeDto.class.getName(), this);
    }

    @Override
    public void preCreate(CatTypeDto dto, AdmBasekeyCatType domainBean) {
        validateRequiredFields(dto.getCatTypeName());
        validateIfCiTypeIdExistAndUnique(null, dto.getCiTypeId());
        validateIfCatTypeNameIsUnique(null, dto.getCatTypeName());
    }

    @Override
    public void preUpdate(Integer id, Map<String, Object> vals) {
        validateIfIdAbsent(id);
        AdmBasekeyCatType catType = catTypeRepository.getOne(id);
        validateIfCiTypeIdExistAndUnique(catType.getCiTypeId(), vals.get("ciTypeId"));
        validateIfCatTypeNameIsUnique(catType.getName(), vals.get("catTypeName"));
        validateIfSysOrCommonType(id);
    }

    @Override
    public void preDelete(Integer id) {
        validateIfIdAbsent(id);
        AdmBasekeyCatType catType = catTypeRepository.getOne(id);
        validateIfSysOrCommonType(id);
        validateIfHaveCats(catType);
    }

    private void validateRequiredFields(String catTypeName) {
        if (StringUtils.isBlank(catTypeName)) {
            throw new InvalidArgumentException("Field 'catTypeName' is required.");
        }

    }

    private void validateIfHaveCats(AdmBasekeyCatType catType) {
        if (!catRepository.findAllByIdAdmBasekeyCatType(catType.getIdAdmBasekeyCatType()).isEmpty()) {
            throw new InvalidArgumentException(String.format("Not allow to delete cat type [name = %s] since it has cats.", catType.getName()));
        }

    }

    private void validateIfCatTypeNameIsUnique(Object oldName, Object name) {
        if (name != null) {
            if (StringUtils.isBlank((String) name)) {
                throw new InvalidArgumentException(String.format("Cat type name [%s] is not allow to be empty.", name));
            }

            if (!name.equals(oldName) && catTypeRepository.existsByName((String) name)) {
                throw new InvalidArgumentException(String.format("Duplicate cat type name [%s] found, not allow to add/update.", name));
            }
        }
    }

    private void validateIfCiTypeIdExistAndUnique(Object oldCiTypeId, Object ciTypeId) {
        if (ciTypeId != null) {
            if (!ciTypeRepository.existsById((Integer) ciTypeId)) {
                throw new InvalidArgumentException(String.format("Can not find out CiType [%s].", ciTypeId));
            }

            if (!ciTypeId.equals(oldCiTypeId) && catTypeRepository.existsByCiTypeId((Integer) ciTypeId)) {
                throw new InvalidArgumentException(String.format("Duplicate ciTypeId [%s] found, not allow to add/update.", ciTypeId));
            }
        }
    }

    private void validateIfSysOrCommonType(Integer id) {
        AdmBasekeyCatType catType = catTypeRepository.getOne(id);
        if (catType.getType() == CmdbConstants.ENUM_CAT_TYPE_SYS || catType.getType() == CmdbConstants.ENUM_CAT_TYPE_COMMON) {
            throw new InvalidArgumentException(String.format("System/Common cat type [name = %s, type = %s] is not allow to update or delete.", catType.getName(), catType.getType()));
        }
    }

    private void validateIfIdAbsent(Integer id) {
        if (id == null) {
            throw new InvalidArgumentException("Field 'catTypeId' is required.");
        }
    }

}
