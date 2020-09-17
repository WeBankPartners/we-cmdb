
SET NAMES utf8 ;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET FOREIGN_KEY_CHECKS=0;

-- Dumping structure for table wecmdb_bk.adm_attr_group
CREATE TABLE IF NOT EXISTS `adm_attr_group` (
  `id_adm_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'NOT USED',
  `name` varchar(64) DEFAULT NULL COMMENT 'NOT USED',
  PRIMARY KEY (`id_adm_attr_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_basekey_cat
CREATE TABLE IF NOT EXISTS `adm_basekey_cat` (
  `id_adm_basekey_cat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of enum category',
  `cat_name` varchar(32) DEFAULT NULL COMMENT 'Name of enum category',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of enu category',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'id_adm_role',
  `id_adm_basekey_cat_type` int(11) DEFAULT NULL COMMENT 'Id of enum category type',
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
  `id_adm_basekey` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of enum code item (key/value pair)',
  `id_adm_basekey_cat` int(11) DEFAULT NULL COMMENT 'Id of enum category',
  `code` varchar(255) DEFAULT NULL COMMENT 'Code as enum code item key',
  `value` varchar(2000) DEFAULT NULL COMMENT 'Value as enum code item display name',
  `group_code_id` int(11) DEFAULT NULL COMMENT 'Id of the group code it belongs to',
  `code_description` varchar(255) DEFAULT NULL COMMENT 'Description enum code item',
  `seq_no` int(11) DEFAULT NULL COMMENT 'Sequence number for ordering',
  `status` varchar(20) DEFAULT 'active' COMMENT 'Status of enum code item (active/inactive)',
  PRIMARY KEY (`id_adm_basekey`),
  KEY `fk_adm_basekey_code_adm_basekey_cat_1` (`id_adm_basekey_cat`),
  KEY `fk_adm_basekey_code_group_code_id` (`group_code_id`),
  CONSTRAINT `fk_adm_basekey_code_adm_basekey_cat_1` FOREIGN KEY (`id_adm_basekey_cat`) REFERENCES `adm_basekey_cat` (`id_adm_basekey_cat`),
  CONSTRAINT `fk_adm_basekey_code_group_code_id` FOREIGN KEY (`group_code_id`) REFERENCES `adm_basekey_code` (`id_adm_basekey`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type
CREATE TABLE IF NOT EXISTS `adm_ci_type` (
  `id_adm_ci_type` int(4) NOT NULL AUTO_INCREMENT COMMENT 'Id of CI data type',
  `name` varchar(32) DEFAULT NULL COMMENT 'Display name of CI data type',
  `image_file_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of CI data type',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'NOT USED',
  `table_name` varchar(64) NOT NULL COMMENT 'Table name managed in DB for CI data type',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT 'Status of CI data type',
  `catalog_id` int(11) DEFAULT NULL COMMENT 'Category Id of CI data type',
  `ci_global_unique_id` int(11) DEFAULT NULL,
  `seq_no` int(11) NOT NULL DEFAULT '0' COMMENT 'Sequence number for ordering',
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
  `id_adm_ci_type_attr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of CI data attribute',
  `id_adm_ci_type` int(4) NOT NULL COMMENT 'Id of CI data type it belongs to',
  `name` varchar(64) NOT NULL COMMENT 'Display name of CI data attribute',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of CI data attribute',
  `input_type` varchar(32) NOT NULL COMMENT 'Type of UI editor control',
  `property_name` varchar(64) NOT NULL COMMENT 'Column name managed in DB for CI data attribute',
  `property_type` varchar(32) NOT NULL COMMENT 'Column type managed in DB for CI data attribute',
  `length` int(32) DEFAULT '1' COMMENT 'Column length (if applicable) in DB for CI data attribute',
  `reference_id` int(11) DEFAULT NULL COMMENT 'Id of the referenced CI data type by CI data attribute',
  `reference_name` varchar(64) DEFAULT NULL COMMENT 'Name of referential relation for CI data attribute',
  `reference_type` int(4) DEFAULT NULL COMMENT 'Type of referential relation',
  `filter_rule` varchar(4000) DEFAULT NULL,
  `search_seq_no` int(11) DEFAULT NULL COMMENT 'Sequence number for displaying order in searching criteria',
  `display_type` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute is displayed in table on UI of CI data type',
  `display_seq_no` int(11) DEFAULT NULL COMMENT 'Sequence number for displaying order in CI data type',
  `edit_is_null` int(1) DEFAULT NULL COMMENT 'Whether value for CI data attribute can be null',
  `edit_is_only` int(1) DEFAULT NULL COMMENT 'Whether value for CI data attribute must be unique',
  `edit_is_hiden` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute is hidden in API response for CI data type',
  `edit_is_editable` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute can be edited on UI',
  `is_defunct` int(1) DEFAULT '0' COMMENT 'NOT USED',
  `special_logic` varchar(32) DEFAULT NULL COMMENT 'NOT USED',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT 'Status of CI data attribute',
  `is_system` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute is predefined by WeCMDB system',
  `is_access_controlled` int(1) DEFAULT '0' COMMENT 'Whether access control should be applied for CI data attribute',
  `is_auto` int(1) DEFAULT NULL COMMENT 'Whether automatic value filling is enabled for CI data attribute',
  `auto_fill_rule` varchar(2000) DEFAULT NULL COMMENT 'Automatic value filling rule for CI data attribute',
  `is_refreshable` int(1) DEFAULT NULL,
  `regular_expression_rule` varchar(200) DEFAULT NULL COMMENT 'Regular expression as validation rule',
  `is_delete_validate` int(1) DEFAULT '1' COMMENT 'Whether referential validation should be enforced when any referenced CI data object by this CI data attribute is to be deleted',
  PRIMARY KEY (`id_adm_ci_type_attr`),
  UNIQUE KEY `uniqCiType` (`id_adm_ci_type`,`property_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1186 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type_attr_base
CREATE TABLE IF NOT EXISTS `adm_ci_type_attr_base` (
  `id_adm_ci_type_attr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of base CI data attribute (inherited by all CI data types)',
  `id_adm_ci_type` int(4) NOT NULL COMMENT 'Id of CI data type',
  `name` varchar(64) NOT NULL COMMENT 'Display name of CI data attribute',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of CI data attribute',
  `input_type` varchar(32) NOT NULL COMMENT 'Type of UI editor control',
  `property_name` varchar(64) NOT NULL COMMENT 'Column name managed in DB for CI data attribute',
  `property_type` varchar(32) NOT NULL COMMENT 'Column type managed in DB for CI data attribute',
  `length` int(32) DEFAULT '1' COMMENT 'Column length (if applicable) in DB for CI data attribute',
  `reference_id` int(11) DEFAULT NULL COMMENT 'Id of the referenced CI data type by CI data attribute',
  `reference_name` varchar(64) DEFAULT NULL COMMENT 'Name of referential relation for CI data attribute',
  `reference_type` int(4) DEFAULT NULL COMMENT 'Type of referential relation',
  `filter_rule` varchar(1000) DEFAULT NULL,
  `search_seq_no` int(11) DEFAULT NULL COMMENT 'Sequence number for displaying order in searching criteria',
  `display_type` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute is displayed in table on UI of CI data type',
  `display_seq_no` int(11) DEFAULT NULL COMMENT 'Sequence number for displaying order in CI data type',
  `edit_is_null` int(1) DEFAULT NULL COMMENT 'Whether value for CI data attribute can be null',
  `edit_is_only` int(1) DEFAULT NULL COMMENT 'Whether value for CI data attribute must be unique',
  `edit_is_hiden` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute is hidden in API response for CI data type',
  `edit_is_editable` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute can be edited on UI',
  `is_defunct` int(1) DEFAULT '0' COMMENT 'NOT USED',
  `special_logic` varchar(32) DEFAULT NULL COMMENT 'NOT USED',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT 'Status of CI data attribute',
  `is_system` int(1) DEFAULT NULL COMMENT 'Whether CI data attribute is predefined by WeCMDB system',
  `is_access_controlled` int(1) DEFAULT '0' COMMENT 'Whether access control should be applied for CI data attribute',
  `is_auto` int(1) DEFAULT NULL COMMENT 'Whether automatic value filling is enabled for CI data attribute',
  `auto_fill_rule` varchar(2000) DEFAULT NULL COMMENT 'Automatic value filling rule for CI data attribute',
  `regular_expression_rule` varchar(200) DEFAULT NULL COMMENT 'Regular expression as validation rule',
  `is_delete_validate` int(1) DEFAULT '1' COMMENT 'Whether referential validation should be enforced when any referenced CI data object by this CI data attribute is to be deleted',
  `is_refreshable` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_ci_type_attr_group
CREATE TABLE IF NOT EXISTS `adm_ci_type_attr_group` (
  `id_adm_ci_type_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'NOT USED',
  `id_adm_ci_type_attr` int(11) DEFAULT NULL COMMENT 'NOT USED',
  `id_adm_attr_group` int(11) DEFAULT NULL COMMENT 'NOT USED',
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
  `is_condition` varchar(2) DEFAULT NULL,
  `is_displayed` varchar(2) DEFAULT NULL,
  `mapping_name` varchar(200) DEFAULT NULL,
  `filter` varchar(200) DEFAULT NULL,
  `key_name` varchar(500) DEFAULT NULL,
  `seq_no` int(11) DEFAULT NULL,
  `cn_alias` varchar(64) DEFAULT NULL,
  `sys_attr` varchar(64) DEFAULT NULL,
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
  `remark` varchar(1000) DEFAULT NULL,
  `ci_type_name` varchar(100) DEFAULT NULL,
  `ci_name` varchar(100) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `ci_type_id` int(10) DEFAULT NULL,
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
  `id_adm_menu` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of menu item',
  `name` varchar(255) DEFAULT NULL COMMENT 'Name of menu item',
  `other_name` varchar(255) DEFAULT NULL COMMENT 'Alias of menu item',
  `url` varchar(255) DEFAULT NULL COMMENT 'Link URL of menu item',
  `seq_no` int(11) DEFAULT NULL COMMENT 'Sequence number for displaying',
  `remark` varchar(255) DEFAULT NULL COMMENT 'Remarks',
  `parent_id_adm_menu` int(11) DEFAULT NULL COMMENT 'Id of parent menu item',
  `class_path` varchar(100) DEFAULT NULL COMMENT 'NOT USED',
  `is_active` int(1) DEFAULT '0' COMMENT 'Whether menu item is active',
  PRIMARY KEY (`id_adm_menu`),
  KEY `fk_adm_menu_adm_menu_1` (`parent_id_adm_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role
CREATE TABLE IF NOT EXISTS `adm_role` (
  `id_adm_role` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of user role',
  `role_name` varchar(32) DEFAULT NULL COMMENT 'Name of user role',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of user role',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'NOT USED',
  `parent_id_adm_role` int(11) DEFAULT NULL COMMENT 'Id of parent user role',
  `role_type` varchar(32) DEFAULT NULL COMMENT 'NOT USED',
  `is_system` int(1) DEFAULT '0' COMMENT 'Whether it is predefined by WeCMDB system',
  PRIMARY KEY (`id_adm_role`),
  KEY `fk_adm_role_adm_tenement_1` (`id_adm_tenement`),
  KEY `fk_adm_role_adm_role_1` (`parent_id_adm_role`),
  CONSTRAINT `fk_adm_role_adm_role_1` FOREIGN KEY (`parent_id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_adm_tenement_1` FOREIGN KEY (`id_adm_tenement`) REFERENCES `adm_tenement` (`id_adm_tenement`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_role_ci_type
CREATE TABLE IF NOT EXISTS `adm_role_ci_type` (
  `id_adm_role_ci_type` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role` int(11) NOT NULL,
  `id_adm_ci_type` int(11) NOT NULL,
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
  `id_adm_role_ci_type_ctrl_attr` int(11) NOT NULL AUTO_INCREMENT,
  `id_adm_role_ci_type` int(11) NOT NULL,
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
  `id_adm_role_menu` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of "role - menu item" relation',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'Id of role',
  `id_adm_menu` int(11) DEFAULT NULL COMMENT 'Id of menu item',
  `is_system` int(1) DEFAULT '0' COMMENT 'Whether it is predefined by WeCMDB system',
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
  `id_adm_role_user` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of "role - user" relation',
  `id_adm_role` int(11) DEFAULT NULL COMMENT 'Id of role',
  `id_adm_user` int(11) DEFAULT NULL COMMENT 'Id of user',
  `is_system` int(1) DEFAULT '0' COMMENT 'Whether it is predefined by WeCMDB system',
  PRIMARY KEY (`id_adm_role_user`),
  KEY `fk_adm_role_user_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_role_user_adm_user_1` (`id_adm_user`),
  CONSTRAINT `fk_adm_role_user_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_user_adm_user_1` FOREIGN KEY (`id_adm_user`) REFERENCES `adm_user` (`id_adm_user`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_sequence
CREATE TABLE IF NOT EXISTS `adm_sequence` (
  `id_adm_sequence` int(10) NOT NULL AUTO_INCREMENT COMMENT 'Id of sequence for GUID generation',
  `seq_name` varchar(64) NOT NULL COMMENT 'Name of sequence for GUID generation',
  `current_val` int(11) DEFAULT NULL COMMENT 'Current sequence number',
  `increment_val` int(11) DEFAULT NULL COMMENT 'Sequence number increasing step',
  `length_limitation` int(11) DEFAULT NULL COMMENT 'Limitation on length',
  `left_zero_padding` varchar(1) DEFAULT NULL COMMENT 'Whether left zero padding should be applied',
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
  `name` varchar(32) DEFAULT NULL COMMENT 'NOT USED',
  `description` varchar(255) DEFAULT NULL COMMENT 'NOT USED',
  `en_short_name` varchar(32) DEFAULT NULL COMMENT 'NOT USED',
  PRIMARY KEY (`id_adm_tenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table wecmdb_bk.adm_user
CREATE TABLE IF NOT EXISTS `adm_user` (
  `id_adm_user` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of user',
  `name` varchar(64) DEFAULT NULL COMMENT 'Name of user',
  `code` varchar(100) DEFAULT NULL COMMENT 'Code of user (used by interfaces)',
  `encrypted_password` varchar(100) DEFAULT NULL COMMENT 'Password in cipher text',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of user',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'NOT USED',
  `action_flag` tinyint(1) DEFAULT '0' COMMENT 'Action flag of user',
  `is_system` int(1) DEFAULT '0' COMMENT 'Whether user is predefined by WeCMDB system',
  PRIMARY KEY (`id_adm_user`),
  UNIQUE KEY `adm_user_code` (`code`),
  KEY `fk_adm_user_adm_tenement_1` (`id_adm_tenement`),
  CONSTRAINT `fk_adm_user_adm_tenement_1` FOREIGN KEY (`id_adm_tenement`) REFERENCES `adm_tenement` (`id_adm_tenement`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

SET FOREIGN_KEY_CHECKS=1;
