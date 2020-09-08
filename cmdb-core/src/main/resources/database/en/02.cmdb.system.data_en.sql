
SET FOREIGN_KEY_CHECKS=0;
-- Dumping data for table wecmdb_bk.adm_basekey_cat: ~26 rows (approximately)
/*!40000 ALTER TABLE `adm_basekey_cat` DISABLE KEYS */;
INSERT INTO `adm_basekey_cat` (`id_adm_basekey_cat`, `cat_name`, `description`, `id_adm_role`, `id_adm_basekey_cat_type`, `group_type_id`) VALUES
	(1, 'ci_layer', 'Layer', NULL, 1, NULL),
	(2, 'ci_catalog', 'Catalog', NULL, 1, NULL),
	(3, 'ci_zoom_level', 'Zoom Level', NULL, 1, NULL),
	(4, 'ci_attr_type', 'Attr Type', NULL, 1, NULL),
	(5, 'ci_attr_enum_type', 'Enum Type', NULL, 1, NULL),
	(6, 'ci_attr_ref_type', 'Ref Type', NULL, 1, NULL),
	(7, 'ci_state_design', 'Design Status', NULL, 1, NULL),
	(8, 'ci_state_create', 'Resource Status', NULL, 1, NULL),
	(9, 'ci_state_start_stop', 'Runnable Resource Status', NULL, 1, NULL),
	(10, 'state_transition_operation', 'UI Operation for State Transition', NULL, 1, NULL),
	(11, 'state_transition_action', 'System Action for State Transition', NULL, 1, NULL),
	(12, 'tab_of_planning_design', 'Planning Design Panel Config', NULL, 1, NULL),
	(13, 'tab_query_of_planning_design', 'Planning Design Query Config', NULL, 1, 12),
	(14, 'tab_of_resourse_planning', 'Resource Planning Panel Config', NULL, 1, NULL),
	(15, 'tab_query_of_resourse_planning', 'Resource Planning Query Config', NULL, 1, 14),
	(16, 'tab_of_architecture_design', 'Architecture Design Panel Config', NULL, 1, NULL),
	(17, 'tab_query_of_architecture_design', 'Architecture Design Query Config', NULL, 1, 16),
	(18, 'tab_of_deploy_design', 'Deployment Design Panel Config', NULL, 1, NULL),
	(19, 'tab_query_of_deploy_design', 'Deployment Design Query Config', NULL, 1, 18),
	(20, 'view_config_params', 'View Config Params', NULL, 1, NULL),
	(21, 'view_ci_type_id', 'View CI Type Ids', NULL, 1, NULL),
	(22, 'graph_view_root_ci_type', 'Digram Root CI Types', NULL, 1, NULL),
	(23, 'graph_view_element_ci_type', 'Diagram Element CI Types', NULL, 1, 22),
	(24, 'graph_view_edge_node_level1', 'Diagram Edge Node Lv1', NULL, 1, 23),
	(25, 'graph_view_edge_node_level2', 'Diagram Edge Node Lv2', NULL, 1, 23),
	(26, 'graph_view_edge_node_level3', 'Diagram Edge Node Lv3', NULL, 1, 23);
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
	(27, 5, 'common', 'Public', NULL, 'Public Enum', 1, 'active'),
	(28, 5, 'private', 'Private', NULL, 'Private Enum', 2, 'active'),
	(29, 6, 'belong', 'Belongs to', NULL, 'belongs to', 1, 'active'),
	(30, 6, 'use', 'Uses', NULL, 'uses', 2, 'active'),
	(31, 6, 'depend', 'Depends on', NULL, 'depends on', 3, 'active'),
	(32, 6, 'relation', 'Associated with', NULL, 'associated with', 4, 'active'),
	(33, 6, 'realize', 'Realizes', NULL, 'realizes', 5, 'active'),
	(34, 7, 'new', 'New', NULL, NULL, 1, 'active'),
	(35, 7, 'update', 'Updated', NULL, NULL, 2, 'active'),
	(36, 7, 'deleted', 'Deleted', NULL, NULL, 3, 'active'),
	(37, 8, 'created', 'Created', NULL, NULL, 6, 'active'),
	(38, 8, 'changed', 'Changed', NULL, NULL, 7, 'active'),
	(39, 8, 'destroyed', 'Destroyed', NULL, NULL, 8, 'active'),
	(40, 9, 'created', 'Created', NULL, NULL, 1, 'active'),
	(41, 9, 'startup', 'Started', NULL, NULL, 2, 'active'),
	(42, 9, 'changed', 'Changed', NULL, NULL, 3, 'active'),
	(43, 9, 'stoped', 'Stopped', NULL, NULL, 4, 'active'),
	(44, 9, 'destroyed', 'Destroyed', NULL, NULL, 5, 'active'),
	(45, 10, 'insert', 'Insert', NULL, NULL, 1, 'active'),
	(46, 10, 'update', 'Update', NULL, NULL, 2, 'active'),
	(47, 10, 'discard', 'Discard', NULL, NULL, 3, 'active'),
	(48, 10, 'delete', 'Delete', NULL, NULL, 4, 'active'),
	(49, 10, 'confirm', 'Confirm', NULL, NULL, 5, 'active'),
	(50, 10, 'startup', 'Start', NULL, NULL, 6, 'active'),
	(51, 10, 'stop', 'Stop', NULL, NULL, 7, 'active'),
	(52, 11, 'insert', 'Insert', NULL, NULL, 1, 'active'),
	(53, 11, 'insert-update', 'Insert&Update', NULL, NULL, 2, 'active'),
	(54, 11, 'delete', 'delete', NULL, NULL, 3, 'active'),
	(55, 11, 'update-delete', 'Update&Delete', NULL, NULL, 4, 'active'),
	(56, 11, 'update', 'Update', NULL, NULL, 5, 'active'),
	(57, 11, 'confirm', 'Confirm', NULL, NULL, 6, 'active');
/*!40000 ALTER TABLE `adm_basekey_code` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_ci_type_attr_base: ~12 rows (approximately)
/*!40000 ALTER TABLE `adm_ci_type_attr_base` DISABLE KEYS */;
INSERT INTO `adm_ci_type_attr_base` (`id_adm_ci_type_attr`, `id_adm_ci_type`, `name`, `description`, `input_type`, `property_name`, `property_type`, `length`, `reference_id`, `reference_name`, `reference_type`, `filter_rule`, `search_seq_no`, `display_type`, `display_seq_no`, `edit_is_null`, `edit_is_only`, `edit_is_hiden`, `edit_is_editable`, `is_defunct`, `special_logic`, `status`, `is_system`, `is_access_controlled`, `is_auto`, `auto_fill_rule`, `regular_expression_rule`, `is_delete_validate`, `is_refreshable`) VALUES
	(1, 1, 'GUID', 'Global Unique ID', 'text', 'guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(2, 1, 'P-GUID', 'Global Unique Id for Previous Revision', 'text', 'p_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 1),
	(3, 1, 'R-GUID', 'Global Unique Id for Root(First) Revision', 'text', 'r_guid', 'varchar', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(4, 1, 'Updated by', 'User who made the latest data change', 'text', 'updated_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 1),
	(5, 1, 'Updated at', 'Time when the latest data change was made', 'date', 'updated_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 1),
	(6, 1, 'Created by', 'User who created the data record', 'text', 'created_by', 'varchar', 50, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(7, 1, 'Created at', 'Time when data record was created', 'date', 'created_date', 'datetime', 1, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 1, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(8, 1, 'Status', 'Status', 'select', 'state', 'int', 15, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(9, 1, 'Unique Name', 'Unique Name', 'text', 'key_name', 'varchar', 1000, NULL, NULL, NULL, NULL, 1, 1, 1, 0, 1, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 1, 0),
	(10, 1, 'Status Code', 'Status Code', 'text', 'state_code', 'varchar', 50, NULL, NULL, NULL, NULL, 2, 1, 2, 0, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 1, NULL, NULL, 1, 0),
	(11, 1, 'Confirmed at', 'Time when data changes were applied and confirmed', 'text', 'fixed_date', 'varchar', 19, NULL, NULL, NULL, NULL, 3, 1, 3, 1, 0, 0, 0, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0),
	(12, 1, 'Code', 'Code', 'text', 'code', 'varchar', 1000, NULL, NULL, NULL, NULL, 4, 1, 4, 0, 0, 0, 1, 0, NULL, 'notCreated', 1, 0, 0, NULL, NULL, 1, 0);
/*!40000 ALTER TABLE `adm_ci_type_attr_base` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_menu: ~19 rows (approximately)
/*!40000 ALTER TABLE `adm_menu` DISABLE KEYS */;
INSERT INTO `adm_menu` (`id_adm_menu`, `name`, `other_name`, `url`, `seq_no`, `remark`, `parent_id_adm_menu`, `class_path`, `is_active`) VALUES
	(1, 'DATA_QUERY', 'Query', NULL, 1, NULL, NULL, NULL, 0),
	(2, 'DATA_MANAGEMENT', 'Manage', NULL, 2, NULL, NULL, NULL, 0),
	(4, 'VIEW_MANAGEMENT', 'Views', NULL, 4, NULL, NULL, NULL, 0),
	(5, 'ADMIN', 'Configure', NULL, 5, NULL, NULL, NULL, 0),
	(6, 'DESIGNING_CI_DATA_ENQUIRY', 'For CI Data', NULL, 6, NULL, 1, NULL, 0),
	(7, 'DESIGNING_CI_INTEGRATED_QUERY_EXECUTION', 'For Composed Data', NULL, 7, NULL, 1, NULL, 0),
	(8, 'CMDB_DESIGNING_ENUM_ENQUIRY', 'For Enumerations', NULL, 8, NULL, 1, NULL, 0),
	(9, 'DESIGNING_CI_DATA_MANAGEMENT', 'CI Data', NULL, 9, NULL, 2, NULL, 0),
	(10, 'DESIGNING_CI_INTEGRATED_QUERY_MANAGEMENT', 'Composed Queries', NULL, 10, NULL, 2, NULL, 0),
	(11, 'CMDB_DESIGNING_ENUM_MANAGEMENT', 'Enumerations', NULL, 11, NULL, 2, NULL, 0),
	(16, 'IDC_PLANNING_DESIGN', 'IDC Planning', NULL, 16, NULL, 4, NULL, 0),
	(17, 'IDC_RESOURCE_PLANNING', 'IDC Resources', NULL, 17, NULL, 4, NULL, 0),
	(18, 'APPLICATION_ARCHITECTURE_DESIGN', 'App Architecture', NULL, 18, NULL, 4, NULL, 0),
	(19, 'APPLICATION_DEPLOYMENT_DESIGN', 'App Deployment', NULL, 19, NULL, 4, NULL, 0),
	(20, 'ADMIN_CMDB_MODEL_MANAGEMENT', 'Data Modeling', NULL, 20, NULL, 5, NULL, 0),
	(21, 'ADMIN_PERMISSION_MANAGEMENT', 'Permissions', NULL, 21, NULL, 5, NULL, 0),
	(22, 'CMDB_ADMIN_BASE_DATA_MANAGEMENT', 'Basic Data', NULL, 22, NULL, 5, NULL, 0),
	(23, 'ADMIN_QUERY_LOG', 'Logging', NULL, 23, NULL, 5, NULL, 0),
	(24, 'ADMIN_USER_PASSWORD_MANAGEMENT', 'Users', NULL, 24, NULL, 5, NULL, 0);
/*!40000 ALTER TABLE `adm_menu` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.adm_role: ~2 rows (approximately)
/*!40000 ALTER TABLE `adm_role` DISABLE KEYS */;
INSERT INTO `adm_role` (`id_adm_role`, `role_name`, `description`, `id_adm_tenement`, `parent_id_adm_role`, `role_type`, `is_system`) VALUES
	(1, 'SUPER_ADMIN', 'Super Admin', NULL, NULL, 'ADMIN', 1),
	(13, 'SUB_SYSTEM', 'Sub System', NULL, NULL, 'ADMIN', 1);
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
