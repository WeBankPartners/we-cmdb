/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
SET FOREIGN_KEY_CHECKS=0;

-- Dumping data for table wecmdb_bk.application_domain: ~3 rows (approximately)
/*!40000 ALTER TABLE `application_domain` DISABLE KEYS */;
INSERT INTO `application_domain` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0005_0000000001', NULL, '0005_0000000001', 'umadmin', '2020-04-18 17:57:55', 'umadmin', '2020-04-11 22:08:41', 34, '管理应用域', NULL, 'ADm', '管理服务', '管理应用域', 'new'),
	('0005_0000000002', NULL, '0005_0000000002', 'umadmin', '2020-04-18 17:58:28', 'umadmin', '2020-04-11 22:09:00', 34, '公共应用域', NULL, 'ADc', '公共服务', '公共应用域', 'new'),
	('0005_0000000003', NULL, '0005_0000000003', 'umadmin', '2020-04-18 17:56:57', 'umadmin', '2020-04-18 17:56:57', 34, '业务应用域', NULL, 'ADb', '业务应用', '业务应用域', 'new');
/*!40000 ALTER TABLE `application_domain` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.app_instance: ~10 rows (approximately)
/*!40000 ALTER TABLE `app_instance` DISABLE KEYS */;
INSERT INTO `app_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_script`, `deploy_user`, `deploy_user_password`, `host_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `port`, `port_conflict`, `start_script`, `state_code`, `stop_script`, `storage`, `unit`, `variable_values`, `name`, `app_log_files`, `rw_dir`, `rw_file`) VALUES
	('0050_0000000002', NULL, '0050_0000000002', 'umadmin', '2020-05-25 20:23:09', 'umadmin', '2020-05-08 17:42:07', 40, 'democoreapp1_IP3423:10001', NULL, 'democoreapp1_IP3423:10001', '', '1', '', '', '/data/PRD_DEMO_CORE_APP/', 'javadeploy', 'Abcd1234', '0032_0000000010', '2', 'IP3423:20001', '20001', '10001', 'IP3423:10001', '/data/PRD_DEMO_CORE_APP/', 'created', '/data/PRD_DEMO_CORE_APP/', '10', '0048_0000000002', '=', 'democoreapp1', '/data/PRD_DEMO_CORE_APP/current/logs/out.log', '', ''),
	('0050_0000000003', NULL, '0050_0000000003', 'umadmin', '2020-05-25 20:23:08', 'umadmin', '2020-05-08 17:42:08', 40, 'democoreapp2_IP3425:10001', NULL, 'democoreapp2_IP3425:10001', '', '1', '', '', '/data/PRD_DEMO_CORE_APP/', 'javadeploy', 'Abcd1234', '0032_0000000011', '2', 'IP3425:20001', '20001', '10001', 'IP3425:10001', '/data/PRD_DEMO_CORE_APP/', 'created', '/data/PRD_DEMO_CORE_APP/', '10', '0048_0000000002', '=', 'democoreapp2', '/data/PRD_DEMO_CORE_APP/current/logs/out.log', '', ''),
	('0050_0000000008', NULL, '0050_0000000008', 'umadmin', '2020-05-25 20:21:00', 'umadmin', '2020-05-20 16:55:55', 40, 'demonginx01_IP3489:10001', NULL, 'demonginx01_IP3489:10001', '', '1', '', '', '/data/PRD_AaDEMO_PROXY_NGINX/', 'root', '', '0032_0000000016', '1', 'IP3489:10001', '10001', '10001', 'IP3489:10001', '/data/PRD_AaDEMO_PROXY_NGINX/', 'created', '/data/PRD_AaDEMO_PROXY_NGINX/', '20', '0048_0000000017', '=', 'demonginx01', '', '', ''),
	('0050_0000000009', NULL, '0050_0000000009', 'umadmin', '2020-05-25 20:20:59', 'umadmin', '2020-05-20 16:55:57', 40, 'demonginx02_IP3486:10001', NULL, 'demonginx02_IP3486:10001', '', '1', '', '', '/data/PRD_AaDEMO_PROXY_NGINX/', 'root', '', '0032_0000000017', '1', 'IP3486:10001', '10001', '10001', 'IP3486:10001', '/data/PRD_AaDEMO_PROXY_NGINX/', 'created', '/data/PRD_AaDEMO_PROXY_NGINX/', '20', '0048_0000000017', '=', 'demonginx02', '', '', ''),
	('0050_0000000010', NULL, '0050_0000000010', 'umadmin', '2020-05-25 20:23:07', 'umadmin', '2020-05-20 16:55:58', 40, 'demoapp01_IP6437:10001', NULL, 'demoapp01_IP6437:10001', '', '1', '', '', '/data/PRD_AaDEMO_CORE_APP/', 'javadeploy', 'Abcd1234', '0032_0000000014', '2', 'IP6437:20001', '20001', '10001', 'IP6437:10001', '/data/PRD_AaDEMO_CORE_APP/', 'created', '/data/PRD_AaDEMO_CORE_APP/', '20', '0048_0000000016', '=', 'demoapp01', '/data/PRD_AaDEMO_CORE_APP/current/logs/out.log', '', ''),
	('0050_0000000011', NULL, '0050_0000000011', 'umadmin', '2020-05-25 20:23:06', 'umadmin', '2020-05-20 16:55:59', 40, 'demoapp02_IP6442:10001', NULL, 'demoapp02_IP6442:10001', '', '1', '', '', '/data/PRD_AaDEMO_CORE_APP/', 'javadeploy', 'Abcd1234', '0032_0000000015', '2', 'IP6442:20001', '20001', '10001', 'IP6442:10001', '/data/PRD_AaDEMO_CORE_APP/', 'created', '/data/PRD_AaDEMO_CORE_APP/', '20', '0048_0000000016', '=', 'demoapp02', '/data/PRD_AaDEMO_CORE_APP/current/logs/out.log', '', ''),
	('0050_0000000012', NULL, '0050_0000000012', 'umadmin', '2020-06-30 15:31:17', 'umadmin', '2020-05-23 00:30:43', 40, 'demoapp02_IP6496:10001', NULL, 'demoapp02_IP6496:10001', '', '1', '0045_0000000005', '', '/data/PRD_TaDEMO_CORE_APP/demo-app-spring-boot_1.5.3/bin/deploy.sh', 'javadeploy', 'Abcd1234', '0032_0000000022', '2', 'IP6496:20001', '20001', '10001', 'IP6496:10001', '/data/PRD_TaDEMO_CORE_APP/current/bin/start.sh', 'created', '/data/PRD_TaDEMO_CORE_APP/current/bin/stop.sh', '20', '0048_0000000021', 'jmx_hostname,jmx_port,port,db_host_ip,db_host_port,db_name,db_username,db_password=IP6496,20001,10001,IP4383,3306,ademocore,dbuser,Abcd1234&0051_0000000005', 'demoapp02', '/data/PRD_TaDEMO_CORE_APP/current/logs/out.log', '', ''),
	('0050_0000000013', NULL, '0050_0000000013', 'umadmin', '2020-06-30 15:31:15', 'umadmin', '2020-05-23 00:30:44', 40, 'demoapp01_IP6436:10001', NULL, 'demoapp01_IP6436:10001', '', '1', '0045_0000000005', '', '/data/PRD_TaDEMO_CORE_APP/demo-app-spring-boot_1.5.3/bin/deploy.sh', 'javadeploy', 'Abcd1234', '0032_0000000023', '2', 'IP6436:20001', '20001', '10001', 'IP6436:10001', '/data/PRD_TaDEMO_CORE_APP/current/bin/start.sh', 'created', '/data/PRD_TaDEMO_CORE_APP/current/bin/stop.sh', '20', '0048_0000000021', 'jmx_hostname,jmx_port,port,db_host_ip,db_host_port,db_name,db_username,db_password=IP6436,20001,10001,IP4383,3306,ademocore,dbuser,Abcd1234&0051_0000000005', 'demoapp01', '/data/PRD_TaDEMO_CORE_APP/current/logs/out.log', '', ''),
	('0050_0000000014', NULL, '0050_0000000014', 'umadmin', '2020-06-30 15:31:13', 'umadmin', '2020-05-23 00:30:46', 40, 'demonginx02_IP3467:10001', NULL, 'demonginx02_IP3467:10001', '', '1', '0045_0000000007', '', '/data/PRD_TaDEMO_PROXY_NGINX/demo-app-nginx_0.1.1/bin/deploy.sh', 'root', '', '0032_0000000020', '1', 'IP3467:10001', '10001', '10001', 'IP3467:10001', '/data/PRD_TaDEMO_PROXY_NGINX/demo-app-nginx_0.1.1/bin/start.sh', 'created', '/data/PRD_TaDEMO_PROXY_NGINX/demo-app-nginx_0.1.1/bin/stop.sh', '20', '0048_0000000020', 'port,backend_server_ip_1,backend_server_port_1,backend_server_ip_2,backend_server_port_2,context_path=10001,IP9754,10001,IP3675,10001,~*^.+$', 'demonginx02', '', '', ''),
	('0050_0000000015', NULL, '0050_0000000015', 'umadmin', '2020-06-30 15:31:12', 'umadmin', '2020-05-23 00:30:47', 40, 'demonginx01_IP3424:10001', NULL, 'demonginx01_IP3424:10001', '', '1', '0045_0000000007', '', '/data/PRD_TaDEMO_PROXY_NGINX/demo-app-nginx_0.1.1/bin/deploy.sh', 'root', '', '0032_0000000021', '1', 'IP3424:10001', '10001', '10001', 'IP3424:10001', '/data/PRD_TaDEMO_PROXY_NGINX/demo-app-nginx_0.1.1/bin/start.sh', 'created', '/data/PRD_TaDEMO_PROXY_NGINX/demo-app-nginx_0.1.1/bin/stop.sh', '20', '0048_0000000020', 'port,backend_server_ip_1,backend_server_port_1,backend_server_ip_2,backend_server_port_2,context_path=10001,IP9754,10001,IP3675,10001,~*^.+$', 'demonginx01', '', '', '');
/*!40000 ALTER TABLE `app_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.app_system: ~3 rows (approximately)
/*!40000 ALTER TABLE `app_system` DISABLE KEYS */;
INSERT INTO `app_system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_environment`, `legal_person`, `state_code`, `app_system_design`) VALUES
	('0046_0000000003', NULL, '0046_0000000003', 'umadmin', '2020-06-30 15:35:55', 'umadmin', '2020-05-07 17:28:00', 37, 'PRD_DEMO', NULL, 'DEMO', '腾讯云分布式部署', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000002'),
	('0046_0000000005', NULL, '0046_0000000005', 'umadmin', '2020-06-30 15:35:55', 'umadmin', '2020-05-20 16:05:58', 37, 'PRD_AaDEMO', NULL, 'AaDEMO', '阿里云部署', '0003_0000000001', '', 'created', '0037_0000000007'),
	('0046_0000000007', NULL, '0046_0000000007', 'umadmin', '2020-06-30 15:35:55', 'umadmin', '2020-05-23 00:06:14', 37, 'PRD_TaDEMO', NULL, 'TaDEMO', '腾讯云部署', '0003_0000000001', '', 'created', '0037_0000000007');
/*!40000 ALTER TABLE `app_system` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.app_system$data_center: ~3 rows (approximately)
/*!40000 ALTER TABLE `app_system$data_center` DISABLE KEYS */;
INSERT INTO `app_system$data_center` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(11, '0046_0000000007', '0022_0000000016', 1),
	(12, '0046_0000000005', '0022_0000000009', 1),
	(13, '0046_0000000003', '0022_0000000001', 1);
/*!40000 ALTER TABLE `app_system$data_center` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.app_system_design: ~6 rows (approximately)
/*!40000 ALTER TABLE `app_system_design` DISABLE KEYS */;
INSERT INTO `app_system_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `application_domain`, `app_system_design_id`, `data_center_design`, `name`, `state_code`) VALUES
	('0037_0000000002', '0037_0000000008', '0037_0000000002', 'umadmin', '2020-05-20 15:33:51', 'umadmin', '2020-05-07 17:26:12', 35, 'DEMO', NULL, 'DEMO', '', '0005_0000000002', '1234', '0012_0000000001', '演示系统', 'update'),
	('0037_0000000003', NULL, '0037_0000000002', 'umadmin', '2020-05-08 14:53:43', 'umadmin', '2020-05-07 17:26:12', 34, 'DEMO', '2020-05-08 14:53:43', 'DEMO', '', '0005_0000000002', '1234', '0012_0000000001', '演示系统', 'new'),
	('0037_0000000004', NULL, '0037_0000000004', 'umadmin', '2020-05-08 17:26:34', 'umadmin', '2020-05-08 17:26:34', 34, 'UM', NULL, 'UM', '', '0005_0000000002', '2446', '0012_0000000001', '用户管理', 'new'),
	('0037_0000000006', NULL, '0037_0000000006', 'umadmin', '2020-05-20 16:04:55', 'umadmin', '2020-05-20 15:32:45', 34, 'aUM', NULL, 'aUM', '', '0005_0000000002', '2445', '0012_0000000002', '用户管理_通用', 'new'),
	('0037_0000000007', NULL, '0037_0000000007', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:32:45', 34, 'aDEMO', '2020-05-20 17:11:11', 'aDEMO', '', '0005_0000000002', '1232', '0012_0000000002', '演示系统_通用', 'new'),
	('0037_0000000008', '0037_0000000003', '0037_0000000002', 'umadmin', '2020-05-20 15:33:39', 'umadmin', '2020-05-07 17:26:12', 35, 'DEMO', '2020-05-08 17:34:28', 'DEMO', '', '0005_0000000002', '1234', '0012_0000000001', '演示系统', 'update');
/*!40000 ALTER TABLE `app_system_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.block_storage: ~2 rows (approximately)
/*!40000 ALTER TABLE `block_storage` DISABLE KEYS */;
INSERT INTO `block_storage` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `billing_cycle`, `storage_type`, `charge_type`, `disk_size`, `end_date`, `file_system`, `host_resource_instance`, `mount_point`, `name`, `state_code`) VALUES
	('0036_0000000004', NULL, '0036_0000000004', 'umadmin', '2020-05-20 15:16:00', 'umadmin', '2020-05-20 15:16:00', 37, 'ALI_SE5_PRD_SF__JAVA1__apphost01_test', NULL, 'test', '', '', '', '0062_0000000042', '0063_0000000005', '50', '', 'EXT4', '0032_0000000014', '/testvol', 'testvol', 'created'),
	('0036_0000000005', NULL, '0036_0000000005', 'umadmin', '2020-05-22 23:54:00', 'umadmin', '2020-05-22 23:54:00', 37, 'TX_BJ_PRD_SF__JAVA1__apphost01_test', NULL, 'test', '', '', '', '0062_0000000014', '0063_0000000004', '50', '', 'EXT4', '0032_0000000023', '/testvol', 'testvol', 'created');
/*!40000 ALTER TABLE `block_storage` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.business_zone: ~18 rows (approximately)
/*!40000 ALTER TABLE `business_zone` DISABLE KEYS */;
INSERT INTO `business_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `network_zone`, `description`, `business_zone_design`, `business_zone_type`, `logic_business_zone`, `name`, `state_code`, `legal_person`) VALUES
	('0028_0000000002', NULL, '0028_0000000002', 'umadmin', '2020-06-30 15:17:31', 'umadmin', '2020-04-28 23:46:13', 37, '_SF_110', NULL, '110', NULL, '', '0018_0000000003', 'GROUP', '', '客户账务', 'created', '0004_0000000001'),
	('0028_0000000003', NULL, '0028_0000000003', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-28 23:46:14', 37, '_SF_1A0', NULL, '1A0', NULL, '', '0018_0000000002', 'GROUP', '', '公共服务', 'created', '0004_0000000001'),
	('0028_0000000004', NULL, '0028_0000000004', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-28 23:46:16', 37, '_DMZ_1D0', NULL, '1D0', NULL, '', '0018_0000000004', 'GROUP', '', '互联接入', 'created', '0004_0000000001'),
	('0028_0000000005', NULL, '0028_0000000005', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-28 23:46:17', 37, '_ECN_1E0', NULL, '1E0', NULL, '', '0018_0000000005', 'GROUP', '', '伙伴对接', 'created', '0004_0000000001'),
	('0028_0000000006', NULL, '0028_0000000006', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-28 23:46:18', 37, '_MGMT_1M0', NULL, '1M0', NULL, '', '0018_0000000006', 'GROUP', '', '运维管理', 'created', '0004_0000000001'),
	('0028_0000000007', NULL, '0028_0000000007', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-28 23:46:19', 37, '_QZ_1Q0', NULL, '1Q0', NULL, '', '0018_0000000007', 'GROUP', '', '后台管理', 'created', '0004_0000000001'),
	('0028_0000000008', NULL, '0028_0000000008', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:53:27', 37, 'TX_GZ_PRD_SF_111', NULL, '111', '0024_0000000002', '', '0018_0000000003', 'NODE', '0028_0000000002', '客户账务', 'created', '0004_0000000001'),
	('0028_0000000009', NULL, '0028_0000000009', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:53:28', 37, 'TX_CD_DR_SF_112', NULL, '112', '0024_0000000007', '', '0018_0000000003', 'NODE', '0028_0000000002', '客户账务', 'created', '0004_0000000001'),
	('0028_0000000010', NULL, '0028_0000000010', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:53:28', 37, 'TX_GZ_PRD_SF_1A1', NULL, '1A1', '0024_0000000002', '', '0018_0000000002', 'NODE', '0028_0000000003', '公共服务', 'created', '0004_0000000001'),
	('0028_0000000011', NULL, '0028_0000000011', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:53:28', 37, 'TX_CD_DR_SF_1A2', NULL, '1A2', '0024_0000000007', '', '0018_0000000002', 'NODE', '0028_0000000003', '公共服务', 'created', '0004_0000000001'),
	('0028_0000000012', NULL, '0028_0000000012', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:53:29', 37, 'TX_GZ_PRD_DMZ_1D1', NULL, '1D1', '0024_0000000003', '', '0018_0000000004', 'NODE', '0028_0000000004', '外网对接', 'created', '0004_0000000001'),
	('0028_0000000013', NULL, '0028_0000000013', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:53:29', 37, 'TX_CD_DR_DMZ_1D2', NULL, '1D2', '0024_0000000008', '', '0018_0000000004', 'NODE', '0028_0000000004', '外网对接', 'created', '0004_0000000001'),
	('0028_0000000014', NULL, '0028_0000000014', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:53:29', 37, 'TX_GZ_PRD_MGMT_1M1', NULL, '1M1', '0024_0000000005', '', '0018_0000000006', 'NODE', '0028_0000000006', '运维管理', 'created', '0004_0000000001'),
	('0028_0000000015', NULL, '0028_0000000015', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:53:30', 37, 'TX_CD_DR_MGMT_1M2', NULL, '1M2', '0024_0000000010', '', '0018_0000000006', 'NODE', '0028_0000000006', '运维管理', 'created', '0004_0000000001'),
	('0028_0000000016', NULL, '0028_0000000016', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:53:30', 37, 'TX_GZ_PRD_QZ_1Q1', NULL, '1Q1', '0024_0000000006', '', '0018_0000000007', 'NODE', '0028_0000000007', '后台管理', 'created', '0004_0000000001'),
	('0028_0000000017', NULL, '0028_0000000017', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:53:30', 37, 'TX_CD_DR_QZ_1Q2', NULL, '1Q2', '0024_0000000011', '', '0018_0000000007', 'NODE', '0028_0000000007', '后台管理', 'created', '0004_0000000001'),
	('0028_0000000018', NULL, '0028_0000000018', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-28 23:53:31', 37, 'TX_CD_DR_ECN_1E1', NULL, '1E1', '0024_0000000009', '', '0018_0000000005', 'NODE', '0028_0000000005', '伙伴对接', 'created', '0004_0000000001'),
	('0028_0000000019', NULL, '0028_0000000019', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-28 23:53:31', 37, 'TX_CD_DR_ECN_1E2', NULL, '1E2', '0024_0000000009', '', '0018_0000000005', 'NODE', '0028_0000000005', '伙伴对接', 'created', '0004_0000000001');
/*!40000 ALTER TABLE `business_zone` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.business_zone_design: ~10 rows (approximately)
/*!40000 ALTER TABLE `business_zone_design` DISABLE KEYS */;
INSERT INTO `business_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `network_zone_design`, `description`, `state_code`) VALUES
	('0018_0000000002', NULL, '0018_0000000002', 'umadmin', '2020-06-30 15:12:17', 'umadmin', '2020-04-28 20:58:23', 34, 'PCD_SF_ADM', NULL, 'ADM', '0014_0000000002', '基础服务', 'new'),
	('0018_0000000003', NULL, '0018_0000000003', 'umadmin', '2020-06-30 15:12:18', 'umadmin', '2020-04-28 20:58:23', 34, 'PCD_SF_DCN', NULL, 'DCN', '0014_0000000002', '业务服务', 'new'),
	('0018_0000000004', NULL, '0018_0000000004', 'umadmin', '2020-06-30 15:12:19', 'umadmin', '2020-04-28 20:58:23', 34, 'PCD_DMZ_DMZ', NULL, 'DMZ', '0014_0000000003', '外连服务', 'new'),
	('0018_0000000005', NULL, '0018_0000000005', 'umadmin', '2020-06-30 15:12:20', 'umadmin', '2020-04-28 20:58:23', 34, 'PCD_ECN_ECN', NULL, 'ECN', '0014_0000000004', '伙伴服务', 'new'),
	('0018_0000000006', NULL, '0018_0000000006', 'umadmin', '2020-06-30 15:12:16', 'umadmin', '2020-04-28 20:58:24', 34, 'PCD_MGMT_MT', NULL, 'MT', '0014_0000000005', '科技运维服务', 'new'),
	('0018_0000000007', NULL, '0018_0000000007', 'umadmin', '2020-06-30 15:12:16', 'umadmin', '2020-04-28 20:58:24', 34, 'PCD_QZ_QZ', NULL, 'QZ', '0014_0000000006', '业务运营服务', 'new'),
	('0018_0000000008', NULL, '0018_0000000008', 'umadmin', '2020-06-30 15:12:17', 'umadmin', '2020-04-28 20:58:24', 34, 'PCD_WAN_ALL', NULL, 'ALL', '0014_0000000007', '互联网', 'new'),
	('0018_0000000009', NULL, '0018_0000000009', 'umadmin', '2020-06-30 15:12:15', 'umadmin', '2020-04-28 20:58:25', 34, 'PCD_TON_OPS', NULL, 'OPS', '0014_0000000009', '运维客户端', 'new'),
	('0018_0000000010', NULL, '0018_0000000010', 'umadmin', '2020-06-30 15:12:14', 'umadmin', '2020-04-28 20:59:27', 34, 'PCD_PTN_ANY', NULL, 'ANY', '0014_0000000008', '合作伙伴', 'new'),
	('0018_0000000011', NULL, '0018_0000000011', 'umadmin', '2020-06-30 15:12:14', 'umadmin', '2020-04-28 20:59:27', 34, 'PCD_BON_BAC', NULL, 'BAC', '0014_0000000010', '业务管理客户端', 'new');
/*!40000 ALTER TABLE `business_zone_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cache_instance: ~3 rows (approximately)
/*!40000 ALTER TABLE `cache_instance` DISABLE KEYS */;
INSERT INTO `cache_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cache_resource_instance`, `memory`, `port`, `state_code`, `unit`, `name`) VALUES
	('0052_0000000002', NULL, '0052_0000000002', 'umadmin', '2020-05-08 17:43:49', 'umadmin', '2020-05-08 17:43:48', 37, 'democorecache_IP9756:6379', NULL, 'democorecache_IP9756:6379', '', '0034_0000000003', '2', '6379', 'created', '0048_0000000004', 'democorecache'),
	('0052_0000000004', NULL, '0052_0000000004', 'umadmin', '2020-05-23 00:28:50', 'umadmin', '2020-05-20 16:58:01', 37, 'ademocore_IP3285:6379', NULL, 'ademocore_IP3285:6379', '', '0034_0000000004', '2', '6379', 'created', '0048_0000000013', 'ademocore'),
	('0052_0000000005', NULL, '0052_0000000005', 'umadmin', '2020-05-23 00:28:50', 'umadmin', '2020-05-23 00:27:30', 37, 'ademocore_IP3268:6379', NULL, 'ademocore_IP3268:6379', '', '0034_0000000006', '2', '6379', 'created', '0048_0000000023', 'ademocore');
/*!40000 ALTER TABLE `cache_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cache_resource_instance: ~3 rows (approximately)
/*!40000 ALTER TABLE `cache_resource_instance` DISABLE KEYS */;
INSERT INTO `cache_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `end_date`, `ip_address`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_type`, `resource_set`, `state_code`, `user_name`, `user_password`, `resource_instance_system`, `network_segment`) VALUES
	('0034_0000000003', NULL, '0034_0000000003', 'umadmin', '2020-05-08 17:06:12', 'umadmin', '2020-05-08 17:06:11', 40, 'TX_GZ_PRD_SF_1A1_REDIS1__admredis1', NULL, 'admredis1_IP9756', '', '', '', '', '0063_0000000004', '0008_0000000005', '', 'IP9756', '6379', '', '', 'IP9756:6379', '6379', 'admredis1', '0010_0000000050', '0009_0000000026', '0029_0000000054', 'created', 'root', 'Abcd1234', '0011_0000000028', '0023_0000000057'),
	('0034_0000000004', NULL, '0034_0000000004', 'umadmin', '2020-05-21 14:59:09', 'umadmin', '2020-05-20 15:13:30', 40, 'ALI_HZ_PRD_SF__REDIS1__redis01', NULL, 'redis01_IP3285', '', '', '', '', '0063_0000000005', '0008_0000000015', '', 'IP3285', '6379', '', '', 'IP3285:6379', '6379', 'redis01', '0010_0000000050', '0009_0000000028', '0029_0000000102', 'created', 'root', 'Abcd1234', '0011_0000000031', '0023_0000000066'),
	('0034_0000000006', NULL, '0034_0000000006', 'umadmin', '2020-05-22 19:49:08', 'umadmin', '2020-05-22 19:49:07', 40, 'TX_BJ_PRD_SF__REDIS1__redis01', NULL, 'redis01_IP3268', '', '', '', '', '0063_0000000004', '0008_0000000005', '', 'IP3268', '6379', '', '', 'IP3268:6379', '6379', 'redis01', '0010_0000000050', '0009_0000000026', '0029_0000000134', 'created', 'root', 'Abcd1234', '0011_0000000028', '0023_0000000102');
/*!40000 ALTER TABLE `cache_resource_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.charge_type: ~6 rows (approximately)
/*!40000 ALTER TABLE `charge_type` DISABLE KEYS */;
INSERT INTO `charge_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `state_code`, `fixed_date`, `code`, `cloud_vendor`, `description`, `name`) VALUES
	('0063_0000000001', NULL, '0063_0000000001', 'umadmin', '2020-04-29 16:10:16', 'umadmin', '2020-04-11 23:47:23', 34, '包月付费', 'new', NULL, 'prePaid', '0006_0000000001', '', '包月付费'),
	('0063_0000000002', NULL, '0063_0000000002', 'umadmin', '2020-04-29 16:10:16', 'umadmin', '2020-04-11 23:47:47', 34, '按量付费', 'new', NULL, 'postPaid', '0006_0000000001', '', '按量付费'),
	('0063_0000000003', NULL, '0063_0000000003', 'umadmin', '2020-04-29 16:10:16', 'umadmin', '2020-04-18 16:06:34', 34, '包月付费', 'new', NULL, 'PREPAID', '0006_0000000002', '', '包月付费'),
	('0063_0000000004', NULL, '0063_0000000004', 'umadmin', '2020-04-29 16:10:16', 'umadmin', '2020-04-18 16:07:03', 34, '按量付费', 'new', NULL, 'POSTPAID_BY_HOUR', '0006_0000000002', '', '按量付费'),
	('0063_0000000005', NULL, '0063_0000000005', 'umadmin', '2020-05-20 15:06:38', 'umadmin', '2020-05-20 15:06:37', 34, '按量付费', 'new', NULL, 'PostPaid', '0006_0000000004', '', '按量付费'),
	('0063_0000000006', NULL, '0063_0000000006', 'umadmin', '2020-05-20 15:06:38', 'umadmin', '2020-05-20 15:06:38', 34, '包月付费', 'new', NULL, 'PrePaid', '0006_0000000004', '', '包月付费');
/*!40000 ALTER TABLE `charge_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cloud_vendor: ~6 rows (approximately)
/*!40000 ALTER TABLE `cloud_vendor` DISABLE KEYS */;
INSERT INTO `cloud_vendor` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0006_0000000001', NULL, '0006_0000000001', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-11 22:12:23', 34, '华为云', NULL, 'HW', '华为云', '华为云', 'new'),
	('0006_0000000002', NULL, '0006_0000000002', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 22:12:45', 34, '腾讯云', NULL, 'TX', '腾讯云', '腾讯云', 'new'),
	('0006_0000000003', NULL, '0006_0000000003', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:36:36', 34, '云外部', NULL, 'OC', '云外部', '云外部', 'new'),
	('0006_0000000004', NULL, '0006_0000000004', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-23 12:16:31', 34, '阿里云', NULL, 'ALI', '阿里云', '阿里云', 'new'),
	('0006_0000000005', NULL, '0006_0000000005', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-23 12:17:45', 34, '亚马逊云', NULL, 'AWS', '亚马逊云', '亚马逊云', 'new'),
	('0006_0000000006', NULL, '0006_0000000006', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-23 12:18:49', 34, '微软云', NULL, 'AZ', '微软云', '微软云', 'new');
/*!40000 ALTER TABLE `cloud_vendor` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cluster_node_type: ~15 rows (approximately)
/*!40000 ALTER TABLE `cluster_node_type` DISABLE KEYS */;
INSERT INTO `cluster_node_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cluster_type`, `name`, `state_code`) VALUES
	('0008_0000000001', NULL, '0008_0000000001', 'umadmin', '2020-04-29 18:44:49', 'umadmin', '2020-04-11 23:57:10', 34, 'NODE_负载均衡', NULL, 'node', '', '0007_0000000001', 'NODE', 'new'),
	('0008_0000000002', NULL, '0008_0000000002', 'umadmin', '2020-04-29 18:44:49', 'umadmin', '2020-04-11 23:57:56', 34, '主节点_MYSQL主备', NULL, 'master', '', '0007_0000000002', '主节点', 'new'),
	('0008_0000000003', NULL, '0008_0000000003', 'umadmin', '2020-04-29 18:44:49', 'umadmin', '2020-04-11 23:58:21', 34, 'NODE_节点多活', NULL, 'node', '', '0007_0000000003', 'NODE', 'new'),
	('0008_0000000004', NULL, '0008_0000000004', 'umadmin', '2020-04-29 18:44:49', 'umadmin', '2020-04-13 00:17:07', 34, '主节点_REDIS主备', NULL, 'master', '', '0007_0000000005', '主节点', 'new'),
	('0008_0000000005', NULL, '0008_0000000005', 'umadmin', '2020-04-29 18:44:49', 'umadmin', '2020-04-18 17:47:21', 34, '主节点_REDIS主备', NULL, 'master', '', '0007_0000000009', '主节点', 'new'),
	('0008_0000000006', NULL, '0008_0000000006', 'umadmin', '2020-04-29 18:44:48', 'umadmin', '2020-04-18 17:47:22', 34, 'NODE_节点多活', NULL, 'node', '', '0007_0000000012', 'NODE', 'new'),
	('0008_0000000007', NULL, '0008_0000000007', 'umadmin', '2020-04-29 18:44:48', 'umadmin', '2020-04-18 17:47:22', 34, '主节点_MYSQL主备', NULL, 'master', '', '0007_0000000008', '主节点', 'new'),
	('0008_0000000008', NULL, '0008_0000000008', 'umadmin', '2020-04-29 18:44:48', 'umadmin', '2020-04-18 17:47:22', 34, 'NODE_负载均衡', NULL, 'node', '', '0007_0000000007', 'NODE', 'new'),
	('0008_0000000009', NULL, '0008_0000000009', 'umadmin', '2020-04-29 18:44:48', 'umadmin', '2020-04-24 18:18:32', 34, 'NODE_BDP集群', NULL, 'bdpnode', '', '0007_0000000015', 'NODE', 'new'),
	('0008_0000000010', NULL, '0008_0000000010', 'umadmin', '2020-04-29 18:44:48', 'umadmin', '2020-04-24 18:18:45', 34, 'NODE_BDP集群', NULL, 'bdpnode', '', '0007_0000000016', 'NODE', 'new'),
	('0008_0000000011', NULL, '0008_0000000011', 'umadmin', '2020-05-20 14:25:39', 'umadmin', '2020-05-20 14:25:39', 34, 'NODE_BDP集群', NULL, 'bdpnode', '', '0007_0000000019', 'NODE', 'new'),
	('0008_0000000012', NULL, '0008_0000000012', 'umadmin', '2020-05-20 14:25:39', 'umadmin', '2020-05-20 14:25:39', 34, 'NODE_节点多活', NULL, 'node', '', '0007_0000000020', 'NODE', 'new'),
	('0008_0000000013', NULL, '0008_0000000013', 'umadmin', '2020-05-20 14:25:39', 'umadmin', '2020-05-20 14:25:39', 34, '主节点_MYSQL主备', NULL, 'master', '', '0007_0000000024', '主节点', 'new'),
	('0008_0000000014', NULL, '0008_0000000014', 'umadmin', '2020-05-20 14:25:39', 'umadmin', '2020-05-20 14:25:39', 34, 'NODE_负载均衡', NULL, 'node', '', '0007_0000000025', 'NODE', 'new'),
	('0008_0000000015', NULL, '0008_0000000015', 'umadmin', '2020-05-20 14:25:39', 'umadmin', '2020-05-20 14:25:39', 34, '主节点_REDIS主备', NULL, 'master', '', '0007_0000000023', '主节点', 'new');
/*!40000 ALTER TABLE `cluster_node_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cluster_type: ~23 rows (approximately)
/*!40000 ALTER TABLE `cluster_type` DISABLE KEYS */;
INSERT INTO `cluster_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_vendor`, `name`, `state_code`) VALUES
	('0007_0000000001', NULL, '0007_0000000001', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 23:55:10', 34, '负载均衡_华为云', NULL, 'LB', '', '0006_0000000001', '负载均衡', 'new'),
	('0007_0000000002', NULL, '0007_0000000002', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 23:55:31', 34, 'MYSQL主备_华为云', NULL, 'true', '', '0006_0000000001', 'MYSQL主备', 'new'),
	('0007_0000000003', NULL, '0007_0000000003', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 23:56:20', 34, '节点多活_华为云', NULL, 'MN', '', '0006_0000000001', '节点多活', 'new'),
	('0007_0000000004', NULL, '0007_0000000004', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-12 15:43:58', 34, 'MYSQL单机_华为云', NULL, 'false', '', '0006_0000000001', 'MYSQL单机', 'new'),
	('0007_0000000005', NULL, '0007_0000000005', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-13 00:15:52', 34, 'REDIS主备_华为云', NULL, 'ha', '', '0006_0000000001', 'REDIS主备', 'new'),
	('0007_0000000006', NULL, '0007_0000000006', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-13 00:16:17', 34, 'REDIS单机_华为云', NULL, 'single', '', '0006_0000000001', 'REDIS单机', 'new'),
	('0007_0000000007', NULL, '0007_0000000007', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:46:50', 34, '负载均衡_腾讯云', NULL, 'LB', '', '0006_0000000002', '负载均衡', 'new'),
	('0007_0000000008', NULL, '0007_0000000008', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:47:48', 34, 'MYSQL主备_腾讯云', NULL, 'masterslave', '', '0006_0000000002', 'MYSQL主备', 'new'),
	('0007_0000000009', NULL, '0007_0000000009', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:48:27', 34, 'REDIS主备_腾讯云', NULL, 'redisha', '', '0006_0000000002', 'REDIS主备', 'new'),
	('0007_0000000010', NULL, '0007_0000000010', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:48:57', 34, 'REDIS单机_腾讯云', NULL, 'single', '', '0006_0000000002', 'REDIS单机', 'new'),
	('0007_0000000011', NULL, '0007_0000000011', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:49:24', 34, 'MYSQL单机_腾讯云', NULL, 'single', '', '0006_0000000002', 'MYSQL单机', 'new'),
	('0007_0000000012', NULL, '0007_0000000012', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 14:50:33', 34, '节点多活_腾讯云', NULL, 'MN', '', '0006_0000000002', '节点多活', 'new'),
	('0007_0000000015', NULL, '0007_0000000015', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-24 18:17:47', 34, 'BDP集群_腾讯云', NULL, 'bdpcluster', '', '0006_0000000002', 'BDP集群', 'new'),
	('0007_0000000016', NULL, '0007_0000000016', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 18:17:58', 34, 'BDP集群_华为云', NULL, 'bdpcluster', '', '0006_0000000001', 'BDP集群', 'new'),
	('0007_0000000017', NULL, '0007_0000000017', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-29 15:33:48', 34, 'REDIS集群_腾讯云', NULL, 'rediscluster', '', '0006_0000000002', 'REDIS集群', 'new'),
	('0007_0000000018', NULL, '0007_0000000018', 'umadmin', '2020-05-20 12:38:57', 'umadmin', '2020-05-20 12:38:57', 34, 'REDIS集群_阿里云', NULL, 'rediscluster', '', '0006_0000000004', 'REDIS集群', 'new'),
	('0007_0000000019', NULL, '0007_0000000019', 'umadmin', '2020-05-20 12:38:57', 'umadmin', '2020-05-20 12:38:57', 34, 'BDP集群_阿里云', NULL, 'bdpcluster', '', '0006_0000000004', 'BDP集群', 'new'),
	('0007_0000000020', NULL, '0007_0000000020', 'umadmin', '2020-05-20 12:38:57', 'umadmin', '2020-05-20 12:38:57', 34, '节点多活_阿里云', NULL, 'MN', '', '0006_0000000004', '节点多活', 'new'),
	('0007_0000000021', NULL, '0007_0000000021', 'umadmin', '2020-05-20 12:38:57', 'umadmin', '2020-05-20 12:38:57', 34, 'MYSQL单机_阿里云', NULL, 'single', '', '0006_0000000004', 'MYSQL单机', 'new'),
	('0007_0000000022', NULL, '0007_0000000022', 'umadmin', '2020-05-20 12:38:58', 'umadmin', '2020-05-20 12:38:57', 34, 'REDIS单机_阿里云', NULL, 'single', '', '0006_0000000004', 'REDIS单机', 'new'),
	('0007_0000000023', NULL, '0007_0000000023', 'umadmin', '2020-05-20 12:38:58', 'umadmin', '2020-05-20 12:38:58', 34, 'REDIS主备_阿里云', NULL, 'redisha', '', '0006_0000000004', 'REDIS主备', 'new'),
	('0007_0000000024', NULL, '0007_0000000024', 'umadmin', '2020-05-20 12:38:58', 'umadmin', '2020-05-20 12:38:58', 34, 'MYSQL主备_阿里云', NULL, 'masterslave', '', '0006_0000000004', 'MYSQL主备', 'new'),
	('0007_0000000025', NULL, '0007_0000000025', 'umadmin', '2020-05-20 12:38:58', 'umadmin', '2020-05-20 12:38:58', 34, '负载均衡_阿里云', NULL, 'LB', '', '0006_0000000004', '负载均衡', 'new');
/*!40000 ALTER TABLE `cluster_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cluster_type$unit_type: ~49 rows (approximately)
/*!40000 ALTER TABLE `cluster_type$unit_type` DISABLE KEYS */;
INSERT INTO `cluster_type$unit_type` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(3, '0007_0000000014', '0002_0000000002', 1),
	(4, '0007_0000000013', '0002_0000000002', 1),
	(91, '0007_0000000005', '0002_0000000003', 1),
	(92, '0007_0000000004', '0002_0000000002', 1),
	(93, '0007_0000000003', '0002_0000000006', 2),
	(94, '0007_0000000003', '0002_0000000010', 3),
	(95, '0007_0000000003', '0002_0000000009', 1),
	(96, '0007_0000000003', '0002_0000000005', 5),
	(97, '0007_0000000003', '0002_0000000004', 4),
	(98, '0007_0000000002', '0002_0000000002', 1),
	(99, '0007_0000000001', '0002_0000000011', 2),
	(100, '0007_0000000001', '0002_0000000010', 3),
	(101, '0007_0000000001', '0002_0000000005', 5),
	(102, '0007_0000000001', '0002_0000000001', 4),
	(103, '0007_0000000001', '0002_0000000012', 1),
	(104, '0007_0000000017', '0002_0000000003', 1),
	(105, '0007_0000000016', '0002_0000000008', 1),
	(106, '0007_0000000015', '0002_0000000008', 1),
	(107, '0007_0000000012', '0002_0000000006', 2),
	(108, '0007_0000000012', '0002_0000000005', 5),
	(109, '0007_0000000012', '0002_0000000009', 1),
	(110, '0007_0000000012', '0002_0000000010', 3),
	(111, '0007_0000000012', '0002_0000000004', 4),
	(112, '0007_0000000011', '0002_0000000002', 1),
	(113, '0007_0000000010', '0002_0000000003', 1),
	(114, '0007_0000000009', '0002_0000000003', 1),
	(115, '0007_0000000008', '0002_0000000002', 1),
	(116, '0007_0000000007', '0002_0000000011', 2),
	(117, '0007_0000000007', '0002_0000000012', 1),
	(118, '0007_0000000007', '0002_0000000005', 5),
	(119, '0007_0000000007', '0002_0000000010', 3),
	(120, '0007_0000000007', '0002_0000000001', 4),
	(121, '0007_0000000006', '0002_0000000003', 1),
	(122, '0007_0000000018', '0002_0000000003', 1),
	(123, '0007_0000000019', '0002_0000000008', 1),
	(124, '0007_0000000020', '0002_0000000005', 5),
	(125, '0007_0000000020', '0002_0000000009', 1),
	(126, '0007_0000000020', '0002_0000000010', 3),
	(127, '0007_0000000020', '0002_0000000004', 4),
	(128, '0007_0000000020', '0002_0000000006', 2),
	(129, '0007_0000000021', '0002_0000000002', 1),
	(130, '0007_0000000022', '0002_0000000003', 1),
	(131, '0007_0000000023', '0002_0000000003', 1),
	(132, '0007_0000000024', '0002_0000000002', 1),
	(133, '0007_0000000025', '0002_0000000001', 4),
	(134, '0007_0000000025', '0002_0000000005', 5),
	(135, '0007_0000000025', '0002_0000000010', 3),
	(136, '0007_0000000025', '0002_0000000012', 1),
	(137, '0007_0000000025', '0002_0000000011', 2);
/*!40000 ALTER TABLE `cluster_type$unit_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cos_instance: ~0 rows (approximately)
/*!40000 ALTER TABLE `cos_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `cos_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.cos_resource_instance: ~0 rows (approximately)
/*!40000 ALTER TABLE `cos_resource_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `cos_resource_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.data_center: ~12 rows (approximately)
/*!40000 ALTER TABLE `data_center` DISABLE KEYS */;
INSERT INTO `data_center` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cloud_uid`, `cloud_vendor`, `data_center_design`, `data_center_type`, `location`, `name`, `regional_data_center`, `state_code`, `available_zone`, `region`, `cen_asset_id`) VALUES
	('0022_0000000001', NULL, '0022_0000000001', 'umadmin', '2020-06-30 15:37:29', 'umadmin', '2020-04-12 03:52:22', 37, 'TX_GZ_PRD', NULL, 'TX_GZ_PRD', '', '', '0006_0000000002', '0012_0000000001', 'REGION', 'Region=', '腾讯云生产数据中心', '', 'created', '', 'GZ', NULL),
	('0022_0000000002', NULL, '0022_0000000002', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-12 03:53:02', 37, 'TX_CD_DR', NULL, 'TX_CD_DR', '', '', '0006_0000000002', '0012_0000000001', 'REGION', 'Region=', '腾讯云容灾数据中心', '', 'created', '', 'CD', NULL),
	('0022_0000000003', NULL, '0022_0000000003', 'umadmin', '2020-06-30 15:36:54', 'umadmin', '2020-04-12 03:54:07', 37, 'TX_GZ_PRD1', NULL, 'TX_GZ_PRD1', '', '', '0006_0000000002', '0012_0000000001', 'ZONE', 'Region=;AvailableZone=', '腾讯云生产数据中心1', '0022_0000000001', 'created', '', 'GZ', NULL),
	('0022_0000000004', NULL, '0022_0000000004', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-12 03:54:56', 37, 'TX_CD_DR1', NULL, 'TX_CD_DR1', '', '', '0006_0000000002', '0012_0000000001', 'ZONE', 'Region=;AvailableZone=', '腾讯云容灾数据中心1', '0022_0000000002', 'created', '', 'CD', NULL),
	('0022_0000000005', NULL, '0022_0000000005', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-12 03:54:56', 37, 'TX_GZ_PRD2', NULL, 'TX_GZ_PRD2', '', '', '0006_0000000002', '0012_0000000001', 'ZONE', 'Region=;AvailableZone=', '腾讯云生产数据中心2', '0022_0000000001', 'created', '', 'GZ', NULL),
	('0022_0000000006', NULL, '0022_0000000006', 'umadmin', '2020-04-28 21:56:28', 'umadmin', '2020-04-13 18:49:27', 37, 'ODC', NULL, 'ODC', '', '', '0006_0000000003', '0012_0000000001', 'REGION', 'null', '数据中心外部', '', 'created', 'null', 'ALL', NULL),
	('0022_0000000009', NULL, '0022_0000000009', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 11:56:13', 37, 'ALI_HZ_PRD', NULL, 'ALI_HZ_PRD', '', '', '0006_0000000004', '0012_0000000002', 'REGION', 'regionId=cn-hangzhou;regionGroup=cn-hangzhou-MAZ10', '阿里云杭州生产数据中心', '', 'created', '', 'cn-hangzhou', NULL),
	('0022_0000000010', NULL, '0022_0000000010', 'umadmin', '2020-05-22 18:05:10', 'umadmin', '2020-05-20 11:59:27', 37, 'ALI_HZ_PRD2', NULL, 'ALI_HZ_PRD2', '', '', '0006_0000000004', '0012_0000000002', 'ZONE', 'regionId=cn-hangzhou;regionGroup=cn-hangzhou-MAZ10', '阿里云杭州生产数据中心2', '0022_0000000009', 'created', 'cn-hangzhou-i', 'cn-hangzhou', NULL),
	('0022_0000000011', NULL, '0022_0000000011', 'umadmin', '2020-05-21 14:57:33', 'umadmin', '2020-05-20 11:59:27', 37, 'ALI_HZ_PRD1', NULL, 'ALI_HZ_PRD1', '', '', '0006_0000000004', '0012_0000000002', 'ZONE', 'regionId=cn-hangzhou;regionGroup=cn-hangzhou-MAZ10', '阿里云杭州生产数据中心1', '0022_0000000009', 'created', 'cn-hangzhou-h', 'cn-hangzhou', NULL),
	('0022_0000000016', NULL, '0022_0000000016', 'umadmin', '2020-05-23 13:20:37', 'umadmin', '2020-05-22 17:59:23', 37, 'TX_BJ_PRD', NULL, 'TX_BJ_PRD', '', '', '0006_0000000002', '0012_0000000002', 'REGION', 'Region=ap-beijing', '腾讯云北京生产数据中心', '', 'created', '', 'ap-beijing', ''),
	('0022_0000000017', NULL, '0022_0000000017', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 18:04:02', 37, 'TX_BJ_PRD2', NULL, 'TX_BJ_PRD2', '', '', '0006_0000000002', '0012_0000000002', 'ZONE', 'Region=ap-beijing;AvailableZone=ap-beijing-5', '腾讯云北京生产数据中心2', '0022_0000000016', 'created', 'ap-beijing-5', 'ap-beijing', NULL),
	('0022_0000000018', NULL, '0022_0000000018', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 18:04:02', 37, 'TX_BJ_PRD1', NULL, 'TX_BJ_PRD1', '', '', '0006_0000000002', '0012_0000000002', 'ZONE', 'Region=ap-beijing;AvailableZone=ap-beijing-4', '腾讯云北京生产数据中心1', '0022_0000000016', 'created', 'ap-beijing-4', 'ap-beijing', NULL);
/*!40000 ALTER TABLE `data_center` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.data_center$deploy_environment: ~13 rows (approximately)
/*!40000 ALTER TABLE `data_center$deploy_environment` DISABLE KEYS */;
INSERT INTO `data_center$deploy_environment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(8, '0022_0000000006', '0003_0000000002', 2),
	(9, '0022_0000000006', '0003_0000000001', 1),
	(34, '0022_0000000011', '0003_0000000001', 1),
	(36, '0022_0000000009', '0003_0000000001', 1),
	(44, '0022_0000000010', '0003_0000000001', 1),
	(45, '0022_0000000017', '0003_0000000001', 1),
	(46, '0022_0000000018', '0003_0000000001', 1),
	(47, '0022_0000000016', '0003_0000000001', 1),
	(48, '0022_0000000004', '0003_0000000002', 1),
	(49, '0022_0000000005', '0003_0000000001', 1),
	(50, '0022_0000000003', '0003_0000000001', 1),
	(51, '0022_0000000002', '0003_0000000002', 1),
	(52, '0022_0000000001', '0003_0000000001', 1);
/*!40000 ALTER TABLE `data_center$deploy_environment` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.data_center_design: ~2 rows (approximately)
/*!40000 ALTER TABLE `data_center_design` DISABLE KEYS */;
INSERT INTO `data_center_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0012_0000000001', NULL, '0012_0000000001', 'umadmin', '2020-06-30 15:38:01', 'umadmin', '2020-04-12 00:00:02', 34, 'PCD', NULL, 'PCD', '公有云机房', '公有云机房-分布式架构', 'new'),
	('0012_0000000002', NULL, '0012_0000000002', 'umadmin', '2020-05-20 10:05:43', 'umadmin', '2020-05-20 10:05:43', 34, 'DC', NULL, 'DC', '公有云机房-通用版', '公有云机房-通用版', 'new');
/*!40000 ALTER TABLE `data_center_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.default_security_policy: ~126 rows (approximately)
/*!40000 ALTER TABLE `default_security_policy` DISABLE KEYS */;
INSERT INTO `default_security_policy` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `default_security_policy_design`, `policy_network_segment`, `owner_network_segment`, `port`, `protocol`, `security_policy_action`, `security_policy_type`, `state_code`, `security_policy_asset_id`) VALUES
	('0025_0000000003', NULL, '0025_0000000003', 'umadmin', '2020-05-23 23:13:30', 'umadmin', '2020-04-28 22:16:53', 37, 'HW_SG_PRD_SF__ingress_1-65535__HW_SG_PRD_SF', NULL, 'ingress_1-65535', '', '0015_0000000003', '0023_0000000003', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000004', NULL, '0025_0000000004', 'umadmin', '2020-05-23 23:13:29', 'umadmin', '2020-04-28 22:16:53', 37, 'HW_SG_PRD_DMZ__ingress_1-65535__HW_SG_PRD_DMZ', NULL, 'ingress_1-65535', '', '0015_0000000004', '0023_0000000004', '0023_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000005', NULL, '0025_0000000005', 'umadmin', '2020-05-23 23:13:29', 'umadmin', '2020-04-28 22:16:53', 37, 'HW_SG_PRD_ECN__egress_1-65535__HW_SG_PRD_ECN', NULL, 'egress_1-65535', '', '0015_0000000007', '0023_0000000005', '0023_0000000005', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000006', NULL, '0025_0000000006', 'umadmin', '2020-05-23 23:13:28', 'umadmin', '2020-04-28 22:16:54', 37, 'HW_SG_PRD_ECN__ingress_1-65535__HW_SG_PRD_ECN', NULL, 'ingress_1-65535', '', '0015_0000000006', '0023_0000000005', '0023_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000007', NULL, '0025_0000000007', 'umadmin', '2020-05-23 23:13:27', 'umadmin', '2020-04-28 22:16:54', 37, 'HW_SG_PRD_DMZ__egress_1-65535__HW_SG_PRD_DMZ', NULL, 'egress_1-65535', '', '0015_0000000005', '0023_0000000004', '0023_0000000004', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000008', NULL, '0025_0000000008', 'umadmin', '2020-05-23 23:13:27', 'umadmin', '2020-04-28 22:16:54', 37, 'HW_SG_PRD_MGMT__egress_1-65535__HW_SG_PRD_MGMT', NULL, 'egress_1-65535', '', '0015_0000000009', '0023_0000000006', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000009', NULL, '0025_0000000009', 'umadmin', '2020-05-23 23:13:26', 'umadmin', '2020-04-28 22:16:55', 37, 'HW_SG_PRD_MGMT__ingress_1-65535__HW_SG_PRD_MGMT', NULL, 'ingress_1-65535', '', '0015_0000000008', '0023_0000000006', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000010', NULL, '0025_0000000010', 'umadmin', '2020-05-23 23:13:25', 'umadmin', '2020-04-28 22:16:55', 37, 'HW_SG_PRD_QZ__egress_1-65535__HW_SG_PRD_QZ', NULL, 'egress_1-65535', '', '0015_0000000011', '0023_0000000007', '0023_0000000007', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000011', NULL, '0025_0000000011', 'umadmin', '2020-05-23 23:13:15', 'umadmin', '2020-04-28 22:16:56', 37, 'HW_SG_PRD_QZ__ingress_1-65535__HW_SG_PRD_QZ', NULL, 'ingress_1-65535', '', '0015_0000000010', '0023_0000000007', '0023_0000000007', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000012', NULL, '0025_0000000012', 'umadmin', '2020-05-23 23:13:15', 'umadmin', '2020-04-28 22:19:10', 37, 'HW_SG_PRD_SF__ingress_10000-19999__HW_SG_PRD_ECN', NULL, 'ingress_10000-19999', '', '0015_0000000013', '0023_0000000005', '0023_0000000003', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000013', NULL, '0025_0000000013', 'umadmin', '2020-05-23 23:13:14', 'umadmin', '2020-04-28 22:19:10', 37, 'HW_SG_PRD_SF__ingress_10000-19999__HW_SG_PRD_DMZ', NULL, 'ingress_10000-19999', '', '0015_0000000012', '0023_0000000004', '0023_0000000003', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000014', NULL, '0025_0000000014', 'umadmin', '2020-05-23 23:13:14', 'umadmin', '2020-04-28 22:19:11', 37, 'HW_SG_PRD_SF__ingress_80-443__HW_SG_PRD_QZ', NULL, 'ingress_80-443', '', '0015_0000000015', '0023_0000000007', '0023_0000000003', '80-443', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000015', NULL, '0025_0000000015', 'umadmin', '2020-05-23 23:13:13', 'umadmin', '2020-04-28 22:19:11', 37, 'HW_SG_PRD_SF__ingress_1-65535__HW_SG_PRD1_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000014', '0023_0000000020', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000016', NULL, '0025_0000000016', 'umadmin', '2020-05-23 23:13:13', 'umadmin', '2020-04-28 22:19:11', 37, 'HW_SG_PRD_SF__ingress_1-65535__HW_SG_PRD2_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000014', '0023_0000000021', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000017', NULL, '0025_0000000017', 'umadmin', '2020-05-23 23:13:12', 'umadmin', '2020-04-28 22:19:12', 37, 'HW_SG_PRD_DMZ__ingress_1-65535__HW_SG_PRD1_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000016', '0023_0000000020', '0023_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000018', NULL, '0025_0000000018', 'umadmin', '2020-05-23 23:13:12', 'umadmin', '2020-04-28 22:19:12', 37, 'HW_SG_PRD_DMZ__ingress_1-65535__HW_SG_PRD2_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000016', '0023_0000000021', '0023_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000019', NULL, '0025_0000000019', 'umadmin', '2020-05-23 23:13:12', 'umadmin', '2020-04-28 22:19:12', 37, 'HW_SG_PRD_ECN__ingress_1-65535__HW_SG_PRD1_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000017', '0023_0000000020', '0023_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000020', NULL, '0025_0000000020', 'umadmin', '2020-05-23 23:13:12', 'umadmin', '2020-04-28 22:19:13', 37, 'HW_SG_PRD_ECN__ingress_1-65535__HW_SG_PRD2_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000017', '0023_0000000021', '0023_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000021', NULL, '0025_0000000021', 'umadmin', '2020-05-23 23:13:10', 'umadmin', '2020-04-28 22:19:13', 37, 'HW_SG_PRD_MGMT__egress_1-65535__HW_SG_PRD_ECN', NULL, 'egress_1-65535', '', '0015_0000000022', '0023_0000000005', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000022', NULL, '0025_0000000022', 'umadmin', '2020-05-23 23:12:57', 'umadmin', '2020-04-28 22:36:56', 37, 'HW_SG_PRD_MGMT__egress_1-65535__HW_SG_PRD_DMZ', NULL, 'egress_1-65535', '', '0015_0000000021', '0023_0000000004', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000023', NULL, '0025_0000000023', 'umadmin', '2020-05-23 23:12:57', 'umadmin', '2020-04-28 22:36:56', 37, 'HW_SG_PRD_MGMT__egress_1-65535__HW_SG_PRD_SF', NULL, 'egress_1-65535', '', '0015_0000000020', '0023_0000000003', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000028', NULL, '0025_0000000028', 'umadmin', '2020-05-23 23:12:57', 'umadmin', '2020-04-28 23:05:47', 37, 'TX_SG_DR_MGMT__egress_1-65535__TX_SG_DR_DMZ', NULL, 'egress_1-65535', '', '0015_0000000021', '0023_0000000041', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000029', NULL, '0025_0000000029', 'umadmin', '2020-05-23 23:12:57', 'umadmin', '2020-04-28 23:05:48', 37, 'TX_SG_DR_MGMT__egress_1-65535__TX_SG_DR_SF', NULL, 'egress_1-65535', '', '0015_0000000020', '0023_0000000043', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000030', NULL, '0025_0000000030', 'umadmin', '2020-05-23 23:13:12', 'umadmin', '2020-04-28 23:05:48', 37, 'TX_SG_DR_ECN__ingress_1-65535__TX_SG_DR1_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000017', '0023_0000000049', '0023_0000000042', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000031', NULL, '0025_0000000031', 'umadmin', '2020-05-23 23:13:10', 'umadmin', '2020-04-28 23:05:48', 37, 'TX_SG_DR_MGMT__egress_1-65535__TX_SG_DR_ECN', NULL, 'egress_1-65535', '', '0015_0000000022', '0023_0000000042', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000032', NULL, '0025_0000000032', 'umadmin', '2020-05-23 23:13:12', 'umadmin', '2020-04-28 23:05:49', 37, 'TX_SG_DR_DMZ__ingress_1-65535__TX_SG_DR1_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000016', '0023_0000000049', '0023_0000000041', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000034', NULL, '0025_0000000034', 'umadmin', '2020-05-23 23:13:30', 'umadmin', '2020-04-28 23:05:49', 37, 'TX_SG_DR_SF__ingress_1-65535__HW_SG_PRD_SF', NULL, 'ingress_1-65535', '', '0015_0000000003', '0023_0000000003', '0023_0000000043', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000035', NULL, '0025_0000000035', 'umadmin', '2020-05-23 23:13:14', 'umadmin', '2020-04-28 23:05:50', 37, 'TX_SG_DR_SF__ingress_80-443__TX_SG_DR_QZ', NULL, 'ingress_80-443', '', '0015_0000000015', '0023_0000000039', '0023_0000000043', '80-443', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000036', NULL, '0025_0000000036', 'umadmin', '2020-05-23 23:13:13', 'umadmin', '2020-04-28 23:05:50', 37, 'TX_SG_DR_SF__ingress_1-65535__TX_SG_DR1_MGMT_APP01', NULL, 'ingress_1-65535', '', '0015_0000000014', '0023_0000000049', '0023_0000000043', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000038', NULL, '0025_0000000038', 'umadmin', '2020-05-23 23:13:15', 'umadmin', '2020-04-28 23:05:51', 37, 'TX_SG_DR_SF__ingress_10000-19999__TX_SG_DR_ECN', NULL, 'ingress_10000-19999', '', '0015_0000000013', '0023_0000000042', '0023_0000000043', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000039', NULL, '0025_0000000039', 'umadmin', '2020-05-23 23:13:14', 'umadmin', '2020-04-28 23:05:51', 37, 'TX_SG_DR_SF__ingress_10000-19999__TX_SG_DR_DMZ', NULL, 'ingress_10000-19999', '', '0015_0000000012', '0023_0000000041', '0023_0000000043', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000040', NULL, '0025_0000000040', 'umadmin', '2020-05-23 23:13:15', 'umadmin', '2020-04-28 23:05:51', 37, 'TX_SG_DR_QZ__ingress_1-65535__TX_SG_DR_QZ', NULL, 'ingress_1-65535', '', '0015_0000000010', '0023_0000000039', '0023_0000000039', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000041', NULL, '0025_0000000041', 'umadmin', '2020-05-23 23:13:26', 'umadmin', '2020-04-28 23:05:52', 37, 'TX_SG_DR_MGMT__ingress_1-65535__TX_SG_DR_MGMT', NULL, 'ingress_1-65535', '', '0015_0000000008', '0023_0000000040', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000042', NULL, '0025_0000000042', 'umadmin', '2020-05-23 23:13:25', 'umadmin', '2020-04-28 23:05:52', 37, 'TX_SG_DR_QZ__egress_1-65535__TX_SG_DR_QZ', NULL, 'egress_1-65535', '', '0015_0000000011', '0023_0000000039', '0023_0000000039', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000043', NULL, '0025_0000000043', 'umadmin', '2020-05-23 23:13:28', 'umadmin', '2020-04-28 23:05:53', 37, 'TX_SG_DR_ECN__ingress_1-65535__TX_SG_DR_ECN', NULL, 'ingress_1-65535', '', '0015_0000000006', '0023_0000000042', '0023_0000000042', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000044', NULL, '0025_0000000044', 'umadmin', '2020-05-23 23:13:27', 'umadmin', '2020-04-28 23:05:53', 37, 'TX_SG_DR_DMZ__egress_1-65535__TX_SG_DR_DMZ', NULL, 'egress_1-65535', '', '0015_0000000005', '0023_0000000041', '0023_0000000041', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000045', NULL, '0025_0000000045', 'umadmin', '2020-05-23 23:13:27', 'umadmin', '2020-04-28 23:05:53', 37, 'TX_SG_DR_MGMT__egress_1-65535__TX_SG_DR_MGMT', NULL, 'egress_1-65535', '', '0015_0000000009', '0023_0000000040', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000046', NULL, '0025_0000000046', 'umadmin', '2020-05-23 23:13:30', 'umadmin', '2020-04-28 23:05:54', 37, 'TX_SG_DR_SF__ingress_1-65535__TX_SG_DR_SF', NULL, 'ingress_1-65535', '', '0015_0000000003', '0023_0000000043', '0023_0000000043', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000047', NULL, '0025_0000000047', 'umadmin', '2020-05-23 23:13:29', 'umadmin', '2020-04-28 23:05:54', 37, 'TX_SG_DR_DMZ__ingress_1-65535__TX_SG_DR_DMZ', NULL, 'ingress_1-65535', '', '0015_0000000004', '0023_0000000041', '0023_0000000041', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000048', NULL, '0025_0000000048', 'umadmin', '2020-05-23 23:13:29', 'umadmin', '2020-04-28 23:05:54', 37, 'TX_SG_DR_ECN__egress_1-65535__TX_SG_DR_ECN', NULL, 'egress_1-65535', '', '0015_0000000007', '0023_0000000042', '0023_0000000042', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000050', NULL, '0025_0000000050', 'umadmin', '2020-05-23 23:13:30', 'umadmin', '2020-04-28 23:07:28', 37, 'HW_SG_PRD_SF__ingress_1-65535__TX_SG_DR_SF', NULL, 'ingress_1-65535', '', '0015_0000000003', '0023_0000000043', '0023_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000051', NULL, '0025_0000000051', 'umadmin', '2020-05-23 23:13:26', 'umadmin', '2020-04-28 23:07:28', 37, 'HW_SG_PRD_MGMT__ingress_1-65535__TX_SG_DR_MGMT', NULL, 'ingress_1-65535', '', '0015_0000000008', '0023_0000000040', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000052', NULL, '0025_0000000052', 'umadmin', '2020-05-23 23:13:26', 'umadmin', '2020-04-28 23:07:29', 37, 'TX_SG_DR_MGMT__ingress_1-65535__HW_SG_PRD_MGMT', NULL, 'ingress_1-65535', '', '0015_0000000008', '0023_0000000006', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000053', NULL, '0025_0000000053', 'umadmin', '2020-05-23 23:13:27', 'umadmin', '2020-04-28 23:07:29', 37, 'HW_SG_PRD_MGMT__egress_1-65535__TX_SG_DR_MGMT', NULL, 'egress_1-65535', '', '0015_0000000009', '0023_0000000040', '0023_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000054', NULL, '0025_0000000054', 'umadmin', '2020-05-23 23:13:27', 'umadmin', '2020-04-28 23:07:30', 37, 'TX_SG_DR_MGMT__egress_1-65535__HW_SG_PRD_MGMT', NULL, 'egress_1-65535', '', '0015_0000000009', '0023_0000000006', '0023_0000000040', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000055', NULL, '0025_0000000055', 'umadmin', '2020-05-23 23:12:54', 'umadmin', '2020-05-08 10:46:29', 37, 'TX_GZ_PRD_MGMT__ingress_4000-9999__TX_GZ_PRD_SF', NULL, 'ingress_4000-9999', '', '0015_0000000028', '0023_0000000003', '0023_0000000006', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000056', NULL, '0025_0000000056', 'umadmin', '2020-05-23 23:12:54', 'umadmin', '2020-05-08 10:46:29', 37, 'TX_GZ_PRD_MGMT__ingress_4000-9999__TX_GZ_PRD_ECN', NULL, 'ingress_4000-9999', '', '0015_0000000030', '0023_0000000005', '0023_0000000006', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000057', NULL, '0025_0000000057', 'umadmin', '2020-05-23 23:12:53', 'umadmin', '2020-05-08 10:46:30', 37, 'TX_GZ_PRD_MGMT__ingress_4000-9999__TX_GZ_PRD_DMZ', NULL, 'ingress_4000-9999', '', '0015_0000000029', '0023_0000000004', '0023_0000000006', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000058', NULL, '0025_0000000058', 'umadmin', '2020-05-23 23:12:55', 'umadmin', '2020-05-08 10:47:21', 37, 'TX_GZ_PRD_SF__egress_4000-9999__TX_GZ_PRD1_MGMT_APP01', NULL, 'egress_4000-9999', '', '0015_0000000027', '0023_0000000020', '0023_0000000003', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000059', NULL, '0025_0000000059', 'umadmin', '2020-05-23 23:12:55', 'umadmin', '2020-05-08 10:47:21', 37, 'TX_GZ_PRD_SF__egress_4000-9999__TX_GZ_PRD2_MGMT_APP01', NULL, 'egress_4000-9999', '', '0015_0000000027', '0023_0000000021', '0023_0000000003', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000060', NULL, '0025_0000000060', 'umadmin', '2020-05-23 23:12:55', 'umadmin', '2020-05-08 10:47:22', 37, 'TX_GZ_PRD_ECN__egress_4000-9999__TX_GZ_PRD1_MGMT_APP01', NULL, 'egress_4000-9999', '', '0015_0000000026', '0023_0000000020', '0023_0000000005', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000061', NULL, '0025_0000000061', 'umadmin', '2020-05-23 23:12:55', 'umadmin', '2020-05-08 10:47:22', 37, 'TX_GZ_PRD_ECN__egress_4000-9999__TX_GZ_PRD2_MGMT_APP01', NULL, 'egress_4000-9999', '', '0015_0000000026', '0023_0000000021', '0023_0000000005', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000062', NULL, '0025_0000000062', 'umadmin', '2020-05-23 23:12:56', 'umadmin', '2020-05-08 10:47:22', 37, 'TX_GZ_PRD_DMZ__egress_4000-9999__TX_GZ_PRD1_MGMT_APP01', NULL, 'egress_4000-9999', '', '0015_0000000025', '0023_0000000020', '0023_0000000004', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000063', NULL, '0025_0000000063', 'umadmin', '2020-05-23 23:12:56', 'umadmin', '2020-05-08 10:47:23', 37, 'TX_GZ_PRD_DMZ__egress_4000-9999__TX_GZ_PRD2_MGMT_APP01', NULL, 'egress_4000-9999', '', '0015_0000000025', '0023_0000000021', '0023_0000000004', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000064', NULL, '0025_0000000064', 'umadmin', '2020-05-22 12:39:01', 'umadmin', '2020-05-20 14:09:29', 37, 'ALI_HZ_PRD_MGMT__ingress_443__ALI_HZ_PRD_TON_CLIENT', NULL, 'ingress_443', '', '0015_0000000054', '0023_0000000086', '0023_0000000064', '443', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000065', NULL, '0025_0000000065', 'umadmin', '2020-05-22 12:39:00', 'umadmin', '2020-05-20 14:09:30', 37, 'ALI_HZ_PRD1_DMZ_PROXY__egress_80-443__ALI_HZ_PRD_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000053', '0023_0000000085', '0023_0000000078', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000066', NULL, '0025_0000000066', 'umadmin', '2020-05-22 12:39:01', 'umadmin', '2020-05-20 14:09:30', 37, 'ALI_HZ_PRD2_DMZ_PROXY__egress_80-443__ALI_HZ_PRD_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000053', '0023_0000000085', '0023_0000000079', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000067', NULL, '0025_0000000067', 'umadmin', '2020-05-22 12:39:01', 'umadmin', '2020-05-20 14:09:30', 37, 'ALI_HZ_PRD_MGMT__egress_1-65534__ALI_HZ_PRD_SF', NULL, 'egress_1-65534', '', '0015_0000000051', '0023_0000000063', '0023_0000000064', '1-65534', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000068', NULL, '0025_0000000068', 'umadmin', '2020-05-22 12:39:00', 'umadmin', '2020-05-20 14:09:31', 37, 'ALI_HZ_PRD_MGMT__egress_1-65534__ALI_HZ_PRD_DMZ', NULL, 'egress_1-65534', '', '0015_0000000052', '0023_0000000065', '0023_0000000064', '1-65534', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000069', NULL, '0025_0000000069', 'umadmin', '2020-05-22 12:39:00', 'umadmin', '2020-05-20 14:09:31', 37, 'ALI_HZ_PRD_MGMT__ingress_4000-9999__ALI_HZ_PRD_SF', NULL, 'ingress_4000-9999', '', '0015_0000000049', '0023_0000000063', '0023_0000000064', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000070', NULL, '0025_0000000070', 'umadmin', '2020-05-22 12:39:00', 'umadmin', '2020-05-20 14:09:31', 37, 'ALI_HZ_PRD_MGMT__ingress_4000-9999__ALI_HZ_PRD_DMZ', NULL, 'ingress_4000-9999', '', '0015_0000000050', '0023_0000000065', '0023_0000000064', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000071', NULL, '0025_0000000071', 'umadmin', '2020-05-22 12:38:59', 'umadmin', '2020-05-20 14:09:32', 37, 'ALI_HZ_PRD_SF__egress_4000-9999__ALI_HZ_PRD1_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000047', '0023_0000000072', '0023_0000000063', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000072', NULL, '0025_0000000072', 'umadmin', '2020-05-22 12:38:59', 'umadmin', '2020-05-20 14:09:32', 37, 'ALI_HZ_PRD_SF__egress_4000-9999__ALI_HZ_PRD2_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000047', '0023_0000000073', '0023_0000000063', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000073', NULL, '0025_0000000073', 'umadmin', '2020-05-22 12:38:59', 'umadmin', '2020-05-20 14:09:32', 37, 'ALI_HZ_PRD_DMZ__egress_4000-9999__ALI_HZ_PRD1_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000048', '0023_0000000072', '0023_0000000065', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000074', NULL, '0025_0000000074', 'umadmin', '2020-05-22 12:39:00', 'umadmin', '2020-05-20 14:09:32', 37, 'ALI_HZ_PRD_DMZ__egress_4000-9999__ALI_HZ_PRD2_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000048', '0023_0000000073', '0023_0000000065', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000075', NULL, '0025_0000000075', 'umadmin', '2020-05-22 12:38:58', 'umadmin', '2020-05-20 14:09:33', 37, 'ALI_HZ_PRD_SF__ingress_1-65535__ALI_HZ_PRD1_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000045', '0023_0000000072', '0023_0000000063', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000076', NULL, '0025_0000000076', 'umadmin', '2020-05-22 12:38:58', 'umadmin', '2020-05-20 14:09:33', 37, 'ALI_HZ_PRD_SF__ingress_1-65535__ALI_HZ_PRD2_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000045', '0023_0000000073', '0023_0000000063', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000077', NULL, '0025_0000000077', 'umadmin', '2020-05-22 12:38:59', 'umadmin', '2020-05-20 14:09:33', 37, 'ALI_HZ_PRD_DMZ__ingress_1-65535__ALI_HZ_PRD1_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000046', '0023_0000000072', '0023_0000000065', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000078', NULL, '0025_0000000078', 'umadmin', '2020-05-22 12:38:58', 'umadmin', '2020-05-20 14:09:34', 37, 'ALI_HZ_PRD_DMZ__ingress_1-65535__ALI_HZ_PRD2_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000046', '0023_0000000073', '0023_0000000065', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000079', NULL, '0025_0000000079', 'umadmin', '2020-05-22 12:38:58', 'umadmin', '2020-05-20 14:09:34', 37, 'ALI_HZ_PRD_SF__ingress_10000-19999__ALI_HZ_PRD_DMZ', NULL, 'ingress_10000-19999', '', '0015_0000000043', '0023_0000000065', '0023_0000000063', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000080', NULL, '0025_0000000080', 'umadmin', '2020-05-22 12:38:58', 'umadmin', '2020-05-20 14:09:34', 37, 'ALI_HZ_PRD_DMZ__ingress_10000-19999__ALI_HZ_PRD_SF', NULL, 'ingress_10000-19999', '', '0015_0000000044', '0023_0000000063', '0023_0000000065', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000081', NULL, '0025_0000000081', 'umadmin', '2020-05-22 12:38:57', 'umadmin', '2020-05-20 14:09:35', 37, 'ALI_HZ_PRD_MGMT__egress_1-65535__ALI_HZ_PRD_MGMT', NULL, 'egress_1-65535', '', '0015_0000000042', '0023_0000000064', '0023_0000000064', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000082', NULL, '0025_0000000082', 'umadmin', '2020-05-22 12:38:57', 'umadmin', '2020-05-20 14:09:35', 37, 'ALI_HZ_PRD_MGMT__ingress_1-65535__ALI_HZ_PRD_MGMT', NULL, 'ingress_1-65535', '', '0015_0000000041', '0023_0000000064', '0023_0000000064', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000083', NULL, '0025_0000000083', 'umadmin', '2020-05-22 18:37:18', 'umadmin', '2020-05-20 14:09:35', 37, 'ALI_HZ_PRD_DMZ__egress_1-65535__ALI_HZ_PRD1_DMZ_PROXY', NULL, 'egress_3128', '', '0015_0000000040', '0023_0000000078', '0023_0000000065', '3128', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000084', NULL, '0025_0000000084', 'umadmin', '2020-05-22 12:38:57', 'umadmin', '2020-05-20 14:10:27', 37, 'ALI_HZ_PRD_DMZ__ingress_1-65535__ALI_HZ_PRD_DMZ', NULL, 'ingress_1-65535', '', '0015_0000000039', '0023_0000000065', '0023_0000000065', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000086', NULL, '0025_0000000086', 'umadmin', '2020-05-22 12:38:56', 'umadmin', '2020-05-20 14:10:28', 37, 'ALI_HZ_PRD_SF__ingress_1-65535__ALI_HZ_PRD_SF', NULL, 'ingress_1-65535', '', '0015_0000000037', '0023_0000000063', '0023_0000000063', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000087', NULL, '0025_0000000087', 'umadmin', '2020-05-22 18:37:18', 'umadmin', '2020-05-22 18:35:43', 37, 'ALI_HZ_PRD_DMZ__egress_1-65535__ALI_HZ_PRD2_DMZ_PROXY', NULL, 'egress_3128', '', '0015_0000000040', '0023_0000000079', '0023_0000000065', '3128', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000088', NULL, '0025_0000000088', 'umadmin', '2020-05-22 19:20:51', 'umadmin', '2020-05-22 19:20:51', 37, 'TX_BJ_PRD2_DMZ_PROXY__egress_80-443__TX_BJ_PRD_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000053', '0023_0000000095', '0023_0000000104', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000089', NULL, '0025_0000000089', 'umadmin', '2020-05-22 19:20:52', 'umadmin', '2020-05-22 19:20:51', 37, 'TX_BJ_PRD_MGMT__egress_1-65534__TX_BJ_PRD_SF', NULL, 'egress_1-65534', '', '0015_0000000051', '0023_0000000090', '0023_0000000088', '1-65534', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000090', NULL, '0025_0000000090', 'umadmin', '2020-05-22 19:20:52', 'umadmin', '2020-05-22 19:20:52', 37, 'TX_BJ_PRD_MGMT__ingress_443__TX_BJ_PRD_TON_CLIENT', NULL, 'ingress_443', '', '0015_0000000054', '0023_0000000094', '0023_0000000088', '443', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000091', NULL, '0025_0000000091', 'umadmin', '2020-05-22 19:22:05', 'umadmin', '2020-05-22 19:22:05', 37, 'TX_BJ_PRD_SF__ingress_1-65535__TX_BJ_PRD2_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000045', '0023_0000000105', '0023_0000000090', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000092', NULL, '0025_0000000092', 'umadmin', '2020-05-22 19:22:06', 'umadmin', '2020-05-22 19:22:05', 37, 'TX_BJ_PRD_DMZ__ingress_1-65535__TX_BJ_PRD1_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000046', '0023_0000000099', '0023_0000000089', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000093', NULL, '0025_0000000093', 'umadmin', '2020-05-22 19:22:06', 'umadmin', '2020-05-22 19:22:06', 37, 'TX_BJ_PRD_SF__egress_4000-9999__TX_BJ_PRD1_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000047', '0023_0000000099', '0023_0000000090', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000094', NULL, '0025_0000000094', 'umadmin', '2020-05-22 19:22:06', 'umadmin', '2020-05-22 19:22:06', 37, 'TX_BJ_PRD_SF__egress_4000-9999__TX_BJ_PRD2_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000047', '0023_0000000105', '0023_0000000090', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000095', NULL, '0025_0000000095', 'umadmin', '2020-05-22 19:22:07', 'umadmin', '2020-05-22 19:22:06', 37, 'TX_BJ_PRD_DMZ__egress_4000-9999__TX_BJ_PRD1_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000048', '0023_0000000099', '0023_0000000089', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000096', NULL, '0025_0000000096', 'umadmin', '2020-05-22 19:22:07', 'umadmin', '2020-05-22 19:22:07', 37, 'TX_BJ_PRD_DMZ__egress_4000-9999__TX_BJ_PRD2_MGMT_APP', NULL, 'egress_4000-9999', '', '0015_0000000048', '0023_0000000105', '0023_0000000089', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000097', NULL, '0025_0000000097', 'umadmin', '2020-05-22 19:22:07', 'umadmin', '2020-05-22 19:22:07', 37, 'TX_BJ_PRD_MGMT__egress_1-65534__TX_BJ_PRD_DMZ', NULL, 'egress_1-65534', '', '0015_0000000052', '0023_0000000089', '0023_0000000088', '1-65534', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000098', NULL, '0025_0000000098', 'umadmin', '2020-05-22 19:22:08', 'umadmin', '2020-05-22 19:22:07', 37, 'TX_BJ_PRD_MGMT__ingress_4000-9999__TX_BJ_PRD_SF', NULL, 'ingress_4000-9999', '', '0015_0000000049', '0023_0000000090', '0023_0000000088', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000099', NULL, '0025_0000000099', 'umadmin', '2020-05-22 19:22:08', 'umadmin', '2020-05-22 19:22:08', 37, 'TX_BJ_PRD_MGMT__ingress_4000-9999__TX_BJ_PRD_DMZ', NULL, 'ingress_4000-9999', '', '0015_0000000050', '0023_0000000089', '0023_0000000088', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000100', NULL, '0025_0000000100', 'umadmin', '2020-05-22 19:22:08', 'umadmin', '2020-05-22 19:22:08', 37, 'TX_BJ_PRD1_DMZ_PROXY__egress_80-443__TX_BJ_PRD_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000053', '0023_0000000095', '0023_0000000097', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000101', NULL, '0025_0000000101', 'umadmin', '2020-05-22 19:23:25', 'umadmin', '2020-05-22 19:23:24', 37, 'TX_BJ_PRD_DMZ__egress_3128__TX_BJ_PRD2_DMZ_PROXY', NULL, 'egress_3128', '', '0015_0000000040', '0023_0000000104', '0023_0000000089', '3128', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000102', NULL, '0025_0000000102', 'umadmin', '2020-05-22 19:23:25', 'umadmin', '2020-05-22 19:23:25', 37, 'TX_BJ_PRD_SF__ingress_1-65535__TX_BJ_PRD_SF', NULL, 'ingress_1-65535', '', '0015_0000000037', '0023_0000000090', '0023_0000000090', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000103', NULL, '0025_0000000103', 'umadmin', '2020-05-22 19:23:25', 'umadmin', '2020-05-22 19:23:25', 37, 'TX_BJ_PRD_DMZ__ingress_1-65535__TX_BJ_PRD_DMZ', NULL, 'ingress_1-65535', '', '0015_0000000039', '0023_0000000089', '0023_0000000089', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000104', NULL, '0025_0000000104', 'umadmin', '2020-05-22 19:23:25', 'umadmin', '2020-05-22 19:23:25', 37, 'TX_BJ_PRD_MGMT__egress_1-65535__TX_BJ_PRD_MGMT', NULL, 'egress_1-65535', '', '0015_0000000042', '0023_0000000088', '0023_0000000088', '1-65535', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000105', NULL, '0025_0000000105', 'umadmin', '2020-05-22 19:23:26', 'umadmin', '2020-05-22 19:23:26', 37, 'TX_BJ_PRD_MGMT__ingress_1-65535__TX_BJ_PRD_MGMT', NULL, 'ingress_1-65535', '', '0015_0000000041', '0023_0000000088', '0023_0000000088', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000106', NULL, '0025_0000000106', 'umadmin', '2020-05-22 19:23:26', 'umadmin', '2020-05-22 19:23:26', 37, 'TX_BJ_PRD_DMZ__egress_3128__TX_BJ_PRD1_DMZ_PROXY', NULL, 'egress_3128', '', '0015_0000000040', '0023_0000000097', '0023_0000000089', '3128', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000107', NULL, '0025_0000000107', 'umadmin', '2020-05-22 19:23:26', 'umadmin', '2020-05-22 19:23:26', 37, 'TX_BJ_PRD_DMZ__ingress_1-65535__TX_BJ_PRD2_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000046', '0023_0000000105', '0023_0000000089', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000108', NULL, '0025_0000000108', 'umadmin', '2020-05-22 19:23:27', 'umadmin', '2020-05-22 19:23:26', 37, 'TX_BJ_PRD_SF__ingress_10000-19999__TX_BJ_PRD_DMZ', NULL, 'ingress_10000-19999', '', '0015_0000000043', '0023_0000000089', '0023_0000000090', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000109', NULL, '0025_0000000109', 'umadmin', '2020-05-22 19:23:27', 'umadmin', '2020-05-22 19:23:27', 37, 'TX_BJ_PRD_DMZ__ingress_10000-19999__TX_BJ_PRD_SF', NULL, 'ingress_10000-19999', '', '0015_0000000044', '0023_0000000090', '0023_0000000089', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000110', NULL, '0025_0000000110', 'umadmin', '2020-05-22 19:23:27', 'umadmin', '2020-05-22 19:23:27', 37, 'TX_BJ_PRD_SF__ingress_1-65535__TX_BJ_PRD1_MGMT_APP', NULL, 'ingress_1-65535', '', '0015_0000000045', '0023_0000000099', '0023_0000000090', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000111', NULL, '0025_0000000111', 'umadmin', '2020-05-23 23:12:52', 'umadmin', '2020-05-23 19:04:10', 37, 'TX_GZ_PRD1_DMZ_PROXY01__egress_80-443__ODC_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000056', '0023_0000000037', '0023_0000000012', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000112', NULL, '0025_0000000112', 'umadmin', '2020-05-23 23:12:52', 'umadmin', '2020-05-23 19:04:10', 37, 'TX_GZ_PRD2_DMZ_PROXY01__egress_80-443__ODC_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000056', '0023_0000000037', '0023_0000000013', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000113', NULL, '0025_0000000113', 'umadmin', '2020-05-23 23:12:52', 'umadmin', '2020-05-23 19:04:11', 37, 'TX_CD_DR1_DMZ_PROXY01__egress_80-443__ODC_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000056', '0023_0000000037', '0023_0000000053', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000114', NULL, '0025_0000000114', 'umadmin', '2020-05-23 23:12:53', 'umadmin', '2020-05-23 19:04:11', 37, 'TX_GZ_PRD1_MGMT_PROXY01__egress_80-443__ODC_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000057', '0023_0000000037', '0023_0000000024', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000115', NULL, '0025_0000000115', 'umadmin', '2020-05-23 23:12:53', 'umadmin', '2020-05-23 19:04:11', 37, 'TX_GZ_PRD2_MGMT_PROXY01__egress_80-443__ODC_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000057', '0023_0000000037', '0023_0000000025', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000116', NULL, '0025_0000000116', 'umadmin', '2020-05-23 23:12:53', 'umadmin', '2020-05-23 19:04:12', 37, 'TX_CD_DR1_MGMT_PROXY01__egress_80-443__ODC_WAN_ALL', NULL, 'egress_80-443', '', '0015_0000000057', '0023_0000000037', '0023_0000000047', '80-443', 'TCP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000117', NULL, '0025_0000000117', 'umadmin', '2020-05-23 23:10:06', 'umadmin', '2020-05-23 23:10:05', 37, 'TX_BJ_PRD_DMZ__ingress_10000-19999__TX_BJ_PRD_WAN_ALL', NULL, 'ingress_10000-19999', '', '0015_0000000055', '0023_0000000095', '0023_0000000089', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000118', NULL, '0025_0000000118', 'umadmin', '2020-05-23 23:10:35', 'umadmin', '2020-05-23 23:10:35', 37, 'ALI_HZ_PRD_DMZ__ingress_10000-19999__ALI_HZ_PRD_WAN_ALL', NULL, 'ingress_10000-19999', '', '0015_0000000055', '0023_0000000085', '0023_0000000065', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000119', NULL, '0025_0000000119', 'umadmin', '2020-05-23 23:17:22', 'umadmin', '2020-05-23 23:17:22', 37, 'TX_GZ_PRD_DMZ__ingress_10000-19999__ODC_WAN_ALL', NULL, 'ingress_10000-19999', '', '0015_0000000058', '0023_0000000037', '0023_0000000004', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000120', NULL, '0025_0000000120', 'umadmin', '2020-05-23 23:17:22', 'umadmin', '2020-05-23 23:17:22', 37, 'TX_CD_DR_DMZ__ingress_10000-19999__ODC_WAN_ALL', NULL, 'ingress_10000-19999', '', '0015_0000000058', '0023_0000000037', '0023_0000000041', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000121', NULL, '0025_0000000121', 'umadmin', '2020-05-25 13:14:18', 'umadmin', '2020-05-25 13:14:18', 37, 'TX_BJ_PRD_DMZ__ingress_-1__TX_BJ_PRD1_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000066', '0023_0000000099', '0023_0000000089', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000122', NULL, '0025_0000000122', 'umadmin', '2020-05-25 13:14:19', 'umadmin', '2020-05-25 13:14:18', 37, 'TX_BJ_PRD_DMZ__ingress_-1__TX_BJ_PRD2_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000066', '0023_0000000105', '0023_0000000089', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000123', NULL, '0025_0000000123', 'umadmin', '2020-05-25 13:14:19', 'umadmin', '2020-05-25 13:14:19', 37, 'TX_BJ_PRD_SF__ingress_-1__TX_BJ_PRD1_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000065', '0023_0000000099', '0023_0000000090', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000124', NULL, '0025_0000000124', 'umadmin', '2020-05-25 13:14:19', 'umadmin', '2020-05-25 13:14:19', 37, 'TX_BJ_PRD_SF__ingress_-1__TX_BJ_PRD2_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000065', '0023_0000000105', '0023_0000000090', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000125', NULL, '0025_0000000125', 'umadmin', '2020-05-25 13:14:20', 'umadmin', '2020-05-25 13:14:20', 37, 'TX_BJ_PRD_MGMT__ingress_-1__TX_BJ_PRD_MGMT', NULL, 'ingress_-1', '', '0015_0000000067', '0023_0000000088', '0023_0000000088', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000126', NULL, '0025_0000000126', 'umadmin', '2020-05-25 13:14:20', 'umadmin', '2020-05-25 13:14:20', 37, 'TX_BJ_PRD_MGMT__egress_-1__TX_BJ_PRD_SF', NULL, 'egress_-1', '', '0015_0000000068', '0023_0000000090', '0023_0000000088', '-1', 'ICMP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000127', NULL, '0025_0000000127', 'umadmin', '2020-05-25 13:14:41', 'umadmin', '2020-05-25 13:14:41', 37, 'TX_BJ_PRD_MGMT__egress_-1__TX_BJ_PRD_MGMT', NULL, 'egress_-1', '', '0015_0000000070', '0023_0000000088', '0023_0000000088', '-1', 'ICMP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000128', NULL, '0025_0000000128', 'umadmin', '2020-05-25 13:14:41', 'umadmin', '2020-05-25 13:14:41', 37, 'TX_BJ_PRD_MGMT__egress_-1__TX_BJ_PRD_DMZ', NULL, 'egress_-1', '', '0015_0000000069', '0023_0000000089', '0023_0000000088', '-1', 'ICMP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000129', NULL, '0025_0000000129', 'umadmin', '2020-05-25 13:17:14', 'umadmin', '2020-05-25 13:17:14', 37, 'ALI_HZ_PRD_DMZ__ingress_-1__ALI_HZ_PRD1_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000066', '0023_0000000072', '0023_0000000065', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000130', NULL, '0025_0000000130', 'umadmin', '2020-05-25 13:17:15', 'umadmin', '2020-05-25 13:17:14', 37, 'ALI_HZ_PRD_DMZ__ingress_-1__ALI_HZ_PRD2_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000066', '0023_0000000073', '0023_0000000065', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000131', NULL, '0025_0000000131', 'umadmin', '2020-05-25 13:17:15', 'umadmin', '2020-05-25 13:17:15', 37, 'ALI_HZ_PRD_SF__ingress_-1__ALI_HZ_PRD1_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000065', '0023_0000000072', '0023_0000000063', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000132', NULL, '0025_0000000132', 'umadmin', '2020-05-25 13:17:15', 'umadmin', '2020-05-25 13:17:15', 37, 'ALI_HZ_PRD_SF__ingress_-1__ALI_HZ_PRD2_MGMT_APP', NULL, 'ingress_-1', '', '0015_0000000065', '0023_0000000073', '0023_0000000063', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000133', NULL, '0025_0000000133', 'umadmin', '2020-05-25 13:17:16', 'umadmin', '2020-05-25 13:17:15', 37, 'ALI_HZ_PRD_MGMT__ingress_-1__ALI_HZ_PRD_MGMT', NULL, 'ingress_-1', '', '0015_0000000067', '0023_0000000064', '0023_0000000064', '-1', 'ICMP', 'ACCEPT', 'ingress', 'created', ''),
	('0025_0000000134', NULL, '0025_0000000134', 'umadmin', '2020-05-25 13:17:16', 'umadmin', '2020-05-25 13:17:16', 37, 'ALI_HZ_PRD_MGMT__egress_-1__ALI_HZ_PRD_SF', NULL, 'egress_-1', '', '0015_0000000068', '0023_0000000063', '0023_0000000064', '-1', 'ICMP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000135', NULL, '0025_0000000135', 'umadmin', '2020-05-25 13:17:16', 'umadmin', '2020-05-25 13:17:16', 37, 'ALI_HZ_PRD_MGMT__egress_-1__ALI_HZ_PRD_MGMT', NULL, 'egress_-1', '', '0015_0000000070', '0023_0000000064', '0023_0000000064', '-1', 'ICMP', 'ACCEPT', 'egress', 'created', ''),
	('0025_0000000136', NULL, '0025_0000000136', 'umadmin', '2020-05-25 13:17:17', 'umadmin', '2020-05-25 13:17:16', 37, 'ALI_HZ_PRD_MGMT__egress_-1__ALI_HZ_PRD_DMZ', NULL, 'egress_-1', '', '0015_0000000069', '0023_0000000065', '0023_0000000064', '-1', 'ICMP', 'ACCEPT', 'egress', 'created', '');
/*!40000 ALTER TABLE `default_security_policy` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.default_security_policy_design: ~53 rows (approximately)
/*!40000 ALTER TABLE `default_security_policy_design` DISABLE KEYS */;
INSERT INTO `default_security_policy_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `policy_network_segment_design`, `owner_network_segment_design`, `port`, `protocol`, `security_policy_action`, `security_policy_type`, `state_code`) VALUES
	('0015_0000000003', NULL, '0015_0000000003', 'umadmin', '2020-06-30 15:37:50', 'umadmin', '2020-04-28 21:28:46', 34, 'PCD_SF__ingress_1-65535__PCD_SF', NULL, 'ingress_1-65535', '区域内部互联', '0013_0000000003', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000004', NULL, '0015_0000000004', 'umadmin', '2020-06-30 15:37:50', 'umadmin', '2020-04-28 21:29:47', 34, 'PCD_DMZ__ingress_1-65535__PCD_DMZ', NULL, 'ingress_1-65535', '区域内部互联', '0013_0000000004', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000005', NULL, '0015_0000000005', 'umadmin', '2020-06-30 15:37:50', 'umadmin', '2020-04-28 21:29:48', 34, 'PCD_DMZ__egress_1-65535__PCD_DMZ', NULL, 'egress_1-65535', '区域内部互联', '0013_0000000004', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000006', NULL, '0015_0000000006', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:29:48', 34, 'PCD_ECN__ingress_1-65535__PCD_ECN', NULL, 'ingress_1-65535', '区域内部互联', '0013_0000000005', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000007', NULL, '0015_0000000007', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:29:48', 34, 'PCD_ECN__egress_1-65535__PCD_ECN', NULL, 'egress_1-65535', '区域内部互联', '0013_0000000005', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000008', NULL, '0015_0000000008', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:29:49', 34, 'PCD_MGMT__ingress_1-65535__PCD_MGMT', NULL, 'ingress_1-65535', '区域内部互联', '0013_0000000006', '0013_0000000006', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000009', NULL, '0015_0000000009', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:29:49', 34, 'PCD_MGMT__egress_1-65535__PCD_MGMT', NULL, 'egress_1-65535', '区域内部互联', '0013_0000000006', '0013_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000010', NULL, '0015_0000000010', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:29:50', 34, 'PCD_QZ__ingress_1-65535__PCD_QZ', NULL, 'ingress_1-65535', '区域内部互联', '0013_0000000007', '0013_0000000007', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000011', NULL, '0015_0000000011', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:29:50', 34, 'PCD_QZ__egress_1-65535__PCD_QZ', NULL, 'egress_1-65535', '区域内部互联', '0013_0000000007', '0013_0000000007', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000012', NULL, '0015_0000000012', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:34:07', 34, 'PCD_SF__ingress_10000-19999__PCD_DMZ', NULL, 'ingress_10000-19999', '面向DMZ开放10000-19999', '0013_0000000004', '0013_0000000003', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000013', NULL, '0015_0000000013', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:34:07', 34, 'PCD_SF__ingress_10000-19999__PCD_ECN', NULL, 'ingress_10000-19999', '面向ECN开放10000-19999', '0013_0000000005', '0013_0000000003', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000014', NULL, '0015_0000000014', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:34:08', 34, 'PCD_SF__ingress_1-65535__PCD_MGMT_APP', NULL, 'ingress_1-65535', '面向MGMT开放1-65535', '0013_0000000022', '0013_0000000003', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000015', NULL, '0015_0000000015', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:34:08', 34, 'PCD_SF__ingress_80-443__PCD_QZ', NULL, 'ingress_80-443', '面向QZ开放80-443', '0013_0000000007', '0013_0000000003', '80-443', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000016', NULL, '0015_0000000016', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:35:31', 34, 'PCD_DMZ__ingress_1-65535__PCD_MGMT_APP', NULL, 'ingress_1-65535', '面向MGMT_APP开放1-65535', '0013_0000000022', '0013_0000000004', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000017', NULL, '0015_0000000017', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:35:41', 34, 'PCD_ECN__ingress_1-65535__PCD_MGMT_APP', NULL, 'ingress_1-65535', '面向MGMT_APP开放1-65535', '0013_0000000022', '0013_0000000005', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000018', NULL, '0015_0000000018', 'umadmin', '2020-06-30 15:37:51', 'umadmin', '2020-04-28 21:36:59', 34, 'PCD_ECN__ingress_10000-19999__PCD_SF_APP', NULL, 'ingress_10000-19999', '面向SF_APP开放10000-19999', '0013_0000000014', '0013_0000000005', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000019', NULL, '0015_0000000019', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-04-28 21:36:59', 34, 'PCD_DMZ__ingress_10000-19999__PCD_SF_APP', NULL, 'ingress_10000-19999', '面向SF_APP开放10000-19999', '0013_0000000014', '0013_0000000004', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000020', NULL, '0015_0000000020', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-04-28 21:38:48', 34, 'PCD_MGMT__egress_1-65535__PCD_SF', NULL, 'egress_1-65535', '运维监控', '0013_0000000003', '0013_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000021', NULL, '0015_0000000021', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-04-28 21:38:48', 34, 'PCD_MGMT__egress_1-65535__PCD_DMZ', NULL, 'egress_1-65535', '运维监控', '0013_0000000004', '0013_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000022', NULL, '0015_0000000022', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-04-28 21:38:48', 34, 'PCD_MGMT__egress_1-65535__PCD_ECN', NULL, 'egress_1-65535', '运维监控', '0013_0000000005', '0013_0000000006', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000025', NULL, '0015_0000000025', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-08 00:45:52', 34, 'PCD_DMZ__egress_4000-9999__PCD_MGMT_APP', NULL, 'egress_4000-9999', 'saltstack agent', '0013_0000000022', '0013_0000000004', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000026', NULL, '0015_0000000026', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-08 00:46:28', 34, 'PCD_ECN__egress_4000-9999__PCD_MGMT_APP', NULL, 'egress_4000-9999', 'saltstack agent', '0013_0000000022', '0013_0000000005', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000027', NULL, '0015_0000000027', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-08 00:47:46', 34, 'PCD_SF__egress_4000-9999__PCD_MGMT_APP', NULL, 'egress_4000-9999', 'saltstack agent', '0013_0000000022', '0013_0000000003', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000028', NULL, '0015_0000000028', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-08 00:51:54', 34, 'PCD_MGMT__ingress_4000-9999__PCD_SF', NULL, 'ingress_4000-9999', 'saltstack agent', '0013_0000000003', '0013_0000000006', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000029', NULL, '0015_0000000029', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-08 00:51:55', 34, 'PCD_MGMT__ingress_4000-9999__PCD_DMZ', NULL, 'ingress_4000-9999', 'saltstack agent', '0013_0000000004', '0013_0000000006', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000030', NULL, '0015_0000000030', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-08 00:51:55', 34, 'PCD_MGMT__ingress_4000-9999__PCD_ECN', NULL, 'ingress_4000-9999', 'saltstack agent', '0013_0000000005', '0013_0000000006', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000037', NULL, '0015_0000000037', 'umadmin', '2020-05-20 11:34:27', 'umadmin', '2020-05-20 11:34:24', 34, 'DC_SF__ingress_1-65535__DC_SF', NULL, 'ingress_1-65535', '网络区域内部互联', '0013_0000000032', '0013_0000000032', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000039', NULL, '0015_0000000039', 'umadmin', '2020-05-20 11:34:32', 'umadmin', '2020-05-20 11:34:30', 34, 'DC_DMZ__ingress_1-65535__DC_DMZ', NULL, 'ingress_1-65535', '网络区域内部互联', '0013_0000000034', '0013_0000000034', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000040', NULL, '0015_0000000040', 'umadmin', '2020-05-22 18:37:18', 'umadmin', '2020-05-20 11:34:33', 34, 'DC_DMZ__egress_3128__DC_DMZ_PROXY', NULL, 'egress_3128', '访问SQUID代理', '0013_0000000039', '0013_0000000034', '3128', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000041', NULL, '0015_0000000041', 'umadmin', '2020-05-20 11:34:38', 'umadmin', '2020-05-20 11:34:35', 34, 'DC_MGMT__ingress_1-65535__DC_MGMT', NULL, 'ingress_1-65535', '网络区域内部互联', '0013_0000000033', '0013_0000000033', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000042', NULL, '0015_0000000042', 'umadmin', '2020-05-20 11:34:41', 'umadmin', '2020-05-20 11:34:38', 34, 'DC_MGMT__egress_1-65535__DC_MGMT', NULL, 'egress_1-65535', '网络区域内部互联', '0013_0000000033', '0013_0000000033', '1-65535', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000043', NULL, '0015_0000000043', 'umadmin', '2020-05-20 11:36:35', 'umadmin', '2020-05-20 11:36:35', 34, 'DC_SF__ingress_10000-19999__DC_DMZ', NULL, 'ingress_10000-19999', '', '0013_0000000034', '0013_0000000032', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000044', NULL, '0015_0000000044', 'umadmin', '2020-05-20 11:36:36', 'umadmin', '2020-05-20 11:36:35', 34, 'DC_DMZ__ingress_10000-19999__DC_SF', NULL, 'ingress_10000-19999', '', '0013_0000000032', '0013_0000000034', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000045', NULL, '0015_0000000045', 'umadmin', '2020-05-20 11:36:36', 'umadmin', '2020-05-20 11:36:36', 34, 'DC_SF__ingress_1-65535__DC_MGMT_APP', NULL, 'ingress_1-65535', '', '0013_0000000042', '0013_0000000032', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000046', NULL, '0015_0000000046', 'umadmin', '2020-05-20 11:36:37', 'umadmin', '2020-05-20 11:36:36', 34, 'DC_DMZ__ingress_1-65535__DC_MGMT_APP', NULL, 'ingress_1-65535', '', '0013_0000000042', '0013_0000000034', '1-65535', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000047', NULL, '0015_0000000047', 'umadmin', '2020-05-20 11:37:13', 'umadmin', '2020-05-20 11:37:13', 34, 'DC_SF__egress_4000-9999__DC_MGMT_APP', NULL, 'egress_4000-9999', '', '0013_0000000042', '0013_0000000032', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000048', NULL, '0015_0000000048', 'umadmin', '2020-05-20 11:37:13', 'umadmin', '2020-05-20 11:37:13', 34, 'DC_DMZ__egress_4000-9999__DC_MGMT_APP', NULL, 'egress_4000-9999', '', '0013_0000000042', '0013_0000000034', '4000-9999', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000049', NULL, '0015_0000000049', 'umadmin', '2020-05-20 11:38:59', 'umadmin', '2020-05-20 11:38:59', 34, 'DC_MGMT__ingress_4000-9999__DC_SF', NULL, 'ingress_4000-9999', '', '0013_0000000032', '0013_0000000033', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000050', NULL, '0015_0000000050', 'umadmin', '2020-05-20 11:39:00', 'umadmin', '2020-05-20 11:38:59', 34, 'DC_MGMT__ingress_4000-9999__DC_DMZ', NULL, 'ingress_4000-9999', '', '0013_0000000034', '0013_0000000033', '4000-9999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000051', NULL, '0015_0000000051', 'umadmin', '2020-05-20 11:39:00', 'umadmin', '2020-05-20 11:39:00', 34, 'DC_MGMT__egress_1-65534__DC_SF', NULL, 'egress_1-65534', '', '0013_0000000032', '0013_0000000033', '1-65534', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000052', NULL, '0015_0000000052', 'umadmin', '2020-05-20 11:39:01', 'umadmin', '2020-05-20 11:39:00', 34, 'DC_MGMT__egress_1-65534__DC_DMZ', NULL, 'egress_1-65534', '', '0013_0000000034', '0013_0000000033', '1-65534', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000053', NULL, '0015_0000000053', 'umadmin', '2020-05-20 11:41:52', 'umadmin', '2020-05-20 11:39:41', 34, 'DC_DMZ_PROXY__egress_80-443__DC_WAN_ALL', NULL, 'egress_80-443', '', '0013_0000000044', '0013_0000000039', '80-443', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000054', NULL, '0015_0000000054', 'umadmin', '2020-05-20 11:42:58', 'umadmin', '2020-05-20 11:42:38', 34, 'DC_MGMT__ingress_443__DC_TON_CLIENT', NULL, 'ingress_443', '', '0013_0000000045', '0013_0000000033', '443', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000055', NULL, '0015_0000000055', 'umadmin', '2020-05-22 18:28:50', 'umadmin', '2020-05-22 18:28:49', 34, 'DC_DMZ__ingress_10000-19999__DC_WAN_ALL', NULL, 'ingress_10000-19999', '', '0013_0000000044', '0013_0000000034', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000056', NULL, '0015_0000000056', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-23 18:59:43', 34, 'PCD_DMZ_PROXY__egress_80-443__PCD_WAN_ALL', NULL, 'egress_80-443', '', '0013_0000000026', '0013_0000000016', '80-443', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000057', NULL, '0015_0000000057', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-23 18:59:43', 34, 'PCD_MGMT_PROXY__egress_80-443__PCD_WAN_ALL', NULL, 'egress_80-443', '', '0013_0000000026', '0013_0000000019', '80-443', 'TCP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000058', NULL, '0015_0000000058', 'umadmin', '2020-06-30 15:37:52', 'umadmin', '2020-05-23 23:15:35', 34, 'PCD_DMZ__ingress_10000-19999__PCD_WAN_ALL', NULL, 'ingress_10000-19999', '', '0013_0000000026', '0013_0000000004', '10000-19999', 'TCP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000065', NULL, '0015_0000000065', 'umadmin', '2020-05-25 13:10:22', 'umadmin', '2020-05-25 12:55:28', 34, 'DC_SF__ingress_-1__DC_MGMT_APP', NULL, 'ingress_-1', '', '0013_0000000042', '0013_0000000032', '-1', 'ICMP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000066', NULL, '0015_0000000066', 'umadmin', '2020-05-25 13:10:22', 'umadmin', '2020-05-25 12:55:28', 34, 'DC_DMZ__ingress_-1__DC_MGMT_APP', NULL, 'ingress_-1', '', '0013_0000000042', '0013_0000000034', '-1', 'ICMP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000067', NULL, '0015_0000000067', 'umadmin', '2020-05-25 13:10:21', 'umadmin', '2020-05-25 12:55:29', 34, 'DC_MGMT__ingress_-1__DC_MGMT', NULL, 'ingress_-1', '网络区域内部互联', '0013_0000000033', '0013_0000000033', '-1', 'ICMP', 'ACCEPT', 'ingress', 'new'),
	('0015_0000000068', NULL, '0015_0000000068', 'umadmin', '2020-05-25 13:12:31', 'umadmin', '2020-05-25 13:12:31', 34, 'DC_MGMT__egress_-1__DC_SF', NULL, 'egress_-1', '', '0013_0000000032', '0013_0000000033', '-1', 'ICMP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000069', NULL, '0015_0000000069', 'umadmin', '2020-05-25 13:12:32', 'umadmin', '2020-05-25 13:12:32', 34, 'DC_MGMT__egress_-1__DC_DMZ', NULL, 'egress_-1', '', '0013_0000000034', '0013_0000000033', '-1', 'ICMP', 'ACCEPT', 'egress', 'new'),
	('0015_0000000070', NULL, '0015_0000000070', 'umadmin', '2020-05-25 13:12:33', 'umadmin', '2020-05-25 13:12:32', 34, 'DC_MGMT__egress_-1__DC_MGMT', NULL, 'egress_-1', '网络区域内部互联', '0013_0000000033', '0013_0000000033', '-1', 'ICMP', 'ACCEPT', 'egress', 'new');
/*!40000 ALTER TABLE `default_security_policy_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.deploy_environment: ~3 rows (approximately)
/*!40000 ALTER TABLE `deploy_environment` DISABLE KEYS */;
INSERT INTO `deploy_environment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0003_0000000001', NULL, '0003_0000000001', 'umadmin', '2020-04-11 21:55:55', 'umadmin', '2020-04-11 21:55:54', 34, '生产环境', NULL, 'PRD', '生产环境', '生产环境', 'new'),
	('0003_0000000002', NULL, '0003_0000000002', 'umadmin', '2020-04-11 21:56:10', 'umadmin', '2020-04-11 21:56:10', 34, '容灾环境', NULL, 'DR', '容灾环境', '容灾环境', 'new'),
	('0003_0000000003', NULL, '0003_0000000003', 'umadmin', '2020-05-22 19:35:45', 'umadmin', '2020-05-22 19:35:30', 34, '验收环境', NULL, 'STG', '验收环境', '验收环境', 'new');
/*!40000 ALTER TABLE `deploy_environment` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.deploy_package: ~3 rows (approximately)
/*!40000 ALTER TABLE `deploy_package` DISABLE KEYS */;
INSERT INTO `deploy_package` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_file_path`, `deploy_package_url`, `diff_conf_file`, `is_decompression`, `md5_value`, `name`, `start_file_path`, `state_code`, `stop_file_path`, `unit_design`, `upload_time`, `upload_user`) VALUES
	('0045_0000000005', NULL, '0045_0000000005', 'umadmin', '2020-06-30 15:30:02', 'umadmin', '2020-06-30 15:18:46', 34, 'aDEMO_CORE_APP_demo-app-spring-boot_1.5.3.tar.gz', '2020-06-30 15:30:02', 'demo-app-spring-boot_1.5.3.tar.gz', 'demo-app-spring-boot_1.5.3.tar.gz', 'demo-app-spring-boot_1.5.3/bin/deploy.sh', 'http://10.128.202.3:9000/wecube-artifacts/4523d14ea55a20293f6fa2e1da524618_demo-app-spring-boot_1.5.3.tar.gz', 'demo-app-spring-boot_1.5.3/conf/application-prod.properties|demo-app-spring-boot_1.5.3/bin/start.sh', NULL, '4523d14ea55a20293f6fa2e1da524618', 'demo-app-spring-boot_1.5.3.tar.gz', 'current/bin/start.sh', 'new', 'current/bin/stop.sh', '0039_0000000017', '2020-06-30 15:18:45', 'umadmin'),
	('0045_0000000006', NULL, '0045_0000000006', 'umadmin', '2020-06-30 15:30:13', 'umadmin', '2020-06-30 15:20:03', 34, 'aDEMO_CORE_DB_demo-app-spring-boot-db_1.0.1.tar.gz', '2020-06-30 15:30:13', 'demo-app-spring-boot-db_1.0.1.tar.gz', 'demo-app-spring-boot-db_1.0.1.tar.gz', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'http://10.128.202.3:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar.gz', '', NULL, 'd502c4127f7c3cc6fb7a060eab1e31bb', 'demo-app-spring-boot-db_1.0.1.tar.gz', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'new', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', '0039_0000000015', '2020-06-30 15:20:03', 'umadmin'),
	('0045_0000000007', NULL, '0045_0000000007', 'umadmin', '2020-06-30 15:30:17', 'umadmin', '2020-06-30 15:20:32', 34, 'aDEMO_PROXY_NGINX_demo-app-nginx_0.1.1.tar.gz', '2020-06-30 15:30:17', 'demo-app-nginx_0.1.1.tar.gz', 'demo-app-nginx_0.1.1.tar.gz', 'demo-app-nginx_0.1.1/bin/deploy.sh', 'http://10.128.202.3:9000/wecube-artifacts/d87dd39bfb554f6b40286c5965925179_demo-app-nginx_0.1.1.tar.gz', 'demo-app-nginx_0.1.1/conf/demo-app-nginx.conf', NULL, 'd87dd39bfb554f6b40286c5965925179', 'demo-app-nginx_0.1.1.tar.gz', 'demo-app-nginx_0.1.1/bin/start.sh', 'new', 'demo-app-nginx_0.1.1/bin/stop.sh', '0039_0000000018', '2020-06-30 15:20:31', 'umadmin');
/*!40000 ALTER TABLE `deploy_package` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.deploy_package$diff_conf_variable: ~14 rows (approximately)
/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` DISABLE KEYS */;
INSERT INTO `deploy_package$diff_conf_variable` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(7, '0045_0000000005', '0044_0000000003', 1),
	(8, '0045_0000000005', '0044_0000000004', 2),
	(9, '0045_0000000005', '0044_0000000008', 6),
	(10, '0045_0000000005', '0044_0000000006', 4),
	(11, '0045_0000000005', '0044_0000000001', 7),
	(12, '0045_0000000005', '0044_0000000005', 3),
	(13, '0045_0000000005', '0044_0000000007', 5),
	(14, '0045_0000000005', '0044_0000000002', 8),
	(15, '0045_0000000007', '0044_0000000010', 2),
	(16, '0045_0000000007', '0044_0000000013', 6),
	(17, '0045_0000000007', '0044_0000000012', 4),
	(18, '0045_0000000007', '0044_0000000011', 3),
	(19, '0045_0000000007', '0044_0000000009', 1),
	(20, '0045_0000000007', '0044_0000000003', 5);
/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.diff_configuration: ~13 rows (approximately)
/*!40000 ALTER TABLE `diff_configuration` DISABLE KEYS */;
INSERT INTO `diff_configuration` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `state_code`, `variable_name`, `variable_value`) VALUES
	('0044_0000000001', NULL, '0044_0000000001', 'SYS_PLATFORM', '2020-05-11 16:39:04', 'SYS_PLATFORM', '2020-04-19 20:54:31', 34, 'jmx_hostname', NULL, 'jmx_hostname', NULL, 'new', 'jmx_hostname', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":32,\\"parentRs\\":{\\"attrId\\":927,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":32,\\"parentRs\\":{\\"attrId\\":546,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000002', NULL, '0044_0000000002', 'SYS_PLATFORM', '2020-05-11 16:39:12', 'SYS_PLATFORM', '2020-04-19 20:54:31', 34, 'jmx_port', NULL, 'jmx_port', NULL, 'new', 'jmx_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":50,\\"parentRs\\":{\\"attrId\\":929,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000003', NULL, '0044_0000000003', 'SYS_PLATFORM', '2020-05-11 16:39:19', 'SYS_PLATFORM', '2020-04-19 20:54:31', 34, 'port', NULL, 'port', NULL, 'new', 'port', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":50,\\"parentRs\\":{\\"attrId\\":928,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000004', NULL, '0044_0000000004', 'SYS_PLATFORM', '2020-05-11 16:40:28', 'SYS_PLATFORM', '2020-04-19 20:54:31', 34, 'db_host_ip', NULL, 'db_host_ip', NULL, 'new', 'db_host_ip', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"DB\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":33,\\"parentRs\\":{\\"attrId\\":957,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":33,\\"parentRs\\":{\\"attrId\\":581,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000005', NULL, '0044_0000000005', 'SYS_PLATFORM', '2020-05-11 16:41:02', 'SYS_PLATFORM', '2020-04-19 20:54:31', 34, 'db_host_port', NULL, 'db_host_port', NULL, 'new', 'db_host_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"DB\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":958,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000006', NULL, '0044_0000000006', 'SYS_PLATFORM', '2020-05-11 16:41:17', 'SYS_PLATFORM', '2020-04-19 20:54:31', 34, 'db_name', NULL, 'db_name', NULL, 'new', 'db_name', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"DB\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":1057,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000007', NULL, '0044_0000000007', 'SYS_PLATFORM', '2020-05-11 16:41:33', 'SYS_PLATFORM', '2020-04-19 20:54:32', 34, 'db_username', NULL, 'db_username', NULL, 'new', 'db_username', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"DB\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":964,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000008', NULL, '0044_0000000008', 'SYS_PLATFORM', '2020-05-11 16:42:26', 'SYS_PLATFORM', '2020-04-19 20:54:32', 34, 'db_password', NULL, 'db_password', NULL, 'new', 'db_password', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"DB\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":965,\\"isReferedFromParent\\":1}}]"},{"type":"specialDelimiter","value":"&\\u0001"},{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"DB\\"}]},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":956,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":51,\\"parentRs\\":{\\"attrId\\":944,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000009', NULL, '0044_0000000009', 'SYS_PLATFORM', '2020-05-25 12:35:16', 'SYS_PLATFORM', '2020-05-25 12:30:18', 34, 'backend_server_ip_1', NULL, 'backend_server_ip_1', NULL, 'new', 'backend_server_ip_1', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"LB\\"}]},{\\"ciTypeId\\":53,\\"parentRs\\":{\\"attrId\\":1003,\\"isReferedFromParent\\":0},\\"filters\\":[{\\"name\\":\\"name\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"democorelb01\\"}]},{\\"ciTypeId\\":35,\\"parentRs\\":{\\"attrId\\":1004,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":35,\\"parentRs\\":{\\"attrId\\":649,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000010', NULL, '0044_0000000010', 'SYS_PLATFORM', '2020-05-25 12:35:29', 'SYS_PLATFORM', '2020-05-25 12:30:18', 34, 'backend_server_port_1', NULL, 'backend_server_port_1', NULL, 'new', 'backend_server_port_1', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"LB\\"}]},{\\"ciTypeId\\":53,\\"parentRs\\":{\\"attrId\\":1003,\\"isReferedFromParent\\":0},\\"filters\\":[{\\"name\\":\\"name\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"democorelb01\\"}]},{\\"ciTypeId\\":53,\\"parentRs\\":{\\"attrId\\":1005,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000011', NULL, '0044_0000000011', 'SYS_PLATFORM', '2020-05-25 12:35:54', 'SYS_PLATFORM', '2020-05-25 12:30:18', 34, 'backend_server_ip_2', NULL, 'backend_server_ip_2', NULL, 'new', 'backend_server_ip_2', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"LB\\"}]},{\\"ciTypeId\\":53,\\"parentRs\\":{\\"attrId\\":1003,\\"isReferedFromParent\\":0},\\"filters\\":[{\\"name\\":\\"name\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"democorelb02\\"}]},{\\"ciTypeId\\":35,\\"parentRs\\":{\\"attrId\\":1004,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":35,\\"parentRs\\":{\\"attrId\\":649,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000012', NULL, '0044_0000000012', 'SYS_PLATFORM', '2020-05-25 12:36:09', 'SYS_PLATFORM', '2020-05-25 12:30:19', 34, 'backend_server_port_2', NULL, 'backend_server_port_2', NULL, 'new', 'backend_server_port_2', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":49,\\"parentRs\\":{\\"attrId\\":908,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":910,\\"isReferedFromParent\\":1},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"LB\\"}]},{\\"ciTypeId\\":53,\\"parentRs\\":{\\"attrId\\":1003,\\"isReferedFromParent\\":0},\\"filters\\":[{\\"name\\":\\"name\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"democorelb02\\"}]},{\\"ciTypeId\\":53,\\"parentRs\\":{\\"attrId\\":1005,\\"isReferedFromParent\\":1}}]"}]'),
	('0044_0000000013', NULL, '0044_0000000013', 'SYS_PLATFORM', '2020-05-25 12:38:10', 'SYS_PLATFORM', '2020-05-25 12:30:19', 34, 'context_path', NULL, 'context_path', NULL, 'new', 'context_path', '[{"type":"rule","value":"[{\\"ciTypeId\\":50},{\\"ciTypeId\\":48,\\"parentRs\\":{\\"attrId\\":926,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":39,\\"parentRs\\":{\\"attrId\\":887,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":64,\\"parentRs\\":{\\"attrId\\":1119,\\"isReferedFromParent\\":0},\\"filters\\":[{\\"name\\":\\"code\\",\\"operator\\":\\"eq\\",\\"type\\":\\"value\\",\\"value\\":\\"context_path\\"}]},{\\"ciTypeId\\":64,\\"parentRs\\":{\\"attrId\\":1118,\\"isReferedFromParent\\":1}}]"}]');
/*!40000 ALTER TABLE `diff_configuration` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.host_resource_instance: ~20 rows (approximately)
/*!40000 ALTER TABLE `host_resource_instance` DISABLE KEYS */;
INSERT INTO `host_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `ip_address`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_system`, `resource_instance_type`, `resource_set`, `state_code`, `storage`, `user_name`, `user_password`, `storage_type`, `network_segment`, `subnet_security_group`) VALUES
	('0032_0000000002', NULL, '0032_0000000002', 'umadmin', '2020-05-08 11:03:18', 'umadmin', '2020-04-29 11:26:40', 40, 'TX_GZ_PRD_MGMT_1M1_DOCKER1__wecubecore01', NULL, 'wecubecore01_10.128.200.2', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', '10.128.200.2', '22', '', '', '10.128.200.2:9100', '9100', 'wecubecore01', '0010_0000000048', '0011_0000000029', '0009_0000000017', '0029_0000000038', 'created', '50', 'root', 'Wecube@123456', '0062_0000000016', '0023_0000000020', 'N'),
	('0032_0000000003', NULL, '0032_0000000003', 'umadmin', '2020-05-08 11:03:17', 'umadmin', '2020-04-29 11:26:41', 40, 'TX_GZ_PRD_MGMT_1M1_DOCKER1__wecubecore02', NULL, 'wecubecore02_10.128.201.2', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', '10.128.201.2', '22', '', '', '10.128.201.2:9100', '9100', 'wecubecore02', '0010_0000000048', '0011_0000000029', '0009_0000000017', '0029_0000000038', 'created', '50', 'root', 'Wecube@123456', '0062_0000000016', '0023_0000000021', 'N'),
	('0032_0000000004', NULL, '0032_0000000004', 'umadmin', '2020-05-08 11:03:17', 'umadmin', '2020-04-29 11:29:44', 40, 'TX_GZ_PRD_MGMT_1M1_DOCKER1__wecubeplugin01', NULL, 'wecubeplugin01_10.128.200.3', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', '10.128.200.3', '22', '', '', '10.128.200.3:9100', '9100', 'wecubeplugin01', '0010_0000000049', '0011_0000000029', '0009_0000000017', '0029_0000000038', 'created', '50', 'root', 'Wecube@123456', '0062_0000000016', '0023_0000000020', 'N'),
	('0032_0000000005', NULL, '0032_0000000005', 'umadmin', '2020-05-08 11:03:16', 'umadmin', '2020-04-29 11:29:46', 40, 'TX_GZ_PRD_MGMT_1M1_DOCKER1__wecubeplugin02', NULL, 'wecubeplugin02_10.128.201.3', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', '10.128.201.3', '22', '', '', '10.128.201.3:9100', '9100', 'wecubeplugin02', '0010_0000000049', '0011_0000000029', '0009_0000000017', '0029_0000000038', 'created', '50', 'root', 'Wecube@123456', '0062_0000000016', '0023_0000000021', 'N'),
	('0032_0000000006', NULL, '0032_0000000006', 'umadmin', '2020-05-08 11:03:16', 'umadmin', '2020-04-29 11:33:14', 40, 'TX_GZ_PRD_MGMT_1M1_VDI1__mgmtvdi01', NULL, 'mgmtvdi01_10.128.196.3', '', '', '', '', '0063_0000000004', '0008_0000000006', '', '', '10.128.196.3', '3389', '', '', '10.128.196.3:9100', '9100', 'mgmtvdi01', '0010_0000000053', '0011_0000000025', '0009_0000000012', '0029_0000000036', 'created', '50', 'Administrator', 'Wecube@123456', '0062_0000000009', '0023_0000000018', 'N'),
	('0032_0000000007', NULL, '0032_0000000007', 'umadmin', '2020-05-08 11:03:15', 'umadmin', '2020-04-29 11:33:15', 40, 'TX_GZ_PRD_MGMT_1M1_VDI1__mgmtvdi02', NULL, 'mgmtvdi02_10.128.197.3', '', '', '', '', '0063_0000000004', '0008_0000000006', '', '', '10.128.197.3', '3389', '', '', '10.128.197.3:9100', '9100', 'mgmtvdi02', '0010_0000000053', '0011_0000000025', '0009_0000000012', '0029_0000000036', 'created', '50', 'Administrator', 'Wecube@123456', '0062_0000000009', '0023_0000000019', 'N'),
	('0032_0000000008', NULL, '0032_0000000008', 'umadmin', '2020-05-08 11:03:15', 'umadmin', '2020-04-29 11:34:45', 40, 'TX_GZ_PRD_MGMT_1M1_SQUID1__mgmtsquid01', NULL, 'mgmtsquid01_10.128.220.3', '', '', '', '', '0063_0000000004', '0008_0000000006', '', '', '10.128.220.3', '22', '', '', '10.128.220.3:9100', '9100', 'mgmtsquid01', '0010_0000000047', '0011_0000000029', '0009_0000000013', '0029_0000000034', 'created', '50', 'root', 'Wecube@123456', '0062_0000000010', '0023_0000000024', 'Y'),
	('0032_0000000009', NULL, '0032_0000000009', 'umadmin', '2020-05-08 11:03:14', 'umadmin', '2020-04-29 11:34:46', 40, 'TX_GZ_PRD_MGMT_1M1_SQUID1__mgmtsquid02', NULL, 'mgmtsquid02_10.128.221.3', '', '', '', '', '0063_0000000004', '0008_0000000006', '', '', '10.128.221.3', '22', '', '', '10.128.221.3:9100', '9100', 'mgmtsquid02', '0010_0000000047', '0011_0000000029', '0009_0000000013', '0029_0000000034', 'created', '50', 'root', 'Wecube@123456', '0062_0000000010', '0023_0000000025', 'Y'),
	('0032_0000000010', NULL, '0032_0000000010', 'umadmin', '2020-05-08 17:01:55', 'umadmin', '2020-05-08 17:01:54', 40, 'TX_GZ_PRD_SF_1A1_JAVA1__admhost1', NULL, 'admhost1_IP3423', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', 'IP3423', '22', '', '', 'IP3423:9100', '9100', 'admhost1', '0010_0000000047', '0011_0000000029', '0009_0000000016', '0029_0000000051', 'created', '50', 'root', 'Abcd1234', '0062_0000000014', '0023_0000000008', 'N'),
	('0032_0000000011', NULL, '0032_0000000011', 'umadmin', '2020-05-08 17:01:55', 'umadmin', '2020-05-08 17:01:55', 40, 'TX_GZ_PRD_SF_1A1_JAVA1__admhost2', NULL, 'admhost2_IP3425', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', 'IP3425', '22', '', '', 'IP3425:9100', '9100', 'admhost2', '0010_0000000047', '0011_0000000029', '0009_0000000016', '0029_0000000051', 'created', '50', 'root', 'Abcd1234', '0062_0000000014', '0023_0000000009', 'N'),
	('0032_0000000013', NULL, '0032_0000000013', 'umadmin', '2020-05-23 14:30:06', 'umadmin', '2020-05-20 15:07:20', 40, 'ALI_HZ_PRD_MGMT__DOCKER1__alihzwecubehost', NULL, 'alihzwecubehost_IP8654', '', '', '', '', '0063_0000000005', '0008_0000000014', '4', '', 'IP8654', '22', '', '8', 'IP8654:9100', '9100', 'alihzwecubehost', '0010_0000000049', '0011_0000000033', '0009_0000000032', '0029_0000000106', 'created', '50', 'root', 'Wecube@123456', '0062_0000000037', '0023_0000000072', 'N'),
	('0032_0000000014', NULL, '0032_0000000014', 'umadmin', '2020-05-22 23:51:10', 'umadmin', '2020-05-20 15:09:15', 40, 'ALI_HZ_PRD_SF__JAVA1__apphost01', NULL, 'apphost01_IP6437', '', '', '', '', '0063_0000000005', '0008_0000000014', '', '', 'IP6437', '22', '', '', 'IP6437:9100', '9100', 'apphost01', '0010_0000000048', '0011_0000000033', '0009_0000000034', '0029_0000000103', 'created', '50', 'root', 'Abcd1234', '0062_0000000042', '0023_0000000071', 'N'),
	('0032_0000000015', NULL, '0032_0000000015', 'umadmin', '2020-05-22 23:51:09', 'umadmin', '2020-05-20 15:09:16', 40, 'ALI_HZ_PRD_SF__JAVA1__apphost02', NULL, 'apphost02_IP6442', '', '', '', '', '0063_0000000005', '0008_0000000014', '', '', 'IP6442', '22', '', '', 'IP6442:9100', '9100', 'apphost02', '0010_0000000048', '0011_0000000033', '0009_0000000034', '0029_0000000103', 'created', '50', 'root', 'Abcd1234', '0062_0000000042', '0023_0000000070', 'N'),
	('0032_0000000016', NULL, '0032_0000000016', 'umadmin', '2020-05-22 23:51:09', 'umadmin', '2020-05-20 16:51:46', 40, 'ALI_HZ_PRD_DMZ__NGINX1__nginxhost01', NULL, 'nginxhost01_IP3489', '', '', '', '', '0063_0000000005', '0008_0000000014', '', '', 'IP3489', '22', '', '', 'IP3489:9100', '9100', 'nginxhost01', '0010_0000000047', '0011_0000000033', '0009_0000000030', '0029_0000000113', 'created', '50', 'root', 'Abcd1234', '0062_0000000035', '0023_0000000083', 'N'),
	('0032_0000000017', NULL, '0032_0000000017', 'umadmin', '2020-05-22 23:51:08', 'umadmin', '2020-05-20 16:51:47', 40, 'ALI_HZ_PRD_DMZ__NGINX1__nginxhost02', NULL, 'nginxhost02_IP3486', '', '', '', '', '0063_0000000005', '0008_0000000014', '', '', 'IP3486', '22', '', '', 'IP3486:9100', '9100', 'nginxhost02', '0010_0000000047', '0011_0000000033', '0009_0000000030', '0029_0000000113', 'created', '50', 'root', 'Abcd1234', '0062_0000000035', '0023_0000000084', 'N'),
	('0032_0000000019', NULL, '0032_0000000019', 'umadmin', '2020-05-23 14:17:32', 'umadmin', '2020-05-22 19:53:21', 40, 'TX_BJ_PRD_MGMT__DOCKER1__txbjwecubehost', NULL, 'txbjwecubehost_IP4386', '', '', '', '', '0063_0000000004', '0008_0000000008', '4', '', 'IP4386', '22', '', '8', 'IP4386:9100', '9100', 'txbjwecubehost', '0010_0000000049', '0011_0000000029', '0009_0000000017', '0029_0000000131', 'created', '50', 'root', 'Wecube@123456', '0062_0000000016', '0023_0000000099', 'N'),
	('0032_0000000020', NULL, '0032_0000000020', 'umadmin', '2020-05-22 23:53:22', 'umadmin', '2020-05-22 23:53:22', 40, 'TX_BJ_PRD_DMZ__NGINX1__nginxhost02', NULL, 'nginxhost02_IP3467', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', 'IP3467', '22', '', '', 'IP3467:9100', '9100', 'nginxhost02', '0010_0000000047', '0011_0000000029', '0009_0000000021', '0029_0000000128', 'created', '50', 'root', 'Abcd1234', '0062_0000000023', '0023_0000000103', 'N'),
	('0032_0000000021', NULL, '0032_0000000021', 'umadmin', '2020-05-22 23:53:23', 'umadmin', '2020-05-22 23:53:22', 40, 'TX_BJ_PRD_DMZ__NGINX1__nginxhost01', NULL, 'nginxhost01_IP3424', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', 'IP3424', '22', '', '', 'IP3424:9100', '9100', 'nginxhost01', '0010_0000000047', '0011_0000000029', '0009_0000000021', '0029_0000000128', 'created', '50', 'root', 'Abcd1234', '0062_0000000023', '0023_0000000096', 'N'),
	('0032_0000000022', NULL, '0032_0000000022', 'umadmin', '2020-05-22 23:53:23', 'umadmin', '2020-05-22 23:53:23', 40, 'TX_BJ_PRD_SF__JAVA1__apphost02', NULL, 'apphost02_IP6496', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', 'IP6496', '22', '', '', 'IP6496:9100', '9100', 'apphost02', '0010_0000000047', '0011_0000000029', '0009_0000000016', '0029_0000000135', 'created', '50', 'root', 'Abcd1234', '0062_0000000014', '0023_0000000107', 'N'),
	('0032_0000000023', NULL, '0032_0000000023', 'umadmin', '2020-05-22 23:53:24', 'umadmin', '2020-05-22 23:53:23', 40, 'TX_BJ_PRD_SF__JAVA1__apphost01', NULL, 'apphost01_IP6436', '', '', '', '', '0063_0000000004', '0008_0000000008', '', '', 'IP6436', '22', '', '', 'IP6436:9100', '9100', 'apphost01', '0010_0000000047', '0011_0000000029', '0009_0000000016', '0029_0000000135', 'created', '50', 'root', 'Abcd1234', '0062_0000000014', '0023_0000000100', 'N');
/*!40000 ALTER TABLE `host_resource_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.invoke: ~16 rows (approximately)
/*!40000 ALTER TABLE `invoke` DISABLE KEYS */;
INSERT INTO `invoke` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_unit`, `invoke_design`, `invoke_type`, `invoke_unit`, `state_code`, `invoked_resource_type`) VALUES
	('0049_0000000002', NULL, '0049_0000000002', 'umadmin', '2020-05-23 18:29:10', 'umadmin', '2020-05-08 17:40:36', 37, 'PRD_DEMO_CLIENT_BROWER-->--PRD_DEMO_CORE_LB', NULL, 'PRD_DEMO_CLIENT_BROWER-->--PRD_DEMO_CORE_LB', '', '0048_0000000005', '0040_0000000002', '同步调用', '0048_0000000006', 'created', 'LB'),
	('0049_0000000003', NULL, '0049_0000000003', 'umadmin', '2020-05-23 18:28:45', 'umadmin', '2020-05-08 17:40:36', 37, 'PRD_DEMO_CORE_LB-->--PRD_DEMO_CORE_APP', NULL, 'PRD_DEMO_CORE_LB-->--PRD_DEMO_CORE_APP', '', '0048_0000000002', '0040_0000000003', '同步调用', '0048_0000000005', 'created', 'HOST'),
	('0049_0000000004', NULL, '0049_0000000004', 'umadmin', '2020-05-23 18:29:08', 'umadmin', '2020-05-08 17:40:37', 37, 'PRD_DEMO_CORE_APP-->--PRD_DEMO_CORE_REDIS', NULL, 'PRD_DEMO_CORE_APP-->--PRD_DEMO_CORE_REDIS', '', '0048_0000000004', '0040_0000000005', '同步调用', '0048_0000000002', 'created', 'CACHE'),
	('0049_0000000005', NULL, '0049_0000000005', 'umadmin', '2020-05-23 18:29:08', 'umadmin', '2020-05-08 17:40:37', 37, 'PRD_DEMO_CORE_APP-->--PRD_DEMO_CORE_DB', NULL, 'PRD_DEMO_CORE_APP-->--PRD_DEMO_CORE_DB', '', '0048_0000000003', '0040_0000000004', '同步调用', '0048_0000000002', 'created', 'RDB'),
	('0049_0000000006', NULL, '0049_0000000006', 'umadmin', '2020-05-23 00:34:57', 'umadmin', '2020-05-20 16:48:39', 37, 'PRD_AaDEMO_CLIENT_BROWER-->--PRD_AaDEMO_PROXY_ELB', NULL, 'PRD_AaDEMO_CLIENT_BROWER-->--PRD_AaDEMO_PROXY_ELB', '', '0048_0000000018', '0040_0000000009', '同步调用', '0048_0000000012', 'created', 'LB'),
	('0049_0000000007', NULL, '0049_0000000007', 'umadmin', '2020-05-23 00:35:07', 'umadmin', '2020-05-20 16:48:39', 37, 'PRD_AaDEMO_PROXY_ELB-->--PRD_AaDEMO_PROXY_NGINX', NULL, 'PRD_AaDEMO_PROXY_ELB-->--PRD_AaDEMO_PROXY_NGINX', '', '0048_0000000017', '0040_0000000010', '同步调用', '0048_0000000018', 'created', 'HOST'),
	('0049_0000000008', NULL, '0049_0000000008', 'umadmin', '2020-05-23 00:35:07', 'umadmin', '2020-05-20 16:48:39', 37, 'PRD_AaDEMO_PROXY_NGINX-->--PRD_AaDEMO_CORE_LB', NULL, 'PRD_AaDEMO_PROXY_NGINX-->--PRD_AaDEMO_CORE_LB', '', '0048_0000000014', '0040_0000000011', '同步调用', '0048_0000000017', 'created', 'LB'),
	('0049_0000000009', NULL, '0049_0000000009', 'umadmin', '2020-05-23 00:34:56', 'umadmin', '2020-05-20 16:48:40', 37, 'PRD_AaDEMO_CORE_LB-->--PRD_AaDEMO_CORE_APP', NULL, 'PRD_AaDEMO_CORE_LB-->--PRD_AaDEMO_CORE_APP', '', '0048_0000000016', '0040_0000000015', '同步调用', '0048_0000000014', 'created', 'HOST'),
	('0049_0000000010', NULL, '0049_0000000010', 'umadmin', '2020-05-23 00:34:57', 'umadmin', '2020-05-20 16:48:40', 37, 'PRD_AaDEMO_CORE_APP-->--PRD_AaDEMO_CORE_REDIS', NULL, 'PRD_AaDEMO_CORE_APP-->--PRD_AaDEMO_CORE_REDIS', '', '0048_0000000013', '0040_0000000012', '同步调用', '0048_0000000016', 'created', 'CACHE'),
	('0049_0000000011', NULL, '0049_0000000011', 'umadmin', '2020-05-23 00:34:56', 'umadmin', '2020-05-20 16:48:52', 37, 'PRD_AaDEMO_CORE_APP-->--PRD_AaDEMO_CORE_DB', NULL, 'PRD_AaDEMO_CORE_APP-->--PRD_AaDEMO_CORE_DB', '', '0048_0000000015', '0040_0000000013', '同步调用', '0048_0000000016', 'created', 'RDB'),
	('0049_0000000012', NULL, '0049_0000000012', 'umadmin', '2020-06-30 15:30:42', 'umadmin', '2020-05-23 00:33:14', 37, 'PRD_TaDEMO_CORE_APP-->--PRD_TaDEMO_CORE_DB', NULL, 'PRD_TaDEMO_CORE_APP-->--PRD_TaDEMO_CORE_DB', '', '0048_0000000022', '0040_0000000013', '同步调用', '0048_0000000021', 'created', 'RDB'),
	('0049_0000000013', NULL, '0049_0000000013', 'umadmin', '2020-06-30 15:30:43', 'umadmin', '2020-05-23 00:33:15', 37, 'PRD_TaDEMO_CORE_LB-->--PRD_TaDEMO_CORE_APP', NULL, 'PRD_TaDEMO_CORE_LB-->--PRD_TaDEMO_CORE_APP', '', '0048_0000000021', '0040_0000000015', '同步调用', '0048_0000000024', 'created', 'HOST'),
	('0049_0000000014', NULL, '0049_0000000014', 'umadmin', '2020-05-23 00:33:15', 'umadmin', '2020-05-23 00:33:15', 37, 'PRD_TaDEMO_CORE_APP-->--PRD_TaDEMO_CORE_REDIS', NULL, 'PRD_TaDEMO_CORE_APP-->--PRD_TaDEMO_CORE_REDIS', '', '0048_0000000023', '0040_0000000012', '同步调用', '0048_0000000021', 'created', 'CACHE'),
	('0049_0000000015', NULL, '0049_0000000015', 'umadmin', '2020-05-23 00:33:16', 'umadmin', '2020-05-23 00:33:15', 37, 'PRD_TaDEMO_CLIENT_BROWER-->--PRD_TaDEMO_PROXY_ELB', NULL, 'PRD_TaDEMO_CLIENT_BROWER-->--PRD_TaDEMO_PROXY_ELB', '', '0048_0000000019', '0040_0000000009', '同步调用', '0048_0000000025', 'created', 'LB'),
	('0049_0000000016', NULL, '0049_0000000016', 'umadmin', '2020-06-30 15:30:43', 'umadmin', '2020-05-23 00:33:16', 37, 'PRD_TaDEMO_PROXY_ELB-->--PRD_TaDEMO_PROXY_NGINX', NULL, 'PRD_TaDEMO_PROXY_ELB-->--PRD_TaDEMO_PROXY_NGINX', '', '0048_0000000020', '0040_0000000010', '同步调用', '0048_0000000019', 'created', 'HOST'),
	('0049_0000000017', NULL, '0049_0000000017', 'umadmin', '2020-05-23 00:33:16', 'umadmin', '2020-05-23 00:33:16', 37, 'PRD_TaDEMO_PROXY_NGINX-->--PRD_TaDEMO_CORE_LB', NULL, 'PRD_TaDEMO_PROXY_NGINX-->--PRD_TaDEMO_CORE_LB', '', '0048_0000000024', '0040_0000000011', '同步调用', '0048_0000000020', 'created', 'LB');
/*!40000 ALTER TABLE `invoke` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.invoke_design: ~16 rows (approximately)
/*!40000 ALTER TABLE `invoke_design` DISABLE KEYS */;
INSERT INTO `invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_unit_design`, `invoke_type`, `invoke_unit_design`, `resource_set_invoke_design`, `state_code`) VALUES
	('0040_0000000002', NULL, '0040_0000000002', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:22:18', 34, 'DEMO_CLIENT_BROWER-->--DEMO_CORE_LB', '2020-05-08 17:34:28', 'BROWER-->--LB', '', '0039_0000000003', '同步调用', '0039_0000000006', '0021_0000000002', 'new'),
	('0040_0000000003', NULL, '0040_0000000003', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:23:10', 34, 'DEMO_CORE_LB-->--DEMO_CORE_APP', '2020-05-08 17:34:28', 'LB-->--APP', '', '0039_0000000002', '同步调用', '0039_0000000003', '0021_0000000007', 'new'),
	('0040_0000000004', NULL, '0040_0000000004', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:23:11', 34, 'DEMO_CORE_APP-->--DEMO_CORE_DB', '2020-05-08 17:34:28', 'APP-->--DB', '', '0039_0000000004', '同步调用', '0039_0000000002', '0021_0000000004', 'new'),
	('0040_0000000005', NULL, '0040_0000000005', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:23:11', 34, 'DEMO_CORE_APP-->--DEMO_CORE_REDIS', '2020-05-08 17:34:28', 'APP-->--REDIS', '', '0039_0000000005', '同步调用', '0039_0000000002', '0021_0000000006', 'new'),
	('0040_0000000006', NULL, '0040_0000000006', 'umadmin', '2020-05-08 17:29:37', 'umadmin', '2020-05-08 17:29:37', 34, 'UM_SER_LB-->--UM_SER_APP', NULL, 'LB-->--APP', '', '0039_0000000007', '同步调用', '0039_0000000008', '0021_0000000007', 'new'),
	('0040_0000000007', NULL, '0040_0000000007', 'umadmin', '2020-05-08 17:30:32', 'umadmin', '2020-05-08 17:30:31', 34, 'UM_SER_APP-->--UM_SER_DB', NULL, 'APP-->--DB', '', '0039_0000000009', '同步调用', '0039_0000000007', '0021_0000000004', 'new'),
	('0040_0000000008', NULL, '0040_0000000008', 'umadmin', '2020-06-30 15:47:05', 'umadmin', '2020-05-08 17:31:49', 34, 'DEMO_CORE_APP-->--UM_SER_LB', '2020-05-08 17:34:28', 'APP-->--LB', '', '0039_0000000008', '同步调用', '0039_0000000002', '0021_0000000012', 'new'),
	('0040_0000000009', NULL, '0040_0000000009', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:52:19', 34, 'aDEMO_CLIENT_BROWER-->--aDEMO_PROXY_ELB', '2020-05-20 17:11:11', 'BROWER-->--ELB', '', '0039_0000000019', '同步调用', '0039_0000000013', '0021_0000000014', 'new'),
	('0040_0000000010', NULL, '0040_0000000010', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:52:38', 34, 'aDEMO_PROXY_ELB-->--aDEMO_PROXY_NGINX', '2020-05-20 17:11:11', 'ELB-->--NGINX', '', '0039_0000000018', '同步调用', '0039_0000000019', '0021_0000000017', 'new'),
	('0040_0000000011', NULL, '0040_0000000011', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:54:54', 34, 'aDEMO_PROXY_NGINX-->--aDEMO_CORE_LB', '2020-05-20 17:11:11', 'NGINX-->--LB', '', '0039_0000000016', '同步调用', '0039_0000000018', '0021_0000000025', 'new'),
	('0040_0000000012', NULL, '0040_0000000012', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:54:55', 34, 'aDEMO_CORE_APP-->--aDEMO_CORE_REDIS', '2020-05-20 17:11:11', 'APP-->--REDIS', '', '0039_0000000014', '同步调用', '0039_0000000017', '0021_0000000023', 'new'),
	('0040_0000000013', NULL, '0040_0000000013', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:54:55', 34, 'aDEMO_CORE_APP-->--aDEMO_CORE_DB', '2020-05-20 17:11:11', 'APP-->--DB', '', '0039_0000000015', '同步调用', '0039_0000000017', '0021_0000000024', 'new'),
	('0040_0000000014', NULL, '0040_0000000014', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:54:55', 34, 'aDEMO_CORE_APP-->--aUM_SER_LB', '2020-05-20 17:11:11', 'APP-->--LB', '', '0039_0000000011', '同步调用', '0039_0000000017', '0021_0000000021', 'new'),
	('0040_0000000015', NULL, '0040_0000000015', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:54:55', 34, 'aDEMO_CORE_LB-->--aDEMO_CORE_APP', '2020-05-20 17:11:11', 'LB-->--APP', '', '0039_0000000017', '同步调用', '0039_0000000016', '0021_0000000027', 'new'),
	('0040_0000000016', NULL, '0040_0000000016', 'umadmin', '2020-05-20 16:03:31', 'umadmin', '2020-05-20 16:03:31', 34, 'aUM_SER_APP-->--aUM_SER_DB', NULL, 'APP-->--DB', '', '0039_0000000010', '同步调用', '0039_0000000012', '0021_0000000024', 'new'),
	('0040_0000000017', NULL, '0040_0000000017', 'umadmin', '2020-05-20 16:04:07', 'umadmin', '2020-05-20 16:04:07', 34, 'aUM_SER_LB-->--aUM_SER_APP', NULL, 'LB-->--APP', '', '0039_0000000012', '同步调用', '0039_0000000011', '0021_0000000027', 'new');
/*!40000 ALTER TABLE `invoke_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.ip_address: ~6 rows (approximately)
/*!40000 ALTER TABLE `ip_address` DISABLE KEYS */;
INSERT INTO `ip_address` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `state_code`, `asset_id`, `network_segment`) VALUES
	('0031_0000000056', NULL, '0031_0000000056', 'umadmin', '2020-05-20 12:55:15', 'umadmin', '2020-04-29 22:48:12', 37, 'IP1223', NULL, 'IP1223', '', 'created', '', '0023_0000000044'),
	('0031_0000000057', NULL, '0031_0000000057', 'umadmin', '2020-05-20 12:55:15', 'umadmin', '2020-04-29 22:48:12', 37, 'IP1224', NULL, 'IP1224', '', 'created', '', '0023_0000000045'),
	('0031_0000000058', NULL, '0031_0000000058', 'umadmin', '2020-05-20 12:55:14', 'umadmin', '2020-04-30 03:12:04', 37, 'IP3435', NULL, 'IP3435', '', 'created', '', '0023_0000000028'),
	('0031_0000000059', NULL, '0031_0000000059', 'umadmin', '2020-05-20 12:55:14', 'umadmin', '2020-04-30 03:12:04', 37, 'IP3423', NULL, 'IP3423', '', 'created', '', '0023_0000000029'),
	('0031_0000000060', NULL, '0031_0000000060', 'umadmin', '2020-05-20 12:55:14', 'umadmin', '2020-05-20 12:54:13', 37, 'IP6345', NULL, 'IP6345', '', 'created', '', '0023_0000000080'),
	('0031_0000000061', NULL, '0031_0000000061', 'umadmin', '2020-05-22 19:13:14', 'umadmin', '2020-05-22 19:13:14', 37, 'IP8766', NULL, 'IP8766', '', 'created', '', '0023_0000000091');
/*!40000 ALTER TABLE `ip_address` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.lb_instance: ~8 rows (approximately)
/*!40000 ALTER TABLE `lb_instance` DISABLE KEYS */;
INSERT INTO `lb_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `lb_listener_asset_id`, `lb_resource_instance`, `port`, `state_code`, `unit`, `name`, `monitor_key_name`) VALUES
	('0053_0000000002', NULL, '0053_0000000002', 'umadmin', '2020-05-22 10:57:03', 'umadmin', '2020-05-08 17:44:17', 37, 'democorelb1_IP6433:80', NULL, 'democorelb1_IP6433:80', '', '', '0035_0000000004', '80', 'created', '0048_0000000005', 'democorelb1', 'IP6433:80'),
	('0053_0000000003', NULL, '0053_0000000003', 'umadmin', '2020-05-22 10:57:03', 'umadmin', '2020-05-08 17:44:18', 37, 'democorelb2_IP6435:80', NULL, 'democorelb2_IP6435:80', '', '', '0035_0000000005', '80', 'created', '0048_0000000005', 'democorelb2', 'IP6435:80'),
	('0053_0000000006', NULL, '0053_0000000006', 'umadmin', '2020-05-23 00:17:15', 'umadmin', '2020-05-20 17:03:23', 37, 'democorelb01_IP3773:10001', NULL, 'democorelb01_IP3773:10001', '', '', '0035_0000000008', '10001', 'created', '0048_0000000014', 'democorelb01', 'IP3773:10001'),
	('0053_0000000007', NULL, '0053_0000000007', 'umadmin', '2020-05-23 00:17:15', 'umadmin', '2020-05-20 17:03:24', 37, 'democorelb02_IP1345:10001', NULL, 'democorelb02_IP1345:10001', '', '', '0035_0000000009', '10001', 'created', '0048_0000000014', 'democorelb02', 'IP1345:10001'),
	('0053_0000000008', NULL, '0053_0000000008', 'umadmin', '2020-05-23 00:17:14', 'umadmin', '2020-05-20 17:04:09', 37, 'demoelb01_IP3645:80', NULL, 'demoelb01_IP3645:80', '', '', '0035_0000000010', '80', 'created', '0048_0000000018', 'demoelb01', 'IP3645:80'),
	('0053_0000000012', NULL, '0053_0000000012', 'umadmin', '2020-05-23 00:26:15', 'umadmin', '2020-05-23 00:20:02', 37, 'demoelb01_IP3649:80', NULL, 'demoelb01_IP3649:80', '', '', '0035_0000000014', '80', 'created', '0048_0000000019', 'demoelb01', 'IP3649:80'),
	('0053_0000000013', NULL, '0053_0000000013', 'umadmin', '2020-05-23 00:31:17', 'umadmin', '2020-05-23 00:20:03', 37, 'democorelb02_IP3675:10001', NULL, 'democorelb02_IP3675:10001', '', '', '0035_0000000016', '10001', 'created', '0048_0000000024', 'democorelb02', 'IP3675:10001'),
	('0053_0000000014', NULL, '0053_0000000014', 'umadmin', '2020-05-23 00:31:18', 'umadmin', '2020-05-23 00:20:03', 37, 'democorelb01_IP9754:10001', NULL, 'democorelb01_IP9754:10001', '', '', '0035_0000000015', '10001', 'created', '0048_0000000024', 'democorelb01', 'IP9754:10001');
/*!40000 ALTER TABLE `lb_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.lb_resource_instance: ~10 rows (approximately)
/*!40000 ALTER TABLE `lb_resource_instance` DISABLE KEYS */;
INSERT INTO `lb_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `end_date`, `ip_address`, `master_resource_instance`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_type`, `resource_set`, `state_code`, `network_segment`) VALUES
	('0035_0000000002', NULL, '0035_0000000002', 'umadmin', '2020-05-08 11:04:33', 'umadmin', '2020-04-29 18:41:53', 37, 'TX_GZ_PRD_MGMT_1M1_ILB1__wecubelb01', NULL, 'wecubelb01_IP4451', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP4451', '', 'IP4451:80', '80', 'wecubelb01', '0009_0000000014', '0029_0000000040', 'created', '0023_0000000020'),
	('0035_0000000003', NULL, '0035_0000000003', 'umadmin', '2020-05-08 11:04:33', 'umadmin', '2020-04-29 18:41:54', 37, 'TX_GZ_PRD_MGMT_1M1_ILB1__wecubelb02', NULL, 'wecubelb02_IP1221', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP1221', '', 'IP1221:80', '80', 'wecubelb02', '0009_0000000014', '0029_0000000040', 'created', '0023_0000000021'),
	('0035_0000000004', NULL, '0035_0000000004', 'umadmin', '2020-05-08 17:04:58', 'umadmin', '2020-05-08 17:04:58', 37, 'TX_GZ_PRD_SF_1A1_ILB1__admlb1', NULL, 'admlb1_IP6433', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP6433', NULL, 'IP6433:80', '80', 'admlb1', '0009_0000000014', '0029_0000000050', 'created', '0023_0000000008'),
	('0035_0000000005', NULL, '0035_0000000005', 'umadmin', '2020-05-08 17:04:58', 'umadmin', '2020-05-08 17:04:58', 37, 'TX_GZ_PRD_SF_1A1_ILB1__admlb2', NULL, 'admlb2_IP6435', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP6435', NULL, 'IP6435:80', '80', 'admlb2', '0009_0000000014', '0029_0000000050', 'created', '0023_0000000009'),
	('0035_0000000008', NULL, '0035_0000000008', 'umadmin', '2020-05-23 00:17:15', 'umadmin', '2020-05-20 15:14:30', 37, 'ALI_HZ_PRD_SF__ILB1__sflb01', NULL, 'sflb01_IP3773', '', '', '', '0063_0000000005', '0008_0000000012', '', 'IP3773', NULL, 'IP3773:80', '80', 'sflb01', '0009_0000000037', '0029_0000000104', 'created', '0023_0000000071'),
	('0035_0000000009', NULL, '0035_0000000009', 'umadmin', '2020-05-23 00:17:15', 'umadmin', '2020-05-20 15:14:30', 37, 'ALI_HZ_PRD_SF__ILB1__sflb02', NULL, 'sflb02_IP1345', '', '', '', '0063_0000000005', '0008_0000000012', '', 'IP1345', NULL, 'IP1345:80', '80', 'sflb02', '0009_0000000037', '0029_0000000104', 'created', '0023_0000000070'),
	('0035_0000000010', NULL, '0035_0000000010', 'umadmin', '2020-05-23 00:17:14', 'umadmin', '2020-05-20 16:52:34', 37, 'ALI_HZ_PRD_DMZ__ELB1__elb01', NULL, 'elb01_IP3645', '', '', '', '0063_0000000005', '0008_0000000012', '', 'IP3645', NULL, 'IP3645:80', '80', 'elb01', '0009_0000000038', '0029_0000000116', 'created', '0023_0000000080'),
	('0035_0000000014', NULL, '0035_0000000014', 'umadmin', '2020-05-23 00:19:30', 'umadmin', '2020-05-23 00:19:29', 37, 'TX_BJ_PRD_DMZ__ELB1__elb01', NULL, 'elb01_IP3649', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP3649', NULL, 'IP3649:80', '80', 'elb01', '0009_0000000009', '0029_0000000127', 'created', '0023_0000000091'),
	('0035_0000000015', NULL, '0035_0000000015', 'umadmin', '2020-05-23 00:19:31', 'umadmin', '2020-05-23 00:19:30', 37, 'TX_BJ_PRD_SF__ILB1__sflb01', NULL, 'sflb01_IP9754', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP9754', NULL, 'IP9754:80', '80', 'sflb01', '0009_0000000014', '0029_0000000132', 'created', '0023_0000000100'),
	('0035_0000000016', NULL, '0035_0000000016', 'umadmin', '2020-05-23 00:19:33', 'umadmin', '2020-05-23 00:19:32', 37, 'TX_BJ_PRD_SF__ILB1__sflb02', NULL, 'sflb02_IP3675', '', '', '', '0063_0000000004', '0008_0000000006', '', 'IP3675', NULL, 'IP3675:80', '80', 'sflb02', '0009_0000000014', '0029_0000000132', 'created', '0023_0000000107');
/*!40000 ALTER TABLE `lb_resource_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.legal_person: ~0 rows (approximately)
/*!40000 ALTER TABLE `legal_person` DISABLE KEYS */;
INSERT INTO `legal_person` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0004_0000000001', NULL, '0004_0000000001', 'umadmin', '2020-04-11 21:55:18', 'umadmin', '2020-04-11 21:55:18', 34, 'DEMO法人', NULL, 'DEMO', 'DEMO法人', 'DEMO法人', 'new');
/*!40000 ALTER TABLE `legal_person` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.manage_role: ~0 rows (approximately)
/*!40000 ALTER TABLE `manage_role` DISABLE KEYS */;
INSERT INTO `manage_role` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `email`, `name`, `phone`, `state_code`) VALUES
	('0001_0000000001', NULL, '0001_0000000001', 'umadmin', '2020-05-22 12:29:22', 'umadmin', '2020-04-11 21:54:11', 34, '超级管理员', NULL, 'SUPER_ADMIN', '超级管理员', 'demo@163.com', '超级管理员', '15800000000', 'new');
/*!40000 ALTER TABLE `manage_role` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_link: ~38 rows (approximately)
/*!40000 ALTER TABLE `network_link` DISABLE KEYS */;
INSERT INTO `network_link` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `max_concurrent`, `netband_width`, `network_segment_1`, `network_segment_2`, `network_link_design`, `network_link_type`, `state_code`, `subnet_network_segment`, `nat_table_asset_id`) VALUES
	('0026_0000000002', NULL, '0026_0000000002', 'umadmin', '2020-05-20 11:13:25', 'umadmin', '2020-04-28 23:12:05', 37, 'TX_GZ_PRD_SF__peer__TX_CD_DR_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000003', '0023_0000000043', '0016_0000000015', '0054_0000000004', 'created', '', NULL),
	('0026_0000000003', NULL, '0026_0000000003', 'umadmin', '2020-05-20 11:13:26', 'umadmin', '2020-04-28 23:12:05', 37, 'ODC_BON__eip__TX_GZ_PRD_QZ', NULL, 'eip', '', '', '100000', '10', '0023_0000000033', '0023_0000000007', '0016_0000000014', '0054_0000000008', 'created', '', NULL),
	('0026_0000000004', NULL, '0026_0000000004', 'umadmin', '2020-05-20 11:13:26', 'umadmin', '2020-04-28 23:12:06', 37, 'ODC_WAN__nat__TX_GZ_PRD_DMZ', NULL, 'nat', '', '', '100000', '10', '0023_0000000030', '0023_0000000004', '0016_0000000010', '0054_0000000003', 'created', '', NULL),
	('0026_0000000005', NULL, '0026_0000000005', 'umadmin', '2020-05-20 11:13:27', 'umadmin', '2020-04-28 23:12:06', 37, 'ODC_PTN__vpn__TX_GZ_PRD_ECN', NULL, 'vpn', '', '', '100000', '10', '0023_0000000031', '0023_0000000005', '0016_0000000011', '0054_0000000006', 'created', '', NULL),
	('0026_0000000006', NULL, '0026_0000000006', 'umadmin', '2020-05-20 11:13:27', 'umadmin', '2020-04-28 23:12:07', 37, 'ODC_WAN__nat__TX_GZ_PRD_MGMT', NULL, 'nat', '', '', '100000', '10', '0023_0000000030', '0023_0000000006', '0016_0000000012', '0054_0000000003', 'created', '', NULL),
	('0026_0000000007', NULL, '0026_0000000007', 'umadmin', '2020-05-20 11:13:28', 'umadmin', '2020-04-28 23:12:07', 37, 'ODC_TON__vpn__TX_GZ_PRD_MGMT', NULL, 'vpn', '', '', '100000', '10', '0023_0000000032', '0023_0000000006', '0016_0000000013', '0054_0000000006', 'created', '', NULL),
	('0026_0000000008', NULL, '0026_0000000008', 'umadmin', '2020-05-20 11:13:28', 'umadmin', '2020-04-28 23:12:08', 37, 'TX_GZ_PRD_MGMT__peer__TX_CD_DR_MGMT', NULL, 'peer', '', '', '100000', '10', '0023_0000000006', '0023_0000000040', '0016_0000000007', '0054_0000000004', 'created', '', NULL),
	('0026_0000000009', NULL, '0026_0000000009', 'umadmin', '2020-05-20 11:13:29', 'umadmin', '2020-04-28 23:12:08', 37, 'TX_GZ_PRD_MGMT__peer__TX_GZ_PRD_DMZ', NULL, 'peer', '', '', '100000', '10', '0023_0000000006', '0023_0000000004', '0016_0000000008', '0054_0000000004', 'created', '', NULL),
	('0026_0000000010', NULL, '0026_0000000010', 'umadmin', '2020-05-20 11:13:29', 'umadmin', '2020-04-28 23:15:12', 37, 'TX_GZ_PRD_MGMT__peer__TX_GZ_PRD_ECN', NULL, 'peer', '', '', '100000', '10', '0023_0000000006', '0023_0000000005', '0016_0000000009', '0054_0000000004', 'created', '', NULL),
	('0026_0000000011', NULL, '0026_0000000011', 'umadmin', '2020-05-20 11:13:30', 'umadmin', '2020-04-28 23:15:12', 37, 'ODC_WAN__eip__TX_GZ_PRD_DMZ', NULL, 'eip', '', '', '100000', '10', '0023_0000000030', '0023_0000000004', '0016_0000000003', '0054_0000000008', 'created', '', NULL),
	('0026_0000000012', NULL, '0026_0000000012', 'umadmin', '2020-05-23 23:13:52', 'umadmin', '2020-04-28 23:15:13', 37, 'TX_GZ_PRD_ECN__peer__TX_GZ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000005', '0023_0000000003', '0016_0000000004', '0054_0000000004', 'created', '', NULL),
	('0026_0000000013', NULL, '0026_0000000013', 'umadmin', '2020-05-20 11:13:40', 'umadmin', '2020-04-28 23:15:13', 37, 'TX_GZ_PRD_MGMT__peer__TX_GZ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000006', '0023_0000000003', '0016_0000000005', '0054_0000000004', 'created', '', NULL),
	('0026_0000000014', NULL, '0026_0000000014', 'umadmin', '2020-05-20 11:13:40', 'umadmin', '2020-04-28 23:15:13', 37, 'TX_GZ_PRD_QZ__peer__TX_GZ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000007', '0023_0000000003', '0016_0000000006', '0054_0000000004', 'created', '', NULL),
	('0026_0000000015', NULL, '0026_0000000015', 'umadmin', '2020-05-20 11:13:41', 'umadmin', '2020-04-28 23:15:14', 37, 'TX_GZ_PRD_DMZ__peer__TX_GZ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000004', '0023_0000000003', '0016_0000000002', '0054_0000000004', 'created', '', NULL),
	('0026_0000000016', NULL, '0026_0000000016', 'umadmin', '2020-05-20 11:13:26', 'umadmin', '2020-04-28 23:15:14', 37, 'ODC_BON__eip__TX_CD_DR_QZ', NULL, 'eip', '', '', '100000', '10', '0023_0000000033', '0023_0000000039', '0016_0000000014', '0054_0000000008', 'created', '', NULL),
	('0026_0000000017', NULL, '0026_0000000017', 'umadmin', '2020-05-20 11:13:26', 'umadmin', '2020-04-28 23:15:14', 37, 'ODC_WAN__nat__TX_CD_DR_DMZ', NULL, 'nat', '', '', '100000', '10', '0023_0000000030', '0023_0000000041', '0016_0000000010', '0054_0000000003', 'created', '', NULL),
	('0026_0000000018', NULL, '0026_0000000018', 'umadmin', '2020-05-20 11:13:27', 'umadmin', '2020-04-28 23:15:15', 37, 'ODC_PTN__vpn__TX_CD_DR_ECN', NULL, 'vpn', '', '', '100000', '10', '0023_0000000031', '0023_0000000042', '0016_0000000011', '0054_0000000006', 'created', '', NULL),
	('0026_0000000019', NULL, '0026_0000000019', 'umadmin', '2020-05-20 11:13:27', 'umadmin', '2020-04-28 23:15:15', 37, 'ODC_WAN__nat__TX_CD_DR_MGMT', NULL, 'nat', '', '', '100000', '10', '0023_0000000030', '0023_0000000040', '0016_0000000012', '0054_0000000003', 'created', '', NULL),
	('0026_0000000020', NULL, '0026_0000000020', 'umadmin', '2020-05-20 11:13:28', 'umadmin', '2020-04-28 23:17:38', 37, 'ODC_TON__vpn__TX_CD_DR_MGMT', NULL, 'vpn', '', '', '100000', '10', '0023_0000000032', '0023_0000000040', '0016_0000000013', '0054_0000000006', 'created', '', NULL),
	('0026_0000000021', NULL, '0026_0000000021', 'umadmin', '2020-05-20 11:13:29', 'umadmin', '2020-04-28 23:17:39', 37, 'TX_CD_DR_MGMT__peer__TX_CD_DR_DMZ', NULL, 'peer', '', '', '100000', '10', '0023_0000000040', '0023_0000000041', '0016_0000000008', '0054_0000000004', 'created', '', NULL),
	('0026_0000000022', NULL, '0026_0000000022', 'umadmin', '2020-05-20 11:13:29', 'umadmin', '2020-04-28 23:17:39', 37, 'TX_CD_DR_MGMT__peer__TX_CD_DR_ECN', NULL, 'peer', '', '', '100000', '10', '0023_0000000040', '0023_0000000042', '0016_0000000009', '0054_0000000004', 'created', '', NULL),
	('0026_0000000023', NULL, '0026_0000000023', 'umadmin', '2020-05-20 11:13:30', 'umadmin', '2020-04-28 23:17:39', 37, 'ODC_WAN__eip__TX_CD_DR_DMZ', NULL, 'eip', '', '', '100000', '10', '0023_0000000030', '0023_0000000041', '0016_0000000003', '0054_0000000008', 'created', '', NULL),
	('0026_0000000024', NULL, '0026_0000000024', 'umadmin', '2020-05-23 23:13:52', 'umadmin', '2020-04-28 23:17:40', 37, 'TX_CD_DR_ECN__peer__TX_CD_DR_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000042', '0023_0000000043', '0016_0000000004', '0054_0000000004', 'created', '', NULL),
	('0026_0000000025', NULL, '0026_0000000025', 'umadmin', '2020-05-20 11:13:40', 'umadmin', '2020-04-28 23:18:13', 37, 'TX_CD_DR_MGMT__peer__TX_CD_DR_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000040', '0023_0000000043', '0016_0000000005', '0054_0000000004', 'created', '', NULL),
	('0026_0000000026', NULL, '0026_0000000026', 'umadmin', '2020-05-20 11:13:40', 'umadmin', '2020-04-28 23:18:14', 37, 'TX_CD_DR_QZ__peer__TX_CD_DR_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000039', '0023_0000000043', '0016_0000000006', '0054_0000000004', 'created', '', NULL),
	('0026_0000000027', NULL, '0026_0000000027', 'umadmin', '2020-05-22 10:57:41', 'umadmin', '2020-04-28 23:18:14', 37, 'TX_CD_DR_DMZ__peer__TX_CD_DR_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000041', '0023_0000000043', '0016_0000000002', '0054_0000000004', 'created', '', NULL),
	('0026_0000000028', NULL, '0026_0000000028', 'umadmin', '2020-05-22 12:30:35', 'umadmin', '2020-05-20 12:28:42', 37, 'ALI_HZ_PRD_TON__eip__ALI_HZ_PRD_MGMT', NULL, 'eip', '', '', '100000', '10', '0023_0000000081', '0023_0000000064', '0016_0000000027', '0054_0000000012', 'created', '', NULL),
	('0026_0000000029', NULL, '0026_0000000029', 'umadmin', '2020-05-22 12:30:36', 'umadmin', '2020-05-20 12:28:42', 37, 'ALI_HZ_PRD_WAN__nat__ALI_HZ_PRD_DMZ', NULL, 'nat', '', '', '100000', '10', '0023_0000000082', '0023_0000000065', '0016_0000000026', '0054_0000000014', 'created', '0023_0000000012', NULL),
	('0026_0000000030', NULL, '0026_0000000030', 'umadmin', '2020-05-22 12:30:36', 'umadmin', '2020-05-20 12:28:42', 37, 'ALI_HZ_PRD_WAN__eip__ALI_HZ_PRD_DMZ', NULL, 'eip', '', '', '100000', '10', '0023_0000000082', '0023_0000000065', '0016_0000000025', '0054_0000000012', 'created', '', NULL),
	('0026_0000000031', NULL, '0026_0000000031', 'umadmin', '2020-05-22 12:30:36', 'umadmin', '2020-05-20 12:28:42', 37, 'ALI_HZ_PRD_MGMT__peer__ALI_HZ_PRD_DMZ', NULL, 'peer', '', '', '100000', '10', '0023_0000000064', '0023_0000000065', '0016_0000000024', '0054_0000000015', 'created', '', NULL),
	('0026_0000000032', NULL, '0026_0000000032', 'umadmin', '2020-05-22 12:30:34', 'umadmin', '2020-05-20 12:28:43', 37, 'ALI_HZ_PRD_MGMT__peer__ALI_HZ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000064', '0023_0000000063', '0016_0000000023', '0054_0000000015', 'created', '', NULL),
	('0026_0000000033', NULL, '0026_0000000033', 'umadmin', '2020-05-22 12:30:35', 'umadmin', '2020-05-20 12:28:43', 37, 'ALI_HZ_PRD_DMZ__peer__ALI_HZ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000065', '0023_0000000063', '0016_0000000022', '0054_0000000015', 'created', '', NULL),
	('0026_0000000034', NULL, '0026_0000000034', 'umadmin', '2020-05-22 19:15:36', 'umadmin', '2020-05-22 19:15:35', 37, 'TX_BJ_PRD_MGMT__peer__TX_BJ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000088', '0023_0000000090', '0016_0000000023', '0054_0000000004', 'created', '', NULL),
	('0026_0000000035', NULL, '0026_0000000035', 'umadmin', '2020-05-22 19:15:36', 'umadmin', '2020-05-22 19:15:36', 37, 'TX_BJ_PRD_DMZ__peer__TX_BJ_PRD_SF', NULL, 'peer', '', '', '100000', '10', '0023_0000000089', '0023_0000000090', '0016_0000000022', '0054_0000000004', 'created', '', NULL),
	('0026_0000000036', NULL, '0026_0000000036', 'umadmin', '2020-05-22 19:15:36', 'umadmin', '2020-05-22 19:15:36', 37, 'TX_BJ_PRD_TON__eip__TX_BJ_PRD_MGMT', NULL, 'eip', '', '', '100000', '10', '0023_0000000093', '0023_0000000088', '0016_0000000027', '0054_0000000008', 'created', '', NULL),
	('0026_0000000037', NULL, '0026_0000000037', 'umadmin', '2020-05-22 19:15:36', 'umadmin', '2020-05-22 19:15:36', 37, 'TX_BJ_PRD_WAN__nat__TX_BJ_PRD_DMZ', NULL, 'nat', '', '', '100000', '10', '0023_0000000092', '0023_0000000089', '0016_0000000026', '0054_0000000003', 'created', '', NULL),
	('0026_0000000038', NULL, '0026_0000000038', 'umadmin', '2020-05-22 19:15:37', 'umadmin', '2020-05-22 19:15:36', 37, 'TX_BJ_PRD_WAN__eip__TX_BJ_PRD_DMZ', NULL, 'eip', '', '', '100000', '10', '0023_0000000092', '0023_0000000089', '0016_0000000025', '0054_0000000008', 'created', '', NULL),
	('0026_0000000039', NULL, '0026_0000000039', 'umadmin', '2020-05-22 19:15:37', 'umadmin', '2020-05-22 19:15:37', 37, 'TX_BJ_PRD_MGMT__peer__TX_BJ_PRD_DMZ', NULL, 'peer', '', '', '100000', '10', '0023_0000000088', '0023_0000000089', '0016_0000000024', '0054_0000000004', 'created', '', NULL);
/*!40000 ALTER TABLE `network_link` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_link$nat_ip_address: ~6 rows (approximately)
/*!40000 ALTER TABLE `network_link$nat_ip_address` DISABLE KEYS */;
INSERT INTO `network_link$nat_ip_address` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(5, '0026_0000000019', '0031_0000000058', 1),
	(6, '0026_0000000017', '0031_0000000059', 1),
	(7, '0026_0000000006', '0031_0000000056', 1),
	(8, '0026_0000000004', '0031_0000000057', 1),
	(10, '0026_0000000029', '0031_0000000060', 1),
	(11, '0026_0000000037', '0031_0000000061', 1);
/*!40000 ALTER TABLE `network_link$nat_ip_address` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_link_design: ~20 rows (approximately)
/*!40000 ALTER TABLE `network_link_design` DISABLE KEYS */;
INSERT INTO `network_link_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `network_segment_design_1`, `network_segment_design_2`, `state_code`) VALUES
	('0016_0000000002', NULL, '0016_0000000002', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:35:37', 34, 'PCD_DMZ__peer__PCD_SF', NULL, 'peer', '', '0013_0000000004', '0013_0000000003', 'new'),
	('0016_0000000003', NULL, '0016_0000000003', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:57', 34, 'PCD_WAN__eip__PCD_DMZ', NULL, 'eip', '', '0013_0000000008', '0013_0000000004', 'new'),
	('0016_0000000004', NULL, '0016_0000000004', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:57', 34, 'PCD_ECN__peer__PCD_SF', NULL, 'peer', '', '0013_0000000005', '0013_0000000003', 'new'),
	('0016_0000000005', NULL, '0016_0000000005', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:57', 34, 'PCD_MGMT__peer__PCD_SF', NULL, 'peer', '', '0013_0000000006', '0013_0000000003', 'new'),
	('0016_0000000006', NULL, '0016_0000000006', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:57', 34, 'PCD_QZ__peer__PCD_SF', NULL, 'peer', '', '0013_0000000007', '0013_0000000003', 'new'),
	('0016_0000000007', NULL, '0016_0000000007', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:58', 34, 'PCD_MGMT__peer__PCD_MGMT', NULL, 'peer', '', '0013_0000000006', '0013_0000000006', 'new'),
	('0016_0000000008', NULL, '0016_0000000008', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:58', 34, 'PCD_MGMT__peer__PCD_DMZ', NULL, 'peer', '', '0013_0000000006', '0013_0000000004', 'new'),
	('0016_0000000009', NULL, '0016_0000000009', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:58', 34, 'PCD_MGMT__peer__PCD_ECN', NULL, 'peer', '', '0013_0000000006', '0013_0000000005', 'new'),
	('0016_0000000010', NULL, '0016_0000000010', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:59', 34, 'PCD_WAN__nat__PCD_DMZ', NULL, 'nat', '', '0013_0000000008', '0013_0000000004', 'new'),
	('0016_0000000011', NULL, '0016_0000000011', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:59', 34, 'PCD_PTN__vpn__PCD_ECN', NULL, 'vpn', '', '0013_0000000009', '0013_0000000005', 'new'),
	('0016_0000000012', NULL, '0016_0000000012', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:59', 34, 'PCD_WAN__nat__PCD_MGMT', NULL, 'nat', '', '0013_0000000008', '0013_0000000006', 'new'),
	('0016_0000000013', NULL, '0016_0000000013', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:38:59', 34, 'PCD_TON__vpn__PCD_MGMT', NULL, 'vpn', '', '0013_0000000010', '0013_0000000006', 'new'),
	('0016_0000000014', NULL, '0016_0000000014', 'umadmin', '2020-06-30 15:37:54', 'umadmin', '2020-04-28 18:39:00', 34, 'PCD_BON__eip__PCD_QZ', NULL, 'eip', '', '0013_0000000011', '0013_0000000007', 'new'),
	('0016_0000000015', NULL, '0016_0000000015', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 18:43:55', 34, 'PCD_SF__peer__PCD_SF', NULL, 'peer', '', '0013_0000000003', '0013_0000000003', 'new'),
	('0016_0000000022', NULL, '0016_0000000022', 'umadmin', '2020-05-20 11:12:42', 'umadmin', '2020-05-20 11:12:40', 34, 'DC_DMZ__peer__DC_SF', NULL, 'peer', '', '0013_0000000034', '0013_0000000032', 'new'),
	('0016_0000000023', NULL, '0016_0000000023', 'umadmin', '2020-05-20 11:12:44', 'umadmin', '2020-05-20 11:12:42', 34, 'DC_MGMT__peer__DC_SF', NULL, 'peer', '', '0013_0000000033', '0013_0000000032', 'new'),
	('0016_0000000024', NULL, '0016_0000000024', 'umadmin', '2020-05-20 11:12:46', 'umadmin', '2020-05-20 11:12:44', 34, 'DC_MGMT__peer__DC_DMZ', NULL, 'peer', '', '0013_0000000033', '0013_0000000034', 'new'),
	('0016_0000000025', NULL, '0016_0000000025', 'umadmin', '2020-05-20 11:12:48', 'umadmin', '2020-05-20 11:12:46', 34, 'DC_WAN__eip__DC_DMZ', NULL, 'eip', '', '0013_0000000043', '0013_0000000034', 'new'),
	('0016_0000000026', NULL, '0016_0000000026', 'umadmin', '2020-05-20 11:12:50', 'umadmin', '2020-05-20 11:12:48', 34, 'DC_WAN__nat__DC_DMZ', NULL, 'nat', '', '0013_0000000043', '0013_0000000034', 'new'),
	('0016_0000000027', NULL, '0016_0000000027', 'umadmin', '2020-05-20 11:12:51', 'umadmin', '2020-05-20 11:12:50', 34, 'DC_TON__eip__DC_MGMT', NULL, 'eip', '', '0013_0000000046', '0013_0000000033', 'new');
/*!40000 ALTER TABLE `network_link_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_link_type: ~15 rows (approximately)
/*!40000 ALTER TABLE `network_link_type` DISABLE KEYS */;
INSERT INTO `network_link_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `cloud_vendor`) VALUES
	('0054_0000000001', NULL, '0054_0000000001', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-12 13:16:06', 34, '对等连接', NULL, 'peering', '', '对等连接', 'new', '0006_0000000001'),
	('0054_0000000002', NULL, '0054_0000000002', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-12 19:02:43', 34, 'NAT网关', NULL, 'nat', '', 'NAT网关', 'new', '0006_0000000001'),
	('0054_0000000003', NULL, '0054_0000000003', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-18 17:50:44', 34, 'NAT网关', NULL, 'NAT', '', 'NAT网关', 'new', '0006_0000000002'),
	('0054_0000000004', NULL, '0054_0000000004', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-18 17:50:44', 34, '对等连接', NULL, 'PEERCONNECTION', '', '对等连接', 'new', '0006_0000000002'),
	('0054_0000000005', NULL, '0054_0000000005', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-18 17:54:14', 34, 'VPN网关', NULL, 'VPN', '', 'VPN网关', 'new', '0006_0000000001'),
	('0054_0000000006', NULL, '0054_0000000006', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-18 17:54:22', 34, 'VPN网关', NULL, 'VPN', '', 'VPN网关', 'new', '0006_0000000002'),
	('0054_0000000007', NULL, '0054_0000000007', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-18 18:36:03', 34, '弹性公网IP', NULL, 'EIP', '', '弹性公网IP', 'new', '0006_0000000001'),
	('0054_0000000008', NULL, '0054_0000000008', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-18 18:36:16', 34, '弹性公网IP', NULL, 'EIP', '', '弹性公网IP', 'new', '0006_0000000002'),
	('0054_0000000009', NULL, '0054_0000000009', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-20 00:50:29', 34, '专线网关', NULL, 'DIRECT', '', '专线网关', 'new', '0006_0000000002'),
	('0054_0000000010', NULL, '0054_0000000010', 'umadmin', '2020-04-29 16:10:29', 'umadmin', '2020-04-20 00:50:29', 34, '专线网关', NULL, 'DIRECT', '', '专线网关', 'new', '0006_0000000001'),
	('0054_0000000011', NULL, '0054_0000000011', 'umadmin', '2020-05-20 12:26:43', 'umadmin', '2020-05-20 12:26:43', 34, '专线网关', NULL, 'DIRECT', '', '专线网关', 'new', '0006_0000000004'),
	('0054_0000000012', NULL, '0054_0000000012', 'umadmin', '2020-05-20 12:26:43', 'umadmin', '2020-05-20 12:26:43', 34, '弹性公网IP', NULL, 'EIP', '', '弹性公网IP', 'new', '0006_0000000004'),
	('0054_0000000013', NULL, '0054_0000000013', 'umadmin', '2020-05-20 12:26:43', 'umadmin', '2020-05-20 12:26:43', 34, 'VPN网关', NULL, 'VPN', '', 'VPN网关', 'new', '0006_0000000004'),
	('0054_0000000014', NULL, '0054_0000000014', 'umadmin', '2020-05-20 12:26:43', 'umadmin', '2020-05-20 12:26:43', 34, 'NAT网关', NULL, 'NAT', '', 'NAT网关', 'new', '0006_0000000004'),
	('0054_0000000015', NULL, '0054_0000000015', 'umadmin', '2020-05-20 12:26:43', 'umadmin', '2020-05-20 12:26:43', 34, '云企业网', NULL, 'CEN', '', '云企业网', 'new', '0006_0000000004');
/*!40000 ALTER TABLE `network_link_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_segment: ~106 rows (approximately)
/*!40000 ALTER TABLE `network_segment` DISABLE KEYS */;
INSERT INTO `network_segment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center`, `f_network_segment`, `gateway_ip`, `mask`, `name`, `network_segment_design`, `network_segment_usage`, `route_table_asset_id`, `state_code`, `subnet_asset_id`, `vpc_asset_id`, `private_route_table`, `security_group_asset_id`, `private_nat`, `nat_rule_asset_id`, `private_security_group`, `num`) VALUES
	('0023_0000000002', NULL, '0023_0000000002', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 21:57:34', 37, '10.128.0.0/16__TX_GZ_PRD_PDC', NULL, '10.128.0.0/16', '', '0022_0000000001', '', '', '16', 'TX_GZ_PRD_PDC', '0013_0000000002', 'RDC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000003', NULL, '0023_0000000003', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 21:58:44', 37, '10.128.0.0/17__TX_GZ_PRD_SF', NULL, '10.128.0.0/17', '', '0022_0000000001', '0023_0000000002', '', '17', 'TX_GZ_PRD_SF', '0013_0000000003', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000004', NULL, '0023_0000000004', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 21:58:45', 37, '10.128.128.0/19__TX_GZ_PRD_DMZ', NULL, '10.128.128.0/19', '', '0022_0000000001', '0023_0000000002', '', '19', 'TX_GZ_PRD_DMZ', '0013_0000000004', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000005', NULL, '0023_0000000005', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 21:58:45', 37, '10.128.160.0/19__TX_GZ_PRD_ECN', NULL, '10.128.160.0/19', '', '0022_0000000001', '0023_0000000002', '', '19', 'TX_GZ_PRD_ECN', '0013_0000000005', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000006', NULL, '0023_0000000006', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 21:58:46', 37, '10.128.192.0/19__TX_GZ_PRD_MGMT', NULL, '10.128.192.0/19', '', '0022_0000000001', '0023_0000000002', '', '19', 'TX_GZ_PRD_MGMT', '0013_0000000006', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000007', NULL, '0023_0000000007', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 21:58:47', 37, '10.128.224.0/19__TX_GZ_PRD_QZ', NULL, '10.128.224.0/19', '', '0022_0000000001', '0023_0000000002', '', '19', 'TX_GZ_PRD_QZ', '0013_0000000007', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000008', NULL, '0023_0000000008', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:01:31', 37, '10.128.64.0/24__TX_GZ_PRD1_SF_APP01', NULL, '10.128.64.0/24', '', '0022_0000000003', '0023_0000000003', '', '24', 'TX_GZ_PRD1_SF_APP01', '0013_0000000014', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000009', NULL, '0023_0000000009', 'umadmin', '2020-06-30 15:36:51', 'umadmin', '2020-04-28 22:01:32', 37, '10.128.65.0/24__TX_GZ_PRD2_SF_APP01', NULL, '10.128.65.0/24', '', '0022_0000000005', '0023_0000000003', '', '24', 'TX_GZ_PRD2_SF_APP01', '0013_0000000014', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000010', NULL, '0023_0000000010', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:04:50', 37, '10.128.128.0/24__TX_GZ_PRD1_DMZ_APP01', NULL, '10.128.128.0/24', '', '0022_0000000003', '0023_0000000004', '', '24', 'TX_GZ_PRD1_DMZ_APP01', '0013_0000000015', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000011', NULL, '0023_0000000011', 'umadmin', '2020-06-30 15:36:51', 'umadmin', '2020-04-28 22:04:50', 37, '10.128.129.0/24__TX_GZ_PRD2_DMZ_APP01', NULL, '10.128.129.0/24', '', '0022_0000000005', '0023_0000000004', '', '24', 'TX_GZ_PRD2_DMZ_APP01', '0013_0000000015', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000012', NULL, '0023_0000000012', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:04:51', 37, '10.128.156.0/24__TX_GZ_PRD1_DMZ_PROXY01', NULL, '10.128.156.0/24', '', '0022_0000000003', '0023_0000000004', '', '24', 'TX_GZ_PRD1_DMZ_PROXY01', '0013_0000000016', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', '01'),
	('0023_0000000013', NULL, '0023_0000000013', 'umadmin', '2020-06-30 15:36:51', 'umadmin', '2020-04-28 22:04:52', 37, '10.128.157.0/24__TX_GZ_PRD2_DMZ_PROXY01', NULL, '10.128.157.0/24', '', '0022_0000000005', '0023_0000000004', '', '24', 'TX_GZ_PRD2_DMZ_PROXY01', '0013_0000000016', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', '01'),
	('0023_0000000014', NULL, '0023_0000000014', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:05:51', 37, '10.128.160.0/24__TX_GZ_PRD1_ECN_APP01', NULL, '10.128.160.0/24', '', '0022_0000000003', '0023_0000000005', '', '24', 'TX_GZ_PRD1_ECN_APP01', '0013_0000000018', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000015', NULL, '0023_0000000015', 'umadmin', '2020-06-30 15:36:51', 'umadmin', '2020-04-28 22:05:52', 37, '10.128.161.0/24__TX_GZ_PRD2_ECN_APP01', NULL, '10.128.161.0/24', '', '0022_0000000005', '0023_0000000005', '', '24', 'TX_GZ_PRD2_ECN_APP01', '0013_0000000018', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000016', NULL, '0023_0000000016', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:10:30', 37, '10.128.192.0/24__TX_GZ_PRD1_MGMT_SEC01', NULL, '10.128.192.0/24', '', '0022_0000000003', '0023_0000000006', '', '24', 'TX_GZ_PRD1_MGMT_SEC01', '0013_0000000024', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000017', NULL, '0023_0000000017', 'umadmin', '2020-06-30 15:36:51', 'umadmin', '2020-04-28 22:10:31', 37, '10.128.193.0/24__TX_GZ_PRD2_MGMT_SEC01', NULL, '10.128.193.0/24', '', '0022_0000000005', '0023_0000000006', '', '24', 'TX_GZ_PRD2_MGMT_SEC01', '0013_0000000024', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000018', NULL, '0023_0000000018', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:10:31', 37, '10.128.196.0/24__TX_GZ_PRD1_MGMT_VDI01', NULL, '10.128.196.0/24', '', '0022_0000000003', '0023_0000000006', '', '24', 'TX_GZ_PRD1_MGMT_VDI01', '0013_0000000023', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000019', NULL, '0023_0000000019', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-28 22:10:32', 37, '10.128.197.0/24__TX_GZ_PRD2_MGMT_VDI01', NULL, '10.128.197.0/24', '', '0022_0000000005', '0023_0000000006', '', '24', 'TX_GZ_PRD2_MGMT_VDI01', '0013_0000000023', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000020', NULL, '0023_0000000020', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:10:33', 37, '10.128.200.0/24__TX_GZ_PRD1_MGMT_APP01', NULL, '10.128.200.0/24', '', '0022_0000000003', '0023_0000000006', '', '24', 'TX_GZ_PRD1_MGMT_APP01', '0013_0000000022', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000021', NULL, '0023_0000000021', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-28 22:10:33', 37, '10.128.201.0/24__TX_GZ_PRD2_MGMT_APP01', NULL, '10.128.201.0/24', '', '0022_0000000005', '0023_0000000006', '', '24', 'TX_GZ_PRD2_MGMT_APP01', '0013_0000000022', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000022', NULL, '0023_0000000022', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:10:34', 37, '10.128.212.0/24__TX_GZ_PRD1_MGMT_DB01', NULL, '10.128.212.0/24', '', '0022_0000000003', '0023_0000000006', '', '24', 'TX_GZ_PRD1_MGMT_DB01', '0013_0000000021', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000023', NULL, '0023_0000000023', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-28 22:10:35', 37, '10.128.213.0/24__TX_GZ_PRD2_MGMT_DB01', NULL, '10.128.213.0/24', '', '0022_0000000005', '0023_0000000006', '', '24', 'TX_GZ_PRD2_MGMT_DB01', '0013_0000000021', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000024', NULL, '0023_0000000024', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:10:35', 37, '10.128.220.0/24__TX_GZ_PRD1_MGMT_PROXY01', NULL, '10.128.220.0/24', '', '0022_0000000003', '0023_0000000006', '', '24', 'TX_GZ_PRD1_MGMT_PROXY01', '0013_0000000019', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', '01'),
	('0023_0000000025', NULL, '0023_0000000025', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-28 22:10:36', 37, '10.128.221.0/24__TX_GZ_PRD2_MGMT_PROXY01', NULL, '10.128.221.0/24', '', '0022_0000000005', '0023_0000000006', '', '24', 'TX_GZ_PRD2_MGMT_PROXY01', '0013_0000000019', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', '01'),
	('0023_0000000026', NULL, '0023_0000000026', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-28 22:11:49', 37, '10.128.224.0/24__TX_GZ_PRD1_QZ_VDI01', NULL, '10.128.224.0/24', '', '0022_0000000003', '0023_0000000007', '', '24', 'TX_GZ_PRD1_QZ_VDI01', '0013_0000000025', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000027', NULL, '0023_0000000027', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-28 22:11:50', 37, '10.128.225.0/24__TX_GZ_PRD2_QZ_VDI01', NULL, '10.128.225.0/24', '', '0022_0000000005', '0023_0000000007', '', '24', 'TX_GZ_PRD2_QZ_VDI01', '0013_0000000025', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000028', NULL, '0023_0000000028', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 22:14:35', 37, '0.0.0.0/0__TX_GZ_PRD_DMZ_WNET', NULL, '0.0.0.0/0', '', '0022_0000000001', '0023_0000000004', '', '0', 'TX_GZ_PRD_DMZ_WNET', '0013_0000000017', 'WNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000029', NULL, '0023_0000000029', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 22:14:36', 37, '0.0.0.0/0__TX_GZ_PRD_QZ_WNET', NULL, '0.0.0.0/0', '', '0022_0000000001', '0023_0000000007', '', '0', 'TX_GZ_PRD_QZ_WNET', '0013_0000000030', 'WNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000030', NULL, '0023_0000000030', 'umadmin', '2020-04-28 22:24:56', 'umadmin', '2020-04-28 22:24:55', 37, '0.0.0.0/0__ODC_WAN', NULL, '0.0.0.0/0', '', '0022_0000000006', '', '', '0', 'ODC_WAN', '0013_0000000008', 'VPC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000031', NULL, '0023_0000000031', 'umadmin', '2020-04-28 22:24:56', 'umadmin', '2020-04-28 22:24:56', 37, '0.0.0.0/32__ODC_PTN', NULL, '0.0.0.0/32', '', '0022_0000000006', '', '', '0', 'ODC_PTN', '0013_0000000009', 'VPC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000032', NULL, '0023_0000000032', 'umadmin', '2020-04-28 22:24:57', 'umadmin', '2020-04-28 22:24:56', 37, '0.0.0.0/32__ODC_TON', NULL, '0.0.0.0/32', '', '0022_0000000006', '', '', '0', 'ODC_TON', '0013_0000000010', 'VPC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000033', NULL, '0023_0000000033', 'umadmin', '2020-04-28 22:24:58', 'umadmin', '2020-04-28 22:24:57', 37, '0.0.0.0/32__ODC_BON', NULL, '0.0.0.0/32', '', '0022_0000000006', '', '', '0', 'ODC_BON', '0013_0000000011', 'VPC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000034', NULL, '0023_0000000034', 'umadmin', '2020-04-28 22:34:19', 'umadmin', '2020-04-28 22:33:08', 37, '192.168.130.0/24__ODC_BON_ADM01', NULL, '192.168.130.0/24', '', '0022_0000000006', '0023_0000000033', '', '24', 'ODC_BON_ADM01', '0013_0000000028', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000035', NULL, '0023_0000000035', 'umadmin', '2020-04-28 22:34:19', 'umadmin', '2020-04-28 22:33:09', 37, '10.111.0.0/31__ODC_PTN_ANY01', NULL, '10.111.0.0/31', '', '0022_0000000006', '0023_0000000031', '', '31', 'ODC_PTN_ANY01', '0013_0000000029', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000036', NULL, '0023_0000000036', 'umadmin', '2020-04-28 22:34:18', 'umadmin', '2020-04-28 22:33:10', 37, '192.168.128.0/24__ODC_TON_OPS01', NULL, '192.168.128.0/24', '', '0022_0000000006', '0023_0000000032', '', '24', 'ODC_TON_OPS01', '0013_0000000027', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000037', NULL, '0023_0000000037', 'umadmin', '2020-04-28 22:33:48', 'umadmin', '2020-04-28 22:33:10', 37, '0.0.0.0/0__ODC_WAN_ALL', NULL, '0.0.0.0/0', '', '0022_0000000006', '0023_0000000030', '', '0', 'ODC_WAN_ALL', '0013_0000000026', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000038', NULL, '0023_0000000038', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:40:22', 37, '10.130.0.0/16__TX_CD_DR_PDC', NULL, '10.130.0.0/16', '', '0022_0000000002', '', '', '16', 'TX_CD_DR_PDC', '0013_0000000002', 'RDC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000039', NULL, '0023_0000000039', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:42:17', 37, '10.130.224.0/19__TX_CD_DR_QZ', NULL, '10.130.224.0/19', '', '0022_0000000002', '0023_0000000038', '', '19', 'TX_CD_DR_QZ', '0013_0000000007', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000040', NULL, '0023_0000000040', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:42:17', 37, '10.130.192.0/19__TX_CD_DR_MGMT', NULL, '10.130.192.0/19', '', '0022_0000000002', '0023_0000000038', '', '19', 'TX_CD_DR_MGMT', '0013_0000000006', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000041', NULL, '0023_0000000041', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:42:18', 37, '10.130.128.0/19__TX_CD_DR_DMZ', NULL, '10.130.128.0/19', '', '0022_0000000002', '0023_0000000038', '', '19', 'TX_CD_DR_DMZ', '0013_0000000004', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000042', NULL, '0023_0000000042', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:42:19', 37, '10.130.160.0/19__TX_CD_DR_ECN', NULL, '10.130.160.0/19', '', '0022_0000000002', '0023_0000000038', '', '19', 'TX_CD_DR_ECN', '0013_0000000005', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000043', NULL, '0023_0000000043', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:42:19', 37, '10.130.0.0/17__TX_CD_DR_SF', NULL, '10.130.0.0/17', '', '0022_0000000002', '0023_0000000038', '', '17', 'TX_CD_DR_SF', '0013_0000000003', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000044', NULL, '0023_0000000044', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:48:05', 37, '0.0.0.0/0__TX_CD_DR_DMZ_WNET', NULL, '0.0.0.0/0', '', '0022_0000000002', '0023_0000000041', '', '0', 'TX_CD_DR_DMZ_WNET', '0013_0000000017', 'WNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000045', NULL, '0023_0000000045', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 22:48:05', 37, '0.0.0.0/0__TX_CD_DR_QZ_WNET', NULL, '0.0.0.0/0', '', '0022_0000000002', '0023_0000000039', '', '0', 'TX_CD_DR_QZ_WNET', '0013_0000000030', 'WNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000046', NULL, '0023_0000000046', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:06', 37, '10.130.224.0/24__TX_CD_DR1_QZ_VDI01', NULL, '10.130.224.0/24', '', '0022_0000000004', '0023_0000000039', '', '24', 'TX_CD_DR1_QZ_VDI01', '0013_0000000025', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000047', NULL, '0023_0000000047', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:07', 37, '10.130.220.0/24__TX_CD_DR1_MGMT_PROXY01', NULL, '10.130.220.0/24', '', '0022_0000000004', '0023_0000000040', '', '24', 'TX_CD_DR1_MGMT_PROXY01', '0013_0000000019', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', '01'),
	('0023_0000000048', NULL, '0023_0000000048', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:08', 37, '10.130.212.0/24__TX_CD_DR1_MGMT_DB01', NULL, '10.130.212.0/24', '', '0022_0000000004', '0023_0000000040', '', '24', 'TX_CD_DR1_MGMT_DB01', '0013_0000000021', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000049', NULL, '0023_0000000049', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:08', 37, '10.130.200.0/24__TX_CD_DR1_MGMT_APP01', NULL, '10.130.200.0/24', '', '0022_0000000004', '0023_0000000040', '', '24', 'TX_CD_DR1_MGMT_APP01', '0013_0000000022', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000050', NULL, '0023_0000000050', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:09', 37, '10.130.196.0/24__TX_CD_DR1_MGMT_VDI01', NULL, '10.130.196.0/24', '', '0022_0000000004', '0023_0000000040', '', '24', 'TX_CD_DR1_MGMT_VDI01', '0013_0000000023', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000051', NULL, '0023_0000000051', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:10', 37, '10.130.192.0/24__TX_CD_DR1_MGMT_SEC01', NULL, '10.130.192.0/24', '', '0022_0000000004', '0023_0000000040', '', '24', 'TX_CD_DR1_MGMT_SEC01', '0013_0000000024', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000052', NULL, '0023_0000000052', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:10', 37, '10.130.160.0/24__TX_CD_DR1_ECN_APP01', NULL, '10.130.160.0/24', '', '0022_0000000004', '0023_0000000042', '', '24', 'TX_CD_DR1_ECN_APP01', '0013_0000000018', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000053', NULL, '0023_0000000053', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:11', 37, '10.130.156.0/24__TX_CD_DR1_DMZ_PROXY01', NULL, '10.130.156.0/24', '', '0022_0000000004', '0023_0000000041', '', '24', 'TX_CD_DR1_DMZ_PROXY01', '0013_0000000016', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', '01'),
	('0023_0000000054', NULL, '0023_0000000054', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:12', 37, '10.130.128.0/24__TX_CD_DR1_DMZ_APP01', NULL, '10.130.128.0/24', '', '0022_0000000004', '0023_0000000041', '', '24', 'TX_CD_DR1_DMZ_APP01', '0013_0000000015', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000055', NULL, '0023_0000000055', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-28 22:48:12', 37, '10.130.64.0/24__TX_CD_DR1_SF_APP01', NULL, '10.130.64.0/24', '', '0022_0000000004', '0023_0000000043', '', '24', 'TX_CD_DR1_SF_APP01', '0013_0000000014', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000056', NULL, '0023_0000000056', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-29 00:33:37', 37, '10.128.1.0/24__TX_GZ_PRD2_SF_DB01', NULL, '10.128.1.0/24', '', '0022_0000000005', '0023_0000000003', '', '24', 'TX_GZ_PRD2_SF_DB01', '0013_0000000012', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000057', NULL, '0023_0000000057', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-29 00:33:38', 37, '10.128.0.0/24__TX_GZ_PRD1_SF_DB01', NULL, '10.128.0.0/24', '', '0022_0000000003', '0023_0000000003', '', '24', 'TX_GZ_PRD1_SF_DB01', '0013_0000000012', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000058', NULL, '0023_0000000058', 'umadmin', '2020-06-30 15:36:53', 'umadmin', '2020-04-29 00:34:24', 37, '10.128.32.0/24__TX_GZ_PRD1_SF_BDP01', NULL, '10.128.32.0/24', '', '0022_0000000003', '0023_0000000003', '', '24', 'TX_GZ_PRD1_SF_BDP01', '0013_0000000013', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000059', NULL, '0023_0000000059', 'umadmin', '2020-06-30 15:36:52', 'umadmin', '2020-04-29 00:34:25', 37, '10.128.33.0/24__TX_GZ_PRD2_SF_BDP01', NULL, '10.128.33.0/24', '', '0022_0000000005', '0023_0000000003', '', '24', 'TX_GZ_PRD2_SF_BDP01', '0013_0000000013', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000060', NULL, '0023_0000000060', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-29 00:37:33', 37, '10.130.32.0/24__TX_CD_DR1_SF_BDP01', NULL, '10.130.32.0/24', '', '0022_0000000004', '0023_0000000043', '', '24', 'TX_CD_DR1_SF_BDP01', '0013_0000000013', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000061', NULL, '0023_0000000061', 'umadmin', '2020-06-30 15:36:50', 'umadmin', '2020-04-29 00:37:34', 37, '10.130.0.0/24__TX_CD_DR1_SF_DB01', NULL, '10.130.0.0/24', '', '0022_0000000004', '0023_0000000043', '', '24', 'TX_CD_DR1_SF_DB01', '0013_0000000012', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '01'),
	('0023_0000000062', NULL, '0023_0000000062', 'umadmin', '2020-05-22 10:48:25', 'umadmin', '2020-05-20 12:10:02', 37, '10.128.192.0/20__ALI_HZ_PRD_DC', NULL, '10.128.192.0/20', '', '0022_0000000009', '', '', '20', 'ALI_HZ_PRD_DC', '0013_0000000031', 'RDC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000063', NULL, '0023_0000000063', 'umadmin', '2020-05-22 10:48:25', 'umadmin', '2020-05-20 12:10:46', 37, '10.128.192.0/21__ALI_HZ_PRD_SF', NULL, '10.128.192.0/21', '', '0022_0000000009', '0023_0000000062', '', '21', 'ALI_HZ_PRD_SF', '0013_0000000032', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000064', NULL, '0023_0000000064', 'umadmin', '2020-05-23 14:19:13', 'umadmin', '2020-05-20 12:10:47', 37, '10.128.200.0/22__ALI_HZ_PRD_MGMT', NULL, '10.128.200.0/22', '', '0022_0000000009', '0023_0000000062', '', '22', 'ALI_HZ_PRD_MGMT', '0013_0000000033', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000065', NULL, '0023_0000000065', 'umadmin', '2020-05-22 10:48:25', 'umadmin', '2020-05-20 12:10:47', 37, '10.128.204.0/22__ALI_HZ_PRD_DMZ', NULL, '10.128.204.0/22', '', '0022_0000000009', '0023_0000000062', '', '22', 'ALI_HZ_PRD_DMZ', '0013_0000000034', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000066', NULL, '0023_0000000066', 'umadmin', '2020-05-21 14:57:32', 'umadmin', '2020-05-20 12:12:22', 37, '10.128.192.0/24__ALI_HZ_PRD1_SF_DB', NULL, '10.128.192.0/24', '', '0022_0000000011', '0023_0000000063', '', '24', 'ALI_HZ_PRD1_SF_DB', '0013_0000000035', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000067', NULL, '0023_0000000067', 'umadmin', '2020-05-22 18:05:09', 'umadmin', '2020-05-20 12:12:22', 37, '10.128.193.0/24__ALI_HZ_PRD2_SF_DB', NULL, '10.128.193.0/24', '', '0022_0000000010', '0023_0000000063', '', '24', 'ALI_HZ_PRD2_SF_DB', '0013_0000000035', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000068', NULL, '0023_0000000068', 'umadmin', '2020-05-21 14:57:32', 'umadmin', '2020-05-20 12:13:34', 37, '10.128.194.0/24__ALI_HZ_PRD1_SF_BDP', NULL, '10.128.194.0/24', '', '0022_0000000011', '0023_0000000063', '', '24', 'ALI_HZ_PRD1_SF_BDP', '0013_0000000036', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000069', NULL, '0023_0000000069', 'umadmin', '2020-05-22 18:05:09', 'umadmin', '2020-05-20 12:13:35', 37, '10.128.195.0/24__ALI_HZ_PRD2_SF_BDP', NULL, '10.128.195.0/24', '', '0022_0000000010', '0023_0000000063', '', '24', 'ALI_HZ_PRD2_SF_BDP', '0013_0000000036', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000070', NULL, '0023_0000000070', 'umadmin', '2020-05-22 18:05:09', 'umadmin', '2020-05-20 12:14:05', 37, '10.128.198.0/23__ALI_HZ_PRD2_SF_APP', NULL, '10.128.198.0/23', '', '0022_0000000010', '0023_0000000063', '', '23', 'ALI_HZ_PRD2_SF_APP', '0013_0000000037', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000071', NULL, '0023_0000000071', 'umadmin', '2020-05-21 14:57:32', 'umadmin', '2020-05-20 12:14:06', 37, '10.128.196.0/23__ALI_HZ_PRD1_SF_APP', NULL, '10.128.196.0/23', '', '0022_0000000011', '0023_0000000063', '', '23', 'ALI_HZ_PRD1_SF_APP', '0013_0000000037', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000072', NULL, '0023_0000000072', 'umadmin', '2020-05-23 14:19:13', 'umadmin', '2020-05-20 12:16:57', 37, '10.128.202.0/24__ALI_HZ_PRD1_MGMT_APP', NULL, '10.128.202.0/24', '', '0022_0000000011', '0023_0000000064', '', '24', 'ALI_HZ_PRD1_MGMT_APP', '0013_0000000042', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000073', NULL, '0023_0000000073', 'umadmin', '2020-05-22 18:05:09', 'umadmin', '2020-05-20 12:16:58', 37, '10.128.203.0/24__ALI_HZ_PRD2_MGMT_APP', NULL, '10.128.203.0/24', '', '0022_0000000010', '0023_0000000064', '', '24', 'ALI_HZ_PRD2_MGMT_APP', '0013_0000000042', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000074', NULL, '0023_0000000074', 'umadmin', '2020-05-21 14:57:32', 'umadmin', '2020-05-20 12:16:58', 37, '10.128.200.0/24__ALI_HZ_PRD1_MGMT_DB', NULL, '10.128.200.0/24', '', '0022_0000000011', '0023_0000000064', '', '24', 'ALI_HZ_PRD1_MGMT_DB', '0013_0000000041', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000075', NULL, '0023_0000000075', 'umadmin', '2020-05-22 18:05:10', 'umadmin', '2020-05-20 12:16:58', 37, '10.128.201.0/24__ALI_HZ_PRD2_MGMT_DB', NULL, '10.128.201.0/24', '', '0022_0000000010', '0023_0000000064', '', '24', 'ALI_HZ_PRD2_MGMT_DB', '0013_0000000041', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000078', NULL, '0023_0000000078', 'umadmin', '2020-05-21 14:57:32', 'umadmin', '2020-05-20 12:19:39', 37, '10.128.206.0/24__ALI_HZ_PRD1_DMZ_PROXY', NULL, '10.128.206.0/24', '', '0022_0000000011', '0023_0000000065', '', '24', 'ALI_HZ_PRD1_DMZ_PROXY', '0013_0000000039', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', ''),
	('0023_0000000079', NULL, '0023_0000000079', 'umadmin', '2020-05-22 18:05:10', 'umadmin', '2020-05-20 12:19:39', 37, '10.128.207.0/24__ALI_HZ_PRD2_DMZ_PROXY', NULL, '10.128.207.0/24', '', '0022_0000000010', '0023_0000000065', '', '24', 'ALI_HZ_PRD2_DMZ_PROXY', '0013_0000000039', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', ''),
	('0023_0000000080', NULL, '0023_0000000080', 'umadmin', '2020-05-22 10:48:25', 'umadmin', '2020-05-20 12:20:33', 37, '0.0.0.0/0__ALI_HZ_PRD_DMZ_WNET', NULL, '0.0.0.0/0', '', '0022_0000000009', '0023_0000000065', '', '0', 'ALI_HZ_PRD_DMZ_WNET', '0013_0000000040', 'WNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000081', NULL, '0023_0000000081', 'umadmin', '2020-05-22 10:48:25', 'umadmin', '2020-05-20 12:21:28', 37, '1.1.1.1/32__ALI_HZ_PRD_TON', NULL, '1.1.1.1/32', '', '0022_0000000009', '', '', '0', 'ALI_HZ_PRD_TON', '0013_0000000046', 'TON', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000082', NULL, '0023_0000000082', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:23:01', 37, '0.0.0.0/0__ALI_HZ_PRD_WAN', NULL, '0.0.0.0/0', '', '0022_0000000009', '', '', '0', 'ALI_HZ_PRD_WAN', '0013_0000000043', 'WAN', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000083', NULL, '0023_0000000083', 'umadmin', '2020-05-21 14:57:33', 'umadmin', '2020-05-20 12:50:54', 37, '10.128.204.0/24__ALI_HZ_PRD1_DMZ_APP', NULL, '10.128.204.0/24', '', '0022_0000000011', '0023_0000000065', '', '24', 'ALI_HZ_PRD1_DMZ_APP', '0013_0000000038', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000084', NULL, '0023_0000000084', 'umadmin', '2020-05-22 18:05:10', 'umadmin', '2020-05-20 12:50:54', 37, '10.128.205.0/24__ALI_HZ_PRD2_DMZ_APP', NULL, '10.128.205.0/24', '', '0022_0000000010', '0023_0000000065', '', '24', 'ALI_HZ_PRD2_DMZ_APP', '0013_0000000038', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000085', NULL, '0023_0000000085', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 14:05:36', 37, '0.0.0.0/0__ALI_HZ_PRD_WAN_ALL', NULL, '0.0.0.0/0', '', '0022_0000000009', '0023_0000000082', '', '0', 'ALI_HZ_PRD_WAN_ALL', '0013_0000000044', 'WAN', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000086', NULL, '0023_0000000086', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 14:05:37', 37, '1.1.1.1/32__ALI_HZ_PRD_TON_CLIENT', NULL, '1.1.1.1/32', '', '0022_0000000009', '0023_0000000081', '', '0', 'ALI_HZ_PRD_TON_CLIENT', '0013_0000000045', 'TON', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000087', NULL, '0023_0000000087', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:04:53', 37, '10.128.192.0/20__TX_BJ_PRD_DC', NULL, '10.128.192.0/20', '', '0022_0000000016', '', '', '20', 'TX_BJ_PRD_DC', '0013_0000000031', 'RDC', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000088', NULL, '0023_0000000088', 'umadmin', '2020-05-23 14:31:01', 'umadmin', '2020-05-22 19:05:52', 37, '10.128.200.0/22__TX_BJ_PRD_MGMT', NULL, '10.128.200.0/22', '', '0022_0000000016', '0023_0000000087', '', '22', 'TX_BJ_PRD_MGMT', '0013_0000000033', 'VPC', '', 'created', '', 'vpc-guf2rcp4', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000089', NULL, '0023_0000000089', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:05:53', 37, '10.128.204.0/22__TX_BJ_PRD_DMZ', NULL, '10.128.204.0/22', '', '0022_0000000016', '0023_0000000087', '', '22', 'TX_BJ_PRD_DMZ', '0013_0000000034', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000090', NULL, '0023_0000000090', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:05:54', 37, '10.128.192.0/21__TX_BJ_PRD_SF', NULL, '10.128.192.0/21', '', '0022_0000000016', '0023_0000000087', '', '21', 'TX_BJ_PRD_SF', '0013_0000000032', 'VPC', '', 'created', '', '', 'Y', '', 'N', '', 'Y', ''),
	('0023_0000000091', NULL, '0023_0000000091', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:07:28', 37, '0.0.0.0/0__TX_BJ_PRD_DMZ_WNET', NULL, '0.0.0.0/0', '', '0022_0000000016', '0023_0000000089', '', '0', 'TX_BJ_PRD_DMZ_WNET', '0013_0000000040', 'WNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000092', NULL, '0023_0000000092', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:08:13', 37, '0.0.0.0/0__TX_BJ_PRD_WAN', NULL, '0.0.0.0/0', '', '0022_0000000016', '', '', '0', 'TX_BJ_PRD_WAN', '0013_0000000043', 'WAN', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000093', NULL, '0023_0000000093', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:08:14', 37, '1.1.1.1/32__TX_BJ_PRD_TON', NULL, '1.1.1.1/32', '', '0022_0000000016', '', '', '0', 'TX_BJ_PRD_TON', '0013_0000000046', 'TON', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000094', NULL, '0023_0000000094', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:09:00', 37, '1.1.1.1/32__TX_BJ_PRD_TON_CLIENT', NULL, '1.1.1.1/32', '', '0022_0000000016', '0023_0000000093', '', '0', 'TX_BJ_PRD_TON_CLIENT', '0013_0000000045', 'TON', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000095', NULL, '0023_0000000095', 'umadmin', '2020-05-23 13:20:35', 'umadmin', '2020-05-22 19:09:00', 37, '0.0.0.0/0__TX_BJ_PRD_WAN_ALL', NULL, '0.0.0.0/0', '', '0022_0000000016', '0023_0000000092', '', '0', 'TX_BJ_PRD_WAN_ALL', '0013_0000000044', 'WAN', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000096', NULL, '0023_0000000096', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 19:11:32', 37, '10.128.204.0/24__TX_BJ_PRD1_DMZ_APP', NULL, '10.128.204.0/24', '', '0022_0000000018', '0023_0000000089', '', '24', 'TX_BJ_PRD1_DMZ_APP', '0013_0000000038', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000097', NULL, '0023_0000000097', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 19:11:32', 37, '10.128.206.0/24__TX_BJ_PRD1_DMZ_PROXY', NULL, '10.128.206.0/24', '', '0022_0000000018', '0023_0000000089', '', '24', 'TX_BJ_PRD1_DMZ_PROXY', '0013_0000000039', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', ''),
	('0023_0000000098', NULL, '0023_0000000098', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 19:11:33', 37, '10.128.200.0/24__TX_BJ_PRD1_MGMT_DB', NULL, '10.128.200.0/24', '', '0022_0000000018', '0023_0000000088', '', '24', 'TX_BJ_PRD1_MGMT_DB', '0013_0000000041', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000099', NULL, '0023_0000000099', 'umadmin', '2020-05-23 14:31:01', 'umadmin', '2020-05-22 19:11:34', 37, '10.128.202.0/24__TX_BJ_PRD1_MGMT_APP', NULL, '10.128.202.0/24', '', '0022_0000000018', '0023_0000000088', '', '24', 'TX_BJ_PRD1_MGMT_APP', '0013_0000000042', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000100', NULL, '0023_0000000100', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 19:11:34', 37, '10.128.196.0/23__TX_BJ_PRD1_SF_APP', NULL, '10.128.196.0/23', '', '0022_0000000018', '0023_0000000090', '', '23', 'TX_BJ_PRD1_SF_APP', '0013_0000000037', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000101', NULL, '0023_0000000101', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 19:11:35', 37, '10.128.194.0/24__TX_BJ_PRD1_SF_BDP', NULL, '10.128.194.0/24', '', '0022_0000000018', '0023_0000000090', '', '24', 'TX_BJ_PRD1_SF_BDP', '0013_0000000036', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000102', NULL, '0023_0000000102', 'umadmin', '2020-05-22 19:32:48', 'umadmin', '2020-05-22 19:11:35', 37, '10.128.192.0/24__TX_BJ_PRD1_SF_DB', NULL, '10.128.192.0/24', '', '0022_0000000018', '0023_0000000090', '', '24', 'TX_BJ_PRD1_SF_DB', '0013_0000000035', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000103', NULL, '0023_0000000103', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:44', 37, '10.128.205.0/24__TX_BJ_PRD2_DMZ_APP', NULL, '10.128.205.0/24', '', '0022_0000000017', '0023_0000000089', '', '24', 'TX_BJ_PRD2_DMZ_APP', '0013_0000000038', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000104', NULL, '0023_0000000104', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:45', 37, '10.128.207.0/24__TX_BJ_PRD2_DMZ_PROXY', NULL, '10.128.207.0/24', '', '0022_0000000017', '0023_0000000089', '', '24', 'TX_BJ_PRD2_DMZ_PROXY', '0013_0000000039', 'SUBNET', '', 'created', '', '', 'Y', '', 'Y', '', 'Y', ''),
	('0023_0000000105', NULL, '0023_0000000105', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:45', 37, '10.128.203.0/24__TX_BJ_PRD2_MGMT_APP', NULL, '10.128.203.0/24', '', '0022_0000000017', '0023_0000000088', '', '24', 'TX_BJ_PRD2_MGMT_APP', '0013_0000000042', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000106', NULL, '0023_0000000106', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:46', 37, '10.128.201.0/24__TX_BJ_PRD2_MGMT_DB', NULL, '10.128.201.0/24', '', '0022_0000000017', '0023_0000000088', '', '24', 'TX_BJ_PRD2_MGMT_DB', '0013_0000000041', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000107', NULL, '0023_0000000107', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:46', 37, '10.128.198.0/23__TX_BJ_PRD2_SF_APP', NULL, '10.128.198.0/23', '', '0022_0000000017', '0023_0000000090', '', '23', 'TX_BJ_PRD2_SF_APP', '0013_0000000037', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000108', NULL, '0023_0000000108', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:47', 37, '10.128.195.0/24__TX_BJ_PRD2_SF_BDP', NULL, '10.128.195.0/24', '', '0022_0000000017', '0023_0000000090', '', '24', 'TX_BJ_PRD2_SF_BDP', '0013_0000000036', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', ''),
	('0023_0000000109', NULL, '0023_0000000109', 'umadmin', '2020-05-22 19:32:47', 'umadmin', '2020-05-22 19:12:47', 37, '10.128.193.0/24__TX_BJ_PRD2_SF_DB', NULL, '10.128.193.0/24', '', '0022_0000000017', '0023_0000000090', '', '24', 'TX_BJ_PRD2_SF_DB', '0013_0000000035', 'SUBNET', '', 'created', '', '', 'N', '', 'N', '', 'N', '');
/*!40000 ALTER TABLE `network_segment` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_segment_design: ~45 rows (approximately)
/*!40000 ALTER TABLE `network_segment_design` DISABLE KEYS */;
INSERT INTO `network_segment_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center_design`, `f_network_segment_design`, `mask`, `name`, `network_segment_usage`, `state_code`, `private_route_table`, `private_nat`, `private_security_group`) VALUES
	('0013_0000000002', NULL, '0013_0000000002', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:19:11', 34, '10.*.0.0/16__RDC__PCD_PDC', NULL, '10.*.0.0/16', '', '0012_0000000001', '', '16', 'PDC', 'RDC', 'new', 'N', 'N', 'N'),
	('0013_0000000003', NULL, '0013_0000000003', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:25:45', 34, '10.*.0.0/17__VPC__PCD_SF', NULL, '10.*.0.0/17', '核心业务区', '0012_0000000001', '0013_0000000002', '17', 'SF', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000004', NULL, '0013_0000000004', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:29', 34, '10.*.128.0/19__VPC__PCD_DMZ', NULL, '10.*.128.0/19', '互联网接入区', '0012_0000000001', '0013_0000000002', '19', 'DMZ', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000005', NULL, '0013_0000000005', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:30', 34, '10.*.160.0/19__VPC__PCD_ECN', NULL, '10.*.160.0/19', '伙伴网接入区', '0012_0000000001', '0013_0000000002', '19', 'ECN', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000006', NULL, '0013_0000000006', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:32', 34, '10.*.192.0/19__VPC__PCD_MGMT', NULL, '10.*.192.0/19', '科技运维网接入区', '0012_0000000001', '0013_0000000002', '19', 'MGMT', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000007', NULL, '0013_0000000007', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:32', 34, '10.*.224.0/19__VPC__PCD_QZ', NULL, '10.*.224.0/19', '业务运营网接入区', '0012_0000000001', '0013_0000000002', '19', 'QZ', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000008', NULL, '0013_0000000008', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:33', 34, '0.0.0.0/0__VPC__PCD_WAN', NULL, '0.0.0.0/0', '互联网', '0012_0000000001', '0013_0000000002', '0', 'WAN', 'VPC', 'new', 'N', 'N', 'N'),
	('0013_0000000009', NULL, '0013_0000000009', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:34', 34, '*.*.*.*/0__VPC__PCD_PTN', NULL, '*.*.*.*/0', '伙伴网', '0012_0000000001', '0013_0000000002', '0', 'PTN', 'VPC', 'new', 'N', 'N', 'N'),
	('0013_0000000010', NULL, '0013_0000000010', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:35', 34, '*.*.*.*/0__VPC__PCD_TON', NULL, '*.*.*.*/0', '科技运维网', '0012_0000000001', '0013_0000000002', '0', 'TON', 'VPC', 'new', 'N', 'N', 'N'),
	('0013_0000000011', NULL, '0013_0000000011', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 18:30:35', 34, '*.*.*.*/0__VPC__PCD_BON', NULL, '*.*.*.*/0', '业务运营网', '0012_0000000001', '0013_0000000002', '0', 'BON', 'VPC', 'new', 'N', 'N', 'N'),
	('0013_0000000012', NULL, '0013_0000000012', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:10:47', 34, '10.*.[0-31].0/24__SUBNET__PCD_SF_DB', NULL, '10.*.[0-31].0/24', '数据库网段', '0012_0000000001', '0013_0000000003', '24', 'SF_DB', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000013', NULL, '0013_0000000013', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:10:48', 34, '10.*.[32-63].0/24__SUBNET__PCD_SF_BDP', NULL, '10.*.[32-63].0/24', '大数据网段', '0012_0000000001', '0013_0000000003', '24', 'SF_BDP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000014', NULL, '0013_0000000014', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:10:48', 34, '10.*.[64-127].0/24__SUBNET__PCD_SF_APP', NULL, '10.*.[64-127].0/24', '应用网段', '0012_0000000001', '0013_0000000003', '24', 'SF_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000015', NULL, '0013_0000000015', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:10:49', 34, '10.*.[128-155].0/24__SUBNET__PCD_DMZ_APP', NULL, '10.*.[128-155].0/24', '应用网段', '0012_0000000001', '0013_0000000004', '24', 'DMZ_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000016', NULL, '0013_0000000016', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:10:49', 34, '10.*.[156-159].0/24__SUBNET__PCD_DMZ_PROXY', NULL, '10.*.[156-159].0/24', '代理服务网段', '0012_0000000001', '0013_0000000004', '24', 'DMZ_PROXY', 'SUBNET', 'new', 'Y', 'Y', 'Y'),
	('0013_0000000017', NULL, '0013_0000000017', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:10:50', 34, '0.0.0.0/0__WNET__PCD_DMZ_WNET', NULL, '0.0.0.0/0', '互联网网段', '0012_0000000001', '0013_0000000004', '0', 'DMZ_WNET', 'WNET', 'new', 'N', 'N', 'N'),
	('0013_0000000018', NULL, '0013_0000000018', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 19:12:47', 34, '10.*.[160-191].0/24__SUBNET__PCD_ECN_APP', NULL, '10.*.[160-191].0/24', '应用网段', '0012_0000000001', '0013_0000000005', '24', 'ECN_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000019', NULL, '0013_0000000019', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 20:41:25', 34, '10.*.[220-223].0/24__SUBNET__PCD_MGMT_PROXY', NULL, '10.*.[220-223].0/24', '代理网段', '0012_0000000001', '0013_0000000006', '24', 'MGMT_PROXY', 'SUBNET', 'new', 'Y', 'Y', 'Y'),
	('0013_0000000020', NULL, '0013_0000000020', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 20:41:25', 34, '10.*.[216-219].0/24__SUBNET__PCD_MGMT_BDP', NULL, '10.*.[216-219].0/24', '大数据网段', '0012_0000000001', '0013_0000000006', '24', 'MGMT_BDP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000021', NULL, '0013_0000000021', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 20:41:26', 34, '10.*.[212-215].0/24__SUBNET__PCD_MGMT_DB', NULL, '10.*.[212-215].0/24', '数据库网段', '0012_0000000001', '0013_0000000006', '24', 'MGMT_DB', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000022', NULL, '0013_0000000022', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 20:41:26', 34, '10.*.[200-211].0/24__SUBNET__PCD_MGMT_APP', NULL, '10.*.[200-211].0/24', '应用和跳板机网段', '0012_0000000001', '0013_0000000006', '24', 'MGMT_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000023', NULL, '0013_0000000023', 'umadmin', '2020-06-30 15:37:47', 'umadmin', '2020-04-28 20:41:27', 34, '10.*.[196-199].0/24__SUBNET__PCD_MGMT_VDI', NULL, '10.*.[196-199].0/24', 'Windows VDI网段', '0012_0000000001', '0013_0000000006', '24', 'MGMT_VDI', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000024', NULL, '0013_0000000024', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 20:41:27', 34, '10.*.[192-195].0/24__SUBNET__PCD_MGMT_SEC', NULL, '10.*.[192-195].0/24', '堡垒机网段', '0012_0000000001', '0013_0000000006', '24', 'MGMT_SEC', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000025', NULL, '0013_0000000025', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 20:43:24', 34, '10.*.[224-255].0/24__SUBNET__PCD_QZ_VDI', NULL, '10.*.[224-255].0/24', '业务运营VDI网段', '0012_0000000001', '0013_0000000007', '24', 'QZ_VDI', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000026', NULL, '0013_0000000026', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 20:53:04', 34, '0.0.0.0/0__SUBNET__PCD_WAN_ALL', NULL, '0.0.0.0/0', '', '0012_0000000001', '0013_0000000008', '0', 'WAN_ALL', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000027', NULL, '0013_0000000027', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 20:53:07', 34, '*.*.*.*/24__SUBNET__PCD_TON_OPS', NULL, '*.*.*.*/24', '', '0012_0000000001', '0013_0000000010', '24', 'TON_OPS', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000028', NULL, '0013_0000000028', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 20:53:09', 34, '*.*.*.*/24__SUBNET__PCD_BON_ADM', NULL, '*.*.*.*/24', '', '0012_0000000001', '0013_0000000011', '24', 'BON_ADM', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000029', NULL, '0013_0000000029', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 20:53:12', 34, '*.*.*.*/31__SUBNET__PCD_PTN_ANY', NULL, '*.*.*.*/31', '', '0012_0000000001', '0013_0000000009', '31', 'PTN_ANY', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000030', NULL, '0013_0000000030', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 21:17:15', 34, '0.0.0.0/0__WNET__PCD_QZ_WNET', NULL, '0.0.0.0/0', '', '0012_0000000001', '0013_0000000007', '0', 'QZ_WNET', 'WNET', 'new', 'N', 'N', 'N'),
	('0013_0000000031', NULL, '0013_0000000031', 'umadmin', '2020-05-20 10:42:32', 'umadmin', '2020-05-20 10:39:41', 34, '10.*.192.0/20__RDC__DC_DC', NULL, '10.*.192.0/20', '', '0012_0000000002', '', '20', 'DC', 'RDC', 'new', 'N', 'N', 'N'),
	('0013_0000000032', NULL, '0013_0000000032', 'umadmin', '2020-05-20 10:42:45', 'umadmin', '2020-05-20 10:41:43', 34, '10.*.192.0/21__VPC__DC_SF', NULL, '10.*.192.0/21', '', '0012_0000000002', '0013_0000000031', '21', 'SF', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000033', NULL, '0013_0000000033', 'umadmin', '2020-05-20 10:43:21', 'umadmin', '2020-05-20 10:43:21', 34, '10.*.200.0/22__VPC__DC_MGMT', NULL, '10.*.200.0/22', '', '0012_0000000002', '0013_0000000031', '22', 'MGMT', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000034', NULL, '0013_0000000034', 'umadmin', '2020-05-20 10:44:15', 'umadmin', '2020-05-20 10:44:15', 34, '10.*.204.0/22__VPC__DC_DMZ', NULL, '10.*.204.0/22', '', '0012_0000000002', '0013_0000000031', '22', 'DMZ', 'VPC', 'new', 'Y', 'N', 'Y'),
	('0013_0000000035', NULL, '0013_0000000035', 'umadmin', '2020-05-20 10:46:44', 'umadmin', '2020-05-20 10:46:44', 34, '10.*.[192-193].0/24__SUBNET__DC_SF_DB', NULL, '10.*.[192-193].0/24', '', '0012_0000000002', '0013_0000000032', '24', 'SF_DB', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000036', NULL, '0013_0000000036', 'umadmin', '2020-05-20 10:46:44', 'umadmin', '2020-05-20 10:46:44', 34, '10.*.[194-195].0/24__SUBNET__DC_SF_BDP', NULL, '10.*.[194-195].0/24', '', '0012_0000000002', '0013_0000000032', '24', 'SF_BDP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000037', NULL, '0013_0000000037', 'umadmin', '2020-05-20 12:17:41', 'umadmin', '2020-05-20 10:47:16', 34, '10.*.[196-199].0/23__SUBNET__DC_SF_APP', NULL, '10.*.[196-199].0/23', '', '0012_0000000002', '0013_0000000032', '23', 'SF_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000038', NULL, '0013_0000000038', 'umadmin', '2020-05-20 10:50:20', 'umadmin', '2020-05-20 10:50:19', 34, '10.*.[204,205].0/24__SUBNET__DC_DMZ_APP', NULL, '10.*.[204,205].0/24', '', '0012_0000000002', '0013_0000000034', '24', 'DMZ_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000039', NULL, '0013_0000000039', 'umadmin', '2020-05-20 10:50:20', 'umadmin', '2020-05-20 10:50:20', 34, '10.*.[206,207].0/24__SUBNET__DC_DMZ_PROXY', NULL, '10.*.[206,207].0/24', '', '0012_0000000002', '0013_0000000034', '24', 'DMZ_PROXY', 'SUBNET', 'new', 'Y', 'Y', 'Y'),
	('0013_0000000040', NULL, '0013_0000000040', 'umadmin', '2020-05-20 10:50:57', 'umadmin', '2020-05-20 10:50:57', 34, '0.0.0.0/0__WNET__DC_DMZ_WNET', NULL, '0.0.0.0/0', '', '0012_0000000002', '0013_0000000034', '0', 'DMZ_WNET', 'WNET', 'new', 'N', 'N', 'N'),
	('0013_0000000041', NULL, '0013_0000000041', 'umadmin', '2020-05-20 10:53:06', 'umadmin', '2020-05-20 10:53:05', 34, '10.*.[200,201].0/24__SUBNET__DC_MGMT_DB', NULL, '10.*.[200,201].0/24', '', '0012_0000000002', '0013_0000000033', '24', 'MGMT_DB', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000042', NULL, '0013_0000000042', 'umadmin', '2020-05-20 10:53:29', 'umadmin', '2020-05-20 10:53:29', 34, '10.*.[202,203].0/24__SUBNET__DC_MGMT_APP', NULL, '10.*.[202,203].0/24', '', '0012_0000000002', '0013_0000000033', '24', 'MGMT_APP', 'SUBNET', 'new', 'N', 'N', 'N'),
	('0013_0000000043', NULL, '0013_0000000043', 'umadmin', '2020-05-20 10:54:01', 'umadmin', '2020-05-20 10:54:01', 34, '0.0.0.0/0__WAN__DC_WAN', NULL, '0.0.0.0/0', '', '0012_0000000002', '', '0', 'WAN', 'WAN', 'new', 'N', 'N', 'N'),
	('0013_0000000044', NULL, '0013_0000000044', 'umadmin', '2020-05-20 10:58:44', 'umadmin', '2020-05-20 10:54:40', 34, '0.0.0.0/0__WAN__DC_WAN_ALL', NULL, '0.0.0.0/0', '', '0012_0000000002', '0013_0000000043', '0', 'WAN_ALL', 'WAN', 'new', 'N', 'N', 'N'),
	('0013_0000000045', NULL, '0013_0000000045', 'umadmin', '2020-05-20 10:58:44', 'umadmin', '2020-05-20 10:55:52', 34, '*.*.*.*/32__TON__DC_TON_CLIENT', NULL, '*.*.*.*/32', '', '0012_0000000002', '0013_0000000046', '0', 'TON_CLIENT', 'TON', 'new', 'N', 'N', 'N'),
	('0013_0000000046', NULL, '0013_0000000046', 'umadmin', '2020-05-20 10:55:53', 'umadmin', '2020-05-20 10:55:52', 34, '*.*.*.*/32__TON__DC_TON', NULL, '*.*.*.*/32', '', '0012_0000000002', '', '0', 'TON', 'TON', 'new', 'N', 'N', 'N');
/*!40000 ALTER TABLE `network_segment_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_zone: ~24 rows (approximately)
/*!40000 ALTER TABLE `network_zone` DISABLE KEYS */;
INSERT INTO `network_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center`, `network_segment`, `network_zone_design`, `network_zone_layer`, `state_code`) VALUES
	('0024_0000000002', NULL, '0024_0000000002', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 23:36:43', 37, 'TX_GZ_PRD_SF', NULL, 'SF', '', '0022_0000000001', '0023_0000000003', '0014_0000000002', 'CORE', 'created'),
	('0024_0000000003', NULL, '0024_0000000003', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 23:36:44', 37, 'TX_GZ_PRD_DMZ', NULL, 'DMZ', '', '0022_0000000001', '0023_0000000004', '0014_0000000003', 'LINK', 'created'),
	('0024_0000000004', NULL, '0024_0000000004', 'umadmin', '2020-06-30 15:37:25', 'umadmin', '2020-04-28 23:36:44', 37, 'TX_GZ_PRD_ECN', NULL, 'ECN', '', '0022_0000000001', '0023_0000000005', '0014_0000000004', 'LINK', 'created'),
	('0024_0000000005', NULL, '0024_0000000005', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:36:45', 37, 'TX_GZ_PRD_MGMT', NULL, 'MGMT', '', '0022_0000000001', '0023_0000000006', '0014_0000000005', 'LINK', 'created'),
	('0024_0000000006', NULL, '0024_0000000006', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-28 23:36:45', 37, 'TX_GZ_PRD_QZ', NULL, 'QZ', '', '0022_0000000001', '0023_0000000007', '0014_0000000006', 'LINK', 'created'),
	('0024_0000000007', NULL, '0024_0000000007', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:36:45', 37, 'TX_CD_DR_SF', NULL, 'SF', '', '0022_0000000002', '0023_0000000043', '0014_0000000002', 'CORE', 'created'),
	('0024_0000000008', NULL, '0024_0000000008', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:36:46', 37, 'TX_CD_DR_DMZ', NULL, 'DMZ', '', '0022_0000000002', '0023_0000000041', '0014_0000000003', 'LINK', 'created'),
	('0024_0000000009', NULL, '0024_0000000009', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:36:46', 37, 'TX_CD_DR_ECN', NULL, 'ECN', '', '0022_0000000002', '0023_0000000042', '0014_0000000004', 'LINK', 'created'),
	('0024_0000000010', NULL, '0024_0000000010', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:36:47', 37, 'TX_CD_DR_MGMT', NULL, 'MGMT', '', '0022_0000000002', '0023_0000000040', '0014_0000000005', 'LINK', 'created'),
	('0024_0000000011', NULL, '0024_0000000011', 'umadmin', '2020-06-30 15:37:21', 'umadmin', '2020-04-28 23:36:47', 37, 'TX_CD_DR_QZ', NULL, 'QZ', '', '0022_0000000002', '0023_0000000039', '0014_0000000006', 'LINK', 'created'),
	('0024_0000000012', NULL, '0024_0000000012', 'umadmin', '2020-04-28 23:36:48', 'umadmin', '2020-04-28 23:36:47', 37, 'ODC_WAN', NULL, 'WAN', '', '0022_0000000006', '0023_0000000030', '0014_0000000007', 'CLIENT', 'created'),
	('0024_0000000013', NULL, '0024_0000000013', 'umadmin', '2020-04-28 23:36:48', 'umadmin', '2020-04-28 23:36:48', 37, 'ODC_PTN', NULL, 'PTN', '', '0022_0000000006', '0023_0000000031', '0014_0000000008', 'CLIENT', 'created'),
	('0024_0000000014', NULL, '0024_0000000014', 'umadmin', '2020-04-28 23:36:48', 'umadmin', '2020-04-28 23:36:48', 37, 'ODC_TON', NULL, 'TON', '', '0022_0000000006', '0023_0000000032', '0014_0000000009', 'CLIENT', 'created'),
	('0024_0000000015', NULL, '0024_0000000015', 'umadmin', '2020-04-28 23:36:49', 'umadmin', '2020-04-28 23:36:48', 37, 'ODC_BON', NULL, 'BON', '', '0022_0000000006', '0023_0000000033', '0014_0000000010', 'CLIENT', 'created'),
	('0024_0000000016', NULL, '0024_0000000016', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:23:07', 37, 'ALI_HZ_PRD_SF', NULL, 'SF', '', '0022_0000000009', '0023_0000000063', '0014_0000000011', 'CORE', 'created'),
	('0024_0000000017', NULL, '0024_0000000017', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:23:07', 37, 'ALI_HZ_PRD_DMZ', NULL, 'DMZ', '', '0022_0000000009', '0023_0000000065', '0014_0000000012', 'LINK', 'created'),
	('0024_0000000018', NULL, '0024_0000000018', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:23:07', 37, 'ALI_HZ_PRD_MGMT', NULL, 'MGMT', '', '0022_0000000009', '0023_0000000064', '0014_0000000013', 'LINK', 'created'),
	('0024_0000000019', NULL, '0024_0000000019', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:23:08', 37, 'ALI_HZ_PRD_TON', NULL, 'TON', '', '0022_0000000009', '0023_0000000081', '0014_0000000014', 'CLIENT', 'created'),
	('0024_0000000020', NULL, '0024_0000000020', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:23:08', 37, 'ALI_HZ_PRD_WAN', NULL, 'WAN', '', '0022_0000000009', '0023_0000000082', '0014_0000000015', 'CLIENT', 'created'),
	('0024_0000000021', NULL, '0024_0000000021', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:24:37', 37, 'TX_BJ_PRD_TON', NULL, 'TON', '', '0022_0000000016', '0023_0000000093', '0014_0000000014', 'CLIENT', 'created'),
	('0024_0000000022', NULL, '0024_0000000022', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:24:38', 37, 'TX_BJ_PRD_WAN', NULL, 'WAN', '', '0022_0000000016', '0023_0000000092', '0014_0000000015', 'CLIENT', 'created'),
	('0024_0000000023', NULL, '0024_0000000023', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:24:38', 37, 'TX_BJ_PRD_SF', NULL, 'SF', '', '0022_0000000016', '0023_0000000090', '0014_0000000011', 'CORE', 'created'),
	('0024_0000000024', NULL, '0024_0000000024', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:24:38', 37, 'TX_BJ_PRD_DMZ', NULL, 'DMZ', '', '0022_0000000016', '0023_0000000089', '0014_0000000012', 'LINK', 'created'),
	('0024_0000000025', NULL, '0024_0000000025', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:24:38', 37, 'TX_BJ_PRD_MGMT', NULL, 'MGMT', '', '0022_0000000016', '0023_0000000088', '0014_0000000013', 'LINK', 'created');
/*!40000 ALTER TABLE `network_zone` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.network_zone_design: ~14 rows (approximately)
/*!40000 ALTER TABLE `network_zone_design` DISABLE KEYS */;
INSERT INTO `network_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `data_center_design`, `network_segment_design`, `network_zone_layer`, `state_code`) VALUES
	('0014_0000000002', NULL, '0014_0000000002', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:31:38', 34, 'PCD_SF', NULL, 'SF', '核心业务区域', '0012_0000000001', '0013_0000000003', 'CORE', 'new'),
	('0014_0000000003', NULL, '0014_0000000003', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:40', 34, 'PCD_DMZ', NULL, 'DMZ', '外网接入区域', '0012_0000000001', '0013_0000000004', 'LINK', 'new'),
	('0014_0000000004', NULL, '0014_0000000004', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:40', 34, 'PCD_ECN', NULL, 'ECN', '伙伴接入区域', '0012_0000000001', '0013_0000000005', 'LINK', 'new'),
	('0014_0000000005', NULL, '0014_0000000005', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:41', 34, 'PCD_MGMT', NULL, 'MGMT', '科技运维接入区域', '0012_0000000001', '0013_0000000006', 'LINK', 'new'),
	('0014_0000000006', NULL, '0014_0000000006', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:41', 34, 'PCD_QZ', NULL, 'QZ', '业务运营接入区域', '0012_0000000001', '0013_0000000007', 'LINK', 'new'),
	('0014_0000000007', NULL, '0014_0000000007', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:41', 34, 'PCD_WAN', NULL, 'WAN', '外网区域', '0012_0000000001', '0013_0000000008', 'CLIENT', 'new'),
	('0014_0000000008', NULL, '0014_0000000008', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:42', 34, 'PCD_PTN', NULL, 'PTN', '伙伴区域', '0012_0000000001', '0013_0000000009', 'CLIENT', 'new'),
	('0014_0000000009', NULL, '0014_0000000009', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:42', 34, 'PCD_TON', NULL, 'TON', '科技运维区域', '0012_0000000001', '0013_0000000010', 'CLIENT', 'new'),
	('0014_0000000010', NULL, '0014_0000000010', 'umadmin', '2020-06-30 15:37:48', 'umadmin', '2020-04-28 18:34:42', 34, 'PCD_BON', NULL, 'BON', '业务运营区域', '0012_0000000001', '0013_0000000011', 'CLIENT', 'new'),
	('0014_0000000011', NULL, '0014_0000000011', 'umadmin', '2020-05-20 10:59:03', 'umadmin', '2020-05-20 10:59:03', 34, 'DC_SF', NULL, 'SF', '', '0012_0000000002', '0013_0000000032', 'CORE', 'new'),
	('0014_0000000012', NULL, '0014_0000000012', 'umadmin', '2020-05-20 11:02:34', 'umadmin', '2020-05-20 11:02:34', 34, 'DC_DMZ', NULL, 'DMZ', '', '0012_0000000002', '0013_0000000034', 'LINK', 'new'),
	('0014_0000000013', NULL, '0014_0000000013', 'umadmin', '2020-05-20 11:02:35', 'umadmin', '2020-05-20 11:02:34', 34, 'DC_MGMT', NULL, 'MGMT', '', '0012_0000000002', '0013_0000000033', 'LINK', 'new'),
	('0014_0000000014', NULL, '0014_0000000014', 'umadmin', '2020-05-20 11:02:35', 'umadmin', '2020-05-20 11:02:35', 34, 'DC_TON', NULL, 'TON', '', '0012_0000000002', '0013_0000000046', 'CLIENT', 'new'),
	('0014_0000000015', NULL, '0014_0000000015', 'umadmin', '2020-05-20 11:02:35', 'umadmin', '2020-05-20 11:02:35', 34, 'DC_WAN', NULL, 'WAN', '', '0012_0000000002', '0013_0000000043', 'CLIENT', 'new');
/*!40000 ALTER TABLE `network_zone_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.rdb_instance: ~3 rows (approximately)
/*!40000 ALTER TABLE `rdb_instance` DISABLE KEYS */;
INSERT INTO `rdb_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_script`, `deploy_user`, `deploy_user_password`, `memory`, `port`, `rdb_resource_instance`, `regular_backup_asset_id`, `rollback_script`, `state_code`, `storage`, `unit`, `upgrade_script`, `variable_values`, `name`, `deploy_backup_asset_id`) VALUES
	('0051_0000000002', NULL, '0051_0000000002', 'umadmin', '2020-05-08 17:42:54', 'umadmin', '2020-05-08 17:42:54', 37, 'democore_IP7544:3306', NULL, 'democore(master)_IP7544:3306', '', '1', '', '', NULL, 'democore', 'Abcd1234', '2', '3306', '0033_0000000006', '', NULL, 'created', '10', '0048_0000000003', NULL, '=', 'democore', ''),
	('0051_0000000004', NULL, '0051_0000000004', 'umadmin', '2020-05-21 14:58:51', 'umadmin', '2020-05-20 16:57:23', 37, 'ademocore_IP4323:3306', NULL, 'ademocore(master)_IP4323:3306', '', '1', '', '', NULL, 'dbuser', 'Abcd1234', '2', '3306', '0033_0000000007', '', NULL, 'created', '20', '0048_0000000015', NULL, '=', 'ademocore', ''),
	('0051_0000000005', NULL, '0051_0000000005', 'umadmin', '2020-06-30 15:31:29', 'umadmin', '2020-05-23 00:29:06', 37, 'ademocore_IP4383:3306', NULL, 'ademocore(master)_IP4383:3306', '', '1', '0045_0000000006', '', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'dbuser', 'Abcd1234', '2', '3306', '0033_0000000008', '', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', 'created', '20', '0048_0000000022', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', '=', 'ademocore', '');
/*!40000 ALTER TABLE `rdb_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.rdb_resource_instance: ~5 rows (approximately)
/*!40000 ALTER TABLE `rdb_resource_instance` DISABLE KEYS */;
INSERT INTO `rdb_resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `backup_asset_id`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `ip_address`, `login_port`, `master_resource_instance`, `memory`, `monitor_key_name`, `monitor_port`, `name`, `resource_instance_spec`, `resource_instance_system`, `resource_instance_type`, `resource_set`, `state_code`, `storage`, `user_name`, `user_password`, `storage_type`, `network_segment`) VALUES
	('0033_0000000004', NULL, '0033_0000000004', 'umadmin', '2020-05-08 11:08:29', 'umadmin', '2020-04-29 11:38:17', 40, 'TX_GZ_PRD_MGMT_1M1_MYSQL1__wecubecore', NULL, 'wecubecore_IP3467', '', '', '', '', '0063_0000000004', '0008_0000000007', '', '', '10.128.212.5', '3306', '', '', 'IP3467:3306', '3306', 'wecubecore', '0010_0000000044', '0011_0000000023', '0009_0000000023', '0029_0000000039', 'created', '50', 'root', 'Wecube@123456', '0062_0000000011', '0023_0000000022'),
	('0033_0000000005', NULL, '0033_0000000005', 'umadmin', '2020-05-08 15:35:37', 'umadmin', '2020-04-29 11:38:18', 40, 'TX_GZ_PRD_MGMT_1M1_MYSQL1__wecubeplugin', NULL, 'wecubeplugin_IP3425', '', '', '', '', '0063_0000000004', '0008_0000000007', '', '', '10.128.212.15', '3306', '', '', 'IP3425:3306', '3306', 'wecubeplugin', '0010_0000000045', '0011_0000000023', '0009_0000000023', '0029_0000000039', 'created', '50', 'root', 'Wecube@123456', '0062_0000000011', '0023_0000000022'),
	('0033_0000000006', NULL, '0033_0000000006', 'umadmin', '2020-05-08 17:03:38', 'umadmin', '2020-05-08 17:03:38', 40, 'TX_GZ_PRD_SF_1A1_MYSQL1__admmysql1', NULL, 'admmysql1_IP7544', '', '', '', '', '0063_0000000004', '0008_0000000007', '', '', 'IP7544', '3306', '', '', 'IP7544:3306', '3306', 'admmysql1', '0010_0000000044', '0011_0000000023', '0009_0000000023', '0029_0000000055', 'created', '50', 'root', 'Abcd1234', '0062_0000000011', '0023_0000000057'),
	('0033_0000000007', NULL, '0033_0000000007', 'umadmin', '2020-05-21 14:58:51', 'umadmin', '2020-05-20 15:11:02', 40, 'ALI_HZ_PRD_SF__MYSQL1__mysql01', NULL, 'mysql01_IP4323', '', '', '', '', '0063_0000000005', '0008_0000000013', '', '', 'IP4323', '3306', '', '', 'IP4323:3306', '3306', 'mysql01', '0010_0000000055', '0011_0000000034', '0009_0000000029', '0029_0000000101', 'created', '50', 'root', 'Abcd1234', '0062_0000000041', '0023_0000000066'),
	('0033_0000000008', NULL, '0033_0000000008', 'umadmin', '2020-05-22 19:50:15', 'umadmin', '2020-05-22 19:50:14', 40, 'TX_BJ_PRD_SF__MYSQL1__mysql01', NULL, 'mysql01_IP4383', '', '', '', '', '0063_0000000004', '0008_0000000007', '', '', 'IP4383', '3306', '', '', 'IP4383:3306', '3306', 'mysql01', '0010_0000000044', '0011_0000000023', '0009_0000000023', '0029_0000000136', 'created', '50', 'root', 'Abcd1234', '0062_0000000011', '0023_0000000102');
/*!40000 ALTER TABLE `rdb_resource_instance` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_instance_spec: ~16 rows (approximately)
/*!40000 ALTER TABLE `resource_instance_spec` DISABLE KEYS */;
INSERT INTO `resource_instance_spec` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `unit_type`, `resource_instance_type`) VALUES
	('0010_0000000041', NULL, '0010_0000000041', 'umadmin', '2020-04-29 17:26:19', 'umadmin', '2020-04-29 17:20:52', 34, '2G', NULL, '2G', '', '2G', 'new', NULL, NULL),
	('0010_0000000042', NULL, '0010_0000000042', 'umadmin', '2020-04-29 17:26:19', 'umadmin', '2020-04-29 17:20:52', 34, '4G', NULL, '4G', '', '4G', 'new', NULL, NULL),
	('0010_0000000043', NULL, '0010_0000000043', 'umadmin', '2020-04-29 17:26:19', 'umadmin', '2020-04-29 17:20:52', 34, '8G', NULL, '8G', '', '8G', 'new', NULL, NULL),
	('0010_0000000044', NULL, '0010_0000000044', 'umadmin', '2020-05-20 14:59:54', 'umadmin', '2020-04-29 17:20:52', 34, '1核2G', NULL, '2000', '', '1核2G', 'new', NULL, NULL),
	('0010_0000000045', NULL, '0010_0000000045', 'umadmin', '2020-05-20 14:59:54', 'umadmin', '2020-04-29 17:20:52', 34, '2核4G', NULL, '4000', '', '2核4G', 'new', NULL, NULL),
	('0010_0000000046', NULL, '0010_0000000046', 'umadmin', '2020-05-20 14:59:54', 'umadmin', '2020-04-29 17:20:52', 34, '4核8G', NULL, '8000', '', '4核8G', 'new', NULL, NULL),
	('0010_0000000047', NULL, '0010_0000000047', 'umadmin', '2020-05-20 14:53:33', 'umadmin', '2020-04-29 17:23:58', 34, '1核2G', NULL, '1C2G', '', '1核2G', 'new', NULL, NULL),
	('0010_0000000048', NULL, '0010_0000000048', 'umadmin', '2020-05-20 14:55:05', 'umadmin', '2020-04-29 17:23:58', 34, '2核4G', NULL, '2C4G', '', '2核4G', 'new', NULL, NULL),
	('0010_0000000049', NULL, '0010_0000000049', 'umadmin', '2020-05-20 14:54:01', 'umadmin', '2020-04-29 17:23:58', 34, '4核8G', NULL, '4C8G', '', '4核8G', 'new', NULL, NULL),
	('0010_0000000050', NULL, '0010_0000000050', 'umadmin', '2020-05-20 14:56:01', 'umadmin', '2020-04-29 17:27:11', 34, '2G', NULL, '2048', '', '2G', 'new', NULL, NULL),
	('0010_0000000051', NULL, '0010_0000000051', 'umadmin', '2020-05-20 14:56:01', 'umadmin', '2020-04-29 17:27:11', 34, '4G', NULL, '4096', '', '4G', 'new', NULL, NULL),
	('0010_0000000052', NULL, '0010_0000000052', 'umadmin', '2020-05-20 14:56:01', 'umadmin', '2020-04-29 17:27:11', 34, '8G', NULL, '8192', '', '8G', 'new', NULL, NULL),
	('0010_0000000053', NULL, '0010_0000000053', 'umadmin', '2020-04-29 18:35:16', 'umadmin', '2020-04-29 18:35:16', 34, '2核4G', NULL, '2C4G', '', '2核4G', 'new', NULL, NULL),
	('0010_0000000054', NULL, '0010_0000000054', 'umadmin', '2020-05-20 14:58:48', 'umadmin', '2020-05-20 14:58:48', 34, '1核2G', NULL, '1C2G', '', '1核2G', 'new', NULL, NULL),
	('0010_0000000055', NULL, '0010_0000000055', 'umadmin', '2020-05-20 14:58:48', 'umadmin', '2020-05-20 14:58:48', 34, '2核4G', NULL, '2C4G', '', '2核4G', 'new', NULL, NULL),
	('0010_0000000056', NULL, '0010_0000000056', 'umadmin', '2020-05-20 14:58:48', 'umadmin', '2020-05-20 14:58:48', 34, '4核8G', NULL, '4C8G', '', '4核8G', 'new', NULL, NULL);
/*!40000 ALTER TABLE `resource_instance_spec` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_instance_spec$resource_instance_type: ~68 rows (approximately)
/*!40000 ALTER TABLE `resource_instance_spec$resource_instance_type` DISABLE KEYS */;
INSERT INTO `resource_instance_spec$resource_instance_type` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(62, '0010_0000000041', '0009_0000000007', 1),
	(63, '0010_0000000041', '0009_0000000006', 2),
	(64, '0010_0000000042', '0009_0000000007', 1),
	(65, '0010_0000000042', '0009_0000000006', 2),
	(66, '0010_0000000043', '0009_0000000007', 1),
	(67, '0010_0000000043', '0009_0000000006', 2),
	(78, '0010_0000000053', '0009_0000000005', 2),
	(79, '0010_0000000053', '0009_0000000012', 1),
	(110, '0010_0000000047', '0009_0000000022', 2),
	(111, '0010_0000000047', '0009_0000000013', 4),
	(112, '0010_0000000047', '0009_0000000021', 6),
	(113, '0010_0000000047', '0009_0000000036', 7),
	(114, '0010_0000000047', '0009_0000000001', 1),
	(115, '0010_0000000047', '0009_0000000034', 9),
	(116, '0010_0000000047', '0009_0000000030', 8),
	(117, '0010_0000000047', '0009_0000000016', 5),
	(118, '0010_0000000047', '0009_0000000004', 3),
	(128, '0010_0000000049', '0009_0000000001', 1),
	(129, '0010_0000000049', '0009_0000000019', 2),
	(130, '0010_0000000049', '0009_0000000031', 7),
	(131, '0010_0000000049', '0009_0000000032', 8),
	(132, '0010_0000000049', '0009_0000000020', 3),
	(133, '0010_0000000049', '0009_0000000017', 6),
	(134, '0010_0000000049', '0009_0000000016', 5),
	(135, '0010_0000000049', '0009_0000000034', 9),
	(136, '0010_0000000049', '0009_0000000018', 4),
	(137, '0010_0000000048', '0009_0000000019', 2),
	(138, '0010_0000000048', '0009_0000000020', 3),
	(139, '0010_0000000048', '0009_0000000018', 4),
	(140, '0010_0000000048', '0009_0000000034', 9),
	(141, '0010_0000000048', '0009_0000000012', 11),
	(142, '0010_0000000048', '0009_0000000001', 1),
	(143, '0010_0000000048', '0009_0000000032', 8),
	(144, '0010_0000000048', '0009_0000000035', 10),
	(145, '0010_0000000048', '0009_0000000031', 7),
	(146, '0010_0000000048', '0009_0000000005', 12),
	(147, '0010_0000000048', '0009_0000000016', 5),
	(148, '0010_0000000048', '0009_0000000017', 6),
	(149, '0010_0000000050', '0009_0000000027', 3),
	(150, '0010_0000000050', '0009_0000000028', 4),
	(151, '0010_0000000050', '0009_0000000026', 2),
	(152, '0010_0000000050', '0009_0000000025', 1),
	(153, '0010_0000000051', '0009_0000000027', 3),
	(154, '0010_0000000051', '0009_0000000028', 4),
	(155, '0010_0000000051', '0009_0000000026', 2),
	(156, '0010_0000000051', '0009_0000000025', 1),
	(157, '0010_0000000052', '0009_0000000027', 3),
	(158, '0010_0000000052', '0009_0000000028', 4),
	(159, '0010_0000000052', '0009_0000000026', 2),
	(160, '0010_0000000052', '0009_0000000025', 1),
	(161, '0010_0000000054', '0009_0000000002', 2),
	(162, '0010_0000000054', '0009_0000000033', 3),
	(163, '0010_0000000054', '0009_0000000024', 1),
	(164, '0010_0000000054', '0009_0000000029', 4),
	(165, '0010_0000000055', '0009_0000000002', 2),
	(166, '0010_0000000055', '0009_0000000033', 3),
	(167, '0010_0000000055', '0009_0000000024', 1),
	(168, '0010_0000000055', '0009_0000000029', 4),
	(169, '0010_0000000056', '0009_0000000002', 2),
	(170, '0010_0000000056', '0009_0000000033', 4),
	(171, '0010_0000000056', '0009_0000000024', 1),
	(172, '0010_0000000056', '0009_0000000029', 3),
	(173, '0010_0000000044', '0009_0000000015', 2),
	(174, '0010_0000000044', '0009_0000000023', 1),
	(175, '0010_0000000045', '0009_0000000015', 2),
	(176, '0010_0000000045', '0009_0000000023', 1),
	(177, '0010_0000000046', '0009_0000000002', 2),
	(178, '0010_0000000046', '0009_0000000024', 1);
/*!40000 ALTER TABLE `resource_instance_spec$resource_instance_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_instance_system: ~13 rows (approximately)
/*!40000 ALTER TABLE `resource_instance_system` DISABLE KEYS */;
INSERT INTO `resource_instance_system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `resource_instance_type`, `name`, `state_code`) VALUES
	('0011_0000000023', NULL, '0011_0000000023', 'umadmin', '2020-04-29 17:18:34', 'umadmin', '2020-04-29 17:18:34', 34, 'MYSQL5.6', NULL, '5.6', '', NULL, 'MYSQL5.6', 'new'),
	('0011_0000000024', NULL, '0011_0000000024', 'umadmin', '2020-04-29 17:18:34', 'umadmin', '2020-04-29 17:18:34', 34, 'MYSQL5.6', NULL, '5.6', '', NULL, 'MYSQL5.6', 'new'),
	('0011_0000000025', NULL, '0011_0000000025', 'umadmin', '2020-04-29 17:18:34', 'umadmin', '2020-04-29 17:18:34', 34, 'WinServer2012中文', NULL, 'img-29hl923v', '', NULL, 'WinServer2012中文', 'new'),
	('0011_0000000026', NULL, '0011_0000000026', 'umadmin', '2020-04-29 17:18:35', 'umadmin', '2020-04-29 17:18:34', 34, 'WinServer2012中文', NULL, 'img-29hl923v', '', NULL, 'WinServer2012中文', 'new'),
	('0011_0000000027', NULL, '0011_0000000027', 'umadmin', '2020-04-29 17:18:35', 'umadmin', '2020-04-29 17:18:35', 34, 'REDIS3.0', NULL, '3.0', '', NULL, 'REDIS3.0', 'new'),
	('0011_0000000028', NULL, '0011_0000000028', 'umadmin', '2020-04-29 17:18:35', 'umadmin', '2020-04-29 17:18:35', 34, 'REDIS4.0', NULL, '4.0', '', NULL, 'REDIS4.0', 'new'),
	('0011_0000000029', NULL, '0011_0000000029', 'umadmin', '2020-04-29 17:18:35', 'umadmin', '2020-04-29 17:18:35', 34, 'CentOS7.5 64位', NULL, 'img-oikl1tzv', '', NULL, 'CentOS7.5 64位', 'new'),
	('0011_0000000030', NULL, '0011_0000000030', 'umadmin', '2020-04-29 17:18:35', 'umadmin', '2020-04-29 17:18:35', 34, 'CentOS7.5 64位', NULL, 'img-oikl1tzv', '', NULL, 'CentOS7.5 64位', 'new'),
	('0011_0000000031', NULL, '0011_0000000031', 'umadmin', '2020-05-20 15:01:13', 'umadmin', '2020-05-20 15:01:13', 34, 'REDIS4.0', NULL, '4.0', '', NULL, 'REDIS4.0', 'new'),
	('0011_0000000032', NULL, '0011_0000000032', 'umadmin', '2020-05-20 15:01:13', 'umadmin', '2020-05-20 15:01:13', 34, 'REDIS5.0', NULL, '5.0', '', NULL, 'REDIS5.0', 'new'),
	('0011_0000000033', NULL, '0011_0000000033', 'umadmin', '2020-05-20 15:05:11', 'umadmin', '2020-05-20 15:05:11', 34, 'CentOS7.5 64位', NULL, 'centos_7_05_64_20G_alibase_20181210.vhd', '', NULL, 'CentOS7.5 64位', 'new'),
	('0011_0000000034', NULL, '0011_0000000034', 'umadmin', '2020-05-20 15:05:11', 'umadmin', '2020-05-20 15:05:11', 34, 'MYSQL5.7', NULL, '5.7', '', NULL, 'MYSQL5.7', 'new'),
	('0011_0000000035', NULL, '0011_0000000035', 'umadmin', '2020-05-20 15:05:11', 'umadmin', '2020-05-20 15:05:11', 34, 'WinServer2012中文', NULL, '请查询配置', '', NULL, 'WinServer2012中文', 'new');
/*!40000 ALTER TABLE `resource_instance_system` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_instance_system$resource_instance_type: ~30 rows (approximately)
/*!40000 ALTER TABLE `resource_instance_system$resource_instance_type` DISABLE KEYS */;
INSERT INTO `resource_instance_system$resource_instance_type` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0011_0000000023', '0009_0000000023', 1),
	(2, '0011_0000000024', '0009_0000000024', 1),
	(3, '0011_0000000025', '0009_0000000012', 1),
	(4, '0011_0000000026', '0009_0000000005', 1),
	(5, '0011_0000000027', '0009_0000000007', 2),
	(6, '0011_0000000027', '0009_0000000006', 1),
	(7, '0011_0000000028', '0009_0000000026', 2),
	(8, '0011_0000000028', '0009_0000000025', 1),
	(9, '0011_0000000029', '0009_0000000021', 1),
	(10, '0011_0000000029', '0009_0000000019', 2),
	(11, '0011_0000000029', '0009_0000000013', 5),
	(12, '0011_0000000029', '0009_0000000017', 3),
	(13, '0011_0000000029', '0009_0000000016', 4),
	(14, '0011_0000000030', '0009_0000000020', 2),
	(15, '0011_0000000030', '0009_0000000018', 3),
	(16, '0011_0000000030', '0009_0000000022', 1),
	(17, '0011_0000000030', '0009_0000000004', 4),
	(18, '0011_0000000030', '0009_0000000001', 5),
	(19, '0011_0000000031', '0009_0000000028', 2),
	(20, '0011_0000000031', '0009_0000000027', 1),
	(21, '0011_0000000032', '0009_0000000028', 1),
	(22, '0011_0000000032', '0009_0000000027', 2),
	(23, '0011_0000000033', '0009_0000000036', 4),
	(24, '0011_0000000033', '0009_0000000032', 1),
	(25, '0011_0000000033', '0009_0000000030', 5),
	(26, '0011_0000000033', '0009_0000000031', 2),
	(27, '0011_0000000033', '0009_0000000034', 3),
	(28, '0011_0000000034', '0009_0000000033', 1),
	(29, '0011_0000000034', '0009_0000000029', 2),
	(30, '0011_0000000035', '0009_0000000035', 1);
/*!40000 ALTER TABLE `resource_instance_system$resource_instance_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_instance_type: ~36 rows (approximately)
/*!40000 ALTER TABLE `resource_instance_type` DISABLE KEYS */;
INSERT INTO `resource_instance_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `unit_type`, `cluster_type`) VALUES
	('0009_0000000001', NULL, '0009_0000000001', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 22:21:49', 34, '内存型_华为云JAVA', NULL, 'm3', '', '内存型', 'new', '0002_0000000001', '0007_0000000001'),
	('0009_0000000002', NULL, '0009_0000000002', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 23:36:11', 34, '异步型_华为云MYSQL', NULL, 'async', '', '异步型', 'new', '0002_0000000002', '0007_0000000002'),
	('0009_0000000003', NULL, '0009_0000000003', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-11 23:40:13', 34, '内网型_华为云LB', NULL, 'Internal', '', '内网型', 'new', '0002_0000000004', '0007_0000000003'),
	('0009_0000000004', NULL, '0009_0000000004', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-12 03:07:31', 34, '通用型_华为云SQUID', NULL, 's3', '', '通用型', 'new', '0002_0000000006', '0007_0000000003'),
	('0009_0000000005', NULL, '0009_0000000005', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-12 03:09:45', 34, '通用型_华为云VDI', NULL, 's3', '', '通用型', 'new', '0002_0000000005', '0007_0000000003'),
	('0009_0000000006', NULL, '0009_0000000006', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-13 00:07:13', 34, '主从型_华为云REDIS', NULL, 'ha', '', '主从型', 'new', '0002_0000000003', '0007_0000000005'),
	('0009_0000000007', NULL, '0009_0000000007', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-13 18:04:06', 34, '单机型_华为云REDIS', NULL, 'single', '', '单机型', 'new', '0002_0000000003', '0007_0000000006'),
	('0009_0000000008', NULL, '0009_0000000008', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-13 18:09:23', 34, '外网型_华为云LB', NULL, 'External', '', '外网型', 'new', '0002_0000000004', '0007_0000000003'),
	('0009_0000000009', NULL, '0009_0000000009', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 17:41:10', 34, '外网型_腾讯云LB', NULL, 'external_lb', '', '外网型', 'new', '0002_0000000004', '0007_0000000012'),
	('0009_0000000012', NULL, '0009_0000000012', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 17:41:11', 34, '通用型_腾讯云VDI', NULL, 'S3', '', '通用型', 'new', '0002_0000000005', '0007_0000000012'),
	('0009_0000000013', NULL, '0009_0000000013', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 17:41:11', 34, '通用型_腾讯云SQUID', NULL, 'S3', '', '通用型', 'new', '0002_0000000006', '0007_0000000012'),
	('0009_0000000014', NULL, '0009_0000000014', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 17:41:11', 34, '内网型_腾讯云LB', NULL, 'internal_lb', '', '内网型', 'new', '0002_0000000004', '0007_0000000012'),
	('0009_0000000015', NULL, '0009_0000000015', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 17:41:12', 34, '异步型_腾讯云MYSQL', NULL, '0', '', '异步型', 'new', '0002_0000000002', '0007_0000000008'),
	('0009_0000000016', NULL, '0009_0000000016', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-18 17:41:12', 34, '内存型_腾讯云JAVA', NULL, 'M3', '', '内存型', 'new', '0002_0000000001', '0007_0000000007'),
	('0009_0000000017', NULL, '0009_0000000017', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-24 11:56:43', 34, '内存型_腾讯云DOCKER', NULL, 'M3', '', '内存型', 'new', '0002_0000000012', '0007_0000000007'),
	('0009_0000000018', NULL, '0009_0000000018', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 11:56:43', 34, '内存型_华为云DOCKER', NULL, 'm3', '', '内存型', 'new', '0002_0000000012', '0007_0000000001'),
	('0009_0000000019', NULL, '0009_0000000019', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-24 11:57:31', 34, '内存型_腾讯云OAP', NULL, 'M3', '', '内存型', 'new', '0002_0000000010', '0007_0000000012'),
	('0009_0000000020', NULL, '0009_0000000020', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 11:57:31', 34, '内存型_华为云OAP', NULL, 'm3', '', '内存型', 'new', '0002_0000000010', '0007_0000000003'),
	('0009_0000000021', NULL, '0009_0000000021', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-24 11:58:00', 34, '通用型_腾讯云NGINX', NULL, 'S3', '', '通用型', 'new', '0002_0000000011', '0007_0000000007'),
	('0009_0000000022', NULL, '0009_0000000022', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 11:58:01', 34, '通用型_华为云NGINX', NULL, 's3', '', '通用型', 'new', '0002_0000000011', '0007_0000000001'),
	('0009_0000000023', NULL, '0009_0000000023', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-29 11:45:39', 34, '半同步型_腾讯云MYSQL', NULL, '1', '', '半同步型', 'new', '0002_0000000002', '0007_0000000008'),
	('0009_0000000024', NULL, '0009_0000000024', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-29 11:45:39', 34, '半同步型_华为云MYSQL', NULL, 'semisync', '', '半同步型', 'new', '0002_0000000002', '0007_0000000002'),
	('0009_0000000025', NULL, '0009_0000000025', 'umadmin', '2020-05-20 11:58:02', 'umadmin', '2020-04-29 11:54:02', 34, '集群版4.0_腾讯云REDIS', NULL, '7', '', '集群版4.0', 'new', '0002_0000000003', '0007_0000000017'),
	('0009_0000000026', NULL, '0009_0000000026', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-29 11:54:02', 34, '主从型4.0_腾讯云REDIS', NULL, '6', '', '主从型4.0', 'new', '0002_0000000003', '0007_0000000009'),
	('0009_0000000027', NULL, '0009_0000000027', 'umadmin', '2020-05-20 14:52:10', 'umadmin', '2020-05-20 14:50:48', 34, '集群型_阿里云REDIS', NULL, 'CLUSTER', '', '集群型', 'new', '0002_0000000003', '0007_0000000018'),
	('0009_0000000028', NULL, '0009_0000000028', 'umadmin', '2020-05-20 14:52:11', 'umadmin', '2020-05-20 14:50:48', 34, '主从型_阿里云REDIS', NULL, 'MASTER_SLAVE', '', '主从型', 'new', '0002_0000000003', '0007_0000000023'),
	('0009_0000000029', NULL, '0009_0000000029', 'umadmin', '2020-05-22 11:01:40', 'umadmin', '2020-05-20 14:50:48', 34, '高可用型_阿里云MYSQL', NULL, 'HighAvailability', '', '高可用型', 'new', '0002_0000000002', '0007_0000000024'),
	('0009_0000000030', NULL, '0009_0000000030', 'umadmin', '2020-05-20 14:50:49', 'umadmin', '2020-05-20 14:50:48', 34, '计算型_阿里云NGINX', NULL, 'c6', '', '计算型', 'new', '0002_0000000011', '0007_0000000025'),
	('0009_0000000031', NULL, '0009_0000000031', 'umadmin', '2020-05-20 14:50:49', 'umadmin', '2020-05-20 14:50:49', 34, '计算型_阿里云OAP', NULL, 'c6', '', '计算型', 'new', '0002_0000000010', '0007_0000000020'),
	('0009_0000000032', NULL, '0009_0000000032', 'umadmin', '2020-05-20 14:50:49', 'umadmin', '2020-05-20 14:50:49', 34, '内存型_阿里云DOCKER', NULL, 'g6', '', '内存型', 'new', '0002_0000000012', '0007_0000000025'),
	('0009_0000000033', NULL, '0009_0000000033', 'umadmin', '2020-05-22 11:01:40', 'umadmin', '2020-05-20 14:50:49', 34, '三节点企业型_阿里云MYSQL', NULL, 'Finance', '', '三节点企业型', 'new', '0002_0000000002', '0007_0000000024'),
	('0009_0000000034', NULL, '0009_0000000034', 'umadmin', '2020-05-20 14:50:49', 'umadmin', '2020-05-20 14:50:49', 34, '内存型_阿里云JAVA', NULL, 'g6', '', '内存型', 'new', '0002_0000000001', '0007_0000000025'),
	('0009_0000000035', NULL, '0009_0000000035', 'umadmin', '2020-05-20 14:50:49', 'umadmin', '2020-05-20 14:50:49', 34, '计算型_阿里云VDI', NULL, 'c6', '', '计算型', 'new', '0002_0000000005', '0007_0000000020'),
	('0009_0000000036', NULL, '0009_0000000036', 'umadmin', '2020-05-20 14:50:50', 'umadmin', '2020-05-20 14:50:49', 34, '计算型_阿里云SQUID', NULL, 'c6', '', '计算型', 'new', '0002_0000000006', '0007_0000000020'),
	('0009_0000000037', NULL, '0009_0000000037', 'umadmin', '2020-05-20 14:50:50', 'umadmin', '2020-05-20 14:50:50', 34, '内网型_阿里云LB', NULL, 'intranet', '', '内网型', 'new', '0002_0000000004', '0007_0000000020'),
	('0009_0000000038', NULL, '0009_0000000038', 'umadmin', '2020-05-20 14:50:50', 'umadmin', '2020-05-20 14:50:50', 34, '外网型_阿里云LB', NULL, 'internet', '', '外网型', 'new', '0002_0000000004', '0007_0000000020');
/*!40000 ALTER TABLE `resource_instance_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_set: ~109 rows (approximately)
/*!40000 ALTER TABLE `resource_set` DISABLE KEYS */;
INSERT INTO `resource_set` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone`, `cluster_type`, `logic_resource_set`, `manage_role`, `resource_type`, `resource_set_design`, `resource_set_type`, `state_code`, `unit_type`, `network_zone`, `init_script_type`, `init_script`) VALUES
	('0029_0000000002', NULL, '0029_0000000002', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:52', 37, '__1E0_OAPP1', NULL, 'OAPP1', '', '0028_0000000005', '', '', '0001_0000000001', 'HOST', '0019_0000000026', 'GROUP', 'created', '0002_0000000010', '', '', ''),
	('0029_0000000003', NULL, '0029_0000000003', 'umadmin', '2020-06-30 15:17:27', 'umadmin', '2020-04-29 00:13:53', 37, '__1Q0_ELB1', NULL, 'ELB1', '', '0028_0000000007', '', '', '0001_0000000001', 'LB', '0019_0000000027', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000004', NULL, '0029_0000000004', 'umadmin', '2020-06-30 15:17:27', 'umadmin', '2020-04-29 00:13:53', 37, '__1Q0_VDI1', NULL, 'VDI1', '', '0028_0000000007', '', '', '0001_0000000001', 'HOST', '0019_0000000028', 'GROUP', 'created', '0002_0000000005', '', '', ''),
	('0029_0000000005', NULL, '0029_0000000005', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:53', 37, '__1E0_JAVA1', NULL, 'JAVA1', '', '0028_0000000005', '', '', '0001_0000000001', 'HOST', '0019_0000000025', 'GROUP', 'created', '0002_0000000001', '', '', ''),
	('0029_0000000006', NULL, '0029_0000000006', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:54', 37, '__1M0_SEC1', NULL, 'SEC1', '', '0028_0000000006', '', '', '0001_0000000001', 'HOST', '0019_0000000022', 'GROUP', 'created', '0002_0000000010', '', '', ''),
	('0029_0000000007', NULL, '0029_0000000007', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:54', 37, '__1M0_SQUID1', NULL, 'SQUID1', '', '0028_0000000006', '', '', '0001_0000000001', 'HOST', '0019_0000000023', 'GROUP', 'created', '0002_0000000006', '', '', ''),
	('0029_0000000008', NULL, '0029_0000000008', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:55', 37, '__1E0_ILB1', NULL, 'ILB1', '', '0028_0000000005', '', '', '0001_0000000001', 'LB', '0019_0000000024', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000009', NULL, '0029_0000000009', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:55', 37, '__1M0_VDI1', NULL, 'VDI1', '', '0028_0000000006', '', '', '0001_0000000001', 'HOST', '0019_0000000021', 'GROUP', 'created', '0002_0000000005', '', '', ''),
	('0029_0000000010', NULL, '0029_0000000010', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:55', 37, '__1M0_DOCKER1', NULL, 'DOCKER1', '', '0028_0000000006', '', '', '0001_0000000001', 'HOST', '0019_0000000019', 'GROUP', 'created', '0002_0000000012', '', '', ''),
	('0029_0000000011', NULL, '0029_0000000011', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:56', 37, '__1M0_ACCESS1', NULL, 'ACCESS1', '', '0028_0000000006', '', '', '0001_0000000001', 'HOST', '0019_0000000020', 'GROUP', 'created', '0002_0000000010', '', '', ''),
	('0029_0000000012', NULL, '0029_0000000012', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:56', 37, '__1D0_ILB1', NULL, 'ILB1', '', '0028_0000000004', '', '', '0001_0000000001', 'LB', '0019_0000000016', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000013', NULL, '0029_0000000013', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:57', 37, '__1M0_ILB1', NULL, 'ILB1', '', '0028_0000000006', '', '', '0001_0000000001', 'LB', '0019_0000000017', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000014', NULL, '0029_0000000014', 'umadmin', '2020-06-30 15:17:28', 'umadmin', '2020-04-29 00:13:57', 37, '__1M0_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000006', '', '', '0001_0000000001', 'RDB', '0019_0000000018', 'GROUP', 'created', '0002_0000000002', '', '', ''),
	('0029_0000000015', NULL, '0029_0000000015', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:57', 37, '__1D0_ELB1', NULL, 'ELB1', '', '0028_0000000004', '', '', '0001_0000000001', 'LB', '0019_0000000014', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000016', NULL, '0029_0000000016', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:58', 37, '__1D0_JAVA1', NULL, 'JAVA1', '', '0028_0000000004', '', '', '0001_0000000001', 'HOST', '0019_0000000015', 'GROUP', 'created', '0002_0000000001', '', '', ''),
	('0029_0000000017', NULL, '0029_0000000017', 'umadmin', '2020-06-30 15:17:31', 'umadmin', '2020-04-29 00:13:58', 37, '__110_ILB1', NULL, 'ILB1', '', '0028_0000000002', '', '', '0001_0000000001', 'LB', '0019_0000000011', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000018', NULL, '0029_0000000018', 'umadmin', '2020-06-30 15:17:29', 'umadmin', '2020-04-29 00:13:59', 37, '__1D0_SQUID1', NULL, 'SQUID1', '', '0028_0000000004', '', '', '0001_0000000001', 'HOST', '0019_0000000012', 'GROUP', 'created', '0002_0000000006', '', '', ''),
	('0029_0000000019', NULL, '0029_0000000019', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:13:59', 37, '__1D0_NGINX1', NULL, 'NGINX1', '', '0028_0000000004', '', '', '0001_0000000001', 'HOST', '0019_0000000013', 'GROUP', 'created', '0002_0000000011', '', '', ''),
	('0029_0000000020', NULL, '0029_0000000020', 'umadmin', '2020-06-30 15:17:31', 'umadmin', '2020-04-29 00:13:59', 37, '__110_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000002', '', '', '0001_0000000001', 'RDB', '0019_0000000008', 'GROUP', 'created', '0002_0000000002', '', '', ''),
	('0029_0000000021', NULL, '0029_0000000021', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:14:00', 37, '__1A0_OAPP1', NULL, 'OAPP1', '', '0028_0000000003', '', '', '0001_0000000001', 'HOST', '0019_0000000005', 'GROUP', 'created', '0002_0000000010', '', '', ''),
	('0029_0000000022', NULL, '0029_0000000022', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:14:00', 37, '__1A0_JAVA1', NULL, 'JAVA1', '', '0028_0000000003', '', '', '0001_0000000001', 'HOST', '0019_0000000006', 'GROUP', 'created', '0002_0000000001', '', '', ''),
	('0029_0000000023', NULL, '0029_0000000023', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:18:24', 37, '__1A0_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000003', '', '', '0001_0000000001', 'RDB', '0019_0000000002', 'GROUP', 'created', '0002_0000000002', '', '', ''),
	('0029_0000000024', NULL, '0029_0000000024', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:18:25', 37, '__1A0_BDP1', NULL, 'BDP1', '', '0028_0000000003', '', '', '0001_0000000001', 'BDP', '0019_0000000004', 'GROUP', 'created', '0002_0000000008', '', '', ''),
	('0029_0000000025', NULL, '0029_0000000025', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:18:25', 37, '__1A0_REDIS1', NULL, 'REDIS1', '', '0028_0000000003', '', '', '0001_0000000001', 'CACHE', '0019_0000000003', 'GROUP', 'created', '0002_0000000003', '', '', ''),
	('0029_0000000026', NULL, '0029_0000000026', 'umadmin', '2020-06-30 15:17:30', 'umadmin', '2020-04-29 00:18:26', 37, '__1A0_ILB1', NULL, 'ILB1', '', '0028_0000000003', '', '', '0001_0000000001', 'LB', '0019_0000000007', 'GROUP', 'created', '0002_0000000004', '', '', ''),
	('0029_0000000027', NULL, '0029_0000000027', 'umadmin', '2020-06-30 15:17:31', 'umadmin', '2020-04-29 00:20:42', 37, '__110_REDIS1', NULL, 'REDIS1', '', '0028_0000000002', '', '', '0001_0000000001', 'CACHE', '0019_0000000009', 'GROUP', 'created', '0002_0000000003', '', '', ''),
	('0029_0000000028', NULL, '0029_0000000028', 'umadmin', '2020-06-30 15:17:31', 'umadmin', '2020-04-29 00:20:43', 37, '__110_JAVA1', NULL, 'JAVA1', '', '0028_0000000002', '', '', '0001_0000000001', 'HOST', '0019_0000000010', 'GROUP', 'created', '0002_0000000001', '', '', ''),
	('0029_0000000029', NULL, '0029_0000000029', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-29 00:35:22', 37, 'TX_GZ_PRD_QZ_1Q1_VDI1', NULL, 'VDI1', '', '0028_0000000016', '0007_0000000007', '0029_0000000004', '0001_0000000001', 'HOST', '0019_0000000028', 'NODE', 'created', '0002_0000000005', '0024_0000000006', '', ''),
	('0029_0000000030', NULL, '0029_0000000030', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-29 00:35:22', 37, 'TX_GZ_PRD_QZ_1Q1_ELB1', NULL, 'ELB1', '', '0028_0000000016', '0007_0000000012', '0029_0000000003', '0001_0000000001', 'LB', '0019_0000000027', 'NODE', 'created', '0002_0000000004', '0024_0000000006', '', ''),
	('0029_0000000031', NULL, '0029_0000000031', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-29 00:35:23', 37, 'TX_GZ_PRD_ECN_1E1_OAPP1', NULL, 'OAPP1', '', '0028_0000000018', '0007_0000000007', '0029_0000000002', '0001_0000000001', 'HOST', '0019_0000000026', 'NODE', 'created', '0002_0000000010', '0024_0000000004', 'USER_PARAM', 'ls -an /'),
	('0029_0000000032', NULL, '0029_0000000032', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-29 00:35:23', 37, 'TX_GZ_PRD_ECN_1E1_JAVA1', NULL, 'JAVA1', '', '0028_0000000018', '0007_0000000007', '0029_0000000005', '0001_0000000001', 'HOST', '0019_0000000025', 'NODE', 'created', '0002_0000000001', '0024_0000000004', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000033', NULL, '0029_0000000033', 'umadmin', '2020-06-30 15:37:26', 'umadmin', '2020-04-29 00:35:24', 37, 'TX_GZ_PRD_ECN_1E1_ILB1', NULL, 'ILB1', '', '0028_0000000018', '0007_0000000012', '0029_0000000008', '0001_0000000001', 'LB', '0019_0000000024', 'NODE', 'created', '0002_0000000004', '0024_0000000004', '', ''),
	('0029_0000000034', NULL, '0029_0000000034', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:24', 37, 'TX_GZ_PRD_MGMT_1M1_SQUID1', NULL, 'SQUID1', '', '0028_0000000014', '0007_0000000012', '0029_0000000007', '0001_0000000001', 'HOST', '0019_0000000023', 'NODE', 'created', '0002_0000000006', '0024_0000000005', 'USER_PARAM', 'sudo yum install squid -y'),
	('0029_0000000035', NULL, '0029_0000000035', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:25', 37, 'TX_GZ_PRD_MGMT_1M1_SEC1', NULL, 'SEC1', '', '0028_0000000014', '0007_0000000012', '0029_0000000006', '0001_0000000001', 'HOST', '0019_0000000022', 'NODE', 'created', '0002_0000000010', '0024_0000000005', '', ''),
	('0029_0000000036', NULL, '0029_0000000036', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:25', 37, 'TX_GZ_PRD_MGMT_1M1_VDI1', NULL, 'VDI1', '', '0028_0000000014', '0007_0000000012', '0029_0000000009', '0001_0000000001', 'HOST', '0019_0000000021', 'NODE', 'created', '0002_0000000005', '0024_0000000005', '', ''),
	('0029_0000000037', NULL, '0029_0000000037', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:26', 37, 'TX_GZ_PRD_MGMT_1M1_ACCESS1', NULL, 'ACCESS1', '', '0028_0000000014', '0007_0000000012', '0029_0000000011', '0001_0000000001', 'HOST', '0019_0000000020', 'NODE', 'created', '0002_0000000010', '0024_0000000005', 'USER_PARAM', 'ls -an /'),
	('0029_0000000038', NULL, '0029_0000000038', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:26', 37, 'TX_GZ_PRD_MGMT_1M1_DOCKER1', NULL, 'DOCKER1', '', '0028_0000000014', '0007_0000000007', '0029_0000000010', '0001_0000000001', 'HOST', '0019_0000000019', 'NODE', 'created', '0002_0000000012', '0024_0000000005', 'USER_PARAM', 'ls -an /'),
	('0029_0000000039', NULL, '0029_0000000039', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:26', 37, 'TX_GZ_PRD_MGMT_1M1_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000014', '0007_0000000008', '0029_0000000014', '0001_0000000001', 'RDB', '0019_0000000018', 'NODE', 'created', '0002_0000000002', '0024_0000000005', '', ''),
	('0029_0000000040', NULL, '0029_0000000040', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:27', 37, 'TX_GZ_PRD_MGMT_1M1_ILB1', NULL, 'ILB1', '', '0028_0000000014', '0007_0000000012', '0029_0000000013', '0001_0000000001', 'LB', '0019_0000000017', 'NODE', 'created', '0002_0000000004', '0024_0000000005', '', ''),
	('0029_0000000041', NULL, '0029_0000000041', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:27', 37, 'TX_GZ_PRD_DMZ_1D1_ILB1', NULL, 'ILB1', '', '0028_0000000012', '0007_0000000012', '0029_0000000012', '0001_0000000001', 'LB', '0019_0000000016', 'NODE', 'created', '0002_0000000004', '0024_0000000003', '', ''),
	('0029_0000000042', NULL, '0029_0000000042', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:28', 37, 'TX_GZ_PRD_DMZ_1D1_JAVA1', NULL, 'JAVA1', '', '0028_0000000012', '0007_0000000007', '0029_0000000016', '0001_0000000001', 'HOST', '0019_0000000015', 'NODE', 'created', '0002_0000000001', '0024_0000000003', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000043', NULL, '0029_0000000043', 'umadmin', '2020-06-30 15:37:27', 'umadmin', '2020-04-29 00:35:28', 37, 'TX_GZ_PRD_DMZ_1D1_ELB1', NULL, 'ELB1', '', '0028_0000000012', '0007_0000000012', '0029_0000000015', '0001_0000000001', 'LB', '0019_0000000014', 'NODE', 'created', '0002_0000000004', '0024_0000000003', '', ''),
	('0029_0000000044', NULL, '0029_0000000044', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:29', 37, 'TX_GZ_PRD_DMZ_1D1_NGINX1', NULL, 'NGINX1', '', '0028_0000000012', '0007_0000000007', '0029_0000000019', '0001_0000000001', 'HOST', '0019_0000000013', 'NODE', 'created', '0002_0000000011', '0024_0000000003', 'USER_PARAM', 'sudo yum install nginx -y && sudo nginx'),
	('0029_0000000045', NULL, '0029_0000000045', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:29', 37, 'TX_GZ_PRD_DMZ_1D1_SQUID1', NULL, 'SQUID1', '', '0028_0000000012', '0007_0000000012', '0029_0000000018', '0001_0000000001', 'HOST', '0019_0000000012', 'NODE', 'created', '0002_0000000006', '0024_0000000003', 'USER_PARAM', 'sudo yum install squid -y'),
	('0029_0000000046', NULL, '0029_0000000046', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:30', 37, 'TX_GZ_PRD_SF_111_ILB1', NULL, 'ILB1', '', '0028_0000000008', '0007_0000000012', '0029_0000000017', '0001_0000000001', 'LB', '0019_0000000011', 'NODE', 'created', '0002_0000000004', '0024_0000000002', '', ''),
	('0029_0000000047', NULL, '0029_0000000047', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:30', 37, 'TX_GZ_PRD_SF_111_JAVA1', NULL, 'JAVA1', '', '0028_0000000008', '0007_0000000007', '0029_0000000028', '0001_0000000001', 'HOST', '0019_0000000010', 'NODE', 'created', '0002_0000000001', '0024_0000000002', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000048', NULL, '0029_0000000048', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:31', 37, 'TX_GZ_PRD_SF_111_REDIS1', NULL, 'REDIS1', '', '0028_0000000008', '0007_0000000009', '0029_0000000027', '0001_0000000001', 'CACHE', '0019_0000000009', 'NODE', 'created', '0002_0000000003', '0024_0000000002', '', ''),
	('0029_0000000049', NULL, '0029_0000000049', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:31', 37, 'TX_GZ_PRD_SF_111_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000008', '0007_0000000008', '0029_0000000020', '0001_0000000001', 'RDB', '0019_0000000008', 'NODE', 'created', '0002_0000000002', '0024_0000000002', '', ''),
	('0029_0000000050', NULL, '0029_0000000050', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:32', 37, 'TX_GZ_PRD_SF_1A1_ILB1', NULL, 'ILB1', '', '0028_0000000010', '0007_0000000012', '0029_0000000026', '0001_0000000001', 'LB', '0019_0000000007', 'NODE', 'created', '0002_0000000004', '0024_0000000002', '', ''),
	('0029_0000000051', NULL, '0029_0000000051', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:32', 37, 'TX_GZ_PRD_SF_1A1_JAVA1', NULL, 'JAVA1', '', '0028_0000000010', '0007_0000000007', '0029_0000000022', '0001_0000000001', 'HOST', '0019_0000000006', 'NODE', 'created', '0002_0000000001', '0024_0000000002', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000052', NULL, '0029_0000000052', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:33', 37, 'TX_GZ_PRD_SF_1A1_OAPP1', NULL, 'OAPP1', '', '0028_0000000010', '0007_0000000007', '0029_0000000021', '0001_0000000001', 'HOST', '0019_0000000005', 'NODE', 'created', '0002_0000000010', '0024_0000000002', 'USER_PARAM', 'ls -an /'),
	('0029_0000000053', NULL, '0029_0000000053', 'umadmin', '2020-06-30 15:37:28', 'umadmin', '2020-04-29 00:35:33', 37, 'TX_GZ_PRD_SF_1A1_BDP1', NULL, 'BDP1', '', '0028_0000000010', '0007_0000000015', '0029_0000000024', '0001_0000000001', 'BDP', '0019_0000000004', 'NODE', 'created', '0002_0000000008', '0024_0000000002', '', ''),
	('0029_0000000054', NULL, '0029_0000000054', 'umadmin', '2020-06-30 15:37:29', 'umadmin', '2020-04-29 00:35:34', 37, 'TX_GZ_PRD_SF_1A1_REDIS1', NULL, 'REDIS1', '', '0028_0000000010', '0007_0000000009', '0029_0000000025', '0001_0000000001', 'CACHE', '0019_0000000003', 'NODE', 'created', '0002_0000000003', '0024_0000000002', '', ''),
	('0029_0000000055', NULL, '0029_0000000055', 'umadmin', '2020-06-30 15:37:29', 'umadmin', '2020-04-29 00:35:34', 37, 'TX_GZ_PRD_SF_1A1_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000010', '0007_0000000008', '0029_0000000023', '0001_0000000001', 'RDB', '0019_0000000002', 'NODE', 'created', '0002_0000000002', '0024_0000000002', '', ''),
	('0029_0000000056', NULL, '0029_0000000056', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:33', 37, 'TX_CD_DR_QZ_1Q2_VDI1', NULL, 'VDI1', '', '0028_0000000017', '0007_0000000007', '0029_0000000004', '0001_0000000001', 'HOST', '0019_0000000028', 'NODE', 'created', '0002_0000000005', '0024_0000000011', '', ''),
	('0029_0000000057', NULL, '0029_0000000057', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:34', 37, 'TX_CD_DR_QZ_1Q2_ELB1', NULL, 'ELB1', '', '0028_0000000017', '0007_0000000012', '0029_0000000003', '0001_0000000001', 'LB', '0019_0000000027', 'NODE', 'created', '0002_0000000004', '0024_0000000011', '', ''),
	('0029_0000000058', NULL, '0029_0000000058', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:34', 37, 'TX_CD_DR_ECN_1E2_OAPP1', NULL, 'OAPP1', '', '0028_0000000019', '0007_0000000007', '0029_0000000002', '0001_0000000001', 'HOST', '0019_0000000026', 'NODE', 'created', '0002_0000000010', '0024_0000000009', 'USER_PARAM', 'ls -an /'),
	('0029_0000000059', NULL, '0029_0000000059', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:35', 37, 'TX_CD_DR_ECN_1E2_JAVA1', NULL, 'JAVA1', '', '0028_0000000019', '0007_0000000007', '0029_0000000005', '0001_0000000001', 'HOST', '0019_0000000025', 'NODE', 'created', '0002_0000000001', '0024_0000000009', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000060', NULL, '0029_0000000060', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:35', 37, 'TX_CD_DR_ECN_1E2_ILB1', NULL, 'ILB1', '', '0028_0000000019', '0007_0000000012', '0029_0000000008', '0001_0000000001', 'LB', '0019_0000000024', 'NODE', 'created', '0002_0000000004', '0024_0000000009', '', ''),
	('0029_0000000061', NULL, '0029_0000000061', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:36', 37, 'TX_CD_DR_MGMT_1M2_SQUID1', NULL, 'SQUID1', '', '0028_0000000015', '0007_0000000012', '0029_0000000007', '0001_0000000001', 'HOST', '0019_0000000023', 'NODE', 'created', '0002_0000000006', '0024_0000000010', 'USER_PARAM', 'sudo yum install squid -y'),
	('0029_0000000062', NULL, '0029_0000000062', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:36', 37, 'TX_CD_DR_MGMT_1M2_SEC1', NULL, 'SEC1', '', '0028_0000000015', '0007_0000000012', '0029_0000000006', '0001_0000000001', 'HOST', '0019_0000000022', 'NODE', 'created', '0002_0000000010', '0024_0000000010', '', ''),
	('0029_0000000063', NULL, '0029_0000000063', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:37', 37, 'TX_CD_DR_MGMT_1M2_VDI1', NULL, 'VDI1', '', '0028_0000000015', '0007_0000000012', '0029_0000000009', '0001_0000000001', 'HOST', '0019_0000000021', 'NODE', 'created', '0002_0000000005', '0024_0000000010', '', ''),
	('0029_0000000064', NULL, '0029_0000000064', 'umadmin', '2020-06-30 15:37:22', 'umadmin', '2020-04-29 00:46:37', 37, 'TX_CD_DR_MGMT_1M2_ACCESS1', NULL, 'ACCESS1', '', '0028_0000000015', '0007_0000000012', '0029_0000000011', '0001_0000000001', 'HOST', '0019_0000000020', 'NODE', 'created', '0002_0000000010', '0024_0000000010', 'USER_PARAM', 'ls -an /'),
	('0029_0000000065', NULL, '0029_0000000065', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:37', 37, 'TX_CD_DR_MGMT_1M2_DOCKER1', NULL, 'DOCKER1', '', '0028_0000000015', '0007_0000000007', '0029_0000000010', '0001_0000000001', 'HOST', '0019_0000000019', 'NODE', 'created', '0002_0000000012', '0024_0000000010', 'USER_PARAM', 'ls -an /'),
	('0029_0000000066', NULL, '0029_0000000066', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:38', 37, 'TX_CD_DR_MGMT_1M2_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000015', '0007_0000000008', '0029_0000000014', '0001_0000000001', 'RDB', '0019_0000000018', 'NODE', 'created', '0002_0000000002', '0024_0000000010', '', ''),
	('0029_0000000067', NULL, '0029_0000000067', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:38', 37, 'TX_CD_DR_MGMT_1M2_ILB1', NULL, 'ILB1', '', '0028_0000000015', '0007_0000000012', '0029_0000000013', '0001_0000000001', 'LB', '0019_0000000017', 'NODE', 'created', '0002_0000000004', '0024_0000000010', '', ''),
	('0029_0000000068', NULL, '0029_0000000068', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:39', 37, 'TX_CD_DR_DMZ_1D2_ILB1', NULL, 'ILB1', '', '0028_0000000013', '0007_0000000012', '0029_0000000012', '0001_0000000001', 'LB', '0019_0000000016', 'NODE', 'created', '0002_0000000004', '0024_0000000008', '', ''),
	('0029_0000000069', NULL, '0029_0000000069', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:39', 37, 'TX_CD_DR_DMZ_1D2_JAVA1', NULL, 'JAVA1', '', '0028_0000000013', '0007_0000000007', '0029_0000000016', '0001_0000000001', 'HOST', '0019_0000000015', 'NODE', 'created', '0002_0000000001', '0024_0000000008', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000070', NULL, '0029_0000000070', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:40', 37, 'TX_CD_DR_DMZ_1D2_ELB1', NULL, 'ELB1', '', '0028_0000000013', '0007_0000000012', '0029_0000000015', '0001_0000000001', 'LB', '0019_0000000014', 'NODE', 'created', '0002_0000000004', '0024_0000000008', '', ''),
	('0029_0000000071', NULL, '0029_0000000071', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:40', 37, 'TX_CD_DR_DMZ_1D2_NGINX1', NULL, 'NGINX1', '', '0028_0000000013', '0007_0000000007', '0029_0000000019', '0001_0000000001', 'HOST', '0019_0000000013', 'NODE', 'created', '0002_0000000011', '0024_0000000008', 'USER_PARAM', 'sudo yum install nginx -y && sudo nginx'),
	('0029_0000000072', NULL, '0029_0000000072', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:41', 37, 'TX_CD_DR_DMZ_1D2_SQUID1', NULL, 'SQUID1', '', '0028_0000000013', '0007_0000000012', '0029_0000000018', '0001_0000000001', 'HOST', '0019_0000000012', 'NODE', 'created', '0002_0000000006', '0024_0000000008', 'USER_PARAM', 'sudo yum install squid -y'),
	('0029_0000000073', NULL, '0029_0000000073', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:41', 37, 'TX_CD_DR_SF_112_ILB1', NULL, 'ILB1', '', '0028_0000000009', '0007_0000000012', '0029_0000000017', '0001_0000000001', 'LB', '0019_0000000011', 'NODE', 'created', '0002_0000000004', '0024_0000000007', '', ''),
	('0029_0000000074', NULL, '0029_0000000074', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:42', 37, 'TX_CD_DR_SF_112_JAVA1', NULL, 'JAVA1', '', '0028_0000000009', '0007_0000000007', '0029_0000000028', '0001_0000000001', 'HOST', '0019_0000000010', 'NODE', 'created', '0002_0000000001', '0024_0000000007', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000075', NULL, '0029_0000000075', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:42', 37, 'TX_CD_DR_SF_112_REDIS1', NULL, 'REDIS1', '', '0028_0000000009', '0007_0000000009', '0029_0000000027', '0001_0000000001', 'CACHE', '0019_0000000009', 'NODE', 'created', '0002_0000000003', '0024_0000000007', '', ''),
	('0029_0000000076', NULL, '0029_0000000076', 'umadmin', '2020-06-30 15:37:23', 'umadmin', '2020-04-29 00:46:43', 37, 'TX_CD_DR_SF_112_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000009', '0007_0000000008', '0029_0000000020', '0001_0000000001', 'RDB', '0019_0000000008', 'NODE', 'created', '0002_0000000002', '0024_0000000007', '', ''),
	('0029_0000000077', NULL, '0029_0000000077', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-29 00:46:43', 37, 'TX_CD_DR_SF_1A2_ILB1', NULL, 'ILB1', '', '0028_0000000011', '0007_0000000012', '0029_0000000026', '0001_0000000001', 'LB', '0019_0000000007', 'NODE', 'created', '0002_0000000004', '0024_0000000007', '', ''),
	('0029_0000000078', NULL, '0029_0000000078', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-29 00:46:44', 37, 'TX_CD_DR_SF_1A2_JAVA1', NULL, 'JAVA1', '', '0028_0000000011', '0007_0000000007', '0029_0000000022', '0001_0000000001', 'HOST', '0019_0000000006', 'NODE', 'created', '0002_0000000001', '0024_0000000007', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000079', NULL, '0029_0000000079', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-29 00:46:44', 37, 'TX_CD_DR_SF_1A2_OAPP1', NULL, 'OAPP1', '', '0028_0000000011', '0007_0000000007', '0029_0000000021', '0001_0000000001', 'HOST', '0019_0000000005', 'NODE', 'created', '0002_0000000010', '0024_0000000007', 'USER_PARAM', 'ls -an /'),
	('0029_0000000080', NULL, '0029_0000000080', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-29 00:46:45', 37, 'TX_CD_DR_SF_1A2_BDP1', NULL, 'BDP1', '', '0028_0000000011', '0007_0000000015', '0029_0000000024', '0001_0000000001', 'BDP', '0019_0000000004', 'NODE', 'created', '0002_0000000008', '0024_0000000007', '', ''),
	('0029_0000000081', NULL, '0029_0000000081', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-29 00:46:45', 37, 'TX_CD_DR_SF_1A2_REDIS1', NULL, 'REDIS1', '', '0028_0000000011', '0007_0000000009', '0029_0000000025', '0001_0000000001', 'CACHE', '0019_0000000003', 'NODE', 'created', '0002_0000000003', '0024_0000000007', '', ''),
	('0029_0000000082', NULL, '0029_0000000082', 'umadmin', '2020-06-30 15:37:24', 'umadmin', '2020-04-29 00:46:46', 37, 'TX_CD_DR_SF_1A2_MYSQL1', NULL, 'MYSQL1', '', '0028_0000000011', '0007_0000000008', '0029_0000000023', '0001_0000000001', 'RDB', '0019_0000000002', 'NODE', 'created', '0002_0000000002', '0024_0000000007', '', ''),
	('0029_0000000101', NULL, '0029_0000000101', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:42:55', 37, 'ALI_HZ_PRD_SF__MYSQL1', NULL, 'MYSQL1', '', '', '0007_0000000024', '', '0001_0000000001', 'RDB', '0019_0000000034', 'NODE', 'created', '0002_0000000002', '0024_0000000016', '', ''),
	('0029_0000000102', NULL, '0029_0000000102', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:42:56', 37, 'ALI_HZ_PRD_SF__REDIS1', NULL, 'REDIS1', '', '', '0007_0000000023', '', '0001_0000000001', 'CACHE', '0019_0000000035', 'NODE', 'created', '0002_0000000003', '0024_0000000016', '', ''),
	('0029_0000000103', NULL, '0029_0000000103', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:42:56', 37, 'ALI_HZ_PRD_SF__JAVA1', NULL, 'JAVA1', '', '', '0007_0000000025', '', '0001_0000000001', 'HOST', '0019_0000000037', 'NODE', 'created', '0002_0000000001', '0024_0000000016', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000104', NULL, '0029_0000000104', 'umadmin', '2020-05-22 10:48:26', 'umadmin', '2020-05-20 12:42:57', 37, 'ALI_HZ_PRD_SF__ILB1', NULL, 'ILB1', '', '', '0007_0000000020', '', '0001_0000000001', 'LB', '0019_0000000036', 'NODE', 'created', '0002_0000000004', '0024_0000000016', '', ''),
	('0029_0000000105', NULL, '0029_0000000105', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:42:57', 37, 'ALI_HZ_PRD_SF__BDP1', NULL, 'BDP1', '', '', '0007_0000000019', '', '0001_0000000001', 'BDP', '0019_0000000045', 'NODE', 'created', '0002_0000000008', '0024_0000000016', '', ''),
	('0029_0000000106', NULL, '0029_0000000106', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:42:58', 37, 'ALI_HZ_PRD_MGMT__DOCKER1', NULL, 'DOCKER1', '', '', '0007_0000000025', '', '0001_0000000001', 'HOST', '0019_0000000044', 'NODE', 'created', '0002_0000000012', '0024_0000000018', 'USER_PARAM', 'ls -an /'),
	('0029_0000000107', NULL, '0029_0000000107', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:45:48', 37, 'ALI_HZ_PRD_MGMT__MYSQL1', NULL, 'MYSQL1', '', '', '0007_0000000024', '', '0001_0000000001', 'RDB', '0019_0000000043', 'NODE', 'created', '0002_0000000002', '0024_0000000018', '', ''),
	('0029_0000000113', NULL, '0029_0000000113', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:53:40', 37, 'ALI_HZ_PRD_DMZ__NGINX1', NULL, 'NGINX1', '', '', '0007_0000000025', '', '0001_0000000001', 'HOST', '0019_0000000039', 'NODE', 'created', '0002_0000000011', '0024_0000000017', 'USER_PARAM', 'sudo yum install nginx -y && sudo nginx'),
	('0029_0000000114', NULL, '0029_0000000114', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:53:40', 37, 'ALI_HZ_PRD_DMZ__JAVA1', NULL, 'JAVA1', '', '', '0007_0000000025', '', '0001_0000000001', 'HOST', '0019_0000000040', 'NODE', 'created', '0002_0000000001', '0024_0000000017', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000115', NULL, '0029_0000000115', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:53:41', 37, 'ALI_HZ_PRD_DMZ__ILB1', NULL, 'ILB1', '', '', '0007_0000000020', '', '0001_0000000001', 'LB', '0019_0000000042', 'NODE', 'created', '0002_0000000004', '0024_0000000017', '', ''),
	('0029_0000000116', NULL, '0029_0000000116', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:53:41', 37, 'ALI_HZ_PRD_DMZ__ELB1', NULL, 'ELB1', '', '', '0007_0000000020', '', '0001_0000000001', 'LB', '0019_0000000041', 'NODE', 'created', '0002_0000000004', '0024_0000000017', '', ''),
	('0029_0000000117', NULL, '0029_0000000117', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 12:53:42', 37, 'ALI_HZ_PRD_DMZ__SQUID1', NULL, 'SQUID1', '', '', '0007_0000000020', '', '0001_0000000001', 'HOST', '0019_0000000038', 'NODE', 'created', '0002_0000000006', '0024_0000000017', 'USER_PARAM', 'sudo yum install squid -y'),
	('0029_0000000120', NULL, '0029_0000000120', 'umadmin', '2020-05-22 10:48:27', 'umadmin', '2020-05-20 16:36:38', 37, 'ALI_HZ_PRD_WAN__BROWER', NULL, 'BROWER', '', '', '0007_0000000020', '', '0001_0000000001', 'HOST', '0019_0000000046', 'NODE', 'created', '0002_0000000009', '0024_0000000020', '', ''),
	('0029_0000000122', NULL, '0029_0000000122', 'umadmin', '2020-05-22 18:39:00', 'umadmin', '2020-05-22 18:38:49', 37, 'ALI_HZ_PRD_TON__BROWER', NULL, 'BROWER', '', '', '0007_0000000020', '', '0001_0000000001', 'HOST', '0019_0000000048', 'NODE', 'created', '0002_0000000009', '0024_0000000019', '', ''),
	('0029_0000000123', NULL, '0029_0000000123', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:12', 37, 'TX_BJ_PRD_TON__BROWER', NULL, 'BROWER', '', '', '0007_0000000012', '', '0001_0000000001', 'HOST', '0019_0000000048', 'NODE', 'created', '0002_0000000009', '0024_0000000021', '', ''),
	('0029_0000000124', NULL, '0029_0000000124', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:12', 37, 'TX_BJ_PRD_WAN__BROWER', NULL, 'BROWER', '', '', '0007_0000000012', '', '0001_0000000001', 'HOST', '0019_0000000046', 'NODE', 'created', '0002_0000000009', '0024_0000000022', '', ''),
	('0029_0000000125', NULL, '0029_0000000125', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:12', 37, 'TX_BJ_PRD_DMZ__SQUID1', NULL, 'SQUID1', '', '', '0007_0000000012', '', '0001_0000000001', 'HOST', '0019_0000000038', 'NODE', 'created', '0002_0000000006', '0024_0000000024', 'USER_PARAM', 'sudo yum install squid -y'),
	('0029_0000000126', NULL, '0029_0000000126', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:13', 37, 'TX_BJ_PRD_DMZ__ILB1', NULL, 'ILB1', '', '', '0007_0000000012', '', '0001_0000000001', 'LB', '0019_0000000042', 'NODE', 'created', '0002_0000000004', '0024_0000000024', '', ''),
	('0029_0000000127', NULL, '0029_0000000127', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:13', 37, 'TX_BJ_PRD_DMZ__ELB1', NULL, 'ELB1', '', '', '0007_0000000012', '', '0001_0000000001', 'LB', '0019_0000000041', 'NODE', 'created', '0002_0000000004', '0024_0000000024', '', ''),
	('0029_0000000128', NULL, '0029_0000000128', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:14', 37, 'TX_BJ_PRD_DMZ__NGINX1', NULL, 'NGINX1', '', '', '0007_0000000007', '', '0001_0000000001', 'HOST', '0019_0000000039', 'NODE', 'created', '0002_0000000011', '0024_0000000024', 'USER_PARAM', 'sudo yum install nginx -y && sudo nginx'),
	('0029_0000000129', NULL, '0029_0000000129', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:14', 37, 'TX_BJ_PRD_DMZ__JAVA1', NULL, 'JAVA1', '', '', '0007_0000000007', '', '0001_0000000001', 'HOST', '0019_0000000040', 'NODE', 'created', '0002_0000000001', '0024_0000000024', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000130', NULL, '0029_0000000130', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:15', 37, 'TX_BJ_PRD_MGMT__MYSQL1', NULL, 'MYSQL1', '', '', '0007_0000000008', '', '0001_0000000001', 'RDB', '0019_0000000043', 'NODE', 'created', '0002_0000000002', '0024_0000000025', '', ''),
	('0029_0000000131', NULL, '0029_0000000131', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:15', 37, 'TX_BJ_PRD_MGMT__DOCKER1', NULL, 'DOCKER1', '', '', '0007_0000000007', '', '0001_0000000001', 'HOST', '0019_0000000044', 'NODE', 'created', '0002_0000000012', '0024_0000000025', 'USER_PARAM', 'ls -an /'),
	('0029_0000000132', NULL, '0029_0000000132', 'umadmin', '2020-05-23 13:20:36', 'umadmin', '2020-05-22 19:28:16', 37, 'TX_BJ_PRD_SF__ILB1', NULL, 'ILB1', '', '', '0007_0000000012', '', '0001_0000000001', 'LB', '0019_0000000036', 'NODE', 'created', '0002_0000000004', '0024_0000000023', '', ''),
	('0029_0000000133', NULL, '0029_0000000133', 'umadmin', '2020-05-23 13:20:37', 'umadmin', '2020-05-22 19:31:50', 37, 'TX_BJ_PRD_SF__BDP1', NULL, 'BDP1', '', '', '0007_0000000015', '', '0001_0000000001', 'BDP', '0019_0000000045', 'NODE', 'created', '0002_0000000008', '0024_0000000023', '', ''),
	('0029_0000000134', NULL, '0029_0000000134', 'umadmin', '2020-05-23 13:20:37', 'umadmin', '2020-05-22 19:31:51', 37, 'TX_BJ_PRD_SF__REDIS1', NULL, 'REDIS1', '', '', '0007_0000000009', '', '0001_0000000001', 'CACHE', '0019_0000000035', 'NODE', 'created', '0002_0000000003', '0024_0000000023', '', ''),
	('0029_0000000135', NULL, '0029_0000000135', 'umadmin', '2020-05-23 13:20:37', 'umadmin', '2020-05-22 19:31:51', 37, 'TX_BJ_PRD_SF__JAVA1', NULL, 'JAVA1', '', '', '0007_0000000007', '', '0001_0000000001', 'HOST', '0019_0000000037', 'NODE', 'created', '0002_0000000001', '0024_0000000023', 'USER_PARAM', 'sudo yum install -y java-1.8.0-openjdk'),
	('0029_0000000136', NULL, '0029_0000000136', 'umadmin', '2020-05-23 13:20:37', 'umadmin', '2020-05-22 19:31:52', 37, 'TX_BJ_PRD_SF__MYSQL1', NULL, 'MYSQL1', '', '', '0007_0000000008', '', '0001_0000000001', 'RDB', '0019_0000000034', 'NODE', 'created', '0002_0000000002', '0024_0000000023', '', '');
/*!40000 ALTER TABLE `resource_set` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_set$deploy_environment: ~81 rows (approximately)
/*!40000 ALTER TABLE `resource_set$deploy_environment` DISABLE KEYS */;
INSERT INTO `resource_set$deploy_environment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(94, '0029_0000000102', '0003_0000000001', 1),
	(95, '0029_0000000103', '0003_0000000001', 1),
	(96, '0029_0000000104', '0003_0000000001', 1),
	(97, '0029_0000000105', '0003_0000000001', 1),
	(98, '0029_0000000106', '0003_0000000001', 1),
	(99, '0029_0000000101', '0003_0000000001', 1),
	(100, '0029_0000000113', '0003_0000000001', 1),
	(101, '0029_0000000114', '0003_0000000001', 1),
	(102, '0029_0000000115', '0003_0000000001', 1),
	(103, '0029_0000000116', '0003_0000000001', 1),
	(104, '0029_0000000117', '0003_0000000001', 1),
	(106, '0029_0000000120', '0003_0000000001', 1),
	(108, '0029_0000000122', '0003_0000000001', 1),
	(109, '0029_0000000132', '0003_0000000001', 1),
	(110, '0029_0000000130', '0003_0000000001', 1),
	(111, '0029_0000000131', '0003_0000000001', 1),
	(112, '0029_0000000128', '0003_0000000001', 1),
	(113, '0029_0000000129', '0003_0000000001', 1),
	(114, '0029_0000000126', '0003_0000000001', 1),
	(115, '0029_0000000127', '0003_0000000001', 1),
	(116, '0029_0000000123', '0003_0000000001', 1),
	(117, '0029_0000000124', '0003_0000000001', 1),
	(118, '0029_0000000125', '0003_0000000001', 1),
	(119, '0029_0000000133', '0003_0000000001', 1),
	(120, '0029_0000000134', '0003_0000000001', 1),
	(121, '0029_0000000135', '0003_0000000001', 1),
	(122, '0029_0000000136', '0003_0000000001', 1),
	(123, '0029_0000000029', '0003_0000000001', 1),
	(124, '0029_0000000030', '0003_0000000001', 1),
	(125, '0029_0000000041', '0003_0000000001', 1),
	(126, '0029_0000000037', '0003_0000000001', 1),
	(127, '0029_0000000038', '0003_0000000001', 1),
	(128, '0029_0000000039', '0003_0000000001', 1),
	(129, '0029_0000000035', '0003_0000000001', 1),
	(130, '0029_0000000036', '0003_0000000001', 1),
	(131, '0029_0000000033', '0003_0000000001', 1),
	(132, '0029_0000000034', '0003_0000000001', 1),
	(133, '0029_0000000031', '0003_0000000001', 1),
	(134, '0029_0000000051', '0003_0000000001', 1),
	(135, '0029_0000000048', '0003_0000000001', 1),
	(136, '0029_0000000049', '0003_0000000001', 1),
	(137, '0029_0000000046', '0003_0000000001', 1),
	(138, '0029_0000000047', '0003_0000000001', 1),
	(139, '0029_0000000044', '0003_0000000001', 1),
	(140, '0029_0000000045', '0003_0000000001', 1),
	(141, '0029_0000000042', '0003_0000000001', 1),
	(142, '0029_0000000043', '0003_0000000001', 1),
	(143, '0029_0000000040', '0003_0000000001', 1),
	(145, '0029_0000000060', '0003_0000000002', 1),
	(146, '0029_0000000057', '0003_0000000002', 1),
	(147, '0029_0000000058', '0003_0000000002', 1),
	(148, '0029_0000000056', '0003_0000000002', 1),
	(149, '0029_0000000054', '0003_0000000001', 1),
	(150, '0029_0000000055', '0003_0000000001', 1),
	(151, '0029_0000000052', '0003_0000000001', 1),
	(152, '0029_0000000053', '0003_0000000001', 1),
	(153, '0029_0000000050', '0003_0000000001', 1),
	(154, '0029_0000000071', '0003_0000000002', 1),
	(155, '0029_0000000068', '0003_0000000002', 1),
	(156, '0029_0000000069', '0003_0000000002', 1),
	(157, '0029_0000000066', '0003_0000000002', 1),
	(158, '0029_0000000067', '0003_0000000002', 1),
	(159, '0029_0000000063', '0003_0000000002', 1),
	(160, '0029_0000000064', '0003_0000000002', 1),
	(161, '0029_0000000065', '0003_0000000002', 1),
	(162, '0029_0000000061', '0003_0000000002', 1),
	(163, '0029_0000000062', '0003_0000000002', 1),
	(164, '0029_0000000081', '0003_0000000002', 1),
	(165, '0029_0000000078', '0003_0000000002', 1),
	(166, '0029_0000000079', '0003_0000000002', 1),
	(167, '0029_0000000076', '0003_0000000002', 1),
	(168, '0029_0000000077', '0003_0000000002', 1),
	(169, '0029_0000000074', '0003_0000000002', 1),
	(170, '0029_0000000075', '0003_0000000002', 1),
	(171, '0029_0000000072', '0003_0000000002', 1),
	(172, '0029_0000000073', '0003_0000000002', 1),
	(173, '0029_0000000070', '0003_0000000002', 1),
	(174, '0029_0000000082', '0003_0000000002', 1),
	(175, '0029_0000000080', '0003_0000000002', 1),
	(176, '0029_0000000032', '0003_0000000001', 1),
	(177, '0029_0000000059', '0003_0000000002', 1);
/*!40000 ALTER TABLE `resource_set$deploy_environment` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_set$network_segment: ~129 rows (approximately)
/*!40000 ALTER TABLE `resource_set$network_segment` DISABLE KEYS */;
INSERT INTO `resource_set$network_segment` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(219, '0029_0000000102', '0023_0000000067', 2),
	(220, '0029_0000000102', '0023_0000000066', 1),
	(221, '0029_0000000103', '0023_0000000070', 1),
	(222, '0029_0000000103', '0023_0000000071', 2),
	(223, '0029_0000000104', '0023_0000000070', 2),
	(224, '0029_0000000104', '0023_0000000071', 1),
	(225, '0029_0000000105', '0023_0000000068', 1),
	(226, '0029_0000000105', '0023_0000000069', 2),
	(227, '0029_0000000106', '0023_0000000073', 1),
	(228, '0029_0000000106', '0023_0000000072', 2),
	(229, '0029_0000000101', '0023_0000000067', 2),
	(230, '0029_0000000101', '0023_0000000066', 1),
	(231, '0029_0000000107', '0023_0000000074', 2),
	(232, '0029_0000000107', '0023_0000000075', 1),
	(233, '0029_0000000113', '0023_0000000083', 1),
	(234, '0029_0000000113', '0023_0000000084', 2),
	(235, '0029_0000000114', '0023_0000000083', 1),
	(236, '0029_0000000114', '0023_0000000084', 2),
	(237, '0029_0000000115', '0023_0000000083', 1),
	(238, '0029_0000000115', '0023_0000000084', 2),
	(239, '0029_0000000116', '0023_0000000080', 1),
	(240, '0029_0000000117', '0023_0000000078', 1),
	(241, '0029_0000000117', '0023_0000000079', 2),
	(243, '0029_0000000120', '0023_0000000085', 1),
	(245, '0029_0000000122', '0023_0000000086', 1),
	(280, '0029_0000000132', '0023_0000000107', 2),
	(281, '0029_0000000132', '0023_0000000100', 1),
	(282, '0029_0000000130', '0023_0000000106', 2),
	(283, '0029_0000000130', '0023_0000000098', 1),
	(284, '0029_0000000131', '0023_0000000099', 1),
	(285, '0029_0000000131', '0023_0000000105', 2),
	(286, '0029_0000000128', '0023_0000000103', 2),
	(287, '0029_0000000128', '0023_0000000096', 1),
	(288, '0029_0000000129', '0023_0000000103', 2),
	(289, '0029_0000000129', '0023_0000000096', 1),
	(290, '0029_0000000126', '0023_0000000103', 2),
	(291, '0029_0000000126', '0023_0000000096', 1),
	(292, '0029_0000000127', '0023_0000000091', 1),
	(293, '0029_0000000123', '0023_0000000094', 1),
	(294, '0029_0000000124', '0023_0000000095', 1),
	(295, '0029_0000000125', '0023_0000000097', 1),
	(296, '0029_0000000125', '0023_0000000104', 2),
	(297, '0029_0000000133', '0023_0000000101', 1),
	(298, '0029_0000000133', '0023_0000000108', 2),
	(299, '0029_0000000134', '0023_0000000102', 1),
	(300, '0029_0000000134', '0023_0000000109', 2),
	(301, '0029_0000000135', '0023_0000000100', 1),
	(302, '0029_0000000135', '0023_0000000107', 2),
	(303, '0029_0000000136', '0023_0000000102', 1),
	(304, '0029_0000000136', '0023_0000000109', 2),
	(305, '0029_0000000029', '0023_0000000027', 2),
	(306, '0029_0000000029', '0023_0000000026', 1),
	(307, '0029_0000000030', '0023_0000000029', 1),
	(308, '0029_0000000041', '0023_0000000011', 2),
	(309, '0029_0000000041', '0023_0000000010', 1),
	(310, '0029_0000000037', '0023_0000000021', 2),
	(311, '0029_0000000037', '0023_0000000020', 1),
	(312, '0029_0000000038', '0023_0000000021', 2),
	(313, '0029_0000000038', '0023_0000000020', 1),
	(314, '0029_0000000039', '0023_0000000023', 2),
	(315, '0029_0000000039', '0023_0000000022', 1),
	(316, '0029_0000000035', '0023_0000000016', 1),
	(317, '0029_0000000035', '0023_0000000017', 2),
	(318, '0029_0000000036', '0023_0000000019', 2),
	(319, '0029_0000000036', '0023_0000000018', 1),
	(320, '0029_0000000033', '0023_0000000015', 2),
	(321, '0029_0000000033', '0023_0000000014', 1),
	(322, '0029_0000000034', '0023_0000000024', 1),
	(323, '0029_0000000034', '0023_0000000025', 2),
	(324, '0029_0000000031', '0023_0000000015', 2),
	(325, '0029_0000000031', '0023_0000000014', 1),
	(326, '0029_0000000051', '0023_0000000008', 1),
	(327, '0029_0000000051', '0023_0000000009', 2),
	(328, '0029_0000000048', '0023_0000000057', 2),
	(329, '0029_0000000048', '0023_0000000056', 1),
	(330, '0029_0000000049', '0023_0000000057', 2),
	(331, '0029_0000000049', '0023_0000000056', 1),
	(332, '0029_0000000046', '0023_0000000008', 1),
	(333, '0029_0000000046', '0023_0000000009', 2),
	(334, '0029_0000000047', '0023_0000000008', 1),
	(335, '0029_0000000047', '0023_0000000009', 2),
	(336, '0029_0000000044', '0023_0000000010', 1),
	(337, '0029_0000000044', '0023_0000000011', 2),
	(338, '0029_0000000045', '0023_0000000012', 1),
	(339, '0029_0000000045', '0023_0000000013', 2),
	(340, '0029_0000000042', '0023_0000000010', 1),
	(341, '0029_0000000042', '0023_0000000011', 2),
	(342, '0029_0000000043', '0023_0000000028', 1),
	(343, '0029_0000000040', '0023_0000000020', 1),
	(344, '0029_0000000040', '0023_0000000021', 2),
	(346, '0029_0000000060', '0023_0000000052', 1),
	(347, '0029_0000000057', '0023_0000000045', 1),
	(348, '0029_0000000058', '0023_0000000052', 1),
	(349, '0029_0000000056', '0023_0000000046', 1),
	(350, '0029_0000000054', '0023_0000000057', 2),
	(351, '0029_0000000054', '0023_0000000056', 1),
	(352, '0029_0000000055', '0023_0000000057', 2),
	(353, '0029_0000000055', '0023_0000000056', 1),
	(354, '0029_0000000052', '0023_0000000009', 2),
	(355, '0029_0000000052', '0023_0000000008', 1),
	(356, '0029_0000000053', '0023_0000000059', 2),
	(357, '0029_0000000053', '0023_0000000058', 1),
	(358, '0029_0000000050', '0023_0000000009', 2),
	(359, '0029_0000000050', '0023_0000000008', 1),
	(360, '0029_0000000071', '0023_0000000054', 1),
	(361, '0029_0000000068', '0023_0000000054', 1),
	(362, '0029_0000000069', '0023_0000000054', 1),
	(363, '0029_0000000066', '0023_0000000048', 1),
	(364, '0029_0000000067', '0023_0000000049', 1),
	(365, '0029_0000000063', '0023_0000000050', 1),
	(366, '0029_0000000064', '0023_0000000049', 1),
	(367, '0029_0000000065', '0023_0000000049', 1),
	(368, '0029_0000000061', '0023_0000000047', 1),
	(369, '0029_0000000062', '0023_0000000051', 1),
	(370, '0029_0000000081', '0023_0000000061', 1),
	(371, '0029_0000000078', '0023_0000000055', 1),
	(372, '0029_0000000079', '0023_0000000055', 1),
	(373, '0029_0000000076', '0023_0000000061', 1),
	(374, '0029_0000000077', '0023_0000000055', 1),
	(375, '0029_0000000074', '0023_0000000055', 1),
	(376, '0029_0000000075', '0023_0000000061', 1),
	(377, '0029_0000000072', '0023_0000000053', 1),
	(378, '0029_0000000073', '0023_0000000055', 1),
	(379, '0029_0000000070', '0023_0000000044', 1),
	(380, '0029_0000000082', '0023_0000000061', 1),
	(381, '0029_0000000080', '0023_0000000060', 1),
	(382, '0029_0000000032', '0023_0000000014', 1),
	(383, '0029_0000000032', '0023_0000000015', 2),
	(384, '0029_0000000059', '0023_0000000052', 1);
/*!40000 ALTER TABLE `resource_set$network_segment` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_set_design: ~47 rows (approximately)
/*!40000 ALTER TABLE `resource_set_design` DISABLE KEYS */;
INSERT INTO `resource_set_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `business_zone_design`, `network_segment_design`, `state_code`, `unit_type`, `network_zone_design`) VALUES
	('0019_0000000002', NULL, '0019_0000000002', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:05', 34, 'PCD_SF_ADM_MYSQL', NULL, 'MYSQL', '', '0018_0000000002', '0013_0000000012', 'new', '0002_0000000002', '0014_0000000002'),
	('0019_0000000003', NULL, '0019_0000000003', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:06', 34, 'PCD_SF_ADM_REDIS', NULL, 'REDIS', '', '0018_0000000002', '0013_0000000012', 'new', '0002_0000000003', '0014_0000000002'),
	('0019_0000000004', NULL, '0019_0000000004', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:06', 34, 'PCD_SF_ADM_BDP', NULL, 'BDP', '', '0018_0000000002', '0013_0000000013', 'new', '0002_0000000008', '0014_0000000002'),
	('0019_0000000005', NULL, '0019_0000000005', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:07', 34, 'PCD_SF_ADM_OAPP', NULL, 'OAPP', '', '0018_0000000002', '0013_0000000014', 'new', '0002_0000000010', '0014_0000000002'),
	('0019_0000000006', NULL, '0019_0000000006', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:07', 34, 'PCD_SF_ADM_JAVA', NULL, 'JAVA', '', '0018_0000000002', '0013_0000000014', 'new', '0002_0000000001', '0014_0000000002'),
	('0019_0000000007', NULL, '0019_0000000007', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:07', 34, 'PCD_SF_ADM_ILB', NULL, 'ILB', '', '0018_0000000002', '0013_0000000014', 'new', '0002_0000000004', '0014_0000000002'),
	('0019_0000000008', NULL, '0019_0000000008', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:08', 34, 'PCD_SF_DCN_MYSQL', NULL, 'MYSQL', '', '0018_0000000003', '0013_0000000012', 'new', '0002_0000000002', '0014_0000000002'),
	('0019_0000000009', NULL, '0019_0000000009', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:08', 34, 'PCD_SF_DCN_REDIS', NULL, 'REDIS', '', '0018_0000000003', '0013_0000000012', 'new', '0002_0000000003', '0014_0000000002'),
	('0019_0000000010', NULL, '0019_0000000010', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:08', 34, 'PCD_SF_DCN_JAVA', NULL, 'JAVA', '', '0018_0000000003', '0013_0000000014', 'new', '0002_0000000001', '0014_0000000002'),
	('0019_0000000011', NULL, '0019_0000000011', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:09', 34, 'PCD_SF_DCN_ILB', NULL, 'ILB', '', '0018_0000000003', '0013_0000000014', 'new', '0002_0000000004', '0014_0000000002'),
	('0019_0000000012', NULL, '0019_0000000012', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:09', 34, 'PCD_DMZ_DMZ_SQUID', NULL, 'SQUID', '', '0018_0000000004', '0013_0000000016', 'new', '0002_0000000006', '0014_0000000003'),
	('0019_0000000013', NULL, '0019_0000000013', 'umadmin', '2020-06-30 15:37:55', 'umadmin', '2020-04-28 21:10:09', 34, 'PCD_DMZ_DMZ_NGINX', NULL, 'NGINX', '', '0018_0000000004', '0013_0000000015', 'new', '0002_0000000011', '0014_0000000003'),
	('0019_0000000014', NULL, '0019_0000000014', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:10', 34, 'PCD_DMZ_DMZ_ELB', NULL, 'ELB', '', '0018_0000000004', '0013_0000000017', 'new', '0002_0000000004', '0014_0000000003'),
	('0019_0000000015', NULL, '0019_0000000015', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:10', 34, 'PCD_DMZ_DMZ_JAVA', NULL, 'JAVA', '', '0018_0000000004', '0013_0000000015', 'new', '0002_0000000001', '0014_0000000003'),
	('0019_0000000016', NULL, '0019_0000000016', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:11', 34, 'PCD_DMZ_DMZ_ILB', NULL, 'ILB', '', '0018_0000000004', '0013_0000000015', 'new', '0002_0000000004', '0014_0000000003'),
	('0019_0000000017', NULL, '0019_0000000017', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:11', 34, 'PCD_MGMT_MT_ILB', NULL, 'ILB', '', '0018_0000000006', '0013_0000000022', 'new', '0002_0000000004', '0014_0000000005'),
	('0019_0000000018', NULL, '0019_0000000018', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:11', 34, 'PCD_MGMT_MT_MYSQL', NULL, 'MYSQL', '', '0018_0000000006', '0013_0000000021', 'new', '0002_0000000002', '0014_0000000005'),
	('0019_0000000019', NULL, '0019_0000000019', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:12', 34, 'PCD_MGMT_MT_DOCKER', NULL, 'DOCKER', '', '0018_0000000006', '0013_0000000022', 'new', '0002_0000000012', '0014_0000000005'),
	('0019_0000000020', NULL, '0019_0000000020', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:12', 34, 'PCD_MGMT_MT_ACCESS', NULL, 'ACCESS', '', '0018_0000000006', '0013_0000000022', 'new', '0002_0000000010', '0014_0000000005'),
	('0019_0000000021', NULL, '0019_0000000021', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:10:13', 34, 'PCD_MGMT_MT_VDI', NULL, 'VDI', '', '0018_0000000006', '0013_0000000023', 'new', '0002_0000000005', '0014_0000000005'),
	('0019_0000000022', NULL, '0019_0000000022', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:11:37', 34, 'PCD_MGMT_MT_SEC', NULL, 'SEC', '', '0018_0000000006', '0013_0000000024', 'new', '0002_0000000010', '0014_0000000005'),
	('0019_0000000023', NULL, '0019_0000000023', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:11:37', 34, 'PCD_MGMT_MT_SQUID', NULL, 'SQUID', '', '0018_0000000006', '0013_0000000019', 'new', '0002_0000000006', '0014_0000000005'),
	('0019_0000000024', NULL, '0019_0000000024', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:11:37', 34, 'PCD_ECN_ECN_ILB', NULL, 'ILB', '', '0018_0000000005', '0013_0000000018', 'new', '0002_0000000004', '0014_0000000004'),
	('0019_0000000025', NULL, '0019_0000000025', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:11:38', 34, 'PCD_ECN_ECN_JAVA', NULL, 'JAVA', '', '0018_0000000005', '0013_0000000018', 'new', '0002_0000000001', '0014_0000000004'),
	('0019_0000000026', NULL, '0019_0000000026', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:18:06', 34, 'PCD_ECN_ECN_OAPP', NULL, 'OAPP', '', '0018_0000000005', '0013_0000000018', 'new', '0002_0000000010', '0014_0000000004'),
	('0019_0000000027', NULL, '0019_0000000027', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:18:06', 34, 'PCD_QZ_QZ_ELB', NULL, 'ELB', '', '0018_0000000007', '0013_0000000030', 'new', '0002_0000000004', '0014_0000000006'),
	('0019_0000000028', NULL, '0019_0000000028', 'umadmin', '2020-06-30 15:37:56', 'umadmin', '2020-04-28 21:18:06', 34, 'PCD_QZ_QZ_VDI', NULL, 'VDI', '', '0018_0000000007', '0013_0000000025', 'new', '0002_0000000005', '0014_0000000006'),
	('0019_0000000029', NULL, '0019_0000000029', 'umadmin', '2020-06-30 15:37:57', 'umadmin', '2020-04-29 12:23:25', 34, 'PCD_WAN_ALL_CLIENT', NULL, 'CLIENT', '', '0018_0000000008', '0013_0000000026', 'new', '0002_0000000009', '0014_0000000007'),
	('0019_0000000030', NULL, '0019_0000000030', 'umadmin', '2020-06-30 15:37:57', 'umadmin', '2020-04-29 12:24:45', 34, 'PCD_WAN_ALL_OAP', NULL, 'OAP', '', '0018_0000000008', '0013_0000000026', 'new', '0002_0000000010', '0014_0000000007'),
	('0019_0000000031', NULL, '0019_0000000031', 'umadmin', '2020-06-30 15:37:57', 'umadmin', '2020-04-29 12:25:28', 34, 'PCD_TON_OPS_CLIENT', NULL, 'CLIENT', '', '0018_0000000009', '0013_0000000027', 'new', '0002_0000000009', '0014_0000000009'),
	('0019_0000000032', NULL, '0019_0000000032', 'umadmin', '2020-06-30 15:37:57', 'umadmin', '2020-04-29 12:25:58', 34, 'PCD_BON_BAC_CLIENT', NULL, 'CLIENT', '', '0018_0000000011', '0013_0000000028', 'new', '0002_0000000009', '0014_0000000010'),
	('0019_0000000033', NULL, '0019_0000000033', 'umadmin', '2020-06-30 15:37:57', 'umadmin', '2020-04-29 12:25:59', 34, 'PCD_PTN_ANY_OAP', NULL, 'OAP', '', '0018_0000000010', '0013_0000000029', 'new', '0002_0000000010', '0014_0000000008'),
	('0019_0000000034', NULL, '0019_0000000034', 'umadmin', '2020-05-20 12:44:30', 'umadmin', '2020-05-20 11:17:55', 34, 'DC_SF__MYSQL', NULL, 'MYSQL', '', '', '0013_0000000035', 'new', '0002_0000000002', '0014_0000000011'),
	('0019_0000000035', NULL, '0019_0000000035', 'umadmin', '2020-05-20 11:21:21', 'umadmin', '2020-05-20 11:21:21', 34, 'DC_SF__REDIS', NULL, 'REDIS', '', '', '0013_0000000035', 'new', '0002_0000000003', '0014_0000000011'),
	('0019_0000000036', NULL, '0019_0000000036', 'umadmin', '2020-05-20 11:21:22', 'umadmin', '2020-05-20 11:21:22', 34, 'DC_SF__ILB', NULL, 'ILB', '', '', '0013_0000000037', 'new', '0002_0000000004', '0014_0000000011'),
	('0019_0000000037', NULL, '0019_0000000037', 'umadmin', '2020-05-20 11:21:22', 'umadmin', '2020-05-20 11:21:22', 34, 'DC_SF__JAVA', NULL, 'JAVA', '', '', '0013_0000000037', 'new', '0002_0000000001', '0014_0000000011'),
	('0019_0000000038', NULL, '0019_0000000038', 'umadmin', '2020-05-20 11:21:23', 'umadmin', '2020-05-20 11:21:22', 34, 'DC_DMZ__SQUID', NULL, 'SQUID', '', '', '0013_0000000039', 'new', '0002_0000000006', '0014_0000000012'),
	('0019_0000000039', NULL, '0019_0000000039', 'umadmin', '2020-05-20 11:21:23', 'umadmin', '2020-05-20 11:21:23', 34, 'DC_DMZ__NGINX', NULL, 'NGINX', '', '', '0013_0000000038', 'new', '0002_0000000011', '0014_0000000012'),
	('0019_0000000040', NULL, '0019_0000000040', 'umadmin', '2020-05-20 11:21:23', 'umadmin', '2020-05-20 11:21:23', 34, 'DC_DMZ__JAVA', NULL, 'JAVA', '', '', '0013_0000000038', 'new', '0002_0000000001', '0014_0000000012'),
	('0019_0000000041', NULL, '0019_0000000041', 'umadmin', '2020-05-20 11:21:24', 'umadmin', '2020-05-20 11:21:23', 34, 'DC_DMZ__ELB', NULL, 'ELB', '', '', '0013_0000000040', 'new', '0002_0000000004', '0014_0000000012'),
	('0019_0000000042', NULL, '0019_0000000042', 'umadmin', '2020-05-20 11:21:24', 'umadmin', '2020-05-20 11:21:24', 34, 'DC_DMZ__ILB', NULL, 'ILB', '', '', '0013_0000000038', 'new', '0002_0000000004', '0014_0000000012'),
	('0019_0000000043', NULL, '0019_0000000043', 'umadmin', '2020-05-20 11:22:17', 'umadmin', '2020-05-20 11:22:17', 34, 'DC_MGMT__MYSQL', NULL, 'MYSQL', '', '', '0013_0000000041', 'new', '0002_0000000002', '0014_0000000013'),
	('0019_0000000044', NULL, '0019_0000000044', 'umadmin', '2020-05-20 11:22:18', 'umadmin', '2020-05-20 11:22:17', 34, 'DC_MGMT__DOCKER', NULL, 'DOCKER', '', '', '0013_0000000042', 'new', '0002_0000000012', '0014_0000000013'),
	('0019_0000000045', NULL, '0019_0000000045', 'umadmin', '2020-05-20 11:23:03', 'umadmin', '2020-05-20 11:23:03', 34, 'DC_SF__BDP', NULL, 'BDP', '', '', '0013_0000000036', 'new', '0002_0000000008', '0014_0000000011'),
	('0019_0000000046', NULL, '0019_0000000046', 'umadmin', '2020-05-20 11:24:12', 'umadmin', '2020-05-20 11:24:12', 34, 'DC_WAN__CLIENT', NULL, 'CLIENT', '', '', '0013_0000000044', 'new', '0002_0000000009', '0014_0000000015'),
	('0019_0000000047', NULL, '0019_0000000047', 'umadmin', '2020-05-20 11:24:13', 'umadmin', '2020-05-20 11:24:12', 34, 'DC_WAN__OAP', NULL, 'OAP', '', '', '0013_0000000044', 'new', '0002_0000000010', '0014_0000000015'),
	('0019_0000000048', NULL, '0019_0000000048', 'umadmin', '2020-05-20 11:24:13', 'umadmin', '2020-05-20 11:24:13', 34, 'DC_TON__CLIENT', NULL, 'CLIENT', '', '', '0013_0000000045', 'new', '0002_0000000009', '0014_0000000014');
/*!40000 ALTER TABLE `resource_set_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_set_design$application_domain: ~27 rows (approximately)
/*!40000 ALTER TABLE `resource_set_design$application_domain` DISABLE KEYS */;
INSERT INTO `resource_set_design$application_domain` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(3, '0019_0000000035', '0005_0000000002', 2),
	(4, '0019_0000000035', '0005_0000000003', 1),
	(5, '0019_0000000036', '0005_0000000002', 2),
	(6, '0019_0000000036', '0005_0000000003', 1),
	(7, '0019_0000000037', '0005_0000000002', 2),
	(8, '0019_0000000037', '0005_0000000003', 1),
	(9, '0019_0000000038', '0005_0000000002', 2),
	(10, '0019_0000000038', '0005_0000000003', 1),
	(11, '0019_0000000039', '0005_0000000002', 2),
	(12, '0019_0000000039', '0005_0000000003', 1),
	(13, '0019_0000000040', '0005_0000000002', 2),
	(14, '0019_0000000040', '0005_0000000003', 1),
	(15, '0019_0000000041', '0005_0000000002', 2),
	(16, '0019_0000000041', '0005_0000000003', 1),
	(17, '0019_0000000042', '0005_0000000002', 2),
	(18, '0019_0000000042', '0005_0000000003', 1),
	(19, '0019_0000000043', '0005_0000000001', 1),
	(20, '0019_0000000044', '0005_0000000001', 1),
	(21, '0019_0000000045', '0005_0000000002', 2),
	(22, '0019_0000000045', '0005_0000000003', 1),
	(23, '0019_0000000046', '0005_0000000002', 2),
	(24, '0019_0000000046', '0005_0000000003', 1),
	(25, '0019_0000000047', '0005_0000000002', 2),
	(26, '0019_0000000047', '0005_0000000003', 1),
	(27, '0019_0000000048', '0005_0000000001', 1),
	(28, '0019_0000000034', '0005_0000000003', 1),
	(29, '0019_0000000034', '0005_0000000002', 2);
/*!40000 ALTER TABLE `resource_set_design$application_domain` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.resource_set_invoke_design: ~26 rows (approximately)
/*!40000 ALTER TABLE `resource_set_invoke_design` DISABLE KEYS */;
INSERT INTO `resource_set_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_resource_set_design`, `invoke_resource_set_design`, `state_code`) VALUES
	('0021_0000000002', NULL, '0021_0000000002', 'umadmin', '2020-05-20 09:34:24', 'umadmin', '2020-05-08 17:21:51', 34, 'PCD_QZ_QZ_VDI-->>--PCD_SF_ADM_ILB', NULL, 'VDI-->>--ILB', '', '0019_0000000007', '0019_0000000028', NULL),
	('0021_0000000003', NULL, '0021_0000000003', 'umadmin', '2020-05-20 09:34:24', 'umadmin', '2020-05-08 17:21:51', 34, 'PCD_QZ_QZ_VDI-->>--PCD_SF_DCN_ILB', NULL, 'VDI-->>--ILB', '', '0019_0000000011', '0019_0000000028', NULL),
	('0021_0000000004', NULL, '0021_0000000004', 'umadmin', '2020-05-20 09:32:38', 'umadmin', '2020-05-08 17:21:52', 34, 'PCD_SF_ADM_JAVA-->>--PCD_SF_ADM_MYSQL', NULL, 'JAVA-->>--MYSQL', '', '0019_0000000002', '0019_0000000006', NULL),
	('0021_0000000005', NULL, '0021_0000000005', 'umadmin', '2020-05-20 09:32:24', 'umadmin', '2020-05-08 17:21:52', 34, 'PCD_SF_ADM_JAVA-->>--PCD_SF_ADM_JAVA', NULL, 'JAVA-->>--JAVA', '', '0019_0000000006', '0019_0000000006', NULL),
	('0021_0000000006', NULL, '0021_0000000006', 'umadmin', '2020-05-20 09:32:25', 'umadmin', '2020-05-08 17:21:52', 34, 'PCD_SF_ADM_JAVA-->>--PCD_SF_ADM_REDIS', NULL, 'JAVA-->>--REDIS', '', '0019_0000000003', '0019_0000000006', NULL),
	('0021_0000000007', NULL, '0021_0000000007', 'umadmin', '2020-05-20 09:32:25', 'umadmin', '2020-05-08 17:21:52', 34, 'PCD_SF_ADM_ILB-->>--PCD_SF_ADM_JAVA', NULL, 'ILB-->>--JAVA', '', '0019_0000000006', '0019_0000000007', NULL),
	('0021_0000000008', NULL, '0021_0000000008', 'umadmin', '2020-05-20 09:32:24', 'umadmin', '2020-05-08 17:21:52', 34, 'PCD_DMZ_DMZ_JAVA-->>--PCD_SF_ADM_JAVA', NULL, 'JAVA-->>--JAVA', '', '0019_0000000006', '0019_0000000015', NULL),
	('0021_0000000009', NULL, '0021_0000000009', 'umadmin', '2020-05-20 09:32:24', 'umadmin', '2020-05-08 17:21:53', 34, 'PCD_SF_ADM_JAVA-->>--PCD_DMZ_DMZ_ILB', NULL, 'JAVA-->>--ILB', '', '0019_0000000016', '0019_0000000006', NULL),
	('0021_0000000010', NULL, '0021_0000000010', 'umadmin', '2020-05-20 09:32:25', 'umadmin', '2020-05-08 17:21:53', 34, 'PCD_DMZ_DMZ_JAVA-->>--PCD_SF_ADM_ILB', NULL, 'JAVA-->>--ILB', '', '0019_0000000007', '0019_0000000015', NULL),
	('0021_0000000011', NULL, '0021_0000000011', 'umadmin', '2020-05-20 09:32:24', 'umadmin', '2020-05-08 17:21:53', 34, 'PCD_SF_ADM_JAVA-->>--PCD_DMZ_DMZ_JAVA', NULL, 'JAVA-->>--JAVA', '', '0019_0000000015', '0019_0000000006', NULL),
	('0021_0000000012', NULL, '0021_0000000012', 'umadmin', '2020-05-20 09:32:25', 'umadmin', '2020-05-08 17:31:26', 34, 'PCD_SF_ADM_JAVA-->>--PCD_SF_ADM_ILB', NULL, 'JAVA-->>--ILB', '', '0019_0000000007', '0019_0000000006', NULL),
	('0021_0000000013', NULL, '0021_0000000013', 'umadmin', '2020-05-20 11:27:35', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_TON__CLIENT-->>--DC_MGMT__DOCKER', NULL, 'CLIENT-->>--DOCKER', '', '0019_0000000044', '0019_0000000048', 'new'),
	('0021_0000000014', NULL, '0021_0000000014', 'umadmin', '2020-05-20 11:27:35', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_WAN__CLIENT-->>--DC_DMZ__ELB', NULL, 'CLIENT-->>--ELB', '', '0019_0000000041', '0019_0000000046', 'new'),
	('0021_0000000015', NULL, '0021_0000000015', 'umadmin', '2020-05-20 11:27:35', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_MGMT__DOCKER-->>--DC_MGMT__MYSQL', NULL, 'DOCKER-->>--MYSQL', '', '0019_0000000043', '0019_0000000044', 'new'),
	('0021_0000000016', NULL, '0021_0000000016', 'umadmin', '2020-05-20 11:27:35', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_DMZ__ILB-->>--DC_DMZ__JAVA', NULL, 'ILB-->>--JAVA', '', '0019_0000000040', '0019_0000000042', 'new'),
	('0021_0000000017', NULL, '0021_0000000017', 'umadmin', '2020-05-20 11:27:35', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_DMZ__ELB-->>--DC_DMZ__NGINX', NULL, 'ELB-->>--NGINX', '', '0019_0000000039', '0019_0000000041', 'new'),
	('0021_0000000018', NULL, '0021_0000000018', 'umadmin', '2020-05-20 11:27:35', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_DMZ__JAVA-->>--DC_DMZ__SQUID', NULL, 'JAVA-->>--SQUID', '', '0019_0000000038', '0019_0000000040', 'new'),
	('0021_0000000019', NULL, '0021_0000000019', 'umadmin', '2020-05-20 11:27:36', 'umadmin', '2020-05-20 11:27:35', 34, 'DC_SF__JAVA-->>--DC_DMZ__ILB', NULL, 'JAVA-->>--ILB', '', '0019_0000000042', '0019_0000000037', 'new'),
	('0021_0000000020', NULL, '0021_0000000020', 'umadmin', '2020-05-20 11:27:36', 'umadmin', '2020-05-20 11:27:36', 34, 'DC_SF__JAVA-->>--DC_DMZ__JAVA', NULL, 'JAVA-->>--JAVA', '', '0019_0000000040', '0019_0000000037', 'new'),
	('0021_0000000021', NULL, '0021_0000000021', 'umadmin', '2020-05-20 11:27:36', 'umadmin', '2020-05-20 11:27:36', 34, 'DC_SF__JAVA-->>--DC_SF__ILB', NULL, 'JAVA-->>--ILB', '', '0019_0000000036', '0019_0000000037', 'new'),
	('0021_0000000022', NULL, '0021_0000000022', 'umadmin', '2020-05-20 11:27:36', 'umadmin', '2020-05-20 11:27:36', 34, 'DC_SF__JAVA-->>--DC_SF__BDP', NULL, 'JAVA-->>--BDP', '', '0019_0000000045', '0019_0000000037', 'new'),
	('0021_0000000023', NULL, '0021_0000000023', 'umadmin', '2020-05-20 11:27:36', 'umadmin', '2020-05-20 11:27:36', 34, 'DC_SF__JAVA-->>--DC_SF__REDIS', NULL, 'JAVA-->>--REDIS', '', '0019_0000000035', '0019_0000000037', 'new'),
	('0021_0000000024', NULL, '0021_0000000024', 'umadmin', '2020-05-20 12:44:30', 'umadmin', '2020-05-20 11:27:36', 34, 'DC_SF__JAVA-->>--DC_SF__MYSQL', NULL, 'JAVA-->>--MYSQL', '', '0019_0000000034', '0019_0000000037', 'new'),
	('0021_0000000025', NULL, '0021_0000000025', 'umadmin', '2020-05-20 11:28:07', 'umadmin', '2020-05-20 11:28:07', 34, 'DC_DMZ__NGINX-->>--DC_SF__ILB', NULL, 'NGINX-->>--ILB', '', '0019_0000000036', '0019_0000000039', 'new'),
	('0021_0000000026', NULL, '0021_0000000026', 'umadmin', '2020-05-20 11:28:07', 'umadmin', '2020-05-20 11:28:07', 34, 'DC_DMZ__NGINX-->>--DC_SF__JAVA', NULL, 'NGINX-->>--JAVA', '', '0019_0000000037', '0019_0000000039', 'new'),
	('0021_0000000027', NULL, '0021_0000000027', 'umadmin', '2020-05-20 15:54:43', 'umadmin', '2020-05-20 15:54:43', 34, 'DC_SF__ILB-->>--DC_SF__JAVA', NULL, 'ILB-->>--JAVA', '', '0019_0000000037', '0019_0000000036', 'new');
/*!40000 ALTER TABLE `resource_set_invoke_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.route: ~61 rows (approximately)
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `asset_id`, `dest_network_segment`, `owner_network_segment`, `network_link`, `route_design`, `state_code`) VALUES
	('0030_0000000002', NULL, '0030_0000000002', 'umadmin', '2020-05-11 11:16:52', 'umadmin', '2020-04-28 23:21:38', 37, 'TX_GZ_PRD_MGMT__peer__TX_CD_DR_MGMT', NULL, 'peer', '', '', '0023_0000000040', '0023_0000000006', '0026_0000000008', '0020_0000000017', 'created'),
	('0030_0000000005', NULL, '0030_0000000005', 'umadmin', '2020-04-28 23:21:39', 'umadmin', '2020-04-28 23:21:39', 37, 'HW_SG_PRD1_DMZ_PROXY01__nat__ODC_WAN_ALL', NULL, 'nat', '', '', '0023_0000000037', '0023_0000000012', '0026_0000000004', '0020_0000000012', 'created'),
	('0030_0000000006', NULL, '0030_0000000006', 'umadmin', '2020-04-28 23:21:39', 'umadmin', '2020-04-28 23:21:39', 37, 'HW_SG_PRD2_DMZ_PROXY01__nat__ODC_WAN_ALL', NULL, 'nat', '', '', '0023_0000000037', '0023_0000000013', '0026_0000000004', '0020_0000000012', 'created'),
	('0030_0000000007', NULL, '0030_0000000007', 'umadmin', '2020-04-28 23:21:39', 'umadmin', '2020-04-28 23:21:39', 37, 'HW_SG_PRD1_MGMT_PROXY01__nat__ODC_WAN_ALL', NULL, 'nat', '', '', '0023_0000000037', '0023_0000000024', '0026_0000000006', '0020_0000000013', 'created'),
	('0030_0000000008', NULL, '0030_0000000008', 'umadmin', '2020-04-28 23:21:40', 'umadmin', '2020-04-28 23:21:39', 37, 'HW_SG_PRD2_MGMT_PROXY01__nat__ODC_WAN_ALL', NULL, 'nat', '', '', '0023_0000000037', '0023_0000000025', '0026_0000000006', '0020_0000000013', 'created'),
	('0030_0000000009', NULL, '0030_0000000009', 'umadmin', '2020-04-28 23:21:40', 'umadmin', '2020-04-28 23:21:40', 37, 'HW_SG_PRD_QZ__peer__HW_SG_PRD1_SF_APP01', NULL, 'peer', '', '', '0023_0000000008', '0023_0000000007', '0026_0000000014', '0020_0000000011', 'created'),
	('0030_0000000010', NULL, '0030_0000000010', 'umadmin', '2020-04-28 23:21:40', 'umadmin', '2020-04-28 23:21:40', 37, 'HW_SG_PRD_QZ__peer__HW_SG_PRD2_SF_APP01', NULL, 'peer', '', '', '0023_0000000009', '0023_0000000007', '0026_0000000014', '0020_0000000011', 'created'),
	('0030_0000000011', NULL, '0030_0000000011', 'umadmin', '2020-04-28 23:21:41', 'umadmin', '2020-04-28 23:21:40', 37, 'HW_SG_PRD_DMZ__peer__HW_SG_PRD_MGMT', NULL, 'peer', '', '', '0023_0000000006', '0023_0000000004', '0026_0000000009', '0020_0000000008', 'created'),
	('0030_0000000012', NULL, '0030_0000000012', 'umadmin', '2020-04-28 23:21:41', 'umadmin', '2020-04-28 23:21:41', 37, 'HW_SG_PRD_ECN__peer__HW_SG_PRD1_SF_APP01', NULL, 'peer', '', '', '0023_0000000008', '0023_0000000005', '0026_0000000012', '0020_0000000009', 'created'),
	('0030_0000000013', NULL, '0030_0000000013', 'umadmin', '2020-04-28 23:21:41', 'umadmin', '2020-04-28 23:21:41', 37, 'HW_SG_PRD_ECN__peer__HW_SG_PRD2_SF_APP01', NULL, 'peer', '', '', '0023_0000000009', '0023_0000000005', '0026_0000000012', '0020_0000000009', 'created'),
	('0030_0000000014', NULL, '0030_0000000014', 'umadmin', '2020-04-28 23:21:42', 'umadmin', '2020-04-28 23:21:41', 37, 'HW_SG_PRD_ECN__peer__HW_SG_PRD_MGMT', NULL, 'peer', '', '', '0023_0000000006', '0023_0000000005', '0026_0000000010', '0020_0000000010', 'created'),
	('0030_0000000015', NULL, '0030_0000000015', 'umadmin', '2020-04-28 23:21:42', 'umadmin', '2020-04-28 23:21:42', 37, 'HW_SG_PRD_SF__peer__HW_SG_PRD_ECN', NULL, 'peer', '', '', '0023_0000000005', '0023_0000000003', '0026_0000000012', '0020_0000000003', 'created'),
	('0030_0000000016', NULL, '0030_0000000016', 'umadmin', '2020-04-28 23:21:42', 'umadmin', '2020-04-28 23:21:42', 37, 'HW_SG_PRD_SF__peer__HW_SG_PRD_QZ', NULL, 'peer', '', '', '0023_0000000007', '0023_0000000003', '0026_0000000014', '0020_0000000004', 'created'),
	('0030_0000000017', NULL, '0030_0000000017', 'umadmin', '2020-04-28 23:22:34', 'umadmin', '2020-04-28 23:22:34', 37, 'HW_SG_PRD_SF__peer__HW_SG_PRD_MGMT', NULL, 'peer', '', '', '0023_0000000006', '0023_0000000003', '0026_0000000013', '0020_0000000005', 'created'),
	('0030_0000000018', NULL, '0030_0000000018', 'umadmin', '2020-05-11 11:16:25', 'umadmin', '2020-04-28 23:22:34', 37, 'TX_GZ_PRD_SF__peer__TX_CD_DR_SF', NULL, 'peer', '', '', '0023_0000000043', '0023_0000000003', '0026_0000000002', '0020_0000000006', 'created'),
	('0030_0000000019', NULL, '0030_0000000019', 'umadmin', '2020-04-28 23:22:35', 'umadmin', '2020-04-28 23:22:35', 37, 'HW_SG_PRD_DMZ__peer__HW_SG_PRD1_SF_APP01', NULL, 'peer', '', '', '0023_0000000008', '0023_0000000004', '0026_0000000015', '0020_0000000007', 'created'),
	('0030_0000000020', NULL, '0030_0000000020', 'umadmin', '2020-04-28 23:22:35', 'umadmin', '2020-04-28 23:22:35', 37, 'HW_SG_PRD_DMZ__peer__HW_SG_PRD2_SF_APP01', NULL, 'peer', '', '', '0023_0000000009', '0023_0000000004', '0026_0000000015', '0020_0000000007', 'created'),
	('0030_0000000021', NULL, '0030_0000000021', 'umadmin', '2020-04-28 23:22:36', 'umadmin', '2020-04-28 23:22:35', 37, 'HW_SG_PRD_SF__peer__HW_SG_PRD_DMZ', NULL, 'peer', '', '', '0023_0000000004', '0023_0000000003', '0026_0000000015', '0020_0000000002', 'created'),
	('0030_0000000022', NULL, '0030_0000000022', 'umadmin', '2020-04-28 23:24:45', 'umadmin', '2020-04-28 23:24:44', 37, 'TX_SG_DR_DMZ__peer__TX_SG_DR1_SF_APP01', NULL, 'peer', '', '', '0023_0000000055', '0023_0000000041', '0026_0000000027', '0020_0000000007', 'created'),
	('0030_0000000023', NULL, '0030_0000000023', 'umadmin', '2020-04-28 23:24:45', 'umadmin', '2020-04-28 23:24:45', 37, 'TX_SG_DR_ECN__peer__TX_SG_DR1_SF_APP01', NULL, 'peer', '', '', '0023_0000000055', '0023_0000000042', '0026_0000000024', '0020_0000000009', 'created'),
	('0030_0000000024', NULL, '0030_0000000024', 'umadmin', '2020-04-28 23:24:45', 'umadmin', '2020-04-28 23:24:45', 37, 'TX_SG_DR_QZ__peer__TX_SG_DR1_SF_APP01', NULL, 'peer', '', '', '0023_0000000055', '0023_0000000039', '0026_0000000026', '0020_0000000011', 'created'),
	('0030_0000000025', NULL, '0030_0000000025', 'umadmin', '2020-04-28 23:24:46', 'umadmin', '2020-04-28 23:24:45', 37, 'TX_SG_DR1_DMZ_PROXY01__nat__ODC_WAN_ALL', NULL, 'nat', '', '', '0023_0000000037', '0023_0000000053', '0026_0000000017', '0020_0000000012', 'created'),
	('0030_0000000026', NULL, '0030_0000000026', 'umadmin', '2020-04-28 23:24:46', 'umadmin', '2020-04-28 23:24:46', 37, 'TX_SG_DR1_MGMT_PROXY01__nat__ODC_WAN_ALL', NULL, 'nat', '', '', '0023_0000000037', '0023_0000000047', '0026_0000000019', '0020_0000000013', 'created'),
	('0030_0000000027', NULL, '0030_0000000027', 'umadmin', '2020-04-28 23:30:07', 'umadmin', '2020-04-28 23:30:06', 37, 'TX_SG_DR_SF__peer__TX_SG_DR_DMZ', NULL, 'peer', '', '', '0023_0000000041', '0023_0000000043', '0026_0000000027', '0020_0000000002', 'created'),
	('0030_0000000028', NULL, '0030_0000000028', 'umadmin', '2020-04-28 23:30:07', 'umadmin', '2020-04-28 23:30:07', 37, 'TX_SG_DR_SF__peer__TX_SG_DR_MGMT', NULL, 'peer', '', '', '0023_0000000040', '0023_0000000043', '0026_0000000025', '0020_0000000005', 'created'),
	('0030_0000000029', NULL, '0030_0000000029', 'umadmin', '2020-05-11 15:58:08', 'umadmin', '2020-04-28 23:30:07', 37, 'TX_CD_DR_SF__peer__TX_GZ_PRD_SF', NULL, 'peer', '', '', '0023_0000000003', '0023_0000000043', '0026_0000000002', '0020_0000000006', 'created'),
	('0030_0000000030', NULL, '0030_0000000030', 'umadmin', '2020-04-28 23:30:07', 'umadmin', '2020-04-28 23:30:07', 37, 'TX_SG_DR_SF__peer__TX_SG_DR_ECN', NULL, 'peer', '', '', '0023_0000000042', '0023_0000000043', '0026_0000000024', '0020_0000000003', 'created'),
	('0030_0000000031', NULL, '0030_0000000031', 'umadmin', '2020-04-28 23:30:08', 'umadmin', '2020-04-28 23:30:08', 37, 'TX_SG_DR_SF__peer__TX_SG_DR_QZ', NULL, 'peer', '', '', '0023_0000000039', '0023_0000000043', '0026_0000000026', '0020_0000000004', 'created'),
	('0030_0000000032', NULL, '0030_0000000032', 'umadmin', '2020-04-28 23:30:08', 'umadmin', '2020-04-28 23:30:08', 37, 'TX_SG_DR_ECN__peer__TX_SG_DR_MGMT', NULL, 'peer', '', '', '0023_0000000040', '0023_0000000042', '0026_0000000022', '0020_0000000010', 'created'),
	('0030_0000000033', NULL, '0030_0000000033', 'umadmin', '2020-04-28 23:30:08', 'umadmin', '2020-04-28 23:30:08', 37, 'TX_SG_DR_DMZ__peer__TX_SG_DR_MGMT', NULL, 'peer', '', '', '0023_0000000040', '0023_0000000041', '0026_0000000021', '0020_0000000008', 'created'),
	('0030_0000000034', NULL, '0030_0000000034', 'umadmin', '2020-05-11 15:58:08', 'umadmin', '2020-04-28 23:30:08', 37, 'TX_CD_DR_MGMT__peer__TX_GZ_PRD_MGMT', NULL, 'peer', '', '', '0023_0000000006', '0023_0000000040', '0026_0000000008', '0020_0000000017', 'created'),
	('0030_0000000037', NULL, '0030_0000000037', 'umadmin', '2020-04-30 11:55:54', 'umadmin', '2020-04-30 11:55:54', 37, 'HW_SG_PRD_MGMT__peer__HW_SG_PRD_SF', NULL, 'peer', '', '', '0023_0000000003', '0023_0000000006', '0026_0000000013', '0020_0000000018', 'created'),
	('0030_0000000038', NULL, '0030_0000000038', 'umadmin', '2020-04-30 11:55:55', 'umadmin', '2020-04-30 11:55:54', 37, 'TX_SG_DR_MGMT__peer__TX_SG_DR_SF', NULL, 'peer', '', '', '0023_0000000043', '0023_0000000040', '0026_0000000025', '0020_0000000018', 'created'),
	('0030_0000000039', NULL, '0030_0000000039', 'umadmin', '2020-04-30 11:55:55', 'umadmin', '2020-04-30 11:55:55', 37, 'HW_SG_PRD_MGMT__peer__HW_SG_PRD_DMZ', NULL, 'peer', '', '', '0023_0000000004', '0023_0000000006', '0026_0000000009', '0020_0000000019', 'created'),
	('0030_0000000040', NULL, '0030_0000000040', 'umadmin', '2020-04-30 11:55:55', 'umadmin', '2020-04-30 11:55:55', 37, 'TX_SG_DR_MGMT__peer__TX_SG_DR_DMZ', NULL, 'peer', '', '', '0023_0000000041', '0023_0000000040', '0026_0000000021', '0020_0000000019', 'created'),
	('0030_0000000041', NULL, '0030_0000000041', 'umadmin', '2020-04-30 11:55:56', 'umadmin', '2020-04-30 11:55:55', 37, 'HW_SG_PRD_MGMT__peer__HW_SG_PRD_ECN', NULL, 'peer', '', '', '0023_0000000005', '0023_0000000006', '0026_0000000010', '0020_0000000020', 'created'),
	('0030_0000000042', NULL, '0030_0000000042', 'umadmin', '2020-05-08 00:22:17', 'umadmin', '2020-04-30 11:55:56', 37, 'TX_CD_DR_MGMT__peer__TX_CD_DR_ECN', NULL, 'peer', '', '', '0023_0000000042', '0023_0000000040', '0026_0000000022', '0020_0000000020', 'created'),
	('0030_0000000043', NULL, '0030_0000000043', 'umadmin', '2020-05-22 12:40:39', 'umadmin', '2020-05-20 14:13:12', 37, 'ALI_HZ_PRD_DMZ__peer__ALI_HZ_PRD1_MGMT_APP', NULL, 'peer', '', '', '0023_0000000072', '0023_0000000065', '0026_0000000031', '0020_0000000025', 'created'),
	('0030_0000000044', NULL, '0030_0000000044', 'umadmin', '2020-05-22 12:40:40', 'umadmin', '2020-05-20 14:13:12', 37, 'ALI_HZ_PRD_DMZ__peer__ALI_HZ_PRD2_MGMT_APP', NULL, 'peer', '', '', '0023_0000000073', '0023_0000000065', '0026_0000000031', '0020_0000000025', 'created'),
	('0030_0000000045', NULL, '0030_0000000045', 'umadmin', '2020-05-22 12:40:40', 'umadmin', '2020-05-20 14:13:12', 37, 'ALI_HZ_PRD1_DMZ_PROXY__nat__ALI_HZ_PRD_WAN_ALL', NULL, 'nat', '', '', '0023_0000000085', '0023_0000000078', '0026_0000000029', '0020_0000000026', 'created'),
	('0030_0000000046', NULL, '0030_0000000046', 'umadmin', '2020-05-22 12:40:40', 'umadmin', '2020-05-20 14:13:12', 37, 'ALI_HZ_PRD2_DMZ_PROXY__nat__ALI_HZ_PRD_WAN_ALL', NULL, 'nat', '', '', '0023_0000000085', '0023_0000000079', '0026_0000000029', '0020_0000000026', 'created'),
	('0030_0000000047', NULL, '0030_0000000047', 'umadmin', '2020-05-22 12:40:38', 'umadmin', '2020-05-20 14:13:13', 37, 'ALI_HZ_PRD_MGMT__peer__ALI_HZ_PRD_DMZ', NULL, 'peer', '', '', '0023_0000000065', '0023_0000000064', '0026_0000000031', '0020_0000000027', 'created'),
	('0030_0000000048', NULL, '0030_0000000048', 'umadmin', '2020-05-22 12:40:38', 'umadmin', '2020-05-20 14:13:13', 37, 'ALI_HZ_PRD_SF__peer__ALI_HZ_PRD1_MGMT_APP', NULL, 'peer', '', '', '0023_0000000072', '0023_0000000063', '0026_0000000032', '0020_0000000023', 'created'),
	('0030_0000000049', NULL, '0030_0000000049', 'umadmin', '2020-05-22 12:40:39', 'umadmin', '2020-05-20 14:13:13', 37, 'ALI_HZ_PRD_SF__peer__ALI_HZ_PRD2_MGMT_APP', NULL, 'peer', '', '', '0023_0000000073', '0023_0000000063', '0026_0000000032', '0020_0000000023', 'created'),
	('0030_0000000050', NULL, '0030_0000000050', 'umadmin', '2020-05-22 12:40:39', 'umadmin', '2020-05-20 14:13:13', 37, 'ALI_HZ_PRD_MGMT__peer__ALI_HZ_PRD_SF', NULL, 'peer', '', '', '0023_0000000063', '0023_0000000064', '0026_0000000032', '0020_0000000024', 'created'),
	('0030_0000000051', NULL, '0030_0000000051', 'umadmin', '2020-05-22 12:40:39', 'umadmin', '2020-05-20 14:13:13', 37, 'ALI_HZ_PRD_SF__peer__ALI_HZ_PRD1_DMZ_APP', NULL, 'peer', '', '', '0023_0000000083', '0023_0000000063', '0026_0000000033', '0020_0000000021', 'created'),
	('0030_0000000052', NULL, '0030_0000000052', 'umadmin', '2020-05-22 12:40:38', 'umadmin', '2020-05-20 14:13:14', 37, 'ALI_HZ_PRD_SF__peer__ALI_HZ_PRD2_DMZ_APP', NULL, 'peer', '', '', '0023_0000000084', '0023_0000000063', '0026_0000000033', '0020_0000000021', 'created'),
	('0030_0000000053', NULL, '0030_0000000053', 'umadmin', '2020-05-22 12:40:38', 'umadmin', '2020-05-20 14:13:41', 37, 'ALI_HZ_PRD_DMZ__peer__ALI_HZ_PRD2_SF_APP', NULL, 'peer', '', '', '0023_0000000070', '0023_0000000065', '0026_0000000033', '0020_0000000022', 'created'),
	('0030_0000000054', NULL, '0030_0000000054', 'umadmin', '2020-05-22 12:40:38', 'umadmin', '2020-05-20 14:13:42', 37, 'ALI_HZ_PRD_DMZ__peer__ALI_HZ_PRD1_SF_APP', NULL, 'peer', '', '', '0023_0000000071', '0023_0000000065', '0026_0000000033', '0020_0000000022', 'created'),
	('0030_0000000055', NULL, '0030_0000000055', 'umadmin', '2020-05-22 19:19:15', 'umadmin', '2020-05-22 19:19:14', 37, 'TX_BJ_PRD_DMZ__peer__TX_BJ_PRD1_SF_APP', NULL, 'peer', '', '', '0023_0000000100', '0023_0000000089', '0026_0000000035', '0020_0000000022', 'created'),
	('0030_0000000056', NULL, '0030_0000000056', 'umadmin', '2020-05-22 19:19:15', 'umadmin', '2020-05-22 19:19:15', 37, 'TX_BJ_PRD_DMZ__peer__TX_BJ_PRD2_SF_APP', NULL, 'peer', '', '', '0023_0000000107', '0023_0000000089', '0026_0000000035', '0020_0000000022', 'created'),
	('0030_0000000057', NULL, '0030_0000000057', 'umadmin', '2020-05-22 19:19:15', 'umadmin', '2020-05-22 19:19:15', 37, 'TX_BJ_PRD_SF__peer__TX_BJ_PRD2_DMZ_APP', NULL, 'peer', '', '', '0023_0000000103', '0023_0000000090', '0026_0000000035', '0020_0000000021', 'created'),
	('0030_0000000058', NULL, '0030_0000000058', 'umadmin', '2020-05-22 19:19:15', 'umadmin', '2020-05-22 19:19:15', 37, 'TX_BJ_PRD_MGMT__peer__TX_BJ_PRD_DMZ', NULL, 'peer', '', '', '0023_0000000089', '0023_0000000088', '0026_0000000039', '0020_0000000027', 'created'),
	('0030_0000000059', NULL, '0030_0000000059', 'umadmin', '2020-05-22 19:19:16', 'umadmin', '2020-05-22 19:19:15', 37, 'TX_BJ_PRD_SF__peer__TX_BJ_PRD1_MGMT_APP', NULL, 'peer', '', '', '0023_0000000099', '0023_0000000090', '0026_0000000034', '0020_0000000023', 'created'),
	('0030_0000000060', NULL, '0030_0000000060', 'umadmin', '2020-05-22 19:19:16', 'umadmin', '2020-05-22 19:19:16', 37, 'TX_BJ_PRD_SF__peer__TX_BJ_PRD2_MGMT_APP', NULL, 'peer', '', '', '0023_0000000105', '0023_0000000090', '0026_0000000034', '0020_0000000023', 'created'),
	('0030_0000000061', NULL, '0030_0000000061', 'umadmin', '2020-05-22 19:19:16', 'umadmin', '2020-05-22 19:19:16', 37, 'TX_BJ_PRD_MGMT__peer__TX_BJ_PRD_SF', NULL, 'peer', '', '', '0023_0000000090', '0023_0000000088', '0026_0000000034', '0020_0000000024', 'created'),
	('0030_0000000062', NULL, '0030_0000000062', 'umadmin', '2020-05-22 19:19:16', 'umadmin', '2020-05-22 19:19:16', 37, 'TX_BJ_PRD_SF__peer__TX_BJ_PRD1_DMZ_APP', NULL, 'peer', '', '', '0023_0000000096', '0023_0000000090', '0026_0000000035', '0020_0000000021', 'created'),
	('0030_0000000063', NULL, '0030_0000000063', 'umadmin', '2020-05-22 19:19:17', 'umadmin', '2020-05-22 19:19:17', 37, 'TX_BJ_PRD_DMZ__peer__TX_BJ_PRD1_MGMT_APP', NULL, 'peer', '', '', '0023_0000000099', '0023_0000000089', '0026_0000000039', '0020_0000000025', 'created'),
	('0030_0000000064', NULL, '0030_0000000064', 'umadmin', '2020-05-22 19:19:17', 'umadmin', '2020-05-22 19:19:17', 37, 'TX_BJ_PRD_DMZ__peer__TX_BJ_PRD2_MGMT_APP', NULL, 'peer', '', '', '0023_0000000105', '0023_0000000089', '0026_0000000039', '0020_0000000025', 'created'),
	('0030_0000000065', NULL, '0030_0000000065', 'umadmin', '2020-05-22 19:19:17', 'umadmin', '2020-05-22 19:19:17', 37, 'TX_BJ_PRD1_DMZ_PROXY__nat__TX_BJ_PRD_WAN_ALL', NULL, 'nat', '', '', '0023_0000000095', '0023_0000000097', '0026_0000000037', '0020_0000000026', 'created'),
	('0030_0000000066', NULL, '0030_0000000066', 'umadmin', '2020-05-22 19:19:18', 'umadmin', '2020-05-22 19:19:17', 37, 'TX_BJ_PRD2_DMZ_PROXY__nat__TX_BJ_PRD_WAN_ALL', NULL, 'nat', '', '', '0023_0000000095', '0023_0000000104', '0026_0000000037', '0020_0000000026', 'created');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.route_design: ~25 rows (approximately)
/*!40000 ALTER TABLE `route_design` DISABLE KEYS */;
INSERT INTO `route_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `dest_network_segment_design`, `network_zone_link_design`, `owner_network_segment_design`, `state_code`) VALUES
	('0020_0000000002', NULL, '0020_0000000002', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:47', 34, 'PCD_SF__peer__PCD_DMZ', NULL, 'peer', '', '0013_0000000004', '0016_0000000002', '0013_0000000003', 'new'),
	('0020_0000000003', NULL, '0020_0000000003', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:48', 34, 'PCD_SF__peer__PCD_ECN', NULL, 'peer', '', '0013_0000000005', '0016_0000000004', '0013_0000000003', 'new'),
	('0020_0000000004', NULL, '0020_0000000004', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:48', 34, 'PCD_SF__peer__PCD_QZ', NULL, 'peer', '', '0013_0000000007', '0016_0000000006', '0013_0000000003', 'new'),
	('0020_0000000005', NULL, '0020_0000000005', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:48', 34, 'PCD_SF__peer__PCD_MGMT', NULL, 'peer', '', '0013_0000000006', '0016_0000000005', '0013_0000000003', 'new'),
	('0020_0000000006', NULL, '0020_0000000006', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:48', 34, 'PCD_SF__peer__PCD_SF', NULL, 'peer', '', '0013_0000000003', '0016_0000000015', '0013_0000000003', 'new'),
	('0020_0000000007', NULL, '0020_0000000007', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:48', 34, 'PCD_DMZ__peer__PCD_SF_APP', NULL, 'peer', '', '0013_0000000014', '0016_0000000002', '0013_0000000004', 'new'),
	('0020_0000000008', NULL, '0020_0000000008', 'umadmin', '2020-06-30 15:37:59', 'umadmin', '2020-04-28 21:22:49', 34, 'PCD_DMZ__peer__PCD_MGMT', NULL, 'peer', '', '0013_0000000006', '0016_0000000008', '0013_0000000004', 'new'),
	('0020_0000000009', NULL, '0020_0000000009', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:22:49', 34, 'PCD_ECN__peer__PCD_SF_APP', NULL, 'peer', '', '0013_0000000014', '0016_0000000004', '0013_0000000005', 'new'),
	('0020_0000000010', NULL, '0020_0000000010', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:22:49', 34, 'PCD_ECN__peer__PCD_MGMT', NULL, 'peer', '', '0013_0000000006', '0016_0000000009', '0013_0000000005', 'new'),
	('0020_0000000011', NULL, '0020_0000000011', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:22:50', 34, 'PCD_QZ__peer__PCD_SF_APP', NULL, 'peer', '', '0013_0000000014', '0016_0000000006', '0013_0000000007', 'new'),
	('0020_0000000012', NULL, '0020_0000000012', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:25:32', 34, 'PCD_DMZ_PROXY__nat__PCD_WAN_ALL', NULL, 'nat', '', '0013_0000000026', '0016_0000000010', '0013_0000000016', 'new'),
	('0020_0000000013', NULL, '0020_0000000013', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:25:32', 34, 'PCD_MGMT_PROXY__nat__PCD_WAN_ALL', NULL, 'nat', '', '0013_0000000026', '0016_0000000012', '0013_0000000019', 'new'),
	('0020_0000000014', NULL, '0020_0000000014', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:27:29', 34, 'PCD_MGMT__vpn__PCD_TON_OPS', NULL, 'vpn', '', '0013_0000000027', '0016_0000000013', '0013_0000000006', 'new'),
	('0020_0000000015', NULL, '0020_0000000015', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:27:29', 34, 'PCD_ECN__vpn__PCD_PTN_ANY', NULL, 'vpn', '', '0013_0000000029', '0016_0000000011', '0013_0000000005', 'new'),
	('0020_0000000017', NULL, '0020_0000000017', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-28 21:46:09', 34, 'PCD_MGMT__peer__PCD_MGMT', NULL, 'peer', '', '0013_0000000006', '0016_0000000007', '0013_0000000006', 'new'),
	('0020_0000000018', NULL, '0020_0000000018', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-30 11:41:08', 34, 'PCD_MGMT__peer__PCD_SF', NULL, 'peer', '', '0013_0000000003', '0016_0000000005', '0013_0000000006', 'new'),
	('0020_0000000019', NULL, '0020_0000000019', 'umadmin', '2020-06-30 15:38:00', 'umadmin', '2020-04-30 11:41:08', 34, 'PCD_MGMT__peer__PCD_DMZ', NULL, 'peer', '', '0013_0000000004', '0016_0000000008', '0013_0000000006', 'new'),
	('0020_0000000020', NULL, '0020_0000000020', 'umadmin', '2020-06-30 15:38:01', 'umadmin', '2020-04-30 11:41:08', 34, 'PCD_MGMT__peer__PCD_ECN', NULL, 'peer', '', '0013_0000000005', '0016_0000000009', '0013_0000000006', 'new'),
	('0020_0000000021', NULL, '0020_0000000021', 'umadmin', '2020-05-20 11:45:51', 'umadmin', '2020-05-20 11:45:51', 34, 'DC_SF__peer__DC_DMZ_APP', NULL, 'peer', '', '0013_0000000038', '0016_0000000022', '0013_0000000032', 'new'),
	('0020_0000000022', NULL, '0020_0000000022', 'umadmin', '2020-05-20 12:17:40', 'umadmin', '2020-05-20 11:45:51', 34, 'DC_DMZ__peer__DC_SF_APP', NULL, 'peer', '', '0013_0000000037', '0016_0000000022', '0013_0000000034', 'new'),
	('0020_0000000023', NULL, '0020_0000000023', 'umadmin', '2020-05-20 11:45:52', 'umadmin', '2020-05-20 11:45:52', 34, 'DC_SF__peer__DC_MGMT_APP', NULL, 'peer', '', '0013_0000000042', '0016_0000000023', '0013_0000000032', 'new'),
	('0020_0000000024', NULL, '0020_0000000024', 'umadmin', '2020-05-20 11:46:50', 'umadmin', '2020-05-20 11:45:52', 34, 'DC_MGMT__peer__DC_SF', NULL, 'peer', '', '0013_0000000032', '0016_0000000023', '0013_0000000033', 'new'),
	('0020_0000000025', NULL, '0020_0000000025', 'umadmin', '2020-05-20 11:48:07', 'umadmin', '2020-05-20 11:48:07', 34, 'DC_DMZ__peer__DC_MGMT_APP', NULL, 'peer', '', '0013_0000000042', '0016_0000000024', '0013_0000000034', 'new'),
	('0020_0000000026', NULL, '0020_0000000026', 'umadmin', '2020-05-20 11:48:07', 'umadmin', '2020-05-20 11:48:07', 34, 'DC_DMZ_PROXY__nat__DC_WAN_ALL', NULL, 'nat', '', '0013_0000000044', '0016_0000000026', '0013_0000000039', 'new'),
	('0020_0000000027', NULL, '0020_0000000027', 'umadmin', '2020-05-20 11:48:07', 'umadmin', '2020-05-20 11:48:07', 34, 'DC_MGMT__peer__DC_DMZ', NULL, 'peer', '', '0013_0000000034', '0016_0000000024', '0013_0000000033', 'new');
/*!40000 ALTER TABLE `route_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.service_design: ~5 rows (approximately)
/*!40000 ALTER TABLE `service_design` DISABLE KEYS */;
INSERT INTO `service_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `service_invoke_type`, `service_nature`, `service_type`, `state_code`, `unit_design`) VALUES
	('0041_0000000002', NULL, '0041_0000000002', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:24:52', 34, 'S100001_登录', '2020-05-08 17:34:28', 'S100001', '', '登录', '同步请求', '查询类', '直连服务', 'new', '0039_0000000002'),
	('0041_0000000003', NULL, '0041_0000000003', 'umadmin', '2020-05-08 17:29:09', 'umadmin', '2020-05-08 17:29:09', 34, 'S100003_认证', NULL, 'S100003', '', '认证', '同步调用', '查询类', '直连服务', 'new', '0039_0000000007'),
	('0041_0000000004', NULL, '0041_0000000004', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:56:36', 34, 'S100045_登录', '2020-05-20 17:11:11', 'S100045', '', '登录', '同步请求', '查询类', '直连服务', 'new', '0039_0000000018'),
	('0041_0000000005', NULL, '0041_0000000005', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:57:48', 34, 'S100003_登录', '2020-05-20 17:11:11', 'S100003', '', '登录', '同步请求', '查询类', '直连服务', 'new', '0039_0000000017'),
	('0041_0000000007', NULL, '0041_0000000007', 'umadmin', '2020-05-20 15:59:01', 'umadmin', '2020-05-20 15:59:01', 34, 'S100043_认证', NULL, 'S100043', '', '认证', '同步请求', '查询类', '直连服务', 'new', '0039_0000000012');
/*!40000 ALTER TABLE `service_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.service_invoke_design: ~5 rows (approximately)
/*!40000 ALTER TABLE `service_invoke_design` DISABLE KEYS */;
INSERT INTO `service_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `invoked_unit_design`, `invoke_unit_design`, `service_design`, `state_code`) VALUES
	('0042_0000000002', NULL, '0042_0000000002', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:25:22', 34, 'DEMO_CLIENT_BROWER-->--DEMO_CORE_APP@S100001_登录', '2020-05-08 17:34:28', 'BROWER-->--APP@登录', '', '0039_0000000002', '0039_0000000006', '0041_0000000002', 'new'),
	('0042_0000000003', NULL, '0042_0000000003', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:32:16', 34, 'DEMO_CORE_APP-->--UM_SER_APP@S100003_认证', '2020-05-08 17:34:28', 'APP-->--APP@认证', '', '0039_0000000007', '0039_0000000002', '0041_0000000003', 'new'),
	('0042_0000000004', NULL, '0042_0000000004', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:57:00', 34, 'aDEMO_CLIENT_BROWER-->--aDEMO_PROXY_NGINX@S100045_登录', '2020-05-20 17:11:11', 'BROWER-->--NGINX@登录', '', '0039_0000000018', '0039_0000000013', '0041_0000000004', 'new'),
	('0042_0000000005', NULL, '0042_0000000005', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:58:03', 34, 'aDEMO_PROXY_NGINX-->--aDEMO_CORE_APP@S100003_登录', '2020-05-20 17:11:11', 'NGINX-->--APP@登录', '', '0039_0000000017', '0039_0000000018', '0041_0000000005', 'new'),
	('0042_0000000006', NULL, '0042_0000000006', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:59:38', 34, 'aDEMO_CORE_APP-->--aUM_SER_APP@S100043_认证', '2020-05-20 17:11:11', 'APP-->--APP@认证', '', '0039_0000000012', '0039_0000000017', '0041_0000000007', 'new');
/*!40000 ALTER TABLE `service_invoke_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.service_invoke_seq_design: ~2 rows (approximately)
/*!40000 ALTER TABLE `service_invoke_seq_design` DISABLE KEYS */;
INSERT INTO `service_invoke_seq_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `app_system_design`) VALUES
	('0043_0000000002', NULL, '0043_0000000002', 'umadmin', '2020-05-08 17:32:52', 'umadmin', '2020-05-08 17:32:52', 34, 'DEMO_seq_LOGIN', NULL, 'LOGIN', '', '登录', 'new', '0037_0000000002'),
	('0043_0000000003', NULL, '0043_0000000003', 'umadmin', '2020-05-20 16:00:15', 'umadmin', '2020-05-20 16:00:15', 34, 'aDEMO_seq_LOGIN', NULL, 'LOGIN', '', '用户登录', 'new', '0037_0000000007');
/*!40000 ALTER TABLE `service_invoke_seq_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.service_invoke_seq_design$service_invoke_design_sequence: ~5 rows (approximately)
/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` DISABLE KEYS */;
INSERT INTO `service_invoke_seq_design$service_invoke_design_sequence` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0043_0000000002', '0042_0000000003', 2),
	(2, '0043_0000000002', '0042_0000000002', 1),
	(3, '0043_0000000003', '0042_0000000004', 1),
	(4, '0043_0000000003', '0042_0000000006', 3),
	(5, '0043_0000000003', '0042_0000000005', 2);
/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.static_diff_conf_value: ~0 rows (approximately)
/*!40000 ALTER TABLE `static_diff_conf_value` DISABLE KEYS */;
INSERT INTO `static_diff_conf_value` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `state_code`, `fixed_date`, `code`, `deploy_environment`, `deploy_environment_difference`, `description`, `static_value`, `unit_design`) VALUES
	('0064_0000000002', NULL, '0064_0000000002', 'umadmin', '2020-05-25 12:37:51', 'umadmin', '2020-05-25 12:37:51', 34, 'aDEMO_PROXY_NGINX__context_path', 'new', NULL, 'context_path', '', 'N', '全部转发', '~*^.+$', '0039_0000000018');
/*!40000 ALTER TABLE `static_diff_conf_value` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.storage_type: ~30 rows (approximately)
/*!40000 ALTER TABLE `storage_type` DISABLE KEYS */;
INSERT INTO `storage_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `state_code`, `fixed_date`, `code`, `cloud_vendor`, `description`, `name`, `unit_type`) VALUES
	('0062_0000000001', NULL, '0062_0000000001', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-11 23:49:54', 34, '普通IO型_华为云JAVA', 'new', NULL, 'SATA', '0006_0000000001', '', '普通IO型', '0002_0000000001'),
	('0062_0000000002', NULL, '0062_0000000002', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-11 23:50:47', 34, '高IO型_华为云JAVA', 'new', NULL, 'SAS', '0006_0000000001', '', '高IO型', '0002_0000000001'),
	('0062_0000000005', NULL, '0062_0000000005', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-11 23:53:18', 34, '超高IO型_华为云MYSQL', 'new', NULL, 'ULTRAHIGH', '0006_0000000001', '', '超高IO型', '0002_0000000002'),
	('0062_0000000007', NULL, '0062_0000000007', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-12 03:14:26', 34, '普通IO型_华为云VDI', 'new', NULL, 'SATA', '0006_0000000001', '', '普通IO型', '0002_0000000005'),
	('0062_0000000008', NULL, '0062_0000000008', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-12 03:14:26', 34, '普通IO型_华为云SQUID', 'new', NULL, 'SATA', '0006_0000000001', '', '普通IO型', '0002_0000000006'),
	('0062_0000000009', NULL, '0062_0000000009', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-18 17:12:15', 34, '普通IO型_腾讯云VDI', 'new', NULL, 'CLOUD_BASIC', '0006_0000000002', '', '普通IO型', '0002_0000000005'),
	('0062_0000000010', NULL, '0062_0000000010', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-18 17:12:16', 34, '普通IO型_腾讯云SQUID', 'new', NULL, 'CLOUD_BASIC', '0006_0000000002', '', '普通IO型', '0002_0000000006'),
	('0062_0000000011', NULL, '0062_0000000011', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-18 17:12:16', 34, '超高IO型_腾讯云MYSQL', 'new', NULL, 'LOCAL_SSD', '0006_0000000002', '', '超高IO型', '0002_0000000002'),
	('0062_0000000013', NULL, '0062_0000000013', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-18 17:12:16', 34, '高IO型_腾讯云JAVA', 'new', NULL, 'CLOUD_PREMIUM', '0006_0000000002', '', '高IO型', '0002_0000000001'),
	('0062_0000000014', NULL, '0062_0000000014', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-18 17:12:16', 34, '普通IO型_腾讯云JAVA', 'new', NULL, 'CLOUD_BASIC', '0006_0000000002', '', '普通IO型', '0002_0000000001'),
	('0062_0000000015', NULL, '0062_0000000015', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 12:01:37', 34, '高IO型_腾讯云DOCKER', 'new', NULL, 'CLOUD_PREMIUM', '0006_0000000002', '', '高IO型', '0002_0000000012'),
	('0062_0000000016', NULL, '0062_0000000016', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 12:01:37', 34, '普通IO型_腾讯云DOCKER', 'new', NULL, 'CLOUD_BASIC', '0006_0000000002', '', '普通IO型', '0002_0000000012'),
	('0062_0000000017', NULL, '0062_0000000017', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-24 12:01:37', 34, '高IO型_华为云DOCKER', 'new', NULL, 'SAS', '0006_0000000001', '', '高IO型', '0002_0000000012'),
	('0062_0000000018', NULL, '0062_0000000018', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-24 12:01:37', 34, '普通IO型_华为云DOCKER', 'new', NULL, 'SATA', '0006_0000000001', '', '普通IO型', '0002_0000000012'),
	('0062_0000000019', NULL, '0062_0000000019', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 12:01:37', 34, '高IO型_腾讯云OAP', 'new', NULL, 'CLOUD_PREMIUM', '0006_0000000002', '', '高IO型', '0002_0000000010'),
	('0062_0000000020', NULL, '0062_0000000020', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 12:01:37', 34, '普通IO型_腾讯云OAP', 'new', NULL, 'CLOUD_BASIC', '0006_0000000002', '', '普通IO型', '0002_0000000010'),
	('0062_0000000021', NULL, '0062_0000000021', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-24 12:01:38', 34, '高IO型_华为云OAP', 'new', NULL, 'SAS', '0006_0000000001', '', '高IO型', '0002_0000000010'),
	('0062_0000000022', NULL, '0062_0000000022', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-24 12:01:38', 34, '普通IO型_华为云OAP', 'new', NULL, 'SATA', '0006_0000000001', '', '普通IO型', '0002_0000000010'),
	('0062_0000000023', NULL, '0062_0000000023', 'umadmin', '2020-05-20 11:58:03', 'umadmin', '2020-04-24 12:02:05', 34, '普通IO型_腾讯云NGINX', 'new', NULL, 'CLOUD_BASIC', '0006_0000000002', '', '普通IO型', '0002_0000000011'),
	('0062_0000000024', NULL, '0062_0000000024', 'umadmin', '2020-05-20 11:58:04', 'umadmin', '2020-04-24 12:02:05', 34, '普通IO型_华为云NGINX', 'new', NULL, 'SATA', '0006_0000000001', '', '普通IO型', '0002_0000000011'),
	('0062_0000000035', NULL, '0062_0000000035', 'umadmin', '2020-05-20 14:21:49', 'umadmin', '2020-05-20 14:21:49', 34, '高效云盘_阿里云NGINX', 'new', NULL, 'cloud_efficiency', '0006_0000000004', '', '高效云盘', '0002_0000000011'),
	('0062_0000000036', NULL, '0062_0000000036', 'umadmin', '2020-05-20 14:21:49', 'umadmin', '2020-05-20 14:21:49', 34, 'SSD云盘_阿里云DOCKER', 'new', NULL, 'cloud_ssd', '0006_0000000004', '', 'SSD云盘', '0002_0000000012'),
	('0062_0000000037', NULL, '0062_0000000037', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:49', 34, '高效云盘_阿里云DOCKER', 'new', NULL, 'cloud_efficiency', '0006_0000000004', '', '高效云盘', '0002_0000000012'),
	('0062_0000000038', NULL, '0062_0000000038', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:50', 34, 'SSD云盘_阿里云OAP', 'new', NULL, 'cloud_ssd', '0006_0000000004', '', 'SSD云盘', '0002_0000000010'),
	('0062_0000000039', NULL, '0062_0000000039', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:50', 34, '高效云盘_阿里云OAP', 'new', NULL, 'cloud_efficiency', '0006_0000000004', '', '高效云盘', '0002_0000000010'),
	('0062_0000000040', NULL, '0062_0000000040', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:50', 34, '高效云盘_阿里云SQUID', 'new', NULL, 'cloud_efficiency', '0006_0000000004', '', '高效云盘', '0002_0000000006'),
	('0062_0000000041', NULL, '0062_0000000041', 'umadmin', '2020-05-20 14:23:45', 'umadmin', '2020-05-20 14:21:50', 34, '本地SSD盘_阿里云MYSQL', 'new', NULL, 'local_ssd', '0006_0000000004', '', '本地SSD盘', '0002_0000000002'),
	('0062_0000000042', NULL, '0062_0000000042', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:50', 34, '高效云盘_阿里云JAVA', 'new', NULL, 'cloud_efficiency', '0006_0000000004', '', '高效云盘', '0002_0000000001'),
	('0062_0000000043', NULL, '0062_0000000043', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:50', 34, 'SSD云盘_阿里云JAVA', 'new', NULL, 'cloud_ssd', '0006_0000000004', '', 'SSD云盘', '0002_0000000001'),
	('0062_0000000044', NULL, '0062_0000000044', 'umadmin', '2020-05-20 14:21:50', 'umadmin', '2020-05-20 14:21:50', 34, '高效云盘_阿里云VDI', 'new', NULL, 'cloud_efficiency', '0006_0000000004', '', '高效云盘', '0002_0000000005');
/*!40000 ALTER TABLE `storage_type` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.subsys: ~8 rows (approximately)
/*!40000 ALTER TABLE `subsys` DISABLE KEYS */;
INSERT INTO `subsys` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `manage_role`, `state_code`, `subsys_design`, `app_system`, `network_zone`) VALUES
	('0047_0000000002', NULL, '0047_0000000002', 'umadmin', '2020-05-08 17:35:58', 'umadmin', '2020-05-08 17:35:58', 37, 'PRD_DEMO_CLIENT', NULL, 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000003', '0046_0000000003', NULL),
	('0047_0000000003', NULL, '0047_0000000003', 'umadmin', '2020-05-08 17:36:37', 'umadmin', '2020-05-08 17:36:37', 37, 'PRD_DEMO_CORE', NULL, 'CORE', '', '0001_0000000001', 'created', '0038_0000000002', '0046_0000000003', NULL),
	('0047_0000000004', NULL, '0047_0000000004', 'umadmin', '2020-05-23 00:06:53', 'umadmin', '2020-05-20 16:31:07', 37, 'PRD_AaDEMO_CLIENT', NULL, 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000006', '0046_0000000005', '0024_0000000020'),
	('0047_0000000005', NULL, '0047_0000000005', 'umadmin', '2020-05-23 00:06:52', 'umadmin', '2020-05-20 16:31:28', 37, 'PRD_AaDEMO_CORE', NULL, 'CORE', '', '0001_0000000001', 'created', '0038_0000000007', '0046_0000000005', '0024_0000000016'),
	('0047_0000000006', NULL, '0047_0000000006', 'umadmin', '2020-05-23 00:06:53', 'umadmin', '2020-05-20 16:31:28', 37, 'PRD_AaDEMO_PROXY', NULL, 'PROXY', '', '0001_0000000001', 'created', '0038_0000000008', '0046_0000000005', '0024_0000000017'),
	('0047_0000000007', NULL, '0047_0000000007', 'umadmin', '2020-05-23 00:07:48', 'umadmin', '2020-05-23 00:07:48', 37, 'PRD_TaDEMO_CORE', NULL, 'CORE', '', '0001_0000000001', 'created', '0038_0000000007', '0046_0000000007', '0024_0000000023'),
	('0047_0000000008', NULL, '0047_0000000008', 'umadmin', '2020-05-23 00:07:48', 'umadmin', '2020-05-23 00:07:48', 37, 'PRD_TaDEMO_PROXY', NULL, 'PROXY', '', '0001_0000000001', 'created', '0038_0000000008', '0046_0000000007', '0024_0000000024'),
	('0047_0000000009', NULL, '0047_0000000009', 'umadmin', '2020-05-23 00:07:49', 'umadmin', '2020-05-23 00:07:48', 37, 'PRD_TaDEMO_CLIENT', NULL, 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000006', '0046_0000000007', '0024_0000000022');
/*!40000 ALTER TABLE `subsys` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.subsys$business_zone: ~13 rows (approximately)
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

-- Dumping data for table wecmdb_bk.subsys_design: ~7 rows (approximately)
/*!40000 ALTER TABLE `subsys_design` DISABLE KEYS */;
INSERT INTO `subsys_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`, `subsys_design_id`, `app_system_design`, `network_zone_design`) VALUES
	('0038_0000000002', NULL, '0038_0000000002', 'umadmin', '2020-05-08 14:53:43', 'umadmin', '2020-05-07 17:26:47', 34, 'DEMO_CORE', '2020-05-08 14:53:43', 'CORE', '', '核心子系统', 'new', '1235', '0037_0000000002', NULL),
	('0038_0000000003', NULL, '0038_0000000003', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:07:37', 34, 'DEMO_CLIENT', '2020-05-08 17:34:28', 'CLIENT', '', '客户端子系统', 'new', '1256', '0037_0000000002', NULL),
	('0038_0000000004', NULL, '0038_0000000004', 'umadmin', '2020-05-08 17:27:11', 'umadmin', '2020-05-08 17:27:11', 34, 'UM_SER', NULL, 'SER', '', '服务子系统', 'new', '3456', '0037_0000000004', NULL),
	('0038_0000000005', NULL, '0038_0000000005', 'umadmin', '2020-05-20 15:40:58', 'umadmin', '2020-05-20 15:40:58', 34, 'aUM_SER', NULL, 'SER', '', '服务子系统', 'new', '3453', '0037_0000000006', '0014_0000000011'),
	('0038_0000000006', NULL, '0038_0000000006', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:40:58', 34, 'aDEMO_CLIENT', '2020-05-20 17:11:11', 'CLIENT', '', '客户端子系统', 'new', '1251', '0037_0000000007', '0014_0000000015'),
	('0038_0000000007', NULL, '0038_0000000007', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:40:58', 34, 'aDEMO_CORE', '2020-05-20 17:11:11', 'CORE', '', '核心子系统', 'new', '1223', '0037_0000000007', '0014_0000000011'),
	('0038_0000000008', NULL, '0038_0000000008', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:42:26', 34, 'aDEMO_PROXY', '2020-05-20 17:11:11', 'PROXY', '', '代理子系统', 'new', '1228', '0037_0000000007', '0014_0000000012');
/*!40000 ALTER TABLE `subsys_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.subsys_design$business_zone_design: ~13 rows (approximately)
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

-- Dumping data for table wecmdb_bk.unit: ~19 rows (approximately)
/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
INSERT INTO `unit` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `deploy_path`, `manage_role`, `public_key`, `resource_set`, `security_group_asset_id`, `state_code`, `subsys`, `unit_design`, `unit_type`, `protocol`, `white_list_type`) VALUES
	('0048_0000000002', NULL, '0048_0000000002', 'umadmin', '2020-05-11 17:13:42', 'umadmin', '2020-05-08 17:38:03', 37, 'PRD_DEMO_CORE_APP', NULL, 'APP', '', '/data/PRD_DEMO_CORE_APP/', '0001_0000000001', '', '0029_0000000051', '', 'created', '0047_0000000003', '0039_0000000002', '0002_0000000001', 'TCP', 'E'),
	('0048_0000000003', NULL, '0048_0000000003', 'umadmin', '2020-05-08 17:38:04', 'umadmin', '2020-05-08 17:38:04', 37, 'PRD_DEMO_CORE_DB', NULL, 'DB', '', '/data/PRD_DEMO_CORE_DB/', '0001_0000000001', '', '0029_0000000055', '', 'created', '0047_0000000003', '0039_0000000004', '0002_0000000002', 'TCP', 'N'),
	('0048_0000000004', NULL, '0048_0000000004', 'umadmin', '2020-05-08 17:39:01', 'umadmin', '2020-05-08 17:38:05', 37, 'PRD_DEMO_CORE_REDIS', NULL, 'REDIS', '', '/data/PRD_DEMO_CORE_REDIS/', '0001_0000000001', '', '0029_0000000054', '', 'created', '0047_0000000003', '0039_0000000005', '0002_0000000003', 'TCP', 'N'),
	('0048_0000000005', NULL, '0048_0000000005', 'umadmin', '2020-05-08 17:38:05', 'umadmin', '2020-05-08 17:38:05', 37, 'PRD_DEMO_CORE_LB', NULL, 'LB', '', '/data/PRD_DEMO_CORE_LB/', '0001_0000000001', '', '0029_0000000050', '', 'created', '0047_0000000003', '0039_0000000003', '0002_0000000004', 'TCP', 'N'),
	('0048_0000000006', NULL, '0048_0000000006', 'umadmin', '2020-05-08 17:39:47', 'umadmin', '2020-05-08 17:39:47', 37, 'PRD_DEMO_CLIENT_BROWER', NULL, 'BROWER', '', '/data/PRD_DEMO_CLIENT_BROWER/', '0001_0000000001', '', '0029_0000000029', '', 'created', '0047_0000000002', '0039_0000000006', '0002_0000000005', 'TCP', 'N'),
	('0048_0000000012', NULL, '0048_0000000012', 'umadmin', '2020-05-23 00:12:26', 'umadmin', '2020-05-20 16:40:20', 37, 'PRD_AaDEMO_CLIENT_BROWER', NULL, 'BROWER', '', '/data/PRD_AaDEMO_CLIENT_BROWER/', '0001_0000000001', '', '0029_0000000120', '', 'created', '0047_0000000004', '0039_0000000013', '0002_0000000009', 'TCP', 'N'),
	('0048_0000000013', NULL, '0048_0000000013', 'umadmin', '2020-05-23 00:12:25', 'umadmin', '2020-05-20 16:40:21', 37, 'PRD_AaDEMO_CORE_REDIS', NULL, 'REDIS', '', '/data/PRD_AaDEMO_CORE_REDIS/', '0001_0000000001', '', '0029_0000000102', '', 'created', '0047_0000000005', '0039_0000000014', '0002_0000000003', 'TCP', 'N'),
	('0048_0000000014', NULL, '0048_0000000014', 'umadmin', '2020-05-23 00:12:25', 'umadmin', '2020-05-20 16:40:21', 37, 'PRD_AaDEMO_CORE_LB', NULL, 'LB', '', '/data/PRD_AaDEMO_CORE_LB/', '0001_0000000001', '', '0029_0000000104', '', 'created', '0047_0000000005', '0039_0000000016', '0002_0000000004', 'TCP', 'N'),
	('0048_0000000015', NULL, '0048_0000000015', 'umadmin', '2020-05-23 00:12:24', 'umadmin', '2020-05-20 16:40:22', 37, 'PRD_AaDEMO_CORE_DB', NULL, 'DB', '', '/data/PRD_AaDEMO_CORE_DB/', '0001_0000000001', '', '0029_0000000101', '', 'created', '0047_0000000005', '0039_0000000015', '0002_0000000002', 'TCP', 'N'),
	('0048_0000000016', NULL, '0048_0000000016', 'umadmin', '2020-05-23 00:12:23', 'umadmin', '2020-05-20 16:40:23', 37, 'PRD_AaDEMO_CORE_APP', NULL, 'APP', '', '/data/PRD_AaDEMO_CORE_APP/', '0001_0000000001', '', '0029_0000000103', '', 'created', '0047_0000000005', '0039_0000000017', '0002_0000000001', 'TCP', 'E'),
	('0048_0000000017', NULL, '0048_0000000017', 'umadmin', '2020-05-23 00:12:23', 'umadmin', '2020-05-20 16:45:47', 37, 'PRD_AaDEMO_PROXY_NGINX', NULL, 'NGINX', '', '/data/PRD_AaDEMO_PROXY_NGINX/', '0001_0000000001', '', '0029_0000000113', '', 'created', '0047_0000000006', '0039_0000000018', '0002_0000000011', 'TCP', 'E'),
	('0048_0000000018', NULL, '0048_0000000018', 'umadmin', '2020-05-23 00:12:22', 'umadmin', '2020-05-20 16:45:48', 37, 'PRD_AaDEMO_PROXY_ELB', NULL, 'ELB', '', '/data/PRD_AaDEMO_PROXY_ELB/', '0001_0000000001', '', '0029_0000000116', '', 'created', '0047_0000000006', '0039_0000000019', '0002_0000000004', 'TCP', 'N'),
	('0048_0000000019', NULL, '0048_0000000019', 'umadmin', '2020-05-23 00:13:38', 'umadmin', '2020-05-23 00:13:37', 37, 'PRD_TaDEMO_PROXY_ELB', NULL, 'ELB', '', '/data/PRD_TaDEMO_PROXY_ELB/', '0001_0000000001', '', '0029_0000000127', '', 'created', '0047_0000000008', '0039_0000000019', '0002_0000000004', 'TCP', 'N'),
	('0048_0000000020', NULL, '0048_0000000020', 'umadmin', '2020-06-30 15:30:43', 'umadmin', '2020-05-23 00:13:38', 37, 'PRD_TaDEMO_PROXY_NGINX', NULL, 'NGINX', '', '/data/PRD_TaDEMO_PROXY_NGINX/', '0001_0000000001', '', '0029_0000000128', '', 'created', '0047_0000000008', '0039_0000000018', '0002_0000000011', 'TCP', 'E'),
	('0048_0000000021', NULL, '0048_0000000021', 'umadmin', '2020-06-30 15:30:43', 'umadmin', '2020-05-23 00:13:38', 37, 'PRD_TaDEMO_CORE_APP', NULL, 'APP', '', '/data/PRD_TaDEMO_CORE_APP/', '0001_0000000001', '', '0029_0000000135', '', 'created', '0047_0000000007', '0039_0000000017', '0002_0000000001', 'TCP', 'E'),
	('0048_0000000022', NULL, '0048_0000000022', 'umadmin', '2020-06-30 15:30:42', 'umadmin', '2020-05-23 00:13:39', 37, 'PRD_TaDEMO_CORE_DB', NULL, 'DB', '', '/data/PRD_TaDEMO_CORE_DB/', '0001_0000000001', '', '0029_0000000136', '', 'created', '0047_0000000007', '0039_0000000015', '0002_0000000002', 'TCP', 'N'),
	('0048_0000000023', NULL, '0048_0000000023', 'umadmin', '2020-05-23 00:13:40', 'umadmin', '2020-05-23 00:13:40', 37, 'PRD_TaDEMO_CORE_REDIS', NULL, 'REDIS', '', '/data/PRD_TaDEMO_CORE_REDIS/', '0001_0000000001', '', '0029_0000000134', '', 'created', '0047_0000000007', '0039_0000000014', '0002_0000000003', 'TCP', 'N'),
	('0048_0000000024', NULL, '0048_0000000024', 'umadmin', '2020-05-23 00:13:41', 'umadmin', '2020-05-23 00:13:40', 37, 'PRD_TaDEMO_CORE_LB', NULL, 'LB', '', '/data/PRD_TaDEMO_CORE_LB/', '0001_0000000001', '', '0029_0000000132', '', 'created', '0047_0000000007', '0039_0000000016', '0002_0000000004', 'TCP', 'N'),
	('0048_0000000025', NULL, '0048_0000000025', 'umadmin', '2020-05-23 00:13:41', 'umadmin', '2020-05-23 00:13:41', 37, 'PRD_TaDEMO_CLIENT_BROWER', NULL, 'BROWER', '', '/data/PRD_TaDEMO_CLIENT_BROWER/', '0001_0000000001', '', '0029_0000000124', '', 'created', '0047_0000000009', '0039_0000000013', '0002_0000000009', 'TCP', 'N');
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.unit$deploy_package: ~3 rows (approximately)
/*!40000 ALTER TABLE `unit$deploy_package` DISABLE KEYS */;
INSERT INTO `unit$deploy_package` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0048_0000000022', '0045_0000000006', 1),
	(2, '0048_0000000020', '0045_0000000007', 1),
	(3, '0048_0000000021', '0045_0000000005', 1);
/*!40000 ALTER TABLE `unit$deploy_package` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.unit_design: ~18 rows (approximately)
/*!40000 ALTER TABLE `unit_design` DISABLE KEYS */;
INSERT INTO `unit_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `across_resource_set`, `name`, `protocol`, `resource_set_design`, `state_code`, `subsys_design`, `unit_type`, `white_list_type`) VALUES
	('0039_0000000002', NULL, '0039_0000000002', 'umadmin', '2020-05-08 14:53:43', 'umadmin', '2020-05-07 17:27:15', 34, 'DEMO_CORE_APP', '2020-05-08 14:53:43', 'APP', '', 'N', '应用', 'TCP', '0019_0000000006', 'new', '0038_0000000002', '0002_0000000001', 'E'),
	('0039_0000000003', NULL, '0039_0000000003', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:08:14', 34, 'DEMO_CORE_LB', '2020-05-08 17:34:28', 'LB', '', 'N', '负载均衡', 'TCP', '0019_0000000007', 'new', '0038_0000000002', '0002_0000000004', 'N'),
	('0039_0000000004', NULL, '0039_0000000004', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:08:42', 34, 'DEMO_CORE_DB', '2020-05-08 17:34:28', 'DB', '', 'N', '数据库', 'TCP', '0019_0000000002', 'new', '0038_0000000002', '0002_0000000002', 'N'),
	('0039_0000000005', NULL, '0039_0000000005', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:09:11', 34, 'DEMO_CORE_REDIS', '2020-05-08 17:34:28', 'REDIS', '', 'N', '缓存', 'TCP', '0019_0000000003', 'new', '0038_0000000002', '0002_0000000003', 'N'),
	('0039_0000000006', NULL, '0039_0000000006', 'umadmin', '2020-05-08 17:34:29', 'umadmin', '2020-05-08 17:18:01', 34, 'DEMO_CLIENT_BROWER', '2020-05-08 17:34:28', 'BROWER', '', 'N', '浏览器客户端', 'TCP', '0019_0000000028', 'new', '0038_0000000003', '0002_0000000005', 'N'),
	('0039_0000000007', NULL, '0039_0000000007', 'umadmin', '2020-05-08 17:27:46', 'umadmin', '2020-05-08 17:27:46', 34, 'UM_SER_APP', NULL, 'APP', '', 'N', '应用', 'TCP', '0019_0000000006', 'new', '0038_0000000004', '0002_0000000001', 'E'),
	('0039_0000000008', NULL, '0039_0000000008', 'umadmin', '2020-05-08 17:28:18', 'umadmin', '2020-05-08 17:28:17', 34, 'UM_SER_LB', NULL, 'LB', '', 'N', '负载均衡', 'TCP', '0019_0000000007', 'new', '0038_0000000004', '0002_0000000004', 'N'),
	('0039_0000000009', NULL, '0039_0000000009', 'umadmin', '2020-05-08 17:30:04', 'umadmin', '2020-05-08 17:30:03', 34, 'UM_SER_DB', NULL, 'DB', '', 'N', '数据库', 'TCP', '0019_0000000002', 'new', '0038_0000000004', '0002_0000000002', 'N'),
	('0039_0000000010', NULL, '0039_0000000010', 'umadmin', '2020-05-20 15:48:35', 'umadmin', '2020-05-20 15:48:35', 34, 'aUM_SER_DB', NULL, 'DB', '', 'N', '数据库', 'TCP', '0019_0000000034', 'new', '0038_0000000005', '0002_0000000002', 'N'),
	('0039_0000000011', NULL, '0039_0000000011', 'umadmin', '2020-05-20 15:48:36', 'umadmin', '2020-05-20 15:48:35', 34, 'aUM_SER_LB', NULL, 'LB', '', 'N', '负载均衡', 'TCP', '0019_0000000036', 'new', '0038_0000000005', '0002_0000000004', 'N'),
	('0039_0000000012', NULL, '0039_0000000012', 'umadmin', '2020-05-20 15:48:36', 'umadmin', '2020-05-20 15:48:36', 34, 'aUM_SER_APP', NULL, 'APP', '', 'N', '应用', 'TCP', '0019_0000000037', 'new', '0038_0000000005', '0002_0000000001', 'E'),
	('0039_0000000013', NULL, '0039_0000000013', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:48:36', 34, 'aDEMO_CLIENT_BROWER', '2020-05-20 17:11:11', 'BROWER', '', 'N', '浏览器客户端', 'TCP', '0019_0000000046', 'new', '0038_0000000006', '0002_0000000009', 'N'),
	('0039_0000000014', NULL, '0039_0000000014', 'umadmin', '2020-05-20 17:11:13', 'umadmin', '2020-05-20 15:48:36', 34, 'aDEMO_CORE_REDIS', '2020-05-20 17:11:11', 'REDIS', '', 'N', '缓存', 'TCP', '0019_0000000035', 'new', '0038_0000000007', '0002_0000000003', 'N'),
	('0039_0000000015', NULL, '0039_0000000015', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:48:37', 34, 'aDEMO_CORE_DB', '2020-05-20 17:11:11', 'DB', '', 'N', '数据库', 'TCP', '0019_0000000034', 'new', '0038_0000000007', '0002_0000000002', 'N'),
	('0039_0000000016', NULL, '0039_0000000016', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:48:37', 34, 'aDEMO_CORE_LB', '2020-05-20 17:11:11', 'LB', '', 'N', '负载均衡', 'TCP', '0019_0000000036', 'new', '0038_0000000007', '0002_0000000004', 'N'),
	('0039_0000000017', NULL, '0039_0000000017', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:48:37', 34, 'aDEMO_CORE_APP', '2020-05-20 17:11:11', 'APP', '', 'N', '应用', 'TCP', '0019_0000000037', 'new', '0038_0000000007', '0002_0000000001', 'E'),
	('0039_0000000018', NULL, '0039_0000000018', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:50:02', 34, 'aDEMO_PROXY_NGINX', '2020-05-20 17:11:11', 'NGINX', '', 'N', '反向代理', 'TCP', '0019_0000000039', 'new', '0038_0000000008', '0002_0000000011', 'E'),
	('0039_0000000019', NULL, '0039_0000000019', 'umadmin', '2020-05-20 17:11:12', 'umadmin', '2020-05-20 15:50:02', 34, 'aDEMO_PROXY_ELB', '2020-05-20 17:11:11', 'ELB', '', 'N', '外网负载均衡', 'TCP', '0019_0000000041', 'new', '0038_0000000008', '0002_0000000004', 'N');
/*!40000 ALTER TABLE `unit_design` ENABLE KEYS */;

-- Dumping data for table wecmdb_bk.unit_type: ~12 rows (approximately)
/*!40000 ALTER TABLE `unit_type` DISABLE KEYS */;
INSERT INTO `unit_type` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `state`, `key_name`, `fixed_date`, `code`, `description`, `name`, `state_code`) VALUES
	('0002_0000000001', NULL, '0002_0000000001', 'umadmin', '2020-04-29 15:29:06', 'umadmin', '2020-04-11 22:09:37', 34, 'JAVA', NULL, 'JAVA', 'JAVA应用', 'JAVA', 'new'),
	('0002_0000000002', NULL, '0002_0000000002', 'umadmin', '2020-04-29 15:28:10', 'umadmin', '2020-04-11 22:09:52', 34, 'MYSQL', NULL, 'MYSQL', 'MYSQL数据库', 'MYSQL', 'new'),
	('0002_0000000003', NULL, '0002_0000000003', 'umadmin', '2020-04-29 15:28:09', 'umadmin', '2020-04-11 22:10:13', 34, 'REDIS', NULL, 'REDIS', 'REDIS缓存', 'REDIS', 'new'),
	('0002_0000000004', NULL, '0002_0000000004', 'umadmin', '2020-04-29 15:27:48', 'umadmin', '2020-04-11 22:10:53', 34, 'LB', NULL, 'LB', '负载均衡', 'LB', 'new'),
	('0002_0000000005', NULL, '0002_0000000005', 'umadmin', '2020-04-29 15:27:24', 'umadmin', '2020-04-11 22:11:32', 34, 'VDI', NULL, 'VDI', '虚拟桌面', 'VDI', 'new'),
	('0002_0000000006', NULL, '0002_0000000006', 'umadmin', '2020-04-29 15:27:15', 'umadmin', '2020-04-12 02:55:35', 34, 'SQUID', NULL, 'SQUID', 'SQUID代理', 'SQUID', 'new'),
	('0002_0000000008', NULL, '0002_0000000008', 'umadmin', '2020-04-29 15:27:00', 'umadmin', '2020-04-20 17:57:04', 34, 'BDP', NULL, 'BDP', '大数据应用', 'BDP', 'new'),
	('0002_0000000009', NULL, '0002_0000000009', 'umadmin', '2020-04-29 15:28:21', 'umadmin', '2020-04-22 18:51:53', 34, 'CLIENT', NULL, 'CLIENT', '客户端', 'CLIENT', 'new'),
	('0002_0000000010', NULL, '0002_0000000010', 'umadmin', '2020-04-29 15:28:53', 'umadmin', '2020-04-22 18:57:28', 34, 'OAP', NULL, 'OAP', '其他应用', 'OAP', 'new'),
	('0002_0000000011', NULL, '0002_0000000011', 'umadmin', '2020-04-23 15:14:10', 'umadmin', '2020-04-23 15:14:10', 34, 'NGINX', NULL, 'NGINX', 'NGINX', 'NGINX', 'new'),
	('0002_0000000012', NULL, '0002_0000000012', 'umadmin', '2020-04-23 15:22:35', 'umadmin', '2020-04-23 15:22:34', 34, 'DOCKER', NULL, 'DOCKER', 'DOCKER', 'DOCKER', 'new'),
	('0002_0000000013', NULL, '0002_0000000013', 'umadmin', '2020-04-23 15:22:35', 'umadmin', '2020-04-23 15:22:34', 34, 'COS', NULL, 'COS', 'COS', 'COS', 'new');

SET FOREIGN_KEY_CHECKS=1;

/*!40000 ALTER TABLE `unit_type` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;