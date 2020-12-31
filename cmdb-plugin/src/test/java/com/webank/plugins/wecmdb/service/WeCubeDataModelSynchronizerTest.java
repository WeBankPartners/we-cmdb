package com.webank.plugins.wecmdb.service;

import com.webank.cmdb.controller.AbstractBaseControllerTest;
import org.junit.Ignore;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.TestPropertySource;

@TestPropertySource(properties="plugins.gateway-url=http://81.71.133.151:19090/")
@Ignore("Actually a integration test requiring WeCube platform")
public class WeCubeDataModelSynchronizerTest extends AbstractBaseControllerTest {
    @Autowired
    WeCubeDataModelSynchronizer weCubeDataModelSynchronizer;

    @Test
    @WithMockUser(
            username = "mockUser",
           ***REMOVED***"
    )
    public void test() {
        weCubeDataModelSynchronizer.synchronize().block();
    }
}
