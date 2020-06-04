package com.webank.cmdb.service.interceptor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.annotation.PostConstruct;
import javax.transaction.Transactional;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.FieldType;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplateAliasAttr;
import com.webank.cmdb.domain.AdmIntegrateTemplateRelation;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.repository.AdmCiTypeAttrGroupRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateAliasAttrRepository;
import com.webank.cmdb.repository.AdmIntegrateTemplateRelationRepository;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.util.DataTypeConverter;

@Service

public class CiTypeAttrsInterceptorService extends BasicInterceptorService<CiTypeAttrDto, AdmCiTypeAttr> {
    public static final String NAME = "CiTypeAttrsInterceptorService";

    @Autowired
    private StaticEntityRepository staticEntityRepository;
    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private AdmIntegrateTemplateAliasAttrRepository intTemplAliasAttrRepository;
    @Autowired
    private AdmIntegrateTemplateRelationRepository intTemplRltRepository;
    @Autowired
    private AdmCiTypeAttrGroupRepository attrGroupRepository;

    @Override
    public String getName() {
        return NAME;
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(CiTypeAttrDto.class.getName(), this);
    }

    @Override
    public QueryResponse<?> postQuery(QueryResponse<CiTypeAttrDto> dtoResponse) {
        List<CiTypeAttrDto> attrDtos = dtoResponse.getContents();
        // will not return attribute if is hidden
        attrDtos = attrDtos.stream().filter(attr -> {
            return !attr.getIsHidden();
        }).collect(Collectors.toList());

        dtoResponse.setContents(attrDtos);
        return dtoResponse;
    }

    @Override
    public void preCreate(CiTypeAttrDto dto, AdmCiTypeAttr domainBean) {
        validateIfDecommissionedStatus(domainBean.getCiTypeId(), domainBean.getName());
        validateIfReferenceInfoMissing(domainBean.getInputType(), domainBean.getReferenceId(), domainBean.getReferenceName());
        handleRefAttrWithAutoFillLengthForCreate(domainBean);
        validateCiTypeId(domainBean.getCiTypeId());
        validateIfNameUniqueByCiTypeId(null, domainBean.getName(), domainBean.getCiTypeId());
        validatePropertyName(null, domainBean.getPropertyName(), domainBean.getCiTypeId());
        validatePropertyTypeAndLength(domainBean.getPropertyType(), domainBean.getLength(), domainBean.getCiTypeId());
        validateAutoFillRule(dto.getIsAuto(), dto.getAutoFillRule());
        assignDisplaySeqNo(domainBean);
    }

    private void assignDisplaySeqNo(AdmCiTypeAttr domainBean) {
        AdmCiTypeAttr lastCiTypeAttr = ciTypeAttrRepository.findFirstByCiTypeIdOrderByDisplaySeqNoDesc(domainBean.getCiTypeId());
        if (lastCiTypeAttr != null && lastCiTypeAttr.getDisplaySeqNo() != null) {
            domainBean.setDisplaySeqNo(lastCiTypeAttr.getDisplaySeqNo() + 1);
        } else {
            domainBean.setDisplaySeqNo(1);
        }
    }

    private void validateAutoFillRule(Object isAuto, Object autoFillRule) {
        if (isAuto != null && ((Boolean) isAuto)) {
            if (autoFillRule == null || StringUtils.isBlank((String)autoFillRule)) {
                throw new InvalidArgumentException("Auto fill rule can't be null as isAuto = Yes");
            }
        }
    }

    @Transactional
    @Override
    public void preUpdate(Integer id, Map<String, Object> vals) {
        validateIfIdAbsent(id);
        Optional<AdmCiTypeAttr> ciTypeAttrOpt = ciTypeAttrRepository.findById(id);
        validateIfAttrExist(id, ciTypeAttrOpt);
        validateIfDecommissionedStatus(vals.get("ciTypeId"), ciTypeAttrOpt.get().getName());
        validateIfReferenceInfoMissing(vals.get("inputType"), vals.get("referenceId"), vals.get("referenceName"));
        handleRefAttrWithAutoFillLengthForUpdate(vals);
        validateCiTypeIdForUpdate(vals);
        validateIfNameUniqueByCiTypeId(ciTypeAttrOpt.get().getName(), vals.get("name"), vals.get("ciTypeId"));
        validatePropertyNameForUpdate(vals, ciTypeAttrOpt);
        validatePropertyTypeAndLengthForUpdate(vals);
        handleDirtyStatus(ciTypeAttrOpt.get(), vals);
        validateAutoFillRule(vals.get("isAuto"), vals.get("autoFillRule"));
    }

    @Override
    public void preDelete(Integer id) {
        validateIfIdAbsent(id);
        Optional<AdmCiTypeAttr> ciTypeAttrOpt = ciTypeAttrRepository.findById(id);
        validateIfAttrExist(id, ciTypeAttrOpt);
        validateDeletableStatus(id, ciTypeAttrOpt.get());
        validateIfSystemAttr(ciTypeAttrOpt.get());
        validateIfUsedForIntegrateTemplateAliasAttr(id);
        validateIfUsedForIntegrateTemplateRelation(id);
        validateIfUsedForAttrGroup(id);
    }

    private void validateIfReferenceInfoMissing(Object inputType, Object referenceId, Object referenceName) {
        if (inputType != null) {
            switch (InputType.fromCode((String) inputType)) {
            case Reference:
            case MultRef:
            case OrchestrationMuliRef:
            case Orchestration:
                if (referenceId == null) {
                    throw new InvalidArgumentException(String.format("Reference id is required for ref attr [inputType = %s].", inputType));
                }

                if (referenceName == null) {
                    throw new InvalidArgumentException(String.format("Reference name is required for ref attr [inputType = %s].", inputType));
                }

                if (!ciTypeRepository.existsById((Integer) referenceId)) {
                    throw new InvalidArgumentException(String.format("Can not find out Reference id [%s].", referenceId));
                }
                break;
            case Droplist:
            case MultSelDroplist:
                if (referenceId == null) {
                    throw new InvalidArgumentException(String.format("Reference id is required for select attr [inputType = %s].", inputType));
                }
                break;
            default:
                break;
            }
        }
    }

    private void validateIfNameUniqueByCiTypeId(Object oldAttrName, Object attrName, Object ciTypeId) {
        if (attrName != null) {
            if (StringUtils.isBlank((String) attrName)) {
                throw new InvalidArgumentException(String.format("Attr name [%s] is not allow to be empty.", attrName));
            }

            if (ciTypeId != null && !attrName.equals(oldAttrName) && ciTypeAttrRepository.existsByNameAndCiTypeId((String) attrName, (Integer) ciTypeId)) {
                throw new InvalidArgumentException(String.format("Dupliate attr name [%s] with the same ci type id [%s], not allow to add/update.", attrName, ciTypeId));
            }
        }
    }

    private void validateIfUsedForAttrGroup(Integer id) {
        if (attrGroupRepository.existsByCiTypeAttrId(id)) {
            throw new InvalidArgumentException(String.format("CiType is used for attr group [id=%s]", id));
        }
    }

    private void validateIfIdAbsent(Integer id) {
        if (id == null) {
            throw new InvalidArgumentException("Field 'ciTypeAttrId' must not be absent.");
        }
    }

    private void validatePropertyTypeAndLengthForUpdate(Map<String, Object> vals) {
        if (vals.get("propertyType") != null) {
            validatePropertyTypeAndLength((String) vals.get("propertyType"), (Integer) vals.get("length"), (Integer) vals.get("ciTypeId"));
        }
    }

    private void validatePropertyNameForUpdate(Map<String, Object> vals, Optional<AdmCiTypeAttr> ciTypeAttrOpt) {
        if (ciTypeAttrOpt.isPresent() && vals.get("propertyName") != null) {
            if (!CiStatus.NotCreated.getCode().equals(ciTypeAttrOpt.get().getStatus()) && !ciTypeAttrOpt.get().getPropertyName().equals(vals.get("propertyName"))) {
                throw new InvalidArgumentException(String.format("Not allow to change propertyName of status [%s].", ciTypeAttrOpt.get().getStatus()));
            }
            validatePropertyName(ciTypeAttrOpt.get().getPropertyName(), vals.get("propertyName"), ciTypeAttrOpt.get().getCiTypeId());
        }
    }

    private void validateCiTypeIdForUpdate(Map<String, Object> vals) {
        if (vals.get("ciTypeId") != null) {
            validateCiTypeId((Integer) vals.get("ciTypeId"));
        }
    }

    private void handleRefAttrWithAutoFillLengthForUpdate(Map<String, Object> vals) {
        Integer autoFillLength = getAutoFillLength((String) vals.get("inputType"));
        if (autoFillLength != null) {
            vals.put("length", autoFillLength);
        }
    }

    private void validateIfDecommissionedStatus(Object ciTypeId, Object attrName) {
        if (ciTypeId != null) {
            AdmCiType ciType = staticEntityRepository.findEntityById(AdmCiType.class, (Integer) ciTypeId);
            if (CiStatus.Decommissioned.getCode().equals(ciType.getStatus())) {
                throw new InvalidArgumentException(String.format("Attr [name=%s] is not allow to add/update since it's ci type have been decommissioned.", attrName));
            }
        }
    }

    private void handleDirtyStatus(AdmCiTypeAttr attr, Map<String, Object> vals) {
        if (isDirtyChange(vals, attr) && !CiStatus.NotCreated.getCode().equals(attr.getStatus())) {
            attr.setStatus(CiStatus.Dirty.getCode());
            staticEntityRepository.update(attr);
        }
    }

    private boolean isDirtyChange(Map<String, Object> vals, AdmCiTypeAttr entity) {
        if (vals.get("length") != null && !DataTypeConverter.convertToInteger(vals.get("length")).equals(entity.getLength())) {
            return true;
        }

        if (vals.get("description") != null && !vals.get("description").equals(entity.getDescription())) {
            return true;
        }

        if (vals.get("isNullable") != null && !DataTypeConverter.convertToInteger(vals.get("isNullable")).equals(entity.getEditIsNull())) {
            return true;
        }
        return false;
    }

    private void handleRefAttrWithAutoFillLengthForCreate(AdmCiTypeAttr domainBean) {
        Integer autoFillLength = getAutoFillLength(domainBean.getInputType());
        if (autoFillLength != null) {
            domainBean.setLength(autoFillLength);
        }
    }

    private Integer getAutoFillLength(String inputType) {
        Integer autoFillLength = null;
        switch (InputType.fromCode(inputType)) {
        case Reference:
        case Orchestration:
            autoFillLength = CmdbConstants.DEFAULT_LENGTH_OF_GUID;
            break;
        case MultRef:
        case OrchestrationMuliRef:
            autoFillLength = CmdbConstants.DEFAULT_LENGTH_OF_MULTIPLE_REF;
            break;
        case Droplist:
            autoFillLength = CmdbConstants.DEFAULT_LENGTH_OF_SELECT;
            break;
        case MultSelDroplist:
            autoFillLength = CmdbConstants.DEFAULT_LENGTH_OF_MULTIPLE_SELECT;
            break;
        default:
            break;
        }

        return autoFillLength;
    }

    private void validatePropertyName(Object oldPropertyName, Object propertyName, Integer ciTypeId) {
        if (propertyName != null) {
            String propertyNameStr = (String)propertyName;
            if (CmdbConstants.MYSQL_SCHEMA_KEYWORDS.contains(propertyNameStr.trim().toUpperCase())) {
                throw new InvalidArgumentException(String.format("Invalid property name [%s] as it is database key words.", propertyNameStr));
            }

            if (!propertyNameStr.equals(oldPropertyName) && ciTypeAttrRepository.existsByPropertyNameAndCiTypeId(propertyNameStr, ciTypeId)) {
                throw new InvalidArgumentException(String.format("Property name [%s] already existed for ciType [%s(%d)]", propertyNameStr, getCiTypeName(ciTypeId), ciTypeId));
            }

            if (propertyNameStr.length() > CmdbConstants.MAX_LENGTH_OF_COLUMN) {
                throw new InvalidArgumentException(String.format("Field propertyName [%s] is too long, max length is [%d]", propertyNameStr, CmdbConstants.MAX_LENGTH_OF_COLUMN));
            }

            if (!Pattern.matches("[a-zA-Z0-9_]+", propertyNameStr)) {
                throw new InvalidArgumentException(String.format("Field propertyName [%s] must be composed by letters, '_' or numbers", propertyNameStr));
            }

            if (StringUtils.isAllUpperCase(propertyNameStr.toString().substring(0, 1))) {
                throw new InvalidArgumentException(String.format("Field propertyName [%s] must be start with lowercase.", propertyNameStr));
            }
        }
    }

    private void validatePropertyTypeAndLength(String propertyType, Integer length, Integer ciTypeId) {
        if (propertyType == null) {
            throw new InvalidArgumentException("Field 'propertyType' is required.");
        }

        switch (FieldType.fromCode(propertyType)) {
        case Varchar:
        case Int:
            if (length == null) {
                throw new InvalidArgumentException(String.format("Length can not be null for property type [%s]", propertyType));
            }

            if (length < 0) {
                throw new InvalidArgumentException(String.format("Invalid length [%d], it should be > 0", length));
            }
            break;
        case None:
            throw new ServiceException(String.format("Can not find out class type of property type [%s] for CI type [%s(%d)]", propertyType, getCiTypeName(ciTypeId), ciTypeId));
        default:
            break;
        }
    }

    private void validateCiTypeId(Integer ciTypeId) {
        if (ciTypeId == null) {
            throw new InvalidArgumentException("ciTypeId can not be null.");
        }

        AdmCiType ciType = staticEntityRepository.findEntityById(AdmCiType.class, ciTypeId);
        if (ciType == null) {
            throw new InvalidArgumentException(String.format("Can not find out CiType [%d].", ciTypeId));
        }
    }

    private void validateIfUsedForIntegrateTemplateRelation(Integer id) {
        List<AdmIntegrateTemplateRelation> intTemplRlt = intTemplRltRepository.findByChildRefAttrId(id);
        if (!intTemplRlt.isEmpty()) {
            List<Integer> ids = new ArrayList<>();
            intTemplRlt.forEach(x -> ids.add(x.getIdRelation()));
            throw new InvalidArgumentException(String.format("CiType is used for template relation [%s]", StringUtils.join(ids, ",")));
        }
    }

    private void validateIfUsedForIntegrateTemplateAliasAttr(Integer id) {
        List<AdmIntegrateTemplateAliasAttr> intTemplAliasAttr = intTemplAliasAttrRepository.findByCiTypeAttrId(id);
        if (!intTemplAliasAttr.isEmpty()) {
            List<String> cnAlias = new ArrayList<>();
            intTemplAliasAttr.forEach(x -> cnAlias.add(x.getCnAlias()));
            throw new InvalidArgumentException(String.format("CiType is used for template alias attr [%s]", StringUtils.join(cnAlias, ",")));
        }
    }

    private void validateIfSystemAttr(AdmCiTypeAttr ciTypeAttr) {
        if (ciTypeAttr.getIsSystem() == CmdbConstants.IS_SYSTEM_YES) {
            throw new InvalidArgumentException("System attr is not allow to update/delete.");
        }
    }

    private void validateDeletableStatus(Integer id, AdmCiTypeAttr ciTypeAttr) {
        String status = ciTypeAttr.getStatus();
        if (!CiStatus.fromCode(status).equals(CiStatus.NotCreated)) {
            throw new InvalidArgumentException(String.format("CiType attr's status is [%s], attr is created, [%d] can not be deleted.", status, id));
        }
    }

    private void validateIfAttrExist(Integer id, Optional<AdmCiTypeAttr> ciTypeAttrOpt) {
        if (!ciTypeAttrOpt.isPresent()) {
            throw new InvalidArgumentException(String.format("Can not find out CiTypeAttr [%d]", id));
        }
    }

    private String getCiTypeName(Integer ciTypeId) {
        if (ciTypeId != null) {
            AdmCiType ciType = ciTypeRepository.getOne(ciTypeId);
            if (ciType != null) {
                return ciType.getName();
            }
            return "";
        }
        return "";
    }

}
