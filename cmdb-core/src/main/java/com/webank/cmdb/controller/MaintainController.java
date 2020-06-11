package com.webank.cmdb.controller;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.dto.FilterRuleDto;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.service.FilterRuleService;
import com.webank.cmdb.util.JsonUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * This controller is for maintaining purpose
 */
@RestController
@RequestMapping("/maintain")
public class MaintainController {
    @Autowired
    private FilterRuleService filterRuleService;

    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;

    @PostMapping("/filterRule/upgrade")
    @ResponseBody
    @Transactional
    public Map upgradeFilterRule(){
        List<AdmCiTypeAttr> attrs = ciTypeAttrRepository.findAllByFilterRuleNotNull();
        if(attrs == null || attrs.size()==0){
            return ImmutableMap.of("result","There is not any filter rule configured in attribute.");
        }

        int processedCount = 0;
        List<Integer> failedAttrIds = new LinkedList<>();

        for (AdmCiTypeAttr attr : attrs) {
            String legacyFilterRule = attr.getFilterRule();
            if(Strings.isNullOrEmpty(legacyFilterRule)){
                continue;
            }

            FilterRuleDto filterRuleDto = filterRuleService.convertLegacyFilterRule(legacyFilterRule);
            if(filterRuleDto != null) {
                String filterRule = JsonUtil.toJsonString(filterRuleDto);
                attr.setFilterRule(filterRule);
                ciTypeAttrRepository.save(attr);
                processedCount++;
            }else{
                failedAttrIds.add(attr.getIdAdmCiTypeAttr());
            }
        }
        return ImmutableMap.of("processedCount",processedCount,"failedAttrIds",failedAttrIds);
    }
}
