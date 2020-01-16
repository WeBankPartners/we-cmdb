package com.webank.plugins.wecmdb.helper;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.webank.plugins.wecmdb.exception.PluginException;

public class ConfirmHelper {
    public static List<String> parseGuid(String guidStr) {
        List<String> guids = new ArrayList<>();
        if (StringUtils.isBlank(guidStr)) {
            return guids;
        }

        if (guidStr.startsWith("[")) {
            if (guidStr.endsWith("]")) {
                guids = Arrays.asList(guidStr.substring(1, guidStr.length() - 1).split(","));
            } else {
                throw new PluginException(String.format("Guid start with '[' must end with ']' as pair.", guidStr));
            }
        } else {
            guids.add(guidStr);
        }
        return guids;
    }
}
