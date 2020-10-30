package com.webank.plugins.wecmdb.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "plugins")
public class PluginApplicationProperties {
    private String propertyEncryptKeyPath;

    public String getPropertyEncryptKeyPath() {
        return propertyEncryptKeyPath;
    }

    public void setPropertyEncryptKeyPath(String propertyEncryptKeyPath) {
        this.propertyEncryptKeyPath = propertyEncryptKeyPath;
    }
    
    
}
