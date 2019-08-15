DROP TABLE IF EXISTS `wb_system`;
CREATE TABLE `wb_system` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `system_id` varchar(15) DEFAULT NULL COMMENT 'System ID',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `state` int(11) DEFAULT NULL COMMENT 'State',
  `system_type` int(11) DEFAULT NULL COMMENT 'System Type',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `key_name` varchar(500) NOT NULL COMMENT '唯一值',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_system_name_en` (`name_en`),
  KEY `wb_system_system_id` (`system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wb_system` (`name_en`, `name_cn`, `system_id`, `description`, `system_type`, `guid`, `updated_by`, `updated_date`, `created_by`, `created_date`,`key_name`,`r_guid`,`state`) VALUES
	('Bank system', '银行系统', null, 'Bank system', 554, '0002_0000000001', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(),'Bank system','0002_0000000001',34),
	('Public system', '公共系统', '0002_0000000001', 'Functional system', 555, '0002_0000000002', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(),'public system','0002_0000000002',34);
	
DROP TABLE IF EXISTS `wb_sub_system`;
CREATE TABLE `wb_sub_system` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `system_id` varchar(15) DEFAULT NULL COMMENT 'System ID',
  `zone_id` varchar(15) DEFAULT NULL COMMENT 'Zone ID',
  `state` int(11) DEFAULT NULL COMMENT 'State',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_sub_system_name_en` (`name_en`),
  KEY `wb_sub_system_system_id` (`system_id`),
  KEY `wb_sub_system_zone_id` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wb_sub_system` (`name_en`, `system_id`, `zone_id`, `state`, `name_cn`, `description`, `guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `r_guid`) VALUES
	('Deposite system', '0002_0000000001', '1', 34, '存款系统', 'Deposite system', '0003_0000000001', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(),'0003_0000000001'),
	('Subsystem1', '0002_0000000001', '1', 34, '子系统1', 'Subsystem1', '0003_0000000002', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000002'),
	('Subsystem2', '0002_0000000001', '1', 34, '子系统2', 'Subsystem2', '0003_0000000003', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000003'),
	('Subsystem3', '0002_0000000001', '1', 34, '子系统3', 'Subsystem3', '0003_0000000004', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000004'),
	('Subsystem4', '0002_0000000001', '1', 34, '子系统4', 'Subsystem4', '0003_0000000005', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000005'),
	('Subsystem5', '0002_0000000001', '1', 34, '子系统5', 'Subsystem5', '0003_0000000006', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000006'),
	('Subsystem6', '0002_0000000001', '1', 34, '子系统6', 'Subsystem6', '0003_0000000007', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000007'),
	('Subsystem7', '0002_0000000001', '1', 34, '子系统7', 'Subsystem7', '0003_0000000008', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000008'),
	('Subsystem8', '0002_0000000001', '1', 34, '子系统8', 'Subsystem8', '0003_0000000009', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000009'),
	('Subsystem9', '0002_0000000001', '1', 34, '子系统9', 'Subsystem9', '0003_0000000010', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000010'),
	('Subsystem10', '0002_0000000001', '1', 34, '子系统10', 'Subsystem10', '0003_0000000011', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000011'),
	('Subsystem11', '0002_0000000001', '1', 34, '子系统11', 'Subsystem11', '0003_0000000012', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0003_0000000012');


DROP TABLE IF EXISTS `wb_zone`;
CREATE TABLE `wb_zone` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `zone_type` int(11) DEFAULT NULL COMMENT 'Zone Type',
  `idc_min` int(2) DEFAULT NULL COMMENT 'IDC Min',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_zone_name_en` (`name_en`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wb_zone` (`guid`, `description`, `key_name`, `updated_by`, `updated_date`, `created_by`, `created_date`, `idc_min`, `name_en`, `zone_type`, `r_guid`) VALUES
  ('1', 'zone', 'zone_cd_sf', 'umadmin', CURRENT_TIMESTAMP() , NULL, CURRENT_TIMESTAMP() , '1', 'zone_cd_sf', 1, '1');


DROP TABLE IF EXISTS `wb_unit`;
CREATE TABLE `wb_unit` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `subsystem_id` varchar(15) DEFAULT NULL COMMENT 'Sub-System ID',
  `state` int(11) DEFAULT NULL COMMENT 'State',
  `unit_type` int(11) DEFAULT NULL COMMENT 'Unit Type',
  `software` int(11) DEFAULT NULL COMMENT 'Software',
  `version` varchar(45) DEFAULT NULL COMMENT 'Version',
  `cluster` int(11) DEFAULT NULL COMMENT 'Cluster',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_unit_name_en` (`name_en`),
  KEY `wb_unit_subsystem_id` (`subsystem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wb_unit` (`name_en`, `name_cn`, `subsystem_id`, `state`, `unit_type`, `software`, `version`, `cluster`, `description`, `guid`, `updated_by`, `updated_date`, `created_by`, `created_date`, `r_guid`) VALUES
	('Test Unit 1', 'Test Unit 1', '0003_0000000001', 560, null, null, '1', null, 'test', '0005_00000001', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0005_00000001'),
	('Test Unit 2', 'Test Unit 2', '0003_0000000001', 561, null, null, '1', null, 'test', '0005_00000002', 'umadmin', CURRENT_TIMESTAMP(), 'umadmin', CURRENT_TIMESTAMP(), '0005_00000002');


DROP TABLE IF EXISTS `wb_service`;
CREATE TABLE `wb_service` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `unit_id` varchar(15) DEFAULT NULL COMMENT 'Unit ID',
  `port` varchar(5) DEFAULT NULL COMMENT 'Port',
  `invokable` int(11) DEFAULT NULL COMMENT 'Invokable',
  `service_type` int(11) DEFAULT NULL COMMENT 'Service Type',
  `context` int(11) DEFAULT NULL COMMENT 'Context',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_service_name_en` (`name_en`),
  UNIQUE KEY `wb_service_service_type` (`service_type`),
  KEY `wb_service_unit_id` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_invoke_relation`;
CREATE TABLE `wb_invoke_relation` (
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `service_id` varchar(15) DEFAULT NULL COMMENT 'Service ID',
  `invoked_service_id` varchar(15) DEFAULT NULL COMMENT 'Invoked Service ID',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  KEY `wb_invoke_relation_service_id` (`service_id`),
  KEY `wb_invoke_relation_invoked_service_id` (`invoked_service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_idc`;
CREATE TABLE `wb_idc` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `city` int(11) DEFAULT NULL COMMENT 'City',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `address` int(11) DEFAULT NULL COMMENT 'Address',
  `capacity` int(10) DEFAULT NULL COMMENT 'Capacity',
  `idc_type` int(11) DEFAULT NULL COMMENT 'IDC Type',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_idc_name_en` (`name_en`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_dcn`;
CREATE TABLE `wb_dcn` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `zone_id` varchar(15) DEFAULT NULL COMMENT 'Zone ID',
  `dcn_type` int(11) DEFAULT NULL COMMENT 'DCN Type',
  `idc_min` int(2) DEFAULT NULL COMMENT 'IDC Min',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_dcn_name_en` (`name_en`),
  KEY `wb_dcn_zone_id` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_zone_link`;
CREATE TABLE `wb_zone_link` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `zone_a_id` varchar(15) DEFAULT NULL COMMENT 'Zone A ID',
  `zone_b_id` varchar(15) DEFAULT NULL COMMENT 'Zone B ID',
  `zone_link_type` int(11) DEFAULT NULL COMMENT 'Zone Link Type',
  `idc_min` int(2) DEFAULT NULL COMMENT 'IDC Min',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_zone_link_name_en` (`name_en`),
  KEY `wb_zone_link_zone_a_id` (`zone_a_id`),
  KEY `wb_zone_link_zone_b_id` (`zone_b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_set`;
CREATE TABLE `wb_set` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `dcn_id` varchar(15) DEFAULT NULL COMMENT 'DCN ID',
  `set_type` int(11) DEFAULT NULL COMMENT 'SET Type',
  `idc_min` int(2) DEFAULT NULL COMMENT 'IDC Min',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_set_name_en` (`name_en`),
  KEY `wb_set_dcn_id` (`dcn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_set_node`;
CREATE TABLE `wb_set_node` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `idc_id` varchar(15) DEFAULT NULL COMMENT 'IDC ID',
  `set_id` varchar(15) DEFAULT NULL COMMENT 'SET ID',
  `set_node_type` int(11) DEFAULT NULL COMMENT 'SET Node Type',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `os_max` int(5) DEFAULT NULL COMMENT 'OS Max',
  `os_min` int(5) DEFAULT NULL COMMENT 'OS Min',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_set_node_name_en` (`name_en`),
  KEY `wb_set_node_idc_id` (`idc_id`),
  KEY `wb_set_node_set_id` (`set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_dcn_node`;
CREATE TABLE `wb_dcn_node` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `idc_id` varchar(15) DEFAULT NULL COMMENT 'IDC ID',
  `dcn_id` varchar(15) DEFAULT NULL COMMENT 'DCN ID',
  `dcn_node_type` int(11) DEFAULT NULL COMMENT 'DCN Node Type',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_dcn_node_name_en` (`name_en`),
  KEY `wb_dcn_node_idc_id` (`idc_id`),
  KEY `wb_dcn_node_dcn_id` (`dcn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_zone_node`;
CREATE TABLE `wb_zone_node` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `name_cn` varchar(45) DEFAULT NULL COMMENT 'Chinese Name',
  `zone_id` varchar(15) DEFAULT NULL COMMENT 'Zone ID',
  `idc_id` varchar(15) DEFAULT NULL COMMENT 'IDC ID',
  `zone_node_type` int(11) DEFAULT NULL COMMENT 'Zone Node Type',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_zone_node_name_en` (`name_en`),
  KEY `wb_zone_node_zone_id` (`zone_id`),
  KEY `wb_zone_node_idc_id` (`idc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_zone_node_link`;
CREATE TABLE `wb_zone_node_link` (
  `name_en` varchar(45) DEFAULT NULL COMMENT 'English Name',
  `zone_node_a_id` varchar(15) DEFAULT NULL COMMENT 'Zone Node A ID',
  `zone_node_b_id` varchar(15) DEFAULT NULL COMMENT 'Zone Node B ID',
  `zone_node_link_type` int(11) DEFAULT NULL COMMENT 'Zone Node Link Type',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_zone_node_link_name_en` (`name_en`),
  KEY `wb_zone_node_link_zone_node_a_id` (`zone_node_a_id`),
  KEY `wb_zone_node_link_zone_node_b_id` (`zone_node_b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_ip_segment`;
CREATE TABLE `wb_ip_segment` (
  `name` varchar(45) DEFAULT NULL COMMENT 'Name',
  `mask` int(11) DEFAULT NULL COMMENT 'Mask',
  `ip_segment_id` varchar(15) DEFAULT NULL COMMENT 'IP Segment ID',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `begin` varchar(45) DEFAULT NULL COMMENT 'Begin',
  `end` varchar(45) DEFAULT NULL COMMENT 'End',
  `zone_node_id` varchar(15) DEFAULT NULL COMMENT 'Zone Node ID',
  `dcn_node_id` varchar(15) DEFAULT NULL COMMENT 'DCN Node ID',
  `set_node_id` varchar(15) DEFAULT NULL COMMENT 'SET Node ID',
  `idc_id` varchar(15) DEFAULT NULL COMMENT 'IDC ID',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `wb_ip_segment_name` (`name`),
  UNIQUE KEY `wb_ip_segment_mask` (`mask`),
  KEY `wb_ip_segment_ip_segment_id` (`ip_segment_id`),
  KEY `wb_ip_segment_zone_node_id` (`zone_node_id`),
  KEY `wb_ip_segment_dcn_node_id` (`dcn_node_id`),
  KEY `wb_ip_segment_set_node_id` (`set_node_id`),
  KEY `wb_ip_segment_idc_id` (`idc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_os`;
CREATE TABLE `wb_os` (
  `name` varchar(100) DEFAULT NULL COMMENT 'Name',
  `set_node_id` varchar(15) DEFAULT NULL COMMENT 'SET Node ID',
  `os_type` int(11) DEFAULT NULL COMMENT 'OS Type',
  `version` int(11) DEFAULT NULL COMMENT 'Version',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `core_num` int(5) DEFAULT NULL COMMENT 'Core Num',
  `mem_num` int(5) DEFAULT NULL COMMENT 'Mem Num',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `name` (`name`),
  KEY `wb_os_set_node_id` (`set_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_storage`;
CREATE TABLE `wb_storage` (
  `capacity` int(10) DEFAULT NULL COMMENT 'Capacity',
  `storage_type` int(11) DEFAULT NULL COMMENT 'Storage Type',
  `os_id` varchar(15) DEFAULT NULL COMMENT 'OS ID',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` date DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` date DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `p_guid` varchar(15) NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) NOT NULL COMMENT '原始数据guid',
  PRIMARY KEY (`guid`),
  KEY `wb_storage_os_id` (`os_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_state_create`;
CREATE TABLE `wb_state_create` (
  `name` varchar(45) DEFAULT NULL COMMENT 'Name',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `state` int(11) DEFAULT NULL COMMENT 'State',
	`fixed_date` VARCHAR(19) NULL DEFAULT NULL COMMENT '确认日期',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` VARCHAR(15) NULL DEFAULT NULL COMMENT '前全局唯一ID',
	`r_guid` VARCHAR(15) NOT NULL COMMENT '根全局唯一ID',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  PRIMARY KEY (`guid`,`r_guid`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_state_startup`;
CREATE TABLE `wb_state_startup` (
  `name` varchar(45) DEFAULT NULL COMMENT 'Name',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `state` int(11) DEFAULT NULL COMMENT 'State',
	`fixed_date` VARCHAR(19) NULL DEFAULT NULL COMMENT '确认日期',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` VARCHAR(15) NULL DEFAULT NULL COMMENT '前全局唯一ID',
	`r_guid` VARCHAR(15) NOT NULL COMMENT '根全局唯一ID',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  PRIMARY KEY (`guid`,`r_guid`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `wb_state_design`;
CREATE TABLE `wb_state_design` (
  `name` varchar(45) DEFAULT NULL COMMENT 'Name',
  `description` varchar(200) DEFAULT NULL COMMENT 'Description',
  `state` INT(15) NULL DEFAULT NULL COMMENT '状态',
  `fixed_date` VARCHAR(19) NULL DEFAULT NULL COMMENT '确认日期',
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` VARCHAR(15) NULL DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` VARCHAR(15) NOT NULL COMMENT '根全局唯一ID',
  `key_name` varchar(64) NOT NULL COMMENT '唯一值',
  `updated_by` varchar(64) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(64) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  PRIMARY KEY (`guid`,`r_guid`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	INSERT INTO `wb_state_create` (`name`,  `description`, `state`, `fixed_date`, `guid`, `p_guid`, `r_guid`) VALUES
	('wb_state_create 1', 'description 1',39, null, '0081_00000001', null, '0081_00000001'),
	('wb_state_create 2', 'description 2',39, '2019-07-01', '0081_00000012', null, '0081_00000002'),
	('wb_state_create 2', 'description 2',40, null, '0081_00000002', '0081_00000012', '0081_00000002'),
	('wb_state_create 3', 'description 3',39, '2019-07-01', '0081_00000013', null, '0081_00000003'),
	('wb_state_create 3', 'description 3',41, null, '0081_00000003', '0081_00000013', '0081_00000003'),
	('wb_state_create 4', 'description 4',40, '2019-07-01', '0081_00000014', null, '0081_00000004'),
	('wb_state_create 4', 'description 4',40, null, '0081_00000004', '0081_00000014', '0081_00000004'),
	('wb_state_create 5', 'description 5',40, '2019-07-01', '0081_00000015', null, '0081_00000005'),
	('wb_state_create 5', 'description 5',40, null, '0081_00000005', '0081_00000015', '0081_00000005'),
	('wb_state_create 6', 'description 6',40, '2019-07-01', '0081_00000016', null, '0081_00000006'),
	('wb_state_create 6', 'description 6',41, null, '0081_00000006', '0081_00000016', '0081_00000006'),
	('wb_state_create 7', 'description 7',41, '2019-07-01', '0081_00000017', null, '0081_00000007'),
	('wb_state_create 7', 'description 7',41, null, '0081_00000007', '0081_00000017', '0081_00000007');


	INSERT INTO `wb_state_startup` (`name`,  `description`, `state`, `fixed_date`, `guid`, `p_guid`, `r_guid`) VALUES
	('wb_state_startup 1', 'description 1',34, null, '0082_00000001', null, '0082_00000001');

	INSERT INTO `wb_state_design` (`name`,  `description`, `state`, `fixed_date`, `guid`, `p_guid`, `r_guid`) VALUES
	('wb_state_design 1', 'description 1',141, null, '0083_00000001', null, '0083_00000001'),
	('wb_state_design 2', 'description 2',141, '2019-07-01', '0083_00000012', null, '0083_00000002'),
	('wb_state_design 2', 'description 2',142, null, '0083_00000002', '0083_00000012', '0083_00000002'),
	('wb_state_design 3', 'description 3',141, '2019-07-01', '0083_00000013', null, '0083_00000003'),
	('wb_state_design 3', 'description 3',143, null, '0083_00000003', '0083_00000013', '0083_00000003'),
	('wb_state_design 4', 'description 4',142, '2019-07-01', '0083_00000014', null, '0083_00000004'),
	('wb_state_design 4', 'description 4',142, null, '0083_00000004', '0083_00000014', '0083_00000004'),
	('wb_state_design 5', 'description 5',142, '2019-07-01', '0083_00000015', null, '0083_00000005'),
	('wb_state_design 5', 'description 5',142, null, '0083_00000005', '0083_00000015', '0083_00000005'),
	('wb_state_design 6', 'description 6',142, '2019-07-01', '0083_00000016', null, '0083_00000006'),
	('wb_state_design 6', 'description 6',143, null, '0083_00000006', '0083_00000016', '0083_00000006'),
	('wb_state_design 7', 'description 7',143, '2019-07-01', '0083_00000017', null, '0083_00000007'),
	('wb_state_design 7', 'description 7',143, null, '0083_00000007', '0083_00000017', '0083_00000007');