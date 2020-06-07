package com.webank.cmdb.service;

import com.webank.cmdb.controller.AbstractBaseControllerTest;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import javax.transaction.Transactional;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.junit.Assert.assertThat;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class RouteQueryExpressionServiceImplTest extends AbstractBaseControllerTest {
    @Autowired
    private RouteQueryExpressionService routeQueryExpressionService;

    @Test
    @Transactional
    public void queryAllNetworkSegmentThenReturnAll(){
        List result = routeQueryExpressionService.executeQuery("network_segment:guid");
        assertThat(result,notNullValue());
        assertThat(result.size(),equalTo(12));
    }

    @Test
    @Transactional
    public void queryNetworkSegmentWithFatherReferenceThenReturnProperRecord(){
        List result = routeQueryExpressionService.executeQuery("network_segment~(f_network_segment)network_segment:guid");
//        List result = routeQueryExpressionService.executeQuery("network_segment[{mask eq 16}].f_network_segment>network_segment:guid");
        assertThat(result,notNullValue());
        assertThat(result.size(),equalTo(8));
    }
}
