SET FOREIGN_KEY_CHECKS=0;
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
	(20, 'business_group', '业务群组', NULL, 2, NULL),
	(21, 'unit_design_type', '单元设计类型', NULL, 2, NULL),
	(22, 'unit_type', '单元类型', NULL, 2, 21),
	(24, 'deploy_environment', '部署环境', NULL, 2, NULL),
	(25, 'charge_type', '计费模式', NULL, 2, NULL),
	(26, 'network_zone_type', '网络区域类型', NULL, 2, NULL),
	(27, 'network_zone_layer', '网络区域层级', NULL, 2, NULL),
	(28, 'service_type', '服务类型', NULL, 2, NULL),
	(29, 'invoke_type', '调用类型', NULL, 2, NULL),
	(30, 'cluster_type', '集群类型', NULL, 2, 21),
	(32, 'network_segment_type', '网段类型', NULL, 2, NULL),
	(33, 'network_segment_usage', '网段用途', NULL, 2, 32),
	(34, 'network_zone_link_type', '网络连接类型', NULL, 2, NULL),
	(35, 'across_resource_set', '跨资源集合部署', NULL, 5, NULL),
	(36, 'service_dns_domain', '服务域名域', NULL, 11, NULL),
	(37, 'diff_conf_variable', '差异配置变量', NULL, 14, NULL),
	(38, 'resource_instance_type', '资源实例类型', NULL, 17, 21),
	(39, 'resource_system', '资源系统', NULL, 17, 21),
	(40, 'resource_instance_spec', '资源实例规格', NULL, 17, 21),
	(41, 'cluster_node_type', '集群节点类型', NULL, 17, 30),
	(42, 'block_storage_type', '块存储类型', NULL, 18, NULL),
	(43, 'ip_address_usage', 'IP地址用途', NULL, 19, 32),
	(44, 'auth_parameter', '认证参数', NULL, 20, NULL);

INSERT INTO `adm_basekey_cat_type` (`id_adm_basekey_cat_type`, `name`, `description`, `ci_type_id`, `type`) VALUES
	(1, 'sys', NULL, NULL, 1),
	(2, 'common', NULL, NULL, 2),
	(3, 'system_design', '系统设计', 1, 3),
	(4, 'subsys_design', '子系统设计', 2, 3),
	(5, 'unit_design', '单元设计', 3, 3),
	(6, 'service_design', '服务设计', 4, 3),
	(7, 'invoke_design', '调用设计', 5, 3),
	(8, 'invoke_seq_design', '调用时序设计', 6, 3),
	(9, 'system', '系统', 7, 3),
	(10, 'subsys', '子系统', 8, 3),
	(11, 'unit', '单元', 9, 3),
	(12, 'service', '服务', 10, 3),
	(13, 'invoke', '调用', 11, 3),
	(14, 'deploy_package', '部署包', 12, 3),
	(15, 'deploy_user', '部署用户', 13, 3),
	(16, 'business_app_instance', '业务应用实例', 14, 3),
	(17, 'resource_instance', '资源实例', 15, 3),
	(18, 'block_storage', '块存储', 16, 3),
	(19, 'ip_address', 'IP地址', 17, 3),
	(20, 'data_center', '数据中心', 18, 3),
	(21, 'network_zone', '网络区域', 19, 3),
	(22, 'network_zone_link', '网络区域连接', 20, 3),
	(23, 'business_zone', '业务区域', 21, 3),
	(24, 'resource_set', '资源集合', 22, 3),
	(25, 'network_segment', '网段', 23, 3),
	(26, 'routing_rule', '路由规则', 24, 3),
	(27, 'data_center_design', '数据中心设计', 25, 3),
	(28, 'network_zone_design', '网络区域设计', 26, 3),
	(29, 'network_zone_link_design', '网络区域连接设计', 27, 3),
	(30, 'business_zone_design', '业务区域设计', 28, 3),
	(31, 'resource_set_design', '资源集合设计', 29, 3),
	(32, 'network_segment_design', '网段设计', 30, 3),
	(33, 'routing_rule_design', '路由规则设计', 31, 3);

INSERT INTO `adm_basekey_code` (`id_adm_basekey`, `id_adm_basekey_cat`, `code`, `value`, `group_code_id`, `code_description`, `seq_no`, `status`) VALUES
	(1, 1, 'AAL', '应用架构层', NULL, '应用架构层', 1, 'active'),
	(2, 1, 'ADL', '应用部署层', NULL, '应用部署层', 2, 'active'),
	(3, 1, 'SRL', '资源运行层', NULL, '资源运行层', 3, 'active'),
	(4, 1, 'RPL', '资源规划层', NULL, '资源规划层', 4, 'active'),
	(5, 1, 'PDL', '规划设计层', NULL, '规划设计层', 5, 'active'),
	(6, 2, 'AAL', '应用架构层', NULL, '应用架构层', 1, 'active'),
	(7, 2, 'ADL', '应用部署层', NULL, '应用部署层', 2, 'active'),
	(8, 2, 'SRL', '资源运行层', NULL, '资源运行层', 3, 'active'),
	(9, 2, 'RPL', '资源规划层', NULL, '资源规划层', 4, 'active'),
	(10, 2, 'PDL', '规划设计层', NULL, '规划设计层', 5, 'active'),
	(11, 3, '1', '1', NULL, 'Zoom Level 1', 1, 'active'),
	(12, 3, '2', '2', NULL, 'Zoom Level 2', 2, 'active'),
	(13, 3, '3', '3', NULL, 'Zoom Level 3', 3, 'active'),
	(14, 3, '4', '4', NULL, 'Zoom Level 4', 4, 'active'),
	(15, 3, '5', '5', NULL, 'Zoom Level 5', 5, 'active'),
	(16, 4, 'text', '文本', NULL, '文本', 1, 'active'),
	(17, 4, 'area', '文本域', NULL, '文本域', 2, 'active'),
	(18, 4, 'number', '整型数字', NULL, '整型数字', 3, 'active'),
	(19, 4, 'regular_text', '正则校验文本', NULL, '正则校验文本', 4, 'inactive'),
	(20, 4, 'datetime', '时间', NULL, '时间', 5, 'active'),
	(21, 4, 'select', '下拉选择', NULL, '下拉选择', 6, 'active'),
	(22, 4, 'multi_enum', '多选下拉选择', NULL, '多选下拉选择', 7, 'active'),
	(23, 4, 'ref', '引用', NULL, '引用', 8, 'active'),
	(24, 4, 'multi_ref', '多选引用', NULL, '多选引用', 9, 'active'),
	(25, 4, '预留2', '预留2', NULL, '预留2', 10, 'inactive'),
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
	(36, 7, 'delete', '删除', NULL, NULL, 3, 'active'),
	(37, 8, 'created', '创建', NULL, NULL, 6, 'active'),
	(38, 8, 'change', '变更', NULL, NULL, 7, 'active'),
	(39, 8, 'destroyed', '销毁', NULL, NULL, 8, 'active'),
	(40, 9, 'created', '创建', NULL, NULL, 1, 'active'),
	(41, 9, 'startup', '启动', NULL, NULL, 2, 'active'),
	(42, 9, 'change', '变更', NULL, NULL, 3, 'active'),
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
	(58, 20, 'business_group_A', '业务群组A', NULL, '业务群组A', 1, 'active'),
	(59, 20, 'business_group_B', '业务群组B', NULL, '业务群组B', 2, 'active'),
	(60, 21, 'tomcat', 'tomcat', NULL, 'tomcat', 2, 'active'),
	(61, 21, 'mysql', 'mysql', NULL, 'mysql', 1, 'active'),
	(62, 21, 'redis', 'redis', NULL, 'redis', 3, 'active'),
	(63, 22, 'tomcat_7', 'tomcat_7', 60, 'tomcat_7', 1, 'active'),
	(64, 22, 'tomcat_8', 'tomcat_8', 60, 'tomcat_8', 2, 'active'),
	(65, 22, 'mysql_7', 'mysql_7', 61, 'mysql_7', 3, 'active'),
	(66, 22, 'mysql_8', 'mysql_8', 61, 'mysql_8', 4, 'active'),
	(67, 22, 'redis_4', 'redis_4', 62, 'redis_4', 5, 'active'),
	(68, 22, 'redis_5', 'redis_5', 62, 'redis_5', 6, 'active'),
	(69, 24, 'PRD', '生产环境', NULL, '生产环境', 1, 'active'),
	(70, 24, 'DR', '容灾环境', NULL, '容灾环境', 2, 'active'),
	(71, 24, 'STGi', 'STGi环境', NULL, 'STGi环境', 3, 'active'),
	(72, 24, 'STGk', 'STGk环境', NULL, 'STGk环境', 4, 'active'),
	(73, 24, 'INTi', 'INTi环境', NULL, 'INTi环境', 5, 'active'),
	(74, 24, 'INTk', 'INTk环境', NULL, 'INTk环境', 6, 'active'),
	(75, 24, 'DEV', '开发环境', NULL, '开发环境', 7, 'active'),
	(76, 25, 'PERPAID', '包年包月', NULL, '包年包月', 1, 'active'),
	(77, 25, 'POSTPAID_BY_HOUR', '按量计费', NULL, '按量计费', 2, 'active'),
	(78, 27, 'client_layer', '客户层', NULL, '客户层', 1, 'active'),
	(79, 27, 'link_layer', '接入层', NULL, '接入层', 2, 'active'),
	(80, 27, 'buss_layer', '业务层', NULL, '业务层', 3, 'active'),
	(81, 28, 'tcp_long', 'tcp长连接', NULL, 'tcp长连接', 1, 'active'),
	(82, 28, 'tcp_short', 'tcp短连接', NULL, 'tcp短连接', 2, 'active'),
	(83, 28, 'udp', 'udp', NULL, 'udp', 3, 'active'),
	(84, 29, 'sync_invoke', '同步调用', NULL, '同步调用', 1, 'active'),
	(85, 29, 'sync_request', '同步请求', NULL, '同步请求', 2, 'active'),
	(86, 29, 'async_respond', '异步返回', NULL, '异步返回', 3, 'active'),
	(87, 30, 'loadblacne', '负载均衡', 60, '负载均衡', 1, 'active'),
	(88, 30, 'keepalived', 'keepalived', 60, 'keepalived', 2, 'active'),
	(89, 30, 'mysql_ms', 'mysql_主从', 61, 'mysql_主从', 3, 'active'),
	(90, 30, 'mysql_alone', 'mysql_单机', 61, 'mysql_单机', 4, 'active'),
	(91, 30, 'redis_ms', 'redis_主从', 62, 'redis_主从', 5, 'active'),
	(92, 30, 'redis_alone', 'redis_单机', 62, 'redis_单机', 6, 'active'),
	(93, 32, 'intranet', '内网网段', NULL, '内网网段', 1, 'active'),
	(94, 32, 'internet', '互联网网段', NULL, '互联网网段', 2, 'active'),
	(95, 33, 'data_center', '数据中心', 93, '数据中心', 1, 'active'),
	(96, 33, 'network_zone', '网络区域', 93, '网络区域', 2, 'active'),
	(97, 33, 'business_zone', '业务区域', 93, '业务区域', 3, 'active'),
	(98, 33, 'resource_set', '资源集合', 93, '资源集合', 4, 'active'),
	(99, 33, 'internet', '互联网', 94, '互联网', 1, 'active'),
	(101, 34, 'peer_connection', '对等连接', NULL, '对等连接', 1, 'active'),
	(102, 34, 'nat_gateway', 'NAT网关', NULL, 'NAT网关', 2, 'active'),
	(103, 35, 'single', '单资源集合', NULL, '单资源集合', 3, 'active'),
	(104, 35, 'local', '同城资源集合', NULL, '同城资源集合', 1, 'active'),
	(105, 35, 'remote', '异地资源集合', NULL, '异地资源集合', 2, 'active'),
	(106, 36, 'app.demo.com', '内网应用域名', NULL, '内网应用域名', 1, 'active'),
	(107, 36, 'db.demo.com', '内网数据库域名', NULL, '内网数据库域名', 2, 'active'),
	(108, 36, 'cache.demo.com', '内网缓存域名', NULL, '内网缓存域名', 3, 'active'),
	(109, 36, 'demo.com', '外网应用域名', NULL, '外网应用域名', 4, 'active'),
	(110, 38, 'standard_type', '标准型CVM', 60, '标准型CVM', 1, 'active'),
	(111, 38, 'mem_type', '内存型CVM', 60, '内存型CVM', 2, 'active'),
	(112, 38, 'mysql_standard_type', '基础版mysql', 61, '基础版mysql', 3, 'active'),
	(113, 38, 'mysql_ha_type', '高可用版mysql', 61, '高可用版mysql', 4, 'active'),
	(114, 38, 'redis_standard_type', '基础版redis', 62, '基础版redis', 5, 'active'),
	(115, 38, 'redis_ha_type', '高可用版redis', 62, '高可用版redis', 6, 'active'),
	(116, 39, 'img-31tjrtph', 'CentOs 7.2 64位', 60, 'CentOs 7.2 64位', 1, 'active'),
	(117, 39, 'img-6ns5om13', 'CentOs 6.8 64位', 60, 'CentOs 6.8 64位', 2, 'active'),
	(118, 39, 'mysql5.5', 'mysql5.5', 61, 'mysql5.5', 3, 'active'),
	(119, 39, 'mysql5.6', 'mysql5.6', 61, 'mysql5.6', 4, 'active'),
	(120, 39, 'redis3.0', 'redis3.0', 62, 'redis3.0', 5, 'active'),
	(121, 39, 'redis4.0', 'redis4.0', 62, 'redis4.0', 6, 'active'),
	(122, 40, '1C2G_CVM', '1核2GB', 60, '1核2GB', 1, 'active'),
	(123, 40, '2C4G_CVM', '2核4GB', 60, '2核4GB', 2, 'active'),
	(124, 40, '1C2G_MYSQL', '1核2GB', 61, '1核2GB', 3, 'active'),
	(125, 40, '2C4G_MYSQL', '2核4GB', 61, '2核4GB', 4, 'active'),
	(126, 40, '4G', '4GB', 62, '4GB', 5, 'active'),
	(127, 40, '8G', '8GB', 62, '8GB', 6, 'active'),
	(128, 41, 'loadblance_node', '负载均衡节点', 87, '负载均衡节点', 1, 'active'),
	(129, 41, 'keepalived_master', 'Keepalived主节点', 88, 'Keepalived主节点', 2, 'active'),
	(130, 41, 'keepalived_slave', 'Keepalived从节点', 88, 'Keepalived从节点', 3, 'active'),
	(131, 41, 'mysql_ms_master', 'mysql主节点', 89, 'mysql主节点', 4, 'active'),
	(132, 41, 'mysql_ms_slave', 'mysql从节点', 89, 'mysql从节点', 5, 'active'),
	(133, 41, 'mysql_alone_node', 'mysql节点', 90, 'mysql节点', 6, 'active'),
	(134, 41, 'redis_ms_master', 'redis主节点', 91, 'redis主节点', 7, 'active'),
	(135, 41, 'redis_ms_slave', 'redis从节点', 91, 'redis从节点', 8, 'active'),
	(136, 41, 'redis_alone_node', 'redis节点', 92, 'redis节点', 9, 'active'),
	(137, 42, 'high_performance', '高性能', NULL, '高性能', 1, 'active'),
	(138, 42, 'high_capacity', '高容量', NULL, '高容量', 2, 'active'),
	(139, 42, 'ssd', 'SSD', NULL, 'SSD', 3, 'active'),
	(140, 43, '业务IP', '业务IP', 93, '业务IP', 1, 'active'),
	(141, 43, '网关IP', '网关IP', 93, '网关IP', 2, 'active'),
	(142, 43, '广播IP', '广播IP', 93, '广播IP', 3, 'active'),
	(143, 43, '外网IP', '主机IP', 94, '外网IP', 4, 'active'),
	(145, 44, 'redis_master', '认证参数', 108, '认证参数', 4, 'active');

INSERT INTO `adm_ci_type` (`id_adm_ci_type`, `name`, `description`, `id_adm_tenement`, `table_name`, `status`, `catalog_id`, `ci_global_unique_id`, `seq_no`, `layer_id`, `zoom_level_id`, `image_file_id`, `ci_state_type`) VALUES
	(1, '系统设计', '系统设计', NULL, 'system_design', 'created', 6, NULL, 1, 1, 1, 35, NULL),
	(2, '子系统设计', '子系统设计', NULL, 'subsys_design', 'created', 6, NULL, 2, 1, 1, 36, NULL),
	(3, '单元设计', '单元设计', NULL, 'unit_design', 'created', 6, NULL, 3, 1, 1, 37, NULL),
	(4, '服务设计', '服务设计', NULL, 'service_design', 'created', 6, NULL, 4, 1, 1, 38, NULL),
	(5, '调用设计', '调用设计', NULL, 'invoke_design', 'created', 6, NULL, 5, 1, 1, 39, NULL),
	(6, '调用时序设计', '调用时序设计', NULL, 'invoke_seq_design', 'created', 6, NULL, 6, 1, 1, 40, NULL),
	(7, '系统', '系统', NULL, 'system', 'created', 7, NULL, 1, 2, 1, 67, NULL),
	(8, '子系统', '子系统', NULL, 'subsys', 'created', 7, NULL, 2, 2, 1, 41, NULL),
	(9, '单元', '单元', NULL, 'unit', 'created', 7, NULL, 3, 2, 1, 42, NULL),
	(10, '服务', '服务', NULL, 'service', 'created', 7, NULL, 4, 2, 1, 43, NULL),
	(11, '调用', '调用', NULL, 'invoke', 'created', 7, NULL, 5, 2, 1, 44, NULL),
	(12, '部署包', '部署包', NULL, 'deploy_package', 'created', 7, NULL, 6, 2, 1, 47, NULL),
	(13, '部署用户', '部署用户', NULL, 'deploy_user', 'created', 7, NULL, 7, 2, 1, 46, NULL),
	(14, '业务应用实例', '业务应用实例', NULL, 'business_app_instance', 'created', 8, NULL, 1, 3, 1, 48, NULL),
	(15, '资源实例', '资源实例', NULL, 'resource_instance', 'created', 8, NULL, 2, 3, 1, 49, NULL),
	(16, '块存储', '块存储', NULL, 'block_storage', 'created', 8, NULL, 3, 3, 1, 50, NULL),
	(17, 'IP地址', 'IP地址', NULL, 'ip_address', 'created', 8, NULL, 4, 3, 1, 51, NULL),
	(18, '数据中心', '数据中心', NULL, 'data_center', 'created', 9, NULL, 1, 4, 1, 52, NULL),
	(19, '网络区域', '网络区域', NULL, 'network_zone', 'created', 9, NULL, 2, 4, 1, 53, NULL),
	(20, '网络区域连接', '网络区域连接', NULL, 'network_zone_link', 'created', 9, NULL, 3, 4, 1, 54, NULL),
	(21, '业务区域', '业务区域', NULL, 'business_zone', 'created', 9, NULL, 4, 4, 1, 55, NULL),
	(22, '资源集合', '资源集合', NULL, 'resource_set', 'created', 9, NULL, 5, 4, 1, 56, NULL),
	(23, '网段', '网段', NULL, 'network_segment', 'created', 9, NULL, 6, 4, 1, 57, NULL),
	(24, '路由规则', '路由规则', NULL, 'routing_rule', 'created', 9, NULL, 7, 4, 1, 59, NULL),
	(25, '数据中心设计', '数据中心设计', NULL, 'data_center_design', 'created', 10, NULL, 1, 5, 1, 60, NULL),
	(26, '网络区域设计', '网络区域设计', NULL, 'network_zone_design', 'created', 10, NULL, 2, 5, 1, 61, NULL),
	(27, '网络区域连接设计', '网络区域连接设计', NULL, 'network_zone_link_design', 'created', 10, NULL, 3, 5, 1, 62, NULL),
	(28, '业务区域设计', '业务区域设计', NULL, 'business_zone_design', 'created', 10, NULL, 4, 5, 1, 63, NULL),
	(29, '资源集合设计', '资源集合设计', NULL, 'resource_set_design', 'created', 10, NULL, 5, 5, 1, 64, NULL),
	(30, '网段设计', '网段设计', NULL, 'network_segment_design', 'created', 10, NULL, 6, 5, 1, 65, NULL),
	(31, '路由规则设计', '路由规则设计', NULL, 'routing_rule_design', 'created', 10, NULL, 7, 5, 1, 66, NULL);

INSERT INTO `adm_ci_type_attr_base` (`id_adm_ci_type_attr`, `id_adm_ci_type`, `name`, `description`, `input_type`, `property_name`, `property_type`, `length`, `reference_id`, `reference_name`, `reference_type`, `filter_rule`, `search_seq_no`, `display_type`, `display_seq_no`, `edit_is_null`, `edit_is_only`, `edit_is_hiden`, `edit_is_editable`, `is_defunct`, `special_logic`, `status`, `is_system`, `is_access_controlled`, `is_auto`, `auto_fill_rule`, `regular_expression_rule`, `is_refreshable`) VALUES
	(1, 1, '全局唯一ID', '全局唯一ID', 'text', 'guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(2, 1, '前全局唯一ID', '前一版本数据的guid', 'text', 'p_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(3, 1, '根全局唯一ID', '原始数据guid', 'text', 'r_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(4, 1, '更新用户', '更新用户', 'text', 'updated_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(5, 1, '更新日期', '更新日期', 'date', 'updated_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(6, 1, '创建用户', '创建用户', 'text', 'created_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(7, 1, '创建日期', '创建日期', 'date', 'created_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(8, 1, '唯一名称', '唯一名称', 'text', 'key_name', 'varchar', 200, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 0),
	(9, 1, '状态', '状态', 'select', 'state', 'int', 15, 7, NULL, NULL, NULL, 2, 1, 2, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(10, 1, '确认日期', '确认日期', 'text', 'fixed_date', 'varchar', 19, NULL, NULL, NULL, NULL, 3, 1, 3, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(11, 1, '描述说明', '描述说明', 'textArea', 'description', 'varchar', 1000, NULL, NULL, NULL, NULL, 4, 1, 4, 1, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0),
	(12, 1, '编码', '编码', 'text', 'code', 'varchar', 50, NULL, NULL, NULL, NULL, 5, 1, 5, 0, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 0);
	
INSERT INTO `adm_role_ci_type` (`id_adm_role_ci_type`, `id_adm_role`, `id_adm_ci_type`, `ci_type_name`, `creation_permission`, `removal_permission`, `modification_permission`, `enquiry_permission`, `execution_permission`, `grant_permission`) VALUES
	(806, 1, 1, '系统设计', 'Y', 'Y', 'Y', 'Y', 'Y', 'N'),
	(807, 1, 7, '系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(808, 1, 14, '业务应用实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(809, 1, 18, '数据中心', 'N', 'N', 'N', 'N', 'N', 'N'),
	(810, 1, 25, '数据中心设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(811, 1, 2, '子系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(812, 1, 8, '子系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(813, 1, 15, '资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(814, 1, 19, '网络区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(815, 1, 26, '网络区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(816, 1, 3, '单元设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(817, 1, 9, '单元', 'N', 'N', 'N', 'N', 'N', 'N'),
	(818, 1, 16, '块存储', 'N', 'N', 'N', 'N', 'N', 'N'),
	(819, 1, 20, '网络区域连接', 'N', 'N', 'N', 'N', 'N', 'N'),
	(820, 1, 27, '网络区域连接设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(821, 1, 4, '服务设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(822, 1, 10, '服务', 'N', 'N', 'N', 'N', 'N', 'N'),
	(823, 1, 17, 'IP地址', 'N', 'N', 'N', 'N', 'N', 'N'),
	(824, 1, 21, '业务区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(825, 1, 28, '业务区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(826, 1, 5, '调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(827, 1, 11, '调用', 'N', 'N', 'N', 'N', 'N', 'N'),
	(828, 1, 22, '资源集合', 'N', 'N', 'N', 'N', 'N', 'N'),
	(829, 1, 29, '资源集合设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(830, 1, 6, '调用时序设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(831, 1, 12, '部署包', 'N', 'N', 'N', 'N', 'N', 'N'),
	(832, 1, 23, '网段', 'N', 'N', 'N', 'N', 'N', 'N'),
	(833, 1, 30, '网段设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(834, 1, 13, '部署用户', 'N', 'N', 'N', 'N', 'N', 'N'),
	(835, 1, 24, '路由规则', 'N', 'N', 'N', 'N', 'N', 'N'),
	(836, 1, 31, '路由规则设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(837, 2, 1, '系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(838, 2, 7, '系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(839, 2, 14, '业务应用实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(840, 2, 18, '数据中心', 'N', 'N', 'N', 'N', 'N', 'N'),
	(841, 2, 25, '数据中心设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(842, 2, 2, '子系统设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(843, 2, 8, '子系统', 'N', 'N', 'N', 'N', 'N', 'N'),
	(844, 2, 15, '资源实例', 'N', 'N', 'N', 'N', 'N', 'N'),
	(845, 2, 19, '网络区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(846, 2, 26, '网络区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(847, 2, 3, '单元设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(848, 2, 9, '单元', 'N', 'N', 'N', 'N', 'N', 'N'),
	(849, 2, 16, '块存储', 'N', 'N', 'N', 'N', 'N', 'N'),
	(850, 2, 20, '网络区域连接', 'N', 'N', 'N', 'N', 'N', 'N'),
	(851, 2, 27, '网络区域连接设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(852, 2, 4, '服务设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(853, 2, 10, '服务', 'N', 'N', 'N', 'N', 'N', 'N'),
	(854, 2, 17, 'IP地址', 'N', 'N', 'N', 'N', 'N', 'N'),
	(855, 2, 21, '业务区域', 'N', 'N', 'N', 'N', 'N', 'N'),
	(856, 2, 28, '业务区域设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(857, 2, 5, '调用设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(858, 2, 11, '调用', 'N', 'N', 'N', 'N', 'N', 'N'),
	(859, 2, 22, '资源集合', 'N', 'N', 'N', 'N', 'N', 'N'),
	(860, 2, 29, '资源集合设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(861, 2, 6, '调用时序设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(862, 2, 12, '部署包', 'N', 'N', 'N', 'N', 'N', 'N'),
	(863, 2, 23, '网段', 'N', 'N', 'N', 'N', 'N', 'N'),
	(864, 2, 30, '网段设计', 'N', 'N', 'N', 'N', 'N', 'N'),
	(865, 2, 13, '部署用户', 'N', 'N', 'N', 'N', 'N', 'N'),
	(866, 2, 24, '路由规则', 'N', 'N', 'N', 'N', 'N', 'N'),
	(867, 2, 31, '路由规则设计', 'N', 'N', 'N', 'N', 'N', 'N');

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
	(57, 36, 0, 36, 1, 49, 57, 'active');

INSERT INTO `adm_role` (`id_adm_role`, `role_name`, `description`, `id_adm_tenement`, `parent_id_adm_role`, `role_type`, `is_system`) VALUES
	(1, 'SUPER_ADMIN', '超级管理员', NULL, NULL, 'ADMIN', 1),
	(2, 'CMDB_ADMIN', 'CMDB管理员', NULL, NULL, 'ADMIN', 0),
	(3, 'PLUGIN_ADMIN', '插件管理员', NULL, NULL, 'ADMIN', 0),
	(4, 'IDC_ARCHITECT', '基础架构规划-IDC', NULL, NULL, 'ADMIN', 0),
	(5, 'NETWORK_ARCHITECT', '基础架构规划-网络', NULL, NULL, 'ADMIN', 0),
	(6, 'APP_ARCHITECT', '应用架构师', NULL, NULL, 'ADMIN', 0),
	(7, 'OPS-PROD', '生产环境运维', NULL, NULL, 'ADMIN', 0),
	(8, 'OPS-TEST', '测试环境运维', NULL, NULL, 'ADMIN', 0),
	(9, 'DEVELOPER', '开发人员', NULL, NULL, 'ADMIN', 0),
	(10, 'REGULAR', '普通用户', NULL, NULL, 'REGULAR', 0),
	(11, 'READONLY', '只读用户', NULL, NULL, 'READONLY', 0);

INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `encrypted_password`, `description`, `id_adm_tenement`, `action_flag`, `is_system`) VALUES
	(1, 'admin', 'admin','$2a$10$Gh3WDwZ8kFpxbmo/h.oywuN.LuYwgrlx53ZeG.mz7P4eKgct7IYZm', 'admin', NULL, 0, 1);

INSERT INTO `adm_role_user` (`id_adm_role_user`, `id_adm_role`, `id_adm_user`, `is_system`) VALUES
    ('1', '1', 1, 1);

INSERT INTO `adm_menu` (`id_adm_menu`, `name`, `other_name`, `seq_no`, `parent_id_adm_menu`) VALUES
(1, 'DATA_QUERY', '数据查询', 1, NULL),
(2, 'DATA_MANAGEMENT', '数据管理', 2, NULL),
(4, 'VIEW_MANAGEMENT', '视图管理', 4, NULL),
(5, 'ADMIN', '系统', 5, NULL),
(6, 'DESIGNING_CI_DATA_ENQUIRY', 'CI数据查询', 6, 1),
(7, 'DESIGNING_CI_INTEGRATED_QUERY_EXECUTION', 'CI数据综合查询', 7, 1),
(8, 'CMDB_DESIGNING_ENUM_ENQUIRY', '枚举数据查询', 8, 1),
(9, 'DESIGNING_CI_DATA_MANAGEMENT', 'CI数据管理', 9, 2),
(10, 'DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT', 'CI综合查询管理', 10, 2),
(11, 'CMDB_DESIGNING_ENUM_MANAGEMENT', '枚举数据管理', 11, 2),
(16, 'IDC_PLANNING_DESIGN', 'IDC规划设计', 16, 4),
(17, 'IDC_RESOURCE_PLANNING', 'IDC资源规划', 17, 4),
(18, 'APPLICATION_ARCHITECTURE_DESIGN', '应用架构设计', 18, 4),
(19, 'APPLICATION_DEPLOYMENT_DESIGN', '应用部署设计', 19, 4),
(20, 'ADMIN_CMDB_MODEL_MANAGEMENT', 'CMDB模型管理', 20, 5),
(21, 'ADMIN_PERMISSION_MANAGEMENT', '系统权限管理', 21, 5),
(22, 'CMDB_ADMIN_BASE_DATA_MANAGEMENT', '基础数据管理', 22, 5),
(23, 'ADMIN_QUERY_LOG', '日志查询', 23, 5),
(24, 'ADMIN_USER_PASSWORD_MANAGEMENT', '用户密码管理', 24, 5);

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
(24, 1, 24, 0);

SET FOREIGN_KEY_CHECKS=1;
