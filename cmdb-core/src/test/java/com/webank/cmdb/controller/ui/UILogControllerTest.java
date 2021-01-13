package com.webank.cmdb.controller.ui;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.controller.AbstractBaseControllerTest;
import org.junit.Test;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;

import javax.transaction.Transactional;

import java.io.Serializable;
import java.util.Map;

import static com.webank.cmdb.domain.AdmMenu.MENU_ADMIN_QUERY_LOG;
import static com.webank.cmdb.domain.AdmMenu.ROLE_PREFIX;
import static org.hamcrest.CoreMatchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WithMockUser(username = "test", authorities = { ROLE_PREFIX + MENU_ADMIN_QUERY_LOG })
public class UILogControllerTest extends AbstractBaseControllerTest {

    @Test
    public void queryLogWithEmptyQueryObject() throws Exception {
        mvc.perform(post("/ui/v2/log/query").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.statusCode", is("OK")));
        ;
    }

    @Test
    public void queryLogWithNullSorting() throws Exception {
        mvc.perform(post("/ui/v2/log/query").contentType(MediaType.APPLICATION_JSON)
                .content("{\"sorting\": null}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.statusCode", is("OK")));
        ;
    }

    @Test
    public void queryLogWithSorting() throws Exception {
        Map<String, Object> sortingMap = ImmutableMap.of("asc", true, "field", "createdDate");
        Map<String, Object> requestMap = ImmutableMap.of("sorting", sortingMap);

        mvc.perform(post("/ui/v2/log/query").contentType(MediaType.APPLICATION_JSON)
                .content(new ObjectMapper().writeValueAsString(requestMap)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.statusCode", is("OK")));
        ;
    }

}
