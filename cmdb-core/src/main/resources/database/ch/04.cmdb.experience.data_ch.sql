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

SET FOREIGN_KEY_CHECKS=1;
