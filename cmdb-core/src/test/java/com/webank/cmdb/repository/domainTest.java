package com.webank.cmdb.repository;

import java.util.Arrays;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cglib.beans.BeanMap;

import com.webank.cmdb.config.ApplicationProperties.DatasourceProperties;
import com.webank.cmdb.constant.DynamicEntityType;
import com.webank.cmdb.dynamicEntity.DynamicEntityClassLoader;
import com.webank.cmdb.dynamicEntity.DynamicEntityGenerator;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.dynamicEntity.HibernateJpaEntityManagerFactory;

//@SpringBootTest
//@RunWith(SpringRunner.class)
//@ActiveProfiles("test")
public class domainTest {
    @Autowired
    private DataSource dataSource;
    @Autowired
    private DynamicEntityClassLoader entityCL;
    @Autowired
    private DatasourceProperties datasourceProperties;

    // @Test
    public void testDomain() throws Exception {
//		byte[] domainBuf = AdmMenuDump.generateClzz();
        List<FieldNode> fields = Arrays.asList(new FieldNode(DynamicEntityType.CI, 1, "idAdmMenu", Integer.class, "id_adm_menu", true), new FieldNode(DynamicEntityType.CI, 1, "classPath", String.class, "class_path"),
                new FieldNode(DynamicEntityType.CI, 1, "isActive", Integer.class, "is_active"), new FieldNode(DynamicEntityType.CI, 1, "name", String.class, "name"),
                new FieldNode(DynamicEntityType.CI, 1, "otherName", String.class, "other_name"), new FieldNode(DynamicEntityType.CI, 1, "parentIdAdmMenu", Integer.class, "parent_id_adm_menu"),
                new FieldNode(DynamicEntityType.CI, 1, "remark", String.class, "remark"), new FieldNode(DynamicEntityType.CI, 1, "seqNo", Integer.class, "seq_no"), new FieldNode(DynamicEntityType.CI, 1, "url", String.class, "url"));

        byte[] domainBuf = DynamicEntityGenerator.generate("test/domain/AdmMenu", "adm_menu", fields);

        Class clzz = entityCL.getClass(domainBuf);
        HibernateJpaEntityManagerFactory ciManagerFactory = new HibernateJpaEntityManagerFactory(Arrays.asList(clzz), dataSource, entityCL, datasourceProperties.getSchema());
        EntityManager ciEntityManager = ciManagerFactory.getEntityManagerFactory()
                .createEntityManager();

        Object entity = clzz.newInstance();
        BeanMap beanMap = BeanMap.create(entity);
        beanMap.put("name", "test menu");
        beanMap.put("remark", "test remark");
        beanMap.put("seqNo", 99);
        EntityTransaction transaction = ciEntityManager.getTransaction();
        transaction.begin();
        Object updatedEntity = ciEntityManager.merge(entity);
        System.out.println("id:" + BeanMap.create(updatedEntity)
                .get("idAdmMenu"));
        transaction.commit();

    }
}
