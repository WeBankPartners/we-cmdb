package com.webank.cmdb.util;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Component;

import com.webank.cmdb.service.CmdbService;
import com.webank.cmdb.stateTransition.Action;
import com.webank.cmdb.stateTransition.ActionRegistry;

@Component
public class ServiceRegisteProcess implements BeanPostProcessor {
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        if (bean instanceof CmdbService) {
            ServiceRegistry.getInstance().registe((CmdbService) bean);
        } else if (bean instanceof Action) {
            ActionRegistry.getInstance().register((Action) bean);
        }

        return bean;
    }
}
