package com.webank.cmdb.repository;

import static org.assertj.core.api.Assertions.assertThat;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.config.TestDatabase;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class UserRepositoryTest extends LegacyAbstractBaseControllerTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    public void whenFindRolesByUsernameTwiceThenTheSecondTimeShouldGetFromCache() {
        assertThat(userRepository.findRolesByUserName("mock_user1")).extracting("roleName")
                .containsExactly("SUPER_ADMIN");
        TestDatabase.executeSql(dataSource, "update adm_role set role_name='SUPER_ADMIN_modified' where role_name='SUPER_ADMIN'");
        assertThat(userRepository.findRolesByUserName("mock_user1")).extracting("roleName")
                .containsExactly("SUPER_ADMIN");
    }

}
