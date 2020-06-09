package com.webank.cmdb.service.impl;

import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_CREATION;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_ENQUIRY;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_EXECUTION;
import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.sql.DataSource;
import javax.transaction.Transactional;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.support.exception.CmdbAccessDeniedException;
import com.webank.cmdb.util.CmdbThreadLocal;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class AuthorizationServiceImplTest extends LegacyAbstractBaseControllerTest {

    @Autowired
    private AuthorizationServiceImpl authorizationService;

    @Autowired
    private DataSource dataSource;

    @Override
    protected void doSetup(DataSource dataSource){
        TestDatabase.executeSqlScript(dataSource, "db/test-data-for-access-control-scenarios.sql");
        authorizationService.setSecurityEnabled(true);
        CmdbThreadLocal.getIntance()
                .putCurrentUser("mock_user1");
    }

    @Override
    protected void doCleanUp(DataSource dataSource){
        authorizationService.setSecurityEnabled(false);
    }

    @Test
    public void givenCreationPermissionsGrantedOnCiTypeLevelWhenPerformingCreationThenShouldBePermitted() {
        int ciTypeId = 1007;
        Map ciData = ImmutableMap.of("guid", "1007_1000000001", "subsys_design", "1002_1000000013", "env", 49);
        authorizationService.authorizeCiData(ciTypeId, ciData, ACTION_CREATION);
    }

    @Test
    @Transactional
    public void givenExecutionPermissionsGrantedOnCiTypeAttributeLevelWhenPerformingExecutionThenShouldBePermitted() {
        int ciTypeId = 1007;
        Map ciData = ImmutableMap.of("guid", "1007_1000000001", "subsys_design", "1002_1000000013", "env", 141);
        authorizationService.authorizeCiData(ciTypeId, ciData, ACTION_EXECUTION);
    }

    @Transactional
    @Test(expected = CmdbAccessDeniedException.class)
    public void givenNoPermissionSetupForEnquiryActionWhenPerformingEnquiryThenShouldBeDenied() throws CmdbAccessDeniedException {
        int ciTypeId = 1007;
        Map ciData = ImmutableMap.of("guid", "1007_1000000001", "subsys_design", "1002_1000000013", "env", 99);
        authorizationService.authorizeCiData(ciTypeId, ciData, ACTION_ENQUIRY);
    }

    @Test
    public void givenPermissionsGrantedOnCiTypeLevelThenShouldBeTreatAsCiTypePermitted() {
        assertThat(authorizationService.isCiTypePermitted(1007, ACTION_CREATION)).isTrue();
    }

    @Test
    public void givenPermissionsGrantedOnCiTypeAttributeLevelThenShouldNotBeTreatAsCiTypePermitted() {
        assertThat(authorizationService.isCiTypePermitted(1007, ACTION_EXECUTION)).isFalse();
    }

    @Transactional
    @Test
    public void givenPermissionsGrantedOnCiTypeAttributeLevelWhenFetchingPermittedDataThenShouldCollectAllConditionSetupValues() {
        List<Map<String, Set<?>>> permittedData = authorizationService.getPermittedData(1007, ACTION_CREATION);
        assertThat(permittedData).flatExtracting("env")
                .contains(141, 142);
        assertThat(permittedData).flatExtracting("subsys_design")
                .contains("1002_1000000013", "1002_1000000014", "1002_1000000015");
    }

    @Transactional
    @Test
    public void whenGetUserAuthorityTwiceThenTheSecondTimeShouldGetFromCache() {
        List<Map<String, Set<?>>> permittedData = authorizationService.getPermittedData(1007, ACTION_CREATION);
        assertThat(permittedData).flatExtracting("env")
                .contains(141, 142);
        assertThat(permittedData).flatExtracting("subsys_design")
                .contains("1002_1000000014", "1002_1000000013", "1002_1000000015");

        TestDatabase.executeSql(dataSource, "delete from adm_role_user where id_adm_role=1 and id_adm_user='1001'");

        permittedData = authorizationService.getPermittedData(1007, ACTION_CREATION);
        assertThat(permittedData).flatExtracting("env")
                .contains(141, 142);
        assertThat(permittedData).flatExtracting("subsys_design")
                .contains("1002_1000000013", "1002_1000000014", "1002_1000000015");

    }
}
