SET FOREIGN_KEY_CHECKS=0;

/*!40000 ALTER TABLE `adm_user` DISABLE KEYS */;
INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `encrypted_password`, `description`, `id_adm_tenement`, `action_flag`, `is_system`) VALUES
	(1, 'admin', 'admin', '$2a$10$Gh3WDwZ8kFpxbmo/h.oywuN.LuYwgrlx53ZeG.mz7P4eKgct7IYZm', 'admin', NULL, 0, 1),
	(2, 'Jordan Zhang', 'jordan', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Admin', NULL, NULL, NULL),
	(3, 'Monkey', 'monkey', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Developer', NULL, NULL, NULL),
	(4, 'Chaney Liu', 'chaneyliu', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Architect', NULL, NULL, NULL);
/*!40000 ALTER TABLE `adm_user` ENABLE KEYS */;

/*!40000 ALTER TABLE `application_domain` DISABLE KEYS */;
INSERT INTO `application_domain` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0005_0000000001', NULL, '0005_0000000001', 'umadmin', '2020-03-21 15:54:41', 'umadmin', '2020-03-21 14:51:07', 34, 'CKY|存款业务域', '', 'CKY', '', '存款业务域', NULL),
	('0005_0000000002', NULL, '0005_0000000002', 'umadmin', '2020-03-21 15:54:41', 'umadmin', '2020-03-21 14:51:26', 34, 'DKY|贷款业务域', '', 'DKY', '', '贷款业务域', NULL),
	('0005_0000000003', NULL, '0005_0000000003', 'umadmin', '2020-03-21 15:53:58', 'umadmin', '2020-03-21 14:51:51', 34, 'CSY|公共服务域', '', 'CSY', '', '公共服务域', NULL),
	('0005_0000000004', NULL, '0005_0000000004', 'umadmin', '2020-03-21 14:53:45', 'umadmin', '2020-03-21 14:53:44', 34, 'MTY|管理工具域', '', 'MTY', '', '管理工具域', NULL),
	('0005_0000000005', NULL, '0005_0000000005', 'umadmin', '2020-03-21 15:54:22', 'umadmin', '2020-03-21 15:54:22', 34, 'PCY|桌面服务域', '', 'PCY', '', '桌面服务域', NULL);
/*!40000 ALTER TABLE `application_domain` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_instance` DISABLE KEYS */;
INSERT INTO `app_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_script`, `deploy_user`, `deploy_user_password`, `host_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `port`, `port_conflict`, `start_script`, `state_code`, `stop_script`, `storage`, `unit`, `variable_values`) VALUES
	('0050_0000000001', NULL, '0050_0000000001', 'umadmin', '2020-04-02 18:32:07', 'umadmin', '2020-03-22 08:38:38', 40, 'PRD_DEMO_CORE_APP_10.128.33.2:18080', '', '10.128.33.2:18080', '', '1', '', '', '/data/PRD_DEMO_CORE_APP', 'DEMO_CORE', '******', '0032_0000000001', '2', '10.128.33.2:28080', '28080', '18080', '10.128.33.2:18080', '/data/PRD_DEMO_CORE_APP', 'created', '/data/PRD_DEMO_CORE_APP', '10', '0048_0000000002', '='),
	('0050_0000000002', NULL, '0050_0000000002', 'umadmin', '2020-04-02 18:32:06', 'umadmin', '2020-03-22 08:47:56', 40, 'PRD_DEMO_CORE_APP_10.128.33.3:18080', '', '10.128.33.3:18080', '', '1', '', '', '/data/PRD_DEMO_CORE_APP', 'DEMO_CORE', '******', '0032_0000000002', '2', '10.128.33.3:28080', '28080', '18080', '10.128.33.3:18080', '/data/PRD_DEMO_CORE_APP', 'created', '/data/PRD_DEMO_CORE_APP', '10', '0048_0000000002', '=');
/*!40000 ALTER TABLE `app_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_system` DISABLE KEYS */;
INSERT INTO `app_system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_environment`, `legal_person`, `state_code`, `app_system_design`) VALUES
	('0046_0000000001', NULL, '0046_0000000001', 'umadmin', '2020-04-01 17:28:51', 'umadmin', '2020-03-22 07:39:33', 37, 'PRD_DEMO', '2020-03-27 04:08:59', 'PRD_DEMO', '', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000001');
/*!40000 ALTER TABLE `app_system` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_system$data_center` DISABLE KEYS */;
INSERT INTO `app_system$data_center` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0046_0000000001', '0022_0000000002', 1);
/*!40000 ALTER TABLE `app_system$data_center` ENABLE KEYS */;

/*!40000 ALTER TABLE `app_system_design` DISABLE KEYS */;
INSERT INTO `app_system_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `application_domain`, `app_system_design_id`, `data_center_design`, `name`, `state_code`) VALUES
	('0037_0000000001', '0037_0000000007', '0037_0000000001', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-22 07:02:40', 35, 'DEMO', '2020-04-02 18:27:04', 'DEMO', '', '0005_0000000003', '123456', '0012_0000000002', '演示系统', 'update');
/*!40000 ALTER TABLE `app_system_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `block_storage` DISABLE KEYS */;
INSERT INTO `block_storage` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `billing_cycle`, `block_storage_type`, `charge_type`, `disk_size`, `end_date`, `file_system`, `host_resource_instance`, `mount_point`, `name`, `state_code`) VALUES
	('0036_0000000001', NULL, '0036_0000000001', 'umadmin', '2020-04-02 18:23:35', 'umadmin', '2020-04-02 18:23:12', 37, 'host1_10.128.33.2_applog', '', 'applog', '', '', '', 'CLOUD_PREMIUM', 'POSTPAID_BY_HOUR', '50', '', 'EXT', '0032_0000000001', '/appdata', '日志盘', 'created');
/*!40000 ALTER TABLE `block_storage` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone` DISABLE KEYS */;
INSERT INTO `business_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone_design`, `business_zone_type`, `logic_business_zone`, `name`, `state_code`) VALUES
	('0028_0000000001', NULL, '0028_0000000001', 'umadmin', '2020-04-02 17:39:14', 'umadmin', '2020-03-21 17:49:30', 37, 'PCv1_SF_CS_1C0', '', '1C0', '', '0018_0000000001', 'GROUP', '', '公共服务', 'created'),
	('0028_0000000002', NULL, '0028_0000000002', 'umadmin', '2020-04-02 17:22:41', 'umadmin', '2020-03-21 18:03:20', 37, 'PCv1_SF_CS_1C2', '', '1C2', '', '0018_0000000001', 'NODE', '0028_0000000001', '公共服务', 'created'),
	('0028_0000000003', NULL, '0028_0000000003', 'umadmin', '2020-04-02 17:39:14', 'umadmin', '2020-03-21 18:04:30', 37, 'PCv1_MGMT_PC_1P0', '', '1P0', '', '0018_0000000003', 'GROUP', '', '桌面服务', 'created'),
	('0028_0000000004', NULL, '0028_0000000004', 'umadmin', '2020-04-02 17:22:41', 'umadmin', '2020-03-21 18:06:02', 37, 'PCv1_MGMT_PC_1P2', '', '1P2', '', '0018_0000000003', 'NODE', '0028_0000000003', '桌面服务', 'created'),
	('0028_0000000005', NULL, '0028_0000000005', 'umadmin', '2020-04-02 17:39:13', 'umadmin', '2020-03-21 18:06:47', 37, 'PCv1_MGMT_MT_1M0', '', '1M0', '', '0018_0000000002', 'GROUP', '', '管理工具', 'created'),
	('0028_0000000006', NULL, '0028_0000000006', 'umadmin', '2020-04-02 17:22:41', 'umadmin', '2020-03-21 18:08:38', 37, 'PCv1_MGMT_MT_1M2', '', '1M2', '', '0018_0000000002', 'NODE', '0028_0000000005', '管理工具', 'created');
/*!40000 ALTER TABLE `business_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone$network_segment` DISABLE KEYS */;
INSERT INTO `business_zone$network_segment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(135, '0028_0000000006', '0023_0000000011', 3),
	(136, '0028_0000000006', '0023_0000000009', 1),
	(137, '0028_0000000006', '0023_0000000012', 4),
	(138, '0028_0000000006', '0023_0000000010', 2),
	(139, '0028_0000000004', '0023_0000000008', 1),
	(140, '0028_0000000002', '0023_0000000007', 4),
	(141, '0028_0000000002', '0023_0000000005', 2),
	(142, '0028_0000000002', '0023_0000000006', 3),
	(143, '0028_0000000002', '0023_0000000004', 1),
	(144, '0028_0000000005', '0023_0000000009', 1),
	(145, '0028_0000000005', '0023_0000000011', 3),
	(146, '0028_0000000005', '0023_0000000010', 2),
	(147, '0028_0000000005', '0023_0000000012', 4),
	(148, '0028_0000000003', '0023_0000000008', 1),
	(149, '0028_0000000001', '0023_0000000007', 4),
	(150, '0028_0000000001', '0023_0000000004', 1),
	(151, '0028_0000000001', '0023_0000000005', 2),
	(152, '0028_0000000001', '0023_0000000006', 3);
/*!40000 ALTER TABLE `business_zone$network_segment` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone$network_zone` DISABLE KEYS */;
INSERT INTO `business_zone$network_zone` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(45, '0028_0000000006', '0024_0000000003', 1),
	(47, '0028_0000000004', '0024_0000000003', 1),
	(49, '0028_0000000002', '0024_0000000001', 1),
	(54, '0028_0000000005', '0024_0000000003', 1),
	(55, '0028_0000000003', '0024_0000000003', 1),
	(56, '0028_0000000001', '0024_0000000001', 1);
/*!40000 ALTER TABLE `business_zone$network_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone_design` DISABLE KEYS */;
INSERT INTO `business_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `network_zone_design`, `state_code`) VALUES
	('0018_0000000001', NULL, '0018_0000000001', 'umadmin', '2020-04-02 17:11:32', 'umadmin', '2020-03-21 14:52:34', 34, 'PCv1_SF_CS', '', 'CS', '', '0014_0000000001', 'new'),
	('0018_0000000002', NULL, '0018_0000000002', 'umadmin', '2020-04-02 17:11:32', 'umadmin', '2020-03-21 14:54:24', 34, 'PCv1_MGMT_MT', '', 'MT', '', '0014_0000000002', 'new'),
	('0018_0000000003', NULL, '0018_0000000003', 'umadmin', '2020-04-02 17:11:32', 'umadmin', '2020-03-21 15:55:01', 34, 'PCv1_MGMT_PC', '', 'PC', '', '0014_0000000002', 'new');
/*!40000 ALTER TABLE `business_zone_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone_design$application_domain` DISABLE KEYS */;
INSERT INTO `business_zone_design$application_domain` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(21, '0018_0000000003', '0005_0000000001', 5),
	(22, '0018_0000000003', '0005_0000000005', 1),
	(23, '0018_0000000003', '0005_0000000002', 4),
	(24, '0018_0000000003', '0005_0000000003', 3),
	(25, '0018_0000000003', '0005_0000000004', 2),
	(26, '0018_0000000002', '0005_0000000004', 1),
	(27, '0018_0000000001', '0005_0000000001', 5),
	(28, '0018_0000000001', '0005_0000000005', 1),
	(29, '0018_0000000001', '0005_0000000002', 4),
	(30, '0018_0000000001', '0005_0000000003', 3),
	(31, '0018_0000000001', '0005_0000000004', 2);
/*!40000 ALTER TABLE `business_zone_design$application_domain` ENABLE KEYS */;

/*!40000 ALTER TABLE `business_zone_design$network_segment_design` DISABLE KEYS */;
INSERT INTO `business_zone_design$network_segment_design` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(64, '0018_0000000003', '0013_0000000008', 1),
	(65, '0018_0000000002', '0013_0000000009', 1),
	(66, '0018_0000000002', '0013_0000000010', 3),
	(67, '0018_0000000002', '0013_0000000011', 2),
	(68, '0018_0000000002', '0013_0000000012', 4),
	(69, '0018_0000000001', '0013_0000000004', 1),
	(70, '0018_0000000001', '0013_0000000006', 3),
	(71, '0018_0000000001', '0013_0000000007', 4),
	(72, '0018_0000000001', '0013_0000000005', 2);
/*!40000 ALTER TABLE `business_zone_design$network_segment_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `cache_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `cache_resource_instance` DISABLE KEYS */;
INSERT INTO `cache_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `end_date`, `intranet_ip`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_type`, `resource_set`, `state_code`, `unit_type`, `user_name`, `user_password`) VALUES
	('0034_0000000001', NULL, '0034_0000000001', 'umadmin', '2020-04-02 18:08:48', 'umadmin', '2020-04-02 18:08:46', 40, 'redis1_10.128.34.2', '', '_10.128.34.2_10.128.34.2', '', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000005', '', '0031_0000000006', '6000', '', '', '10.128.34.2:6000', '6000', 'redis1', '0010_0000000005', '0009_0000000007', '0029_0000000012', 'created', '0002_0000000003', 'root', 'Abcd1234');
/*!40000 ALTER TABLE `cache_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `cloud_vendor` DISABLE KEYS */;
INSERT INTO `cloud_vendor` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0006_0000000001', NULL, '0006_0000000001', 'umadmin', '2020-03-21 16:48:43', 'umadmin', '2020-03-21 16:48:43', 34, 'QCLOUD|腾讯云', '', 'QCLOUD', '', '腾讯云', NULL),
	('0006_0000000002', NULL, '0006_0000000002', 'umadmin', '2020-03-26 00:53:27', 'umadmin', '2020-03-26 00:53:27', 34, 'HWCLOUD|华为云', '', 'HWCLOUD', '', '华为云', 'new');
/*!40000 ALTER TABLE `cloud_vendor` ENABLE KEYS */;

/*!40000 ALTER TABLE `cluster_node_type` DISABLE KEYS */;
INSERT INTO `cluster_node_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cluster_type`, `name`, `state_code`) VALUES
	('0008_0000000001', NULL, '0008_0000000001', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-21 18:15:02', 34, 'NODE|负载节点', '', 'NODE', '', '0007_0000000001', '负载节点', 'new'),
	('0008_0000000002', NULL, '0008_0000000002', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-21 18:16:07', 34, 'master|MYSQL master', '', 'master', '', '0007_0000000002', 'MYSQL master', 'new'),
	('0008_0000000003', NULL, '0008_0000000003', 'umadmin', '2020-04-02 18:05:16', 'umadmin', '2020-03-21 18:16:23', 34, 'ro|MYSQL slave', '', 'ro', '', '0007_0000000002', 'MYSQL slave', 'new'),
	('0008_0000000004', NULL, '0008_0000000004', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-22 07:01:54', 34, 'NODE|单一节点', '', 'NODE', '', '0007_0000000004', '单一节点', 'new'),
	('0008_0000000005', NULL, '0008_0000000005', 'umadmin', '2020-04-02 18:04:55', 'umadmin', '2020-04-02 18:04:55', 34, 'master|REDIS Master', '', 'master', '', '0007_0000000003', 'REDIS Master', 'new'),
	('0008_0000000006', NULL, '0008_0000000006', 'umadmin', '2020-04-02 18:05:41', 'umadmin', '2020-04-02 18:05:41', 34, 'slave|REDIS slave', '', 'slave', '', '0007_0000000003', 'REDIS slave', 'new');
/*!40000 ALTER TABLE `cluster_node_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `cluster_type` DISABLE KEYS */;
INSERT INTO `cluster_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`) VALUES
	('0007_0000000001', NULL, '0007_0000000001', 'umadmin', '2020-03-22 05:30:25', 'umadmin', '2020-03-21 18:12:00', 34, 'CLB|负载均衡', '', 'CLB', '', '0006_0000000001', '负载均衡', 'new'),
	('0007_0000000002', NULL, '0007_0000000002', 'umadmin', '2020-03-22 05:30:25', 'umadmin', '2020-03-21 18:13:50', 34, 'CMMS|MYSQL主从', '', 'CMMS', '', '0006_0000000001', 'MYSQL主从', 'new'),
	('0007_0000000003', NULL, '0007_0000000003', 'umadmin', '2020-03-22 05:30:25', 'umadmin', '2020-03-21 18:14:16', 34, 'CRMS|REDIS主从', '', 'CRMS', '', '0006_0000000001', 'REDIS主从', 'new'),
	('0007_0000000004', NULL, '0007_0000000004', 'umadmin', '2020-03-22 05:29:45', 'umadmin', '2020-03-22 05:29:45', 34, 'LBC|LB集群', '', 'LBC', '', '0006_0000000001', 'LB集群', 'new'),
	('0007_0000000005', NULL, '0007_0000000005', 'umadmin', '2020-03-22 05:30:15', 'umadmin', '2020-03-22 05:30:15', 34, 'MN|多节点', '', 'MN', '', '0006_0000000001', '多节点', 'new');
/*!40000 ALTER TABLE `cluster_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `data_center` DISABLE KEYS */;
INSERT INTO `data_center` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_uid`, `cloud_vendor`, `data_center_design`, `data_center_type`, `location`, `name`, `regional_data_center`, `state_code`) VALUES
	('0022_0000000001', NULL, '0022_0000000001', 'umadmin', '2020-03-24 01:44:57', 'umadmin', '2020-03-21 16:51:12', 37, 'GZP', '', 'GZP', '', '', '0006_0000000001', '0012_0000000002', 'REGION', 'Region=ap-guangzhou', '广州生产数据中心', '', 'created'),
	('0022_0000000002', NULL, '0022_0000000002', 'umadmin', '2020-03-24 01:44:57', 'umadmin', '2020-03-21 16:53:12', 37, 'GZP2', '', 'GZP2', '', '', '0006_0000000001', '0012_0000000002', 'ZONE', 'Region=ap-guangzhou;AvailableZone=ap-guangzhou-4', '广州生产2号数据中心', '', 'created');
/*!40000 ALTER TABLE `data_center` ENABLE KEYS */;

/*!40000 ALTER TABLE `data_center$deploy_environment` DISABLE KEYS */;
INSERT INTO `data_center$deploy_environment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(7, '0022_0000000002', '0003_0000000001', 1),
	(8, '0022_0000000001', '0003_0000000001', 1),
	(11, '0022_0000000003', '0003_0000000003', 1),
	(12, '0022_0000000003', '0003_0000000004', 2);
/*!40000 ALTER TABLE `data_center$deploy_environment` ENABLE KEYS */;

/*!40000 ALTER TABLE `data_center_design` DISABLE KEYS */;
INSERT INTO `data_center_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0012_0000000002', NULL, '0012_0000000002', 'umadmin', '2020-04-02 17:12:12', 'umadmin', '2020-03-21 10:43:34', 34, 'PCv1', '', 'PCv1', '公有云版本1', '公有云版本1', 'new');
/*!40000 ALTER TABLE `data_center_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `default_security_policy` DISABLE KEYS */;
INSERT INTO `default_security_policy` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `default_security_policy_design`, `policy_network_segment`, `owner_network_segment`, `port`, `protocol`, `security_policy_action`, `security_policy_type`, `state_code`, `security_policy_asset_id`) VALUES
	('0025_0000000001', NULL, '0025_0000000001', 'umadmin', '2020-04-02 17:18:46', 'umadmin', '2020-03-22 11:04:53', 37, 'GZP_SF_ACCEPT_GZP_SF_ingress_1-65535', '', 'GZP_SF_ACCEPT_GZP_SF_ingress_1-65535', '', '0015_0000000003', '0023_0000000002', '0023_0000000002', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', NULL),
	('0025_0000000002', NULL, '0025_0000000002', 'umadmin', '2020-04-02 17:18:46', 'umadmin', '2020-03-22 11:08:39', 37, 'GZP_SF_ACCEPT_GZP_SF_egress_1-65535', '', 'GZP_SF_ACCEPT_GZP_SF_egress_1-65535', '', '0015_0000000004', '0023_0000000002', '0023_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', NULL),
	('0025_0000000003', NULL, '0025_0000000003', 'umadmin', '2020-04-02 17:18:46', 'umadmin', '2020-03-22 11:08:55', 37, 'GZP_SF_ACCEPT_GZP2_MGMT_MT_APP_ingress_1-65535', '', 'GZP_SF_ACCEPT_GZP2_MGMT_MT_APP_ingress_1-65535', '', '0015_0000000005', '0023_0000000010', '0023_0000000002', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', NULL),
	('0025_0000000004', NULL, '0025_0000000004', 'umadmin', '2020-04-02 17:18:46', 'umadmin', '2020-03-22 11:09:19', 37, 'GZP_SF_ACCEPT_GZP2_MGMT_MT_APP_egress_1-65535', '', 'GZP_SF_ACCEPT_GZP2_MGMT_MT_APP_egress_1-65535', '', '0015_0000000006', '0023_0000000010', '0023_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', NULL),
	('0025_0000000005', NULL, '0025_0000000005', 'umadmin', '2020-04-02 17:18:45', 'umadmin', '2020-03-22 11:09:34', 37, 'GZP_MGMT_ACCEPT_GZP_MGMT_ingress_1-65535', '', 'GZP_MGMT_ACCEPT_GZP_MGMT_ingress_1-65535', '', '0015_0000000001', '0023_0000000003', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', NULL),
	('0025_0000000006', NULL, '0025_0000000006', 'umadmin', '2020-04-02 17:18:45', 'umadmin', '2020-03-22 11:09:53', 37, 'GZP_MGMT_ACCEPT_GZP_MGMT_egress_1-65535', '', 'GZP_MGMT_ACCEPT_GZP_MGMT_egress_1-65535', '', '0015_0000000002', '0023_0000000003', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', NULL),
	('0025_0000000007', NULL, '0025_0000000007', 'umadmin', '2020-04-02 17:18:45', 'umadmin', '2020-03-22 11:10:07', 37, 'GZP_MGMT_ACCEPT_GZP_SF_ingress_1-65535', '', 'GZP_MGMT_ACCEPT_GZP_SF_ingress_1-65535', '', '0015_0000000007', '0023_0000000002', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', NULL);
/*!40000 ALTER TABLE `default_security_policy` ENABLE KEYS */;

/*!40000 ALTER TABLE `default_security_policy_design` DISABLE KEYS */;
INSERT INTO `default_security_policy_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `policy_network_segment_design`, `owner_network_segment_design`, `port`, `protocol`, `security_policy_action`, `security_policy_type`, `state_code`) VALUES
	('0015_0000000001', NULL, '0015_0000000001', 'umadmin', '2020-04-02 17:17:40', 'umadmin', '2020-03-21 16:25:55', 34, '   MGMT ACCEPT MGMT ingress1-65535', '', 'MGMT ACCEPT MGMT ingress', '', '0013_0000000003', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000002', NULL, '0015_0000000002', 'umadmin', '2020-04-02 17:17:40', 'umadmin', '2020-03-21 16:34:44', 34, '   MGMT ACCEPT MGMT egress1-65535', '', 'MGMT ACCEPT MGMT egress', '', '0013_0000000003', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000003', NULL, '0015_0000000003', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-21 16:35:25', 34, '   SF ACCEPT SF ingress1-65535', '', 'SF ACCEPT SF ingress', '', '0013_0000000002', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000004', NULL, '0015_0000000004', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-21 16:35:48', 34, '   SF ACCEPT SF egress1-65535', '', 'SF ACCEPT SF egress', '', '0013_0000000002', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000005', NULL, '0015_0000000005', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-21 16:36:33', 34, '   SF ACCEPT MGMT_MT_APP ingress1-65535', '', 'SF ACCEPT MGMT_MT_APP ingress', '', '0013_0000000010', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000006', NULL, '0015_0000000006', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-21 16:37:19', 34, '   SF ACCEPT MGMT_MT_APP egress1-65535', '', 'SF ACCEPT MGMT_MT_APP egress', '', '0013_0000000010', '0013_0000000002', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000007', NULL, '0015_0000000007', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-22 10:52:32', 34, '   MGMT ACCEPT SF ingress1-65535', '', 'MGMT ACCEPT SF ingress', '', '0013_0000000002', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new');
/*!40000 ALTER TABLE `default_security_policy_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `deploy_environment` DISABLE KEYS */;
INSERT INTO `deploy_environment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0003_0000000001', NULL, '0003_0000000001', 'umadmin', '2020-03-21 16:49:23', 'umadmin', '2020-03-21 16:49:23', 34, 'PRD|生产环境', '', 'PRD', '', '生产环境', NULL),
	('0003_0000000002', NULL, '0003_0000000002', 'umadmin', '2020-03-21 16:49:38', 'umadmin', '2020-03-21 16:49:38', 34, 'DR|容灾环境', '', 'DR', '', '容灾环境', NULL),
	('0003_0000000003', NULL, '0003_0000000003', 'umadmin', '2020-03-21 16:50:18', 'umadmin', '2020-03-21 16:50:17', 34, 'STGi|UAT环境i', '', 'STGi', '', 'UAT环境i', NULL),
	('0003_0000000004', NULL, '0003_0000000004', 'umadmin', '2020-03-21 16:50:35', 'umadmin', '2020-03-21 16:50:35', 34, 'STGk|UAT环境k', '', 'STGk', '', 'UAT环境k', NULL);
/*!40000 ALTER TABLE `deploy_environment` ENABLE KEYS */;

/*!40000 ALTER TABLE `deploy_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `deploy_package` ENABLE KEYS */;

/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` DISABLE KEYS */;
/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` ENABLE KEYS */;

/*!40000 ALTER TABLE `diff_configuration` DISABLE KEYS */;
INSERT INTO `diff_configuration` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `state_code`, `variable_name`, `variable_value`) VALUES
	('0044_0000000001', NULL, '0044_0000000001', 'SYS_PLATFORM', '2020-03-24 05:51:43', 'SYS_PLATFORM', '2020-03-24 02:12:15', 34, 'jmx_hostname', NULL, 'jmx_hostname', NULL, 'new', 'jmx_hostname', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":32,\\"parentRs\\":{\\"attrId\\":927,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":31,\\"parentRs\\":{\\"attrId\\":546,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":31,\\"parentRs\\":{\\"attrId\\":521,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000002', NULL, '0044_0000000002', 'SYS_PLATFORM', '2020-03-24 05:51:51', 'SYS_PLATFORM', '2020-03-24 02:12:15', 34, 'jmx_port', NULL, 'jmx_port', NULL, 'new', 'jmx_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":50,\\"parentRs\\":{\\"attrId\\":929,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000003', NULL, '0044_0000000003', 'SYS_PLATFORM', '2020-03-24 05:52:15', 'SYS_PLATFORM', '2020-03-24 02:12:16', 34, 'port', NULL, 'port', NULL, 'new', 'port', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":50,\\"parentRs\\":{\\"attrId\\":928,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000005', NULL, '0044_0000000005', 'SYS_PLATFORM', '2020-03-24 06:30:35', 'SYS_PLATFORM', '2020-03-24 02:12:16', 34, 'db_host_port', NULL, 'db_host_port', NULL, 'new', 'db_host_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"key_name\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"PRD_DEMO_CORE_DB1\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":958,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000006', NULL, '0044_0000000006', 'SYS_PLATFORM', '2020-03-24 02:12:16', 'SYS_PLATFORM', '2020-03-24 02:12:16', 34, 'db_name', NULL, 'db_name', NULL, 'new', 'db_name', ''),
	('0044_0000000007', NULL, '0044_0000000007', 'SYS_PLATFORM', '2020-03-24 02:12:16', 'SYS_PLATFORM', '2020-03-24 02:12:16', 34, 'db_username', NULL, 'db_username', NULL, 'new', 'db_username', ''),
	('0044_0000000008', NULL, '0044_0000000008', 'SYS_PLATFORM', '2020-03-24 02:12:16', 'SYS_PLATFORM', '2020-03-24 02:12:16', 34, 'db_password', NULL, 'db_password', NULL, 'new', 'db_password', ''),
	('0044_0000000009', NULL, '0044_0000000009', 'SYS_PLATFORM', '2020-03-24 05:58:19', 'SYS_PLATFORM', '2020-03-24 05:56:03', 34, 'db_host_ip', NULL, 'db_host_ip', NULL, 'new', 'db_host_ip', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"key_name\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"PRD_DEMO_CORE_DB1\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":33,\\"parentRs\\":{\\"attrId\\":957,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":31,\\"parentRs\\":{\\"attrId\\":581,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":31,\\"parentRs\\":{\\"attrId\\":521,\\"isReferedFromParent\\":1}}]"}]');
/*!40000 ALTER TABLE `diff_configuration` ENABLE KEYS */;

/*!40000 ALTER TABLE `host_resource_instance` DISABLE KEYS */;
INSERT INTO `host_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `intranet_ip`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_system`, `resource_instance_type`, `resource_set`, `state_code`, `storage`, `unit_type`, `user_name`, `user_password`) VALUES
	('0032_0000000001', NULL, '0032_0000000001', 'umadmin', '2020-04-02 17:59:16', 'umadmin', '2020-03-22 05:06:52', 40, 'host1_10.128.33.2', '', 'host1_10.128.33.2', '', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000001', '', '', '0031_0000000003', '22', '', '', '10.128.33.2:30000', '30000', 'host1', '0010_0000000001', '0011_0000000001', '0009_0000000001', '0029_0000000011', 'created', '50', '0002_0000000001', 'root', '******'),
	('0032_0000000002', NULL, '0032_0000000002', 'umadmin', '2020-04-02 17:59:15', 'umadmin', '2020-03-22 06:18:15', 40, 'host2_10.128.33.3', '', 'host2_10.128.33.3', '', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000001', '', '', '0031_0000000004', '22', '', '', '10.128.33.3:30000', '30000', 'host2', '0010_0000000001', '0011_0000000001', '0009_0000000001', '0029_0000000011', 'created', '50', '0002_0000000001', 'root', '******'),
	('0032_0000000003', NULL, '0032_0000000003', 'umadmin', '2020-04-02 17:57:44', 'umadmin', '2020-03-22 06:36:32', 40, 'host1_10.128.202.2', '', 'host1_10.128.202.2', '', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000001', '', '', '0031_0000000011', '22', '', '', '10.128.202.2:30000', '30000', 'host1', '0010_0000000002', '0011_0000000001', '0009_0000000001', '0029_0000000016', 'created', '50', '0002_0000000001', 'root', '******'),
	('0032_0000000004', NULL, '0032_0000000004', 'umadmin', '2020-04-02 17:58:09', 'umadmin', '2020-03-22 06:38:05', 40, 'host2_10.128.202.3', '', 'host2_10.128.202.3', '', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000001', '', '', '0031_0000000012', '22', '', '', '10.128.202.3:30000', '30000', 'host2', '0010_0000000002', '0011_0000000001', '0009_0000000001', '0029_0000000016', 'created', '50', '0002_0000000001', 'root', '******');
/*!40000 ALTER TABLE `host_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `invoke` DISABLE KEYS */;
INSERT INTO `invoke` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `access_control`, `invoked_unit`, `invoke_design`, `invoke_type`, `invoke_unit`, `state_code`) VALUES
	('0049_0000000001', NULL, '0049_0000000001', 'umadmin', '2020-04-02 18:28:47', 'umadmin', '2020-03-22 12:33:53', 37, 'PRD_DEMO_CLIENT_BROWER-->--PRD_DEMO_CORE_LB', '', 'PRD_DEMO_CLIENT_BROWER-->--PRD_DEMO_CORE_LB', '', '', '0048_0000000001', '0040_0000000001', '同步调用', '0048_0000000004', 'created'),
	('0049_0000000002', NULL, '0049_0000000002', 'umadmin', '2020-04-02 18:28:47', 'umadmin', '2020-03-22 12:34:19', 37, 'PRD_DEMO_CORE_LB-->--PRD_DEMO_CORE_APP', '', 'PRD_DEMO_CORE_LB-->--PRD_DEMO_CORE_APP', '', '', '0048_0000000002', '0040_0000000002', '同步调用', '0048_0000000001', 'created'),
	('0049_0000000003', NULL, '0049_0000000003', 'umadmin', '2020-04-02 18:28:47', 'umadmin', '2020-03-22 12:34:57', 37, 'PRD_DEMO_CORE_APP-->--PRD_DEMO_CORE_DB', '', 'PRD_DEMO_CORE_APP-->--PRD_DEMO_CORE_DB', '', '', '0048_0000000003', '0040_0000000003', '同步调用', '0048_0000000002', 'created');
/*!40000 ALTER TABLE `invoke` ENABLE KEYS */;

/*!40000 ALTER TABLE `invoke_design` DISABLE KEYS */;
INSERT INTO `invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_unit_design`, `invoke_type`, `invoke_unit_design`, `resource_set_invoke_design`, `state_code`) VALUES
	('0040_0000000001', NULL, '0040_0000000001', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-22 07:20:08', 34, 'DEMO_CLIENT_BROWER-->--DEMO_CORE_LB', '2020-04-02 18:27:04', 'BROWER-->--LB', '', '0039_0000000003', '同步调用', '0039_0000000004', '0021_0000000002', 'new'),
	('0040_0000000002', NULL, '0040_0000000002', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:23:41', 34, 'DEMO_CORE_LB-->--DEMO_CORE_APP', '2020-04-02 18:27:04', 'LB-->--APP', '', '0039_0000000001', '同步调用', '0039_0000000003', '0021_0000000008', 'new'),
	('0040_0000000003', NULL, '0040_0000000003', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:23:56', 34, 'DEMO_CORE_APP-->--DEMO_CORE_DB', '2020-04-02 18:27:04', 'APP-->--DB', '', '0039_0000000002', '同步调用', '0039_0000000001', '0021_0000000007', 'new'),
	('0040_0000000004', NULL, '0040_0000000004', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-31 11:30:25', 34, 'DEMO_BATCH_APP-->--DEMO_CORE_DB', '2020-04-02 18:27:04', 'APP-->--DB', '', '0039_0000000002', '同步调用', '0039_0000000006', '0021_0000000007', 'new');
/*!40000 ALTER TABLE `invoke_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `ip_address` DISABLE KEYS */;
INSERT INTO `ip_address` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `ip_address_usage`, `network_segment`, `state_code`, `used_record`) VALUES
	('0031_0000000001', NULL, '0031_0000000001', 'umadmin', '2020-04-02 17:16:09', 'umadmin', '2020-03-22 04:46:06', 37, '10.128.32.2_GZP2_SF_CS_LB', '', '10.128.32.2', '', '资源', '0023_0000000004', 'created', '未使用'),
	('0031_0000000002', NULL, '0031_0000000002', 'umadmin', '2020-04-02 17:16:09', 'umadmin', '2020-03-22 04:46:28', 37, '10.128.32.3_GZP2_SF_CS_LB', '', '10.128.32.3', '', '资源', '0023_0000000004', 'created', '未使用'),
	('0031_0000000003', NULL, '0031_0000000003', 'umadmin', '2020-04-02 17:59:17', 'umadmin', '2020-03-22 04:47:37', 37, '10.128.33.2_GZP2_SF_CS_APP', '', '10.128.33.2', '', '资源', '0023_0000000005', 'created', '未使用'),
	('0031_0000000004', NULL, '0031_0000000004', 'umadmin', '2020-04-02 17:59:16', 'umadmin', '2020-03-22 04:47:47', 37, '10.128.33.3_GZP2_SF_CS_APP', '', '10.128.33.3', '', '资源', '0023_0000000005', 'created', '未使用'),
	('0031_0000000005', NULL, '0031_0000000005', 'umadmin', '2020-04-02 17:16:08', 'umadmin', '2020-03-22 04:48:18', 37, '10.128.34.3_GZP2_SF_CS_CACHE', '', '10.128.34.3', '', '资源', '0023_0000000006', 'created', '未使用'),
	('0031_0000000006', NULL, '0031_0000000006', 'umadmin', '2020-04-02 17:16:08', 'umadmin', '2020-03-22 04:48:31', 37, '10.128.34.2_GZP2_SF_CS_CACHE', '', '10.128.34.2', '', '资源', '0023_0000000006', 'created', '未使用'),
	('0031_0000000007', NULL, '0031_0000000007', 'umadmin', '2020-04-02 17:16:08', 'umadmin', '2020-03-22 04:49:01', 37, '10.128.34.130_GZP2_SF_CS_RDB', '', '10.128.34.130', '', '资源', '0023_0000000007', 'created', '未使用'),
	('0031_0000000008', NULL, '0031_0000000008', 'umadmin', '2020-04-02 17:16:08', 'umadmin', '2020-03-22 04:50:39', 37, '10.128.34.131_GZP2_SF_CS_RDB', '', '10.128.34.131', '', '资源', '0023_0000000007', 'created', '未使用'),
	('0031_0000000009', NULL, '0031_0000000009', 'umadmin', '2020-04-02 17:16:07', 'umadmin', '2020-03-22 04:51:00', 37, '10.128.200.2_GZP2_MGMT_PC_VDI', '', '10.128.200.2', '', '资源', '0023_0000000008', 'created', '未使用'),
	('0031_0000000010', NULL, '0031_0000000010', 'umadmin', '2020-04-02 17:16:07', 'umadmin', '2020-03-22 04:51:12', 37, '10.128.200.3_GZP2_MGMT_PC_VDI', '', '10.128.200.3', '', '资源', '0023_0000000008', 'created', '未使用'),
	('0031_0000000011', NULL, '0031_0000000011', 'umadmin', '2020-04-02 17:16:06', 'umadmin', '2020-03-22 04:51:32', 37, '10.128.202.2_GZP2_MGMT_MT_APP', '', '10.128.202.2', '', '资源', '0023_0000000010', 'created', '未使用'),
	('0031_0000000012', NULL, '0031_0000000012', 'umadmin', '2020-04-02 17:16:06', 'umadmin', '2020-03-22 04:52:31', 37, '10.128.202.3_GZP2_MGMT_MT_APP', '', '10.128.202.3', '', '资源', '0023_0000000010', 'created', '未使用'),
	('0031_0000000013', NULL, '0031_0000000013', 'umadmin', '2020-04-02 17:16:05', 'umadmin', '2020-03-22 04:52:57', 37, '10.128.203.2_GZP2_MGMT_MT_CACHE', '', '10.128.203.2', '', '资源', '0023_0000000011', 'created', '未使用'),
	('0031_0000000014', NULL, '0031_0000000014', 'umadmin', '2020-04-02 17:16:05', 'umadmin', '2020-03-22 04:53:12', 37, '10.128.203.3_GZP2_MGMT_MT_CACHE', '', '10.128.203.3', '', '资源', '0023_0000000011', 'created', '未使用'),
	('0031_0000000015', NULL, '0031_0000000015', 'umadmin', '2020-04-02 17:16:05', 'umadmin', '2020-03-22 04:53:27', 37, '10.128.203.130_GZP2_MGMT_MT_RDB', '', '10.128.203.130', '', '资源', '0023_0000000012', 'created', '未使用'),
	('0031_0000000016', NULL, '0031_0000000016', 'umadmin', '2020-04-02 17:16:05', 'umadmin', '2020-03-22 04:53:43', 37, '10.128.203.131_GZP2_MGMT_MT_RDB', '', '10.128.203.131', '', '资源', '0023_0000000012', 'created', '未使用'),
	('0031_0000000017', NULL, '0031_0000000017', 'umadmin', '2020-04-02 17:16:07', 'umadmin', '2020-03-22 04:54:13', 37, '10.128.201.2_GZP2_MGMT_MT_LB', '', '10.128.201.2', '', '资源', '0023_0000000009', 'created', '未使用'),
	('0031_0000000018', NULL, '0031_0000000018', 'umadmin', '2020-04-02 17:16:07', 'umadmin', '2020-03-22 04:54:32', 37, '10.128.201.3_GZP2_MGMT_MT_LB', '', '10.128.201.3', '', '资源', '0023_0000000009', 'created', '未使用'),
	('0031_0000000019', NULL, '0031_0000000019', 'umadmin', '2020-04-02 17:16:07', 'umadmin', '2020-04-01 17:17:31', 37, '10.128.201.4_GZP2_MGMT_MT_LB', '', '10.128.201.4', '', '资源', '0023_0000000009', 'created', '未使用'),
	('0031_0000000020', NULL, '0031_0000000020', 'umadmin', '2020-04-02 17:16:07', 'umadmin', '2020-04-01 17:17:31', 37, '10.128.201.5_GZP2_MGMT_MT_LB', '', '10.128.201.5', '', '资源', '0023_0000000009', 'created', '未使用');
/*!40000 ALTER TABLE `ip_address` ENABLE KEYS */;

/*!40000 ALTER TABLE `lb_instance` DISABLE KEYS */;
INSERT INTO `lb_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `lb_listener_asset_id`, `lb_resource_instance`, `port`, `state_code`, `unit`) VALUES
	('0053_0000000001', NULL, '0053_0000000001', 'umadmin', '2020-04-02 18:38:16', 'umadmin', '2020-03-22 12:19:26', 37, 'PRD_DEMO_CORE_LB_PRD_DEMO_CORE_LB_10.128.32.2:80', '', 'PRD_DEMO_CORE_LB_10.128.32.2:80', '', '', '0035_0000000001', '80', 'created', '0048_0000000001');
/*!40000 ALTER TABLE `lb_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `lb_resource_instance` DISABLE KEYS */;
INSERT INTO `lb_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `end_date`, `intranet_ip`, `master_resource_instance`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_type`, `resource_set`, `state_code`, `unit_type`) VALUES
	('0035_0000000001', NULL, '0035_0000000001', 'umadmin', '2020-04-02 18:11:25', 'umadmin', '2020-03-22 07:02:05', 37, 'lb1_10.128.32.2', '', 'lb1_10.128.32.2', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000004', '', '0031_0000000001', '', '10.128.32.2:80', '80', 'lb1', '0009_0000000009', '0029_0000000010', 'created', '0002_0000000004');
/*!40000 ALTER TABLE `lb_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `legal_person` DISABLE KEYS */;
INSERT INTO `legal_person` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0004_0000000001', NULL, '0004_0000000001', 'umadmin', '2020-03-22 07:39:27', 'umadmin', '2020-03-22 07:39:26', 34, 'WEBANK|微众银行', '', 'WEBANK', '', '微众银行', 'new');
/*!40000 ALTER TABLE `legal_person` ENABLE KEYS */;

/*!40000 ALTER TABLE `manage_role` DISABLE KEYS */;
INSERT INTO `manage_role` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `email`, `name`, `phone`, `state_code`) VALUES
	('0001_0000000001', NULL, '0001_0000000001', 'umadmin', '2020-03-21 08:53:48', 'umadmin', '2020-03-21 08:44:15', 34, 'SUBPER_ADMIN|超级管理员', '', 'SUBPER_ADMIN', '无', 'demo@xxx.com', '超级管理员', '13811111111', 'new');
/*!40000 ALTER TABLE `manage_role` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_segment` DISABLE KEYS */;
INSERT INTO `network_segment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center`, `f_network_segment`, `gateway_ip`, `mask`, `name`, `network_segment_design`, `network_segment_usage`, `route_table_asset_id`, `state_code`, `subnet_asset_id`, `vpc_asset_id`, `private_route_table`, `security_group_asset_id`) VALUES
	('0023_0000000001', NULL, '0023_0000000001', 'umadmin', '2020-04-02 17:17:42', 'umadmin', '2020-03-21 16:55:39', 37, '10.128.0.0/16_RDC_GZP', '', '10.128.0.0/16', 'GZP', '0022_0000000001', '', '', '16', 'GZP', '0013_0000000001', 'RDC', '', 'created', '', '', 'N', NULL),
	('0023_0000000002', NULL, '0023_0000000002', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-21 16:58:54', 37, '10.128.0.0/17_VPC_GZP_SF', '', '10.128.0.0/17', 'GZP_SF', '0022_0000000001', '0023_0000000001', '', '17', 'GZP_SF', '0013_0000000002', 'VPC', '', 'created', '', '', 'Y', NULL),
	('0023_0000000003', NULL, '0023_0000000003', 'umadmin', '2020-04-02 17:17:40', 'umadmin', '2020-03-21 17:08:06', 37, '10.128.192.0/19_VPC_GZP_MGMT', '', '10.128.192.0/19', 'GZP_MGMT', '0022_0000000001', '0023_0000000001', '', '19', 'GZP_MGMT', '0013_0000000003', 'VPC', '', 'created', '', '', 'Y', NULL),
	('0023_0000000004', NULL, '0023_0000000004', 'umadmin', '2020-04-02 17:17:39', 'umadmin', '2020-03-21 17:10:24', 37, '10.128.32.0/24_SUBNET_GZP2_SF_CS_LB', '', '10.128.32.0/24', 'GZP2_SF_CS_LB', '0022_0000000002', '0023_0000000002', '', '24', 'GZP2_SF_CS_LB', '0013_0000000004', 'SUBNET', '', 'created', '', '', 'Y', NULL),
	('0023_0000000005', NULL, '0023_0000000005', 'umadmin', '2020-04-02 17:17:38', 'umadmin', '2020-03-21 17:11:58', 37, '10.128.33.0/24_SUBNET_GZP2_SF_CS_APP', '', '10.128.33.0/24', 'GZP2_SF_CS_APP', '0022_0000000002', '0023_0000000002', '', '24', 'GZP2_SF_CS_APP', '0013_0000000005', 'SUBNET', '', 'created', '', '', 'N', NULL),
	('0023_0000000006', NULL, '0023_0000000006', 'umadmin', '2020-04-02 17:17:38', 'umadmin', '2020-03-21 17:12:56', 37, '10.128.34.0/25_SUBNET_GZP2_SF_CS_CACHE', '', '10.128.34.0/25', 'GZP2_SF_CS_CACHE', '0022_0000000002', '0023_0000000002', '', '25', 'GZP2_SF_CS_CACHE', '0013_0000000006', 'SUBNET', '', 'created', '', '', 'N', NULL),
	('0023_0000000007', NULL, '0023_0000000007', 'umadmin', '2020-04-02 17:17:38', 'umadmin', '2020-03-21 17:13:42', 37, '10.128.34.128/25_SUBNET_GZP2_SF_CS_RDB', '', '10.128.34.128/25', 'GZP2_SF_CS_RDB', '0022_0000000002', '0023_0000000002', '', '25', 'GZP2_SF_CS_RDB', '0013_0000000007', 'SUBNET', '', 'created', '', '', 'N', NULL),
	('0023_0000000008', NULL, '0023_0000000008', 'umadmin', '2020-04-02 17:17:37', 'umadmin', '2020-03-21 17:15:03', 37, '10.128.200.0/24_SUBNET_GZP2_MGMT_PC_VDI', '', '10.128.200.0/24', 'GZP2_MGMT_PC_VDI', '0022_0000000002', '0023_0000000003', '', '24', 'GZP2_MGMT_PC_VDI', '0013_0000000008', 'SUBNET', '', 'created', '', '', 'Y', NULL),
	('0023_0000000009', NULL, '0023_0000000009', 'umadmin', '2020-04-02 17:17:37', 'umadmin', '2020-03-21 17:16:23', 37, '10.128.201.0/24_SUBNET_GZP2_MGMT_MT_LB', '', '10.128.201.0/24', 'GZP2_MGMT_MT_LB', '0022_0000000002', '0023_0000000003', '', '24', 'GZP2_MGMT_MT_LB', '0013_0000000009', 'SUBNET', '', 'created', '', '', 'Y', NULL),
	('0023_0000000010', NULL, '0023_0000000010', 'umadmin', '2020-04-02 17:17:37', 'umadmin', '2020-03-21 17:17:30', 37, '10.128.202.0/24_SUBNET_GZP2_MGMT_MT_APP', '', '10.128.202.0/24', 'GZP2_MGMT_MT_APP', '0022_0000000002', '0023_0000000003', '', '24', 'GZP2_MGMT_MT_APP', '0013_0000000010', 'SUBNET', '', 'created', '', '', 'Y', NULL),
	('0023_0000000011', NULL, '0023_0000000011', 'umadmin', '2020-04-02 17:17:36', 'umadmin', '2020-03-21 17:18:13', 37, '10.128.203.0/25_SUBNET_GZP2_MGMT_MT_CACHE', '', '10.128.203.0/25', 'GZP2_MGMT_MT_CACHE', '0022_0000000002', '0023_0000000003', '', '25', 'GZP2_MGMT_MT_CACHE', '0013_0000000011', 'SUBNET', '', 'created', '', '', 'N', NULL),
	('0023_0000000012', NULL, '0023_0000000012', 'umadmin', '2020-04-02 17:17:35', 'umadmin', '2020-03-21 17:19:06', 37, '10.128.203.128/25_SUBNET_GZP2_MGMT_MT_RDB', '', '10.128.203.128/25', 'GZP2_MGMT_MT_RDB', '0022_0000000002', '0023_0000000003', '', '25', 'GZP2_MGMT_MT_RDB', '0013_0000000012', 'SUBNET', '', 'created', '', '', 'N', NULL);
/*!40000 ALTER TABLE `network_segment` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_segment_design` DISABLE KEYS */;
INSERT INTO `network_segment_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center_design`, `f_network_segment_design`, `mask`, `name`, `network_segment_usage`, `state_code`, `private_route_table`) VALUES
	('0013_0000000001', NULL, '0013_0000000001', 'umadmin', '2020-04-02 17:17:42', 'umadmin', '2020-03-21 14:21:08', 34, '10.*.0.0/16_RDC|_PC', '', '10.*.0.0/16', '', '0012_0000000002', '', '16', 'PC', 'RDC', 'new', 'N'),
	('0013_0000000002', NULL, '0013_0000000002', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-21 14:28:53', 34, '10.*.0.0/17_VPC|PC_SF', '', '10.*.0.0/17', '', '0012_0000000002', '0013_0000000001', '17', 'SF', 'VPC', 'new', 'Y'),
	('0013_0000000003', NULL, '0013_0000000003', 'umadmin', '2020-04-02 17:17:40', 'umadmin', '2020-03-21 14:29:42', 34, '10.*.192.0/19_VPC|PC_MGMT', '', '10.*.192.0/19', '', '0012_0000000002', '0013_0000000001', '19', 'MGMT', 'VPC', 'new', 'Y'),
	('0013_0000000004', NULL, '0013_0000000004', 'umadmin', '2020-04-02 17:17:39', 'umadmin', '2020-03-21 14:35:52', 34, '10.*.[0,32,64,96].0/24_SUBNET|SF_SF_CS_LB', '', '10.*.[0,32,64,96].0/24', '', '0012_0000000002', '0013_0000000002', '24', 'SF_CS_LB', 'SUBNET', 'new', 'Y'),
	('0013_0000000005', NULL, '0013_0000000005', 'umadmin', '2020-04-02 17:17:38', 'umadmin', '2020-03-21 14:36:59', 34, '10.*.[1,33,65,97].0/24_SUBNET|SF_SF_CS_APP', '', '10.*.[1,33,65,97].0/24', '', '0012_0000000002', '0013_0000000002', '24', 'SF_CS_APP', 'SUBNET', 'new', 'N'),
	('0013_0000000006', NULL, '0013_0000000006', 'umadmin', '2020-04-02 17:17:38', 'umadmin', '2020-03-21 14:37:58', 34, '10.*.[2,34,65,98].0/25_SUBNET|SF_SF_CS_CACHE', '', '10.*.[2,34,65,98].0/25', '', '0012_0000000002', '0013_0000000002', '25', 'SF_CS_CACHE', 'SUBNET', 'new', 'N'),
	('0013_0000000007', NULL, '0013_0000000007', 'umadmin', '2020-04-02 17:17:38', 'umadmin', '2020-03-21 14:38:47', 34, '10.*.[2,34,65,98].128/25_SUBNET|SF_SF_CS_RDB', '', '10.*.[2,34,65,98].128/25', '', '0012_0000000002', '0013_0000000002', '25', 'SF_CS_RDB', 'SUBNET', 'new', 'N'),
	('0013_0000000008', NULL, '0013_0000000008', 'umadmin', '2020-04-02 17:17:37', 'umadmin', '2020-03-21 14:40:00', 34, '10.*.[192,200,208,216].0/24_SUBNET|MGMT_MGMT_PC_VDI', '', '10.*.[192,200,208,216].0/24', '', '0012_0000000002', '0013_0000000003', '24', 'MGMT_PC_VDI', 'SUBNET', 'new', 'Y'),
	('0013_0000000009', NULL, '0013_0000000009', 'umadmin', '2020-04-02 17:17:37', 'umadmin', '2020-03-21 14:43:39', 34, '10.*.[193,201,209,217].0/24_SUBNET|MGMT_MGMT_MT_LB', '', '10.*.[193,201,209,217].0/24', '', '0012_0000000002', '0013_0000000003', '24', 'MGMT_MT_LB', 'SUBNET', 'new', 'Y'),
	('0013_0000000010', NULL, '0013_0000000010', 'umadmin', '2020-04-02 17:17:37', 'umadmin', '2020-03-21 14:44:47', 34, '10.*.[194,202,210,218].0/24_SUBNET|MGMT_MGMT_MT_APP', '', '10.*.[194,202,210,218].0/24', '', '0012_0000000002', '0013_0000000003', '24', 'MGMT_MT_APP', 'SUBNET', 'new', 'Y'),
	('0013_0000000011', NULL, '0013_0000000011', 'umadmin', '2020-04-02 17:17:36', 'umadmin', '2020-03-21 14:45:49', 34, '10.*.[195,203,211,219].0/25_SUBNET|MGMT_MGMT_MT_CACHE', '', '10.*.[195,203,211,219].0/25', '', '0012_0000000002', '0013_0000000003', '25', 'MGMT_MT_CACHE', 'SUBNET', 'new', 'N'),
	('0013_0000000012', NULL, '0013_0000000012', 'umadmin', '2020-04-02 17:17:35', 'umadmin', '2020-03-21 14:46:41', 34, '10.*.[195,203,211,219].128/25_SUBNET|MGMT_MGMT_MT_RDB', '', '10.*.[195,203,211,219].128/25', '', '0012_0000000002', '0013_0000000003', '25', 'MGMT_MT_RDB', 'SUBNET', 'new', 'N');
/*!40000 ALTER TABLE `network_segment_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_zone` DISABLE KEYS */;
INSERT INTO `network_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center`, `network_segment`, `network_zone_design`, `network_zone_layer`, `state_code`) VALUES
	('0024_0000000001', NULL, '0024_0000000001', 'umadmin', '2020-04-02 17:18:23', 'umadmin', '2020-03-21 17:27:31', 37, 'GZP_SF', '', 'SF', 'SF', '0022_0000000001', '0023_0000000002', '0014_0000000001', 'CORE', 'created'),
	('0024_0000000003', NULL, '0024_0000000003', 'umadmin', '2020-04-02 17:18:23', 'umadmin', '2020-03-21 17:42:26', 37, 'GZP_MGMT', '', 'MGMT', 'MGMT', '0022_0000000001', '0023_0000000003', '0014_0000000002', 'LINK', 'created');
/*!40000 ALTER TABLE `network_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_zone_design` DISABLE KEYS */;
INSERT INTO `network_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center_design`, `network_segment_design`, `network_zone_layer`, `state_code`) VALUES
	('0014_0000000001', NULL, '0014_0000000001', 'umadmin', '2020-04-02 17:02:52', 'umadmin', '2020-03-21 14:47:47', 34, 'PCv1_SF', '', 'SF', '', '0012_0000000002', '0013_0000000002', 'CORE', 'new'),
	('0014_0000000002', NULL, '0014_0000000002', 'umadmin', '2020-04-02 17:02:51', 'umadmin', '2020-03-21 14:48:10', 34, 'PCv1_MGMT', '', 'MGMT', '', '0012_0000000002', '0013_0000000003', 'LINK', 'new');
/*!40000 ALTER TABLE `network_zone_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_zone_link` DISABLE KEYS */;
INSERT INTO `network_zone_link` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `max_concurrent`, `netband_width`, `network_zone_1`, `network_zone_2`, `network_zone_link_design`, `network_zone_link_type`, `state_code`) VALUES
	('0026_0000000001', NULL, '0026_0000000001', 'umadmin', '2020-04-02 17:19:03', 'umadmin', '2020-03-22 10:08:43', 37, 'GZP_MGMT_link_GZP_SF', '', 'MGMT_link_SF', '', '', '10000', '100', '0024_0000000003', '0024_0000000001', '0016_0000000001', 'PEERCONNECTION', 'created');
/*!40000 ALTER TABLE `network_zone_link` ENABLE KEYS */;

/*!40000 ALTER TABLE `network_zone_link_design` DISABLE KEYS */;
INSERT INTO `network_zone_link_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `network_zone_design_1`, `network_zone_design_2`, `network_zone_link_type`, `state_code`) VALUES
	('0016_0000000001', NULL, '0016_0000000001', 'umadmin', '2020-04-02 17:07:18', 'umadmin', '2020-03-21 16:22:57', 34, 'PCv1_MGMT_link_PCv1_SF', '', 'MGMT-link-SF', '', '0014_0000000002', '0014_0000000001', 'PEERCONNECTION', 'new');
/*!40000 ALTER TABLE `network_zone_link_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `node_type` DISABLE KEYS */;
INSERT INTO `node_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0054_0000000001', NULL, '0054_0000000001', 'umadmin', '2020-03-22 05:54:56', 'umadmin', '2020-03-22 05:54:56', 34, 'GROUP|逻辑分组', '', 'GROUP', '', '逻辑分组', 'new'),
	('0054_0000000002', NULL, '0054_0000000002', 'umadmin', '2020-03-22 05:55:08', 'umadmin', '2020-03-22 05:55:08', 34, 'NODE|物理节点', '', 'NODE', '', '物理节点', 'new');
/*!40000 ALTER TABLE `node_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `rdb_instance` DISABLE KEYS */;
INSERT INTO `rdb_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_script`, `deploy_user`, `deploy_user_password`, `memory`, `port`, `rdb_resource_instance`, `regular_backup_asset_id`, `rollback_script`, `state_code`, `storage`, `unit`, `upgrade_script`, `variable_values`) VALUES
	('0051_0000000001', NULL, '0051_0000000001', 'umadmin', '2020-04-02 18:36:35', 'umadmin', '2020-03-22 12:15:06', 37, 'PRD_DEMO_CORE_DB_10.128.34.130:3306', '', '10.128.34.130:3306/DB|master', '', '1', '', '', NULL, 'democore', '******', '2', '3306', '0033_0000000001', '', NULL, 'created', '20', '0048_0000000003', NULL, '=');
/*!40000 ALTER TABLE `rdb_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `rdb_resource_instance` DISABLE KEYS */;
INSERT INTO `rdb_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `intranet_ip`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_system`, `resource_instance_type`, `resource_set`, `state_code`, `storage`, `unit_type`, `user_name`, `user_password`) VALUES
	('0033_0000000001', NULL, '0033_0000000001', 'umadmin', '2020-04-02 18:00:50', 'umadmin', '2020-03-22 06:58:40', 40, 'mysql1_10.128.34.130', '', 'mysql1_10.128.34.130', '', '', '', '', 'POSTPAID_BY_HOUR', '0008_0000000002', '', '', '0031_0000000007', '3306', '', '', '10.128.34.130:3306', '3306', 'mysql1', '0010_0000000003', '0011_0000000003', '0009_0000000003', '0029_0000000013', 'created', '50', '0002_0000000002', 'root', '******');
/*!40000 ALTER TABLE `rdb_resource_instance` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_instance_spec` DISABLE KEYS */;
INSERT INTO `resource_instance_spec` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`, `unit_type`) VALUES
	('0010_0000000001', NULL, '0010_0000000001', 'umadmin', '2020-04-02 18:03:40', 'umadmin', '2020-03-22 05:01:38', 34, '1C2G|CVM_1核2G', '', '1C2G', '', '0006_0000000001', 'CVM_1核2G', 'new', '0002_0000000001'),
	('0010_0000000002', NULL, '0010_0000000002', 'umadmin', '2020-04-02 18:03:39', 'umadmin', '2020-03-22 05:02:08', 34, '2C4G|CVM_2核4G', '', '2C4G', '', '0006_0000000001', 'CVM_2核4G', 'new', '0002_0000000001'),
	('0010_0000000003', NULL, '0010_0000000003', 'umadmin', '2020-04-02 18:03:24', 'umadmin', '2020-03-22 06:54:13', 34, '2000|MYSQL_2G内存', '', '2000', '', '0006_0000000001', 'MYSQL_2G内存', 'new', '0002_0000000002'),
	('0010_0000000004', NULL, '0010_0000000004', 'umadmin', '2020-04-02 18:03:24', 'umadmin', '2020-03-22 06:54:26', 34, '4000|MYSQL_4G内存', '', '4000', '', '0006_0000000001', 'MYSQL_4G内存', 'new', '0002_0000000002'),
	('0010_0000000005', NULL, '0010_0000000005', 'umadmin', '2020-04-02 18:02:43', 'umadmin', '2020-04-02 18:02:43', 34, '2000|REDIS_2G内存', '', '2000', '', '0006_0000000001', 'REDIS_2G内存', 'new', '0002_0000000003'),
	('0010_0000000006', NULL, '0010_0000000006', 'umadmin', '2020-04-02 18:03:06', 'umadmin', '2020-04-02 18:03:06', 34, '4000|REDIS_4G内存', '', '4000', '', '0006_0000000001', 'REDIS_4G内存', 'new', '0002_0000000003');
/*!40000 ALTER TABLE `resource_instance_spec` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_instance_system` DISABLE KEYS */;
INSERT INTO `resource_instance_system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`, `unit_type`) VALUES
	('0011_0000000001', NULL, '0011_0000000001', 'umadmin', '2020-03-22 05:00:37', 'umadmin', '2020-03-22 05:00:37', 34, 'img-8toqc6s3|CentOs 7.4 64位', '', 'img-8toqc6s3', '', '0006_0000000001', 'CentOs 7.4 64位', 'new', '0002_0000000001'),
	('0011_0000000002', NULL, '0011_0000000002', 'umadmin', '2020-03-22 05:03:08', 'umadmin', '2020-03-22 05:03:08', 34, 'img-6ns5om13|CentOs 6.8 64位', '', 'img-6ns5om13', '', '0006_0000000001', 'CentOs 6.8 64位', 'new', '0002_0000000001'),
	('0011_0000000003', NULL, '0011_0000000003', 'umadmin', '2020-03-22 06:55:24', 'umadmin', '2020-03-22 06:55:24', 34, '5.6|MYSQL5.6', '', '5.6', '', '0006_0000000001', 'MYSQL5.6', 'new', '0002_0000000002'),
	('0011_0000000004', NULL, '0011_0000000004', 'umadmin', '2020-03-22 06:55:41', 'umadmin', '2020-03-22 06:55:41', 34, '5.7|MYSQL5.7', '', '5.7', '', '0006_0000000001', 'MYSQL5.7', 'new', '0002_0000000002');
/*!40000 ALTER TABLE `resource_instance_system` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_instance_type` DISABLE KEYS */;
INSERT INTO `resource_instance_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`, `unit_type`) VALUES
	('0009_0000000001', NULL, '0009_0000000001', 'umadmin', '2020-03-22 04:59:37', 'umadmin', '2020-03-22 04:59:37', 34, 'standard|标准CVM', '', 'standard', '', '0006_0000000001', '标准CVM', 'new', '0002_0000000001'),
	('0009_0000000002', NULL, '0009_0000000002', 'umadmin', '2020-03-22 05:04:07', 'umadmin', '2020-03-22 05:04:07', 34, 'memory|内存型CVM', '', 'memory', '', '0006_0000000001', '内存型CVM', 'new', '0002_0000000001'),
	('0009_0000000003', NULL, '0009_0000000003', 'umadmin', '2020-03-22 06:41:26', 'umadmin', '2020-03-22 06:40:47', 34, '0|异步同步类型', '', '0', '', '0006_0000000001', '异步同步类型', 'new', '0002_0000000002'),
	('0009_0000000004', NULL, '0009_0000000004', 'umadmin', '2020-03-22 06:41:19', 'umadmin', '2020-03-22 06:41:19', 34, '2|强同步类型', '', '2', '', '0006_0000000001', '强同步类型', 'new', '0002_0000000002'),
	('0009_0000000005', NULL, '0009_0000000005', 'umadmin', '2020-03-22 06:42:20', 'umadmin', '2020-03-22 06:42:20', 34, '3|3.2主从类型', '', '3', '', '0006_0000000001', '3.2主从类型', 'new', '0002_0000000003'),
	('0009_0000000006', NULL, '0009_0000000006', 'umadmin', '2020-03-22 06:42:34', 'umadmin', '2020-03-22 06:42:34', 34, '4|3.2集群类型', '', '4', '', '0006_0000000001', '3.2集群类型', 'new', '0002_0000000003'),
	('0009_0000000007', NULL, '0009_0000000007', 'umadmin', '2020-03-22 06:43:20', 'umadmin', '2020-03-22 06:43:20', 34, '6|4.0主从类型', '', '6', '', '0006_0000000001', '4.0主从类型', 'new', '0002_0000000003'),
	('0009_0000000008', NULL, '0009_0000000008', 'umadmin', '2020-03-22 06:43:39', 'umadmin', '2020-03-22 06:43:39', 34, '7|4.0集群类型', '', '7', '', '0006_0000000001', '4.0集群类型', 'new', '0002_0000000003'),
	('0009_0000000009', NULL, '0009_0000000009', 'umadmin', '2020-03-22 06:49:01', 'umadmin', '2020-03-22 06:49:01', 34, 'internal_lb|内网类型', '', 'internal_lb', '', '0006_0000000001', '内网类型', 'new', '0002_0000000004'),
	('0009_0000000010', NULL, '0009_0000000010', 'umadmin', '2020-03-22 06:49:32', 'umadmin', '2020-03-22 06:49:32', 34, 'external_lb|外网类型', '', 'external_lb', '', '0006_0000000001', '外网类型', 'new', '0002_0000000005');
/*!40000 ALTER TABLE `resource_instance_type` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set` DISABLE KEYS */;
INSERT INTO `resource_set` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone`, `cluster_type`, `logic_resource_set`, `manage_role`, `name`, `resource_set_design`, `resource_set_type`, `state_code`) VALUES
	('0029_0000000001', NULL, '0029_0000000001', 'umadmin', '2020-04-02 17:54:42', 'umadmin', '2020-03-21 18:17:10', 37, 'PCv1_SF_CS_1C0_1A0', '', '1A0', '', '0028_0000000001', '0007_0000000001', '', '0001_0000000001', '0', '0019_0000000001', 'GROUP', 'created'),
	('0029_0000000002', NULL, '0029_0000000002', 'umadmin', '2020-04-02 17:54:41', 'umadmin', '2020-03-21 18:18:00', 37, 'PCv1_SF_CS_1C0_1L0', '', '1L0', '', '0028_0000000001', '0007_0000000004', '', '0001_0000000001', '0', '0019_0000000004', 'GROUP', 'created'),
	('0029_0000000003', NULL, '0029_0000000003', 'umadmin', '2020-04-02 17:54:41', 'umadmin', '2020-03-22 04:13:25', 37, 'PCv1_SF_CS_1C0_1R0', '', '1R0', '', '0028_0000000001', '0007_0000000002', '', '0001_0000000001', '0', '0019_0000000003', 'GROUP', 'created'),
	('0029_0000000004', NULL, '0029_0000000004', 'umadmin', '2020-04-02 17:54:41', 'umadmin', '2020-03-22 05:28:17', 37, 'PCv1_SF_CS_1C0_1C0', '', '1C0', '', '0028_0000000001', '0007_0000000003', '', '0001_0000000001', '0', '0019_0000000002', 'GROUP', 'created'),
	('0029_0000000005', NULL, '0029_0000000005', 'umadmin', '2020-04-02 17:54:41', 'umadmin', '2020-03-22 05:30:53', 37, 'PCv1_MGMT_PC_1P0_1V0', '', '1V0', '', '0028_0000000003', '0007_0000000005', '', '0001_0000000001', '0', '0019_0000000009', 'GROUP', 'created'),
	('0029_0000000006', NULL, '0029_0000000006', 'umadmin', '2020-04-02 17:54:41', 'umadmin', '2020-03-22 05:31:35', 37, 'PCv1_MGMT_MT_1M0_1L0', '', '1L0', '', '0028_0000000005', '0007_0000000004', '', '0001_0000000001', '0', '0019_0000000008', 'GROUP', 'created'),
	('0029_0000000007', NULL, '0029_0000000007', 'umadmin', '2020-04-02 17:54:40', 'umadmin', '2020-03-22 05:32:26', 37, 'PCv1_MGMT_MT_1M0_1A0', '', '1A0', '', '0028_0000000005', '0007_0000000001', '', '0001_0000000001', '0', '0019_0000000005', 'GROUP', 'created'),
	('0029_0000000008', NULL, '0029_0000000008', 'umadmin', '2020-04-02 17:54:40', 'umadmin', '2020-03-22 05:33:13', 37, 'PCv1_MGMT_MT_1M0_1C0', '', '1C0', '', '0028_0000000005', '0007_0000000003', '', '0001_0000000001', '0', '0019_0000000006', 'GROUP', 'created'),
	('0029_0000000009', NULL, '0029_0000000009', 'umadmin', '2020-04-02 17:52:56', 'umadmin', '2020-03-22 05:33:57', 37, 'PCv1_MGMT_MT_1M0_1R0', '', '1R0', '', '0028_0000000005', '0007_0000000002', '', '0001_0000000001', '3', '0019_0000000007', 'GROUP', 'created'),
	('0029_0000000010', NULL, '0029_0000000010', 'umadmin', '2020-04-02 17:30:53', 'umadmin', '2020-03-22 05:35:07', 37, 'PCv1_SF_CS_1C2_1L2', '', '1L2', '', '0028_0000000002', '0007_0000000004', '0029_0000000002', '0001_0000000001', '2', '0019_0000000004', 'NODE', 'created'),
	('0029_0000000011', NULL, '0029_0000000011', 'umadmin', '2020-04-02 17:30:53', 'umadmin', '2020-03-22 05:37:16', 37, 'PCv1_SF_CS_1C2_1A2', '', '1A2', '', '0028_0000000002', '0007_0000000001', '0029_0000000001', '0001_0000000001', '2', '0019_0000000001', 'NODE', 'created'),
	('0029_0000000012', NULL, '0029_0000000012', 'umadmin', '2020-04-02 17:30:53', 'umadmin', '2020-03-22 05:39:22', 37, 'PCv1_SF_CS_1C2_1C2', '', '1C2', '', '0028_0000000002', '0007_0000000003', '0029_0000000004', '0001_0000000001', '2', '0019_0000000002', 'NODE', 'created'),
	('0029_0000000013', NULL, '0029_0000000013', 'umadmin', '2020-04-02 17:30:53', 'umadmin', '2020-03-22 05:41:27', 37, 'PCv1_SF_CS_1C2_1R2', '', '1R2', '', '0028_0000000002', '0007_0000000002', '0029_0000000003', '0001_0000000001', '2', '0019_0000000003', 'NODE', 'created'),
	('0029_0000000014', NULL, '0029_0000000014', 'umadmin', '2020-04-02 17:30:53', 'umadmin', '2020-03-22 05:43:21', 37, 'PCv1_MGMT_PC_1P2_1V2', '', '1V2', '', '0028_0000000004', '0007_0000000005', '0029_0000000005', '0001_0000000001', '2', '0019_0000000009', 'NODE', 'created'),
	('0029_0000000015', NULL, '0029_0000000015', 'umadmin', '2020-04-02 17:30:53', 'umadmin', '2020-03-22 06:33:07', 37, 'PCv1_MGMT_MT_1M2_1L2', '', '1L2', '', '0028_0000000006', '0007_0000000004', '0029_0000000006', '0001_0000000001', '2', '0019_0000000008', 'NODE', 'created'),
	('0029_0000000016', NULL, '0029_0000000016', 'umadmin', '2020-04-02 17:30:52', 'umadmin', '2020-03-22 06:33:44', 37, 'PCv1_MGMT_MT_1M2_1A2', '', '1A2', '', '0028_0000000006', '0007_0000000001', '0029_0000000007', '0001_0000000001', '2', '0019_0000000005', 'NODE', 'created'),
	('0029_0000000017', NULL, '0029_0000000017', 'umadmin', '2020-04-02 17:30:52', 'umadmin', '2020-03-22 06:34:16', 37, 'PCv1_MGMT_MT_1M2_1C2', '', '1C2', '', '0028_0000000006', '0007_0000000003', '0029_0000000008', '0001_0000000001', '2', '0019_0000000006', 'NODE', 'created'),
	('0029_0000000018', NULL, '0029_0000000018', 'umadmin', '2020-04-02 17:30:52', 'umadmin', '2020-03-22 06:34:49', 37, 'PCv1_MGMT_MT_1M2_1R2', '', '1R2', '', '0028_0000000006', '0007_0000000002', '0029_0000000009', '0001_0000000001', '2', '0019_0000000007', 'NODE', 'created');
/*!40000 ALTER TABLE `resource_set` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set$deploy_environment` DISABLE KEYS */;
INSERT INTO `resource_set$deploy_environment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(51, '0029_0000000018', '0003_0000000001', 1),
	(52, '0029_0000000017', '0003_0000000001', 1),
	(53, '0029_0000000016', '0003_0000000001', 1),
	(54, '0029_0000000015', '0003_0000000001', 1),
	(55, '0029_0000000014', '0003_0000000001', 1),
	(56, '0029_0000000013', '0003_0000000001', 1),
	(57, '0029_0000000012', '0003_0000000001', 1),
	(58, '0029_0000000011', '0003_0000000001', 1),
	(59, '0029_0000000010', '0003_0000000001', 1),
	(60, '0029_0000000009', '0003_0000000001', 1),
	(61, '0029_0000000008', '0003_0000000001', 1),
	(62, '0029_0000000007', '0003_0000000001', 1),
	(63, '0029_0000000006', '0003_0000000001', 1),
	(64, '0029_0000000005', '0003_0000000001', 1),
	(65, '0029_0000000004', '0003_0000000001', 1),
	(66, '0029_0000000003', '0003_0000000001', 1),
	(67, '0029_0000000002', '0003_0000000001', 1),
	(68, '0029_0000000001', '0003_0000000001', 1);
/*!40000 ALTER TABLE `resource_set$deploy_environment` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set$network_segment` DISABLE KEYS */;
INSERT INTO `resource_set$network_segment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(47, '0029_0000000018', '0023_0000000012', 1),
	(48, '0029_0000000017', '0023_0000000011', 1),
	(49, '0029_0000000016', '0023_0000000010', 1),
	(50, '0029_0000000015', '0023_0000000009', 1),
	(51, '0029_0000000014', '0023_0000000008', 1),
	(52, '0029_0000000013', '0023_0000000007', 1),
	(53, '0029_0000000012', '0023_0000000006', 1),
	(54, '0029_0000000011', '0023_0000000005', 1),
	(55, '0029_0000000010', '0023_0000000004', 1),
	(56, '0029_0000000009', '0023_0000000012', 1),
	(57, '0029_0000000008', '0023_0000000011', 1),
	(58, '0029_0000000007', '0023_0000000010', 1),
	(59, '0029_0000000006', '0023_0000000009', 1),
	(60, '0029_0000000005', '0023_0000000008', 1),
	(61, '0029_0000000004', '0023_0000000006', 1),
	(62, '0029_0000000003', '0023_0000000007', 1),
	(63, '0029_0000000002', '0023_0000000004', 1),
	(64, '0029_0000000001', '0023_0000000005', 1);
/*!40000 ALTER TABLE `resource_set$network_segment` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set_design` DISABLE KEYS */;
INSERT INTO `resource_set_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone_design`, `network_segment_design`, `state_code`, `unit_type`) VALUES
	('0019_0000000001', NULL, '0019_0000000001', 'umadmin', '2020-04-02 17:11:56', 'umadmin', '2020-03-21 15:05:09', 34, 'PCv1_SF_CS_APP', '', 'APP', '', '0018_0000000001', '0013_0000000005', 'new', '0002_0000000001'),
	('0019_0000000002', NULL, '0019_0000000002', 'umadmin', '2020-04-02 17:11:56', 'umadmin', '2020-03-21 15:06:14', 34, 'PCv1_SF_CS_CACHE', '', 'CACHE', '', '0018_0000000001', '0013_0000000006', 'new', '0002_0000000003'),
	('0019_0000000003', NULL, '0019_0000000003', 'umadmin', '2020-04-02 17:11:56', 'umadmin', '2020-03-21 15:06:27', 34, 'PCv1_SF_CS_RDB', '', 'RDB', '', '0018_0000000001', '0013_0000000007', 'new', '0002_0000000002'),
	('0019_0000000004', NULL, '0019_0000000004', 'umadmin', '2020-04-02 17:11:55', 'umadmin', '2020-03-21 15:07:05', 34, 'PCv1_SF_CS_LB', '', 'LB', '', '0018_0000000001', '0013_0000000004', 'new', '0002_0000000004'),
	('0019_0000000005', NULL, '0019_0000000005', 'umadmin', '2020-04-02 17:11:55', 'umadmin', '2020-03-21 15:07:38', 34, 'PCv1_MGMT_MT_APP', '', 'APP', '', '0018_0000000002', '0013_0000000010', 'new', '0002_0000000001'),
	('0019_0000000006', NULL, '0019_0000000006', 'umadmin', '2020-04-02 17:11:55', 'umadmin', '2020-03-21 15:07:59', 34, 'PCv1_MGMT_MT_CACHE', '', 'CACHE', '', '0018_0000000002', '0013_0000000011', 'new', '0002_0000000003'),
	('0019_0000000007', NULL, '0019_0000000007', 'umadmin', '2020-04-02 17:11:55', 'umadmin', '2020-03-21 15:08:21', 34, 'PCv1_MGMT_MT_RDB', '', 'RDB', '', '0018_0000000002', '0013_0000000012', 'new', '0002_0000000002'),
	('0019_0000000008', NULL, '0019_0000000008', 'umadmin', '2020-04-02 17:11:55', 'umadmin', '2020-03-21 15:09:26', 34, 'PCv1_MGMT_MT_LB', '', 'LB', '', '0018_0000000002', '0013_0000000009', 'new', '0002_0000000004'),
	('0019_0000000009', NULL, '0019_0000000009', 'umadmin', '2020-04-02 17:11:54', 'umadmin', '2020-03-21 15:58:09', 34, 'PCv1_MGMT_PC_VDI', '', 'VDI', '', '0018_0000000003', '0013_0000000008', 'new', '0002_0000000006');
/*!40000 ALTER TABLE `resource_set_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `resource_set_invoke_design` DISABLE KEYS */;
INSERT INTO `resource_set_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_resource_set_design`, `invoke_resource_set_design`, `state_code`) VALUES
	('0021_0000000001', NULL, '0021_0000000001', 'umadmin', '2020-04-02 17:12:28', 'umadmin', '2020-03-21 15:59:21', 34, 'PCv1_MGMT_PC_VDI-->>--PCv1_MGMT_MT_LB', '', 'VDI-->>--LB', '', '0019_0000000008', '0019_0000000009', 'new'),
	('0021_0000000002', NULL, '0021_0000000002', 'umadmin', '2020-04-02 17:12:28', 'umadmin', '2020-03-21 16:01:11', 34, 'PCv1_MGMT_PC_VDI-->>--PCv1_SF_CS_LB', '', 'VDI-->>--LB', '', '0019_0000000004', '0019_0000000009', 'new'),
	('0021_0000000003', NULL, '0021_0000000003', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-21 16:01:38', 34, 'PCv1_MGMT_MT_APP-->>--PCv1_MGMT_MT_CACHE', '', 'APP-->>--CACHE', '', '0019_0000000006', '0019_0000000005', 'new'),
	('0021_0000000004', NULL, '0021_0000000004', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-21 16:01:52', 34, 'PCv1_MGMT_MT_APP-->>--PCv1_MGMT_MT_RDB', '', 'APP-->>--RDB', '', '0019_0000000007', '0019_0000000005', 'new'),
	('0021_0000000005', NULL, '0021_0000000005', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-21 16:02:01', 34, 'PCv1_MGMT_MT_LB-->>--PCv1_MGMT_MT_APP', '', 'LB-->>--APP', '', '0019_0000000005', '0019_0000000008', 'new'),
	('0021_0000000006', NULL, '0021_0000000006', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-21 16:02:26', 34, 'PCv1_SF_CS_APP-->>--PCv1_SF_CS_CACHE', '', 'APP-->>--CACHE', '', '0019_0000000002', '0019_0000000001', 'new'),
	('0021_0000000007', NULL, '0021_0000000007', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-21 16:02:40', 34, 'PCv1_SF_CS_APP-->>--PCv1_SF_CS_RDB', '', 'APP-->>--RDB', '', '0019_0000000003', '0019_0000000001', 'new'),
	('0021_0000000008', NULL, '0021_0000000008', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-21 16:02:57', 34, 'PCv1_SF_CS_LB-->>--PCv1_SF_CS_APP', '', 'LB-->>--APP', '', '0019_0000000001', '0019_0000000004', 'new'),
	('0021_0000000009', NULL, '0021_0000000009', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-23 18:03:35', 34, 'PCv1_SF_CS_APP-->>--PCv1_SF_CS_LB', '', 'APP-->>--LB', '', '0019_0000000004', '0019_0000000001', 'new'),
	('0021_0000000010', NULL, '0021_0000000010', 'umadmin', '2020-04-02 17:12:27', 'umadmin', '2020-03-23 18:03:45', 34, 'PCv1_MGMT_MT_APP-->>--PCv1_MGMT_MT_LB', '', 'APP-->>--LB', '', '0019_0000000008', '0019_0000000005', 'new');
/*!40000 ALTER TABLE `resource_set_invoke_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `dest_network_segment`, `owner_network_segment`, `network_zone_link`, `route_design`, `state_code`) VALUES
	('0030_0000000001', NULL, '0030_0000000001', 'umadmin', '2020-04-02 17:19:47', 'umadmin', '2020-03-22 10:30:33', 37, '10.128.0.0/17_VPC_GZP_SF-->>--10.128.202.0/24_SUBNET_GZP2_MGMT_MT_APP', '', 'GZP_SF--to--GZP2_MGMT_MT_APP', '', '', '0023_0000000010', '0023_0000000002', '0026_0000000001', '0020_0000000004', 'created'),
	('0030_0000000002', NULL, '0030_0000000002', 'umadmin', '2020-04-02 17:19:47', 'umadmin', '2020-03-22 10:32:52', 37, '10.128.202.0/24_SUBNET_GZP2_MGMT_MT_APP-->>--10.128.0.0/17_VPC_GZP_SF', '', 'GZP2_MGMT_MT_APP--to--GZP_SF', '', '', '0023_0000000002', '0023_0000000010', '0026_0000000001', '0020_0000000003', 'created'),
	('0030_0000000003', NULL, '0030_0000000003', 'umadmin', '2020-04-02 17:19:47', 'umadmin', '2020-03-22 10:38:09', 37, '10.128.32.0/24_SUBNET_GZP2_SF_CS_LB-->>--10.128.192.0/19_VPC_GZP_MGMT', '', 'GZP2_SF_CS_LB--to--GZP_MGMT', '', '', '0023_0000000003', '0023_0000000004', '0026_0000000001', '0020_0000000002', 'created'),
	('0030_0000000004', NULL, '0030_0000000004', 'umadmin', '2020-04-02 17:19:47', 'umadmin', '2020-03-22 10:38:19', 37, '10.128.192.0/19_VPC_GZP_MGMT-->>--10.128.32.0/24_SUBNET_GZP2_SF_CS_LB', '', 'GZP_MGMT--to--GZP2_SF_CS_LB', '', '', '0023_0000000004', '0023_0000000003', '0026_0000000001', '0020_0000000001', 'created');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;

/*!40000 ALTER TABLE `route_design` DISABLE KEYS */;
INSERT INTO `route_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `dest_network_segment_design`, `network_zone_link_design`, `owner_network_segment_design`, `state_code`) VALUES
	('0020_0000000001', NULL, '0020_0000000001', 'umadmin', '2020-04-02 17:17:40', 'umadmin', '2020-03-22 10:11:58', 34, 'MGMT-->>--SF_CS_LB', '', 'MGMT-->>--SF_CS_LB', '', '0013_0000000004', '0016_0000000001', '0013_0000000003', 'new'),
	('0020_0000000002', NULL, '0020_0000000002', 'umadmin', '2020-04-02 17:17:40', 'umadmin', '2020-03-22 10:12:26', 34, 'SF_CS_LB-->>--MGMT', '', 'SF_CS_LB-->>--MGMT', '', '0013_0000000003', '0016_0000000001', '0013_0000000004', 'new'),
	('0020_0000000003', NULL, '0020_0000000003', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-22 10:13:07', 34, 'MGMT_MT_APP-->>--SF', '', 'MGMT_MT_APP-->>--SF', '', '0013_0000000002', '0016_0000000001', '0013_0000000010', 'new'),
	('0020_0000000004', NULL, '0020_0000000004', 'umadmin', '2020-04-02 17:17:41', 'umadmin', '2020-03-22 10:13:26', 34, 'SF-->>--MGMT_MT_APP', '', 'SF-->>--MGMT_MT_APP', '', '0013_0000000010', '0016_0000000001', '0013_0000000002', 'new');
/*!40000 ALTER TABLE `route_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_design` DISABLE KEYS */;
INSERT INTO `service_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `service_invoke_type`, `service_nature`, `service_type`, `state_code`, `unit_design`) VALUES
	('0041_0000000001', NULL, '0041_0000000001', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:30:35', 34, 'S100001_登录', '2020-04-02 18:27:04', 'S100001', '', '登录', '同步请求', '查询类', '直连服务', 'new', '0039_0000000001');
/*!40000 ALTER TABLE `service_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_invoke_design` DISABLE KEYS */;
INSERT INTO `service_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_unit_design`, `invoke_unit_design`, `service_design`, `state_code`) VALUES
	('0042_0000000001', NULL, '0042_0000000001', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-22 07:31:09', 34, 'DEMO_CLIENT_BROWER-->--DEMO_CORE_APP@S100001_登录', '2020-04-02 18:27:04', 'BROWER-->--APP@登录', '', '0039_0000000001', '0039_0000000004', '0041_0000000001', 'new');
/*!40000 ALTER TABLE `service_invoke_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_invoke_seq_design` DISABLE KEYS */;
INSERT INTO `service_invoke_seq_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `app_system_design`) VALUES
	('0043_0000000001', NULL, '0043_0000000001', 'umadmin', '2020-04-02 18:26:37', 'umadmin', '2020-04-02 18:26:37', 34, 'DEMO_seq_LOGON', '', 'LOGON', '', '登录', 'new', '0037_0000000001');
/*!40000 ALTER TABLE `service_invoke_seq_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` DISABLE KEYS */;
INSERT INTO `service_invoke_seq_design$service_invoke_design_sequence` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0043_0000000001', '0042_0000000001', 1);
/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys` DISABLE KEYS */;
INSERT INTO `subsys` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `manage_role`, `state_code`, `subsys_design`, `app_system`) VALUES
	('0047_0000000001', NULL, '0047_0000000001', 'umadmin', '2020-04-02 18:27:53', 'umadmin', '2020-03-22 07:41:52', 37, 'PRD_DEMO_CORE', '', 'CORE', '', '0001_0000000001', 'created', '0038_0000000001', '0046_0000000001'),
	('0047_0000000002', NULL, '0047_0000000002', 'umadmin', '2020-04-02 18:27:52', 'umadmin', '2020-03-22 07:42:02', 37, 'PRD_DEMO_CLIENT', '', 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000002', '0046_0000000001');
/*!40000 ALTER TABLE `subsys` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys$business_zone` DISABLE KEYS */;
INSERT INTO `subsys$business_zone` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(3, '0047_0000000002', '0028_0000000004', 1),
	(4, '0047_0000000001', '0028_0000000002', 1);
/*!40000 ALTER TABLE `subsys$business_zone` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys_design` DISABLE KEYS */;
INSERT INTO `subsys_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `subsys_design_id`, `app_system_design`) VALUES
	('0038_0000000001', NULL, '0038_0000000001', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:03:18', 34, 'DEMO_CORE', '2020-04-02 18:27:04', 'CORE', '', '核心子系统', 'new', '123456', '0037_0000000001'),
	('0038_0000000002', NULL, '0038_0000000002', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-22 07:06:50', 34, 'DEMO_CLIENT', '2020-04-02 18:27:04', 'CLIENT', '', '客户端子系统', 'new', '123333', '0037_0000000001'),
	('0038_0000000003', NULL, '0038_0000000003', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-31 11:27:32', 34, 'DEMO_BATCH', '2020-04-02 18:27:04', 'BATCH', '', '跑批', 'new', '123457', '0037_0000000001');
/*!40000 ALTER TABLE `subsys_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `subsys_design$business_zone_design` DISABLE KEYS */;
INSERT INTO `subsys_design$business_zone_design` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(12, '0038_0000000003', '0018_0000000001', 1),
	(13, '0038_0000000002', '0018_0000000003', 1),
	(14, '0038_0000000001', '0018_0000000001', 1);
/*!40000 ALTER TABLE `subsys_design$business_zone_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
INSERT INTO `unit` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_path`, `manage_role`, `public_key`, `resource_set`, `security_group_asset_id`, `state_code`, `subsys`, `unit_design`, `unit_type`) VALUES
	('0048_0000000001', NULL, '0048_0000000001', 'umadmin', '2020-04-02 18:31:55', 'umadmin', '2020-03-22 08:03:58', 37, 'PRD_DEMO_CORE_LB', '', 'LB', '', '/data/PRD_DEMO_CORE_LB', '0001_0000000001', '', '0029_0000000010', '', 'created', '0047_0000000001', '0039_0000000003', '0002_0000000004'),
	('0048_0000000002', NULL, '0048_0000000002', 'umadmin', '2020-04-02 18:31:55', 'umadmin', '2020-03-22 08:08:05', 37, 'PRD_DEMO_CORE_APP', '', 'APP', '', '/data/PRD_DEMO_CORE_APP', '0001_0000000001', '', '0029_0000000011', '', 'created', '0047_0000000001', '0039_0000000001', '0002_0000000001'),
	('0048_0000000003', NULL, '0048_0000000003', 'umadmin', '2020-04-02 18:31:54', 'umadmin', '2020-03-22 08:08:22', 37, 'PRD_DEMO_CORE_DB', '', 'DB', '', '/data/PRD_DEMO_CORE_DB', '0001_0000000001', '', '0029_0000000013', '', 'created', '0047_0000000001', '0039_0000000002', '0002_0000000002'),
	('0048_0000000004', NULL, '0048_0000000004', 'umadmin', '2020-04-02 18:31:54', 'umadmin', '2020-03-22 08:08:36', 37, 'PRD_DEMO_CLIENT_BROWER', '', 'BROWER', '', '/data/PRD_DEMO_CLIENT_BROWER', '0001_0000000001', '', '0029_0000000014', '', 'created', '0047_0000000002', '0039_0000000004', '0002_0000000006');
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit$deploy_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `unit$deploy_package` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit_design` DISABLE KEYS */;
INSERT INTO `unit_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `across_resource_set`, `name`, `protocol`, `resource_set_design`, `state_code`, `subsys_design`, `unit_type`) VALUES
	('0039_0000000001', NULL, '0039_0000000001', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:07:45', 34, 'DEMO_CORE_APP', '2020-04-02 18:27:04', 'APP', '', 'Y', '程序', 'TCP', '0019_0000000001', 'new', '0038_0000000001', '0002_0000000001'),
	('0039_0000000002', NULL, '0039_0000000002', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:14:17', 34, 'DEMO_CORE_DB', '2020-04-02 18:27:04', 'DB', '', 'Y', '数据库', 'TCP', '0019_0000000003', 'new', '0038_0000000001', '0002_0000000002'),
	('0039_0000000003', NULL, '0039_0000000003', 'umadmin', '2020-04-02 18:27:05', 'umadmin', '2020-03-22 07:14:45', 34, 'DEMO_CORE_LB', '2020-04-02 18:27:04', 'LB', '', 'Y', '负载均衡', 'TCP', '0019_0000000004', 'new', '0038_0000000001', '0002_0000000004'),
	('0039_0000000004', NULL, '0039_0000000004', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-22 07:15:19', 34, 'DEMO_CLIENT_BROWER', '2020-04-02 18:27:04', 'BROWER', '', 'Y', 'WEB端', 'TCP', '0019_0000000009', 'new', '0038_0000000002', '0002_0000000006'),
	('0039_0000000006', NULL, '0039_0000000006', 'umadmin', '2020-04-02 18:27:04', 'umadmin', '2020-03-31 11:28:09', 34, 'DEMO_BATCH_APP', '2020-04-02 18:27:04', 'APP', '', 'Y', 'APP程序', 'TCP', '0019_0000000001', 'new', '0038_0000000003', '0002_0000000001');
/*!40000 ALTER TABLE `unit_design` ENABLE KEYS */;

/*!40000 ALTER TABLE `unit_type` DISABLE KEYS */;
INSERT INTO `unit_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0002_0000000001', NULL, '0002_0000000001', 'umadmin', '2020-03-21 14:58:20', 'umadmin', '2020-03-21 14:58:20', 34, 'TOMCAT|TOMCAT', '', 'TOMCAT', '', 'TOMCAT', NULL),
	('0002_0000000002', NULL, '0002_0000000002', 'umadmin', '2020-03-21 14:58:38', 'umadmin', '2020-03-21 14:58:38', 34, 'MYSQL|MYSQL', '', 'MYSQL', '', 'MYSQL', NULL),
	('0002_0000000003', NULL, '0002_0000000003', 'umadmin', '2020-03-21 14:58:51', 'umadmin', '2020-03-21 14:58:51', 34, 'REDIS|REDIS', '', 'REDIS', '', 'REDIS', NULL),
	('0002_0000000004', NULL, '0002_0000000004', 'umadmin', '2020-03-21 15:01:34', 'umadmin', '2020-03-21 14:59:41', 34, 'INSLB|内网LB', '', 'INSLB', '', '内网LB', NULL),
	('0002_0000000005', NULL, '0002_0000000005', 'umadmin', '2020-03-21 15:01:53', 'umadmin', '2020-03-21 15:01:53', 34, 'OUTLB|外网LB', '', 'OUTLB', '', '外网LB', NULL),
	('0002_0000000006', NULL, '0002_0000000006', 'umadmin', '2020-03-21 15:57:59', 'umadmin', '2020-03-21 15:57:59', 34, 'VDI|虚拟桌面', '', 'VDI', '', '虚拟桌面', NULL);


SET FOREIGN_KEY_CHECKS=1;
