package com.webank.plugins.wecmdb.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "plugins")
@Data
public class PluginApplicationProperties {
    private String gatewayUrl;
    private String packageName;
    private String propertyEncryptKeyPath;
    private Boolean keepDataModelSync;
}
