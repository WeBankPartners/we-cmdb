package com.webank.cmdb.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.transaction.Transactional;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.ui.helper.AdmCiTypeCachingService;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.AutoFillIntegrationQueryDto;
import com.webank.cmdb.dto.AutoFillIntegrationQueryExDto;
import com.webank.cmdb.dto.AutoFillItem;
import com.webank.cmdb.dto.FilterRuleDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dto.RelationshipEx;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.service.FilterRuleService;
import com.webank.cmdb.util.JsonUtil;

/**
 * This controller is for maintaining purpose
 */
@RestController
@RequestMapping("/maintain")
public class MaintainController {
    private static final Logger log = LoggerFactory.getLogger(MaintainController.class);
    @Autowired
    private FilterRuleService filterRuleService;

    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    
    @Autowired
    private AdmCiTypeCachingService admCiTypeCachingService;

    @PostMapping("/filterRule/upgrade")
    @ResponseBody
    @Transactional
    public Map upgradeFilterRule() {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByFilterRuleNotNull();
        if (attrs == null || attrs.size() == 0) {
            return ImmutableMap.of("result", "There is not any filter rule configured in attribute.");
        }

        int processedCount = 0;
        List<Integer> failedAttrIds = new LinkedList<>();

        for (AdmCiTypeAttr attr : attrs) {
            String legacyFilterRule = attr.getFilterRule();
            if (Strings.isNullOrEmpty(legacyFilterRule)) {
                continue;
            }

            FilterRuleDto filterRuleDto = filterRuleService.convertLegacyFilterRule(legacyFilterRule);
            if (filterRuleDto != null) {
                String filterRule = JsonUtil.toJsonString(filterRuleDto);
                attr.setFilterRule(filterRule);
                ciTypeAttrRepository.save(attr);
                processedCount++;
            } else {
                failedAttrIds.add(attr.getIdAdmCiTypeAttr());
            }
        }
        return ImmutableMap.of("processedCount", processedCount, "failedAttrIds", failedAttrIds);
    }

    @PostMapping("/autoFillRule/upgrade")
    @ResponseBody
    @Transactional
    public String upgradeAutoFillRule() throws IOException {
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAll();
        int count = 0;
        for (AdmCiTypeAttr attr : attrs) {
            if (attr.getIsAuto() != 1) {
                continue;
            }

            if (StringUtils.isBlank(attr.getAutoFillRule())) {
                continue;
            }

            String autoFillValueStr = upgradeAutoFillRuleToTableNames(attr.getAutoFillRule());
            attr.setAutoFillRule(autoFillValueStr);
            ciTypeAttrRepository.saveAndFlush(attr);
            
            count++;
        }

        admCiTypeCachingService.forceRefresh();
        return String.format("Total %s auto fill rules upgraded.", count);
    }

    private String upgradeAutoFillRuleToTableNames(String autoFillValueStr) throws IOException {
        List<AutoFillItem> autoFillItems = JsonUtil.toList(autoFillValueStr, AutoFillItem.class);
        List<AutoFillItem> exAutoFillItems = new ArrayList<>();

        String reg = "\"ciTypeId\":\\d+[},]";
        Pattern r = Pattern.compile(reg);
        for (AutoFillItem autoFillItem : autoFillItems) {
            log.info("before upgrade: {}", autoFillItem.getValue());
            AutoFillItem exAutoFillItem = new AutoFillItem();
            exAutoFillItem.setType(autoFillItem.getType());
            if (!autoFillItem.getType().equals("rule")) {
                exAutoFillItem.setValue(autoFillItem.getValue());
            } else {
                Matcher m = r.matcher(autoFillItem.getValue());

                if (m.find()) {
                    List<AutoFillIntegrationQueryDto> intDtos = JsonUtil.toList(autoFillItem.getValue(),
                            AutoFillIntegrationQueryDto.class);

                    List<AutoFillIntegrationQueryExDto> exIntDtos = new ArrayList<>();
                    for (AutoFillIntegrationQueryDto intDto : intDtos) {
                        AutoFillIntegrationQueryExDto exIntDto = convert(intDto);
                        exIntDtos.add(exIntDto);
                    }

                    String itemJsonValue = JsonUtil.toJson(exIntDtos);
                    exAutoFillItem.setValue(itemJsonValue);
                    log.info("upgraded Json: {} ", itemJsonValue);
                } else {
                    log.info("NOT match: {} ", autoFillItem.getValue());
                    exAutoFillItem.setValue(autoFillItem.getValue());
                }
            }

            exAutoFillItems.add(exAutoFillItem);
        }

        return JsonUtil.toJson(exAutoFillItems);
    }

    private AutoFillIntegrationQueryExDto convert(IntegrationQueryDto intDto) {
        AutoFillIntegrationQueryExDto exIntDto = new AutoFillIntegrationQueryExDto();
        exIntDto.setName(intDto.getName());
        exIntDto.setKeyName(intDto.getKeyName());
        AdmCiType admCiType = ciTypeRepository.findAdmCiTypeAndAttrsById(intDto.getCiTypeId());
        exIntDto.setCiTypeId(admCiType.getTableName());
        exIntDto.setAttrs(intDto.getAttrs());
        exIntDto.setAttrAliases(intDto.getAttrAliases());
        exIntDto.setAggKeyNames(intDto.getAggKeyNames());
        exIntDto.setAttrKeyNames(intDto.getAttrKeyNames());

        if (intDto instanceof AutoFillIntegrationQueryDto) {
            AutoFillIntegrationQueryDto af = (AutoFillIntegrationQueryDto) intDto;
            exIntDto.setEnumCodeAttr(af.getEnumCodeAttr());
        }

        // relation with parent node, it is not needed in root node.
        if (intDto.getParentRs() != null) {
            Relationship rs = intDto.getParentRs();
            RelationshipEx exRs = new RelationshipEx();

            Optional<AdmCiTypeAttr> admCiTypeAttrOpt = ciTypeAttrRepository.findById(rs.getAttrId());
            AdmCiTypeAttr exAttr = admCiTypeAttrOpt.get();
            String exAttrId = String.format("%s#%s", exAttr.getAdmCiType().getTableName(), exAttr.getPropertyName());
            exRs.setAttrId(exAttrId);
            exRs.setIsReferedFromParent(rs.getIsReferedFromParent());
            exIntDto.setParentRs(exRs);
        }

        exIntDto.setFilters(intDto.getFilters());
        for (IntegrationQueryDto c : intDto.getChildren()) {
            AutoFillIntegrationQueryExDto exC = convert(c);

            exIntDto.addChild(exC);
        }

        return exIntDto;

    }
}
