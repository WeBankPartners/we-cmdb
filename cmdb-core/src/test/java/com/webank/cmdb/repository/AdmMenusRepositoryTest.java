package com.webank.cmdb.repository;

import static org.assertj.core.api.Assertions.assertThat;

import javax.sql.DataSource;

import org.junit.Before;
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
public class AdmMenusRepositoryTest {
	@Autowired
	private AdmMenusRepository admMenusRepository;
	
	@Autowired
	private DataSource dataSource;

    @Before
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
    }

    @Test
    public void findMenusByUserName() {
    	assertThat(admMenusRepository.findMenusByUserName("mock_user1")).extracting("name").contains("menuA");
    }
}
