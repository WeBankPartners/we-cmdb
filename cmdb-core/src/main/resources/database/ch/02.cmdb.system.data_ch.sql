SET FOREIGN_KEY_CHECKS=0;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*!40000 ALTER TABLE `adm_attr_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `adm_attr_group` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_basekey_cat` DISABLE KEYS */;
INSERT INTO `adm_basekey_cat` (`id_adm_basekey_cat`, `cat_name`, `description`, `id_adm_role`, `id_adm_basekey_cat_type`, `group_type_id`) VALUES
	(1, 'ci_layer', '层级', NULL, 1, NULL),
	(2, 'ci_catalog', '目录', NULL, 1, NULL),
	(3, 'ci_zoom_level', 'Zoom', NULL, 1, NULL),
	(4, 'ci_attr_type', '属性类型', NULL, 1, NULL),
	(5, 'ci_attr_enum_type', '枚举类型', NULL, 1, NULL),
	(6, 'ci_attr_ref_type', '引用类型', NULL, 1, NULL),
	(7, 'ci_state_design', '设计类CI状态', NULL, 1, NULL),
	(8, 'ci_state_create', '可创建类CI状态', NULL, 1, NULL),
	(9, 'ci_state_start_stop', '可起停类CI状态', NULL, 1, NULL),
	(10, 'state_transition_operation', '状态迁移操作', NULL, 1, NULL),
	(11, 'state_transition_action', '状态迁移动作', NULL, 1, NULL),
	(12, 'tab_of_planning_design', '规划设计CI标签', NULL, 1, NULL),
	(13, 'tab_query_of_planning_design', '规划设计标签查询', NULL, 1, 12),
	(14, 'tab_of_resourse_planning', '资源规划CI标签', NULL, 1, NULL),
	(15, 'tab_query_of_resourse_planning', '资源规划标签查询', NULL, 1, 14),
	(16, 'tab_of_architecture_design', '架构设计CI标签', NULL, 1, NULL),
	(17, 'tab_query_of_architecture_design', '架构设计标签查询', NULL, 1, 16),
	(18, 'tab_of_deploy_design', '部署设计CI标签', NULL, 1, NULL),
	(19, 'tab_query_of_deploy_design', '部署设计标签查询', NULL, 1, 18),
	(20, 'view_config_params', '视图初始化参数', NULL, 1, NULL),
	(21, 'view_ci_type_id', '视图相关CI的ID', NULL, 1, NULL);
/*!40000 ALTER TABLE `adm_basekey_cat` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_basekey_cat_type` DISABLE KEYS */;
INSERT INTO `adm_basekey_cat_type` (`id_adm_basekey_cat_type`, `name`, `description`, `ci_type_id`, `type`) VALUES
	(1, 'sys', NULL, NULL, 1),
	(2, 'common', NULL, NULL, 2),
	(3, 'manage_role', '管理角色', 1, 3),
	(4, 'unit_type', '单元类型', 2, 3),
	(5, 'deploy_environment', '部署环境', 3, 3),
	(6, 'legal_person', '法人', 4, 3),
	(7, 'application_domain', '应用域', 5, 3),
	(8, 'cloud_vendor', '公有云厂家', 6, 3),
	(9, 'cluster_type', '集群类型', 7, 3),
	(10, 'cluster_node_type', '集群节点类型', 8, 3),
	(11, 'resource_instance_type', '资源实例类型', 9, 3),
	(12, 'resource_instance_spec', '资源实例规格', 10, 3),
	(13, 'resource_instance_system', '资源实例系统', 11, 3),
	(14, 'data_center_design', '数据中心设计', 12, 3),
	(15, 'network_segment_design', '网段设计', 13, 3),
	(16, 'network_zone_design', '网络区域设计', 14, 3),
	(17, 'default_security_policy_d', '默认安全策略设计', 15, 3),
	(18, 'network_zone_link_design', '网络区域连接设计', 16, 3),
	(20, 'business_zone_design', '业务区域设计', 18, 3),
	(21, 'resource_set_design', '资源集合设计', 19, 3),
	(22, 'resource_set_route_design', '资源集合路由设计', 20, 3),
	(23, 'resource_set_invoke_desig', '资源集合调用设计', 21, 3),
	(24, 'data_center', '数据中心', 22, 3),
	(25, 'network_segment', '网段', 23, 3),
	(26, 'network_zone', '网络区域', 24, 3),
	(27, 'default_security_policy', '默认安全策略', 25, 3),
	(28, 'network_zone_link', '网络区域连接', 26, 3),
	(30, 'business_zone', '业务区域', 28, 3),
	(31, 'resource_set', '资源集合', 29, 3),
	(32, 'resource_set_route', '资源集合路由', 30, 3),
	(33, 'ip_address', 'IP地址', 31, 3),
	(34, 'host_resource_instance', '主机资源实例', 32, 3),
	(35, 'rdb_resource_instance', '数据库资源实例', 33, 3),
	(36, 'cache_resource_instance', '缓存资源实例', 34, 3),
	(37, 'lb_resource_instance', '负载均衡资源实例', 35, 3),
	(38, 'block_storage', '块存储', 36, 3),
	(39, 'app_system_design', '应用系统设计', 37, 3),
	(40, 'subsys_design', '子系统设计', 38, 3),
	(41, 'unit_design', '单元设计', 39, 3),
	(42, 'invoke_design', '调用设计', 40, 3),
	(43, 'service_design', '服务设计', 41, 3),
	(44, 'service_invoke_design', '服务调用设计', 42, 3),
	(45, 'service_invoke_seq_design', '服务调用时序设计', 43, 3),
	(46, 'diff_configuration', '差异化变量', 44, 3),
	(47, 'deploy_package', '部署物料包', 45, 3),
	(48, 'app_system', '应用系统', 46, 3),
	(49, 'subsys', '子系统', 47, 3),
	(50, 'unit', '单元', 48, 3),
	(51, 'invoke', '调用', 49, 3),
	(52, 'app_instance', '应用实例', 50, 3),
	(53, 'rdb_instance', '数据库实例', 51, 3),
	(54, 'cache_instance', '缓存实例', 52, 3),
	(55, 'lb_instance', '负载均衡实例', 53, 3),
	(56, 'network_link_type', '网络连接类型', 54, 3),
	(59, 'storage_type', '存储类型', 62, 3),
	(60, 'charge_type', '计费模式', 63, 3);
/*!40000 ALTER TABLE `adm_basekey_cat_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_basekey_code` DISABLE KEYS */;
INSERT INTO `adm_basekey_code` (`id_adm_basekey`, `id_adm_basekey_cat`, `code`, `value`, `group_code_id`, `code_description`, `seq_no`, `status`) VALUES
	(1, 1, 'app_architecture_layer', '应用架构层', NULL, '应用架构层', 1, 'active'),
	(2, 1, 'app_develop_layer', '应用开发层', NULL, '应用开发层', 2, 'active'),
	(3, 1, 'app_deploy_layer', '应用部署层', NULL, '应用部署层', 3, 'active'),
	(4, 1, 'res_instance_layer', '资源实例层', NULL, '资源实例层', 4, 'active'),
	(5, 1, 'res_planning_layer', '资源规划层', NULL, '资源规划层', 5, 'active'),
	(6, 1, 'res_architecture_layer', '资源架构层', NULL, '资源架构层', 6, 'active'),
	(7, 2, 'app_architecture_layer', '应用架构层', NULL, '应用架构层', 1, 'active'),
	(8, 2, 'app_develop_layer', '应用开发层', NULL, '应用开发层', 2, 'active'),
	(9, 2, 'app_deploy_layer', '应用部署层', NULL, '应用部署层', 3, 'active'),
	(10, 2, 'res_instance_layer', '资源实例层', NULL, '资源实例层', 4, 'active'),
	(11, 2, 'res_planning_layer', '资源规划层', NULL, '资源规划层', 5, 'active'),
	(12, 2, 'res_architecture_layer', '资源架构层', NULL, '资源架构层', 6, 'active'),
	(13, 3, '1', '常规图层', NULL, '常规图层', 1, 'active'),
	(14, 3, '2', '网络图层', NULL, '网络图层', 2, 'active'),
	(15, 3, '3', '基础图层', NULL, '基础图层', 3, 'active'),
	(16, 4, 'text', '文本', NULL, '文本', 1, 'active'),
	(17, 4, 'area', '文本域', NULL, '文本域', 2, 'active'),
	(18, 4, 'number', '整型数字', NULL, '整型数字', 3, 'active'),
	(19, 4, 'regular_text', '正则校验文本', NULL, '正则校验文本', 4, 'inactive'),
	(20, 4, 'datetime', '时间', NULL, '时间', 5, 'active'),
	(21, 4, 'select', '下拉选择', NULL, '下拉选择', 6, 'active'),
	(22, 4, 'multi_enum', '多选下拉选择', NULL, '多选下拉选择', 7, 'active'),
	(23, 4, 'ref', '引用', NULL, '引用', 8, 'active'),
	(24, 4, 'multi_ref', '多选引用', NULL, '多选引用', 9, 'active'),
	(25, 4, 'password', '密码', NULL, '密码', 10, 'active'),
	(26, 4, '预留3', '预留3', NULL, '预留3', 11, 'inactive'),
	(27, 5, 'common', '公共枚举', NULL, '公共枚举', 1, 'active'),
	(28, 5, 'private', '私有枚举', NULL, '私有枚举', 2, 'active'),
	(29, 6, 'belong', '属于', NULL, '属于', 1, 'active'),
	(30, 6, 'use', '使用', NULL, '使用', 2, 'active'),
	(31, 6, 'depend', '依赖', NULL, '依赖', 3, 'active'),
	(32, 6, 'relation', '关联', NULL, '关联', 4, 'active'),
	(33, 6, 'realize', '实现', NULL, '实现', 5, 'active'),
	(34, 7, 'new', '新增', NULL, NULL, 1, 'active'),
	(35, 7, 'update', '更新', NULL, NULL, 2, 'active'),
	(36, 7, 'deleted', '删除', NULL, NULL, 3, 'active'),
	(37, 8, 'created', '创建', NULL, NULL, 6, 'active'),
	(38, 8, 'changed', '变更', NULL, NULL, 7, 'active'),
	(39, 8, 'destroyed', '销毁', NULL, NULL, 8, 'active'),
	(40, 9, 'created', '创建', NULL, NULL, 1, 'active'),
	(41, 9, 'startup', '启动', NULL, NULL, 2, 'active'),
	(42, 9, 'changed', '变更', NULL, NULL, 3, 'active'),
	(43, 9, 'stoped', '停止', NULL, NULL, 4, 'active'),
	(44, 9, 'destroyed', '销毁', NULL, NULL, 5, 'active'),
	(45, 10, 'insert', '添加', NULL, NULL, 1, 'active'),
	(46, 10, 'update', '更新', NULL, NULL, 2, 'active'),
	(47, 10, 'discard', '放弃', NULL, NULL, 3, 'active'),
	(48, 10, 'delete', '删除', NULL, NULL, 4, 'active'),
	(49, 10, 'confirm', '确认', NULL, NULL, 5, 'active'),
	(50, 10, 'startup', '启动', NULL, NULL, 6, 'active'),
	(51, 10, 'stop', '停止', NULL, NULL, 7, 'active'),
	(52, 11, 'insert', '插入', NULL, NULL, 1, 'active'),
	(53, 11, 'insert-update', '插入-更新', NULL, NULL, 2, 'active'),
	(54, 11, 'delete', '删除', NULL, NULL, 3, 'active'),
	(55, 11, 'update-delete', '更新-删除', NULL, NULL, 4, 'active'),
	(56, 11, 'update', '更新', NULL, NULL, 5, 'active'),
	(57, 11, 'confirm', '确认', NULL, NULL, 6, 'active'),
	(58, 20, 'idcPlanningLinkFrom', 'network_segment_design_1', NULL, NULL, 1, 'active'),
	(59, 20, 'idcPlanningLinkTo', 'network_segment_design_2', NULL, NULL, 2, 'active'),
	(60, 20, 'idcPlanningLayer', 'network_zone_layer', NULL, NULL, 3, 'active'),
	(61, 20, 'idcPlanningNetworkSegmentDesign', 'network_segment_design', NULL, NULL, 4, 'active'),
	(62, 20, 'resourcePlaningRegionalDataCenter', 'regional_data_center', NULL, NULL, 5, 'active'),
	(63, 20, 'resourcePlaningNetworkSegmentDesign', 'network_segment', NULL, NULL, 6, 'active'),
	(64, 20, 'resourcePlaningDataCenter', 'data_center', NULL, NULL, 7, 'active'),
	(65, 20, 'resourcePlaningVpcNetworkZone', 'vpc_network_zone', NULL, NULL, 8, 'active'),
	(66, 20, 'resourcePlaningLinkFrom', 'network_segment_1', NULL, NULL, 9, 'active'),
	(67, 20, 'resourcePlaningLinkTo', 'network_segment_2', NULL, NULL, 10, 'active'),
	(68, 20, 'appArchitectureDesignServiceDesign', 'service_design', NULL, NULL, 11, 'active'),
	(69, 20, 'appArchitectureDesignServiceType', 'service_type', NULL, NULL, 12, 'active'),
	(70, 20, 'appArchitectureDesignServiceInvokeDesignSequence', 'service_invoke_design_sequence', NULL, NULL, 13, 'active'),
	(71, 20, 'appArchitectureDesignInvokeDiagramLinkFrom', 'invoke_unit_design', NULL, NULL, 14, 'active'),
	(72, 20, 'appArchitectureDesignInvokeDiagramLinkTo', 'invoked_unit_design', NULL, NULL, 15, 'active'),
	(73, 20, 'appDeploymentDesignResourceInstance', 'resource_instance', NULL, NULL, 16, 'active'),
	(74, 20, 'appDeploymentDesignInvokeUnit', 'invoke_unit', NULL, NULL, 17, 'active'),
	(75, 20, 'appDeploymentDesignInvokedUnit', 'invoked_unit', NULL, NULL, 18, 'active'),
	(77, 20, 'appArchitectureDesignSyetemDesign', 'app_system_design', NULL, NULL, 19, 'active'),
	(78, 20, 'appArchitectureDesignInvokeDesign', 'invoke_design', NULL, NULL, 20, 'active'),
	(79, 20, 'appArchitectureDesignUnitDesignId', '39', NULL, NULL, 21, 'active'),
	(80, 20, 'appArchitectureDesignInvokeDesignId', '40', NULL, NULL, 22, 'active'),
	(81, 20, 'appArchitectureDesignServiceInvokeDesignId', '42', NULL, NULL, 23, 'active'),
	(83, 20, 'appArchitectureDesignInvokeSequenceId', '43', NULL, NULL, 24, 'active'),
	(89, 19, 'guid_of_deploy_detail', '[{"ciTypeId": 47},{ "ciTypeId": 38, "parentRs": { "attrId": 870, "isReferedFromParent": 1}},{ "ciTypeId": 37,"parentRs": { "attrId": 709,"isReferedFromParent": 1}}]', NULL, NULL, 8, 'active'),
	(90, 21, 'ciTypeIdOfSystemDesign', '37', NULL, NULL, NULL, 'active'),
	(91, 21, 'ciTypeIdOfSubsystemDesign', '38', NULL, NULL, NULL, 'active'),
	(92, 21, 'ciTypeIdOfUnitDesign', '39', NULL, NULL, NULL, 'active'),
	(93, 21, 'ciTypeIdOfUnit', '48', NULL, NULL, NULL, 'active'),
	(94, 21, 'ciTypeIdOfSubsys', '47', NULL, NULL, NULL, 'active'),
	(95, 21, 'ciTypeIdOfSystem', '46', NULL, NULL, NULL, 'active'),
	(96, 21, 'ciTypeIdOfHost', '32', NULL, NULL, NULL, 'active'),
	(97, 21, 'ciTypeIdOfInstance', '50', NULL, NULL, NULL, 'active'),
	(98, 21, 'ciTypeIdOfIdc', '22', NULL, NULL, NULL, 'active'),
	(99, 21, 'ciTypeIdOfZone', '24', NULL, NULL, NULL, 'active'),
	(100, 21, 'ciTypeIdOfZoneLink', '26', NULL, NULL, NULL, 'active'),
	(101, 21, 'ciTypeIdOfIdcDesign', '12', NULL, NULL, NULL, 'active'),
	(102, 21, 'ciTypeIdOfZoneDesign', '14', NULL, NULL, NULL, 'active'),
	(103, 21, 'ciTypeIdOfZoneLinkDesign', '16', NULL, NULL, NULL, 'active'),
	(104, 12, '13', '网段设计', NULL, NULL, 1, 'active'),
	(105, 12, '14', '网络区域设计', NULL, NULL, 2, 'active'),
	(106, 12, '15', '默认安全策略设计', NULL, NULL, 3, 'active'),
	(107, 12, '16', '网络连接设计', NULL, NULL, 4, 'active'),
	(111, 12, '20', '路由设计', NULL, NULL, 5, 'active'),
	(112, 12, '18', '业务区域设计', NULL, NULL, 6, 'active'),
	(113, 12, '19', '资源集合设计', NULL, NULL, 7, 'active'),
	(114, 12, '21', '资源集合调用设计', NULL, NULL, 8, 'active'),
	(115, 13, 'network_segment_design', '[{"ciTypeId":13},{"ciTypeId":12,"parentRs":{"attrId":193,"isReferedFromParent":1}}]', 104, NULL, 1, 'active'),
	(116, 13, 'network_zone_design', '[{"ciTypeId":14},{"ciTypeId":12,"parentRs":{"attrId":209,"isReferedFromParent":1}}]', 105, NULL, 2, 'active'),
	(117, 13, 'default_security_policy_design', '[{"ciTypeId":15},{"ciTypeId":13,"parentRs":{"attrId":225,"isReferedFromParent":1}},{"ciTypeId":12,"parentRs":{"attrId":193,"isReferedFromParent":1}}]', 106, NULL, 3, 'active'),
	(118, 13, 'network_link_design', '[{"ciTypeId":16},{"ciTypeId":13,"parentRs":{"attrId":245,"isReferedFromParent":1}},{"ciTypeId":12,"parentRs":{"attrId":193,"isReferedFromParent":1}}]', 107, NULL, 4, 'active'),
	(119, 13, 'route_design', '[{"ciTypeId":20},{"ciTypeId":13,"parentRs":{"attrId":308,"isReferedFromParent":1}},{"ciTypeId":12,"parentRs":{"attrId":193,"isReferedFromParent":1}}]', 111, NULL, 5, 'active'),
	(120, 13, 'business_zone_design', '[{"ciTypeId":18},{"ciTypeId":14,"parentRs":{"attrId":276,"isReferedFromParent":1}},{"ciTypeId":12,"parentRs":{"attrId":209,"isReferedFromParent":1}}]', 112, NULL, 6, 'active'),
	(121, 13, 'resource_set_design', '[{"ciTypeId":19},{"ciTypeId":18,"parentRs":{"attrId":292,"isReferedFromParent":1}},{"ciTypeId":14,"parentRs":{"attrId":276,"isReferedFromParent":1}},{"ciTypeId":12,"parentRs":{"attrId":209,"isReferedFromParent":1}}]', 113, NULL, 7, 'active'),
	(122, 13, 'resource_set_invoke_design', '[{"ciTypeId":21},{"ciTypeId":19,"parentRs":{"attrId":324,"isReferedFromParent":1}},{"ciTypeId":18,"parentRs":{"attrId":292,"isReferedFromParent":1}},{"ciTypeId":14,"parentRs":{"attrId":276,"isReferedFromParent":1}},{"ciTypeId":12,"parentRs":{"attrId":209,"isReferedFromParent":1}}]', 114, NULL, 8, 'active'),
	(123, 14, '23', '网段', NULL, NULL, 1, 'active'),
	(124, 14, '24', '网络区域', NULL, NULL, 2, 'active'),
	(125, 14, '25', '默认安全策略', NULL, NULL, 3, 'active'),
	(126, 14, '26', '网络连接', NULL, NULL, 4, 'active'),
	(127, 14, '30', '路由', NULL, NULL, 5, 'active'),
	(128, 14, '28', '业务区域', NULL, NULL, 6, 'active'),
	(129, 14, '29', '资源集合', NULL, NULL, 7, 'active'),
	(130, 14, '31', 'IP地址', NULL, NULL, 8, 'active'),
	(131, 15, 'network_segment', '[{"ciTypeId":23},{"ciTypeId":22,"parentRs":{"attrId":361,"isReferedFromParent":1}}]', 123, NULL, 1, 'active'),
	(132, 15, 'network_zone', '[{"ciTypeId":24},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 124, NULL, 2, 'active'),
	(133, 15, 'default_security_policy', '[{"ciTypeId":25},{"ciTypeId":23,"parentRs":{"attrId":403,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":361,"isReferedFromParent":1}}]', 125, NULL, 3, 'active'),
	(134, 15, 'network_link', '[{"ciTypeId":26},{"ciTypeId":23,"parentRs":{"attrId":424,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":361,"isReferedFromParent":1}}]', 126, NULL, 4, 'active'),
	(135, 15, 'route', '[{"ciTypeId":30},{"ciTypeId":23,"parentRs":{"attrId":505,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":361,"isReferedFromParent":1}}]', 127, NULL, 5, 'active'),
	(136, 15, 'business_zone', '[{"ciTypeId":28},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 128, NULL, 6, 'active'),
	(137, 15, 'resource_set', '[{"ciTypeId":29},{"ciTypeId":28,"parentRs":{"attrId":481,"isReferedFromParent":1}},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 129, NULL, 7, 'active'),
	(138, 15, 'ip_address', '[{"ciTypeId":31},{"ciTypeId":23,"parentRs":{"attrId":522,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":361,"isReferedFromParent":1}}]', 130, NULL, 8, 'active'),
	(139, 14, '32', '主机资源实例', NULL, NULL, 9, 'active'),
	(140, 14, '33', '数据库资源实例', NULL, NULL, 10, 'active'),
	(141, 14, '34', '缓存资源实例', NULL, NULL, 11, 'active'),
	(142, 14, '35', '负载均衡资源实例', NULL, NULL, 12, 'active'),
	(143, 14, '36', '块存储', NULL, NULL, 13, 'active'),
	(144, 15, 'host_resource_instance', '[{"ciTypeId":32},{"ciTypeId":29,"parentRs":{"attrId":538,"isReferedFromParent":1}},{"ciTypeId":28,"parentRs":{"attrId":481,"isReferedFromParent":1}},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 139, NULL, 9, 'active'),
	(145, 15, 'rdb_resource_instance', '[{"ciTypeId":33},{"ciTypeId":29,"parentRs":{"attrId":573,"isReferedFromParent":1}},{"ciTypeId":28,"parentRs":{"attrId":481,"isReferedFromParent":1}},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 140, NULL, 10, 'active'),
	(146, 15, 'cache_resource_instance', '[{"ciTypeId":34},{"ciTypeId":29,"parentRs":{"attrId":608,"isReferedFromParent":1}},{"ciTypeId":28,"parentRs":{"attrId":481,"isReferedFromParent":1}},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 141, NULL, 11, 'active'),
	(147, 15, 'lb_resource_instance', '[{"ciTypeId":35},{"ciTypeId":29,"parentRs":{"attrId":643,"isReferedFromParent":1}},{"ciTypeId":28,"parentRs":{"attrId":481,"isReferedFromParent":1}},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 142, NULL, 12, 'active'),
	(148, 15, 'block_storage', '[{"ciTypeId":36},{"ciTypeId":32,"parentRs":{"attrId":669,"isReferedFromParent":1}},{"ciTypeId":29,"parentRs":{"attrId":538,"isReferedFromParent":1}},{"ciTypeId":28,"parentRs":{"attrId":481,"isReferedFromParent":1}},{"ciTypeId":24,"parentRs":{"attrId":463,"isReferedFromParent":1}},{"ciTypeId":22,"parentRs":{"attrId":383,"isReferedFromParent":1}}]', 143, NULL, 13, 'active'),
	(149, 16, '38', '子系统设计', NULL, NULL, 1, 'active'),
	(150, 16, '39', '单元设计', NULL, NULL, 2, 'active'),
	(151, 16, '40', '调用设计', NULL, NULL, 3, 'active'),
	(152, 16, '41', '服务设计', NULL, NULL, 4, 'active'),
	(153, 16, '42', '服务调用设计', NULL, NULL, 5, 'active'),
	(154, 16, '43', '服务调用时序设计', NULL, NULL, 6, 'active'),
	(155, 17, 'subsys_design', '[{"ciTypeId":38},{"ciTypeId":37,"parentRs":{"attrId":709,"isReferedFromParent":1}}]', 149, NULL, 1, 'active'),
	(156, 17, 'unit_design', '[{"ciTypeId":39},{"ciTypeId":38,"parentRs":{"attrId":726,"isReferedFromParent":1}},{"ciTypeId":37,"parentRs":{"attrId":709,"isReferedFromParent":1}}]', 150, NULL, 2, 'active'),
	(157, 17, 'invoke_design', '[{"ciTypeId":40},{"ciTypeId":39,"parentRs":{"attrId":745,"isReferedFromParent":1}},{"ciTypeId":38,"parentRs":{"attrId":726,"isReferedFromParent":1}},{"ciTypeId":37,"parentRs":{"attrId":709,"isReferedFromParent":1}}]', 151, NULL, 3, 'active'),
	(158, 17, 'service_design', '[{"ciTypeId":41},{"ciTypeId":39,"parentRs":{"attrId":762,"isReferedFromParent":1}},{"ciTypeId":38,"parentRs":{"attrId":726,"isReferedFromParent":1}},{"ciTypeId":37,"parentRs":{"attrId":709,"isReferedFromParent":1}}]', 152, NULL, 4, 'active'),
	(159, 17, 'service_invoke_design', '[{"ciTypeId":42},{"ciTypeId":39,"parentRs":{"attrId":780,"isReferedFromParent":1}},{"ciTypeId":38,"parentRs":{"attrId":726,"isReferedFromParent":1}},{"ciTypeId":37,"parentRs":{"attrId":709,"isReferedFromParent":1}}]', 153, NULL, 5, 'active'),
	(160, 17, 'service_invoke_seq_design', '[{"ciTypeId":42},{"ciTypeId":37,"parentRs":{"attrId":796,"isReferedFromParent":1}}]', 154, NULL, 6, 'active'),
	(161, 18, '47', '子系统', NULL, NULL, 1, 'active'),
	(162, 18, '48', '单元', NULL, NULL, 2, 'active'),
	(163, 18, '49', '调用', NULL, NULL, 3, 'active'),
	(164, 18, '50', '应用实例', NULL, NULL, 4, 'active'),
	(165, 18, '51', '数据库实例', NULL, NULL, 5, 'active'),
	(166, 18, '52', '缓存实例', NULL, NULL, 6, 'active'),
	(167, 18, '53', '负载均衡实例', NULL, NULL, 7, 'active'),
	(168, 19, 'subsys', '[{"ciTypeId":47},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 161, NULL, 9, 'active'),
	(169, 19, 'unit', '[{"ciTypeId":48},{"ciTypeId":47,"parentRs":{"attrId":886,"isReferedFromParent":1}},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 162, NULL, 10, 'active'),
	(170, 19, 'invoke', '[{"ciTypeId":49},{"ciTypeId":48,"parentRs":{"attrId":908,"isReferedFromParent":1}},{"ciTypeId":47,"parentRs":{"attrId":886,"isReferedFromParent":1}},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 163, NULL, 11, 'active'),
	(171, 19, 'app_instance', '[{"ciTypeId":50},{"ciTypeId":48,"parentRs":{"attrId":926,"isReferedFromParent":1}},{"ciTypeId":47,"parentRs":{"attrId":886,"isReferedFromParent":1}},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 164, NULL, 12, 'active'),
	(172, 19, 'rdb_instance', '[{"ciTypeId":51},{"ciTypeId":48,"parentRs":{"attrId":956,"isReferedFromParent":1}},{"ciTypeId":47,"parentRs":{"attrId":886,"isReferedFromParent":1}},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 165, NULL, 13, 'active'),
	(173, 19, 'cache_instance', '[{"ciTypeId":52},{"ciTypeId":48,"parentRs":{"attrId":984,"isReferedFromParent":1}},{"ciTypeId":47,"parentRs":{"attrId":886,"isReferedFromParent":1}},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 166, NULL, 14, 'active'),
	(174, 19, 'lb_instance', '[{"ciTypeId":53},{"ciTypeId":48,"parentRs":{"attrId":1003,"isReferedFromParent":1}},{"ciTypeId":47,"parentRs":{"attrId":886,"isReferedFromParent":1}},{"ciTypeId":46,"parentRs":{"attrId":869,"isReferedFromParent":1}}]', 167, NULL, 15, 'active'),
	(175, 20, 'appDeploymentDesignUnitId', '48', NULL, NULL, 25, 'active'),
	(176, 20, 'appDeploymentDesignInvokeId', '49', NULL, NULL, 26, 'active'),
	(177, 20, 'appDeploymentDesignBusinessAppInstanceId', '50,51,52,53', NULL, NULL, 27, 'active'),
	(178, 20, 'resourcePlaningLinkId', '26', NULL, NULL, 28, 'active'),
	(179, 20, 'idcPlanningLinkId', '16', NULL, NULL, 29, 'active'),
	(180, 20, 'appArchitectureDesignInvokeType', 'invoke_type', NULL, NULL, 30, 'active');
/*!40000 ALTER TABLE `adm_basekey_code` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_ci_type` DISABLE KEYS */;
INSERT INTO `adm_ci_type` (`id_adm_ci_type`, `name`, `image_file_id`, `description`, `id_adm_tenement`, `table_name`, `status`, `catalog_id`, `ci_global_unique_id`, `seq_no`, `layer_id`, `zoom_level_id`, `ci_state_type`) VALUES
	(1, '管理角色', 1, '管理角色', NULL, 'manage_role', 'created', 7, NULL, 1, 1, 15, NULL),
	(2, '单元类型', 1, '单元类型', NULL, 'unit_type', 'created', 7, NULL, 2, 1, 15, NULL),
	(3, '部署环境', 1, '部署环境', NULL, 'deploy_environment', 'created', 9, NULL, 1, 3, 15, NULL),
	(4, '法人', 1, '法人', NULL, 'legal_person', 'created', 9, NULL, 2, 3, 15, NULL),
	(5, '应用域', 1, '应用域', NULL, 'application_domain', 'created', 12, NULL, 1, 6, 15, NULL),
	(6, '云厂商', 1, '公有云厂家', NULL, 'cloud_vendor', 'created', 11, NULL, 1, 5, 15, NULL),
	(7, '集群类型', 1, '集群类型', NULL, 'cluster_type', 'created', 11, NULL, 2, 5, 15, NULL),
	(8, '集群节点类型', 1, '集群节点类型', NULL, 'cluster_node_type', 'created', 10, NULL, 1, 4, 15, NULL),
	(9, '资源实例类型', 1, '资源实例类型', NULL, 'resource_instance_type', 'created', 10, NULL, 2, 4, 15, NULL),
	(10, '资源实例规格', 1, '资源实例规格', NULL, 'resource_instance_spec', 'created', 10, NULL, 3, 4, 15, NULL),
	(11, '资源实例系统', 1, '资源实例系统', NULL, 'resource_instance_system', 'created', 10, NULL, 4, 4, 15, NULL),
	(12, '数据中心设计', 22, '数据中心设计', NULL, 'data_center_design', 'created', 12, NULL, 2, 6, 13, NULL),
	(13, '网段设计', 21, '网段设计', NULL, 'network_segment_design', 'created', 12, NULL, 3, 6, 14, NULL),
	(14, '网络区域设计', 23, '网络区域设计', NULL, 'network_zone_design', 'created', 12, NULL, 4, 6, 13, NULL),
	(15, '默认安全策略设计', 15, '默认安全策略设计', NULL, 'default_security_policy_design', 'created', 12, NULL, 5, 6, 14, NULL),
	(16, '网络连接设计', 24, '网络连接设计', NULL, 'network_link_design', 'created', 12, NULL, 6, 6, 14, NULL),
	(18, '业务区域设计', 25, '业务区域设计', NULL, 'business_zone_design', 'created', 12, NULL, 8, 6, 13, NULL),
	(19, '资源集合设计', 26, '资源集合设计', NULL, 'resource_set_design', 'created', 12, NULL, 9, 6, 13, NULL),
	(20, '路由设计', 10, '路由设计', NULL, 'route_design', 'created', 12, NULL, 10, 6, 14, NULL),
	(21, '资源集合调用设计', 15, '资源集合调用设计', NULL, 'resource_set_invoke_design', 'created', 12, NULL, 11, 6, 13, NULL),
	(22, '数据中心', 16, '数据中心', NULL, 'data_center', 'created', 11, NULL, 3, 5, 13, NULL),
	(23, '网段', 21, '网段', NULL, 'network_segment', 'created', 11, NULL, 4, 5, 14, NULL),
	(24, '网络区域', 17, '网络区域', NULL, 'network_zone', 'created', 11, NULL, 5, 5, 13, NULL),
	(25, '默认安全策略', 15, '默认安全策略', NULL, 'default_security_policy', 'created', 11, NULL, 6, 5, 14, NULL),
	(26, '网络连接', 18, '网络连接', NULL, 'network_link', 'created', 11, NULL, 7, 5, 14, NULL),
	(28, '业务区域', 19, '业务区域', NULL, 'business_zone', 'created', 11, NULL, 9, 5, 13, NULL),
	(29, '资源集合', 20, '资源集合', NULL, 'resource_set', 'created', 11, NULL, 10, 5, 13, NULL),
	(30, '路由', 10, '路由', NULL, 'route', 'created', 11, NULL, 11, 5, 14, NULL),
	(31, 'IP地址', 14, 'IP地址', NULL, 'ip_address', 'created', 10, NULL, 5, 4, 14, NULL),
	(32, '主机资源实例', 12, '主机资源实例', NULL, 'host_resource_instance', 'created', 10, NULL, 6, 4, 13, NULL),
	(33, '数据库资源实例', 12, '数据库资源实例', NULL, 'rdb_resource_instance', 'created', 10, NULL, 7, 4, 13, NULL),
	(34, '缓存资源实例', 12, '缓存资源实例', NULL, 'cache_resource_instance', 'created', 10, NULL, 8, 4, 13, NULL),
	(35, '负载均衡资源实例', 12, '负载均衡资源实例', NULL, 'lb_resource_instance', 'created', 10, NULL, 9, 4, 13, NULL),
	(36, '块存储', 13, '块存储', NULL, 'block_storage', 'created', 10, NULL, 10, 4, 13, NULL),
	(37, '应用系统设计', 1, '应用系统设计', NULL, 'app_system_design', 'created', 7, NULL, 3, 1, 13, NULL),
	(38, '子系统设计', 2, '子系统设计', NULL, 'subsys_design', 'created', 7, NULL, 4, 1, 13, NULL),
	(39, '单元设计', 3, '单元设计', NULL, 'unit_design', 'created', 7, NULL, 5, 1, 13, NULL),
	(40, '调用设计', 5, '调用设计', NULL, 'invoke_design', 'created', 7, NULL, 6, 1, 13, NULL),
	(41, '服务设计', 4, '服务设计', NULL, 'service_design', 'created', 7, NULL, 7, 1, 13, NULL),
	(42, '服务调用设计', 9, '服务调用设计', NULL, 'service_invoke_design', 'created', 7, NULL, 8, 1, 13, NULL),
	(43, '服务调用时序设计', 6, '服务调用时序设计', NULL, 'service_invoke_seq_design', 'created', 7, NULL, 9, 1, 13, NULL),
	(44, '差异化配置', 11, '差异化变量', NULL, 'diff_configuration', 'created', 8, NULL, 2, 2, 13, NULL),
	(45, '部署物料包', 2, '部署物料包', NULL, 'deploy_package', 'created', 8, NULL, 1, 2, 13, NULL),
	(46, '应用系统', 1, '应用系统', NULL, 'app_system', 'created', 9, NULL, 3, 3, 13, NULL),
	(47, '子系统', 7, '子系统', NULL, 'subsys', 'created', 9, NULL, 4, 3, 13, NULL),
	(48, '单元', 8, '单元', NULL, 'unit', 'created', 9, NULL, 5, 3, 13, NULL),
	(49, '调用', 10, '调用', NULL, 'invoke', 'created', 9, NULL, 6, 3, 13, NULL),
	(50, '应用实例', 15, '应用实例', NULL, 'app_instance', 'created', 9, NULL, 7, 3, 13, NULL),
	(51, '数据库实例', 15, '数据库实例', NULL, 'rdb_instance', 'created', 9, NULL, 8, 3, 13, NULL),
	(52, '缓存实例', 15, '缓存实例', NULL, 'cache_instance', 'created', 9, NULL, 9, 3, 13, NULL),
	(53, '负载均衡实例', 15, '负载均衡实例', NULL, 'lb_instance', 'created', 9, NULL, 10, 3, 13, NULL),
	(54, '网络连接类型', 1, '网络连接类型', NULL, 'network_link_type', 'created', NULL, NULL, 1, 5, 15, NULL),
	(62, '存储类型', 13, '存储类型', NULL, 'storage_type', 'created', NULL, NULL, 2, 4, 15, NULL),
	(63, '计费模式', 19, '计费模式', NULL, 'charge_type', 'created', NULL, NULL, 3, 4, 15, NULL);
/*!40000 ALTER TABLE `adm_ci_type` ENABLE KEYS */;


/*!40000 ALTER TABLE `adm_ci_type_attr_base` DISABLE KEYS */;
INSERT INTO `adm_ci_type_attr_base` (`id_adm_ci_type_attr`, `id_adm_ci_type`, `name`, `description`, `input_type`, `property_name`, `property_type`, `length`, `reference_id`, `reference_name`, `reference_type`, `filter_rule`, `search_seq_no`, `display_type`, `display_seq_no`, `edit_is_null`, `edit_is_only`, `edit_is_hiden`, `edit_is_editable`, `is_defunct`, `special_logic`, `status`, `is_system`, `is_access_controlled`, `is_auto`, `auto_fill_rule`, `regular_expression_rule`, `is_refreshable`) VALUES
	(1, 1, '全局唯一ID', '全局唯一ID', 'text', 'guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(2, 1, '前全局唯一ID', '前一版本数据的guid', 'text', 'p_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1),
	(3, 1, '根全局唯一ID', '原始数据guid', 'text', 'r_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(4, 1, '更新用户', '更新用户', 'text', 'updated_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1),
	(5, 1, '更新日期', '更新日期', 'date', 'updated_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1),
	(6, 1, '创建用户', '创建用户', 'text', 'created_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(7, 1, '创建日期', '创建日期', 'date', 'created_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(8, 1, '状态', '状态', 'select', 'state', 'int', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(9, 1, '唯一名称', '唯一名称', 'text', 'key_name', 'varchar', 1000, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 0),
	(10, 1, '状态编码', '状态编码', 'text', 'state_code', 'varchar', 50, NULL, NULL, NULL, NULL, 2, 1, 2, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 0),
	(11, 1, '确认日期', '确认日期', 'text', 'fixed_date', 'varchar', 19, NULL, NULL, NULL, NULL, 3, 1, 3, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(12, 1, '编码', '编码', 'text', 'code', 'varchar', 1000, NULL, NULL, NULL, NULL, 4, 1, 4, 0, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0);
/*!40000 ALTER TABLE `adm_ci_type_attr_base` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_ci_type_attr_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `adm_ci_type_attr_group` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_integrate_template` DISABLE KEYS */;
INSERT INTO `adm_integrate_template` (`id_adm_integrate_template`, `ci_type_id`, `name`, `des`) VALUES
	(2, 26, 'test', 'test');
/*!40000 ALTER TABLE `adm_integrate_template` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_integrate_template_alias` DISABLE KEYS */;
INSERT INTO `adm_integrate_template_alias` (`id_alias`, `id_adm_ci_type`, `id_adm_integrate_template`, `alias`) VALUES
	(1, 26, 2, '网络区域连接'),
	(2, 24, 2, '2-1-网络区域2-关联'),
	(3, 28, 2, '3-1-业务区域-网络区域'),
	(4, 29, 2, '4-1-资源集合-业务区域');
/*!40000 ALTER TABLE `adm_integrate_template_alias` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_integrate_template_alias_attr` DISABLE KEYS */;
INSERT INTO `adm_integrate_template_alias_attr` (`id_attr`, `id_alias`, `id_ci_type_attr`, `is_condition`, `is_displayed`, `mapping_name`, `filter`, `key_name`, `seq_no`, `cn_alias`, `sys_attr`) VALUES
	(1, 1, 422, '1', '1', '编码', NULL, 'networkZoneLink$code', 1, NULL, NULL),
	(2, 2, 382, '1', '1', '编码', NULL, 'networkZoneLink-networkZone$code', 1, NULL, NULL),
	(3, 3, 461, '1', '1', '编码', NULL, 'networkZoneLink-networkZone-businessZone$code', 1, NULL, NULL),
	(4, 4, 480, '1', '1', '编码', NULL, 'networkZoneLink-networkZone-businessZone-resourceSet$code', 1, NULL, NULL);
/*!40000 ALTER TABLE `adm_integrate_template_alias_attr` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_integrate_template_relation` DISABLE KEYS */;
INSERT INTO `adm_integrate_template_relation` (`id_relation`, `child_alias_id`, `child_ref_attr_id`, `parent_alias_id`, `is_refered_from_parent`) VALUES
	(1, 2, 424, 1, 1),
	(2, 3, 463, 2, 0),
	(3, 4, 481, 3, 0);
/*!40000 ALTER TABLE `adm_integrate_template_relation` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `adm_log` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_menu` DISABLE KEYS */;
INSERT INTO `adm_menu` (`id_adm_menu`, `name`, `other_name`, `url`, `seq_no`, `remark`, `parent_id_adm_menu`, `class_path`, `is_active`) VALUES
	(1, 'DATA_QUERY', '数据查询', NULL, 1, NULL, NULL, NULL, 0),
	(2, 'DATA_MANAGEMENT', '数据管理', NULL, 2, NULL, NULL, NULL, 0),
	(4, 'VIEW_MANAGEMENT', '视图管理', NULL, 4, NULL, NULL, NULL, 0),
	(5, 'ADMIN', '系统', NULL, 5, NULL, NULL, NULL, 0),
	(6, 'DESIGNING_CI_DATA_ENQUIRY', 'CI数据查询', NULL, 6, NULL, 1, NULL, 0),
	(7, 'DESIGNING_CI_INTEGRATED_QUERY_EXECUTION', 'CI数据综合查询', NULL, 7, NULL, 1, NULL, 0),
	(8, 'CMDB_DESIGNING_ENUM_ENQUIRY', '枚举数据查询', NULL, 8, NULL, 1, NULL, 0),
	(9, 'DESIGNING_CI_DATA_MANAGEMENT', 'CI数据管理', NULL, 9, NULL, 2, NULL, 0),
	(10, 'DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT', 'CI综合查询管理', NULL, 10, NULL, 2, NULL, 0),
	(11, 'CMDB_DESIGNING_ENUM_MANAGEMENT', '枚举数据管理', NULL, 11, NULL, 2, NULL, 0),
	(16, 'IDC_PLANNING_DESIGN', 'IDC规划设计', NULL, 16, NULL, 4, NULL, 0),
	(17, 'IDC_RESOURCE_PLANNING', 'IDC资源规划', NULL, 17, NULL, 4, NULL, 0),
	(18, 'APPLICATION_ARCHITECTURE_DESIGN', '应用架构设计', NULL, 18, NULL, 4, NULL, 0),
	(19, 'APPLICATION_DEPLOYMENT_DESIGN', '应用部署设计', NULL, 19, NULL, 4, NULL, 0),
	(20, 'ADMIN_CMDB_MODEL_MANAGEMENT', 'CMDB模型管理', NULL, 20, NULL, 5, NULL, 0),
	(21, 'ADMIN_PERMISSION_MANAGEMENT', '系统权限管理', NULL, 21, NULL, 5, NULL, 0),
	(22, 'CMDB_ADMIN_BASE_DATA_MANAGEMENT', '基础数据管理', NULL, 22, NULL, 5, NULL, 0),
	(23, 'ADMIN_QUERY_LOG', '日志查询', NULL, 23, NULL, 5, NULL, 0),
	(24, 'ADMIN_USER_PASSWORD_MANAGEMENT', '用户密码管理', NULL, 24, NULL, 5, NULL, 0);
/*!40000 ALTER TABLE `adm_menu` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_role` DISABLE KEYS */;
INSERT INTO `adm_role` (`id_adm_role`, `role_name`, `description`, `id_adm_tenement`, `parent_id_adm_role`, `role_type`, `is_system`) VALUES
	(1, 'SUPER_ADMIN', '超级管理员', NULL, NULL, 'ADMIN', 1),
	(2, 'CMDB_ADMIN', 'CMDB管理员', NULL, NULL, 'ADMIN', 0),
	(3, 'admin', NULL, NULL, NULL, NULL, NULL),
	(11, 'STG_OPS', NULL, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `adm_role` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_role_ci_type` DISABLE KEYS */;
INSERT INTO `adm_role_ci_type` (`id_adm_role_ci_type`, `id_adm_role`, `id_adm_ci_type`, `ci_type_name`, `creation_permission`, `removal_permission`, `modification_permission`, `enquiry_permission`, `execution_permission`, `grant_permission`) VALUES
	(1, 1, 1, '管理角色', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(2, 1, 2, '单元类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(3, 1, 3, '部署环境', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(4, 1, 4, '法人', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(5, 1, 5, '应用域', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(6, 1, 6, '云厂商', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(7, 1, 7, '集群类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(8, 1, 8, '集群节点类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(9, 1, 9, '资源实例类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(10, 1, 10, '资源实例规格', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(11, 1, 11, '资源实例系统', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(12, 1, 12, '数据中心设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(13, 1, 13, '网段设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(14, 1, 14, '网络区域设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(15, 1, 15, '默认安全策略设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(16, 1, 16, '网络区域连接设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(18, 1, 18, '业务区域设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(19, 1, 19, '资源集合设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(20, 1, 20, '资源集合路由设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(21, 1, 21, '资源集合调用设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(22, 1, 22, '数据中心', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(23, 1, 23, '网段', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(24, 1, 24, '网络区域', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(25, 1, 25, '默认安全策略', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(26, 1, 26, '网络区域连接', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(28, 1, 28, '业务区域', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(29, 1, 29, '资源集合', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(30, 1, 30, '资源集合路由', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(31, 1, 31, 'IP地址', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(32, 1, 32, '主机资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(33, 1, 33, '数据库资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(34, 1, 34, '缓存资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(35, 1, 35, '负载均衡资源实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(36, 1, 36, '块存储', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(37, 1, 37, '应用系统设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(38, 1, 38, '子系统设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(39, 1, 39, '单元设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(40, 1, 40, '调用设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(41, 1, 41, '服务设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(42, 1, 42, '服务调用设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(43, 1, 43, '服务调用时序设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(44, 1, 44, '差异化配置', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(45, 1, 45, '部署物料包', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(46, 1, 46, '应用系统', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(47, 1, 47, '子系统', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(48, 1, 48, '单元', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(49, 1, 49, '调用', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(50, 1, 50, '应用实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(51, 1, 51, '数据库实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(52, 1, 52, '缓存实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(53, 1, 53, '负载均衡实例', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(54, 1, 54, '节点类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(55, 3, 1, '管理角色', 'N', 'N', 'N', 'N', 'N', 'N'),
	(56, 3, 2, '单元类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(57, 3, 3, '部署环境', 'N', 'N', 'N', 'N', 'N', 'N'),
	(58, 3, 4, '法人', 'N', 'N', 'N', 'N', 'N', 'N'),
	(59, 3, 5, '应用域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(60, 3, 6, '云厂商', 'N', 'N', 'N', 'N', 'N', 'N'),
	(61, 3, 7, '集群类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(62, 3, 8, '集群节点类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(63, 3, 9, '资源实例类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(64, 3, 10, '资源实例规格', 'N', 'N', 'N', 'N', 'N', 'N'),
	(65, 3, 11, '资源实例系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(66, 3, 12, '数据中心设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(67, 3, 13, '网段设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(68, 3, 14, '网络区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(69, 3, 15, '默认安全策略设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(70, 3, 16, '网络区域连接设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(71, 3, 18, '业务区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(72, 3, 19, '资源集合设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(73, 3, 20, '路由设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(74, 3, 21, '资源集合调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(75, 3, 22, '数据中心', 'N', 'N', 'N', 'N', 'N', 'N'),
	(76, 3, 23, '网段', 'N', 'N', 'N', 'N', 'N', 'N'),
	(77, 3, 24, '网络区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(78, 3, 25, '默认安全策略', 'N', 'N', 'N', 'N', 'N', 'N'),
	(79, 3, 26, '网络区域连接', 'N', 'N', 'N', 'N', 'N', 'N'),
	(80, 3, 28, '业务区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(81, 3, 29, '资源集合', 'N', 'N', 'N', 'N', 'N', 'N'),
	(82, 3, 30, '路由', 'N', 'N', 'N', 'N', 'N', 'N'),
	(83, 3, 31, 'IP地址', 'N', 'N', 'N', 'N', 'N', 'N'),
	(84, 3, 32, '主机资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(85, 3, 33, '数据库资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(86, 3, 34, '缓存资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(87, 3, 35, '负载均衡资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(88, 3, 36, '块存储', 'N', 'N', 'N', 'N', 'N', 'N'),
	(89, 3, 37, '应用系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(90, 3, 38, '子系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(91, 3, 39, '单元设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(92, 3, 40, '调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(93, 3, 41, '服务设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(94, 3, 42, '服务调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(95, 3, 43, '服务调用时序设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(96, 3, 44, '差异化配置', 'N', 'N', 'N', 'N', 'N', 'N'),
	(97, 3, 45, '部署物料包', 'N', 'N', 'N', 'N', 'N', 'N'),
	(98, 3, 46, '应用系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(99, 3, 47, '子系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(100, 3, 48, '单元', 'N', 'N', 'N', 'N', 'N', 'N'),
	(101, 3, 49, '调用', 'N', 'N', 'N', 'N', 'N', 'N'),
	(102, 3, 50, '应用实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(103, 3, 51, '数据库实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(104, 3, 52, '缓存实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(105, 3, 53, '负载均衡实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(106, 3, 54, '节点类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(471, 11, 1, '管理角色', 'N', 'N', 'N', 'N', 'N', 'N'),
	(472, 11, 2, '单元类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(473, 11, 3, '部署环境', 'N', 'N', 'N', 'N', 'N', 'N'),
	(474, 11, 4, '法人', 'N', 'N', 'N', 'N', 'N', 'N'),
	(475, 11, 5, '应用域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(476, 11, 6, '云厂商', 'N', 'N', 'N', 'N', 'N', 'N'),
	(477, 11, 7, '集群类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(478, 11, 8, '集群节点类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(479, 11, 9, '资源实例类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(480, 11, 10, '资源实例规格', 'N', 'N', 'N', 'N', 'N', 'N'),
	(481, 11, 11, '资源实例系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(482, 11, 12, '数据中心设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(483, 11, 13, '网段设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(484, 11, 14, '网络区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(485, 11, 15, '默认安全策略设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(486, 11, 16, '网络区域连接设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(487, 11, 18, '业务区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(488, 11, 19, '资源集合设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(489, 11, 20, '路由设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(490, 11, 21, '资源集合调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(491, 11, 22, '数据中心', 'N', 'N', 'N', 'N', 'N', 'N'),
	(492, 11, 23, '网段', 'N', 'N', 'N', 'N', 'N', 'N'),
	(493, 11, 24, '网络区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(494, 11, 25, '默认安全策略', 'N', 'N', 'N', 'N', 'N', 'N'),
	(495, 11, 26, '网络区域连接', 'N', 'N', 'N', 'N', 'N', 'N'),
	(496, 11, 28, '业务区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(497, 11, 29, '资源集合', 'N', 'N', 'N', 'N', 'N', 'N'),
	(498, 11, 30, '路由', 'N', 'N', 'N', 'N', 'N', 'N'),
	(499, 11, 31, 'IP地址', 'N', 'N', 'N', 'N', 'N', 'N'),
	(500, 11, 32, '主机资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(501, 11, 33, '数据库资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(502, 11, 34, '缓存资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(503, 11, 35, '负载均衡资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(504, 11, 36, '块存储', 'N', 'N', 'N', 'N', 'N', 'N'),
	(505, 11, 37, '应用系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(506, 11, 38, '子系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(507, 11, 39, '单元设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(508, 11, 40, '调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(509, 11, 41, '服务设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(510, 11, 42, '服务调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(511, 11, 43, '服务调用时序设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(512, 11, 44, '差异化配置', 'N', 'N', 'N', 'N', 'N', 'N'),
	(513, 11, 45, '部署物料包', 'N', 'N', 'N', 'N', 'N', 'N'),
	(514, 11, 46, '应用系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(515, 11, 47, '子系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(516, 11, 48, '单元', 'N', 'N', 'N', 'N', 'N', 'N'),
	(517, 11, 49, '调用', 'N', 'N', 'N', 'N', 'N', 'N'),
	(518, 11, 50, '应用实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(519, 11, 51, '数据库实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(520, 11, 52, '缓存实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(521, 11, 53, '负载均衡实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(522, 11, 54, '节点类型', 'N', 'N', 'N', 'N', 'N', 'N'),
	(523, 1, 62, '存储类型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(524, 1, 63, '计费模型', 'Y', 'Y', 'Y', 'Y', 'Y', 'N');
/*!40000 ALTER TABLE `adm_role_ci_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_role_ci_type_ctrl_attr` DISABLE KEYS */;
INSERT INTO `adm_role_ci_type_ctrl_attr` (`id_adm_role_ci_type_ctrl_attr`, `id_adm_role_ci_type`, `creation_permission`, `removal_permission`, `modification_permission`, `enquiry_permission`, `execution_permission`, `grant_permission`) VALUES
	(1, 37, 'N', 'N', 'N', 'Y', 'N', 'N');
/*!40000 ALTER TABLE `adm_role_ci_type_ctrl_attr` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_role_ci_type_ctrl_attr_condition` DISABLE KEYS */;
INSERT INTO `adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`, `id_adm_role_ci_type_ctrl_attr`, `id_adm_ci_type_attr`, `ci_type_attr_name`, `condition_value`, `condition_value_type`) VALUES
	(1, 1, 693, '应用域', '0005_0000000005', NULL);
/*!40000 ALTER TABLE `adm_role_ci_type_ctrl_attr_condition` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_role_menu` DISABLE KEYS */;
INSERT INTO `adm_role_menu` (`id_adm_role_menu`, `id_adm_role`, `id_adm_menu`, `is_system`) VALUES
	(1, 1, 1, 0),
	(2, 1, 2, 0),
	(5, 1, 5, 1),
	(6, 1, 6, 0),
	(7, 1, 7, 0),
	(8, 1, 8, 0),
	(9, 1, 9, 0),
	(10, 1, 10, 0),
	(11, 1, 11, 0),
	(16, 1, 16, 0),
	(17, 1, 17, 0),
	(18, 1, 18, 0),
	(19, 1, 19, 0),
	(20, 1, 20, 0),
	(21, 1, 21, 1),
	(22, 1, 22, 0),
	(23, 1, 23, 0),
	(24, 1, 24, 0),
	(25, 2, 20, 0),
	(26, 2, 21, 0),
	(27, 2, 22, 0),
	(28, 2, 23, 0),
	(29, 2, 24, 0),
	(30, 2, 9, 0),
	(31, 2, 10, 0),
	(32, 2, 11, 0),
	(33, 2, 16, 0),
	(34, 2, 17, 0),
	(35, 2, 18, 0),
	(36, 2, 19, 0),
	(37, 2, 6, 0),
	(38, 2, 7, 0),
	(39, 2, 8, 0),
	(44, 9, 6, 0),
	(45, 9, 7, 0),
	(46, 9, 8, 0),
	(47, 9, 9, 0),
	(48, 9, 10, 0),
	(49, 9, 11, 0),
	(50, 6, 16, 0),
	(51, 6, 17, 0),
	(52, 6, 18, 0),
	(53, 6, 19, 0),
	(54, 6, 6, 0),
	(55, 6, 7, 0),
	(56, 6, 8, 0),
	(57, 6, 9, 0),
	(58, 6, 10, 0),
	(59, 6, 11, 0),
	(61, 6, 22, 0),
	(62, 6, 20, 0),
	(63, 6, 23, 0);
/*!40000 ALTER TABLE `adm_role_menu` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_role_user` DISABLE KEYS */;
INSERT INTO `adm_role_user` (`id_adm_role_user`, `id_adm_role`, `id_adm_user`, `is_system`) VALUES
	(1, 1, 1, 1),
	(2, 2, 2, 0),
	(3, 9, 3, 0),
	(4, 6, 4, 0);
/*!40000 ALTER TABLE `adm_role_user` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_sequence` DISABLE KEYS */;
INSERT INTO `adm_sequence` (`id_adm_sequence`, `seq_name`, `current_val`, `increment_val`, `length_limitation`, `left_zero_padding`) VALUES
	(1, 'manage_role', 1, 1, 8, 'N'),
	(2, 'data_center_design', 1, 1, 8, 'N'),
	(3, 'network_segment_design', 26, 1, 8, 'N'),
	(4, 'network_zone_design', 7, 1, 8, 'N'),
	(5, 'application_domain', 2, 1, 8, 'N'),
	(6, 'business_zone_design', 6, 1, 8, 'N'),
	(7, 'unit_type', 6, 1, 8, 'N'),
	(8, 'resource_set_design', 19, 1, 8, 'N'),
	(9, 'resource_set_invoke_design', 16, 1, 8, 'N'),
	(10, 'network_link_design', 11, 1, 8, 'N'),
	(11, 'default_security_policy_design', 24, 1, 8, 'N'),
	(12, 'network_zone_route_design', 0, 1, 8, 'N'),
	(13, 'resource_set_route_design', 0, 1, 8, 'N'),
	(14, 'cloud_vendor', 2, 1, 8, 'N'),
	(15, 'deploy_environment', 2, 1, 8, 'N'),
	(16, 'data_center', 6, 1, 8, 'N'),
	(17, 'network_segment', 45, 1, 8, 'N'),
	(18, 'network_zone', 5, 1, 8, 'N'),
	(19, 'business_zone', 9, 1, 8, 'N'),
	(20, 'cluster_type', 6, 1, 8, 'N'),
	(21, 'cluster_node_type', 4, 1, 8, 'N'),
	(22, 'resource_set', 30, 1, 8, 'N'),
	(23, 'ip_address', 114, 1, 8, 'N'),
	(24, 'resource_instance_type', 8, 1, 8, 'N'),
	(25, 'resource_instance_system', 5, 1, 8, 'N'),
	(26, 'resource_instance_spec', 11, 1, 8, 'N'),
	(27, 'host_resource_instance', 6, 1, 8, 'N'),
	(28, 'network_link_type', 2, 1, 8, 'N'),
	(29, 'rdb_resource_instance', 3, 1, 8, 'N'),
	(30, 'lb_resource_instance', 2, 1, 8, 'N'),
	(31, 'app_system_design', 4, 1, 8, 'N'),
	(32, 'subsys_design', 13, 1, 8, 'N'),
	(33, 'unit_design', 21, 1, 8, 'N'),
	(34, 'invoke_design', 28, 1, 8, 'N'),
	(35, 'service_design', 1, 1, 8, 'N'),
	(36, 'service_invoke_design', 1, 1, 8, 'N'),
	(37, 'legal_person', 1, 1, 8, 'N'),
	(38, 'app_system', 4, 1, 8, 'N'),
	(39, 'subsys', 13, 1, 8, 'N'),
	(40, 'unit', 21, 1, 8, 'N'),
	(41, 'app_instance', 10, 1, 8, 'N'),
	(42, 'network_link', 6, 1, 8, 'N'),
	(43, 'route_design', 15, 1, 8, 'N'),
	(44, 'route', 2, 1, 8, 'N'),
	(45, 'default_security_policy', 14, 1, 8, 'N'),
	(46, 'rdb_instance', 3, 1, 8, 'N'),
	(47, 'lb_instance', 4, 1, 8, 'N'),
	(48, 'invoke', 28, 1, 8, 'N'),
	(49, 'deploy_package', 1, 1, 8, 'N'),
	(50, 'diff_configuration', 0, 1, 8, 'N'),
	(51, 'cache_resource_instance', 1, 1, 8, 'N'),
	(52, 'block_storage', 0, 1, 8, 'N'),
	(53, 'service_invoke_seq_design', 0, 1, 8, 'N'),
	(54, 'cache_instance', 1, 1, 8, 'N'),
	(55, 'charge_type', 2, 1, 8, 'N'),
	(56, 'storage_type', 8, 1, 8, 'N');
/*!40000 ALTER TABLE `adm_sequence` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_state_transition` DISABLE KEYS */;
INSERT INTO `adm_state_transition` (`id_adm_state_transition`, `current_state`, `current_state_is_confirmed`, `target_state`, `target_state_is_confirmed`, `operation`, `action`, `status`) VALUES
	(1, 37, 0, NULL, NULL, 48, 54, 'active'),
	(2, NULL, NULL, 37, 0, 45, 52, 'active'),
	(3, 37, 0, 37, 0, 46, 56, 'active'),
	(4, 37, 0, 37, 1, 49, 57, 'active'),
	(5, 37, 1, 38, 0, 46, 53, 'active'),
	(6, 38, 0, 37, 1, 47, 55, 'active'),
	(7, 37, 1, 39, 0, 48, 53, 'active'),
	(8, 39, 0, 37, 1, 47, 55, 'active'),
	(9, 38, 0, 38, 0, 46, 56, 'active'),
	(10, 38, 0, 38, 1, 49, 57, 'active'),
	(11, 38, 1, 38, 0, 46, 53, 'active'),
	(12, 38, 0, 38, 1, 47, 55, 'active'),
	(13, 38, 1, 39, 0, 48, 53, 'active'),
	(14, 39, 0, 38, 1, 47, 55, 'active'),
	(15, 39, 0, 39, 1, 49, 57, 'active'),
	(16, 40, 0, NULL, NULL, 48, 54, 'active'),
	(17, NULL, NULL, 40, 0, 45, 52, 'active'),
	(18, 40, 0, 40, 0, 46, 56, 'active'),
	(19, 40, 0, 40, 1, 49, 57, 'active'),
	(20, 40, 1, 41, 0, 50, 53, 'active'),
	(21, 41, 0, 40, 1, 47, 55, 'active'),
	(22, 41, 0, 41, 1, 49, 57, 'active'),
	(23, 40, 1, 43, 0, 51, 53, 'active'),
	(24, 43, 0, 40, 1, 47, 55, 'active'),
	(25, 43, 0, 43, 1, 49, 57, 'active'),
	(26, 41, 1, 43, 0, 51, 53, 'active'),
	(27, 43, 0, 41, 1, 47, 55, 'active'),
	(28, 43, 1, 41, 0, 50, 53, 'active'),
	(29, 41, 0, 43, 1, 47, 55, 'active'),
	(30, 41, 1, 42, 0, 46, 53, 'active'),
	(31, 42, 0, 41, 1, 47, 55, 'active'),
	(32, 43, 1, 42, 0, 46, 53, 'active'),
	(33, 42, 0, 43, 1, 47, 55, 'active'),
	(34, 42, 0, 42, 0, 46, 56, 'active'),
	(35, 42, 0, 42, 1, 49, 57, 'active'),
	(36, 42, 1, 43, 0, 51, 53, 'active'),
	(37, 43, 0, 42, 1, 47, 55, 'active'),
	(38, 42, 1, 41, 0, 50, 53, 'active'),
	(39, 41, 0, 42, 1, 47, 55, 'active'),
	(40, 43, 1, 44, 0, 48, 53, 'active'),
	(41, 44, 0, 43, 1, 47, 55, 'active'),
	(42, 44, 0, 44, 1, 49, 57, 'active'),
	(43, 34, 0, NULL, NULL, 48, 54, 'active'),
	(44, NULL, NULL, 34, 0, 45, 52, 'active'),
	(45, 34, 0, 34, 0, 46, 56, 'active'),
	(46, 34, 0, 34, 1, 49, 57, 'active'),
	(47, 34, 1, 35, 0, 46, 53, 'active'),
	(48, 35, 0, 34, 1, 47, 55, 'active'),
	(49, 34, 1, 36, 0, 48, 53, 'active'),
	(50, 36, 0, 34, 1, 47, 55, 'active'),
	(51, 35, 0, 35, 0, 46, 56, 'active'),
	(52, 35, 0, 35, 1, 49, 57, 'active'),
	(53, 35, 1, 35, 0, 46, 53, 'active'),
	(54, 35, 0, 35, 1, 47, 55, 'active'),
	(55, 35, 1, 36, 0, 48, 53, 'active'),
	(56, 36, 0, 35, 1, 47, 55, 'active'),
	(57, 36, 0, 36, 1, 49, 57, 'active'),
	(58, 40, 1, 42, 0, 46, 53, 'active'),
	(59, 42, 0, 40, 1, 47, 55, 'active');
/*!40000 ALTER TABLE `adm_state_transition` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_tenement` DISABLE KEYS */;
/*!40000 ALTER TABLE `adm_tenement` ENABLE KEYS */;

/*!40000 ALTER TABLE `adm_user` DISABLE KEYS */;
INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `encrypted_password`, `description`, `id_adm_tenement`, `action_flag`, `is_system`) VALUES
	(1, 'admin', 'admin', '$2a$10$Gh3WDwZ8kFpxbmo/h.oywuN.LuYwgrlx53ZeG.mz7P4eKgct7IYZm', 'admin', NULL, 0, 1),
	(2, 'Jordan Zhang', 'jordan', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Admin', NULL, NULL, NULL),
	(3, 'Monkey', 'monkey', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Developer', NULL, NULL, NULL),
	(4, 'Chaney Liu', 'chaneyliu', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Architect', NULL, NULL, NULL);
/*!40000 ALTER TABLE `adm_user` ENABLE KEYS */;

/*!40000 ALTER TABLE `application_domain` DISABLE KEYS */;
INSERT INTO `application_domain` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0005_0000000001', NULL, '0005_0000000001', 'umadmin', '2020-04-11 22:08:41', 'umadmin', '2020-04-11 22:08:41', 34, '应用域a', NULL, 'ADa', '应用域a', '应用域a', 'new'),
	('0005_0000000002', NULL, '0005_0000000002', 'umadmin', '2020-04-11 22:09:01', 'umadmin', '2020-04-11 22:09:00', 34, '应用域b', NULL, 'ADb', '应用域b', '应用域b', 'new');
/*!40000 ALTER TABLE `application_domain` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_instance` DISABLE KEYS */;
INSERT INTO `app_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_script`, `deploy_user`, `deploy_user_password`, `host_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `port`, `port_conflict`, `start_script`, `state_code`, `stop_script`, `storage`, `unit`, `variable_values`, `name`) VALUES
	('0050_0000000001', NULL, '0050_0000000001', 'umadmin', '2020-04-15 11:34:49', 'umadmin', '2020-04-13 14:15:37', 40, 'PRD_UM_SRV_APP_10.128.0.2:18080', NULL, 'umsvr1_10.128.0.2:18080', '', '4', '', '', '/data/PRD_UM_SRV_APP/', 'UM_SRV', 'Abcd1234', '0032_0000000002', '8', '10.128.0.2:28090', '28090', '18080', '10.128.0.2:18080', '/data/PRD_UM_SRV_APP/', 'created', '/data/PRD_UM_SRV_APP/', '40', '0048_0000000008', '=', 'umsvr1'),
	('0050_0000000002', NULL, '0050_0000000002', 'umadmin', '2020-04-15 11:34:48', 'umadmin', '2020-04-13 14:16:48', 40, 'PRD_UM_SSO_APP_10.128.0.2:18081', NULL, 'umsso1_10.128.0.2:18081', '', '4', '', '', '/data/PRD_UM_SSO_APP/', 'UM_SSO', 'Abcd1234', '0032_0000000002', '8', '10.128.0.2:28091', '28091', '18081', '10.128.0.2:18081', '/data/PRD_UM_SSO_APP/', 'created', '/data/PRD_UM_SSO_APP/', '40', '0048_0000000007', '=', 'umsso1'),
	('0050_0000000003', NULL, '0050_0000000003', 'umadmin', '2020-04-15 11:34:47', 'umadmin', '2020-04-13 14:16:50', 40, 'PRD_UM_CORE_APP_10.128.0.2:18082', NULL, 'umcore1_10.128.0.2:18082', '', '4', '', '', '/data/PRD_UM_CORE_APP/', 'UM_CORE', 'Abcd1234', '0032_0000000002', '8', '10.128.0.2:28092', '28092', '18082', '10.128.0.2:18082', '/data/PRD_UM_CORE_APP/', 'created', '/data/PRD_UM_CORE_APP/', '40', '0048_0000000004', '=', 'umcore1'),
	('0050_0000000004', NULL, '0050_0000000004', 'umadmin', '2020-04-15 11:34:46', 'umadmin', '2020-04-13 15:21:56', 40, 'PRD_FPS_TP_APP_10.128.0.2:18083', NULL, 'fpstp1_10.128.0.2:18083', '', '4', '', '', '/data/PRD_FPS_TP_APP/', 'FPS_TP', 'Abcd1234', '0032_0000000002', '8', '10.128.0.2:28093', '28093', '18083', '10.128.0.2:18083', '/data/PRD_FPS_TP_APP/', 'created', '/data/PRD_FPS_TP_APP/', '40', '0048_0000000009', '=', 'fpstp1'),
	('0050_0000000005', NULL, '0050_0000000005', 'umadmin', '2020-04-15 11:34:45', 'umadmin', '2020-04-13 15:22:20', 40, 'PRD_FPS_HBASE_APP_10.128.0.2:18084', NULL, 'fpshbase1_10.128.0.2:18084', '', '4', '', '', '/data/PRD_FPS_HBASE_APP/', 'FPS_HBASE', '******', '0032_0000000002', '8', '10.128.0.2:28094', '28094', '18084', '10.128.0.2:18084', '/data/PRD_FPS_HBASE_APP/', 'created', '/data/PRD_FPS_HBASE_APP/', '40', '0048_0000000010', '=', 'fpshbase1'),
	('0050_0000000006', NULL, '0050_0000000006', 'umadmin', '2020-04-15 11:34:44', 'umadmin', '2020-04-13 15:37:54', 40, 'PRD_WEMQ_ADM_APP_10.128.64.2:18085', NULL, 'wemqadm1_10.128.64.2:18085', '', '4', '', '', '/data/PRD_WEMQ_ADM_APP/', 'WEMQ_ADM', 'Abcd1234', '0032_0000000001', '8', '10.128.64.2:28095', '28095', '18085', '10.128.64.2:18085', '/data/PRD_WEMQ_ADM_APP/', 'created', '/data/PRD_WEMQ_ADM_APP/', '40', '0048_0000000012', '=', 'wemqadm1'),
	('0050_0000000007', NULL, '0050_0000000007', 'umadmin', '2020-04-15 11:34:42', 'umadmin', '2020-04-13 15:38:51', 40, 'PRD_WEMQ_BROKER_APP_10.128.64.2:18088', NULL, 'wemqbroker1_10.128.64.2:18088', '', '4', '', '', '/data/PRD_WEMQ_BROKER_APP/', 'WEMQ_BROKER', '******', '0032_0000000001', '8', '10.128.64.2:28098', '28098', '18088', '10.128.64.2:18088', '/data/PRD_WEMQ_BROKER_APP/', 'created', '/data/PRD_WEMQ_BROKER_APP/', '40', '0048_0000000014', '=', 'wemqbroker1'),
	('0050_0000000008', NULL, '0050_0000000008', 'umadmin', '2020-04-15 11:34:41', 'umadmin', '2020-04-13 15:38:53', 40, 'PRD_WEMQ_NAMESRV_APP_10.128.64.2:18087', NULL, 'wemqnameser1_10.128.64.2:18087', '', '4', '', '', '/data/PRD_WEMQ_NAMESRV_APP/', 'WEMQ_NAMESRV', '******', '0032_0000000001', '8', '10.128.64.2:28097', '28097', '18087', '10.128.64.2:18087', '/data/PRD_WEMQ_NAMESRV_APP/', 'created', '/data/PRD_WEMQ_NAMESRV_APP/', '40', '0048_0000000013', '=', 'wemqnameser1'),
	('0050_0000000009', NULL, '0050_0000000009', 'umadmin', '2020-04-15 11:34:40', 'umadmin', '2020-04-13 15:38:55', 40, 'PRD_WEMQ_CC_APP_10.128.64.2:18086', NULL, 'wemqcs1_10.128.64.2:18086', '', '4', '', '', '/data/PRD_WEMQ_CC_APP/', 'WEMQ_CC', '******', '0032_0000000001', '8', '10.128.64.2:28096', '28096', '18086', '10.128.64.2:18086', '/data/PRD_WEMQ_CC_APP/', 'created', '/data/PRD_WEMQ_CC_APP/', '40', '0048_0000000016', '=', 'wemqcs1'),
	('0050_0000000010', NULL, '0050_0000000010', 'umadmin', '2020-04-15 11:34:39', 'umadmin', '2020-04-13 15:47:24', 40, 'PRD_RMB_SGS_APP_10.128.64.2:18089', NULL, 'rmbsgs1_10.128.64.2:18089', '', '4', '', '', '/data/PRD_RMB_SGS_APP/', 'RMB_SGS', 'Abcd1234', '0032_0000000001', '8', '10.128.64.2:28099', '28099', '18089', '10.128.64.2:18089', '/data/PRD_RMB_SGS_APP/', 'created', '/data/PRD_RMB_SGS_APP/', '40', '0048_0000000018', '=', 'rmbsgs1');
/*!40000 ALTER TABLE `app_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_system` DISABLE KEYS */;
INSERT INTO `app_system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_environment`, `legal_person`, `state_code`, `app_system_design`) VALUES
	('0046_0000000001', NULL, '0046_0000000001', 'umadmin', '2020-04-13 13:48:46', 'umadmin', '2020-04-13 13:47:54', 37, 'PRD_UM', NULL, 'UM', '', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000001'),
	('0046_0000000002', NULL, '0046_0000000002', 'umadmin', '2020-04-13 13:48:22', 'umadmin', '2020-04-13 13:48:21', 37, 'PRD_FPS', NULL, 'FPS', '', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000002'),
	('0046_0000000003', NULL, '0046_0000000003', 'umadmin', '2020-04-13 13:49:16', 'umadmin', '2020-04-13 13:49:16', 37, 'PRD_WEMQ', NULL, 'WEMQ', '', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000003'),
	('0046_0000000004', NULL, '0046_0000000004', 'umadmin', '2020-04-13 13:50:00', 'umadmin', '2020-04-13 13:49:32', 37, 'PRD_RMB', NULL, 'RMB', '', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000004');
/*!40000 ALTER TABLE `app_system` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_system$data_center` DISABLE KEYS */;
INSERT INTO `app_system$data_center` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(3, '0046_0000000002', '0022_0000000003', 1),
	(4, '0046_0000000001', '0022_0000000003', 1),
	(5, '0046_0000000003', '0022_0000000003', 1),
	(6, '0046_0000000004', '0022_0000000003', 1);
/*!40000 ALTER TABLE `app_system$data_center` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_system_design` DISABLE KEYS */;
INSERT INTO `app_system_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `application_domain`, `app_system_design_id`, `data_center_design`, `name`, `state_code`) VALUES
	('0037_0000000001', NULL, '0037_0000000001', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:46:11', 34, 'UM', '2020-04-15 14:19:00', 'UM', '', '0005_0000000001', '1070', '0012_0000000001', 'UM - 统一登录认证平台', 'new'),
	('0037_0000000002', NULL, '0037_0000000002', 'umadmin', '2020-04-13 13:46:30', 'umadmin', '2020-04-13 13:46:30', 34, 'FPS', NULL, 'FPS', '', '0005_0000000001', '1068', '0012_0000000001', 'FPS - 文件处理系统', 'new'),
	('0037_0000000003', NULL, '0037_0000000003', 'umadmin', '2020-04-13 13:46:52', 'umadmin', '2020-04-13 13:46:52', 34, 'WEMQ', NULL, 'WEMQ', '', '0005_0000000001', '1078', '0012_0000000001', 'WEMQ - 消息中间件', 'new'),
	('0037_0000000004', NULL, '0037_0000000004', 'umadmin', '2020-04-13 13:47:14', 'umadmin', '2020-04-13 13:47:14', 34, 'RMB', NULL, 'RMB', '', '0005_0000000001', '1065', '0012_0000000001', 'RMB - 消息总线', 'new');
/*!40000 ALTER TABLE `app_system_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `block_storage` DISABLE KEYS */;
/*!40000 ALTER TABLE `block_storage` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone` DISABLE KEYS */;
INSERT INTO `business_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone_design`, `business_zone_type`, `logic_business_zone`, `name`, `state_code`, `network_zone`) VALUES
	('0028_0000000001', NULL, '0028_0000000001', 'umadmin', '2020-04-12 23:38:07', 'umadmin', '2020-04-12 13:23:16', 37, 'PCD_SF_CS_1C0', NULL, '1C0', '', '0018_0000000001', 'GROUP', '', '公共服务', 'created', NULL),
	('0028_0000000002', NULL, '0028_0000000002', 'umadmin', '2020-04-12 23:38:07', 'umadmin', '2020-04-12 13:31:34', 37, 'PCD_MG_MT_1M0', NULL, '1M0', '', '0018_0000000005', 'GROUP', '', '管理工具', 'created', NULL),
	('0028_0000000003', NULL, '0028_0000000003', 'umadmin', '2020-04-12 23:36:40', 'umadmin', '2020-04-12 13:32:47', 37, 'PCD_SF_CS_1C1', NULL, '1C1', '', '0018_0000000001', 'NODE', '0028_0000000001', '公共服务', 'created', '0024_0000000001'),
	('0028_0000000004', NULL, '0028_0000000004', 'umadmin', '2020-04-12 23:36:40', 'umadmin', '2020-04-12 13:34:03', 37, 'PCD_MG_MT_1M1', NULL, '1M1', '', '0018_0000000005', 'NODE', '0028_0000000002', '管理工具', 'created', '0024_0000000002'),
	('0028_0000000005', NULL, '0028_0000000005', 'umadmin', '2020-04-12 23:38:06', 'umadmin', '2020-04-12 13:35:34', 37, 'PCD_MG_QZ_1Q0', NULL, '1Q0', '', '0018_0000000006', 'GROUP', '', '生产对接', 'created', NULL),
	('0028_0000000006', NULL, '0028_0000000006', 'umadmin', '2020-04-12 23:36:07', 'umadmin', '2020-04-12 13:36:07', 37, 'PCD_MG_QZ_1Q1', NULL, '1Q1', '', '0018_0000000006', 'NODE', '0028_0000000005', '生产对接', 'created', '0024_0000000002'),
	('0028_0000000007', NULL, '0028_0000000007', 'umadmin', '2020-04-12 23:35:20', 'umadmin', '2020-04-12 14:14:21', 37, 'PCD_MG_QZ_1Q2', NULL, '1Q2', '', '0018_0000000006', 'NODE', '0028_0000000005', '生产对接', 'created', '0024_0000000004'),
	('0028_0000000008', NULL, '0028_0000000008', 'umadmin', '2020-04-12 23:36:06', 'umadmin', '2020-04-12 14:14:21', 37, 'PCD_MG_MT_1M2', NULL, '1M2', '', '0018_0000000005', 'NODE', '0028_0000000002', '管理工具', 'created', '0024_0000000004'),
	('0028_0000000009', NULL, '0028_0000000009', 'umadmin', '2020-04-12 23:36:06', 'umadmin', '2020-04-12 14:14:21', 37, 'PCD_SF_CS_1C2', NULL, '1C2', '', '0018_0000000001', 'NODE', '0028_0000000001', '公共服务', 'created', '0024_0000000003');
/*!40000 ALTER TABLE `business_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone$network_segment` DISABLE KEYS */;
INSERT INTO `business_zone$network_segment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(249, '0028_0000000007', '0023_0000000042', 2),
	(250, '0028_0000000007', '0023_0000000041', 1),
	(251, '0028_0000000008', '0023_0000000038', 1),
	(252, '0028_0000000008', '0023_0000000039', 2),
	(253, '0028_0000000008', '0023_0000000040', 3),
	(254, '0028_0000000008', '0023_0000000037', 4),
	(255, '0028_0000000009', '0023_0000000033', 2),
	(256, '0028_0000000009', '0023_0000000036', 5),
	(257, '0028_0000000009', '0023_0000000034', 3),
	(258, '0028_0000000009', '0023_0000000035', 4),
	(259, '0028_0000000009', '0023_0000000032', 1),
	(260, '0028_0000000006', '0023_0000000020', 1),
	(261, '0028_0000000006', '0023_0000000026', 3),
	(262, '0028_0000000006', '0023_0000000027', 4),
	(263, '0028_0000000006', '0023_0000000021', 2),
	(264, '0028_0000000004', '0023_0000000025', 4),
	(265, '0028_0000000004', '0023_0000000023', 2),
	(266, '0028_0000000004', '0023_0000000028', 6),
	(267, '0028_0000000004', '0023_0000000030', 7),
	(268, '0028_0000000004', '0023_0000000029', 5),
	(269, '0028_0000000004', '0023_0000000031', 8),
	(270, '0028_0000000004', '0023_0000000022', 1),
	(271, '0028_0000000004', '0023_0000000024', 3),
	(272, '0028_0000000003', '0023_0000000013', 4),
	(273, '0028_0000000003', '0023_0000000015', 6),
	(274, '0028_0000000003', '0023_0000000019', 10),
	(275, '0028_0000000003', '0023_0000000012', 3),
	(276, '0028_0000000003', '0023_0000000018', 9),
	(277, '0028_0000000003', '0023_0000000014', 5),
	(278, '0028_0000000003', '0023_0000000010', 1),
	(279, '0028_0000000003', '0023_0000000017', 8),
	(280, '0028_0000000003', '0023_0000000016', 7),
	(281, '0028_0000000003', '0023_0000000011', 2);
/*!40000 ALTER TABLE `business_zone$network_segment` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone_design` DISABLE KEYS */;
INSERT INTO `business_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `network_zone_design`, `state_code`) VALUES
	('0018_0000000001', NULL, '0018_0000000001', 'umadmin', '2020-04-12 02:40:24', 'umadmin', '2020-04-12 02:37:36', 34, 'PCD_SF_CS', NULL, 'CS', '公共服务', '0014_0000000001', 'new'),
	('0018_0000000002', NULL, '0018_0000000002', 'umadmin', '2020-04-12 02:40:38', 'umadmin', '2020-04-12 02:38:30', 34, 'PCD_SF_DCN', NULL, 'DCN', '客户业务', '0014_0000000001', 'new'),
	('0018_0000000003', NULL, '0018_0000000003', 'umadmin', '2020-04-12 02:43:54', 'umadmin', '2020-04-12 02:42:00', 34, 'PCD_DMZ_DCN', NULL, 'DCN', '客户业务', '0014_0000000002', 'new'),
	('0018_0000000004', NULL, '0018_0000000004', 'umadmin', '2020-04-12 02:44:38', 'umadmin', '2020-04-12 02:44:38', 34, 'PCD_ECN_DCN', NULL, 'DCN', '客户业务', '0014_0000000003', 'new'),
	('0018_0000000005', NULL, '0018_0000000005', 'umadmin', '2020-04-12 02:45:41', 'umadmin', '2020-04-12 02:45:26', 34, 'PCD_MG_MT', NULL, 'MT', '关联工具', '0014_0000000004', 'new'),
	('0018_0000000006', NULL, '0018_0000000006', 'umadmin', '2020-04-12 14:27:33', 'umadmin', '2020-04-12 02:46:42', 34, 'PCD_MG_QZ', NULL, 'QZ', '虚拟桌面', '0014_0000000004', 'new');
/*!40000 ALTER TABLE `business_zone_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone_design$application_domain` DISABLE KEYS */;
INSERT INTO `business_zone_design$application_domain` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(38, '0018_0000000001', '0005_0000000001', 1),
	(39, '0018_0000000002', '0005_0000000002', 1),
	(42, '0018_0000000003', '0005_0000000002', 1),
	(43, '0018_0000000004', '0005_0000000002', 1),
	(45, '0018_0000000005', '0005_0000000001', 1),
	(47, '0018_0000000006', '0005_0000000001', 1);
/*!40000 ALTER TABLE `business_zone_design$application_domain` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone_design$network_segment_design` DISABLE KEYS */;
INSERT INTO `business_zone_design$network_segment_design` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(99, '0018_0000000001', '0013_0000000008', 3),
	(100, '0018_0000000001', '0013_0000000006', 1),
	(101, '0018_0000000001', '0013_0000000010', 5),
	(102, '0018_0000000001', '0013_0000000007', 2),
	(103, '0018_0000000001', '0013_0000000009', 4),
	(104, '0018_0000000002', '0013_0000000010', 4),
	(105, '0018_0000000002', '0013_0000000008', 3),
	(106, '0018_0000000002', '0013_0000000006', 1),
	(107, '0018_0000000002', '0013_0000000007', 2),
	(120, '0018_0000000003', '0013_0000000011', 3),
	(121, '0018_0000000003', '0013_0000000013', 1),
	(122, '0018_0000000003', '0013_0000000012', 2),
	(123, '0018_0000000004', '0013_0000000014', 2),
	(124, '0018_0000000004', '0013_0000000015', 1),
	(129, '0018_0000000005', '0013_0000000018', 3),
	(130, '0018_0000000005', '0013_0000000019', 4),
	(131, '0018_0000000005', '0013_0000000017', 2),
	(132, '0018_0000000005', '0013_0000000016', 1),
	(134, '0018_0000000006', '0013_0000000024', 2),
	(135, '0018_0000000006', '0013_0000000020', 1);
/*!40000 ALTER TABLE `business_zone_design$network_segment_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `cache_instance` DISABLE KEYS */;
INSERT INTO `cache_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cache_resource_instance`, `memory`, `port`, `state_code`, `unit`, `name`) VALUES
	('0052_0000000001', NULL, '0052_0000000001', 'umadmin', '2020-04-15 11:44:17', 'umadmin', '2020-04-13 14:21:56', 37, 'PRD_UM_SSO_REDIS_10.128.32.2:6379', NULL, 'umsso_10.128.32.2:6379', '', '0034_0000000001', '4', '6379', 'created', '0048_0000000006', 'umsso');
/*!40000 ALTER TABLE `cache_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `cache_resource_instance` DISABLE KEYS */;
INSERT INTO `cache_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `end_date`, `intranet_ip`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_type`, `resource_set`, `state_code`, `unit_type`, `user_name`, `user_password`, `resource_instance_system`) VALUES
	('0034_0000000001', NULL, '0034_0000000001', 'umadmin', '2020-04-15 11:19:17', 'umadmin', '2020-04-13 00:24:57', 40, 'PRD1_SF_CACHE_csredis1', NULL, 'csredis1_10.128.32.2', '', '', '', '', '0063_0000000002', '0008_0000000004', '', '0031_0000000082', '6379', '', '', '10.128.32.2:6379', '6379', 'csredis1', '0010_0000000009', '0009_0000000006', '0029_0000000006', 'created', '0002_0000000003', 'root', 'Abcd1234', '0011_0000000005');
/*!40000 ALTER TABLE `cache_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `charge_type` DISABLE KEYS */;
INSERT INTO `charge_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `state_code`, `fixed_date`, `code`, `cloud_vendor`, `description`, `name`) VALUES
	('0063_0000000001', NULL, '0063_0000000001', 'umadmin', '2020-04-11 23:48:02', 'umadmin', '2020-04-11 23:47:23', 34, '华为云包月付费', 'new', NULL, 'prePaid', '0006_0000000001', '包月付费', '包月付费'),
	('0063_0000000002', NULL, '0063_0000000002', 'umadmin', '2020-04-11 23:48:02', 'umadmin', '2020-04-11 23:47:47', 34, '华为云按量付费', 'new', NULL, 'postPaid', '0006_0000000001', '按量付费', '按量付费');
/*!40000 ALTER TABLE `charge_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `cloud_vendor` DISABLE KEYS */;
INSERT INTO `cloud_vendor` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0006_0000000001', NULL, '0006_0000000001', 'umadmin', '2020-04-11 22:12:23', 'umadmin', '2020-04-11 22:12:23', 34, '华为云', NULL, 'HWCLOUD', '华为云', '华为云', 'new'),
	('0006_0000000002', NULL, '0006_0000000002', 'umadmin', '2020-04-11 22:12:45', 'umadmin', '2020-04-11 22:12:45', 34, '腾讯云', NULL, 'QCLOUD', '腾讯云', '腾讯云', 'new');
/*!40000 ALTER TABLE `cloud_vendor` ENABLE KEYS */;

/*!40000 ALTER TABLE `cluster_node_type` DISABLE KEYS */;
INSERT INTO `cluster_node_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cluster_type`, `name`, `state_code`) VALUES
	('0008_0000000001', NULL, '0008_0000000001', 'umadmin', '2020-04-11 23:58:05', 'umadmin', '2020-04-11 23:57:10', 34, '华为云负载均衡_NODE', NULL, 'node', 'NODE', '0007_0000000001', 'NODE', 'new'),
	('0008_0000000002', NULL, '0008_0000000002', 'umadmin', '2020-04-11 23:57:56', 'umadmin', '2020-04-11 23:57:56', 34, '华为云高可用_主节点', NULL, 'master', '主节点', '0007_0000000002', '主节点', 'new'),
	('0008_0000000003', NULL, '0008_0000000003', 'umadmin', '2020-04-11 23:58:21', 'umadmin', '2020-04-11 23:58:21', 34, '华为云节点多活_NODE', NULL, 'node', 'NODE', '0007_0000000003', 'NODE', 'new'),
	('0008_0000000004', NULL, '0008_0000000004', 'umadmin', '2020-04-13 00:17:07', 'umadmin', '2020-04-13 00:17:07', 34, '华为云REDIS主备_主节点', NULL, 'master', '', '0007_0000000005', '主节点', 'new');
/*!40000 ALTER TABLE `cluster_node_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `cluster_type` DISABLE KEYS */;
INSERT INTO `cluster_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`) VALUES
	('0007_0000000001', NULL, '0007_0000000001', 'umadmin', '2020-04-11 23:55:41', 'umadmin', '2020-04-11 23:55:10', 34, '华为云负载均衡', NULL, 'LB', '负载均衡', '0006_0000000001', '负载均衡', 'new'),
	('0007_0000000002', NULL, '0007_0000000002', 'umadmin', '2020-04-13 17:49:49', 'umadmin', '2020-04-11 23:55:31', 34, '华为云MYSQL主备', NULL, 'true', '主备', '0006_0000000001', 'MYSQL主备', 'new'),
	('0007_0000000003', NULL, '0007_0000000003', 'umadmin', '2020-04-11 23:56:39', 'umadmin', '2020-04-11 23:56:20', 34, '华为云节点多活', NULL, 'MN', '节点多活', '0006_0000000001', '节点多活', 'new'),
	('0007_0000000004', NULL, '0007_0000000004', 'umadmin', '2020-04-13 17:50:06', 'umadmin', '2020-04-12 15:43:58', 34, '华为云MYSQL单机', NULL, 'false', '单机', '0006_0000000001', 'MYSQL单机', 'new'),
	('0007_0000000005', NULL, '0007_0000000005', 'umadmin', '2020-04-13 17:50:20', 'umadmin', '2020-04-13 00:15:52', 34, '华为云REDIS主备', NULL, 'ha', '', '0006_0000000001', 'REDIS主备', 'new'),
	('0007_0000000006', NULL, '0007_0000000006', 'umadmin', '2020-04-13 17:50:39', 'umadmin', '2020-04-13 00:16:17', 34, '华为云REDIS单机', NULL, 'single', '', '0006_0000000001', 'REDIS单机', 'new');
/*!40000 ALTER TABLE `cluster_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `data_center` DISABLE KEYS */;
INSERT INTO `data_center` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_uid`, `cloud_vendor`, `data_center_design`, `data_center_type`, `location`, `name`, `regional_data_center`, `state_code`, `available_zone`) VALUES
	('0022_0000000001', NULL, '0022_0000000001', 'umadmin', '2020-04-15 10:03:47', 'umadmin', '2020-04-12 03:52:22', 37, 'PRD', NULL, 'PRD', '', '', '0006_0000000001', '0012_0000000001', 'REGION', 'CloudApiDomainName=myhuaweicloud.com;Region=ap-southeast-3;ProjectId=', '生产数据中心', '', 'created', ''),
	('0022_0000000002', NULL, '0022_0000000002', 'umadmin', '2020-04-15 10:03:47', 'umadmin', '2020-04-12 03:53:02', 37, 'DR', NULL, 'DR', '', '', '0006_0000000001', '0012_0000000001', 'REGION', 'CloudApiDomainName=myhuaweicloud.com;Region=ap-southeast-3;ProjectId=', '容灾数据中心', '', 'created', ''),
	('0022_0000000003', NULL, '0022_0000000003', 'umadmin', '2020-04-15 10:03:46', 'umadmin', '2020-04-12 03:54:07', 37, 'PRD1', NULL, 'PRD1', '', '', '0006_0000000001', '0012_0000000001', 'ZONE', 'CloudApiDomainName=myhuaweicloud.com;Region=ap-southeast-3;ProjectId=', '生产1', '0022_0000000001', 'created', 'ap-southeast-3a'),
	('0022_0000000004', NULL, '0022_0000000004', 'umadmin', '2020-04-15 10:03:46', 'umadmin', '2020-04-12 03:54:56', 37, 'DR1', NULL, 'DR1', '', '', '0006_0000000001', '0012_0000000001', 'ZONE', 'CloudApiDomainName=myhuaweicloud.com;Region=ap-southeast-3;ProjectId=', '容灾1', '0022_0000000002', 'created', 'ap-southeast-3c'),
	('0022_0000000005', NULL, '0022_0000000005', 'umadmin', '2020-04-15 10:03:46', 'umadmin', '2020-04-12 03:54:56', 37, 'PRD2', NULL, 'PRD2', '', '', '0006_0000000001', '0012_0000000001', 'ZONE', 'CloudApiDomainName=myhuaweicloud.com;Region=ap-southeast-3;ProjectId=', '生产2', '0022_0000000001', 'created', 'ap-southeast-3b'),
	('0022_0000000006', NULL, '0022_0000000006', 'umadmin', '2020-04-13 18:49:27', 'umadmin', '2020-04-13 18:49:27', 37, 'ODC', NULL, 'ODC', '', '', '0006_0000000001', '0012_0000000001', 'REGION', '1', '数据中心外部', '', 'created', '1');
/*!40000 ALTER TABLE `data_center` ENABLE KEYS */;

/*!40000 ALTER TABLE `data_center$deploy_environment` DISABLE KEYS */;
INSERT INTO `data_center$deploy_environment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(42, '0022_0000000006', '0003_0000000001', 2),
	(43, '0022_0000000006', '0003_0000000002', 1),
	(49, '0022_0000000004', '0003_0000000002', 1),
	(50, '0022_0000000005', '0003_0000000001', 1),
	(51, '0022_0000000003', '0003_0000000001', 1),
	(52, '0022_0000000002', '0003_0000000002', 1),
	(53, '0022_0000000001', '0003_0000000001', 1);
/*!40000 ALTER TABLE `data_center$deploy_environment` ENABLE KEYS */;

/*!40000 ALTER TABLE `data_center_design` DISABLE KEYS */;
INSERT INTO `data_center_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0012_0000000001', NULL, '0012_0000000001', 'umadmin', '2020-04-12 00:00:03', 'umadmin', '2020-04-12 00:00:02', 34, 'PCD', NULL, 'PCD', '公有云机房', '公有云机房', 'new');
/*!40000 ALTER TABLE `data_center_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `default_security_policy` DISABLE KEYS */;
INSERT INTO `default_security_policy` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `default_security_policy_design`, `policy_network_segment`, `owner_network_segment`, `port`, `protocol`, `security_policy_action`, `security_policy_type`, `state_code`, `security_policy_asset_id`) VALUES
	('0025_0000000001', NULL, '0025_0000000001', 'umadmin', '2020-04-14 17:05:14', 'umadmin', '2020-04-12 12:55:10', 37, 'PRD_SF ACCEPT PRD_SF egress 1-65535', NULL, 'PRD_SF ACCEPT PRD_SF egress 1-65535', '', '0015_0000000001', '0023_0000000009', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000002', NULL, '0025_0000000002', 'umadmin', '2020-04-14 17:05:13', 'umadmin', '2020-04-12 13:06:25', 37, 'PRD_MG ACCEPT PRD_MG egress 1-65535', NULL, 'PRD_MG ACCEPT PRD_MG egress 1-65535', '', '0015_0000000004', '0023_0000000008', '0023_0000000008', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000003', NULL, '0025_0000000003', 'umadmin', '2020-04-14 17:05:13', 'umadmin', '2020-04-12 13:06:25', 37, 'PRD_SF ACCEPT PRD1_MG_APP egress 1-65535', NULL, 'PRD_SF ACCEPT PRD1_MG_APP egress 1-65535', '', '0015_0000000005', '0023_0000000023', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000004', NULL, '0025_0000000004', 'umadmin', '2020-04-14 17:05:13', 'umadmin', '2020-04-12 13:06:26', 37, 'PRD_SF ACCEPT PRD2_MG_APP egress 1-65535', NULL, 'PRD_SF ACCEPT PRD2_MG_APP egress 1-65535', '', '0015_0000000005', '0023_0000000029', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000005', NULL, '0025_0000000005', 'umadmin', '2020-04-14 17:04:46', 'umadmin', '2020-04-12 13:07:12', 37, 'PRD_MG ACCEPT PRD_SF egress 1-65535', NULL, 'PRD_MG ACCEPT PRD_SF egress 1-65535', '', '0015_0000000008', '0023_0000000009', '0023_0000000008', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000006', NULL, '0025_0000000006', 'umadmin', '2020-04-14 17:04:45', 'umadmin', '2020-04-14 00:53:18', 37, 'PRD_SF ACCEPT PRD1_MG_APP ingress 1-65535', NULL, 'PRD_SF ACCEPT PRD1_MG_APP ingress 1-65535', '', '0015_0000000011', '0023_0000000023', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000007', NULL, '0025_0000000007', 'umadmin', '2020-04-14 17:04:45', 'umadmin', '2020-04-14 00:53:59', 37, 'PRD_SF ACCEPT PRD2_MG_APP ingress 1-65535', NULL, 'PRD_SF ACCEPT PRD2_MG_APP ingress 1-65535', '', '0015_0000000011', '0023_0000000029', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000008', NULL, '0025_0000000008', 'umadmin', '2020-04-14 17:04:45', 'umadmin', '2020-04-14 00:54:51', 37, 'PRD_SF ACCEPT PRD1_MG_LB egress 1-65535', NULL, 'PRD_SF ACCEPT PRD1_MG_LB egress 1-65535', '', '0015_0000000012', '0023_0000000022', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000009', NULL, '0025_0000000009', 'umadmin', '2020-04-14 17:04:44', 'umadmin', '2020-04-14 00:55:17', 37, 'PRD_SF ACCEPT PRD2_MG_LB egress 1-65535', NULL, 'PRD_SF ACCEPT PRD2_MG_LB egress 1-65535', '', '0015_0000000012', '0023_0000000028', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000010', NULL, '0025_0000000010', 'umadmin', '2020-04-14 17:04:44', 'umadmin', '2020-04-14 00:56:34', 37, 'PRD_SF ACCEPT PRD1_MG_VDI egress 1-65535', NULL, 'PRD_SF ACCEPT PRD1_MG_VDI egress 1-65535', '', '0015_0000000018', '0023_0000000020', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000011', NULL, '0025_0000000011', 'umadmin', '2020-04-14 17:04:44', 'umadmin', '2020-04-14 00:56:34', 37, 'PRD_SF ACCEPT PRD2_MG_VDI egress 1-65535', NULL, 'PRD_SF ACCEPT PRD2_MG_VDI egress 1-65535', '', '0015_0000000018', '0023_0000000026', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000012', NULL, '0025_0000000012', 'umadmin', '2020-04-14 17:04:43', 'umadmin', '2020-04-14 00:57:02', 37, 'PRD_SF ACCEPT DR_SF ingress 1-65535', NULL, 'PRD_SF ACCEPT DR_SF ingress 1-65535', '', '0015_0000000017', '0023_0000000007', '0023_0000000009', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000013', NULL, '0025_0000000013', 'umadmin', '2020-04-14 17:04:43', 'umadmin', '2020-04-14 00:57:55', 37, 'PRD_MG ACCEPT PRD_MG ingress 1-65535', NULL, 'PRD_MG ACCEPT PRD_MG ingress 1-65535', '', '0015_0000000016', '0023_0000000008', '0023_0000000008', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000014', NULL, '0025_0000000014', 'umadmin', '2020-04-14 17:04:43', 'umadmin', '2020-04-14 00:58:17', 37, 'PRD_MG ACCEPT PRD_SF ingress 1-65535', NULL, 'PRD_MG ACCEPT PRD_SF ingress 1-65535', '', '0015_0000000013', '0023_0000000009', '0023_0000000008', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', '');
/*!40000 ALTER TABLE `default_security_policy` ENABLE KEYS */;

/*!40000 ALTER TABLE `default_security_policy_design` DISABLE KEYS */;
INSERT INTO `default_security_policy_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `policy_network_segment_design`, `owner_network_segment_design`, `port`, `protocol`, `security_policy_action`, `security_policy_type`, `state_code`) VALUES
	('0015_0000000001', NULL, '0015_0000000001', 'umadmin', '2020-04-14 17:02:19', 'umadmin', '2020-04-12 02:28:15', 34, 'PCD_SF ACCEPT PCD_SF egress1-65535', NULL, 'PCD_SF ACCEPT PCD_SF egress', 'SF内部访问', '0013_0000000002', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000002', NULL, '0015_0000000002', 'umadmin', '2020-04-14 17:02:18', 'umadmin', '2020-04-12 02:31:22', 34, 'PCD_DMZ ACCEPT PCD_DMZ egress1-65535', NULL, 'PCD_DMZ ACCEPT PCD_DMZ egress', 'DMZ内部访问', '0013_0000000003', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000003', NULL, '0015_0000000003', 'umadmin', '2020-04-14 17:02:18', 'umadmin', '2020-04-12 02:31:23', 34, 'PCD_ECN ACCEPT PCD_ECN egress1-65535', NULL, 'PCD_ECN ACCEPT PCD_ECN egress', 'ECN内部访问', '0013_0000000004', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000004', NULL, '0015_0000000004', 'umadmin', '2020-04-14 17:02:17', 'umadmin', '2020-04-12 02:31:24', 34, 'PCD_MG ACCEPT PCD_MG egress1-65535', NULL, 'PCD_MG ACCEPT PCD_MG egress', 'MG内部访问', '0013_0000000005', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000005', NULL, '0015_0000000005', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 02:35:05', 34, 'PCD_SF ACCEPT PCD_MG_APP egress1-65535', NULL, 'PCD_SF ACCEPT PCD_MG_APP egress', 'SF访问工具', '0013_0000000018', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000006', NULL, '0015_0000000006', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 02:35:06', 34, 'PCD_DMZ ACCEPT PCD_MG_APP egress1-65535', NULL, 'PCD_DMZ ACCEPT PCD_MG_APP egress', 'DMZ访问MG的APP', '0013_0000000018', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000007', NULL, '0015_0000000007', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 02:35:06', 34, 'PCD_ECN ACCEPT PCD_MG_APP egress1-65535', NULL, 'PCD_ECN ACCEPT PCD_MG_APP egress', 'ECN访问MG的APP', '0013_0000000018', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000008', NULL, '0015_0000000008', 'umadmin', '2020-04-14 17:01:59', 'umadmin', '2020-04-12 02:35:07', 34, 'PCD_MG ACCEPT PCD_SF egress1-65535', NULL, 'PCD_MG ACCEPT PCD_SF egress', 'MG访访问SF', '0013_0000000002', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000009', NULL, '0015_0000000009', 'umadmin', '2020-04-14 17:01:58', 'umadmin', '2020-04-12 02:35:08', 34, 'PCD_MG ACCEPT PCD_DMZ egress1-65535', NULL, 'PCD_MG ACCEPT PCD_DMZ egress', 'MG访访问DMZ', '0013_0000000003', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000010', NULL, '0015_0000000010', 'umadmin', '2020-04-14 17:01:58', 'umadmin', '2020-04-12 02:35:08', 34, 'PCD_MG ACCEPT PCD_ECN egress1-65535', NULL, 'PCD_MG ACCEPT PCD_ECN egress', 'MG访访问ECN', '0013_0000000004', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000011', NULL, '0015_0000000011', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-13 21:34:12', 34, 'PCD_SF ACCEPT PCD_MG_APP ingress1-65535', NULL, 'PCD_SF ACCEPT PCD_MG_APP ingress', '工具APP访问SF', '0013_0000000018', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000012', NULL, '0015_0000000012', 'umadmin', '2020-04-14 17:01:57', 'umadmin', '2020-04-14 00:36:01', 34, 'PCD_SF ACCEPT PCD_MG_LB egress1-65535', NULL, 'PCD_SF ACCEPT PCD_MG_LB egress', 'SF访问工具负载均衡', '0013_0000000019', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000013', NULL, '0015_0000000013', 'umadmin', '2020-04-14 17:01:56', 'umadmin', '2020-04-14 00:37:37', 34, 'PCD_MG ACCEPT PCD_SF ingress1-65535', NULL, 'PCD_MG ACCEPT PCD_SF ingress', 'SF访问MG', '0013_0000000002', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000014', NULL, '0015_0000000014', 'umadmin', '2020-04-14 17:01:55', 'umadmin', '2020-04-14 00:38:16', 34, 'PCD_MG ACCEPT PCD_DMZ ingress1-65535', NULL, 'PCD_MG ACCEPT PCD_DMZ ingress', 'DMZ访问MG', '0013_0000000003', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000015', NULL, '0015_0000000015', 'umadmin', '2020-04-14 17:01:39', 'umadmin', '2020-04-14 00:38:17', 34, 'PCD_MG ACCEPT PCD_ECN ingress1-65535', NULL, 'PCD_MG ACCEPT PCD_ECN ingress', 'ECN访问MG', '0013_0000000004', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000016', NULL, '0015_0000000016', 'umadmin', '2020-04-14 17:01:38', 'umadmin', '2020-04-14 00:38:58', 34, 'PCD_MG ACCEPT PCD_MG ingress1-65535', NULL, 'PCD_MG ACCEPT PCD_MG ingress', 'MG内部访问', '0013_0000000005', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000017', NULL, '0015_0000000017', 'umadmin', '2020-04-14 17:01:38', 'umadmin', '2020-04-14 00:40:32', 34, 'PCD_SF ACCEPT PCD_SF ingress1-65535', NULL, 'PCD_SF ACCEPT PCD_SF ingress', 'SF内部访问', '0013_0000000002', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000018', NULL, '0015_0000000018', 'umadmin', '2020-04-14 17:01:37', 'umadmin', '2020-04-14 00:41:52', 34, 'PCD_SF ACCEPT PCD_MG_VDI egress1-65535', NULL, 'PCD_SF ACCEPT PCD_MG_VDI egress', 'VDI客户端访问', '0013_0000000020', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000019', NULL, '0015_0000000019', 'umadmin', '2020-04-14 17:01:37', 'umadmin', '2020-04-14 00:47:13', 34, 'PCD_ECN ACCEPT PCD_ECN ingress1-65535', NULL, 'PCD_ECN ACCEPT PCD_ECN ingress', 'ECN内部访问', '0013_0000000004', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000020', NULL, '0015_0000000020', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-14 00:48:47', 34, 'PCD_ECN ACCEPT PCD_MG_APP ingress1-65535', NULL, 'PCD_ECN ACCEPT PCD_MG_APP ingress', 'MG的APP访问ECN', '0013_0000000018', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000021', NULL, '0015_0000000021', 'umadmin', '2020-04-14 17:01:35', 'umadmin', '2020-04-14 00:49:34', 34, 'PCD_ECN ACCEPT PCD_MG_LB egress1-65535', NULL, 'PCD_ECN ACCEPT PCD_MG_LB egress', 'ECN访问MG的LB', '0013_0000000019', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000022', NULL, '0015_0000000022', 'umadmin', '2020-04-14 17:01:35', 'umadmin', '2020-04-14 00:51:13', 34, 'PCD_DMZ ACCEPT PCD_MG_LB egress1-65535', NULL, 'PCD_DMZ ACCEPT PCD_MG_LB egress', 'ECN访问MG的LB', '0013_0000000019', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000023', NULL, '0015_0000000023', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-14 00:51:14', 34, 'PCD_DMZ ACCEPT PCD_MG_APP ingress1-65535', NULL, 'PCD_DMZ ACCEPT PCD_MG_APP ingress', 'MG的APP访问ECN', '0013_0000000018', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000024', NULL, '0015_0000000024', 'umadmin', '2020-04-14 17:01:34', 'umadmin', '2020-04-14 00:51:15', 34, 'PCD_DMZ ACCEPT PCD_ECN ingress1-65535', NULL, 'PCD_DMZ ACCEPT PCD_ECN ingress', 'ECN内部访问', '0013_0000000004', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new');
/*!40000 ALTER TABLE `default_security_policy_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `deploy_environment` DISABLE KEYS */;
INSERT INTO `deploy_environment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0003_0000000001', NULL, '0003_0000000001', 'umadmin', '2020-04-11 21:55:55', 'umadmin', '2020-04-11 21:55:54', 34, '生产环境', NULL, 'PRD', '生产环境', '生产环境', 'new'),
	('0003_0000000002', NULL, '0003_0000000002', 'umadmin', '2020-04-11 21:56:10', 'umadmin', '2020-04-11 21:56:10', 34, '容灾环境', NULL, 'DR', '容灾环境', '容灾环境', 'new');
/*!40000 ALTER TABLE `deploy_environment` ENABLE KEYS */;

/*!40000 ALTER TABLE `deploy_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `deploy_package` ENABLE KEYS */;

/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` DISABLE KEYS */;
/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` ENABLE KEYS */;

/*!40000 ALTER TABLE `diff_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `diff_configuration` ENABLE KEYS */;

/*!40000 ALTER TABLE `host_resource_instance` DISABLE KEYS */;
INSERT INTO `host_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `intranet_ip`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_system`, `resource_instance_type`, `resource_set`, `state_code`, `storage`, `unit_type`, `user_name`, `user_password`, `storage_type`) VALUES
	('0032_0000000001', NULL, '0032_0000000001', 'umadmin', '2020-04-15 11:18:46', 'umadmin', '2020-04-12 15:23:15', 40, 'PRD2_SF_APP_cstapp2', NULL, 'cstapp2_10.128.64.2', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000034', '22', '', '', '10.128.64.2:9100', '9100', 'cstapp2', '0010_0000000006', '0011_0000000001', '0009_0000000001', '0029_0000000002', 'created', '50', '0002_0000000001', 'root', 'Abcd1234', '0062_0000000001'),
	('0032_0000000002', NULL, '0032_0000000002', 'umadmin', '2020-04-15 11:18:43', 'umadmin', '2020-04-12 15:33:48', 40, 'PRD1_SF_APP_cstapp1', NULL, 'cstapp1_10.128.0.2', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000002', '22', '', '', '10.128.0.2:9100', '9100', 'cstapp1', '0010_0000000006', '0011_0000000001', '0009_0000000001', '0029_0000000002', 'created', '50', '0002_0000000001', 'root', 'Abcd1234', '0062_0000000001'),
	('0032_0000000003', NULL, '0032_0000000003', 'umadmin', '2020-04-15 11:18:40', 'umadmin', '2020-04-12 15:35:34', 40, 'PRD1_MG_APP_wecubeplugin', NULL, 'wecubeplugin_10.128.202.2', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000066', '22', '', '', '10.128.202.2:9100', '9100', 'wecubeplugin', '0010_0000000006', '0011_0000000001', '0009_0000000001', '0029_0000000024', 'created', '50', '0002_0000000001', 'root', 'Abcd1234', '0062_0000000001'),
	('0032_0000000004', NULL, '0032_0000000004', 'umadmin', '2020-04-15 11:18:39', 'umadmin', '2020-04-12 15:36:33', 40, 'PRD1_MG_APP_wecubecore', NULL, 'wecubecore_10.128.202.3', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000067', '22', '', '', '10.128.202.3:9100', '9100', 'wecubecore', '0010_0000000006', '0011_0000000001', '0009_0000000001', '0029_0000000024', 'created', '50', '0002_0000000001', 'root', 'Abcd1234', '0062_0000000001'),
	('0032_0000000005', NULL, '0032_0000000005', 'umadmin', '2020-04-15 11:18:37', 'umadmin', '2020-04-14 01:28:06', 40, 'PRD1_MG_VDI_wecubevdi', NULL, 'wecubevdi_10.128.192.3', '', '', '', '', '0063_0000000002', '0008_0000000003', '', '', '0031_0000000097', '22', '', '', '10.128.192.3:9100', '9100', 'wecubevdi', '0010_0000000004', '0011_0000000004', '0009_0000000005', '0029_0000000029', 'created', '50', '0002_0000000005', 'admin', 'Abcd1234', '0062_0000000007'),
	('0032_0000000006', NULL, '0032_0000000006', 'umadmin', '2020-04-15 11:18:36', 'umadmin', '2020-04-14 01:30:02', 40, 'PRD1_MG_PROXY_wecubesquid', NULL, 'wecubesquid_10.128.199.3', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000109', '22', '', '', '10.128.199.3:9100', '9100', 'wecubesquid', '0010_0000000003', '0011_0000000003', '0009_0000000004', '0029_0000000026', 'created', '50', '0002_0000000006', 'root', 'Abcd1234', '0062_0000000008');
/*!40000 ALTER TABLE `host_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `invoke` DISABLE KEYS */;
INSERT INTO `invoke` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `access_control`, `invoked_unit`, `invoke_design`, `invoke_type`, `invoke_unit`, `state_code`) VALUES
	('0049_0000000001', NULL, '0049_0000000001', 'umadmin', '2020-04-13 14:13:03', 'umadmin', '2020-04-13 14:13:02', 37, 'PRD_UM_CLIENT_BROWSER-->--PRD_UM_SSO_LB', NULL, 'PRD_UM_CLIENT_BROWSER-->--PRD_UM_SSO_LB', '', '', '0048_0000000005', '0040_0000000001', '同步调用', '0048_0000000001', 'created'),
	('0049_0000000002', NULL, '0049_0000000002', 'umadmin', '2020-04-13 14:14:29', 'umadmin', '2020-04-13 14:14:28', 37, 'PRD_UM_SRV_APP-->--PRD_UM_CORE_DB', NULL, 'PRD_UM_SRV_APP-->--PRD_UM_CORE_DB', '', '', '0048_0000000002', '0040_0000000002', '同步调用', '0048_0000000008', 'created'),
	('0049_0000000003', NULL, '0049_0000000003', 'umadmin', '2020-04-13 14:14:29', 'umadmin', '2020-04-13 14:14:29', 37, 'PRD_UM_CORE_APP-->--PRD_UM_CORE_DB', NULL, 'PRD_UM_CORE_APP-->--PRD_UM_CORE_DB', '', '', '0048_0000000002', '0040_0000000003', '同步调用', '0048_0000000004', 'created'),
	('0049_0000000004', NULL, '0049_0000000004', 'umadmin', '2020-04-13 14:14:29', 'umadmin', '2020-04-13 14:14:29', 37, 'PRD_UM_CORE_APP-->--PRD_UM_SRV_APP', NULL, 'PRD_UM_CORE_APP-->--PRD_UM_SRV_APP', '', '', '0048_0000000008', '0040_0000000004', '同步调用', '0048_0000000004', 'created'),
	('0049_0000000005', NULL, '0049_0000000005', 'umadmin', '2020-04-13 14:14:30', 'umadmin', '2020-04-13 14:14:29', 37, 'PRD_UM_CORE_APP-->--PRD_UM_SSO_REDIS', NULL, 'PRD_UM_CORE_APP-->--PRD_UM_SSO_REDIS', '', '', '0048_0000000006', '0040_0000000005', '同步调用', '0048_0000000004', 'created'),
	('0049_0000000006', NULL, '0049_0000000006', 'umadmin', '2020-04-13 14:14:30', 'umadmin', '2020-04-13 14:14:30', 37, 'PRD_UM_CORE_LB-->--PRD_UM_CORE_APP', NULL, 'PRD_UM_CORE_LB-->--PRD_UM_CORE_APP', '', '', '0048_0000000004', '0040_0000000006', '同步调用', '0048_0000000003', 'created'),
	('0049_0000000007', NULL, '0049_0000000007', 'umadmin', '2020-04-13 14:14:30', 'umadmin', '2020-04-13 14:14:30', 37, 'PRD_UM_CLIENT_BROWSER-->--PRD_UM_CORE_LB', NULL, 'PRD_UM_CLIENT_BROWSER-->--PRD_UM_CORE_LB', '', '', '0048_0000000003', '0040_0000000007', '同步调用', '0048_0000000001', 'created'),
	('0049_0000000008', NULL, '0049_0000000008', 'umadmin', '2020-04-13 14:14:31', 'umadmin', '2020-04-13 14:14:30', 37, 'PRD_UM_SSO_APP-->--PRD_UM_SSO_REDIS', NULL, 'PRD_UM_SSO_APP-->--PRD_UM_SSO_REDIS', '', '', '0048_0000000006', '0040_0000000009', '同步调用', '0048_0000000007', 'created'),
	('0049_0000000009', NULL, '0049_0000000009', 'umadmin', '2020-04-13 14:14:31', 'umadmin', '2020-04-13 14:14:31', 37, 'PRD_UM_SSO_APP-->--PRD_UM_SRV_APP', NULL, 'PRD_UM_SSO_APP-->--PRD_UM_SRV_APP', '', '', '0048_0000000008', '0040_0000000008', '同步调用', '0048_0000000007', 'created'),
	('0049_0000000010', NULL, '0049_0000000010', 'umadmin', '2020-04-13 14:14:31', 'umadmin', '2020-04-13 14:14:31', 37, 'PRD_UM_SSO_LB-->--PRD_UM_SSO_APP', NULL, 'PRD_UM_SSO_LB-->--PRD_UM_SSO_APP', '', '', '0048_0000000007', '0040_0000000010', '同步调用', '0048_0000000005', 'created'),
	('0049_0000000011', NULL, '0049_0000000011', 'umadmin', '2020-04-13 15:20:34', 'umadmin', '2020-04-13 15:20:33', 37, 'PRD_FPS_TP_APP-->--PRD_FPS_HBASE_APP', NULL, 'PRD_FPS_TP_APP-->--PRD_FPS_HBASE_APP', '', '', '0048_0000000010', '0040_0000000011', '同步调用', '0048_0000000009', 'created'),
	('0049_0000000012', NULL, '0049_0000000012', 'umadmin', '2020-04-13 15:20:42', 'umadmin', '2020-04-13 15:20:42', 37, 'PRD_FPS_TP_APP-->--PRD_UM_SRV_APP', NULL, 'PRD_FPS_TP_APP-->--PRD_UM_SRV_APP', '', '', '0048_0000000008', '0040_0000000012', '同步调用', '0048_0000000009', 'created'),
	('0049_0000000013', NULL, '0049_0000000013', 'umadmin', '2020-04-13 15:34:35', 'umadmin', '2020-04-13 15:34:35', 37, 'PRD_WEMQ_CLIENT_BROWSER-->--PRD_WEMQ_ADM_LB', NULL, 'PRD_WEMQ_CLIENT_BROWSER-->--PRD_WEMQ_ADM_LB', '', '', '0048_0000000017', '0040_0000000013', '同步调用', '0048_0000000011', 'created'),
	('0049_0000000014', NULL, '0049_0000000014', 'umadmin', '2020-04-13 15:36:39', 'umadmin', '2020-04-13 15:36:39', 37, 'PRD_WEMQ_BROKER_APP-->--PRD_WEMQ_CC_APP', NULL, 'PRD_WEMQ_BROKER_APP-->--PRD_WEMQ_CC_APP', '', '', '0048_0000000016', '0040_0000000023', '同步调用', '0048_0000000014', 'created'),
	('0049_0000000015', NULL, '0049_0000000015', 'umadmin', '2020-04-13 15:36:39', 'umadmin', '2020-04-13 15:36:39', 37, 'PRD_WEMQ_BROKER_APP-->--PRD_WEMQ_NAMESRV_APP', NULL, 'PRD_WEMQ_BROKER_APP-->--PRD_WEMQ_NAMESRV_APP', '', '', '0048_0000000013', '0040_0000000022', '同步调用', '0048_0000000014', 'created'),
	('0049_0000000016', NULL, '0049_0000000016', 'umadmin', '2020-04-13 15:36:40', 'umadmin', '2020-04-13 15:36:39', 37, 'PRD_WEMQ_CC_APP-->--PRD_WEMQ_BROKER_APP', NULL, 'PRD_WEMQ_CC_APP-->--PRD_WEMQ_BROKER_APP', '', '', '0048_0000000014', '0040_0000000017', '同步调用', '0048_0000000016', 'created'),
	('0049_0000000017', NULL, '0049_0000000017', 'umadmin', '2020-04-13 15:36:40', 'umadmin', '2020-04-13 15:36:40', 37, 'PRD_WEMQ_CC_APP-->--PRD_WEMQ_NAMESRV_APP', NULL, 'PRD_WEMQ_CC_APP-->--PRD_WEMQ_NAMESRV_APP', '', '', '0048_0000000013', '0040_0000000016', '同步调用', '0048_0000000016', 'created'),
	('0049_0000000018', NULL, '0049_0000000018', 'umadmin', '2020-04-13 15:36:40', 'umadmin', '2020-04-13 15:36:40', 37, 'PRD_WEMQ_CC_APP-->--PRD_WEMQ_CC_DB', NULL, 'PRD_WEMQ_CC_APP-->--PRD_WEMQ_CC_DB', '', '', '0048_0000000015', '0040_0000000015', '同步调用', '0048_0000000016', 'created'),
	('0049_0000000019', NULL, '0049_0000000019', 'umadmin', '2020-04-13 15:36:40', 'umadmin', '2020-04-13 15:36:40', 37, 'PRD_WEMQ_ADM_LB-->--PRD_WEMQ_ADM_APP', NULL, 'PRD_WEMQ_ADM_LB-->--PRD_WEMQ_ADM_APP', '', '', '0048_0000000012', '0040_0000000014', '同步调用', '0048_0000000017', 'created'),
	('0049_0000000020', NULL, '0049_0000000020', 'umadmin', '2020-04-13 15:36:41', 'umadmin', '2020-04-13 15:36:40', 37, 'PRD_WEMQ_ADM_APP-->--PRD_WEMQ_CC_APP', NULL, 'PRD_WEMQ_ADM_APP-->--PRD_WEMQ_CC_APP', '', '', '0048_0000000016', '0040_0000000021', '同步调用', '0048_0000000012', 'created'),
	('0049_0000000021', NULL, '0049_0000000021', 'umadmin', '2020-04-13 15:36:41', 'umadmin', '2020-04-13 15:36:41', 37, 'PRD_WEMQ_ADM_APP-->--PRD_WEMQ_NAMESRV_APP', NULL, 'PRD_WEMQ_ADM_APP-->--PRD_WEMQ_NAMESRV_APP', '', '', '0048_0000000013', '0040_0000000020', '同步调用', '0048_0000000012', 'created'),
	('0049_0000000022', NULL, '0049_0000000022', 'umadmin', '2020-04-13 15:36:41', 'umadmin', '2020-04-13 15:36:41', 37, 'PRD_WEMQ_ADM_APP-->--PRD_WEMQ_CC_DB', NULL, 'PRD_WEMQ_ADM_APP-->--PRD_WEMQ_CC_DB', '', '', '0048_0000000015', '0040_0000000019', '同步调用', '0048_0000000012', 'created'),
	('0049_0000000023', NULL, '0049_0000000023', 'umadmin', '2020-04-13 15:36:42', 'umadmin', '2020-04-13 15:36:41', 37, 'PRD_WEMQ_ADM_APP-->--PRD_UM_SSO_APP', NULL, 'PRD_WEMQ_ADM_APP-->--PRD_UM_SSO_APP', '', '', '0048_0000000007', '0040_0000000018', '同步调用', '0048_0000000012', 'created'),
	('0049_0000000024', NULL, '0049_0000000024', 'umadmin', '2020-04-13 15:45:44', 'umadmin', '2020-04-13 15:45:44', 37, 'PRD_RMB_CLIENT_BROWSER-->--PRD_RMB_SGS_LB', NULL, 'PRD_RMB_CLIENT_BROWSER-->--PRD_RMB_SGS_LB', '', '', '0048_0000000019', '0040_0000000024', '同步调用', '0048_0000000020', 'created'),
	('0049_0000000025', NULL, '0049_0000000025', 'umadmin', '2020-04-13 15:46:23', 'umadmin', '2020-04-13 15:46:22', 37, 'PRD_RMB_SGS_APP-->--PRD_UM_SSO_APP', NULL, 'PRD_RMB_SGS_APP-->--PRD_UM_SSO_APP', '', '', '0048_0000000007', '0040_0000000028', '同步调用', '0048_0000000018', 'created'),
	('0049_0000000026', NULL, '0049_0000000026', 'umadmin', '2020-04-13 15:46:23', 'umadmin', '2020-04-13 15:46:23', 37, 'PRD_RMB_SGS_APP-->--PRD_UM_SRV_APP', NULL, 'PRD_RMB_SGS_APP-->--PRD_UM_SRV_APP', '', '', '0048_0000000008', '0040_0000000027', '同步调用', '0048_0000000018', 'created'),
	('0049_0000000027', NULL, '0049_0000000027', 'umadmin', '2020-04-13 15:46:23', 'umadmin', '2020-04-13 15:46:23', 37, 'PRD_RMB_SGS_APP-->--PRD_RMB_SGS_DB', NULL, 'PRD_RMB_SGS_APP-->--PRD_RMB_SGS_DB', '', '', '0048_0000000021', '0040_0000000026', '同步调用', '0048_0000000018', 'created'),
	('0049_0000000028', NULL, '0049_0000000028', 'umadmin', '2020-04-13 15:46:24', 'umadmin', '2020-04-13 15:46:23', 37, 'PRD_RMB_SGS_LB-->--PRD_RMB_SGS_APP', NULL, 'PRD_RMB_SGS_LB-->--PRD_RMB_SGS_APP', '', '', '0048_0000000018', '0040_0000000025', '同步调用', '0048_0000000019', 'created');
/*!40000 ALTER TABLE `invoke` ENABLE KEYS */;

/*!40000 ALTER TABLE `invoke_design` DISABLE KEYS */;
INSERT INTO `invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_unit_design`, `invoke_type`, `invoke_unit_design`, `resource_set_invoke_design`, `state_code`) VALUES
	('0040_0000000001', NULL, '0040_0000000001', 'umadmin', '2020-04-15 14:19:02', 'umadmin', '2020-04-13 14:02:27', 34, 'UM_CLIENT_BROWER-->--UM_SSO_LB', '2020-04-15 14:19:00', 'BROWER-->--LB', '', '0039_0000000006', '同步调用', '0039_0000000001', '0021_0000000001', 'new'),
	('0040_0000000002', NULL, '0040_0000000002', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:48', 34, 'UM_SRV_APP-->--UM_CORE_DB', '2020-04-15 14:19:00', 'APP-->--DB', '', '0039_0000000007', '同步调用', '0039_0000000002', '0021_0000000003', 'new'),
	('0040_0000000003', NULL, '0040_0000000003', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:48', 34, 'UM_CORE_APP-->--UM_CORE_DB', '2020-04-15 14:19:00', 'APP-->--DB', '', '0039_0000000007', '同步调用', '0039_0000000008', '0021_0000000003', 'new'),
	('0040_0000000004', NULL, '0040_0000000004', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:48', 34, 'UM_CORE_APP-->--UM_SRV_APP', '2020-04-15 14:19:00', 'APP-->--APP', '', '0039_0000000002', '同步调用', '0039_0000000008', '0021_0000000016', 'new'),
	('0040_0000000005', NULL, '0040_0000000005', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:48', 34, 'UM_CORE_APP-->--UM_SSO_REDIS', '2020-04-15 14:19:00', 'APP-->--REDIS', '', '0039_0000000004', '同步调用', '0039_0000000008', '0021_0000000004', 'new'),
	('0040_0000000006', NULL, '0040_0000000006', 'umadmin', '2020-04-15 14:19:02', 'umadmin', '2020-04-13 14:05:49', 34, 'UM_CORE_LB-->--UM_CORE_APP', '2020-04-15 14:19:00', 'LB-->--APP', '', '0039_0000000008', '同步调用', '0039_0000000005', '0021_0000000005', 'new'),
	('0040_0000000007', NULL, '0040_0000000007', 'umadmin', '2020-04-15 14:19:02', 'umadmin', '2020-04-13 14:05:49', 34, 'UM_CLIENT_BROWER-->--UM_CORE_LB', '2020-04-15 14:19:00', 'BROWER-->--LB', '', '0039_0000000005', '同步调用', '0039_0000000001', '0021_0000000001', 'new'),
	('0040_0000000008', NULL, '0040_0000000008', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:49', 34, 'UM_SSO_APP-->--UM_SRV_APP', '2020-04-15 14:19:00', 'APP-->--APP', '', '0039_0000000002', '同步调用', '0039_0000000003', '0021_0000000016', 'new'),
	('0040_0000000009', NULL, '0040_0000000009', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:50', 34, 'UM_SSO_APP-->--UM_SSO_REDIS', '2020-04-15 14:19:00', 'APP-->--REDIS', '', '0039_0000000004', '同步调用', '0039_0000000003', '0021_0000000004', 'new'),
	('0040_0000000010', NULL, '0040_0000000010', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:05:50', 34, 'UM_SSO_LB-->--UM_SSO_APP', '2020-04-15 14:19:00', 'LB-->--APP', '', '0039_0000000003', '同步调用', '0039_0000000006', '0021_0000000005', 'new'),
	('0040_0000000011', NULL, '0040_0000000011', 'umadmin', '2020-04-13 14:43:40', 'umadmin', '2020-04-13 14:43:39', 34, 'FPS_TP_APP-->--FPS_HBASE_APP', NULL, 'APP-->--APP', '', '0039_0000000010', '同步调用', '0039_0000000009', '0021_0000000016', 'new'),
	('0040_0000000012', NULL, '0040_0000000012', 'umadmin', '2020-04-13 14:43:57', 'umadmin', '2020-04-13 14:43:57', 34, 'FPS_TP_APP-->--UM_SRV_APP', NULL, 'APP-->--APP', '', '0039_0000000002', '同步调用', '0039_0000000009', '0021_0000000016', 'new'),
	('0040_0000000013', NULL, '0040_0000000013', 'umadmin', '2020-04-13 15:05:36', 'umadmin', '2020-04-13 15:05:36', 34, 'WEMQ_CLIENT_BROWER-->--WEMQ_ADM_LB', NULL, 'BROWER-->--LB', '', '0039_0000000013', '同步调用', '0039_0000000014', '0021_0000000001', 'new'),
	('0040_0000000014', NULL, '0040_0000000014', 'umadmin', '2020-04-13 15:08:55', 'umadmin', '2020-04-13 15:08:54', 34, 'WEMQ_ADM_LB-->--WEMQ_ADM_APP', NULL, 'LB-->--APP', '', '0039_0000000016', '同步调用', '0039_0000000013', '0021_0000000005', 'new'),
	('0040_0000000015', NULL, '0040_0000000015', 'umadmin', '2020-04-13 15:08:55', 'umadmin', '2020-04-13 15:08:55', 34, 'WEMQ_CC_APP-->--WEMQ_CC_DB', NULL, 'APP-->--DB', '', '0039_0000000015', '同步调用', '0039_0000000017', '0021_0000000003', 'new'),
	('0040_0000000016', NULL, '0040_0000000016', 'umadmin', '2020-04-13 15:08:55', 'umadmin', '2020-04-13 15:08:55', 34, 'WEMQ_CC_APP-->--WEMQ_NAMESRV_APP', NULL, 'APP-->--APP', '', '0039_0000000012', '同步调用', '0039_0000000017', '0021_0000000016', 'new'),
	('0040_0000000017', NULL, '0040_0000000017', 'umadmin', '2020-04-13 15:08:55', 'umadmin', '2020-04-13 15:08:55', 34, 'WEMQ_CC_APP-->--WEMQ_BROKER_APP', NULL, 'APP-->--APP', '', '0039_0000000011', '同步调用', '0039_0000000017', '0021_0000000016', 'new'),
	('0040_0000000018', NULL, '0040_0000000018', 'umadmin', '2020-04-13 15:08:56', 'umadmin', '2020-04-13 15:08:55', 34, 'WEMQ_ADM_APP-->--UM_SSO_APP', NULL, 'APP-->--APP', '', '0039_0000000003', '同步调用', '0039_0000000016', '0021_0000000016', 'new'),
	('0040_0000000019', NULL, '0040_0000000019', 'umadmin', '2020-04-13 15:08:56', 'umadmin', '2020-04-13 15:08:56', 34, 'WEMQ_ADM_APP-->--WEMQ_CC_DB', NULL, 'APP-->--DB', '', '0039_0000000015', '同步调用', '0039_0000000016', '0021_0000000003', 'new'),
	('0040_0000000020', NULL, '0040_0000000020', 'umadmin', '2020-04-13 15:08:56', 'umadmin', '2020-04-13 15:08:56', 34, 'WEMQ_ADM_APP-->--WEMQ_NAMESRV_APP', NULL, 'APP-->--APP', '', '0039_0000000012', '同步调用', '0039_0000000016', '0021_0000000016', 'new'),
	('0040_0000000021', NULL, '0040_0000000021', 'umadmin', '2020-04-13 15:08:57', 'umadmin', '2020-04-13 15:08:56', 34, 'WEMQ_ADM_APP-->--WEMQ_CC_APP', NULL, 'APP-->--APP', '', '0039_0000000017', '同步调用', '0039_0000000016', '0021_0000000016', 'new'),
	('0040_0000000022', NULL, '0040_0000000022', 'umadmin', '2020-04-13 15:08:57', 'umadmin', '2020-04-13 15:08:57', 34, 'WEMQ_BROKER_APP-->--WEMQ_NAMESRV_APP', NULL, 'APP-->--APP', '', '0039_0000000012', '同步调用', '0039_0000000011', '0021_0000000016', 'new'),
	('0040_0000000023', NULL, '0040_0000000023', 'umadmin', '2020-04-13 15:08:57', 'umadmin', '2020-04-13 15:08:57', 34, 'WEMQ_BROKER_APP-->--WEMQ_CC_APP', NULL, 'APP-->--APP', '', '0039_0000000017', '同步调用', '0039_0000000011', '0021_0000000016', 'new'),
	('0040_0000000024', NULL, '0040_0000000024', 'umadmin', '2020-04-13 15:15:21', 'umadmin', '2020-04-13 15:15:21', 34, 'RMB_CLIENT_BROWSER-->--RMB_SGS_LB', NULL, 'BROWSER-->--LB', '', '0039_0000000019', '同步调用', '0039_0000000020', '0021_0000000001', 'new'),
	('0040_0000000025', NULL, '0040_0000000025', 'umadmin', '2020-04-13 15:15:57', 'umadmin', '2020-04-13 15:15:57', 34, 'RMB_SGS_LB-->--RMB_SGS_APP', NULL, 'LB-->--APP', '', '0039_0000000018', '同步调用', '0039_0000000019', '0021_0000000005', 'new'),
	('0040_0000000026', NULL, '0040_0000000026', 'umadmin', '2020-04-13 15:16:47', 'umadmin', '2020-04-13 15:16:47', 34, 'RMB_SGS_APP-->--RMB_SGS_DB', NULL, 'APP-->--DB', '', '0039_0000000021', '同步调用', '0039_0000000018', '0021_0000000003', 'new'),
	('0040_0000000027', NULL, '0040_0000000027', 'umadmin', '2020-04-13 15:16:48', 'umadmin', '2020-04-13 15:16:47', 34, 'RMB_SGS_APP-->--UM_SRV_APP', NULL, 'APP-->--APP', '', '0039_0000000002', '同步调用', '0039_0000000018', '0021_0000000016', 'new'),
	('0040_0000000028', NULL, '0040_0000000028', 'umadmin', '2020-04-13 15:16:48', 'umadmin', '2020-04-13 15:16:48', 34, 'RMB_SGS_APP-->--UM_SSO_APP', NULL, 'APP-->--APP', '', '0039_0000000003', '同步调用', '0039_0000000018', '0021_0000000016', 'new');
/*!40000 ALTER TABLE `invoke_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `ip_address` DISABLE KEYS */;
INSERT INTO `ip_address` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `ip_address_usage`, `network_segment`, `state_code`, `used_record`, `asset_id`) VALUES
	('0031_0000000001', NULL, '0031_0000000001', 'umadmin', '2020-04-14 16:46:01', 'umadmin', '2020-04-12 14:32:13', 37, '10.128.0.1_PRD1_PRD1_SF_APP', NULL, '10.128.0.1', '', '网关', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000002', NULL, '0031_0000000002', 'umadmin', '2020-04-15 11:18:43', 'umadmin', '2020-04-12 14:34:14', 37, '10.128.0.2_PRD1_PRD1_SF_APP', NULL, '10.128.0.2', '', '内网资源', '0023_0000000010', 'created', 'cstapp1使用', ''),
	('0031_0000000003', NULL, '0031_0000000003', 'umadmin', '2020-04-14 16:46:01', 'umadmin', '2020-04-12 14:34:15', 37, '10.128.0.3_PRD1_PRD1_SF_APP', NULL, '10.128.0.3', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000004', NULL, '0031_0000000004', 'umadmin', '2020-04-14 16:46:01', 'umadmin', '2020-04-12 14:34:15', 37, '10.128.0.4_PRD1_PRD1_SF_APP', NULL, '10.128.0.4', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000005', NULL, '0031_0000000005', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:16', 37, '10.128.0.5_PRD1_PRD1_SF_APP', NULL, '10.128.0.5', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000006', NULL, '0031_0000000006', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:17', 37, '10.128.0.6_PRD1_PRD1_SF_APP', NULL, '10.128.0.6', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000007', NULL, '0031_0000000007', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:18', 37, '10.128.0.7_PRD1_PRD1_SF_APP', NULL, '10.128.0.7', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000008', NULL, '0031_0000000008', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:19', 37, '10.128.0.8_PRD1_PRD1_SF_APP', NULL, '10.128.0.8', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000009', NULL, '0031_0000000009', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:20', 37, '10.128.0.9_PRD1_PRD1_SF_APP', NULL, '10.128.0.9', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000010', NULL, '0031_0000000010', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:21', 37, '10.128.0.10_PRD1_PRD1_SF_APP', NULL, '10.128.0.10', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000011', NULL, '0031_0000000011', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:22', 37, '10.128.0.11_PRD1_PRD1_SF_APP', NULL, '10.128.0.11', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000012', NULL, '0031_0000000012', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:23', 37, '10.128.0.12_PRD1_PRD1_SF_APP', NULL, '10.128.0.12', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000013', NULL, '0031_0000000013', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:23', 37, '10.128.0.13_PRD1_PRD1_SF_APP', NULL, '10.128.0.13', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000014', NULL, '0031_0000000014', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:24', 37, '10.128.0.14_PRD1_PRD1_SF_APP', NULL, '10.128.0.14', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000015', NULL, '0031_0000000015', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:25', 37, '10.128.0.15_PRD1_PRD1_SF_APP', NULL, '10.128.0.15', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000016', NULL, '0031_0000000016', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 14:34:26', 37, '10.128.0.16_PRD1_PRD1_SF_APP', NULL, '10.128.0.16', '', '内网资源', '0023_0000000010', 'created', '使用', ''),
	('0031_0000000017', NULL, '0031_0000000017', 'umadmin', '2020-04-14 16:45:58', 'umadmin', '2020-04-12 14:35:50', 37, '10.128.40.1_PRD1_PRD1_SF_RDB', NULL, '10.128.40.1', '', '网关', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000018', NULL, '0031_0000000018', 'umadmin', '2020-04-15 11:08:44', 'umadmin', '2020-04-12 14:37:08', 37, '10.128.40.2_PRD1_PRD1_SF_RDB', NULL, '10.128.40.2', '', '内网资源', '0023_0000000012', 'created', 'csmysql1使用', ''),
	('0031_0000000019', NULL, '0031_0000000019', 'umadmin', '2020-04-14 16:45:58', 'umadmin', '2020-04-12 14:37:09', 37, '10.128.40.3_PRD1_PRD1_SF_RDB', NULL, '10.128.40.3', '', '内网资源', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000020', NULL, '0031_0000000020', 'umadmin', '2020-04-14 16:45:58', 'umadmin', '2020-04-12 14:37:10', 37, '10.128.40.4_PRD1_PRD1_SF_RDB', NULL, '10.128.40.4', '', '内网资源', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000021', NULL, '0031_0000000021', 'umadmin', '2020-04-14 16:45:59', 'umadmin', '2020-04-12 14:37:10', 37, '10.128.40.5_PRD1_PRD1_SF_RDB', NULL, '10.128.40.5', '', '内网资源', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000022', NULL, '0031_0000000022', 'umadmin', '2020-04-14 16:45:59', 'umadmin', '2020-04-12 14:37:11', 37, '10.128.40.6_PRD1_PRD1_SF_RDB', NULL, '10.128.40.6', '', '内网资源', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000023', NULL, '0031_0000000023', 'umadmin', '2020-04-14 16:45:59', 'umadmin', '2020-04-12 14:37:12', 37, '10.128.40.7_PRD1_PRD1_SF_RDB', NULL, '10.128.40.7', '', '内网资源', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000024', NULL, '0031_0000000024', 'umadmin', '2020-04-14 16:45:59', 'umadmin', '2020-04-12 14:37:13', 37, '10.128.40.8_PRD1_PRD1_SF_RDB', NULL, '10.128.40.8', '', '内网资源', '0023_0000000012', 'created', '使用', ''),
	('0031_0000000025', NULL, '0031_0000000025', 'umadmin', '2020-04-14 16:45:55', 'umadmin', '2020-04-12 14:37:45', 37, '10.128.56.1_PRD1_PRD1_SF_LB', NULL, '10.128.56.1', '', '网关', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000026', NULL, '0031_0000000026', 'umadmin', '2020-04-15 11:19:34', 'umadmin', '2020-04-12 14:39:05', 37, '10.128.56.2_PRD1_PRD1_SF_LB', NULL, '10.128.56.2', '', '内网资源', '0023_0000000014', 'created', 'cslb1使用', ''),
	('0031_0000000027', NULL, '0031_0000000027', 'umadmin', '2020-04-14 16:45:55', 'umadmin', '2020-04-12 14:39:06', 37, '10.128.56.3_PRD1_PRD1_SF_LB', NULL, '10.128.56.3', '', '内网资源', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000028', NULL, '0031_0000000028', 'umadmin', '2020-04-14 16:45:55', 'umadmin', '2020-04-12 14:39:06', 37, '10.128.56.4_PRD1_PRD1_SF_LB', NULL, '10.128.56.4', '', '内网资源', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000029', NULL, '0031_0000000029', 'umadmin', '2020-04-14 16:45:55', 'umadmin', '2020-04-12 14:39:07', 37, '10.128.56.5_PRD1_PRD1_SF_LB', NULL, '10.128.56.5', '', '内网资源', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000030', NULL, '0031_0000000030', 'umadmin', '2020-04-14 16:45:55', 'umadmin', '2020-04-12 14:39:08', 37, '10.128.56.6_PRD1_PRD1_SF_LB', NULL, '10.128.56.6', '', '内网资源', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000031', NULL, '0031_0000000031', 'umadmin', '2020-04-14 16:45:55', 'umadmin', '2020-04-12 14:39:09', 37, '10.128.56.7_PRD1_PRD1_SF_LB', NULL, '10.128.56.7', '', '内网资源', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000032', NULL, '0031_0000000032', 'umadmin', '2020-04-14 16:45:56', 'umadmin', '2020-04-12 14:39:10', 37, '10.128.56.8_PRD1_PRD1_SF_LB', NULL, '10.128.56.8', '', '内网资源', '0023_0000000014', 'created', '使用', ''),
	('0031_0000000033', NULL, '0031_0000000033', 'umadmin', '2020-04-14 16:45:52', 'umadmin', '2020-04-12 14:39:44', 37, '10.128.64.1_PRD2_PRD2_SF_APP', NULL, '10.128.64.1', '', '网关', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000034', NULL, '0031_0000000034', 'umadmin', '2020-04-15 11:18:46', 'umadmin', '2020-04-12 14:41:10', 37, '10.128.64.2_PRD2_PRD2_SF_APP', NULL, '10.128.64.2', '', '内网资源', '0023_0000000015', 'created', 'cstapp2使用', ''),
	('0031_0000000035', NULL, '0031_0000000035', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:11', 37, '10.128.64.3_PRD2_PRD2_SF_APP', NULL, '10.128.64.3', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000036', NULL, '0031_0000000036', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:12', 37, '10.128.64.4_PRD2_PRD2_SF_APP', NULL, '10.128.64.4', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000037', NULL, '0031_0000000037', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:13', 37, '10.128.64.5_PRD2_PRD2_SF_APP', NULL, '10.128.64.5', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000038', NULL, '0031_0000000038', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:14', 37, '10.128.64.6_PRD2_PRD2_SF_APP', NULL, '10.128.64.6', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000039', NULL, '0031_0000000039', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:15', 37, '10.128.64.7_PRD2_PRD2_SF_APP', NULL, '10.128.64.7', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000040', NULL, '0031_0000000040', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:16', 37, '10.128.64.8_PRD2_PRD2_SF_APP', NULL, '10.128.64.8', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000041', NULL, '0031_0000000041', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:17', 37, '10.128.64.9_PRD2_PRD2_SF_APP', NULL, '10.128.64.9', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000042', NULL, '0031_0000000042', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:17', 37, '10.128.64.10_PRD2_PRD2_SF_APP', NULL, '10.128.64.10', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000043', NULL, '0031_0000000043', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:18', 37, '10.128.64.11_PRD2_PRD2_SF_APP', NULL, '10.128.64.11', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000044', NULL, '0031_0000000044', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:19', 37, '10.128.64.12_PRD2_PRD2_SF_APP', NULL, '10.128.64.12', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000045', NULL, '0031_0000000045', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:20', 37, '10.128.64.13_PRD2_PRD2_SF_APP', NULL, '10.128.64.13', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000046', NULL, '0031_0000000046', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:21', 37, '10.128.64.14_PRD2_PRD2_SF_APP', NULL, '10.128.64.14', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000047', NULL, '0031_0000000047', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:22', 37, '10.128.64.15_PRD2_PRD2_SF_APP', NULL, '10.128.64.15', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000048', NULL, '0031_0000000048', 'umadmin', '2020-04-14 16:45:53', 'umadmin', '2020-04-12 14:41:23', 37, '10.128.64.16_PRD2_PRD2_SF_APP', NULL, '10.128.64.16', '', '内网资源', '0023_0000000015', 'created', '使用', ''),
	('0031_0000000049', NULL, '0031_0000000049', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:42:58', 37, '10.128.104.1_PRD2_PRD2_SF_RDB', NULL, '10.128.104.1', '', '网关', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000050', NULL, '0031_0000000050', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:10', 37, '10.128.104.2_PRD2_PRD2_SF_RDB', NULL, '10.128.104.2', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000051', NULL, '0031_0000000051', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:11', 37, '10.128.104.3_PRD2_PRD2_SF_RDB', NULL, '10.128.104.3', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000052', NULL, '0031_0000000052', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:12', 37, '10.128.104.4_PRD2_PRD2_SF_RDB', NULL, '10.128.104.4', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000053', NULL, '0031_0000000053', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:13', 37, '10.128.104.5_PRD2_PRD2_SF_RDB', NULL, '10.128.104.5', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000054', NULL, '0031_0000000054', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:14', 37, '10.128.104.6_PRD2_PRD2_SF_RDB', NULL, '10.128.104.6', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000055', NULL, '0031_0000000055', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:14', 37, '10.128.104.7_PRD2_PRD2_SF_RDB', NULL, '10.128.104.7', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000056', NULL, '0031_0000000056', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 14:53:15', 37, '10.128.104.8_PRD2_PRD2_SF_RDB', NULL, '10.128.104.8', '', '内网资源', '0023_0000000017', 'created', '使用', ''),
	('0031_0000000057', NULL, '0031_0000000057', 'umadmin', '2020-04-14 16:45:24', 'umadmin', '2020-04-12 14:53:45', 37, '10.128.120.1_PRD2_PRD2_SF_LB', NULL, '10.128.120.1', '', '网关', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000058', NULL, '0031_0000000058', 'umadmin', '2020-04-15 11:19:33', 'umadmin', '2020-04-12 14:54:23', 37, '10.128.120.2_PRD2_PRD2_SF_LB', NULL, '10.128.120.2', '', '内网资源', '0023_0000000019', 'created', 'cslb2使用', ''),
	('0031_0000000059', NULL, '0031_0000000059', 'umadmin', '2020-04-14 16:45:24', 'umadmin', '2020-04-12 14:54:24', 37, '10.128.120.3_PRD2_PRD2_SF_LB', NULL, '10.128.120.3', '', '内网资源', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000060', NULL, '0031_0000000060', 'umadmin', '2020-04-14 16:45:24', 'umadmin', '2020-04-12 14:54:25', 37, '10.128.120.4_PRD2_PRD2_SF_LB', NULL, '10.128.120.4', '', '内网资源', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000061', NULL, '0031_0000000061', 'umadmin', '2020-04-14 16:45:25', 'umadmin', '2020-04-12 14:54:26', 37, '10.128.120.5_PRD2_PRD2_SF_LB', NULL, '10.128.120.5', '', '内网资源', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000062', NULL, '0031_0000000062', 'umadmin', '2020-04-14 16:45:25', 'umadmin', '2020-04-12 14:54:26', 37, '10.128.120.6_PRD2_PRD2_SF_LB', NULL, '10.128.120.6', '', '内网资源', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000063', NULL, '0031_0000000063', 'umadmin', '2020-04-14 16:45:25', 'umadmin', '2020-04-12 14:54:27', 37, '10.128.120.7_PRD2_PRD2_SF_LB', NULL, '10.128.120.7', '', '内网资源', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000064', NULL, '0031_0000000064', 'umadmin', '2020-04-14 16:45:25', 'umadmin', '2020-04-12 14:54:28', 37, '10.128.120.8_PRD2_PRD2_SF_LB', NULL, '10.128.120.8', '', '内网资源', '0023_0000000019', 'created', '使用', ''),
	('0031_0000000065', NULL, '0031_0000000065', 'umadmin', '2020-04-14 16:45:21', 'umadmin', '2020-04-12 14:55:09', 37, '10.128.202.1_PRD1_PRD1_MG_APP', NULL, '10.128.202.1', '', '网关', '0023_0000000023', 'created', '使用', ''),
	('0031_0000000066', NULL, '0031_0000000066', 'umadmin', '2020-04-15 11:18:40', 'umadmin', '2020-04-12 14:55:33', 37, '10.128.202.2_PRD1_PRD1_MG_APP', NULL, '10.128.202.2', '', '内网资源', '0023_0000000023', 'created', 'wecubeplugin使用', ''),
	('0031_0000000067', NULL, '0031_0000000067', 'umadmin', '2020-04-15 11:18:39', 'umadmin', '2020-04-12 14:55:33', 37, '10.128.202.3_PRD1_PRD1_MG_APP', NULL, '10.128.202.3', '', '内网资源', '0023_0000000023', 'created', 'wecubecore使用', ''),
	('0031_0000000068', NULL, '0031_0000000068', 'umadmin', '2020-04-14 16:45:21', 'umadmin', '2020-04-12 14:55:34', 37, '10.128.202.4_PRD1_PRD1_MG_APP', NULL, '10.128.202.4', '', '内网资源', '0023_0000000023', 'created', '使用', ''),
	('0031_0000000069', NULL, '0031_0000000069', 'umadmin', '2020-04-14 16:44:45', 'umadmin', '2020-04-12 14:56:16', 37, '10.128.218.1_PRD2_PRD2_MG_APP', NULL, '10.128.218.1', '', '网关', '0023_0000000029', 'created', '使用', ''),
	('0031_0000000070', NULL, '0031_0000000070', 'umadmin', '2020-04-14 16:44:45', 'umadmin', '2020-04-12 14:56:36', 37, '10.128.218.2_PRD2_PRD2_MG_APP', NULL, '10.128.218.2', '', '内网资源', '0023_0000000029', 'created', '使用', ''),
	('0031_0000000071', NULL, '0031_0000000071', 'umadmin', '2020-04-14 16:44:45', 'umadmin', '2020-04-12 14:56:36', 37, '10.128.218.3_PRD2_PRD2_MG_APP', NULL, '10.128.218.3', '', '内网资源', '0023_0000000029', 'created', '使用', ''),
	('0031_0000000072', NULL, '0031_0000000072', 'umadmin', '2020-04-14 16:44:45', 'umadmin', '2020-04-12 14:56:37', 37, '10.128.218.4_PRD2_PRD2_MG_APP', NULL, '10.128.218.4', '', '内网资源', '0023_0000000029', 'created', '使用', ''),
	('0031_0000000073', NULL, '0031_0000000073', 'umadmin', '2020-04-14 16:45:19', 'umadmin', '2020-04-12 14:57:25', 37, '10.128.206.1_PRD1_PRD1_MG_RDB', NULL, '10.128.206.1', '', '网关', '0023_0000000025', 'created', '使用', ''),
	('0031_0000000074', NULL, '0031_0000000074', 'umadmin', '2020-04-15 11:08:41', 'umadmin', '2020-04-12 14:57:46', 37, '10.128.206.2_PRD1_PRD1_MG_RDB', NULL, '10.128.206.2', '', '内网资源', '0023_0000000025', 'created', 'wecubecore使用', ''),
	('0031_0000000075', NULL, '0031_0000000075', 'umadmin', '2020-04-14 16:44:43', 'umadmin', '2020-04-12 14:58:27', 37, '10.128.222.1_PRD2_PRD2_MG_RDB', NULL, '10.128.222.1', '', '网关', '0023_0000000031', 'created', '使用', ''),
	('0031_0000000076', NULL, '0031_0000000076', 'umadmin', '2020-04-14 16:44:43', 'umadmin', '2020-04-12 14:58:38', 37, '10.128.222.2_PRD2_PRD2_MG_RDB', NULL, '10.128.222.2', '', '内网资源', '0023_0000000031', 'created', '使用', ''),
	('0031_0000000077', NULL, '0031_0000000077', 'umadmin', '2020-04-14 16:45:20', 'umadmin', '2020-04-12 14:59:18', 37, '10.128.200.1_PRD1_PRD1_MG_LB', NULL, '10.128.200.1', '', '网关', '0023_0000000022', 'created', '使用', ''),
	('0031_0000000078', NULL, '0031_0000000078', 'umadmin', '2020-04-14 16:45:20', 'umadmin', '2020-04-12 14:59:33', 37, '10.128.200.2_PRD1_PRD1_MG_LB', NULL, '10.128.200.2', '', '内网资源', '0023_0000000022', 'created', '使用', ''),
	('0031_0000000079', NULL, '0031_0000000079', 'umadmin', '2020-04-14 16:44:48', 'umadmin', '2020-04-12 14:59:56', 37, '10.128.216.1_PRD2_PRD2_MG_LB', NULL, '10.128.216.1', '', '网关', '0023_0000000028', 'created', '使用', ''),
	('0031_0000000080', NULL, '0031_0000000080', 'umadmin', '2020-04-14 16:44:48', 'umadmin', '2020-04-12 15:00:04', 37, '10.128.216.2_PRD2_PRD2_MG_LB', NULL, '10.128.216.2', '', '内网资源', '0023_0000000028', 'created', '使用', ''),
	('0031_0000000081', NULL, '0031_0000000081', 'umadmin', '2020-04-14 16:45:57', 'umadmin', '2020-04-13 00:21:29', 37, '10.128.32.1_PRD1_PRD1_SF_CACHE', NULL, '10.128.32.1', '', '网关', '0023_0000000011', 'created', '使用', ''),
	('0031_0000000082', NULL, '0031_0000000082', 'umadmin', '2020-04-15 11:19:17', 'umadmin', '2020-04-13 00:21:58', 37, '10.128.32.2_PRD1_PRD1_SF_CACHE', NULL, '10.128.32.2', '', '内网资源', '0023_0000000011', 'created', 'csredis1使用', ''),
	('0031_0000000083', NULL, '0031_0000000083', 'umadmin', '2020-04-14 16:45:25', 'umadmin', '2020-04-13 00:22:42', 37, '10.128.96.1_PRD2_PRD2_SF_CACHE', NULL, '10.128.96.1', '', '网关', '0023_0000000016', 'created', '使用', ''),
	('0031_0000000084', NULL, '0031_0000000084', 'umadmin', '2020-04-14 16:45:26', 'umadmin', '2020-04-13 00:23:26', 37, '10.128.96.2_PRD2_PRD2_SF_CACHE', NULL, '10.128.96.2', '', '内网资源', '0023_0000000016', 'created', '使用', ''),
	('0031_0000000085', NULL, '0031_0000000085', 'umadmin', '2020-04-14 16:44:43', 'umadmin', '2020-04-13 00:24:09', 37, '10.129.32.2_DR1_DR1_SF_CACHE', NULL, '10.129.32.2', '', '内网资源', '0023_0000000033', 'created', '使用', ''),
	('0031_0000000086', NULL, '0031_0000000086', 'umadmin', '2020-04-14 16:44:43', 'umadmin', '2020-04-13 00:24:10', 37, '10.129.32.1_DR1_DR1_SF_CACHE', NULL, '10.129.32.1', '', '网关', '0023_0000000033', 'created', '使用', ''),
	('0031_0000000087', NULL, '0031_0000000087', 'umadmin', '2020-04-14 16:44:10', 'umadmin', '2020-04-13 09:49:30', 37, '0.0.0.1_PRD_PRD_MG_WNET', NULL, '0.0.0.1', '', '外网NAT', '0023_0000000043', 'created', '使用', ''),
	('0031_0000000089', NULL, '0031_0000000089', 'umadmin', '2020-04-14 16:44:09', 'umadmin', '2020-04-13 19:25:52', 37, '0.0.0.1_DR_DR_MG_WNET', NULL, '0.0.0.1', '', '外网NAT', '0023_0000000045', 'created', '使用', ''),
	('0031_0000000091', NULL, '0031_0000000091', 'umadmin', '2020-04-14 16:44:13', 'umadmin', '2020-04-13 19:27:21', 37, '10.129.202.1_DR1_DR1_MG_APP', NULL, '10.129.202.1', '', '网关', '0023_0000000040', 'created', '使用', ''),
	('0031_0000000092', NULL, '0031_0000000092', 'umadmin', '2020-04-14 16:44:13', 'umadmin', '2020-04-13 19:28:11', 37, '10.129.202.2_DR1_DR1_MG_APP', NULL, '10.129.202.2', '', '内网资源', '0023_0000000040', 'created', '使用', ''),
	('0031_0000000093', NULL, '0031_0000000093', 'umadmin', '2020-04-14 16:44:13', 'umadmin', '2020-04-13 19:28:12', 37, '10.129.202.3_DR1_DR1_MG_APP', NULL, '10.129.202.3', '', '内网资源', '0023_0000000040', 'created', '使用', ''),
	('0031_0000000094', NULL, '0031_0000000094', 'umadmin', '2020-04-14 16:44:13', 'umadmin', '2020-04-13 19:28:13', 37, '10.129.202.4_DR1_DR1_MG_APP', NULL, '10.129.202.4', '', '内网资源', '0023_0000000040', 'created', '使用', ''),
	('0031_0000000095', NULL, '0031_0000000095', 'umadmin', '2020-04-14 16:45:22', 'umadmin', '2020-04-14 01:21:32', 37, '10.128.192.1_PRD1_PRD1_MG_VDI', NULL, '10.128.192.1', '', '网关', '0023_0000000020', 'created', '使用', ''),
	('0031_0000000096', NULL, '0031_0000000096', 'umadmin', '2020-04-14 16:45:22', 'umadmin', '2020-04-14 01:22:22', 37, '10.128.192.2_PRD1_PRD1_MG_VDI', NULL, '10.128.192.2', '', '内网资源', '0023_0000000020', 'created', '使用', ''),
	('0031_0000000097', NULL, '0031_0000000097', 'umadmin', '2020-04-15 11:18:37', 'umadmin', '2020-04-14 01:22:23', 37, '10.128.192.3_PRD1_PRD1_MG_VDI', NULL, '10.128.192.3', '', '内网资源', '0023_0000000020', 'created', 'wecubevdi使用', ''),
	('0031_0000000098', NULL, '0031_0000000098', 'umadmin', '2020-04-14 16:45:22', 'umadmin', '2020-04-14 01:22:24', 37, '10.128.192.4_PRD1_PRD1_MG_VDI', NULL, '10.128.192.4', '', '内网资源', '0023_0000000020', 'created', '使用', ''),
	('0031_0000000099', NULL, '0031_0000000099', 'umadmin', '2020-04-14 16:44:46', 'umadmin', '2020-04-14 01:23:32', 37, '10.128.208.1_PRD2_PRD2_MG_VDI', NULL, '10.128.208.1', '', '网关', '0023_0000000026', 'created', '使用', ''),
	('0031_0000000100', NULL, '0031_0000000100', 'umadmin', '2020-04-14 16:44:46', 'umadmin', '2020-04-14 01:24:20', 37, '10.128.208.2_PRD2_PRD2_MG_VDI', NULL, '10.128.208.2', '', '内网资源', '0023_0000000026', 'created', '使用', ''),
	('0031_0000000101', NULL, '0031_0000000101', 'umadmin', '2020-04-14 16:44:46', 'umadmin', '2020-04-14 01:24:21', 37, '10.128.208.3_PRD2_PRD2_MG_VDI', NULL, '10.128.208.3', '', '内网资源', '0023_0000000026', 'created', '使用', ''),
	('0031_0000000102', NULL, '0031_0000000102', 'umadmin', '2020-04-14 16:44:46', 'umadmin', '2020-04-14 01:24:22', 37, '10.128.208.4_PRD2_PRD2_MG_VDI', NULL, '10.128.208.4', '', '内网资源', '0023_0000000026', 'created', '使用', ''),
	('0031_0000000103', NULL, '0031_0000000103', 'umadmin', '2020-04-14 16:45:23', 'umadmin', '2020-04-14 01:25:12', 37, '10.128.199.1_PRD1_PRD1_MG_PROXY', NULL, '10.128.199.1', '', '网关', '0023_0000000021', 'created', '使用', ''),
	('0031_0000000104', NULL, '0031_0000000104', 'umadmin', '2020-04-15 11:55:25', 'umadmin', '2020-04-14 01:26:19', 37, '10.128.199.2_PRD1_PRD1_MG_PROXY', NULL, '10.128.199.2', '', '内网资源', '0023_0000000021', 'created', '0.0.0.0/0_WAN_ODC_WAN_link_10.128.192.0/19_VPC_PRD_MG使用', ''),
	('0031_0000000105', NULL, '0031_0000000105', 'umadmin', '2020-04-14 16:44:47', 'umadmin', '2020-04-14 01:26:20', 37, '10.128.215.1_PRD2_PRD2_MG_PROXY', NULL, '10.128.215.1', '', '网关', '0023_0000000027', 'created', '使用', ''),
	('0031_0000000106', NULL, '0031_0000000106', 'umadmin', '2020-04-14 16:44:47', 'umadmin', '2020-04-14 01:26:21', 37, '10.128.215.2_PRD2_PRD2_MG_PROXY', NULL, '10.128.215.2', '', '内网资源', '0023_0000000027', 'created', '使用', ''),
	('0031_0000000107', NULL, '0031_0000000107', 'umadmin', '2020-04-15 11:08:40', 'umadmin', '2020-04-14 01:36:10', 37, '10.128.206.3_PRD1_PRD1_MG_RDB', NULL, '10.128.206.3', '', '内网资源', '0023_0000000025', 'created', 'wecubeplugin使用', ''),
	('0031_0000000108', NULL, '0031_0000000108', 'umadmin', '2020-04-14 16:45:19', 'umadmin', '2020-04-14 01:36:11', 37, '10.128.206.4_PRD1_PRD1_MG_RDB', NULL, '10.128.206.4', '', '内网资源', '0023_0000000025', 'created', '使用', ''),
	('0031_0000000109', NULL, '0031_0000000109', 'umadmin', '2020-04-15 11:18:36', 'umadmin', '2020-04-14 11:02:53', 37, '10.128.199.3_PRD1_PRD1_MG_PROXY', NULL, '10.128.199.3', '', '内网资源', '0023_0000000021', 'created', 'wecubesquid使用', ''),
	('0031_0000000110', NULL, '0031_0000000110', 'umadmin', '2020-04-14 16:45:23', 'umadmin', '2020-04-14 11:02:54', 37, '10.128.199.4_PRD1_PRD1_MG_PROXY', NULL, '10.128.199.4', '', '内网资源', '0023_0000000021', 'created', '使用', ''),
	('0031_0000000111', NULL, '0031_0000000111', 'umadmin', '2020-04-14 16:44:11', 'umadmin', '2020-04-14 11:06:52', 37, '10.129.199.1_DR1_DR1_MG_PROXY', NULL, '10.129.199.1', '', '网关', '0023_0000000042', 'created', '使用', ''),
	('0031_0000000112', NULL, '0031_0000000112', 'umadmin', '2020-04-15 11:55:24', 'umadmin', '2020-04-14 11:07:38', 37, '10.129.199.2_DR1_DR1_MG_PROXY', NULL, '10.129.199.2', '', '内网资源', '0023_0000000042', 'created', '0.0.0.0/0_WAN_ODC_WAN_link_10.129.192.0/19_VPC_DR_MG使用', ''),
	('0031_0000000113', NULL, '0031_0000000113', 'umadmin', '2020-04-14 16:44:11', 'umadmin', '2020-04-14 11:07:39', 37, '10.129.199.3_DR1_DR1_MG_PROXY', NULL, '10.129.199.3', '', '内网资源', '0023_0000000042', 'created', '使用', ''),
	('0031_0000000114', NULL, '0031_0000000114', 'umadmin', '2020-04-14 16:44:11', 'umadmin', '2020-04-14 11:07:41', 37, '10.129.199.4_DR1_DR1_MG_PROXY', NULL, '10.129.199.4', '', '内网资源', '0023_0000000042', 'created', '使用', '');
/*!40000 ALTER TABLE `ip_address` ENABLE KEYS */;

/*!40000 ALTER TABLE `lb_instance` DISABLE KEYS */;
INSERT INTO `lb_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `lb_listener_asset_id`, `lb_resource_instance`, `port`, `state_code`, `unit`, `name`) VALUES
	('0053_0000000001', NULL, '0053_0000000001', 'umadmin', '2020-04-15 11:44:55', 'umadmin', '2020-04-13 14:22:29', 37, 'PRD_UM_SSO_LB_10.128.56.2:umsso', NULL, 'umsso_10.128.56.2:991', '', '', '0035_0000000001', '991', 'created', '0048_0000000005', 'umsso'),
	('0053_0000000002', NULL, '0053_0000000002', 'umadmin', '2020-04-15 11:44:55', 'umadmin', '2020-04-13 14:22:48', 37, 'PRD_UM_CORE_LB_10.128.56.2:umcore', NULL, 'umcore_10.128.56.2:991', '', '', '0035_0000000001', '991', 'created', '0048_0000000003', 'umcore'),
	('0053_0000000003', NULL, '0053_0000000003', 'umadmin', '2020-04-15 11:44:55', 'umadmin', '2020-04-13 15:41:27', 37, 'PRD_WEMQ_ADM_LB_10.128.56.2:wemqadm', NULL, 'wemqadm_10.128.56.2:991', '', '', '0035_0000000001', '991', 'created', '0048_0000000017', 'wemqadm'),
	('0053_0000000004', NULL, '0053_0000000004', 'umadmin', '2020-04-15 11:44:54', 'umadmin', '2020-04-13 15:48:59', 37, 'PRD_RMB_SGS_LB_10.128.56.2:rmbsgs', NULL, 'rmbsgs_10.128.56.2:991', '', '', '0035_0000000001', '991', 'created', '0048_0000000019', 'rmbsgs');
/*!40000 ALTER TABLE `lb_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `lb_resource_instance` DISABLE KEYS */;
INSERT INTO `lb_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `end_date`, `ip_address`, `master_resource_instance`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_type`, `resource_set`, `state_code`, `unit_type`) VALUES
	('0035_0000000001', NULL, '0035_0000000001', 'umadmin', '2020-04-15 11:19:35', 'umadmin', '2020-04-13 00:00:57', 37, 'PRD1_SF_LB_cslb1', NULL, 'cslb1_10.128.56.2', '', '', '', '0063_0000000002', '0008_0000000003', '', '0031_0000000026', '', '10.128.56.2:80', '80', 'cslb1', '0009_0000000003', '0029_0000000008', 'created', '0002_0000000004'),
	('0035_0000000002', NULL, '0035_0000000002', 'umadmin', '2020-04-15 11:19:33', 'umadmin', '2020-04-13 00:03:22', 37, 'PRD2_SF_LB_cslb2', NULL, 'cslb2_10.128.120.2', '', '', '', '0063_0000000002', '0008_0000000003', '', '0031_0000000058', '', '10.128.120.2:80', '80', 'cslb2', '0009_0000000003', '0029_0000000008', 'created', '0002_0000000004');
/*!40000 ALTER TABLE `lb_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `legal_person` DISABLE KEYS */;
INSERT INTO `legal_person` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0004_0000000001', NULL, '0004_0000000001', 'umadmin', '2020-04-11 21:55:18', 'umadmin', '2020-04-11 21:55:18', 34, 'DEMO法人', NULL, 'DEMO', 'DEMO法人', 'DEMO法人', 'new');
/*!40000 ALTER TABLE `legal_person` ENABLE KEYS */;

/*!40000 ALTER TABLE `manage_role` DISABLE KEYS */;
INSERT INTO `manage_role` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `email`, `name`, `phone`, `state_code`) VALUES
	('0001_0000000001', NULL, '0001_0000000001', 'umadmin', '2020-04-11 21:54:11', 'umadmin', '2020-04-11 21:54:11', 34, '超级管理员', NULL, 'SUPER_ADMIN', '超级管理员', 'demo@demo.com', '超级管理员', '15800000000', 'new');
/*!40000 ALTER TABLE `manage_role` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_link` DISABLE KEYS */;
INSERT INTO `network_link` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `max_concurrent`, `netband_width`, `network_segment_1`, `network_segment_2`, `network_link_design`, `network_link_type`, `state_code`, `ip_address`, `name`) VALUES
	('0026_0000000001', NULL, '0026_0000000001', 'umadmin', '2020-04-14 16:46:06', 'umadmin', '2020-04-12 13:17:50', 37, '10.128.192.0/19_VPC_PRD_MG_link_10.128.0.0/17_VPC_PRD_SF', NULL, 'PRD_MG_link_PRD_SF', '', '', '10000', '1000', '0023_0000000008', '0023_0000000009', '0016_0000000003', '0054_0000000001', 'created', NULL, '对等连接1'),
	('0026_0000000002', NULL, '0026_0000000002', 'umadmin', '2020-04-14 16:46:07', 'umadmin', '2020-04-12 14:06:39', 37, '10.129.192.0/19_VPC_DR_MG_link_10.129.0.0/17_VPC_DR_SF', NULL, 'DR_MG_link_DR_SF', '', '', '10000', '1000', '0023_0000000006', '0023_0000000007', '0016_0000000003', '0054_0000000001', 'created', NULL, '对等连接2'),
	('0026_0000000003', NULL, '0026_0000000003', 'umadmin', '2020-04-14 16:46:06', 'umadmin', '2020-04-12 14:09:10', 37, '10.129.0.0/17_VPC_DR_SF_link_10.128.0.0/17_VPC_PRD_SF', NULL, 'DR_SF_link_PRD_SF', '', '', '10000', '1000', '0023_0000000007', '0023_0000000009', '0016_0000000009', '0054_0000000001', 'created', NULL, '对等连接3'),
	('0026_0000000004', NULL, '0026_0000000004', 'umadmin', '2020-04-14 16:46:07', 'umadmin', '2020-04-12 14:09:34', 37, '10.128.192.0/19_VPC_PRD_MG_link_10.129.192.0/19_VPC_DR_MG', NULL, 'PRD_MG_link_DR_MG', '', '', '10000', '1000', '0023_0000000008', '0023_0000000006', '0016_0000000010', '0054_0000000001', 'created', NULL, '对等连接4'),
	('0026_0000000005', NULL, '0026_0000000005', 'umadmin', '2020-04-15 11:55:25', 'umadmin', '2020-04-13 18:45:50', 37, '0.0.0.0/0__WAN__NDC_WAN_link_10.128.192.0/19__VPC__PRD_MG', NULL, 'NDC_WAN_link_PRD_MG', '', '', '1000', '10', '0023_0000000044', '0023_0000000008', '0016_0000000011', '0054_0000000002', 'created', '0031_0000000104', 'NAT连接'),
	('0026_0000000006', NULL, '0026_0000000006', 'umadmin', '2020-04-15 11:55:25', 'umadmin', '2020-04-13 18:53:13', 37, '0.0.0.0/0__WAN__NDC_WAN_link_10.129.192.0/19__VPC__DR_MG', NULL, 'NDC_WAN_link_DR_MG', '', '', '1000', '10', '0023_0000000044', '0023_0000000006', '0016_0000000011', '0054_0000000002', 'created', '0031_0000000112', 'NAT连接');
/*!40000 ALTER TABLE `network_link` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_link$internet_ip` DISABLE KEYS */;
INSERT INTO `network_link$internet_ip` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(13, '0026_0000000006', '0031_0000000089', 1),
	(14, '0026_0000000005', '0031_0000000087', 1);
/*!40000 ALTER TABLE `network_link$internet_ip` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_link_design` DISABLE KEYS */;
INSERT INTO `network_link_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `network_segment_design_1`, `network_segment_design_2`, `network_link_type`, `state_code`) VALUES
	('0016_0000000001', NULL, '0016_0000000001', 'umadmin', '2020-04-14 16:31:27', 'umadmin', '2020-04-12 02:25:41', 34, 'PCD_DMZ_link_PCD_SF', NULL, 'PCD_DMZ-link-PCD_SF', '', '0013_0000000003', '0013_0000000002', 'PEERCONNECTION', 'new'),
	('0016_0000000002', NULL, '0016_0000000002', 'umadmin', '2020-04-14 16:31:27', 'umadmin', '2020-04-12 02:26:51', 34, 'PCD_ECN_link_PCD_SF', NULL, 'PCD_ECN-link-PCD_SF', '', '0013_0000000004', '0013_0000000002', 'PEERCONNECTION', 'new'),
	('0016_0000000003', NULL, '0016_0000000003', 'umadmin', '2020-04-14 16:31:27', 'umadmin', '2020-04-12 02:26:51', 34, 'PCD_MG_link_PCD_SF', NULL, 'PCD_MG-link-PCD_SF', '', '0013_0000000005', '0013_0000000002', 'PEERCONNECTION', 'new'),
	('0016_0000000004', NULL, '0016_0000000004', 'umadmin', '2020-04-14 16:31:22', 'umadmin', '2020-04-12 02:26:51', 34, 'PCD_MG_link_PCD_ECN', NULL, 'PCD_MG-link-PCD_ECN', '', '0013_0000000005', '0013_0000000004', 'PEERCONNECTION', 'new'),
	('0016_0000000005', NULL, '0016_0000000005', 'umadmin', '2020-04-14 16:31:24', 'umadmin', '2020-04-12 02:26:51', 34, 'PCD_DMZ_link_PCD_MG', NULL, 'PCD_DMZ-link-PCD_MG', '', '0013_0000000003', '0013_0000000005', 'PEERCONNECTION', 'new'),
	('0016_0000000006', NULL, '0016_0000000006', 'umadmin', '2020-04-14 16:32:01', 'umadmin', '2020-04-12 02:26:52', 34, 'PDC_WAN_link_PCD_DMZ', NULL, 'PDC_WAN-link-PCD_DMZ', '', '0013_0000000021', '0013_0000000003', 'PEERCONNECTION', 'new'),
	('0016_0000000007', NULL, '0016_0000000007', 'umadmin', '2020-04-14 16:32:00', 'umadmin', '2020-04-12 02:26:52', 34, 'PDC_PTN_link_PCD_ECN', NULL, 'PDC_PTN-link-PCD_ECN', '', '0013_0000000022', '0013_0000000004', 'PEERCONNECTION', 'new'),
	('0016_0000000008', NULL, '0016_0000000008', 'umadmin', '2020-04-14 16:31:59', 'umadmin', '2020-04-12 02:26:52', 34, 'PDC_OPN_link_PCD_MG', NULL, 'PDC_OPN-link-PCD_MG', '', '0013_0000000023', '0013_0000000005', 'PEERCONNECTION', 'new'),
	('0016_0000000009', NULL, '0016_0000000009', 'umadmin', '2020-04-14 16:31:27', 'umadmin', '2020-04-12 14:08:11', 34, 'PCD_SF_link_PCD_SF', NULL, 'PCD_SF-link-PCD_SF', '', '0013_0000000002', '0013_0000000002', 'PEERCONNECTION', 'new'),
	('0016_0000000010', NULL, '0016_0000000010', 'umadmin', '2020-04-14 16:31:19', 'umadmin', '2020-04-12 14:08:27', 34, 'PCD_MG_link_PCD_MG', NULL, 'PCD_MG-link-PCD_MG', '', '0013_0000000005', '0013_0000000005', 'PEERCONNECTION', 'new'),
	('0016_0000000011', NULL, '0016_0000000011', 'umadmin', '2020-04-14 16:32:01', 'umadmin', '2020-04-13 10:49:39', 34, 'PDC_WAN_link_PCD_MG', NULL, 'PDC_WAN-link-PCD_MG', '', '0013_0000000021', '0013_0000000005', 'NAT', 'new');
/*!40000 ALTER TABLE `network_link_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_link_type` DISABLE KEYS */;
INSERT INTO `network_link_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `cloud_vendor`) VALUES
	('0054_0000000001', NULL, '0054_0000000001', 'umadmin', '2020-04-12 13:17:19', 'umadmin', '2020-04-12 13:16:06', 34, '华为云对等连接', NULL, 'peering', '', '对等连接', 'new', '0006_0000000001'),
	('0054_0000000002', NULL, '0054_0000000002', 'umadmin', '2020-04-12 19:02:43', 'umadmin', '2020-04-12 19:02:43', 34, '华为云NAT网关', NULL, 'nat', '', 'NAT网关', 'new', '0006_0000000001');
/*!40000 ALTER TABLE `network_link_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_segment` DISABLE KEYS */;
INSERT INTO `network_segment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center`, `f_network_segment`, `gateway_ip`, `mask`, `name`, `network_segment_design`, `network_segment_usage`, `route_table_asset_id`, `state_code`, `subnet_asset_id`, `vpc_asset_id`, `private_route_table`, `security_group_asset_id`, `private_nat`, `nat_rule_asset_id`) VALUES
	('0023_0000000001', NULL, '0023_0000000001', 'umadmin', '2020-04-14 16:47:06', 'umadmin', '2020-04-12 03:57:49', 37, '10.128.0.0/16__RDC__RDC', NULL, '10.128.0.0/16', '', '0022_0000000001', '', '', '0', 'RDC', '0013_0000000001', 'RDC', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000005', NULL, '0023_0000000005', 'umadmin', '2020-04-14 16:47:05', 'umadmin', '2020-04-12 03:59:08', 37, '10.129.0.0/16__RDC__RDC', NULL, '10.129.0.0/16', '', '0022_0000000002', '', '', '0', 'RDC', '0013_0000000001', 'RDC', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000006', NULL, '0023_0000000006', 'umadmin', '2020-04-14 16:46:07', 'umadmin', '2020-04-12 04:10:27', 37, '10.129.192.0/19__VPC__DR_MG', NULL, '10.129.192.0/19', '', '0022_0000000002', '0023_0000000005', '', '19', 'DR_MG', '0013_0000000005', 'VPC', '', 'created', '', '', 'Y', '', 'N', ''),
	('0023_0000000007', NULL, '0023_0000000007', 'umadmin', '2020-04-14 16:46:03', 'umadmin', '2020-04-12 04:10:28', 37, '10.129.0.0/17__VPC__DR_SF', NULL, '10.129.0.0/17', '', '0022_0000000002', '0023_0000000005', '', '17', 'DR_SF', '0013_0000000002', 'VPC', '', 'created', '', '', 'Y', '', 'N', ''),
	('0023_0000000008', NULL, '0023_0000000008', 'umadmin', '2020-04-14 16:46:04', 'umadmin', '2020-04-12 04:10:28', 37, '10.128.192.0/19__VPC__PRD_MG', NULL, '10.128.192.0/19', '', '0022_0000000001', '0023_0000000001', '', '19', 'PRD_MG', '0013_0000000005', 'VPC', '', 'created', '', '', 'Y', '', 'N', ''),
	('0023_0000000009', NULL, '0023_0000000009', 'umadmin', '2020-04-14 16:46:06', 'umadmin', '2020-04-12 04:10:28', 37, '10.128.0.0/17__VPC__PRD_SF', NULL, '10.128.0.0/17', '', '0022_0000000001', '0023_0000000001', '', '17', 'PRD_SF', '0013_0000000002', 'VPC', '', 'created', '', '', 'Y', '', 'N', ''),
	('0023_0000000010', NULL, '0023_0000000010', 'umadmin', '2020-04-14 16:46:02', 'umadmin', '2020-04-12 12:08:13', 37, '10.128.0.0/22__SUBNET__PRD1_SF_APP', NULL, '10.128.0.0/22', '', '0022_0000000003', '0023_0000000009', '', '22', 'PRD1_SF_APP', '0013_0000000006', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000011', NULL, '0023_0000000011', 'umadmin', '2020-04-14 16:45:57', 'umadmin', '2020-04-12 12:08:14', 37, '10.128.32.0/24__SUBNET__PRD1_SF_CACHE', NULL, '10.128.32.0/24', '', '0022_0000000003', '0023_0000000009', '', '24', 'PRD1_SF_CACHE', '0013_0000000007', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000012', NULL, '0023_0000000012', 'umadmin', '2020-04-14 16:45:59', 'umadmin', '2020-04-12 12:08:14', 37, '10.128.40.0/24__SUBNET__PRD1_SF_RDB', NULL, '10.128.40.0/24', '', '0022_0000000003', '0023_0000000009', '', '24', 'PRD1_SF_RDB', '0013_0000000008', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000013', NULL, '0023_0000000013', 'umadmin', '2020-04-14 16:46:00', 'umadmin', '2020-04-12 12:08:14', 37, '10.128.48.0/24__SUBNET__PRD1_SF_BDP', NULL, '10.128.48.0/24', '', '0022_0000000003', '0023_0000000009', '', '24', 'PRD1_SF_BDP', '0013_0000000009', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000014', NULL, '0023_0000000014', 'umadmin', '2020-04-14 16:45:56', 'umadmin', '2020-04-12 12:08:15', 37, '10.128.56.0/24__SUBNET__PRD1_SF_LB', NULL, '10.128.56.0/24', '', '0022_0000000003', '0023_0000000009', '', '24', 'PRD1_SF_LB', '0013_0000000010', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000015', NULL, '0023_0000000015', 'umadmin', '2020-04-14 16:45:54', 'umadmin', '2020-04-12 12:11:49', 37, '10.128.64.0/22__SUBNET__PRD2_SF_APP', NULL, '10.128.64.0/22', '', '0022_0000000005', '0023_0000000009', '', '22', 'PRD2_SF_APP', '0013_0000000006', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000016', NULL, '0023_0000000016', 'umadmin', '2020-04-14 16:45:26', 'umadmin', '2020-04-12 12:11:50', 37, '10.128.96.0/24__SUBNET__PRD2_SF_CACHE', NULL, '10.128.96.0/24', '', '0022_0000000005', '0023_0000000009', '', '24', 'PRD2_SF_CACHE', '0013_0000000007', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000017', NULL, '0023_0000000017', 'umadmin', '2020-04-14 16:45:27', 'umadmin', '2020-04-12 12:11:50', 37, '10.128.104.0/24__SUBNET__PRD2_SF_RDB', NULL, '10.128.104.0/24', '', '0022_0000000005', '0023_0000000009', '', '24', 'PRD2_SF_RDB', '0013_0000000008', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000018', NULL, '0023_0000000018', 'umadmin', '2020-04-14 16:45:28', 'umadmin', '2020-04-12 12:11:50', 37, '10.128.112.0/24__SUBNET__PRD2_SF_BDP', NULL, '10.128.112.0/24', '', '0022_0000000005', '0023_0000000009', '', '24', 'PRD2_SF_BDP', '0013_0000000009', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000019', NULL, '0023_0000000019', 'umadmin', '2020-04-14 16:45:25', 'umadmin', '2020-04-12 12:11:51', 37, '10.128.120.0/24__SUBNET__PRD2_SF_LB', NULL, '10.128.120.0/24', '', '0022_0000000005', '0023_0000000009', '', '24', 'PRD2_SF_LB', '0013_0000000010', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000020', NULL, '0023_0000000020', 'umadmin', '2020-04-14 16:45:22', 'umadmin', '2020-04-12 12:25:33', 37, '10.128.192.0/24__SUBNET__PRD1_MG_VDI', NULL, '10.128.192.0/24', '', '0022_0000000003', '0023_0000000008', '', '24', 'PRD1_MG_VDI', '0013_0000000020', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000021', NULL, '0023_0000000021', 'umadmin', '2020-04-15 00:48:50', 'umadmin', '2020-04-12 12:25:33', 37, '10.128.199.0/24__SUBNET__PRD1_MG_PROXY', NULL, '10.128.199.0/24', '', '0022_0000000003', '0023_0000000008', '', '24', 'PRD1_MG_PROXY', '0013_0000000024', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000022', NULL, '0023_0000000022', 'umadmin', '2020-04-14 16:45:20', 'umadmin', '2020-04-12 12:25:34', 37, '10.128.200.0/24__SUBNET__PRD1_MG_LB', NULL, '10.128.200.0/24', '', '0022_0000000003', '0023_0000000008', '', '24', 'PRD1_MG_LB', '0013_0000000019', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000023', NULL, '0023_0000000023', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 12:25:34', 37, '10.128.202.0/24__SUBNET__PRD1_MG_APP', NULL, '10.128.202.0/24', '', '0022_0000000003', '0023_0000000008', '', '24', 'PRD1_MG_APP', '0013_0000000018', 'SUBNET', '', 'created', '', '', 'N', '', 'Y', ''),
	('0023_0000000024', NULL, '0023_0000000024', 'umadmin', '2020-04-14 16:45:18', 'umadmin', '2020-04-12 12:25:35', 37, '10.128.204.0/24__SUBNET__PRD1_MG_CACHE', NULL, '10.128.204.0/24', '', '0022_0000000003', '0023_0000000008', '', '24', 'PRD1_MG_CACHE', '0013_0000000017', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000025', NULL, '0023_0000000025', 'umadmin', '2020-04-14 16:45:19', 'umadmin', '2020-04-12 12:25:35', 37, '10.128.206.0/24__SUBNET__PRD1_MG_RDB', NULL, '10.128.206.0/24', '', '0022_0000000003', '0023_0000000008', '', '24', 'PRD1_MG_RDB', '0013_0000000016', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000026', NULL, '0023_0000000026', 'umadmin', '2020-04-14 16:44:47', 'umadmin', '2020-04-12 12:29:37', 37, '10.128.208.0/24__SUBNET__PRD2_MG_VDI', NULL, '10.128.208.0/24', '', '0022_0000000005', '0023_0000000008', '', '24', 'PRD2_MG_VDI', '0013_0000000020', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000027', NULL, '0023_0000000027', 'umadmin', '2020-04-15 00:48:50', 'umadmin', '2020-04-12 12:29:37', 37, '10.128.215.0/24__SUBNET__PRD2_MG_PROXY', NULL, '10.128.215.0/24', '', '0022_0000000005', '0023_0000000008', '', '24', 'PRD2_MG_PROXY', '0013_0000000024', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000028', NULL, '0023_0000000028', 'umadmin', '2020-04-14 16:44:48', 'umadmin', '2020-04-12 12:29:37', 37, '10.128.216.0/24__SUBNET__PRD2_MG_LB', NULL, '10.128.216.0/24', '', '0022_0000000005', '0023_0000000008', '', '24', 'PRD2_MG_LB', '0013_0000000019', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000029', NULL, '0023_0000000029', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 12:29:38', 37, '10.128.218.0/24__SUBNET__PRD2_MG_APP', NULL, '10.128.218.0/24', '', '0022_0000000005', '0023_0000000008', '', '24', 'PRD2_MG_APP', '0013_0000000018', 'SUBNET', '', 'created', '', '', 'N', '', 'Y', ''),
	('0023_0000000030', NULL, '0023_0000000030', 'umadmin', '2020-04-14 16:44:45', 'umadmin', '2020-04-12 12:29:38', 37, '10.128.220.0/24__SUBNET__PRD2_MG_CACHE', NULL, '10.128.220.0/24', '', '0022_0000000005', '0023_0000000008', '', '24', 'PRD2_MG_CACHE', '0013_0000000017', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000031', NULL, '0023_0000000031', 'umadmin', '2020-04-14 16:44:44', 'umadmin', '2020-04-12 12:29:39', 37, '10.128.222.0/24__SUBNET__PRD2_MG_RDB', NULL, '10.128.222.0/24', '', '0022_0000000005', '0023_0000000008', '', '24', 'PRD2_MG_RDB', '0013_0000000016', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000032', NULL, '0023_0000000032', 'umadmin', '2020-04-14 16:44:42', 'umadmin', '2020-04-12 12:47:37', 37, '10.129.56.0/24__SUBNET__DR1_SF_LB', NULL, '10.129.56.0/24', '', '0022_0000000004', '0023_0000000007', '', '24', 'DR1_SF_LB', '0013_0000000010', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000033', NULL, '0023_0000000033', 'umadmin', '2020-04-14 16:44:43', 'umadmin', '2020-04-12 12:47:37', 37, '10.129.32.0/24__SUBNET__DR1_SF_CACHE', NULL, '10.129.32.0/24', '', '0022_0000000004', '0023_0000000007', '', '24', 'DR1_SF_CACHE', '0013_0000000007', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000034', NULL, '0023_0000000034', 'umadmin', '2020-04-14 16:44:41', 'umadmin', '2020-04-12 12:47:38', 37, '10.129.40.0/24__SUBNET__DR1_SF_RDB', NULL, '10.129.40.0/24', '', '0022_0000000004', '0023_0000000007', '', '24', 'DR1_SF_RDB', '0013_0000000008', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000035', NULL, '0023_0000000035', 'umadmin', '2020-04-14 16:44:42', 'umadmin', '2020-04-12 12:47:38', 37, '10.129.48.0/24__SUBNET__DR1_SF_BDP', NULL, '10.129.48.0/24', '', '0022_0000000004', '0023_0000000007', '', '24', 'DR1_SF_BDP', '0013_0000000009', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000036', NULL, '0023_0000000036', 'umadmin', '2020-04-14 16:44:16', 'umadmin', '2020-04-12 12:47:39', 37, '10.129.0.0/22__SUBNET__DR1_SF_APP', NULL, '10.129.0.0/22', '', '0022_0000000004', '0023_0000000007', '', '22', 'DR1_SF_APP', '0013_0000000006', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000037', NULL, '0023_0000000037', 'umadmin', '2020-04-14 16:44:14', 'umadmin', '2020-04-12 12:49:27', 37, '10.129.204.0/24__SUBNET__DR1_MG_CACHE', NULL, '10.129.204.0/24', '', '0022_0000000004', '0023_0000000006', '', '24', 'DR1_MG_CACHE', '0013_0000000017', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000038', NULL, '0023_0000000038', 'umadmin', '2020-04-14 16:44:15', 'umadmin', '2020-04-12 12:49:27', 37, '10.129.206.0/24__SUBNET__DR1_MG_RDB', NULL, '10.129.206.0/24', '', '0022_0000000004', '0023_0000000006', '', '24', 'DR1_MG_RDB', '0013_0000000016', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000039', NULL, '0023_0000000039', 'umadmin', '2020-04-14 16:44:12', 'umadmin', '2020-04-12 12:49:28', 37, '10.129.200.0/24__SUBNET__DR1_MG_LB', NULL, '10.129.200.0/24', '', '0022_0000000004', '0023_0000000006', '', '24', 'DR1_MG_LB', '0013_0000000019', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000040', NULL, '0023_0000000040', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 12:49:28', 37, '10.129.202.0/24__SUBNET__DR1_MG_APP', NULL, '10.129.202.0/24', '', '0022_0000000004', '0023_0000000006', '', '24', 'DR1_MG_APP', '0013_0000000018', 'SUBNET', '', 'created', '', '', 'N', '', 'Y', ''),
	('0023_0000000041', NULL, '0023_0000000041', 'umadmin', '2020-04-14 16:44:14', 'umadmin', '2020-04-12 12:49:28', 37, '10.129.192.0/24__SUBNET__DR1_MG_VDI', NULL, '10.129.192.0/24', '', '0022_0000000004', '0023_0000000006', '', '24', 'DR1_MG_VDI', '0013_0000000020', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000042', NULL, '0023_0000000042', 'umadmin', '2020-04-15 00:48:50', 'umadmin', '2020-04-12 12:49:29', 37, '10.129.199.0/24__SUBNET__DR1_MG_PROXY', NULL, '10.129.199.0/24', '', '0022_0000000004', '0023_0000000006', '', '24', 'DR1_MG_PROXY', '0013_0000000024', 'SUBNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000043', NULL, '0023_0000000043', 'umadmin', '2020-04-14 16:44:10', 'umadmin', '2020-04-12 20:15:12', 37, '0.0.0.0/0__WNET__PRD_MG_WNET', NULL, '0.0.0.0/0', '', '0022_0000000001', '0023_0000000008', '', '0', 'PRD_MG_WNET', '0013_0000000026', 'WNET', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000044', NULL, '0023_0000000044', 'umadmin', '2020-04-14 16:44:10', 'umadmin', '2020-04-13 09:54:17', 37, '0.0.0.0/0__WAN__NDC_WAN', NULL, '0.0.0.0/0', '', '0022_0000000006', '', '', '0', 'NDC_WAN', '0013_0000000021', 'WAN', '', 'created', '', '', 'N', '', 'N', ''),
	('0023_0000000045', NULL, '0023_0000000045', 'umadmin', '2020-04-14 16:44:09', 'umadmin', '2020-04-13 19:25:18', 37, '0.0.0.0/0__WNET__DR_MG_WNET', NULL, '0.0.0.0/0', '', '0022_0000000002', '0023_0000000006', '', '0', 'DR_MG_WNET', '0013_0000000026', 'WNET', '', 'created', '', '', 'N', '', 'N', '');
/*!40000 ALTER TABLE `network_segment` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_segment_design` DISABLE KEYS */;
INSERT INTO `network_segment_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center_design`, `f_network_segment_design`, `mask`, `name`, `network_segment_usage`, `state_code`, `private_route_table`, `private_nat`) VALUES
	('0013_0000000001', NULL, '0013_0000000001', 'umadmin', '2020-04-14 16:31:28', 'umadmin', '2020-04-12 00:02:38', 34, 'X .*.*.*/0__RDC__PCD', NULL, 'X .*.*.*/0', '云数据中心网段', '0012_0000000001', '', '0', 'PCD', 'RDC', 'new', 'N', 'N'),
	('0013_0000000002', NULL, '0013_0000000002', 'umadmin', '2020-04-14 16:31:27', 'umadmin', '2020-04-12 00:14:41', 34, 'X.*.0.0/17__VPC__PCD_SF', NULL, 'X.*.0.0/17', 'SF网段', '0012_0000000001', '0013_0000000001', '17', 'PCD_SF', 'VPC', 'new', 'Y', 'N'),
	('0013_0000000003', NULL, '0013_0000000003', 'umadmin', '2020-04-14 16:31:25', 'umadmin', '2020-04-12 00:18:08', 34, 'X.*.128.0/19__VPC__PCD_DMZ', NULL, 'X.*.128.0/19', 'DMZ网段', '0012_0000000001', '0013_0000000001', '19', 'PCD_DMZ', 'VPC', 'new', 'Y', 'N'),
	('0013_0000000004', NULL, '0013_0000000004', 'umadmin', '2020-04-14 16:31:23', 'umadmin', '2020-04-12 00:21:28', 34, 'X.*.160.0/19__VPC__PCD_ECN', NULL, 'X.*.160.0/19', 'ECN网段', '0012_0000000001', '0013_0000000001', '19', 'PCD_ECN', 'VPC', 'new', 'Y', 'N'),
	('0013_0000000005', NULL, '0013_0000000005', 'umadmin', '2020-04-14 16:31:20', 'umadmin', '2020-04-12 00:22:30', 34, 'X.*.192.0/19__VPC__PCD_MG', NULL, 'X.*.192.0/19', 'MG网段', '0012_0000000001', '0013_0000000001', '19', 'PCD_MG', 'VPC', 'new', 'Y', 'N'),
	('0013_0000000006', NULL, '0013_0000000006', 'umadmin', '2020-04-14 16:31:16', 'umadmin', '2020-04-12 00:30:28', 34, 'X.*.[0-31,64-95].0/22__SUBNET__PCD_SF_APP', NULL, 'X.*.[0-31,64-95].0/22', 'APP网段', '0012_0000000001', '0013_0000000002', '22', 'PCD_SF_APP', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000007', NULL, '0013_0000000007', 'umadmin', '2020-04-14 16:31:45', 'umadmin', '2020-04-12 00:33:35', 34, 'X.*.[32-39,96-103].0/24__SUBNET__PCD_SF_CACHE', NULL, 'X.*.[32-39,96-103].0/24', 'CACHE网段', '0012_0000000001', '0013_0000000002', '24', 'PCD_SF_CACHE', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000008', NULL, '0013_0000000008', 'umadmin', '2020-04-14 16:31:44', 'umadmin', '2020-04-12 00:34:58', 34, 'X.*.[40-47,104-111].0/24__SUBNET__PCD_SF_RDB', NULL, 'X.*.[40-47,104-111].0/24', 'RDB网段', '0012_0000000001', '0013_0000000002', '24', 'PCD_SF_RDB', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000009', NULL, '0013_0000000009', 'umadmin', '2020-04-14 16:31:44', 'umadmin', '2020-04-12 00:36:53', 34, 'X.*.[48-55,112-119].0/24__SUBNET__PCD_SF_BDP', NULL, 'X.*.[48-55,112-119].0/24', 'BDP网段', '0012_0000000001', '0013_0000000002', '24', 'PCD_SF_BDP', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000010', NULL, '0013_0000000010', 'umadmin', '2020-04-14 16:31:43', 'umadmin', '2020-04-12 00:38:10', 34, 'X.*.[56-63,120-127].0/24__SUBNET__PCD_SF_LB', NULL, 'X.*.[56-63,120-127].0/24', 'LB网段', '0012_0000000001', '0013_0000000002', '24', 'PCD_SF_LB', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000011', NULL, '0013_0000000011', 'umadmin', '2020-04-14 16:31:42', 'umadmin', '2020-04-12 00:43:26', 34, 'X.*.[128-131,144-147].0/24__SUBNET__PCD_DMZ_LB', NULL, 'X.*.[128-131,144-147].0/24', 'LB网段', '0012_0000000001', '0013_0000000003', '24', 'PCD_DMZ_LB', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000012', NULL, '0013_0000000012', 'umadmin', '2020-04-14 16:31:42', 'umadmin', '2020-04-12 00:48:20', 34, 'X.*.[132-135,148-151].0/24__SUBNET__PCD_DMZ_FPY', NULL, 'X.*.[132-135,148-151].0/24', 'FPY网段', '0012_0000000001', '0013_0000000003', '24', 'PCD_DMZ_FPY', 'SUBNET', 'new', 'N', 'Y'),
	('0013_0000000013', NULL, '0013_0000000013', 'umadmin', '2020-04-14 16:31:41', 'umadmin', '2020-04-12 00:51:03', 34, 'X.*.[136-139,152-155].0/24__SUBNET__PCD_DMZ_RPY', NULL, 'X.*.[136-139,152-155].0/24', 'RPY网段', '0012_0000000001', '0013_0000000003', '24', 'PCD_DMZ_RPY', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000014', NULL, '0013_0000000014', 'umadmin', '2020-04-14 16:31:40', 'umadmin', '2020-04-12 01:45:30', 34, 'X.*.[164-167,180-183].0/24__SUBNET__PCD_ECN_FRONT', NULL, 'X.*.[164-167,180-183].0/24', 'FRONT网段', '0012_0000000001', '0013_0000000004', '24', 'PCD_ECN_FRONT', 'SUBNET', 'new', 'N', 'Y'),
	('0013_0000000015', NULL, '0013_0000000015', 'umadmin', '2020-04-14 16:31:41', 'umadmin', '2020-04-12 01:45:30', 34, 'X.*.[160-163,176-179].0/24__SUBNET__PCD_ECN_LB', NULL, 'X.*.[160-163,176-179].0/24', 'LB网段', '0012_0000000001', '0013_0000000004', '24', 'PCD_ECN_LB', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000016', NULL, '0013_0000000016', 'umadmin', '2020-04-14 16:32:03', 'umadmin', '2020-04-12 01:56:05', 34, 'X.*.[206-207,222-223].0/24__SUBNET__PCD_MG_RDB', NULL, 'X.*.[206-207,222-223].0/24', 'RDB网段', '0012_0000000001', '0013_0000000005', '24', 'PCD_MG_RDB', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000017', NULL, '0013_0000000017', 'umadmin', '2020-04-14 16:32:04', 'umadmin', '2020-04-12 01:56:05', 34, 'X.*.[204-205,220-221].0/24__SUBNET__PCD_MG_CACHE', NULL, 'X.*.[204-205,220-221].0/24', 'CACHE网段', '0012_0000000001', '0013_0000000005', '24', 'PCD_MG_CACHE', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000018', NULL, '0013_0000000018', 'umadmin', '2020-04-15 00:46:49', 'umadmin', '2020-04-12 01:56:05', 34, 'X.*.[202-203,218-219].0/24__SUBNET__PCD_MG_APP', NULL, 'X.*.[202-203,218-219].0/24', 'APP网段', '0012_0000000001', '0013_0000000005', '24', 'PCD_MG_APP', 'SUBNET', 'new', 'N', 'Y'),
	('0013_0000000019', NULL, '0013_0000000019', 'umadmin', '2020-04-14 16:32:02', 'umadmin', '2020-04-12 01:56:06', 34, 'X.*.[200-201,216-217].0/24__SUBNET__PCD_MG_LB', NULL, 'X.*.[200-201,216-217].0/24', 'LB网段', '0012_0000000001', '0013_0000000005', '24', 'PCD_MG_LB', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000020', NULL, '0013_0000000020', 'umadmin', '2020-04-14 16:32:03', 'umadmin', '2020-04-12 01:56:06', 34, 'X.*.[192-198,208-214].0/24__SUBNET__PCD_MG_VDI', NULL, 'X.*.[192-198,208-214].0/24', 'VDI网段', '0012_0000000001', '0013_0000000005', '24', 'PCD_MG_VDI', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000021', NULL, '0013_0000000021', 'umadmin', '2020-04-14 16:32:01', 'umadmin', '2020-04-12 02:00:47', 34, '0.0.0.0/0__WAN__PDC_WAN', NULL, '0.0.0.0/0', 'WAN网段', '0012_0000000001', '', '0', 'PDC_WAN', 'WAN', 'new', 'N', 'N'),
	('0013_0000000022', NULL, '0013_0000000022', 'umadmin', '2020-04-14 16:32:00', 'umadmin', '2020-04-12 02:01:18', 34, '0.0.0.0/0__PTN__PDC_PTN', NULL, '0.0.0.0/0', 'PTN网段', '0012_0000000001', '', '0', 'PDC_PTN', 'PTN', 'new', 'N', 'N'),
	('0013_0000000023', NULL, '0013_0000000023', 'umadmin', '2020-04-14 16:32:00', 'umadmin', '2020-04-12 02:02:43', 34, '0.0.0.0/0__OPN__PDC_OPN', NULL, '0.0.0.0/0', 'OPN网段', '0012_0000000001', '', '0', 'PDC_OPN', 'OPN', 'new', 'N', 'N'),
	('0013_0000000024', NULL, '0013_0000000024', 'umadmin', '2020-04-15 00:48:50', 'umadmin', '2020-04-12 03:40:21', 34, 'X.*.[199,215].0/24__SUBNET__PCD_MG_PROXY', NULL, 'X.*.[199,215].0/24', 'PROXY网段', '0012_0000000001', '0013_0000000005', '24', 'PCD_MG_PROXY', 'SUBNET', 'new', 'N', 'N'),
	('0013_0000000025', NULL, '0013_0000000025', 'umadmin', '2020-04-14 16:31:58', 'umadmin', '2020-04-12 19:44:54', 34, '0.0.0.0/0__WNET__PCD_DMZ_WNET', NULL, '0.0.0.0/0', 'VPC公网网段', '0012_0000000001', '0013_0000000003', '0', 'PCD_DMZ_WNET', 'WNET', 'new', 'N', 'N'),
	('0013_0000000026', NULL, '0013_0000000026', 'umadmin', '2020-04-14 16:31:58', 'umadmin', '2020-04-12 19:45:45', 34, '0.0.0.0/0__WNET__PCD_MG_WNET', NULL, '0.0.0.0/0', 'VPC公网网段', '0012_0000000001', '0013_0000000005', '0', 'PCD_MG_WNET', 'WNET', 'new', 'N', 'N');
/*!40000 ALTER TABLE `network_segment_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_zone` DISABLE KEYS */;
INSERT INTO `network_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center`, `network_segment`, `network_zone_design`, `network_zone_layer`, `state_code`) VALUES
	('0024_0000000001', NULL, '0024_0000000001', 'umadmin', '2020-04-13 10:44:05', 'umadmin', '2020-04-12 12:50:44', 37, 'PRD_SF', NULL, 'SF', '', '0022_0000000001', '0023_0000000009', '0014_0000000001', 'CORE', 'created'),
	('0024_0000000002', NULL, '0024_0000000002', 'umadmin', '2020-04-13 10:44:05', 'umadmin', '2020-04-12 12:51:22', 37, 'PRD_MG', NULL, 'MG', '', '0022_0000000001', '0023_0000000008', '0014_0000000004', 'LINK', 'created'),
	('0024_0000000003', NULL, '0024_0000000003', 'umadmin', '2020-04-13 10:44:05', 'umadmin', '2020-04-12 14:06:03', 37, 'DR_SF', NULL, 'SF', '', '0022_0000000002', '0023_0000000007', '0014_0000000001', 'CORE', 'created'),
	('0024_0000000004', NULL, '0024_0000000004', 'umadmin', '2020-04-13 10:44:05', 'umadmin', '2020-04-12 14:06:03', 37, 'DR_MG', NULL, 'MG', '', '0022_0000000002', '0023_0000000006', '0014_0000000004', 'LINK', 'created'),
	('0024_0000000005', NULL, '0024_0000000005', 'umadmin', '2020-04-13 18:51:21', 'umadmin', '2020-04-13 10:47:39', 37, 'ODC_WAN', NULL, 'WAN', '', '0022_0000000006', '0023_0000000044', '0014_0000000005', 'CLIENT', 'created');
/*!40000 ALTER TABLE `network_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_zone_design` DISABLE KEYS */;
INSERT INTO `network_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center_design`, `network_segment_design`, `network_zone_layer`, `state_code`) VALUES
	('0014_0000000001', NULL, '0014_0000000001', 'umadmin', '2020-04-12 01:57:04', 'umadmin', '2020-04-12 01:57:04', 34, 'PCD_SF', NULL, 'SF', '', '0012_0000000001', '0013_0000000002', 'CORE', 'new'),
	('0014_0000000002', NULL, '0014_0000000002', 'umadmin', '2020-04-12 01:57:20', 'umadmin', '2020-04-12 01:57:20', 34, 'PCD_DMZ', NULL, 'DMZ', '', '0012_0000000001', '0013_0000000003', 'LINK', 'new'),
	('0014_0000000003', NULL, '0014_0000000003', 'umadmin', '2020-04-12 01:57:34', 'umadmin', '2020-04-12 01:57:34', 34, 'PCD_ECN', NULL, 'ECN', '', '0012_0000000001', '0013_0000000004', 'LINK', 'new'),
	('0014_0000000004', NULL, '0014_0000000004', 'umadmin', '2020-04-12 01:57:56', 'umadmin', '2020-04-12 01:57:56', 34, 'PCD_MG', NULL, 'MG', '', '0012_0000000001', '0013_0000000005', 'LINK', 'new'),
	('0014_0000000005', NULL, '0014_0000000005', 'umadmin', '2020-04-12 02:03:10', 'umadmin', '2020-04-12 02:03:10', 34, 'PCD_WAN', NULL, 'WAN', '', '0012_0000000001', '0013_0000000021', 'CLIENT', 'new'),
	('0014_0000000006', NULL, '0014_0000000006', 'umadmin', '2020-04-12 02:03:27', 'umadmin', '2020-04-12 02:03:27', 34, 'PCD_PTN', NULL, 'PTN', '', '0012_0000000001', '0013_0000000022', 'CLIENT', 'new'),
	('0014_0000000007', NULL, '0014_0000000007', 'umadmin', '2020-04-12 02:03:43', 'umadmin', '2020-04-12 02:03:43', 34, 'PCD_OPN', NULL, 'OPN', '', '0012_0000000001', '0013_0000000023', 'CLIENT', 'new');
/*!40000 ALTER TABLE `network_zone_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `rdb_instance` DISABLE KEYS */;
INSERT INTO `rdb_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_script`, `deploy_user`, `deploy_user_password`, `memory`, `port`, `rdb_resource_instance`, `regular_backup_asset_id`, `rollback_script`, `state_code`, `storage`, `unit`, `upgrade_script`, `variable_values`, `name`, `deploy_backup_asset_id`) VALUES
	('0051_0000000001', NULL, '0051_0000000001', 'umadmin', '2020-04-15 11:43:42', 'umadmin', '2020-04-13 14:21:09', 37, 'PRD_UM_CORE_DB_10.128.40.2:3306', NULL, 'DB(master)_10.128.40.2:3306', '', '4', '', '', NULL, 'UM_CORE', 'webank@12345', '8', '3306', '0033_0000000001', '', NULL, 'created', '50', '0048_0000000002', NULL, '=', 'umcore', ''),
	('0051_0000000002', NULL, '0051_0000000002', 'umadmin', '2020-04-15 11:43:41', 'umadmin', '2020-04-13 15:40:47', 37, 'PRD_WEMQ_CC_DB_10.128.40.2:3306', NULL, 'DB(master)_10.128.40.2:3306', '', '4', '', '', NULL, 'WEMQ_CC', 'webank@12345', '8', '3306', '0033_0000000001', '', NULL, 'created', '40', '0048_0000000015', NULL, '=', 'wemqcc', ''),
	('0051_0000000003', NULL, '0051_0000000003', 'umadmin', '2020-04-15 11:43:40', 'umadmin', '2020-04-13 15:48:34', 37, 'PRD_RMB_SGS_DB_10.128.40.2:3306', NULL, 'DB(master)_10.128.40.2:3306', '', '4', '', '', NULL, 'WEMQ_CC', 'webank@123456', '8', '3306', '0033_0000000001', '', NULL, 'created', '40', '0048_0000000021', NULL, '=', 'rmbsgs', '');
/*!40000 ALTER TABLE `rdb_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `rdb_resource_instance` DISABLE KEYS */;
INSERT INTO `rdb_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `intranet_ip`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_system`, `resource_instance_type`, `resource_set`, `state_code`, `storage`, `unit_type`, `user_name`, `user_password`, `storage_type`) VALUES
	('0033_0000000001', NULL, '0033_0000000001', 'umadmin', '2020-04-15 11:08:44', 'umadmin', '2020-04-12 15:46:47', 40, 'PRD1_SF_RDB_csmysql1', NULL, 'csmysql1_10.128.40.2', '', '', '', '', '0063_0000000002', '0008_0000000002', '', '', '0031_0000000018', '3306', '', '', '10.128.40.2:3306', '3306', 'csmysql1', '0010_0000000007', '0011_0000000002', '0009_0000000002', '0029_0000000007', 'created', '50', '0002_0000000002', 'root', 'Abcd1234', '0062_0000000005'),
	('0033_0000000002', NULL, '0033_0000000002', 'umadmin', '2020-04-15 11:08:41', 'umadmin', '2020-04-14 01:32:22', 40, 'PRD1_MG_RDB_wecubecore', NULL, 'wecubecore_10.128.206.2', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000074', '3306', '', '', '10.128.206.2:3306', '3306', 'wecubecore', '0010_0000000007', '0011_0000000002', '0009_0000000002', '0029_0000000023', 'created', '50', '0002_0000000002', 'root', 'Abcd1234', '0062_0000000005'),
	('0033_0000000003', NULL, '0033_0000000003', 'umadmin', '2020-04-15 11:08:40', 'umadmin', '2020-04-14 01:37:07', 40, 'PRD1_MG_RDB_wecubeplugin', NULL, 'wecubeplugin_10.128.206.3', '', '', '', '', '0063_0000000002', '0008_0000000001', '', '', '0031_0000000107', '3306', '', '', '10.128.206.3:3306', '3306', 'wecubeplugin', '0010_0000000007', '0011_0000000002', '0009_0000000002', '0029_0000000023', 'created', '50', '0002_0000000002', 'root', 'Abcd1234', '0062_0000000005');
/*!40000 ALTER TABLE `rdb_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_instance_spec` DISABLE KEYS */;
INSERT INTO `resource_instance_spec` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`, `unit_type`) VALUES
	('0010_0000000001', NULL, '0010_0000000001', 'umadmin', '2020-04-12 03:12:27', 'umadmin', '2020-04-11 23:45:07', 34, '华为云TVM1核2G内存', NULL, '1C2G', '1核2G内存', '0006_0000000001', 'TVM1核2G内存', 'new', '0002_0000000001'),
	('0010_0000000002', NULL, '0010_0000000002', 'umadmin', '2020-04-11 23:46:00', 'umadmin', '2020-04-11 23:46:00', 34, '华为云MYSQL1核2G', NULL, '1C2G', 'MYSQL1核2G', '0006_0000000001', 'MYSQL1核2G', 'new', '0002_0000000002'),
	('0010_0000000003', NULL, '0010_0000000003', 'umadmin', '2020-04-12 03:12:54', 'umadmin', '2020-04-12 03:12:54', 34, '华为云NVM核2G内存', NULL, '1C2G', '', '0006_0000000001', 'NVM核2G内存', 'new', '0002_0000000006'),
	('0010_0000000004', NULL, '0010_0000000004', 'umadmin', '2020-04-12 03:13:18', 'umadmin', '2020-04-12 03:13:18', 34, '华为云WVM', NULL, '1C2G', '', '0006_0000000001', 'WVM', 'new', '0002_0000000005'),
	('0010_0000000005', NULL, '0010_0000000005', 'umadmin', '2020-04-12 15:28:19', 'umadmin', '2020-04-12 15:28:19', 34, '华为云TVM2核4G内存', NULL, '2C4G', '2核4G内存', '0006_0000000001', 'TVM2核4G内存', 'new', '0002_0000000001'),
	('0010_0000000006', NULL, '0010_0000000006', 'umadmin', '2020-04-12 15:28:19', 'umadmin', '2020-04-12 15:28:19', 34, '华为云TVM4核8G内存', NULL, '4C8G', '4核8G内存', '0006_0000000001', 'TVM4核8G内存', 'new', '0002_0000000001'),
	('0010_0000000007', NULL, '0010_0000000007', 'umadmin', '2020-04-12 15:29:10', 'umadmin', '2020-04-12 15:29:10', 34, '华为云MYSQL2核4G', NULL, '2C4G', 'MYSQL2核4G', '0006_0000000001', 'MYSQL2核4G', 'new', '0002_0000000002'),
	('0010_0000000008', NULL, '0010_0000000008', 'umadmin', '2020-04-12 15:29:10', 'umadmin', '2020-04-12 15:29:10', 34, '华为云MYSQL4核8G', NULL, '4C8G', 'MYSQL4核8G', '0006_0000000001', 'MYSQL4核8G', 'new', '0002_0000000002'),
	('0010_0000000009', NULL, '0010_0000000009', 'umadmin', '2020-04-13 17:59:19', 'umadmin', '2020-04-13 00:11:55', 34, '华为云REDIS 2G', NULL, '2', '', '0006_0000000001', 'REDIS 2G', 'new', '0002_0000000003'),
	('0010_0000000010', NULL, '0010_0000000010', 'umadmin', '2020-04-13 17:59:19', 'umadmin', '2020-04-13 00:12:19', 34, '华为云REDIS 4G', NULL, '4', '', '0006_0000000001', 'REDIS 4G', 'new', '0002_0000000003'),
	('0010_0000000011', NULL, '0010_0000000011', 'umadmin', '2020-04-13 17:59:19', 'umadmin', '2020-04-13 00:12:19', 34, '华为云REDIS 8G', NULL, '8', '', '0006_0000000001', 'REDIS 8G', 'new', '0002_0000000003');
/*!40000 ALTER TABLE `resource_instance_spec` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_instance_system` DISABLE KEYS */;
INSERT INTO `resource_instance_system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `resource_instance_type`, `name`, `state_code`) VALUES
	('0011_0000000001', NULL, '0011_0000000001', 'umadmin', '2020-04-15 12:01:57', 'umadmin', '2020-04-11 23:43:30', 34, '内存型CentOS7.5 64位', NULL, '60fa1baa-a3ca-4218-8717-04c618d39787', 'CentOS6.8 64位', '0009_0000000001', 'CentOS7.5 64位', 'new'),
	('0011_0000000002', NULL, '0011_0000000002', 'umadmin', '2020-04-13 17:40:05', 'umadmin', '2020-04-11 23:44:04', 34, '异步同步型MYSQL5.6', NULL, '5.6', 'MYSQL5.6', '0009_0000000002', 'MYSQL5.6', 'new'),
	('0011_0000000003', NULL, '0011_0000000003', 'umadmin', '2020-04-15 12:01:56', 'umadmin', '2020-04-12 03:11:11', 34, '通用型CentOS7.5 64位', NULL, '60fa1baa-a3ca-4218-8717-04c618d39787', '', '0009_0000000004', 'CentOS7.5 64位', 'new'),
	('0011_0000000004', NULL, '0011_0000000004', 'umadmin', '2020-04-12 03:11:36', 'umadmin', '2020-04-12 03:11:36', 34, '通用型2Windows2018', NULL, 'Windows2018', '', '0009_0000000005', 'Windows2018', 'new'),
	('0011_0000000005', NULL, '0011_0000000005', 'umadmin', '2020-04-14 00:33:31', 'umadmin', '2020-04-13 00:08:45', 34, '主从型REDIS3.0', NULL, '3.0', '', '0009_0000000006', 'REDIS3.0', 'new');
/*!40000 ALTER TABLE `resource_instance_system` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_instance_type` DISABLE KEYS */;
INSERT INTO `resource_instance_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`, `unit_type`) VALUES
	('0009_0000000001', NULL, '0009_0000000001', 'umadmin', '2020-04-12 03:07:45', 'umadmin', '2020-04-11 22:21:49', 34, '华为云内存型', NULL, 'm3', '通用计算型', '0006_0000000001', '内存型', 'new', '0002_0000000001'),
	('0009_0000000002', NULL, '0009_0000000002', 'umadmin', '2020-04-12 16:14:33', 'umadmin', '2020-04-11 23:36:11', 34, '华为云异步同步型', NULL, 'async', '', '0006_0000000001', '异步同步型', 'new', '0002_0000000002'),
	('0009_0000000003', NULL, '0009_0000000003', 'umadmin', '2020-04-13 18:08:58', 'umadmin', '2020-04-11 23:40:13', 34, '华为云内网型', NULL, 'Internal', '', '0006_0000000001', '内网型', 'new', '0002_0000000004'),
	('0009_0000000004', NULL, '0009_0000000004', 'umadmin', '2020-04-12 03:07:31', 'umadmin', '2020-04-12 03:07:31', 34, '华为云通用型', NULL, 's3', '', '0006_0000000001', '通用型', 'new', '0002_0000000006'),
	('0009_0000000005', NULL, '0009_0000000005', 'umadmin', '2020-04-12 03:10:07', 'umadmin', '2020-04-12 03:09:45', 34, '华为云通用型2', NULL, 's3', '', '0006_0000000001', '通用型2', 'new', '0002_0000000005'),
	('0009_0000000006', NULL, '0009_0000000006', 'umadmin', '2020-04-13 17:52:25', 'umadmin', '2020-04-13 00:07:13', 34, '华为云主从型', NULL, 'ha', '', '0006_0000000001', '主从型', 'new', '0002_0000000003'),
	('0009_0000000007', NULL, '0009_0000000007', 'umadmin', '2020-04-13 18:04:06', 'umadmin', '2020-04-13 18:04:06', 34, '华为云单机型', NULL, 'single', '', '0006_0000000001', '单机型', 'new', '0002_0000000003'),
	('0009_0000000008', NULL, '0009_0000000008', 'umadmin', '2020-04-13 18:09:23', 'umadmin', '2020-04-13 18:09:23', 34, '华为云外网型', NULL, 'External', '', '0006_0000000001', '外网型', 'new', '0002_0000000004');
/*!40000 ALTER TABLE `resource_instance_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set` DISABLE KEYS */;
INSERT INTO `resource_set` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone`, `cluster_type`, `logic_resource_set`, `manage_role`, `resource_type`, `resource_set_design`, `resource_set_type`, `state_code`, `unit_type`) VALUES
	('0029_0000000001', NULL, '0029_0000000001', 'umadmin', '2020-04-12 14:15:43', 'umadmin', '2020-04-12 13:41:46', 37, 'PCD_SF_CS_1C0_1TAPP0', NULL, '1TAPP0', '', '0028_0000000001', '0007_0000000001', '', '0001_0000000001', 'HOST', '0019_0000000001', 'GROUP', 'created', '0002_0000000001'),
	('0029_0000000002', NULL, '0029_0000000002', 'umadmin', '2020-04-12 15:07:45', 'umadmin', '2020-04-12 13:44:13', 37, 'PCD_SF_CS_1C1_1TAPP1', NULL, '1TAPP1', '', '0028_0000000003', '0007_0000000001', '0029_0000000001', '0001_0000000001', 'HOST', '0019_0000000001', 'NODE', 'created', '0002_0000000001'),
	('0029_0000000003', NULL, '0029_0000000003', 'umadmin', '2020-04-12 14:15:43', 'umadmin', '2020-04-12 14:00:03', 37, 'PCD_SF_CS_1C0_1RCACHE0', NULL, '1RCACHE0', '', '0028_0000000001', '0007_0000000001', '', '0001_0000000001', 'CACHE', '0019_0000000003', 'GROUP', 'created', '0002_0000000003'),
	('0029_0000000004', NULL, '0029_0000000004', 'umadmin', '2020-04-12 14:15:43', 'umadmin', '2020-04-12 14:00:04', 37, 'PCD_SF_CS_1C0_1MRDB0', NULL, '1MRDB0', '', '0028_0000000001', '0007_0000000001', '', '0001_0000000001', 'RDB', '0019_0000000002', 'GROUP', 'created', '0002_0000000002'),
	('0029_0000000005', NULL, '0029_0000000005', 'umadmin', '2020-04-12 15:48:33', 'umadmin', '2020-04-12 14:00:04', 37, 'PCD_SF_CS_1C0_1ILB0', NULL, '1ILB0', '', '0028_0000000001', '0007_0000000003', '', '0001_0000000001', 'LB', '0019_0000000004', 'GROUP', 'created', '0002_0000000004'),
	('0029_0000000006', NULL, '0029_0000000006', 'umadmin', '2020-04-13 00:19:24', 'umadmin', '2020-04-12 14:01:49', 37, 'PCD_SF_CS_1C1_1RCACHE1', NULL, '1RCACHE1', '', '0028_0000000003', '0007_0000000005', '0029_0000000003', '0001_0000000001', 'CACHE', '0019_0000000003', 'NODE', 'created', '0002_0000000003'),
	('0029_0000000007', NULL, '0029_0000000007', 'umadmin', '2020-04-12 17:52:01', 'umadmin', '2020-04-12 14:01:49', 37, 'PCD_SF_CS_1C1_1MRDB1', NULL, '1MRDB1', '', '0028_0000000003', '0007_0000000002', '0029_0000000004', '0001_0000000001', 'RDB', '0019_0000000002', 'NODE', 'created', '0002_0000000002'),
	('0029_0000000008', NULL, '0029_0000000008', 'umadmin', '2020-04-12 17:53:41', 'umadmin', '2020-04-12 14:01:50', 37, 'PCD_SF_CS_1C1_1ILB1', NULL, '1ILB1', '', '0028_0000000003', '0007_0000000003', '0029_0000000005', '0001_0000000001', 'LB', '0019_0000000004', 'NODE', 'created', '0002_0000000004'),
	('0029_0000000009', NULL, '0029_0000000009', 'umadmin', '2020-04-12 17:53:41', 'umadmin', '2020-04-12 14:16:58', 37, 'PCD_SF_CS_1C2_1ILB2', NULL, '1ILB2', '', '0028_0000000009', '0007_0000000003', '0029_0000000005', '0001_0000000001', 'LB', '0019_0000000004', 'NODE', 'created', '0002_0000000004'),
	('0029_0000000010', NULL, '0029_0000000010', 'umadmin', '2020-04-13 00:19:24', 'umadmin', '2020-04-12 14:16:58', 37, 'PCD_SF_CS_1C2_1RCACHE2', NULL, '1RCACHE2', '', '0028_0000000009', '0007_0000000005', '0029_0000000003', '0001_0000000001', 'CACHE', '0019_0000000003', 'NODE', 'created', '0002_0000000003'),
	('0029_0000000011', NULL, '0029_0000000011', 'umadmin', '2020-04-12 17:52:20', 'umadmin', '2020-04-12 14:16:58', 37, 'PCD_SF_CS_1C2_1MRDB2', NULL, '1MRDB2', '', '0028_0000000009', '0007_0000000002', '0029_0000000004', '0001_0000000001', 'RDB', '0019_0000000002', 'NODE', 'created', '0002_0000000002'),
	('0029_0000000012', NULL, '0029_0000000012', 'umadmin', '2020-04-12 15:32:12', 'umadmin', '2020-04-12 14:16:59', 37, 'PCD_SF_CS_1C2_1TAPP2', NULL, '1TAPP2', '', '0028_0000000009', '0007_0000000001', '0029_0000000001', '0001_0000000001', 'HOST', '0019_0000000001', 'NODE', 'created', '0002_0000000001'),
	('0029_0000000013', NULL, '0029_0000000013', 'umadmin', '2020-04-12 14:19:13', 'umadmin', '2020-04-12 14:19:13', 37, 'PCD_MG_MT_1M0_1MRDB0', NULL, '1MRDB0', '', '0028_0000000002', '0007_0000000001', '', '0001_0000000001', 'RDB', '0019_0000000016', 'GROUP', 'created', '0002_0000000002'),
	('0029_0000000014', NULL, '0029_0000000014', 'umadmin', '2020-04-12 14:19:13', 'umadmin', '2020-04-12 14:19:13', 37, 'PCD_MG_MT_1M0_1ILB0', NULL, '1ILB0', '', '0028_0000000002', '0007_0000000001', '', '0001_0000000001', 'LB', '0019_0000000014', 'GROUP', 'created', '0002_0000000004'),
	('0029_0000000015', NULL, '0029_0000000015', 'umadmin', '2020-04-12 14:19:13', 'umadmin', '2020-04-12 14:19:13', 37, 'PCD_MG_MT_1M0_1RCACHE0', NULL, '1RCACHE0', '', '0028_0000000002', '0007_0000000001', '', '0001_0000000001', 'CACHE', '0019_0000000015', 'GROUP', 'created', '0002_0000000003'),
	('0029_0000000016', NULL, '0029_0000000016', 'umadmin', '2020-04-12 14:19:14', 'umadmin', '2020-04-12 14:19:13', 37, 'PCD_MG_MT_1M0_1TAPP0', NULL, '1TAPP0', '', '0028_0000000002', '0007_0000000001', '', '0001_0000000001', 'HOST', '0019_0000000017', 'GROUP', 'created', '0002_0000000001'),
	('0029_0000000017', NULL, '0029_0000000017', 'umadmin', '2020-04-12 14:22:33', 'umadmin', '2020-04-12 14:22:33', 37, 'PCD_MG_MT_1M2_1TAPP2', NULL, '1TAPP2', '', '0028_0000000008', '0007_0000000001', '0029_0000000016', '0001_0000000001', 'HOST', '0019_0000000017', 'NODE', 'created', '0002_0000000001'),
	('0029_0000000018', NULL, '0029_0000000018', 'umadmin', '2020-04-12 17:55:38', 'umadmin', '2020-04-12 14:22:33', 37, 'PCD_MG_MT_1M2_1ILB2', NULL, '1ILB2', '', '0028_0000000008', '0007_0000000001', '0029_0000000014', '0001_0000000001', 'LB', '0019_0000000014', 'NODE', 'created', '0002_0000000004'),
	('0029_0000000019', NULL, '0029_0000000019', 'umadmin', '2020-04-13 00:19:23', 'umadmin', '2020-04-12 14:22:34', 37, 'PCD_MG_MT_1M2_1RCACHE2', NULL, '1RCACHE2', '', '0028_0000000008', '0007_0000000005', '0029_0000000015', '0001_0000000001', 'CACHE', '0019_0000000015', 'NODE', 'created', '0002_0000000003'),
	('0029_0000000020', NULL, '0029_0000000020', 'umadmin', '2020-04-12 17:55:02', 'umadmin', '2020-04-12 14:22:34', 37, 'PCD_MG_MT_1M2_1MRDB2', NULL, '1MRDB2', '', '0028_0000000008', '0007_0000000001', '0029_0000000013', '0001_0000000001', 'RDB', '0019_0000000016', 'NODE', 'created', '0002_0000000002'),
	('0029_0000000021', NULL, '0029_0000000021', 'umadmin', '2020-04-12 17:55:37', 'umadmin', '2020-04-12 14:22:34', 37, 'PCD_MG_MT_1M1_1ILB1', NULL, '1ILB1', '', '0028_0000000004', '0007_0000000001', '0029_0000000014', '0001_0000000001', 'LB', '0019_0000000014', 'NODE', 'created', '0002_0000000004'),
	('0029_0000000022', NULL, '0029_0000000022', 'umadmin', '2020-04-13 00:19:23', 'umadmin', '2020-04-12 14:22:34', 37, 'PCD_MG_MT_1M1_1RCACHE1', NULL, '1RCACHE1', '', '0028_0000000004', '0007_0000000005', '0029_0000000015', '0001_0000000001', 'CACHE', '0019_0000000015', 'NODE', 'created', '0002_0000000003'),
	('0029_0000000023', NULL, '0029_0000000023', 'umadmin', '2020-04-12 17:55:02', 'umadmin', '2020-04-12 14:22:34', 37, 'PCD_MG_MT_1M1_1MRDB1', NULL, '1MRDB1', '', '0028_0000000004', '0007_0000000001', '0029_0000000013', '0001_0000000001', 'RDB', '0019_0000000016', 'NODE', 'created', '0002_0000000002'),
	('0029_0000000024', NULL, '0029_0000000024', 'umadmin', '2020-04-12 17:54:21', 'umadmin', '2020-04-12 14:22:35', 37, 'PCD_MG_MT_1M1_1TAPP1', NULL, '1TAPP1', '', '0028_0000000004', '0007_0000000001', '0029_0000000016', '0001_0000000001', 'HOST', '0019_0000000017', 'NODE', 'created', '0002_0000000001'),
	('0029_0000000025', NULL, '0029_0000000025', 'umadmin', '2020-04-14 01:09:40', 'umadmin', '2020-04-12 14:30:13', 37, 'PCD_MG_QZ_1Q0_1PROXY0', NULL, '1PROXY0', '', '0028_0000000005', '0007_0000000003', '', '0001_0000000001', 'HOST', '0019_0000000019', 'GROUP', 'created', '0002_0000000006'),
	('0029_0000000026', NULL, '0029_0000000026', 'umadmin', '2020-04-14 01:09:40', 'umadmin', '2020-04-12 14:31:21', 37, 'PCD_MG_QZ_1Q1_1PROXY1', NULL, '1PROXY1', '', '0028_0000000006', '0007_0000000001', '0029_0000000025', '0001_0000000001', 'HOST', '0019_0000000019', 'NODE', 'created', '0002_0000000006'),
	('0029_0000000027', NULL, '0029_0000000027', 'umadmin', '2020-04-14 01:09:40', 'umadmin', '2020-04-12 14:31:21', 37, 'PCD_MG_QZ_1Q2_1PROXY2', NULL, '1PROXY2', '', '0028_0000000007', '0007_0000000001', '0029_0000000025', '0001_0000000001', 'HOST', '0019_0000000019', 'NODE', 'created', '0002_0000000006'),
	('0029_0000000028', NULL, '0029_0000000028', 'umadmin', '2020-04-14 01:09:17', 'umadmin', '2020-04-12 17:57:04', 37, 'PCD_MG_QZ_1Q0_1VDI0', NULL, '1VDI0', '', '0028_0000000005', '0007_0000000003', '', '0001_0000000001', 'HOST', '0019_0000000018', 'GROUP', 'created', '0002_0000000005'),
	('0029_0000000029', NULL, '0029_0000000029', 'umadmin', '2020-04-14 01:19:10', 'umadmin', '2020-04-12 17:57:56', 37, 'PCD_MG_QZ_1Q1_1VDI1', NULL, '1VDI1', '', '0028_0000000006', '0007_0000000003', '0029_0000000028', '0001_0000000001', 'HOST', '0019_0000000018', 'NODE', 'created', '0002_0000000005'),
	('0029_0000000030', NULL, '0029_0000000030', 'umadmin', '2020-04-14 01:19:10', 'umadmin', '2020-04-12 17:57:56', 37, 'PCD_MG_QZ_1Q2_1VDI2', NULL, '1VDI2', '', '0028_0000000007', '0007_0000000003', '0029_0000000028', '0001_0000000001', 'HOST', '0019_0000000018', 'NODE', 'created', '0002_0000000005');
/*!40000 ALTER TABLE `resource_set` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set$deploy_environment` DISABLE KEYS */;
INSERT INTO `resource_set$deploy_environment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(109, '0029_0000000017', '0003_0000000002', 1),
	(113, '0029_0000000002', '0003_0000000001', 1),
	(114, '0029_0000000012', '0003_0000000002', 1),
	(117, '0029_0000000007', '0003_0000000001', 1),
	(118, '0029_0000000011', '0003_0000000002', 1),
	(121, '0029_0000000009', '0003_0000000002', 1),
	(122, '0029_0000000008', '0003_0000000001', 1),
	(123, '0029_0000000024', '0003_0000000001', 1),
	(124, '0029_0000000020', '0003_0000000002', 1),
	(125, '0029_0000000023', '0003_0000000001', 1),
	(128, '0029_0000000021', '0003_0000000001', 1),
	(129, '0029_0000000018', '0003_0000000002', 1),
	(130, '0029_0000000026', '0003_0000000001', 1),
	(131, '0029_0000000027', '0003_0000000002', 1),
	(140, '0029_0000000019', '0003_0000000002', 1),
	(141, '0029_0000000022', '0003_0000000001', 1),
	(142, '0029_0000000010', '0003_0000000002', 1),
	(143, '0029_0000000006', '0003_0000000001', 1),
	(144, '0029_0000000029', '0003_0000000001', 1),
	(145, '0029_0000000030', '0003_0000000002', 1);
/*!40000 ALTER TABLE `resource_set$deploy_environment` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set$network_segment` DISABLE KEYS */;
INSERT INTO `resource_set$network_segment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(140, '0029_0000000017', '0023_0000000040', 1),
	(157, '0029_0000000002', '0023_0000000015', 2),
	(158, '0029_0000000002', '0023_0000000010', 1),
	(159, '0029_0000000012', '0023_0000000036', 1),
	(169, '0029_0000000007', '0023_0000000017', 2),
	(170, '0029_0000000007', '0023_0000000012', 1),
	(171, '0029_0000000011', '0023_0000000034', 1),
	(175, '0029_0000000009', '0023_0000000032', 1),
	(176, '0029_0000000008', '0023_0000000014', 1),
	(177, '0029_0000000008', '0023_0000000019', 2),
	(178, '0029_0000000024', '0023_0000000023', 1),
	(179, '0029_0000000024', '0023_0000000029', 2),
	(180, '0029_0000000020', '0023_0000000038', 1),
	(181, '0029_0000000023', '0023_0000000025', 1),
	(182, '0029_0000000023', '0023_0000000031', 2),
	(186, '0029_0000000021', '0023_0000000028', 2),
	(187, '0029_0000000021', '0023_0000000022', 1),
	(188, '0029_0000000018', '0023_0000000039', 1),
	(189, '0029_0000000026', '0023_0000000021', 1),
	(190, '0029_0000000026', '0023_0000000027', 2),
	(191, '0029_0000000027', '0023_0000000042', 1),
	(204, '0029_0000000019', '0023_0000000037', 1),
	(205, '0029_0000000022', '0023_0000000030', 2),
	(206, '0029_0000000022', '0023_0000000024', 1),
	(207, '0029_0000000010', '0023_0000000033', 1),
	(208, '0029_0000000006', '0023_0000000011', 1),
	(209, '0029_0000000006', '0023_0000000016', 2),
	(210, '0029_0000000029', '0023_0000000026', 2),
	(211, '0029_0000000029', '0023_0000000020', 1),
	(212, '0029_0000000030', '0023_0000000041', 1);
/*!40000 ALTER TABLE `resource_set$network_segment` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set_design` DISABLE KEYS */;
INSERT INTO `resource_set_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone_design`, `network_segment_design`, `state_code`, `unit_type`) VALUES
	('0019_0000000001', NULL, '0019_0000000001', 'umadmin', '2020-04-12 02:48:15', 'umadmin', '2020-04-12 02:48:15', 34, 'PCD_SF_CS_TAPP', NULL, 'TAPP', '', '0018_0000000001', '0013_0000000006', 'new', '0002_0000000001'),
	('0019_0000000002', NULL, '0019_0000000002', 'umadmin', '2020-04-12 02:48:42', 'umadmin', '2020-04-12 02:48:42', 34, 'PCD_SF_CS_MRDB', NULL, 'MRDB', '', '0018_0000000001', '0013_0000000008', 'new', '0002_0000000002'),
	('0019_0000000003', NULL, '0019_0000000003', 'umadmin', '2020-04-12 02:49:02', 'umadmin', '2020-04-12 02:49:02', 34, 'PCD_SF_CS_RCACHE', NULL, 'RCACHE', '', '0018_0000000001', '0013_0000000007', 'new', '0002_0000000003'),
	('0019_0000000004', NULL, '0019_0000000004', 'umadmin', '2020-04-12 02:49:28', 'umadmin', '2020-04-12 02:49:28', 34, 'PCD_SF_CS_ILB', NULL, 'ILB', '', '0018_0000000001', '0013_0000000010', 'new', '0002_0000000004'),
	('0019_0000000005', NULL, '0019_0000000005', 'umadmin', '2020-04-12 02:49:59', 'umadmin', '2020-04-12 02:49:59', 34, 'PCD_SF_DCN_TAPP', NULL, 'TAPP', '', '0018_0000000002', '0013_0000000006', 'new', '0002_0000000001'),
	('0019_0000000006', NULL, '0019_0000000006', 'umadmin', '2020-04-12 02:52:30', 'umadmin', '2020-04-12 02:52:30', 34, 'PCD_SF_DCN_ILB', NULL, 'ILB', '', '0018_0000000002', '0013_0000000010', 'new', '0002_0000000004'),
	('0019_0000000007', NULL, '0019_0000000007', 'umadmin', '2020-04-12 02:52:30', 'umadmin', '2020-04-12 02:52:30', 34, 'PCD_SF_DCN_RCACHE', NULL, 'RCACHE', '', '0018_0000000002', '0013_0000000007', 'new', '0002_0000000003'),
	('0019_0000000008', NULL, '0019_0000000008', 'umadmin', '2020-04-12 02:52:30', 'umadmin', '2020-04-12 02:52:30', 34, 'PCD_SF_DCN_MRDB', NULL, 'MRDB', '', '0018_0000000002', '0013_0000000008', 'new', '0002_0000000002'),
	('0019_0000000009', NULL, '0019_0000000009', 'umadmin', '2020-04-12 03:16:21', 'umadmin', '2020-04-12 03:16:21', 34, 'PCD_DMZ_DCN_ILB', NULL, 'ILB', '', '0018_0000000003', '0013_0000000011', 'new', '0002_0000000004'),
	('0019_0000000010', NULL, '0019_0000000010', 'umadmin', '2020-04-12 03:16:21', 'umadmin', '2020-04-12 03:16:21', 34, 'PCD_DMZ_DCN_NGINX', NULL, 'NGINX', '', '0018_0000000003', '0013_0000000012', 'new', '0002_0000000006'),
	('0019_0000000011', NULL, '0019_0000000011', 'umadmin', '2020-04-12 03:18:11', 'umadmin', '2020-04-12 03:18:11', 34, 'PCD_DMZ_DCN_TAPP', NULL, 'TAPP', '', '0018_0000000003', '0013_0000000013', 'new', '0002_0000000001'),
	('0019_0000000012', NULL, '0019_0000000012', 'umadmin', '2020-04-12 03:18:59', 'umadmin', '2020-04-12 03:18:59', 34, 'PCD_ECN_DCN_TAPP', NULL, 'TAPP', '', '0018_0000000004', '0013_0000000014', 'new', '0002_0000000001'),
	('0019_0000000013', NULL, '0019_0000000013', 'umadmin', '2020-04-12 03:19:00', 'umadmin', '2020-04-12 03:19:00', 34, 'PCD_ECN_DCN_ILB', NULL, 'ILB', '', '0018_0000000004', '0013_0000000015', 'new', '0002_0000000004'),
	('0019_0000000014', NULL, '0019_0000000014', 'umadmin', '2020-04-12 03:19:49', 'umadmin', '2020-04-12 03:19:49', 34, 'PCD_MG_MT_ILB', NULL, 'ILB', '', '0018_0000000005', '0013_0000000019', 'new', '0002_0000000004'),
	('0019_0000000015', NULL, '0019_0000000015', 'umadmin', '2020-04-12 03:19:49', 'umadmin', '2020-04-12 03:19:49', 34, 'PCD_MG_MT_RCACHE', NULL, 'RCACHE', '', '0018_0000000005', '0013_0000000017', 'new', '0002_0000000003'),
	('0019_0000000016', NULL, '0019_0000000016', 'umadmin', '2020-04-12 03:19:49', 'umadmin', '2020-04-12 03:19:49', 34, 'PCD_MG_MT_MRDB', NULL, 'MRDB', '', '0018_0000000005', '0013_0000000016', 'new', '0002_0000000002'),
	('0019_0000000017', NULL, '0019_0000000017', 'umadmin', '2020-04-12 03:19:50', 'umadmin', '2020-04-12 03:19:49', 34, 'PCD_MG_MT_TAPP', NULL, 'TAPP', '', '0018_0000000005', '0013_0000000018', 'new', '0002_0000000001'),
	('0019_0000000018', NULL, '0019_0000000018', 'umadmin', '2020-04-12 03:20:07', 'umadmin', '2020-04-12 03:20:07', 34, 'PCD_MG_QZ_VDI', NULL, 'VDI', '', '0018_0000000006', '0013_0000000020', 'new', '0002_0000000005'),
	('0019_0000000019', NULL, '0019_0000000019', 'umadmin', '2020-04-12 14:27:47', 'umadmin', '2020-04-12 14:27:09', 34, 'PCD_MG_QZ_PROXY', NULL, 'PROXY', '', '0018_0000000006', '0013_0000000024', 'new', '0002_0000000006');
/*!40000 ALTER TABLE `resource_set_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set_invoke_design` DISABLE KEYS */;
INSERT INTO `resource_set_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_resource_set_design`, `invoke_resource_set_design`, `state_code`) VALUES
	('0021_0000000001', NULL, '0021_0000000001', 'umadmin', '2020-04-12 03:20:24', 'umadmin', '2020-04-12 03:20:24', 34, 'PCD_MG_QZ_VDI-->>--PCD_SF_CS_ILB', NULL, 'VDI-->>--ILB', '', '0019_0000000004', '0019_0000000018', 'new'),
	('0021_0000000002', NULL, '0021_0000000002', 'umadmin', '2020-04-12 03:20:52', 'umadmin', '2020-04-12 03:20:52', 34, 'PCD_MG_QZ_VDI-->>--PCD_MG_MT_ILB', NULL, 'VDI-->>--ILB', '', '0019_0000000014', '0019_0000000018', 'new'),
	('0021_0000000003', NULL, '0021_0000000003', 'umadmin', '2020-04-12 03:21:10', 'umadmin', '2020-04-12 03:21:10', 34, 'PCD_SF_CS_TAPP-->>--PCD_SF_CS_MRDB', NULL, 'TAPP-->>--MRDB', '', '0019_0000000002', '0019_0000000001', 'new'),
	('0021_0000000004', NULL, '0021_0000000004', 'umadmin', '2020-04-12 03:21:21', 'umadmin', '2020-04-12 03:21:21', 34, 'PCD_SF_CS_TAPP-->>--PCD_SF_CS_RCACHE', NULL, 'TAPP-->>--RCACHE', '', '0019_0000000003', '0019_0000000001', 'new'),
	('0021_0000000005', NULL, '0021_0000000005', 'umadmin', '2020-04-12 03:21:29', 'umadmin', '2020-04-12 03:21:29', 34, 'PCD_SF_CS_ILB-->>--PCD_SF_CS_TAPP', NULL, 'ILB-->>--TAPP', '', '0019_0000000001', '0019_0000000004', 'new'),
	('0021_0000000006', NULL, '0021_0000000006', 'umadmin', '2020-04-12 03:21:43', 'umadmin', '2020-04-12 03:21:42', 34, 'PCD_SF_CS_TAPP-->>--PCD_SF_CS_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000004', '0019_0000000001', 'new'),
	('0021_0000000007', NULL, '0021_0000000007', 'umadmin', '2020-04-12 03:22:00', 'umadmin', '2020-04-12 03:22:00', 34, 'PCD_SF_CS_TAPP-->>--PCD_SF_DCN_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000006', '0019_0000000001', 'new'),
	('0021_0000000008', NULL, '0021_0000000008', 'umadmin', '2020-04-12 03:22:19', 'umadmin', '2020-04-12 03:22:19', 34, 'PCD_SF_DCN_TAPP-->>--PCD_SF_CS_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000004', '0019_0000000005', 'new'),
	('0021_0000000009', NULL, '0021_0000000009', 'umadmin', '2020-04-12 03:22:43', 'umadmin', '2020-04-12 03:22:43', 34, 'PCD_SF_DCN_TAPP-->>--PCD_DMZ_DCN_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000009', '0019_0000000005', 'new'),
	('0021_0000000010', NULL, '0021_0000000010', 'umadmin', '2020-04-12 03:23:07', 'umadmin', '2020-04-12 03:23:07', 34, 'PCD_SF_DCN_TAPP-->>--PCD_ECN_DCN_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000013', '0019_0000000005', 'new'),
	('0021_0000000011', NULL, '0021_0000000011', 'umadmin', '2020-04-12 03:23:32', 'umadmin', '2020-04-12 03:23:32', 34, 'PCD_DMZ_DCN_TAPP-->>--PCD_SF_CS_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000004', '0019_0000000011', 'new'),
	('0021_0000000012', NULL, '0021_0000000012', 'umadmin', '2020-04-12 03:23:56', 'umadmin', '2020-04-12 03:23:55', 34, 'PCD_DMZ_DCN_TAPP-->>--PCD_SF_DCN_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000006', '0019_0000000011', 'new'),
	('0021_0000000013', NULL, '0021_0000000013', 'umadmin', '2020-04-12 03:24:31', 'umadmin', '2020-04-12 03:24:31', 34, 'PCD_ECN_DCN_TAPP-->>--PCD_SF_CS_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000004', '0019_0000000012', 'new'),
	('0021_0000000014', NULL, '0021_0000000014', 'umadmin', '2020-04-12 03:24:47', 'umadmin', '2020-04-12 03:24:47', 34, 'PCD_ECN_DCN_TAPP-->>--PCD_SF_DCN_ILB', NULL, 'TAPP-->>--ILB', '', '0019_0000000006', '0019_0000000012', 'new'),
	('0021_0000000015', NULL, '0021_0000000015', 'umadmin', '2020-04-12 03:25:13', 'umadmin', '2020-04-12 03:25:13', 34, 'PCD_ECN_DCN_ILB-->>--PCD_ECN_DCN_TAPP', NULL, 'ILB-->>--TAPP', '', '0019_0000000012', '0019_0000000013', 'new'),
	('0021_0000000016', NULL, '0021_0000000016', 'umadmin', '2020-04-13 14:04:13', 'umadmin', '2020-04-13 14:04:13', 34, 'PCD_SF_CS_TAPP-->>--PCD_SF_CS_TAPP', NULL, 'TAPP-->>--TAPP', '', '0019_0000000001', '0019_0000000001', 'new');
/*!40000 ALTER TABLE `resource_set_invoke_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `dest_network_segment`, `owner_network_segment`, `network_link`, `route_design`, `state_code`) VALUES
	('0030_0000000001', NULL, '0030_0000000001', 'umadmin', '2020-04-16 10:42:10', 'umadmin', '2020-04-12 13:18:39', 37, 'PRD_MG-->>--PRD_SF', NULL, 'PRD_MG--to--PRD_SF', '', '', '0023_0000000009', '0023_0000000008', '0026_0000000001', '0020_0000000005', 'created'),
	('0030_0000000002', NULL, '0030_0000000002', 'umadmin', '2020-04-14 16:59:17', 'umadmin', '2020-04-12 13:19:09', 37, 'PRD_SF-->>--PRD_MG', NULL, 'PRD_SF--to--PRD_MG', '', '', '0023_0000000008', '0023_0000000009', '0026_0000000001', '0020_0000000006', 'created');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;

/*!40000 ALTER TABLE `route_design` DISABLE KEYS */;
INSERT INTO `route_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `dest_network_segment_design`, `network_zone_link_design`, `owner_network_segment_design`, `state_code`) VALUES
	('0020_0000000001', NULL, '0020_0000000001', 'umadmin', '2020-04-14 16:58:20', 'umadmin', '2020-04-12 03:29:48', 34, 'PCD_DMZ-->>--PCD_SF_LB', NULL, 'PCD_DMZ-->>--PCD_SF_LB', '', '0013_0000000010', '0016_0000000001', '0013_0000000003', 'new'),
	('0020_0000000002', NULL, '0020_0000000002', 'umadmin', '2020-04-14 16:58:20', 'umadmin', '2020-04-12 03:31:00', 34, 'PCD_SF-->>--PCD_DMZ', NULL, 'PCD_SF-->>--PCD_DMZ', '', '0013_0000000003', '0016_0000000001', '0013_0000000002', 'new'),
	('0020_0000000003', NULL, '0020_0000000003', 'umadmin', '2020-04-14 16:58:20', 'umadmin', '2020-04-12 03:31:56', 34, 'PCD_ECN-->>--PCD_SF_LB', NULL, 'PCD_ECN-->>--PCD_SF_LB', '', '0013_0000000010', '0016_0000000002', '0013_0000000004', 'new'),
	('0020_0000000004', NULL, '0020_0000000004', 'umadmin', '2020-04-14 16:58:19', 'umadmin', '2020-04-12 03:32:08', 34, 'PCD_SF-->>--PCD_ECN', NULL, 'PCD_SF-->>--PCD_ECN', '', '0013_0000000004', '0016_0000000002', '0013_0000000002', 'new'),
	('0020_0000000005', NULL, '0020_0000000005', 'umadmin', '2020-04-14 16:58:19', 'umadmin', '2020-04-12 03:32:22', 34, 'PCD_MG-->>--PCD_SF', NULL, 'PCD_MG-->>--PCD_SF', '', '0013_0000000002', '0016_0000000003', '0013_0000000005', 'new'),
	('0020_0000000006', NULL, '0020_0000000006', 'umadmin', '2020-04-14 16:58:09', 'umadmin', '2020-04-12 03:32:35', 34, 'PCD_SF-->>--PCD_MG', NULL, 'PCD_SF-->>--PCD_MG', '', '0013_0000000005', '0016_0000000003', '0013_0000000002', 'new'),
	('0020_0000000007', NULL, '0020_0000000007', 'umadmin', '2020-04-14 16:58:08', 'umadmin', '2020-04-12 03:32:50', 34, 'PCD_DMZ-->>--PCD_MG', NULL, 'PCD_DMZ-->>--PCD_MG', '', '0013_0000000005', '0016_0000000005', '0013_0000000003', 'new'),
	('0020_0000000008', NULL, '0020_0000000008', 'umadmin', '2020-04-14 16:58:08', 'umadmin', '2020-04-12 03:33:06', 34, 'PCD_MG-->>--PCD_DMZ', NULL, 'PCD_MG-->>--PCD_DMZ', '', '0013_0000000003', '0016_0000000005', '0013_0000000005', 'new'),
	('0020_0000000009', NULL, '0020_0000000009', 'umadmin', '2020-04-14 16:58:08', 'umadmin', '2020-04-12 03:33:32', 34, 'PCD_ECN-->>--PCD_DMZ', NULL, 'PCD_ECN-->>--PCD_DMZ', '', '0013_0000000003', '0016_0000000004', '0013_0000000004', 'new'),
	('0020_0000000010', NULL, '0020_0000000010', 'umadmin', '2020-04-14 16:58:08', 'umadmin', '2020-04-12 03:33:32', 34, 'PCD_ECN-->>--PCD_MG', NULL, 'PCD_ECN-->>--PCD_MG', '', '0013_0000000005', '0016_0000000004', '0013_0000000004', 'new'),
	('0020_0000000011', NULL, '0020_0000000011', 'umadmin', '2020-04-14 16:58:07', 'umadmin', '2020-04-12 03:35:38', 34, 'PCD_ECN-->>--PDC_PTN', NULL, 'PCD_ECN-->>--PDC_PTN', '', '0013_0000000022', '0016_0000000007', '0013_0000000004', 'new'),
	('0020_0000000012', NULL, '0020_0000000012', 'umadmin', '2020-04-14 16:58:07', 'umadmin', '2020-04-12 03:35:38', 34, 'PCD_DMZ-->>--PDC_WAN', NULL, 'PCD_DMZ-->>--PDC_WAN', '', '0013_0000000021', '0016_0000000006', '0013_0000000003', 'new'),
	('0020_0000000013', NULL, '0020_0000000013', 'umadmin', '2020-04-14 16:58:08', 'umadmin', '2020-04-12 03:35:38', 34, 'PCD_MG-->>--PDC_OPN', NULL, 'PCD_MG-->>--PDC_OPN', '', '0013_0000000023', '0016_0000000008', '0013_0000000005', 'new'),
	('0020_0000000014', NULL, '0020_0000000014', 'umadmin', '2020-04-14 16:58:07', 'umadmin', '2020-04-12 13:09:59', 34, 'PCD_DMZ-->>--PCD_SF_APP', NULL, 'PCD_DMZ-->>--PCD_SF_APP', '', '0013_0000000006', '0016_0000000001', '0013_0000000003', 'new'),
	('0020_0000000015', NULL, '0020_0000000015', 'umadmin', '2020-04-14 16:58:07', 'umadmin', '2020-04-12 13:11:53', 34, 'PCD_ECN-->>--PCD_SF_APP', NULL, 'PCD_ECN-->>--PCD_SF_APP', '', '0013_0000000006', '0016_0000000002', '0013_0000000004', 'new');
/*!40000 ALTER TABLE `route_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_design` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_invoke_design` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_invoke_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_invoke_seq_design` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_invoke_seq_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` ENABLE KEYS */;

/*!40000 ALTER TABLE `storage_type` DISABLE KEYS */;
INSERT INTO `storage_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `state_code`, `fixed_date`, `code`, `cloud_vendor`, `description`, `name`, `unit_type`) VALUES
	('0062_0000000001', NULL, '0062_0000000001', 'umadmin', '2020-04-11 23:54:01', 'umadmin', '2020-04-11 23:49:54', 34, '华为云TVM普通IO型', 'new', NULL, 'SATA', '0006_0000000001', 'TVM普通IO类型', 'TVM普通IO型', '0002_0000000001'),
	('0062_0000000002', NULL, '0062_0000000002', 'umadmin', '2020-04-11 23:54:01', 'umadmin', '2020-04-11 23:50:47', 34, '华为云TVM高IO型', 'new', NULL, 'SAS', '0006_0000000001', 'TVM高IO型', 'TVM高IO型', '0002_0000000001'),
	('0062_0000000003', NULL, '0062_0000000003', 'umadmin', '2020-04-11 23:54:01', 'umadmin', '2020-04-11 23:51:23', 34, '华为云TVM超过IO型', 'new', NULL, 'SSD', '0006_0000000001', 'TVM超过IO型', 'TVM超过IO型', '0002_0000000001'),
	('0062_0000000005', NULL, '0062_0000000005', 'umadmin', '2020-04-13 17:44:40', 'umadmin', '2020-04-11 23:53:18', 34, '华为云MYSQL超高IO型', 'new', NULL, 'ULTRAHIGH', '0006_0000000001', 'MYSQL超过IO型', 'MYSQL超高IO型', '0002_0000000002'),
	('0062_0000000007', NULL, '0062_0000000007', 'umadmin', '2020-04-12 03:14:26', 'umadmin', '2020-04-12 03:14:26', 34, '华为云WVM普通IO型', 'new', NULL, 'SATA', '0006_0000000001', 'WVM普通IO类型', 'WVM普通IO型', '0002_0000000005'),
	('0062_0000000008', NULL, '0062_0000000008', 'umadmin', '2020-04-12 03:14:26', 'umadmin', '2020-04-12 03:14:26', 34, '华为云NVM普通IO型', 'new', NULL, 'SATA', '0006_0000000001', 'NVM普通IO类型', 'NVM普通IO型', '0002_0000000006');
/*!40000 ALTER TABLE `storage_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys` DISABLE KEYS */;
INSERT INTO `subsys` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `manage_role`, `state_code`, `subsys_design`, `app_system`) VALUES
	('0047_0000000001', NULL, '0047_0000000001', 'umadmin', '2020-04-13 14:08:15', 'umadmin', '2020-04-13 14:06:51', 37, 'PRD_UM_CLIENT', NULL, 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000001', '0046_0000000001'),
	('0047_0000000002', NULL, '0047_0000000002', 'umadmin', '2020-04-13 14:08:14', 'umadmin', '2020-04-13 14:07:12', 37, 'PRD_UM_CORE', NULL, 'CORE', '', '0001_0000000001', 'created', '0038_0000000002', '0046_0000000001'),
	('0047_0000000003', NULL, '0047_0000000003', 'umadmin', '2020-04-13 14:08:14', 'umadmin', '2020-04-13 14:07:34', 37, 'PRD_UM_SRV', NULL, 'SRV', '', '0001_0000000001', 'created', '0038_0000000004', '0046_0000000001'),
	('0047_0000000004', NULL, '0047_0000000004', 'umadmin', '2020-04-13 14:08:14', 'umadmin', '2020-04-13 14:07:34', 37, 'PRD_UM_SSO', NULL, 'SSO', '', '0001_0000000001', 'created', '0038_0000000003', '0046_0000000001'),
	('0047_0000000005', NULL, '0047_0000000005', 'umadmin', '2020-04-13 15:19:26', 'umadmin', '2020-04-13 15:18:01', 37, 'PRD_FPS_TP', NULL, 'TP', '', '0001_0000000001', 'created', '0038_0000000005', '0046_0000000002'),
	('0047_0000000006', NULL, '0047_0000000006', 'umadmin', '2020-04-13 15:19:26', 'umadmin', '2020-04-13 15:18:16', 37, 'PRD_FPS_HBASE', NULL, 'HBASE', '', '0001_0000000001', 'created', '0038_0000000006', '0046_0000000002'),
	('0047_0000000007', NULL, '0047_0000000007', 'umadmin', '2020-04-13 15:24:38', 'umadmin', '2020-04-13 15:23:26', 37, 'PRD_WEMQ_CLIENT', NULL, 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000008', '0046_0000000003'),
	('0047_0000000008', NULL, '0047_0000000008', 'umadmin', '2020-04-13 15:24:23', 'umadmin', '2020-04-13 15:24:23', 37, 'PRD_WEMQ_ADM', NULL, 'ADM', '', '0001_0000000001', 'created', '0038_0000000009', '0046_0000000003'),
	('0047_0000000009', NULL, '0047_0000000009', 'umadmin', '2020-04-13 15:24:24', 'umadmin', '2020-04-13 15:24:23', 37, 'PRD_WEMQ_CC', NULL, 'CC', '', '0001_0000000001', 'created', '0038_0000000010', '0046_0000000003'),
	('0047_0000000010', NULL, '0047_0000000010', 'umadmin', '2020-04-13 15:24:24', 'umadmin', '2020-04-13 15:24:24', 37, 'PRD_WEMQ_NAMESRV', NULL, 'NAMESRV', '', '0001_0000000001', 'created', '0038_0000000011', '0046_0000000003'),
	('0047_0000000011', NULL, '0047_0000000011', 'umadmin', '2020-04-13 15:24:24', 'umadmin', '2020-04-13 15:24:24', 37, 'PRD_WEMQ_BROKER', NULL, 'BROKER', '', '0001_0000000001', 'created', '0038_0000000007', '0046_0000000003'),
	('0047_0000000012', NULL, '0047_0000000012', 'umadmin', '2020-04-13 15:43:24', 'umadmin', '2020-04-13 15:43:23', 37, 'PRD_RMB_CLIENT', NULL, 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000012', '0046_0000000004'),
	('0047_0000000013', NULL, '0047_0000000013', 'umadmin', '2020-04-13 15:43:41', 'umadmin', '2020-04-13 15:43:40', 37, 'PRD_RMB_SGS', NULL, 'SGS', '', '0001_0000000001', 'created', '0038_0000000013', '0046_0000000004');
/*!40000 ALTER TABLE `subsys` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys$business_zone` DISABLE KEYS */;
INSERT INTO `subsys$business_zone` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(9, '0047_0000000003', '0028_0000000003', 1),
	(10, '0047_0000000004', '0028_0000000003', 1),
	(11, '0047_0000000002', '0028_0000000003', 1),
	(12, '0047_0000000001', '0028_0000000006', 1),
	(13, '0047_0000000006', '0028_0000000003', 1),
	(14, '0047_0000000005', '0028_0000000003', 1),
	(15, '0047_0000000008', '0028_0000000003', 1),
	(16, '0047_0000000009', '0028_0000000003', 1),
	(17, '0047_0000000010', '0028_0000000003', 1),
	(18, '0047_0000000011', '0028_0000000003', 1),
	(19, '0047_0000000007', '0028_0000000006', 1),
	(20, '0047_0000000012', '0028_0000000006', 1),
	(21, '0047_0000000013', '0028_0000000003', 1);
/*!40000 ALTER TABLE `subsys$business_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys_design` DISABLE KEYS */;
INSERT INTO `subsys_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `subsys_design_id`, `app_system_design`) VALUES
	('0038_0000000001', NULL, '0038_0000000001', 'umadmin', '2020-04-15 14:19:02', 'umadmin', '2020-04-13 13:52:08', 34, 'UM_CLIENT', '2020-04-15 14:19:00', 'CLIENT', '', '客户端子系统', 'new', '5000', '0037_0000000001'),
	('0038_0000000002', NULL, '0038_0000000002', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:52:31', 34, 'UM_CORE', '2020-04-15 14:19:00', 'CORE', '', '用户管理', 'new', '5014', '0037_0000000001'),
	('0038_0000000003', NULL, '0038_0000000003', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:52:50', 34, 'UM_SSO', '2020-04-15 14:19:00', 'SSO', '', '单点登录', 'new', '5165', '0037_0000000001'),
	('0038_0000000004', NULL, '0038_0000000004', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:53:10', 34, 'UM_SRV', '2020-04-15 14:19:00', 'SRV', '', '鉴权代理', 'new', '5166', '0037_0000000001'),
	('0038_0000000005', NULL, '0038_0000000005', 'umadmin', '2020-04-13 14:42:14', 'umadmin', '2020-04-13 14:41:21', 34, 'FPS_TP', NULL, 'TP', '', '文件处理技术平台', 'new', '5009', '0037_0000000002'),
	('0038_0000000006', NULL, '0038_0000000006', 'umadmin', '2020-04-13 14:41:48', 'umadmin', '2020-04-13 14:41:48', 34, 'FPS_HBASE', NULL, 'HBASE', '', 'HBASE数据库', 'new', '5005', '0037_0000000002'),
	('0038_0000000007', NULL, '0038_0000000007', 'umadmin', '2020-04-13 14:45:50', 'umadmin', '2020-04-13 14:45:50', 34, 'WEMQ_BROKER', NULL, 'BROKER', '', '消息中间件核心', 'new', '5085', '0037_0000000003'),
	('0038_0000000008', NULL, '0038_0000000008', 'umadmin', '2020-04-13 15:03:27', 'umadmin', '2020-04-13 14:50:02', 34, 'WEMQ_CLIENT', NULL, 'CLIENT', '', '客户端子系统', 'new', '5001', '0037_0000000003'),
	('0038_0000000009', NULL, '0038_0000000009', 'umadmin', '2020-04-13 14:50:02', 'umadmin', '2020-04-13 14:50:02', 34, 'WEMQ_ADM', NULL, 'ADM', '', '消息中间件管理台', 'new', '5145', '0037_0000000003'),
	('0038_0000000010', NULL, '0038_0000000010', 'umadmin', '2020-04-13 14:50:02', 'umadmin', '2020-04-13 14:50:02', 34, 'WEMQ_CC', NULL, 'CC', '', '消息中间件配置中心', 'new', '5132', '0037_0000000003'),
	('0038_0000000011', NULL, '0038_0000000011', 'umadmin', '2020-04-13 14:50:02', 'umadmin', '2020-04-13 14:50:02', 34, 'WEMQ_NAMESRV', NULL, 'NAMESRV', '', '消息中间件名字服务', 'new', '5168', '0037_0000000003'),
	('0038_0000000012', NULL, '0038_0000000012', 'umadmin', '2020-04-13 15:10:31', 'umadmin', '2020-04-13 15:10:31', 34, 'RMB_CLIENT', NULL, 'CLIENT', '', '客户端子系统', 'new', '50003', '0037_0000000004'),
	('0038_0000000013', NULL, '0038_0000000013', 'umadmin', '2020-04-13 15:10:52', 'umadmin', '2020-04-13 15:10:52', 34, 'RMB_SGS', NULL, 'SGS', '', 'RMB服务治理平台系统', 'new', '5063', '0037_0000000004');
/*!40000 ALTER TABLE `subsys_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys_design$business_zone_design` DISABLE KEYS */;
INSERT INTO `subsys_design$business_zone_design` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(21, '0038_0000000004', '0018_0000000001', 1),
	(22, '0038_0000000003', '0018_0000000001', 1),
	(23, '0038_0000000002', '0018_0000000001', 1),
	(24, '0038_0000000001', '0018_0000000006', 1),
	(25, '0038_0000000006', '0018_0000000001', 1),
	(26, '0038_0000000005', '0018_0000000001', 1),
	(27, '0038_0000000007', '0018_0000000001', 1),
	(32, '0038_0000000009', '0018_0000000001', 1),
	(33, '0038_0000000010', '0018_0000000001', 1),
	(34, '0038_0000000011', '0018_0000000001', 1),
	(35, '0038_0000000008', '0018_0000000006', 1),
	(36, '0038_0000000012', '0018_0000000006', 1),
	(37, '0038_0000000013', '0018_0000000001', 1);
/*!40000 ALTER TABLE `subsys_design$business_zone_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
INSERT INTO `unit` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_path`, `manage_role`, `public_key`, `resource_set`, `security_group_asset_id`, `state_code`, `subsys`, `unit_design`, `unit_type`, `protocol`) VALUES
	('0048_0000000001', NULL, '0048_0000000001', 'umadmin', '2020-04-14 01:09:17', 'umadmin', '2020-04-13 14:09:58', 37, 'PRD_UM_CLIENT_BROWSER', NULL, 'BROWSER', '', '/data/PRD_UM_CLIENT_BROWSER/', '0001_0000000001', '', '0029_0000000029', '', 'created', '0047_0000000001', '0039_0000000001', '0002_0000000005', 'TCP'),
	('0048_0000000002', NULL, '0048_0000000002', 'umadmin', '2020-04-13 14:12:24', 'umadmin', '2020-04-13 14:12:23', 37, 'PRD_UM_CORE_DB', NULL, 'DB', '', '/data/PRD_UM_CORE_DB/', '0001_0000000001', '', '0029_0000000007', '', 'created', '0047_0000000002', '0039_0000000007', '0002_0000000002', 'TCP'),
	('0048_0000000003', NULL, '0048_0000000003', 'umadmin', '2020-04-13 14:12:25', 'umadmin', '2020-04-13 14:12:24', 37, 'PRD_UM_CORE_LB', NULL, 'LB', '', '/data/PRD_UM_CORE_LB/', '0001_0000000001', '', '0029_0000000008', '', 'created', '0047_0000000002', '0039_0000000005', '0002_0000000004', 'TCP'),
	('0048_0000000004', NULL, '0048_0000000004', 'umadmin', '2020-04-13 14:12:25', 'umadmin', '2020-04-13 14:12:25', 37, 'PRD_UM_CORE_APP', NULL, 'APP', '', '/data/PRD_UM_CORE_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000002', '0039_0000000008', '0002_0000000001', 'TCP'),
	('0048_0000000005', NULL, '0048_0000000005', 'umadmin', '2020-04-13 14:12:26', 'umadmin', '2020-04-13 14:12:25', 37, 'PRD_UM_SSO_LB', NULL, 'LB', '', '/data/PRD_UM_SSO_LB/', '0001_0000000001', '', '0029_0000000008', '', 'created', '0047_0000000004', '0039_0000000006', '0002_0000000004', 'TCP'),
	('0048_0000000006', NULL, '0048_0000000006', 'umadmin', '2020-04-13 14:12:27', 'umadmin', '2020-04-13 14:12:26', 37, 'PRD_UM_SSO_REDIS', NULL, 'REDIS', '', '/data/PRD_UM_SSO_REDIS/', '0001_0000000001', '', '0029_0000000006', '', 'created', '0047_0000000004', '0039_0000000004', '0002_0000000003', 'TCP'),
	('0048_0000000007', NULL, '0048_0000000007', 'umadmin', '2020-04-13 14:12:27', 'umadmin', '2020-04-13 14:12:27', 37, 'PRD_UM_SSO_APP', NULL, 'APP', '', '/data/PRD_UM_SSO_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000004', '0039_0000000003', '0002_0000000001', 'TCP'),
	('0048_0000000008', NULL, '0048_0000000008', 'umadmin', '2020-04-13 14:12:28', 'umadmin', '2020-04-13 14:12:28', 37, 'PRD_UM_SRV_APP', NULL, 'APP', '', '/data/PRD_UM_SRV_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000003', '0039_0000000002', '0002_0000000001', 'TCP'),
	('0048_0000000009', NULL, '0048_0000000009', 'umadmin', '2020-04-13 15:19:52', 'umadmin', '2020-04-13 15:19:51', 37, 'PRD_FPS_TP_APP', NULL, 'APP', '', '/data/PRD_FPS_TP_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000005', '0039_0000000009', '0002_0000000001', 'TCP'),
	('0048_0000000010', NULL, '0048_0000000010', 'umadmin', '2020-04-13 15:20:12', 'umadmin', '2020-04-13 15:20:11', 37, 'PRD_FPS_HBASE_APP', NULL, 'APP', '', '/data/PRD_FPS_HBASE_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000006', '0039_0000000010', '0002_0000000001', 'TCP'),
	('0048_0000000011', NULL, '0048_0000000011', 'umadmin', '2020-04-14 01:09:17', 'umadmin', '2020-04-13 15:25:19', 37, 'PRD_WEMQ_CLIENT_BROWSER', NULL, 'BROWSER', '', '/data/PRD_WEMQ_CLIENT_BROWSER/', '0001_0000000001', '', '0029_0000000029', '', 'created', '0047_0000000007', '0039_0000000014', '0002_0000000005', 'TCP'),
	('0048_0000000012', NULL, '0048_0000000012', 'umadmin', '2020-04-13 15:31:37', 'umadmin', '2020-04-13 15:31:37', 37, 'PRD_WEMQ_ADM_APP', NULL, 'APP', '', '/data/PRD_WEMQ_ADM_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000008', '0039_0000000016', '0002_0000000001', 'TCP'),
	('0048_0000000013', NULL, '0048_0000000013', 'umadmin', '2020-04-13 15:33:50', 'umadmin', '2020-04-13 15:33:49', 37, 'PRD_WEMQ_NAMESRV_APP', NULL, 'APP', '', '/data/PRD_WEMQ_NAMESRV_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000010', '0039_0000000012', '0002_0000000001', 'TCP'),
	('0048_0000000014', NULL, '0048_0000000014', 'umadmin', '2020-04-13 15:33:50', 'umadmin', '2020-04-13 15:33:50', 37, 'PRD_WEMQ_BROKER_APP', NULL, 'APP', '', '/data/PRD_WEMQ_BROKER_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000011', '0039_0000000011', '0002_0000000001', 'TCP'),
	('0048_0000000015', NULL, '0048_0000000015', 'umadmin', '2020-04-13 15:33:51', 'umadmin', '2020-04-13 15:33:50', 37, 'PRD_WEMQ_CC_DB', NULL, 'DB', '', '/data/PRD_WEMQ_CC_DB/', '0001_0000000001', '', '0029_0000000007', '', 'created', '0047_0000000009', '0039_0000000015', '0002_0000000002', 'TCP'),
	('0048_0000000016', NULL, '0048_0000000016', 'umadmin', '2020-04-13 15:33:52', 'umadmin', '2020-04-13 15:33:51', 37, 'PRD_WEMQ_CC_APP', NULL, 'APP', '', '/data/PRD_WEMQ_CC_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000009', '0039_0000000017', '0002_0000000001', 'TCP'),
	('0048_0000000017', NULL, '0048_0000000017', 'umadmin', '2020-04-13 15:33:52', 'umadmin', '2020-04-13 15:33:52', 37, 'PRD_WEMQ_ADM_LB', NULL, 'LB', '', '/data/PRD_WEMQ_ADM_LB/', '0001_0000000001', '', '0029_0000000008', '', 'created', '0047_0000000008', '0039_0000000013', '0002_0000000004', 'TCP'),
	('0048_0000000018', NULL, '0048_0000000018', 'umadmin', '2020-04-13 15:44:27', 'umadmin', '2020-04-13 15:44:26', 37, 'PRD_RMB_SGS_APP', NULL, 'APP', '', '/data/PRD_RMB_SGS_APP/', '0001_0000000001', '', '0029_0000000002', '', 'created', '0047_0000000013', '0039_0000000018', '0002_0000000001', 'TCP'),
	('0048_0000000019', NULL, '0048_0000000019', 'umadmin', '2020-04-13 15:45:20', 'umadmin', '2020-04-13 15:45:19', 37, 'PRD_RMB_SGS_LB', NULL, 'LB', '', '/data/PRD_RMB_SGS_LB/', '0001_0000000001', '', '0029_0000000008', '', 'created', '0047_0000000013', '0039_0000000019', '0002_0000000004', 'TCP'),
	('0048_0000000020', NULL, '0048_0000000020', 'umadmin', '2020-04-14 01:09:17', 'umadmin', '2020-04-13 15:45:20', 37, 'PRD_RMB_CLIENT_BROWSER', NULL, 'BROWSER', '', '/data/PRD_RMB_CLIENT_BROWSER/', '0001_0000000001', '', '0029_0000000029', '', 'created', '0047_0000000012', '0039_0000000020', '0002_0000000005', 'TCP'),
	('0048_0000000021', NULL, '0048_0000000021', 'umadmin', '2020-04-13 15:45:21', 'umadmin', '2020-04-13 15:45:20', 37, 'PRD_RMB_SGS_DB', NULL, 'DB', '', '/data/PRD_RMB_SGS_DB/', '0001_0000000001', '', '0029_0000000007', '', 'created', '0047_0000000013', '0039_0000000021', '0002_0000000002', 'TCP');
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit$deploy_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `unit$deploy_package` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit_design` DISABLE KEYS */;
INSERT INTO `unit_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `across_resource_set`, `name`, `protocol`, `resource_set_design`, `state_code`, `subsys_design`, `unit_type`) VALUES
	('0039_0000000001', NULL, '0039_0000000001', 'umadmin', '2020-04-15 14:19:02', 'umadmin', '2020-04-13 13:57:35', 34, 'UM_CLIENT_BROWER', '2020-04-15 14:19:00', 'BROWER', '', 'Y', 'WEB端', 'TCP', '0019_0000000018', 'new', '0038_0000000001', '0002_0000000005'),
	('0039_0000000002', NULL, '0039_0000000002', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:59:06', 34, 'UM_SRV_APP', '2020-04-15 14:19:00', 'APP', '', 'Y', '鉴权服务', 'TCP', '0019_0000000001', 'new', '0038_0000000004', '0002_0000000001'),
	('0039_0000000003', NULL, '0039_0000000003', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:59:06', 34, 'UM_SSO_APP', '2020-04-15 14:19:00', 'APP', '', 'Y', '单点登录', 'TCP', '0019_0000000001', 'new', '0038_0000000003', '0002_0000000001'),
	('0039_0000000004', NULL, '0039_0000000004', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 13:59:07', 34, 'UM_SSO_REDIS', '2020-04-15 14:19:00', 'REDIS', '', 'Y', '缓存服务', 'TCP', '0019_0000000003', 'new', '0038_0000000003', '0002_0000000003'),
	('0039_0000000005', NULL, '0039_0000000005', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:00:56', 34, 'UM_CORE_LB', '2020-04-15 14:19:00', 'LB', '', 'Y', '负载均衡', 'TCP', '0019_0000000004', 'new', '0038_0000000002', '0002_0000000004'),
	('0039_0000000006', NULL, '0039_0000000006', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:00:56', 34, 'UM_SSO_LB', '2020-04-15 14:19:00', 'LB', '', 'Y', '负载均衡', 'TCP', '0019_0000000004', 'new', '0038_0000000003', '0002_0000000004'),
	('0039_0000000007', NULL, '0039_0000000007', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:00:57', 34, 'UM_CORE_DB', '2020-04-15 14:19:00', 'DB', '', 'Y', '数据库', 'TCP', '0019_0000000002', 'new', '0038_0000000002', '0002_0000000002'),
	('0039_0000000008', NULL, '0039_0000000008', 'umadmin', '2020-04-15 14:19:01', 'umadmin', '2020-04-13 14:00:57', 34, 'UM_CORE_APP', '2020-04-15 14:19:00', 'APP', '', 'Y', '用户管理', 'TCP', '0019_0000000001', 'new', '0038_0000000002', '0002_0000000001'),
	('0039_0000000009', NULL, '0039_0000000009', 'umadmin', '2020-04-13 14:42:50', 'umadmin', '2020-04-13 14:42:50', 34, 'FPS_TP_APP', NULL, 'APP', '', 'Y', '文件处理', 'TCP', '0019_0000000001', 'new', '0038_0000000005', '0002_0000000001'),
	('0039_0000000010', NULL, '0039_0000000010', 'umadmin', '2020-04-13 14:43:04', 'umadmin', '2020-04-13 14:43:03', 34, 'FPS_HBASE_APP', NULL, 'APP', '', 'Y', '文件处理', 'TCP', '0019_0000000001', 'new', '0038_0000000006', '0002_0000000001'),
	('0039_0000000011', NULL, '0039_0000000011', 'umadmin', '2020-04-13 15:01:20', 'umadmin', '2020-04-13 15:01:20', 34, 'WEMQ_BROKER_APP', NULL, 'APP', '', 'Y', '消息中间件核心', 'TCP', '0019_0000000001', 'new', '0038_0000000007', '0002_0000000001'),
	('0039_0000000012', NULL, '0039_0000000012', 'umadmin', '2020-04-13 15:01:46', 'umadmin', '2020-04-13 15:01:46', 34, 'WEMQ_NAMESRV_APP', NULL, 'APP', '', 'Y', '消息中间件名字服务', 'TCP', '0019_0000000001', 'new', '0038_0000000011', '0002_0000000001'),
	('0039_0000000013', NULL, '0039_0000000013', 'umadmin', '2020-04-13 15:04:31', 'umadmin', '2020-04-13 15:04:31', 34, 'WEMQ_ADM_LB', NULL, 'LB', '', 'Y', '负载均衡', 'TCP', '0019_0000000004', 'new', '0038_0000000009', '0002_0000000004'),
	('0039_0000000014', NULL, '0039_0000000014', 'umadmin', '2020-04-13 15:04:32', 'umadmin', '2020-04-13 15:04:31', 34, 'WEMQ_CLIENT_BROWER', NULL, 'BROWER', '', 'Y', 'WEB端', 'TCP', '0019_0000000018', 'new', '0038_0000000008', '0002_0000000005'),
	('0039_0000000015', NULL, '0039_0000000015', 'umadmin', '2020-04-13 15:04:32', 'umadmin', '2020-04-13 15:04:32', 34, 'WEMQ_CC_DB', NULL, 'DB', '', 'Y', '数据库', 'TCP', '0019_0000000002', 'new', '0038_0000000010', '0002_0000000002'),
	('0039_0000000016', NULL, '0039_0000000016', 'umadmin', '2020-04-13 15:04:33', 'umadmin', '2020-04-13 15:04:32', 34, 'WEMQ_ADM_APP', NULL, 'APP', '', 'Y', '消息中间件管理台', 'TCP', '0019_0000000001', 'new', '0038_0000000009', '0002_0000000001'),
	('0039_0000000017', NULL, '0039_0000000017', 'umadmin', '2020-04-13 15:04:33', 'umadmin', '2020-04-13 15:04:33', 34, 'WEMQ_CC_APP', NULL, 'APP', '', 'Y', '消息中间件配置中心', 'TCP', '0019_0000000001', 'new', '0038_0000000010', '0002_0000000001'),
	('0039_0000000018', NULL, '0039_0000000018', 'umadmin', '2020-04-13 15:11:22', 'umadmin', '2020-04-13 15:11:22', 34, 'RMB_SGS_APP', NULL, 'APP', '', 'Y', 'RMB服务治理平台系统', 'TCP', '0019_0000000001', 'new', '0038_0000000013', '0002_0000000001'),
	('0039_0000000019', NULL, '0039_0000000019', 'umadmin', '2020-04-13 15:14:48', 'umadmin', '2020-04-13 15:14:47', 34, 'RMB_SGS_LB', NULL, 'LB', '', 'Y', '负载均衡', 'TCP', '0019_0000000004', 'new', '0038_0000000013', '0002_0000000004'),
	('0039_0000000020', NULL, '0039_0000000020', 'umadmin', '2020-04-13 15:14:48', 'umadmin', '2020-04-13 15:14:48', 34, 'RMB_CLIENT_BROWSER', NULL, 'BROWSER', '', 'Y', 'WEB端', 'TCP', '0019_0000000018', 'new', '0038_0000000012', '0002_0000000005'),
	('0039_0000000021', NULL, '0039_0000000021', 'umadmin', '2020-04-13 15:14:49', 'umadmin', '2020-04-13 15:14:48', 34, 'RMB_SGS_DB', NULL, 'DB', '', 'Y', '数据库', 'TCP', '0019_0000000002', 'new', '0038_0000000013', '0002_0000000002');
/*!40000 ALTER TABLE `unit_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit_type` DISABLE KEYS */;
INSERT INTO `unit_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0002_0000000001', NULL, '0002_0000000001', 'umadmin', '2020-04-11 22:09:37', 'umadmin', '2020-04-11 22:09:37', 34, 'TOMCAT应用', NULL, 'TOMCAT', 'TOMCAT应用', 'TOMCAT应用', 'new'),
	('0002_0000000002', NULL, '0002_0000000002', 'umadmin', '2020-04-11 22:09:53', 'umadmin', '2020-04-11 22:09:52', 34, 'MYSQL数据库', NULL, 'MYSQL', 'MYSQL数据库', 'MYSQL数据库', 'new'),
	('0002_0000000003', NULL, '0002_0000000003', 'umadmin', '2020-04-11 22:10:13', 'umadmin', '2020-04-11 22:10:13', 34, 'REDIS缓存', NULL, 'REDIS', 'REDIS缓存', 'REDIS缓存', 'new'),
	('0002_0000000004', NULL, '0002_0000000004', 'umadmin', '2020-04-11 22:10:53', 'umadmin', '2020-04-11 22:10:53', 34, '负载均衡', NULL, 'LB', '负载均衡', '负载均衡', 'new'),
	('0002_0000000005', NULL, '0002_0000000005', 'umadmin', '2020-04-14 01:09:17', 'umadmin', '2020-04-11 22:11:32', 34, '虚拟桌面', NULL, 'VDI', '虚拟桌面', '虚拟桌面', 'new'),
	('0002_0000000006', NULL, '0002_0000000006', 'umadmin', '2020-04-14 01:09:40', 'umadmin', '2020-04-12 02:55:35', 34, 'SQUID代理', NULL, 'SQUID', 'SQUID代理', 'SQUID代理', 'new');
/*!40000 ALTER TABLE `unit_type` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;


SET FOREIGN_KEY_CHECKS=1;
