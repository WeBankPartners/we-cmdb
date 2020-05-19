
INSERT INTO adm_ci_type (id_adm_ci_type, name,description,id_adm_tenement,table_name,status,catalog_id,ci_global_unique_id,seq_no,layer_id,zoom_level_id,image_file_id,ci_state_type) VALUES
(1002, '子系统设计','子系统设计',NULL,'subsys_design','created',131,NULL,2,1,NULL,2,NULL)
,(1007, '子系统','子系统',NULL,'subsys','created',132,NULL,1,2,NULL,7,NULL)
;

INSERT INTO adm_ci_type_attr (id_adm_ci_type_attr, id_adm_ci_type,name,description,input_type,property_name,property_type,`length`,reference_id,reference_name,reference_type,filter_rule,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,status,is_system,is_access_controlled,is_auto,auto_fill_rule) VALUES
 (10029, 1002,'业务群组','业务群组','select','business_group','int',15,41,NULL,NULL,NULL,8,1,15,0,0,0,1,0,NULL,'dirty',0,0,1,NULL)
,(10025, 1002,'编码','编码','text','code','varchar',50,NULL,NULL,NULL,NULL,5,1,11,0,0,0,1,0,NULL,'created',1,0,0,NULL)
,(10020, 1002,'创建用户','创建用户','text','created_by','varchar',50,NULL,NULL,NULL,NULL,NULL,0,6,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10021, 1002,'创建日期','创建日期','date','created_date','datetime',1,NULL,NULL,NULL,NULL,1,0,7,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10030, 1002,'DCN设计类型','DCN设计类型','select','dcn_design_type','int',15,41,NULL,NULL,NULL,9,1,16,0,0,0,1,0,NULL,'created',0,0,0,NULL)
,(10026, 1002,'描述说明','描述说明','textArea','description','varchar',1000,NULL,NULL,NULL,NULL,NULL,1,12,1,0,0,1,0,NULL,'created',1,0,0,NULL)
,(10024, 1002,'确认日期','确认日期','text','fixed_date','varchar',19,NULL,NULL,NULL,NULL,4,1,10,1,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10015, 1002,'全局唯一ID','全局唯一ID','text','guid','varchar',15,NULL,NULL,NULL,NULL,NULL,0,1,0,1,1,0,0,NULL,'created',1,0,1,NULL)
,(10022, 1002,'唯一名称','唯一名称','text','key_name','varchar',200,NULL,NULL,NULL,NULL,2,1,8,0,1,0,0,0,NULL,'created',1,0,1,NULL)
,(10028, 1002,'名称','名称','text','name','varchar',50,NULL,NULL,NULL,NULL,7,1,14,0,0,0,1,0,NULL,'created',0,0,0,NULL)
,(10016, 1002,'前全局唯一ID','前一版本数据的guid','text','p_guid','varchar',15,NULL,NULL,NULL,NULL,NULL,0,2,1,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10017, 1002,'根全局唯一ID','原始数据guid','text','r_guid','varchar',15,NULL,NULL,NULL,NULL,NULL,0,3,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10027, 1002,'系统设计','系统设计','ref','system_design','varchar',15,1002,'属于',27,NULL,6,1,13,0,0,0,1,0,NULL,'created',0,0,0,NULL)
,(10023, 1002,'状态','状态','select','state','int',15,41,NULL,NULL,NULL,3,1,9,0,0,0,1,0,NULL,'created',1,0,0,NULL)
,(10018, 1002,'更新用户','更新用户','text','updated_by','varchar',50,NULL,NULL,NULL,NULL,NULL,0,4,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10019, 1002,'更新日期','更新日期','date','updated_date','datetime',1,NULL,NULL,NULL,NULL,NULL,0,5,0,0,1,0,0,NULL,'created',1,0,1,NULL)
;


INSERT INTO adm_ci_type_attr (id_adm_ci_type_attr, id_adm_ci_type,name,description,input_type,property_name,property_type,`length`,reference_id,reference_name,reference_type,filter_rule,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,status,is_system,is_access_controlled,is_auto,auto_fill_rule) VALUES
 (10465,1007,'编排实例ID','编排实例ID','text','biz_key','varchar',50,NULL,NULL,NULL,NULL,9,1,16,1,0,0,1,0,NULL,'created',0,0,0,NULL)
,(10107,1007,'编码','编码','text','code','varchar',50,NULL,NULL,NULL,NULL,5,1,11,0,0,0,1,0,NULL,'created',1,0,0,NULL)
,(10102,1007,'创建用户','创建用户','text','created_by','varchar',50,NULL,NULL,NULL,NULL,NULL,0,6,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10103,1007,'创建日期','创建日期','date','created_date','datetime',1,NULL,NULL,NULL,NULL,1,0,7,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10108,1007,'描述说明','描述说明','textArea','description','varchar',1000,NULL,NULL,NULL,NULL,NULL,1,12,1,0,0,1,0,NULL,'created',1,0,0,NULL)
,(10110,1007,'环境','环境','select','env','int',15,41,NULL,NULL,NULL,7,1,14,0,0,0,1,0,NULL,'created',0,1,0,NULL)
,(10106,1007,'确认日期','确认日期','text','fixed_date','varchar',19,NULL,NULL,NULL,NULL,4,1,10,1,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10097,1007,'全局唯一ID','全局唯一ID','text','guid','varchar',15,NULL,NULL,NULL,NULL,NULL,0,1,0,1,1,0,0,NULL,'created',1,0,1,NULL)
,(10104,1007,'唯一名称','唯一名称','text','key_name','varchar',200,NULL,NULL,NULL,NULL,2,1,8,0,1,0,0,0,NULL,'created',1,0,1,NULL)
,(10111,1007,'运维人员','运维人员','text','manager','varchar',50,NULL,NULL,NULL,NULL,8,1,15,1,0,0,1,0,NULL,'created',0,0,0,NULL)
,(10098,1007,'前全局唯一ID','前一版本数据的guid','text','p_guid','varchar',15,NULL,NULL,NULL,NULL,NULL,0,2,1,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10099,1007,'根全局唯一ID','原始数据guid','text','r_guid','varchar',15,NULL,NULL,NULL,NULL,NULL,0,3,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10105,1007,'状态','状态','select','state','int',15,41,NULL,NULL,NULL,3,1,9,0,0,0,1,0,NULL,'created',1,0,0,NULL)
,(10109,1007,'子系统设计','子系统设计','ref','subsys_design','varchar',20,1002,'实现',31,NULL,6,1,13,0,0,0,1,0,NULL,'created',0,1,0,NULL)
,(10100,1007,'更新用户','更新用户','text','updated_by','varchar',50,NULL,NULL,NULL,NULL,NULL,0,4,0,0,1,0,0,NULL,'created',1,0,1,NULL)
,(10101,1007,'更新日期','更新日期','date','updated_date','datetime',1,NULL,NULL,NULL,NULL,NULL,0,5,0,0,1,0,0,NULL,'created',1,0,1,NULL)
;

CREATE TABLE `subsys_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) NOT NULL COMMENT '根全局唯一ID',
  `description` varchar(1000) NOT NULL COMMENT '描述说明',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `business_group` int(15) DEFAULT NULL COMMENT '业务群组',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `dcn_design_type` int(15) DEFAULT NULL COMMENT 'DCN设计类型',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `system_design` varchar(15) DEFAULT NULL COMMENT '系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `subsys` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) NOT NULL COMMENT '根全局唯一ID',
  `description` varchar(1000) NOT NULL COMMENT '描述说明',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `env` int(15) DEFAULT NULL COMMENT '环境',
  `manager` varchar(50) DEFAULT NULL COMMENT '运维人员',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `subsys_design` varchar(20) DEFAULT NULL COMMENT '子系统设计',
  `biz_key` varchar(50) DEFAULT NULL COMMENT 'null',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO subsys_design (guid,p_guid,r_guid,description,fixed_date,key_name,updated_by,updated_date,created_by,created_date,business_group,code,dcn_design_type,name,state,system_design) VALUES
 ('1002_1000000013',NULL,'1002_1000000013','mock sub system','2019-07-03 20:54:42','WECUBE-DEMO','umadm','2019-07-05 04:31:24.000','umadmin','2019-07-03 08:19:53.000',141,'DEMO',141,'mock sub system',141,NULL)
,('1002_1000000014',NULL,'1002_1000000014','客户端','2019-07-04 15:46:32','EDP-CLIENT','umadm','2019-07-08 01:58:33.000','umadmin','2019-07-04 04:06:15.000',141,'CLIENT',141,'微信存款-客户端',141,NULL)
,('1002_1000000015', NULL, '1002_1000000015', '', '2019-07-04 15:46:32', 'EDP-ETL', 'umadm', '2019-07-05 03:38:02', 'umadmin', '2019-07-02 11:59:53', 43, 'ETL', 63, 'dd', 141, '0001_0000000001')
;

INSERT INTO subsys (guid,p_guid,r_guid,description,fixed_date,key_name,updated_by,updated_date,created_by,created_date,code,env,manager,state,subsys_design,biz_key) VALUES
 ('1007_1000000001',NULL,'1007_1000000001','mock sub system',NULL,'WECUBE-DEMO1','umadmin','2019-07-03 08:39:46.000','umadmin','2019-07-03 08:24:22.000','WECUBE-DEMO',141,'',141,'1002_1000000013',NULL)
,('1007_1000000002',NULL,'1007_1000000002','mock sub system',NULL,'WECUBE-DEMO2','umadmin','2019-07-03 08:39:46.000','umadmin','2019-07-03 08:24:22.000','WECUBE-DEMO',142,'',141,'1002_1000000014',NULL)
,('1007_1000000003',NULL,'1007_1000000003','mock sub system',NULL,'WECUBE-DEMO3','umadmin','2019-07-03 08:39:46.000','umadmin','2019-07-03 08:24:22.000','WECUBE-DEMO',NULL,'',141,'1002_1000000013',NULL)
,('1007_1000000004',NULL,'1007_1000000004','mock sub system',NULL,'WECUBE-DEMO4','umadmin','2019-07-03 08:39:46.000','umadmin','2019-07-03 08:24:22.000','WECUBE-DEMO',NULL,'',141,'1002_1000000015',NULL)
;


INSERT INTO `adm_integrate_template` (`id_adm_integrate_template`, `ci_type_id`, `name`, `des`) VALUES
	(11, 1007, 'subsys-subsysdesign', 'subsys-subsysdesign');

INSERT INTO `adm_integrate_template_alias` (`id_alias`, `id_adm_ci_type`, `id_adm_integrate_template`, `alias`) VALUES
	(101, 1007, 11, 'subsys'),
	(102, 1002, 11, 'subsys-subsysDesign');

INSERT INTO `adm_integrate_template_alias_attr` (`id_attr`, `id_alias`, `id_ci_type_attr`, `is_condition`, `is_displayed`, `mapping_name`, `filter`, `key_name`, `seq_no`, `cn_alias`, `sys_attr`) VALUES
	(10001, 101, 10104, '1', '1', 'subsys$key_name', NULL, 'subsys$key_name', 1, NULL, NULL),
	(10002, 102, 10022, '1', '1', 'subsys-subsysDesign$key_name', NULL, 'subsys-subsysDesign$key_name', 1, NULL, NULL);

INSERT INTO `adm_integrate_template_relation` (`id_relation`, `child_alias_id`, `child_ref_attr_id`, `parent_alias_id`, `is_refered_from_parent`) VALUES
	(100001, 102, 10109, 101, 0);

delete from adm_role_ci_type;
INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission)
VALUES
(1, 1,1007,'子系统','Y','Y','N','N','N','N'),
(2, 2,1007,'子系统','N','N','N','Y','N','N'),
(3, 1,1002,'子系统设计','Y','Y','Y','Y','Y','Y');

INSERT INTO adm_role_ci_type_ctrl_attr (id_adm_role_ci_type_ctrl_attr, id_adm_role_ci_type,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission)
VALUES
(1, 1,'Y','Y','Y','Y','Y','N'),
(2, 1,'Y','Y','Y','Y','Y','N'),
(3, 2,'Y','Y','Y','Y','Y','N');

INSERT INTO adm_role_ci_type_ctrl_attr_condition (id_adm_role_ci_type_ctrl_attr_condition,id_adm_role_ci_type_ctrl_attr,id_adm_ci_type_attr,ci_type_attr_name,condition_value, condition_value_type)
VALUES
(1,1,10109,'子系统设计','', 'Expression'),
(2,1,10110,'环境','', 'Select'),
(3,2,10109,'子系统设计','', 'Expression'),
(4,2,10110,'环境','', 'Select');

INSERT INTO adm_role_ci_type_ctrl_attr_expression (id_adm_role_ci_type_ctrl_attr_expression,id_adm_role_ci_type_ctrl_attr_condition,expression)
VALUES
(1,1,'subsys_design[{guid in ["1002_1000000013","1002_1000000014"]}]:[guid]'),
(2,3,'subsys_design[{guid eq "1002_1000000015"}]:[guid]');

INSERT INTO adm_role_ci_type_ctrl_attr_select (id_adm_role_ci_type_ctrl_attr_select,id_adm_role_ci_type_ctrl_attr_condition,id_adm_basekey)
VALUES
(1,2,141),
(2,4,142);

commit;