package com.webank.cmdb.service.interceptor;

import java.util.Optional;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.domain.AdmRole;
import com.webank.cmdb.dto.RoleDto;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.RolerRepository;
import com.webank.cmdb.service.StaticDtoService;

@Service
public class RoleInterceptorService extends BasicInterceptorService<RoleDto, AdmRole> {

    public static final String NAME = "RoleInterceptorService";
    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private RolerRepository rolerRepository;

    @Override
    public String getName() {
        return NAME;
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(RoleDto.class.getName(), this);
    }

    @Override
    public void preDelete(Integer id) {
        Optional<AdmRole> role = rolerRepository.findById(id);
        validateIfIdExisted(id, role);
        validateIfSystemRole(role.get());
    }

    private void validateIfIdExisted(Integer id, Optional<AdmRole> role) {
        if (!role.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out Role with id [%s]", id));
        }
    }

    private void validateIfSystemRole(AdmRole role) {
        if (role.getIsSystem() == CmdbConstants.IS_SYSTEM_YES) {
            throw new InvalidArgumentException(String.format("Cannot be deleted as it is system Role [%s].", role));
        }
    }
}
