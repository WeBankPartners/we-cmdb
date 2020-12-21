
SET FOREIGN_KEY_CHECKS=0;
-- Dumping data for table wecmdb_bk.adm_basekey_cat: ~26 rows (approximately)
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
	(21, 'view_ci_type_id', '视图相关CI的ID', NULL, 1, NULL),
	(22, 'graph_view_root_ci_type', '视图根节点', NULL, 1, NULL),
	(23, 'graph_view_element_ci_type', '视图中图形元素', NULL, 1, 22),
	(24, 'graph_view_edge_node_level1', '视图中边的关联层级一', NULL, 1, 23),
	(25, 'graph_view_edge_node_level2', '视图中边的关联层级二', NULL, 1, 23),
	(26, 'graph_view_edge_node_level3', '视图中边的关联层级三', NULL, 1, 23);
/*!40000 ALTER TABLE `adm_basekey_cat` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_basekey_cat_type: ~59 rows (approximately)
/*!40000 ALTER TABLE `adm_basekey_cat_type` DISABLE KEYS */;
INSERT INTO `adm_basekey_cat_type` (`id_adm_basekey_cat_type`, `name`, `description`, `ci_type_id`, `type`) VALUES
	(1, 'sys', NULL, NULL, 1),
	(2, 'common', NULL, NULL, 2);
/*!40000 ALTER TABLE `adm_basekey_cat_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_basekey_code: ~199 rows (approximately)
/*!40000 ALTER TABLE `adm_basekey_code` DISABLE KEYS */;
INSERT INTO `adm_basekey_code` (`id_adm_basekey`, `id_adm_basekey_cat`, `code`, `value`, `group_code_id`, `code_description`, `seq_no`, `status`) VALUES
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
	(57, 11, 'confirm', '确认', NULL, NULL, 6, 'active');
/*!40000 ALTER TABLE `adm_basekey_code` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_ci_type_attr_base: ~12 rows (approximately)
/*!40000 ALTER TABLE `adm_ci_type_attr_base` DISABLE KEYS */;
INSERT INTO `adm_ci_type_attr_base` (`id_adm_ci_type_attr`, `id_adm_ci_type`, `name`, `description`, `input_type`, `property_name`, `property_type`, `length`, `reference_id`, `reference_name`, `reference_type`, `filter_rule`, `search_seq_no`, `display_type`, `display_seq_no`, `edit_is_null`, `edit_is_only`, `edit_is_hiden`, `edit_is_editable`, `is_defunct`, `special_logic`, `status`, `is_system`, `is_access_controlled`, `is_auto`, `auto_fill_rule`, `regular_expression_rule`, `is_delete_validate`, `is_refreshable`) VALUES
	(1, 1, '全局唯一ID', '全局唯一ID', 'text', 'guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(2, 1, '前全局唯一ID', '前一版本数据的guid', 'text', 'p_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 1),
	(3, 1, '根全局唯一ID', '原始数据guid', 'text', 'r_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(4, 1, '更新用户', '更新用户', 'text', 'updated_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 1),
	(5, 1, '更新日期', '更新日期', 'date', 'updated_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 1),
	(6, 1, '创建用户', '创建用户', 'text', 'created_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(7, 1, '创建日期', '创建日期', 'date', 'created_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(8, 1, '状态', '状态', 'select', 'state', 'int', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(9, 1, '唯一名称', '唯一名称', 'text', 'key_name', 'varchar', 1000, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 1, 0),
	(10, 1, '状态编码', '状态编码', 'text', 'state_code', 'varchar', 50, NULL, NULL, NULL, NULL, 2, 1, 2, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 1, 0),
	(11, 1, '确认日期', '确认日期', 'text', 'fixed_date', 'varchar', 19, NULL, NULL, NULL, NULL, 3, 1, 3, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(12, 1, '编码', '编码', 'text', 'code', 'varchar', 1000, NULL, NULL, NULL, NULL, 4, 1, 4, 0, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0);
/*!40000 ALTER TABLE `adm_ci_type_attr_base` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_menu: ~19 rows (approximately)
/*!40000 ALTER TABLE `adm_menu` DISABLE KEYS */;
INSERT INTO `adm_menu` (`id_adm_menu`, `name`, `other_name`, `url`, `seq_no`, `remark`, `parent_id_adm_menu`, `class_path`, `is_active`) VALUES
	(1, 'DATA_QUERY', '数据查询', NULL, 1, NULL, NULL, NULL, 0),
	(2, 'DATA_MANAGEMENT', '数据管理', NULL, 2, NULL, NULL, NULL, 0),
	(4, 'VIEW_MANAGEMENT', '视图管理', NULL, 4, NULL, NULL, NULL, 0),
	(5, 'ADMIN', '系统', NULL, 5, NULL, NULL, NULL, 0),
	(6, 'DESIGNING_CI_DATA_ENQUIRY', 'CI数据查询', NULL, 6, NULL, 1, NULL, 0),
	(7, 'DESIGNING_CI_INTEGRATED_QUERY_EXECUTION', 'CI数据综合查询', NULL, 7, NULL, 1, NULL, 0),
	(9, 'DESIGNING_CI_DATA_MANAGEMENT', 'CI数据管理', NULL, 9, NULL, 2, NULL, 0),
	(10, 'DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT', 'CI综合查询管理', NULL, 10, NULL, 2, NULL, 0),
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

-- Dumping data for table wecmdb_bk.adm_role: ~2 rows (approximately)
/*!40000 ALTER TABLE `adm_role` DISABLE KEYS */;
INSERT INTO `adm_role` (`id_adm_role`, `role_name`, `description`, `id_adm_tenement`, `parent_id_adm_role`, `role_type`, `is_system`) VALUES
	(1, 'SUPER_ADMIN', '超级管理员', NULL, NULL, 'ADMIN', 1),
	(13, 'SUB_SYSTEM', '子系统', NULL, NULL, 'ADMIN', 1);
/*!40000 ALTER TABLE `adm_role` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_role_menu: ~37 rows (approximately)
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

-- Dumping data for table wecmdb_bk.adm_role_user: ~0 rows (approximately)
/*!40000 ALTER TABLE `adm_role_user` DISABLE KEYS */;
INSERT INTO `adm_role_user` (`id_adm_role_user`, `id_adm_role`, `id_adm_user`, `is_system`) VALUES
	(1, 1, 1, 1);
/*!40000 ALTER TABLE `adm_role_user` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_state_transition: ~59 rows (approximately)
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

-- Dumping data for table wecmdb_bk.adm_tenement: ~0 rows (approximately)
/*!40000 ALTER TABLE `adm_tenement` DISABLE KEYS */;
/*!40000 ALTER TABLE `adm_tenement` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_user: ~0 rows (approximately)
/*!40000 ALTER TABLE `adm_user` DISABLE KEYS */;
INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `encrypted_password`, `description`, `id_adm_tenement`, `action_flag`, `is_system`) VALUES
	(1, 'admin', 'admin', '$2a$10$Gh3WDwZ8kFpxbmo/h.oywuN.LuYwgrlx53ZeG.mz7P4eKgct7IYZm', 'admin', NULL, 0, 1);
/*!40000 ALTER TABLE `adm_user` ENABLE KEYS */;

SET FOREIGN_KEY_CHECKS=1;
