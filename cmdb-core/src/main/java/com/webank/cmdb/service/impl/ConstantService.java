package com.webank.cmdb.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.webank.cmdb.constant.CiStatus;
import static com.webank.cmdb.constant.CmdbConstants.SYMBOL_AND;
import static com.webank.cmdb.constant.CmdbConstants.SYMBOL_EQUALSIGN;
import com.webank.cmdb.constant.EffectiveStatus;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.ReferenceType;
import com.webank.cmdb.util.SpecialSymbolUtils;

@Service
public class ConstantService {
    public List<String> getCiStatus() {
        List<String> statuses = Lists.newLinkedList();
        for (CiStatus status : CiStatus.values()) {
            if (CiStatus.None.equals(status))
                continue;

            statuses.add(status.getCode());
        }
        return statuses;
    }

    public List<String> getReferenceTypes() {
        List<String> referenceTypes = Lists.newLinkedList();
        for (ReferenceType referenceType : ReferenceType.values()) {
            if (ReferenceType.None.equals(referenceType))
                continue;

            referenceTypes.add(referenceType.getCode());
        }
        return referenceTypes;
    }

    public List<String> getInputTypes() {
        List<String> inputTypes = Lists.newLinkedList();
        for (InputType inputType : InputType.values()) {
            if (InputType.None.equals(inputType))
                continue;

            inputTypes.add(inputType.getCode());
        }
        return inputTypes;
    }

    public List<String> getEffectiveStatus() {
        List<String> effectiveStatus = Lists.newLinkedList();
        for (EffectiveStatus status : EffectiveStatus.values()) {
            if (EffectiveStatus.None.equals(status))
                continue;

            effectiveStatus.add(status.getCode());
        }
        return effectiveStatus;
    }

    public List<Map<Object, Object>> getFilterOperator() {
        List<Map<Object, Object>> filterOperatorList = Lists.newLinkedList();
        for (FilterOperator status : FilterOperator.values()) {
            if (FilterOperator.None.equals(status))
                continue;
            HashMap<Object, Object> filterOperatorMap = Maps.newHashMap();
            filterOperatorMap.put("code", status.getCode());
            filterOperatorMap.put("value", status.name());
            filterOperatorList.add(filterOperatorMap);
        }
        return filterOperatorList;
    }

    public Object getSpecialConnector() {
        List<Map<Object, Object>> specialConnector = Lists.newLinkedList();

        Map<Object, Object> and = Maps.newHashMap();
        and.put("code", SpecialSymbolUtils.getAroundSpecialSymbol(SYMBOL_AND));
        and.put("value", SYMBOL_AND);
        specialConnector.add(and);

        Map<Object, Object> equal = Maps.newHashMap();
        equal.put("code", SpecialSymbolUtils.getAroundSpecialSymbol(SYMBOL_EQUALSIGN));
        equal.put("value", SYMBOL_EQUALSIGN);
        specialConnector.add(equal);

        return specialConnector;
    }

}
