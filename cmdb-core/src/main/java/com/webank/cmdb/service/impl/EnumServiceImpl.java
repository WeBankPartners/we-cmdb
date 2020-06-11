package com.webank.cmdb.service.impl;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.dto.CreationRtnDto;
import com.webank.cmdb.dto.EnumCat;
import com.webank.cmdb.dto.EnumInfo;
import com.webank.cmdb.dto.EnumInfoRequest;
import com.webank.cmdb.dto.EnumInfoResponse;
import com.webank.cmdb.dto.EnumPair;
import com.webank.cmdb.dto.PageInfo;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.EnumInfoRepository;
import com.webank.cmdb.service.BaseKeyInfoService;
import com.webank.cmdb.service.EnumService;

@Service
public class EnumServiceImpl implements EnumService {
    @Autowired
    private AdmBasekeyCatRepository basekeyCatRepository;
    @Autowired
    private EnumInfoRepository enumInfoRepository;

    @Autowired
    private BaseKeyInfoService baseKeyInfoService;

    @Override
    public String getName() {
        return EnumService.NAME;
    }

    @Override
    public EnumInfoResponse queryEnumsInfo(EnumInfoRequest enumInfoReq) {
        List<EnumInfo> enumInfos = enumInfoRepository.queryEnumInfo(enumInfoReq);
        int totalRowCount = enumInfoRepository.getTotalRowCount(enumInfoReq);
        EnumInfoResponse response = new EnumInfoResponse();
        response.setEnumInfos(enumInfos);

        int startIndex = 0;
        if (enumInfoReq.isPaging() == true && enumInfoReq.getPageable() != null) {
            startIndex = enumInfoReq.getPageable().getStartIndex();
            PageInfo pageInfo = new PageInfo(totalRowCount, startIndex, enumInfoReq.getPageable().getPageSize());
            response.setPageInfo(pageInfo);
        } else {
            PageInfo pageInfo = new PageInfo(totalRowCount, 0, 0);
            response.setPageInfo(pageInfo);
        }

        return response;
    }

    private AdmBasekeyCat validateCategory(int catId) {
        Optional<AdmBasekeyCat> basekeyCat = basekeyCatRepository.findById(catId);
        if (!basekeyCat.isPresent()) {
            throw new InvalidArgumentException("The specific category is not existed.", "catId", catId);
        }
        return basekeyCat.get();
    }

    @Override
    public List<EnumPair> queryEnumPairs(int catId) {
        AdmBasekeyCat basekeyCat = validateCategory(catId);
        Set<AdmBasekeyCode> baskeyCodes = basekeyCat.getAdmBasekeyCodes();

        List<EnumPair> enumPairs = new LinkedList<>();
        baskeyCodes.forEach(x -> {
            enumPairs.add(new EnumPair(x.getIdAdmBasekey(), x.getCode(), x.getValue()));
        });
        return enumPairs;
    }

    @Override
    public List<EnumCat> listAllEnumCats() {
        List<EnumCat> enumCats = new LinkedList<>();
        List<AdmBasekeyCat> basekeyCats = basekeyCatRepository.findAll();
        basekeyCats.forEach(x -> {
            enumCats.add(new EnumCat(x.getIdAdmBasekeyCat(), x.getCatName()));
        });
        return enumCats;
    }

    @Override
    public void update(int codeId, EnumInfo enumInfo) {
        baseKeyInfoService.updateCode(codeId, enumInfo.toBaseKeyCodeDto());
    }

    @Override
    public void delete(int codeId) {
        baseKeyInfoService.deleteCode(codeId);
    }

    @Override
    public CreationRtnDto addEnumInfo(int catId, EnumInfo enumInfo) {
        int codeId = baseKeyInfoService.addCode(catId, enumInfo.toBaseKeyCodeDto());
        return new CreationRtnDto(codeId);
    }
}
