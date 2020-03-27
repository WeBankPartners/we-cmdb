/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50562
Source Host           : localhost:3306
Source Database       : wecmdb_embedded

Target Server Type    : MYSQL
Target Server Version : 50562
File Encoding         : 65001

Date: 2020-03-27 15:58:48
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for adm_attr_group
-- ----------------------------
DROP TABLE IF EXISTS `adm_attr_group`;
CREATE TABLE `adm_attr_group` (
  `id_adm_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_attr_group',
  `name` varchar(64) DEFAULT NULL COMMENT '组名',
  PRIMARY KEY (`id_adm_attr_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_basekey_cat
-- ----------------------------
DROP TABLE IF EXISTS `adm_basekey_cat`;
CREATE TABLE `adm_basekey_cat` (
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_basekey_cat_type
-- ----------------------------
DROP TABLE IF EXISTS `adm_basekey_cat_type`;
CREATE TABLE `adm_basekey_cat_type` (
  `id_adm_basekey_cat_type` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ci_type_id` int(11) DEFAULT NULL,
  `type` int(4) DEFAULT NULL,
  PRIMARY KEY (`id_adm_basekey_cat_type`),
  KEY `adm_basekey_cat_type_ci_type_1` (`ci_type_id`),
  CONSTRAINT `adm_basekey_cat_type_ci_type_1` FOREIGN KEY (`ci_type_id`) REFERENCES `adm_ci_type` (`id_adm_ci_type`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_basekey_code
-- ----------------------------
DROP TABLE IF EXISTS `adm_basekey_code`;
CREATE TABLE `adm_basekey_code` (
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
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_ci_type
-- ----------------------------
DROP TABLE IF EXISTS `adm_ci_type`;
CREATE TABLE `adm_ci_type` (
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_ci_type_attr
-- ----------------------------
DROP TABLE IF EXISTS `adm_ci_type_attr`;
CREATE TABLE `adm_ci_type_attr` (
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
  `is_refreshable` int(1) DEFAULT NULL,
  `regular_expression_rule` varchar(200) DEFAULT NULL COMMENT '正则规则',
  PRIMARY KEY (`id_adm_ci_type_attr`),
  UNIQUE KEY `uniqCiType` (`id_adm_ci_type`,`property_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1052 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_ci_type_attr_base
-- ----------------------------
DROP TABLE IF EXISTS `adm_ci_type_attr_base`;
CREATE TABLE `adm_ci_type_attr_base` (
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
  `is_refreshable` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_ci_type_attr_group
-- ----------------------------
DROP TABLE IF EXISTS `adm_ci_type_attr_group`;
CREATE TABLE `adm_ci_type_attr_group` (
  `id_adm_ci_type_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_ci_type_attr_group',
  `id_adm_ci_type_attr` int(11) DEFAULT NULL COMMENT 'id_adm_ci_type_attr',
  `id_adm_attr_group` int(11) DEFAULT NULL COMMENT 'id_adm_attr_group',
  PRIMARY KEY (`id_adm_ci_type_attr_group`),
  KEY `fk_adm_ci_type_attr_group_adm_attr_group_1` (`id_adm_attr_group`),
  KEY `fk_adm_ci_type_attr_group_adm_ci_type_attr_1` (`id_adm_ci_type_attr`),
  CONSTRAINT `fk_adm_ci_type_attr_group_adm_attr_group_1` FOREIGN KEY (`id_adm_attr_group`) REFERENCES `adm_attr_group` (`id_adm_attr_group`),
  CONSTRAINT `fk_adm_ci_type_attr_group_adm_ci_type_attr_1` FOREIGN KEY (`id_adm_ci_type_attr`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_files
-- ----------------------------
DROP TABLE IF EXISTS `adm_files`;
CREATE TABLE `adm_files` (
  `id_adm_file` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` blob,
  PRIMARY KEY (`id_adm_file`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_integrate_template
-- ----------------------------
DROP TABLE IF EXISTS `adm_integrate_template`;
CREATE TABLE `adm_integrate_template` (
  `id_adm_integrate_template` int(11) NOT NULL AUTO_INCREMENT,
  `ci_type_id` int(11) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `des` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id_adm_integrate_template`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_integrate_template_alias
-- ----------------------------
DROP TABLE IF EXISTS `adm_integrate_template_alias`;
CREATE TABLE `adm_integrate_template_alias` (
  `id_alias` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_ci_type` int(11) DEFAULT NULL,
  `id_adm_integrate_template` int(11) DEFAULT NULL,
  `alias` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_alias`),
  KEY `fk_adm_integrate_template_alias_template_1` (`id_adm_integrate_template`),
  KEY `fk_adm_integrate_template_alias_adm_ci_type_1` (`id_adm_ci_type`),
  CONSTRAINT `fk_adm_integrate_template_alias_adm_ci_type_1` FOREIGN KEY (`id_adm_ci_type`) REFERENCES `adm_ci_type` (`id_adm_ci_type`),
  CONSTRAINT `fk_adm_integrate_template_alias_adm_integrate_template_1` FOREIGN KEY (`id_adm_integrate_template`) REFERENCES `adm_integrate_template` (`id_adm_integrate_template`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_integrate_template_alias_attr
-- ----------------------------
DROP TABLE IF EXISTS `adm_integrate_template_alias_attr`;
CREATE TABLE `adm_integrate_template_alias_attr` (
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_integrate_template_relation
-- ----------------------------
DROP TABLE IF EXISTS `adm_integrate_template_relation`;
CREATE TABLE `adm_integrate_template_relation` (
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_log
-- ----------------------------
DROP TABLE IF EXISTS `adm_log`;
CREATE TABLE `adm_log` (
  `id_log` int(11) DEFAULT NULL,
  `log_cat` varchar(50) DEFAULT NULL,
  `id_adm_user` varchar(20) DEFAULT NULL,
  `operation` varchar(50) DEFAULT NULL,
  `log_content` longtext,
  `created_at` varchar(19) DEFAULT NULL,
  `guid` bigint(20) NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`guid`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_ci_guid` (`ci_type_instance_guid`),
  KEY `NewIndex1` (`log_cat`),
  KEY `NewIndex2` (`ci_type_name`),
  KEY `NewIndex3` (`ci_name`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_menu
-- ----------------------------
DROP TABLE IF EXISTS `adm_menu`;
CREATE TABLE `adm_menu` (
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

-- ----------------------------
-- Table structure for adm_role
-- ----------------------------
DROP TABLE IF EXISTS `adm_role`;
CREATE TABLE `adm_role` (
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_role_ci_type
-- ----------------------------
DROP TABLE IF EXISTS `adm_role_ci_type`;
CREATE TABLE `adm_role_ci_type` (
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
) ENGINE=InnoDB AUTO_INCREMENT=523 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_role_ci_type_ctrl_attr
-- ----------------------------
DROP TABLE IF EXISTS `adm_role_ci_type_ctrl_attr`;
CREATE TABLE `adm_role_ci_type_ctrl_attr` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_role_ci_type_ctrl_attr_condition
-- ----------------------------
DROP TABLE IF EXISTS `adm_role_ci_type_ctrl_attr_condition`;
CREATE TABLE `adm_role_ci_type_ctrl_attr_condition` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `adm_role_menu`;
CREATE TABLE `adm_role_menu` (
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_role_user
-- ----------------------------
DROP TABLE IF EXISTS `adm_role_user`;
CREATE TABLE `adm_role_user` (
  `id_adm_role_user` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_role_user',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'id_adm_role',
  `id_adm_user` int(11) DEFAULT NULL COMMENT 'id_adm_user',
  `is_system` int(1) DEFAULT '0' COMMENT '是否系统数据',
  PRIMARY KEY (`id_adm_role_user`),
  KEY `fk_adm_role_user_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_role_user_adm_user_1` (`id_adm_user`),
  CONSTRAINT `fk_adm_role_user_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_user_adm_user_1` FOREIGN KEY (`id_adm_user`) REFERENCES `adm_user` (`id_adm_user`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_sequence
-- ----------------------------
DROP TABLE IF EXISTS `adm_sequence`;
CREATE TABLE `adm_sequence` (
  `id_adm_sequence` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_sequence',
  `seq_name` varchar(64) NOT NULL COMMENT '序列名称',
  `current_val` int(11) DEFAULT NULL COMMENT '当前值',
  `increment_val` int(11) DEFAULT NULL COMMENT '步长',
  `length_limitation` int(11) DEFAULT NULL COMMENT '位数限制',
  `left_zero_padding` varchar(1) DEFAULT NULL COMMENT '是否补零，y为是，n为否',
  PRIMARY KEY (`id_adm_sequence`),
  UNIQUE KEY `seq_name_index` (`seq_name`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_state_transition
-- ----------------------------
DROP TABLE IF EXISTS `adm_state_transition`;
CREATE TABLE `adm_state_transition` (
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

-- ----------------------------
-- Table structure for adm_tenement
-- ----------------------------
DROP TABLE IF EXISTS `adm_tenement`;
CREATE TABLE `adm_tenement` (
  `id_adm_tenement` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `en_short_name` varchar(32) DEFAULT NULL COMMENT '英文简称',
  PRIMARY KEY (`id_adm_tenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for adm_user
-- ----------------------------
DROP TABLE IF EXISTS `adm_user`;
CREATE TABLE `adm_user` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for application_domain
-- ----------------------------
DROP TABLE IF EXISTS `application_domain`;
CREATE TABLE `application_domain` (
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

-- ----------------------------
-- Table structure for app_instance
-- ----------------------------
DROP TABLE IF EXISTS `app_instance`;
CREATE TABLE `app_instance` (
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
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `deploy_package` varchar(15) DEFAULT NULL COMMENT '部署包',
  `deploy_package_url` varchar(200) DEFAULT NULL COMMENT '部署包路径',
  `deploy_script` varchar(200) DEFAULT NULL,
  `deploy_user` varchar(200) DEFAULT NULL,
  `deploy_user_password` varchar(200) DEFAULT NULL COMMENT '部署用户密码',
  `host_resource_instance` varchar(15) DEFAULT NULL COMMENT '主机资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL COMMENT '监控端口',
  `port` varchar(200) DEFAULT NULL COMMENT '端口',
  `port_conflict` varchar(200) DEFAULT NULL COMMENT '端口冲突检测',
  `start_script` varchar(200) DEFAULT NULL,
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `stop_script` varchar(200) DEFAULT NULL,
  `storage` varchar(200) DEFAULT NULL COMMENT '存储空间(GB)',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  `variable_values` varchar(4000) DEFAULT NULL COMMENT '差异配置值',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for app_system
-- ----------------------------
DROP TABLE IF EXISTS `app_system`;
CREATE TABLE `app_system` (
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
  `system_design` varchar(15) DEFAULT NULL COMMENT '系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for app_system$data_center
-- ----------------------------
DROP TABLE IF EXISTS `app_system$data_center`;
CREATE TABLE `app_system$data_center` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for app_system_design
-- ----------------------------
DROP TABLE IF EXISTS `app_system_design`;
CREATE TABLE `app_system_design` (
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
  `app_system_design_id` varchar(200) DEFAULT NULL COMMENT '应用系统设计ID',
  `data_center_design` varchar(15) DEFAULT NULL COMMENT '数据中心设计',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for block_storage
-- ----------------------------
DROP TABLE IF EXISTS `block_storage`;
CREATE TABLE `block_storage` (
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
  `block_storage_type` varchar(200) DEFAULT NULL COMMENT '块存储类型',
  `charge_type` varchar(200) DEFAULT NULL COMMENT '计费模式',
  `disk_size` varchar(200) DEFAULT NULL COMMENT '容量(GB)',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `file_system` varchar(200) DEFAULT NULL COMMENT '文件系统格式',
  `host_resource_instance` varchar(15) DEFAULT NULL COMMENT '主机资源实例',
  `mount_point` varchar(200) DEFAULT NULL COMMENT '挂载点',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for business_zone
-- ----------------------------
DROP TABLE IF EXISTS `business_zone`;
CREATE TABLE `business_zone` (
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
  `business_zone_design` varchar(15) DEFAULT NULL COMMENT '业务区域设计',
  `business_zone_type` varchar(200) DEFAULT NULL COMMENT '合法值[GROUP,NODE]',
  `logic_business_zone` varchar(15) DEFAULT NULL COMMENT '逻辑业务区域',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for business_zone$network_segment
-- ----------------------------
DROP TABLE IF EXISTS `business_zone$network_segment`;
CREATE TABLE `business_zone$network_segment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for business_zone$network_zone
-- ----------------------------
DROP TABLE IF EXISTS `business_zone$network_zone`;
CREATE TABLE `business_zone$network_zone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for business_zone_design
-- ----------------------------
DROP TABLE IF EXISTS `business_zone_design`;
CREATE TABLE `business_zone_design` (
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
  `network_zone_design` varchar(15) DEFAULT NULL COMMENT '网络区域设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for business_zone_design$application_domain
-- ----------------------------
DROP TABLE IF EXISTS `business_zone_design$application_domain`;
CREATE TABLE `business_zone_design$application_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for business_zone_design$network_segment_design
-- ----------------------------
DROP TABLE IF EXISTS `business_zone_design$network_segment_design`;
CREATE TABLE `business_zone_design$network_segment_design` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for cache_instance
-- ----------------------------
DROP TABLE IF EXISTS `cache_instance`;
CREATE TABLE `cache_instance` (
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
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `port` varchar(200) DEFAULT NULL COMMENT '端口',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '存储空间(GB)',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cache_resource_instance
-- ----------------------------
DROP TABLE IF EXISTS `cache_resource_instance`;
CREATE TABLE `cache_resource_instance` (
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
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '计费周期(月)',
  `charge_type` varchar(200) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `intranet_ip` varchar(15) DEFAULT NULL COMMENT '内网IP',
  `login_port` varchar(200) DEFAULT NULL COMMENT '登录端口',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_spec` varchar(15) DEFAULT NULL COMMENT '资源实例规格',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '存储空间(GB)',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名',
  `user_password` varchar(200) DEFAULT NULL COMMENT '用户密码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for cloud_vendor
-- ----------------------------
DROP TABLE IF EXISTS `cloud_vendor`;
CREATE TABLE `cloud_vendor` (
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

-- ----------------------------
-- Table structure for cluster_node_type
-- ----------------------------
DROP TABLE IF EXISTS `cluster_node_type`;
CREATE TABLE `cluster_node_type` (
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

-- ----------------------------
-- Table structure for cluster_type
-- ----------------------------
DROP TABLE IF EXISTS `cluster_type`;
CREATE TABLE `cluster_type` (
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

-- ----------------------------
-- Table structure for data_center
-- ----------------------------
DROP TABLE IF EXISTS `data_center`;
CREATE TABLE `data_center` (
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
  `data_center_type` varchar(200) DEFAULT NULL COMMENT '合法值[REGION,ZONE]',
  `location` varchar(200) DEFAULT NULL COMMENT '位置',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `regional_data_center` varchar(15) DEFAULT NULL COMMENT '地域数据中心',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for data_center$deploy_environment
-- ----------------------------
DROP TABLE IF EXISTS `data_center$deploy_environment`;
CREATE TABLE `data_center$deploy_environment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for data_center_design
-- ----------------------------
DROP TABLE IF EXISTS `data_center_design`;
CREATE TABLE `data_center_design` (
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

-- ----------------------------
-- Table structure for default_security_policy
-- ----------------------------
DROP TABLE IF EXISTS `default_security_policy`;
CREATE TABLE `default_security_policy` (
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
  `maxport` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for default_security_policy_design
-- ----------------------------
DROP TABLE IF EXISTS `default_security_policy_design`;
CREATE TABLE `default_security_policy_design` (
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
  `port` varchar(200) DEFAULT NULL COMMENT '合法格式\n1、ALL；\n2、数字段，使用‘-’连接；\n3、数字数组，使用‘,‘分隔',
  `protocol` varchar(200) DEFAULT NULL COMMENT '合法值为[TCP,UDP,ICPM]',
  `security_policy_action` varchar(200) DEFAULT NULL COMMENT '合法值为[DROP,ACCEPT]',
  `security_policy_type` varchar(200) DEFAULT NULL COMMENT '合法值为[ingress, egress]',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `maxport` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for deploy_environment
-- ----------------------------
DROP TABLE IF EXISTS `deploy_environment`;
CREATE TABLE `deploy_environment` (
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

-- ----------------------------
-- Table structure for deploy_package
-- ----------------------------
DROP TABLE IF EXISTS `deploy_package`;
CREATE TABLE `deploy_package` (
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
  `diff_conf_file` varchar(200) DEFAULT NULL COMMENT '差异配置文件',
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

-- ----------------------------
-- Table structure for deploy_package$diff_conf_variable
-- ----------------------------
DROP TABLE IF EXISTS `deploy_package$diff_conf_variable`;
CREATE TABLE `deploy_package$diff_conf_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for diff_configuration
-- ----------------------------
DROP TABLE IF EXISTS `diff_configuration`;
CREATE TABLE `diff_configuration` (
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

-- ----------------------------
-- Table structure for host_resource_instance
-- ----------------------------
DROP TABLE IF EXISTS `host_resource_instance`;
CREATE TABLE `host_resource_instance` (
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
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '计费周期(月)',
  `charge_type` varchar(200) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `intranet_ip` varchar(15) DEFAULT NULL COMMENT '内网IP',
  `login_port` varchar(200) DEFAULT NULL COMMENT '登录端口',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_spec` varchar(15) DEFAULT NULL COMMENT '资源实例规格',
  `resource_instance_system` varchar(15) DEFAULT NULL COMMENT '资源实例系统',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '存储空间(GB)',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名',
  `user_password` varchar(200) DEFAULT NULL COMMENT '用户密码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for invoke
-- ----------------------------
DROP TABLE IF EXISTS `invoke`;
CREATE TABLE `invoke` (
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
  `access_control` varchar(200) DEFAULT NULL COMMENT '访问控制',
  `invoked_unit` varchar(15) DEFAULT NULL COMMENT '被调用单元',
  `invoke_design` varchar(15) DEFAULT NULL COMMENT '调用设计',
  `invoke_type` varchar(200) DEFAULT NULL COMMENT '调用类型',
  `invoke_unit` varchar(15) DEFAULT NULL COMMENT '调用单元',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for invoke_design
-- ----------------------------
DROP TABLE IF EXISTS `invoke_design`;
CREATE TABLE `invoke_design` (
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
  `invoke_type` varchar(200) DEFAULT NULL COMMENT '同步调用\n同步请求\n异步返回',
  `invoke_unit_design` varchar(15) DEFAULT NULL COMMENT '调用单元设计',
  `resource_set_invoke_design` varchar(15) DEFAULT NULL COMMENT '资源集合调用设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for ip_address
-- ----------------------------
DROP TABLE IF EXISTS `ip_address`;
CREATE TABLE `ip_address` (
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
  `ip_address_usage` varchar(200) DEFAULT NULL COMMENT 'IP用途',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `used_record` varchar(1000) DEFAULT NULL COMMENT '使用记录',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for lb_instance
-- ----------------------------
DROP TABLE IF EXISTS `lb_instance`;
CREATE TABLE `lb_instance` (
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
  `port` varchar(200) DEFAULT NULL COMMENT '端口',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for lb_resource_instance
-- ----------------------------
DROP TABLE IF EXISTS `lb_resource_instance`;
CREATE TABLE `lb_resource_instance` (
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
  `charge_type` varchar(200) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `intranet_ip` varchar(15) DEFAULT NULL COMMENT '内网IP',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for legal_person
-- ----------------------------
DROP TABLE IF EXISTS `legal_person`;
CREATE TABLE `legal_person` (
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

-- ----------------------------
-- Table structure for manage_role
-- ----------------------------
DROP TABLE IF EXISTS `manage_role`;
CREATE TABLE `manage_role` (
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

-- ----------------------------
-- Table structure for network_segment
-- ----------------------------
DROP TABLE IF EXISTS `network_segment`;
CREATE TABLE `network_segment` (
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
  `mask` varchar(200) DEFAULT NULL COMMENT '子网掩码',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `network_segment_design` varchar(15) DEFAULT NULL COMMENT '网段设计',
  `network_segment_usage` varchar(200) DEFAULT NULL COMMENT '网段用途',
  `route_table_asset_id` varchar(200) DEFAULT NULL COMMENT '路由表资产ID',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subnet_asset_id` varchar(200) DEFAULT NULL COMMENT '子网资产ID',
  `vpc_asset_id` varchar(200) DEFAULT NULL COMMENT 'VPC资产ID',
  `private_route_table` varchar(200) DEFAULT NULL COMMENT '独立路由表',
  `security_group_asset_id` varchar(200) DEFAULT NULL COMMENT '安全组资产ID',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for network_segment_design
-- ----------------------------
DROP TABLE IF EXISTS `network_segment_design`;
CREATE TABLE `network_segment_design` (
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
  `mask` varchar(200) DEFAULT NULL COMMENT '子网掩码',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `network_segment_usage` varchar(200) DEFAULT NULL COMMENT '合法值[RDC,VPC,SUBNET]，RDC：地域数据中心；VPC：私有网络区域；SUBNET：子网',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `private_route_table` varchar(200) DEFAULT NULL COMMENT '合法值[Y,N]',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for network_zone
-- ----------------------------
DROP TABLE IF EXISTS `network_zone`;
CREATE TABLE `network_zone` (
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

-- ----------------------------
-- Table structure for network_zone_design
-- ----------------------------
DROP TABLE IF EXISTS `network_zone_design`;
CREATE TABLE `network_zone_design` (
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
  `network_zone_layer` varchar(200) DEFAULT NULL COMMENT '合法值[CLIENT,LINK,CORE]',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for network_zone_link
-- ----------------------------
DROP TABLE IF EXISTS `network_zone_link`;
CREATE TABLE `network_zone_link` (
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
  `network_zone_1` varchar(15) DEFAULT NULL COMMENT '网络区域1',
  `network_zone_2` varchar(15) DEFAULT NULL COMMENT '网络区域2',
  `network_zone_link_design` varchar(15) DEFAULT NULL COMMENT '网络区域连接设计',
  `network_zone_link_type` varchar(200) DEFAULT NULL COMMENT '网络连接类型',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for network_zone_link_design
-- ----------------------------
DROP TABLE IF EXISTS `network_zone_link_design`;
CREATE TABLE `network_zone_link_design` (
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
  `network_zone_design_1` varchar(15) DEFAULT NULL COMMENT '网络区域设计1',
  `network_zone_design_2` varchar(15) DEFAULT NULL COMMENT '网络区域设计2',
  `network_zone_link_type` varchar(200) DEFAULT NULL COMMENT '合法值[PEERCONNECTION,NAT]',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for network_zone_route
-- ----------------------------
DROP TABLE IF EXISTS `network_zone_route`;
CREATE TABLE `network_zone_route` (
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
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `network_zone` varchar(15) DEFAULT NULL COMMENT '网络区域',
  `network_zone_link` varchar(15) DEFAULT NULL COMMENT '网络区域连接',
  `network_zone_route_design` varchar(15) DEFAULT NULL COMMENT '网络区域路由设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for network_zone_route_design
-- ----------------------------
DROP TABLE IF EXISTS `network_zone_route_design`;
CREATE TABLE `network_zone_route_design` (
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
  `network_segment_design` varchar(15) DEFAULT NULL COMMENT '网段设计',
  `network_zone_design` varchar(15) DEFAULT NULL COMMENT '网络区域设计',
  `network_zone_link_design` varchar(15) DEFAULT NULL COMMENT '网络区域连接设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for node_type
-- ----------------------------
DROP TABLE IF EXISTS `node_type`;
CREATE TABLE `node_type` (
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

-- ----------------------------
-- Table structure for rdb_instance
-- ----------------------------
DROP TABLE IF EXISTS `rdb_instance`;
CREATE TABLE `rdb_instance` (
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
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `deploy_package` varchar(15) DEFAULT NULL COMMENT '部署包',
  `deploy_package_url` varchar(200) DEFAULT NULL COMMENT '部署包路径',
  `deploy_script` varchar(200) DEFAULT NULL,
  `deploy_user` varchar(200) DEFAULT NULL,
  `deploy_user_password` varchar(200) DEFAULT NULL COMMENT '部署用户密码',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `port` varchar(200) DEFAULT NULL COMMENT '端口',
  `rdb_resource_instance` varchar(15) DEFAULT NULL COMMENT '数据库资源实例',
  `regular_backup_asset_id` varchar(200) DEFAULT NULL COMMENT '常规备份资产ID',
  `rollback_script` varchar(200) DEFAULT NULL,
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '存储空间(GB)',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  `upgrade_script` varchar(200) DEFAULT NULL,
  `variable_values` varchar(4000) DEFAULT NULL COMMENT '差异配置值',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rdb_resource_instance
-- ----------------------------
DROP TABLE IF EXISTS `rdb_resource_instance`;
CREATE TABLE `rdb_resource_instance` (
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
  `billing_cycle` varchar(200) DEFAULT NULL COMMENT '计费周期(月)',
  `charge_type` varchar(200) DEFAULT NULL COMMENT '计费模式',
  `cluster_node_type` varchar(15) DEFAULT NULL COMMENT '集群节点类型',
  `cpu` varchar(200) DEFAULT NULL COMMENT 'CPU(核)',
  `end_date` varchar(200) DEFAULT NULL COMMENT '截止时间，包年包月时必须给出',
  `intranet_ip` varchar(15) DEFAULT NULL COMMENT '内网IP',
  `login_port` varchar(200) DEFAULT NULL COMMENT '登录端口',
  `master_resource_instance` varchar(15) DEFAULT NULL COMMENT '主资源实例',
  `memory` varchar(200) DEFAULT NULL COMMENT '内存(GB)',
  `monitor_key_name` varchar(200) DEFAULT NULL,
  `monitor_port` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_instance_spec` varchar(15) DEFAULT NULL COMMENT '资源实例规格',
  `resource_instance_system` varchar(15) DEFAULT NULL COMMENT '资源系统',
  `resource_instance_type` varchar(15) DEFAULT NULL COMMENT '资源实例类型',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集合',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `storage` varchar(200) DEFAULT NULL COMMENT '存储空间(GB)',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名',
  `user_password` varchar(200) DEFAULT NULL COMMENT '用户密码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for resource_instance_spec
-- ----------------------------
DROP TABLE IF EXISTS `resource_instance_spec`;
CREATE TABLE `resource_instance_spec` (
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
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for resource_instance_system
-- ----------------------------
DROP TABLE IF EXISTS `resource_instance_system`;
CREATE TABLE `resource_instance_system` (
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
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for resource_instance_type
-- ----------------------------
DROP TABLE IF EXISTS `resource_instance_type`;
CREATE TABLE `resource_instance_type` (
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
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for resource_set
-- ----------------------------
DROP TABLE IF EXISTS `resource_set`;
CREATE TABLE `resource_set` (
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
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `resource_set_design` varchar(15) DEFAULT NULL COMMENT '资源集合设计',
  `resource_set_type` varchar(200) DEFAULT NULL COMMENT '合法值[GROUP,NODE]',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for resource_set$deploy_environment
-- ----------------------------
DROP TABLE IF EXISTS `resource_set$deploy_environment`;
CREATE TABLE `resource_set$deploy_environment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for resource_set$network_segment
-- ----------------------------
DROP TABLE IF EXISTS `resource_set$network_segment`;
CREATE TABLE `resource_set$network_segment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for resource_set_design
-- ----------------------------
DROP TABLE IF EXISTS `resource_set_design`;
CREATE TABLE `resource_set_design` (
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
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for resource_set_invoke_design
-- ----------------------------
DROP TABLE IF EXISTS `resource_set_invoke_design`;
CREATE TABLE `resource_set_invoke_design` (
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

-- ----------------------------
-- Table structure for route
-- ----------------------------
DROP TABLE IF EXISTS `route`;
CREATE TABLE `route` (
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
  `network_zone_link` varchar(15) DEFAULT NULL COMMENT '网络区域连接',
  `route_design` varchar(15) DEFAULT NULL COMMENT '路由设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for route_design
-- ----------------------------
DROP TABLE IF EXISTS `route_design`;
CREATE TABLE `route_design` (
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

-- ----------------------------
-- Table structure for service_design
-- ----------------------------
DROP TABLE IF EXISTS `service_design`;
CREATE TABLE `service_design` (
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
  `service_invoke_type` varchar(200) DEFAULT NULL COMMENT '合法值 [  同步, 异步 , 广播, 同步调用 ]',
  `service_nature` varchar(200) DEFAULT NULL COMMENT '合法值 [  查询类 , 交易类 ]',
  `service_type` varchar(200) DEFAULT NULL COMMENT '合法值 [  直连服务 , RMB服务 ]',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for service_invoke_design
-- ----------------------------
DROP TABLE IF EXISTS `service_invoke_design`;
CREATE TABLE `service_invoke_design` (
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

-- ----------------------------
-- Table structure for service_invoke_seq_design
-- ----------------------------
DROP TABLE IF EXISTS `service_invoke_seq_design`;
CREATE TABLE `service_invoke_seq_design` (
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
  `system_design` varchar(15) DEFAULT NULL COMMENT '系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for service_invoke_seq_design$service_invoke_design_sequence
-- ----------------------------
DROP TABLE IF EXISTS `service_invoke_seq_design$service_invoke_design_sequence`;
CREATE TABLE `service_invoke_seq_design$service_invoke_design_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for subsys
-- ----------------------------
DROP TABLE IF EXISTS `subsys`;
CREATE TABLE `subsys` (
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
  `system` varchar(15) DEFAULT NULL COMMENT '系统',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for subsys$business_zone
-- ----------------------------
DROP TABLE IF EXISTS `subsys$business_zone`;
CREATE TABLE `subsys$business_zone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for subsys_design
-- ----------------------------
DROP TABLE IF EXISTS `subsys_design`;
CREATE TABLE `subsys_design` (
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
  `subsys_design_id` varchar(200) DEFAULT NULL COMMENT '应用系统设计ID',
  `system_design` varchar(15) DEFAULT NULL COMMENT '系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for subsys_design$business_zone_design
-- ----------------------------
DROP TABLE IF EXISTS `subsys_design$business_zone_design`;
CREATE TABLE `subsys_design$business_zone_design` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for unit
-- ----------------------------
DROP TABLE IF EXISTS `unit`;
CREATE TABLE `unit` (
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
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for unit$deploy_package
-- ----------------------------
DROP TABLE IF EXISTS `unit$deploy_package`;
CREATE TABLE `unit$deploy_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_guid` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for unit_design
-- ----------------------------
DROP TABLE IF EXISTS `unit_design`;
CREATE TABLE `unit_design` (
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
  `across_resource_set` varchar(200) DEFAULT NULL COMMENT '跨资源集合部署',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `protocol` varchar(200) DEFAULT NULL COMMENT '通讯协议',
  `resource_set_design` varchar(15) DEFAULT NULL COMMENT '资源集合设计',
  `state_code` varchar(50) DEFAULT NULL COMMENT '状态编码',
  `subsys_design` varchar(15) DEFAULT NULL COMMENT '系统',
  `unit_type` varchar(15) DEFAULT NULL COMMENT '单元类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for unit_type
-- ----------------------------
DROP TABLE IF EXISTS `unit_type`;
CREATE TABLE `unit_type` (
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

SET FOREIGN_KEY_CHECKS=1;