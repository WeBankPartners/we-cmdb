package com.webank.plugins.wecmdb.aop;

import com.webank.cmdb.controller.AbstractBaseControllerTest;
import com.webank.plugins.wecmdb.config.PluginApplicationProperties;
import com.webank.plugins.wecmdb.service.WeCubeDataModelSynchronizer;
import org.junit.After;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.SpyBean;

import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

public class AfterCiTypeAppliedAspectTest extends AbstractBaseControllerTest {
    @Autowired
    PluginApplicationProperties pluginApplicationProperties;
    @SpyBean
    WeCubeDataModelSynchronizer weCubeDataModelSynchronizer;

    @Test
    public void should_NOT_call_WeCubeDataModelSynchronizer_synchronize_when_property_is_NOT_set() {
        pluginApplicationProperties.setKeepDataModelSync(null);
        givenAppliedCiType();
        verify(weCubeDataModelSynchronizer, never()).synchronize();
    }

    @Test
    public void should_NOT_call_WeCubeDataModelSynchronizer_synchronize_when_property_is_FALSE() {
        pluginApplicationProperties.setKeepDataModelSync(false);
        givenAppliedCiType();
        verify(weCubeDataModelSynchronizer, never()).synchronize();
    }

    @Test
    public void should_call_WeCubeDataModelSynchronizer_synchronize_after_ci_type_applied() {
        pluginApplicationProperties.setKeepDataModelSync(true);
        givenAppliedCiType();
        verify(weCubeDataModelSynchronizer).synchronize();
    }

    @After
    public void clear() {
        pluginApplicationProperties.setKeepDataModelSync(false);
    }
}