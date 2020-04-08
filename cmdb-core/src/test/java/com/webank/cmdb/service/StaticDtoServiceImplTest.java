package com.webank.cmdb.service;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.nullValue;
import static org.junit.Assert.assertThat;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.webank.cmdb.controller.LegacyAbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.google.common.collect.ImmutableMap;
import com.webank.cmdb.constant.CiStatus;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.dto.CatCodeDto;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class StaticDtoServiceImplTest  extends LegacyAbstractBaseControllerTest {
    @Autowired
    private StaticDtoService staticDtoService;

    @Test
    public void queryCiTypeDtoWithoutFilterThenResultAllResult() {
        QueryRequest request = new QueryRequest();
        QueryResponse<CiTypeDto> response = staticDtoService.query(CiTypeDto.class, request);
        assertThat(response.getContents()
                .size(), equalTo(27));
    }

    @Test
    public void createDomainThenTheNewOneCanBeQuery() {
        CatTypeDto catTypeDto1 = new CatTypeDto();
        String catTypeNamePrefix = "New Type";
        catTypeDto1.setCatTypeName(catTypeNamePrefix + "1");
        catTypeDto1.setDescription("New desc 1");

        CatTypeDto catTypeDto2 = new CatTypeDto();
        catTypeDto2.setCatTypeName(catTypeNamePrefix + "2");
        catTypeDto2.setDescription("New desc 2");

        List<CatTypeDto> catTypeDtos = new LinkedList<CatTypeDto>();
        catTypeDtos.add(catTypeDto1);
        catTypeDtos.add(catTypeDto2);

        staticDtoService.create(CatTypeDto.class, catTypeDtos);

        QueryRequest request = new QueryRequest();
        request.getFilters()
                .add(new Filter("catTypeName", FilterOperator.Contains.getCode(), catTypeNamePrefix));
        request.setPaging(false);
        QueryResponse response = staticDtoService.query(CatTypeDto.class, request);
        assertThat(response.getContents()
                .size(), equalTo(2));
    }

    @Test
    public void updateCatCodeThenTheNewDataCanBeQueried() {
        Map<String, Object> updateMap = ImmutableMap.of("codeId", 4, "code", "Catalog new");
        staticDtoService.update(CatCodeDto.class, Arrays.asList(updateMap));

        QueryRequest request = new QueryRequest();
        request.getFilters()
                .add(new Filter("codeId", FilterOperator.Equal.getCode(), 4));
        request.setPaging(false);
        QueryResponse response = staticDtoService.query(CatCodeDto.class, request);
        assertThat(response.getContents()
                .size(), equalTo(1));

    }

    @Test
    public void updateStatusFieldOfCiTypeThenStatusIsIgnored() {
        Map<String, Object> updateMap = ImmutableMap.of("ciTypeId", 2, "status", CiStatus.Decommissioned);
        List<CiTypeDto> updatedList = staticDtoService.update(CiTypeDto.class, Arrays.asList(updateMap));
        assertThat(updatedList.size(), equalTo(1));
        assertThat(updatedList.get(0)
                .getSeqNo(), not(CiStatus.Decommissioned.getCode()));
    }

    @Test
    public void updateNonStatusFieldOfCiTypeThenUpdateSuccess() {
        Map<String, Object> updateMap = ImmutableMap.of("ciTypeId", 2, "description", "description 1");
        List<CiTypeDto> ciTypeDtos = staticDtoService.update(CiTypeDto.class, Arrays.asList(updateMap));
        assertThat(ciTypeDtos.size(), equalTo(1));
        assertThat(ciTypeDtos.get(0)
                .getErrorMessage(), nullValue());
    }

    @Test
    public void queryOnline1CodeThenReturnResultWithGroupCodeObject() {
        QueryRequest request = new QueryRequest();
        request.getFilters()
                .add(new Filter("codeId", FilterOperator.Equal.getCode(), 557));
        request.setPaging(false);
        QueryResponse<CatCodeDto> response = staticDtoService.query(CatCodeDto.class, request);
        assertThat(response.getContents()
                .size(), equalTo(1));
        assertThat(response.getContents()
                .get(0).getGroupCodeId(), is(instanceOf(CatCodeDto.class)));

    }
}
