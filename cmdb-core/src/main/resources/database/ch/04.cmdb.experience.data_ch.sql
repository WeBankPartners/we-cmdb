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
	
	
-- ----------------------------
-- Table structure for application_domain
-- ----------------------------
-- ----------------------------
-- Records of application_domain
-- ----------------------------
INSERT INTO `application_domain` VALUES ('0005_0000000001', null, '0005_0000000001', 'umadmin', '2020-03-21 15:54:41', 'umadmin', '2020-03-21 14:51:07', '34', 'CKY|存款业务域', '', 'CKY', '', '存款业务域', null);
INSERT INTO `application_domain` VALUES ('0005_0000000002', null, '0005_0000000002', 'umadmin', '2020-03-21 15:54:41', 'umadmin', '2020-03-21 14:51:26', '34', 'DKY|贷款业务域', '', 'DKY', '', '贷款业务域', null);
INSERT INTO `application_domain` VALUES ('0005_0000000003', null, '0005_0000000003', 'umadmin', '2020-03-21 15:53:58', 'umadmin', '2020-03-21 14:51:51', '34', 'CSY|公共服务域', '', 'CSY', '', '公共服务域', null);
INSERT INTO `application_domain` VALUES ('0005_0000000004', null, '0005_0000000004', 'umadmin', '2020-03-21 14:53:45', 'umadmin', '2020-03-21 14:53:44', '34', 'MTY|管理工具域', '', 'MTY', '', '管理工具域', null);
INSERT INTO `application_domain` VALUES ('0005_0000000005', null, '0005_0000000005', 'umadmin', '2020-03-21 15:54:22', 'umadmin', '2020-03-21 15:54:22', '34', 'PCY|桌面服务域', '', 'PCY', '', '桌面服务域', null);

-- ----------------------------
-- Records of app_instance
-- ----------------------------
INSERT INTO `app_instance` VALUES ('0050_0000000001', null, '0050_0000000001', 'SYS_PLATFORM', '2020-03-24 06:30:35', 'umadmin', '2020-03-22 08:38:38', '40', 'PRD_DEMO_CORE_APP1_10.128.33.17:18080', '', '10.128.33.17:18080', '', '1', '', '', '', 'DEMO_CORE', 'Abcd1234', '0032_0000000001', '2', '10.128.33.17:28080', '28080', '18080', '10.128.33.17:18080', '', 'created', '', '10', '0048_0000000002', '=');
INSERT INTO `app_instance` VALUES ('0050_0000000002', null, '0050_0000000002', 'SYS_PLATFORM', '2020-03-24 06:30:36', 'umadmin', '2020-03-22 08:47:56', '40', 'PRD_DEMO_CORE_APP1_10.128.33.10:18080', '', '10.128.33.10:18080', '', '1', '', '', '', 'DEMO_CORE', 'Abcd1234', '0032_0000000002', '2', '10.128.33.10:28080', '28080', '18080', '10.128.33.10:18080', '', 'created', '', '10', '0048_0000000002', '=');

-- ----------------------------
-- Records of app_system
-- ----------------------------
INSERT INTO `app_system` VALUES ('0046_0000000001', null, '0046_0000000001', 'umadmin', '2020-03-27 04:09:00', 'umadmin', '2020-03-22 07:39:33', '37', 'PRD_DEMO', '2020-03-27 04:08:59', 'DEMO', '', '0003_0000000001', '0004_0000000001', 'created', '0037_0000000001');

-- ----------------------------
-- Records of app_system$data_center
-- ----------------------------
INSERT INTO `app_system$data_center` VALUES ('1', '0046_0000000001', '0022_0000000002', '1');

-- ----------------------------
-- Records of app_system_design
-- ----------------------------
INSERT INTO `app_system_design` VALUES ('0037_0000000001', '0037_0000000002', '0037_0000000001', 'umadmin', '2020-03-24 05:48:32', 'umadmin', '2020-03-22 07:02:40', '35', 'DEMO', null, 'DEMO', '', '0005_0000000003', '123456', '0012_0000000002', '演示系统', 'update');
INSERT INTO `app_system_design` VALUES ('0037_0000000002', null, '0037_0000000001', 'umadmin', '2020-03-23 18:21:38', 'umadmin', '2020-03-22 07:02:40', '34', 'DEMO', '2020-03-23 18:21:37', 'DEMO', '', '0005_0000000003', '123456', '0012_0000000002', '演示系统', 'new');


-- ----------------------------
-- Records of business_zone
-- ----------------------------
INSERT INTO `business_zone` VALUES ('0028_0000000001', null, '0028_0000000001', 'umadmin', '2020-03-22 05:26:13', 'umadmin', '2020-03-21 17:49:30', '37', 'PCv1_SF_CS_1', '', '1', '', '0018_0000000001', 'GROUP', '', '公共服务', 'created');
INSERT INTO `business_zone` VALUES ('0028_0000000002', null, '0028_0000000002', 'umadmin', '2020-03-24 03:19:07', 'umadmin', '2020-03-21 18:03:20', '37', 'PCv1_SF_CS_101', '', '101', '', '0018_0000000001', 'NODE', '0028_0000000001', '公共服务', 'created');
INSERT INTO `business_zone` VALUES ('0028_0000000003', null, '0028_0000000003', 'umadmin', '2020-03-22 05:26:13', 'umadmin', '2020-03-21 18:04:30', '37', 'PCv1_MGMT_PC_1', '', '1', '', '0018_0000000003', 'GROUP', '', '桌面服务', 'created');
INSERT INTO `business_zone` VALUES ('0028_0000000004', null, '0028_0000000004', 'umadmin', '2020-03-22 05:26:13', 'umadmin', '2020-03-21 18:06:02', '37', 'PCv1_MGMT_PC_101', '', '101', '', '0018_0000000003', 'NODE', '0028_0000000003', '桌面服务', 'created');
INSERT INTO `business_zone` VALUES ('0028_0000000005', null, '0028_0000000005', 'umadmin', '2020-03-22 05:26:13', 'umadmin', '2020-03-21 18:06:47', '37', 'PCv1_MGMT_MT_1', '', '1', '', '0018_0000000002', 'GROUP', '', '管理工具', 'created');
INSERT INTO `business_zone` VALUES ('0028_0000000006', null, '0028_0000000006', 'umadmin', '2020-03-22 05:26:12', 'umadmin', '2020-03-21 18:08:38', '37', 'PCv1_MGMT_MT_101', '', '101', '', '0018_0000000002', 'NODE', '0028_0000000005', '管理工具', 'created');


-- ----------------------------
-- Records of business_zone$network_segment
-- ----------------------------
INSERT INTO `business_zone$network_segment` VALUES ('86', '0028_0000000006', '0023_0000000011', '2');
INSERT INTO `business_zone$network_segment` VALUES ('87', '0028_0000000006', '0023_0000000010', '3');
INSERT INTO `business_zone$network_segment` VALUES ('88', '0028_0000000006', '0023_0000000012', '1');
INSERT INTO `business_zone$network_segment` VALUES ('89', '0028_0000000006', '0023_0000000009', '4');
INSERT INTO `business_zone$network_segment` VALUES ('90', '0028_0000000005', '0023_0000000011', '2');
INSERT INTO `business_zone$network_segment` VALUES ('91', '0028_0000000005', '0023_0000000010', '3');
INSERT INTO `business_zone$network_segment` VALUES ('92', '0028_0000000005', '0023_0000000012', '1');
INSERT INTO `business_zone$network_segment` VALUES ('93', '0028_0000000005', '0023_0000000009', '4');
INSERT INTO `business_zone$network_segment` VALUES ('94', '0028_0000000004', '0023_0000000008', '1');
INSERT INTO `business_zone$network_segment` VALUES ('95', '0028_0000000003', '0023_0000000008', '1');
INSERT INTO `business_zone$network_segment` VALUES ('100', '0028_0000000001', '0023_0000000004', '1');
INSERT INTO `business_zone$network_segment` VALUES ('101', '0028_0000000001', '0023_0000000006', '4');
INSERT INTO `business_zone$network_segment` VALUES ('102', '0028_0000000001', '0023_0000000007', '3');
INSERT INTO `business_zone$network_segment` VALUES ('103', '0028_0000000001', '0023_0000000005', '2');
INSERT INTO `business_zone$network_segment` VALUES ('104', '0028_0000000002', '0023_0000000006', '4');
INSERT INTO `business_zone$network_segment` VALUES ('105', '0028_0000000002', '0023_0000000005', '2');
INSERT INTO `business_zone$network_segment` VALUES ('106', '0028_0000000002', '0023_0000000004', '1');
INSERT INTO `business_zone$network_segment` VALUES ('107', '0028_0000000002', '0023_0000000007', '3');

-- ----------------------------
-- Records of business_zone$network_zone
-- ----------------------------
INSERT INTO `business_zone$network_zone` VALUES ('29', '0028_0000000006', '0024_0000000003', '1');
INSERT INTO `business_zone$network_zone` VALUES ('30', '0028_0000000005', '0024_0000000003', '1');
INSERT INTO `business_zone$network_zone` VALUES ('31', '0028_0000000004', '0024_0000000003', '1');
INSERT INTO `business_zone$network_zone` VALUES ('32', '0028_0000000003', '0024_0000000003', '1');
INSERT INTO `business_zone$network_zone` VALUES ('34', '0028_0000000001', '0024_0000000001', '1');
INSERT INTO `business_zone$network_zone` VALUES ('35', '0028_0000000002', '0024_0000000001', '1');

-- ----------------------------
-- Records of business_zone_design
-- ----------------------------
INSERT INTO `business_zone_design` VALUES ('0018_0000000001', null, '0018_0000000001', 'umadmin', '2020-03-22 05:22:45', 'umadmin', '2020-03-21 14:52:34', '34', 'PCv1_SF_CS', '', 'CS', '', '0014_0000000001', 'new');
INSERT INTO `business_zone_design` VALUES ('0018_0000000002', null, '0018_0000000002', 'umadmin', '2020-03-22 05:22:45', 'umadmin', '2020-03-21 14:54:24', '34', 'PCv1_MGMT_MT', '', 'MT', '', '0014_0000000002', 'new');
INSERT INTO `business_zone_design` VALUES ('0018_0000000003', null, '0018_0000000003', 'umadmin', '2020-03-22 05:22:45', 'umadmin', '2020-03-21 15:55:01', '34', 'PCv1_MGMT_PC', '', 'PC', '', '0014_0000000002', 'new');

-- ----------------------------
-- Records of business_zone_design$application_domain
-- ----------------------------
INSERT INTO `business_zone_design$application_domain` VALUES ('10', '0018_0000000003', '0005_0000000004', '2');
INSERT INTO `business_zone_design$application_domain` VALUES ('11', '0018_0000000003', '0005_0000000003', '3');
INSERT INTO `business_zone_design$application_domain` VALUES ('12', '0018_0000000003', '0005_0000000002', '4');
INSERT INTO `business_zone_design$application_domain` VALUES ('13', '0018_0000000003', '0005_0000000001', '5');
INSERT INTO `business_zone_design$application_domain` VALUES ('14', '0018_0000000003', '0005_0000000005', '1');
INSERT INTO `business_zone_design$application_domain` VALUES ('15', '0018_0000000002', '0005_0000000004', '1');
INSERT INTO `business_zone_design$application_domain` VALUES ('16', '0018_0000000001', '0005_0000000004', '2');
INSERT INTO `business_zone_design$application_domain` VALUES ('17', '0018_0000000001', '0005_0000000003', '3');
INSERT INTO `business_zone_design$application_domain` VALUES ('18', '0018_0000000001', '0005_0000000002', '4');
INSERT INTO `business_zone_design$application_domain` VALUES ('19', '0018_0000000001', '0005_0000000001', '5');
INSERT INTO `business_zone_design$application_domain` VALUES ('20', '0018_0000000001', '0005_0000000005', '1');

-- ----------------------------
-- Records of business_zone_design$network_segment_design
-- ----------------------------
INSERT INTO `business_zone_design$network_segment_design` VALUES ('55', '0018_0000000003', '0013_0000000008', '1');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('56', '0018_0000000002', '0013_0000000009', '1');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('57', '0018_0000000002', '0013_0000000012', '4');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('58', '0018_0000000002', '0013_0000000010', '2');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('59', '0018_0000000002', '0013_0000000011', '3');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('60', '0018_0000000001', '0013_0000000005', '3');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('61', '0018_0000000001', '0013_0000000006', '1');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('62', '0018_0000000001', '0013_0000000004', '4');
INSERT INTO `business_zone_design$network_segment_design` VALUES ('63', '0018_0000000001', '0013_0000000007', '2');

-- ----------------------------
-- Records of cache_instance
-- ----------------------------

-- ----------------------------
-- Records of cloud_vendor
-- ----------------------------
INSERT INTO `cloud_vendor` VALUES ('0006_0000000001', null, '0006_0000000001', 'umadmin', '2020-03-21 16:48:43', 'umadmin', '2020-03-21 16:48:43', '34', 'QCLOUD|腾讯云', '', 'QCLOUD', '', '腾讯云', null);
INSERT INTO `cloud_vendor` VALUES ('0006_0000000002', null, '0006_0000000002', 'umadmin', '2020-03-26 00:53:27', 'umadmin', '2020-03-26 00:53:27', '34', 'HWCLOUD|华为云', '', 'HWCLOUD', '', '华为云', 'new');

-- ----------------------------
-- Records of cluster_node_type
-- ----------------------------
INSERT INTO `cluster_node_type` VALUES ('0008_0000000001', null, '0008_0000000001', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-21 18:15:02', '34', 'NODE|负载节点', '', 'NODE', '', '0007_0000000001', '负载节点', 'new');
INSERT INTO `cluster_node_type` VALUES ('0008_0000000002', null, '0008_0000000002', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-21 18:16:07', '34', 'master|MYSQL master', '', 'master', '', '0007_0000000002', 'MYSQL master', 'new');
INSERT INTO `cluster_node_type` VALUES ('0008_0000000003', null, '0008_0000000003', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-21 18:16:23', '34', 'ro|master 从节点', '', 'ro', '', '0007_0000000002', 'master 从节点', 'new');
INSERT INTO `cluster_node_type` VALUES ('0008_0000000004', null, '0008_0000000004', 'umadmin', '2020-03-22 07:08:48', 'umadmin', '2020-03-22 07:01:54', '34', 'NODE|单一节点', '', 'NODE', '', '0007_0000000004', '单一节点', 'new');

-- ----------------------------
-- Records of cluster_type
-- ----------------------------
INSERT INTO `cluster_type` VALUES ('0007_0000000001', null, '0007_0000000001', 'umadmin', '2020-03-22 05:30:25', 'umadmin', '2020-03-21 18:12:00', '34', 'CLB|负载均衡', '', 'CLB', '', '0006_0000000001', '负载均衡', 'new');
INSERT INTO `cluster_type` VALUES ('0007_0000000002', null, '0007_0000000002', 'umadmin', '2020-03-22 05:30:25', 'umadmin', '2020-03-21 18:13:50', '34', 'CMMS|MYSQL主从', '', 'CMMS', '', '0006_0000000001', 'MYSQL主从', 'new');
INSERT INTO `cluster_type` VALUES ('0007_0000000003', null, '0007_0000000003', 'umadmin', '2020-03-22 05:30:25', 'umadmin', '2020-03-21 18:14:16', '34', 'CRMS|REDIS主从', '', 'CRMS', '', '0006_0000000001', 'REDIS主从', 'new');
INSERT INTO `cluster_type` VALUES ('0007_0000000004', null, '0007_0000000004', 'umadmin', '2020-03-22 05:29:45', 'umadmin', '2020-03-22 05:29:45', '34', 'LBC|LB集群', '', 'LBC', '', '0006_0000000001', 'LB集群', 'new');
INSERT INTO `cluster_type` VALUES ('0007_0000000005', null, '0007_0000000005', 'umadmin', '2020-03-22 05:30:15', 'umadmin', '2020-03-22 05:30:15', '34', 'MN|多节点', '', 'MN', '', '0006_0000000001', '多节点', 'new');

-- ----------------------------
-- Records of data_center
-- ----------------------------
INSERT INTO `data_center` VALUES ('0022_0000000001', null, '0022_0000000001', 'umadmin', '2020-03-24 01:44:57', 'umadmin', '2020-03-21 16:51:12', '37', 'GZP', '', 'GZP', '', '', '0006_0000000001', '0012_0000000002', 'REGION', 'Region=ap-guangzhou', '广州生产数据中心', '', 'created');
INSERT INTO `data_center` VALUES ('0022_0000000002', null, '0022_0000000002', 'umadmin', '2020-03-24 01:44:57', 'umadmin', '2020-03-21 16:53:12', '37', 'GZP2', '', 'GZP2', '', '', '0006_0000000001', '0012_0000000002', 'ZONE', 'Region=ap-guangzhou;AvailableZone=ap-guangzhou-4', '广州生产2号数据中心', '', 'created');
INSERT INTO `data_center` VALUES ('0022_0000000003', null, '0022_0000000003', 'umadmin', '2020-03-26 00:53:51', 'umadmin', '2020-03-26 00:50:10', '37', 'HW-GZ', '', 'HW-GZ', '', 'SecretKey=TvKPtPMfeQXC7g028ExcuOIQfyZJeKFFUU6aorxC;AccessKey=0DHVATZENWAYHVYGMSNF;DomainId=08221744890010ad0fc5c0003e316000', '0006_0000000002', '0012_0000000007', 'TEST', 'CloudApiDomainName=myhuaweicloud.com;Region=cn-south-1;ProjectId=0824b56fd200265e2fd5c00037d647a1', '华为广州测试', '', 'created');

-- ----------------------------
-- Records of data_center$deploy_environment
-- ----------------------------
INSERT INTO `data_center$deploy_environment` VALUES ('7', '0022_0000000002', '0003_0000000001', '1');
INSERT INTO `data_center$deploy_environment` VALUES ('8', '0022_0000000001', '0003_0000000001', '1');
INSERT INTO `data_center$deploy_environment` VALUES ('11', '0022_0000000003', '0003_0000000003', '1');
INSERT INTO `data_center$deploy_environment` VALUES ('12', '0022_0000000003', '0003_0000000004', '2');


-- ----------------------------
-- Records of data_center_design
-- ----------------------------
INSERT INTO `data_center_design` VALUES ('0012_0000000002', null, '0012_0000000002', 'umadmin', '2020-03-22 14:49:53', 'umadmin', '2020-03-21 10:43:34', '34', 'PCv1', '', 'PCv1', '公有云版本1', '公有云版本1', 'new');
INSERT INTO `data_center_design` VALUES ('0012_0000000007', '0012_0000000009', '0012_0000000007', 'umadmin', '2020-03-26 00:46:55', 'umadmin', '2020-03-26 00:45:24', '35', 'HWu0', '2020-03-26 00:46:55', 'HWu0', '华为云a', '华为云1', 'update');
INSERT INTO `data_center_design` VALUES ('0012_0000000009', null, '0012_0000000007', 'umadmin', '2020-03-26 00:46:07', 'umadmin', '2020-03-26 00:45:24', '34', 'HWu1', '2020-03-26 00:45:32', 'HWu1', '华为云', '华为云', 'new');

-- ----------------------------
-- Records of default_security_policy
-- ----------------------------
INSERT INTO `default_security_policy` VALUES ('0025_0000000001', null, '0025_0000000001', 'SYS_PLATFORM', '2020-03-24 02:40:01', 'umadmin', '2020-03-22 11:04:53', '37', 'GZP_SF ACCEPT GZP_SF ingress', '', 'GZP_SF ACCEPT GZP_SF ingress', '', '0015_0000000003', '0023_0000000002', '0023_0000000002', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000002', null, '0025_0000000002', 'SYS_PLATFORM', '2020-03-24 02:40:01', 'umadmin', '2020-03-22 11:08:39', '37', 'GZP_SF ACCEPT GZP_SF egress', '', 'GZP_SF ACCEPT GZP_SF egress', '', '0015_0000000004', '0023_0000000002', '0023_0000000002', 'ALL', 'TCP', 'ACCEPT', 'egress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000003', null, '0025_0000000003', 'SYS_PLATFORM', '2020-03-24 02:40:02', 'umadmin', '2020-03-22 11:08:55', '37', 'GZP_SF ACCEPT GZP2_MGMT_MT_APP ingress', '', 'GZP_SF ACCEPT GZP2_MGMT_MT_APP ingress', '', '0015_0000000005', '0023_0000000010', '0023_0000000002', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000004', null, '0025_0000000004', 'SYS_PLATFORM', '2020-03-24 02:40:02', 'umadmin', '2020-03-22 11:09:19', '37', 'GZP_SF ACCEPT GZP2_MGMT_MT_APP egress', '', 'GZP_SF ACCEPT GZP2_MGMT_MT_APP egress', '', '0015_0000000006', '0023_0000000010', '0023_0000000002', 'ALL', 'TCP', 'ACCEPT', 'egress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000005', null, '0025_0000000005', 'SYS_PLATFORM', '2020-03-24 02:40:02', 'umadmin', '2020-03-22 11:09:34', '37', 'GZP_MGMT ACCEPT GZP_MGMT ingress', '', 'GZP_MGMT ACCEPT GZP_MGMT ingress', '', '0015_0000000001', '0023_0000000003', '0023_0000000003', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000006', null, '0025_0000000006', 'SYS_PLATFORM', '2020-03-24 02:40:03', 'umadmin', '2020-03-22 11:09:53', '37', 'GZP_MGMT ACCEPT GZP_MGMT egress', '', 'GZP_MGMT ACCEPT GZP_MGMT egress', '', '0015_0000000002', '0023_0000000003', '0023_0000000003', 'ALL', 'TCP', 'ACCEPT', 'egress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000007', null, '0025_0000000007', 'umadmin', '2020-03-26 16:43:03', 'umadmin', '2020-03-22 11:10:07', '37', '         GZP_MGMT_ACCEPT_GZP_SF_ingress_ALL', '', 'GZP_MGMT ACCEPT GZP_SF ingress', '', '0015_0000000007', '0023_0000000002', '0023_0000000003', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000008', '0025_0000000010', '0025_0000000008', 'SYS_PLATFORM', '2020-03-26 18:58:32', 'umadmin', '2020-03-26 06:02:31', '38', 'HW-SF_ACCEPT_HW-SF_ingress_8100', '2020-03-26 18:58:31', 'HW-SF_ACCEPT_HW-SF_ingress_8100', 'a9d52640-e4ab-47e0-95d6-8d1205e0cb43', '0015_0000000008', '0023_0000000013', '0023_0000000013', '8100', 'TCP', 'ACCEPT', 'ingress', 'changed', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000009', '0025_0000000011', '0025_0000000009', 'umadmin', '2020-03-27 07:04:11', 'umadmin', '2020-03-26 18:57:17', '38', 'HW-SF_REJECT_HW-SF_egress_90', null, 'HW-SF_REJECT_HW-SF_egress_90', 'c4e5cf55-6316-41f9-86d3-d787ddd94789', '0015_0000000010', '0023_0000000013', '0023_0000000013', '90', 'TCP', 'REJECT', 'egress', 'changed', '100');
INSERT INTO `default_security_policy` VALUES ('0025_0000000010', null, '0025_0000000008', 'SYS_PLATFORM', '2020-03-26 18:58:30', 'umadmin', '2020-03-26 06:02:31', '37', 'HW-SF_ACCEPT_HW-SF_ingress_8100', '2020-03-26 18:49:18', 'HW-SF_ACCEPT_HW-SF_ingress_8100', 'f48076be-34c0-4dc7-ad30-6a944c38e51b', '0015_0000000008', '0023_0000000013', '0023_0000000013', '8100', 'TCP', 'ACCEPT', 'ingress', 'created', null);
INSERT INTO `default_security_policy` VALUES ('0025_0000000011', null, '0025_0000000009', 'SYS_PLATFORM', '2020-03-26 18:58:32', 'umadmin', '2020-03-26 18:57:17', '37', 'HW-SF_REJECT_HW-SF_egress_90', '2020-03-26 18:58:31', 'HW-SF_REJECT_HW-SF_egress_90', 'c4e5cf55-6316-41f9-86d3-d787ddd94789', '0015_0000000010', '0023_0000000013', '0023_0000000013', '90', 'TCP', 'REJECT', 'egress', 'created', null);

-- ----------------------------
-- Records of default_security_policy_design
-- ----------------------------
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000001', null, '0015_0000000001', 'umadmin', '2020-03-22 10:59:33', 'umadmin', '2020-03-21 16:25:55', '34', 'PCv1_MGMT ACCEPT MGMT ingress', '', 'PCv1_MGMT ACCEPT MGMT ingress', '', '0013_0000000003', '0013_0000000003', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000002', null, '0015_0000000002', 'umadmin', '2020-03-22 10:59:32', 'umadmin', '2020-03-21 16:34:44', '34', 'PCv1_MGMT ACCEPT MGMT egress', '', 'PCv1_MGMT ACCEPT MGMT egress', '', '0013_0000000003', '0013_0000000003', 'ALL', 'TCP', 'ACCEPT', 'egress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000003', null, '0015_0000000003', 'umadmin', '2020-03-22 10:59:32', 'umadmin', '2020-03-21 16:35:25', '34', 'PCv1_SF ACCEPT SF ingress', '', 'PCv1_SF ACCEPT SF ingress', '', '0013_0000000002', '0013_0000000002', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000004', null, '0015_0000000004', 'umadmin', '2020-03-22 10:59:32', 'umadmin', '2020-03-21 16:35:48', '34', 'PCv1_SF ACCEPT SF egress', '', 'PCv1_SF ACCEPT SF egress', '', '0013_0000000002', '0013_0000000002', 'ALL', 'TCP', 'ACCEPT', 'egress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000005', null, '0015_0000000005', 'umadmin', '2020-03-22 10:59:31', 'umadmin', '2020-03-21 16:36:33', '34', 'PCv1_SF ACCEPT MGMT_MT_APP ingress', '', 'PCv1_SF ACCEPT MGMT_MT_APP ingress', '', '0013_0000000010', '0013_0000000002', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000006', null, '0015_0000000006', 'umadmin', '2020-03-22 10:59:31', 'umadmin', '2020-03-21 16:37:19', '34', 'PCv1_SF ACCEPT MGMT_MT_APP egress', '', 'PCv1_SF ACCEPT MGMT_MT_APP egress', '', '0013_0000000010', '0013_0000000002', 'ALL', 'TCP', 'ACCEPT', 'egress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000007', null, '0015_0000000007', 'umadmin', '2020-03-22 10:59:31', 'umadmin', '2020-03-22 10:52:32', '34', 'PCv1_MGMT ACCEPT SF ingress', '', 'PCv1_MGMT ACCEPT SF ingress', '', '0013_0000000002', '0013_0000000003', 'ALL', 'TCP', 'ACCEPT', 'ingress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000008', null, '0015_0000000008', 'umadmin', '2020-03-26 07:27:10', 'umadmin', '2020-03-26 03:14:24', '34', '   HW-SF ACCEPT HW-SF ingress8100', '', 'HW-SF ACCEPT HW-SF ingress', '', '0013_0000000013', '0013_0000000013', '8100', 'TCP', 'ACCEPT', 'ingress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000009', null, '0015_0000000009', 'umadmin', '2020-03-26 07:27:10', 'umadmin', '2020-03-26 06:05:03', '34', '   HW-SF ACCEPT HW-SF ingress8200', '', 'HW-SF ACCEPT HW-SF ingress', '8300', '0013_0000000013', '0013_0000000013', '8200', 'TCP', 'ACCEPT', 'ingress', 'new', null);
INSERT INTO `default_security_policy_design` VALUES ('0015_0000000010', null, '0015_0000000010', 'umadmin', '2020-03-27 07:04:11', 'umadmin', '2020-03-26 06:06:08', '34', '   HW-SF REJECT HW-SF egress90', '', 'HW-SF REJECT HW-SF egress', '', '0013_0000000013', '0013_0000000013', '90', 'TCP', 'REJECT', 'egress', 'new', '100');

-- ----------------------------
-- Records of deploy_environment
-- ----------------------------
INSERT INTO `deploy_environment` VALUES ('0003_0000000001', null, '0003_0000000001', 'umadmin', '2020-03-21 16:49:23', 'umadmin', '2020-03-21 16:49:23', '34', 'PRD|生产环境', '', 'PRD', '', '生产环境', null);
INSERT INTO `deploy_environment` VALUES ('0003_0000000002', null, '0003_0000000002', 'umadmin', '2020-03-21 16:49:38', 'umadmin', '2020-03-21 16:49:38', '34', 'DR|容灾环境', '', 'DR', '', '容灾环境', null);
INSERT INTO `deploy_environment` VALUES ('0003_0000000003', null, '0003_0000000003', 'umadmin', '2020-03-21 16:50:18', 'umadmin', '2020-03-21 16:50:17', '34', 'STGi|UAT环境i', '', 'STGi', '', 'UAT环境i', null);
INSERT INTO `deploy_environment` VALUES ('0003_0000000004', null, '0003_0000000004', 'umadmin', '2020-03-21 16:50:35', 'umadmin', '2020-03-21 16:50:35', '34', 'STGk|UAT环境k', '', 'STGk', '', 'UAT环境k', null);

-- ----------------------------
-- Records of deploy_package
-- ----------------------------

-- ----------------------------
-- Records of diff_configuration
-- ----------------------------
INSERT INTO `diff_configuration` VALUES ('0044_0000000001', null, '0044_0000000001', 'SYS_PLATFORM', '2020-03-24 05:51:43', 'SYS_PLATFORM', '2020-03-24 02:12:15', '34', 'jmx_hostname', null, 'jmx_hostname', null, 'new', 'jmx_hostname', '[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":50},{\\\"ciTypeId\\\":32,\\\"parentRs\\\":{\\\"attrId\\\":927,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":31,\\\"parentRs\\\":{\\\"attrId\\\":546,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":31,\\\"parentRs\\\":{\\\"attrId\\\":521,\\\"isReferedFromParent\\\":1}}]\"}]');
INSERT INTO `diff_configuration` VALUES ('0044_0000000002', null, '0044_0000000002', 'SYS_PLATFORM', '2020-03-24 05:51:51', 'SYS_PLATFORM', '2020-03-24 02:12:15', '34', 'jmx_port', null, 'jmx_port', null, 'new', 'jmx_port', '[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":50},{\\\"ciTypeId\\\":50,\\\"parentRs\\\":{\\\"attrId\\\":929,\\\"isReferedFromParent\\\":1}}]\"}]');
INSERT INTO `diff_configuration` VALUES ('0044_0000000003', null, '0044_0000000003', 'SYS_PLATFORM', '2020-03-24 05:52:15', 'SYS_PLATFORM', '2020-03-24 02:12:16', '34', 'port', null, 'port', null, 'new', 'port', '[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":50},{\\\"ciTypeId\\\":50,\\\"parentRs\\\":{\\\"attrId\\\":928,\\\"isReferedFromParent\\\":1}}]\"}]');
INSERT INTO `diff_configuration` VALUES ('0044_0000000005', null, '0044_0000000005', 'SYS_PLATFORM', '2020-03-24 06:30:35', 'SYS_PLATFORM', '2020-03-24 02:12:16', '34', 'db_host_port', null, 'db_host_port', null, 'new', 'db_host_port', '[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":50},{\\\"ciTypeId\\\":48,\\\"parentRs\\\":{\\\"attrId\\\":926,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":49,\\\"parentRs\\\":{\\\"attrId\\\":908,\\\"isReferedFromParent\\\":0}},{\\\"ciTypeId\\\":48,\\\"parentRs\\\":{\\\"attrId\\\":910,\\\"isReferedFromParent\\\":1},\\\"filters\\\":[{\\\"name\\\":\\\"key_name\\\",\\\"operator\\\":\\\"eq\\\",\\\"type\\\":\\\"value\\\",\\\"value\\\":\\\"PRD_DEMO_CORE_DB1\\\"}]},{\\\"ciTypeId\\\":51,\\\"parentRs\\\":{\\\"attrId\\\":956,\\\"isReferedFromParent\\\":0}},{\\\"ciTypeId\\\":51,\\\"parentRs\\\":{\\\"attrId\\\":958,\\\"isReferedFromParent\\\":1}}]\"}]');
INSERT INTO `diff_configuration` VALUES ('0044_0000000006', null, '0044_0000000006', 'SYS_PLATFORM', '2020-03-24 02:12:16', 'SYS_PLATFORM', '2020-03-24 02:12:16', '34', 'db_name', null, 'db_name', null, 'new', 'db_name', '');
INSERT INTO `diff_configuration` VALUES ('0044_0000000007', null, '0044_0000000007', 'SYS_PLATFORM', '2020-03-24 02:12:16', 'SYS_PLATFORM', '2020-03-24 02:12:16', '34', 'db_username', null, 'db_username', null, 'new', 'db_username', '');
INSERT INTO `diff_configuration` VALUES ('0044_0000000008', null, '0044_0000000008', 'SYS_PLATFORM', '2020-03-24 02:12:16', 'SYS_PLATFORM', '2020-03-24 02:12:16', '34', 'db_password', null, 'db_password', null, 'new', 'db_password', '');
INSERT INTO `diff_configuration` VALUES ('0044_0000000009', null, '0044_0000000009', 'SYS_PLATFORM', '2020-03-24 05:58:19', 'SYS_PLATFORM', '2020-03-24 05:56:03', '34', 'db_host_ip', null, 'db_host_ip', null, 'new', 'db_host_ip', '[{\"type\":\"rule\",\"value\":\"[{\\\"ciTypeId\\\":50},{\\\"ciTypeId\\\":48,\\\"parentRs\\\":{\\\"attrId\\\":926,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":49,\\\"parentRs\\\":{\\\"attrId\\\":908,\\\"isReferedFromParent\\\":0}},{\\\"ciTypeId\\\":48,\\\"parentRs\\\":{\\\"attrId\\\":910,\\\"isReferedFromParent\\\":1},\\\"filters\\\":[{\\\"name\\\":\\\"key_name\\\",\\\"operator\\\":\\\"eq\\\",\\\"type\\\":\\\"value\\\",\\\"value\\\":\\\"PRD_DEMO_CORE_DB1\\\"}]},{\\\"ciTypeId\\\":51,\\\"parentRs\\\":{\\\"attrId\\\":956,\\\"isReferedFromParent\\\":0}},{\\\"ciTypeId\\\":33,\\\"parentRs\\\":{\\\"attrId\\\":957,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":31,\\\"parentRs\\\":{\\\"attrId\\\":581,\\\"isReferedFromParent\\\":1}},{\\\"ciTypeId\\\":31,\\\"parentRs\\\":{\\\"attrId\\\":521,\\\"isReferedFromParent\\\":1}}]\"}]');


-- ----------------------------
-- Records of host_resource_instance
-- ----------------------------
INSERT INTO `host_resource_instance` VALUES ('0032_0000000001', null, '0032_0000000001', 'SYS_PLATFORM', '2020-03-24 05:07:00', 'umadmin', '2020-03-22 05:06:52', '40', 'host1_10.128.33.17', '', 'host1', '', '', '', '0', 'POSTPAID_BY_HOUR', '0008_0000000001', '1', '', '0031_0000000003', '22', '', '2', '10.128.33.17:9100', '9100', 'host1', '0010_0000000001', '0011_0000000001', '0009_0000000001', '0029_0000000011', 'created', '50', '0002_0000000001', 'root', 'Abcd1234');
INSERT INTO `host_resource_instance` VALUES ('0032_0000000002', null, '0032_0000000002', 'SYS_PLATFORM', '2020-03-24 05:07:00', 'umadmin', '2020-03-22 06:18:15', '40', 'host2_10.128.33.10', '', 'host2', '', '', '', '0', 'POSTPAID_BY_HOUR', '0008_0000000001', '1', '', '0031_0000000004', '22', '', '2', '10.128.33.10:9100', '9100', 'host2', '0010_0000000001', '0011_0000000001', '0009_0000000001', '0029_0000000011', 'created', '50', '0002_0000000001', 'root', 'Abcd1234');
INSERT INTO `host_resource_instance` VALUES ('0032_0000000003', null, '0032_0000000003', 'umadmin', '2020-03-22 15:25:41', 'umadmin', '2020-03-22 06:36:32', '40', 'host1_10.128.202.2', '', 'host1', '', '', '', '0', 'POSTPAID_BY_HOUR', '0008_0000000001', '2', '', '0031_0000000011', '22', '', '4', '10.128.202.2:9100', '9100', 'host1', '0010_0000000002', '0011_0000000001', '0009_0000000001', '0029_0000000016', 'created', '50', '0002_0000000001', 'root', 'Abcd1234');
INSERT INTO `host_resource_instance` VALUES ('0032_0000000004', null, '0032_0000000004', 'umadmin', '2020-03-24 01:54:45', 'umadmin', '2020-03-22 06:38:05', '40', 'host2_10.128.202.3', '', 'host2', '', '', '', '0', 'POSTPAID_BY_HOUR', '0008_0000000001', '2', '', '0031_0000000012', '22', '', '4', '10.128.202.3:9100', '9100', 'host2', '0010_0000000002', '0011_0000000001', '0009_0000000001', '0029_0000000016', 'created', '50', '0002_0000000001', 'root', 'Abcd1234');

-- ----------------------------
-- Records of invoke
-- ----------------------------
INSERT INTO `invoke` VALUES ('0049_0000000001', null, '0049_0000000001', 'umadmin', '2020-03-22 12:33:54', 'umadmin', '2020-03-22 12:33:53', '37', 'PRD_DEMO_CLIENT_BROWER1_invoke_PRD_DEMO_CORE_LB1', '', 'PRD_DEMO_CLIENT_BROWER1_invoke_PRD_DEMO_CORE_LB1', '', '', '0048_0000000001', '0040_0000000001', '同步调用', '0048_0000000004', 'created');
INSERT INTO `invoke` VALUES ('0049_0000000002', null, '0049_0000000002', 'umadmin', '2020-03-22 12:34:19', 'umadmin', '2020-03-22 12:34:19', '37', 'PRD_DEMO_CORE_LB1_invoke_PRD_DEMO_CORE_APP1', '', 'PRD_DEMO_CORE_LB1_invoke_PRD_DEMO_CORE_APP1', '', '', '0048_0000000002', '0040_0000000002', '同步调用', '0048_0000000001', 'created');
INSERT INTO `invoke` VALUES ('0049_0000000003', null, '0049_0000000003', 'umadmin', '2020-03-22 12:34:57', 'umadmin', '2020-03-22 12:34:57', '37', 'PRD_DEMO_CORE_APP1_invoke_PRD_DEMO_CORE_DB1', '', 'PRD_DEMO_CORE_APP1_invoke_PRD_DEMO_CORE_DB1', '', '', '0048_0000000003', '0040_0000000003', '同步调用', '0048_0000000002', 'created');

-- ----------------------------
-- Records of invoke_design
-- ----------------------------
INSERT INTO `invoke_design` VALUES ('0040_0000000001', null, '0040_0000000001', 'umadmin', '2020-03-24 06:19:17', 'umadmin', '2020-03-22 07:20:08', '34', 'DEMO_CLIENT_BROWER_invoke_DEMO_CORE_LB', '2020-03-23 18:21:37', 'BROWER_invoke_LB', '', '0039_0000000003', '同步调用', '0039_0000000004', '0021_0000000002', 'new');
INSERT INTO `invoke_design` VALUES ('0040_0000000002', null, '0040_0000000002', 'umadmin', '2020-03-23 18:22:39', 'umadmin', '2020-03-22 07:23:41', '34', 'DEMO_CORE_LB_invoke_DEMO_CORE_APP', '2020-03-23 18:21:37', 'LB_invoke_APP', '', '0039_0000000001', '同步调用', '0039_0000000003', '0021_0000000008', 'new');
INSERT INTO `invoke_design` VALUES ('0040_0000000003', null, '0040_0000000003', 'umadmin', '2020-03-23 18:22:38', 'umadmin', '2020-03-22 07:23:56', '34', 'DEMO_CORE_APP_invoke_DEMO_CORE_DB', '2020-03-23 18:21:37', 'APP_invoke_DB', '', '0039_0000000002', '同步调用', '0039_0000000001', '0021_0000000007', 'new');

-- ----------------------------
-- Records of ip_address
-- ----------------------------
INSERT INTO `ip_address` VALUES ('0031_0000000001', null, '0031_0000000001', 'umadmin', '2020-03-22 10:49:27', 'umadmin', '2020-03-22 04:46:06', '37', '10.128.32.2_GZP2_SF_CS_LB', '', '10.128.32.2', '', '资源', '0023_0000000004', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000002', null, '0031_0000000002', 'umadmin', '2020-03-22 10:49:27', 'umadmin', '2020-03-22 04:46:28', '37', '10.128.32.3_GZP2_SF_CS_LB', '', '10.128.32.3', '', '资源', '0023_0000000004', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000003', null, '0031_0000000003', 'SYS_PLATFORM', '2020-03-24 04:54:28', 'umadmin', '2020-03-22 04:47:37', '37', '10.128.33.17_GZP2_SF_CS_APP', '', '10.128.33.17', '', '资源', '0023_0000000005', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000004', null, '0031_0000000004', 'SYS_PLATFORM', '2020-03-24 04:54:31', 'umadmin', '2020-03-22 04:47:47', '37', '10.128.33.10_GZP2_SF_CS_APP', '', '10.128.33.10', '', '资源', '0023_0000000005', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000005', null, '0031_0000000005', 'umadmin', '2020-03-22 10:49:26', 'umadmin', '2020-03-22 04:48:18', '37', '10.128.34.3_GZP2_SF_CS_CACHE', '', '10.128.34.3', '', '资源', '0023_0000000006', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000006', null, '0031_0000000006', 'umadmin', '2020-03-22 10:49:26', 'umadmin', '2020-03-22 04:48:31', '37', '10.128.34.2_GZP2_SF_CS_CACHE', '', '10.128.34.2', '', '资源', '0023_0000000006', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000007', null, '0031_0000000007', 'umadmin', '2020-03-22 10:49:26', 'umadmin', '2020-03-22 04:49:01', '37', '10.128.34.130_GZP2_SF_CS_RDB', '', '10.128.34.130', '', '资源', '0023_0000000007', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000008', null, '0031_0000000008', 'umadmin', '2020-03-22 10:49:26', 'umadmin', '2020-03-22 04:50:39', '37', '10.128.34.131_GZP2_SF_CS_RDB', '', '10.128.34.131', '', '资源', '0023_0000000007', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000009', null, '0031_0000000009', 'umadmin', '2020-03-22 10:49:26', 'umadmin', '2020-03-22 04:51:00', '37', '10.128.200.2_GZP2_MGMT_PC_VDI', '', '10.128.200.2', '', '资源', '0023_0000000008', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000010', null, '0031_0000000010', 'umadmin', '2020-03-22 10:49:26', 'umadmin', '2020-03-22 04:51:12', '37', '10.128.200.3_GZP2_MGMT_PC_VDI', '', '10.128.200.3', '', '资源', '0023_0000000008', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000011', null, '0031_0000000011', 'umadmin', '2020-03-24 01:53:46', 'umadmin', '2020-03-22 04:51:32', '37', '10.128.202.2_GZP2_MGMT_MT_APP', '', '10.128.202.2', '', '资源', '0023_0000000010', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000012', null, '0031_0000000012', 'umadmin', '2020-03-24 01:53:46', 'umadmin', '2020-03-22 04:52:31', '37', '10.128.202.3_GZP2_MGMT_MT_APP', '', '10.128.202.3', '', '资源', '0023_0000000010', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000013', null, '0031_0000000013', 'umadmin', '2020-03-25 04:59:32', 'umadmin', '2020-03-22 04:52:57', '37', '10.128.203.2_GZP2_MGMT_MT_CACHE', '', '10.128.203.2', '', '资源', '0023_0000000011', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000014', null, '0031_0000000014', 'umadmin', '2020-03-25 04:59:32', 'umadmin', '2020-03-22 04:53:12', '37', '10.128.203.3_GZP2_MGMT_MT_CACHE', '', '10.128.203.3', '', '资源', '0023_0000000011', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000015', null, '0031_0000000015', 'umadmin', '2020-03-25 04:59:32', 'umadmin', '2020-03-22 04:53:27', '37', '10.128.203.130_GZP2_MGMT_MT_RDB', '', '10.128.203.130', '', '资源', '0023_0000000012', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000016', null, '0031_0000000016', 'umadmin', '2020-03-25 04:59:32', 'umadmin', '2020-03-22 04:53:43', '37', '10.128.203.131_GZP2_MGMT_MT_RDB', '', '10.128.203.131', '', '资源', '0023_0000000012', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000017', null, '0031_0000000017', 'umadmin', '2020-03-22 10:49:25', 'umadmin', '2020-03-22 04:54:13', '37', '10.128.201.2_GZP2_MGMT_MT_LB', '', '10.128.201.2', '', '资源', '0023_0000000009', 'created', '未使用');
INSERT INTO `ip_address` VALUES ('0031_0000000018', null, '0031_0000000018', 'umadmin', '2020-03-22 10:49:25', 'umadmin', '2020-03-22 04:54:32', '37', '10.128.201.3_GZP2_MGMT_MT_LB', '', '10.128.201.3', '', '资源', '0023_0000000009', 'created', '未使用');

-- ----------------------------
-- Records of lb_instance
-- ----------------------------
INSERT INTO `lb_instance` VALUES ('0053_0000000001', null, '0053_0000000001', 'umadmin', '2020-03-22 12:19:26', 'umadmin', '2020-03-22 12:19:26', '37', 'PRD_DEMO_CORE_LB1_1', '', '1', '', '', '0035_0000000001', '8080', 'created', '0048_0000000001');


-- ----------------------------
-- Records of lb_resource_instance
-- ----------------------------
INSERT INTO `lb_resource_instance` VALUES ('0035_0000000001', null, '0035_0000000001', 'umadmin', '2020-03-22 08:13:06', 'umadmin', '2020-03-22 07:02:05', '37', 'lb1_10.128.32.2', '', 'lb1', '', '', '0', 'POSTPAID_BY_HOUR', '0008_0000000004', '', '0031_0000000001', '', '10.128.32.2:80', '80', 'lb1', '0009_0000000009', '0029_0000000010', 'created', '0002_0000000004');

-- ----------------------------
-- Records of legal_person
-- ----------------------------
INSERT INTO `legal_person` VALUES ('0004_0000000001', null, '0004_0000000001', 'umadmin', '2020-03-22 07:39:27', 'umadmin', '2020-03-22 07:39:26', '34', 'WEBANK|微众银行', '', 'WEBANK', '', '微众银行', 'new');

-- ----------------------------
-- Records of manage_role
-- ----------------------------
INSERT INTO `manage_role` VALUES ('0001_0000000001', null, '0001_0000000001', 'umadmin', '2020-03-21 08:53:48', 'umadmin', '2020-03-21 08:44:15', '34', 'SUBPER_ADMIN|超级管理员', '', 'SUBPER_ADMIN', '无', 'demo@xxx.com', '超级管理员', '13811111111', 'new');

-- ----------------------------
-- Records of network_segment
-- ----------------------------
INSERT INTO `network_segment` VALUES ('0023_0000000001', null, '0023_0000000001', 'umadmin', '2020-03-22 10:42:25', 'umadmin', '2020-03-21 16:55:39', '37', '10.128.0.0/16_RDC_GZP', '', '10.128.0.0/16', 'GZP', '0022_0000000001', '', '', '16', 'GZP', '0013_0000000001', 'RDC', '', 'created', '', '', 'N', null);
INSERT INTO `network_segment` VALUES ('0023_0000000002', null, '0023_0000000002', 'SYS_PLATFORM', '2020-03-24 02:39:28', 'umadmin', '2020-03-21 16:58:54', '37', '10.128.0.0/17_VPC_GZP_SF', '', '10.128.0.0/17', 'GZP_SF', '0022_0000000001', '0023_0000000001', '', '17', 'GZP_SF', '0013_0000000002', 'VPC', '', 'created', '', '', 'Y', null);
INSERT INTO `network_segment` VALUES ('0023_0000000003', null, '0023_0000000003', 'SYS_PLATFORM', '2020-03-24 02:39:28', 'umadmin', '2020-03-21 17:08:06', '37', '10.128.192.0/19_VPC_GZP_MGMT', '', '10.128.192.0/19', 'GZP_MGMT', '0022_0000000001', '0023_0000000001', '', '19', 'GZP_MGMT', '0013_0000000003', 'VPC', '', 'created', '', '', 'Y', null);
INSERT INTO `network_segment` VALUES ('0023_0000000004', null, '0023_0000000004', 'SYS_PLATFORM', '2020-03-24 02:39:46', 'umadmin', '2020-03-21 17:10:24', '37', '10.128.32.0/24_SUBNET_GZP2_SF_CS_LB', '', '10.128.32.0/24', 'GZP2_SF_CS_LB', '0022_0000000002', '0023_0000000002', '', '24', 'GZP2_SF_CS_LB', '0013_0000000004', 'SUBNET', '', 'created', '', '', 'Y', null);
INSERT INTO `network_segment` VALUES ('0023_0000000005', null, '0023_0000000005', 'SYS_PLATFORM', '2020-03-24 02:39:51', 'umadmin', '2020-03-21 17:11:58', '37', '10.128.33.0/24_SUBNET_GZP2_SF_CS_APP', '', '10.128.33.0/24', 'GZP2_SF_CS_APP', '0022_0000000002', '0023_0000000002', '', '24', 'GZP2_SF_CS_APP', '0013_0000000005', 'SUBNET', '', 'created', '', '', 'N', null);
INSERT INTO `network_segment` VALUES ('0023_0000000006', null, '0023_0000000006', 'SYS_PLATFORM', '2020-03-24 02:39:52', 'umadmin', '2020-03-21 17:12:56', '37', '10.128.34.0/25_SUBNET_GZP2_SF_CS_CACHE', '', '10.128.34.0/25', 'GZP2_SF_CS_CACHE', '0022_0000000002', '0023_0000000002', '', '25', 'GZP2_SF_CS_CACHE', '0013_0000000006', 'SUBNET', '', 'created', '', '', 'N', null);
INSERT INTO `network_segment` VALUES ('0023_0000000007', null, '0023_0000000007', 'SYS_PLATFORM', '2020-03-24 02:39:53', 'umadmin', '2020-03-21 17:13:42', '37', '10.128.34.128/25_SUBNET_GZP2_SF_CS_RDB', '', '10.128.34.128/25', 'GZP2_SF_CS_RDB', '0022_0000000002', '0023_0000000002', '', '25', 'GZP2_SF_CS_RDB', '0013_0000000007', 'SUBNET', '', 'created', '', '', 'N', null);
INSERT INTO `network_segment` VALUES ('0023_0000000008', null, '0023_0000000008', 'SYS_PLATFORM', '2020-03-24 02:39:47', 'umadmin', '2020-03-21 17:15:03', '37', '10.128.200.0/24_SUBNET_GZP2_MGMT_PC_VDI', '', '10.128.200.0/24', 'GZP2_MGMT_PC_VDI', '0022_0000000002', '0023_0000000003', '', '24', 'GZP2_MGMT_PC_VDI', '0013_0000000008', 'SUBNET', '', 'created', '', '', 'Y', null);
INSERT INTO `network_segment` VALUES ('0023_0000000009', null, '0023_0000000009', 'SYS_PLATFORM', '2020-03-24 02:39:49', 'umadmin', '2020-03-21 17:16:23', '37', '10.128.201.0/24_SUBNET_GZP2_MGMT_MT_LB', '', '10.128.201.0/24', 'GZP2_MGMT_MT_LB', '0022_0000000002', '0023_0000000003', '', '24', 'GZP2_MGMT_MT_LB', '0013_0000000009', 'SUBNET', '', 'created', '', '', 'Y', null);
INSERT INTO `network_segment` VALUES ('0023_0000000010', null, '0023_0000000010', 'SYS_PLATFORM', '2020-03-24 02:39:54', 'umadmin', '2020-03-21 17:17:30', '37', '10.128.202.0/24_SUBNET_GZP2_MGMT_MT_APP', '', '10.128.202.0/24', 'GZP2_MGMT_MT_APP', '0022_0000000002', '0023_0000000003', '', '24', 'GZP2_MGMT_MT_APP', '0013_0000000010', 'SUBNET', '', 'created', '', '', 'Y', null);
INSERT INTO `network_segment` VALUES ('0023_0000000011', null, '0023_0000000011', 'umadmin', '2020-03-25 04:59:33', 'umadmin', '2020-03-21 17:18:13', '37', '10.128.203.0/25_SUBNET_GZP2_MGMT_MT_CACHE', '', '10.128.203.0/25', 'GZP2_MGMT_MT_CACHE', '0022_0000000002', '0023_0000000003', '', '25', 'GZP2_MGMT_MT_CACHE', '0013_0000000011', 'SUBNET', '', 'created', '', '', 'N', null);
INSERT INTO `network_segment` VALUES ('0023_0000000012', null, '0023_0000000012', 'umadmin', '2020-03-25 04:59:32', 'umadmin', '2020-03-21 17:19:06', '37', '10.128.203.128/25_SUBNET_GZP2_MGMT_MT_RDB', '', '10.128.203.128/25', 'GZP2_MGMT_MT_RDB', '0022_0000000002', '0023_0000000003', '', '25', 'GZP2_MGMT_MT_RDB', '0013_0000000012', 'SUBNET', '', 'created', '', '', 'N', null);
INSERT INTO `network_segment` VALUES ('0023_0000000013', '0023_0000000019', '0023_0000000013', 'SYS_PLATFORM', '2020-03-27 07:26:52', 'umadmin', '2020-03-26 02:32:18', '38', '172.16.0.0/14_VPC_HW-SF', '2020-03-27 07:26:52', '172.16.0.0/14', '', '0022_0000000003', '', '', '14', 'HW-SF', '0013_0000000013', 'VPC', '', 'changed', '', '5d2b96ea-59f5-4144-8c28-ffa5068e816e', 'Y', '55b46c55-c68c-49cb-b265-85217cad0923');
INSERT INTO `network_segment` VALUES ('0023_0000000014', '0023_0000000020', '0023_0000000014', 'SYS_PLATFORM', '2020-03-27 07:26:52', 'umadmin', '2020-03-26 02:34:24', '38', '172.20.0.0/14_VPC_HW-ADM', '2020-03-27 07:26:52', '172.20.0.0/14', '', '0022_0000000003', '', '', '14', 'HW-ADM', '0013_0000000014', 'VPC', '', 'changed', '', 'e2de5a00-9ac5-4cbd-a257-775224a8f08a', 'Y', '');
INSERT INTO `network_segment` VALUES ('0023_0000000015', '0023_0000000021', '0023_0000000015', 'umadmin', '2020-03-26 17:27:07', 'umadmin', '2020-03-26 02:35:02', '38', '172.24.0.0/14_VPC_HW-DMZ', '2020-03-26 17:27:06', '172.24.0.0/14', '', '0022_0000000003', '', '', '14', 'HW-DMZ', '0013_0000000015', 'VPC', '', 'changed', '', '7d3f18e1-e888-4f05-979b-e1164917817a', 'Y', '');
INSERT INTO `network_segment` VALUES ('0023_0000000016', '0023_0000000024', '0023_0000000016', 'SYS_PLATFORM', '2020-03-27 07:26:52', 'umadmin', '2020-03-26 02:39:58', '38', '172.16.0.0/24_SUBNET_HW-SF-APP', '2020-03-27 07:26:52', '172.16.0.0/24', '', '0022_0000000003', '0023_0000000013', '', '24', 'HW-SF-APP', '0013_0000000016', 'SUBNET', '', 'changed', 'ad537ba7-4da4-4dda-9051-e0f4b20ae38a', '', null, '');
INSERT INTO `network_segment` VALUES ('0023_0000000017', '0023_0000000023', '0023_0000000017', 'SYS_PLATFORM', '2020-03-27 07:26:52', 'umadmin', '2020-03-26 02:41:10', '38', '172.17.0.0/24_ABC_HW-SF-DB', '2020-03-27 07:26:52', '172.17.0.0/24', '', '0022_0000000003', '0023_0000000013', '', '24', 'HW-SF-DB', '0013_0000000017', 'ABC', '', 'changed', '9b7ac229-3072-4bb4-a85c-ff4f6f72fed3', '', null, '');
INSERT INTO `network_segment` VALUES ('0023_0000000018', '0023_0000000022', '0023_0000000018', 'SYS_PLATFORM', '2020-03-27 07:26:52', 'umadmin', '2020-03-26 02:43:40', '38', '172.20.0.0/24_SUBNET_HW-ADM-APP', '2020-03-27 07:26:52', '172.20.0.0/24', '', '0022_0000000003', '0023_0000000014', '', '24', 'HW-ADM-APP', '0013_0000000018', 'SUBNET', '', 'changed', '4760902b-23df-4f5f-8ada-60becd0b7bc8', '', null, '');
INSERT INTO `network_segment` VALUES ('0023_0000000019', null, '0023_0000000013', 'SYS_PLATFORM', '2020-03-26 14:34:37', 'umadmin', '2020-03-26 02:32:18', '37', '172.16.0.0/14_VPC_HW-SF', '2020-03-26 10:44:24', '172.16.0.0/14', '', '0022_0000000003', '', '', '14', 'HW-SF', '0013_0000000013', 'VPC', '', 'created', '', '', 'Y', '');
INSERT INTO `network_segment` VALUES ('0023_0000000020', null, '0023_0000000014', 'SYS_PLATFORM', '2020-03-26 14:34:37', 'umadmin', '2020-03-26 02:34:24', '37', '172.20.0.0/14_VPC_HW-ADM', '2020-03-26 10:44:24', '172.20.0.0/14', '', '0022_0000000003', '', '', '14', 'HW-ADM', '0013_0000000014', 'VPC', '', 'created', '', '', 'Y', '');
INSERT INTO `network_segment` VALUES ('0023_0000000021', null, '0023_0000000015', 'SYS_PLATFORM', '2020-03-26 14:34:38', 'umadmin', '2020-03-26 02:35:02', '37', '172.24.0.0/14_VPC_HW-DMZ', '2020-03-26 10:44:24', '172.24.0.0/14', '', '0022_0000000003', '', '', '14', 'HW-DMZ', '0013_0000000015', 'VPC', '', 'created', '', '', 'Y', '');
INSERT INTO `network_segment` VALUES ('0023_0000000022', null, '0023_0000000018', 'SYS_PLATFORM', '2020-03-26 17:20:55', 'umadmin', '2020-03-26 02:43:40', '37', '172.20.0.0/24_SUBNET_HW-ADM-APP', '2020-03-26 17:20:54', '172.20.0.0/24', '', '0022_0000000003', '0023_0000000014', '', '24', 'HW-ADM-APP', '0013_0000000018', 'SUBNET', '', 'created', '', '', null, '');
INSERT INTO `network_segment` VALUES ('0023_0000000023', null, '0023_0000000017', 'SYS_PLATFORM', '2020-03-26 17:20:55', 'umadmin', '2020-03-26 02:41:10', '37', '172.17.0.0/24_VPC_HW-SF-DB', '2020-03-26 17:20:54', '172.17.0.0/24', '', '0022_0000000003', '0023_0000000013', '', '24', 'HW-SF-DB', '0013_0000000017', 'ABC', '', 'created', '', '', null, '');
INSERT INTO `network_segment` VALUES ('0023_0000000024', null, '0023_0000000016', 'SYS_PLATFORM', '2020-03-26 17:20:55', 'umadmin', '2020-03-26 02:39:58', '37', '172.16.0.0/24_VPC_HW-SF-APP', '2020-03-26 17:20:54', '172.16.0.0/24', '', '0022_0000000003', '0023_0000000013', '', '24', 'HW-SF-APP', '0013_0000000016', 'SUBNET', '', 'created', '', '', null, '');

-- ----------------------------
-- Records of network_segment_design
-- ----------------------------
INSERT INTO `network_segment_design` VALUES ('0013_0000000001', null, '0013_0000000001', 'umadmin', '2020-03-22 05:24:40', 'umadmin', '2020-03-21 14:21:08', '34', '10.*.0.0/16_RDC|_PC', '', '10.*.0.0/16', '', '0012_0000000002', '', '16', 'PC', 'RDC', 'new', null);
INSERT INTO `network_segment_design` VALUES ('0013_0000000002', null, '0013_0000000002', 'umadmin', '2020-03-22 05:24:40', 'umadmin', '2020-03-21 14:28:53', '34', '10.*.0.0/17_VPC|PC_SF', '', '10.*.0.0/17', '', '0012_0000000002', '0013_0000000001', '17', 'SF', 'VPC', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000003', null, '0013_0000000003', 'umadmin', '2020-03-22 10:47:20', 'umadmin', '2020-03-21 14:29:42', '34', '10.*.192.0/19_VPC|PC_MGMT', '', '10.*.192.0/19', '', '0012_0000000002', '0013_0000000001', '19', 'MGMT', 'VPC', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000004', null, '0013_0000000004', 'umadmin', '2020-03-22 10:47:19', 'umadmin', '2020-03-21 14:35:52', '34', '10.*.[0,32,64,96].0/24_SUBNET|SF_SF_CS_LB', '', '10.*.[0,32,64,96].0/24', '', '0012_0000000002', '0013_0000000002', '24', 'SF_CS_LB', 'SUBNET', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000005', null, '0013_0000000005', 'umadmin', '2020-03-22 10:47:19', 'umadmin', '2020-03-21 14:36:59', '34', '10.*.[1,33,65,97].0/24_SUBNET|SF_SF_CS_APP', '', '10.*.[1,33,65,97].0/24', '', '0012_0000000002', '0013_0000000002', '24', 'SF_CS_APP', 'SUBNET', 'new', null);
INSERT INTO `network_segment_design` VALUES ('0013_0000000006', null, '0013_0000000006', 'umadmin', '2020-03-22 10:47:18', 'umadmin', '2020-03-21 14:37:58', '34', '10.*.[2,34,65,98].0/25_SUBNET|SF_SF_CS_CACHE', '', '10.*.[2,34,65,98].0/25', '', '0012_0000000002', '0013_0000000002', '25', 'SF_CS_CACHE', 'SUBNET', 'new', null);
INSERT INTO `network_segment_design` VALUES ('0013_0000000007', null, '0013_0000000007', 'umadmin', '2020-03-22 10:47:18', 'umadmin', '2020-03-21 14:38:47', '34', '10.*.[2,34,65,98].128/25_SUBNET|SF_SF_CS_RDB', '', '10.*.[2,34,65,98].128/25', '', '0012_0000000002', '0013_0000000002', '25', 'SF_CS_RDB', 'SUBNET', 'new', null);
INSERT INTO `network_segment_design` VALUES ('0013_0000000008', null, '0013_0000000008', 'umadmin', '2020-03-22 10:47:18', 'umadmin', '2020-03-21 14:40:00', '34', '10.*.[192,200,208,216].0/24_SUBNET|MGMT_MGMT_PC_VDI', '', '10.*.[192,200,208,216].0/24', '', '0012_0000000002', '0013_0000000003', '24', 'MGMT_PC_VDI', 'SUBNET', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000009', null, '0013_0000000009', 'umadmin', '2020-03-22 10:47:17', 'umadmin', '2020-03-21 14:43:39', '34', '10.*.[193,201,209,217].0/24_SUBNET|MGMT_MGMT_MT_LB', '', '10.*.[193,201,209,217].0/24', '', '0012_0000000002', '0013_0000000003', '24', 'MGMT_MT_LB', 'SUBNET', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000010', null, '0013_0000000010', 'umadmin', '2020-03-22 10:47:17', 'umadmin', '2020-03-21 14:44:47', '34', '10.*.[194,202,210,218].0/24_SUBNET|MGMT_MGMT_MT_APP', '', '10.*.[194,202,210,218].0/24', '', '0012_0000000002', '0013_0000000003', '24', 'MGMT_MT_APP', 'SUBNET', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000011', null, '0013_0000000011', 'umadmin', '2020-03-22 10:47:16', 'umadmin', '2020-03-21 14:45:49', '34', '10.*.[195,203,211,219].0/25_SUBNET|MGMT_MGMT_MT_CACHE', '', '10.*.[195,203,211,219].0/25', '', '0012_0000000002', '0013_0000000003', '25', 'MGMT_MT_CACHE', 'SUBNET', 'new', null);
INSERT INTO `network_segment_design` VALUES ('0013_0000000012', null, '0013_0000000012', 'umadmin', '2020-03-22 10:47:16', 'umadmin', '2020-03-21 14:46:41', '34', '10.*.[195,203,211,219].128/25_SUBNET|MGMT_MGMT_MT_RDB', '', '10.*.[195,203,211,219].128/25', '', '0012_0000000002', '0013_0000000003', '25', 'MGMT_MT_RDB', 'SUBNET', 'new', null);
INSERT INTO `network_segment_design` VALUES ('0013_0000000013', null, '0013_0000000013', 'umadmin', '2020-03-26 07:27:10', 'umadmin', '2020-03-26 01:33:14', '34', '172.16.0.0/14_VPC|_HW-SF', '', '172.16.0.0/14', '', '0012_0000000007', '', '14', 'HW-SF', 'VPC', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000014', null, '0013_0000000014', 'umadmin', '2020-03-26 07:27:09', 'umadmin', '2020-03-26 01:34:12', '34', '172.20.0.0/14_VPC|_HW-ADM', '', '172.20.0.0/14', '', '0012_0000000007', '', '14', 'HW-ADM', 'VPC', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000015', null, '0013_0000000015', 'umadmin', '2020-03-26 07:27:08', 'umadmin', '2020-03-26 01:35:35', '34', '172.24.0.0/14_VPC|_HW-DMZ', '', '172.24.0.0/14', '', '0012_0000000007', '', '14', 'HW-DMZ', 'VPC', 'new', 'Y');
INSERT INTO `network_segment_design` VALUES ('0013_0000000016', null, '0013_0000000016', 'umadmin', '2020-03-26 02:37:08', 'umadmin', '2020-03-26 02:37:08', '34', '172.16.0.0/24_SUBNET|HW-SF_HW-SF-APP', '', '172.16.0.0/24', '', '0012_0000000007', '0013_0000000013', '24', 'HW-SF-APP', 'SUBNET', 'new', '');
INSERT INTO `network_segment_design` VALUES ('0013_0000000017', null, '0013_0000000017', 'umadmin', '2020-03-26 16:29:00', 'umadmin', '2020-03-26 02:38:12', '34', '172.17.0.0/24_ABC|HW-SF_HW-SF-DB', '', '172.17.0.0/24', '', '0012_0000000007', '0013_0000000013', '24', 'HW-SF-DB', 'ABC', 'new', '');
INSERT INTO `network_segment_design` VALUES ('0013_0000000018', null, '0013_0000000018', 'umadmin', '2020-03-26 11:04:43', 'umadmin', '2020-03-26 02:39:19', '34', '172.20.0.0/24_SUBNET|HW-ADM_HW-ADM-APP', '', '172.20.0.0/24', '', '0012_0000000007', '0013_0000000014', '24', 'HW-ADM-APP', 'SUBNET', 'new', '');

-- ----------------------------
-- Records of network_zone
-- ----------------------------
INSERT INTO `network_zone` VALUES ('0024_0000000001', null, '0024_0000000001', 'SYS_PLATFORM', '2020-03-24 02:39:30', 'umadmin', '2020-03-21 17:27:31', '37', 'GZP_SF', '', 'SF', 'SF', '0022_0000000001', '0023_0000000002', '0014_0000000001', 'CORE', 'created');
INSERT INTO `network_zone` VALUES ('0024_0000000003', null, '0024_0000000003', 'SYS_PLATFORM', '2020-03-24 02:39:32', 'umadmin', '2020-03-21 17:42:26', '37', 'GZP_MGMT', '', 'MGMT', 'MGMT', '0022_0000000001', '0023_0000000003', '0014_0000000002', 'LINK', 'created');
INSERT INTO `network_zone` VALUES ('0024_0000000005', null, '0024_0000000005', 'umadmin', '2020-03-26 02:47:22', 'umadmin', '2020-03-26 02:47:21', '37', 'HW-GZ_HW-SF', '', 'HW-SF', '', '0022_0000000003', '0023_0000000013', '0014_0000000003', 'CORE', 'created');
INSERT INTO `network_zone` VALUES ('0024_0000000006', null, '0024_0000000006', 'umadmin', '2020-03-26 02:47:38', 'umadmin', '2020-03-26 02:47:38', '37', 'HW-GZ_HW-ADM', '', 'HW-ADM', '', '0022_0000000003', '0023_0000000014', '0014_0000000004', 'LINK', 'created');
INSERT INTO `network_zone` VALUES ('0024_0000000007', null, '0024_0000000007', 'umadmin', '2020-03-26 02:48:33', 'umadmin', '2020-03-26 02:48:11', '37', 'HW-GZ_HW-DMZ', '', 'HW-DMZ', '', '0022_0000000003', '0023_0000000015', '0014_0000000005', 'TEST', 'created');

-- ----------------------------
-- Records of network_zone_design
-- ----------------------------
INSERT INTO `network_zone_design` VALUES ('0014_0000000001', null, '0014_0000000001', 'umadmin', '2020-03-22 05:21:51', 'umadmin', '2020-03-21 14:47:47', '34', 'PCv1_SF', '', 'SF', '', '0012_0000000002', '0013_0000000002', 'CORE', 'new');
INSERT INTO `network_zone_design` VALUES ('0014_0000000002', null, '0014_0000000002', 'umadmin', '2020-03-22 05:21:51', 'umadmin', '2020-03-21 14:48:10', '34', 'PCv1_MGMT', '', 'MGMT', '', '0012_0000000002', '0013_0000000003', 'LINK', 'new');
INSERT INTO `network_zone_design` VALUES ('0014_0000000003', null, '0014_0000000003', 'umadmin', '2020-03-26 02:45:46', 'umadmin', '2020-03-26 02:45:46', '34', 'HWu0_HW-SF', '', 'HW-SF', '', '0012_0000000007', '0013_0000000013', 'CORE', 'new');
INSERT INTO `network_zone_design` VALUES ('0014_0000000004', null, '0014_0000000004', 'umadmin', '2020-03-26 02:46:21', 'umadmin', '2020-03-26 02:46:20', '34', 'HWu0_HW-ADM', '', 'HW-ADM', '', '0012_0000000007', '0013_0000000014', 'LINK', 'new');
INSERT INTO `network_zone_design` VALUES ('0014_0000000005', null, '0014_0000000005', 'umadmin', '2020-03-26 02:46:55', 'umadmin', '2020-03-26 02:46:55', '34', 'HWu0_HW-DMZ', '', 'HW-DMZ', '', '0012_0000000007', '0013_0000000015', 'TEST', 'new');

-- ----------------------------
-- Records of network_zone_link
-- ----------------------------
INSERT INTO `network_zone_link` VALUES ('0026_0000000001', null, '0026_0000000001', 'SYS_PLATFORM', '2020-03-24 02:39:40', 'umadmin', '2020-03-22 10:08:43', '37', 'GZP_MGMT_link_GZP_SF', '', 'MGMT_link_SF', '', '', '10000', '100', '0024_0000000003', '0024_0000000001', '0016_0000000001', 'PEERCONNECTION', 'created');
INSERT INTO `network_zone_link` VALUES ('0026_0000000002', null, '0026_0000000002', 'umadmin', '2020-03-26 03:10:00', 'umadmin', '2020-03-26 03:09:59', '37', 'HW-GZ_HW-SF_link_HW-GZ_HW-ADM', '', 'HW-SF_link_HW-ADM', '', '', '100', '1', '0024_0000000005', '0024_0000000006', '0016_0000000002', 'PEERCONNECTION', 'created');
INSERT INTO `network_zone_link` VALUES ('0026_0000000003', null, '0026_0000000003', 'umadmin', '2020-03-26 03:10:22', 'umadmin', '2020-03-26 03:10:22', '37', 'HW-GZ_HW-SF_link_HW-GZ_HW-SF', '', 'HW-SF_link_HW-SF', '', '', '100', '1', '0024_0000000005', '0024_0000000005', '0016_0000000003', 'NAT', 'created');

-- ----------------------------
-- Records of network_zone_link_design
-- ----------------------------
INSERT INTO `network_zone_link_design` VALUES ('0016_0000000001', null, '0016_0000000001', 'umadmin', '2020-03-22 05:24:53', 'umadmin', '2020-03-21 16:22:57', '34', 'PCv1_MGMT_link_PCv1_SF', '', 'MGMT-link-SF', '', '0014_0000000002', '0014_0000000001', 'PEERCONNECTION', 'new');
INSERT INTO `network_zone_link_design` VALUES ('0016_0000000002', null, '0016_0000000002', 'umadmin', '2020-03-26 03:08:32', 'umadmin', '2020-03-26 03:08:32', '34', 'HWu0_HW-SF_link_HWu0_HW-ADM', '', 'HW-SF-link-HW-ADM', '', '0014_0000000003', '0014_0000000004', 'PEERCONNECTION', 'new');
INSERT INTO `network_zone_link_design` VALUES ('0016_0000000003', null, '0016_0000000003', 'umadmin', '2020-03-26 03:08:47', 'umadmin', '2020-03-26 03:08:47', '34', 'HWu0_HW-SF_link_HWu0_HW-SF', '', 'HW-SF-link-HW-SF', '', '0014_0000000003', '0014_0000000003', 'NAT', 'new');

-- ----------------------------
-- Records of network_zone_route
-- ----------------------------

-- ----------------------------
-- Records of network_zone_route_design
-- ----------------------------
INSERT INTO `network_zone_route_design` VALUES ('0017_0000000001', null, '0017_0000000001', 'umadmin', '2020-03-21 16:42:03', 'umadmin', '2020-03-21 16:38:16', '34', 'PCv1_SF_to_MT_APP', '', 'PCv1_SF_to_MT_APP', '', '0013_0000000010', '0014_0000000001', '0016_0000000001', null);
INSERT INTO `network_zone_route_design` VALUES ('0017_0000000002', null, '0017_0000000002', 'umadmin', '2020-03-21 17:04:46', 'umadmin', '2020-03-21 16:40:03', '34', 'PCv1_MGMT_to_SF', '', 'PCv1_MGMT_to_SF', '', '0013_0000000002', '0014_0000000002', '0016_0000000001', null);
INSERT INTO `network_zone_route_design` VALUES ('0017_0000000003', null, '0017_0000000003', 'umadmin', '2020-03-21 16:43:12', 'umadmin', '2020-03-21 16:43:11', '34', 'PCv1_SF_to_MT_LB', '', 'PCv1_SF_to_MT_LB', '', '0013_0000000009', '0014_0000000001', '0016_0000000001', null);

-- ----------------------------
-- Records of node_type
-- ----------------------------
INSERT INTO `node_type` VALUES ('0054_0000000001', null, '0054_0000000001', 'umadmin', '2020-03-22 05:54:56', 'umadmin', '2020-03-22 05:54:56', '34', 'GROUP|逻辑分组', '', 'GROUP', '', '逻辑分组', 'new');
INSERT INTO `node_type` VALUES ('0054_0000000002', null, '0054_0000000002', 'umadmin', '2020-03-22 05:55:08', 'umadmin', '2020-03-22 05:55:08', '34', 'NODE|物理节点', '', 'NODE', '', '物理节点', 'new');

-- ----------------------------
-- Records of rdb_instance
-- ----------------------------
INSERT INTO `rdb_instance` VALUES ('0051_0000000001', null, '0051_0000000001', 'umadmin', '2020-03-22 12:15:09', 'umadmin', '2020-03-22 12:15:06', '37', 'PRD_DEMO_CORE_DB1_10.128.34.130:3306', '', 'democoredb', '', '1', '', '', null, 'democore', 'Abcd1234', '2', '3306', '0033_0000000001', '', null, 'created', '20', '0048_0000000003', null, '===');

-- ----------------------------
-- Records of rdb_resource_instance
-- ----------------------------
INSERT INTO `rdb_resource_instance` VALUES ('0033_0000000001', null, '0033_0000000001', 'umadmin', '2020-03-22 08:12:03', 'umadmin', '2020-03-22 06:58:40', '40', '10.128.34.130', '', 'mysql1', '', '', '', '0', 'POSTPAID_BY_HOUR', '0008_0000000002', '1', '', '0031_0000000007', '3306', '', '2', '10.128.34.130:3306', '3306', 'mysql1', '0010_0000000003', '0011_0000000003', '0009_0000000003', '0029_0000000013', 'created', '50', '0002_0000000002', 'root', 'Abcd1234');

-- ----------------------------
-- Records of resource_instance_spec
-- ----------------------------
INSERT INTO `resource_instance_spec` VALUES ('0010_0000000001', null, '0010_0000000001', 'umadmin', '2020-03-22 05:01:38', 'umadmin', '2020-03-22 05:01:38', '34', '1C2G|Q_1核2G', '', '1C2G', '', '0006_0000000001', 'Q_1核2G', 'new', '0002_0000000001');
INSERT INTO `resource_instance_spec` VALUES ('0010_0000000002', null, '0010_0000000002', 'umadmin', '2020-03-22 05:02:09', 'umadmin', '2020-03-22 05:02:08', '34', '2C4G|Q_2核4G', '', '2C4G', '', '0006_0000000001', 'Q_2核4G', 'new', '0002_0000000001');
INSERT INTO `resource_instance_spec` VALUES ('0010_0000000003', null, '0010_0000000003', 'umadmin', '2020-03-22 06:54:13', 'umadmin', '2020-03-22 06:54:13', '34', '2000|2G内存', '', '2000', '', '0006_0000000001', '2G内存', 'new', '0002_0000000002');
INSERT INTO `resource_instance_spec` VALUES ('0010_0000000004', null, '0010_0000000004', 'umadmin', '2020-03-22 06:54:26', 'umadmin', '2020-03-22 06:54:26', '34', '4000|4G内存', '', '4000', '', '0006_0000000001', '4G内存', 'new', '0002_0000000002');

-- ----------------------------
-- Records of resource_instance_system
-- ----------------------------
INSERT INTO `resource_instance_system` VALUES ('0011_0000000001', null, '0011_0000000001', 'umadmin', '2020-03-22 05:00:37', 'umadmin', '2020-03-22 05:00:37', '34', 'img-8toqc6s3|CentOs 7.4 64位', '', 'img-8toqc6s3', '', '0006_0000000001', 'CentOs 7.4 64位', 'new', '0002_0000000001');
INSERT INTO `resource_instance_system` VALUES ('0011_0000000002', null, '0011_0000000002', 'umadmin', '2020-03-22 05:03:08', 'umadmin', '2020-03-22 05:03:08', '34', 'img-6ns5om13|CentOs 6.8 64位', '', 'img-6ns5om13', '', '0006_0000000001', 'CentOs 6.8 64位', 'new', '0002_0000000001');
INSERT INTO `resource_instance_system` VALUES ('0011_0000000003', null, '0011_0000000003', 'umadmin', '2020-03-22 06:55:24', 'umadmin', '2020-03-22 06:55:24', '34', '5.6|MYSQL5.6', '', '5.6', '', '0006_0000000001', 'MYSQL5.6', 'new', '0002_0000000002');
INSERT INTO `resource_instance_system` VALUES ('0011_0000000004', null, '0011_0000000004', 'umadmin', '2020-03-22 06:55:41', 'umadmin', '2020-03-22 06:55:41', '34', '5.7|MYSQL5.7', '', '5.7', '', '0006_0000000001', 'MYSQL5.7', 'new', '0002_0000000002');


-- ----------------------------
-- Records of resource_instance_type
-- ----------------------------
INSERT INTO `resource_instance_type` VALUES ('0009_0000000001', null, '0009_0000000001', 'umadmin', '2020-03-22 04:59:37', 'umadmin', '2020-03-22 04:59:37', '34', 'standard|标准CVM', '', 'standard', '', '0006_0000000001', '标准CVM', 'new', '0002_0000000001');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000002', null, '0009_0000000002', 'umadmin', '2020-03-22 05:04:07', 'umadmin', '2020-03-22 05:04:07', '34', 'memory|内存型CVM', '', 'memory', '', '0006_0000000001', '内存型CVM', 'new', '0002_0000000001');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000003', null, '0009_0000000003', 'umadmin', '2020-03-22 06:41:26', 'umadmin', '2020-03-22 06:40:47', '34', '0|异步同步类型', '', '0', '', '0006_0000000001', '异步同步类型', 'new', '0002_0000000002');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000004', null, '0009_0000000004', 'umadmin', '2020-03-22 06:41:19', 'umadmin', '2020-03-22 06:41:19', '34', '2|强同步类型', '', '2', '', '0006_0000000001', '强同步类型', 'new', '0002_0000000002');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000005', null, '0009_0000000005', 'umadmin', '2020-03-22 06:42:20', 'umadmin', '2020-03-22 06:42:20', '34', '3|3.2主从类型', '', '3', '', '0006_0000000001', '3.2主从类型', 'new', '0002_0000000003');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000006', null, '0009_0000000006', 'umadmin', '2020-03-22 06:42:34', 'umadmin', '2020-03-22 06:42:34', '34', '4|3.2集群类型', '', '4', '', '0006_0000000001', '3.2集群类型', 'new', '0002_0000000003');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000007', null, '0009_0000000007', 'umadmin', '2020-03-22 06:43:20', 'umadmin', '2020-03-22 06:43:20', '34', '6|4.0主从类型', '', '6', '', '0006_0000000001', '4.0主从类型', 'new', '0002_0000000003');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000008', null, '0009_0000000008', 'umadmin', '2020-03-22 06:43:39', 'umadmin', '2020-03-22 06:43:39', '34', '7|4.0集群类型', '', '7', '', '0006_0000000001', '4.0集群类型', 'new', '0002_0000000003');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000009', null, '0009_0000000009', 'umadmin', '2020-03-22 06:49:01', 'umadmin', '2020-03-22 06:49:01', '34', 'internal_lb|内网类型', '', 'internal_lb', '', '0006_0000000001', '内网类型', 'new', '0002_0000000004');
INSERT INTO `resource_instance_type` VALUES ('0009_0000000010', null, '0009_0000000010', 'umadmin', '2020-03-22 06:49:32', 'umadmin', '2020-03-22 06:49:32', '34', 'external_lb|外网类型', '', 'external_lb', '', '0006_0000000001', '外网类型', 'new', '0002_0000000005');

-- ----------------------------
-- Records of resource_set
-- ----------------------------
INSERT INTO `resource_set` VALUES ('0029_0000000001', null, '0029_0000000001', 'umadmin', '2020-03-22 05:26:31', 'umadmin', '2020-03-21 18:17:10', '37', 'PCv1_SF_CS_1_APP1', '', '1', '', '0028_0000000001', '0007_0000000001', '', '0001_0000000001', '3', '0019_0000000001', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000002', null, '0029_0000000002', 'umadmin', '2020-03-22 05:31:50', 'umadmin', '2020-03-21 18:18:00', '37', 'PCv1_SF_CS_1_LB1', '', '1', '', '0028_0000000001', '0007_0000000004', '', '0001_0000000001', '3', '0019_0000000004', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000003', null, '0029_0000000003', 'umadmin', '2020-03-22 05:26:30', 'umadmin', '2020-03-22 04:13:25', '37', 'PCv1_SF_CS_1_RDB1', '', '1', '', '0028_0000000001', '0007_0000000002', '', '0001_0000000001', '3', '0019_0000000003', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000004', null, '0029_0000000004', 'umadmin', '2020-03-22 05:28:17', 'umadmin', '2020-03-22 05:28:17', '37', 'PCv1_SF_CS_1_CACHE1', '', '1', '', '0028_0000000001', '0007_0000000003', '', '0001_0000000001', '3', '0019_0000000002', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000005', null, '0029_0000000005', 'umadmin', '2020-03-22 05:30:54', 'umadmin', '2020-03-22 05:30:53', '37', 'PCv1_MGMT_PC_1_VDI1', '', '1', '', '0028_0000000003', '0007_0000000005', '', '0001_0000000001', '3', '0019_0000000009', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000006', null, '0029_0000000006', 'umadmin', '2020-03-22 05:31:35', 'umadmin', '2020-03-22 05:31:35', '37', 'PCv1_MGMT_MT_1_LB1', '', '1', '', '0028_0000000005', '0007_0000000004', '', '0001_0000000001', '3', '0019_0000000008', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000007', null, '0029_0000000007', 'umadmin', '2020-03-22 05:32:26', 'umadmin', '2020-03-22 05:32:26', '37', 'PCv1_MGMT_MT_1_APP1', '', '1', '', '0028_0000000005', '0007_0000000001', '', '0001_0000000001', '3', '0019_0000000005', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000008', null, '0029_0000000008', 'umadmin', '2020-03-22 05:33:13', 'umadmin', '2020-03-22 05:33:13', '37', 'PCv1_MGMT_MT_1_CACHE1', '', '1', '', '0028_0000000005', '0007_0000000003', '', '0001_0000000001', '3', '0019_0000000006', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000009', null, '0029_0000000009', 'umadmin', '2020-03-22 05:33:57', 'umadmin', '2020-03-22 05:33:57', '37', 'PCv1_MGMT_MT_1_RDB1', '', '1', '', '0028_0000000005', '0007_0000000002', '', '0001_0000000001', '3', '0019_0000000007', 'GROUP', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000010', null, '0029_0000000010', 'umadmin', '2020-03-22 05:37:48', 'umadmin', '2020-03-22 05:35:07', '37', 'PCv1_SF_CS_101_LB101', '', '101', '', '0028_0000000002', '0007_0000000004', '0029_0000000002', '0001_0000000001', '3', '0019_0000000004', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000011', null, '0029_0000000011', 'umadmin', '2020-03-22 05:37:16', 'umadmin', '2020-03-22 05:37:16', '37', 'PCv1_SF_CS_101_APP101', '', '101', '', '0028_0000000002', '0007_0000000001', '0029_0000000001', '0001_0000000001', '3', '0019_0000000001', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000012', null, '0029_0000000012', 'umadmin', '2020-03-22 05:39:22', 'umadmin', '2020-03-22 05:39:22', '37', 'PCv1_SF_CS_101_CACHE101', '', '101', '', '0028_0000000002', '0007_0000000003', '0029_0000000004', '0001_0000000001', '3', '0019_0000000002', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000013', null, '0029_0000000013', 'umadmin', '2020-03-22 05:41:28', 'umadmin', '2020-03-22 05:41:27', '37', 'PCv1_SF_CS_101_RDB101', '', '101', '', '0028_0000000002', '0007_0000000002', '0029_0000000003', '0001_0000000001', '3', '0019_0000000003', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000014', null, '0029_0000000014', 'umadmin', '2020-03-22 05:43:22', 'umadmin', '2020-03-22 05:43:21', '37', 'PCv1_MGMT_PC_101_VDI101', '', '101', '', '0028_0000000004', '0007_0000000005', '0029_0000000005', '0001_0000000001', '3', '0019_0000000009', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000015', null, '0029_0000000015', 'umadmin', '2020-03-22 06:33:08', 'umadmin', '2020-03-22 06:33:07', '37', 'PCv1_MGMT_MT_101_LB101', '', '101', '', '0028_0000000006', '0007_0000000004', '0029_0000000006', '0001_0000000001', '3', '0019_0000000008', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000016', null, '0029_0000000016', 'umadmin', '2020-03-22 06:33:45', 'umadmin', '2020-03-22 06:33:44', '37', 'PCv1_MGMT_MT_101_APP101', '', '101', '', '0028_0000000006', '0007_0000000001', '0029_0000000007', '0001_0000000001', '3', '0019_0000000005', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000017', null, '0029_0000000017', 'umadmin', '2020-03-22 06:34:16', 'umadmin', '2020-03-22 06:34:16', '37', 'PCv1_MGMT_MT_101_CACHE101', '', '101', '', '0028_0000000006', '0007_0000000003', '0029_0000000008', '0001_0000000001', '3', '0019_0000000006', 'NODE', 'created');
INSERT INTO `resource_set` VALUES ('0029_0000000018', null, '0029_0000000018', 'umadmin', '2020-03-22 06:34:49', 'umadmin', '2020-03-22 06:34:49', '37', 'PCv1_MGMT_MT_101_RDB101', '', '101', '', '0028_0000000006', '0007_0000000002', '0029_0000000009', '0001_0000000001', '3', '0019_0000000007', 'NODE', 'created');

-- ----------------------------
-- Records of resource_set$deploy_environment
-- ----------------------------
INSERT INTO `resource_set$deploy_environment` VALUES ('11', '0029_0000000003', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('13', '0029_0000000001', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('15', '0029_0000000004', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('16', '0029_0000000005', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('17', '0029_0000000006', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('18', '0029_0000000002', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('19', '0029_0000000007', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('20', '0029_0000000008', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('21', '0029_0000000009', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('23', '0029_0000000011', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('24', '0029_0000000010', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('25', '0029_0000000012', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('26', '0029_0000000013', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('27', '0029_0000000014', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('28', '0029_0000000015', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('29', '0029_0000000016', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('30', '0029_0000000017', '0003_0000000001', '1');
INSERT INTO `resource_set$deploy_environment` VALUES ('31', '0029_0000000018', '0003_0000000001', '1');

-- ----------------------------
-- Records of resource_set$network_segment
-- ----------------------------
INSERT INTO `resource_set$network_segment` VALUES ('7', '0029_0000000003', '0023_0000000007', '1');
INSERT INTO `resource_set$network_segment` VALUES ('9', '0029_0000000001', '0023_0000000005', '1');
INSERT INTO `resource_set$network_segment` VALUES ('11', '0029_0000000004', '0023_0000000006', '1');
INSERT INTO `resource_set$network_segment` VALUES ('12', '0029_0000000005', '0023_0000000008', '1');
INSERT INTO `resource_set$network_segment` VALUES ('13', '0029_0000000006', '0023_0000000009', '1');
INSERT INTO `resource_set$network_segment` VALUES ('14', '0029_0000000002', '0023_0000000004', '1');
INSERT INTO `resource_set$network_segment` VALUES ('15', '0029_0000000007', '0023_0000000010', '1');
INSERT INTO `resource_set$network_segment` VALUES ('16', '0029_0000000008', '0023_0000000011', '1');
INSERT INTO `resource_set$network_segment` VALUES ('17', '0029_0000000009', '0023_0000000012', '1');
INSERT INTO `resource_set$network_segment` VALUES ('19', '0029_0000000011', '0023_0000000005', '1');
INSERT INTO `resource_set$network_segment` VALUES ('20', '0029_0000000010', '0023_0000000004', '1');
INSERT INTO `resource_set$network_segment` VALUES ('21', '0029_0000000012', '0023_0000000006', '1');
INSERT INTO `resource_set$network_segment` VALUES ('22', '0029_0000000013', '0023_0000000007', '1');
INSERT INTO `resource_set$network_segment` VALUES ('23', '0029_0000000014', '0023_0000000008', '1');
INSERT INTO `resource_set$network_segment` VALUES ('24', '0029_0000000015', '0023_0000000009', '1');
INSERT INTO `resource_set$network_segment` VALUES ('25', '0029_0000000016', '0023_0000000010', '1');
INSERT INTO `resource_set$network_segment` VALUES ('26', '0029_0000000017', '0023_0000000011', '1');
INSERT INTO `resource_set$network_segment` VALUES ('27', '0029_0000000018', '0023_0000000012', '1');

-- ----------------------------
-- Records of resource_set_design
-- ----------------------------
INSERT INTO `resource_set_design` VALUES ('0019_0000000001', null, '0019_0000000001', 'umadmin', '2020-03-22 05:23:15', 'umadmin', '2020-03-21 15:05:09', '34', 'PCv1_SF_CS_APP', '', 'APP', '', '0018_0000000001', '0013_0000000005', 'new', '0002_0000000001');
INSERT INTO `resource_set_design` VALUES ('0019_0000000002', null, '0019_0000000002', 'umadmin', '2020-03-22 05:23:14', 'umadmin', '2020-03-21 15:06:14', '34', 'PCv1_SF_CS_CACHE', '', 'CACHE', '', '0018_0000000001', '0013_0000000006', 'new', '0002_0000000003');
INSERT INTO `resource_set_design` VALUES ('0019_0000000003', null, '0019_0000000003', 'umadmin', '2020-03-22 05:23:14', 'umadmin', '2020-03-21 15:06:27', '34', 'PCv1_SF_CS_RDB', '', 'RDB', '', '0018_0000000001', '0013_0000000007', 'new', '0002_0000000002');
INSERT INTO `resource_set_design` VALUES ('0019_0000000004', null, '0019_0000000004', 'umadmin', '2020-03-22 05:23:14', 'umadmin', '2020-03-21 15:07:05', '34', 'PCv1_SF_CS_LB', '', 'LB', '', '0018_0000000001', '0013_0000000004', 'new', '0002_0000000004');
INSERT INTO `resource_set_design` VALUES ('0019_0000000005', null, '0019_0000000005', 'umadmin', '2020-03-22 05:23:13', 'umadmin', '2020-03-21 15:07:38', '34', 'PCv1_MGMT_MT_APP', '', 'APP', '', '0018_0000000002', '0013_0000000010', 'new', '0002_0000000001');
INSERT INTO `resource_set_design` VALUES ('0019_0000000006', null, '0019_0000000006', 'umadmin', '2020-03-22 05:23:13', 'umadmin', '2020-03-21 15:07:59', '34', 'PCv1_MGMT_MT_CACHE', '', 'CACHE', '', '0018_0000000002', '0013_0000000011', 'new', '0002_0000000003');
INSERT INTO `resource_set_design` VALUES ('0019_0000000007', null, '0019_0000000007', 'umadmin', '2020-03-22 05:23:13', 'umadmin', '2020-03-21 15:08:21', '34', 'PCv1_MGMT_MT_RDB', '', 'RDB', '', '0018_0000000002', '0013_0000000012', 'new', '0002_0000000002');
INSERT INTO `resource_set_design` VALUES ('0019_0000000008', null, '0019_0000000008', 'umadmin', '2020-03-22 05:23:13', 'umadmin', '2020-03-21 15:09:26', '34', 'PCv1_MGMT_MT_LB', '', 'LB', '', '0018_0000000002', '0013_0000000009', 'new', '0002_0000000004');
INSERT INTO `resource_set_design` VALUES ('0019_0000000009', null, '0019_0000000009', 'umadmin', '2020-03-22 05:23:12', 'umadmin', '2020-03-21 15:58:09', '34', 'PCv1_MGMT_PC_VDI', '', 'VDI', '', '0018_0000000003', '0013_0000000008', 'new', '0002_0000000006');

-- ----------------------------
-- Records of resource_set_invoke_design
-- ----------------------------
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000001', null, '0021_0000000001', 'umadmin', '2020-03-22 05:23:36', 'umadmin', '2020-03-21 15:59:21', '34', 'PCv1_MGMT_PC_VDI_access_PCv1_MGMT_MT_LB', '', 'VDI-LB', '', '0019_0000000008', '0019_0000000009', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000002', null, '0021_0000000002', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:01:11', '34', 'PCv1_MGMT_PC_VDI_access_PCv1_SF_CS_LB', '', 'VDI-LB', '', '0019_0000000004', '0019_0000000009', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000003', null, '0021_0000000003', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:01:38', '34', 'PCv1_MGMT_MT_APP_access_PCv1_MGMT_MT_CACHE', '', 'APP-CACHE', '', '0019_0000000006', '0019_0000000005', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000004', null, '0021_0000000004', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:01:52', '34', 'PCv1_MGMT_MT_APP_access_PCv1_MGMT_MT_RDB', '', 'APP-RDB', '', '0019_0000000007', '0019_0000000005', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000005', null, '0021_0000000005', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:02:01', '34', 'PCv1_MGMT_MT_LB_access_PCv1_MGMT_MT_APP', '', 'LB-APP', '', '0019_0000000005', '0019_0000000008', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000006', null, '0021_0000000006', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:02:26', '34', 'PCv1_SF_CS_APP_access_PCv1_SF_CS_CACHE', '', 'APP-CACHE', '', '0019_0000000002', '0019_0000000001', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000007', null, '0021_0000000007', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:02:40', '34', 'PCv1_SF_CS_APP_access_PCv1_SF_CS_RDB', '', 'APP-RDB', '', '0019_0000000003', '0019_0000000001', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000008', null, '0021_0000000008', 'umadmin', '2020-03-22 05:23:35', 'umadmin', '2020-03-21 16:02:57', '34', 'PCv1_SF_CS_LB_access_PCv1_SF_CS_APP', '', 'LB-APP', '', '0019_0000000001', '0019_0000000004', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000009', null, '0021_0000000009', 'umadmin', '2020-03-23 18:03:36', 'umadmin', '2020-03-23 18:03:35', '34', 'PCv1_SF_CS_APP_access_PCv1_SF_CS_LB', '', 'APP-LB', '', '0019_0000000004', '0019_0000000001', 'new');
INSERT INTO `resource_set_invoke_design` VALUES ('0021_0000000010', null, '0021_0000000010', 'umadmin', '2020-03-23 18:03:45', 'umadmin', '2020-03-23 18:03:45', '34', 'PCv1_MGMT_MT_APP_access_PCv1_MGMT_MT_LB', '', 'APP-LB', '', '0019_0000000008', '0019_0000000005', 'new');

-- ----------------------------
-- Records of route
-- ----------------------------
INSERT INTO `route` VALUES ('0030_0000000001', null, '0030_0000000001', 'SYS_PLATFORM', '2020-03-24 02:40:56', 'umadmin', '2020-03-22 10:30:33', '37', '10.128.0.0/17_VPC_GZP_SF---to---10.128.202.0/24_SUBNET_GZP2_MGMT_MT_APP', '', 'GZP_SF---to---GZP2_MGMT_MT_APP', '', '', '0023_0000000010', '0023_0000000002', '0026_0000000001', '0020_0000000004', 'created');
INSERT INTO `route` VALUES ('0030_0000000002', null, '0030_0000000002', 'umadmin', '2020-03-24 01:53:46', 'umadmin', '2020-03-22 10:32:52', '37', '10.128.202.0/24_SUBNET_GZP2_MGMT_MT_APP---to---10.128.0.0/17_VPC_GZP_SF', '', 'GZP2_MGMT_MT_APP---to---GZP_SF', '', '', '0023_0000000002', '0023_0000000010', '0026_0000000001', '0020_0000000003', 'created');
INSERT INTO `route` VALUES ('0030_0000000003', null, '0030_0000000003', 'umadmin', '2020-03-24 01:53:47', 'umadmin', '2020-03-22 10:38:09', '37', '10.128.32.0/24_SUBNET_GZP2_SF_CS_LB---to---10.128.192.0/19_VPC_GZP_MGMT', '', 'GZP2_SF_CS_LB---to---GZP_MGMT', '', '', '0023_0000000003', '0023_0000000004', '0026_0000000001', '0020_0000000002', 'created');
INSERT INTO `route` VALUES ('0030_0000000004', null, '0030_0000000004', 'SYS_PLATFORM', '2020-03-24 02:40:57', 'umadmin', '2020-03-22 10:38:19', '37', '10.128.192.0/19_VPC_GZP_MGMT---to---10.128.32.0/24_SUBNET_GZP2_SF_CS_LB', '', 'GZP_MGMT---to---GZP2_SF_CS_LB', '', '', '0023_0000000004', '0023_0000000003', '0026_0000000001', '0020_0000000001', 'created');
INSERT INTO `route` VALUES ('0030_0000000005', null, '0030_0000000005', 'umadmin', '2020-03-26 10:42:40', 'umadmin', '2020-03-26 08:04:57', '37', '172.16.0.0/14_VPC_HW-SF---to---172.20.0.0/14_VPC_HW-ADM', '', 'HW-SF---to---HW-ADM', '', '', '0023_0000000014', '0023_0000000013', '0026_0000000002', '0020_0000000005', 'created');
INSERT INTO `route` VALUES ('0030_0000000006', null, '0030_0000000006', 'umadmin', '2020-03-26 10:42:40', 'umadmin', '2020-03-26 08:05:13', '37', '172.20.0.0/14_VPC_HW-ADM---to---172.16.0.0/14_VPC_HW-SF', '', 'HW-ADM---to---HW-SF', '', '', '0023_0000000013', '0023_0000000014', '0026_0000000002', '0020_0000000006', 'created');

-- ----------------------------
-- Records of route_design
-- ----------------------------
INSERT INTO `route_design` VALUES ('0020_0000000001', null, '0020_0000000001', 'umadmin', '2020-03-22 10:47:20', 'umadmin', '2020-03-22 10:11:58', '34', 'MGMT---to---SF_CS_LB', '', 'MGMT---to---SF_CS_LB', '', '0013_0000000004', '0016_0000000001', '0013_0000000003', 'new');
INSERT INTO `route_design` VALUES ('0020_0000000002', null, '0020_0000000002', 'umadmin', '2020-03-22 10:47:20', 'umadmin', '2020-03-22 10:12:26', '34', 'SF_CS_LB---to---MGMT', '', 'SF_CS_LB---to---MGMT', '', '0013_0000000003', '0016_0000000001', '0013_0000000004', 'new');
INSERT INTO `route_design` VALUES ('0020_0000000003', null, '0020_0000000003', 'umadmin', '2020-03-22 10:47:17', 'umadmin', '2020-03-22 10:13:07', '34', 'MGMT_MT_APP---to---SF', '', 'MGMT_MT_APP---to---SF', '', '0013_0000000002', '0016_0000000001', '0013_0000000010', 'new');
INSERT INTO `route_design` VALUES ('0020_0000000004', null, '0020_0000000004', 'umadmin', '2020-03-22 10:47:17', 'umadmin', '2020-03-22 10:13:26', '34', 'SF---to---MGMT_MT_APP', '', 'SF---to---MGMT_MT_APP', '', '0013_0000000010', '0016_0000000001', '0013_0000000002', 'new');
INSERT INTO `route_design` VALUES ('0020_0000000005', null, '0020_0000000005', 'umadmin', '2020-03-26 07:58:50', 'umadmin', '2020-03-26 07:58:49', '34', 'HW-SF---to---HW-ADM', '', 'HW-SF---to---HW-ADM', '', '0013_0000000014', '0016_0000000002', '0013_0000000013', 'new');
INSERT INTO `route_design` VALUES ('0020_0000000006', null, '0020_0000000006', 'umadmin', '2020-03-26 07:59:17', 'umadmin', '2020-03-26 07:59:17', '34', 'HW-ADM---to---HW-SF', '', 'HW-ADM---to---HW-SF', '', '0013_0000000013', '0016_0000000002', '0013_0000000014', 'new');

-- ----------------------------
-- Records of service_design
-- ----------------------------
INSERT INTO `service_design` VALUES ('0041_0000000001', null, '0041_0000000001', 'umadmin', '2020-03-23 18:22:12', 'umadmin', '2020-03-22 07:30:35', '34', 'DEMO_CORE_APP_S100001|登录', '2020-03-23 18:21:37', 'S100001', '', '登录', '同步请求', '查询类', '直连服务', 'new', '0039_0000000001');

-- ----------------------------
-- Records of service_invoke_design
-- ----------------------------
INSERT INTO `service_invoke_design` VALUES ('0042_0000000001', null, '0042_0000000001', 'umadmin', '2020-03-24 06:19:17', 'umadmin', '2020-03-22 07:31:09', '34', 'DEMO_CLIENT_BROWER_invoke_DEMO_CORE_APP_S100001|登录', '2020-03-23 18:21:37', 'BROWER-APP|登录', '', '0039_0000000001', '0039_0000000004', '0041_0000000001', 'new');

-- ----------------------------
-- Records of service_invoke_seq_design
-- ----------------------------

-- ----------------------------
-- Records of service_invoke_seq_design$service_invoke_design_sequence
-- ----------------------------

-- ----------------------------
-- Records of subsys
-- ----------------------------
INSERT INTO `subsys` VALUES ('0047_0000000001', null, '0047_0000000001', 'umadmin', '2020-03-22 07:41:53', 'umadmin', '2020-03-22 07:41:52', '37', 'PRD_DEMO_CORE', '', 'CORE', '', '0001_0000000001', 'created', '0038_0000000001', '0046_0000000001');
INSERT INTO `subsys` VALUES ('0047_0000000002', null, '0047_0000000002', 'umadmin', '2020-03-22 07:42:03', 'umadmin', '2020-03-22 07:42:02', '37', 'PRD_DEMO_CLIENT', '', 'CLIENT', '', '0001_0000000001', 'created', '0038_0000000002', '0046_0000000001');

-- ----------------------------
-- Records of subsys$business_zone
-- ----------------------------
INSERT INTO `subsys$business_zone` VALUES ('1', '0047_0000000001', '0028_0000000002', '1');
INSERT INTO `subsys$business_zone` VALUES ('2', '0047_0000000002', '0028_0000000004', '1');

-- ----------------------------
-- Records of subsys_design
-- ----------------------------
INSERT INTO `subsys_design` VALUES ('0038_0000000001', null, '0038_0000000001', 'umadmin', '2020-03-23 18:21:47', 'umadmin', '2020-03-22 07:03:18', '34', 'DEMO_CORE', '2020-03-23 18:21:37', 'CORE', '', '核心子系统', 'new', '123456', '0037_0000000001');
INSERT INTO `subsys_design` VALUES ('0038_0000000002', null, '0038_0000000002', 'umadmin', '2020-03-23 18:21:46', 'umadmin', '2020-03-22 07:06:50', '34', 'DEMO_CLIENT', '2020-03-23 18:21:37', 'CLIENT', '', '客户端子系统', 'new', '123333', '0037_0000000001');

-- ----------------------------
-- Records of subsys_design$business_zone_design
-- ----------------------------
INSERT INTO `subsys_design$business_zone_design` VALUES ('3', '0038_0000000001', '0018_0000000001', '1');
INSERT INTO `subsys_design$business_zone_design` VALUES ('4', '0038_0000000002', '0018_0000000003', '1');

-- ----------------------------
-- Records of unit
-- ----------------------------
INSERT INTO `unit` VALUES ('0048_0000000001', null, '0048_0000000001', 'umadmin', '2020-03-23 07:27:57', 'umadmin', '2020-03-22 08:03:58', '37', 'PRD_DEMO_CORE_LB1', '', '1', '', '/data/PRD_DEMO_CORE_LB1', '0001_0000000001', '', '0029_0000000010', '', 'created', '0047_0000000001', '0039_0000000003', '0002_0000000004');
INSERT INTO `unit` VALUES ('0048_0000000002', null, '0048_0000000002', 'umadmin', '2020-03-23 07:27:57', 'umadmin', '2020-03-22 08:08:05', '37', 'PRD_DEMO_CORE_APP1', '', '1', '', '/data/PRD_DEMO_CORE_APP1', '0001_0000000001', '', '0029_0000000011', '', 'created', '0047_0000000001', '0039_0000000001', '0002_0000000001');
INSERT INTO `unit` VALUES ('0048_0000000003', null, '0048_0000000003', 'umadmin', '2020-03-23 07:26:14', 'umadmin', '2020-03-22 08:08:22', '37', 'PRD_DEMO_CORE_DB1', '', '1', '', '/data/PRD_DEMO_CORE_DB1', '0001_0000000001', '', '0029_0000000013', '', 'created', '0047_0000000001', '0039_0000000002', '0002_0000000002');
INSERT INTO `unit` VALUES ('0048_0000000004', null, '0048_0000000004', 'umadmin', '2020-03-24 06:19:17', 'umadmin', '2020-03-22 08:08:36', '37', 'PRD_DEMO_CLIENT_BROWER1', '', '1', '', '/data/PRD_DEMO_CLIENT_BROWER1', '0001_0000000001', '', '0029_0000000014', '', 'created', '0047_0000000002', '0039_0000000004', '0002_0000000006');

-- ----------------------------
-- Records of unit$deploy_package
-- ----------------------------

-- ----------------------------
-- Records of unit_design
-- ----------------------------
INSERT INTO `unit_design` VALUES ('0039_0000000001', null, '0039_0000000001', 'umadmin', '2020-03-23 18:22:00', 'umadmin', '2020-03-22 07:07:45', '34', 'DEMO_CORE_APP', '2020-03-23 18:21:37', 'APP', '', 'Y', '程序', 'TCP', '0019_0000000001', 'new', '0038_0000000001', '0002_0000000001');
INSERT INTO `unit_design` VALUES ('0039_0000000002', null, '0039_0000000002', 'umadmin', '2020-03-23 18:21:59', 'umadmin', '2020-03-22 07:14:17', '34', 'DEMO_CORE_DB', '2020-03-23 18:21:37', 'DB', '', 'Y', '数据库', 'TCP', '0019_0000000003', 'new', '0038_0000000001', '0002_0000000002');
INSERT INTO `unit_design` VALUES ('0039_0000000003', null, '0039_0000000003', 'umadmin', '2020-03-23 18:21:58', 'umadmin', '2020-03-22 07:14:45', '34', 'DEMO_CORE_LB', '2020-03-23 18:21:37', 'LB', '', 'Y', '负载均衡', 'TCP', '0019_0000000004', 'new', '0038_0000000001', '0002_0000000004');
INSERT INTO `unit_design` VALUES ('0039_0000000004', null, '0039_0000000004', 'umadmin', '2020-03-24 06:19:52', 'umadmin', '2020-03-22 07:15:19', '34', 'DEMO_CLIENT_BROWER', '2020-03-23 18:21:37', 'BROWER', '', 'Y', 'WEB端', 'TCP', '0019_0000000009', 'new', '0038_0000000002', '0002_0000000006');

-- ----------------------------
-- Records of unit_type
-- ----------------------------
INSERT INTO `unit_type` VALUES ('0002_0000000001', null, '0002_0000000001', 'umadmin', '2020-03-21 14:58:20', 'umadmin', '2020-03-21 14:58:20', '34', 'TOMCAT|TOMCAT', '', 'TOMCAT', '', 'TOMCAT', null);
INSERT INTO `unit_type` VALUES ('0002_0000000002', null, '0002_0000000002', 'umadmin', '2020-03-21 14:58:38', 'umadmin', '2020-03-21 14:58:38', '34', 'MYSQL|MYSQL', '', 'MYSQL', '', 'MYSQL', null);
INSERT INTO `unit_type` VALUES ('0002_0000000003', null, '0002_0000000003', 'umadmin', '2020-03-21 14:58:51', 'umadmin', '2020-03-21 14:58:51', '34', 'REDIS|REDIS', '', 'REDIS', '', 'REDIS', null);
INSERT INTO `unit_type` VALUES ('0002_0000000004', null, '0002_0000000004', 'umadmin', '2020-03-21 15:01:34', 'umadmin', '2020-03-21 14:59:41', '34', 'INSLB|内网LB', '', 'INSLB', '', '内网LB', null);
INSERT INTO `unit_type` VALUES ('0002_0000000005', null, '0002_0000000005', 'umadmin', '2020-03-21 15:01:53', 'umadmin', '2020-03-21 15:01:53', '34', 'OUTLB|外网LB', '', 'OUTLB', '', '外网LB', null);
INSERT INTO `unit_type` VALUES ('0002_0000000006', null, '0002_0000000006', 'umadmin', '2020-03-21 15:57:59', 'umadmin', '2020-03-21 15:57:59', '34', 'VDI|虚拟桌面', '', 'VDI', '', '虚拟桌面', null);

SET FOREIGN_KEY_CHECKS=1;
