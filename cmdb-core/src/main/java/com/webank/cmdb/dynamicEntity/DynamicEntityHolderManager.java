package com.webank.cmdb.dynamicEntity;

import java.util.HashMap;
import java.util.Map;

public class DynamicEntityHolderManager {

    private Map<Integer, DynamicEntityMeta> holderMap = new HashMap<>();

    public DynamicEntityMeta getHolder(int ciTypeId) {
        return holderMap.get(ciTypeId);
    }

}
