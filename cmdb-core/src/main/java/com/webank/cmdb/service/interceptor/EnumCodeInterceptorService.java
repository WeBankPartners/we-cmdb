package com.webank.cmdb.service.interceptor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Lists;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.EffectiveStatus;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.service.impl.CiServiceImpl;

@Service
public class EnumCodeInterceptorService extends BasicInterceptorService<CatCodeDto, AdmBasekeyCode> {
    private static Logger logger = LoggerFactory.getLogger(EnumCodeInterceptorService.class);

    public static final String NAME = "EnumCodeInterceptorService";

    @Autowired
    private AdmBasekeyCatRepository catRepository;

    @Autowired
    private AdmBasekeyCodeRepository codeRepository;

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;

    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;

    @Autowired
    private CiServiceImpl ciService;

    @Autowired
    private StaticDtoService staticDtoService;

    @Override
    public String getName() {
        return NAME;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    @Override
    public QueryResponse<?> postQuery(QueryResponse<CatCodeDto> dtoResponse) {
        List<CatCodeDto> codeDtos = dtoResponse.getContents();

        if (codeDtos != null && !codeDtos.isEmpty()) {
            List<CatCodeDto> convertedDtos = Lists.newLinkedList();
            for (CatCodeDto codeDto : codeDtos) {
                if (codeDto.getGroupCodeId() != null && codeDto.getGroupCodeId() instanceof Integer) {
                    enrichGroupCodeId(convertedDtos, codeDto);
                } else {
                    convertedDtos.add(codeDto);
                }
            }

            return new QueryResponse(dtoResponse.getPageInfo(), convertedDtos);
        } else {
            return dtoResponse;
        }
    }

    private void enrichGroupCodeId(List<CatCodeDto> convertedDtos, CatCodeDto codeDto) {
        Optional<AdmBasekeyCode> domainCodeOpt = codeRepository.findById((Integer) codeDto.getGroupCodeId());
        if (!domainCodeOpt.isPresent()) {
            logger.warn("The group code id [{}] is not valid of code [{}].", codeDto.getGroupCodeId(), codeDto.getCodeId());
            convertedDtos.add(codeDto);
        } else {
            CatCodeDto groupCodeDto = CatCodeDto.fromAdmBasekeyCode(domainCodeOpt.get());
            codeDto.setGroupCodeId(groupCodeDto);
            convertedDtos.add(codeDto);
        }
    }

    @PostConstruct
    public void init() {
        staticDtoService.registerInterceptor(CatCodeDto.class.getName(), this);
    }

    @Override
    public void preCreate(CatCodeDto dto, AdmBasekeyCode domainBean) {
        validateRequiredFields(dto);
        validateIfCatIdExist(dto.getCatId());
        validateGroupCodeId(dto.getGroupCodeId());
        validateIfCodeUniqueByCatId(null, dto.getCode(), dto.getCatId(),dto.getGroupCodeId());
        validateIfValueUniqueByCatId(null, dto.getValue(), dto.getCatId(),dto.getGroupCodeId());
        assignSeqNo(domainBean);
        assignDefaultStatus(domainBean);
    }

    private void assignDefaultStatus(AdmBasekeyCode domainBean) {
        if (StringUtils.isBlank(domainBean.getStatus())) {
            domainBean.setStatus(EffectiveStatus.Active.getCode());
        }
    }

    @Override
    public void preUpdate(Integer id, Map<String, Object> vals) {
        validateIfIdAbsent(id);
        AdmBasekeyCode code = codeRepository.getOne(id);
        validateIfCatIdExist(vals.get("catId"));
        validateGroupCodeId(vals.get("groupCodeId"));
        validateIfCodeUniqueByCatId(code, vals.get("code"), vals.get("catId"), vals.get("groupCodeId"));
        validateIfValueUniqueByCatId(code, vals.get("value"), vals.get("catId"), vals.get("groupCodeId"));
        validateStatus(vals);
    }

    @Override
    public void preDelete(Integer id) {
        validateIfIdAbsent(id);
        AdmBasekeyCode code = codeRepository.getOne(id);
        validateIfGroupForOtherCodes(id);
        validateIfUsedForCiType(code);
        validateIfUsedForCiData(code);
    }

    private void validateIfUsedForCiData(AdmBasekeyCode code) {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findByInputTypeAndReferenceId(InputType.Droplist.getCode(), code.getCatId());
        attrs.forEach(attr -> {
            if (isUsedByCiData(attr.getCiTypeId(), attr.getPropertyName(), code.getIdAdmBasekey())) {
                throw new InvalidArgumentException(String.format("Code [%d] is used for ci data [ciTypeId = %s, propertyName = %s]", code.getIdAdmBasekey(), attr.getCiTypeId(), attr.getPropertyName()));
            }
        });
    }

    private boolean isUsedByCiData(Integer ciTypeId, String propertyName, int value) {
        QueryRequest request = new QueryRequest();
        List<Filter> filters = new ArrayList<>();
        Filter filter = new Filter(propertyName, "eq", value);
        filters.add(filter);
        request.setFilters(filters);
        QueryResponse response = ciService.query(ciTypeId, request);
        return response.getContents() != null && !response.getContents().isEmpty();
    }

    private void validateIfUsedForCiType(AdmBasekeyCode code) {
        Optional<AdmBasekeyCat> cat = catRepository.findById(code.getCatId());
        if (cat.isPresent()) {
            if (cat.get().getCatName().equals(CmdbConstants.CI_TYPE_CATALOG) && ciTypeRepository.existsByCatalogId(code.getIdAdmBasekey())) {
                throw new InvalidArgumentException(String.format("Code [value=%s] can not be deleted since it have been used for ci type as catalog [id=%d].", code.getValue(), code.getIdAdmBasekey()));
            }

            if (cat.get().getCatName().equals(CmdbConstants.CI_TYPE_LAYER) && ciTypeRepository.existsByLayerId(code.getIdAdmBasekey())) {
                throw new InvalidArgumentException(String.format("Code [value=%s] can not be deleted since it have been used for ci type as layer [id=%d].", code.getValue(), code.getIdAdmBasekey()));
            }

            if (cat.get().getCatName().equals(CmdbConstants.CI_TYPE_ZOOM_LEVEL) && ciTypeRepository.existsByZoomLevelId(code.getIdAdmBasekey())) {
                throw new InvalidArgumentException(String.format("Code [value=%s] can not be deleted since it have been used for ci type as zoom level [id=%d]", code.getValue(), code.getIdAdmBasekey()));
            }

            if (cat.get().getCatName().equals(CmdbConstants.CI_TYPE_CI_STATE_TYPE) && ciTypeRepository.existsByCiStateTypeId(code.getIdAdmBasekey())) {
                throw new InvalidArgumentException(String.format("Code [value=%s] can not be deleted since it have been used for ci type as ci state type [id=%d]", code.getValue(), code.getIdAdmBasekey()));
            }
        }
    }

    private void validateIfGroupForOtherCodes(Integer id) {
        if (!codeRepository.findByGroupCodeId(id).isEmpty()) {
            throw new InvalidArgumentException(String.format("Code [%d] is used for grouping other codes.", id));
        }
    }

    private void validateIfCodeUniqueByCatId(AdmBasekeyCode oldCode, Object code, Object catId, Object groupCodeId) {
        if (code != null) {
            if (StringUtils.isBlank((String) code)) {
                throw new InvalidArgumentException("Code is not allow to be empty.");
            }

             if (groupCodeId != null) {
            	if (oldCode == null && codeRepository.existsByCatIdAndCodeAndGroupCodeId((Integer) catId, (String) code, (Integer)groupCodeId)) {
		            throw new InvalidArgumentException(String.format("Code with catId [%s] and code [%s] and groupCodeId [%s] already exists.", catId, code, groupCodeId));
            	}
            	
            	if (oldCode != null && codeRepository.existsByCatIdAndCodeAndGroupCodeIdAndIdAdmBasekeyNot((Integer) catId, (String) code, oldCode.getIdAdmBasekey(), (Integer)groupCodeId)) {
		            throw new InvalidArgumentException(String.format("Code with catId [%s] and code [%s] and groupCodeId [%s] already exists.", catId, code, groupCodeId));
            	}
            }else {
            	if (oldCode == null && codeRepository.existsByCatIdAndCode((Integer) catId, (String) code)) {
            		throw new InvalidArgumentException(String.format("Code with catId [%s] and code [%s] already exists.", catId, code));
            	}
            	
            	if (oldCode != null && codeRepository.existsByCatIdAndCodeAndIdAdmBasekeyNot((Integer) catId, (String) code, oldCode.getIdAdmBasekey())) {
            		throw new InvalidArgumentException(String.format("Code with catId [%s] and code [%s] already exists.", catId, code));
            	}
            }
        }
    }

    private void validateIfValueUniqueByCatId(AdmBasekeyCode oldValue, Object value, Object catId, Object groupCodeId) {
        if (value != null) {
            if (StringUtils.isBlank((String) value)) {
                throw new InvalidArgumentException("Value is not allow to be empty.");
            }

            if (groupCodeId != null) {
		        if (oldValue == null && codeRepository.existsByCatIdAndValueAndGroupCodeId((Integer) catId, (String) value, (Integer) groupCodeId)) {
		            throw new InvalidArgumentException(String.format("Code with catId [%s] and value [%s] and groupCodeId [%s] already exists.", catId, value, groupCodeId));
		        }
		
		        if (oldValue != null && codeRepository.existsByCatIdAndValueAndGroupCodeIdAndIdAdmBasekeyNot((Integer) catId, (String) value, oldValue.getIdAdmBasekey(), (Integer) groupCodeId)) {
		            throw new InvalidArgumentException(String.format("Code with catId [%s] and value [%s] and groupCodeId [%s] already exists.", catId, value, groupCodeId));
		        }
            }else {
            	if (oldValue == null && codeRepository.existsByCatIdAndValue((Integer) catId, (String) value)) {
            		throw new InvalidArgumentException(String.format("Code with catId [%s] and value [%s] already exists.", catId, value));
            	}
            	
            	if (oldValue != null && codeRepository.existsByCatIdAndValueAndIdAdmBasekeyNot((Integer) catId, (String) value, oldValue.getIdAdmBasekey())) {
            		throw new InvalidArgumentException(String.format("Code with catId [%s] and value [%s] already exists.", catId, value));
            	}
            }
        }
    }

    private void validateGroupCodeId(Object groupCodeId) {
        if (groupCodeId != null && !codeRepository.existsById((Integer) groupCodeId)) {
            throw new InvalidArgumentException(String.format("Can not find out catGroupCodeId [%s].", groupCodeId));
        }
    }

    private void validateIfCatIdExist(Object catId) {
        if (catId != null && !catRepository.existsById((Integer) catId)) {
            throw new InvalidArgumentException(String.format("Can not find out cat [%s].", catId));
        }
    }

    private void validateRequiredFields(CatCodeDto dto) {
        if (dto.getCatId() == null) {
            throw new InvalidArgumentException("Field 'catId' is required");
        }

        if (dto.getCode() == null) {
            throw new InvalidArgumentException("Field 'code' is required");
        }

        if (dto.getValue() == null) {
            throw new InvalidArgumentException("Field 'value' is required");
        }
    }

    private void assignSeqNo(AdmBasekeyCode domainBean) {
        AdmBasekeyCode lastCodeSeqNo = codeRepository.findFirstByCatIdOrderBySeqNoDesc(domainBean.getCatId());
        if (lastCodeSeqNo == null) {
            domainBean.setSeqNo(1);
        } else {
            if (lastCodeSeqNo.getSeqNo()==null){
                domainBean.setSeqNo(1);
            }else{
                domainBean.setSeqNo(lastCodeSeqNo.getSeqNo() + 1);
            }
        }
    }

    private void validateStatus(Map<String, Object> vals) {
        if (isNotValidStatus(vals)) {
            throw new InvalidArgumentException(String.format("Status [%s] is invalid.", (Integer) vals.get("status")));
        }
    }

    private void validateIfIdAbsent(Integer id) {
        if (id == null) {
            throw new InvalidArgumentException("Field 'codeId' is required.");
        }
    }

    private boolean isNotValidStatus(Map<String, Object> vals) {
        return vals != null && vals.get("status") != null && !(EffectiveStatus.Active.getCode().equals(vals.get("status")) || EffectiveStatus.Inactive.getCode().equals(vals.get("status")));
    }
}
