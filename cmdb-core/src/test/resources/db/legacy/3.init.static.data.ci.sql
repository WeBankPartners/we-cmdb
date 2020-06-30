INSERT INTO `adm_ci_type` (`id_adm_ci_type`, `name`, `description`, `id_adm_tenement`, `table_name`, `status`, `catalog_id`, `ci_global_unique_id`, `seq_no`, `layer_id`, `zoom_level_id`, `image_file_id`,`ci_state_type`) VALUES
	(1, '日志', '日志', 1, 'adm_log_test', 'notCreated', 130, NULL, 1, 5, 9, 3, 162),
	(2, 'System', 'System', 1, 'wb_system', 'created', 1, NULL, 1, 5, 556, 32, 162),
	(3, 'Sub System', 'Sub System', 1, 'wb_sub_system', 'created', 1, NULL, 2, 5,30, 5, 162),
	(4, 'Zone', 'Zone', 1, 'wb_zone', 'created', 4, NULL, 1, 5, 9, 5, 162),
	(5, 'Unit', 'Unit', 1, 'wb_unit', 'created', 4, NULL, 2, 5, 9, 29, 162),
	(6, 'Service', 'Service', 1, 'wb_service', 'created', 2, NULL, 1, 6, 10, 5, 558),
	(7, 'Invoke Relation', 'Invoke Relation', 1, 'wb_invoke_relation', 'created', 2, NULL, 2, 5, 9, 5, 162),
	(8, 'IDC', 'IDC', 1, 'wb_idc', 'created', 3, NULL, 1, 5, 9, 5, 162),
	(9, 'DCN', 'DCN', 1, 'wb_dcn', 'created', 4, NULL, 3, 5, 9, 5, 162),
	(10, 'Zone Link', 'Zone Link', 1, 'wb_zone_link', 'created', 4, NULL, 4, 5, 9, 5, 162),
	(11, 'SET', 'SET', 1, 'wb_set', 'created', 4, NULL, 5, 5, 9, 5, 162),
	(12, 'SET Node', 'SET Node', 1, 'wb_set_node', 'created', 3, NULL, 2, 5, 9, 5, 162),
	(13, 'DCN Node', 'DCN Node', 1, 'wb_dcn_node', 'created', 3, NULL, 3, 5, 9, 5, 162),
	(14, 'Zone Node', 'Zone Node', 1, 'wb_zone_node', 'created', 3, NULL, 4, 5, 9, 5, 162),
	(15, 'Zone Node Link', 'Zone Node Link', 1, 'wb_zone_node_link', 'created', 3, NULL, 5, 5, 9, 5, 162),
	(16, 'IP Segment', 'IP Segment', 1, 'wb_ip_segment', 'created', 3, NULL, 6, 5, 9, 5, 162),
	(17, 'OS', 'Operating System', 1, 'wb_os', 'created', 3, NULL, 7, 5, 9, 13, 162),
	(18, 'Storage', 'Storage', 1, 'wb_storage', 'decommissioned', 3, NULL, 8, 5, 9, 5, 162),
	(19, 'Instance', 'Instance', 1, 'wb_instance', 'notCreated', 2, NULL, 3, 6, 10, 5, 162),
	(20, 'IP Used', 'IP Used', 1, 'wb_ip_used', 'notCreated', 3, NULL, 9, 5, 9, 5, 558),
	(21, 'Mock_Ci_Type_A', 'Mock Ci Type A', 1, 'wb_mock_ci_type_a', 'notCreated', 3, NULL, 9, 5, 9, 5, 162),
	(22, 'Mock_Ci_Type_B', 'Mock Ci Type B', 1, 'wb_mock_ci_type_b', 'notCreated', 3, NULL, 9, 5, 9, 5, 162),
	(23, 'Mock_Ci_Type_C', 'Mock Ci Type C', 1, 'wb_mock_ci_type_c', 'created', 3, NULL, 9, 5, 9, 5, 162),
	(81, '可创建类CI', '可创建类CI', 1, 'wb_state_create', 'created', 130, NULL, 1, 5, 9, 3, 162),
	(82, '可启停类CI', '可启停类CI', 1, 'wb_state_startup', 'created', 130, NULL, 1, 5, 9, 3, 162),
	(83, '设计类CI', '设计类CI', 1, 'wb_state_design', 'created', 130, NULL, 1, 5, 9, 3, 162),
	(84, 'Self_Ref_Ci_Type', 'Mock Self Ref Ci Type', 1, 'sef_ref_ci_type', 'notCreated', 3, NULL, 9, 5, 9, 5, 162);


INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (1, 'CMDB System','CMDB System',null,1);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (2, 'CMDB Commons','CMDB System',null,2);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (3, 'System','System',2,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (4, 'Sub System','Sub System',3,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (5, 'Unit','Unit',5,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (6, 'Instance','Instance',19,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (7, 'Service','Service',6,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (8, 'IP Used','IP Used',20,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (9, 'IP Segment','IP Segment',16,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (10, 'OS','OS',17,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (11, 'Storage','Storage',18,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (12, 'IDC','IDC',8,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (13, 'Zone Node','Zone Node',14,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (14, 'Zone Node Link','Zone Node Link',15,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (15, 'DCN Node','DCN Node',13,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (16, 'SET Node','SET Node',12,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (17, 'Zone','Zone',4,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (18, 'Zone Link','Zone Link',10,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (19, 'DCN','DCN',9,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (20, 'SET','SET',11,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (21, 'Geography','Geography',null,3);
INSERT INTO adm_basekey_cat_type (id_adm_basekey_cat_type,name,description,ci_type_id,type) VALUES (22, 'Mock_CatType_A','Mock CatType A',21,3);


INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (1, 'ci_catalog','ci_catalog',NULL, 1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (29, 'ci_layer','ci_layer',NULL, 1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (30, 'ci_zoom_level','ci_zoom_level',NULL, 1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (154,'日志操作类型','日志操作类型',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (155,'日志类别','日志类别',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (2, 'System Types','System Types',NULL, 3);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (3, 'Sub System States','Sub System States',NULL, 4);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (4, 'Unit States','Unit States',NULL, 5);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (5, 'Unit Types','Unit Types',NULL, 5);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (6, 'Unit Software','Unit Software',NULL, 5);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (7, 'Unit Clusters','Unit Clusters',NULL, 5);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (8, 'Instance Types','Instance Types',NULL, 6);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (9, 'ci_state_create', '可创建类CI状态', NULL, 1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (10, 'ci_state_start_stop', '可起停类CI状态', NULL, 1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (11, 'Service Context','Service Context',NULL, 7);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (12, 'IP Types','IP Types',NULL, 8);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (13, 'IP States','IP States',NULL, 8);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (14, 'IP Masks','IP Masks',NULL, 9);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (15, 'OS Types','OS Types',NULL, 10);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (16, 'OS Versions','OS Versions',NULL, 10);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (17, 'Storage Types','Storage Types',NULL, 11);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (18, 'IDC Cities','IDC Cities',NULL, 12);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (19, 'IDC Addresses','IDC Addresses',NULL, 12);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (20, 'IDC Types','IDC Types',NULL, 12);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (21, 'Zone Node Types','Zone Node Types',NULL, 13);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (22, 'Zone Node Link Types','Zone Node Link Types',NULL, 14);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (23, 'DCN Node Types','DCN Node Types',NULL, 15);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (24, 'SET Node Types','SET Node Types',NULL, 16);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (25, 'Zone Types','Zone Types',NULL, 17);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (26, 'Zone Link Types','Zone Link Types',NULL, 18);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (27, 'DCN Types','DCN Types',NULL, 19);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (28, 'SET Types','SET Types',NULL, 20);

INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (39, 'state_transition_operation', '状态迁移操作',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (40, 'state_transition_action', '状态迁移动作',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (41, 'ci_state_design', '设计类CI状态',NULL,1);

INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (156,'Country','Country',NULL,21);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type,group_type_id) VALUES (157,'Province','Province',NULL,21,156);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type,group_type_id) VALUES (158,'City','City',NULL,21,157);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (159,'Mock_Cat_A','Mock Cat A',NULL,22);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (160, 'business_group','business_group',NULL, 2);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (161,'Mock_Cat_B','Mock Cat B',NULL,22);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (162,'ci_state_type','ci_state_type',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (991,'Mock_Cat_C','Mock Cat C',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (9911,'Mock_Cat_C','Mock Cat C',NULL,1);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (9922,'Mock_Cat_C','Mock Cat C',NULL,2);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (992,'Mock_Cat_B','Mock Cat B',NULL,2);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (993,'Mock_Cat_A','Mock Cat A',NULL,22);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (994,'Mock_Cat_A','Mock Cat A',NULL,22);
INSERT INTO adm_basekey_cat (id_adm_basekey_cat, cat_name,description,id_adm_role,id_adm_basekey_cat_type) VALUES (995,'Mock_Cat_A','Mock Cat A',NULL,22);


INSERT INTO `adm_basekey_code` (`id_adm_basekey`, `id_adm_basekey_cat`, `code`, `value`, `group_code_id`, `code_description`, `seq_no`, `status`) VALUES
	(1, 1, 'Catalog 1', 'Catalog 1', NULL, 'Catalog 1', 1, 'active'),
	(2, 1, 'Catalog 2', 'Catalog 2', NULL, 'Catalog 2', 2, 'active'),
	(3, 1, 'Catalog 3', 'Catalog 3', NULL, 'Catalog 3', 3, 'active'),
	(4, 1, 'Catalog 4', 'Catalog 4', NULL, 'Catalog 4', 4, 'active'),
	(5, 29, 'Business Layer', 'Business Layer', NULL, 'Business Layer', 5, 'active'),
	(6, 29, 'Running Layer', 'Running Layer', NULL, 'Running Layer', 6, 'active'),
	(7, 29, 'Physical Layer', 'Physical Layer', NULL, 'Physical Layer', 7, 'active'),
	(8, 29, 'Planning Layer', 'Planning Layer', NULL, 'Planning Layer', 8, 'active'),
	(9, 30, '1', '1', NULL, '1', 9, 'active'),
	(10, 30, '2', '2', NULL, '2', 10, 'active'),
	(11, 30, '3', '3', NULL, '3', 11, 'active'),
	(12, 30, '4', '4', NULL, '4', 12, 'active'),
	(100, 156, 'China', '中国(China)', NULL, '中国', 1, 'active'),
	(101, 156, 'USA', '美国(USA)', NULL, '美国', 1, 'active'),
	(110, 157, 'Guangdong', '广东', 100, '广东', 1, 'active'),
	(111, 157, 'Hunan', '湖南', 100, '湖南', 2, 'active'),
	(120, 158, 'Shenzhen', '深圳', 110, '深圳', 1, 'active'),
	(121, 158, 'Guangzhou', '广州', 110, '广州', 2, 'active'),
	(122, 159, 'Mock_Code_A', 'Mock_Code_A_Value', NULL, 'Mock Code A Desc', 1, 'active'),

-- begin of state transition --
	(34, 10, 'created', '创建', NULL, NULL, 1, 'active'),
	(35, 10, 'startup', '启动', NULL, NULL, 2, 'active'),
	(36, 10, 'change', '变更', NULL, NULL, 3, 'active'),
	(37, 10, 'stoped', '停止', NULL, NULL, 4, 'active'),
	(38, 10, 'destroyed', '销毁', NULL, NULL, 5, 'active'),
	(39, 9, 'created', '创建', NULL, NULL, 6, 'active'),
	(40, 9, 'change', '变更', NULL, NULL, 7, 'active'),
	(41, 9, 'destroyed', '销毁', NULL, NULL, 8, 'active'),
	(141, 41, 'new', '新增', NULL, NULL, 1, 'active'),
	(142, 41, 'update', '更新', NULL, NULL, 2, 'active'),
	(143, 41, 'delete', '删除', NULL, NULL, 3, 'active'),
	(144, 39, 'insert', '添加', NULL, NULL, 1, 'active'),
	(145, 39, 'update', '更新', NULL, NULL, 2, 'active'),
	(146, 39, 'discard', '放弃', NULL, NULL, 3, 'active'),
	(147, 39, 'delete', '删除', NULL, NULL, 4, 'active'),
	(148, 39, 'confirm', '确认', NULL, NULL, 5, 'active'),
	(149, 40, 'insert', '插入', NULL, NULL, 1, 'active'),
	(150, 40, 'insert-update', '插入-更新', NULL, NULL, 2, 'active'),
	(151, 40, 'delete', '删除', NULL, NULL, 3, 'active'),
	(152, 40, 'update-delete', '更新-删除', NULL, NULL, 4, 'active'),
	(153, 40, 'update', '更新', NULL, NULL, 5, 'active'),
	(154, 40, 'confirm', '确认', NULL, NULL, 6, 'active'),
	(155, 41, 'client_layer', '客户端层', NULL, NULL, 1, 'active'),
	(156, 41, 'link_layer', '接入层', NULL, NULL, 2, 'active'),
	(157, 41, 'buss_layer', '业务层', NULL, NULL, 3, 'active'),
	(158, 39, 'startup', '启动', NULL, NULL, 6, 'active'),
	(159, 39, 'stop', '停止', NULL, NULL, 7, 'active'),
-- end of state transition --

	(545, 154, '1001', '修改成功', NULL, '修改成功', 5, 'active'),
	(546, 154, '1002', '新增成功', NULL, '新增成功', 4, 'active'),
	(547, 154, '1003', '新增失败', NULL, '新增失败', 3, 'active'),
	(548, 154, '1004', '删除成功', NULL, '删除成功', 2, 'active'),
	(549, 154, '1005', '删除失败', NULL, '删除失败', 1, 'active'),
	(550, 155, '1006', '配置管理', NULL, '配置管理', 4, 'active'),
	(551, 155, '1007', '角色管理', NULL, '角色管理', 3, 'active'),
	(552, 155, '1008', '配置信息管理', NULL, '配置信息管理', 2, 'active'),
	(553, 155, '1009', '基础属性管理', NULL, '基础属性管理', 1, 'active'),
	(554, 2, 'Functional', NULL, NULL, 'Functional', 1, 'active'),
	(555, 2, 'public system', NULL, NULL, 'public system', 2, 'active'),
	(556, 3, 'Online', NULL, NULL, 'Online', 1, 'active'),
	(557, 3, 'Online-1', 'Online-1-Value', 556, 'Online-1', 1, 'active'),
	(558, 162, 'realizeable', 'realizeable', NULL, 'realizeable', 1, 'active'),
	(559, 162, 'desgin', 'desgin', NULL, 'desgin', 2, 'active'),
	(560, 5, 'unit_type_code_1', 'unit_type_value_1', NULL, 'unit_type_desc_1', 1, 'active'),
	(561, 5, 'unit_type_code_2', 'unit_type_value_2', NULL, 'unit_type_desc_1', 2, 'active'),
	(881, 991, 'SystemEnumCode', 'SystemEnumValue', NULL, 'desc', 1, 'active'),
	(882, 992, 'CommonEnumCode', 'CommonEnumValue', NULL, 'desc', 1, 'active'),
	(883, 993, 'PrivateEnumCode1', 'PrivateEnumValue1', NULL, 'desc', 1, 'active'),
	(884, 993, 'PrivateEnumCode2', 'PrivateEnumValue2', NULL, 'desc', 1, 'active'),
	(885, 993, 'PrivateEnumCode3', 'PrivateEnumValue3', NULL, 'desc', 1, 'active'),
	(886, 993, 'PrivateEnumCode4', 'PrivateEnumValue4', NULL, 'desc', 1, 'active'),
	(887, 993, 'PrivateEnumCode5', 'PrivateEnumValue5', NULL, 'desc', 1, 'active'),
	(888, 993, 'PrivateEnumCode6', 'PrivateEnumValue6', NULL, 'desc', 1, 'active'),
	(889, 993, 'PrivateEnumCode7', 'PrivateEnumValue7', NULL, 'desc', 1, 'active'),
	(890, 993, 'PrivateEnumCode8', 'PrivateEnumValue8', NULL, 'desc', 1, 'active'),
	(891, 993, 'PrivateEnumCode9', 'PrivateEnumValue9', NULL, 'desc', 1, 'active'),
	(892, 993, 'PrivateEnumCode10', 'PrivateEnumValue10', NULL, 'desc', 1, 'active'),
	(893, 993, 'PrivateEnumCode11', 'PrivateEnumValue11', NULL, 'desc', 1, 'active');



-- adm_log
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('全局唯一ID', 'text', '全局唯一ID', 1, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1)
,('唯一值', 'text', '唯一值', 1, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1)
,('更新用户', 'text', '更新用户', 1, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('更新日期', 'date', '更新日期', 1, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1)
,('创建用户', 'text', '创建用户', 1, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('创建日期', 'date', '创建日期', 1, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1);

-- System
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_auto) VALUES
 ('English Name','text','English Name',2,'name_en','varchar',1,'1',1,0,'1','0',1,'0',NULL,45,0,'created',0,0)
,('Chinese Name','text','Chinese Name',2,'name_cn','varchar',2,'1',2,'1','0','0',1,'0',NULL,45,0,'created',0,0)
,('System ID','ref','System ID',2,'system_id','varchar',4,'1',3,'1','0','0','1','0','',15,2,'created',0,0)
,('Description','text','Description',2,'description','varchar',4,'1',4,'1','0','0',1,'0',NULL,200,0,'created',0,0)
,('System Type','select','System Type',2,'system_type','int',5,'1',5,'0','0','0',1,'0',NULL,45,2,'created',0,0)
,('State','select','State',2,'state','int',4,'1',4,'0','0','0','1','0',NULL,45,10,'created',1,1)
,('全局唯一ID', 'text', '全局唯一ID', 2, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1)
,('唯一值', 'text', '唯一值', 2, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1)
,('更新用户', 'text', '更新用户', 2, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1)
,('更新日期', 'date', '更新日期', 2, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1)
,('创建用户', 'text', '创建用户', 2, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1)
,('创建日期', 'date', '创建日期', 2, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1)
,('前全局唯一ID', 'text', '前一版本数据的guid', 2, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1)
,('根全局唯一ID', 'text', '根全局唯一ID', 2, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1);

-- Sub System
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_auto,auto_fill_rule) VALUES
('English Name','text','English Name',3,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0',0,NULL)
,('Chinese Name','text','Chinese Name',3,'name_cn','varchar',5,'1',5,'1','0','0','1','0',NULL,45,0,'created','0',0,NULL)
,('System ID','ref','System ID',3,'system_id','varchar',2,'1',2,'0','0','0','1','0',NULL,15,2,'created','0',0,NULL)
,('Zone ID','ref','Zone ID',3,'zone_id','varchar',3,'1',3,'0','0','0','1','0',NULL,15,4,'created','0',0,NULL)
,('State','select','State',3,'state','int',4,'1',4,'0','0','0','1','0',NULL,45,10,'created',1,1,NULL)
,('Description','text','Description',3,'description','varchar',6,'1',6,'1','0','0','1','0',NULL,200,0,'created','0',0,NULL)
,('全局唯一ID', 'text', '全局唯一ID', 3, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1,1,NULL)
,('唯一值', 'text', '唯一值', 3, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1,NULL)
,('更新用户', 'text', '更新用户', 3, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1,NULL)
,('更新日期', 'date', '更新日期', 3, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1,NULL)
,('创建用户', 'text', '创建用户', 3, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1,NULL)
,('创建日期', 'date', '创建日期', 3, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 'created', 1,1,NULL)
,('前全局唯一ID', 'text', '前一版本数据的guid', 3, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1,NULL)
,('根全局唯一ID', 'text', '根全局唯一ID', 3, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1,NULL);


-- Zone
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',4,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',4,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'decommissioned','0')
,('Zone Type','select','Zone Type',4,'zone_type','int',3,'1',3,'0','0','0','1','0',NULL,45,25,'created','0')
,('IDC Min','number','IDC Min',4,'idc_min','int',5,'1',4,'0','0','0','0','0',NULL,2,0,'created','0')
,('Description','text','Description',4,'description','varchar',5,'1',5,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 4, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 4, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 4, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 4, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 4, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 4, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 4, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 4, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- Unit
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_delete_validate) VALUES
('English Name','text','English Name',5,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0',0)
,('Chinese Name','text','Chinese Name',5,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0',0)
,('Sub-System ID','ref','Sub-System ID',5,'subsystem_id','varchar',3,'1',3,'1','0','0','1','0','',15,3,'created','0',0)
,('State','select','State',5,'state','int',4,'1',4,'0','0','0','1','0',NULL,45,4,'created','0',0)
,('Unit Type','select','Unit Type',5,'unit_type','int',5,'1',5,'0','0','0','1','0',NULL,45,5,'created','0',0)
,('Software','select','Software',5,'software','int',6,'1',6,'0','0','0','1','0',NULL,45,6,'created','0',0)
,('Version','date','Version',5,'version','varchar',7,'1',7,'0','0','0','1','0',NULL,45,0,'created','0',0)
,('Cluster','select','Cluster',5,'cluster','int',8,'1',8,'0','0','0','1','0',NULL,45,7,'created','0',0)
,('Description','text','Description',5,'description','varchar',9,'1',9,'1','0','0','0','0',NULL,200,0,'created','0',0)
,('全局唯一ID', 'text', '全局唯一ID', 5, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1,0)
,('唯一值', 'text', '唯一值', 5, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,0)
,('更新用户', 'text', '更新用户', 5, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,0)
,('更新日期', 'date', '更新日期', 5, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,0)
,('创建用户', 'text', '创建用户', 5, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,0)
,('创建日期', 'date', '创建日期', 5, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,0)
,('前全局唯一ID', 'text', '全局唯一ID', 5, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1,0)
,('根全局唯一ID', 'text', '全局唯一ID', 5, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1,0)
;

-- Service
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',6,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',6,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('Unit ID','ref','Unit ID',6,'unit_id','varchar',3,'1',3,'0','0','0','0','0','',15,5,'created','0')
,('Port','text','Port',6,'port','varchar',4,'1',4,'1','0','0','0','0',NULL,5,0,'created','0')
,('Invokable','select','Invokable',6,'invokable','int',5,'1',5,'0','0','0','1','0',NULL,45,9,'created','0')
,('Service Type','select','Service Type',6,'service_type','int',6,'1',6,'0','1','0','1','0',NULL,45,10,'created','0')
,('Context','select','Context',6,'context','int',7,'1',7,'0','0','0','0','0',NULL,200,11,'created','0')
,('Description','text','Description',6,'description','varchar',8,'1',8,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 6, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 6, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 6, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 6, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 6, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 6, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 6, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 6, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- Invoke Relation
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Description','text','Description',7,'description','varchar',1,'1',1,'1','0','0','0','0',NULL,200,0,'created','0')
,('Service ID','ref','Service ID',7,'service_id','varchar',2,'1',2,'0','0','0','0','0','',15,6,'created','0')
,('Invoked Service ID','ref','Invoked Service ID',7,'invoked_service_id','varchar',3,'1',3,'0','0','0','0','0','',15,6,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 7, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 7, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 7, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 7, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 7, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 7, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 7, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 7, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- IDC
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',8,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',8,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('City','select','City',8,'city','int',3,'1',3,'0','0','0','1','0',NULL,45,18,'created','0')
,('Description','text','Description',8,'description','varchar',4,'1',4,'1','0','0','0','0',NULL,200,0,'created','0')
,('Address','select','Address',8,'address','int',5,'1',5,'1','0','0','0','0',NULL,100,19,'created','0')
,('Capacity','number','Capacity',8,'capacity','int',6,'1',6,'1','0','0','0','0',NULL,10,0,'created','0')
,('IDC Type','select','IDC Type',8,'idc_type','int',7,'1',7,'1','0','0','1','0',NULL,45,20,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 8, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 8, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 8, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 8, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 8, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 8, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 8, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 8, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- DCN
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',9,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',9,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('Zone ID','ref','Zone ID',9,'zone_id','varchar',3,'1',3,'0','0','0','1','0',NULL,15,4,'created','0')
,('DCN Type','select','DCN Type',9,'dcn_type','int',4,'1',4,'0','0','0','1','0',NULL,45,25,'created','0')
,('IDC Min','number','IDC Min',9,'idc_min','int',5,'1',5,'0','0','0','0','0',NULL,2,0,'created','0')
,('Description','text','Description',9,'description','varchar',6,'1',6,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 9, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 9, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 9, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 9, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 9, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 9, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 9, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 9, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- Zone Link
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',10,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',10,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('Zone A ID','ref','Zone A ID',10,'zone_a_id','varchar',3,'1',3,'0','0','0','0','0',NULL,15,4,'created','0')
,('Zone B ID','ref','Zone B ID',10,'zone_b_id','varchar',4,'1',4,'0','0','0','0','0',NULL,15,4,'created','0')
,('Zone Link Type','select','Zone Link Type',10,'zone_link_type','int',5,'1',5,'0','0','0','1','0',NULL,45,26,'created','0')
,('IDC Min','number','IDC Min',10,'idc_min','int',6,'1',6,'0','0','0','0','0',NULL,2,0,'created','0')
,('Description','text','Description',10,'description','varchar',7,'1',7,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 10, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 10, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 10, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 10, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 10, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 10, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 10, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 10, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- SET
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',11,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',11,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('DCN ID','ref','DCN ID',11,'dcn_id','varchar',3,'1',3,'0','0','0','0','0',NULL,15,9,'created','0')
,('SET Type','select','SET Type',11,'set_type','int',4,'1',4,'0','0','0','1','0',NULL,45,28,'created','0')
,('IDC Min','number','IDC Min',11,'idc_min','int',5,'1',5,'0','0','0','0','0',NULL,2,0,'created','0')
,('Description','text','Description',11,'description','varchar',6,'1',6,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 11, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 11, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 11, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 11, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 11, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 11, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 11, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 11, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;


-- SET Node
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',12,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',12,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('IDC ID','ref','IDC ID',12,'idc_id','varchar',3,'1',3,'0','0','0','0','0',NULL,15,8,'created','0')
,('SET ID','ref','SET ID',12,'set_id','varchar',4,'1',4,'0','0','0','0','0',NULL,15,11,'created','0')
,('SET Node Type','select','SET Node Type',12,'set_node_type','int',5,'1',5,'0','0','0','1','0',NULL,45,24,'created','0')
,('Description','text','Description',12,'description','varchar',6,'1',6,'1','0','0','0','0',NULL,200,0,'created','0')
,('OS Min','number','OS Min',12,'os_min','int',7,'1',7,'0','0','0','0','0',NULL,5,0,'created','0')
,('OS Max','number','OS Max',12,'os_max','int',8,'1',8,'0','0','0','0','0',NULL,5,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 12, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 12, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 12, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 12, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 12, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 12, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 12, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 12, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- DCN Node
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',13,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',13,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('IDC ID','ref','IDC ID',13,'idc_id','varchar',3,'1',3,'0','0','0','0','0',NULL,15,8,'created','0')
,('DCN ID','ref','DCN ID',13,'dcn_id','varchar',4,'1',4,'0','0','0','0','0',NULL,15,9,'created','0')
,('DCN Node Type','select','DCN Node Type',13,'dcn_node_type','int',5,'1',5,'0','0','0','1','0',NULL,45,23,'created','0')
,('Description','text','Description',13,'description','varchar',6,'1',6,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 13, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 13, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 13, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 13, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 13, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 13, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 13, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 13, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- Zone Node
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',14,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Chinese Name','text','Chinese Name',14,'name_cn','varchar',2,'1',2,'1','0','0','1','0',NULL,45,0,'created','0')
,('Zone ID','ref','Zone ID',14,'zone_id','varchar',3,'1',3,'0','0','0','1','0',NULL,15,4,'created','0')
,('IDC ID','ref','IDC ID',14,'idc_id','varchar',4,'1',4,'0','0','0','0','0',NULL,15,8,'created','0')
,('Zone Node Type','select','Zone Node Type',14,'zone_node_type','int',5,'1',5,'0','0','0','1','0',NULL,45,21,'created','0')
,('Description','text','Description',14,'description','varchar',6,'1',6,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 14, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 14, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 14, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 14, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 14, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 14, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 14, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 14, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- Zone Node Link
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('English Name','text','English Name',15,'name_en','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Zone Node A ID','ref','Zone Node A ID',15,'zone_node_a_id','varchar',2,'1',2,'0','0','0','0','0',NULL,15,14,'created','0')
,('Zone Node B ID','ref','Zone Node B ID',15,'zone_node_b_id','varchar',3,'1',3,'0','0','0','0','0',NULL,15,14,'created','0')
,('Zone Node Link Type','select','Zone Node Link Type',15,'zone_node_link_type','int',4,'1',4,'0','0','0','1','0',NULL,45,22,'created','0')
,('Description','text','Description',15,'description','varchar',5,'1',5,'1','0','0','0','0',NULL,200,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 15, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 15, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 15, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 15, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 15, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 15, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 15, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 15, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- IP Segment
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Name','text','Name',16,'name','varchar',1,'1',1,'0','1','0','1','0',NULL,45,0,'created','0')
,('Mask','select','Mask',16,'mask','int',2,'1',2,'1','1','0','1','0',NULL,45,14,'created','0')
,('IP Segment ID','ref','IP Segment ID',16,'ip_segment_id','varchar',3,'1',3,'1','0','0','0','0',NULL,15,16,'created','0')
,('Description','text','Description',16,'description','varchar',4,'1',4,'1','0','0','0','0',NULL,200,0,'created','0')
,('Begin','text','Begin',16,'begin','varchar',5,'1',5,'1','0','0','1','0',NULL,45,0,'created','0')
,('End','text','End',16,'end','varchar',6,'1',6,'1','0','0','1','0',NULL,45,0,'created','0')
,('Zone Node ID','ref','Zone Node ID',16,'zone_node_id','varchar',7,'1',7,'1','0','0','0','0',NULL,15,14,'created','0')
,('DCN Node ID','ref','DCN Node ID',16,'dcn_node_id','varchar',8,'1',8,'1','0','0','0','0',NULL,15,13,'created','0')
,('SET Node ID','ref','SET Node ID',16,'set_node_id','varchar',9,'1',9,'1','0','0','0','0',NULL,15,12,'created','0')
,('IDC ID','ref','IDC ID',16,'idc_id','varchar',10,'1',10,'0','0','0','0','0',NULL,15,8,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 16, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 16, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 16, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 16, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 16, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 16, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 16, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 16, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- OS
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Name','text','Name',17,'name','varchar',1,'1',1,'0','1','0','0','0',NULL,100,0,'created','0')
,('SET Node ID','ref','SET Node ID',17,'set_node_id','varchar',2,'1',2,'1','0','0','0','0',NULL,15,12,'created','0')
,('OS Type','select','OS Type',17,'os_type','int',3,'1',3,'0','0','0','1','0',NULL,45,15,'created','0')
,('Version','select','Version',17,'version','int',4,'1',4,'0','0','0','1','0',NULL,45,16,'created','0')
,('Description','text','Description',17,'description','varchar',5,'1',5,'1','0','0','0','0',NULL,200,0,'created','0')
,('Core Num','number','Core Num',17,'core_num','int',6,'1',6,'0','0','0','0','0',NULL,5,0,'created','0')
,('Mem Num','number','Mem Num',17,'mem_num','int',7,'1',7,'0','0','0','0','0',NULL,5,0,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 17, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 17, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 17, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 17, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 17, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 17, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('前全局唯一ID', 'text', '全局唯一ID', 17, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('根全局唯一ID', 'text', '全局唯一ID', 17, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
;

-- Storage
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Capacity','number','Capacity',18,'capacity','int',1,'1',1,'0','0','0','0','0',NULL,10,0,'created','0')
,('Storage Type','select','Storage Type',18,'storage_type','int',2,'1',2,'0','0','0','1','0',NULL,45,17,'created','0')
,('OS ID','ref','OS ID',18,'os_id','varchar',3,'1',3,'0','0','0','0','0',NULL,15,17,'created','0')
,('全局唯一ID', 'text', '全局唯一ID', 18, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 18, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新用户', 'text', '更新用户', 18, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('更新日期', 'date', '更新日期', 18, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1)
,('创建用户', 'text', '创建用户', 18, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1)
,('创建日期', 'date', '创建日期', 18, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1);

-- wb_instance
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('全局唯一ID', 'text', '全局唯一ID', 19, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1)
,('唯一值', 'text', '唯一值', 19, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1)
,('更新用户', 'text', '更新用户', 19, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('更新日期', 'date', '更新日期', 19, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1)
,('创建用户', 'text', '创建用户', 19, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('创建日期', 'date', '创建日期', 19, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1);

-- wb_ip_used
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('全局唯一ID', 'text', '全局唯一ID', 20, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1)
,('唯一值', 'text', '唯一值', 20, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1)
,('更新用户', 'text', '更新用户', 20, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('更新日期', 'date', '更新日期', 20, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1)
,('创建用户', 'text', '创建用户', 20, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('创建日期', 'date', '创建日期', 20, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1);

-- Mock Attr for wb_mock_ci_type_a
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_auto) VALUES
('Mock_Attr_A','text','Mock Attr A',21,'mock_attr_a','varchar',1,'1',1,'0','0','0','1','0',NULL,10,0,'notCreated','0',0)
,('State','select','State',21,'state','int',4,'1',4,'0','0','0','1','0',NULL,45,10,'created',1,1)
,('全局唯一ID', 'text', '全局唯一ID', 21, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1,1)
,('唯一值', 'text', '唯一值', 21, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1,1)
,('更新用户', 'text', '更新用户', 21, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1,1)
,('更新日期', 'date', '更新日期', 21, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1,1)
,('创建用户', 'text', '创建用户', 21, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1,1)
,('创建日期', 'date', '创建日期', 21, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1,1)
,('前全局唯一ID', 'text', '全局唯一ID', 21, 'p_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1,1)
,('根全局唯一ID', 'text', '全局唯一ID', 21, 'r_guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1,1)
;


-- Mock Attr for wb_mock_ci_type_b
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Mock_Attr_B','text','Mock Attr B',22,'mock_attr_b','varchar',1,'1',1,'0','0','0','1','0',NULL,10,0,'notCreated','0')
,('Mock_Attr_A','ref','Mock_Attr_A',22,'mock_attr_a','varchar',2,'1',2,'0','0','0','1','0',NULL,15,21,'notCreated','0')
,('Mock_Attr_B_Desc','text','Mock Attr B Desc',22,'mock_attr_b_desc','varchar',1,'1',1,'0','0','0','0','0',NULL,10,0,'notCreated','0')
,('全局唯一ID', 'text', '全局唯一ID', 22, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'notCreated', 1)
,('唯一值', 'text', '唯一值', 22, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1)
,('更新用户', 'text', '更新用户', 22, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('更新日期', 'date', '更新日期', 22, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1)
,('创建用户', 'text', '创建用户', 22, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('创建日期', 'date', '创建日期', 22, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1);

-- Mock Attr for wb_mock_ci_type_c
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Mock_Attr_C','text','Mock Attr C',23,'mock_attr_b','varchar',1,'1',1,'0','0','0','0','0',NULL,10,0,'notCreated','0')
,('Mock_Attr_C_Desc','text','Mock Attr C Desc',23,'mock_attr_b_desc','varchar',1,'1',1,'0','0','0','0','0',NULL,10,0,'notCreated','0')
,('全局唯一ID', 'text', '全局唯一ID', 23, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 23, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1)
,('更新用户', 'text', '更新用户', 23, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('更新日期', 'date', '更新日期', 23, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1)
,('创建用户', 'text', '创建用户', 23, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('创建日期', 'date', '创建日期', 23, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1);


-- wb_create
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_auto) VALUES
('Name','text','Name',81,'name','varchar',1,'1',1,0,'1','0',1,'0',NULL,45,0,'created',0,0),
('Description','text','Description',81,'description','varchar',4,'1',4,'1','0','0',1,'0',NULL,200,0,'created',0,0),
('State','select','State',81,'state','int',4,'1',4,'0','0','0','0','0',NULL,15,9,'created',1,1),
('确认日期', 'text', '确认日期', 81, 'fixed_date', 'varchar', 5, '1', 4, '0','0','0','0','0',NULL, 19, NULL, 'created', 1, 1),
('全局唯一ID', 'text', '全局唯一ID', 81, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1),
('前全局唯一ID', 'text', '前一版本数据的guid', 81, 'p_guid', 'varchar', NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, 15, NULL, 'created', 1, 1),
('根全局唯一ID', 'text', '原始数据guid', 81, 'r_guid', 'varchar', NULL, NULL, NULL, 0, 0, 1, 0, 0, NULL, 15, NULL, 'created', 1, 1),
('唯一值', 'text', '唯一值', 81, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('更新用户', 'text', '更新用户', 81, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('更新日期', 'date', '更新日期', 81, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1),
('创建用户', 'text', '创建用户', 81, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('创建日期', 'date', '创建日期', 81, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1);

-- wb_startup
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_auto) VALUES
('Name','text','Name',82,'name','varchar',1,'1',1,0,'1','0',1,'0',NULL,45,0,'created',0,0),
('Description','text','Description',82,'description','varchar',4,'1',4,'1','0','0',1,'0',NULL,200,0,'created',0,0),
('State','select','State',82,'state','int',4,'1',4,'0','0','0','0','0',NULL,15,10,'created',1,1),
('确认日期', 'text', '确认日期', 82, 'fixed_date', 'varchar', 5, '1', 4, '0','0','0','0','0',NULL, 19, NULL, 'created', 1, 1),
('全局唯一ID', 'text', '全局唯一ID', 82, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1),
('前全局唯一ID', 'text', '前一版本数据的guid', 82, 'p_guid', 'varchar', NULL, NULL, NULL, 1, 0, 1, 0, 0, NULL, 15, NULL, 'created', 1, 1),
('根全局唯一ID', 'text', '原始数据guid', 82, 'r_guid', 'varchar', NULL, NULL, NULL, 0, 0, 1, 0, 0, NULL, 15, NULL, 'created', 1, 1),
('唯一值', 'text', '唯一值', 82, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('更新用户', 'text', '更新用户', 82, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('更新日期', 'date', '更新日期', 82, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1),
('创建用户', 'text', '创建用户', 82, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('创建日期', 'date', '创建日期', 82, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1);

-- wb_design
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system,is_auto) VALUES
('Name','text','Name',83,'name','varchar',1,'1',1,0,'1','0',1,'0',NULL,45,0,'created',0,0),
('Description','text','Description',83,'description','varchar',4,'1',4,1,'0','0',1,'0',NULL,200,0,'created',0,0),
('State','select','State',83,'state','int',4,'1',4,0,'0','0',1,'0',NULL,15,41,'created',1,0),
('确认日期', 'text', '确认日期', 83, 'fixed_date', 'varchar', 5, '1', 4, 1,'0','0','0','0',NULL, 19, NULL, 'created', 1, 1),
('全局唯一ID', 'text', '全局唯一ID', 83, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1 ,1),
('前全局唯一ID', 'text', '前一版本数据的guid', 83, 'p_guid', 'varchar', NULL, NULL, NULL, 1, 0, 1, 0, 0, NULL, 15, NULL, 'created', 1, 1),
('根全局唯一ID', 'text', '原始数据guid', 83, 'r_guid', 'varchar', NULL, NULL, NULL, 0, 0, 1, 0, 0, NULL, 15, NULL, 'created', 1, 1),
('唯一值', 'text', '唯一值', 83, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('更新用户', 'text', '更新用户', 83, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('更新日期', 'date', '更新日期', 83, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1),
('创建用户', 'text', '创建用户', 83, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'created', 1,1),
('创建日期', 'date', '创建日期', 83, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'created', 1,1);


INSERT INTO `adm_ci_type_attr_base` (`id_adm_ci_type_attr`, `id_adm_ci_type`, `name`, `description`, `input_type`, `property_name`, `property_type`, `length`, `reference_id`, `reference_name`, `reference_type`, `filter_rule`, `search_seq_no`, `display_type`, `display_seq_no`, `edit_is_null`, `edit_is_only`, `edit_is_hiden`, `edit_is_editable`, `is_defunct`, `special_logic`, `status`, `is_system`, `is_access_controlled`, `is_auto`, `auto_fill_rule`, `regular_expression_rule`, `is_refreshable`, `is_delete_validate`) VALUES
	(1, 1, '全局唯一ID', '全局唯一ID', 'text', 'guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(2, 1, '前全局唯一ID', '前一版本数据的guid', 'text', 'p_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(3, 1, '根全局唯一ID', '原始数据guid', 'text', 'r_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(4, 1, '更新用户', '更新用户', 'text', 'updated_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(5, 1, '更新日期', '更新日期', 'date', 'updated_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(6, 1, '创建用户', '创建用户', 'text', 'created_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(7, 1, '创建日期', '创建日期', 'date', 'created_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(8, 1, '唯一名称', '唯一名称', 'text', 'key_name', 'varchar', 200, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 0, 1),
	(9, 1, '状态', '状态', 'select', 'state', 'int', 15, 7, NULL, NULL, NULL, 2, 1, 2, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(10, 1, '确认日期', '确认日期', 'text', 'fixed_date', 'varchar', 19, NULL, NULL, NULL, NULL, 3, 1, 3, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(11, 1, '描述说明', '描述说明', 'textArea', 'description', 'varchar', 1000, NULL, NULL, NULL, NULL, 4, 1, 4, 1, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1),
	(12, 1, '编码', '编码', 'text', 'code', 'varchar', 50, NULL, NULL, NULL, NULL, 5, 1, 5, 0, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0, 1);


-- Mock Attr for Self_Ref_Ci_Type
INSERT INTO adm_ci_type_attr (name,input_type,description,id_adm_ci_type,property_name,property_type,search_seq_no,display_type,display_seq_no,edit_is_null,edit_is_only,edit_is_hiden,edit_is_editable,is_defunct,special_logic,`length`,reference_id,status,is_system) VALUES
('Self_Ref_Attr','ref','Self ref attr',84,'self_ref','varchar',1,'1',1,'0','0','0','0','0',NULL,10,84,'notCreated','0')
,('全局唯一ID', 'text', '全局唯一ID', 84, 'guid', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 15, NULL, 'created', 1)
,('唯一值', 'text', '唯一值', 84, 'key_name', 'varchar', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, 500, NULL, 'notCreated', 1)
,('更新用户', 'text', '更新用户', 84, 'updated_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('更新日期', 'date', '更新日期', 84, 'updated_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1)
,('创建用户', 'text', '创建用户', 84, 'created_by', 'varchar', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, 64, NULL, 'notCreated', 1)
,('创建日期', 'date', '创建日期', 84, 'created_date', 'date', NULL, NULL, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 'notCreated', 1);


INSERT INTO `adm_state_transition` (`id_adm_state_transition`, `current_state`, `current_state_is_confirmed`, `target_state`, `target_state_is_confirmed`, `operation`, `action`, `status`) VALUES
	(1, 39, 0, NULL, NULL, 147, 151, 'active'),
	(2, NULL, NULL, 39, 0, 144, 149, 'active'),
	(3, 39, 0, 39, 0, 145, 153, 'active'),
	(4, 39, 0, 39, 1, 148, 154, 'active'),
	(5, 39, 1, 40, 0, 145, 150, 'active'),
	(6, 40, 0, 39, 1, 146, 152, 'active'),
	(7, 39, 1, 41, 0, 147, 150, 'active'),
	(8, 41, 0, 39, 1, 146, 152, 'active'),
	(9, 40, 0, 40, 0, 145, 153, 'active'),
	(10, 40, 0, 40, 1, 148, 154, 'active'),
	(11, 40, 1, 40, 0, 145, 150, 'active'),
	(12, 40, 0, 40, 1, 146, 152, 'active'),
	(13, 40, 1, 41, 0, 147, 150, 'active'),
	(14, 41, 0, 40, 1, 146, 152, 'active'),
	(15, 41, 0, 41, 1, 148, 154, 'active'),
	(16, 34, 0, NULL, NULL, 147, 151, 'active'),
	(17, NULL, NULL, 34, 0, 144, 149, 'active'),
	(18, 34, 0, 34, 0, 145, 153, 'active'),
	(19, 34, 0, 34, 1, 148, 154, 'active'),
	(20, 34, 1, 35, 0, 158, 150, 'active'),
	(21, 35, 0, 34, 1, 146, 152, 'active'),
	(22, 35, 0, 35, 1, 148, 154, 'active'),
	(23, 34, 1, 37, 0, 159, 150, 'active'),
	(24, 37, 0, 34, 1, 146, 152, 'active'),
	(25, 37, 0, 37, 1, 148, 154, 'active'),
	(26, 35, 1, 37, 0, 159, 150, 'active'),
	(27, 37, 0, 35, 1, 146, 152, 'active'),
	(28, 37, 1, 35, 0, 158, 150, 'active'),
	(29, 35, 0, 37, 1, 146, 152, 'active'),
	(30, 35, 1, 36, 0, 145, 150, 'active'),
	(31, 36, 0, 35, 1, 146, 152, 'active'),
	(32, 37, 1, 36, 0, 145, 150, 'active'),
	(33, 36, 0, 37, 1, 146, 152, 'active'),
	(34, 36, 0, 36, 0, 145, 153, 'active'),
	(35, 36, 0, 36, 1, 148, 154, 'active'),
	(36, 36, 1, 37, 0, 159, 150, 'active'),
	(37, 37, 0, 36, 1, 146, 152, 'active'),
	(38, 36, 1, 35, 0, 158, 150, 'active'),
	(39, 35, 0, 36, 1, 146, 152, 'active'),
	(40, 37, 1, 38, 0, 147, 150, 'active'),
	(41, 38, 0, 37, 1, 146, 152, 'active'),
	(42, 38, 0, 38, 1, 148, 154, 'active'),
	(43, 141, 0, NULL, NULL, 147, 151, 'active'),
	(44, NULL, NULL, 141, 0, 144, 149, 'active'),
	(45, 141, 0, 141, 0, 145, 153, 'active'),
	(46, 141, 0, 141, 1, 148, 154, 'active'),
	(47, 141, 1, 142, 0, 145, 150, 'active'),
	(48, 142, 0, 141, 1, 146, 152, 'active'),
	(49, 141, 1, 143, 0, 147, 150, 'active'),
	(50, 143, 0, 141, 1, 146, 152, 'active'),
	(51, 142, 0, 142, 0, 145, 153, 'active'),
	(52, 142, 0, 142, 1, 148, 154, 'active'),
	(53, 142, 1, 142, 0, 145, 150, 'active'),
	(54, 142, 0, 142, 1, 146, 152, 'active'),
	(55, 142, 1, 143, 0, 147, 150, 'active'),
	(56, 143, 0, 142, 1, 146, 152, 'active'),
	(57, 143, 0, 143, 1, 148, 154, 'active');


INSERT INTO `adm_integrate_template` (`id_adm_integrate_template`, `ci_type_id`, `name`, `des`) VALUES
	(1, 21, 'MockA-MockB', 'MockA-MockB');

INSERT INTO `adm_integrate_template_alias` (`id_alias`, `id_adm_ci_type`, `id_adm_integrate_template`, `alias`) VALUES
	(1, 21, 1, 'MockA'),
	(2, 22, 1, 'MockB');

INSERT INTO `adm_integrate_template_alias_attr` (`id_attr`, `id_alias`, `id_ci_type_attr`, `is_condition`, `is_displayed`, `mapping_name`, `filter`, `key_name`, `seq_no`, `cn_alias`, `sys_attr`) VALUES
	(1, 1, 228, '1', '1', 'Mock_Attr_A', NULL, 'MockA-MockB$mock_attr_a', 1, NULL, NULL),
	(2, 2, 235, '1', '1', 'Mock_Attr_B', NULL, 'MockA-MockB$mock_attr_b', 1, NULL, NULL);

INSERT INTO `adm_integrate_template_relation` (`id_relation`, `child_alias_id`, `child_ref_attr_id`, `parent_alias_id`, `is_refered_from_parent`) VALUES
	(1, 1, 236, 2, 0);

INSERT INTO adm_role (id_adm_role, role_name,description,id_adm_tenement,parent_id_adm_role,role_type,is_system) VALUES
(1,'SUPER_ADMIN','超级管理员',NULL,NULL,'ADMIN',1)
,(2,'CMDB_ADMIN','CMDB管理员',NULL,NULL,'ADMIN',0)
,(3,'PLUGIN_ADMIN','插件管理员',NULL,NULL,'ADMIN',0)
,(4,'IDC_ARCHITECT','基础架构规划-IDC',NULL,NULL,'ADMIN',0)
,(5,'NETWORK_ARCHITECT','基础架构规划-网络',NULL,NULL,'ADMIN',0)
,(6,'APP_ARCHITECT','应用架构师',NULL,NULL,'ADMIN',0)
,(7,'OPS-PROD','生产环境运维',NULL,NULL,'ADMIN',0)
,(8,'OPS-TEST','测试环境运维',NULL,NULL,'ADMIN',0)
,(9,'DEVELOPER','开发人员',NULL,NULL,'ADMIN',0)
,(10,'REGULAR','普通用户',NULL,NULL,'REGULAR',0)
,(11,'READONLY','只读用户',NULL,NULL,'READONLY',0)
;

INSERT INTO adm_user (id_adm_user, name, code, description,is_system) VALUES
('1001', 'mock_user1','mock_user1','mock_user1',1)
,('1002', 'mock_user2','mock_user2','mock_user2',0)
,('1003', 'mock_user3','mock_user3','mock_user3',0)
,('1004', 'mock_user4','mock_user4','mock_user4',0)
;
INSERT INTO adm_role_user (id_adm_role_user, id_adm_role, id_adm_user, is_system) VALUES
(1, 1,'1001',1)
,(2, 1,'1002',0)
,(3, 1,'1003',0)
;

INSERT INTO adm_role_ci_type (id_adm_role_ci_type, id_adm_role,id_adm_ci_type,ci_type_name,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES
(1,1,1,'系统设计','Y','N','Y','N','Y','N')
,(2,1,7,'子系统','N','N','Y','N','N','N')
,(3,1,12,'主机','N','N','N','Y','N','N')
,(4,1,16,'机房','N','N','N','N','Y','N')
,(5,1,22,'机房设计','N','N','N','N','N','Y')
;

INSERT INTO adm_role_ci_type_ctrl_attr (id_adm_role_ci_type_ctrl_attr, id_adm_role_ci_type,creation_permission,removal_permission,modification_permission,enquiry_permission,execution_permission,grant_permission) VALUES
(1, 1,'Y','Y','Y','N','N','N')
,(2, 1,'N','N','N','N','N','N')
,(3, 1,'N','N','N','N','N','N')
,(4, 1,'N','N','N','N','N','N')
;

INSERT INTO adm_role_ci_type_ctrl_attr_condition (id_adm_role_ci_type_ctrl_attr_condition, id_adm_role_ci_type_ctrl_attr,id_adm_ci_type_attr,condition_value,ci_type_attr_name) VALUES
(1,1,11,NULL,'业务群组1')
,(2,1,12,NULL,'业务群组2')
,(3,1,13,NULL,'业务群组3')
,(4,1,14,NULL,'业务群组4')
,(5,1,15,'42,43','业务群组')
;

INSERT INTO adm_menu (id_adm_menu, name,other_name,url,seq_no,remark,parent_id_adm_menu,class_path,is_active) VALUES
(1, 'menuA','','menuA/index.html',1,NULL,NULL,NULL,0)
,(2, 'menuB','','menuB/index.html',2,NULL,NULL,NULL,0)
,(3, 'menuC','','menuC/index.html',3,NULL,NULL,NULL,0)
,(4, 'menuD','','menuD/index.html',4,NULL,NULL,NULL,0)
;

INSERT INTO adm_role_menu (id_adm_role_menu, id_adm_role,id_adm_menu,is_system) VALUES
(1,1,1,1)
,(2,1,2,0)
,(3,1,3,0)
;

INSERT INTO `adm_files` (`id_adm_file`, `type`, `name`, `content`) VALUES
	(1, 'image/png', 'img', null);
