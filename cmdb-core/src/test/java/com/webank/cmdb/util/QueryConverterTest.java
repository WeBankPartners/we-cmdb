package com.webank.cmdb.util;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;

import java.util.Arrays;
import java.util.List;

import org.junit.Test;

import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.dto.CatTypeDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.repository.impl.StaticEntityRepositoryImpl.FilterPath;

public class QueryConverterTest {

    @Test
    public void converFilterWithOneChildLevelThenReturnProperFilterPath() {
        List<Filter> filters = Arrays.asList(new Filter("layerCode.code", FilterOperator.Equal.getCode(), "layer code val"), new Filter("name", FilterOperator.Equal.getCode(), "ci type name val"));
        FilterPath path = QueryConverter.convertFilter(CiTypeDto.class, Arrays.asList("layerCode"), filters);
        assertThat(path.getFilters()
                .size(), equalTo(1));
        assertThat(path.getJoinChildren()
                .size(), equalTo(1));
        assertThat(path.getJoinChildren()
                .get(0)
                .getFilters()
                .size(), equalTo(1));
        assertThat(path.getJoinChildren()
                .get(0)
                .getFilters()
                .get(0)
                .getField(), equalTo("code"));
    }

    @Test
    public void convertFilterWithoutTwoChildLevelThenReturnProperFilterPath() {
        List<Filter> filters = Arrays.asList(new Filter("cats.codes.codeId", FilterOperator.Equal.getCode(), 2));
        FilterPath path = QueryConverter.convertFilter(CatTypeDto.class, Arrays.asList("cats", "cats.codes"), filters);
        assertThat(path.getJoinChildren()
                .size(), equalTo(1));
        assertThat(path.getJoinChildren()
                .get(0)
                .getJoinChildren()
                .size(), equalTo(1));
        assertThat(path.getJoinChildren()
                .get(0)
                .getJoinChildren()
                .get(0)
                .getFilters()
                .size(), equalTo(1));
        assertThat(path.getJoinChildren()
                .get(0)
                .getJoinChildren()
                .get(0)
                .getFilters()
                .get(0)
                .getField(), equalTo("idAdmBasekey"));
    }
}
