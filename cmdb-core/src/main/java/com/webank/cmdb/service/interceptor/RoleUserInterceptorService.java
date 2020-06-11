package com.webank.cmdb.service.interceptor;

import java.util.Optional;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.domain.AdmRoleUser;
import com.webank.cmdb.dto.RoleUserDto;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmRoleUserRepository;
import com.webank.cmdb.service.StaticDtoService;

@Service
public class RoleUserInterceptorService extends BasicInterceptorService<RoleUserDto, AdmRoleUser> {

    public static final String NAME = "RoleUserInterceptorService";
    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private AdmRoleUserRepository admRoleUserRepository;

    @Override
    public String getName() {
        return NAME;
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(RoleUserDto.class.getName(), this);
    }

    @Override
    public void preDelete(Integer id) {
        Optional<AdmRoleUser> roleUser = admRoleUserRepository.findById(id);
        validateIfIdExisted(id, roleUser);
        validateIfSystemRole(roleUser.get());
    }

    private void validateIfIdExisted(Integer id, Optional<AdmRoleUser> roleUser) {
        if (!roleUser.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out RoleUser with id [%s]", id));
        }
    }

    private void validateIfSystemRole(AdmRoleUser roleUser) {
        if (roleUser.getIsSystem() == CmdbConstants.IS_SYSTEM_YES) {
            throw new InvalidArgumentException(String.format("Cannot be deleted as it is system RoleUser [%s].", roleUser));
        }
    }
}
