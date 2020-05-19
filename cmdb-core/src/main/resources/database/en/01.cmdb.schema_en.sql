SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE IF NOT EXISTS `adm_code_value` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `value` varchar(20000) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codeIndex` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_attr_group` (
  `id_adm_attr_group` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id_adm_attr_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_ci_type` (
  `id_adm_ci_type` int(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `id_adm_tenement` int(11) DEFAULT NULL ,
  `table_name` varchar(64) NOT NULL ,
  `status` varchar(20) DEFAULT 'notCreated' ,
  `catalog_id` int(11) DEFAULT NULL ,
  `ci_global_unique_id` int(11) DEFAULT NULL,
  `seq_no` int(11) NOT NULL DEFAULT '0' ,
  `layer_id` int(11) DEFAULT NULL,
  `zoom_level_id` int(11) DEFAULT NULL,
  `image_file_id` int(11) DEFAULT NULL,
  `ci_state_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type`),
  UNIQUE KEY `tableNameIndex` (`table_name`),
  KEY `fk_adm_ci_type_adm_ci_type_1` (`catalog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_basekey_cat_type` (
  `id_adm_basekey_cat_type` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ci_type_id` int(11) DEFAULT NULL,
  `type` int(4) DEFAULT NULL,
  PRIMARY KEY (`id_adm_basekey_cat_type`),
  KEY `adm_basekey_cat_type_ci_type_1` (`ci_type_id`),
  CONSTRAINT `adm_basekey_cat_type_ci_type_1` FOREIGN KEY (`ci_type_id`) REFERENCES `adm_ci_type` (`id_adm_ci_type`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `adm_basekey_cat` (
  `id_adm_basekey_cat` int(11) NOT NULL AUTO_INCREMENT ,
  `cat_name` varchar(32) DEFAULT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `id_adm_role` int(11) DEFAULT NULL ,
  `id_adm_basekey_cat_type` int(11) DEFAULT NULL ,
  `group_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_adm_basekey_cat`),
  KEY `fk_adm_basekey_cat_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_basekey_cat_type` (`id_adm_basekey_cat_type`),
  KEY `fk_adm_basekey_group_type_id` (`group_type_id`),
  CONSTRAINT `fk_adm_basekey_cat_type` FOREIGN KEY (`id_adm_basekey_cat_type`) REFERENCES `adm_basekey_cat_type` (`id_adm_basekey_cat_type`),
  CONSTRAINT `fk_adm_basekey_group_type_id` FOREIGN KEY (`group_type_id`) REFERENCES `adm_basekey_cat` (`id_adm_basekey_cat`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_basekey_code` (
  `id_adm_basekey` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_basekey_cat` int(11) DEFAULT NULL ,
  `code` varchar(255) DEFAULT NULL ,
  `value` varchar(2000) DEFAULT NULL ,
  `group_code_id` int(11) DEFAULT NULL ,
  `code_description` varchar(255) DEFAULT NULL ,
  `seq_no` int(11) DEFAULT NULL ,
  `status` varchar(20) DEFAULT 'active' ,
  PRIMARY KEY (`id_adm_basekey`),
  KEY `fk_adm_basekey_code_adm_basekey_cat_1` (`id_adm_basekey_cat`),
  KEY `fk_adm_basekey_code_group_code_id` (`group_code_id`),
  CONSTRAINT `fk_adm_basekey_code_adm_basekey_cat_1` FOREIGN KEY (`id_adm_basekey_cat`) REFERENCES `adm_basekey_cat` (`id_adm_basekey_cat`),
  CONSTRAINT `fk_adm_basekey_code_group_code_id` FOREIGN KEY (`group_code_id`) REFERENCES `adm_basekey_code` (`id_adm_basekey`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_basekey_cat_type` (
  `id_adm_basekey_cat_type` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ci_type_id` int(11) DEFAULT NULL,
  `type` int(4) DEFAULT NULL,
  PRIMARY KEY (`id_adm_basekey_cat_type`),
  KEY `adm_basekey_cat_type_ci_type_1` (`ci_type_id`),
  CONSTRAINT `adm_basekey_cat_type_ci_type_1` FOREIGN KEY (`ci_type_id`) REFERENCES `adm_ci_type` (`id_adm_ci_type`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_ci_type_attr_base` (
  `id_adm_ci_type_attr` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_ci_type` int(4) NOT NULL ,
  `name` varchar(64) NOT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `input_type` varchar(32) NOT NULL ,
  `property_name` varchar(64) NOT NULL ,
  `property_type` varchar(32) NOT NULL ,
  `length` int(32) DEFAULT '1' ,
  `reference_id` int(11) DEFAULT NULL ,
  `reference_name` varchar(64) DEFAULT NULL ,
  `reference_type` int(4) DEFAULT NULL ,
  `filter_rule` varchar(1000) DEFAULT NULL,
  `search_seq_no` int(11) DEFAULT NULL ,
  `display_type` int(1) DEFAULT NULL ,
  `display_seq_no` int(11) DEFAULT NULL ,
  `edit_is_null` int(1) DEFAULT NULL,
  `edit_is_only` int(1) DEFAULT NULL ,
  `edit_is_hiden` int(1) DEFAULT NULL ,
  `edit_is_editable` int(1) DEFAULT NULL ,
  `is_defunct` int(1) DEFAULT '0' ,
  `special_logic` varchar(32) DEFAULT NULL ,
  `status` varchar(20) DEFAULT 'notCreated' ,
  `is_system` int(1) DEFAULT NULL ,
  `is_access_controlled` int(1) DEFAULT '0' ,
  `is_auto` int(1) DEFAULT NULL,
  `auto_fill_rule` varchar(2000) DEFAULT NULL ,
  `regular_expression_rule` varchar(200) DEFAULT NULL ,
  `is_refreshable` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_ci_type_attr` (
  `id_adm_ci_type_attr` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_ci_type` int(4) NOT NULL ,
  `name` varchar(64) NOT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `input_type` varchar(32) NOT NULL ,
  `property_name` varchar(64) NOT NULL ,
  `property_type` varchar(32) NOT NULL ,
  `length` int(32) DEFAULT '1' ,
  `reference_id` int(11) DEFAULT NULL ,
  `reference_name` varchar(64) DEFAULT NULL ,
  `reference_type` int(4) DEFAULT NULL ,
  `filter_rule` varchar(1000) DEFAULT NULL,
  `search_seq_no` int(11) DEFAULT NULL ,
  `display_type` int(1) DEFAULT NULL ,
  `display_seq_no` int(11) DEFAULT NULL ,
  `edit_is_null` int(1) DEFAULT NULL,
  `edit_is_only` int(1) DEFAULT NULL ,
  `edit_is_hiden` int(1) DEFAULT NULL ,
  `edit_is_editable` int(1) DEFAULT NULL ,
  `is_defunct` int(1) DEFAULT '0' ,
  `special_logic` varchar(32) DEFAULT NULL ,
  `status` varchar(20) DEFAULT 'notCreated' ,
  `is_system` int(1) DEFAULT NULL ,
  `is_access_controlled` int(1) DEFAULT '0' ,
  `is_auto` int(1) DEFAULT NULL,
  `auto_fill_rule` varchar(2000) DEFAULT NULL ,
  `regular_expression_rule` varchar(200) DEFAULT NULL ,
  `is_refreshable` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_adm_ci_type_attr`),
  UNIQUE KEY `uniqCiType` (`id_adm_ci_type`,`property_name`)
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_ci_type_attr_group` (
  `id_adm_ci_type_attr_group` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_ci_type_attr` int(11) DEFAULT NULL ,
  `id_adm_attr_group` int(11) DEFAULT NULL ,
  PRIMARY KEY (`id_adm_ci_type_attr_group`),
  KEY `fk_adm_ci_type_attr_group_adm_attr_group_1` (`id_adm_attr_group`),
  KEY `fk_adm_ci_type_attr_group_adm_ci_type_attr_1` (`id_adm_ci_type_attr`),
  CONSTRAINT `fk_adm_ci_type_attr_group_adm_attr_group_1` FOREIGN KEY (`id_adm_attr_group`) REFERENCES `adm_attr_group` (`id_adm_attr_group`),
  CONSTRAINT `fk_adm_ci_type_attr_group_adm_ci_type_attr_1` FOREIGN KEY (`id_adm_ci_type_attr`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_files` (
  `id_adm_file` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `content` blob,
  PRIMARY KEY (`id_adm_file`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_integrate_template` (
  `id_adm_integrate_template` int(11) NOT NULL AUTO_INCREMENT,
  `ci_type_id` int(11) NOT NULL,
  `name` varchar(64) DEFAULT NULL,
  `des` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id_adm_integrate_template`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=437 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_integrate_template_alias_attr` (
  `id_attr` int(11) NOT NULL AUTO_INCREMENT,
  `id_alias` int(11) DEFAULT NULL,
  `id_ci_type_attr` int(11) DEFAULT NULL,
  `is_condition` varchar(2) DEFAULT NULL ,
  `is_displayed` varchar(2) DEFAULT NULL ,
  `mapping_name` varchar(200) DEFAULT NULL ,
  `filter` varchar(200) DEFAULT NULL ,
  `key_name` varchar(500) DEFAULT NULL ,
  `seq_no` int(11) DEFAULT NULL ,
  `cn_alias` varchar(64) DEFAULT NULL ,
  `sys_attr` varchar(64) DEFAULT NULL ,
  PRIMARY KEY (`id_attr`),
  KEY `fk_adm_integrate_template_alias_attr_1` (`id_alias`),
  KEY `fk_adm_integrate_template_alias_attr_2` (`id_ci_type_attr`),
  CONSTRAINT `fk_adm_integrate_template_alias_attr_1` FOREIGN KEY (`id_alias`) REFERENCES `adm_integrate_template_alias` (`id_alias`),
  CONSTRAINT `fk_adm_integrate_template_alias_attr_2` FOREIGN KEY (`id_ci_type_attr`) REFERENCES `adm_ci_type_attr` (`id_adm_ci_type_attr`)
) ENGINE=InnoDB AUTO_INCREMENT=497 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=329 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `adm_menu` (
  `id_adm_menu` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL ,
  `other_name` varchar(255) DEFAULT NULL ,
  `url` varchar(255) DEFAULT NULL ,
  `seq_no` int(11) DEFAULT NULL ,
  `remark` varchar(255) DEFAULT NULL ,
  `parent_id_adm_menu` int(11) DEFAULT NULL ,
  `class_path` varchar(100) DEFAULT NULL ,
  `is_active` int(1) DEFAULT '0' ,
  PRIMARY KEY (`id_adm_menu`),
  KEY `fk_adm_menu_adm_menu_1` (`parent_id_adm_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_tenement` (
  `id_adm_tenement` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `en_short_name` varchar(32) DEFAULT NULL ,
  PRIMARY KEY (`id_adm_tenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_role` (
  `id_adm_role` int(11) NOT NULL AUTO_INCREMENT ,
  `role_name` varchar(32) DEFAULT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `id_adm_tenement` int(11) DEFAULT NULL ,
  `parent_id_adm_role` int(11) DEFAULT NULL ,
  `role_type` varchar(32) DEFAULT NULL ,
  `is_system` int(1) DEFAULT '0' ,
  PRIMARY KEY (`id_adm_role`),
  KEY `fk_adm_role_adm_tenement_1` (`id_adm_tenement`),
  KEY `fk_adm_role_adm_role_1` (`parent_id_adm_role`),
  CONSTRAINT `fk_adm_role_adm_role_1` FOREIGN KEY (`parent_id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_adm_tenement_1` FOREIGN KEY (`id_adm_tenement`) REFERENCES `adm_tenement` (`id_adm_tenement`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_role_ci_type` (
  `id_adm_role_ci_type` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_role` int(11) NOT NULL ,
  `id_adm_ci_type` int(11) NOT NULL ,
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
) ENGINE=InnoDB AUTO_INCREMENT=469 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_role_ci_type_ctrl_attr` (
  `id_adm_role_ci_type_ctrl_attr` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_role_ci_type` int(11) NOT NULL ,
  `creation_permission` varchar(1) NOT NULL DEFAULT 'N',
  `removal_permission` varchar(1) NOT NULL DEFAULT 'N',
  `modification_permission` varchar(1) NOT NULL DEFAULT 'N',
  `enquiry_permission` varchar(1) NOT NULL DEFAULT 'N',
  `execution_permission` varchar(1) NOT NULL DEFAULT 'N',
  `grant_permission` varchar(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id_adm_role_ci_type_ctrl_attr`),
  KEY `fk_adm_role_ci_type_attribute_adm_role_ci_type_1` (`id_adm_role_ci_type`),
  CONSTRAINT `fk_adm_role_ci_type_attribute_adm_role_ci_type_1` FOREIGN KEY (`id_adm_role_ci_type`) REFERENCES `adm_role_ci_type` (`id_adm_role_ci_type`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `adm_role_menu` (
  `id_adm_role_menu` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_role` int(11) DEFAULT NULL ,
  `id_adm_menu` int(11) DEFAULT NULL ,
  `is_system` int(1) DEFAULT '0' ,
  PRIMARY KEY (`id_adm_role_menu`),
  UNIQUE KEY `role_menu_unique` (`id_adm_role`,`id_adm_menu`),
  KEY `fk_adm_role_menu_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_role_menu_adm_menu_1` (`id_adm_menu`),
  CONSTRAINT `fk_adm_role_menu_adm_menu_1` FOREIGN KEY (`id_adm_menu`) REFERENCES `adm_menu` (`id_adm_menu`) ON DELETE CASCADE,
  CONSTRAINT `fk_adm_role_menu_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_user` (
  `id_adm_user` int(11) NOT NULL AUTO_INCREMENT ,
  `name` varchar(64) DEFAULT NULL ,
  `code` varchar(100) DEFAULT NULL ,
  `encrypted_password` varchar(100) DEFAULT NULL ,
  `description` varchar(255) DEFAULT NULL ,
  `id_adm_tenement` int(11) DEFAULT NULL ,
  `action_flag` tinyint(1) DEFAULT '0' ,
  `is_system` int(1) DEFAULT '0' ,
  PRIMARY KEY (`id_adm_user`),
  UNIQUE KEY `adm_user_code` (`code`),
  KEY `fk_adm_user_adm_tenement_1` (`id_adm_tenement`),
  CONSTRAINT `fk_adm_user_adm_tenement_1` FOREIGN KEY (`id_adm_tenement`) REFERENCES `adm_tenement` (`id_adm_tenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_role_user` (
  `id_adm_role_user` int(11) NOT NULL AUTO_INCREMENT ,
  `id_adm_role` int(11) DEFAULT NULL ,
  `id_adm_user` int(11) DEFAULT NULL ,
  `is_system` int(1) DEFAULT '0' ,
  PRIMARY KEY (`id_adm_role_user`),
  KEY `fk_adm_role_user_adm_role_1` (`id_adm_role`),
  KEY `fk_adm_role_user_adm_user_1` (`id_adm_user`),
  CONSTRAINT `fk_adm_role_user_adm_role_1` FOREIGN KEY (`id_adm_role`) REFERENCES `adm_role` (`id_adm_role`),
  CONSTRAINT `fk_adm_role_user_adm_user_1` FOREIGN KEY (`id_adm_user`) REFERENCES `adm_user` (`id_adm_user`)
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_sequence` (
  `id_adm_sequence` int(10) NOT NULL AUTO_INCREMENT ,
  `seq_name` varchar(64) NOT NULL ,
  `current_val` int(11) DEFAULT NULL ,
  `increment_val` int(11) DEFAULT NULL ,
  `length_limitation` int(11) DEFAULT NULL ,
  `left_zero_padding` varchar(1) DEFAULT NULL ,
  PRIMARY KEY (`id_adm_sequence`),
  UNIQUE KEY `seq_name_index` (`seq_name`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

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

CREATE TABLE `block_storage` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `charge_type` int(15) DEFAULT NULL ,
  `disk_size` int(15) DEFAULT NULL ,
  `host` varchar(15) DEFAULT NULL ,
  `instance_num` int(2) DEFAULT NULL ,
  `mount_point` varchar(50) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `DCN` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `dcn_design` varchar(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `zone` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `DCN_desgin` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `business_group` int(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `zone_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `host` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `charge_type` int(15) DEFAULT NULL ,
  `disk` int(15) DEFAULT NULL ,
  `instance_num` int(2) DEFAULT NULL ,
  `internet_nat_ip` varchar(15) DEFAULT NULL ,
  `intranet_ip` varchar(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `os` int(15) DEFAULT NULL ,
  `password` varchar(64) DEFAULT NULL ,
  `resource_set` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `username` varchar(50) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `IDC` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `address` varchar(1000) DEFAULT NULL ,
  `city` varchar(50) DEFAULT NULL ,
  `env_type` int(15) DEFAULT NULL ,
  `idc_design` varchar(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `network_segment` varchar(15) DEFAULT NULL ,
  `parameter` varchar(1000) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `IDC_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `env_type` int(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `invoke_design` varchar(15) DEFAULT NULL ,
  `service` varchar(15) DEFAULT NULL ,
  `unit` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `service_design` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `unit_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke_sequence_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `service_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke_sequence_design$invoke_design_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) NOT NULL,
  `to_guid` varchar(15) NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ip_addr` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `network_segment` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `used_record` varchar(1000) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `network_segment` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `f_network_segment` varchar(15) DEFAULT NULL ,
  `gateway_ip` varchar(15) DEFAULT NULL ,
  `mask` int(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `package` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `deploy_file` varchar(200) DEFAULT NULL ,
  `deploy_path` varchar(200) DEFAULT NULL ,
  `deploy_user` int(15) DEFAULT NULL ,
  `diff_conf_file` varchar(200) DEFAULT NULL ,
  `md5_value` varchar(50) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `start_file` varchar(200) DEFAULT NULL ,
  `stop_file` varchar(200) DEFAULT NULL ,
  `unit_design` varchar(15) DEFAULT NULL ,
  `upload_time` datetime DEFAULT NULL ,
  `upload_user` varchar(50) DEFAULT NULL ,
  `url` varchar(200) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `package$diff_conf_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) NOT NULL,
  `to_code` int(11) NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `package$diff_conf_variable_fk_code` (`to_code`),
  CONSTRAINT `package$diff_conf_variable_fk_code` FOREIGN KEY (`to_code`) REFERENCES `adm_basekey_code` (`id_adm_basekey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `resource_set` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `dcn` varchar(15) DEFAULT NULL ,
  `env` int(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `network_segment` varchar(15) DEFAULT NULL ,
  `resource_set_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `resource_set_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `dcn_design` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `running_instance` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `charge_type` int(15) DEFAULT NULL ,
  `host` varchar(15) DEFAULT NULL ,
  `instance_disk` int(4) DEFAULT NULL ,
  `instance_mem` int(2) DEFAULT NULL ,
  `instance_num` int(2) DEFAULT NULL ,
  `port` varchar(50) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `unit` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `service` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `dns_domain` int(15) DEFAULT NULL ,
  `dns_name` varchar(50) DEFAULT NULL ,
  `ha_type` int(15) DEFAULT NULL ,
  `service_design` varchar(15) DEFAULT NULL ,
  `service_ip` varchar(15) DEFAULT NULL ,
  `service_port` varchar(50) DEFAULT NULL ,
  `unit` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `service_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `ha_type` int(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `unit_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `subsys` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `env` int(15) DEFAULT NULL ,
  `manager` varchar(50) DEFAULT NULL ,
  `subsys_design` varchar(20) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `subsys_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `business_group` int(15) DEFAULT NULL ,
  `dcn_design_type` int(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `system_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `system_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `business_group` int(50) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `unit` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `instance_num` int(3) DEFAULT NULL ,
  `package` varchar(20) DEFAULT NULL ,
  `subsys` varchar(20) DEFAULT NULL ,
  `unit_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `unit$resource_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_guid` varchar(15) NOT NULL,
  `to_guid` varchar(15) NOT NULL,
  `seq_no` int(5) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `unit_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `across_idc` int(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `resource_set_design` varchar(15) DEFAULT NULL ,
  `resource_set_design_type` int(15) DEFAULT NULL ,
  `subsys_design` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `idc` varchar(15) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `network_segment` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `vpc` varchar(50) DEFAULT NULL ,
  `zone_design` varchar(15) DEFAULT NULL ,
  `zone_layer` int(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `idc_design` varchar(15) DEFAULT NULL ,
  `type` int(15) DEFAULT NULL ,
  `zone_layer` int(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone_link` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `asset_code` varchar(50) DEFAULT NULL ,
  `name` varchar(50) DEFAULT NULL ,
  `zone1` varchar(15) DEFAULT NULL ,
  `zone2` varchar(15) DEFAULT NULL ,
  `zone_link_design` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone_link_design` (
  `guid` varchar(15) NOT NULL ,
  `p_guid` varchar(15) DEFAULT NULL ,
  `r_guid` varchar(15) DEFAULT NULL ,
  `updated_by` varchar(50) DEFAULT NULL ,
  `updated_date` datetime DEFAULT NULL ,
  `created_by` varchar(50) DEFAULT NULL ,
  `created_date` datetime DEFAULT NULL ,
  `key_name` varchar(200) DEFAULT NULL ,
  `state` int(15) DEFAULT NULL ,
  `fixed_date` varchar(19) DEFAULT NULL ,
  `code` varchar(50) DEFAULT NULL ,
  `description` varchar(1000) DEFAULT NULL ,
  `orchestration` int(15) DEFAULT NULL ,
  `biz_key` varchar(50) DEFAULT NULL ,
  `zone_design1` varchar(15) DEFAULT NULL ,
  `zone_design2` varchar(15) DEFAULT NULL ,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SET FOREIGN_KEY_CHECKS=1;
