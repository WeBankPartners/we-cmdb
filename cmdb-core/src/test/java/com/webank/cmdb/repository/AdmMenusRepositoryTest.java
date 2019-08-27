package com.webank.cmdb.repository;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.controller.AbstractBaseControllerTest;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class AdmMenusRepositoryTest extends AbstractBaseControllerTest {
    @Autowired
    private AdmMenusRepository admMenusRepository;

    @Test
    public void findMenusByUserName() {
        assertThat(admMenusRepository.findMenusByUserName("umadmin")).extracting("name").contains("menuA");
    }
}
