package com.webank.cmdb.controller.apiv2;

import static com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition.TYPE_EXPRESSION;
import static com.webank.cmdb.domain.AdmRoleCiTypeCtrlAttrCondition.TYPE_ID;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.util.List;

import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.util.CmdbThreadLocal;
import org.junit.Test;
import org.springframework.http.MediaType;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.util.JsonUtil;

import javax.sql.DataSource;

public class ApiV2ControllerRoleCiTypeCtrlAttrConditionTest extends LegacyAbstractBaseControllerTest {
    @Override
    protected void doSetup(DataSource dataSource){
        TestDatabase.executeSqlScript(dataSource, "db/test-data-for-access-control-scenarios.sql");
        CmdbThreadLocal.getIntance()
                .putCurrentUser("mock_user1");
    }

    @Test
    public void whenCreateRoleCiTypeCtrlAttrConditionShouldReturnRoleId() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("roleCiTypeCtrlAttrId", 3)
                        .put("ciTypeAttrId", 10109)
                        .put("conditionValueExprs", Lists.newArrayList("subsys_design[{key_name eq 'WECUBE-DEMO'}]:guid"))
                        .put("conditionType", "Expression")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-citype-ctrl-attr-conditions/create").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].conditionId", greaterThanOrEqualTo(1)))
                .andExpect(jsonPath("$.data[0].conditionType", is("Expression")));
    }

    @Test
    public void whenUpdateRoleCiTypeCtrlAttrConditionShouldSuccess() throws Exception {
        List<?> jsonList = ImmutableList.builder()
                .add(ImmutableMap.builder()
                        .put("callbackId", "123456")
                        .put("conditionId", 1)
                        .put("conditionValue", "updatedConditionValue")
                        .put("conditionType", "Expression")
                        .build())
                .build();
        String reqJson = JsonUtil.toJson(jsonList);
        mvc.perform(post("/api/v2/role-citype-ctrl-attr-conditions/update").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data[0].conditionId", is(1)))
                .andExpect(jsonPath("$.data[0].conditionValue", is("updatedConditionValue")))
                .andExpect(jsonPath("$.data[0].conditionType", is(TYPE_EXPRESSION)));
    }

    @Test
    public void whenDeleteRoleCiTypeCtrlAttrConditionShouldSuccess() throws Exception {
        QueryRequest queryRequest = new QueryRequest();
        queryRequest.getFilters()
                .add(new Filter("conditionId", "in", Lists.newArrayList(1, 2, 3)));
        String reqJson = JsonUtil.toJsonString(queryRequest);
        mvc.perform(post("/api/v2/role-citype-ctrl-attr-conditions/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].conditionId", contains(1, 2, 3)));

        mvc.perform(post("/api/v2/role-citype-ctrl-attr-conditions/delete").contentType(MediaType.APPLICATION_JSON)
                .content("[2,3]"))
                .andExpect(jsonPath("$.statusCode", is("OK")));

        mvc.perform(post("/api/v2/role-citype-ctrl-attr-conditions/retrieve").contentType(MediaType.APPLICATION_JSON)
                .content(reqJson))
                .andExpect(jsonPath("$.statusCode", is("OK")))
                .andExpect(jsonPath("$.data.contents[*].conditionId", contains(1)));
    }
}
