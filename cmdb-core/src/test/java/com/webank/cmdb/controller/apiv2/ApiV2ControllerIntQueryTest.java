package com.webank.cmdb.controller.apiv2;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import org.junit.Test;
import org.springframework.http.MediaType;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;

public class ApiV2ControllerIntQueryTest extends LegacyAbstractBaseControllerTest {

    private static final int ciTypeId = 3;

    @Test
    public void getIntegrationQueryWhenSuccess() throws Exception {
        mvc.perform(get("/api/v2/intQuery/{queryId}", 1).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.name", notNullValue()));
    }

    @Test
    public void duplicateIntQueryWhenSuccess() throws Exception {
        mvc.perform(post("/api/v2/intQuery/{queryId}/duplicate", 1).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", notNullValue()));
    }

    @Test
    public void queryIntQueryHeaderWhenSuccess() throws Exception {
        mvc.perform(get("/api/v2/intQuery/{queryId}/header", 1).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data", hasSize(greaterThan(0))));
    }

    @Test
    public void getIntQueryByNameWhenSuccess() throws Exception {
        mvc.perform(get("/api/v2/intQuery/ciType/{ciTypeId}/{queryId}", 21, 1).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.name", notNullValue()));
    }

    @Test
    public void searchIntQueryByCiTypeIdWhenSuccess() throws Exception {
        mvc.perform(get("/api/v2/intQuery/ciType/{ciTypeId}/search", 21).contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].name", notNullValue()));
    }

    @Test
    public void searchIntQueryByCiTypeIdAndNameWhenSuccess() throws Exception {
        mvc.perform(get("/api/v2/intQuery/ciType/{ciTypeId}/search?name={name}", 21, "MockA-MockB").contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].name", notNullValue()));
    }

}
