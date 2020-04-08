package com.webank.cmdb.service.impl;

import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_CREATION;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_ENQUIRY;
import static com.webank.cmdb.domain.AdmRoleCiTypeActionPermissions.ACTION_EXECUTION;
import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.sql.DataSource;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.exception.CmdbAccessDeniedException;
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
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','Y','Y','N','N','N','N')" + ",(2, 2,1007,'子系统','N','N','N','Y','N','N')" + ",(3, 1,1002,'子系统设计','Y','Y','Y','Y','Y','Y')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr (id_adm_role_ci_type_ctrl_attr, id_adm_role_ci_type,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + "(1, 1,'Y','Y','Y','Y','Y','N')" + ",(2, 1,'Y','Y','Y','Y','Y','N')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr_condition (id_adm_role_ci_type_ctrl_attr,id_adm_ci_type_attr,ci_type_attr_name,condition_value, condition_value_type) VALUES"
                + " (1,10109,'子系统设计','1002_1000000013, 1002_1000000014', 'GUID')" + ",(1,10110,'环境','141', 'ID')" + ",(2,10109,'子系统设计','1002_1000000015', 'GUID')" + ",(2,10110,'环境','142', 'ID')" + ";");
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
    public void givenExecutionPermissionsGrantedOnCiTypeAttributeLevelWhenPerformingExecutionThenShouldBePermitted() {
        int ciTypeId = 1007;
        Map ciData = ImmutableMap.of("guid", "1007_1000000001", "subsys_design", "1002_1000000013", "env", 141);
        authorizationService.authorizeCiData(ciTypeId, ciData, ACTION_EXECUTION);
    }

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

    @Test
    public void givenPermissionsGrantedOnCiTypeAttributeLevelWhenFetchingPermittedDataThenShouldCollectAllConditionSetupValues() {
        List<Map<String, Set<?>>> permittedData = authorizationService.getPermittedData(1007, ACTION_CREATION);
        assertThat(permittedData).flatExtracting("env")
                .contains(141, 142);
        assertThat(permittedData).flatExtracting("subsys_design")
                .contains("1002_1000000013", "1002_1000000014", "1002_1000000015");
    }

    @Test
    public void whenGetUserAuthorityTwiceThenTheSecondTimeShouldGetFromCache() {
        List<Map<String, Set<?>>> permittedData = authorizationService.getPermittedData(1007, ACTION_CREATION);
        assertThat(permittedData).flatExtracting("env")
                .contains(141, 142);
        assertThat(permittedData).flatExtracting("subsys_design")
                .contains("1002_1000000013", "1002_1000000014", "1002_1000000015");

        TestDatabase.executeSql(dataSource, "delete from adm_role_user where id_adm_role=1 and id_adm_user='1001'");

        permittedData = authorizationService.getPermittedData(1007, ACTION_CREATION);
        assertThat(permittedData).flatExtracting("env")
                .contains(141, 142);
        assertThat(permittedData).flatExtracting("subsys_design")
                .contains("1002_1000000013", "1002_1000000014", "1002_1000000015");

    }
}
