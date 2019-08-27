package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.MENU_QUERY_CONFIG;
import static com.webank.cmdb.domain.AdmMenu.ROLE_PREFIX;
import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.Map;

import javax.persistence.EntityManager;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MvcResult;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.service.impl.AuthorizationServiceImpl;
import com.webank.cmdb.util.JsonUtil;

@TestPropertySource(properties = "spring.cache.type=none")
@WithMockUser(username = "mock_user1", authorities = { ROLE_PREFIX + MENU_QUERY_CONFIG })
public class AccessControlTest extends AbstractBaseControllerTest {

    @Autowired
    private AuthorizationServiceImpl authorizationService;

    @Autowired
    private EntityManager entityManager;

    @Before
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
        TestDatabase.executeSqlScript(dataSource, "db/test-data-for-access-control-scenarios.sql");
        authorizationService.setSecurityEnabled(true);

        reload();
        Mockito.when(databaseService.isTableExisted(Mockito.anyString()))
                .thenReturn(false);

    }

    @After
    public void cleanUp() {
        super.cleanUp();
        authorizationService.setSecurityEnabled(false);
    }

    @Test
    public void givenNoneCreationPermissionsSetupWhenPerformingCreationThenShouldBeDenied() throws Exception {
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','N','N','N','N','N','N')" + ",(2, 1,1002,'子系统设计','N','N','N','Y','N','N')" + ";");

        int ciTypeId = 1007;
        Map ciData = ImmutableMap.of("guid", "1007_0000000001", "subsys_design", "1002_1000000013", "env", 141, "code", "mock_code", "state", 141);

        String reqJson = JsonUtil.toJson(ciData);
        mvc.perform(post("/ciType/{ciTypeId}/ci/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERROR")))
                .andExpect(jsonPath("$.statusMessage", is("Access denied. No Creation permission on ci-type[1007] found for mock_user1")));
    }

    @Test
    public void givenCreationPermissionsGrantedOnCiTypeLevelWhenPerformingCreationThenShouldBePermitted() throws Exception {
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','Y','N','N','N','N','N')" + ",(2, 1,1002,'子系统设计','N','N','N','Y','N','N')" + ";");

        int ciTypeId = 1007;
        Map ciData = ImmutableMap.of("guid", "1007_0000000001", "subsys_design", "1002_1000000013", "env", 141, "code", "mock_code", "state", 141);

        String reqJson = JsonUtil.toJson(ciData);
        mvc.perform(post("/ciType/{ciTypeId}/ci/add", ciTypeId).contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.id", notNullValue()));
    }

    @Test
    public void givenModificationPermissionsGrantOnCiTypeAttributeLevelWhenPerformingUpdateThenShouldBePermittedOrDeniedBasedOnTheRule() throws Exception {
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','N','N','N','N','N','N')" + ",(2, 1,1002,'子系统设计','N','N','N','Y','N','N')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr (id_adm_role_ci_type_ctrl_attr, id_adm_role_ci_type,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + "(1, 1,'N','N','Y','N','N','N')" + ";" + "INSERT INTO adm_role_ci_type_ctrl_attr_condition (id_adm_role_ci_type_ctrl_attr,id_adm_ci_type_attr,ci_type_attr_name,condition_value, condition_value_type) VALUES"
                + " (1,10109,'子系统设计','1002_1000000013, 1002_1000000014', 'GUID')" + ",(1,10110,'环境','141', 'ID')" + ";");

        int ciTypeId = 1007;

        // Permission denied on existing data
        Map ciData = ImmutableMap.of("guid", "1007_1000000002", "subsys_design", "1002_1000000013", "env", 141, "code", "UPDATED_CODE", "state", 141);
        String reqJson = JsonUtil.toJson(ciData);
        mvc.perform(post("/ciType/{ciTypeId}/ci/{guid}/update", ciTypeId, "1007_1000000002").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERROR")))
                .andExpect(jsonPath("$.statusMessage", is("Access denied. No Modification permission on ci-type[1007] found for mock_user1")));

        // Permission denied on incoming data
        ciData = ImmutableMap.of("guid", "1007_1000000001", "subsys_design", "1002_1000000013", "env", 142, "code", "UPDATED_CODE", "state", 141);
        reqJson = JsonUtil.toJson(ciData);
        mvc.perform(post("/ciType/{ciTypeId}/ci/{guid}/update", ciTypeId, "1007_1000000001").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("ERROR")))
                .andExpect(jsonPath("$.statusMessage", is("Access denied. No Modification permission on ci-type[1007] found for mock_user1")));

        // Permission granted on both existing data and incoming data
        ciData = ImmutableMap.of("guid", "1007_1000000001", "subsys_design", "1002_1000000013", "env", 141, "code", "UPDATED_CODE", "state", 141);
        reqJson = JsonUtil.toJson(ciData);
        mvc.perform(post("/ciType/{ciTypeId}/ci/{guid}/update", ciTypeId, "1007_1000000001").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", is("Success")));
    }

    @Test
    public void givenNonePermissionSetupForEnquiryActionWhenPerformingEnquiryThenShouldReturnGuidAndKeyNameAndGuidOnly() throws Exception {
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','N','N','N','N','N','N')" + ",(2, 1,1002,'子系统设计','N','N','N','N','N','N')" + ";");

        MvcResult mvcResult = mvc.perform(get("/ciType/{ciTypeId}/ci/{guid}", 1007, "1007_1000000002").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andReturn();
        String responseBody = mvcResult.getResponse()
                .getContentAsString();
        assertThat(responseBody).isEqualTo("{\"statusCode\":\"OK\",\"data\":{\"key_name\":\"WECUBE-DEMO2\",\"guid\":\"1007_1000000002\"}}");
    }

    @Test
    public void givenNonePermissionSetupForEnquiryActionWhenPerformingEnquiryAllThenShouldReturnEmptyData() throws Exception {
        mvc.perform(post("/ciType/{ciTypeId}/cis", 1007).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.pageInfo.totalRows", is(0)));
    }

    @Test
    public void givenEnquiryPermissionsGrantedWhenExecutingIntegrationQueryThenShouldReturnGrantedData() throws Exception {
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','N','N','N','N','N','N')" + ",(2, 1,1002,'子系统设计','N','N','N','Y','N','N')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr (id_adm_role_ci_type_ctrl_attr, id_adm_role_ci_type,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,'N','N','N','Y','N','N')" + ",(2, 1,'N','N','N','Y','N','N')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr_condition (id_adm_role_ci_type_ctrl_attr,id_adm_ci_type_attr,ci_type_attr_name,condition_value, condition_value_type) VALUES"
                + " (1,10109,'子系统设计','1002_1000000013, 1002_1000000015', 'GUID')" + ",(1,10110,'环境','141', 'ID')" + ",(2,10109,'子系统设计','1002_1000000014, 1002_1000000015', 'GUID')" + ",(2,10110,'环境','142', 'ID')" + ";");

        int queryId = 11;

        mvc.perform(post("/api/v2/intQuery/{queryId}/execute", queryId).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.pageInfo.totalRows", is(2)))
                .andExpect(jsonPath("$.data.contents[*].subsys$key_name", contains("WECUBE-DEMO1", "WECUBE-DEMO2")))
                .andExpect(jsonPath("$.data.contents[*].subsys-subsysDesign$key_name", contains("WECUBE-DEMO", "EDP-CLIENT")));
    }

    @Test
    public void givenEnquiryPermissionsGrantedWhenExecutingAdHocIntegrationQueryThenShouldReturnGrantedData() throws Exception {
        TestDatabase.executeSql(dataSource, "delete from adm_role_ci_type;"
                + "INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,1007,'子系统','N','N','N','N','N','N')" + ",(2, 1,1002,'子系统设计','N','N','N','Y','N','N')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr (id_adm_role_ci_type_ctrl_attr, id_adm_role_ci_type,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES"
                + " (1, 1,'N','N','N','Y','N','N')" + ",(2, 1,'N','N','N','Y','N','N')" + ";"
                + "INSERT INTO adm_role_ci_type_ctrl_attr_condition (id_adm_role_ci_type_ctrl_attr,id_adm_ci_type_attr,ci_type_attr_name,condition_value, condition_value_type) VALUES"
                + " (1,10109,'子系统设计','1002_1000000013, 1002_1000000015', 'GUID')" + ",(1,10110,'环境','141', 'ID')" + ",(2,10109,'子系统设计','1002_1000000014, 1002_1000000015', 'GUID')" + ",(2,10110,'环境','142', 'ID')" + ";");

        String reqJson = JsonUtil.toJsonString(mockAdhocIntegrationQueryDto());

        mvc.perform(post("/api/v2/intQuery/adhoc/execute").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.pageInfo.totalRows", is(2)))
                .andExpect(jsonPath("$.data.contents[*].subsys$key_name", contains("WECUBE-DEMO1", "WECUBE-DEMO2")))
                .andExpect(jsonPath("$.data.contents[*].subsys-subsysDesign$key_name", contains("WECUBE-DEMO", "EDP-CLIENT")));
    }

    private AdhocIntegrationQueryDto mockAdhocIntegrationQueryDto() {
        AdhocIntegrationQueryDto adhocIntegrationQueryDto = new AdhocIntegrationQueryDto();
        adhocIntegrationQueryDto.setCriteria(mockSubSysIntegrationQueryDto());
        adhocIntegrationQueryDto.setQueryRequest(new QueryRequest());
        return adhocIntegrationQueryDto;
    }

    private IntegrationQueryDto mockSubSysIntegrationQueryDto() {
        IntegrationQueryDto integrationQueryDto = new IntegrationQueryDto();
        integrationQueryDto.setName("subsys");
        integrationQueryDto.setCiTypeId(1007);
        integrationQueryDto.setAttrs(Lists.newArrayList(10104));
        integrationQueryDto.setAttrAliases(Lists.newArrayList("subsys$key_name"));
        integrationQueryDto.setAttrKeyNames(Lists.newArrayList("subsys$key_name"));
        integrationQueryDto.setChildren(Lists.newArrayList(mockSubSysDesignIntegrationQueryDto()));
        return integrationQueryDto;
    }

    private IntegrationQueryDto mockSubSysDesignIntegrationQueryDto() {
        IntegrationQueryDto integrationQueryDto = new IntegrationQueryDto();
        integrationQueryDto.setName("subsys-subsysDesign");
        integrationQueryDto.setCiTypeId(1002);
        integrationQueryDto.setAttrs(Lists.newArrayList(10022));
        integrationQueryDto.setAttrAliases(Lists.newArrayList("subsys-subsysDesign$key_name"));
        integrationQueryDto.setAttrKeyNames(Lists.newArrayList("subsys-subsysDesign$key_name"));
        integrationQueryDto.setParentRs(new Relationship(10109, false));
        return integrationQueryDto;
    }

}
