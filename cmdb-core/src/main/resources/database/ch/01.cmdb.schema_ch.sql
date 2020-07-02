
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table wecmdb_bk.adm_attr_group
CREATE TABLE IF NOT EXISTS `adm_attr_group` (
  `id_adm_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_attr_group',
  `name` varchar(64) DEFAULT NULL COMMENT '组名',
  PRIMARY KEY (`id_adm_attr_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_basekey_cat
CREATE TABLE IF NOT EXISTS `adm_basekey_cat` (
  `id_adm_basekey_cat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_basekey_cat',
  `cat_name` varchar(32) DEFAULT NULL COMMENT '类别名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'id_adm_role',
  `id_adm_basekey_cat_type` int(11) DEFAULT NULL COMMENT '类型',
  `group_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_adm_basekey_cat`),
  KEY `fk_adm_basekey_cat_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_basekey_cat_type` (`id_adm_basekey_cat_type`),
  KEY `fk_adm_basekey_group_type_id` (`group_type_id`),
  CONSTRAINT `fk_adm_basekey_cat_type` FOREIGN KEY (`id_adm_basekey_cat_type`) REFERENCES `adm_basekey_cat_type` (`id_adm_basekey_cat_type`),
  CONSTRAINT `fk_adm_basekey_group_type_id` FOREIGN KEY (`group_type_id`) REFERENCES `adm_basekey_cat` (`id_adm_basekey_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_basekey_cat_type
CREATE TABLE IF NOT EXISTS `adm_basekey_cat_type` (
  `id_adm_basekey_cat_type` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ci_type_id` int(11) DEFAULT NULL,
  `type` int(4) DEFAULT NULL,
  PRIMARY KEY (`id_adm_basekey_cat_type`),
  KEY `adm_basekey_cat_type_ci_type_1` (`ci_type_id`),
  CONSTRAINT `adm_basekey_cat_type_ci_type_1` FOREIGN KEY (`ci_type_id`) REFERENCES `adm_ci_type` (`id_adm_ci_type`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_basekey_code
CREATE TABLE IF NOT EXISTS `adm_basekey_code` (
  `id_adm_basekey` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_basekey',
  `id_adm_basekey_cat` int(11) DEFAULT NULL COMMENT 'id_adm_basekey_cat',
  `code` varchar(255) DEFAULT NULL COMMENT 'key',
  `value` varchar(2000) DEFAULT NULL COMMENT 'name',
  `group_code_id` int(11) DEFAULT NULL COMMENT 'the group code it belong to',
  `code_description` varchar(255) DEFAULT NULL COMMENT '编码描述',
  `seq_no` int(11) DEFAULT NULL COMMENT '排序序号',
  `status` varchar(20) DEFAULT 'active' COMMENT '枚举状态',
  PRIMARY KEY (`id_adm_basekey`),
  KEY `fk_adm_basekey_code_adm_basekey_cat_1` (`id_adm_basekey_cat`),
  KEY `fk_adm_basekey_code_group_code_id` (`group_code_id`),
  CONSTRAINT `fk_adm_basekey_code_adm_basekey_cat_1` FOREIGN KEY (`id_adm_basekey_cat`) REFERENCES `adm_basekey_cat` (`id_adm_basekey_cat`),
  CONSTRAINT `fk_adm_basekey_code_group_code_id` FOREIGN KEY (`group_code_id`) REFERENCES `adm_basekey_code` (`id_adm_basekey`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type
CREATE TABLE IF NOT EXISTS `adm_ci_type` (
  `id_adm_ci_type` int(4) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_ci_type',
  `name` varchar(32) DEFAULT NULL COMMENT 'ci类型中文名称',
  `image_file_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'id_adm_tenement',
  `table_name` varchar(64) NOT NULL COMMENT '真实表名',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT '表状态',
  `catalog_id` int(11) DEFAULT NULL COMMENT 'ci大类类别',
  `ci_global_unique_id` int(11) DEFAULT NULL,
  `seq_no` int(11) NOT NULL DEFAULT '0' COMMENT '序列号',
  `layer_id` int(11) DEFAULT NULL,
  `zoom_level_id` int(11) DEFAULT NULL,
  `ci_state_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type`),
  UNIQUE KEY `tableNameIndex` (`table_name`),
  KEY `fk_adm_ci_type_adm_ci_type_1` (`catalog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type_attr
CREATE TABLE IF NOT EXISTS `adm_ci_type_attr` (
  `id_adm_ci_type_attr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_ci_type_attr',
  `id_adm_ci_type` int(4) NOT NULL COMMENT 'id_adm_ci_type',
  `name` varchar(64) NOT NULL COMMENT 'CI类型属性中文名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `input_type` varchar(32) NOT NULL COMMENT '输入类型',
  `property_name` varchar(64) NOT NULL COMMENT '属性真实列名',
  `property_type` varchar(32) NOT NULL COMMENT '属性真实类型',
  `length` int(32) DEFAULT '1' COMMENT '长度',
  `reference_id` int(11) DEFAULT NULL COMMENT '引用ID',
  `reference_name` varchar(64) DEFAULT NULL COMMENT '引用命名',
  `reference_type` int(4) DEFAULT NULL COMMENT '引用类型',
  `filter_rule` varchar(4000) DEFAULT NULL,
  `search_seq_no` int(11) DEFAULT NULL COMMENT '搜索条件排序序号',
  `display_type` int(1) DEFAULT NULL COMMENT '展示类型',
  `display_seq_no` int(11) DEFAULT NULL COMMENT '展示排序',
  `edit_is_null` int(1) DEFAULT NULL,
  `edit_is_only` int(1) DEFAULT NULL COMMENT '是否唯一',
  `edit_is_hiden` int(1) DEFAULT NULL COMMENT '是否隐藏',
  `edit_is_editable` int(1) DEFAULT NULL COMMENT '是否可编辑',
  `is_defunct` int(1) DEFAULT '0' COMMENT '是否丢弃',
  `special_logic` varchar(32) DEFAULT NULL COMMENT '特殊逻辑',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT '属性状态',
  `is_system` int(1) DEFAULT NULL COMMENT '是否系统字段',
  `is_access_controlled` int(1) DEFAULT '0' COMMENT '是否权限控制',
  `is_auto` int(1) DEFAULT NULL,
  `auto_fill_rule` varchar(2000) DEFAULT NULL COMMENT '自动填充规则',
  `is_refreshable` int(1) DEFAULT NULL,
  `regular_expression_rule` varchar(200) DEFAULT NULL COMMENT '正则规则',
  `is_delete_validate` int(1) DEFAULT '1' COMMENT '删除校验',
  PRIMARY KEY (`id_adm_ci_type_attr`),
  UNIQUE KEY `uniqCiType` (`id_adm_ci_type`,`property_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1186 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type_attr_base
CREATE TABLE IF NOT EXISTS `adm_ci_type_attr_base` (
  `id_adm_ci_type_attr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_ci_type_attr',
  `id_adm_ci_type` int(4) NOT NULL COMMENT 'id_adm_ci_type',
  `name` varchar(64) NOT NULL COMMENT 'CI类型属性中文名',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `input_type` varchar(32) NOT NULL COMMENT '输入类型',
  `property_name` varchar(64) NOT NULL COMMENT '属性真实列名',
  `property_type` varchar(32) NOT NULL COMMENT '属性真实类型',
  `length` int(32) DEFAULT '1' COMMENT '长度',
  `reference_id` int(11) DEFAULT NULL COMMENT '引用ID',
  `reference_name` varchar(64) DEFAULT NULL COMMENT '引用命名',
  `reference_type` int(4) DEFAULT NULL COMMENT '引用类型',
  `filter_rule` varchar(1000) DEFAULT NULL,
  `search_seq_no` int(11) DEFAULT NULL COMMENT '搜索条件排序序号',
  `display_type` int(1) DEFAULT NULL COMMENT '展示类型',
  `display_seq_no` int(11) DEFAULT NULL COMMENT '展示排序',
  `edit_is_null` int(1) DEFAULT NULL,
  `edit_is_only` int(1) DEFAULT NULL COMMENT '是否唯一',
  `edit_is_hiden` int(1) DEFAULT NULL COMMENT '是否隐藏',
  `edit_is_editable` int(1) DEFAULT NULL COMMENT '是否可编辑',
  `is_defunct` int(1) DEFAULT '0' COMMENT '是否丢弃',
  `special_logic` varchar(32) DEFAULT NULL COMMENT '特殊逻辑',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT '属性状态',
  `is_system` int(1) DEFAULT NULL COMMENT '是否系统字段',
  `is_access_controlled` int(1) DEFAULT '0' COMMENT '是否权限控制',
  `is_auto` int(1) DEFAULT NULL,
  `auto_fill_rule` varchar(2000) DEFAULT NULL COMMENT '自动填充规则',
  `regular_expression_rule` varchar(200) DEFAULT NULL COMMENT '正则规则',
  `is_delete_validate` int(1) DEFAULT '1' COMMENT '删除校验',
  `is_refreshable` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type_attr_group
CREATE TABLE IF NOT EXISTS `adm_ci_type_attr_group` (
  `id_adm_ci_type_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_ci_type_attr_group',
  `id_adm_ci_type_attr` int(11) DEFAULT NULL COMMENT 'id_adm_ci_type_attr',
  `id_adm_attr_group` int(11) DEFAULT NULL COMMENT 'id_adm_attr_group',
  PRIMARY KEY (`id_adm_ci_type_attr_group`),
  KEY `fk_adm_ci_type_attr_group_adm_attr_group_1` (`id_adm_attr_group`),
  KEY `fk_adm_ci_type_attr_group_adm_ci_type_attr_1` (`id_adm_ci_type_attr`),
  CONSTRAINT `fk_adm_ci_type_attr_group_adm_attr_group_1` FOREIGN KEY (`id_adm_attr_group`) REFERENCES `adm_attr_group` (`id_adm_attr_group`),
  CONSTRAINT `fk_adm_ci_type_attr_group_adm_ci_type_attr_1` FOREIGN KEY (`id_adm_ci_type_attr`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_files
CREATE TABLE IF NOT EXISTS `adm_files` (
  `id_adm_file` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` blob,
  PRIMARY KEY (`id_adm_file`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_integrate_template
CREATE TABLE IF NOT EXISTS `adm_integrate_template` (
  `id_adm_integrate_template` int(11) NOT NULL AUTO_INCREMENT,
  `ci_type_id` int(11) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `des` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id_adm_integrate_template`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_integrate_template_alias
CREATE TABLE IF NOT EXISTS `adm_integrate_template_alias` (
  `id_alias` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_ci_type` int(11) DEFAULT NULL,
  `id_adm_integrate_template` int(11) DEFAULT NULL,
  `alias` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_alias`),
  KEY `fk_adm_integrate_template_alias_template_1` (`id_adm_integrate_template`),
  KEY `fk_adm_integrate_template_alias_adm_ci_type_1` (`id_adm_ci_type`),
  CONSTRAINT `fk_adm_integrate_template_alias_adm_ci_type_1` FOREIGN KEY (`id_adm_ci_type`) REFERENCES `adm_ci_type` (`id_adm_ci_type`),
  CONSTRAINT `fk_adm_integrate_template_alias_adm_integrate_template_1` FOREIGN KEY (`id_adm_integrate_template`) REFERENCES `adm_integrate_template` (`id_adm_integrate_template`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_integrate_template_alias_attr
CREATE TABLE IF NOT EXISTS `adm_integrate_template_alias_attr` (
  `id_attr` int(11) NOT NULL AUTO_INCREMENT,
  `id_alias` int(11) DEFAULT NULL,
  `id_ci_type_attr` int(11) DEFAULT NULL,
  `is_condition` varchar(2) DEFAULT NULL COMMENT '是否是查询条件',
  `is_displayed` varchar(2) DEFAULT NULL COMMENT '是否展示',
  `mapping_name` varchar(200) DEFAULT NULL COMMENT '属性英文别名',
  `filter` varchar(200) DEFAULT NULL COMMENT '过滤条件',
  `key_name` varchar(500) DEFAULT NULL COMMENT '唯一值',
  `seq_no` int(11) DEFAULT NULL COMMENT '展示排序序号（越小优先级越高）',
  `cn_alias` varchar(64) DEFAULT NULL COMMENT '属性中文别名',
  `sys_attr` varchar(64) DEFAULT NULL COMMENT '系统属性（guid,created_user,created_date,updated_user,updated_date）',
  PRIMARY KEY (`id_attr`),
  KEY `fk_adm_integrate_template_alias_attr_1` (`id_alias`),
  KEY `fk_adm_integrate_template_alias_attr_2` (`id_ci_type_attr`),
  CONSTRAINT `fk_adm_integrate_template_alias_attr_1` FOREIGN KEY (`id_alias`) REFERENCES `adm_integrate_template_alias` (`id_alias`),
  CONSTRAINT `fk_adm_integrate_template_alias_attr_2` FOREIGN KEY (`id_ci_type_attr`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_integrate_template_relation
CREATE TABLE IF NOT EXISTS `adm_integrate_template_relation` (
  `id_relation` int(11) NOT NULL AUTO_INCREMENT,
  `child_alias_id` int(11) DEFAULT NULL,
  `child_ref_attr_id` int(11) DEFAULT NULL,
  `parent_alias_id` int(11) DEFAULT NULL,
  `is_refered_from_parent` int(1) NOT NULL,
  PRIMARY KEY (`id_relation`),
  KEY `fk_adm_integrate_template_relation_alias_2` (`parent_alias_id`),
  KEY `fk_adm_integrate_template_relation_alias_1` (`child_alias_id`),
  KEY `fk_adm_integrate_template_relation_attr_1` (`child_ref_attr_id`),
  CONSTRAINT `fk_adm_integrate_template_relation_alias_1` FOREIGN KEY (`child_alias_id`) REFERENCES `adm_integrate_template_alias` (`id_alias`),
  CONSTRAINT `fk_adm_integrate_template_relation_alias_2` FOREIGN KEY (`parent_alias_id`) REFERENCES `adm_integrate_template_alias` (`id_alias`),
  CONSTRAINT `fk_adm_integrate_template_relation_attr_1` FOREIGN KEY (`child_ref_attr_id`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_log
CREATE TABLE IF NOT EXISTS `adm_log` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `log_cat` varchar(50) DEFAULT NULL,
  `id_adm_user` varchar(20) DEFAULT NULL,
  `operation` varchar(50) DEFAULT NULL,
  `log_content` longtext,
  `created_at` varchar(19) DEFAULT NULL,
  `guid` varchar(15) DEFAULT NULL,
  `updated_by` varchar(64) DEFAULT NULL,
  `updated_date` varchar(64) DEFAULT NULL,
  `created_by` varchar(64) DEFAULT NULL,
  `created_date` varchar(64) DEFAULT NULL,
  `ci_type_instance_guid` varchar(64) DEFAULT NULL,
  `remark` varchar(1000) DEFAULT NULL COMMENT '标注',
  `ci_type_name` varchar(100) DEFAULT NULL COMMENT 'ci类型名称',
  `ci_name` varchar(100) DEFAULT NULL COMMENT '操作ci名称',
  `status` int(2) DEFAULT '0',
  `ci_type_id` int(10) DEFAULT NULL COMMENT 'ci类型id',
  `request_url` varchar(500) DEFAULT NULL,
  `client_host` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_log`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_ci_guid` (`ci_type_instance_guid`),
  KEY `NewIndex1` (`log_cat`),
  KEY `NewIndex2` (`ci_type_name`),
  KEY `NewIndex3` (`ci_name`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_menu
CREATE TABLE IF NOT EXISTS `adm_menu` (
  `id_adm_menu` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '菜单名称',
  `other_name` varchar(255) DEFAULT NULL COMMENT '菜单别名',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `seq_no` int(11) DEFAULT NULL COMMENT '排序序号',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `parent_id_adm_menu` int(11) DEFAULT NULL COMMENT '父菜单ID',
  `class_path` varchar(100) DEFAULT NULL COMMENT '目录对应的图标class',
  `is_active` int(1) DEFAULT '0' COMMENT '0正常，1禁用',
  PRIMARY KEY (`id_adm_menu`),
  KEY `fk_adm_menu_adm_menu_1` (`parent_id_adm_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role
CREATE TABLE IF NOT EXISTS `adm_role` (
  `id_adm_role` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_role',
  `role_name` varchar(32) DEFAULT NULL COMMENT '角色名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'id_adm_tenement',
  `parent_id_adm_role` int(11) DEFAULT NULL COMMENT '父角色ID',
  `role_type` varchar(32) DEFAULT NULL COMMENT '角色类型（平台管理、租户管理、CI管理、数据使用）',
  `is_system` int(1) DEFAULT '0' COMMENT '是否系统数据',
  PRIMARY KEY (`id_adm_role`),
  KEY `fk_adm_role_adm_tenement_1` (`id_adm_tenement`),
  KEY `fk_adm_role_adm_role_1` (`parent_id_adm_role`),
  CONSTRAINT `fk_adm_role_adm_role_1` FOREIGN KEY (`parent_id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_adm_tenement_1` FOREIGN KEY (`id_adm_tenement`) REFERENCES `adm_tenement` (`id_adm_tenement`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_ci_type
CREATE TABLE IF NOT EXISTS `adm_role_ci_type` (
  `id_adm_role_ci_type` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_role_ci_type',
  `id_adm_role` int(11) NOT NULL COMMENT 'id_adm_role',
  `id_adm_ci_type` int(11) NOT NULL COMMENT 'id_adm_ci_type',
  `ci_type_name` varchar(100) DEFAULT NULL,
  `creation_permission` varchar(1) NOT NULL DEFAULT 'N',
  `removal_permission` varchar(1) NOT NULL DEFAULT 'N',
  `modification_permission` varchar(1) NOT NULL DEFAULT 'N',
  `enquiry_permission` varchar(1) NOT NULL DEFAULT 'N',
  `execution_permission` varchar(1) NOT NULL DEFAULT 'N',
  `grant_permission` varchar(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id_adm_role_ci_type`),
  UNIQUE KEY `role_citype_unique` (`id_adm_role`,`id_adm_ci_type`),
  KEY `fk_adm_role_ci_type_adm_role_1` (`id_adm_role`),
  KEY `FK_adm_role_ci_type_adm_ci_type` (`id_adm_ci_type`),
  CONSTRAINT `fk_adm_role_ci_type_adm_citype_1` FOREIGN KEY (`id_adm_ci_type`) REFERENCES `adm_ci_type` (`id_adm_ci_type`) ON DELETE CASCADE,
  CONSTRAINT `fk_adm_role_ci_type_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=749 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_ci_type_ctrl_attr
CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr` (
  `id_adm_role_ci_type_ctrl_attr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_role_ci_type_ctrl_attr',
  `id_adm_role_ci_type` int(11) NOT NULL COMMENT 'id_adm_role_ci_type',
  `creation_permission` varchar(1) NOT NULL DEFAULT 'N',
  `removal_permission` varchar(1) NOT NULL DEFAULT 'N',
  `modification_permission` varchar(1) NOT NULL DEFAULT 'N',
  `enquiry_permission` varchar(1) NOT NULL DEFAULT 'N',
  `execution_permission` varchar(1) NOT NULL DEFAULT 'N',
  `grant_permission` varchar(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr`),
  KEY `fk_adm_role_ci_type_attribute_adm_role_ci_type_1` (`id_adm_role_ci_type`),
  CONSTRAINT `fk_adm_role_ci_type_attribute_adm_role_ci_type_1` FOREIGN KEY (`id_adm_role_ci_type`) REFERENCES `adm_role_ci_type` (`id_adm_role_ci_type`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_ci_type_ctrl_attr_condition
CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr_condition` (
  `id_adm_role_ci_type_ctrl_attr_condition` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role_ci_type_ctrl_attr` int(11) NOT NULL,
  `id_adm_ci_type_attr` int(11) NOT NULL,
  `ci_type_attr_name` varchar(100) DEFAULT NULL,
  `condition_value` varchar(1000) DEFAULT NULL,
  `condition_value_type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr_condition`),
  UNIQUE KEY `role_citype_ctrlattr_cond_unique` (`id_adm_role_ci_type_ctrl_attr`,`id_adm_ci_type_attr`),
  KEY `fk_adm_role_ci_type_attr_adm_role_ci_type_attr_1` (`id_adm_role_ci_type_ctrl_attr`),
  KEY `fk_adm_role_ci_type_attr_adm_ci_type_attr_1` (`id_adm_ci_type_attr`),
  CONSTRAINT `fk_adm_role_ci_type_attr_adm_ci_type_attr_1` FOREIGN KEY (`id_adm_ci_type_attr`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`) ON DELETE CASCADE,
  CONSTRAINT `fk_adm_role_ci_type_attr_adm_role_ci_type_attr_1` FOREIGN KEY (`id_adm_role_ci_type_ctrl_attr`) REFERENCES `adm_role_ci_type_ctrl_attr` (`id_adm_role_ci_type_ctrl_attr`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_ci_type_ctrl_attr_expression
CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr_expression` (
  `id_adm_role_ci_type_ctrl_attr_expression` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role_ci_type_ctrl_attr_condition` int(11) DEFAULT NULL,
  `expression` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr_expression`),
  KEY `id_adm_role_ci_type_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`),
  CONSTRAINT `id_adm_role_ci_type_attr_condition` FOREIGN KEY (`id_adm_role_ci_type_ctrl_attr_condition`) REFERENCES `adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_ci_type_ctrl_attr_select
CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr_select` (
  `id_adm_role_ci_type_ctrl_attr_select` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role_ci_type_ctrl_attr_condition` int(11) NOT NULL,
  `id_adm_basekey` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr_select`),
  KEY `id_adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`),
  KEY `id_adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `id_adm_basekey_code` FOREIGN KEY (`id_adm_basekey`) REFERENCES `adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `id_adm_role_ci_type_ctrl_attr_condition` FOREIGN KEY (`id_adm_role_ci_type_ctrl_attr_condition`) REFERENCES `adm_role_ci_type_ctrl_attr_condition` (`id_adm_role_ci_type_ctrl_attr_condition`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_menu
CREATE TABLE IF NOT EXISTS `adm_role_menu` (
  `id_adm_role_menu` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_role_menu',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'id_adm_role',
  `id_adm_menu` int(11) DEFAULT NULL COMMENT 'id_adm_menu',
  `is_system` int(1) DEFAULT '0' COMMENT '是否系统数据',
  PRIMARY KEY (`id_adm_role_menu`),
  UNIQUE KEY `role_menu_unique` (`id_adm_role`,`id_adm_menu`),
  KEY `fk_adm_role_menu_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_role_menu_adm_menu_1` (`id_adm_menu`),
  CONSTRAINT `fk_adm_role_menu_adm_menu_1` FOREIGN KEY (`id_adm_menu`) REFERENCES `adm_menu` (`id_adm_menu`) ON DELETE CASCADE,
  CONSTRAINT `fk_adm_role_menu_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_user
CREATE TABLE IF NOT EXISTS `adm_role_user` (
  `id_adm_role_user` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_role_user',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'id_adm_role',
  `id_adm_user` int(11) DEFAULT NULL COMMENT 'id_adm_user',
  `is_system` int(1) DEFAULT '0' COMMENT '是否系统数据',
  PRIMARY KEY (`id_adm_role_user`),
  KEY `fk_adm_role_user_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_role_user_adm_user_1` (`id_adm_user`),
  CONSTRAINT `fk_adm_role_user_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_user_adm_user_1` FOREIGN KEY (`id_adm_user`) REFERENCES `adm_user` (`id_adm_user`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_sequence
CREATE TABLE IF NOT EXISTS `adm_sequence` (
  `id_adm_sequence` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_sequence',
  `seq_name` varchar(64) NOT NULL COMMENT '序列名称',
  `current_val` int(11) DEFAULT NULL COMMENT '当前值',
  `increment_val` int(11) DEFAULT NULL COMMENT '步长',
  `length_limitation` int(11) DEFAULT NULL COMMENT '位数限制',
  `left_zero_padding` varchar(1) DEFAULT NULL COMMENT '是否补零，y为是，n为否',
  PRIMARY KEY (`id_adm_sequence`),
  UNIQUE KEY `seq_name_index` (`seq_name`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_state_transition
CREATE TABLE IF NOT EXISTS `adm_state_transition` (
  `id_adm_state_transition` int(11) NOT NULL,
  `current_state` int(11) DEFAULT NULL,
  `current_state_is_confirmed` tinyint(4) DEFAULT NULL,
  `target_state` int(11) DEFAULT NULL,
  `target_state_is_confirmed` tinyint(4) DEFAULT NULL,
  `operation` int(11) DEFAULT NULL,
  `action` int(11) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_adm_state_transition`),
  KEY `fk_adm_state_transition_current_state_idx` (`current_state`),
  KEY `fk_adm_state_transition_target_state_idx` (`target_state`),
  KEY `fk_adm_state_transition_operation_idx` (`operation`),
  KEY `fk_adm_state_transition_action_idx` (`action`),
  CONSTRAINT `fk_adm_state_transition_action` FOREIGN KEY (`action`) REFERENCES `adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `fk_adm_state_transition_current_state` FOREIGN KEY (`current_state`) REFERENCES `adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `fk_adm_state_transition_operation` FOREIGN KEY (`operation`) REFERENCES `adm_basekey_code` (`id_adm_basekey`),
  CONSTRAINT `fk_adm_state_transition_target_state` FOREIGN KEY (`target_state`) REFERENCES `adm_basekey_code` (`id_adm_basekey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_tenement
CREATE TABLE IF NOT EXISTS `adm_tenement` (
  `id_adm_tenement` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `en_short_name` varchar(32) DEFAULT NULL COMMENT '英文简称',
  PRIMARY KEY (`id_adm_tenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_user
CREATE TABLE IF NOT EXISTS `adm_user` (
  `id_adm_user` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_user',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `code` varchar(100) DEFAULT NULL COMMENT '编码（接口类用户使用）',
  `encrypted_password` varchar(100) DEFAULT NULL COMMENT '加密的密码',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'id_adm_tenement',
  `action_flag` tinyint(1) DEFAULT '0' COMMENT '用户操作Flag',
  `is_system` int(1) DEFAULT '0' COMMENT '是否系统数据',
  PRIMARY KEY (`id_adm_user`),
  UNIQUE KEY `adm_user_code` (`code`),
  KEY `fk_adm_user_adm_tenement_1` (`id_adm_tenement`),
  CONSTRAINT `fk_adm_user_adm_tenement_1` FOREIGN KEY (`id_adm_tenement`) REFERENCES `adm_tenement` (`id_adm_tenement`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.application_domain
CREATE TABLE IF NOT EXISTS `application_domain` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.app_instance
CREATE TABLE IF NOT EXISTS `app_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `cpu` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 4 | 6 | 8',
  `deploy_package` varchar(15) DEFAULT NULL COMMENT '部署包',
  `deploy_package_url` varchar(200) DEFAULT NULL COMMENT '部署包路径',
  `deploy_script` varchar(200) DEFAULT NULL,
  `deploy_user` varchar(200) DEFAULT NULL COMMENT '部署用户',
  `deploy_user_password` varchar(200) DEFAULT NULL COMMENT '部署用户密码',
  `host_resource_instance` varchar(15) DEFAULT NULL COMMENT '主机资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 4 | 6 | 8 | 12 | 16',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL COMMENT '10000-29999之间的一个数字',
  `port` varchar(200) DEFAULT NULL COMMENT '10000-19999之间的一个数字',
  `port_conflict` varchar(200) DEFAULT NULL COMMENT '端口冲突检测',
  `start_script` varchar(200) DEFAULT NULL,
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `stop_script` varchar(200) DEFAULT NULL,
  `storage` varchar(200) DEFAULT NULL COMMENT '10 | 20 | 40 | 80 | 120 | 200',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  `variable_values` varchar(4000) DEFAULT NULL COMMENT '差异配置值',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `app_log_files` varchar(200) DEFAULT NULL COMMENT '用于监控获取业务指标数据',
  `rw_dir` varchar(200) DEFAULT NULL COMMENT '非部署目录下的需授权读写目录',
  `rw_file` varchar(200) DEFAULT NULL COMMENT '非部署目录下的需授权读写文件',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.app_system
CREATE TABLE IF NOT EXISTS `app_system` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `deploy_environment` varchar(15) DEFAULT NULL COMMENT '部署环境',
  `legal_person` varchar(15) DEFAULT NULL COMMENT '法人',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `app_system_design` varchar(15) DEFAULT NULL COMMENT '应用系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.app_system$data_center
CREATE TABLE IF NOT EXISTS `app_system$data_center` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.app_system_design
CREATE TABLE IF NOT EXISTS `app_system_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `application_domain` varchar(15) DEFAULT NULL COMMENT '应用域',
  `app_system_design_id` varchar(200) DEFAULT NULL COMMENT '4-6位数字',
  `data_center_design` varchar(15) DEFAULT NULL COMMENT '数据中心设计',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.block_storage
CREATE TABLE IF NOT EXISTS `block_storage` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '计费周期(月)',
  `storage_type` varchar(200) DEFAULT NULL COMMENT '存储类型',
  `charge_type` varchar(15) DEFAULT NULL COMMENT '计费模式',
  `disk_size` varchar(200) DEFAULT NULL COMMENT '50的倍数',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `file_system` varchar(200) DEFAULT NULL COMMENT 'EXT | EXT4',
  `host_resource_instance` varchar(15) DEFAULT NULL COMMENT '主机资源实例',
  `mount_point` varchar(200) DEFAULT NULL COMMENT '/加字母开头的3-12位字符串',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.business_zone
CREATE TABLE IF NOT EXISTS `business_zone` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `network_zone` varchar(15) DEFAULT NULL COMMENT '网络区域',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `business_zone_design` varchar(15) DEFAULT NULL COMMENT '业务区域设计',
  `business_zone_type` varchar(200) DEFAULT NULL COMMENT 'GROUP | NODE',
  `logic_business_zone` varchar(15) DEFAULT NULL COMMENT '逻辑业务区域',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `legal_person` varchar(15) DEFAULT NULL COMMENT '法人',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.business_zone_design
CREATE TABLE IF NOT EXISTS `business_zone_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `network_zone_design` varchar(15) DEFAULT NULL COMMENT '网络区域设计',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cache_instance
CREATE TABLE IF NOT EXISTS `cache_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `cache_resource_instance` varchar(15) DEFAULT NULL COMMENT '缓存资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `port` varchar(200) DEFAULT NULL COMMENT '5000-9999的一个数字',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cache_resource_instance
CREATE TABLE IF NOT EXISTS `cache_resource_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `backup_asset_id` varchar(200) DEFAULT NULL,
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 3',
  `charge_type` varchar(15) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `ip_address` varchar(200) DEFAULT NULL COMMENT '待创建资源,填写IP+4位随机数字',
  `login_port` varchar(200) DEFAULT NULL COMMENT '6379',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL COMMENT '5000-9999的一个数字，一般与登录端口一致',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_spec` varchar(15) DEFAULT NULL COMMENT '资源实例规格',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名',
  `user_password` varchar(200) DEFAULT NULL COMMENT '用户密码',
  `resource_instance_system` varchar(15) DEFAULT NULL COMMENT '资源实例系统',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.charge_type
CREATE TABLE IF NOT EXISTS `charge_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `cloud_vendor` varchar(15) DEFAULT NULL COMMENT '云厂商',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cloud_vendor
CREATE TABLE IF NOT EXISTS `cloud_vendor` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cluster_node_type
CREATE TABLE IF NOT EXISTS `cluster_node_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `cluster_type` varchar(15) DEFAULT NULL COMMENT '集群类型',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cluster_type
CREATE TABLE IF NOT EXISTS `cluster_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `cloud_vendor` varchar(15) DEFAULT NULL COMMENT '云厂商',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cluster_type$unit_type
CREATE TABLE IF NOT EXISTS `cluster_type$unit_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cos_instance
CREATE TABLE IF NOT EXISTS `cos_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `access_id` varchar(200) DEFAULT NULL COMMENT '访问ID',
  `access_key` varchar(200) DEFAULT NULL COMMENT '访问密钥',
  `access_user` varchar(200) DEFAULT NULL COMMENT '访问用户',
  `cos_resource_instance` varchar(15) DEFAULT NULL COMMENT '对象存储资源实例',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.cos_resource_instance
CREATE TABLE IF NOT EXISTS `cos_resource_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `access_dns` varchar(200) DEFAULT NULL COMMENT '访问域名',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `access_proxy` varchar(200) DEFAULT NULL COMMENT '访问代理',
  `is_public` varchar(200) DEFAULT NULL COMMENT 'true | false',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.data_center
CREATE TABLE IF NOT EXISTS `data_center` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `cloud_uid` varchar(200) DEFAULT NULL COMMENT '云用户ID',
  `cloud_vendor` varchar(15) DEFAULT NULL COMMENT '云厂商',
  `data_center_design` varchar(15) DEFAULT NULL COMMENT '数据中心设计',
  `data_center_type` varchar(200) DEFAULT NULL COMMENT 'REGION | ZONE |ENTERPRISE',
  `location` varchar(200) DEFAULT NULL COMMENT '位置',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `regional_data_center` varchar(15) DEFAULT NULL COMMENT '地域数据中心',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `available_zone` varchar(200) DEFAULT NULL COMMENT '可用区',
  `region` varchar(200) DEFAULT NULL COMMENT '地域',
  `cen_asset_id` varchar(200) DEFAULT NULL COMMENT '云企业网资产ID',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.data_center$deploy_environment
CREATE TABLE IF NOT EXISTS `data_center$deploy_environment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.data_center_design
CREATE TABLE IF NOT EXISTS `data_center_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.default_security_policy
CREATE TABLE IF NOT EXISTS `default_security_policy` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `default_security_policy_design` varchar(15) DEFAULT NULL COMMENT '默认安全策略设计',
  `policy_network_segment` varchar(15) DEFAULT NULL COMMENT '策略网段',
  `owner_network_segment` varchar(15) DEFAULT NULL COMMENT '属主网段',
  `port` varchar(200) DEFAULT NULL COMMENT '端口',
  `protocol` varchar(200) DEFAULT NULL COMMENT '协议',
  `security_policy_action` varchar(200) DEFAULT NULL COMMENT '安全规则行为',
  `security_policy_type` varchar(200) DEFAULT NULL COMMENT '安全规则类型',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `security_policy_asset_id` varchar(200) DEFAULT NULL COMMENT '安全策略资产ID',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.default_security_policy_design
CREATE TABLE IF NOT EXISTS `default_security_policy_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `policy_network_segment_design` varchar(15) DEFAULT NULL COMMENT '策略网段设计',
  `owner_network_segment_design` varchar(15) DEFAULT NULL COMMENT '属主网段设计',
  `port` varchar(200) DEFAULT NULL COMMENT '数字或数字段，数字段位N1-N2格式',
  `protocol` varchar(200) DEFAULT NULL COMMENT 'TCP | UDP | ICMP',
  `security_policy_action` varchar(200) DEFAULT NULL COMMENT 'ACCEPT',
  `security_policy_type` varchar(200) DEFAULT NULL COMMENT 'ingress | egress',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.deploy_environment
CREATE TABLE IF NOT EXISTS `deploy_environment` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.deploy_package
CREATE TABLE IF NOT EXISTS `deploy_package` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `deploy_file_path` varchar(200) DEFAULT NULL COMMENT '执行部署脚本文件',
  `deploy_package_url` varchar(200) DEFAULT NULL COMMENT '存储路径',
  `diff_conf_file` varchar(4096) DEFAULT NULL COMMENT '差异配置文件',
  `is_decompression` varchar(200) DEFAULT NULL COMMENT '是否解压',
  `md5_value` varchar(200) DEFAULT NULL COMMENT 'MD5值',
  `name` varchar(200) DEFAULT NULL COMMENT '包名称',
  `start_file_path` varchar(200) DEFAULT NULL COMMENT '启动脚步文件',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `stop_file_path` varchar(200) DEFAULT NULL COMMENT '停止脚步文件',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `upload_user` varchar(200) DEFAULT NULL COMMENT '上传人',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.deploy_package$diff_conf_variable
CREATE TABLE IF NOT EXISTS `deploy_package$diff_conf_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.diff_configuration
CREATE TABLE IF NOT EXISTS `diff_configuration` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `variable_name` varchar(200) DEFAULT NULL COMMENT '变量名',
  `variable_value` varchar(6000) DEFAULT NULL COMMENT '变量值',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.host_resource_instance
CREATE TABLE IF NOT EXISTS `host_resource_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `backup_asset_id` varchar(200) DEFAULT NULL,
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 3',
  `charge_type` varchar(15) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `ip_address` varchar(200) DEFAULT NULL COMMENT '待创建资源,填写IP+4位随机数字',
  `login_port` varchar(200) DEFAULT NULL COMMENT '22|3389',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL COMMENT '9100',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_spec` varchar(15) DEFAULT NULL COMMENT '资源实例规格',
  `resource_instance_system` varchar(15) DEFAULT NULL COMMENT '资源实例系统',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '50的倍数',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名',
  `user_password` varchar(200) DEFAULT NULL COMMENT '用户密码',
  `storage_type` varchar(15) DEFAULT NULL COMMENT '存储类型',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `subnet_security_group` varchar(200) DEFAULT NULL COMMENT 'Y | N ',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.invoke
CREATE TABLE IF NOT EXISTS `invoke` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `invoked_unit` varchar(15) DEFAULT NULL COMMENT '被调用单元',
  `invoke_design` varchar(15) DEFAULT NULL COMMENT '调用设计',
  `invoke_type` varchar(200) DEFAULT NULL COMMENT '调用类型',
  `invoke_unit` varchar(15) DEFAULT NULL COMMENT '调用单元',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `invoked_resource_type` varchar(200) DEFAULT NULL COMMENT '被调用资源类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.invoke_design
CREATE TABLE IF NOT EXISTS `invoke_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `invoked_unit_design` varchar(15) DEFAULT NULL COMMENT '被调用单元设计',
  `invoke_type` varchar(200) DEFAULT NULL COMMENT '同步调用 | 同步请求 | 异步返回',
  `invoke_unit_design` varchar(15) DEFAULT NULL COMMENT '调用单元设计',
  `resource_set_invoke_design` varchar(15) DEFAULT NULL COMMENT '资源集合调用设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.ip_address
CREATE TABLE IF NOT EXISTS `ip_address` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.lb_instance
CREATE TABLE IF NOT EXISTS `lb_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `lb_listener_asset_id` varchar(200) DEFAULT NULL COMMENT '负载监听资产ID',
  `lb_resource_instance` varchar(15) DEFAULT NULL COMMENT '负载均衡资源实例',
  `port` varchar(200) DEFAULT NULL COMMENT '50-999的一个端口或10000-19999的一个端口',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `monitor_key_name` varchar(200) DEFAULT NULL COMMENT '监控唯一名称',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.lb_resource_instance
CREATE TABLE IF NOT EXISTS `lb_resource_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 3',
  `charge_type` varchar(15) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `ip_address` varchar(200) DEFAULT NULL COMMENT '待创建资源,填写IP+4位随机数字',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL COMMENT '50-999的一个端口',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.legal_person
CREATE TABLE IF NOT EXISTS `legal_person` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.manage_role
CREATE TABLE IF NOT EXISTS `manage_role` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `phone` varchar(200) DEFAULT NULL COMMENT '电话号码',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_link
CREATE TABLE IF NOT EXISTS `network_link` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `max_concurrent` varchar(200) DEFAULT NULL COMMENT '最大并发连接数',
  `netband_width` varchar(200) DEFAULT NULL COMMENT '网络带宽(M)',
  `network_segment_1` varchar(15) DEFAULT NULL COMMENT '网段1',
  `network_segment_2` varchar(15) DEFAULT NULL COMMENT '网段2',
  `network_link_design` varchar(15) DEFAULT NULL COMMENT '网络连接设计',
  `network_link_type` varchar(200) DEFAULT NULL COMMENT '自动填充',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subnet_network_segment` varchar(15) DEFAULT NULL COMMENT '子网网段',
  `nat_table_asset_id` varchar(200) DEFAULT NULL COMMENT 'NAT表资产编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_link$nat_ip_address
CREATE TABLE IF NOT EXISTS `network_link$nat_ip_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_link_design
CREATE TABLE IF NOT EXISTS `network_link_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `network_segment_design_1` varchar(15) DEFAULT NULL COMMENT '网段设计1',
  `network_segment_design_2` varchar(15) DEFAULT NULL COMMENT '网段设计2',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_link_type
CREATE TABLE IF NOT EXISTS `network_link_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `cloud_vendor` varchar(15) DEFAULT NULL COMMENT '云厂商',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_segment
CREATE TABLE IF NOT EXISTS `network_segment` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `data_center` varchar(15) DEFAULT NULL COMMENT '数据中心',
  `f_network_segment` varchar(15) DEFAULT NULL COMMENT '父网段',
  `gateway_ip` varchar(200) DEFAULT NULL COMMENT '网关IP地址',
  `mask` varchar(200) DEFAULT NULL COMMENT '自动填充',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `network_segment_design` varchar(15) DEFAULT NULL COMMENT '网段设计',
  `network_segment_usage` varchar(200) DEFAULT NULL COMMENT '自动填充',
  `route_table_asset_id` varchar(200) DEFAULT NULL COMMENT '路由表资产ID',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subnet_asset_id` varchar(200) DEFAULT NULL COMMENT '子网资产ID',
  `vpc_asset_id` varchar(200) DEFAULT NULL COMMENT 'VPC资产ID',
  `private_route_table` varchar(200) DEFAULT NULL COMMENT '独立路由表,腾讯云支持',
  `security_group_asset_id` varchar(200) DEFAULT NULL COMMENT '安全组资产ID',
  `private_nat` varchar(200) DEFAULT NULL COMMENT '独立NAT',
  `nat_rule_asset_id` varchar(200) DEFAULT NULL COMMENT 'NAT规则资产ID',
  `private_security_group` varchar(200) DEFAULT NULL COMMENT 'Y | N',
  `num` varchar(200) DEFAULT NULL COMMENT '2位数字或小写字母',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_segment_design
CREATE TABLE IF NOT EXISTS `network_segment_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `data_center_design` varchar(15) DEFAULT NULL COMMENT '数据中心设计',
  `f_network_segment_design` varchar(15) DEFAULT NULL COMMENT '父网段设计',
  `mask` varchar(200) DEFAULT NULL COMMENT '0-32的数字',
  `name` varchar(200) DEFAULT NULL COMMENT '大写字母数字和下划线组成的字符串',
  `network_segment_usage` varchar(200) DEFAULT NULL COMMENT 'RDC | VPC | SUBNET | WNET | WAN | TON  |BON  | PTN',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `private_route_table` varchar(200) DEFAULT NULL COMMENT 'Y | N',
  `private_nat` varchar(200) DEFAULT NULL COMMENT 'Y | N',
  `private_security_group` varchar(200) DEFAULT NULL COMMENT 'Y | N',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_zone
CREATE TABLE IF NOT EXISTS `network_zone` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `data_center` varchar(15) DEFAULT NULL COMMENT '数据中心',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `network_zone_design` varchar(15) DEFAULT NULL COMMENT '网络区域设计',
  `network_zone_layer` varchar(200) DEFAULT NULL COMMENT '网络区域层级',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.network_zone_design
CREATE TABLE IF NOT EXISTS `network_zone_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `data_center_design` varchar(15) DEFAULT NULL COMMENT '数据中心设计',
  `network_segment_design` varchar(15) DEFAULT NULL COMMENT '网段设计',
  `network_zone_layer` varchar(200) DEFAULT NULL COMMENT 'CLIENT | LINK | CORE',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.rdb_instance
CREATE TABLE IF NOT EXISTS `rdb_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `cpu` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 4 | 6 | 8',
  `deploy_package` varchar(15) DEFAULT NULL COMMENT '部署包',
  `deploy_package_url` varchar(200) DEFAULT NULL COMMENT '部署包路径',
  `deploy_script` varchar(200) DEFAULT NULL,
  `deploy_user` varchar(200) DEFAULT NULL COMMENT '字母开头由字母、数字、下划线组成的6-12位字符串',
  `deploy_user_password` varchar(200) DEFAULT NULL COMMENT '部署用户密码',
  `memory` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 4 | 6 | 8 | 12 | 16',
  `port` varchar(200) DEFAULT NULL COMMENT '1000-4999的一个数字',
  `rdb_resource_instance` varchar(15) DEFAULT NULL COMMENT '数据库资源实例',
  `regular_backup_asset_id` varchar(200) DEFAULT NULL COMMENT '常规备份资产ID',
  `rollback_script` varchar(200) DEFAULT NULL,
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '10的倍数',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  `upgrade_script` varchar(200) DEFAULT NULL,
  `variable_values` varchar(4000) DEFAULT NULL COMMENT '差异配置值',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `deploy_backup_asset_id` varchar(200) DEFAULT NULL COMMENT '部署备份资产ID',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.rdb_resource_instance
CREATE TABLE IF NOT EXISTS `rdb_resource_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `backup_asset_id` varchar(200) DEFAULT NULL,
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '1 | 2 | 3',
  `charge_type` varchar(15) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `ip_address` varchar(200) DEFAULT NULL COMMENT '待创建资源,填写IP+4位随机数字',
  `login_port` varchar(200) DEFAULT NULL COMMENT '1000-4999的一个数字',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL COMMENT '1000-4999的一个数字，一般与登录端口一致',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_spec` varchar(15) DEFAULT NULL COMMENT '资源实例规格',
  `resource_instance_system` varchar(15) DEFAULT NULL COMMENT '资源系统',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '50的倍数',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名',
  `user_password` varchar(200) DEFAULT NULL COMMENT '用户密码',
  `storage_type` varchar(15) DEFAULT NULL COMMENT '存储类型',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_instance_spec
CREATE TABLE IF NOT EXISTS `resource_instance_spec` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_instance_spec$resource_instance_type
CREATE TABLE IF NOT EXISTS `resource_instance_spec$resource_instance_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_instance_system
CREATE TABLE IF NOT EXISTS `resource_instance_system` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_instance_system$resource_instance_type
CREATE TABLE IF NOT EXISTS `resource_instance_system$resource_instance_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_instance_type
CREATE TABLE IF NOT EXISTS `resource_instance_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `cluster_type` varchar(15) DEFAULT NULL COMMENT '集群类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_set
CREATE TABLE IF NOT EXISTS `resource_set` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `business_zone` varchar(15) DEFAULT NULL COMMENT '业务区域',
  `cluster_type` varchar(15) DEFAULT NULL COMMENT '集群类型',
  `logic_resource_set` varchar(15) DEFAULT NULL COMMENT '合法值[LOGIC,NODE]',
  `manage_role` varchar(15) DEFAULT NULL COMMENT '管理角色',
  `resource_type` varchar(200) DEFAULT NULL COMMENT 'BDP | HOST | RDB | CACHE | LB | COS ',
  `resource_set_design` varchar(15) DEFAULT NULL COMMENT '资源集合设计',
  `resource_set_type` varchar(200) DEFAULT NULL COMMENT 'GROUP | NODE',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `network_zone` varchar(15) DEFAULT NULL COMMENT '网络区域',
  `init_script_type` varchar(200) DEFAULT NULL COMMENT 'S3 | LOCAL | USER_PARAM',
  `init_script` varchar(2000) DEFAULT NULL COMMENT '初始化脚本',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_set$deploy_environment
CREATE TABLE IF NOT EXISTS `resource_set$deploy_environment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_set$network_segment
CREATE TABLE IF NOT EXISTS `resource_set$network_segment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=385 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_set_design
CREATE TABLE IF NOT EXISTS `resource_set_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `business_zone_design` varchar(15) DEFAULT NULL COMMENT '安全区域设计',
  `network_segment_design` varchar(15) DEFAULT NULL COMMENT '网段设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `network_zone_design` varchar(15) DEFAULT NULL COMMENT '网络区域设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_set_design$application_domain
CREATE TABLE IF NOT EXISTS `resource_set_design$application_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.resource_set_invoke_design
CREATE TABLE IF NOT EXISTS `resource_set_invoke_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `invoked_resource_set_design` varchar(15) DEFAULT NULL COMMENT '被调用资源集合设计',
  `invoke_resource_set_design` varchar(15) DEFAULT NULL COMMENT '调用资源集合设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.route
CREATE TABLE IF NOT EXISTS `route` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `asset_id` varchar(200) DEFAULT NULL COMMENT '资产ID',
  `dest_network_segment` varchar(15) DEFAULT NULL COMMENT '目标网段',
  `owner_network_segment` varchar(15) DEFAULT NULL COMMENT '属主网段',
  `network_link` varchar(15) DEFAULT NULL COMMENT '网络连接',
  `route_design` varchar(15) DEFAULT NULL COMMENT '路由设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.route_design
CREATE TABLE IF NOT EXISTS `route_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `dest_network_segment_design` varchar(15) DEFAULT NULL COMMENT '目标网段设计',
  `network_zone_link_design` varchar(15) DEFAULT NULL COMMENT '网络区域连接设计',
  `owner_network_segment_design` varchar(15) DEFAULT NULL COMMENT '属主网段设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.service_design
CREATE TABLE IF NOT EXISTS `service_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '服务名称',
  `service_invoke_type` varchar(200) DEFAULT NULL COMMENT '同步请求 | 异步回调 | 广播 | 同步调用',
  `service_nature` varchar(200) DEFAULT NULL COMMENT '查询类 | 交易类',
  `service_type` varchar(200) DEFAULT NULL COMMENT '直连服务 | RMB服务',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.service_invoke_design
CREATE TABLE IF NOT EXISTS `service_invoke_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `invoked_unit_design` varchar(15) DEFAULT NULL COMMENT '被调用单元设计',
  `invoke_unit_design` varchar(15) DEFAULT NULL COMMENT '调用单元设计',
  `service_design` varchar(15) DEFAULT NULL COMMENT '服务设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.service_invoke_seq_design
CREATE TABLE IF NOT EXISTS `service_invoke_seq_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '时序名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `app_system_design` varchar(15) DEFAULT NULL COMMENT '应用系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.service_invoke_seq_design$service_invoke_design_sequence
CREATE TABLE IF NOT EXISTS `service_invoke_seq_design$service_invoke_design_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.static_diff_conf_value
CREATE TABLE IF NOT EXISTS `static_diff_conf_value` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `deploy_environment` varchar(15) DEFAULT NULL COMMENT '部署环境',
  `deploy_environment_difference` varchar(200) DEFAULT NULL COMMENT 'Y | N',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `static_value` varchar(200) DEFAULT NULL COMMENT '静态值',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.storage_type
CREATE TABLE IF NOT EXISTS `storage_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `cloud_vendor` varchar(15) DEFAULT NULL COMMENT '云厂商',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.subsys
CREATE TABLE IF NOT EXISTS `subsys` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `manage_role` varchar(50) DEFAULT NULL COMMENT '管理角色',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subsys_design` varchar(15) DEFAULT NULL COMMENT '子系统设计',
  `app_system` varchar(15) DEFAULT NULL COMMENT '应用系统',
  `network_zone` varchar(15) DEFAULT NULL COMMENT '网络区域',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.subsys$business_zone
CREATE TABLE IF NOT EXISTS `subsys$business_zone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) NOT NULL,
  `to_guid` varchar(15) NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.subsys_design
CREATE TABLE IF NOT EXISTS `subsys_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subsys_design_id` varchar(200) DEFAULT NULL COMMENT '4-6位数字',
  `app_system_design` varchar(15) DEFAULT NULL COMMENT '应用系统设计',
  `network_zone_design` varchar(15) DEFAULT NULL COMMENT '网络区域设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.subsys_design$business_zone_design
CREATE TABLE IF NOT EXISTS `subsys_design$business_zone_design` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) NOT NULL,
  `to_guid` varchar(15) NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.unit
CREATE TABLE IF NOT EXISTS `unit` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `deploy_path` varchar(200) DEFAULT NULL COMMENT '部署路径',
  `manage_role` varchar(15) DEFAULT NULL COMMENT '管理角色',
  `public_key` varchar(1000) DEFAULT NULL COMMENT '加密公钥',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `security_group_asset_id` varchar(200) DEFAULT NULL COMMENT '安全组资产编码',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subsys` varchar(15) DEFAULT NULL COMMENT '子系统',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `protocol` varchar(200) DEFAULT NULL COMMENT '通讯协议',
  `white_list_type` varchar(200) DEFAULT NULL COMMENT 'N默认策略，I入白名单策略，E出白名单策略，IE出入白名单策略',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.unit$deploy_package
CREATE TABLE IF NOT EXISTS `unit$deploy_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.unit_design
CREATE TABLE IF NOT EXISTS `unit_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `across_resource_set` varchar(200) DEFAULT NULL COMMENT '合法值为“Y”或“N”',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `protocol` varchar(200) DEFAULT NULL COMMENT '合法值为“TCP”或“UDP”',
  `resource_set_design` varchar(15) DEFAULT NULL COMMENT '资源集合设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subsys_design` varchar(15) DEFAULT NULL COMMENT '系统',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `white_list_type` varchar(200) DEFAULT NULL COMMENT 'N默认策略，I入白名单策略，E出白名单策略，IE出入白名单策略',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.unit_type
CREATE TABLE IF NOT EXISTS `unit_type` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前一版本数据的guid',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '原始数据guid',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `key_name` varchar(1000) DEFAULT NULL COMMENT '唯一名称',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(1000) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;