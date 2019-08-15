package com.webank.cmdb.repository;

import static com.google.common.collect.Lists.newArrayList;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.groups.Tuple.tuple;

import java.util.List;

import javax.sql.DataSource;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import com.webank.cmdb.config.TestDatabase;
import com.webank.cmdb.domain.AdmRoleCiType;

@SpringBootTest
@RunWith(SpringRunner.class)
@ActiveProfiles("test")
public class RoleCiTypeRepositoryTest {

    @Autowired
    private RoleCiTypeRepository roleCiTypeRepository;

    @Autowired
    private DataSource dataSource;

    @Before
    public void setup() {
        TestDatabase.cleanUpDatabase(dataSource);
        TestDatabase.prepareDatabaseOfLegacyModel(dataSource);
    }

    @Test
    public void findAdmRoleCiTypesByCiTypeIdAndRoleIds() {
        List<AdmRoleCiType> roleCiTypes = roleCiTypeRepository.findAdmRoleCiTypesByCiTypeIdAndRoleIds(1, newArrayList(1));
        assertThat(roleCiTypes).flatExtracting("admRoleCiTypeCtrlAttrs")
                .extracting("creationPermission")
                .containsExactlyInAnyOrder("Y", "N", "N", "N");
        assertThat(roleCiTypes).flatExtracting("admRoleCiTypeCtrlAttrs")
                .flatExtracting("admRoleCiTypeCtrlAttrConditions")
                .extracting("ciTypeAttrId", "admCiTypeAttr.idAdmCiTypeAttr")
                .contains(tuple(11, 11), tuple(12, 12), tuple(13, 13), tuple(14, 14));
    }

}
