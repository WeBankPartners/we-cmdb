package com.webank.cmdb.service.interceptor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCatType;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplate;
import com.webank.cmdb.domain.AdmIntegrateTemplateAlias;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCatTypeRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.repository.AdmFileRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateAliasRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateRepository;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.service.DatabaseService;
import com.webank.cmdb.service.StaticDtoService;

@Service
public class CiTypeInterceptorService extends BasicInterceptorService<CiTypeDto, AdmCiType> {
    public static final String NAME = "CiTypeInterceptorService";

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;

    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private AdmBasekeyCatTypeRepository catTypeRepository;
    @Autowired
    private AdmBasekeyCatRepository catRepository;

    @Autowired
    private AdmBasekeyCodeRepository codeRepository;

    @Autowired
    private AdmIntegrateTemplateRepository intTempRepository;
    @Autowired
    private AdmIntegrateTemplateAliasRepository intTemplAliasRepository;
    @Autowired
    private AdmFileRepository fileRepository;
    @Autowired
    private DatabaseService databaseService;

    @Autowired
    private StaticEntityRepository staticEntityRepository;

    @Autowired
    private StaticDtoService staticDtoService;

    @Override
    public String getName() {
        return NAME;
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(CiTypeDto.class.getName(), this);
    }

    @Override
    public void preCreate(CiTypeDto dto, AdmCiType domainBean) {
        validateRequiredFields(domainBean);
        validateIfNameIsUnique(null, domainBean.getName());
        validateIfTableNameIsUnique(null, domainBean.getTableName());
        validateEnumCode(domainBean.getCatalogId(), CmdbConstants.CI_TYPE_CATALOG);
        validateEnumCode(domainBean.getLayerId(), CmdbConstants.CI_TYPE_LAYER);
        validateEnumCode(domainBean.getCiStateTypeId(), CmdbConstants.CI_TYPE_CI_STATE_TYPE);
        validateImageId(domainBean.getImageFileId());
        validateTableExisted(domainBean.getTableName());
        assignSeqNo(domainBean);
    }

    @Override
    public void postCreate(CiTypeDto dto, AdmCiType domainBean) {
        staticEntityRepository.createDefaultCiTypeAttrs((AdmCiType) domainBean);
        createCatType(domainBean);
    }

    private void createCatType(AdmCiType domainBean) {
        AdmBasekeyCatType catType = new AdmBasekeyCatType();
        catType.setCiTypeId(domainBean.getIdAdmCiType());
        catType.setType(3);
        catType.setName(domainBean.getName());
        staticEntityRepository.create(catType);
    }

    @Override
    public void preUpdate(Integer id, Map<String, Object> vals) {
        validateIfIdAbsent(id);
        Optional<AdmCiType> ciTypeOpt = ciTypeRepository.findById(id);
        if(ciTypeOpt.isPresent()) {
            validateIfNameIsUnique(ciTypeOpt.get().getName(), vals.get("name"));
            validateTableNameForUpdate(ciTypeOpt.get().getTableName(), vals.get("tableName"), vals.get("ciTypeId"));
        }
        validateEnumCode(vals.get("catalogId"), CmdbConstants.CI_TYPE_CATALOG);
        validateEnumCode(vals.get("layerId"), CmdbConstants.CI_TYPE_LAYER);
        validateEnumCode(vals.get("ciStateTypeId"), CmdbConstants.CI_TYPE_CI_STATE_TYPE);
        validateImageId(vals.get("imageFileId"));
    }

    @Override
    public void preDelete(Integer id) {
        validateIfIdAbsent(id);
        Optional<AdmCiType> ciTypeOpt = ciTypeRepository.findById(id);
        validateIfCiTypeExist(id, ciTypeOpt);
        validateStatus(id, ciTypeOpt);
        validateIfReferByOtherCiTypes(ciTypeOpt);
        validateIfUsedForIntegrateTemplate(id);
        validateIfUsedForIntegrateTemplateAlias(id);
        deleteCatType(id);
    }

    private void validateIfReferByOtherCiTypes(Optional<AdmCiType> ciTypeOpt) {
        if (ciTypeOpt.isPresent()) {
            List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Reference.getCode(), ciTypeOpt.get().getIdAdmCiType());
            attrs.addAll(ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.MultRef.getCode(), ciTypeOpt.get().getIdAdmCiType()));
            if (!attrs.isEmpty()) {
                List<AdmCiType> ciTypes = ciTypeRepository.findAllById(attrs.stream().map(AdmCiTypeAttr::getCiTypeId).collect(Collectors.toList()));
                List<String> ciTypeNames = ciTypes.stream().map(AdmCiType::getName).collect(Collectors.toList());
                throw new InvalidArgumentException(String.format("CiType [%s] can not be deleted as it used by other ciTypes %s", ciTypeOpt.get().getName(), ciTypeNames));
            }
        }
    }

    private void deleteCatType(Integer id) {
        List<AdmBasekeyCatType> catTypes = catTypeRepository.findAllByCiTypeId(id);
        catTypes.forEach(catType -> {
            List<AdmBasekeyCat> cats = catRepository.findAllByIdAdmBasekeyCatType(catType.getIdAdmBasekeyCatType());
            cats.forEach(cat -> {
                List<AdmBasekeyCode> codes = codeRepository.findByAdmBasekeyCat_idAdmBasekeyCat(cat.getIdAdmBasekeyCat());
                codes.forEach(code -> codeRepository.delete(code));
                catRepository.delete(cat);
            });
            catTypeRepository.delete(catType);
        });
    }

    private void validateIfNameIsUnique(Object oldName, Object name) {
        if (name != null && !name.equals(oldName) && ciTypeRepository.existsByName((String) name)) {
            throw new InvalidArgumentException(String.format("Duplicate name [%s] found, not allow to add/delete.", name));
        }
    }

    private void validateRequiredFields(AdmCiType domainBean) {
        if (domainBean.getName() == null) {
            throw new InvalidArgumentException("Field 'name' is required.");
        }

        if (domainBean.getTableName() == null) {
            throw new InvalidArgumentException("Field 'tableName' is required.");
        }
    }

    private void validateTableExisted(String tableName) {
        if (databaseService.isTableExisted(tableName)) {
            throw new InvalidArgumentException(String.format("The given table name [%s] is existed.", tableName));
        }
    }

    private void validateImageId(Object imageFileId) {
        if (imageFileId != null && !fileRepository.existsById((Integer) imageFileId)) {
            throw new InvalidArgumentException(String.format("Can not find out image file id [%s]", imageFileId));
        }
    }

    private void validateIfTableNameIsUnique(Object oldTableName, Object tableName) {
        if (tableName != null) {
            String tableNameStr = (String) tableName;
            if (CmdbConstants.MYSQL_SCHEMA_KEYWORDS.contains(tableNameStr.trim().toUpperCase())) {
                throw new InvalidArgumentException(String.format("Invalid table name [%s] as it is database key words.", tableNameStr));
            }

            if (tableNameStr.length() > CmdbConstants.MAX_LENGTH_OF_TABLE) {
                throw new InvalidArgumentException(String.format("Field tableName [%s] is too long, max length is [%d]", tableNameStr, CmdbConstants.MAX_LENGTH_OF_TABLE));
            }
            if (!tableNameStr.equals(oldTableName) && ciTypeRepository.findByTableName(tableNameStr) != null) {
                throw new InvalidArgumentException(String.format("The tableName [%s] is already existed", tableNameStr));
            }
            if (!Pattern.matches("[a-zA-Z0-9_]+", tableNameStr)) {
                throw new InvalidArgumentException(String.format("Field tableName [%s] must be composed by letters, '_' or numbers", tableNameStr));
            }
        }
    }

    private void validateEnumCode(Object codeId, String catname) {
        if (codeId != null) {
            Optional<AdmBasekeyCode> code = codeRepository.findById((Integer) codeId);
            if (!code.isPresent()) {
                throw new InvalidArgumentException(String.format("Can not find out code id [%s].", codeId));
            }

            AdmBasekeyCat cat = catRepository.getOne(code.get().getCatId());
            if (cat != null && !catname.equals(cat.getCatName())) {
                throw new InvalidArgumentException(String.format("Invalid code id [%s], expected code id of catName [%s]", codeId, catname));
            }
        }
    }

    private void assignSeqNo(AdmCiType domainBean) {
        AdmCiType lastCiType = ciTypeRepository.findFirstByCatalogIdOrderBySeqNoDesc(domainBean.getCatalogId());
        if (lastCiType == null) {
            domainBean.setSeqNo(1);
        } else {
            domainBean.setSeqNo(lastCiType.getSeqNo() + 1);
        }
    }

    private void validateTableNameForUpdate(Object oldTableName, Object tableName, Object ciTypeId) {
        if (tableName != null && !tableName.equals(oldTableName)) {
            Optional<AdmCiType> ciType = ciTypeRepository.findById((Integer) ciTypeId);
            if (ciType.isPresent() && !CiStatus.NotCreated.getCode().equals(ciType.get().getStatus())) {
                throw new InvalidArgumentException(String.format("CiType with tableName [%s] is created, not allow to change.", ciType.get().getTableName()));
            }
            validateIfTableNameIsUnique(oldTableName, tableName);
        }
    }

    private void validateIfUsedForIntegrateTemplateAlias(Integer id) {
        List<AdmIntegrateTemplateAlias> intTempAlias = intTemplAliasRepository.findByCiTypeId(id);
        if (!intTempAlias.isEmpty()) {
            List<String> alias = new ArrayList<>();
            intTempAlias.forEach(x -> alias.add(x.getAlias()));
            throw new InvalidArgumentException(String.format("CiType is used for template alias [%s]", StringUtils.join(alias, ",")));
        }
    }

    private void validateIfUsedForIntegrateTemplate(Integer id) {
        List<AdmIntegrateTemplate> intTemp = intTempRepository.findAllByCiTypeId(id);
        if (!intTemp.isEmpty()) {
            List<String> names = new ArrayList<>();
            intTemp.forEach(x -> names.add(x.getName()));
            throw new InvalidArgumentException(String.format("CiType is used for template [%s]", StringUtils.join(names, ",")));
        }
    }

    private void validateStatus(Integer id, Optional<AdmCiType> ciTypeOpt) {
        if(!ciTypeOpt.isPresent()) {
            return;
        }
        String status = ciTypeOpt.get().getStatus();
        if (!CiStatus.fromCode(status).equals(CiStatus.NotCreated)) {
            throw new InvalidArgumentException(String.format("CiType's status is [%s], table is created, [%d] can not be deleted.", status, id));
        } else {
            ciTypeAttrRepository.deleteAll(ciTypeAttrRepository.findAllByCiTypeId(id));
        }
    }

    private void validateIfCiTypeExist(Integer id, Optional<AdmCiType> ciTypeOpt) {
        if (!ciTypeOpt.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out CiType [%d]", id));
        }
    }

    private void validateIfIdAbsent(Integer id) {
        if (id == null) {
            throw new InvalidArgumentException("Field 'ciTypeId' must not be absent.");
        }
    }
}
