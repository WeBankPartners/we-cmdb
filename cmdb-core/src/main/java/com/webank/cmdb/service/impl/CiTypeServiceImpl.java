package com.webank.cmdb.service.impl;

import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Creation;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Implementation;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Modification;
import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Removal;
import static com.webank.cmdb.constant.CmdbConstants.DEFAULT_FIELDS;

import java.lang.reflect.Field;
import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.apache.commons.beanutils.BeanMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.webank.cmdb.config.log.OperationLogPointcut;
import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.ImplementOperation;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.PriorityUpdateOper;
import com.webank.cmdb.constant.ReferRelationship;
import com.webank.cmdb.domain.AdmAttrGroup;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.domain.AdmCiTypeAttrGroup;
import com.webank.cmdb.domain.AdmTenement;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeAttrGroupDto;
import com.webank.cmdb.dto.CiTypeCategoryDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.CiTypeHeaderDto;
import com.webank.cmdb.dto.CiTypeHeaderDto.CiKeyPair;
import com.webank.cmdb.dto.CiTypeReferenceDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.exception.DependencyException;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.exception.ServiceException;
import com.webank.cmdb.repository.AdmAttrGroupRepository;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrGroupRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository.BasekeyInfo;
import com.webank.cmdb.repository.AdmTenementRepository;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.service.DatabaseService;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.util.DtoField;
import com.webank.cmdb.util.QueryConverter;

@Service
public class CiTypeServiceImpl implements CiTypeService {
    private static final Logger logger = LoggerFactory.getLogger(CiTypeServiceImpl.class);

    public static final String TABLE_DELIMITER = "_";

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    @Autowired
    private AdmTenementRepository tenementRepository;
    @Autowired
    private DatabaseService databaseService;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private AdmAttrGroupRepository attrGroupRepository;
    @Autowired
    private AdmCiTypeAttrGroupRepository ciTypeAttrGroupRepository;
    @Autowired
    private AdmBasekeyCodeRepository basekeyCodeRepository;
    @Autowired
    private AdmBasekeyCatRepository basekeyCatRepository;
    @Autowired
    private StaticEntityRepository staticEntityRepository;
    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private CiService ciService;

    @Override
    public String getName() {
        return CiTypeService.NAME;
    }

    /**
     * Add a new CI type with given tenement id.
     */
    @Override
    public CiTypeDto addCiType(CiTypeDto ciType) {
        List<CiTypeDto> savedDtos = staticDtoService.create(CiTypeDto.class, Lists.newArrayList(ciType));

        logger.info(String.format("Added CI type sucessfully. (CI type name:%s)", ciType.getName()));
        return savedDtos.get(0);
    }

    @Override
    public CiTypeDto getCiType(int ciTypeId) {
        Optional<AdmCiType> admCiType = ciTypeRepository.findById(ciTypeId);
        if (!admCiType.isPresent()) {
            throw new InvalidArgumentException("Can not find out CiType with given argument.", "ciTypeId", ciTypeId);
        }
        return CiTypeDto.fromAdmCIType(admCiType.get());
    }

    private void assignSeqNo(CiTypeDto ciType) {
        AdmCiType lastCiType = ciTypeRepository.findFirstByCatalogIdOrderBySeqNoDesc(ciType.getCatalogId());
        if (lastCiType == null) {
            ciType.setSeqNo(1);
        } else {
            ciType.setSeqNo(lastCiType.getSeqNo() + 1);
        }
    }

    private AdmTenement validateTenement(int tenementId) {
        Optional<AdmTenement> admTenement = tenementRepository.findById(tenementId);
        if (!admTenement.isPresent()) {
            throw new InvalidArgumentException("Can not find out AdmTenement with given argument.", "tenementId", tenementId);
        }
        return admTenement.get();
    }

    /**
     * Check the table name if meet rule (start with tenement short name) And check
     * if the expected table is existed.
     *
     * @param ciType
     * @return
     */
    private String checkTableName(CiTypeDto ciType) {
        if (Strings.isNullOrEmpty(ciType.getTableName())) {
            throw new InvalidArgumentException("The table name is empty.");
        }
        /*
         * String tablePrefix = TABLE_DELIMITER; String tableName = ""; if
         * (!ciType.getTableName().startsWith(tablePrefix)) { tableName = tablePrefix +
         * ciType.getTableName(); } else { tableName = ciType.getTableName(); }
         */
        String tableName = ciType.getTableName();
        if (ciTypeRepository.findByTableName(tableName) != null || databaseService.isTableExisted(tableName)) {
            throw new InvalidArgumentException("The specific table is existed.", "tableName", tableName);
        }
        return tableName;
    }

    @Override
    public void updateCiType(int ciTypeId, CiTypeDto ciType) {
        if (!ciTypeRepository.existsById(ciTypeId)) {
            throw new InvalidArgumentException("Can not find out CiType with given argument.", "ciTypeId", ciTypeId);
        }

        Map<String, Object> updateMap = new HashMap<>();
        BeanMap ciTypeMap = new BeanMap(ciType);
        Field[] feilds = CiTypeDto.class.getDeclaredFields();
        for (Field field : feilds) {
            DtoField dtoField = field.getAnnotation(DtoField.class);
            if (ciTypeMap.get(field.getName()) != null && (dtoField == null || (dtoField != null && dtoField.updatable()))) {
                updateMap.put(field.getName(), ciTypeMap.get(field.getName()));
            }
        }
//		AdmCiType existingAdmCiType = ciTypeRepository.getOne(ciTypeId);
        staticDtoService.update(CiTypeDto.class, ciTypeId, updateMap);

        // AdmCiType updatedAdmCiType = ciType.updateTo(existingAdmCiType);
        // ciTypeRepository.saveAndFlush(updatedAdmCiType);

        logger.info(String.format("Updated CI type sucessfully. (CI type id:%d)", ciTypeId));
    }

    @OperationLogPointcut(operation = Creation, objectClass = CiTypeAttrDto.class, ciTypeIdArgumentIndex = 0)
    @Transactional
    @Override
    public CiTypeAttrDto addCiTypeAttribute(int ciTypeId, CiTypeAttrDto ciTypeAttr) {
        validateCiType(ciTypeId);

        AdmCiType existingAdmCiType = ciTypeRepository.getOne(ciTypeId);

        AdmCiTypeAttr admCiTypeAttr = ciTypeAttr.toAdmCiTypeAttr();
        admCiTypeAttr.setCiTypeId(ciTypeId);
        admCiTypeAttr.setStatus(CiStatus.NotCreated.getCode());
        AdmCiTypeAttr savedAdmCiTypeAttr = ciTypeAttrRepository.saveAndFlush(admCiTypeAttr);

        logger.info(String.format("Added CI type attribute sucessfully. (CI type id:%d)", ciTypeId));
        return new CiTypeAttrDto(savedAdmCiTypeAttr.getIdAdmCiTypeAttr());
    }

    /**
     * Check if the corresponding CI type is existed
     *
     * @param ciTypeId
     * @exception throw InvalidArgumentException if the corresponding CI type can
     *                  not be found
     */
    private Optional<AdmCiType> validateCiType(int ciTypeId) {
        Optional<AdmCiType> optCiType = ciTypeRepository.findById(ciTypeId);
        if (!optCiType.isPresent()) {
            throw new InvalidArgumentException("Can not find out CiType with given argument.", "ciTypeId", ciTypeId);
        }
        return optCiType;
    }

    @OperationLogPointcut(operation = Modification, objectClass = CiTypeAttrDto.class, ciTypeIdArgumentIndex = 0)
    @Override
    public void updateCiTypeAttribute(int ciTypeId, int ciTypeAttrId, CiTypeAttrDto ciTypeAttr) {
        validateCiType(ciTypeId);
        validateCiTypeAttr(ciTypeAttrId);

        AdmCiTypeAttr existingAttr = ciTypeAttrRepository.getOne(ciTypeAttrId);
        existingAttr = ciTypeAttr.updateToAdmCiTypeAttr(existingAttr);
        ciTypeAttrRepository.saveAndFlush(existingAttr);
        logger.info(String.format("Update CI type attribute sucessfully. (CI type id:%d, attribute id:%d)", ciTypeId, ciTypeAttrId));
    }

    private AdmCiTypeAttr validateCiTypeAttr(int ciTypeAttrId) {
        Optional<AdmCiTypeAttr> optCiTypeAttr = ciTypeAttrRepository.findById(ciTypeAttrId);
        if (!optCiTypeAttr.isPresent()) {
            throw new InvalidArgumentException("Can not find out CiTypeAttr with given argument.", "ciTypeAttrId", ciTypeAttrId);
        }
        return optCiTypeAttr.get();
    }

    @OperationLogPointcut(operation = Removal, objectClass = CiTypeAttrDto.class, ciTypeIdArgumentIndex = 0)
    @Override
    public void deleteCiTypeAttribute(int ciTypeId, int ciTypeAttrId) {
        validateCiType(ciTypeId);
        validateCiTypeAttr(ciTypeAttrId);

        ciTypeAttrRepository.deleteById(ciTypeAttrId);
        logger.info(String.format("Deleted CI type attribute sucessfully. (CI type id:%d, attribute id:%d)", ciTypeId, ciTypeAttrId));
    }

    @OperationLogPointcut(operation = Implementation, objectClass = CiTypeDto.class, ciTypeIdArgumentIndex = 0)
    @Override
    public void createCiTypeTable(int ciTypeId) {
        validateCiType(ciTypeId);

        AdmCiType admCiType = ciTypeRepository.getOne(ciTypeId);
        if (databaseService.isTableExisted(admCiType.getTableName())) {
            throw new InvalidArgumentException("Table is existed.", "tablename", admCiType.getTableName());
        }

        String createTableSql = createCiTypeSQL(admCiType);
        databaseService.executeSQl(createTableSql);
    }

    private String createCiTypeSQL(AdmCiType ciType) {

        StringBuffer sb = new StringBuffer("create table ");
        sb.append(ciType.getTableName()).append(" (");
        for (int i = 0; i < ciType.getAdmCiTypeAttrs().size(); i++) {
            AdmCiTypeAttr attr = ciType.getAdmCiTypeAttrs().get(i);
            sb.append("`" + attr.getPropertyName() + "`").append(" ").append(attr.getPropertyType());
            if (!("text".equals(attr.getPropertyType()) || "longtext".equals(attr.getPropertyType()))) {
                sb.append(" (").append(attr.getLength()).append(") ");
            }
            sb.append(" DEFAULT NULL COMMENT '").append(attr.getDescription()).append("',");
            if (attr.getEditIsOnly() != null && 1 == attr.getEditIsOnly()) {
                sb.append(" UNIQUE KEY (`").append(attr.getPropertyName()).append("`),");
            }
        }
        sb.append("guid varchar(13) NOT NULL COMMENT 'Global unique ID',");
        sb.append("key_name varchar(64) NOT NULL COMMENT 'Unique name',");
        sb.append("`updated_by` varchar(64) DEFAULT NULL COMMENT 'Update by',");
        sb.append("`updated_date` datetime DEFAULT NULL COMMENT 'Update date',");
        sb.append("`created_by` varchar(64) DEFAULT NULL COMMENT 'Create by',");
        sb.append("`created_date` datetime DEFAULT NULL COMMENT 'Create date',");
        sb.append(" PRIMARY KEY (`guid`)");
        for (int i = 0; i < ciType.getAdmCiTypeAttrs().size(); i++) {
            AdmCiTypeAttr attr = ciType.getAdmCiTypeAttrs().get(i);
            if ((attr.getEditIsOnly() != null && attr.getEditIsOnly() == 1) && (CmdbConstants.INPUT_TYPE_MULTIREF.equals(attr.getInputType()) || CmdbConstants.INPUT_TYPE_REF.equals(attr.getInputType()))) {
                sb.append(",").append(" INDEX (`").append(attr.getPropertyName()).append("`) ");
            }
        }
        sb.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8");
        return sb.toString();
    }

    @Override
    public List<CiTypeAttrGroupDto> getAttrGroup(int ciTypeId) {
        validateCiType(ciTypeId);

        List<CiTypeAttrGroupDto> attrGroups = new LinkedList<>();
        List<Integer> attrGroupIds = attrGroupRepository.findAdmAttrGroupId(ciTypeId);
        attrGroupIds.forEach(x -> {
            AdmAttrGroup attrGroup = attrGroupRepository.getOne(x);
            CiTypeAttrGroupDto group = CiTypeAttrGroupDto.from(attrGroup, ciTypeId);
            attrGroups.add(group);
        });
        return attrGroups;
    }

    @OperationLogPointcut(operation = Creation, objectClass = CiTypeAttrGroupDto.class)
    @Transactional
    @Override
    public void addAttrGroup(CiTypeAttrGroupDto attrGroup) {
        if (attrGroupRepository.countByName(attrGroup.getName()) > 0) {
            throw new InvalidArgumentException("The unique group name is existed.", "name", attrGroup.getName());
        }

        attrGroup.getCiTypeAttrs().forEach(x -> {
            validateCiTypeAttr(x.getCiTypeAttrId());
        });

        validateCiTypeAttr(attrGroup);

        AdmAttrGroup admAttrGroup = new AdmAttrGroup();
        admAttrGroup.setName(attrGroup.getName());
        final AdmAttrGroup savedAdmAttrGroup = attrGroupRepository.saveAndFlush(admAttrGroup);

        attrGroup.getCiTypeAttrs().forEach(x -> {
            AdmCiTypeAttrGroup ciTypeAttrGroup = new AdmCiTypeAttrGroup();
            ciTypeAttrGroup.setAdmAttrGroup(savedAdmAttrGroup);
            int attrId = x.getCiTypeAttrId();
            AdmCiTypeAttr ciTypeAttr = ciTypeAttrRepository.getOne(attrId);
            ciTypeAttrGroup.setAdmCiTypeAttr(ciTypeAttr);
            ciTypeAttrGroupRepository.saveAndFlush(ciTypeAttrGroup);
        });
    }

    private void validateCiTypeAttr(CiTypeAttrGroupDto attrGroup) {
        List<Integer> attrIds = new LinkedList<>();
        attrGroup.getCiTypeAttrs().forEach(x -> {
            attrIds.add(x.getCiTypeAttrId());
        });
        List<BigInteger> countResults = ciTypeAttrGroupRepository.countByCiTypeAttrIds(attrIds);
        for (BigInteger count : countResults) {
            if (count.intValue() >= attrIds.size())
                throw new InvalidArgumentException("The unique group is existed.", "ciTypeAttrs", "");
        }
        ;
    }

    @OperationLogPointcut(operation = Modification, objectClass = CiTypeDto.class, ciTypeIdArgumentIndex = 0)
    @Transactional
    @Override
    public void updateCiTypePriority(int ciTypeId, PriorityUpdateOper priorityOper) {
        validateCiType(ciTypeId);
        AdmCiType ciType = ciTypeRepository.getOne(ciTypeId);
        AdmCiType exchangeCiType = null;
        if (PriorityUpdateOper.Up == priorityOper) { // up
            exchangeCiType = ciTypeRepository.findFirstByCatalogIdAndSeqNoLessThanOrderBySeqNoDesc(ciType.getCatalogId(), ciType.getSeqNo());
            if (exchangeCiType == null)
                throw new InvalidArgumentException("The CiType is already in the first place.", "ciTypeId", ciTypeId);
        } else { // Down
            exchangeCiType = ciTypeRepository.findFirstByCatalogIdAndSeqNoGreaterThanOrderBySeqNoAsc(ciType.getCatalogId(), ciType.getSeqNo());
            if (exchangeCiType == null)
                throw new InvalidArgumentException("The CiType is already in the last place.", "ciTypeId", ciTypeId);
        }

        int tempSeqNo = ciType.getSeqNo();
        ciType.setSeqNo(exchangeCiType.getSeqNo());
        exchangeCiType.setSeqNo(tempSeqNo);
        ciTypeRepository.save(ciType);
        ciTypeRepository.save(exchangeCiType);

    }

    @OperationLogPointcut(operation = Removal, objectClass = CiTypeAttrGroupDto.class)
    @Transactional
    @Override
    public void deleteAttrGroup(int attrGroupId) {
        if (!attrGroupRepository.existsById(attrGroupId)) {
            throw new InvalidArgumentException("The attribute unique group is not existed.", "attrGroupId", attrGroupId);
        }

        if (ciTypeAttrGroupRepository.countByAdmAttrGroup_idAdmAttrGroup(attrGroupId) == 0) {
            throw new InvalidArgumentException("The CI type attribute unique group is not existed.", "attrGroupId", attrGroupId);
        }

        ciTypeAttrGroupRepository.deleteByAdmAttrGroup_idAdmAttrGroup(attrGroupId);
        attrGroupRepository.deleteById(attrGroupId);
    }

    @Override
    public CiTypeAttrDto getCiTypeAttribute(int ciTypeAttrId) {
        validateCiTypeAttr(ciTypeAttrId);

        AdmCiTypeAttr admCiTypeAttr = ciTypeAttrRepository.getOne(ciTypeAttrId);
        return CiTypeAttrDto.fromAdmCiTypeAttrs(admCiTypeAttr);
    }

    @Override
    public List<CiTypeAttrDto> listAllAttributes(int ciTypeId) {
        validateCiType(ciTypeId);

        List<CiTypeAttrDto> attrDtos = new LinkedList<CiTypeAttrDto>();
        List<AdmCiTypeAttr> admCiTypeAttrs = ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);

        admCiTypeAttrs.forEach(x -> {
            attrDtos.add(CiTypeAttrDto.fromAdmCiTypeAttrs(x));
        });
        return attrDtos;
    }

    @Override
    public List<CiTypeHeaderDto> getCiTypeHeader(int ciTypeId) {
        validateCiType(ciTypeId);

        List<CiTypeHeaderDto> headerDtos = new LinkedList<>();
        List<AdmCiTypeAttr> admCiTypeAttrs = ciTypeAttrRepository.findAllByCiTypeId(ciTypeId);
        admCiTypeAttrs.forEach(attr -> {
            CiTypeHeaderDto headerDto = new CiTypeHeaderDto(CiTypeHeaderDto.fromAdmCiTypeAttrs(attr));
            InputType inputType = InputType.fromCode(attr.getInputType());
            if (InputType.Droplist.equals(inputType) && attr.getReferenceId() != null) {
                List<AdmBasekeyCode> codes = basekeyCodeRepository.findByAdmBasekeyCat_idAdmBasekeyCat(attr.getReferenceId());
                if (codes != null && codes.size() > 0) {
                    codes.forEach(c -> {
                        headerDto.addEnumValue(c.getIdAdmBasekey(), c.getCode());
                    });
                }
            } else if ((InputType.Reference.equals(inputType) || InputType.MultRef.equals(inputType)) && attr.getReferenceId() != null) {
                List<CiKeyPair> ciKeyPairs = ciService.retrieveKeyPairs(attr.getReferenceId());
                if (ciKeyPairs != null && ciKeyPairs.size() > 0) {
                    headerDto.addValues(ciKeyPairs);
                }
            }
            headerDtos.add(headerDto);
        });
        return headerDtos;
    }

    @Override
    public List<CiTypeDto> listAllCiTypes(QueryRequest ciRequest) {
        Map<String, String> fieldMap = CiTypeDto.getDomainFeildMapping();
        QueryRequest domainQuery = QueryConverter.convertToDomainQuery(ciRequest, fieldMap);
        QueryResponse<AdmCiType> response = staticEntityRepository.query(AdmCiType.class, domainQuery);

        return Lists.transform(response.getContents(), (x) -> {
            return CiTypeDto.fromAdmCIType(x);
        });
    }

    @Override
    public List<CiTypeCategoryDto> listCiTypeWithAttrsLayerInfo() {
        AdmBasekeyCat admBasekeyCat = basekeyCatRepository.findAllByCatName(CmdbConstants.CI_TYPE_LAYER);
        List<BasekeyInfo> basekeyInfos = ciTypeRepository.findLayerCiTypes(1, admBasekeyCat.getIdAdmBasekeyCat());

        Map<Integer, List<AdmCiTypeAttr>> ciTypeAttrMap = new HashMap<>();
        basekeyInfos.forEach(x -> {
            // TO DO : Need to support status filter

            List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByCiTypeId(x.getCtIdAdmCiType());
            ciTypeAttrMap.put(x.getCtIdAdmCiType(), attrs);
        });
        return CiTypeCategoryDto.Builder.build(basekeyInfos, ciTypeAttrMap);

    }

    @Override
    public List<CiTypeReferenceDto> queryReferenceTo(int ciTypeId) {
        validateCiType(ciTypeId);

        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByAdmCiType_idAdmCiTypeAndInputTypeAndReferenceIdNotNull(ciTypeId, InputType.Reference.getCode());
        attrs.addAll(ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.MultRef.getCode(), ciTypeId));

        List<CiTypeReferenceDto> referenceDtos = new LinkedList<>();
        attrs.forEach(x -> {
            CiTypeReferenceDto dto = new CiTypeReferenceDto();
            dto.setCiTypeId(x.getReferenceId());
            dto.setName(ciTypeRepository.getOne(x.getReferenceId()).getName());
            dto.setRefInputType(x.getInputType());
            dto.setRefName(x.getReferenceName());
            dto.setRefPropertyId(x.getIdAdmCiTypeAttr());
            dto.setRefPropertyName(x.getPropertyName());
            dto.setRelationship(ReferRelationship.ReferencedBy.getCode());
            referenceDtos.add(dto);
        });
        return referenceDtos;
    }

    @Override
    public List<CiTypeReferenceDto> queryReferencedBy(int ciTypeId) {
        validateCiType(ciTypeId);

        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Reference.getCode(), ciTypeId);
        attrs.addAll(ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.MultRef.getCode(), ciTypeId));

        List<CiTypeReferenceDto> referenceDtos = new LinkedList<>();
        attrs.forEach(x -> {
            CiTypeReferenceDto dto = new CiTypeReferenceDto();
            dto.setCiTypeId(x.getAdmCiType().getIdAdmCiType());
            dto.setName(x.getAdmCiType().getName());
            dto.setRefInputType(x.getInputType());
            dto.setRefName(x.getName());
            dto.setRefPropertyId(x.getIdAdmCiTypeAttr());
            dto.setRefPropertyName(x.getPropertyName());
            dto.setRelationship(ReferRelationship.ReferenceTo.getCode());
            referenceDtos.add(dto);
        });
        return referenceDtos;
    }

    @OperationLogPointcut(operation = Implementation, objectClass = CiTypeDto.class)
    @Transactional
    @Override
    public void applyCiType(List<Integer> ids) {
        if (logger.isDebugEnabled()) {
            logger.debug("Apply request, ids:{}", ids);
        }

        for (Integer id : ids) {
            AdmCiType admCiType = staticEntityRepository.findEntityById(AdmCiType.class, id);
            applyCiTypeWithAttr(admCiType, true);
        }
    }

    private void applyCiTypeWithAttr(AdmCiType admCiType, boolean validateRefReqired) {
        validateRefAndSelectOfCiType(admCiType, validateRefReqired);
        CiStatus ciStatus = CiStatus.fromCode(admCiType.getStatus());
        if (ciStatus == CiStatus.NotCreated) {
            applySingleCiType(admCiType);
        } else if (ciStatus == CiStatus.Dirty) {
            applyCiTypeAttrs(admCiType);
        }
    }

    private void validateRefAndSelectOfCiType(AdmCiType admCiType, boolean validateReqired) {
        for (AdmCiTypeAttr attr : admCiType.getAdmCiTypeAttrs()) {
            if (isRefAttr(attr.getInputType()) || isSelectAttr(attr.getInputType())) {
                if (attr.getReferenceId() == null) {
                    throw new InvalidArgumentException(String.format("Can not create ciType [name = %s] with reference id of property name [%s] is null.", admCiType.getName(), attr.getPropertyName()));
                }

                if (isRefAttr(attr.getInputType()) && validateReqired) {
                    AdmCiType refCiType = staticEntityRepository.findEntityById(AdmCiType.class, attr.getReferenceId());
                    if (admCiType.getIdAdmCiType() != attr.getReferenceId() && CiStatus.fromCode(refCiType.getStatus()) == CiStatus.NotCreated) {
                        throw new InvalidArgumentException(String.format("Can not create ciType [name = %s] as ref ciType [%s] have not created yet. ", admCiType.getName(), refCiType.getName()));
                    }
                }
            }
        }
    }

    private boolean isRefAttr(String inputType) {
        return InputType.Reference.getCode().equals(inputType) || InputType.MultRef.getCode().equals(inputType);
    }

    private boolean isSelectAttr(String inputType) {
        return InputType.Droplist.getCode().equals(inputType) || InputType.MultSelDroplist.getCode().equals(inputType);
    }

    private void applyCiTypeAttrs(AdmCiType admCiType) {
        for (AdmCiTypeAttr admCiTypeAttr : admCiType.getAdmCiTypeAttrs()) {
            applySingleCiTypeAttr(admCiTypeAttr);
        }
    }

    @OperationLogPointcut(operation = Implementation, objectClass = CiTypeAttrDto.class)
    @Transactional
    @Override
    public void applyCiTypeAttr(List<Integer> ids) {
        if (logger.isDebugEnabled()) {
            logger.debug("Apply ci type attr request, ids:{}", ids);
        }

        for (Integer id : ids) {
            AdmCiTypeAttr admCiTypeAttr = staticEntityRepository.findEntityById(AdmCiTypeAttr.class, id);
            applySingleCiTypeAttr(admCiTypeAttr);
        }
    }

    private void applySingleCiTypeAttr(AdmCiTypeAttr admCiTypeAttr) {
        AdmCiType admCiType = staticEntityRepository.findEntityById(AdmCiType.class, admCiTypeAttr.getCiTypeId());
        if (admCiType == null) {
            throw new ServiceException(String.format("Can not find out ci Type [%d]", admCiTypeAttr.getCiTypeId()));
        }

        if (CiStatus.fromCode(admCiType.getStatus()) == CiStatus.NotCreated) {
            throw new DependencyException(String.format("Can not create ciTypeAttr [%s] due to it's ciType [%s] is not created yet", admCiTypeAttr.getPropertyName(), admCiType.getTableName()));
        }
        if(DEFAULT_FIELDS.isEmpty()){
            DEFAULT_FIELDS = staticEntityRepository.retrieveDefaultAdmCiTypeAttrs(new AdmCiType()).stream().map(AdmCiTypeAttr::getPropertyName).collect(Collectors.toList());
        }
        CiStatus ciStatus = CiStatus.fromCode(admCiTypeAttr.getStatus());
        if (ciStatus == CiStatus.NotCreated || ciStatus == CiStatus.Dirty) {
            // system default columns should be created with table
            if (!DEFAULT_FIELDS.contains(admCiTypeAttr.getPropertyName())) {
                staticEntityRepository.applyCiTypeAttr(admCiTypeAttr);
            }

            admCiTypeAttr.setStatus(CiStatus.Created.getCode());
            staticEntityRepository.update(admCiTypeAttr);
        }

        ciService.invalidate();
    }

    @OperationLogPointcut(operation = Implementation, objectClass = CiTypeDto.class)
    @Transactional
    @Override
    public void applyAllCiType() {
        QueryRequest request = new QueryRequest();
        QueryResponse<AdmCiType> response = staticEntityRepository.query(AdmCiType.class, request);
        if (response != null) {
            for (AdmCiType admCiType : response.getContents()) {
                applyCiTypeWithAttr(admCiType, false);
            }
        }
    }

    private void applySingleCiType(AdmCiType admCiType) {
        staticEntityRepository.applyCiType(admCiType);

        admCiType.setStatus(CiStatus.Created.getCode());
        staticEntityRepository.update(admCiType);

        applyCiTypeAttrs(admCiType);
        ciService.invalidate();
    }

    @OperationLogPointcut(operation = Implementation, objectClass = CiTypeDto.class, ciTypeIdArgumentIndex = 0)
    @Override
    public void implementCiType(int ciTypeId, ImplementOperation operation) {
        AdmCiType ciType = validateCiType(ciTypeId).get();
        CiStatus ciStatus = CiStatus.fromCode(ciType.getStatus());
        if (!ciStatus.isImplementOperationSupported(operation)) {
            throw new InvalidArgumentException(String.format(" Implement operation [%s] is not supported for status [%s].", operation.getCode(), ciStatus.getCode()));
        }

        switch (ciStatus) {
        case NotCreated:
            if (ImplementOperation.Apply.equals(operation)) {
                applyCiType(Lists.newArrayList(ciTypeId));
            }
            break;
        case Created:
            if (ImplementOperation.Decommission.equals(operation)) {
                validateIfReferByOtherCiTypes(ciType);
                ciType.setStatus(CiStatus.Decommissioned.getCode());
                staticEntityRepository.update(ciType);
            }
            break;
        case Decommissioned:
            if (ImplementOperation.Revert.equals(operation)) {
                ciType.setStatus(CiStatus.Created.getCode());
                staticEntityRepository.update(ciType);
            }
            break;
        case Dirty:
            if (ImplementOperation.Apply.equals(operation)) {
                applyCiType(Lists.newArrayList(ciTypeId));
            }
            break;
        }
    }

    private void validateIfReferByOtherCiTypes(AdmCiType ciType) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Reference.getCode(), ciType.getIdAdmCiType());
        attrs.addAll(ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.MultRef.getCode(), ciType.getIdAdmCiType()));
        if (!attrs.isEmpty()) {
            List<AdmCiType> ciTypes = ciTypeRepository.findAllById(attrs.stream().map(AdmCiTypeAttr::getCiTypeId).collect(Collectors.toList()));
            List<String> ciTypeNames = ciTypes.stream().map(AdmCiType::getName).collect(Collectors.toList());
            throw new InvalidArgumentException(String.format("CiType [%s] can not be decommission as it used by other ciTypes %s", ciType.getName(), ciTypeNames));
        }
    }

    @OperationLogPointcut(operation = Implementation, objectClass = CiTypeAttrDto.class)
    @Override
    public void implementCiTypeAttr(int ciTypeAttrId, ImplementOperation operation) {
        AdmCiTypeAttr ciTypeAttr = validateCiTypeAttr(ciTypeAttrId);
        AdmCiType ciType = ciTypeAttr.getAdmCiType();
        CiStatus ciTypeStatus = CiStatus.fromCode(ciType.getStatus());
        if (CiStatus.NotCreated.equals(ciTypeStatus) || CiStatus.Decommissioned.equals(ciTypeStatus)) {
            throw new InvalidArgumentException(String.format("CiType [%d] is not support, status is [%s]", ciType.getIdAdmCiType(), ciType.getStatus()));
        }

        CiStatus ciStatus = CiStatus.fromCode(ciTypeAttr.getStatus());
        if (!ciStatus.isImplementOperationSupported(operation)) {
            throw new InvalidArgumentException(String.format(" Implement operation [%s] is not supported for ci type sttr status [%s].", operation.getCode(), ciStatus.getCode()));
        }

        switch (ciStatus) {
        case NotCreated:
            if (ImplementOperation.Apply.equals(operation)) {
                applyCiTypeAttr(Lists.newArrayList(ciTypeAttrId));
            }
            break;
        case Created:
            if (ImplementOperation.Decommission.equals(operation)) {
                ciTypeAttr.setStatus(CiStatus.Decommissioned.getCode());
                staticEntityRepository.update(ciTypeAttr);
            }
            break;
        case Decommissioned:
            if (ImplementOperation.Revert.equals(operation)) {
                ciTypeAttr.setStatus(CiStatus.Created.getCode());
                staticEntityRepository.update(ciTypeAttr);
            }
            break;
        case Dirty:
            if (ImplementOperation.Apply.equals(operation)) {
                applyCiTypeAttr(Lists.newArrayList(ciTypeAttrId));
            }
            break;
        }

    }

}
