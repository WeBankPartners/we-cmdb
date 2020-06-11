package com.webank.cmdb.service.interceptor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCatType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCatTypeRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.service.StaticDtoService;

@Service
public class EnumCatInterceptorService extends BasicInterceptorService<CategoryDto, AdmBasekeyCat> {
    public static final String NAME = "EnumCatInterceptorService";

    @Autowired
    private AdmBasekeyCatRepository catRepository;

    @Autowired
    private AdmBasekeyCatTypeRepository catTypeRepository;

    @Autowired
    private AdmBasekeyCodeRepository codeRepository;

    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;

    @Autowired
    private StaticDtoService staticDtoService;

    @Override
    public String getName() {
        return NAME;
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(CategoryDto.class.getName(), this);
    }

    @Override
    public void preCreate(CategoryDto dto, AdmBasekeyCat domainBean) {
        validateReqiredFields(dto);
        validateIfCatNameUniqueByCatTypeId(null, dto.getCatName(), dto.getCatTypeId());
        validateCatTypeIdAndIfCatTyeNameIsSys(domainBean.getIdAdmBasekeyCatType());
        validateGroupTypeId(dto.getGroupTypeId());
    }

    @Override
    public void preUpdate(Integer id, Map<String, Object> vals) {
        validateIfIdAbsent(id);
        AdmBasekeyCat cat = catRepository.getOne(id);
        validateIfCatNameUniqueByCatTypeId(cat, vals.get("catName"), vals.get("catTypeId"));
        validateCatTypeIdAndIfCatTyeNameIsSys(vals.get("catTypeId"));
        validateGroupTypeId(vals.get("groupTypeId"));
    }

    @Override
    public void preDelete(Integer id) {
        validateIfIdAbsent(id);
        AdmBasekeyCat cat = catRepository.getOne(id);
        validateCatTypeIdAndIfCatTyeNameIsSys(cat.getIdAdmBasekeyCatType());
        validateIfGroupForOtherCats(id, cat);
        validateIfHaveCodes(cat);
        validateIfHaveCiTypeAttrReference(cat);
    }

    private void validateIfHaveCiTypeAttrReference(AdmBasekeyCat cat) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Droplist.getCode(), cat.getIdAdmBasekeyCat());
        if (!attrs.isEmpty()) {
            List<String> attrNames = new ArrayList<>();
            attrs.forEach(x -> attrNames.add(x.getName()));
            throw new InvalidArgumentException(String.format("Not allow to delete cat [name = %s] since it used for ci type attrs [names = %s].", cat.getCatName(), StringUtils.join(attrNames, ",")));
        }
    }

    private void validateGroupTypeId(Object groupTypeId) {
        if (groupTypeId != null && !catRepository.existsById((Integer) groupTypeId)) {
            throw new InvalidArgumentException(String.format("Can not find out group type id [%s].", groupTypeId));
        }
    }

    private void validateIfCatNameUniqueByCatTypeId(AdmBasekeyCat oldCat, Object catName, Object catTypeId) {
        if (catName != null) {
            if (StringUtils.isBlank((String) catName)) {
                throw new InvalidArgumentException(String.format("Cat name [%s] is not allow to be empty.", catName));
            }

            if (catTypeId != null) {
                if (oldCat == null && catRepository.existsByCatNameAndIdAdmBasekeyCatType((String) catName, (Integer) catTypeId)) {
                    throw new InvalidArgumentException(String.format("Dupliate cat name [%s] with the same cat type [%s], not allow to add/update.", catName, catTypeId));
                }

                if (oldCat != null && catRepository.existsByCatNameAndIdAdmBasekeyCatTypeAndIdAdmBasekeyCatNot((String) catName, (Integer) catTypeId, oldCat.getIdAdmBasekeyCat())) {
                    throw new InvalidArgumentException(String.format("Dupliate cat name [%s] with the same cat type [%s], not allow to add/update.", catName, catTypeId));
                }
            }
        }
    }

    private void validateIfIdAbsent(Integer id) {
        if (id == null) {
            throw new InvalidArgumentException("Field 'catId' is required.");
        }
    }

    private void validateCatTypeIdAndIfCatTyeNameIsSys(Object catTypeId) {
        if (catTypeId != null) {
            Optional<AdmBasekeyCatType> catType = catTypeRepository.findById((Integer) catTypeId);
            if (!catType.isPresent()) {
                throw new InvalidArgumentException(String.format("Can not find out catType id [%s].", catTypeId));
            }

            if (catType.get().getType() == CmdbConstants.ENUM_CAT_TYPE_SYS) {
                throw new InvalidArgumentException(String.format("Not allow to add/update/delete cat [id = %s] for system catType [type = %s]", catTypeId, catType.get().getType()));
            }
        }
    }

    private void validateReqiredFields(CategoryDto dto) {
        if (dto.getCatTypeId() == null) {
            throw new InvalidArgumentException("Field 'catTypeId' is required.");
        }

        if (dto.getCatName() == null) {
            throw new InvalidArgumentException("Field 'catName' is required.");
        }
    }

    private void validateIfHaveCodes(AdmBasekeyCat cat) {
        if (!codeRepository.findByAdmBasekeyCat_idAdmBasekeyCat(cat.getIdAdmBasekeyCat()).isEmpty()) {
            throw new InvalidArgumentException(String.format("Not allow to delete cat [name = %s] since it has codes.", cat.getCatName()));
        }
    }

    private void validateIfGroupForOtherCats(Integer id, AdmBasekeyCat cat) {
        if (!catRepository.findAllByGroupTypeId(id).isEmpty()) {
            throw new InvalidArgumentException(String.format("Not allow to delete cat [name = %s] since it used for grouping other cats.", cat.getCatName()));
        }
    }
}
