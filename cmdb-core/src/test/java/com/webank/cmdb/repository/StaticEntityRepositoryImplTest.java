package com.webank.cmdb.repository;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import java.util.Arrays;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.Lists;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.FilterPath;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.JoinFilter;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class StaticEntityRepositoryImplTest extends LegacyAbstractBaseControllerTest {
    @Autowired
    private StaticEntityRepositoryImpl staticEntityRepositoryImpl;

    @Test
    public void queryCiTypeWithoutAnyFilterThenReturnAllRecords() {
        QueryRequest request = new QueryRequest();
        request.setPaging(false);
        QueryResponse response = staticEntityRepositoryImpl.query(AdmCiType.class, request);
        assertThat(response.getContents()
                .size(), equalTo(27));
    }

    @Test
    public void queryCiTypeWithDiffCaseNameInOperatorFilterThenReturnQualifiedRecords() {
        QueryRequest request = new QueryRequest();
        request.getFilters()
                .add(new Filter("name", FilterOperator.In.getCode(), Arrays.asList("System", "sub system")));
        QueryResponse response = staticEntityRepositoryImpl.query(AdmCiType.class, request);
        assertThat(response.getContents()
                .size(), equalTo(2));
    }

    @Test
    public void queryCiTypeWithNameContainOperatorFilterThenReturnQualifiedRecords() {
        QueryRequest request = new QueryRequest();
        request.getFilters()
                .add(new Filter("name", FilterOperator.Contains.getCode(), "system"));
        QueryResponse response = staticEntityRepositoryImpl.query(AdmCiType.class, request);
        assertThat(response.getContents()
                .size(), equalTo(2));
    }

    @Test
    public void queryAllCiTypeWithPagesize5ThenReturnProperPageInfo() {
        QueryRequest request = new QueryRequest();
        request.setPaging(true);
        request.getPageable()
                .setPageSize(5);
        request.getSorting()
                .setAsc(true);
        request.getSorting()
                .setField("description");

        QueryResponse response = staticEntityRepositoryImpl.query(AdmCiType.class, request);
        assertThat(response.getPageInfo()
                .getPageSize(), equalTo(5));
        assertThat(response.getContents()
                .size(), equalTo(5));

        request.getPageable()
                .setPageSize(5);
        request.getPageable()
                .setStartIndex(10);
        response = staticEntityRepositoryImpl.query(AdmCiType.class, request);
        assertThat(response.getPageInfo()
                .getStartIndex(), equalTo(10));
        assertThat(response.getContents()
                .size(), equalTo(5));
    }

    @Test
    public void queryWithEqualsThenReturnProperRecord() {
        QueryRequest request = new QueryRequest();
        request.getFilters()
                .add(new Filter("idAdmCiType", FilterOperator.Equal.getCode(), 2));

        QueryResponse response = staticEntityRepositoryImpl.query(AdmCiType.class, request);
        assertThat(response.getContents()
                .size(), equalTo(1));

    }

    @Test
    public void queryJoinRequest() {
        JoinFilter layerFilter = new JoinFilter("catId", FilterOperator.Equal, 29);
        FilterPath layerPath = new FilterPath("layerCode", Arrays.asList(layerFilter), null);

        JoinFilter attrFilter = new JoinFilter("idAdmCiTypeAttr", FilterOperator.Equal, 1);
        FilterPath attrPath = new FilterPath("admCiTypeAttrs", Arrays.asList(attrFilter), null);

        FilterPath rootPath = new FilterPath(".", Lists.newArrayList(), Arrays.asList(layerPath, attrPath));

        QueryRequest request = new QueryRequest();
//		request.setRootFilterPath(rootPath);
        QueryResponse response = staticEntityRepositoryImpl.queryCrossRes(AdmCiType.class, request, rootPath);
        assertThat(response.getContents()
                .size(), equalTo(1));
    }
}
