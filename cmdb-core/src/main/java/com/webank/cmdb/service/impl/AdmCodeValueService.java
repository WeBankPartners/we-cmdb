package com.webank.cmdb.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.webank.cmdb.domain.AdmCodeValue;
import com.webank.cmdb.repository.CodeValueRepository;
import com.webank.cmdb.util.SpringUtils;
@Component
public class AdmCodeValueService {
    private static Map<String, String> codeValue = new HashMap<String, String>();
   
    @Autowired
    private CodeValueRepository codeValueRepository;

    public String getValueByCode(String Code) {
        if (codeValue.size() < 1) {
            getMap();
        }
        return codeValue.get(Code).toString();
    }

    private void getMap() {
        CodeValueRepository bean = SpringUtils.getBean(CodeValueRepository.class);
        List<AdmCodeValue> resultList = bean.findAll();
        resultList.forEach(c -> {
            codeValue.put(c.getCode(), c.getValue());
        });
    }
}
