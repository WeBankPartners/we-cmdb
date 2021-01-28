package com.webank.cmdb.controller.ui;

import com.webank.cmdb.controller.AbstractBaseControllerTest;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;

import static com.webank.cmdb.domain.AdmMenu.*;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class UIEnumManagementControllerTest extends AbstractBaseControllerTest {
    private static final String QUERY_SYSTEM_CODE_URL = "/ui/v2/enum/system/codes";
    private static final String QUERY_NON_SYSTEM_CODE_URL = "/ui/v2/enum/non-system/codes";

    @Test
    @WithMockUser(value = "test")
    public void querySystemEnum_should_fail_for_user_without_appropriate_menu_permission() throws Exception {
        shouldApiCallFailForInsufficientPermission(QUERY_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_IDC_PLANNING_DESIGN })
    public void querySystemEnum_should_success_for_role_IDC_PLANNING_DESIGN() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_IDC_RESOURCE_PLANNING })
    public void querySystemEnum_should_success_for_role_IDC_RESOURCE_PLANNING() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_APPLICATION_ARCHITECTURE_DESIGN })
    public void querySystemEnum_should_success_for_role_APPLICATION_ARCHITECTURE_DESIGN() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_APPLICATION_ARCHITECTURE_QUERY })
    public void querySystemEnum_should_success_for_role_APPLICATION_ARCHITECTURE_QUERY() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_APPLICATION_DEPLOYMENT_DESIGN })
    public void querySystemEnum_should_success_for_role_APPLICATION_DEPLOYMENT_DESIGN() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_SYSTEM_CODE_URL);
    }


    @Test
    @WithMockUser(value = "test")
    public void queryNonSystemEnum_should_fail_for_user_without_appropriate_menu_permission() throws Exception {
        shouldApiCallFailForInsufficientPermission(QUERY_NON_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_IDC_PLANNING_DESIGN })
    public void queryNonSystemEnum_should_success_for_role_IDC_PLANNING_DESIGN() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_NON_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_IDC_RESOURCE_PLANNING })
    public void queryNonSystemEnum_should_success_for_role_IDC_RESOURCE_PLANNING() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_NON_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_APPLICATION_ARCHITECTURE_DESIGN })
    public void queryNonSystemEnum_should_success_for_role_APPLICATION_ARCHITECTURE_DESIGN() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_NON_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_APPLICATION_ARCHITECTURE_QUERY })
    public void queryNonSystemEnum_should_success_for_role_APPLICATION_ARCHITECTURE_QUERY() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_NON_SYSTEM_CODE_URL);
    }

    @Test
    @WithMockUser(value = "test", authorities = { ROLE_PREFIX + MENU_APPLICATION_DEPLOYMENT_DESIGN })
    public void queryNonSystemEnum_should_success_for_role_APPLICATION_DEPLOYMENT_DESIGN() throws Exception {
        shouldApiCallSucceedSucceed(QUERY_NON_SYSTEM_CODE_URL);
    }

    private void shouldApiCallSucceedSucceed(String url) throws Exception {
        mvc.perform(post(url)
                .contentType(MediaType.APPLICATION_JSON_UTF8).content("{}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", notNullValue()))
        ;
    }

    private void shouldApiCallFailForInsufficientPermission(String url) throws Exception {
        mvc.perform(post(url)
                .contentType(MediaType.APPLICATION_JSON_UTF8).content("{}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.statusCode", is("ERROR")))
                .andExpect(jsonPath("$.statusMessage", is("Access is denied")))
        ;
    }
}
