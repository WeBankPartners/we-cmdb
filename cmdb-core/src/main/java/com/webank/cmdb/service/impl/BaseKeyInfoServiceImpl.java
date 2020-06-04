package com.webank.cmdb.service.impl;

import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Creation;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Modification;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Removal;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.config.log.OperationLogPointcut;
import com.webank.cmdb.constant.PriorityUpdateOper;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCatType;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CategoryDto;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCatTypeRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.service.BaseKeyInfoService;

@Service
public class BaseKeyInfoServiceImpl implements BaseKeyInfoService {
    @Autowired
    private AdmBasekeyCatRepository basekeyCatRepository;
    @Autowired
    private AdmBasekeyCatTypeRepository basekeyCatTypeRepository;
    @Autowired
    private AdmBasekeyCodeRepository basekeyCodeRepository;

    @Override
    public String getName() {
        return BaseKeyInfoService.NAME;
    }

    @Override
    public List<CategoryDto> listAllBasekeyCat(boolean withCodeInfo) {
        List<CategoryDto> baseKeyInfos = new LinkedList<>();
        basekeyCatRepository.findAll().forEach(b -> {
            baseKeyInfos.add(CategoryDto.fromAdmBasekeyCat(b, withCodeInfo));
        });
        return baseKeyInfos;
    }

    @Override
    public List<CatCodeDto> listBaseKeyCodeWithCatName(String catName) {
        AdmBasekeyCat admBasekeyCat = basekeyCatRepository.findAllByCatName(catName);
        List<CatCodeDto> baseKeyCodes = new LinkedList<>();
        if (admBasekeyCat == null) {
            return null;
        } else {
            admBasekeyCat.getAdmBasekeyCodes().forEach(x -> {
                CatCodeDto ciLayer = CatCodeDto.fromAdmBasekeyCode(x);
                baseKeyCodes.add(ciLayer);
            });
            baseKeyCodes.sort((a, b) -> {
                Integer sn1 = a.getSeqNo();
                Integer sn2 = b.getSeqNo();
                if (sn1 == null) {
                    return sn2 == null ? 0 : -1;
                } else {
                    return sn2 == null ? 1 : sn1 - sn2;
                }
            });
        }
        return baseKeyCodes;
    }

    @Override
    public List<CatTypeDto> listAllBasekeyCatTypeOverview() {
        return listBasekeyCatTypes(true);
    }

    private List<CatTypeDto> listBasekeyCatTypes(boolean withChildHierachy) {
        List<CatTypeDto> baseKeyCatTypeDtos = new LinkedList<>();
        List<AdmBasekeyCatType> basekeyCatTypes = basekeyCatTypeRepository.findAll();
        basekeyCatTypes.forEach(x -> {
            baseKeyCatTypeDtos.add(CatTypeDto.from(x, withChildHierachy));
        });
        return baseKeyCatTypeDtos;
    }

    @Override
    public List<CatTypeDto> listAllBasekeyCatTypes() {
        return listBasekeyCatTypes(false);
    }

    @OperationLogPointcut(operation = Creation, objectClass = CatTypeDto.class)
    @Override
    public void addBasekeyCatType(CatTypeDto baseKeyCatTypeDto) {
        validateCateTypeNameForCreation(baseKeyCatTypeDto);
        AdmBasekeyCatType basekeyCatTypeDomain = baseKeyCatTypeDto.toDomain();
        basekeyCatTypeRepository.save(basekeyCatTypeDomain);
    }

    private void validateCateTypeNameForCreation(CatTypeDto baseKeyCatTypeDto) {
        boolean isExisted = basekeyCatTypeRepository.existsByName(baseKeyCatTypeDto.getCatTypeName());
        if (isExisted) {
            throw new InvalidArgumentException("The specific category type is already existed.", "cateTypeName", baseKeyCatTypeDto.getCatTypeName());
        }
    }

    @Override
    public boolean checkCatTypeName(String catTypeName) {
        return basekeyCatTypeRepository.existsByName(catTypeName);
    }

    @OperationLogPointcut(operation = Creation, objectClass = CategoryDto.class)
    @Override
    public int addCategory(CategoryDto catDto, int catTypeId) {
        Optional<AdmBasekeyCatType> catType = validateCatType(catTypeId);

        if (basekeyCatRepository.countByCatNameAndCatType(catDto.getCatName(), catTypeId) > 0) {
            throw new InvalidArgumentException("The given category name is already existed.", "catName", catDto.getCatName());
        }

        AdmBasekeyCat groupCat = null;
        if (catDto.getGroupTypeId() != null) {
            Optional<AdmBasekeyCat> optGroupCat = basekeyCatRepository.findById(catDto.getGroupTypeId());
            if (optGroupCat.isPresent()) {
                groupCat = optGroupCat.get();
            }
        }
        AdmBasekeyCat admBasekeyCat = catDto.toDomain(groupCat);
        admBasekeyCat.setIdAdmBasekeyCatType(catTypeId);
        AdmBasekeyCat saveAdmBasekeyCat = basekeyCatRepository.saveAndFlush(admBasekeyCat);
        return saveAdmBasekeyCat.getIdAdmBasekeyCat();
    }

    @OperationLogPointcut(operation = Removal, objectClass = CategoryDto.class)
    @Override
    public void deleteCategory(int catId) {
        validateCategory(catId);

        basekeyCatRepository.deleteById(catId);
    }

    private Optional<AdmBasekeyCatType> validateCatType(int catTypeId) {
        Optional<AdmBasekeyCatType> catType = basekeyCatTypeRepository.findById(catTypeId);
        if (!catType.isPresent()) {
            throw new InvalidArgumentException("The specific category type is not existed.", "cateTypeId", catTypeId);
        }
        return catType;
    }

    @OperationLogPointcut(operation = Creation, objectClass = CatCodeDto.class)
    @Override
    public int addCode(int catId, CatCodeDto codeDto) {
        Optional<AdmBasekeyCat> basekeyCat = validateCategory(catId);
        validateCodeForCreation(catId, codeDto);

        AdmBasekeyCode basekeyCode = codeDto.toDomain(basekeyCat.get());
        Integer lastSeqNo = basekeyCodeRepository.getMaxSeqNoByCatId(catId);
        if (lastSeqNo != null) {
            basekeyCode.setSeqNo(lastSeqNo + 1);
        } else {
            basekeyCode.setSeqNo(1);
        }

        AdmBasekeyCode savedBasekeyCode = basekeyCodeRepository.saveAndFlush(basekeyCode);
        return savedBasekeyCode.getIdAdmBasekey();
    }

    /**
     * Check if the given code is existed for same category id.
     * 
     * @param catId
     * @param codeDto
     * @exception throw InvalidArgumentException if the same code is existed.
     */
    private void validateCodeForCreation(int catId, CatCodeDto codeDto) {
        boolean hasSameCatAndCode = basekeyCodeRepository.countByCatIdAndCode(catId, codeDto.getCode()) > 0;
        if (hasSameCatAndCode) {
            throw new InvalidArgumentException("The given code is existed.", "code", codeDto.getCode());
        }
    }

    private Optional<AdmBasekeyCat> validateCategory(int catId) {
        Optional<AdmBasekeyCat> basekeyCat = basekeyCatRepository.findById(catId);
        if (!basekeyCat.isPresent()) {
            throw new InvalidArgumentException("The specific category is not existed.", "catId", catId);
        }
        return basekeyCat;
    }

    @OperationLogPointcut(operation = Removal, objectClass = CatCodeDto.class)
    @Override
    public void deleteCode(int codeId) {
        validateCodeId(codeId);

        basekeyCodeRepository.deleteById(codeId);
    }

    private void validateCodeId(int codeId) {
        if (!basekeyCodeRepository.existsById(codeId)) {
            throw new InvalidArgumentException("The specific base key codeId is not existed.", "codeId", codeId);
        }
    }

    @OperationLogPointcut(operation = Modification, objectClass = CatCodeDto.class)
    @Override
    public void updateCode(int codeId, CatCodeDto codeDto) {
        validateCodeId(codeId);

        AdmBasekeyCode existingKeyCode = basekeyCodeRepository.getOne(codeId);
        AdmBasekeyCat keyCat = existingKeyCode.getAdmBasekeyCat();

        if (basekeyCodeRepository.countForSameCatAndCode(keyCat.getIdAdmBasekeyCat(), codeId, codeDto.getCode()) > 0) {
            throw new InvalidArgumentException("The given code is existed.", "code", codeDto.getCode());
        }
        Integer groupCodeId = (Integer)codeDto.getGroupCodeId();
        if (groupCodeId != null && basekeyCodeRepository.existsById(groupCodeId)) {
            throw new InvalidArgumentException("The give group code is not existed.", "groupCodeId", groupCodeId);
        }

        AdmBasekeyCat admBasekeyCat = null;
        if (codeDto.getCatId() != null) {
            validateCategory(codeDto.getCatId());
            admBasekeyCat = this.basekeyCatRepository.getOne(codeDto.getCatId());
        }

        AdmBasekeyCode basekeyCode = null;
        if (groupCodeId != null) {
            AdmBasekeyCode groupCode = basekeyCodeRepository.getOne(groupCodeId);
            basekeyCode = codeDto.toDomain(groupCode, admBasekeyCat);
        } else {
            basekeyCode = codeDto.toDomain(admBasekeyCat);
        }

        basekeyCode.setIdAdmBasekey(codeId);
        if (basekeyCode.getSeqNo() == null) {
            basekeyCode.setSeqNo(existingKeyCode.getSeqNo());
        }
        basekeyCode.setCatId(keyCat.getIdAdmBasekeyCat());
        basekeyCodeRepository.saveAndFlush(basekeyCode);
    }

    @OperationLogPointcut(operation = Modification, objectClass = CatCodeDto.class)
    @Transactional
    @Override
    public void updateCodePriority(int codeId, PriorityUpdateOper oper) {
        validateCodeId(codeId);

        AdmBasekeyCode curKeyCode = basekeyCodeRepository.getOne(codeId);
        AdmBasekeyCat keyCat = curKeyCode.getAdmBasekeyCat();
        AdmBasekeyCode exchangeCode = null;

        if (PriorityUpdateOper.Up == oper) {
            exchangeCode = basekeyCodeRepository.getForLessSeq(keyCat.getIdAdmBasekeyCat(), curKeyCode.getSeqNo());
            if (exchangeCode == null) {
                throw new InvalidArgumentException("The specific Base key code is already in the first place.", "codeId", codeId);
            }
        } else { // Down
            exchangeCode = basekeyCodeRepository.getForLargerSeq(keyCat.getIdAdmBasekeyCat(), curKeyCode.getSeqNo());
            if (exchangeCode == null) {
                throw new InvalidArgumentException("The specific Base key code is already in the last place.", "codeId", codeId);
            }
        }

        int tempSeqNo = curKeyCode.getSeqNo();
        curKeyCode.setSeqNo(exchangeCode.getSeqNo());
        exchangeCode.setSeqNo(tempSeqNo);
        basekeyCodeRepository.save(exchangeCode);
        basekeyCodeRepository.save(curKeyCode);
    }

    @Override
    public List<CatCodeDto> listCodes(int catTypeId) {
        validateCategory(catTypeId);

        List<AdmBasekeyCode> codes = basekeyCodeRepository.findByAdmBasekeyCat_idAdmBasekeyCat(catTypeId);
        List<CatCodeDto> codeDtos = new LinkedList<>();
        codes.forEach(x -> {
            codeDtos.add(CatCodeDto.fromAdmBasekeyCode(x));
        });

        codeDtos.sort((x, y) -> {
            return x.getSeqNo() - y.getSeqNo();
        });

        return codeDtos;
    }

    @OperationLogPointcut(operation = Modification, objectClass = CategoryDto.class)
    @Override
    public void updateCategory(int catId, CategoryDto catDto) {
        AdmBasekeyCat admBasekeyCat = validateCategory(catId).get();
        admBasekeyCat = catDto.updateTo(admBasekeyCat);
        basekeyCatRepository.saveAndFlush(admBasekeyCat);
    }

    @OperationLogPointcut(operation = Removal, objectClass = CatTypeDto.class)
    @Override
    public void deleteCatType(int catTypeId) {
        validateCatType(catTypeId);
        basekeyCatTypeRepository.deleteById(catTypeId);
    }

    @Override
    public List<CategoryDto> listCommonCats() {
        // TODO need code
        return null;
    }

    @Override
    public List<CategoryDto> listCiTypeCats(int ciTypeId) {
        // TODO list cats which belong to given CI type
        return null;
    }

    @Override
    public CatCodeDto getCode(int codeId) {
        validateCodeId(codeId);
        AdmBasekeyCode admCode = basekeyCodeRepository.getOne(codeId);
        return CatCodeDto.fromAdmBasekeyCode(admCode);
    }

    @Override
    public CatCodeDto getCode(int catId, String code) {
        AdmBasekeyCode admCode = basekeyCodeRepository.findByCatIdAndCode(catId, code);
        return CatCodeDto.fromAdmBasekeyCode(admCode);
    }
}
