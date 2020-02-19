SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `adm_user` (`id_adm_user`, `name`, `code`, `encrypted_password`, `description`, `id_adm_tenement`, `action_flag`, `is_system`) VALUES
	(2, 'Jordan Zhang', 'jordan', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Admin', NULL, NULL, NULL),
	(3, 'Monkey', 'monkey', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Developer', NULL, NULL, NULL),
	(4, 'Chaney Liu', 'chaneyliu', '$2a$10$N7CQen.5UtFbEIPBYWhfgOnAg73h0YbLQjr2ivVuEeDATghfuZea.', 'CMDB Architect', NULL, NULL, NULL);

INSERT INTO `adm_role_user` (`id_adm_role_user`, `id_adm_role`, `id_adm_user`, `is_system`) VALUES
	(2, 2, 2, 0),
	(3, 9, 3, 0),
	(4, 6, 4, 0);

INSERT INTO `adm_role_menu` (`id_adm_role_menu`, `id_adm_role`, `id_adm_menu`, `is_system`) VALUES
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
	
	
-- 正在导出表  wecmdb_embedded.business_app_instance 的数据：~20 rows (大约)
/*!40000 ALTER TABLE `business_app_instance` DISABLE KEYS */;
INSERT INTO `business_app_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `cpu`, `deploy_package`, `deploy_package_url`, `deploy_user_password`, `memory`, `resource_instance`, `storage`, `unit`, `unit_type`, `variable_values`, `lb_listener_asset_code`, `port`, `monitor_port`, `port_conflict`, `management_port`, `start_script`, `stop_script`, `deploy_script`, `deploy_user`, `deploy_backup_asset_code`, `regular_backup_asset_code`, `monitor_password`, `monitor_user`) VALUES
	('0014_0000000001', NULL, '0014_0000000001', NULL, '2019-12-30 03:45:52', NULL, '2019-12-24 04:08:53', 'WECUBE_PRD_CORE_APP_301', 40, '', '', '301', '1', NULL, '', '', '2', '0015_0000000009', '10', '0009_0000000009', 64, '', '', '8080', '28080', '0015_0000000009-8080', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('0014_0000000002', '0014_0000000021', '0014_0000000002', 'SYS_PLATFORM', '2020-01-15 09:16:37', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 42, NULL, '', 'DEMO2_APP1', '1', '0012_0000000037', 'http://localhost:9000/wecube-artifacts/692405b7701244e76962f725e307d543_demo-app-spring-boot_1.2.2.tar-202001151716.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,mock1234,,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000003', '0014_0000000019', '0014_0000000003', 'mockadmin', '2020-01-15 09:15:14', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_DEMO2_DB', 42, NULL, '', 'DEMO2_DB', '', '0012_0000000032', 'http://localhost:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar-202001141540.tar.gz', 'mock1234', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000004', NULL, '0014_0000000004', 'mockadmin', '2020-01-10 08:05:57', NULL, '2020-01-06 03:23:38', 'DEMO2_PRD_CORE_DLB_test', 40, '', '', 'test', '', '', '', '', '', '0015_0000000017', '', '0009_0000000036', 341, '=', '', '13306', '13306', '0015_0000000017-13306', NULL, NULL, NULL, NULL, 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000005', NULL, '0014_0000000005', NULL, '2020-01-08 03:31:40', NULL, '2020-01-06 04:37:43', 'DEMO2_PRD_CORE_ALB_demoapplb1', 40, '2020-01-06 04:38:14', '', 'demoapplb1', '', '', '', '', '', '0015_0000000018', '', '0009_0000000037', 340, '=', 'lbl-mlij8iw6', '8080', '8080', '0015_0000000018-8080', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('0014_0000000006', NULL, '0014_0000000006', 'SYS_PLATFORM', '2020-01-10 06:25:35', NULL, '2020-01-06 09:09:35', 'DEMO2_PRD_CORE_APP_DEMO2_APP2', 40, '', '', 'DEMO2_APP2', '', '0012_0000000022', 'http://localhost:9000/wecube-artifacts/b07f2ce4431323509204a7687e24267a_demo_jar_v1.5-202001061805.zip', '8cadf5b8ada285ead5082837cec5d450', '', '0015_0000000019', '', '0009_0000000034', 64, '1,path=,', '', '8081', '9151', '0015_0000000019-8081', '28081', NULL, NULL, NULL, 'DEMO2_PRD_CORE', NULL, NULL, NULL, NULL),
	('0014_0000000008', NULL, '0014_0000000002', NULL, '2020-01-06 10:40:48', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 40, '2020-01-06 07:48:16', '', 'DEMO2_APP1', '1', '0012_0000000018', 'http://localhost:9000/wecube-artifacts/32bc643b8d274acffce4a46af51ae80b_demo-app-spring-boot_0.0.11.tar-202001061548.tar.gz', '5617aae32df6841911fd28f4dff1c96d', '2', '0015_0000000013', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password=10.128.5.10,3306,8081,test,test,test', '', '8081', '28081', '0015_0000000013-8081', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('0014_0000000009', '0014_0000000008', '0014_0000000002', NULL, '2020-01-06 10:41:00', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 43, '2020-01-06 10:40:59', '', 'DEMO2_APP1', '1', '0012_0000000018', 'http://localhost:9000/wecube-artifacts/32bc643b8d274acffce4a46af51ae80b_demo-app-spring-boot_0.0.11.tar-202001061548.tar.gz', '5617aae32df6841911fd28f4dff1c96d', '2', '0015_0000000013', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password=10.128.5.10,3306,8081,test,test,test', '', '8081', '28081', '0015_0000000013-8081', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('0014_0000000010', NULL, '0014_0000000003', NULL, '2020-01-09 07:19:50', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_db_m', 40, '2020-01-09 07:19:50', '', 'db_m', '', '0012_0000000024', 'http://localhost:9000/wecube-artifacts/9611abbd5f0670e7cfe6911784a8dc9c_demo-app-spring-boot-db_0.0.3_fullload.sql', '20e2dbf3bf59ee346df85e6981135be9', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, NULL, NULL, NULL, 'DEMO2_CORE', NULL, NULL, NULL, NULL),
	('0014_0000000011', '0014_0000000010', '0014_0000000003', 'mockadmin', '2020-01-10 07:18:20', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_db_m', 41, '2020-01-10 07:18:20', '', 'db_m', '', '0012_0000000024', 'http://localhost:9000/wecube-artifacts/9611abbd5f0670e7cfe6911784a8dc9c_demo-app-spring-boot-db_0.0.3_fullload.sql', '20e2dbf3bf59ee346df85e6981135be9', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, NULL, NULL, NULL, 'DEMO2_CORE', NULL, NULL, NULL, NULL),
	('0014_0000000012', '0014_0000000011', '0014_0000000003', 'SYS_PLATFORM', '2020-01-13 07:49:19', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_DEMO2_DB', 42, '2020-01-13 07:49:19', '', 'DEMO2_DB', '', '0012_0000000032', 'http://localhost:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar-202001131549.tar.gz', 'mock1234', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000013', '0014_0000000012', '0014_0000000003', 'mockadmin', '2020-01-13 08:52:03', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_DEMO2_DB', 41, '2020-01-13 08:52:02', '', 'DEMO2_DB', '', '0012_0000000032', 'http://localhost:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar-202001131549.tar.gz', 'mock1234', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000014', '0014_0000000009', '0014_0000000002', 'SYS_PLATFORM', '2020-01-13 08:53:37', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 42, '2020-01-13 07:03:22', '', 'DEMO2_APP1', '1', '0012_0000000023', 'http://localhost:9000/wecube-artifacts/576bab7c54e9e332803bc4fd5ea1c64f_demo-app-spring-boot_1.1.0.tar-202001131154.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_prometheus_exporter_port,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,mock1234,,9151,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000015', '0014_0000000014', '0014_0000000002', 'mockadmin', '2020-01-13 08:54:43', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 41, '2020-01-13 08:54:43', '', 'DEMO2_APP1', '1', '0012_0000000023', 'http://localhost:9000/wecube-artifacts/576bab7c54e9e332803bc4fd5ea1c64f_demo-app-spring-boot_1.1.0.tar-202001131154.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_prometheus_exporter_port,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,mock1234,,9151,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000016', '0014_0000000015', '0014_0000000002', 'SYS_PLATFORM', '2020-01-13 08:57:14', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 42, '2020-01-13 08:57:13', '', 'DEMO2_APP1', '1', '0012_0000000023', 'http://localhost:9000/wecube-artifacts/576bab7c54e9e332803bc4fd5ea1c64f_demo-app-spring-boot_1.1.0.tar-202001131656.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_prometheus_exporter_port,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,xxxxxx,,9151,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000017', '0014_0000000016', '0014_0000000002', 'mockadmin', '2020-01-13 09:18:14', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 41, '2020-01-13 09:18:14', '', 'DEMO2_APP1', '1', '0012_0000000023', 'http://localhost:9000/wecube-artifacts/576bab7c54e9e332803bc4fd5ea1c64f_demo-app-spring-boot_1.1.0.tar-202001131656.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_prometheus_exporter_port,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,xxxxxx,,9151,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.1.0/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000018', '0014_0000000013', '0014_0000000003', 'SYS_PLATFORM', '2020-01-15 02:58:16', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_DEMO2_DB', 42, '2020-01-14 07:41:02', '', 'DEMO2_DB', '', '0012_0000000032', 'http://localhost:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar-202001141540.tar.gz', 'mock1234', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000019', '0014_0000000018', '0014_0000000003', 'mockadmin', '2020-01-15 09:06:30', NULL, '2020-01-06 02:49:15', 'DEMO2_PRD_CORE_DB_DEMO2_DB', 41, '2020-01-15 09:06:30', '', 'DEMO2_DB', '', '0012_0000000032', 'http://localhost:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar-202001141540.tar.gz', 'mock1234', '', '0015_0000000020', '', '0009_0000000035', 66, '=', '', '3306', '3306', '0015_0000000020-3306', NULL, 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000020', '0014_0000000017', '0014_0000000002', 'SYS_PLATFORM', '2020-01-15 09:05:37', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 42, '2020-01-15 02:58:40', '', 'DEMO2_APP1', '1', '0012_0000000037', 'http://localhost:9000/wecube-artifacts/692405b7701244e76962f725e307d543_demo-app-spring-boot_1.2.2.tar-202001151058.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,mock1234,,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE'),
	('0014_0000000021', '0014_0000000020', '0014_0000000002', 'mockadmin', '2020-01-15 09:07:07', NULL, '2020-01-03 04:54:38', 'DEMO2_PRD_CORE_APP_DEMO2_APP1', 41, '2020-01-15 09:07:07', '', 'DEMO2_APP1', '1', '0012_0000000037', 'http://localhost:9000/wecube-artifacts/692405b7701244e76962f725e307d543_demo-app-spring-boot_1.2.2.tar-202001151058.tar.gz', '{cipher_a}3708e2fae9885f558000f5f785b9749e', '2', '0015_0000000014', '10', '0009_0000000034', 64, 'db_host_ip,db_host_port,port,db_name,db_username,db_password,1,jmx_port=10.128.5.10,3306,8081,DEMO2_DB,DEMO2_CORE,mock1234,,9151', '', '8081', '9151', '0015_0000000014-8081', '28081', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/start.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/stop.sh', '/data/DEMO2_PRD_CORE_APP/demo-app-spring-boot_1.2.2/bin/deploy.sh', 'DEMO2_CORE', NULL, NULL, 'DEMO2_CORE', 'DEMO2_CORE');
/*!40000 ALTER TABLE `business_app_instance` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.business_zone 的数据：~25 rows (大约)
/*!40000 ALTER TABLE `business_zone` DISABLE KEYS */;
INSERT INTO `business_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `dcn_design`, `name`, `network_zone`, `network_segment`) VALUES
	('0021_0000000001', NULL, '0021_0000000001', NULL, '2019-12-24 12:27:07', NULL, '2019-12-16 02:21:25', 'GZP3_SF_BZa', 37, '', '', 'BZa', '0028_0000000001', '', '0019_0000000011', '0023_0000000127'),
	('0021_0000000002', NULL, '0021_0000000002', NULL, '2019-12-24 08:08:54', NULL, '2019-12-17 17:56:20', 'GZP3_SF_BZb', 37, '', '', 'BZb', '0028_0000000002', '', '0019_0000000011', '0023_0000000125'),
	('0021_0000000003', NULL, '0021_0000000003', NULL, '2019-12-24 12:27:16', NULL, '2019-12-17 17:56:31', 'GZP3_SF_CS', 37, '', '', 'CS', '0028_0000000004', '', '0019_0000000011', '0023_0000000123'),
	('0021_0000000004', NULL, '0021_0000000004', NULL, '2019-12-24 08:08:54', NULL, '2019-12-17 17:56:48', 'GZP3_DMZ_BZa', 37, '', '', 'BZa', '0028_0000000003', '', '0019_0000000012', '0023_0000000119'),
	('0021_0000000005', NULL, '0021_0000000005', NULL, '2019-12-24 08:07:51', NULL, '2019-12-17 17:57:12', 'GZP3_DMZ_BZb', 37, '', '', 'BZb', '0028_0000000006', '', '0019_0000000012', '0023_0000000117'),
	('0021_0000000006', NULL, '0021_0000000006', NULL, '2019-12-24 08:07:51', NULL, '2019-12-17 17:57:25', 'GZP3_ECN_BZa', 37, '', '', 'BZa', '0028_0000000007', '', '0019_0000000013', '0023_0000000115'),
	('0021_0000000007', NULL, '0021_0000000007', NULL, '2019-12-24 08:07:51', NULL, '2019-12-17 17:57:39', 'GZP3_ECN_BZb', 37, '', '', 'BZb', '0028_0000000008', '', '0019_0000000013', '0023_0000000113'),
	('0021_0000000008', NULL, '0021_0000000008', NULL, '2019-12-24 08:07:51', NULL, '2019-12-17 17:57:53', 'GZP3_MGMT_MT', 37, '', '', 'MT', '0028_0000000005', '', '0019_0000000014', '0023_0000000121'),
	('0021_0000000009', NULL, '0021_0000000009', NULL, '2019-12-24 08:07:51', NULL, '2019-12-17 18:01:28', 'GZP3_MGMT_QZ', 37, '', '', 'QZ', '0028_0000000013', '', '0019_0000000014', '0023_0000000111'),
	('0021_0000000010', NULL, '0021_0000000010', NULL, '2019-12-24 10:29:33', NULL, '2019-12-17 18:01:51', 'NDC_WAN_ALL', 37, '', '', 'ALL', '0028_0000000010', '', '0019_0000000005', '0023_0000000129'),
	('0021_0000000011', NULL, '0021_0000000011', NULL, '2019-12-24 08:07:51', NULL, '2019-12-17 18:02:06', 'NDC_OPN_ALL', 37, '', '', 'ALL', '0028_0000000012', '', '0019_0000000006', '0023_0000000130'),
	('0021_0000000021', NULL, '0021_0000000021', NULL, '2019-12-24 08:07:51', NULL, '2019-12-21 11:26:12', 'GZP3_MGMT_CS', 37, '', '', 'CS', '0028_0000000015', '', '0019_0000000014', '0023_0000000109'),
	('0021_0000000022', NULL, '0021_0000000022', NULL, '2019-12-24 08:07:51', NULL, '2019-12-21 11:38:13', 'GZP3_ECN_CS', 37, '', '', 'CS', '0028_0000000017', '', '0019_0000000013', '0023_0000000107'),
	('0021_0000000023', NULL, '0021_0000000023', NULL, '2019-12-24 08:07:51', NULL, '2019-12-21 11:38:27', 'GZP3_DMZ_CS', 37, '', '', 'CS', '0028_0000000016', '', '0019_0000000012', '0023_0000000105'),
	('0021_0000000024', NULL, '0021_0000000024', NULL, '2019-12-24 12:27:16', NULL, '2019-12-24 08:09:34', 'GZP4_SF_CS', 37, '', '', 'CS', '0028_0000000004', '', '0019_0000000015', '0023_0000000124'),
	('0021_0000000025', NULL, '0021_0000000025', NULL, '2019-12-24 12:27:07', NULL, '2019-12-24 08:10:00', 'GZP4_SF_BZa', 37, '', '', 'BZa', '0028_0000000001', '', '0019_0000000015', '0023_0000000128'),
	('0021_0000000026', NULL, '0021_0000000026', NULL, '2019-12-24 08:11:26', NULL, '2019-12-24 08:11:26', 'GZP4_SF_BZb', 37, '', '', 'BZb', '0028_0000000002', '', '0019_0000000015', '0023_0000000126'),
	('0021_0000000027', NULL, '0021_0000000027', NULL, '2019-12-24 08:13:04', NULL, '2019-12-24 08:13:04', 'GZP4_DMZ_CS', 37, '', '', 'CS', '0028_0000000016', '', '0019_0000000016', '0023_0000000106'),
	('0021_0000000028', NULL, '0021_0000000028', NULL, '2019-12-24 08:13:17', NULL, '2019-12-24 08:13:17', 'GZP4_DMZ_BZa', 37, '', '', 'BZa', '0028_0000000003', '', '0019_0000000016', '0023_0000000120'),
	('0021_0000000029', NULL, '0021_0000000029', NULL, '2019-12-24 08:13:28', NULL, '2019-12-24 08:13:28', 'GZP4_DMZ_BZb', 37, '', '', 'BZb', '0028_0000000006', '', '0019_0000000016', '0023_0000000118'),
	('0021_0000000030', NULL, '0021_0000000030', NULL, '2019-12-24 08:13:39', NULL, '2019-12-24 08:13:39', 'GZP4_ECN_CS', 37, '', '', 'CS', '0028_0000000017', '', '0019_0000000017', '0023_0000000108'),
	('0021_0000000031', NULL, '0021_0000000031', NULL, '2019-12-24 08:13:50', NULL, '2019-12-24 08:13:50', 'GZP4_ECN_BZa', 37, '', '', 'BZa', '0028_0000000007', '', '0019_0000000017', '0023_0000000116'),
	('0021_0000000032', NULL, '0021_0000000032', NULL, '2019-12-24 08:17:05', NULL, '2019-12-24 08:17:04', 'GZP4_ECN_BZb', 37, '', '', 'BZb', '0028_0000000008', '', '0019_0000000017', '0023_0000000114'),
	('0021_0000000033', NULL, '0021_0000000033', NULL, '2019-12-24 08:17:23', NULL, '2019-12-24 08:17:23', 'GZP4_MGMT_CS', 37, '', '', 'CS', '0028_0000000015', '', '0019_0000000018', '0023_0000000110'),
	('0021_0000000034', NULL, '0021_0000000034', NULL, '2019-12-24 08:17:35', NULL, '2019-12-24 08:17:35', 'GZP4_MGMT_MT', 37, '', '', 'MT', '0028_0000000005', '', '0019_0000000018', '0023_0000000122'),
	('0021_0000000035', NULL, '0021_0000000035', NULL, '2019-12-24 08:17:50', NULL, '2019-12-24 08:17:50', 'GZP4_MGMT_QZ', 37, '', '', 'QZ', '0028_0000000013', '', '0019_0000000018', '0023_0000000112');
/*!40000 ALTER TABLE `business_zone` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.business_zone_design 的数据：~15 rows (大约)
/*!40000 ALTER TABLE `business_zone_design` DISABLE KEYS */;
INSERT INTO `business_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `network_zone_design`, `network_segment_design`) VALUES
	('0028_0000000001', NULL, '0028_0000000001', NULL, '2019-12-24 12:27:07', NULL, '2019-12-24 12:24:35', 'V1_SF_BZa', 34, '', '', 'BZa', '0026_0000000001', '0030_0000000011'),
	('0028_0000000002', NULL, '0028_0000000002', NULL, '2019-12-24 08:03:18', NULL, '2019-12-16 01:56:47', 'V1_SF_BZb', 34, '', '', 'BZb', '0026_0000000001', '0030_0000000012'),
	('0028_0000000003', NULL, '0028_0000000003', NULL, '2019-12-24 08:03:18', NULL, '2019-12-16 02:01:43', 'V1_DMZ_BZa', 34, '', '', 'BZa', '0026_0000000003', '0030_0000000015'),
	('0028_0000000004', NULL, '0028_0000000004', NULL, '2019-12-24 12:27:16', NULL, '2019-12-24 12:23:11', 'V1_SF_CS', 34, '', '', 'CS', '0026_0000000001', '0030_0000000013'),
	('0028_0000000005', NULL, '0028_0000000005', NULL, '2019-12-24 08:03:18', NULL, '2019-12-16 03:30:17', 'V1_MGMT_MT', 34, '', '', 'MT', '0026_0000000002', '0030_0000000014'),
	('0028_0000000006', NULL, '0028_0000000006', NULL, '2019-12-24 08:02:19', NULL, '2019-12-16 03:31:33', 'V1_DMZ_BZb', 34, '', '', 'BZb', '0026_0000000003', '0030_0000000016'),
	('0028_0000000007', NULL, '0028_0000000007', NULL, '2019-12-24 08:02:19', NULL, '2019-12-16 03:32:53', 'V1_ECN_BZa', 34, '', '', 'BZa', '0026_0000000004', '0030_0000000017'),
	('0028_0000000008', NULL, '0028_0000000008', NULL, '2019-12-24 08:02:18', NULL, '2019-12-16 03:33:21', 'V1_ECN_BZb', 34, '', '', 'BZb', '0026_0000000004', '0030_0000000018'),
	('0028_0000000010', NULL, '0028_0000000010', NULL, '2019-12-24 08:02:18', NULL, '2019-12-16 03:40:36', 'V1_WAN_ALL', 34, '', '', 'ALL', '0026_0000000006', '0030_0000000069'),
	('0028_0000000011', NULL, '0028_0000000011', NULL, '2019-12-24 08:02:18', NULL, '2019-12-16 03:41:45', 'V1_PTN_ALL', 34, '', '', 'ALL', '0026_0000000008', '0030_0000000021'),
	('0028_0000000012', NULL, '0028_0000000012', NULL, '2019-12-24 08:02:18', NULL, '2019-12-16 03:42:34', 'V1_OPN_ALL', 34, '', '', 'ALL', '0026_0000000007', '0030_0000000022'),
	('0028_0000000013', NULL, '0028_0000000013', NULL, '2019-12-24 08:02:18', NULL, '2019-12-16 09:38:10', 'V1_MGMT_QZ', 34, '', '', 'QZ', '0026_0000000002', '0030_0000000041'),
	('0028_0000000015', NULL, '0028_0000000015', NULL, '2019-12-24 08:02:18', NULL, '2019-12-21 09:11:40', 'V1_MGMT_CS', 34, '', '', 'CS', '0026_0000000002', '0030_0000000065'),
	('0028_0000000016', NULL, '0028_0000000016', NULL, '2019-12-24 08:02:18', NULL, '2019-12-21 09:14:40', 'V1_DMZ_CS', 34, '', '', 'CS', '0026_0000000003', '0030_0000000067'),
	('0028_0000000017', NULL, '0028_0000000017', NULL, '2019-12-24 08:02:18', NULL, '2019-12-21 09:14:52', 'V1_ECN_CS', 34, '', '', 'CS', '0026_0000000004', '0030_0000000066');
/*!40000 ALTER TABLE `business_zone_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.business_zone_design$business_group 的数据：~31 rows (大约)
/*!40000 ALTER TABLE `business_zone_design$business_group` DISABLE KEYS */;
INSERT INTO `business_zone_design$business_group` (`id`, `from_guid`, `to_code`, `seq_no`) VALUES
	(111, '0028_0000000017', 58, 1),
	(112, '0028_0000000017', 59, 2),
	(113, '0028_0000000017', 267, 3),
	(114, '0028_0000000016', 58, 2),
	(115, '0028_0000000016', 59, 1),
	(116, '0028_0000000016', 267, 3),
	(117, '0028_0000000015', 254, 1),
	(118, '0028_0000000013', 58, 1),
	(119, '0028_0000000013', 267, 4),
	(120, '0028_0000000013', 59, 2),
	(121, '0028_0000000013', 254, 3),
	(122, '0028_0000000012', 59, 2),
	(123, '0028_0000000012', 58, 1),
	(124, '0028_0000000012', 254, 3),
	(125, '0028_0000000012', 267, 4),
	(126, '0028_0000000011', 59, 2),
	(127, '0028_0000000011', 267, 3),
	(128, '0028_0000000011', 58, 1),
	(129, '0028_0000000010', 58, 1),
	(130, '0028_0000000010', 59, 2),
	(131, '0028_0000000010', 267, 3),
	(132, '0028_0000000008', 59, 1),
	(133, '0028_0000000007', 58, 1),
	(137, '0028_0000000006', 59, 1),
	(159, '0028_0000000005', 254, 1),
	(163, '0028_0000000003', 58, 1),
	(164, '0028_0000000002', 59, 1),
	(174, '0028_0000000001', 58, 1),
	(175, '0028_0000000004', 58, 1),
	(176, '0028_0000000004', 267, 3),
	(177, '0028_0000000004', 59, 2);
/*!40000 ALTER TABLE `business_zone_design$business_group` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.data_center 的数据：~4 rows (大约)
/*!40000 ALTER TABLE `data_center` DISABLE KEYS */;
INSERT INTO `data_center` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `auth_parameter`, `data_center_design`, `name`, `user_id`, `data_center_type`, `regional_data_center`) VALUES
	('0018_0000000001', NULL, '0018_0000000001', NULL, '2019-12-23 06:56:45', NULL, '2019-12-16 02:16:06', 'GZP3', 37, '', '', 'GZP3', 'Region=ap-guangzhou;AvailableZone=ap-guangzhou-3;SecretID=SecretID;SecretKey=SecretKey', '0025_0000000001', '广州生产3机房', '100011082855', 337, '0018_0000000004'),
	('0018_0000000002', NULL, '0018_0000000002', NULL, '2019-12-27 03:25:36', NULL, '2019-12-17 17:37:39', 'NDC', 37, '', '', 'NDC', '111', '0025_0000000001', '广域网机房', '111', 336, NULL),
	('0018_0000000003', NULL, '0018_0000000003', NULL, '2019-12-23 06:56:45', NULL, '2019-12-18 07:08:21', 'GZP4', 37, '', '', 'GZP4', 'Region=ap-guangzhou;AvailableZone=ap-guangzhou-4;SecretID=SecretID;SecretKey=SecretKey', '0025_0000000001', '广州生产4机房', '100011082855', 337, '0018_0000000004'),
	('0018_0000000004', NULL, '0018_0000000004', NULL, '2019-12-27 07:42:39', NULL, '2019-12-21 09:56:49', 'GZP', 37, '2019-12-27 07:39:05', '', 'GZP', 'Region=ap-guangzhou;SecretID=SecretID;SecretKey=SecretKey', '0025_0000000001', '广州生产机房', '100011082855', 336, '');
/*!40000 ALTER TABLE `data_center` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.data_center$deploy_environment 的数据：~12 rows (大约)
/*!40000 ALTER TABLE `data_center$deploy_environment` DISABLE KEYS */;
INSERT INTO `data_center$deploy_environment` (`id`, `from_guid`, `to_code`, `seq_no`) VALUES
	(51, '0018_0000000003', 70, 2),
	(52, '0018_0000000003', 71, 3),
	(53, '0018_0000000003', 69, 1),
	(54, '0018_0000000003', 72, 4),
	(55, '0018_0000000001', 71, 3),
	(56, '0018_0000000001', 70, 2),
	(57, '0018_0000000001', 72, 4),
	(58, '0018_0000000001', 69, 1),
	(63, '0018_0000000004', 70, 2),
	(64, '0018_0000000004', 69, 1),
	(65, '0018_0000000002', 70, 2),
	(66, '0018_0000000002', 69, 1);
/*!40000 ALTER TABLE `data_center$deploy_environment` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.data_center_design 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `data_center_design` DISABLE KEYS */;
INSERT INTO `data_center_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `name`) VALUES
	('0025_0000000001', NULL, '0025_0000000001', NULL, '2019-12-16 13:34:46', NULL, '2019-12-15 15:16:17', 'V1', 34, '', '', 'V1', '业务机房版本1');
/*!40000 ALTER TABLE `data_center_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.default_security_policy 的数据：~18 rows (大约)
/*!40000 ALTER TABLE `default_security_policy` DISABLE KEYS */;
INSERT INTO `default_security_policy` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `network_segment`, `security_policy_type`, `security_policy_action`, `protocol`, `port`, `vpc_network_zone`) VALUES
	('0038_0000000001', NULL, '0038_0000000001', NULL, '2020-01-02 06:16:16', NULL, '2019-12-25 10:27:34', 'GZP_SF_to_GZ3P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:16', '监控和运维管理', 'GZP_SF_to_GZ3P-MGMT-MT-APP_入站规则', '0023_0000000033', 383, 386, 361, 'all', '0019_0000000001'),
	('0038_0000000002', NULL, '0038_0000000002', NULL, '2020-01-02 06:16:17', NULL, '2019-12-25 12:47:38', 'GZP_DMZ_to_GZ3P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:16', '监控和运维管理', 'GZP_DMZ_to_GZ3P-MGMT-MT-APP_入站规则', '0023_0000000033', 383, 386, 361, 'all', '0019_0000000002'),
	('0038_0000000003', NULL, '0038_0000000003', NULL, '2020-01-02 06:16:18', NULL, '2019-12-25 12:51:52', 'GZP_ECN_to_GZ3P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:17', '监控和运维管理', 'GZP_ECN_to_GZ3P-MGMT-MT-APP_入站规则', '0023_0000000033', 383, 386, 361, 'all', '0019_0000000003'),
	('0038_0000000025', NULL, '0038_0000000025', NULL, '2020-01-10 02:46:30', NULL, '2019-12-25 15:24:38', 'GZP_MGMT_to_GZ3P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:18', '监控和运维管理', 'GZP_MGMT_to_GZ3P-MGMT-MT-APP_入站规则', '0023_0000000033', 383, 386, 361, 'all', '0019_0000000004'),
	('0038_0000000026', NULL, '0038_0000000026', NULL, '2020-01-02 06:16:19', NULL, '2019-12-25 15:25:16', 'GZP_SF_to_GZ4P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:19', '监控和运维管理', 'GZP_SF_to_GZ4P-MGMT-MT-APP_入站规则', '0023_0000000076', 383, 386, 361, 'all', '0019_0000000001'),
	('0038_0000000027', NULL, '0038_0000000027', NULL, '2020-01-02 06:16:20', NULL, '2019-12-25 15:25:40', 'GZP_DMZ_to_GZ4P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:20', '监控和运维管理', 'GZP_DMZ_to_GZ4P-MGMT-MT-APP_入站规则', '0023_0000000076', 383, 386, 361, 'all', '0019_0000000002'),
	('0038_0000000028', NULL, '0038_0000000028', NULL, '2020-01-02 06:16:23', NULL, '2019-12-25 15:25:58', 'GZP_ECN_to_GZ4P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:23', '监控和运维管理', 'GZP_ECN_to_GZ4P-MGMT-MT-APP_入站规则', '0023_0000000076', 383, 386, 361, 'all', '0019_0000000003'),
	('0038_0000000029', NULL, '0038_0000000029', NULL, '2020-01-02 06:16:22', NULL, '2019-12-25 15:26:15', 'GZP_MGMT_to_GZ4P-MGMT-MT-APP_入站规则', 37, '2020-01-02 06:16:21', '监控和运维管理', 'GZP_MGMT_to_GZ4P-MGMT-MT-APP_入站规则', '0023_0000000076', 383, 386, 361, 'all', '0019_0000000004'),
	('0038_0000000030', NULL, '0038_0000000030', NULL, '2020-01-02 06:16:36', NULL, '2019-12-25 17:20:14', 'GZP_SF_to_GZ-SF_入站规则', 37, '2020-01-02 06:16:35', '同网络区域内部互通', 'GZP_SF_to_GZ-SF_入站规则', '0023_0000000003', 383, 386, 361, 'all', '0019_0000000001'),
	('0038_0000000031', NULL, '0038_0000000031', NULL, '2020-01-02 06:16:33', NULL, '2019-12-25 17:20:47', 'GZP_SF_to_GZ-SF_出站规则', 37, '2020-01-02 06:16:32', '同网络区域内部互通', 'GZP_SF_to_GZ-SF_出站规则', '0023_0000000003', 384, 386, 361, 'all', '0019_0000000001'),
	('0038_0000000032', NULL, '0038_0000000032', NULL, '2020-01-02 06:16:32', NULL, '2019-12-25 17:23:31', 'GZP_MGMT_to_GZ-MGMT_入站规则', 37, '2020-01-02 06:16:32', '同网络区域内部互通', 'GZP_MGMT_to_GZ-MGMT_入站规则', '0023_0000000031', 383, 386, 361, 'all', '0019_0000000004'),
	('0038_0000000033', NULL, '0038_0000000033', NULL, '2020-01-02 06:16:31', NULL, '2019-12-25 17:24:02', 'GZP_MGMT_to_GZ-MGMT_出站规则', 37, '2020-01-02 06:16:31', '同网络区域内部互通', 'GZP_MGMT_to_GZ-MGMT_出站规则', '0023_0000000031', 384, 386, 361, 'all', '0019_0000000004'),
	('0038_0000000034', NULL, '0038_0000000034', NULL, '2020-01-02 06:16:31', NULL, '2019-12-25 17:24:29', 'GZP_DMZ_to_GZ-DMZ_入站规则', 37, '2020-01-02 06:16:30', '同网络区域内部互通', 'GZP_DMZ_to_GZ-DMZ_入站规则', '0023_0000000017', 383, 386, 361, 'all', '0019_0000000002'),
	('0038_0000000035', NULL, '0038_0000000035', NULL, '2020-01-02 06:16:30', NULL, '2019-12-25 17:24:45', 'GZP_DMZ_to_GZ-DMZ_出站规则', 37, '2020-01-02 06:16:29', '同网络区域内部互通', 'GZP_DMZ_to_GZ-DMZ_出站规则', '0023_0000000017', 384, 386, 361, 'all', '0019_0000000002'),
	('0038_0000000036', NULL, '0038_0000000036', NULL, '2020-01-02 06:16:29', NULL, '2019-12-25 17:25:04', 'GZP_ECN_to_GZ-ECN_入站规则', 37, '2020-01-02 06:16:28', '同网络区域内部互通', 'GZP_ECN_to_GZ-ECN_入站规则', '0023_0000000024', 383, 386, 361, 'all', '0019_0000000003'),
	('0038_0000000037', NULL, '0038_0000000037', NULL, '2020-01-10 02:46:30', NULL, '2019-12-25 17:25:28', 'GZP_ECN_to_GZ-ECN_出站规则', 37, '2020-01-02 06:16:28', '同网络区域内部互通', 'GZP_ECN_to_GZ-ECN_出站规则', '0023_0000000024', 384, 386, 361, 'all', '0019_0000000003'),
	('0038_0000000038', NULL, '0038_0000000038', NULL, '2020-01-02 06:16:27', NULL, '2019-12-25 18:07:26', 'GZP_DMZ_to_WAN_入站规则', 37, '2020-01-02 06:16:27', '互联网客户端范围', 'GZP_DMZ_to_WAN_入站规则', '0023_0000000082', 383, 386, 361, '8080-18080', '0019_0000000002'),
	('0038_0000000039', NULL, '0038_0000000039', NULL, '2020-01-02 06:16:26', NULL, '2019-12-25 18:08:43', 'GZP_MGMT_to_NDC-OPN_入站规则', 37, '2020-01-02 06:16:26', '登陆运营桌面', 'GZP_MGMT_to_NDC-OPN_入站规则', '0023_0000000041', 383, 386, 361, '3309', '0019_0000000004');
/*!40000 ALTER TABLE `default_security_policy` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.deploy_package 的数据：~8 rows (大约)
/*!40000 ALTER TABLE `deploy_package` DISABLE KEYS */;
INSERT INTO `deploy_package` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `absolute_deploy_file_path`, `absolute_start_file_path`, `absolute_stop_file_path`, `deploy_file_path`, `deploy_package_url`, `deploy_path`, `deploy_user`, `diff_conf_file`, `is_decompression`, `md5_value`, `name`, `start_file_path`, `stop_file_path`, `unit_design`, `upload_time`, `upload_user`) VALUES
	('0012_0000000022', NULL, '0012_0000000022', 'SYS_PLATFORM', '2020-01-10 06:25:35', 'admin', '2020-01-06 09:55:50', 'demo_jar_v1.5.zip', 34, NULL, 'demo_jar_v1.5.zip', NULL, '/data/app/demo_jar_v1.5/start.sh', '/data/app/demo_jar_v1.5/start.sh', '/data/app/demo_jar_v1.5/stop.sh', 'demo_jar_v1.5/start.sh', 'http://localhost:9000/wecube-artifacts/b07f2ce4431323509204a7687e24267a_demo_jar_v1.5.zip', '/data/app/', '0013_0000000001', 'demo_jar_v1.5/start.sh', 'true', 'b07f2ce4431323509204a7687e24267a', 'demo_jar_v1.5.zip', 'demo_jar_v1.5/start.sh', 'demo_jar_v1.5/stop.sh', '0003_0000000029', '2020-01-06 09:55:50', 'admin'),
	('0012_0000000023', NULL, '0012_0000000023', 'SYS_PLATFORM', '2020-01-10 06:59:27', 'admin', '2020-01-06 10:23:36', 'demo-app-spring-boot_1.1.0.tar.gz', 34, NULL, 'demo-app-spring-boot_1.1.0.tar.gz', NULL, '/data/app/demo-app-spring-boot/demo-app-spring-boot_1.1.0/bin/deploy.sh', '/data/app/demo-app-spring-boot/demo-app-spring-boot_1.1.0/bin/start.sh', '/data/app/demo-app-spring-boot/demo-app-spring-boot_1.1.0/bin/stop.sh', 'demo-app-spring-boot_1.1.0/bin/deploy.sh', 'http://localhost:9000/wecube-artifacts/576bab7c54e9e332803bc4fd5ea1c64f_demo-app-spring-boot_1.1.0.tar.gz', '/data/app/demo-app-spring-boot/', '0013_0000000001', 'demo-app-spring-boot_1.1.0/bin/deploy.sh|/demo-app-spring-boot_1.1.0/bin/start.sh|/demo-app-spring-boot_1.1.0/conf/application-prod.properties', 'true', '576bab7c54e9e332803bc4fd5ea1c64f', 'demo-app-spring-boot_1.1.0.tar.gz', 'demo-app-spring-boot_1.1.0/bin/start.sh', 'demo-app-spring-boot_1.1.0/bin/stop.sh', '0003_0000000029', '2020-01-06 10:23:35', 'admin'),
	('0012_0000000030', NULL, '0012_0000000030', 'mockadmin', '2020-01-10 08:15:42', 'mockadmin', '2020-01-10 08:12:13', 'demo-app-spring-boot-db_1.0.0.tar.gz', 34, NULL, 'demo-app-spring-boot-db_1.0.0.tar.gz', NULL, NULL, NULL, NULL, 'demo-app-spring-boot-db_1.0.0/full-load/demo-app-spring-boot-db_fullload.sql', 'http://localhost:9000/wecube-artifacts/59c876cb62ea0bc67b21e0e86dd44665_demo-app-spring-boot-db_1.0.0.tar.gz', NULL, NULL, 'demo-app-spring-boot-db_1.0.0/full-load/demo-app-spring-boot-db_fullload.sql', NULL, '59c876cb62ea0bc67b21e0e86dd44665', 'demo-app-spring-boot-db_1.0.0.tar.gz', 'demo-app-spring-boot-db_1.0.0/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.0/increment/demo-app-spring-boot-db_rollback.sql', '0003_0000000030', '2020-01-10 08:12:13', 'mockadmin'),
	('0012_0000000032', NULL, '0012_0000000032', 'mockadmin', '2020-01-13 07:46:21', 'mockadmin', '2020-01-10 08:16:21', 'demo-app-spring-boot-db_1.0.1.tar.gz', 34, NULL, 'demo-app-spring-boot-db_1.0.1.tar.gz', NULL, NULL, NULL, NULL, 'demo-app-spring-boot-db_1.0.1/full-load/demo-app-spring-boot-db_fullload.sql', 'http://localhost:9000/wecube-artifacts/d502c4127f7c3cc6fb7a060eab1e31bb_demo-app-spring-boot-db_1.0.1.tar.gz', NULL, NULL, '', NULL, 'd502c4127f7c3cc6fb7a060eab1e31bb', 'demo-app-spring-boot-db_1.0.1.tar.gz', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_increment.sql', 'demo-app-spring-boot-db_1.0.1/increment/demo-app-spring-boot-db_rollback.sql', '0003_0000000030', '2020-01-10 08:16:20', 'mockadmin'),
	('0012_0000000034', NULL, '0012_0000000034', 'SYS_PLATFORM', '2020-01-14 05:03:15', 'mockadmin', '2020-01-13 09:22:55', 'demo-app-spring-boot_1.1.1.tar.gz', 34, NULL, 'demo-app-spring-boot_1.1.1.tar.gz', NULL, NULL, NULL, NULL, 'demo-app-spring-boot_1.1.1/bin/deploy.sh', 'http://localhost:9000/wecube-artifacts/084202baba1c5c485f6d2bcdd6f4b362_demo-app-spring-boot_1.1.1.tar.gz', NULL, NULL, 'demo-app-spring-boot_1.1.1/bin/deploy.sh|/demo-app-spring-boot_1.1.1/bin/start.sh|/demo-app-spring-boot_1.1.1/conf/application-prod.properties', NULL, '084202baba1c5c485f6d2bcdd6f4b362', 'demo-app-spring-boot_1.1.1.tar.gz', 'demo-app-spring-boot_1.1.1/bin/start.sh', 'demo-app-spring-boot_1.1.1/bin/stop.sh', '0003_0000000029', '2020-01-13 09:22:54', 'mockadmin'),
	('0012_0000000035', NULL, '0012_0000000035', 'mockadmin', '2020-01-14 06:44:04', 'mockadmin', '2020-01-13 12:07:53', 'demo-app-spring-boot_1.2.0.tar.gz', 34, NULL, 'demo-app-spring-boot_1.2.0.tar.gz', NULL, NULL, NULL, NULL, 'demo-app-spring-boot_1.2.0/bin/deploy.sh', 'http://localhost:9000/wecube-artifacts/e622f8a2fa2ef634fac701060c499c58_demo-app-spring-boot_1.2.0.tar.gz', NULL, NULL, 'demo-app-spring-boot_1.2.0/bin/start.sh|/demo-app-spring-boot_1.2.0/conf/application-prod.properties', 'true', 'e622f8a2fa2ef634fac701060c499c58', 'demo-app-spring-boot_1.2.0.tar.gz', 'demo-app-spring-boot_1.2.0/bin/start.sh', 'demo-app-spring-boot_1.2.0/bin/stop.sh', '0003_0000000029', '2020-01-13 12:07:53', 'mockadmin'),
	('0012_0000000036', NULL, '0012_0000000036', 'mockadmin', '2020-01-14 06:55:23', 'mockadmin', '2020-01-14 06:54:13', 'demo-app-spring-boot_1.2.1.tar.gz', 34, NULL, 'demo-app-spring-boot_1.2.1.tar.gz', NULL, NULL, NULL, NULL, 'demo-app-spring-boot_1.2.1/bin/deploy.sh', 'http://localhost:9000/wecube-artifacts/caa4b15eea6cbd0947bc9114a21f2e1b_demo-app-spring-boot_1.2.1.tar.gz', NULL, NULL, 'demo-app-spring-boot_1.2.1/bin/start.sh|/demo-app-spring-boot_1.2.1/conf/application-prod.properties', 'true', 'caa4b15eea6cbd0947bc9114a21f2e1b', 'demo-app-spring-boot_1.2.1.tar.gz', 'demo-app-spring-boot_1.2.1/bin/start.sh', 'demo-app-spring-boot_1.2.1/bin/stop.sh', '0003_0000000029', '2020-01-14 06:54:13', 'mockadmin'),
	('0012_0000000037', NULL, '0012_0000000037', 'mockadmin', '2020-01-14 07:15:49', 'mockadmin', '2020-01-14 07:13:19', 'demo-app-spring-boot_1.2.2.tar.gz', 34, NULL, 'demo-app-spring-boot_1.2.2.tar.gz', NULL, NULL, NULL, NULL, 'demo-app-spring-boot_1.2.2/bin/deploy.sh', 'http://localhost:9000/wecube-artifacts/692405b7701244e76962f725e307d543_demo-app-spring-boot_1.2.2.tar.gz', NULL, NULL, 'demo-app-spring-boot_1.2.2/bin/start.sh|/demo-app-spring-boot_1.2.2/conf/application-prod.properties', 'true', '692405b7701244e76962f725e307d543', 'demo-app-spring-boot_1.2.2.tar.gz', 'demo-app-spring-boot_1.2.2/bin/start.sh', 'demo-app-spring-boot_1.2.2/bin/stop.sh', '0003_0000000029', '2020-01-14 07:13:18', 'mockadmin');
/*!40000 ALTER TABLE `deploy_package` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.deploy_package$diff_conf_variable 的数据：~44 rows (大约)
/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` DISABLE KEYS */;
INSERT INTO `deploy_package$diff_conf_variable` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(2643, '0012_0000000022', '0032_0000000088', 2),
	(2644, '0012_0000000022', '0032_0000000086', 1),
	(3175, '0012_0000000023', '0032_0000000081', 2),
	(3176, '0012_0000000023', '0032_0000000090', 3),
	(3177, '0012_0000000023', '0032_0000000076', 5),
	(3178, '0012_0000000023', '0032_0000000083', 8),
	(3179, '0012_0000000023', '0032_0000000089', 4),
	(3180, '0012_0000000023', '0032_0000000077', 6),
	(3181, '0012_0000000023', '0032_0000000086', 1),
	(3182, '0012_0000000023', '0032_0000000082', 7),
	(3183, '0012_0000000023', '0032_0000000084', 9),
	(3184, '0012_0000000034', '0032_0000000081', 2),
	(3185, '0012_0000000034', '0032_0000000090', 3),
	(3186, '0012_0000000034', '0032_0000000083', 8),
	(3187, '0012_0000000034', '0032_0000000082', 7),
	(3188, '0012_0000000034', '0032_0000000084', 9),
	(3189, '0012_0000000034', '0032_0000000086', 1),
	(3190, '0012_0000000034', '0032_0000000077', 6),
	(3191, '0012_0000000034', '0032_0000000076', 5),
	(3192, '0012_0000000034', '0032_0000000089', 4),
	(3201, '0012_0000000035', '0032_0000000082', 6),
	(3202, '0012_0000000035', '0032_0000000077', 5),
	(3203, '0012_0000000035', '0032_0000000090', 2),
	(3204, '0012_0000000035', '0032_0000000081', 3),
	(3205, '0012_0000000035', '0032_0000000086', 1),
	(3206, '0012_0000000035', '0032_0000000084', 8),
	(3207, '0012_0000000035', '0032_0000000083', 7),
	(3208, '0012_0000000035', '0032_0000000076', 4),
	(3217, '0012_0000000036', '0032_0000000084', 8),
	(3218, '0012_0000000036', '0032_0000000082', 6),
	(3219, '0012_0000000036', '0032_0000000076', 4),
	(3220, '0012_0000000036', '0032_0000000077', 5),
	(3221, '0012_0000000036', '0032_0000000081', 3),
	(3222, '0012_0000000036', '0032_0000000090', 2),
	(3223, '0012_0000000036', '0032_0000000083', 7),
	(3224, '0012_0000000036', '0032_0000000086', 1),
	(3233, '0012_0000000037', '0032_0000000081', 3),
	(3234, '0012_0000000037', '0032_0000000084', 8),
	(3235, '0012_0000000037', '0032_0000000082', 6),
	(3236, '0012_0000000037', '0032_0000000076', 4),
	(3237, '0012_0000000037', '0032_0000000077', 5),
	(3238, '0012_0000000037', '0032_0000000090', 2),
	(3239, '0012_0000000037', '0032_0000000083', 7),
	(3240, '0012_0000000037', '0032_0000000086', 1);
/*!40000 ALTER TABLE `deploy_package$diff_conf_variable` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.diff_configuration 的数据：~11 rows (大约)
/*!40000 ALTER TABLE `diff_configuration` DISABLE KEYS */;
INSERT INTO `diff_configuration` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `variable_name`, `variable_value`) VALUES
	('0032_0000000076', NULL, '0032_0000000076', NULL, '2020-01-06 02:44:22', NULL, '2019-12-31 06:13:22', 'db_host_ip', 34, NULL, NULL, 'db_host_ip', 'db_host_ip', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":11,\\"parentRs\\":{\\"attrId\\":175,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":176,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":15,\\"parentRs\\":{\\"attrId\\":238,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":17,\\"parentRs\\":{\\"attrId\\":265,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":17,\\"parentRs\\":{\\"attrId\\":306,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000077', NULL, '0032_0000000077', NULL, '2020-01-06 02:44:22', NULL, '2019-12-31 06:13:22', 'db_host_port', 34, NULL, NULL, 'db_host_port', 'db_host_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":11,\\"parentRs\\":{\\"attrId\\":175,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":176,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":239,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000081', NULL, '0032_0000000081', NULL, '2020-01-06 02:44:22', NULL, '2019-12-31 06:37:27', 'port', 34, NULL, NULL, 'port', 'port', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":239,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000082', NULL, '0032_0000000082', NULL, '2020-01-06 02:44:22', NULL, '2020-01-02 03:43:50', 'db_name', 34, NULL, NULL, 'db_name', 'db_name', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":11,\\"parentRs\\":{\\"attrId\\":175,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":176,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":235,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000083', '0032_0000000085', '0032_0000000083', 'SYS_PLATFORM', '2020-01-10 07:36:27', NULL, '2020-01-02 03:49:27', 'db_username', 35, NULL, NULL, 'db_username', 'db_username', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":11,\\"parentRs\\":{\\"attrId\\":175,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":176,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":1006,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000084', NULL, '0032_0000000084', 'SYS_PLATFORM', '2020-01-10 07:36:10', NULL, '2020-01-02 03:49:27', 'db_password', 34, NULL, NULL, 'db_password', 'db_password', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":11,\\"parentRs\\":{\\"attrId\\":175,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":176,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":245,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000085', NULL, '0032_0000000083', NULL, '2020-01-02 06:26:49', NULL, '2020-01-02 03:49:27', '-demo-app-spring-boot_0.0.2.tar.gz-db_username', 34, '2020-01-02 06:26:48', NULL, 'db_username', 'db_username', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":11,\\"parentRs\\":{\\"attrId\\":175,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":9,\\"parentRs\\":{\\"attrId\\":176,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":236,\\"isReferedFromParent\\":0}},{\\"ciTypeId\\":12,\\"parentRs\\":{\\"attrId\\":243,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":13,\\"parentRs\\":{\\"attrId\\":197,\\"isReferedFromParent\\":1}},{\\"ciTypeId\\":13,\\"parentRs\\":{\\"attrId\\":219,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000086', NULL, '0032_0000000086', NULL, '2020-01-06 02:44:22', NULL, '2020-01-03 05:53:16', '1', 34, NULL, NULL, '1', '1', ''),
	('0032_0000000088', NULL, '0032_0000000088', NULL, '2020-01-06 09:56:41', NULL, '2020-01-06 09:56:41', 'path', 34, NULL, NULL, 'path', 'path', ''),
	('0032_0000000089', NULL, '0032_0000000089', NULL, '2020-01-06 10:36:57', NULL, '2020-01-06 10:24:18', 'jmx_prometheus_exporter_port', 34, NULL, NULL, 'jmx_prometheus_exporter_port', 'jmx_prometheus_exporter_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":825,\\"isReferedFromParent\\":1}}]"}]'),
	('0032_0000000090', NULL, '0032_0000000090', 'SYS_PLATFORM', '2020-01-10 07:30:25', NULL, '2020-01-06 10:30:38', 'jmx_port', 34, NULL, NULL, 'jmx_port', 'jmx_port', '[{"type":"rule","value":"[{\\"ciTypeId\\":14},{\\"ciTypeId\\":14,\\"parentRs\\":{\\"attrId\\":825,\\"isReferedFromParent\\":1}}]"}]');
/*!40000 ALTER TABLE `diff_configuration` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.direct_service_invoke 的数据：~1 rows (大约)
/*!40000 ALTER TABLE `direct_service_invoke` DISABLE KEYS */;
INSERT INTO `direct_service_invoke` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `invoked_unit`, `invoke_unit`, `invoke_user`, `invoke_user_password`) VALUES
	('0039_0000000001', NULL, '0039_0000000001', NULL, '2019-12-25 11:22:29', NULL, '2019-12-25 11:21:03', 'DMCS_PRD_MC_BROWER_>>_DMCS_PRD_ADM_APP', 37, '', '', 'DMCS_PRD_MC_BROWER_>>_DMCS_PRD_ADM_APP', '0009_0000000008', '0009_0000000028', NULL, NULL);
/*!40000 ALTER TABLE `direct_service_invoke` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.invoke 的数据：~3 rows (大约)
/*!40000 ALTER TABLE `invoke` DISABLE KEYS */;
INSERT INTO `invoke` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `invoke_design`, `invoke_type`, `invoked_unit`, `invoke_unit`) VALUES
	('0011_0000000003', NULL, '0011_0000000003', NULL, '2020-01-06 03:02:09', NULL, '2019-12-31 09:03:13', 'DEMO2_PRD_CORE_APP_invoke_DEMO2_PRD_CORE_DB', 37, '', '', 'APP-DB', '0005_0000000027', 84, '0009_0000000035', '0009_0000000034'),
	('0011_0000000004', NULL, '0011_0000000004', NULL, '2020-01-06 04:25:07', NULL, '2020-01-06 04:25:07', 'DEMO2_PRD_CORE_DLB_invoke_DEMO2_PRD_CORE_DB', 37, '', '', 'DBLB-DB', '0005_0000000030', 84, '0009_0000000035', '0009_0000000036'),
	('0011_0000000005', NULL, '0011_0000000005', NULL, '2020-01-06 04:30:21', NULL, '2020-01-06 04:30:21', 'DEMO2_PRD_CORE_ALB_invoke_DEMO2_PRD_CORE_APP', 37, '', '', 'ALB-APP', '0005_0000000031', 84, '0009_0000000034', '0009_0000000037');
/*!40000 ALTER TABLE `invoke` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.invoke_design 的数据：~15 rows (大约)
/*!40000 ALTER TABLE `invoke_design` DISABLE KEYS */;
INSERT INTO `invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `invoke_type`, `invoked_unit_design`, `invoke_unit_design`, `resource_set_invoke_design`) VALUES
	('0005_0000000012', NULL, '0005_0000000012', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:40:43', 'DMCS_MC_BROWER-invoke-DMCS_ADM_ALB', 34, '2020-01-03 04:05:07', '', 'WEB-LB', 84, '0003_0000000017', '0003_0000000026', '0036_0000000040'),
	('0005_0000000013', NULL, '0005_0000000013', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:41:03', 'DMCS_ADM_ALB-invoke-DMCS_ADM_APP', 34, '2020-01-03 04:05:07', '', 'ALB-APP', 84, '0003_0000000016', '0003_0000000017', '0036_0000000012'),
	('0005_0000000014', NULL, '0005_0000000014', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:41:18', 'DMCS_ADM_APP-invoke-DMCS_ADM_DLB', 34, '2020-01-03 04:05:07', '', 'APP-DLB', 84, '0003_0000000019', '0003_0000000016', '0036_0000000051'),
	('0005_0000000019', NULL, '0005_0000000019', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:53:07', 'DMCS_ADM_DLB-invoke-DMCS_ADM_DB', 34, '2020-01-03 04:05:07', '', 'DLB-DB', 84, '0003_0000000018', '0003_0000000019', '0036_0000000035'),
	('0005_0000000020', NULL, '0005_0000000020', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:53:29', 'DMCS_ADM_APP-invoke-DMCS_CORE_ALB', 34, '2020-01-03 04:05:07', '', 'APP-ALB', 84, '0003_0000000013', '0003_0000000016', '0036_0000000054'),
	('0005_0000000021', NULL, '0005_0000000021', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:53:57', 'DMCS_CORE_ALB-invoke-DMCS_CORE_APP', 34, '2020-01-03 04:05:07', '', 'ALB-APP', 84, '0003_0000000012', '0003_0000000013', '0036_0000000012'),
	('0005_0000000022', NULL, '0005_0000000022', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:54:14', 'DMCS_CORE_APP-invoke-DMCS_CORE_DLB', 34, '2020-01-03 04:05:07', '', 'APP-DLB', 84, '0003_0000000014', '0003_0000000012', '0036_0000000051'),
	('0005_0000000023', NULL, '0005_0000000023', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:54:30', 'DMCS_CORE_DLB-invoke-DMCS_CORE_DB', 34, '2020-01-03 04:05:07', '', 'DLB-DB', 84, '0003_0000000015', '0003_0000000014', '0036_0000000035'),
	('0005_0000000024', NULL, '0005_0000000024', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:54:59', 'DMCS_PROXY_NGINX-invoke-DMCS_CORE_ALB', 34, '2020-01-03 04:05:07', '', 'NGINX-ALB', 84, '0003_0000000013', '0003_0000000025', '0036_0000000049'),
	('0005_0000000025', NULL, '0005_0000000025', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:35:40', 'DMCS_PROXY_WANLB-invoke-DMCS_PROXY_NGINX', 34, '2020-01-03 04:05:07', '', 'WLB-NGINX', 84, '0003_0000000025', '0003_0000000027', '0036_0000000004'),
	('0005_0000000026', NULL, '0005_0000000026', 'mockadmin', '2020-01-10 07:14:36', NULL, '2019-12-24 10:45:00', 'DMCS_APIC_APIWEB-invoke-DMCS_PROXY_WANLB', 34, '2020-01-03 04:05:07', '', 'WEB-WLB', 84, '0003_0000000027', '0003_0000000028', '0036_0000000042'),
	('0005_0000000027', NULL, '0005_0000000027', NULL, '2020-01-06 03:01:59', NULL, '2019-12-31 08:08:03', 'DEMO2_CORE_APP-invoke-DEMO2_CORE_DB', 34, '', '', 'APP-DLB', 84, '0003_0000000030', '0003_0000000029', '0036_0000000053'),
	('0005_0000000028', NULL, '0005_0000000028', 'mockadmin', '2020-01-10 07:15:08', NULL, '2020-01-03 04:19:04', 'DMCS_BATCH_APP-invoke-DMCS_CORE_DLB', 34, '2020-01-10 07:15:08', '', 'APP-DLB', 84, '0003_0000000014', '0003_0000000032', '0036_0000000051'),
	('0005_0000000030', NULL, '0005_0000000030', NULL, '2020-01-06 04:24:44', NULL, '2020-01-06 04:24:44', 'DEMO2_CORE_DBLB-invoke-DEMO2_CORE_DB', 34, '', '', 'DBLB -DB', 84, '0003_0000000030', '0003_0000000031', '0036_0000000037'),
	('0005_0000000031', NULL, '0005_0000000031', NULL, '2020-01-06 04:28:25', NULL, '2020-01-06 04:28:25', 'DEMO2_CORE_ALB-invoke-DEMO2_CORE_APP', 34, '', '', 'ALB-APP', 84, '0003_0000000029', '0003_0000000035', '0036_0000000034');
/*!40000 ALTER TABLE `invoke_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.ip_address 的数据：~101 rows (大约)
/*!40000 ALTER TABLE `ip_address` DISABLE KEYS */;
INSERT INTO `ip_address` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `ip_address_usage`, `network_segment`, `used_record`) VALUES
	('0017_0000000001', NULL, '0017_0000000001', NULL, '2019-12-24 09:51:06', NULL, '2019-12-16 02:20:28', '10.128.8.10-资源IP', 37, '', '', '10.128.8.10', 143, '0023_0000000005', '未使用'),
	('0017_0000000002', NULL, '0017_0000000002', NULL, '2019-12-24 09:51:06', NULL, '2019-12-18 02:00:32', '10.128.8.11-资源IP', 37, '', '', '10.128.8.11', 143, '0023_0000000005', '未使用'),
	('0017_0000000003', NULL, '0017_0000000003', NULL, '2019-12-24 09:51:32', NULL, '2019-12-18 02:01:36', '10.128.8.202-资源IP', 37, '', '', '10.128.8.202', 143, '0023_0000000006', '未使用'),
	('0017_0000000004', NULL, '0017_0000000004', NULL, '2019-12-24 09:51:53', NULL, '2019-12-18 02:01:54', '10.128.8.203-资源IP', 37, '', '', '10.128.8.203', 143, '0023_0000000006', '未使用'),
	('0017_0000000005', NULL, '0017_0000000005', NULL, '2019-12-24 09:52:22', NULL, '2019-12-18 02:02:18', '10.128.8.138-资源IP', 37, '', '', '10.128.8.138', 143, '0023_0000000007', '未使用'),
	('0017_0000000006', NULL, '0017_0000000006', NULL, '2019-12-24 09:52:22', NULL, '2019-12-18 02:02:38', '10.128.8.139-资源IP', 37, '', '', '10.128.8.139', 143, '0023_0000000007', '未使用'),
	('0017_0000000007', NULL, '0017_0000000007', NULL, '2019-12-24 09:52:46', NULL, '2019-12-18 02:03:22', '10.128.9.10-资源IP', 37, '', '', '10.128.9.10', 143, '0023_0000000009', '未使用'),
	('0017_0000000008', NULL, '0017_0000000008', NULL, '2019-12-24 09:53:11', NULL, '2019-12-18 02:03:44', '10.128.9.202-资源IP', 37, '', '', '10.128.9.202', 143, '0023_0000000010', '未使用'),
	('0017_0000000009', NULL, '0017_0000000009', NULL, '2019-12-24 09:52:46', NULL, '2019-12-18 02:04:07', '10.128.9.11-资源IP', 37, '', '', '10.128.9.11', 143, '0023_0000000009', '未使用'),
	('0017_0000000010', NULL, '0017_0000000010', NULL, '2019-12-24 09:53:11', NULL, '2019-12-18 02:04:34', '10.128.9.203-资源IP', 37, '', '', '10.128.9.203', 143, '0023_0000000010', '未使用'),
	('0017_0000000011', NULL, '0017_0000000011', NULL, '2019-12-24 09:54:01', NULL, '2019-12-18 02:05:01', '10.128.9.138-资源IP', 37, '', '', '10.128.9.138', 143, '0023_0000000011', '未使用'),
	('0017_0000000012', NULL, '0017_0000000012', NULL, '2019-12-24 09:54:01', NULL, '2019-12-18 02:05:25', '10.128.9.139-资源IP', 37, '', '', '10.128.9.139', 143, '0023_0000000011', '未使用'),
	('0017_0000000013', NULL, '0017_0000000013', 'SYS_PLATFORM', '2020-01-14 04:49:42', NULL, '2019-12-18 02:06:31', '10.128.4.14-资源IP', 37, '', '', '10.128.4.14', 143, '0023_0000000013', '未使用'),
	('0017_0000000014', NULL, '0017_0000000014', 'SYS_PLATFORM', '2020-01-10 13:08:09', NULL, '2019-12-18 02:17:04', '10.128.4.15-资源IP', 37, '', '', '10.128.4.15', 143, '0023_0000000013', '未使用'),
	('0017_0000000015', NULL, '0017_0000000015', NULL, '2019-12-24 09:54:57', NULL, '2019-12-18 02:17:30', '10.128.5.138-资源IP', 37, '', '', '10.128.5.138', 143, '0023_0000000014', '未使用'),
	('0017_0000000016', NULL, '0017_0000000016', NULL, '2019-12-24 09:54:57', NULL, '2019-12-18 02:17:59', '10.128.5.139-资源IP', 37, '', '', '10.128.5.139', 143, '0023_0000000014', '未使用'),
	('0017_0000000017', NULL, '0017_0000000017', 'mockadmin', '2020-01-10 13:46:14', NULL, '2019-12-18 02:18:32', '10.128.5.3-资源IP', 37, '', '', '10.128.5.3', 143, '0023_0000000015', '未使用'),
	('0017_0000000018', NULL, '0017_0000000018', 'mockadmin', '2020-01-10 13:46:14', NULL, '2019-12-18 02:19:01', '10.128.5.10-资源IP', 37, '', '', '10.128.5.10', 143, '0023_0000000015', '未使用'),
	('0017_0000000019', NULL, '0017_0000000019', NULL, '2019-12-24 09:55:32', NULL, '2019-12-18 02:21:19', '10.128.6.10-资源IP', 37, '', '', '10.128.6.10', 143, '0023_0000000016', '未使用'),
	('0017_0000000020', NULL, '0017_0000000020', NULL, '2019-12-24 09:55:32', NULL, '2019-12-18 02:21:45', '10.128.6.11-资源IP', 37, '', '', '10.128.6.11', 143, '0023_0000000016', '未使用'),
	('0017_0000000021', NULL, '0017_0000000021', NULL, '2019-12-24 09:56:32', NULL, '2019-12-18 02:22:49', '10.128.130.10-资源IP', 37, '', '', '10.128.130.10', 143, '0023_0000000020', '未使用'),
	('0017_0000000022', NULL, '0017_0000000022', NULL, '2019-12-24 09:56:32', NULL, '2019-12-18 02:23:17', '10.128.130.11-资源IP', 37, '', '', '10.128.130.11', 143, '0023_0000000020', '未使用'),
	('0017_0000000023', NULL, '0017_0000000023', NULL, '2019-12-24 09:56:48', NULL, '2019-12-18 02:23:44', '10.128.130.138-资源IP', 37, '', '', '10.128.130.138', 143, '0023_0000000021', '未使用'),
	('0017_0000000024', NULL, '0017_0000000024', NULL, '2019-12-24 09:57:11', NULL, '2019-12-18 02:24:09', '10.128.130.139-资源IP', 37, '', '', '10.128.130.139', 143, '0023_0000000021', '未使用'),
	('0017_0000000025', NULL, '0017_0000000025', NULL, '2019-12-24 09:57:29', NULL, '2019-12-18 02:24:37', '10.128.131.10-资源IP', 37, '', '', '10.128.131.10', 143, '0023_0000000022', '未使用'),
	('0017_0000000026', NULL, '0017_0000000026', NULL, '2019-12-24 09:57:29', NULL, '2019-12-18 02:25:03', '10.128.131.11-资源IP', 37, '', '', '10.128.131.11', 143, '0023_0000000022', '未使用'),
	('0017_0000000027', NULL, '0017_0000000027', NULL, '2019-12-24 09:57:58', NULL, '2019-12-18 02:25:32', '10.128.131.138-资源IP', 37, '', '', '10.128.131.138', 143, '0023_0000000023', '未使用'),
	('0017_0000000028', NULL, '0017_0000000028', NULL, '2019-12-24 09:57:58', NULL, '2019-12-18 02:25:57', '10.128.131.139-资源IP', 37, '', '', '10.128.131.139', 143, '0023_0000000023', '未使用'),
	('0017_0000000029', NULL, '0017_0000000029', NULL, '2019-12-24 09:58:36', NULL, '2019-12-18 02:27:43', '10.128.162.10-资源IP', 37, '', '', '10.128.162.10', 143, '0023_0000000027', '未使用'),
	('0017_0000000030', NULL, '0017_0000000030', NULL, '2019-12-24 09:58:36', NULL, '2019-12-18 02:28:10', '10.128.162.11-资源IP', 37, '', '', '10.128.162.11', 143, '0023_0000000027', '未使用'),
	('0017_0000000031', NULL, '0017_0000000031', NULL, '2019-12-24 09:58:36', NULL, '2019-12-18 02:28:37', '10.128.162.138-资源IP', 37, '', '', '10.128.162.138', 143, '0023_0000000028', '未使用'),
	('0017_0000000032', NULL, '0017_0000000032', NULL, '2019-12-24 09:58:35', NULL, '2019-12-18 02:29:00', '10.128.162.139-资源IP', 37, '', '', '10.128.162.139', 143, '0023_0000000028', '未使用'),
	('0017_0000000033', NULL, '0017_0000000033', NULL, '2019-12-24 09:58:52', NULL, '2019-12-18 02:29:32', '10.128.163.10-资源IP', 37, '', '', '10.128.163.10', 143, '0023_0000000029', '未使用'),
	('0017_0000000034', NULL, '0017_0000000034', NULL, '2019-12-24 09:59:31', NULL, '2019-12-18 02:30:18', '10.128.163.11-资源IP', 37, '', '', '10.128.163.11', 143, '0023_0000000029', '未使用'),
	('0017_0000000035', NULL, '0017_0000000035', NULL, '2019-12-24 09:59:31', NULL, '2019-12-18 02:30:49', '10.128.163.138-资源IP', 37, '', '', '10.128.163.138', 143, '0023_0000000030', '未使用'),
	('0017_0000000036', NULL, '0017_0000000036', NULL, '2019-12-24 09:59:31', NULL, '2019-12-18 02:31:14', '10.128.163.139-资源IP', 37, '', '', '10.128.163.139', 143, '0023_0000000030', '未使用'),
	('0017_0000000037', NULL, '0017_0000000037', NULL, '2019-12-24 10:00:21', NULL, '2019-12-18 02:32:19', '10.128.194.10-资源IP', 37, '', '', '10.128.194.10', 143, '0023_0000000033', '未使用'),
	('0017_0000000038', NULL, '0017_0000000038', NULL, '2019-12-24 10:00:21', NULL, '2019-12-18 02:32:45', '10.128.194.11-资源IP', 37, '', '', '10.128.194.11', 143, '0023_0000000033', '未使用'),
	('0017_0000000039', NULL, '0017_0000000039', NULL, '2019-12-24 10:00:46', NULL, '2019-12-18 02:33:10', '10.128.194.202-资源IP', 37, '', '', '10.128.194.202', 143, '0023_0000000034', '未使用'),
	('0017_0000000040', NULL, '0017_0000000040', NULL, '2019-12-24 10:00:46', NULL, '2019-12-18 02:33:34', '10.128.194.203-资源IP', 37, '', '', '10.128.194.203', 143, '0023_0000000034', '未使用'),
	('0017_0000000041', NULL, '0017_0000000041', NULL, '2019-12-24 10:01:08', NULL, '2019-12-18 02:34:07', '10.128.194.139-资源IP', 37, '', '', '10.128.194.139', 143, '0023_0000000035', '未使用'),
	('0017_0000000042', NULL, '0017_0000000042', NULL, '2019-12-24 10:01:08', NULL, '2019-12-18 02:34:34', '10.128.194.138-资源IP', 37, '', '', '10.128.194.138', 143, '0023_0000000035', '未使用'),
	('0017_0000000043', NULL, '0017_0000000043', NULL, '2019-12-24 10:33:15', NULL, '2019-12-18 02:35:02', '10.128.201.10-资源IP', 37, '', '', '10.128.201.10', 143, '0023_0000000036', '未使用'),
	('0017_0000000044', NULL, '0017_0000000044', NULL, '2019-12-24 10:34:20', NULL, '2019-12-18 02:35:27', '10.128.201.11-资源IP', 37, '', '', '10.128.201.11', 143, '0023_0000000036', '未使用'),
	('0017_0000000045', NULL, '0017_0000000045', NULL, '2019-12-22 11:24:02', NULL, '2019-12-18 02:42:54', '10.1.0.10-资源IP', 37, '', '', '10.1.0.10', 143, '0023_0000000043', '未使用'),
	('0017_0000000046', NULL, '0017_0000000046', NULL, '2019-12-22 11:24:02', NULL, '2019-12-18 02:43:24', '10.1.0.11-资源IP', 37, '', '', '10.1.0.11', 143, '0023_0000000043', '未使用'),
	('0017_0000000047', NULL, '0017_0000000047', NULL, '2019-12-24 10:34:47', NULL, '2019-12-18 02:44:00', '10.128.195.10-资源IP', 37, '', '', '10.128.195.10', 143, '0023_0000000045', '未使用'),
	('0017_0000000048', NULL, '0017_0000000048', NULL, '2019-12-24 10:34:47', NULL, '2019-12-18 02:44:45', '10.128.195.11-资源IP', 37, '', '', '10.128.195.11', 143, '0023_0000000045', '未使用'),
	('0017_0000000051', NULL, '0017_0000000051', NULL, '2019-12-24 10:35:05', NULL, '2019-12-18 05:42:26', ' 10.128.8.12-资源IP', 37, '', '', ' 10.128.8.12', 143, '0023_0000000005', '未使用'),
	('0017_0000000052', NULL, '0017_0000000052', NULL, '2019-12-24 10:35:05', NULL, '2019-12-18 05:42:53', '10.128.8.13-资源IP', 37, '', '', '10.128.8.13', 143, '0023_0000000005', '未使用'),
	('0017_0000000053', NULL, '0017_0000000053', NULL, '2019-12-24 10:35:23', NULL, '2019-12-18 05:43:47', '10.128.9.12-资源IP', 37, '', '', '10.128.9.12', 143, '0023_0000000009', '未使用'),
	('0017_0000000054', NULL, '0017_0000000054', NULL, '2019-12-24 10:35:23', NULL, '2019-12-18 05:44:08', '10.128.9.13-资源IP', 37, '', '', '10.128.9.13', 143, '0023_0000000009', '未使用'),
	('0017_0000000055', NULL, '0017_0000000055', NULL, '2019-12-24 10:35:34', NULL, '2019-12-18 05:44:53', '10.128.8.14-资源IP', 37, '', '', '10.128.8.14', 143, '0023_0000000005', '未使用'),
	('0017_0000000056', NULL, '0017_0000000056', NULL, '2019-12-24 10:35:47', NULL, '2019-12-18 05:45:12', '10.128.8.15-资源IP', 37, '', '', '10.128.8.15', 143, '0023_0000000005', '未使用'),
	('0017_0000000057', NULL, '0017_0000000057', NULL, '2019-12-24 10:36:16', NULL, '2019-12-18 09:51:58', '10.128.40.10-资源IP', 37, '', '', '10.128.40.10', 143, '0023_0000000048', '未使用'),
	('0017_0000000058', NULL, '0017_0000000058', NULL, '2019-12-24 10:36:16', NULL, '2019-12-18 09:52:38', '10.128.40.11-资源IP', 37, '', '', '10.128.40.11', 143, '0023_0000000048', '未使用'),
	('0017_0000000059', NULL, '0017_0000000059', NULL, '2019-12-24 10:36:39', NULL, '2019-12-18 09:53:03', '10.128.40.202-资源IP', 37, '', '', '10.128.40.202', 143, '0023_0000000049', '未使用'),
	('0017_0000000060', NULL, '0017_0000000060', NULL, '2019-12-24 10:36:39', NULL, '2019-12-18 09:53:28', '10.128.40.203-资源IP', 37, '', '', '10.128.40.203', 143, '0023_0000000049', '未使用'),
	('0017_0000000061', NULL, '0017_0000000061', NULL, '2019-12-24 10:37:04', NULL, '2019-12-18 09:53:53', '10.128.40.138-资源IP', 37, '', '', '10.128.40.138', 143, '0023_0000000050', '未使用'),
	('0017_0000000062', NULL, '0017_0000000062', NULL, '2019-12-24 10:37:04', NULL, '2019-12-18 09:54:23', '10.128.40.139-资源IP', 37, '', '', '10.128.40.139', 143, '0023_0000000050', '未使用'),
	('0017_0000000063', NULL, '0017_0000000063', NULL, '2019-12-24 10:37:26', NULL, '2019-12-18 09:54:48', '10.128.41.10-资源IP', 37, '', '', '10.128.41.10', 143, '0023_0000000052', '未使用'),
	('0017_0000000064', NULL, '0017_0000000064', NULL, '2019-12-24 10:37:26', NULL, '2019-12-18 09:55:10', '10.128.41.11-资源IP', 37, '', '', '10.128.41.11', 143, '0023_0000000052', '未使用'),
	('0017_0000000065', NULL, '0017_0000000065', NULL, '2019-12-24 10:37:41', NULL, '2019-12-18 09:55:32', '10.128.41.202-资源IP', 37, '', '', '10.128.41.202', 143, '0023_0000000053', '未使用'),
	('0017_0000000066', NULL, '0017_0000000066', NULL, '2019-12-24 10:37:59', NULL, '2019-12-18 09:55:51', '10.128.41.203-资源IP', 37, '', '', '10.128.41.203', 143, '0023_0000000053', '未使用'),
	('0017_0000000067', NULL, '0017_0000000067', NULL, '2019-12-24 10:38:22', NULL, '2019-12-18 09:56:12', '10.128.41.138-资源IP', 37, '', '', '10.128.41.138', 143, '0023_0000000054', '未使用'),
	('0017_0000000068', NULL, '0017_0000000068', NULL, '2019-12-24 10:38:22', NULL, '2019-12-18 10:05:48', '10.128.41.139-资源IP', 37, '', '', '10.128.41.139', 143, '0023_0000000054', '未使用'),
	('0017_0000000069', NULL, '0017_0000000069', NULL, '2019-12-24 10:38:37', NULL, '2019-12-18 10:06:31', '10.128.36.10-资源IP', 37, '', '', '10.128.36.10', 143, '0023_0000000056', '未使用'),
	('0017_0000000070', NULL, '0017_0000000070', NULL, '2019-12-24 10:38:37', NULL, '2019-12-18 10:06:57', '10.128.36.11-资源IP', 37, '', '', '10.128.36.11', 143, '0023_0000000056', '未使用'),
	('0017_0000000071', NULL, '0017_0000000071', NULL, '2019-12-24 10:39:24', NULL, '2019-12-18 10:07:44', '10.128.37.138-资源IP', 37, '', '', '10.128.37.138', 143, '0023_0000000057', '未使用'),
	('0017_0000000072', NULL, '0017_0000000072', NULL, '2019-12-24 10:39:24', NULL, '2019-12-18 10:08:08', '10.128.37.139-资源IP', 37, '', '', '10.128.37.139', 143, '0023_0000000057', '未使用'),
	('0017_0000000073', NULL, '0017_0000000073', NULL, '2019-12-24 10:39:02', NULL, '2019-12-18 10:08:31', '10.128.37.10-资源IP', 37, '', '', '10.128.37.10', 143, '0023_0000000058', '未使用'),
	('0017_0000000074', NULL, '0017_0000000074', NULL, '2019-12-24 10:39:02', NULL, '2019-12-18 10:08:59', '10.128.37.11-资源IP', 37, '', '', '10.128.37.11', 143, '0023_0000000058', '未使用'),
	('0017_0000000075', NULL, '0017_0000000075', NULL, '2019-12-24 10:39:40', NULL, '2019-12-18 10:09:30', '10.128.38.10-资源IP', 37, '', '', '10.128.38.10', 143, '0023_0000000059', '未使用'),
	('0017_0000000076', NULL, '0017_0000000076', NULL, '2019-12-24 10:39:53', NULL, '2019-12-18 10:09:52', '10.128.38.11-资源IP', 37, '', '', '10.128.38.11', 143, '0023_0000000059', '未使用'),
	('0017_0000000077', NULL, '0017_0000000077', NULL, '2019-12-24 10:40:44', NULL, '2019-12-18 10:10:21', '10.128.138.10-资源IP', 37, '', '', '10.128.138.10', 143, '0023_0000000063', '未使用'),
	('0017_0000000078', NULL, '0017_0000000078', NULL, '2019-12-24 10:40:44', NULL, '2019-12-18 10:10:43', '10.128.138.11-资源IP', 37, '', '', '10.128.138.11', 143, '0023_0000000063', '未使用'),
	('0017_0000000079', NULL, '0017_0000000079', NULL, '2019-12-24 10:40:44', NULL, '2019-12-18 10:11:11', '10.128.138.138-资源IP', 37, '', '', '10.128.138.138', 143, '0023_0000000064', '未使用'),
	('0017_0000000080', NULL, '0017_0000000080', NULL, '2019-12-24 10:40:44', NULL, '2019-12-18 10:11:32', '10.128.138.139-资源IP', 37, '', '', '10.128.138.139', 143, '0023_0000000064', '未使用'),
	('0017_0000000081', NULL, '0017_0000000081', NULL, '2019-12-24 10:41:26', NULL, '2019-12-18 10:11:53', '10.128.139.10-资源IP', 37, '', '', '10.128.139.10', 143, '0023_0000000065', '未使用'),
	('0017_0000000082', NULL, '0017_0000000082', NULL, '2019-12-24 10:41:26', NULL, '2019-12-18 10:12:14', '10.128.139.11-资源IP', 37, '', '', '10.128.139.11', 143, '0023_0000000065', '未使用'),
	('0017_0000000083', NULL, '0017_0000000083', NULL, '2019-12-24 10:41:26', NULL, '2019-12-18 10:12:35', '10.128.139.138-资源IP', 37, '', '', '10.128.139.138', 143, '0023_0000000066', '未使用'),
	('0017_0000000084', NULL, '0017_0000000084', NULL, '2019-12-24 10:41:26', NULL, '2019-12-18 10:13:00', '10.128.139.139-资源IP', 37, '', '', '10.128.139.139', 143, '0023_0000000066', '未使用'),
	('0017_0000000085', NULL, '0017_0000000085', NULL, '2019-12-24 10:41:42', NULL, '2019-12-18 10:13:21', '10.128.170.10-资源IP', 37, '', '', '10.128.170.10', 143, '0023_0000000070', '未使用'),
	('0017_0000000086', NULL, '0017_0000000086', NULL, '2019-12-24 10:42:14', NULL, '2019-12-18 10:13:42', '10.128.170.11-资源IP', 37, '', '', '10.128.170.11', 143, '0023_0000000070', '未使用'),
	('0017_0000000087', NULL, '0017_0000000087', NULL, '2019-12-24 10:42:14', NULL, '2019-12-18 10:14:05', '10.128.170.138-资源IP', 37, '', '', '10.128.170.138', 143, '0023_0000000071', '未使用'),
	('0017_0000000088', NULL, '0017_0000000088', NULL, '2019-12-24 10:42:14', NULL, '2019-12-18 10:14:35', '10.128.170.139-资源IP', 37, '', '', '10.128.170.139', 143, '0023_0000000071', '未使用'),
	('0017_0000000089', NULL, '0017_0000000089', NULL, '2019-12-24 10:48:53', NULL, '2019-12-18 10:15:00', '10.128.171.10-资源IP', 37, '', '', '10.128.171.10', 143, '0023_0000000072', '未使用'),
	('0017_0000000090', NULL, '0017_0000000090', NULL, '2019-12-24 10:48:53', NULL, '2019-12-18 10:15:33', '10.128.171.11-资源IP', 37, '', '', '10.128.171.11', 143, '0023_0000000072', '未使用'),
	('0017_0000000091', NULL, '0017_0000000091', NULL, '2019-12-24 10:49:26', NULL, '2019-12-18 10:15:54', '10.128.171.138-资源IP', 37, '', '', '10.128.171.138', 143, '0023_0000000073', '未使用'),
	('0017_0000000093', NULL, '0017_0000000093', NULL, '2019-12-24 10:51:52', NULL, '2019-12-18 10:16:48', '10.128.202.10-资源IP', 37, '', '', '10.128.202.10', 143, '0023_0000000076', '未使用'),
	('0017_0000000094', NULL, '0017_0000000094', NULL, '2019-12-24 10:51:52', NULL, '2019-12-18 10:17:12', '10.128.202.11-资源IP', 37, '', '', '10.128.202.11', 143, '0023_0000000076', '未使用'),
	('0017_0000000095', NULL, '0017_0000000095', NULL, '2019-12-24 10:52:19', NULL, '2019-12-18 10:17:36', '10.128.202.202-资源IP', 37, '', '', '10.128.202.202', 143, '0023_0000000077', '未使用'),
	('0017_0000000096', NULL, '0017_0000000096', NULL, '2019-12-24 10:52:19', NULL, '2019-12-18 10:18:02', '10.128.202.203-资源IP', 37, '', '', '10.128.202.203', 143, '0023_0000000077', '未使用'),
	('0017_0000000097', NULL, '0017_0000000097', NULL, '2019-12-24 10:52:43', NULL, '2019-12-18 10:18:39', '10.128.202.138-资源IP', 37, '', '', '10.128.202.138', 143, '0023_0000000078', '未使用'),
	('0017_0000000098', NULL, '0017_0000000098', NULL, '2019-12-24 10:52:43', NULL, '2019-12-18 10:19:10', '10.128.202.139-资源IP', 37, '', '', '10.128.202.139', 143, '0023_0000000078', '未使用'),
	('0017_0000000101', NULL, '0017_0000000101', NULL, '2019-12-22 11:34:45', NULL, '2019-12-19 12:44:31', '145.123.123.234-资源IP', 37, '', '', '145.123.123.234', 143, '0023_0000000082', '未使用'),
	('0017_0000000102', NULL, '0017_0000000102', NULL, '2020-01-06 04:36:02', NULL, '2019-12-19 12:45:17', '10.128.0.3-资源IP', 37, '', '', '10.128.0.3', 143, '0023_0000000083', '未使用'),
	('0017_0000000103', NULL, '0017_0000000103', NULL, '2019-12-22 11:34:45', NULL, '2019-12-19 12:45:42', '10.128.128.10-资源IP', 37, '', '', '10.128.128.10', 143, '0023_0000000085', '未使用'),
	('0017_0000000104', NULL, '0017_0000000104', NULL, '2019-12-22 11:34:45', NULL, '2019-12-19 12:46:01', '10.128.160.10-资源IP', 37, '', '', '10.128.160.10', 143, '0023_0000000087', '未使用'),
	('0017_0000000105', NULL, '0017_0000000105', NULL, '2019-12-22 11:34:45', NULL, '2019-12-19 12:46:33', '10.128.192.10-资源IP', 37, '', '', '10.128.192.10', 143, '0023_0000000089', '未使用'),
	('0017_0000000106', NULL, '0017_0000000106', NULL, '2019-12-24 10:50:24', NULL, '2019-12-24 10:50:24', '10.128.171.139-资源IP', 37, '', '', '10.128.171.139', 143, '0023_0000000073', '未使用'),
	('0017_0000000107', NULL, '0017_0000000107', NULL, '2020-01-02 10:10:37', NULL, '2020-01-02 10:10:37', '10.128.4.13-资源IP', 37, '', '', '10.128.4.13', 143, '0023_0000000013', ''),
	('0017_0000000108', NULL, '0017_0000000108', NULL, '2020-01-06 03:13:59', NULL, '2020-01-06 02:59:48', '10.128.2.10-资源IP', 37, '', '', '10.128.2.10', 143, '0023_0000000091', ''),
	('0017_0000000109', NULL, '0017_0000000109', NULL, '2020-01-06 09:53:06', NULL, '2020-01-06 09:50:41', '10.128.4.12-资源IP', 37, '', '', '10.128.4.12', 143, '0023_0000000013', '');
/*!40000 ALTER TABLE `ip_address` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.network_segment 的数据：~108 rows (大约)
/*!40000 ALTER TABLE `network_segment` DISABLE KEYS */;
INSERT INTO `network_segment` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `f_network_segment`, `gateway_ip`, `mask`, `name`, `network_segment_design`, `network_segment_usage`, `data_center`) VALUES
	('0023_0000000001', NULL, '0023_0000000001', NULL, '2019-12-22 09:16:01', NULL, '2019-12-15 15:19:07', '10.128.0.0/16_数据中心_GZ', 37, '', '', '10.128.0.0/16', '', '', '16', 'GZ', '0030_0000000001', 95, NULL),
	('0023_0000000003', NULL, '0023_0000000003', NULL, '2019-12-24 06:39:54', NULL, '2019-12-16 02:14:41', '10.128.0.0/17_网络区域_GZ-SF', 37, '', '', '10.128.0.0/17', '0023_0000000001', '', '17', 'GZ-SF', '0030_0000000003', 96, '0018_0000000004'),
	('0023_0000000005', NULL, '0023_0000000005', NULL, '2019-12-24 09:23:43', NULL, '2019-12-16 02:20:08', '10.128.8.0/25_资源集合_GZ3P-SF-BZa-APP', 37, '', '', '10.128.8.0/25', '0023_0000000127', '', '25', 'GZ3P-SF-BZa-APP', '0030_0000000023', 98, '0018_0000000001'),
	('0023_0000000006', NULL, '0023_0000000006', NULL, '2019-12-24 09:23:17', NULL, '2019-12-17 17:10:24', '10.128.8.192/26_资源集合_GZ3P-SF-BZa-CACHE', 37, '', '', '10.128.8.192/26', '0023_0000000127', '', '26', 'GZ3P-SF-BZa-CACHE', '0030_0000000024', 98, '0018_0000000001'),
	('0023_0000000007', NULL, '0023_0000000007', NULL, '2019-12-24 09:22:55', NULL, '2019-12-17 17:11:12', '10.128.8.128/26_资源集合_GZ3P-SF-BZa-DB', 37, '', '', '10.128.8.128/26', '0023_0000000127', '', '26', 'GZ3P-SF-BZa-DB', '0030_0000000025', 98, '0018_0000000001'),
	('0023_0000000009', NULL, '0023_0000000009', NULL, '2019-12-24 09:21:06', NULL, '2019-12-17 17:13:09', '10.128.9.0/25_资源集合_GZ3P-SF-BZb-APP', 37, '', '', '10.128.9.0/25', '0023_0000000125', '', '25', 'GZ3P-SF-BZb-APP', '0030_0000000026', 98, '0018_0000000001'),
	('0023_0000000010', NULL, '0023_0000000010', NULL, '2019-12-24 09:20:34', NULL, '2019-12-17 17:13:42', '10.128.9.192/26_资源集合_GZ3P-SF-BZb-CACHE', 37, '', '', '10.128.9.192/26', '0023_0000000125', '', '26', 'GZ3P-SF-BZb-CACHE', '0030_0000000027', 98, '0018_0000000001'),
	('0023_0000000011', NULL, '0023_0000000011', NULL, '2019-12-24 09:20:03', NULL, '2019-12-17 17:14:05', '10.128.9.128/26_资源集合_GZ3P-SF-BZb-DB', 37, '', '', '10.128.9.128/26', '0023_0000000125', '', '26', 'GZ3P-SF-BZb-DB', '0030_0000000028', 98, '0018_0000000001'),
	('0023_0000000013', NULL, '0023_0000000013', NULL, '2019-12-24 09:19:14', NULL, '2019-12-17 17:15:12', '10.128.4.0/24_资源集合_GZ3P-SF-CS-APP', 37, '', '', '10.128.4.0/24', '0023_0000000123', '', '24', 'GZ3P-SF-CS-APP', '0030_0000000029', 98, '0018_0000000001'),
	('0023_0000000014', NULL, '0023_0000000014', NULL, '2019-12-24 09:18:43', NULL, '2019-12-17 17:15:51', '10.128.5.128/25_资源集合_GZ3P-SF-CS-CACHE', 37, '', '', '10.128.5.128/25', '0023_0000000123', '', '25', 'GZ3P-SF-CS-CACHE', '0030_0000000030', 98, '0018_0000000001'),
	('0023_0000000015', NULL, '0023_0000000015', NULL, '2019-12-24 09:18:05', NULL, '2019-12-17 17:16:38', '10.128.5.0/25_资源集合_GZ3P-SF-CS-DB', 37, '', '', '10.128.5.0/25', '0023_0000000123', '', '25', 'GZ3P-SF-CS-DB', '0030_0000000031', 98, '0018_0000000001'),
	('0023_0000000016', NULL, '0023_0000000016', NULL, '2019-12-24 09:17:25', NULL, '2019-12-17 17:17:23', '10.128.6.0/23_资源集合_GZ3P-SF-CS-BDP', 37, '', '', '10.128.6.0/23', '0023_0000000123', '', '23', 'GZ3P-SF-CS-BDP', '0030_0000000032', 98, '0018_0000000001'),
	('0023_0000000017', NULL, '0023_0000000017', NULL, '2019-12-24 06:41:27', NULL, '2019-12-17 17:18:49', '10.128.128.0/19_网络区域_GZ-DMZ', 37, '', '', '10.128.128.0/19', '0023_0000000001', '', '19', 'GZ-DMZ', '0030_0000000005', 96, '0018_0000000004'),
	('0023_0000000020', NULL, '0023_0000000020', NULL, '2019-12-24 09:16:51', NULL, '2019-12-17 17:20:41', '10.128.130.0/25_资源集合_GZ3P-DMZ-BZa-IN', 37, '', '', '10.128.130.0/25', '0023_0000000119', '', '25', 'GZ3P-DMZ-BZa-IN', '0030_0000000033', 98, '0018_0000000001'),
	('0023_0000000021', NULL, '0023_0000000021', NULL, '2019-12-24 09:16:21', NULL, '2019-12-17 17:23:31', '10.128.130.128/25_资源集合_GZ3P-DMZ-BZa-OUT', 37, '', '', '10.128.130.128/25', '0023_0000000119', '', '25', 'GZ3P-DMZ-BZa-OUT', '0030_0000000034', 98, '0018_0000000001'),
	('0023_0000000022', NULL, '0023_0000000022', NULL, '2019-12-24 09:15:42', NULL, '2019-12-17 17:24:08', '10.128.131.0/25_资源集合_GZ3P-DMZ-BZb-IN', 37, '', '', '10.128.131.0/25', '0023_0000000117', '', '25', 'GZ3P-DMZ-BZb-IN', '0030_0000000042', 98, '0018_0000000001'),
	('0023_0000000023', NULL, '0023_0000000023', NULL, '2019-12-24 09:15:15', NULL, '2019-12-17 17:24:34', '10.128.131.128/25_资源集合_GZ3P-DMZ-BZb-OUT', 37, '', '', '10.128.131.128/25', '0023_0000000117', '', '25', 'GZ3P-DMZ-BZb-OUT', '0030_0000000043', 98, '0018_0000000001'),
	('0023_0000000024', NULL, '0023_0000000024', NULL, '2019-12-24 06:42:03', NULL, '2019-12-17 17:25:17', '10.128.160.0/19_网络区域_GZ-ECN', 37, '', '', '10.128.160.0/19', '0023_0000000001', '', '19', 'GZ-ECN', '0030_0000000006', 96, '0018_0000000004'),
	('0023_0000000027', NULL, '0023_0000000027', NULL, '2019-12-24 09:14:34', NULL, '2019-12-17 17:26:38', '10.128.162.0/25_资源集合_GZ3P-ECN-BZa-OWN', 37, '', '', '10.128.162.0/25', '0023_0000000115', '', '25', 'GZ3P-ECN-BZa-OWN', '0030_0000000035', 98, '0018_0000000001'),
	('0023_0000000028', NULL, '0023_0000000028', NULL, '2019-12-24 09:14:08', NULL, '2019-12-17 17:27:03', '10.128.162.128/25_资源集合_GZ3P-ECN-BZa-NOWN', 37, '', '', '10.128.162.128/25', '0023_0000000115', '', '25', 'GZ3P-ECN-BZa-NOWN', '0030_0000000036', 98, '0018_0000000001'),
	('0023_0000000029', NULL, '0023_0000000029', NULL, '2019-12-24 09:13:30', NULL, '2019-12-17 17:27:53', '10.128.163.0/25_资源集合_GZ3P-ECN-BZb-OWN', 37, '', '', '10.128.163.0/25', '0023_0000000113', '', '25', 'GZ3P-ECN-BZb-OWN', '0030_0000000044', 98, '0018_0000000001'),
	('0023_0000000030', NULL, '0023_0000000030', NULL, '2019-12-24 09:12:50', NULL, '2019-12-17 17:28:19', '10.128.163.128/25_资源集合_GZ3P-ECN-BZb-NOWN', 37, '', '', '10.128.163.128/25', '0023_0000000113', '', '25', 'GZ3P-ECN-BZb-NOWN', '0030_0000000045', 98, '0018_0000000001'),
	('0023_0000000031', NULL, '0023_0000000031', NULL, '2019-12-25 12:38:16', NULL, '2019-12-17 17:28:53', '10.128.192.0/19_网络区域_GZ-MGMT', 37, '', '', '10.128.192.0/19', '0023_0000000001', '', '19', 'GZ-MGMT', '0030_0000000004', 96, '0018_0000000004'),
	('0023_0000000033', NULL, '0023_0000000033', NULL, '2019-12-24 09:12:09', NULL, '2019-12-17 17:29:57', '10.128.194.0/25_资源集合_GZ3P-MGMT-MT-APP', 37, '', '', '10.128.194.0/25', '0023_0000000121', '', '25', 'GZ3P-MGMT-MT-APP', '0030_0000000037', 98, '0018_0000000001'),
	('0023_0000000034', NULL, '0023_0000000034', NULL, '2019-12-24 09:11:33', NULL, '2019-12-17 17:30:56', '10.128.194.192/26_资源集合_GZ3P-MGMT-MT-CACHE', 37, '', '', '10.128.194.192/26', '0023_0000000121', '', '26', 'GZ3P-MGMT-MT-CACHE', '0030_0000000038', 98, '0018_0000000001'),
	('0023_0000000035', NULL, '0023_0000000035', NULL, '2019-12-24 09:10:07', NULL, '2019-12-17 17:31:19', '10.128.194.128/26_资源集合_GZ3P-MGMT-MT-DB', 37, '', '', '10.128.194.128/26', '0023_0000000121', '', '26', 'GZ3P-MGMT-MT-DB', '0030_0000000039', 98, '0018_0000000001'),
	('0023_0000000036', NULL, '0023_0000000036', NULL, '2019-12-24 09:04:41', NULL, '2019-12-17 17:31:53', '10.128.201.0/24_资源集合_GZ3P-MGMT-MT-BDP', 37, '', '', '10.128.201.0/24', '0023_0000000110', '', '24', 'GZ3P-MGMT-MT-BDP', '0030_0000000040', 98, '0018_0000000001'),
	('0023_0000000037', NULL, '0023_0000000037', NULL, '2019-12-22 09:16:01', NULL, '2019-12-17 17:36:49', '0.0.0.0/0_数据中心_NDC', 37, '', '', '0.0.0.0/0', '', '', '0', 'NDC', '0030_0000000001', 95, NULL),
	('0023_0000000041', NULL, '0023_0000000041', NULL, '2019-12-24 07:24:23', NULL, '2019-12-17 17:45:41', '10.1.0.0/20_网络区域_NDC-OPN', 37, '', '', '10.1.0.0/20', '0023_0000000037', '', '20', 'NDC-OPN', '0030_0000000009', 96, '0018_0000000002'),
	('0023_0000000043', NULL, '0023_0000000043', NULL, '2019-12-24 09:03:15', NULL, '2019-12-17 17:48:37', '10.1.0.0/24_资源集合_NDC-OPN-ALL-VC', 37, '', '', '10.1.0.0/24', '0023_0000000130', '', '24', 'NDC-OPN-ALL-VC', '0030_0000000052', 98, '0018_0000000002'),
	('0023_0000000045', NULL, '0023_0000000045', NULL, '2019-12-24 08:58:15', NULL, '2019-12-17 18:00:57', '10.128.195.0/24_资源集合_GZ3P-MGMT-QZ-VDI', 37, '', '', '10.128.195.0/24', '0023_0000000111', '', '24', 'GZ3P-MGMT-QZ-VDI', '0030_0000000046', 98, '0018_0000000001'),
	('0023_0000000048', NULL, '0023_0000000048', NULL, '2019-12-24 08:55:49', NULL, '2019-12-18 06:22:08', '10.128.40.0/25_资源集合_GZ4P-SF-BZa-APP', 37, '', '', '10.128.40.0/25', '0023_0000000128', '', '25', 'GZ4P-SF-BZa-APP', '0030_0000000023', 98, '0018_0000000003'),
	('0023_0000000049', NULL, '0023_0000000049', NULL, '2019-12-24 08:55:10', NULL, '2019-12-18 06:22:47', '10.129.40.192/26_资源集合_GZ4P-SF-BZa-CACHE', 37, '', '', '10.129.40.192/26', '0023_0000000128', '', '26', 'GZ4P-SF-BZa-CACHE', '0030_0000000024', 98, '0018_0000000003'),
	('0023_0000000050', NULL, '0023_0000000050', NULL, '2019-12-24 08:54:37', NULL, '2019-12-18 06:23:35', '10.128.40.128/26_资源集合_GZ4P-SF-BZa-DB', 37, '', '', '10.128.40.128/26', '0023_0000000128', '', '26', 'GZ4P-SF-BZa-DB', '0030_0000000025', 98, '0018_0000000003'),
	('0023_0000000052', NULL, '0023_0000000052', NULL, '2019-12-24 08:54:00', NULL, '2019-12-18 06:25:35', '10.128.41.0/25_资源集合_GZ4P-SF-BZb-APP', 38, NULL, '', '10.128.41.0/25', '0023_0000000126', '', '25', 'GZ4P-SF-BZb-APP', '0030_0000000026', 98, '0018_0000000003'),
	('0023_0000000053', NULL, '0023_0000000053', NULL, '2019-12-24 08:53:27', NULL, '2019-12-18 06:26:36', '10.128.41.192/26_资源集合_GZ4P-SF-BZb-CACHE', 37, '', '', '10.128.41.192/26', '0023_0000000126', '', '26', 'GZ4P-SF-BZb-CACHE', '0030_0000000027', 98, '0018_0000000003'),
	('0023_0000000054', NULL, '0023_0000000054', NULL, '2019-12-24 08:51:27', NULL, '2019-12-18 06:27:32', '10.128.41.128/26_资源集合_GZ4P-SF-BZb-DB', 37, '', '', '10.128.41.128/26', '0023_0000000126', '', '26', 'GZ4P-SF-BZb-DB', '0030_0000000028', 98, '0018_0000000003'),
	('0023_0000000056', NULL, '0023_0000000056', NULL, '2019-12-24 09:05:58', NULL, '2019-12-18 06:31:12', '10.128.36.0/24_资源集合_GZ4P-SF-CS-APP', 37, '', '', '10.128.36.0/24', '0023_0000000124', '', '24', 'GZ4P-SF-CS-APP', '0030_0000000029', 98, '0018_0000000003'),
	('0023_0000000057', NULL, '0023_0000000057', NULL, '2019-12-24 08:46:30', NULL, '2019-12-18 06:32:33', '10.128.37.128/25_资源集合_GZ4P-SF-CS-CACHE', 37, '', '', '10.128.37.128/25', '0023_0000000124', '', '25', 'GZ4P-SF-CS-CACHE', '0030_0000000030', 98, '0018_0000000003'),
	('0023_0000000058', NULL, '0023_0000000058', NULL, '2019-12-24 08:45:39', NULL, '2019-12-18 06:33:30', '10.128.37.0/25_资源集合_GZ4P-SF-CS-DB', 37, '', '', '10.128.37.0/25', '0023_0000000124', '', '25', 'GZ4P-SF-CS-DB', '0030_0000000031', 98, '0018_0000000003'),
	('0023_0000000059', NULL, '0023_0000000059', NULL, '2019-12-24 08:44:46', NULL, '2019-12-18 06:34:18', '10.128.38.0/23_资源集合_GZ4P-SF-CS-BDP', 37, '', '', '10.128.38.0/23', '0023_0000000124', '', '23', 'GZ4P-SF-CS-BDP', '0030_0000000032', 98, '0018_0000000003'),
	('0023_0000000063', NULL, '0023_0000000063', NULL, '2019-12-24 08:43:50', NULL, '2019-12-18 06:41:05', '10.128.138.0/25_资源集合_GZ4P-DMZ-BZa-IN', 37, '', '', '10.128.138.0/25', '0023_0000000120', '', '25', 'GZ4P-DMZ-BZa-IN', '0030_0000000033', 98, '0018_0000000003'),
	('0023_0000000064', NULL, '0023_0000000064', NULL, '2019-12-24 08:42:52', NULL, '2019-12-18 06:41:54', '10.128.138.128/25_资源集合_GZ4P-DMZ-BZa-OUT', 37, '', '', '10.128.138.128/25', '0023_0000000120', '', '25', 'GZ4P-DMZ-BZa-OUT', '0030_0000000034', 98, '0018_0000000003'),
	('0023_0000000065', NULL, '0023_0000000065', NULL, '2019-12-24 08:39:52', NULL, '2019-12-18 06:42:44', '10.128.139.0/25_资源集合_GZ4P-DMZ-BZb-IN', 37, '', '', '10.128.139.0/25', '0023_0000000118', '', '25', 'GZ4P-DMZ-BZb-IN', '0030_0000000042', 98, '0018_0000000003'),
	('0023_0000000066', NULL, '0023_0000000066', NULL, '2019-12-24 08:39:07', NULL, '2019-12-18 06:44:20', '10.128.139.128/25_资源集合_GZ4P-DMZ-BZb-OUT', 37, '', '', '10.128.139.128/25', '0023_0000000118', '', '25', 'GZ4P-DMZ-BZb-OUT', '0030_0000000043', 98, '0018_0000000003'),
	('0023_0000000070', NULL, '0023_0000000070', NULL, '2019-12-24 08:38:20', NULL, '2019-12-18 06:48:08', '10.128.170.0/25_资源集合_GZ4P-ECN-BZa-OWN', 37, '', '', '10.128.170.0/25', '0023_0000000116', '', '25', 'GZ4P-ECN-BZa-OWN', '0030_0000000035', 98, '0018_0000000003'),
	('0023_0000000071', NULL, '0023_0000000071', NULL, '2019-12-24 08:37:32', NULL, '2019-12-18 06:49:03', '10.128.170.128/25_资源集合_GZ4P-ECN-BZa-NOWN', 37, '', '', '10.128.170.128/25', '0023_0000000116', '', '25', 'GZ4P-ECN-BZa-NOWN', '0030_0000000036', 98, '0018_0000000003'),
	('0023_0000000072', NULL, '0023_0000000072', NULL, '2019-12-24 10:48:06', NULL, '2019-12-18 06:50:08', '10.128.171.0/25_资源集合_GZ4P-ECN-BZb-OWN', 37, '', '', '10.128.171.0/25', '0023_0000000114', '', '25', 'GZ4P-ECN-BZb-OWN', '0030_0000000044', 98, '0018_0000000003'),
	('0023_0000000073', NULL, '0023_0000000073', NULL, '2019-12-24 08:33:29', NULL, '2019-12-18 06:50:54', '10.128.171.128/25_资源集合_GZ4P-ECN-BZb-NOWN', 37, '', '', '10.128.171.128/25', '0023_0000000114', '', '25', 'GZ4P-ECN-BZb-NOWN', '0030_0000000045', 98, '0018_0000000003'),
	('0023_0000000076', NULL, '0023_0000000076', NULL, '2019-12-24 08:32:46', NULL, '2019-12-18 06:53:33', '10.128.202.0/25_资源集合_GZ4P-MGMT-MT-APP', 37, '', '', '10.128.202.0/25', '0023_0000000122', '', '25', 'GZ4P-MGMT-MT-APP', '0030_0000000037', 98, '0018_0000000003'),
	('0023_0000000077', NULL, '0023_0000000077', NULL, '2019-12-24 08:31:53', NULL, '2019-12-18 06:54:28', '10.128.202.192/26_资源集合_GZ4P-MGMT-MT-CACHE', 37, '', '', '10.128.202.192/26', '0023_0000000122', '', '26', 'GZ4P-MGMT-MT-CACHE', '0030_0000000038', 98, '0018_0000000003'),
	('0023_0000000078', NULL, '0023_0000000078', NULL, '2019-12-24 08:31:07', NULL, '2019-12-18 06:55:20', '10.128.202.128/26_资源集合_GZ4P-MGMT-MT-DB', 37, '', '', '10.128.202.128/26', '0023_0000000122', '', '26', 'GZ4P-MGMT-MT-DB', '0030_0000000039', 98, '0018_0000000003'),
	('0023_0000000079', NULL, '0023_0000000079', NULL, '2019-12-24 08:25:52', NULL, '2019-12-18 06:56:03', '10.128.201.0/24_资源集合_GZ4P-MGMT-MT-BDP', 37, '', '', '10.128.201.0/24', '0023_0000000110', '', '24', 'GZ4P-MGMT-MT-BDP', '0030_0000000040', 98, '0018_0000000003'),
	('0023_0000000081', NULL, '0023_0000000081', NULL, '2019-12-24 08:23:12', NULL, '2019-12-18 06:58:37', '10.128.203.0/24_资源集合_GZ4P-MGMT-QZ-VDI', 37, '', '', '10.128.203.0/24', '0023_0000000112', '', '24', 'GZ4P-MGMT-QZ-VDI', '0030_0000000046', 98, '0018_0000000003'),
	('0023_0000000082', NULL, '0023_0000000082', NULL, '2019-12-24 10:28:41', NULL, '2019-12-19 10:32:00', '0.0.0.0/0_网络区域_WAN', 37, '', '', '0.0.0.0/0', '', '', '0', 'WAN', '0030_0000000048', 96, '0018_0000000002'),
	('0023_0000000083', NULL, '0023_0000000083', NULL, '2019-12-24 08:20:42', NULL, '2019-12-19 12:32:32', '10.128.0.0/23_资源集合_GZ3P-SF-CS-APPLB', 37, '', '', '10.128.0.0/23', '0023_0000000123', '', '23', 'GZ3P-SF-CS-APPLB', '0030_0000000054', 98, '0018_0000000001'),
	('0023_0000000084', NULL, '0023_0000000084', NULL, '2019-12-24 08:20:21', NULL, '2019-12-19 12:35:19', '10.128.32.0/23_资源集合_GZ4P-SF-CS-APPLB', 37, '', '', '10.128.32.0/23', '0023_0000000124', '', '23', 'GZ4P-SF-CS-APPLB', '0030_0000000054', 98, '0018_0000000003'),
	('0023_0000000085', NULL, '0023_0000000085', NULL, '2019-12-24 08:19:47', NULL, '2019-12-19 12:35:54', '10.128.128.0/24_资源集合_GZ3P-DMZ-CS-APPLB', 38, NULL, '', '10.128.128.0/24', '0023_0000000105', '', '24', 'GZ3P-DMZ-CS-APPLB', '0030_0000000055', 98, '0018_0000000001'),
	('0023_0000000086', NULL, '0023_0000000086', NULL, '2019-12-24 08:19:03', NULL, '2019-12-19 12:36:43', '10.128.136.0/24_资源集合_GZ4P-DMZ-CS-APPLB', 37, '', '', '10.128.136.0/24', '0023_0000000106', '', '24', 'GZ4P-DMZ-CS-APPLB', '0030_0000000055', 98, '0018_0000000003'),
	('0023_0000000087', NULL, '0023_0000000087', NULL, '2019-12-24 08:17:55', NULL, '2019-12-19 12:37:21', '10.128.160.0/24_资源集合_GZ3P-ECN-CS-APPLB', 37, '', '', '10.128.160.0/24', '0023_0000000107', '', '24', 'GZ3P-ECN-CS-APPLB', '0030_0000000056', 98, '0018_0000000001'),
	('0023_0000000088', NULL, '0023_0000000088', NULL, '2019-12-24 08:17:03', NULL, '2019-12-19 12:37:51', '10.128.168.0/24_资源集合_GZ4P-ECN-CS-APPLB', 37, '', '', '10.128.168.0/24', '0023_0000000108', '', '24', 'GZ4P-ECN-CS-APPLB', '0030_0000000056', 98, '0018_0000000003'),
	('0023_0000000089', NULL, '0023_0000000089', NULL, '2019-12-24 08:15:59', NULL, '2019-12-19 12:38:34', '10.128.192.0/25_资源集合_GZ3P-MGMT-CS-APPLB', 37, '', '', '10.128.192.0/25', '0023_0000000109', '', '25', 'GZ3P-MGMT-CS-APPLB', '0030_0000000057', 98, '0018_0000000001'),
	('0023_0000000090', NULL, '0023_0000000090', NULL, '2019-12-24 08:15:18', NULL, '2019-12-19 12:39:01', '10.128.200.0/25_资源集合_GZ4P-MGMT-CS-APPLB', 37, '', '', '10.128.200.0/25', '0023_0000000110', '', '25', 'GZ4P-MGMT-CS-APPLB', '0030_0000000057', 98, '0018_0000000003'),
	('0023_0000000091', NULL, '0023_0000000091', NULL, '2019-12-24 08:14:06', NULL, '2019-12-20 04:23:05', '10.128.2.0/23_资源集合_GZ3-SF-CS-DBLB', 37, '', '', '10.128.2.0/23', '0023_0000000123', '', '23', 'GZ3-SF-CS-DBLB', '0030_0000000058', 98, '0018_0000000001'),
	('0023_0000000092', NULL, '0023_0000000092', NULL, '2019-12-24 08:13:30', NULL, '2019-12-20 04:23:31', '10.128.34.0/23_资源集合_GZ4-SF-CS-DBLB', 37, '', '', '10.128.34.0/23', '0023_0000000124', '', '23', 'GZ4-SF-CS-DBLB', '0030_0000000058', 98, '0018_0000000003'),
	('0023_0000000093', NULL, '0023_0000000093', NULL, '2019-12-24 08:11:04', NULL, '2019-12-20 04:24:18', '10.128.192.128/25_资源集合_GZ3-MGMT-CS-DBLB', 37, '', '', '10.128.192.128/25', '0023_0000000109', '', '25', 'GZ3-MGMT-CS-DBLB', '0030_0000000059', 98, '0018_0000000001'),
	('0023_0000000094', NULL, '0023_0000000094', NULL, '2019-12-24 08:08:47', NULL, '2019-12-20 04:25:44', '10.128.200.128/25_资源集合_GZ4-MGMT-CS-DBLB', 37, '', '', '10.128.200.128/25', '0023_0000000110', '', '25', 'GZ4-MGMT-CS-DBLB', '0030_0000000059', 98, '0018_0000000003'),
	('0023_0000000096', NULL, '0023_0000000096', NULL, '2019-12-24 06:39:54', NULL, '2019-12-23 11:55:30', '10.128.0.0/19_网络区域_GZ3-SF', 37, '', '', '10.128.0.0/19', '0023_0000000003', '', '19', 'GZ3-SF', '0030_0000000003', 96, '0018_0000000001'),
	('0023_0000000097', NULL, '0023_0000000097', NULL, '2019-12-24 06:39:54', NULL, '2019-12-23 11:57:22', '10.128.32.0/19_网络区域_GZ4-SF', 37, '', '', '10.128.32.0/19', '0023_0000000003', '', '19', 'GZ4-SF', '0030_0000000003', 96, '0018_0000000003'),
	('0023_0000000098', NULL, '0023_0000000098', NULL, '2019-12-24 06:41:27', NULL, '2019-12-23 11:58:56', '10.128.128.0/21_网络区域_GZ3-DMZ', 37, '', '', '10.128.128.0/21', '0023_0000000017', '', '21', 'GZ3-DMZ', '0030_0000000005', 96, '0018_0000000001'),
	('0023_0000000099', NULL, '0023_0000000099', NULL, '2019-12-24 06:41:27', NULL, '2019-12-23 12:00:16', '10.128.136.0/21_网络区域_GZ4-DMZ', 37, '', '', '10.128.136.0/21', '0023_0000000017', '', '21', 'GZ4-DMZ', '0030_0000000005', 96, '0018_0000000003'),
	('0023_0000000100', NULL, '0023_0000000100', NULL, '2019-12-24 06:42:03', NULL, '2019-12-23 12:01:33', '10.128.160.0/21_网络区域_GZ3-ECN', 37, '', '', '10.128.160.0/21', '0023_0000000024', '', '21', 'GZ3-ECN', '0030_0000000006', 96, '0018_0000000001'),
	('0023_0000000101', NULL, '0023_0000000101', NULL, '2019-12-24 06:42:03', NULL, '2019-12-23 12:02:22', '10.128.168.0/21_网络区域_GZ4-ECN', 37, '', '', '10.128.168.0/21', '0023_0000000024', '', '21', 'GZ4-ECN', '0030_0000000006', 96, '0018_0000000003'),
	('0023_0000000102', NULL, '0023_0000000102', NULL, '2019-12-25 12:38:16', NULL, '2019-12-23 12:03:27', '10.128.192.0/21_网络区域_GZ3-MGMT', 37, '', '', '10.128.192.0/21', '0023_0000000031', '', '21', 'GZ3-MGMT', '0030_0000000004', 96, '0018_0000000001'),
	('0023_0000000103', NULL, '0023_0000000103', NULL, '2019-12-25 12:38:16', NULL, '2019-12-23 12:04:18', '10.128.200.0/21_网络区域_GZ4-MGMT', 37, '', '', '10.128.200.0/21', '0023_0000000031', '', '21', 'GZ4-MGMT', '0030_0000000004', 96, '0018_0000000003'),
	('0023_0000000104', NULL, '0023_0000000104', NULL, '2019-12-24 10:24:51', NULL, '2019-12-23 13:36:27', '0.0.0.0/0_资源集合_NDC-WAN-ALL-WANLB', 37, '', '', '0.0.0.0/0', '0023_0000000129', '', '0', 'NDC-WAN-ALL-WANLB', '0030_0000000071', 98, '0018_0000000002'),
	('0023_0000000105', NULL, '0023_0000000105', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 02:54:13', '10.128.128.0/23_业务区域_GZ3-DMZ-CS', 37, '', '', '10.128.128.0/23', '0023_0000000098', '', '23', 'GZ3-DMZ-CS', '0030_0000000067', 97, '0018_0000000001'),
	('0023_0000000106', NULL, '0023_0000000106', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 06:17:23', '10.128.136.0/23_业务区域_GZ4-DMZ-CS', 37, '', '', '10.128.136.0/23', '0023_0000000099', '', '23', 'GZ4-DMZ-CS', '0030_0000000067', 97, '0018_0000000003'),
	('0023_0000000107', NULL, '0023_0000000107', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 06:20:35', '10.128.160.0/23_业务区域_GZ3-ECN-CS', 37, '', '', '10.128.160.0/23', '0023_0000000100', '', '23', 'GZ3-ECN-CS', '0030_0000000066', 97, '0018_0000000001'),
	('0023_0000000108', NULL, '0023_0000000108', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 06:21:42', '10.128.168.0/23_业务区域_	 GZ4-ECN-CS', 37, '', '', '10.128.168.0/23', '0023_0000000101', '', '23', '	 GZ4-ECN-CS', '0030_0000000066', 97, '0018_0000000003'),
	('0023_0000000109', NULL, '0023_0000000109', NULL, '2019-12-24 07:50:11', NULL, '2019-12-24 06:24:36', '10.128.192.0/23_业务区域_GZ3-MGMT-CS', 37, '', '', '10.128.192.0/23', '0023_0000000102', '', '23', 'GZ3-MGMT-CS', '0030_0000000065', 97, '0018_0000000001'),
	('0023_0000000110', NULL, '0023_0000000110', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 06:25:33', '10.128.200.0/23_业务区域_GZ4-MGMT-CS', 37, '', '', '10.128.200.0/23', '0023_0000000103', '', '23', 'GZ4-MGMT-CS', '0030_0000000065', 97, '0018_0000000003'),
	('0023_0000000111', NULL, '0023_0000000111', NULL, '2019-12-24 07:50:11', NULL, '2019-12-24 06:28:45', '10.128.195.0/24_业务区域_GZ3-MGMT-QZ', 37, '', '', '10.128.195.0/24', '0023_0000000102', '', '24', 'GZ3-MGMT-QZ', '0030_0000000041', 97, '0018_0000000001'),
	('0023_0000000112', NULL, '0023_0000000112', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 06:30:03', '10.128.203.0/24_业务区域_GZ4-MGMT-QZ', 37, '', '', '10.128.203.0/24', '0023_0000000103', '', '24', 'GZ4-MGMT-QZ', '0030_0000000041', 97, '0018_0000000003'),
	('0023_0000000113', NULL, '0023_0000000113', NULL, '2019-12-24 07:50:11', NULL, '2019-12-24 06:40:44', '10.128.163.0/24_业务区域_GZ3-ECN-BZb', 37, '', '', '10.128.163.0/24', '0023_0000000100', '', '24', 'GZ3-ECN-BZb', '0030_0000000018', 97, '0018_0000000001'),
	('0023_0000000114', NULL, '0023_0000000114', NULL, '2019-12-24 08:16:56', NULL, '2019-12-24 06:42:00', '10.128.171.0/24_业务区域_GZ4-ECN-BZb', 37, '', '', '10.128.171.0/24', '0023_0000000101', '', '24', 'GZ4-ECN-BZb', '0030_0000000018', 97, '0018_0000000003'),
	('0023_0000000115', NULL, '0023_0000000115', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:43:42', '10.128.162.0/24_业务区域_GZ3-ECN-BZa', 37, '', '', '10.128.162.0/24', '0023_0000000100', '', '24', 'GZ3-ECN-BZa', '0030_0000000017', 97, '0018_0000000001'),
	('0023_0000000116', NULL, '0023_0000000116', NULL, '2019-12-24 06:46:14', NULL, '2019-12-24 06:44:44', '10.128.170.0/24_业务区域_GZ4-ECN-BZa', 37, '', '', '10.128.170.0/24', '0023_0000000101', '', '24', 'GZ4-ECN-BZa', '0030_0000000017', 97, '0018_0000000003'),
	('0023_0000000117', NULL, '0023_0000000117', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:46:10', '10.128.131.0/24_业务区域_GZ3-DMZ-BZb', 37, '', '', '10.128.131.0/24', '0023_0000000098', '', '24', 'GZ3-DMZ-BZb', '0030_0000000016', 97, '0018_0000000001'),
	('0023_0000000118', NULL, '0023_0000000118', NULL, '2019-12-24 06:47:51', NULL, '2019-12-24 06:47:51', '10.128.139.0/24_业务区域_GZ4-DMZ-BZb', 37, '', '', '10.128.139.0/24', '0023_0000000099', '', '24', 'GZ4-DMZ-BZb', '0030_0000000016', 97, '0018_0000000003'),
	('0023_0000000119', NULL, '0023_0000000119', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:49:43', '10.128.130.0/24_业务区域_GZ3-DMZ-BZa', 37, '', '', '10.128.130.0/24', '0023_0000000098', '', '24', 'GZ3-DMZ-BZa', '0030_0000000015', 97, '0018_0000000001'),
	('0023_0000000120', NULL, '0023_0000000120', NULL, '2019-12-24 06:50:28', NULL, '2019-12-24 06:50:28', '10.128.138.0/24_业务区域_GZ4-DMZ-BZa', 37, '', '', '10.128.138.0/24', '0023_0000000099', '', '24', 'GZ4-DMZ-BZa', '0030_0000000015', 97, '0018_0000000003'),
	('0023_0000000121', NULL, '0023_0000000121', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:52:09', '10.128.194.0/24_业务区域_GZ3-MGMT-MT', 37, '', '', '10.128.194.0/24', '0023_0000000102', '', '24', 'GZ3-MGMT-MT', '0030_0000000014', 97, '0018_0000000001'),
	('0023_0000000122', NULL, '0023_0000000122', NULL, '2019-12-24 06:53:00', NULL, '2019-12-24 06:53:00', '10.128.202.0/24_业务区域_GZ4-MGMT-MT', 37, '', '', '10.128.202.0/24', '0023_0000000103', '', '24', 'GZ4-MGMT-MT', '0030_0000000014', 97, '0018_0000000003'),
	('0023_0000000123', NULL, '0023_0000000123', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:54:29', '10.128.0.0/21_业务区域_GZ3-SF-CS', 37, '', '', '10.128.0.0/21', '0023_0000000096', '', '21', 'GZ3-SF-CS', '0030_0000000013', 97, '0018_0000000001'),
	('0023_0000000124', NULL, '0023_0000000124', NULL, '2019-12-24 06:55:22', NULL, '2019-12-24 06:55:22', '10.128.32.0/21_业务区域_GZ4-SF-CS', 37, '', '', '10.128.32.0/21', '0023_0000000097', '', '21', 'GZ4-SF-CS', '0030_0000000013', 97, '0018_0000000003'),
	('0023_0000000125', NULL, '0023_0000000125', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:56:39', '10.128.9.0/24_业务区域_GZ3-SF-BZb', 37, '', '', '10.128.9.0/24', '0023_0000000096', '', '24', 'GZ3-SF-BZb', '0030_0000000012', 97, '0018_0000000001'),
	('0023_0000000126', NULL, '0023_0000000126', NULL, '2019-12-24 06:58:22', NULL, '2019-12-24 06:58:22', '10.128.41.0/24_业务区域_GZ4-SF-BZb', 37, '', '', '10.128.41.0/24', '0023_0000000097', '', '24', 'GZ4-SF-BZb', '0030_0000000012', 97, '0018_0000000003'),
	('0023_0000000127', NULL, '0023_0000000127', NULL, '2019-12-24 07:50:10', NULL, '2019-12-24 06:59:25', '10.128.8.0/24_业务区域_GZ3-SF-BZa', 37, '', '', '10.128.8.0/24', '0023_0000000096', '', '24', 'GZ3-SF-BZa', '0030_0000000011', 97, '0018_0000000001'),
	('0023_0000000128', NULL, '0023_0000000128', NULL, '2019-12-24 07:00:31', NULL, '2019-12-24 07:00:31', '10.128.40.0/24_业务区域_GZ4-SF-BZa', 37, '', '', '10.128.40.0/24', '0023_0000000097', '', '24', 'GZ4-SF-BZa', '0030_0000000011', 97, '0018_0000000003'),
	('0023_0000000129', NULL, '0023_0000000129', NULL, '2019-12-24 10:28:41', NULL, '2019-12-24 07:06:40', '0.0.0.0/0_业务区域_NDC-WAN-ALL', 37, '', '', '0.0.0.0/0', '0023_0000000137', '', '0', 'NDC-WAN-ALL', '0030_0000000069', 97, '0018_0000000002'),
	('0023_0000000130', NULL, '0023_0000000130', NULL, '2019-12-24 10:22:58', NULL, '2019-12-24 07:18:03', '10.1.0.0/20_业务区域_NDC-OPN-ALL', 37, '', '', '10.1.0.0/20', '0023_0000000041', '', '20', 'NDC-OPN-ALL', '0030_0000000022', 97, '0018_0000000002'),
	('0023_0000000131', NULL, '0023_0000000131', NULL, '2019-12-24 07:26:55', NULL, '2019-12-24 07:26:55', '10.2.1.0/24_网络区域_PTN', 37, '', '', '10.2.1.0/24', '0023_0000000037', '', '24', 'PTN', '0030_0000000010', 96, '0018_0000000002'),
	('0023_0000000132', NULL, '0023_0000000132', NULL, '2019-12-24 10:22:58', NULL, '2019-12-24 07:27:51', '10.2.1.0/24_业务区域_NDC-PTN-ALL', 37, '', '', '10.2.1.0/24', '0023_0000000131', '', '24', 'NDC-PTN-ALL', '0030_0000000021', 97, '0018_0000000002'),
	('0023_0000000133', NULL, '0023_0000000085', NULL, '2019-12-24 07:42:15', NULL, '2019-12-19 12:35:54', '10.128.128.0/24_资源集合_GZ3P-DMZ-CS-APPLB', 37, '2019-12-24 07:42:14', '', '10.128.128.0/24', '0023_0000000017', '', '24', 'GZ3P-DMZ-CS-APPLB', '0030_0000000055', 98, '0018_0000000001'),
	('0023_0000000134', NULL, '0023_0000000052', NULL, '2019-12-24 07:46:05', NULL, '2019-12-18 06:25:35', '10.128.36.128/25_资源集合_GZ4P-SF-BZb-APP', 37, '2019-12-24 07:46:04', '', '10.128.36.128/25', '0023_0000000003', '', '25', 'GZ4P-SF-BZb-APP', '0030_0000000026', 98, '0018_0000000003'),
	('0023_0000000137', NULL, '0023_0000000137', NULL, '2019-12-24 10:24:51', NULL, '2019-12-24 10:18:54', '0.0.0.0/0_网络区域_NDC-WAN', 37, '', '', '0.0.0.0/0', '0023_0000000037', '', '0', 'NDC-WAN', '0030_0000000048', 96, '0018_0000000002'),
	('0023_0000000138', NULL, '0023_0000000138', NULL, '2019-12-24 10:40:25', NULL, '2019-12-24 10:40:25', '0.0.0.0/0_资源集合_NDC-WAN-ALL-WS', 37, '', '', '0.0.0.0/0', '0023_0000000129', '', '0', 'NDC-WAN-ALL-WS', '0030_0000000070', 98, '0018_0000000002');
/*!40000 ALTER TABLE `network_segment` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.network_segment_design 的数据：~60 rows (大约)
/*!40000 ALTER TABLE `network_segment_design` DISABLE KEYS */;
INSERT INTO `network_segment_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `f_network_segment`, `mask`, `name`, `network_segment_usage`, `data_center_design`) VALUES
	('0030_0000000001', NULL, '0030_0000000001', NULL, '2019-12-22 09:16:01', NULL, '2019-12-15 15:14:31', '10.*.0.0/16_数据中心_', 34, '', '', '10.*.0.0/16', '', '0', '', 95, '0025_0000000001'),
	('0030_0000000003', NULL, '0030_0000000003', NULL, '2019-12-24 06:39:54', NULL, '2019-12-15 15:21:22', '10.*.[0,32,64,96].0/19_网络区域_SF', 34, '', '', '10.*.[0,32,64,96].0/19', '0030_0000000001', '19', 'SF', 96, '0025_0000000001'),
	('0030_0000000004', NULL, '0030_0000000004', NULL, '2019-12-25 12:38:16', NULL, '2019-12-15 15:23:45', '10.*.[192,200,208,216].0/21_网络区域_MGMT', 34, '', '', '10.*.[192,200,208,216].0/21', '0030_0000000001', '21', 'MGMT', 96, '0025_0000000001'),
	('0030_0000000005', NULL, '0030_0000000005', NULL, '2019-12-24 06:41:27', NULL, '2019-12-15 15:24:56', '10.*.[128,136,144,152].0/21_网络区域_DMZ', 34, '', '', '10.*.[128,136,144,152].0/21', '0030_0000000001', '21', 'DMZ', 96, '0025_0000000001'),
	('0030_0000000006', NULL, '0030_0000000006', NULL, '2019-12-24 06:42:03', NULL, '2019-12-15 15:25:43', '10.*.[160,168,176,184].0/21_网络区域_ECN', 34, '', '', '10.*.[160,168,176,184].0/21', '0030_0000000001', '21', 'ECN', 96, '0025_0000000001'),
	('0030_0000000009', NULL, '0030_0000000009', NULL, '2019-12-22 09:16:49', NULL, '2019-12-15 15:36:57', '10.1.0.0/20_网络区域_OPN', 34, '', '', '10.1.0.0/20', '0030_0000000001', '20', 'OPN', 96, '0025_0000000001'),
	('0030_0000000010', NULL, '0030_0000000010', NULL, '2019-12-24 07:19:36', NULL, '2019-12-15 15:39:17', '10.2.1.0/24_网络区域_PTN', 34, '', '', '10.2.1.0/24', '0030_0000000001', '24', 'PTN', 96, '0025_0000000001'),
	('0030_0000000011', NULL, '0030_0000000011', NULL, '2019-12-24 06:48:38', NULL, '2019-12-15 15:42:32', '10.*.[8,40,72,104].0/24_业务区域_SF-BZa', 34, '', '', '10.*.[8,40,72,104].0/24', '0030_0000000003', '24', 'SF-BZa', 97, '0025_0000000001'),
	('0030_0000000012', NULL, '0030_0000000012', NULL, '2019-12-24 06:48:38', NULL, '2019-12-15 15:43:19', '10.*.[9,41,73,105].0/24_业务区域_SF-BZb', 34, '', '', '10.*.[9,41,73,105].0/24', '0030_0000000003', '24', 'SF-BZb', 97, '0025_0000000001'),
	('0030_0000000013', NULL, '0030_0000000013', NULL, '2019-12-24 06:48:38', NULL, '2019-12-15 15:47:49', '10.*.[0,32,64,96].0/21_业务区域_SF-CS', 34, '', '', '10.*.[0,32,64,96].0/21', '0030_0000000003', '21', 'SF-CS', 97, '0025_0000000001'),
	('0030_0000000014', NULL, '0030_0000000014', NULL, '2019-12-24 06:48:38', NULL, '2019-12-15 15:50:46', '10.*.[194,202,210,218].0/24_业务区域_MGMT-MT', 34, '', '', '10.*.[194,202,210,218].0/24', '0030_0000000004', '24', 'MGMT-MT', 97, '0025_0000000001'),
	('0030_0000000015', NULL, '0030_0000000015', NULL, '2019-12-24 06:48:38', NULL, '2019-12-15 15:51:35', '10.*.[130,138,146,154].0/24_业务区域_DMZ-BZa', 34, '', '', '10.*.[130,138,146,154].0/24', '0030_0000000005', '24', 'DMZ-BZa', 97, '0025_0000000001'),
	('0030_0000000016', NULL, '0030_0000000016', NULL, '2019-12-24 06:46:15', NULL, '2019-12-15 15:52:38', '10.*.[131,139,147,155].0/24_业务区域_DMZ-BZb', 34, '', '', '10.*.[131,139,147,155].0/24', '0030_0000000005', '24', 'DMZ-BZb', 97, '0025_0000000001'),
	('0030_0000000017', NULL, '0030_0000000017', NULL, '2019-12-24 06:46:14', NULL, '2019-12-15 15:53:24', '10.*.[162,170,178,186].0/24_业务区域_ECN-BZa', 34, '', '', '10.*.[162,170,178,186].0/24', '0030_0000000006', '24', 'ECN-BZa', 97, '0025_0000000001'),
	('0030_0000000018', NULL, '0030_0000000018', NULL, '2019-12-24 06:46:14', NULL, '2019-12-15 15:53:57', '10.*.[163,171,179,187].0/24_业务区域_ECN-BZb', 34, '', '', '10.*.[163,171,179,187].0/24', '0030_0000000006', '24', 'ECN-BZb', 97, '0025_0000000001'),
	('0030_0000000021', NULL, '0030_0000000021', NULL, '2019-12-24 06:46:14', NULL, '2019-12-15 16:00:39', '10.2.1.0/24_业务区域_PTN-ALL', 34, '', '', '10.2.1.0/24', '0030_0000000010', '24', 'PTN-ALL', 97, '0025_0000000001'),
	('0030_0000000022', NULL, '0030_0000000022', NULL, '2019-12-24 06:46:14', NULL, '2019-12-15 16:03:32', '10.1.[0,32,64,96].0/20_业务区域_OPN-ALL', 34, '', '', '10.1.[0,32,64,96].0/20', '0030_0000000009', '20', 'OPN-ALL', 97, '0025_0000000001'),
	('0030_0000000023', NULL, '0030_0000000023', NULL, '2019-12-24 07:02:20', NULL, '2019-12-15 16:18:40', '10.*.[8,40,72,104].0/25_资源集合_SF-BZa-APP', 34, '', '', '10.*.[8,40,72,104].0/25', '0030_0000000011', '25', 'SF-BZa-APP', 98, '0025_0000000001'),
	('0030_0000000024', NULL, '0030_0000000024', NULL, '2019-12-24 07:02:20', NULL, '2019-12-15 16:20:19', '10.*.[8,40,72,104].192/26_资源集合_SF-BZa-CACHE', 34, '', '', '10.*.[8,40,72,104].192/26', '0030_0000000011', '26', 'SF-BZa-CACHE', 98, '0025_0000000001'),
	('0030_0000000025', NULL, '0030_0000000025', NULL, '2019-12-24 07:02:20', NULL, '2019-12-15 16:21:02', '10.*.[8,40,72,104].128/26_资源集合_SF-BZa-DB', 34, '', '', '10.*.[8,40,72,104].128/26', '0030_0000000011', '26', 'SF-BZa-DB', 98, '0025_0000000001'),
	('0030_0000000026', NULL, '0030_0000000026', NULL, '2019-12-24 07:02:20', NULL, '2019-12-15 16:22:21', '10.*.[9,41,73,105].0/25_资源集合_SF-BZb-APP', 34, '', '', '10.*.[9,41,73,105].0/25', '0030_0000000012', '25', 'SF-BZb-APP', 98, '0025_0000000001'),
	('0030_0000000027', NULL, '0030_0000000027', NULL, '2019-12-24 07:02:19', NULL, '2019-12-15 16:22:54', '10.*.[9,41,73,105].192/26_资源集合_SF-BZb-CACHE', 34, '', '', '10.*.[9,41,73,105].192/26', '0030_0000000012', '26', 'SF-BZb-CACHE', 98, '0025_0000000001'),
	('0030_0000000028', NULL, '0030_0000000028', NULL, '2019-12-24 07:02:19', NULL, '2019-12-15 16:23:25', '10.*.[9,41,73,105].128/26_资源集合_SF-BZb-DB', 34, '', '', '10.*.[9,41,73,105].128/26', '0030_0000000012', '26', 'SF-BZb-DB', 98, '0025_0000000001'),
	('0030_0000000029', NULL, '0030_0000000029', NULL, '2019-12-24 07:02:19', NULL, '2019-12-15 16:24:38', '10.*.[4,36,68,100].0/24_资源集合_SF-CS-APP', 34, '', '', '10.*.[4,36,68,100].0/24', '0030_0000000013', '24', 'SF-CS-APP', 98, '0025_0000000001'),
	('0030_0000000030', NULL, '0030_0000000030', NULL, '2019-12-24 06:59:42', NULL, '2019-12-15 16:25:08', '10.*.[5,37,69,101].128/25_资源集合_SF-CS-CACHE', 34, '', '', '10.*.[5,37,69,101].128/25', '0030_0000000013', '25', 'SF-CS-CACHE', 98, '0025_0000000001'),
	('0030_0000000031', NULL, '0030_0000000031', NULL, '2019-12-24 06:59:42', NULL, '2019-12-15 16:25:41', '10.*.[5,37,69,101].0/25_资源集合_SF-CS-DB', 34, '', '', '10.*.[5,37,69,101].0/25', '0030_0000000013', '25', 'SF-CS-DB', 98, '0025_0000000001'),
	('0030_0000000032', NULL, '0030_0000000032', NULL, '2019-12-24 06:59:42', NULL, '2019-12-15 16:38:23', '10.*.[6,38,70,102].0/23_资源集合_SF-CS-BDP', 34, '', '', '10.*.[6,38,70,102].0/23', '0030_0000000013', '23', 'SF-CS-BDP', 98, '0025_0000000001'),
	('0030_0000000033', NULL, '0030_0000000033', NULL, '2019-12-24 06:59:41', NULL, '2019-12-15 16:40:14', '10.*.[130,138,146,174].0/25_资源集合_DMZ-BZa-IN', 34, '', '', '10.*.[130,138,146,174].0/25', '0030_0000000015', '25', 'DMZ-BZa-IN', 98, '0025_0000000001'),
	('0030_0000000034', NULL, '0030_0000000034', NULL, '2019-12-24 06:59:41', NULL, '2019-12-15 16:40:59', '10.*.[130,138,146,174].128/25_资源集合_DMZ-BZa-OUT', 34, '', '', '10.*.[130,138,146,174].128/25', '0030_0000000015', '25', 'DMZ-BZa-OUT', 98, '0025_0000000001'),
	('0030_0000000035', NULL, '0030_0000000035', NULL, '2019-12-24 06:59:41', NULL, '2019-12-15 16:45:03', '10.*.[162,170,178,186].0/25_资源集合_ECN-BZa-OWN', 34, '', '', '10.*.[162,170,178,186].0/25', '0030_0000000017', '25', 'ECN-BZa-OWN', 98, '0025_0000000001'),
	('0030_0000000036', NULL, '0030_0000000036', NULL, '2019-12-24 06:59:41', NULL, '2019-12-15 16:46:36', '10.*.[162,170,178,186].128/25_资源集合_ECN-BZa-NOWN', 34, '', '', '10.*.[162,170,178,186].128/25', '0030_0000000017', '25', 'ECN-BZa-NOWN', 98, '0025_0000000001'),
	('0030_0000000037', NULL, '0030_0000000037', NULL, '2019-12-24 06:59:41', NULL, '2019-12-15 16:47:52', '10.*.[194,202,210,218].0/25_资源集合_MGMT-MT-APP', 34, '', '', '10.*.[194,202,210,218].0/25', '0030_0000000014', '25', 'MGMT-MT-APP', 98, '0025_0000000001'),
	('0030_0000000038', NULL, '0030_0000000038', NULL, '2019-12-24 06:59:40', NULL, '2019-12-15 16:48:14', '10.*.[194,202,210,218].192/26_资源集合_MGMT-MT-CACHE', 34, '', '', '10.*.[194,202,210,218].192/26', '0030_0000000014', '26', 'MGMT-MT-CACHE', 98, '0025_0000000001'),
	('0030_0000000039', NULL, '0030_0000000039', NULL, '2019-12-24 06:59:40', NULL, '2019-12-15 16:48:35', '10.*.[194,202,210,218].128/26_资源集合_MGMT-MT-DB', 34, '', '', '10.*.[194,202,210,218].128/26', '0030_0000000014', '26', 'MGMT-MT-DB', 98, '0025_0000000001'),
	('0030_0000000040', NULL, '0030_0000000040', NULL, '2019-12-24 06:57:16', NULL, '2019-12-15 16:49:16', '10.*.[193,201,209,217].0/24_资源集合_MGMT-CS-BDP', 34, '', '', '10.*.[193,201,209,217].0/24', '0030_0000000065', '24', 'MGMT-CS-BDP', 98, '0025_0000000001'),
	('0030_0000000041', NULL, '0030_0000000041', NULL, '2019-12-24 06:46:14', NULL, '2019-12-16 09:24:12', '10.*.[195,203,211,219].0/24_业务区域_MGMT-QZ', 34, '', '', '10.*.[195,203,211,219].0/24', '0030_0000000004', '24', 'MGMT-QZ', 97, '0025_0000000001'),
	('0030_0000000042', NULL, '0030_0000000042', NULL, '2019-12-24 06:57:15', NULL, '2019-12-16 10:57:22', '10.*.[131,139,147,155].0/25_资源集合_DMZ-BZb-IN', 34, '', '', '10.*.[131,139,147,155].0/25', '0030_0000000016', '25', 'DMZ-BZb-IN', 98, '0025_0000000001'),
	('0030_0000000043', NULL, '0030_0000000043', NULL, '2019-12-24 06:57:15', NULL, '2019-12-16 10:59:40', '10.*.[131,139,147,155].128/25_资源集合_DMZ-BZb-OUT', 34, '', '', '10.*.[131,139,147,155].128/25', '0030_0000000016', '25', 'DMZ-BZb-OUT', 98, '0025_0000000001'),
	('0030_0000000044', NULL, '0030_0000000044', NULL, '2019-12-24 06:57:15', NULL, '2019-12-16 11:19:31', '10.*.[163,171,179,187].0/25_资源集合_ECN-BZb-OWN', 34, '', '', '10.*.[163,171,179,187].0/25', '0030_0000000018', '25', 'ECN-BZb-OWN', 98, '0025_0000000001'),
	('0030_0000000045', NULL, '0030_0000000045', NULL, '2019-12-24 06:57:15', NULL, '2019-12-16 11:20:10', '10.*.[163,171,179,187].128/25_资源集合_ECN-BZb-NOWN', 34, '', '', '10.*.[163,171,179,187].128/25', '0030_0000000018', '25', 'ECN-BZb-NOWN', 98, '0025_0000000001'),
	('0030_0000000046', NULL, '0030_0000000046', NULL, '2019-12-24 06:57:15', NULL, '2019-12-16 11:29:02', '10.*.[195,203,211,219].0/24_资源集合_MGMT-QZ-VDI', 34, '', '', '10.*.[195,203,211,219].0/24', '0030_0000000041', '24', 'MGMT-QZ-VDI', 98, '0025_0000000001'),
	('0030_0000000048', NULL, '0030_0000000048', NULL, '2019-12-23 11:35:53', NULL, '2019-12-16 11:50:03', '0.0.0.0/0_网络区域_WAN', 34, '', '', '0.0.0.0/0', '', '0', 'WAN', 96, '0025_0000000001'),
	('0030_0000000052', NULL, '0030_0000000052', NULL, '2019-12-24 06:57:15', NULL, '2019-12-17 02:22:13', '10.1.0.0/24_资源集合_OPN-ALL-VC', 34, '', '', '10.1.0.0/24', '0030_0000000022', '24', 'OPN-ALL-VC', 98, '0025_0000000001'),
	('0030_0000000053', NULL, '0030_0000000053', NULL, '2019-12-24 06:57:14', NULL, '2019-12-17 02:26:09', '10.2.1.0/28_资源集合_PTN-ALL-FRONT', 34, '', '', '10.2.1.0/28', '0030_0000000021', '24', 'PTN-ALL-FRONT', 98, '0025_0000000001'),
	('0030_0000000054', NULL, '0030_0000000054', NULL, '2019-12-24 06:57:14', NULL, '2019-12-19 11:43:28', '10.*.[0,32,64,96].0/23_资源集合_SF-CS-APPLB', 34, '', '', '10.*.[0,32,64,96].0/23', '0030_0000000013', '23', 'SF-CS-APPLB', 98, '0025_0000000001'),
	('0030_0000000055', NULL, '0030_0000000055', NULL, '2019-12-24 06:57:14', NULL, '2019-12-19 11:46:10', '10.*.[128,136,144,152].0/24_资源集合_DMZ-CS-APPLB', 34, '', '', '10.*.[128,136,144,152].0/24', '0030_0000000067', '24', 'DMZ-CS-APPLB', 98, '0025_0000000001'),
	('0030_0000000056', NULL, '0030_0000000056', NULL, '2019-12-24 06:53:29', NULL, '2019-12-19 11:49:40', '10.*.[160,168,176,184].0/24_资源集合_ECN-CS-APPLB', 34, '', '', '10.*.[160,168,176,184].0/24', '0030_0000000066', '24', 'ECN-CS-APPLB', 98, '0025_0000000001'),
	('0030_0000000057', NULL, '0030_0000000057', NULL, '2019-12-24 06:53:29', NULL, '2019-12-19 11:51:16', '10.*.[192,200,208,216].0/25_资源集合_MGMT-CS-APPLB', 34, '', '', '10.*.[192,200,208,216].0/25', '0030_0000000065', '25', 'MGMT-CS-APPLB', 98, '0025_0000000001'),
	('0030_0000000058', NULL, '0030_0000000058', NULL, '2019-12-24 06:53:29', NULL, '2019-12-19 20:12:59', '10.*.[2,34,66,98].0/23_资源集合_SF-CS-DBLB', 34, '', '', '10.*.[2,34,66,98].0/23', '0030_0000000013', '23', 'SF-CS-DBLB', 98, '0025_0000000001'),
	('0030_0000000059', NULL, '0030_0000000059', NULL, '2019-12-24 06:53:29', NULL, '2019-12-19 20:13:52', '10.*.[192,200,208,216].128/25_资源集合_MGMT-CS-DBLB', 34, '', '', '10.*.[192,200,208,216].128/25', '0030_0000000065', '25', 'MGMT-CS-DBLB', 98, '0025_0000000001'),
	('0030_0000000060', NULL, '0030_0000000060', NULL, '2019-12-24 06:53:29', NULL, '2019-12-20 03:40:12', '10.*.[129,137,145,153].129.0/25_资源集合_DMZ-CS-IN', 34, '', '', '10.*.[129,137,145,153].129.0/25', '0030_0000000067', '25', 'DMZ-CS-IN', 98, '0025_0000000001'),
	('0030_0000000061', NULL, '0030_0000000061', NULL, '2019-12-24 06:53:29', NULL, '2019-12-20 03:40:46', '10.*.[129,137,145,153].128/25_资源集合_DMZ-CS-OUT', 34, '', '', '10.*.[129,137,145,153].128/25', '0030_0000000067', '25', 'DMZ-CS-OUT', 98, '0025_0000000001'),
	('0030_0000000062', NULL, '0030_0000000062', NULL, '2019-12-24 06:53:29', NULL, '2019-12-20 03:42:46', '10.*.[161,169,177,185].128/25_资源集合_ECN-CS-NOWN', 34, '', '', '10.*.[161,169,177,185].128/25', '0030_0000000066', '25', 'ECN-CS-NOWN', 98, '0025_0000000001'),
	('0030_0000000063', NULL, '0030_0000000063', NULL, '2019-12-24 06:53:28', NULL, '2019-12-20 03:43:28', '10.*.[161,169,177,185].0/25_资源集合_ECN-CS-OWN', 34, '', '', '10.*.[161,169,177,185].0/25', '0030_0000000066', '25', 'ECN-CS-OWN', 98, '0025_0000000001'),
	('0030_0000000065', NULL, '0030_0000000065', NULL, '2019-12-24 06:46:14', NULL, '2019-12-20 16:18:11', '10.*.[192,200,208,216].0/23_业务区域_MGMT-CS', 34, '', '', '10.*.[192,200,208,216].0/23', '0030_0000000004', '22', 'MGMT-CS', 97, '0025_0000000001'),
	('0030_0000000066', NULL, '0030_0000000066', NULL, '2019-12-24 06:46:14', NULL, '2019-12-20 16:25:27', '10.*.[160,168,174,152].0/23_业务区域_ECN-CS', 34, '', '', '10.*.[160,168,174,152].0/23', '0030_0000000006', '23', 'ECN-CS', 97, '0025_0000000001'),
	('0030_0000000067', NULL, '0030_0000000067', NULL, '2019-12-24 06:46:14', NULL, '2019-12-20 16:26:55', '10.*.[128,136,144,152].0/23_业务区域_DMZ-CS', 34, '', '', '10.*.[128,136,144,152].0/23', '0030_0000000005', '23', 'DMZ-CS', 97, '0025_0000000001'),
	('0030_0000000069', NULL, '0030_0000000069', NULL, '2019-12-24 06:46:13', NULL, '2019-12-23 13:29:00', '0.0.0.0/0_业务区域_WAN-ALL', 34, '', '', '0.0.0.0/0', '0030_0000000048', '0', 'WAN-ALL', 97, '0025_0000000001'),
	('0030_0000000070', NULL, '0030_0000000070', NULL, '2019-12-24 06:53:28', NULL, '2019-12-23 13:30:32', '0.0.0.0/0_资源集合_WAN-ALL-ALL', 34, '', '', '0.0.0.0/0', '0030_0000000069', '0', 'WAN-ALL-ALL', 98, '0025_0000000001'),
	('0030_0000000071', NULL, '0030_0000000071', NULL, '2019-12-24 06:53:28', NULL, '2019-12-23 13:33:07', '0.0.0.0/0_资源集合_WAN-ALL-WANLB', 34, '', '', '0.0.0.0/0', '0030_0000000069', '0', 'WAN-ALL-WANLB', 98, '0025_0000000001');
/*!40000 ALTER TABLE `network_segment_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.network_zone 的数据：~29 rows (大约)
/*!40000 ALTER TABLE `network_zone` DISABLE KEYS */;
INSERT INTO `network_zone` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `data_center`, `name`, `network_segment`, `network_zone_design`, `network_zone_layer`, `vpc_network_zone`, `network_zone_type`, `vpc_asset_code`, `security_group_asset_code`, `route_table_asset_code`) VALUES
	('0019_0000000001', '0019_0000000032', '0019_0000000001', NULL, '2019-12-31 05:08:34', NULL, '2019-12-16 02:17:17', 'GZP_SF', 38, '2019-12-31 05:08:33', '', 'SF', '0018_0000000004', '业务网络区域', '0023_0000000003', '0026_0000000001', 80, NULL, 379, 'vpc-6b27f6zr', 'sg-0cb9zcnb', 'rtb-ewot6u12'),
	('0019_0000000002', '0019_0000000033', '0019_0000000002', NULL, '2019-12-31 05:08:34', NULL, '2019-12-17 17:33:16', 'GZP_DMZ', 38, '2019-12-31 05:08:33', '', 'DMZ', '0018_0000000004', '广域网络连接区域', '0023_0000000017', '0026_0000000003', 79, NULL, 379, 'vpc-jotfouct', 'sg-b3y6jlxh', 'rtb-9fn5rz8m'),
	('0019_0000000003', '0019_0000000037', '0019_0000000003', NULL, '2020-01-10 02:46:27', NULL, '2019-12-17 17:34:01', 'GZP_ECN', 38, '2020-01-10 02:46:26', '', 'ECN', '0018_0000000004', '伙伴网络接入区域', '0023_0000000024', '0026_0000000004', 79, NULL, 379, 'vpc-6zzot79l', 'sg-4f9cghpr', 'rtb-kpuo97ya'),
	('0019_0000000004', '0019_0000000036', '0019_0000000004', NULL, '2020-01-10 02:46:27', NULL, '2019-12-17 17:34:34', 'GZP_MGMT', 38, '2020-01-10 02:46:26', '', 'MGMT', '0018_0000000004', '运营操作网络区域', '0023_0000000031', '0026_0000000002', 79, NULL, 379, 'vpc-mnd798i7', 'sg-9so3kv3j', 'rtb-o4y8okzy'),
	('0019_0000000005', NULL, '0019_0000000005', NULL, '2019-12-24 10:27:29', NULL, '2019-12-17 17:41:43', 'NDC_WAN', 37, '', '', 'WAN', '0018_0000000002', '广域网', '0023_0000000137', '0026_0000000006', 78, NULL, 380, NULL, NULL, NULL),
	('0019_0000000006', NULL, '0019_0000000006', NULL, '2019-12-17 18:16:59', NULL, '2019-12-17 17:48:58', 'NDC_OPN', 37, '', '', 'OPN', '0018_0000000002', '运营操作网络区域', '0023_0000000041', '0026_0000000007', 78, NULL, NULL, NULL, NULL, NULL),
	('0019_0000000011', NULL, '0019_0000000011', NULL, '2019-12-24 07:36:03', NULL, '2019-12-24 07:34:55', 'GZP3_SF', 37, '', '', 'SF', '0018_0000000001', '广州3业务网络区域', '0023_0000000096', '0026_0000000001', NULL, '0019_0000000001', 380, NULL, NULL, NULL),
	('0019_0000000012', NULL, '0019_0000000012', NULL, '2019-12-24 07:36:51', NULL, '2019-12-24 07:36:51', 'GZP3_DMZ', 37, '', '', 'DMZ', '0018_0000000001', '广州3广域网连接区域', '0023_0000000098', '0026_0000000003', NULL, '0019_0000000002', 380, NULL, NULL, NULL),
	('0019_0000000013', NULL, '0019_0000000013', NULL, '2019-12-24 07:37:33', NULL, '2019-12-24 07:37:33', 'GZP3_ECN', 37, '', '', 'ECN', '0018_0000000001', '广州3伙伴网络连接区域', '0023_0000000100', '0026_0000000004', NULL, '0019_0000000003', 380, NULL, NULL, NULL),
	('0019_0000000014', NULL, '0019_0000000014', NULL, '2019-12-24 07:40:24', NULL, '2019-12-24 07:40:24', 'GZP3_MGMT', 37, '', '', 'MGMT', '0018_0000000001', '广州3运营操作网络连接区域', '0023_0000000102', '0026_0000000002', NULL, '0019_0000000004', 380, NULL, NULL, NULL),
	('0019_0000000015', NULL, '0019_0000000015', NULL, '2019-12-24 07:41:54', NULL, '2019-12-24 07:41:54', 'GZP4_SF', 37, '', '', 'SF', '0018_0000000003', '广州4业务网络区域', '0023_0000000097', '0026_0000000001', NULL, '0019_0000000001', 380, NULL, NULL, NULL),
	('0019_0000000016', NULL, '0019_0000000016', NULL, '2019-12-24 07:42:37', NULL, '2019-12-24 07:42:37', 'GZP4_DMZ', 37, '', '', 'DMZ', '0018_0000000003', '广州4广域网络连接区域', '0023_0000000099', '0026_0000000003', NULL, '0019_0000000002', 380, NULL, NULL, NULL),
	('0019_0000000017', NULL, '0019_0000000017', NULL, '2019-12-24 07:43:14', NULL, '2019-12-24 07:43:14', 'GZP4_ECN', 37, '', '', 'ECN', '0018_0000000003', '广州4伙伴网络连接区域', '0023_0000000101', '0026_0000000004', NULL, '0019_0000000003', 380, NULL, NULL, NULL),
	('0019_0000000018', NULL, '0019_0000000018', NULL, '2019-12-24 07:43:49', NULL, '2019-12-24 07:43:49', 'GZP4_MGMT', 37, '', '', 'MGMT', '0018_0000000003', '广州4运营操作网络连接区域', '0023_0000000103', '0026_0000000002', NULL, '0019_0000000004', 380, NULL, NULL, NULL),
	('0019_0000000019', NULL, '0019_0000000019', NULL, '2019-12-26 07:42:52', NULL, '2019-12-26 07:42:52', 'NDC_PTN', 37, '', '', 'PTN', '0018_0000000002', '合作伙伴网', '0023_0000000131', '0026_0000000008', NULL, '', 380, '', '', ''),
	('0019_0000000020', NULL, '0019_0000000001', NULL, '2019-12-27 07:10:14', NULL, '2019-12-16 02:17:17', 'GZP_SF', 37, '2019-12-27 07:01:34', '', 'SF', '0018_0000000004', '业务网络区域', '0023_0000000003', '0026_0000000001', 80, NULL, 379, 'vpc-6b27f6zr', 'sg-0cb9zcnb', 'rtb-ewot6u12'),
	('0019_0000000021', NULL, '0019_0000000002', NULL, '2019-12-27 07:10:14', NULL, '2019-12-17 17:33:16', 'GZP_DMZ', 37, '2019-12-27 07:01:34', '', 'DMZ', '0018_0000000004', '广域网络连接区域', '0023_0000000017', '0026_0000000003', 79, NULL, 379, 'vpc-jotfouct', 'sg-b3y6jlxh', 'rtb-9fn5rz8m'),
	('0019_0000000022', NULL, '0019_0000000003', NULL, '2019-12-27 07:10:14', NULL, '2019-12-17 17:34:01', 'GZP_ECN', 37, '2019-12-27 07:01:34', '', 'ECN', '0018_0000000004', '伙伴网络接入区域', '0023_0000000024', '0026_0000000004', 79, NULL, 379, 'vpc-6zzot79l', 'sg-4f9cghpr', 'rtb-kpuo97ya'),
	('0019_0000000023', NULL, '0019_0000000004', NULL, '2019-12-27 07:10:14', NULL, '2019-12-17 17:34:34', 'GZP_MGMT', 37, '2019-12-27 07:01:34', '', 'MGMT', '0018_0000000004', '运营操作网络区域', '0023_0000000031', '0026_0000000002', 79, NULL, 379, 'vpc-mnd798i7', 'sg-9so3kv3j', 'rtb-o4y8okzy'),
	('0019_0000000024', NULL, '0019_0000000001', NULL, '2019-12-27 07:28:53', NULL, '2019-12-16 02:17:17', 'GZP_SF', 38, '2019-12-27 07:10:17', '', 'SF', '0018_0000000004', '业务网络区域', '0023_0000000003', '0026_0000000001', 80, NULL, 379, 'vpc-6b27f6zr', 'sg-0cb9zcnb', 'rtb-ewot6u12'),
	('0019_0000000025', NULL, '0019_0000000002', NULL, '2019-12-27 07:28:53', NULL, '2019-12-17 17:33:16', 'GZP_DMZ', 38, '2019-12-27 07:10:17', '', 'DMZ', '0018_0000000004', '广域网络连接区域', '0023_0000000017', '0026_0000000003', 79, NULL, 379, 'vpc-jotfouct', 'sg-b3y6jlxh', 'rtb-9fn5rz8m'),
	('0019_0000000026', NULL, '0019_0000000003', NULL, '2019-12-27 07:28:53', NULL, '2019-12-17 17:34:01', 'GZP_ECN', 38, '2019-12-27 07:10:17', '', 'ECN', '0018_0000000004', '伙伴网络接入区域', '0023_0000000024', '0026_0000000004', 79, NULL, 379, 'vpc-6zzot79l', 'sg-4f9cghpr', 'rtb-kpuo97ya'),
	('0019_0000000027', NULL, '0019_0000000004', NULL, '2019-12-27 07:28:54', NULL, '2019-12-17 17:34:34', 'GZP_MGMT', 38, '2019-12-27 07:10:17', '', 'MGMT', '0018_0000000004', '运营操作网络区域', '0023_0000000031', '0026_0000000002', 79, NULL, 379, 'vpc-mnd798i7', 'sg-9so3kv3j', 'rtb-o4y8okzy'),
	('0019_0000000028', NULL, '0019_0000000001', NULL, '2019-12-27 07:44:55', NULL, '2019-12-16 02:17:17', 'GZP_SF', 38, '2019-12-27 07:28:56', '', 'SF', '0018_0000000004', '业务网络区域', '0023_0000000003', '0026_0000000001', 80, NULL, 379, 'vpc-6b27f6zr', 'sg-0cb9zcnb', 'rtb-ewot6u12'),
	('0019_0000000029', NULL, '0019_0000000002', NULL, '2019-12-27 07:44:55', NULL, '2019-12-17 17:33:16', 'GZP_DMZ', 38, '2019-12-27 07:28:56', '', 'DMZ', '0018_0000000004', '广域网络连接区域', '0023_0000000017', '0026_0000000003', 79, NULL, 379, 'vpc-jotfouct', 'sg-b3y6jlxh', 'rtb-9fn5rz8m'),
	('0019_0000000030', NULL, '0019_0000000003', NULL, '2019-12-27 07:44:56', NULL, '2019-12-17 17:34:01', 'GZP_ECN', 38, '2019-12-27 07:28:56', '', 'ECN', '0018_0000000004', '伙伴网络接入区域', '0023_0000000024', '0026_0000000004', 79, NULL, 379, 'vpc-6zzot79l', 'sg-4f9cghpr', 'rtb-kpuo97ya'),
	('0019_0000000031', NULL, '0019_0000000004', NULL, '2019-12-27 07:44:56', NULL, '2019-12-17 17:34:34', 'GZP_MGMT', 38, '2019-12-27 07:28:56', '', 'MGMT', '0018_0000000004', '运营操作网络区域', '0023_0000000031', '0026_0000000002', 79, NULL, 379, 'vpc-mnd798i7', 'sg-9so3kv3j', 'rtb-o4y8okzy'),
	('0019_0000000032', NULL, '0019_0000000001', NULL, '2019-12-31 05:08:30', NULL, '2019-12-16 02:17:17', 'GZP_SF', 38, '2019-12-27 07:44:58', '', 'SF', '0018_0000000004', '业务网络区域', '0023_0000000003', '0026_0000000001', 80, NULL, 379, 'vpc-6b27f6zr', 'sg-0cb9zcnb', 'rtb-ewot6u12'),
	('0019_0000000033', NULL, '0019_0000000002', NULL, '2019-12-31 05:08:30', NULL, '2019-12-17 17:33:16', 'GZP_DMZ', 38, '2019-12-27 07:44:58', '', 'DMZ', '0018_0000000004', '广域网络连接区域', '0023_0000000017', '0026_0000000003', 79, NULL, 379, 'vpc-jotfouct', 'sg-b3y6jlxh', 'rtb-9fn5rz8m'),
	('0019_0000000034', NULL, '0019_0000000003', NULL, '2019-12-31 05:08:30', NULL, '2019-12-17 17:34:01', 'GZP_ECN', 38, '2019-12-27 07:44:58', '', 'ECN', '0018_0000000004', '伙伴网络接入区域', '0023_0000000024', '0026_0000000004', 79, NULL, 379, 'vpc-6zzot79l', 'sg-4f9cghpr', 'rtb-kpuo97ya'),
	('0019_0000000035', NULL, '0019_0000000004', NULL, '2019-12-31 05:08:31', NULL, '2019-12-17 17:34:34', 'GZP_MGMT', 38, '2019-12-27 07:44:59', '', 'MGMT', '0018_0000000004', '运营操作网络区域', '0023_0000000031', '0026_0000000002', 79, NULL, 379, 'vpc-mnd798i7', 'sg-9so3kv3j', 'rtb-o4y8okzy'),
	('0019_0000000036', '0019_0000000035', '0019_0000000004', NULL, '2020-01-10 02:46:25', NULL, '2019-12-17 17:34:34', 'GZP_MGMT', 38, '2019-12-31 05:08:33', '', 'MGMT', '0018_0000000004', '运营操作网络区域', '0023_0000000031', '0026_0000000002', 79, NULL, 379, 'vpc-mnd798i7', 'sg-9so3kv3j', 'rtb-o4y8okzy'),
	('0019_0000000037', '0019_0000000034', '0019_0000000003', NULL, '2020-01-10 02:46:25', NULL, '2019-12-17 17:34:01', 'GZP_ECN', 38, '2019-12-31 05:08:33', '', 'ECN', '0018_0000000004', '伙伴网络接入区域', '0023_0000000024', '0026_0000000004', 79, NULL, 379, 'vpc-6zzot79l', 'sg-4f9cghpr', 'rtb-kpuo97ya');
/*!40000 ALTER TABLE `network_zone` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.network_zone_design 的数据：~7 rows (大约)
/*!40000 ALTER TABLE `network_zone_design` DISABLE KEYS */;
INSERT INTO `network_zone_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `data_center_design`, `network_segment_design`, `network_zone_layer`) VALUES
	('0026_0000000001', NULL, '0026_0000000001', NULL, '2019-12-19 11:52:14', NULL, '2019-12-15 16:06:22', 'V1_SF', 34, '', '核心运维网络区域', 'SF', '0025_0000000001', '0030_0000000003', 80),
	('0026_0000000002', NULL, '0026_0000000002', NULL, '2019-12-19 11:52:14', NULL, '2019-12-15 16:06:46', 'V1_MGMT', 34, '', '管理工具网络区域', 'MGMT', '0025_0000000001', '0030_0000000004', 79),
	('0026_0000000003', NULL, '0026_0000000003', NULL, '2019-12-19 11:52:13', NULL, '2019-12-15 16:06:57', 'V1_DMZ', 34, '', '广域网接入网络区域', 'DMZ', '0025_0000000001', '0030_0000000005', 79),
	('0026_0000000004', NULL, '0026_0000000004', NULL, '2019-12-19 11:52:13', NULL, '2019-12-15 16:07:07', 'V1_ECN', 34, '', '伙伴接入网络区域', 'ECN', '0025_0000000001', '0030_0000000006', 79),
	('0026_0000000006', NULL, '0026_0000000006', NULL, '2019-12-19 11:52:36', NULL, '2019-12-15 16:07:50', 'V1_WAN', 34, '', '广域网络区域', 'WAN', '0025_0000000001', '0030_0000000048', 78),
	('0026_0000000007', NULL, '0026_0000000007', NULL, '2019-12-17 18:16:59', NULL, '2019-12-15 16:08:26', 'V1_OPN', 34, '', '运维操作网络区域', 'OPN', '0025_0000000001', '0030_0000000009', 78),
	('0026_0000000008', NULL, '0026_0000000008', NULL, '2019-12-15 16:11:21', NULL, '2019-12-15 16:11:21', 'V1_PTN', 34, '', '伙伴网络区域', 'PTN', '0025_0000000001', '0030_0000000010', 78);
/*!40000 ALTER TABLE `network_zone_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.network_zone_link 的数据：~9 rows (大约)
/*!40000 ALTER TABLE `network_zone_link` DISABLE KEYS */;
INSERT INTO `network_zone_link` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `asset_code`, `max_concurrent`, `name`, `netband_width`, `network_zone_1`, `network_zone_2`, `network_zone_link_design`, `network_zone_link_type`, `internet_ip`) VALUES
	('0020_0000000001', NULL, '0020_0000000001', NULL, '2019-12-31 05:08:42', NULL, '2019-12-17 17:51:24', 'GZP_MGMT-link-GZP_SF', 37, '', '', 'MGMT-SF', 'pcx-qrpxm11y', NULL, '', '5', '0019_0000000004', '0019_0000000001', '0027_0000000002', 101, ''),
	('0020_0000000002', NULL, '0020_0000000002', NULL, '2020-01-08 02:17:55', NULL, '2019-12-17 17:53:02', 'GZP_DMZ-link-GZP_SF', 37, '2020-01-08 02:17:54', '', 'DMZ-SF', 'pcx-i07a4y4a', NULL, '', '5', '0019_0000000002', '0019_0000000001', '0027_0000000003', 101, ''),
	('0020_0000000003', NULL, '0020_0000000003', NULL, '2019-12-31 05:08:43', NULL, '2019-12-17 17:53:26', 'GZP_ECN-link-GZP_SF', 37, '', '', 'ECN-SF', 'pcx-ajw686xi', NULL, '', '5', '0019_0000000003', '0019_0000000001', '0027_0000000004', 101, ''),
	('0020_0000000004', NULL, '0020_0000000004', NULL, '2019-12-31 05:08:43', NULL, '2019-12-17 17:53:51', 'GZP_MGMT-link-GZP_ECN', 37, '', '', 'MGMT-ECN', 'pcx-n5pqevxy', NULL, '', '5', '0019_0000000004', '0019_0000000003', '0027_0000000008', 101, ''),
	('0020_0000000005', NULL, '0020_0000000005', NULL, '2019-12-31 05:08:43', NULL, '2019-12-17 17:54:13', 'GZP_DMZ-link-GZP_MGMT', 37, '', '', 'DMZ-MGMT', 'pcx-6hnedrqs', NULL, '', '5', '0019_0000000002', '0019_0000000004', '0027_0000000009', 101, ''),
	('0020_0000000007', NULL, '0020_0000000007', NULL, '2019-12-21 11:25:35', NULL, '2019-12-17 17:55:09', 'NDC_OPN-link-GZP_MGMT', 37, '', '', 'OPS-MGMT', '', NULL, '', '5', '0019_0000000006', '0019_0000000004', '0027_0000000005', 324, ''),
	('0020_0000000015', NULL, '0020_0000000015', NULL, '2019-12-31 05:16:30', NULL, '2019-12-18 08:43:12', 'NDC_WAN-link-GZP_DMZ', 37, '', '', 'DMZ-WAN', '', '10000', '', '10', '0019_0000000005', '0019_0000000002', '0027_0000000010', 102, ''),
	('0020_0000000017', NULL, '0020_0000000017', NULL, '2019-12-26 07:43:53', NULL, '2019-12-26 07:43:53', 'GZP_ECN-link-NDC_PTN', 37, '', '', 'ECN-PTN', '', NULL, '', '5', '0019_0000000003', '0019_0000000019', '0027_0000000007', NULL, '');
/*!40000 ALTER TABLE `network_zone_link` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.network_zone_link_design 的数据：~8 rows (大约)
/*!40000 ALTER TABLE `network_zone_link_design` DISABLE KEYS */;
INSERT INTO `network_zone_link_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `network_zone_design_1`, `network_zone_design_2`, `network_zone_link_type`) VALUES
	('0027_0000000002', NULL, '0027_0000000002', NULL, '2019-12-15 16:12:38', NULL, '2019-12-15 16:12:38', 'V1_MGMT-link-V1_SF', 34, '', '', 'MGMT-SF', '0026_0000000002', '0026_0000000001', 101),
	('0027_0000000003', NULL, '0027_0000000003', NULL, '2019-12-15 16:12:56', NULL, '2019-12-15 16:12:56', 'V1_DMZ-link-V1_SF', 34, '', '', 'DMZ-SF', '0026_0000000003', '0026_0000000001', 101),
	('0027_0000000004', NULL, '0027_0000000004', NULL, '2019-12-15 16:13:14', NULL, '2019-12-15 16:13:14', 'V1_ECN-link-V1_SF', 34, '', '', 'ECN-SF', '0026_0000000004', '0026_0000000001', 101),
	('0027_0000000005', NULL, '0027_0000000005', NULL, '2019-12-18 08:41:05', NULL, '2019-12-15 16:13:42', 'V1_OPN-link-V1_MGMT', 34, '', '', 'OPN-MGMT', '0026_0000000007', '0026_0000000002', 324),
	('0027_0000000007', NULL, '0027_0000000007', NULL, '2019-12-18 08:40:10', NULL, '2019-12-15 16:14:40', 'V1_PTN-link-V1_ECN', 34, '', '', 'PTN-ECN', '0026_0000000008', '0026_0000000004', 256),
	('0027_0000000008', NULL, '0027_0000000008', NULL, '2019-12-15 16:15:02', NULL, '2019-12-15 16:15:02', 'V1_MGMT-link-V1_ECN', 34, '', '', 'MGMT-ECN', '0026_0000000002', '0026_0000000004', 101),
	('0027_0000000009', NULL, '0027_0000000009', NULL, '2019-12-15 16:17:11', NULL, '2019-12-15 16:15:20', 'V1_DMZ-link-V1_MGMT', 34, '', '', 'DMZ-MGMT', '0026_0000000003', '0026_0000000002', 101),
	('0027_0000000010', NULL, '0027_0000000010', NULL, '2019-12-31 04:49:06', NULL, '2019-12-18 08:35:51', 'V1_WAN-link-V1_DMZ', 34, '', '', 'DMZ-WAN', '0026_0000000006', '0026_0000000003', 102);
/*!40000 ALTER TABLE `network_zone_link_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.resource_instance 的数据：~16 rows (大约)
/*!40000 ALTER TABLE `resource_instance` DISABLE KEYS */;
INSERT INTO `resource_instance` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `asset_code`, `billing_cycle`, `charge_type`, `cluster_node_type`, `cpu`, `end_date`, `intranet_ip`, `login_port`, `memory`, `name`, `resource_instance_spec`, `resource_instance_type`, `resource_set`, `resource_system`, `storage`, `unit_type`, `user_name`, `user_password`, `master_resource_instance`, `backup_asset_code`) VALUES
	('0015_0000000009', NULL, '0015_0000000009', NULL, '2019-12-24 10:00:21', NULL, '2019-12-24 04:07:24', 'GZP3_MGMT_MT_APP_10.128.194.10', 40, '', '', '10.128.194.10', '', '0', 77, 128, '', NULL, '0017_0000000037', '22', '', 'host2', 123, 110, '0022_0000000019', 274, '100', 64, 'root', 'mock1234', '', NULL),
	('0015_0000000013', '0015_0000000029', '0015_0000000013', 'SYS_PLATFORM', '2020-01-15 08:01:37', NULL, '2019-12-30 02:20:18', 'GZP3_SF_CS_APP_10.128.4.14', 42, '2020-01-14 04:52:38', '', '10.128.4.14', 'ins-qfcccs3o', '0', 77, 128, '1', NULL, '0017_0000000013', '22', '2', 'testhsot1', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '{cipher_a}071936644a7e3fd04fea916693ff270b', '', NULL),
	('0015_0000000014', NULL, '0015_0000000014', 'SYS_PLATFORM', '2020-01-10 13:09:06', NULL, '2019-12-30 03:39:40', 'GZP3_SF_CS_APP_10.128.4.15', 40, '', '', '10.128.4.15', 'ins-i07lobyc', '0', 77, 128, '1', NULL, '0017_0000000014', '22', '2', 'testhost2', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '{cipher_a}01b582b443fb0b0797dab36d10b791db', '', NULL),
	('0015_0000000015', NULL, '0015_0000000015', 'mockadmin', '2020-01-10 13:46:14', NULL, '2019-12-30 04:27:22', 'GZP3_SF_CS_DB_10.128.5.3', 40, '2020-01-02 06:36:40', '', '10.128.5.3', 'cdb-1yxnv8hv', '0', 77, 131, '', NULL, '0017_0000000017', '3306', '', 'testdb1', 124, 112, '0022_0000000009', 119, '30', 66, 'root', 'adfb2b5ac76b12d90b994b15cecf27c0', '', NULL),
	('0015_0000000016', NULL, '0015_0000000013', NULL, '2019-12-30 09:53:22', NULL, '2019-12-30 02:20:18', 'GZP3_SF_CS_APP_10.128.4.10', 40, '2019-12-30 04:24:33', '', '10.128.4.10', 'ins-kavtoccq', '0', 77, 128, '1', NULL, '0017_0000000013', '22', '2', 'testhsot1', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '071936644a7e3fd04fea916693ff270b', '', NULL),
	('0015_0000000017', NULL, '0015_0000000017', NULL, '2020-01-08 01:51:11', NULL, '2020-01-06 03:00:19', 'GZP3_SF_CS_DBLB_10.128.2.10', 40, '2020-01-06 03:13:59', '', '10.128.2.10', 'lb-pcc2yb52', '0', 77, 357, '', NULL, '0017_0000000108', '', '', 'dblb1', 346, 343, '0022_0000000051', 347, '', 341, '', '', '', NULL),
	('0015_0000000018', NULL, '0015_0000000018', NULL, '2020-01-08 03:31:40', NULL, '2020-01-06 04:35:19', 'GZP3_SF_CS_APPLB_10.128.0.3', 40, '2020-01-06 04:36:02', '', '10.128.0.3', 'lb-0rvdfmtc', '0', 77, 356, '', NULL, '0017_0000000102', '', '', 'applb1', 345, 342, '0022_0000000064', 344, '', 340, '', '', '', NULL),
	('0015_0000000019', NULL, '0015_0000000019', NULL, '2020-01-08 01:15:40', NULL, '2020-01-06 09:52:02', 'GZP3_SF_CS_APP_10.128.4.12', 40, '2020-01-08 01:15:40', '', '10.128.4.12', 'ins-r0llrj7w', '0', 77, 128, '1', NULL, '0017_0000000109', '22', '2', 'testhost3', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '6a48bbcd59b22ff28b72bd428c7d9afd', '', NULL),
	('0015_0000000020', '0015_0000000025', '0015_0000000020', 'mockadmin', '2020-01-10 13:46:14', NULL, '2020-01-07 10:15:48', 'GZP3_SF_CS_DB_10.128.5.10', 42, NULL, '', '10.128.5.10', 'cdb-ihvk8xk1', '0', 77, 131, '', NULL, '0017_0000000018', '3306', '', 'db1', 124, 112, '0022_0000000009', 119, '50', 66, 'root', '{cipher_a}de7a43c511a3be9108d802e6fd5635de', '', NULL),
	('0015_0000000021', '0015_0000000016', '0015_0000000013', NULL, '2020-01-02 09:55:42', NULL, '2019-12-30 02:20:18', 'GZP3_SF_CS_APP_10.128.4.10', 41, '2020-01-02 09:55:42', '', '10.128.4.10', 'ins-kavtoccq', '0', 77, 128, '1', NULL, '0017_0000000013', '22', '2', 'testhsot1', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '071936644a7e3fd04fea916693ff270b', '', NULL),
	('0015_0000000022', NULL, '0015_0000000020', NULL, '2020-01-09 06:18:36', NULL, '2020-01-07 10:15:48', 'GZP3_SF_CS_DB_10.128.5.5', 40, '2020-01-07 10:19:10', '', '10.128.5.5', 'cdb-s1d1qsub', '0', 77, 131, '', NULL, '0017_0000000018', '3306', '', 'db1', 124, 112, '0022_0000000009', 119, '50', 66, 'root', 'de7a43c511a3be9108d802e6fd5635de', '', NULL),
	('0015_0000000023', '0015_0000000022', '0015_0000000020', NULL, '2020-01-09 06:24:44', NULL, '2020-01-07 10:15:48', 'GZP3_SF_CS_DB_10.128.5.3', 41, '2020-01-09 06:22:56', '', '10.128.5.3', 'cdb-s1d1qsub', '0', 77, 131, '', NULL, '0017_0000000018', '3306', '', 'db1', 124, 112, '0022_0000000009', 119, '50', 66, 'root', 'de7a43c511a3be9108d802e6fd5635de', '', NULL),
	('0015_0000000024', '0015_0000000023', '0015_0000000020', 'SYS_PLATFORM', '2020-01-10 10:21:21', NULL, '2020-01-07 10:15:48', 'GZP3_SF_CS_DB_10.128.5.3', 42, '2020-01-09 06:38:53', '', '10.128.5.3', 'cdb-2ejd3hol', '0', 77, 131, '', NULL, '0017_0000000018', '3306', '', 'db1', 124, 112, '0022_0000000009', 119, '50', 66, 'root', 'a13830f01234a4bc007b959c4d81949627661b0eb542f559e7ac19b6d2ff1544945451bc00593360c451920a6bccc4fb', '', NULL),
	('0015_0000000025', '0015_0000000024', '0015_0000000020', 'mockadmin', '2020-01-10 10:23:19', NULL, '2020-01-07 10:15:48', 'GZP3_SF_CS_DB_10.128.5.3', 41, '2020-01-10 10:23:19', '', '10.128.5.3', 'cdb-2ejd3hol', '0', 77, 131, '', NULL, '0017_0000000018', '3306', '', 'db1', 124, 112, '0022_0000000009', 119, '50', 66, 'root', 'a13830f01234a4bc007b959c4d81949627661b0eb542f559e7ac19b6d2ff1544945451bc00593360c451920a6bccc4fb', '', NULL),
	('0015_0000000028', '0015_0000000021', '0015_0000000013', 'mockadmin', '2020-01-14 04:46:25', NULL, '2019-12-30 02:20:18', 'GZP3_SF_CS_APP_10.128.4.14', 42, '2020-01-14 04:38:46', '', '10.128.4.14', 'ins-eh0e2ci6', '0', 77, 128, '1', NULL, '0017_0000000013', '22', '2', 'testhsot1', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '{cipher_a}071936644a7e3fd04fea916693ff270b', '', NULL),
	('0015_0000000029', '0015_0000000028', '0015_0000000013', 'mockadmin', '2020-01-14 04:46:29', NULL, '2019-12-30 02:20:18', 'GZP3_SF_CS_APP_10.128.4.14', 41, '2020-01-14 04:46:29', '', '10.128.4.14', 'ins-eh0e2ci6', '0', 77, 128, '1', NULL, '0017_0000000013', '22', '2', 'testhsot1', 122, 110, '0022_0000000007', 274, '50', 64, 'root', '{cipher_a}071936644a7e3fd04fea916693ff270b', '', NULL);
/*!40000 ALTER TABLE `resource_instance` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.resource_set 的数据：~62 rows (大约)
/*!40000 ALTER TABLE `resource_set` DISABLE KEYS */;
INSERT INTO `resource_set` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `business_zone`, `cluster_type`, `init_script`, `init_source_type`, `name`, `network_segment`, `resource_set_design`, `subnet_asset_code`, `route_table_asset_code`) VALUES
	('0022_0000000001', NULL, '0022_0000000001', NULL, '2019-12-25 02:36:31', NULL, '2019-12-16 02:22:15', 'GZP3_SF_BZa_APP', 37, '', '', 'APP', '0021_0000000001', 87, '', 277, '', '0023_0000000005', '0029_0000000001', NULL, NULL),
	('0022_0000000002', NULL, '0022_0000000002', NULL, '2019-12-24 08:39:28', NULL, '2019-12-17 18:03:40', 'GZP3_SF_BZa_CACHE', 37, '', '', 'CACHE', '0021_0000000001', 91, '', NULL, '', '0023_0000000006', '0029_0000000003', NULL, NULL),
	('0022_0000000003', NULL, '0022_0000000003', NULL, '2019-12-24 08:39:28', NULL, '2019-12-17 18:04:53', 'GZP3_SF_BZa_DB', 37, '', '', 'DB', '0021_0000000001', 89, '', NULL, '', '0023_0000000007', '0029_0000000004', NULL, NULL),
	('0022_0000000004', NULL, '0022_0000000004', NULL, '2019-12-25 02:20:15', NULL, '2019-12-17 18:06:37', 'GZP3_SF_BZb_APP', 37, '', '', 'APP', '0021_0000000002', 87, '', NULL, '', '0023_0000000009', '0029_0000000005', NULL, NULL),
	('0022_0000000005', NULL, '0022_0000000005', NULL, '2019-12-24 08:39:28', NULL, '2019-12-17 18:07:05', 'GZP3_SF_BZb_CACHE', 37, '', '', 'CACHE', '0021_0000000002', 91, '', NULL, '', '0023_0000000010', '0029_0000000006', NULL, NULL),
	('0022_0000000006', NULL, '0022_0000000006', NULL, '2019-12-24 08:39:27', NULL, '2019-12-17 18:07:24', 'GZP3_SF_BZb_DB', 37, '', '', 'DB', '0021_0000000002', 89, '', NULL, '', '0023_0000000011', '0029_0000000007', NULL, NULL),
	('0022_0000000007', '0022_0000000067', '0022_0000000007', NULL, '2020-01-08 07:46:13', NULL, '2019-12-17 18:07:39', 'GZP3_SF_CS_APP', 38, '2020-01-08 07:46:13', '', 'APP', '0021_0000000003', 87, 'sudo yum install -y java-1.8.0-openjdk', 277, '', '0023_0000000013', '0029_0000000008', 'subnet-pv2eti8u', NULL),
	('0022_0000000008', NULL, '0022_0000000008', NULL, '2020-01-08 01:58:30', NULL, '2019-12-17 18:08:05', 'GZP3_SF_CS_CACHE', 37, '2019-12-27 07:16:24', '', 'CACHE', '0021_0000000003', 91, '', NULL, '', '0023_0000000014', '0029_0000000009', 'subnet-5nzk5rsi', NULL),
	('0022_0000000009', '0022_0000000068', '0022_0000000009', NULL, '2020-01-08 07:46:13', NULL, '2019-12-17 18:08:23', 'GZP3_SF_CS_DB', 38, '2020-01-08 07:46:13', '', 'DB', '0021_0000000003', 89, '', NULL, '', '0023_0000000015', '0029_0000000010', 'subnet-1m9bttw2', NULL),
	('0022_0000000010', NULL, '0022_0000000010', NULL, '2020-01-08 05:15:28', NULL, '2019-12-17 18:08:46', 'GZP3_SF_CS_BDP', 37, '2019-12-27 07:16:24', '', 'BDP', '0021_0000000003', 279, '', NULL, '', '0023_0000000016', '0029_0000000011', 'subnet-lnxfrgm2', NULL),
	('0022_0000000011', NULL, '0022_0000000011', NULL, '2019-12-24 08:41:43', NULL, '2019-12-17 18:09:35', 'GZP3_DMZ_BZa_OUT', 37, '', '', 'OUT', '0021_0000000004', 87, '', NULL, '', '0023_0000000021', '0029_0000000013', NULL, NULL),
	('0022_0000000012', NULL, '0022_0000000012', NULL, '2019-12-25 02:12:36', NULL, '2019-12-17 18:09:56', 'GZP3_DMZ_BZa_IN', 37, '', '', 'IN', '0021_0000000004', 87, '', NULL, '', '0023_0000000020', '0029_0000000012', NULL, NULL),
	('0022_0000000013', NULL, '0022_0000000013', NULL, '2019-12-24 08:41:43', NULL, '2019-12-17 18:10:13', 'GZP3_DMZ_BZb_OUT', 37, '', '', 'OUT', '0021_0000000005', 87, '', NULL, '', '0023_0000000023', '0029_0000000015', NULL, NULL),
	('0022_0000000014', NULL, '0022_0000000014', NULL, '2019-12-25 02:12:36', NULL, '2019-12-17 18:10:33', 'GZP3_DMZ_BZb_IN', 37, '', '', 'IN', '0021_0000000005', 87, '', NULL, '', '0023_0000000022', '0029_0000000014', NULL, NULL),
	('0022_0000000015', NULL, '0022_0000000015', NULL, '2019-12-24 08:41:43', NULL, '2019-12-17 18:11:00', 'GZP3_ECN_BZa_OWN', 37, '', '', 'OWN', '0021_0000000006', 87, '', NULL, '', '0023_0000000027', '0029_0000000016', NULL, NULL),
	('0022_0000000016', NULL, '0022_0000000016', NULL, '2019-12-24 08:41:05', NULL, '2019-12-17 18:11:16', 'GZP3_ECN_BZa_NOWN', 37, '', '', 'NOWN', '0021_0000000006', 87, '', NULL, '', '0023_0000000028', '0029_0000000017', NULL, NULL),
	('0022_0000000017', NULL, '0022_0000000017', NULL, '2019-12-24 08:41:05', NULL, '2019-12-17 18:11:31', 'GZP3_ECN_BZb_OWN', 37, '', '', 'OWN', '0021_0000000007', 87, '', NULL, '', '0023_0000000029', '0029_0000000018', NULL, NULL),
	('0022_0000000018', NULL, '0022_0000000018', NULL, '2019-12-24 08:41:05', NULL, '2019-12-17 18:11:47', 'GZP3_ECN_BZb_NOWN', 37, '', '', 'NOWN', '0021_0000000007', 87, '', NULL, '', '0023_0000000030', '0029_0000000019', NULL, NULL),
	('0022_0000000019', NULL, '0022_0000000019', NULL, '2019-12-24 08:41:04', NULL, '2019-12-17 18:12:42', 'GZP3_MGMT_MT_APP', 37, '', '', 'APP', '0021_0000000008', 87, '', NULL, '', '0023_0000000033', '0029_0000000020', NULL, NULL),
	('0022_0000000020', NULL, '0022_0000000020', NULL, '2019-12-24 08:39:27', NULL, '2019-12-17 18:13:05', 'GZP3_MGMT_MT_CACHE', 37, '', '', 'CACHE', '0021_0000000008', 91, '', NULL, '', '0023_0000000034', '0029_0000000021', NULL, NULL),
	('0022_0000000021', NULL, '0022_0000000021', NULL, '2019-12-24 08:39:27', NULL, '2019-12-17 18:13:26', 'GZP3_MGMT_MT_DB', 37, '', '', 'DB', '0021_0000000008', 89, '', NULL, '', '0023_0000000035', '0029_0000000022', NULL, NULL),
	('0022_0000000022', NULL, '0022_0000000022', NULL, '2019-12-24 08:39:27', NULL, '2019-12-17 18:13:49', 'GZP3_MGMT_MT_BDP', 37, '', '', 'BDP', '0021_0000000008', 279, '', NULL, '', '0023_0000000036', '0029_0000000023', NULL, NULL),
	('0022_0000000023', NULL, '0022_0000000023', NULL, '2019-12-24 10:41:42', NULL, '2019-12-17 18:14:17', 'NDC_WAN_ALL_WS', 37, '', '', 'WS', '0021_0000000010', 282, '', NULL, '', '0023_0000000138', '0029_0000000028', NULL, NULL),
	('0022_0000000024', NULL, '0022_0000000024', NULL, '2019-12-17 18:14:58', NULL, '2019-12-17 18:14:58', 'NDC_WAN_ALL_AC', 37, '', '', 'AC', '0021_0000000010', 282, '', NULL, '', '', '0029_0000000026', NULL, NULL),
	('0022_0000000025', NULL, '0022_0000000025', NULL, '2019-12-24 08:39:27', NULL, '2019-12-17 18:15:29', 'GZP3_MGMT_QZ_VDI', 37, '', '', 'VDI', '0021_0000000009', 282, '', NULL, '', '', '0029_0000000024', NULL, NULL),
	('0022_0000000026', NULL, '0022_0000000026', NULL, '2019-12-17 18:18:19', NULL, '2019-12-17 18:15:54', 'NDC_OPN_ALL_VC', 37, '', '', 'VC', '0021_0000000011', 282, '', NULL, '', '0023_0000000043', '0029_0000000029', NULL, NULL),
	('0022_0000000027', NULL, '0022_0000000027', NULL, '2019-12-25 02:23:35', NULL, '2019-12-18 07:48:55', 'GZP4_SF_BZa_APP', 37, '', '', 'APP', '0021_0000000025', 87, '', NULL, '', '0023_0000000048', '0029_0000000001', NULL, NULL),
	('0022_0000000028', NULL, '0022_0000000028', NULL, '2019-12-24 08:38:01', NULL, '2019-12-18 07:49:39', 'GZP4_SF_BZa_CACHE', 37, '', '', 'CACHE', '0021_0000000025', 91, '', NULL, '', '0023_0000000049', '0029_0000000003', NULL, NULL),
	('0022_0000000029', NULL, '0022_0000000029', NULL, '2019-12-24 08:36:03', NULL, '2019-12-18 07:50:32', 'GZP4_SF_BZa_DB', 37, '', '', 'DB', '0021_0000000025', 89, '', NULL, '', '0023_0000000050', '0029_0000000004', NULL, NULL),
	('0022_0000000030', NULL, '0022_0000000030', NULL, '2019-12-25 02:23:19', NULL, '2019-12-18 07:51:29', 'GZP4_SF_BZb_APP', 37, '', '', 'APP', '0021_0000000026', 87, '', NULL, '', '0023_0000000052', '0029_0000000005', NULL, NULL),
	('0022_0000000031', NULL, '0022_0000000031', NULL, '2019-12-24 08:36:02', NULL, '2019-12-18 07:54:57', 'GZP4_SF_BZb_CACHE', 37, '', '', 'CACHE', '0021_0000000026', 91, '', NULL, '', '0023_0000000053', '0029_0000000006', NULL, NULL),
	('0022_0000000032', NULL, '0022_0000000032', NULL, '2019-12-24 08:36:02', NULL, '2019-12-18 08:07:40', 'GZP4_SF_BZb_DB', 37, '', '', 'DB', '0021_0000000026', 89, '', NULL, '', '0023_0000000054', '0029_0000000007', NULL, NULL),
	('0022_0000000033', NULL, '0022_0000000033', NULL, '2019-12-25 02:23:54', NULL, '2019-12-18 08:08:43', 'GZP4_SF_CS_APP', 37, '', '', 'APP', '0021_0000000024', 87, '', NULL, '', '0023_0000000056', '0029_0000000008', NULL, NULL),
	('0022_0000000034', NULL, '0022_0000000034', NULL, '2019-12-24 08:36:02', NULL, '2019-12-18 08:09:36', 'GZP4_SF_CS_CACHE', 37, '', '', 'CACHE', '0021_0000000024', 91, '', NULL, '', '0023_0000000057', '0029_0000000009', NULL, NULL),
	('0022_0000000035', NULL, '0022_0000000035', NULL, '2019-12-24 08:36:02', NULL, '2019-12-18 08:10:30', 'GZP4_SF_CS_DB', 37, '', '', 'DB', '0021_0000000024', 89, '', NULL, '', '0023_0000000058', '0029_0000000010', NULL, NULL),
	('0022_0000000036', NULL, '0022_0000000036', NULL, '2019-12-24 08:36:02', NULL, '2019-12-18 08:11:26', 'GZP4_SF_CS_BDP', 37, '', '', 'BDP', '0021_0000000024', 279, '', NULL, '', '0023_0000000059', '0029_0000000011', NULL, NULL),
	('0022_0000000037', NULL, '0022_0000000037', NULL, '2019-12-25 02:12:36', NULL, '2019-12-18 08:17:39', 'GZP4_DMZ_BZa_IN', 37, '', '', 'IN', '0021_0000000028', 87, '', NULL, '', '0023_0000000063', '0029_0000000012', NULL, NULL),
	('0022_0000000038', NULL, '0022_0000000038', NULL, '2019-12-24 08:38:01', NULL, '2019-12-18 08:18:29', 'GZP4_DMZ_BZa_OUT', 37, '', '', 'OUT', '0021_0000000028', 87, '', NULL, '', '0023_0000000064', '0029_0000000013', NULL, NULL),
	('0022_0000000039', NULL, '0022_0000000039', NULL, '2019-12-25 02:12:36', NULL, '2019-12-18 08:20:09', 'GZP4_DMZ_BZb_IN', 37, '', '', 'IN', '0021_0000000029', 87, '', NULL, '', '0023_0000000065', '0029_0000000014', NULL, NULL),
	('0022_0000000040', NULL, '0022_0000000040', NULL, '2019-12-24 08:38:01', NULL, '2019-12-18 08:20:54', 'GZP4_DMZ_BZb_OUT', 37, '', '', 'OUT', '0021_0000000029', 87, '', NULL, '', '0023_0000000066', '0029_0000000015', NULL, NULL),
	('0022_0000000041', NULL, '0022_0000000041', NULL, '2019-12-24 08:37:02', NULL, '2019-12-18 08:31:31', 'GZP4_ECN_BZa_OWN', 37, '', '', 'OWN', '0021_0000000031', 87, '', NULL, '', '0023_0000000070', '0029_0000000016', NULL, NULL),
	('0022_0000000042', NULL, '0022_0000000042', NULL, '2019-12-24 08:37:02', NULL, '2019-12-18 08:32:36', 'GZP4_ECN_BZa_NOWN', 37, '', '', 'NOWN', '0021_0000000031', 87, '', NULL, '', '0023_0000000071', '0029_0000000017', NULL, NULL),
	('0022_0000000043', NULL, '0022_0000000043', NULL, '2019-12-24 08:37:02', NULL, '2019-12-18 08:34:31', 'GZP4_ECN_BZb_OWN', 37, '', '', 'OWN', '0021_0000000032', 87, '', NULL, '', '0023_0000000072', '0029_0000000018', NULL, NULL),
	('0022_0000000044', NULL, '0022_0000000044', NULL, '2019-12-24 08:37:02', NULL, '2019-12-18 08:35:23', 'GZP4_ECN_BZb_NOWN', 37, '', '', 'NOWN', '0021_0000000032', 87, '', NULL, '', '0023_0000000073', '0029_0000000019', NULL, NULL),
	('0022_0000000045', NULL, '0022_0000000045', NULL, '2019-12-24 08:30:56', NULL, '2019-12-18 08:36:15', 'GZP4_MGMT_MT_APP', 37, '', '', 'APP', '0021_0000000034', 87, '', NULL, '', '0023_0000000076', '0029_0000000020', NULL, NULL),
	('0022_0000000046', NULL, '0022_0000000046', NULL, '2019-12-24 08:30:56', NULL, '2019-12-18 08:37:02', 'GZP4_MGMT_MT_CACHE', 37, '', '', 'CACHE', '0021_0000000034', 91, '', NULL, '', '0023_0000000077', '0029_0000000021', NULL, NULL),
	('0022_0000000047', NULL, '0022_0000000047', NULL, '2019-12-24 08:30:56', NULL, '2019-12-18 08:37:53', 'GZP4_MGMT_MT_DB', 37, '', '', 'DB', '0021_0000000034', 89, '', NULL, '', '0023_0000000078', '0029_0000000022', NULL, NULL),
	('0022_0000000048', NULL, '0022_0000000048', NULL, '2019-12-24 08:30:56', NULL, '2019-12-18 08:39:24', 'GZP4_MGMT_CS_BDP', 37, '', '', 'BDP', '0021_0000000033', 279, '', NULL, '', '0023_0000000079', '0029_0000000023', NULL, NULL),
	('0022_0000000049', NULL, '0022_0000000049', NULL, '2019-12-24 08:30:56', NULL, '2019-12-18 08:40:26', 'GZP4_MGMT_QZ_VDI', 37, '', '', 'VDI', '0021_0000000035', 282, '', NULL, '', '0023_0000000081', '0029_0000000024', NULL, NULL),
	('0022_0000000051', NULL, '0022_0000000051', NULL, '2020-01-08 05:15:28', NULL, '2019-12-21 10:29:40', 'GZP3_SF_CS_DBLB', 37, '2019-12-27 07:16:24', '', 'DBLB', '0021_0000000003', 354, '', NULL, '', '0023_0000000091', '0029_0000000034', 'subnet-qq4oyeew', NULL),
	('0022_0000000052', NULL, '0022_0000000052', NULL, '2019-12-24 08:41:04', NULL, '2019-12-21 11:28:04', 'GZP3_MGMT_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000021', 353, '', NULL, '', '0023_0000000089', '0029_0000000032', NULL, NULL),
	('0022_0000000053', NULL, '0022_0000000053', NULL, '2019-12-24 08:30:56', NULL, '2019-12-21 11:34:18', 'GZP4_MGMT_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000033', 353, '', NULL, '', '0023_0000000090', '0029_0000000032', NULL, NULL),
	('0022_0000000055', NULL, '0022_0000000055', NULL, '2019-12-24 08:41:04', NULL, '2019-12-21 11:38:52', 'GZP3_ECN_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000022', 353, '', NULL, '', '0023_0000000087', '0029_0000000036', NULL, NULL),
	('0022_0000000056', NULL, '0022_0000000056', NULL, '2019-12-24 08:37:02', NULL, '2019-12-21 11:39:25', 'GZP4_ECN_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000030', 353, '', NULL, '', '0023_0000000088', '0029_0000000036', NULL, NULL),
	('0022_0000000057', NULL, '0022_0000000057', NULL, '2019-12-24 08:41:04', NULL, '2019-12-21 11:40:06', 'GZP3_DMZ_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000023', 353, '', NULL, '', '0023_0000000085', '0029_0000000035', NULL, NULL),
	('0022_0000000058', NULL, '0022_0000000058', NULL, '2019-12-24 08:38:01', NULL, '2019-12-21 11:40:39', 'GZP4_DMZ_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000027', 353, '', NULL, '', '0023_0000000086', '0029_0000000035', NULL, NULL),
	('0022_0000000059', NULL, '0022_0000000059', NULL, '2019-12-24 08:36:02', NULL, '2019-12-21 11:41:28', 'GZP4_SF_CS_DBLB', 37, '', '', 'DBLB', '0021_0000000024', 354, '', NULL, '', '0023_0000000092', '0029_0000000034', NULL, NULL),
	('0022_0000000060', NULL, '0022_0000000060', NULL, '2019-12-24 08:41:04', NULL, '2019-12-21 11:41:57', 'GZP3_MGMT_CS_DBLB', 37, '', '', 'DBLB', '0021_0000000021', 353, '', NULL, '', '0023_0000000093', '0029_0000000033', NULL, NULL),
	('0022_0000000061', NULL, '0022_0000000061', NULL, '2019-12-24 09:23:08', NULL, '2019-12-21 11:42:20', 'GZP4_MGMT_CS_DBLB', 37, '', '', 'DBLB', '0021_0000000033', 353, '', NULL, '', '0023_0000000094', '0029_0000000033', NULL, NULL),
	('0022_0000000062', NULL, '0022_0000000062', NULL, '2019-12-24 10:30:27', NULL, '2019-12-24 10:30:27', 'NDC_WAN_ALL_WANLB', 37, '', '', 'WANLB', '0021_0000000010', 355, '', NULL, '', '0023_0000000104', '0029_0000000037', NULL, NULL),
	('0022_0000000064', NULL, '0022_0000000064', NULL, '2020-01-08 03:34:12', NULL, '2019-12-25 04:16:16', 'GZP3_SF_CS_APPLB', 37, '2019-12-27 07:16:19', '', 'APPLB', '0021_0000000003', 353, '', NULL, '', '0023_0000000083', '0029_0000000031', 'subnet-enlmw0pe', 'rtb-mdmq4c3u'),
	('0022_0000000065', NULL, '0022_0000000065', NULL, '2019-12-25 09:43:55', NULL, '2019-12-25 04:16:53', 'GZP4_SF_CS_APPLB', 37, '', '', 'APPLB', '0021_0000000024', 353, '', NULL, '', '0023_0000000084', '0029_0000000031', NULL, NULL),
	('0022_0000000066', NULL, '0022_0000000007', NULL, '2019-12-27 07:16:24', NULL, '2019-12-17 18:07:39', 'GZP3_SF_CS_APP', 37, '2019-12-27 07:16:24', '', 'APP', '0021_0000000003', 87, '', NULL, '', '0023_0000000013', '0029_0000000008', 'subnet-gazxqz4k', NULL),
	('0022_0000000067', '0022_0000000066', '0022_0000000007', NULL, '2020-01-08 07:46:13', NULL, '2019-12-17 18:07:39', 'GZP3_SF_CS_APP', 38, '2020-01-08 02:42:30', '', 'APP', '0021_0000000003', 87, 'sudo yum install -y java-1.8.0-openjdk', 277, '', '0023_0000000013', '0029_0000000008', 'subnet-gazxqz4k', NULL),
	('0022_0000000068', NULL, '0022_0000000009', NULL, '2020-01-08 07:46:13', NULL, '2019-12-17 18:08:23', 'GZP3_SF_CS_DB', 37, '2019-12-27 07:16:24', '', 'DB', '0021_0000000003', 89, '', NULL, '', '0023_0000000015', '0029_0000000010', 'subnet-1m9bttw2', NULL);
/*!40000 ALTER TABLE `resource_set` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.resource_set$deploy_environment 的数据：~64 rows (大约)
/*!40000 ALTER TABLE `resource_set$deploy_environment` DISABLE KEYS */;
INSERT INTO `resource_set$deploy_environment` (`id`, `from_guid`, `to_code`, `seq_no`) VALUES
	(26, '0022_0000000024', 69, 1),
	(30, '0022_0000000026', 69, 1),
	(174, '0022_0000000053', 69, 1),
	(175, '0022_0000000049', 69, 1),
	(176, '0022_0000000048', 69, 1),
	(177, '0022_0000000047', 69, 1),
	(178, '0022_0000000046', 69, 1),
	(179, '0022_0000000045', 69, 1),
	(198, '0022_0000000059', 69, 1),
	(200, '0022_0000000036', 69, 1),
	(201, '0022_0000000035', 69, 1),
	(202, '0022_0000000034', 69, 1),
	(204, '0022_0000000032', 69, 1),
	(205, '0022_0000000031', 69, 1),
	(207, '0022_0000000029', 69, 1),
	(209, '0022_0000000056', 69, 1),
	(210, '0022_0000000044', 69, 1),
	(211, '0022_0000000043', 69, 1),
	(212, '0022_0000000042', 69, 1),
	(213, '0022_0000000041', 69, 1),
	(214, '0022_0000000058', 69, 1),
	(215, '0022_0000000040', 69, 1),
	(217, '0022_0000000038', 69, 1),
	(219, '0022_0000000028', 69, 1),
	(220, '0022_0000000025', 69, 1),
	(221, '0022_0000000022', 69, 1),
	(222, '0022_0000000021', 69, 1),
	(223, '0022_0000000020', 69, 1),
	(224, '0022_0000000010', 69, 1),
	(225, '0022_0000000009', 69, 1),
	(226, '0022_0000000008', 69, 1),
	(227, '0022_0000000006', 69, 1),
	(228, '0022_0000000005', 69, 1),
	(229, '0022_0000000003', 69, 1),
	(230, '0022_0000000002', 69, 1),
	(231, '0022_0000000060', 69, 1),
	(232, '0022_0000000057', 69, 1),
	(233, '0022_0000000055', 69, 1),
	(234, '0022_0000000052', 69, 1),
	(235, '0022_0000000051', 69, 1),
	(237, '0022_0000000019', 69, 1),
	(238, '0022_0000000018', 69, 1),
	(239, '0022_0000000017', 69, 1),
	(240, '0022_0000000016', 69, 1),
	(241, '0022_0000000015', 69, 1),
	(243, '0022_0000000013', 69, 1),
	(245, '0022_0000000011', 69, 1),
	(250, '0022_0000000061', 69, 1),
	(251, '0022_0000000062', 69, 1),
	(257, '0022_0000000023', 69, 1),
	(258, '0022_0000000063', 69, 1),
	(263, '0022_0000000039', 69, 1),
	(264, '0022_0000000037', 69, 1),
	(265, '0022_0000000014', 69, 1),
	(266, '0022_0000000012', 69, 1),
	(273, '0022_0000000004', 69, 1),
	(276, '0022_0000000030', 69, 1),
	(277, '0022_0000000027', 69, 1),
	(278, '0022_0000000033', 69, 1),
	(280, '0022_0000000001', 69, 1),
	(283, '0022_0000000065', 69, 1),
	(286, '0022_0000000064', 69, 1),
	(287, '0022_0000000066', 69, 1),
	(288, '0022_0000000007', 69, 1),
	(289, '0022_0000000067', 69, 1),
	(290, '0022_0000000068', 69, 1);
/*!40000 ALTER TABLE `resource_set$deploy_environment` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.resource_set_design 的数据：~34 rows (大约)
/*!40000 ALTER TABLE `resource_set_design` DISABLE KEYS */;
INSERT INTO `resource_set_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `business_zone_design`, `network_segment_design`, `unit_design_type`) VALUES
	('0029_0000000001', NULL, '0029_0000000001', NULL, '2019-12-21 09:18:36', NULL, '2019-12-16 02:00:13', 'V1_SF_BZa_APP', 34, '', '', 'APP', '0028_0000000001', '0030_0000000023', 60),
	('0029_0000000003', NULL, '0029_0000000003', NULL, '2019-12-17 15:54:50', NULL, '2019-12-16 09:54:59', 'V1_SF_BZa_CACHE', 34, '', '', 'CACHE', '0028_0000000001', '0030_0000000024', 62),
	('0029_0000000004', NULL, '0029_0000000004', NULL, '2019-12-21 09:17:26', NULL, '2019-12-16 09:55:52', 'V1_SF_BZa_DB', 34, '', '', 'DB', '0028_0000000001', '0030_0000000025', 61),
	('0029_0000000005', NULL, '0029_0000000005', NULL, '2019-12-21 09:18:36', NULL, '2019-12-16 09:56:49', 'V1_SF_BZb_APP', 34, '', '', 'APP', '0028_0000000002', '0030_0000000026', 60),
	('0029_0000000006', NULL, '0029_0000000006', NULL, '2019-12-17 15:54:50', NULL, '2019-12-16 09:57:41', 'V1_SF_BZb_CACHE', 34, '', '', 'CACHE', '0028_0000000002', '0030_0000000027', 62),
	('0029_0000000007', NULL, '0029_0000000007', NULL, '2019-12-21 09:17:26', NULL, '2019-12-16 09:58:12', 'V1_SF_BZb_DB', 34, '', '', 'DB', '0028_0000000002', '0030_0000000028', 61),
	('0029_0000000008', NULL, '0029_0000000008', NULL, '2019-12-21 09:18:36', NULL, '2019-12-16 09:59:39', 'V1_SF_CS_APP', 34, '', '', 'APP', '0028_0000000004', '0030_0000000029', 60),
	('0029_0000000009', NULL, '0029_0000000009', NULL, '2019-12-17 15:56:25', NULL, '2019-12-16 10:00:10', 'V1_SF_CS_CACHE', 34, '', '', 'CACHE', '0028_0000000004', '0030_0000000030', 62),
	('0029_0000000010', NULL, '0029_0000000010', NULL, '2019-12-21 09:17:26', NULL, '2019-12-16 10:00:58', 'V1_SF_CS_DB', 34, '', '', 'DB', '0028_0000000004', '0030_0000000031', 61),
	('0029_0000000011', NULL, '0029_0000000011', NULL, '2019-12-17 15:56:25', NULL, '2019-12-16 10:01:35', 'V1_SF_CS_BDP', 34, '', '', 'BDP', '0028_0000000004', '0030_0000000032', 265),
	('0029_0000000012', NULL, '0029_0000000012', NULL, '2019-12-17 15:56:25', NULL, '2019-12-16 10:51:53', 'V1_DMZ_BZa_IN', 34, '', '', 'IN', '0028_0000000003', '0030_0000000033', 257),
	('0029_0000000013', NULL, '0029_0000000013', NULL, '2019-12-21 09:20:15', NULL, '2019-12-16 10:55:09', 'V1_DMZ_BZa_OUT', 34, '', '', 'OUT', '0028_0000000003', '0030_0000000034', 280),
	('0029_0000000014', NULL, '0029_0000000014', NULL, '2019-12-17 15:56:24', NULL, '2019-12-16 11:12:18', 'V1_DMZ_BZb_IN', 34, '', '', 'IN', '0028_0000000006', '0030_0000000042', 257),
	('0029_0000000015', NULL, '0029_0000000015', NULL, '2019-12-21 09:20:15', NULL, '2019-12-16 11:12:51', 'V1_DMZ_BZb_OUT', 34, '', '', 'OUT', '0028_0000000006', '0030_0000000043', 280),
	('0029_0000000016', NULL, '0029_0000000016', NULL, '2019-12-21 09:19:44', NULL, '2019-12-16 11:21:26', 'V1_ECN_BZa_OWN', 34, '', '自主研发前置', 'OWN', '0028_0000000007', '0030_0000000035', 257),
	('0029_0000000017', NULL, '0029_0000000017', NULL, '2019-12-21 09:19:44', NULL, '2019-12-16 11:22:25', 'V1_ECN_BZa_NOWN', 34, '', '非自主研发前置', 'NOWN', '0028_0000000007', '0030_0000000036', 280),
	('0029_0000000018', NULL, '0029_0000000018', NULL, '2019-12-21 09:19:44', NULL, '2019-12-16 11:22:55', 'V1_ECN_BZb_OWN', 34, '', '', 'OWN', '0028_0000000008', '0030_0000000044', 257),
	('0029_0000000019', NULL, '0029_0000000019', NULL, '2019-12-21 09:19:44', NULL, '2019-12-16 11:23:30', 'V1_ECN_BZb_NOWN', 34, '', '', 'NOWN', '0028_0000000008', '0030_0000000045', 280),
	('0029_0000000020', NULL, '0029_0000000020', NULL, '2019-12-21 09:18:02', NULL, '2019-12-16 11:25:47', 'V1_MGMT_MT_APP', 34, '', '', 'APP', '0028_0000000005', '0030_0000000037', 60),
	('0029_0000000021', NULL, '0029_0000000021', NULL, '2019-12-17 18:12:25', NULL, '2019-12-16 11:26:24', 'V1_MGMT_MT_CACHE', 34, '', '', 'CACHE', '0028_0000000005', '0030_0000000038', 62),
	('0029_0000000022', NULL, '0029_0000000022', NULL, '2019-12-21 09:17:46', NULL, '2019-12-16 11:27:00', 'V1_MGMT_MT_DB', 34, '', '', 'DB', '0028_0000000005', '0030_0000000039', 61),
	('0029_0000000023', NULL, '0029_0000000023', NULL, '2019-12-17 18:12:25', NULL, '2019-12-16 11:27:35', 'V1_MGMT_MT_BDP', 34, '', '', 'BDP', '0028_0000000005', '0030_0000000040', 265),
	('0029_0000000024', NULL, '0029_0000000024', NULL, '2019-12-18 09:10:08', NULL, '2019-12-16 11:29:50', 'V1_MGMT_QZ_VDI', 34, '', '', 'VDI', '0028_0000000013', '0030_0000000046', 325),
	('0029_0000000026', NULL, '0029_0000000026', NULL, '2019-12-19 10:06:49', NULL, '2019-12-16 11:51:13', 'V1_WAN_ALL_AC', 34, '', '任意客户端', 'AC', '0028_0000000010', '', 280),
	('0029_0000000028', NULL, '0029_0000000028', NULL, '2019-12-24 10:38:24', NULL, '2019-12-16 14:17:12', 'V1_WAN_ALL_WS', 34, '', '广域网客户端', 'WS', '0028_0000000010', '0030_0000000070', 280),
	('0029_0000000029', NULL, '0029_0000000029', NULL, '2019-12-17 18:17:18', NULL, '2019-12-17 02:22:28', 'V1_OPN_ALL_VC', 34, '', 'VDI客户端', 'VC', '0028_0000000012', '0030_0000000052', 280),
	('0029_0000000030', NULL, '0029_0000000030', NULL, '2019-12-17 16:06:54', NULL, '2019-12-17 02:26:52', 'V1_PTN_ALL_FRONT', 34, '', '前置资源集合', 'FRONT', '0028_0000000011', '0030_0000000053', 280),
	('0029_0000000031', NULL, '0029_0000000031', NULL, '2019-12-25 09:43:55', NULL, '2019-12-21 09:10:15', 'V1_SF_CS_APPLB', 34, '', '', 'APPLB', '0028_0000000004', '0030_0000000054', 338),
	('0029_0000000032', NULL, '0029_0000000032', NULL, '2019-12-21 09:12:06', NULL, '2019-12-21 09:12:06', 'V1_MGMT_CS_APPLB', 34, '', '', 'APPLB', '0028_0000000015', '0030_0000000057', 338),
	('0029_0000000033', NULL, '0029_0000000033', NULL, '2019-12-21 09:12:37', NULL, '2019-12-21 09:12:37', 'V1_MGMT_CS_DBLB', 34, '', '', 'DBLB', '0028_0000000015', '0030_0000000059', 339),
	('0029_0000000034', NULL, '0029_0000000034', NULL, '2019-12-21 09:13:23', NULL, '2019-12-21 09:13:23', 'V1_SF_CS_DBLB', 34, '', '', 'DBLB', '0028_0000000004', '0030_0000000058', 339),
	('0029_0000000035', NULL, '0029_0000000035', NULL, '2019-12-21 09:15:23', NULL, '2019-12-21 09:15:23', 'V1_DMZ_CS_APPLB', 34, '', '', 'APPLB', '0028_0000000016', '0030_0000000055', 338),
	('0029_0000000036', NULL, '0029_0000000036', NULL, '2019-12-21 09:15:54', NULL, '2019-12-21 09:15:54', 'V1_ECN_CS_APPLB', 34, '', '', 'APPLB', '0028_0000000017', '0030_0000000056', 338),
	('0029_0000000037', NULL, '0029_0000000037', NULL, '2019-12-24 10:13:12', NULL, '2019-12-24 10:13:12', 'V1_WAN_ALL_WANLB', 34, '', '', 'WANLB', '0028_0000000010', '0030_0000000071', 348);
/*!40000 ALTER TABLE `resource_set_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.resource_set_design$cluster_type 的数据：~34 rows (大约)
/*!40000 ALTER TABLE `resource_set_design$cluster_type` DISABLE KEYS */;
INSERT INTO `resource_set_design$cluster_type` (`id`, `from_guid`, `to_code`, `seq_no`) VALUES
	(54, '0029_0000000006', 91, 1),
	(57, '0029_0000000003', 91, 1),
	(63, '0029_0000000014', 87, 1),
	(65, '0029_0000000012', 87, 1),
	(66, '0029_0000000011', 279, 1),
	(68, '0029_0000000009', 91, 1),
	(77, '0029_0000000030', 282, 1),
	(83, '0029_0000000023', 279, 1),
	(85, '0029_0000000021', 91, 1),
	(87, '0029_0000000029', 282, 1),
	(88, '0029_0000000024', 282, 1),
	(90, '0029_0000000026', 282, 1),
	(92, '0029_0000000032', 353, 1),
	(93, '0029_0000000033', 354, 1),
	(94, '0029_0000000034', 354, 1),
	(95, '0029_0000000035', 353, 1),
	(96, '0029_0000000036', 353, 1),
	(97, '0029_0000000010', 89, 1),
	(98, '0029_0000000007', 89, 1),
	(99, '0029_0000000004', 89, 1),
	(100, '0029_0000000022', 89, 1),
	(101, '0029_0000000020', 87, 1),
	(102, '0029_0000000008', 87, 1),
	(103, '0029_0000000005', 87, 1),
	(104, '0029_0000000001', 87, 1),
	(105, '0029_0000000019', 282, 1),
	(106, '0029_0000000018', 87, 1),
	(107, '0029_0000000017', 282, 1),
	(108, '0029_0000000016', 87, 1),
	(109, '0029_0000000015', 282, 1),
	(110, '0029_0000000013', 282, 1),
	(111, '0029_0000000037', 355, 1),
	(112, '0029_0000000028', 282, 1),
	(113, '0029_0000000031', 353, 1);
/*!40000 ALTER TABLE `resource_set_design$cluster_type` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.resource_set_invoke_design 的数据：~55 rows (大约)
/*!40000 ALTER TABLE `resource_set_invoke_design` DISABLE KEYS */;
INSERT INTO `resource_set_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `invoked_resource_set_design`, `invoke_resource_set_design`) VALUES
	('0036_0000000002', NULL, '0036_0000000002', NULL, '2019-12-21 12:48:59', NULL, '2019-12-21 09:53:57', 'V1_MGMT_MT_APP_invoke_V1_SF_BZb_APP', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_BZb_APP', '0029_0000000005', '0029_0000000020'),
	('0036_0000000003', NULL, '0036_0000000003', NULL, '2019-12-21 12:48:58', NULL, '2019-12-21 09:54:46', 'V1_MGMT_MT_APP_invoke_V1_SF_BZa_APP', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_BZa_APP', '0029_0000000001', '0029_0000000020'),
	('0036_0000000004', NULL, '0036_0000000004', NULL, '2019-12-25 04:27:02', NULL, '2019-12-25 04:20:46', 'V1_WAN_ALL_WANLB_invoke_V1_DMZ_BZa_IN', 34, '', '', 'V1_WAN_ALL_WANLB_invoke_V1_DMZ_BZa_IN', '0029_0000000012', '0029_0000000037'),
	('0036_0000000005', NULL, '0036_0000000005', NULL, '2019-12-25 04:27:29', NULL, '2019-12-25 04:27:29', 'V1_WAN_ALL_WANLB_invoke_V1_DMZ_BZb_IN', 34, '', '', 'V1_WAN_ALL_WANLB_invoke_V1_DMZ_BZb_IN', '0029_0000000014', '0029_0000000037'),
	('0036_0000000006', NULL, '0036_0000000006', NULL, '2019-12-25 04:28:27', NULL, '2019-12-25 04:28:27', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZa_OWN', 34, '', '', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZa_OWN', '0029_0000000016', '0029_0000000036'),
	('0036_0000000007', NULL, '0036_0000000007', NULL, '2019-12-25 04:28:51', NULL, '2019-12-25 04:28:51', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZa_NOWN', 34, '', '', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZa_NOWN', '0029_0000000017', '0029_0000000036'),
	('0036_0000000008', NULL, '0036_0000000008', NULL, '2019-12-25 04:29:19', NULL, '2019-12-25 04:29:19', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZb_OWN', 34, '', '', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZb_OWN', '0029_0000000018', '0029_0000000036'),
	('0036_0000000009', NULL, '0036_0000000009', NULL, '2019-12-25 04:29:36', NULL, '2019-12-25 04:29:36', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZb_NOWN', 34, '', '', 'V1_ECN_CS_APPLB_invoke_V1_ECN_BZb_NOWN', '0029_0000000019', '0029_0000000036'),
	('0036_0000000010', NULL, '0036_0000000010', NULL, '2019-12-25 04:30:15', NULL, '2019-12-25 04:30:15', 'V1_DMZ_CS_APPLB_invoke_V1_DMZ_BZa_OUT', 34, '', '', 'V1_DMZ_CS_APPLB_invoke_V1_DMZ_BZa_OUT', '0029_0000000013', '0029_0000000035'),
	('0036_0000000011', NULL, '0036_0000000011', NULL, '2019-12-25 04:30:36', NULL, '2019-12-25 04:30:36', 'V1_DMZ_CS_APPLB_invoke_V1_DMZ_BZb_OUT', 34, '', '', 'V1_DMZ_CS_APPLB_invoke_V1_DMZ_BZb_OUT', '0029_0000000015', '0029_0000000035'),
	('0036_0000000012', NULL, '0036_0000000012', NULL, '2019-12-25 04:31:05', NULL, '2019-12-25 04:31:05', 'V1_SF_CS_APPLB_invoke_V1_SF_BZa_APP', 34, '', '', 'V1_SF_CS_APPLB_invoke_V1_SF_BZa_APP', '0029_0000000001', '0029_0000000031'),
	('0036_0000000013', NULL, '0036_0000000013', NULL, '2019-12-25 08:38:21', NULL, '2019-12-25 08:38:20', 'V1_MGMT_MT_APP_invoke_V1_SF_BZa_CACHE', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_BZa_CACHE', '0029_0000000003', '0029_0000000020'),
	('0036_0000000014', NULL, '0036_0000000014', NULL, '2019-12-25 08:38:59', NULL, '2019-12-25 08:38:59', 'V1_MGMT_MT_APP_invoke_V1_SF_BZa_DB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_BZa_DB', '0029_0000000004', '0029_0000000020'),
	('0036_0000000015', NULL, '0036_0000000015', NULL, '2019-12-25 08:39:08', NULL, '2019-12-25 08:39:07', 'V1_MGMT_MT_APP_invoke_V1_SF_BZb_CACHE', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_BZb_CACHE', '0029_0000000006', '0029_0000000020'),
	('0036_0000000016', NULL, '0036_0000000016', NULL, '2019-12-25 08:39:17', NULL, '2019-12-25 08:39:17', 'V1_MGMT_MT_APP_invoke_V1_SF_BZb_DB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_BZb_DB', '0029_0000000007', '0029_0000000020'),
	('0036_0000000017', NULL, '0036_0000000017', NULL, '2019-12-25 08:39:29', NULL, '2019-12-25 08:39:29', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_APP', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_APP', '0029_0000000008', '0029_0000000020'),
	('0036_0000000018', NULL, '0036_0000000018', NULL, '2019-12-25 08:39:41', NULL, '2019-12-25 08:39:40', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_CACHE', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_CACHE', '0029_0000000009', '0029_0000000020'),
	('0036_0000000019', NULL, '0036_0000000019', NULL, '2019-12-25 08:39:52', NULL, '2019-12-25 08:39:52', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_DB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_DB', '0029_0000000010', '0029_0000000020'),
	('0036_0000000020', NULL, '0036_0000000020', NULL, '2019-12-25 08:40:06', NULL, '2019-12-25 08:40:06', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_BDP', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_BDP', '0029_0000000011', '0029_0000000020'),
	('0036_0000000021', NULL, '0036_0000000021', NULL, '2019-12-25 08:40:19', NULL, '2019-12-25 08:40:19', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZa_IN', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZa_IN', '0029_0000000012', '0029_0000000020'),
	('0036_0000000022', NULL, '0036_0000000022', NULL, '2019-12-25 08:40:35', NULL, '2019-12-25 08:40:35', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZa_OUT', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZa_OUT', '0029_0000000013', '0029_0000000020'),
	('0036_0000000023', NULL, '0036_0000000023', NULL, '2019-12-25 08:40:45', NULL, '2019-12-25 08:40:45', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZb_IN', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZb_IN', '0029_0000000014', '0029_0000000020'),
	('0036_0000000024', NULL, '0036_0000000024', NULL, '2019-12-25 08:41:06', NULL, '2019-12-25 08:41:06', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZb_OUT', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_DMZ_BZb_OUT', '0029_0000000015', '0029_0000000020'),
	('0036_0000000025', NULL, '0036_0000000025', NULL, '2019-12-25 08:41:19', NULL, '2019-12-25 08:41:19', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZa_OWN', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZa_OWN', '0029_0000000016', '0029_0000000020'),
	('0036_0000000026', NULL, '0036_0000000026', NULL, '2019-12-25 08:41:29', NULL, '2019-12-25 08:41:29', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZa_NOWN', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZa_NOWN', '0029_0000000017', '0029_0000000020'),
	('0036_0000000027', NULL, '0036_0000000027', NULL, '2019-12-25 08:41:46', NULL, '2019-12-25 08:41:46', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZb_OWN', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZb_OWN', '0029_0000000018', '0029_0000000020'),
	('0036_0000000028', NULL, '0036_0000000028', NULL, '2019-12-25 08:42:02', NULL, '2019-12-25 08:42:02', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZb_NOWN', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_ECN_BZb_NOWN', '0029_0000000019', '0029_0000000020'),
	('0036_0000000029', NULL, '0036_0000000029', NULL, '2019-12-25 08:42:27', NULL, '2019-12-25 08:42:27', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000020'),
	('0036_0000000030', NULL, '0036_0000000030', NULL, '2019-12-25 08:44:21', NULL, '2019-12-25 08:42:56', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_DBLB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_SF_CS_DBLB', '0029_0000000034', '0029_0000000020'),
	('0036_0000000031', NULL, '0036_0000000031', NULL, '2019-12-25 08:44:11', NULL, '2019-12-25 08:43:18', 'V1_MGMT_MT_APP_invoke_V1_DMZ_CS_APPLB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_DMZ_CS_APPLB', '0029_0000000035', '0029_0000000020'),
	('0036_0000000032', NULL, '0036_0000000032', NULL, '2019-12-25 08:43:49', NULL, '2019-12-25 08:43:49', 'V1_MGMT_MT_APP_invoke_V1_ECN_CS_APPLB', 34, '', '', 'V1_MGMT_MT_APP_invoke_V1_ECN_CS_APPLB', '0029_0000000036', '0029_0000000020'),
	('0036_0000000033', NULL, '0036_0000000033', NULL, '2019-12-25 08:46:57', NULL, '2019-12-25 08:46:57', 'V1_SF_CS_APPLB_invoke_V1_SF_BZb_APP', 34, '', '', 'V1_SF_CS_APPLB_invoke_V1_SF_BZb_APP', '0029_0000000005', '0029_0000000031'),
	('0036_0000000034', NULL, '0036_0000000034', NULL, '2019-12-25 08:47:06', NULL, '2019-12-25 08:47:06', 'V1_SF_CS_APPLB_invoke_V1_SF_CS_APP', 34, '', '', 'V1_SF_CS_APPLB_invoke_V1_SF_CS_APP', '0029_0000000008', '0029_0000000031'),
	('0036_0000000035', NULL, '0036_0000000035', NULL, '2019-12-25 08:47:44', NULL, '2019-12-25 08:47:44', 'V1_SF_CS_DBLB_invoke_V1_SF_BZa_DB', 34, '', '', 'V1_SF_CS_DBLB_invoke_V1_SF_BZa_DB', '0029_0000000004', '0029_0000000034'),
	('0036_0000000036', NULL, '0036_0000000036', NULL, '2019-12-25 08:47:52', NULL, '2019-12-25 08:47:52', 'V1_SF_CS_DBLB_invoke_V1_SF_BZb_DB', 34, '', '', 'V1_SF_CS_DBLB_invoke_V1_SF_BZb_DB', '0029_0000000007', '0029_0000000034'),
	('0036_0000000037', NULL, '0036_0000000037', NULL, '2019-12-25 08:48:15', NULL, '2019-12-25 08:48:02', 'V1_SF_CS_DBLB_invoke_V1_SF_CS_DB', 34, '', '', 'V1_SF_CS_DBLB_invoke_V1_SF_CS_DB', '0029_0000000010', '0029_0000000034'),
	('0036_0000000038', NULL, '0036_0000000038', NULL, '2019-12-25 08:48:48', NULL, '2019-12-25 08:48:48', 'V1_MGMT_CS_APPLB_invoke_V1_MGMT_MT_APP', 34, '', '', 'V1_MGMT_CS_APPLB_invoke_V1_MGMT_MT_APP', '0029_0000000020', '0029_0000000032'),
	('0036_0000000039', NULL, '0036_0000000039', NULL, '2019-12-25 08:49:06', NULL, '2019-12-25 08:49:06', 'V1_MGMT_CS_DBLB_invoke_V1_MGMT_MT_DB', 34, '', '', 'V1_MGMT_CS_DBLB_invoke_V1_MGMT_MT_DB', '0029_0000000022', '0029_0000000033'),
	('0036_0000000040', NULL, '0036_0000000040', NULL, '2019-12-25 08:50:10', NULL, '2019-12-25 08:50:10', 'V1_MGMT_QZ_VDI_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_MGMT_QZ_VDI_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000024'),
	('0036_0000000041', NULL, '0036_0000000041', NULL, '2019-12-25 08:50:26', NULL, '2019-12-25 08:50:26', 'V1_MGMT_QZ_VDI_invoke_V1_MGMT_CS_APPLB', 34, '', '', 'V1_MGMT_QZ_VDI_invoke_V1_MGMT_CS_APPLB', '0029_0000000032', '0029_0000000024'),
	('0036_0000000042', NULL, '0036_0000000042', NULL, '2019-12-25 08:51:08', NULL, '2019-12-25 08:51:08', 'V1_WAN_ALL_WS_invoke_V1_WAN_ALL_WANLB', 34, '', '', 'V1_WAN_ALL_WS_invoke_V1_WAN_ALL_WANLB', '0029_0000000037', '0029_0000000028'),
	('0036_0000000043', NULL, '0036_0000000043', NULL, '2019-12-25 08:51:44', NULL, '2019-12-25 08:51:44', 'V1_DMZ_BZa_OUT_invoke_V1_WAN_ALL_AC', 34, '', '', 'V1_DMZ_BZa_OUT_invoke_V1_WAN_ALL_AC', '0029_0000000026', '0029_0000000013'),
	('0036_0000000044', NULL, '0036_0000000044', NULL, '2019-12-25 08:51:54', NULL, '2019-12-25 08:51:54', 'V1_DMZ_BZb_OUT_invoke_V1_WAN_ALL_AC', 34, '', '', 'V1_DMZ_BZb_OUT_invoke_V1_WAN_ALL_AC', '0029_0000000026', '0029_0000000015'),
	('0036_0000000045', NULL, '0036_0000000045', NULL, '2019-12-25 08:52:50', NULL, '2019-12-25 08:52:50', 'V1_ECN_BZa_OWN_invoke_V1_PTN_ALL_FRONT', 34, '', '', 'V1_ECN_BZa_OWN_invoke_V1_PTN_ALL_FRONT', '0029_0000000030', '0029_0000000016'),
	('0036_0000000046', NULL, '0036_0000000046', NULL, '2019-12-25 08:52:59', NULL, '2019-12-25 08:52:59', 'V1_ECN_BZa_NOWN_invoke_V1_PTN_ALL_FRONT', 34, '', '', 'V1_ECN_BZa_NOWN_invoke_V1_PTN_ALL_FRONT', '0029_0000000030', '0029_0000000017'),
	('0036_0000000047', NULL, '0036_0000000047', NULL, '2019-12-25 08:53:08', NULL, '2019-12-25 08:53:08', 'V1_ECN_BZb_OWN_invoke_V1_PTN_ALL_FRONT', 34, '', '', 'V1_ECN_BZb_OWN_invoke_V1_PTN_ALL_FRONT', '0029_0000000030', '0029_0000000018'),
	('0036_0000000048', NULL, '0036_0000000048', NULL, '2019-12-25 08:53:26', NULL, '2019-12-25 08:53:26', 'V1_ECN_BZb_NOWN_invoke_V1_PTN_ALL_FRONT', 34, '', '', 'V1_ECN_BZb_NOWN_invoke_V1_PTN_ALL_FRONT', '0029_0000000030', '0029_0000000019'),
	('0036_0000000049', NULL, '0036_0000000049', NULL, '2019-12-25 10:17:32', NULL, '2019-12-25 10:17:32', 'V1_DMZ_BZa_IN_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_DMZ_BZa_IN_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000012'),
	('0036_0000000050', NULL, '0036_0000000050', NULL, '2019-12-25 10:17:42', NULL, '2019-12-25 10:17:42', 'V1_DMZ_BZb_IN_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_DMZ_BZb_IN_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000014'),
	('0036_0000000051', NULL, '0036_0000000051', NULL, '2019-12-25 10:19:50', NULL, '2019-12-25 10:19:50', 'V1_SF_BZa_APP_invoke_V1_SF_CS_DBLB', 34, '', '', 'V1_SF_BZa_APP_invoke_V1_SF_CS_DBLB', '0029_0000000034', '0029_0000000001'),
	('0036_0000000052', NULL, '0036_0000000052', NULL, '2019-12-25 10:19:58', NULL, '2019-12-25 10:19:58', 'V1_SF_BZb_APP_invoke_V1_SF_CS_DBLB', 34, '', '', 'V1_SF_BZb_APP_invoke_V1_SF_CS_DBLB', '0029_0000000034', '0029_0000000005'),
	('0036_0000000053', NULL, '0036_0000000053', NULL, '2019-12-25 10:20:11', NULL, '2019-12-25 10:20:11', 'V1_SF_CS_APP_invoke_V1_SF_CS_DB', 34, '', '', 'V1_SF_CS_APP_invoke_V1_SF_CS_DB', '0029_0000000010', '0029_0000000008'),
	('0036_0000000054', NULL, '0036_0000000054', NULL, '2019-12-25 10:21:44', NULL, '2019-12-25 10:21:44', 'V1_SF_BZa_APP_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_SF_BZa_APP_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000001'),
	('0036_0000000055', NULL, '0036_0000000055', NULL, '2019-12-25 10:22:08', NULL, '2019-12-25 10:22:08', 'V1_SF_BZb_APP_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_SF_BZb_APP_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000005'),
	('0036_0000000056', NULL, '0036_0000000056', NULL, '2019-12-25 10:22:28', NULL, '2019-12-25 10:22:28', 'V1_SF_CS_APP_invoke_V1_SF_CS_APPLB', 34, '', '', 'V1_SF_CS_APP_invoke_V1_SF_CS_APPLB', '0029_0000000031', '0029_0000000008');
/*!40000 ALTER TABLE `resource_set_invoke_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.routing_rule 的数据：~43 rows (大约)
/*!40000 ALTER TABLE `routing_rule` DISABLE KEYS */;
INSERT INTO `routing_rule` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `asset_code`, `dest_network_segment`, `network_zone_link_design`, `routing_rule_design`, `vpn_connection_asset_code`, `customer_gateway_ip`, `owner_resource_set`, `owner_vpc_network_zone`) VALUES
	('0024_0000000095', NULL, '0024_0000000095', NULL, '2020-01-02 05:51:26', NULL, '2019-12-26 02:31:20', 'GZP_MGMT_to_10.128.160.0/24_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP_MGMT_route to_GZ3P-ECN-CS-APPLB', '140495', '0023_0000000087', '0020_0000000004', '0031_0000000071', '', '', '', '0019_0000000004'),
	('0024_0000000096', NULL, '0024_0000000096', NULL, '2020-01-02 05:51:26', NULL, '2019-12-26 03:00:10', 'GZP3_ECN_CS_APPLB_to_10.128.192.0/19_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP3_ECN_CS_APPLB_route to_GZ-MGMT', '', '0023_0000000031', '0020_0000000004', '0031_0000000070', '', '', '0022_0000000055', ''),
	('0024_0000000097', NULL, '0024_0000000097', NULL, '2020-01-02 05:51:26', NULL, '2019-12-26 03:00:33', 'GZP4_ECN_CS_APPLB_to_10.128.192.0/19_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP4_ECN_CS_APPLB_route to_GZ-MGMT', '', '0023_0000000031', '0020_0000000004', '0031_0000000070', '', '', '0022_0000000056', ''),
	('0024_0000000098', NULL, '0024_0000000098', NULL, '2020-01-02 05:51:09', NULL, '2019-12-26 03:10:23', 'GZP3_ECN_CS_APPLB_to_10.128.0.0/17_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP3_ECN_CS_APPLB_route to_GZ-SF', '', '0023_0000000003', '0020_0000000003', '0031_0000000067', '', '', '0022_0000000055', ''),
	('0024_0000000099', NULL, '0024_0000000099', NULL, '2020-01-02 05:51:09', NULL, '2019-12-26 03:10:43', 'GZP4_ECN_CS_APPLB_to_10.128.0.0/17_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP4_ECN_CS_APPLB_route to_GZ-SF', '', '0023_0000000003', '0020_0000000003', '0031_0000000067', '', '', '0022_0000000056', ''),
	('0024_0000000100', NULL, '0024_0000000100', NULL, '2020-01-02 05:51:09', NULL, '2019-12-26 03:12:33', 'GZP_MGMT_to_10.128.168.0/24_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP_MGMT_route to_GZ4P-ECN-CS-APPLB', '', '0023_0000000088', '0020_0000000004', '0031_0000000071', '', '', '', '0019_0000000004'),
	('0024_0000000101', NULL, '0024_0000000101', NULL, '2020-01-02 05:51:08', NULL, '2019-12-26 03:13:16', 'GZP_SF_to_10.128.160.0/24_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP_SF_route to_GZ3P-ECN-CS-APPLB', '', '0023_0000000087', '0020_0000000003', '0031_0000000061', '', '', '', '0019_0000000001'),
	('0024_0000000102', NULL, '0024_0000000102', NULL, '2020-01-02 05:51:08', NULL, '2019-12-26 03:13:41', 'GZP_SF_to_10.128.168.0/24_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP_SF_route to_GZ4P-ECN-CS-APPLB', '', '0023_0000000088', '0020_0000000003', '0031_0000000061', '', '', '', '0019_0000000001'),
	('0024_0000000103', NULL, '0024_0000000103', NULL, '2020-01-02 05:51:08', NULL, '2019-12-26 07:08:23', 'GZP3_DMZ_CS_APPLB_to_10.128.192.0/19_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP3_DMZ_CS_APPLB_route to_GZ-MGMT', '', '0023_0000000031', '0020_0000000005', '0031_0000000068', '', '', '0022_0000000057', ''),
	('0024_0000000104', NULL, '0024_0000000104', NULL, '2020-01-02 05:51:08', NULL, '2019-12-26 07:08:53', 'GZP4_DMZ_CS_APPLB_to_10.128.192.0/19_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP4_DMZ_CS_APPLB_route to_GZ-MGMT', '', '0023_0000000031', '0020_0000000005', '0031_0000000068', '', '', '0022_0000000058', ''),
	('0024_0000000105', NULL, '0024_0000000105', NULL, '2020-01-02 05:51:07', NULL, '2019-12-26 07:10:10', 'GZP_MGMT_to_10.128.128.0/24_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP_MGMT_route to_GZ3P-DMZ-CS-APPLB', '', '0023_0000000085', '0020_0000000005', '0031_0000000069', '', '', '', '0019_0000000004'),
	('0024_0000000106', NULL, '0024_0000000106', NULL, '2020-01-02 05:51:07', NULL, '2019-12-26 07:10:54', 'GZP_MGMT_to_10.128.136.0/24_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP_MGMT_route to_GZ4P-DMZ-CS-APPLB', '', '0023_0000000086', '0020_0000000005', '0031_0000000069', '', '', '', '0019_0000000004'),
	('0024_0000000107', NULL, '0024_0000000107', NULL, '2020-01-02 05:51:07', NULL, '2019-12-26 07:11:28', 'GZP3_DMZ_CS_APPLB_to_10.128.0.0/17_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP3_DMZ_CS_APPLB_route to_GZ-SF', '', '0023_0000000003', '0020_0000000002', '0031_0000000066', '', '', '0022_0000000057', ''),
	('0024_0000000108', NULL, '0024_0000000108', NULL, '2020-01-02 05:50:50', NULL, '2019-12-26 07:11:57', 'GZP4_DMZ_CS_APPLB_to_10.128.0.0/17_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP4_DMZ_CS_APPLB_route to_GZ-SF', '', '0023_0000000003', '0020_0000000002', '0031_0000000066', '', '', '0022_0000000058', ''),
	('0024_0000000109', NULL, '0024_0000000109', NULL, '2020-01-02 05:50:50', NULL, '2019-12-26 07:12:34', 'GZP_SF_to_10.128.128.0/24_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP_SF_route to_GZ3P-DMZ-CS-APPLB', '', '0023_0000000085', '0020_0000000002', '0031_0000000062', '', '', '', '0019_0000000001'),
	('0024_0000000110', NULL, '0024_0000000110', NULL, '2020-01-02 05:50:50', NULL, '2019-12-26 07:13:03', 'GZP_SF_to_10.128.136.0/24_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP_SF_route to_GZ4P-DMZ-CS-APPLB', '', '0023_0000000086', '0020_0000000002', '0031_0000000062', '', '', '', '0019_0000000001'),
	('0024_0000000111', NULL, '0024_0000000111', NULL, '2020-01-02 05:50:50', NULL, '2019-12-26 07:16:02', 'GZP3_SF_CS_APPLB_to_10.128.128.0/19_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP3_SF_CS_APPLB_route to_GZ-DMZ', '', '0023_0000000017', '0020_0000000002', '0031_0000000050', '', '', '0022_0000000064', ''),
	('0024_0000000112', NULL, '0024_0000000112', NULL, '2020-01-02 05:50:49', NULL, '2019-12-26 07:16:23', 'GZP4_SF_CS_APPLB_to_10.128.128.0/19_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP4_SF_CS_APPLB_route to_GZ-DMZ', '', '0023_0000000017', '0020_0000000002', '0031_0000000050', '', '', '0022_0000000065', ''),
	('0024_0000000113', NULL, '0024_0000000113', NULL, '2020-01-02 05:50:49', NULL, '2019-12-26 07:18:31', 'GZP_DMZ_to_10.128.0.0/23_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP_DMZ_route to_GZ3P-SF-CS-APPLB', '', '0023_0000000083', '0020_0000000002', '0031_0000000054', '', '', '', '0019_0000000002'),
	('0024_0000000114', NULL, '0024_0000000114', NULL, '2020-01-02 05:50:49', NULL, '2019-12-26 07:18:53', 'GZP_DMZ_to_10.128.32.0/23_go_GZP_DMZ-link-GZP_SF', 37, '', '', 'GZP_DMZ_route to_GZ4P-SF-CS-APPLB', '', '0023_0000000084', '0020_0000000002', '0031_0000000054', '', '', '', '0019_0000000002'),
	('0024_0000000115', NULL, '0024_0000000115', NULL, '2020-01-02 05:50:48', NULL, '2019-12-26 07:19:15', 'GZP3_SF_CS_APPLB_to_10.128.160.0/19_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP3_SF_CS_APPLB_route to_GZ-ECN', '', '0023_0000000024', '0020_0000000003', '0031_0000000049', '', '', '0022_0000000064', ''),
	('0024_0000000116', NULL, '0024_0000000116', NULL, '2020-01-02 05:50:48', NULL, '2019-12-26 07:19:31', 'GZP4_SF_CS_APPLB_to_10.128.160.0/19_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP4_SF_CS_APPLB_route to_GZ-ECN', '', '0023_0000000024', '0020_0000000003', '0031_0000000049', '', '', '0022_0000000065', ''),
	('0024_0000000117', NULL, '0024_0000000117', NULL, '2020-01-02 05:50:48', NULL, '2019-12-26 07:20:44', 'GZP_ECN_to_10.128.0.0/23_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP_ECN_route to_GZ3P-SF-CS-APPLB', '', '0023_0000000083', '0020_0000000003', '0031_0000000056', '', '', '', '0019_0000000003'),
	('0024_0000000118', NULL, '0024_0000000118', NULL, '2020-01-02 05:50:30', NULL, '2019-12-26 07:21:08', 'GZP_ECN_to_10.128.32.0/23_go_GZP_ECN-link-GZP_SF', 37, '', '', 'GZP_ECN_route to_GZ4P-SF-CS-APPLB', '', '0023_0000000084', '0020_0000000003', '0031_0000000056', '', '', '', '0019_0000000003'),
	('0024_0000000119', NULL, '0024_0000000119', NULL, '2020-01-02 05:50:30', NULL, '2019-12-26 07:22:03', 'GZP3_SF_CS_APPLB_to_10.128.192.0/19_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP3_SF_CS_APPLB_route to_GZ-MGMT', '', '0023_0000000031', '0020_0000000001', '0031_0000000048', '', '', '0022_0000000064', ''),
	('0024_0000000120', NULL, '0024_0000000120', NULL, '2020-01-02 05:50:30', NULL, '2019-12-26 07:22:21', 'GZP4_SF_CS_APPLB_to_10.128.192.0/19_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP4_SF_CS_APPLB_route to_GZ-MGMT', '', '0023_0000000031', '0020_0000000001', '0031_0000000048', '', '', '0022_0000000065', ''),
	('0024_0000000121', NULL, '0024_0000000121', NULL, '2020-01-02 05:50:30', NULL, '2019-12-26 07:22:55', 'GZP_MGMT_to_10.128.0.0/23_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP_MGMT_route to_GZ3P-SF-CS-APPLB', '', '0023_0000000083', '0020_0000000001', '0031_0000000055', '', '', '', '0019_0000000004'),
	('0024_0000000122', NULL, '0024_0000000122', NULL, '2020-01-02 05:50:29', NULL, '2019-12-26 07:23:16', 'GZP_MGMT_to_10.128.32.0/23_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP_MGMT_route to_GZ4P-SF-CS-APPLB', '', '0023_0000000084', '0020_0000000001', '0031_0000000055', '', '', '', '0019_0000000004'),
	('0024_0000000123', NULL, '0024_0000000123', NULL, '2020-01-02 05:50:29', NULL, '2019-12-26 07:24:40', 'GZP3_MGMT_MT_APP_to_10.128.160.0/19_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP3_MGMT_MT_APP_route to_GZ-ECN', '', '0023_0000000024', '0020_0000000004', '0031_0000000053', '', '', '0022_0000000019', ''),
	('0024_0000000124', NULL, '0024_0000000124', NULL, '2020-01-02 05:50:29', NULL, '2019-12-26 07:24:57', 'GZP4_MGMT_MT_APP_to_10.128.160.0/19_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP4_MGMT_MT_APP_route to_GZ-ECN', '', '0023_0000000024', '0020_0000000004', '0031_0000000053', '', '', '0022_0000000045', ''),
	('0024_0000000125', NULL, '0024_0000000125', NULL, '2020-01-02 05:50:28', NULL, '2019-12-26 07:26:34', 'GZP_ECN_to_10.128.194.0/25_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP_ECN_route to_GZ3P-MGMT-MT-APP', '', '0023_0000000033', '0020_0000000004', '0031_0000000059', '', '', '', '0019_0000000003'),
	('0024_0000000126', NULL, '0024_0000000126', NULL, '2020-01-02 05:50:28', NULL, '2019-12-26 07:26:57', 'GZP_ECN_to_10.128.202.0/25_go_GZP_MGMT-link-GZP_ECN', 37, '', '', 'GZP_ECN_route to_GZ4P-MGMT-MT-APP', '', '0023_0000000076', '0020_0000000004', '0031_0000000059', '', '', '', '0019_0000000003'),
	('0024_0000000127', NULL, '0024_0000000127', NULL, '2020-01-02 05:50:28', NULL, '2019-12-26 07:28:37', 'GZP3_MGMT_MT_APP_to_10.128.128.0/19_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP3_MGMT_MT_APP_route to_GZ-DMZ', '', '0023_0000000017', '0020_0000000005', '0031_0000000052', '', '', '0022_0000000019', ''),
	('0024_0000000128', NULL, '0024_0000000128', NULL, '2020-01-02 05:49:57', NULL, '2019-12-26 07:28:53', 'GZP4_MGMT_MT_APP_to_10.128.128.0/19_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP4_MGMT_MT_APP_route to_GZ-DMZ', '', '0023_0000000017', '0020_0000000005', '0031_0000000052', '', '', '0022_0000000045', ''),
	('0024_0000000129', NULL, '0024_0000000129', NULL, '2020-01-02 05:49:57', NULL, '2019-12-26 07:29:18', 'GZP_DMZ_to_10.128.194.0/25_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP_DMZ_route to_GZ3P-MGMT-MT-APP', '', '0023_0000000033', '0020_0000000005', '0031_0000000058', '', '', '', '0019_0000000002'),
	('0024_0000000130', NULL, '0024_0000000130', NULL, '2020-01-02 05:49:57', NULL, '2019-12-26 07:29:40', 'GZP_DMZ_to_10.128.202.0/25_go_GZP_DMZ-link-GZP_MGMT', 37, '', '', 'GZP_DMZ_route to_GZ4P-MGMT-MT-APP', '', '0023_0000000076', '0020_0000000005', '0031_0000000058', '', '', '', '0019_0000000002'),
	('0024_0000000131', NULL, '0024_0000000131', NULL, '2020-01-02 05:49:56', NULL, '2019-12-26 07:29:58', 'GZP3_MGMT_MT_APP_to_10.128.0.0/17_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP3_MGMT_MT_APP_route to_GZ-SF', '', '0023_0000000003', '0020_0000000001', '0031_0000000051', '', '', '0022_0000000019', ''),
	('0024_0000000132', NULL, '0024_0000000132', NULL, '2020-01-02 05:49:56', NULL, '2019-12-26 07:30:16', 'GZP4_MGMT_MT_APP_to_10.128.0.0/17_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP4_MGMT_MT_APP_route to_GZ-SF', '', '0023_0000000003', '0020_0000000001', '0031_0000000051', '', '', '0022_0000000045', ''),
	('0024_0000000133', NULL, '0024_0000000133', NULL, '2020-01-02 05:49:56', NULL, '2019-12-26 07:30:43', 'GZP_SF_to_10.128.194.0/25_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP_SF_route to_GZ3P-MGMT-MT-APP', '', '0023_0000000033', '0020_0000000001', '0031_0000000057', '', '', '', '0019_0000000001'),
	('0024_0000000134', NULL, '0024_0000000134', NULL, '2020-01-02 05:49:55', NULL, '2019-12-26 07:31:00', 'GZP_SF_to_10.128.202.0/25_go_GZP_MGMT-link-GZP_SF', 37, '', '', 'GZP_SF_route to_GZ4P-MGMT-MT-APP', '', '0023_0000000076', '0020_0000000001', '0031_0000000057', '', '', '', '0019_0000000001'),
	('0024_0000000135', NULL, '0024_0000000135', NULL, '2020-01-02 05:49:55', NULL, '2019-12-26 07:36:46', 'GZP_DMZ_to_0.0.0.0/0_go_NDC_WAN-link-GZP_DMZ', 37, '', '', 'GZP_DMZ_route to_WAN', '', '0023_0000000082', '0020_0000000015', '0031_0000000063', '', '', '', '0019_0000000002'),
	('0024_0000000136', NULL, '0024_0000000136', NULL, '2020-01-02 05:49:55', NULL, '2019-12-26 07:37:06', 'GZP_MGMT_to_10.1.0.0/20_go_NDC_OPN-link-GZP_MGMT', 37, '', '', 'GZP_MGMT_route to_NDC-OPN', '', '0023_0000000041', '0020_0000000007', '0031_0000000065', '', '', '', '0019_0000000004'),
	('0024_0000000137', NULL, '0024_0000000137', NULL, '2020-01-02 05:49:54', NULL, '2019-12-26 07:44:18', 'GZP_ECN_to_10.2.1.0/24_go_GZP_ECN-link-NDC_PTN', 37, '', '', 'GZP_ECN_route to_PTN', '', '0023_0000000131', '0020_0000000017', '0031_0000000064', '', '', '', '0019_0000000003');
/*!40000 ALTER TABLE `routing_rule` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.routing_rule_design 的数据：~23 rows (大约)
/*!40000 ALTER TABLE `routing_rule_design` DISABLE KEYS */;
INSERT INTO `routing_rule_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `dest_network_segment`, `network_zone_link_design`, `owner_vpc_network_zone_design`, `owner_resource_set_design`) VALUES
	('0031_0000000048', NULL, '0031_0000000048', NULL, '2020-01-02 05:55:52', NULL, '2019-12-19 11:53:59', 'V1_SF_CS_APPLB_to_MGMT_go_V1_MGMT-link-V1_SF', 34, '', '', 'V1_SF_CS_APPLB_route_MGMT', '0030_0000000004', '0027_0000000002', NULL, '0029_0000000031'),
	('0031_0000000049', NULL, '0031_0000000049', NULL, '2020-01-02 05:55:51', NULL, '2019-12-19 11:54:17', 'V1_SF_CS_APPLB_to_ECN_go_V1_ECN-link-V1_SF', 34, '', '', 'V1_SF_CS_APPLB_route_ECN', '0030_0000000006', '0027_0000000004', NULL, '0029_0000000031'),
	('0031_0000000050', NULL, '0031_0000000050', NULL, '2020-01-02 05:55:51', NULL, '2019-12-19 11:55:06', 'V1_SF_CS_APPLB_to_DMZ_go_V1_DMZ-link-V1_SF', 34, '', '', 'V1_SF_CS_APPLB_route_DMZ', '0030_0000000005', '0027_0000000003', NULL, '0029_0000000031'),
	('0031_0000000051', NULL, '0031_0000000051', NULL, '2020-01-02 05:55:44', NULL, '2019-12-19 11:57:12', 'V1_MGMT_MT_APP_to_SF_go_V1_MGMT-link-V1_SF', 34, '', '', 'V1_MGMT_MT_APP_route_SF', '0030_0000000003', '0027_0000000002', NULL, '0029_0000000020'),
	('0031_0000000052', NULL, '0031_0000000052', NULL, '2020-01-02 05:55:43', NULL, '2019-12-19 11:57:32', 'V1_MGMT_MT_APP_to_DMZ_go_V1_DMZ-link-V1_MGMT', 34, '', '', 'V1_MGMT_MT_APP_route_DMZ', '0030_0000000005', '0027_0000000009', NULL, '0029_0000000020'),
	('0031_0000000053', NULL, '0031_0000000053', NULL, '2020-01-02 05:55:43', NULL, '2019-12-19 11:57:57', 'V1_MGMT_MT_APP_to_ECN_go_V1_MGMT-link-V1_ECN', 34, '', '', 'V1_MGMT_MT_APP_route_ECN', '0030_0000000006', '0027_0000000008', NULL, '0029_0000000020'),
	('0031_0000000054', NULL, '0031_0000000054', NULL, '2020-01-02 05:55:43', NULL, '2019-12-19 11:59:03', 'V1_DMZ_to_SF-CS-APPLB_go_V1_DMZ-link-V1_SF', 34, '', '', 'V1_DMZ_route_SF-CS-APPLB', '0030_0000000054', '0027_0000000003', '0026_0000000003', NULL),
	('0031_0000000055', NULL, '0031_0000000055', NULL, '2020-01-02 05:55:43', NULL, '2019-12-19 11:59:49', 'V1_MGMT_to_SF-CS-APPLB_go_V1_MGMT-link-V1_SF', 34, '', '', 'V1_MGMT_route_SF-CS-APPLB', '0030_0000000054', '0027_0000000002', '0026_0000000002', NULL),
	('0031_0000000056', NULL, '0031_0000000056', NULL, '2020-01-02 05:55:43', NULL, '2019-12-19 12:00:16', 'V1_ECN_to_SF-CS-APPLB_go_V1_ECN-link-V1_SF', 34, '', '', 'V1_ECN_route_SF-CS-APPLB', '0030_0000000054', '0027_0000000004', '0026_0000000004', NULL),
	('0031_0000000057', NULL, '0031_0000000057', NULL, '2020-01-02 05:55:42', NULL, '2019-12-19 12:02:29', 'V1_SF_to_MGMT-MT-APP_go_V1_MGMT-link-V1_SF', 34, '', '', 'V1_SF_route_MGMT-MT-APP', '0030_0000000037', '0027_0000000002', '0026_0000000001', NULL),
	('0031_0000000058', NULL, '0031_0000000058', NULL, '2020-01-02 05:55:42', NULL, '2019-12-19 12:06:57', 'V1_DMZ_to_MGMT-MT-APP_go_V1_DMZ-link-V1_MGMT', 34, '', '', 'V1_DMZ_route_MGMT-MT-APP', '0030_0000000037', '0027_0000000009', '0026_0000000003', NULL),
	('0031_0000000059', NULL, '0031_0000000059', NULL, '2020-01-02 05:55:42', NULL, '2019-12-19 12:07:18', 'V1_ECN_to_MGMT-MT-APP_go_V1_MGMT-link-V1_ECN', 34, '', '', 'V1_ECN_route_MGMT-MT-APP', '0030_0000000037', '0027_0000000008', '0026_0000000004', NULL),
	('0031_0000000061', NULL, '0031_0000000061', NULL, '2020-01-02 05:55:42', NULL, '2019-12-19 12:09:28', 'V1_SF_to_ECN-CS-APPLB_go_V1_ECN-link-V1_SF', 34, '', '', 'V1_SF_route_ECN-CS-APPLB', '0030_0000000056', '0027_0000000004', '0026_0000000001', NULL),
	('0031_0000000062', NULL, '0031_0000000062', NULL, '2020-01-02 05:55:23', NULL, '2019-12-19 12:09:41', 'V1_SF_to_DMZ-CS-APPLB_go_V1_DMZ-link-V1_SF', 34, '', '', 'V1_SF_route_DMZ-CS-APPLB', '0030_0000000055', '0027_0000000003', '0026_0000000001', NULL),
	('0031_0000000063', NULL, '0031_0000000063', NULL, '2020-01-02 05:55:23', NULL, '2019-12-19 12:12:47', 'V1_DMZ_to_WAN_go_V1_WAN-link-V1_DMZ', 34, '', '', 'V1_DMZ_route_WAN', '0030_0000000048', '0027_0000000010', '0026_0000000003', NULL),
	('0031_0000000064', NULL, '0031_0000000064', NULL, '2020-01-02 05:55:23', NULL, '2019-12-19 12:14:49', 'V1_ECN_to_PTN_go_V1_PTN-link-V1_ECN', 34, '', '', 'V1_ECN_route_PTN', '0030_0000000010', '0027_0000000007', '0026_0000000004', NULL),
	('0031_0000000065', NULL, '0031_0000000065', NULL, '2020-01-02 05:55:23', NULL, '2019-12-25 09:06:36', 'V1_MGMT_to_OPN_go_V1_OPN-link-V1_MGMT', 34, '', '', 'V1_MGMT_route_OPN', '0030_0000000009', '0027_0000000005', '0026_0000000002', NULL),
	('0031_0000000066', NULL, '0031_0000000066', NULL, '2020-01-02 05:55:22', NULL, '2019-12-25 09:09:32', 'V1_DMZ_CS_APPLB_to_SF_go_V1_DMZ-link-V1_SF', 34, '', '', 'V1_DMZ_CS_APPLB_route_SF', '0030_0000000003', '0027_0000000003', NULL, '0029_0000000035'),
	('0031_0000000067', NULL, '0031_0000000067', NULL, '2020-01-02 05:55:22', NULL, '2019-12-25 09:12:59', 'V1_ECN_CS_APPLB_to_SF_go_V1_ECN-link-V1_SF', 34, '', '', 'V1_ECN_CS_APPLB_route_SF', '0030_0000000003', '0027_0000000004', NULL, '0029_0000000036'),
	('0031_0000000068', NULL, '0031_0000000068', NULL, '2020-01-02 05:55:22', NULL, '2019-12-25 09:19:28', 'V1_DMZ_CS_APPLB_to_MGMT_go_V1_DMZ-link-V1_MGMT', 34, '', '', 'V1_DMZ_CS_APPLB_route_MGMT', '0030_0000000004', '0027_0000000009', NULL, '0029_0000000035'),
	('0031_0000000069', NULL, '0031_0000000069', NULL, '2020-01-02 05:55:22', NULL, '2019-12-25 09:20:35', 'V1_MGMT_to_DMZ-CS-APPLB_go_V1_DMZ-link-V1_MGMT', 34, '', '', 'V1_MGMT_route_DMZ-CS-APPLB', '0030_0000000055', '0027_0000000009', '0026_0000000002', NULL),
	('0031_0000000070', NULL, '0031_0000000070', NULL, '2020-01-02 05:55:21', NULL, '2019-12-25 09:28:58', 'V1_ECN_CS_APPLB_to_MGMT_go_V1_MGMT-link-V1_ECN', 34, '', '', 'V1_ECN_CS_APPLB_route_MGMT', '0030_0000000004', '0027_0000000008', NULL, '0029_0000000036'),
	('0031_0000000071', NULL, '0031_0000000071', NULL, '2020-01-02 05:55:21', NULL, '2019-12-25 09:29:21', 'V1_MGMT_to_ECN-CS-APPLB_go_V1_MGMT-link-V1_ECN', 34, '', '', 'V1_MGMT_route_ECN-CS-APPLB', '0030_0000000056', '0027_0000000008', '0026_0000000002', NULL);
/*!40000 ALTER TABLE `routing_rule_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.service_design 的数据：~7 rows (大约)
/*!40000 ALTER TABLE `service_design` DISABLE KEYS */;
INSERT INTO `service_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `name`, `service_type`, `unit_design`, `service_invoke_type`, `service_nature`) VALUES
	('0004_0000000010', NULL, '0004_0000000010', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:34:09', 'DMCS_CORE_APP_S100001_余额查询_直连访问', 34, '2020-01-03 04:05:07', '', 'S100001', '余额查询', 83, '0003_0000000012', 362, 365),
	('0004_0000000011', NULL, '0004_0000000011', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:34:49', 'DMCS_CORE_APP_S200001_开户交易_直连访问', 34, '2020-01-03 04:05:07', '', 'S200001', '开户交易', 83, '0003_0000000012', 362, 366),
	('0004_0000000012', NULL, '0004_0000000012', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:46:34', 'DMCS_CORE_APP_S200002_调整处理_RMB总线', 34, '2020-01-03 04:05:07', '', 'S200002', '调整处理', 82, '0003_0000000012', 362, 366),
	('0004_0000000013', NULL, '0004_0000000013', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:48:15', 'DMCS_ADM_APP_S300002_调整处理_直连访问', 34, '2020-01-03 04:05:07', '', 'S300002', '调整处理', 83, '0003_0000000016', 362, 366),
	('0004_0000000014', NULL, '0004_0000000014', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:49:27', 'DMCS_ADM_APP_S400001_余额查询_直连访问', 34, '2020-01-03 04:05:07', '', 'S400001', '余额查询', 83, '0003_0000000016', 362, 365),
	('0004_0000000015', NULL, '0004_0000000015', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:50:00', 'DMCS_CORE_APP_S100002_余额查询_RMB总线', 34, '2020-01-03 04:05:07', '', 'S100002', '余额查询', 82, '0003_0000000012', 362, 365),
	('0004_0000000016', NULL, '0004_0000000016', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:50:49', 'DMCS_PROXY_NGINX_S500001_余额查询_直连访问', 34, '2020-01-03 04:05:07', '', 'S500001', '余额查询', 83, '0003_0000000025', 362, 365);
/*!40000 ALTER TABLE `service_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.service_invoke_design 的数据：~6 rows (大约)
/*!40000 ALTER TABLE `service_invoke_design` DISABLE KEYS */;
INSERT INTO `service_invoke_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `invoked_unit_design`, `invoke_unit_design`, `service_design`) VALUES
	('0035_0000000001', NULL, '0035_0000000001', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:43:57', 'DMCS_ADM_APP---DMCS_CORE_APP_S100002_余额查询_RMB总线', 34, '2020-01-03 04:05:07', '', '22', '0003_0000000012', '0003_0000000016', '0004_0000000015'),
	('0035_0000000002', NULL, '0035_0000000002', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:46:07', 'DMCS_ADM_APP---DMCS_CORE_APP_S200002_调整处理_RMB总线', 34, '2020-01-03 04:05:07', '', '23', '0003_0000000012', '0003_0000000016', '0004_0000000012'),
	('0035_0000000003', NULL, '0035_0000000003', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:55:18', 'DMCS_MC_BROWER---DMCS_ADM_APP_S400001_余额查询_直连访问', 34, '2020-01-03 04:05:07', '', '33', '0003_0000000016', '0003_0000000026', '0004_0000000014'),
	('0035_0000000004', NULL, '0035_0000000004', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:55:44', 'DMCS_PROXY_NGINX---DMCS_CORE_APP_S100001_余额查询_直连访问', 34, '2020-01-03 04:05:07', '', '33', '0003_0000000012', '0003_0000000025', '0004_0000000010'),
	('0035_0000000005', NULL, '0035_0000000005', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:55:57', 'DMCS_APIC_APIWEB---DMCS_PROXY_NGINX_S500001_余额查询_直连访问', 34, '2020-01-03 04:05:07', '', '33', '0003_0000000025', '0003_0000000028', '0004_0000000016'),
	('0035_0000000006', NULL, '0035_0000000006', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:56:24', 'DMCS_MC_BROWER---DMCS_ADM_APP_S300002_调整处理_直连访问', 34, '2020-01-03 04:05:07', '', '33', '0003_0000000016', '0003_0000000026', '0004_0000000013');
/*!40000 ALTER TABLE `service_invoke_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.service_invoke_seq_design 的数据：~2 rows (大约)
/*!40000 ALTER TABLE `service_invoke_seq_design` DISABLE KEYS */;
INSERT INTO `service_invoke_seq_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `name`, `system_design`) VALUES
	('0006_0000000001', NULL, '0006_0000000001', NULL, '2019-12-24 11:03:16', NULL, '2019-12-21 13:46:45', 'DMCS_seq_QUERY', 34, '', '', 'QUERY', '管理台账户余额查询', '0001_0000000001'),
	('0006_0000000002', NULL, '0006_0000000002', NULL, '2019-12-24 11:03:58', NULL, '2019-12-24 11:03:58', 'DMCS_seq_QUERY2', 34, '', '', 'QUERY2', 'WEB API账户余额查询', '0001_0000000001');
/*!40000 ALTER TABLE `service_invoke_seq_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.service_invoke_seq_design$service_invoke_design_sequence 的数据：~4 rows (大约)
/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` DISABLE KEYS */;
INSERT INTO `service_invoke_seq_design$service_invoke_design_sequence` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(3, '0006_0000000001', '0035_0000000006', 1),
	(4, '0006_0000000001', '0035_0000000002', 2),
	(5, '0006_0000000002', '0035_0000000005', 1),
	(6, '0006_0000000002', '0035_0000000004', 2);
/*!40000 ALTER TABLE `service_invoke_seq_design$service_invoke_design_sequence` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.subsys 的数据：~7 rows (大约)
/*!40000 ALTER TABLE `subsys` DISABLE KEYS */;
INSERT INTO `subsys` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `manager`, `subsys_design`, `system`) VALUES
	('0008_0000000006', NULL, '0008_0000000006', NULL, '2019-12-25 01:35:34', NULL, '2019-12-21 13:51:32', 'DMCS_PRD_CORE', 37, '', '', 'CORE', 'liuchao', '0002_0000000009', '0007_0000000001'),
	('0008_0000000007', NULL, '0008_0000000007', NULL, '2019-12-24 09:35:32', NULL, '2019-12-21 13:52:47', 'DMCS_PRD_ADM', 37, '', '', 'ADM', 'liuchao', '0002_0000000010', '0007_0000000001'),
	('0008_0000000008', NULL, '0008_0000000008', NULL, '2019-12-24 03:56:38', NULL, '2019-12-24 03:56:38', 'WECUBE_PRD_CLIENT', 37, '', '', 'CLIENT', '', '0002_0000000012', '0007_0000000003'),
	('0008_0000000009', NULL, '0008_0000000009', NULL, '2019-12-24 03:56:51', NULL, '2019-12-24 03:56:51', 'WECUBE_PRD_CORE', 37, '', '', 'CORE', '', '0002_0000000011', '0007_0000000003'),
	('0008_0000000010', NULL, '0008_0000000010', NULL, '2019-12-24 12:33:01', NULL, '2019-12-24 12:32:00', 'DMCS_PRD_PROXY', 37, '', '', 'PROXY', '', '0002_0000000015', '0007_0000000001'),
	('0008_0000000011', NULL, '0008_0000000011', NULL, '2019-12-24 12:33:12', NULL, '2019-12-24 12:33:12', 'DMCS_PRD_APIC', 37, '', '', 'APIC', '', '0002_0000000016', '0007_0000000001'),
	('0008_0000000012', NULL, '0008_0000000012', NULL, '2019-12-24 12:33:23', NULL, '2019-12-24 12:33:23', 'DMCS_PRD_MC', 37, '', '', 'MC', '', '0002_0000000014', '0007_0000000001'),
	('0008_0000000013', NULL, '0008_0000000013', NULL, '2020-01-08 10:24:12', NULL, '2019-12-31 06:34:00', 'PRD_DEMO2_CORE', 37, '2019-12-31 06:35:20', '', 'CORE', '', '0002_0000000017', '0007_0000000002');
/*!40000 ALTER TABLE `subsys` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.subsys$business_zone 的数据：~13 rows (大约)
/*!40000 ALTER TABLE `subsys$business_zone` DISABLE KEYS */;
INSERT INTO `subsys$business_zone` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(10, '0008_0000000007', '0021_0000000003', 2),
	(11, '0008_0000000007', '0021_0000000001', 1),
	(12, '0008_0000000008', '0021_0000000011', 1),
	(13, '0008_0000000009', '0021_0000000021', 2),
	(14, '0008_0000000009', '0021_0000000008', 1),
	(16, '0008_0000000010', '0021_0000000010', 2),
	(17, '0008_0000000010', '0021_0000000004', 1),
	(18, '0008_0000000011', '0021_0000000010', 1),
	(19, '0008_0000000012', '0021_0000000009', 1),
	(20, '0008_0000000006', '0021_0000000001', 1),
	(21, '0008_0000000006', '0021_0000000003', 2),
	(23, '0008_0000000013', '0021_0000000001', 1),
	(24, '0008_0000000013', '0021_0000000003', 2);
/*!40000 ALTER TABLE `subsys$business_zone` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.subsys_design 的数据：~10 rows (大约)
/*!40000 ALTER TABLE `subsys_design` DISABLE KEYS */;
INSERT INTO `subsys_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `system_design`, `business_group`, `name`, `subsys_design_id`) VALUES
	('0002_0000000009', NULL, '0002_0000000009', NULL, '2020-01-03 04:15:58', NULL, '2019-12-21 13:21:32', 'DMCS_CORE', 34, '2020-01-03 04:05:07', '', 'CORE', '0001_0000000001', 58, '核心子系统', NULL),
	('0002_0000000010', NULL, '0002_0000000010', NULL, '2020-01-03 04:15:58', NULL, '2019-12-21 13:35:44', 'DMCS_ADM', 34, '2020-01-03 04:05:07', '', 'ADM', '0001_0000000001', 58, '后台管理子系统', NULL),
	('0002_0000000011', NULL, '0002_0000000011', NULL, '2020-01-03 02:29:01', NULL, '2019-12-22 12:01:17', 'WECUBE_CORE', 34, '', '', 'CORE', '0001_0000000003', 254, '核心子系统', NULL),
	('0002_0000000012', NULL, '0002_0000000012', NULL, '2020-01-03 02:29:01', NULL, '2019-12-22 12:03:37', 'WECUBE_CLIENT', 34, '', '', 'CLIENT', '0001_0000000003', 254, 'WEB客户端', NULL),
	('0002_0000000014', NULL, '0002_0000000014', NULL, '2020-01-03 04:15:58', NULL, '2019-12-24 09:44:56', 'DMCS_MC', 34, '2020-01-03 04:05:07', '', 'MC', '0001_0000000001', 58, '管理客户端子系统', NULL),
	('0002_0000000015', NULL, '0002_0000000015', NULL, '2020-01-03 04:15:58', NULL, '2019-12-24 09:45:37', 'DMCS_PROXY', 34, '2020-01-03 04:05:07', '', 'PROXY', '0001_0000000001', 58, '代理子系统', NULL),
	('0002_0000000016', NULL, '0002_0000000016', NULL, '2020-01-03 04:15:58', NULL, '2019-12-24 09:46:50', 'DMCS_APIC', 34, '2020-01-03 04:05:07', '', 'APIC', '0001_0000000001', 58, 'API客户端', NULL),
	('0002_0000000017', '0002_0000000021', '0002_0000000017', NULL, '2020-01-08 10:24:26', NULL, '2019-12-31 03:34:45', 'DEMO2_CORE', 35, NULL, '', 'CORE', '0001_0000000002', 59, '演示核心子系统', '234563'),
	('0002_0000000018', NULL, '0002_0000000017', NULL, '2019-12-31 03:50:59', NULL, '2019-12-31 03:34:45', 'DEMO2_CORE', 34, '2019-12-31 03:34:48', '', 'CORE', '0001_0000000002', 59, '演示核心子系统', NULL),
	('0002_0000000019', NULL, '0002_0000000019', 'mockadmin', '2020-01-10 07:15:08', NULL, '2020-01-03 04:13:33', 'DMCS_BATCH', 34, '2020-01-10 07:15:08', '', 'BATCH', '0001_0000000001', 58, '批量子系统', NULL),
	('0002_0000000020', NULL, '0002_0000000020', 'mockadmin', '2020-01-10 07:15:08', NULL, '2020-01-07 09:59:41', 'DMCS_GL', 34, '2020-01-10 07:15:08', '', 'GL', '0001_0000000001', 58, '小总账', '122334'),
	('0002_0000000021', '0002_0000000018', '0002_0000000017', NULL, '2020-01-08 08:28:13', NULL, '2019-12-31 03:34:45', 'DEMO2_CORE', 35, '2019-12-31 06:35:02', '', 'CORE', '0001_0000000002', 59, '演示核心子系统', NULL);
/*!40000 ALTER TABLE `subsys_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.subsys_design$business_zone_design 的数据：~18 rows (大约)
/*!40000 ALTER TABLE `subsys_design$business_zone_design` DISABLE KEYS */;
INSERT INTO `subsys_design$business_zone_design` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0002_0000000009', '0028_0000000001', 1),
	(2, '0002_0000000009', '0028_0000000004', 2),
	(5, '0002_0000000011', '0028_0000000015', 2),
	(6, '0002_0000000011', '0028_0000000005', 1),
	(9, '0002_0000000012', '0028_0000000012', 1),
	(10, '0002_0000000010', '0028_0000000004', 2),
	(11, '0002_0000000010', '0028_0000000001', 1),
	(18, '0002_0000000015', '0028_0000000010', 2),
	(19, '0002_0000000015', '0028_0000000003', 1),
	(22, '0002_0000000016', '0028_0000000010', 1),
	(23, '0002_0000000014', '0028_0000000013', 1),
	(25, '0002_0000000018', '0028_0000000001', 0),
	(28, '0002_0000000019', '0028_0000000001', 1),
	(29, '0002_0000000019', '0028_0000000004', 2),
	(30, '0002_0000000020', '0028_0000000004', 1),
	(31, '0002_0000000021', '0028_0000000001', 0),
	(32, '0002_0000000021', '0028_0000000004', 0),
	(35, '0002_0000000017', '0028_0000000004', 1),
	(36, '0002_0000000017', '0028_0000000001', 2);
/*!40000 ALTER TABLE `subsys_design$business_zone_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.system 的数据：~3 rows (大约)
/*!40000 ALTER TABLE `system` DISABLE KEYS */;
INSERT INTO `system` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `deploy_environment`, `system_design`, `region_data_center`) VALUES
	('0007_0000000001', NULL, '0007_0000000001', NULL, '2020-01-03 04:15:58', NULL, '2019-12-18 05:23:39', 'DMCS_PRD', 37, '', '', 'DMCS_PRD', 69, '0001_0000000001', NULL),
	('0007_0000000002', NULL, '0007_0000000002', NULL, '2020-01-08 10:24:26', NULL, '2019-12-18 05:24:51', 'PRD_DEMO2', 37, '', '', 'DEMO2_PRD', 69, '0001_0000000002', NULL),
	('0007_0000000003', NULL, '0007_0000000003', 'admin', '2020-01-03 04:26:02', NULL, '2019-12-24 03:52:50', 'WECUBE_PRD', 37, '2020-01-03 12:26:02', '', 'WECUBE_PRD', 69, '0001_0000000003', NULL);
/*!40000 ALTER TABLE `system` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.system$data_center 的数据：~7 rows (大约)
/*!40000 ALTER TABLE `system$data_center` DISABLE KEYS */;
INSERT INTO `system$data_center` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(1, '0007_0000000002', '0018_0000000001', 2),
	(2, '0007_0000000002', '0018_0000000003', 1),
	(3, '0007_0000000002', '0018_0000000002', 3),
	(9, '0007_0000000003', '0018_0000000001', 1),
	(13, '0007_0000000001', '0018_0000000001', 1),
	(14, '0007_0000000001', '0018_0000000002', 2),
	(15, '0007_0000000001', '0018_0000000003', 3);
/*!40000 ALTER TABLE `system$data_center` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.system_design 的数据：~7 rows (大约)
/*!40000 ALTER TABLE `system_design` DISABLE KEYS */;
INSERT INTO `system_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `business_group`, `name`, `data_center_design`, `system_design_id`) VALUES
	('0001_0000000001', '0001_0000000007', '0001_0000000001', 'mockadmin', '2020-01-15 03:46:17', NULL, '2019-12-18 01:53:23', 'DMCS', 35, '2020-01-10 07:15:08', '2', 'DMCS', 58, '存款微核心系统', '0025_0000000001', NULL),
	('0001_0000000002', '0001_0000000006', '0001_0000000002', 'mockadmin', '2020-01-10 07:05:16', NULL, '2019-12-18 03:38:08', 'DEMO2', 35, '2020-01-10 04:51:29', '', 'DEMO2', 59, '演示系统2', '0025_0000000001', '123457'),
	('0001_0000000003', NULL, '0001_0000000003', NULL, '2020-01-03 02:29:01', NULL, '2019-12-22 12:00:06', 'WECUBE', 34, '', '', 'WECUBE', 254, 'WeCube', '0025_0000000001', NULL),
	('0001_0000000004', NULL, '0001_0000000004', NULL, '2020-01-03 02:29:01', NULL, '2019-12-26 14:39:41', 'YYYY', 34, '', '', 'YYYY', 58, 'YYYYT', '0025_0000000001', NULL),
	('0001_0000000005', NULL, '0001_0000000002', NULL, '2020-01-03 03:04:43', NULL, '2019-12-18 03:38:08', NULL, 34, '2019-12-31 03:35:35', '', 'DEMO2', 59, '演示系统2', '0025_0000000001', NULL),
	('0001_0000000006', '0001_0000000005', '0001_0000000002', NULL, '2020-01-03 02:43:09', NULL, '2019-12-18 03:38:08', NULL, 35, '2019-12-31 03:51:02', '', 'DEMO2', 59, '演示系统2', '0025_0000000001', NULL),
	('0001_0000000007', NULL, '0001_0000000001', 'mockadmin', '2020-01-15 03:55:21', NULL, '2019-12-18 01:53:23', NULL, 34, '2020-01-03 04:05:07', '1', 'DMCS', 58, '存款微核心系统', '0025_0000000001', NULL);
/*!40000 ALTER TABLE `system_design` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.unit 的数据：~18 rows (大约)
/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
INSERT INTO `unit` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `manager`, `subsys`, `unit_design`, `port`, `monitor_port`, `security_group_asset_code`, `public_key`, `deploy_path`) VALUES
	('0009_0000000008', NULL, '0009_0000000008', NULL, '2019-12-25 02:29:53', NULL, '2019-12-21 13:59:08', 'DMCS_PRD_ADM_APP', 37, '', '', 'APP', '', '0008_0000000007', '0003_0000000016', '10000', '20000', '', NULL, NULL),
	('0009_0000000009', NULL, '0009_0000000009', NULL, '2019-12-25 02:29:53', NULL, '2019-12-24 03:57:44', 'WECUBE_PRD_CORE_APP', 37, '', '', 'APP', '', '0008_0000000009', '0003_0000000020', '8080', '20008', '', NULL, NULL),
	('0009_0000000014', NULL, '0009_0000000014', NULL, '2019-12-25 02:29:53', NULL, '2019-12-24 07:25:41', 'WECUBE_PRD_CORE_DB', 37, '', '', 'DB', '', '0008_0000000009', '0003_0000000021', '3306', '20008', '', NULL, NULL),
	('0009_0000000018', NULL, '0009_0000000018', NULL, '2019-12-25 02:29:53', NULL, '2019-12-25 01:37:03', 'DMCS_PRD_CORE_APP', 37, '', '', 'APP', '', '0008_0000000006', '0003_0000000012', '10001', '20001', '', NULL, NULL),
	('0009_0000000019', NULL, '0009_0000000019', NULL, '2019-12-25 02:29:53', NULL, '2019-12-25 01:38:50', 'DMCS_PRD_CORE_DB', 37, '', '', 'DB', '', '0008_0000000006', '0003_0000000015', '13306', '13306', '', NULL, NULL),
	('0009_0000000020', NULL, '0009_0000000020', NULL, '2019-12-25 02:29:53', NULL, '2019-12-25 01:40:00', 'DMCS_PRD_ADM_DB', 37, '', '', 'DB', '', '0008_0000000007', '0003_0000000018', '13307', '13307', '', NULL, NULL),
	('0009_0000000021', NULL, '0009_0000000021', NULL, '2019-12-25 02:29:53', NULL, '2019-12-25 01:41:25', 'DMCS_PRD_PROXY_NGINX', 37, '', '', 'NGINX', '', '0008_0000000010', '0003_0000000025', '10000', '10000', '', NULL, NULL),
	('0009_0000000027', NULL, '0009_0000000027', NULL, '2019-12-25 11:12:26', NULL, '2019-12-25 11:12:26', 'DMCS_PRD_CORE_ALB', 37, '', '', 'ALB', '', '0008_0000000006', '0003_0000000013', '10000', '10000', '', NULL, NULL),
	('0009_0000000028', NULL, '0009_0000000028', NULL, '2019-12-25 11:15:07', NULL, '2019-12-25 11:15:07', 'DMCS_PRD_MC_BROWER', 37, '', '', 'BROWER', '', '0008_0000000012', '0003_0000000026', '1000', '100', '', NULL, NULL),
	('0009_0000000029', NULL, '0009_0000000029', NULL, '2019-12-26 10:46:39', NULL, '2019-12-26 10:46:39', 'DMCS_PRD_CORE_DLB', 37, '', '', 'DLB', '', '0008_0000000006', '0003_0000000014', '13308', '3306', '', NULL, NULL),
	('0009_0000000030', NULL, '0009_0000000030', NULL, '2019-12-26 10:47:24', NULL, '2019-12-26 10:47:24', 'DMCS_PRD_ADM_ALB', 37, '', '', 'ALB', '', '0008_0000000007', '0003_0000000017', '80', '80', '', NULL, NULL),
	('0009_0000000031', NULL, '0009_0000000031', NULL, '2019-12-26 10:48:14', NULL, '2019-12-26 10:48:14', 'DMCS_PRD_ADM_DLB', 37, '', '', 'DLB', '', '0008_0000000007', '0003_0000000019', '13309', '13309', '', NULL, NULL),
	('0009_0000000032', NULL, '0009_0000000032', NULL, '2019-12-26 10:50:27', NULL, '2019-12-26 10:50:27', 'DMCS_PRD_APIC_APIWEB', 37, '', '', 'APIWEB', '', '0008_0000000011', '0003_0000000028', '0', '0', '', NULL, NULL),
	('0009_0000000033', NULL, '0009_0000000033', NULL, '2019-12-26 13:06:28', NULL, '2019-12-26 10:51:15', 'DMCS_PRD_PROXY_WANLB', 37, '', '', 'WANLB', '', '0008_0000000010', '0003_0000000027', '80', '80', '', NULL, NULL),
	('0009_0000000034', NULL, '0009_0000000034', NULL, '2020-01-08 08:23:43', NULL, '2019-12-31 08:04:27', 'DEMO2_PRD_CORE_APP', 37, '', '', 'APP', '', '0008_0000000013', '0003_0000000029', '8080', '8080', '', '', '/data/DEMO2_PRD_CORE_APP/'),
	('0009_0000000035', NULL, '0009_0000000035', NULL, '2020-01-06 02:59:34', NULL, '2019-12-31 08:06:27', 'DEMO2_PRD_CORE_DB', 37, '', '', 'DB', '', '0008_0000000013', '0003_0000000030', '3306', '3306', '', '', NULL),
	('0009_0000000036', NULL, '0009_0000000036', NULL, '2020-01-06 02:59:34', NULL, '2019-12-31 08:14:53', 'DEMO2_PRD_CORE_DLB', 37, '', '', 'DLB', '', '0008_0000000013', '0003_0000000031', '13310', '13310', '', '', NULL),
	('0009_0000000037', NULL, '0009_0000000037', NULL, '2020-01-06 04:30:09', NULL, '2020-01-06 04:30:09', 'DEMO2_PRD_CORE_ALB', 37, '', '', 'ALB', '', '0008_0000000013', '0003_0000000035', '8080', '8080', '', '', NULL);
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.unit$deploy_package 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `unit$deploy_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `unit$deploy_package` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.unit$resource_set 的数据：~21 rows (大约)
/*!40000 ALTER TABLE `unit$resource_set` DISABLE KEYS */;
INSERT INTO `unit$resource_set` (`id`, `from_guid`, `to_guid`, `seq_no`) VALUES
	(49, '0009_0000000021', '0022_0000000012', 1),
	(50, '0009_0000000020', '0022_0000000003', 1),
	(51, '0009_0000000019', '0022_0000000003', 1),
	(52, '0009_0000000018', '0022_0000000001', 1),
	(53, '0009_0000000014', '0022_0000000021', 1),
	(54, '0009_0000000009', '0022_0000000019', 1),
	(55, '0009_0000000008', '0022_0000000001', 1),
	(58, '0009_0000000027', '0022_0000000064', 1),
	(59, '0009_0000000028', '0022_0000000025', 1),
	(60, '0009_0000000029', '0022_0000000051', 1),
	(61, '0009_0000000030', '0022_0000000064', 1),
	(62, '0009_0000000031', '0022_0000000051', 1),
	(63, '0009_0000000032', '0022_0000000023', 1),
	(65, '0009_0000000033', '0022_0000000062', 1),
	(72, '0009_0000000036', '0022_0000000051', 1),
	(73, '0009_0000000036', '0022_0000000059', 2),
	(74, '0009_0000000035', '0022_0000000035', 2),
	(75, '0009_0000000035', '0022_0000000009', 1),
	(78, '0009_0000000037', '0022_0000000064', 1),
	(85, '0009_0000000034', '0022_0000000007', 1),
	(86, '0009_0000000034', '0022_0000000033', 2);
/*!40000 ALTER TABLE `unit$resource_set` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.unit$unit_type 的数据：~33 rows (大约)
/*!40000 ALTER TABLE `unit$unit_type` DISABLE KEYS */;
INSERT INTO `unit$unit_type` (`id`, `from_guid`, `to_code`, `seq_no`) VALUES
	(9, '0009_0000000006', 66, 1),
	(10, '0009_0000000005', 281, 1),
	(11, '0009_0000000004', 64, 1),
	(12, '0009_0000000003', 281, 1),
	(13, '0009_0000000002', 258, 1),
	(14, '0009_0000000001', 64, 1),
	(15, '0009_0000000007', 66, 1),
	(19, '0009_0000000010', 340, 1),
	(20, '0009_0000000011', 340, 1),
	(21, '0009_0000000012', 340, 1),
	(22, '0009_0000000013', 340, 1),
	(24, '0009_0000000015', 340, 1),
	(26, '0009_0000000016', 340, 1),
	(28, '0009_0000000017', 340, 1),
	(37, '0009_0000000022', 349, 1),
	(45, '0009_0000000021', 258, 1),
	(46, '0009_0000000020', 66, 1),
	(47, '0009_0000000019', 66, 1),
	(48, '0009_0000000018', 64, 1),
	(49, '0009_0000000014', 66, 1),
	(50, '0009_0000000009', 64, 1),
	(51, '0009_0000000008', 64, 1),
	(55, '0009_0000000027', 340, 1),
	(56, '0009_0000000028', 326, 1),
	(57, '0009_0000000029', 341, 1),
	(58, '0009_0000000030', 340, 1),
	(59, '0009_0000000031', 341, 1),
	(60, '0009_0000000032', 326, 1),
	(62, '0009_0000000033', 349, 1),
	(68, '0009_0000000036', 341, 1),
	(69, '0009_0000000035', 66, 1),
	(71, '0009_0000000037', 340, 1),
	(75, '0009_0000000034', 63, 1);
/*!40000 ALTER TABLE `unit$unit_type` ENABLE KEYS */;

-- 正在导出表  wecmdb_embedded.unit_design 的数据：~21 rows (大约)
/*!40000 ALTER TABLE `unit_design` DISABLE KEYS */;
INSERT INTO `unit_design` (`guid`, `p_guid`, `r_guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `key_name`, `state`, `fixed_date`, `description`, `code`, `across_resource_set`, `name`, `resource_set_design`, `subsys_design`, `unit_design_type`, `protocol`) VALUES
	('0003_0000000012', NULL, '0003_0000000012', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:23:25', 'DMCS_CORE_APP', 34, '2020-01-03 04:05:07', '', 'APP', 104, '核心应用', '0029_0000000001', '0002_0000000009', 60, 361),
	('0003_0000000013', NULL, '0003_0000000013', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:24:07', 'DMCS_CORE_ALB', 34, '2020-01-03 04:05:07', '', 'ALB', 104, '应用负载均衡', '0029_0000000031', '0002_0000000009', 338, 361),
	('0003_0000000014', NULL, '0003_0000000014', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:24:34', 'DMCS_CORE_DLB', 34, '2020-01-03 04:05:07', '', 'DLB', 104, '数据库负载均衡', '0029_0000000034', '0002_0000000009', 339, 361),
	('0003_0000000015', NULL, '0003_0000000015', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:25:06', 'DMCS_CORE_DB', 34, '2020-01-03 04:05:07', '', 'DB', 104, '核心数据库', '0029_0000000004', '0002_0000000009', 61, 361),
	('0003_0000000016', NULL, '0003_0000000016', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:36:18', 'DMCS_ADM_APP', 34, '2020-01-03 04:05:07', '', 'APP', 104, '管理台应用', '0029_0000000001', '0002_0000000010', 60, 361),
	('0003_0000000017', NULL, '0003_0000000017', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:36:59', 'DMCS_ADM_ALB', 34, '2020-01-03 04:05:07', '', 'ALB', 104, '管理台负载均衡', '0029_0000000031', '0002_0000000010', 338, 361),
	('0003_0000000018', NULL, '0003_0000000018', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:37:23', 'DMCS_ADM_DB', 34, '2020-01-03 04:05:07', '', 'DB', 104, '管理台数据库', '0029_0000000004', '0002_0000000010', 61, 361),
	('0003_0000000019', NULL, '0003_0000000019', NULL, '2020-01-03 04:05:07', NULL, '2019-12-21 13:38:07', 'DMCS_ADM_DLB', 34, '2020-01-03 04:05:07', '', 'DLB', 104, 'ADM', '0029_0000000034', '0002_0000000010', 339, 361),
	('0003_0000000020', NULL, '0003_0000000020', NULL, '2019-12-24 07:23:43', NULL, '2019-12-24 03:43:53', 'WECUBE_CORE_APP', 34, '', '', 'APP', 104, '核心应用', '0029_0000000020', '0002_0000000011', 60, 361),
	('0003_0000000021', NULL, '0003_0000000021', NULL, '2019-12-24 07:23:43', NULL, '2019-12-24 03:44:35', 'WECUBE_CORE_DB', 34, '', '', 'DB', 104, '核心数据库', '0029_0000000022', '0002_0000000011', 61, 361),
	('0003_0000000022', NULL, '0003_0000000022', NULL, '2019-12-24 07:23:43', NULL, '2019-12-24 03:46:43', 'WECUBE_CORE_APPLB', 34, '', '', 'APPLB', 104, '应用负载均衡', '0029_0000000032', '0002_0000000011', 338, 361),
	('0003_0000000023', NULL, '0003_0000000023', NULL, '2019-12-24 07:23:43', NULL, '2019-12-24 03:47:19', 'WECUBE_CORE_DBLB', 34, '', '', 'DBLB', 104, '数据库负载均衡', '0029_0000000033', '0002_0000000011', 339, 361),
	('0003_0000000024', NULL, '0003_0000000024', NULL, '2019-12-24 07:23:43', NULL, '2019-12-24 03:50:35', 'WECUBE_CLIENT_BROWER', 34, '', '', 'BROWER', 104, 'WEB客户端', '0029_0000000029', '0002_0000000012', 325, 361),
	('0003_0000000025', NULL, '0003_0000000025', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:48:46', 'DMCS_PROXY_NGINX', 34, '2020-01-03 04:05:07', '', 'NGINX', 104, '正向代理模块', '0029_0000000012', '0002_0000000015', 257, 361),
	('0003_0000000026', NULL, '0003_0000000026', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 09:49:41', 'DMCS_MC_BROWER', 34, '2020-01-03 04:05:07', '', 'BROWER', 103, '管理WEB', '0029_0000000024', '0002_0000000014', 325, 361),
	('0003_0000000027', NULL, '0003_0000000027', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:34:11', 'DMCS_PROXY_WANLB', 34, '2020-01-03 04:05:07', '', 'WANLB', 104, '负载均衡', '0029_0000000037', '0002_0000000015', 348, 361),
	('0003_0000000028', NULL, '0003_0000000028', NULL, '2020-01-03 04:05:07', NULL, '2019-12-24 10:44:24', 'DMCS_APIC_APIWEB', 34, '2020-01-03 04:05:07', '', 'APIWEB', 103, 'APIWEB客户端', '0029_0000000028', '0002_0000000016', 325, 361),
	('0003_0000000029', '0003_0000000033', '0003_0000000029', NULL, '2020-01-03 04:52:39', NULL, '2019-12-31 03:37:35', 'DEMO2_CORE_APP', 35, NULL, '', 'APP', 104, '演示业务应用', '0029_0000000008', '0002_0000000017', 60, 361),
	('0003_0000000030', '0003_0000000034', '0003_0000000030', NULL, '2020-01-06 02:58:14', NULL, '2019-12-31 03:38:11', 'DEMO2_CORE_DB', 35, NULL, '', 'DB', 104, '演示业务数据库', '0029_0000000010', '0002_0000000017', 61, 361),
	('0003_0000000031', NULL, '0003_0000000031', NULL, '2020-01-06 02:58:14', NULL, '2019-12-31 08:12:38', 'DEMO2_CORE_DBLB', 34, '', '', 'DBLB', 104, '演示业务数据库负载均衡', '0029_0000000034', '0002_0000000017', 339, 361),
	('0003_0000000032', NULL, '0003_0000000032', 'mockadmin', '2020-01-10 07:15:08', NULL, '2020-01-03 04:17:51', 'DMCS_BATCH_APP', 34, '2020-01-10 07:15:08', '', 'APP', 104, '跑批单元', '0029_0000000001', '0002_0000000019', 60, 361),
	('0003_0000000033', NULL, '0003_0000000029', NULL, '2019-12-31 03:37:38', NULL, '2019-12-31 03:37:35', 'DEMO2_CORE_APP', 34, '2019-12-31 03:37:37', '', 'APP', 104, '演示业务应用', '0029_0000000001', '0002_0000000017', 60, 361),
	('0003_0000000034', NULL, '0003_0000000030', NULL, '2019-12-31 03:38:13', NULL, '2019-12-31 03:38:11', 'DEMO2_CORE_DB', 34, '2019-12-31 03:38:13', '', 'DB', 104, '演示业务数据库', '0029_0000000004', '0002_0000000017', 61, 361),
	('0003_0000000035', NULL, '0003_0000000035', NULL, '2020-01-06 04:28:13', NULL, '2020-01-06 04:28:13', 'DEMO2_CORE_ALB', 34, '', '', 'ALB', 104, 'APP负载均衡', '0029_0000000031', '0002_0000000017', 338, 361);
/*!40000 ALTER TABLE `unit_design` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
SET FOREIGN_KEY_CHECKS=1;
