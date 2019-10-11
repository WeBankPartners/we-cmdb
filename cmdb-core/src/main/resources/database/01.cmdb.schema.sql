SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE IF NOT EXISTS `adm_attr_group` (
  `id_adm_attr_group` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_attr_group',
  `name` varchar(64) DEFAULT NULL COMMENT '组名',
  PRIMARY KEY (`id_adm_attr_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_ci_type` (
  `id_adm_ci_type` int(4) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_ci_type',
  `name` varchar(32) DEFAULT NULL COMMENT 'ci类型中文名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `id_adm_tenement` int(11) DEFAULT NULL COMMENT 'id_adm_tenement',
  `table_name` varchar(64) NOT NULL COMMENT '真实表名',
  `status` varchar(20) DEFAULT 'notCreated' COMMENT '表状态',
  `catalog_id` int(11) DEFAULT NULL COMMENT 'ci大类类别',
  `ci_global_unique_id` int(11) DEFAULT NULL,
  `seq_no` int(11) NOT NULL DEFAULT '0' COMMENT '序列号',
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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;

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
  UNIQUE KEY `id_adm_basekey_cat_code` (`id_adm_basekey_cat`,`code`),
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
  PRIMARY KEY (`id_adm_ci_type_attr`),
  UNIQUE KEY `uniqCiType` (`id_adm_ci_type`,`property_name`)
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_tenement` (
  `id_adm_tenement` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL COMMENT '名称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `en_short_name` varchar(32) DEFAULT NULL COMMENT '英文简称',
  PRIMARY KEY (`id_adm_tenement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=469 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `adm_sequence` (
  `id_adm_sequence` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id_adm_sequence',
  `seq_name` varchar(64) NOT NULL COMMENT '序列名称',
  `current_val` int(11) DEFAULT NULL COMMENT '当前值',
  `increment_val` int(11) DEFAULT NULL COMMENT '步长',
  `length_limitation` int(11) DEFAULT NULL COMMENT '位数限制',
  `left_zero_padding` varchar(1) DEFAULT NULL COMMENT '是否补零，y为是，n为否',
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
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `charge_type` int(15) DEFAULT NULL COMMENT '计费模式',
  `disk_size` int(15) DEFAULT NULL COMMENT '容量(GB)',
  `host` varchar(15) DEFAULT NULL COMMENT '主机',
  `instance_num` int(2) DEFAULT NULL COMMENT '计费周期(月)',
  `mount_point` varchar(50) DEFAULT NULL COMMENT '挂载点',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `DCN` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `dcn_design` varchar(15) DEFAULT NULL COMMENT '数据中心节点设计',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `zone` varchar(15) DEFAULT NULL COMMENT '安全区域',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `DCN_desgin` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `business_group` int(15) DEFAULT NULL COMMENT '业务群组',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `zone_design` varchar(15) DEFAULT NULL COMMENT '安全区域设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `host` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `charge_type` int(15) DEFAULT NULL COMMENT '计费模式',
  `disk` int(15) DEFAULT NULL COMMENT '系统盘(G)',
  `instance_num` int(2) DEFAULT NULL COMMENT '计费周期(月)',
  `internet_nat_ip` varchar(15) DEFAULT NULL COMMENT '外网IP',
  `intranet_ip` varchar(15) DEFAULT NULL COMMENT '内网IP',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `os` int(15) DEFAULT NULL COMMENT '操作系统',
  `password` varchar(64) DEFAULT NULL COMMENT '主机登陆密码',
  `resource_set` varchar(15) DEFAULT NULL COMMENT '资源集',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `username` varchar(50) DEFAULT NULL COMMENT '主机登陆用户名',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `IDC` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `address` varchar(1000) DEFAULT NULL COMMENT '地址',
  `city` varchar(50) DEFAULT NULL COMMENT '城市',
  `env_type` int(15) DEFAULT NULL COMMENT '类型',
  `idc_design` varchar(15) DEFAULT NULL COMMENT '机房设计',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `parameter` varchar(1000) DEFAULT NULL COMMENT '远程参数',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `IDC_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `env_type` int(15) DEFAULT NULL COMMENT '环境类型',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `invoke_design` varchar(15) DEFAULT NULL COMMENT '调用设计',
  `service` varchar(15) DEFAULT NULL COMMENT '服务',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `service_design` varchar(15) DEFAULT NULL COMMENT '服务设计',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `invoke_sequence_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `name` varchar(50) DEFAULT NULL COMMENT '服务名称',
  `service_design` varchar(15) DEFAULT NULL COMMENT '服务设计',
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
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `network_segment` varchar(15) DEFAULT NULL COMMENT 'IP网段',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `used_record` varchar(1000) DEFAULT NULL COMMENT '使用记录',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `network_segment` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `f_network_segment` varchar(15) DEFAULT NULL COMMENT '父网段',
  `gateway_ip` varchar(15) DEFAULT NULL COMMENT '网关IP地址',
  `mask` int(15) DEFAULT NULL COMMENT '子网',
  `name` varchar(50) DEFAULT NULL COMMENT '服务名称',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `package` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `deploy_file` varchar(200) DEFAULT NULL COMMENT '部署脚本文件',
  `deploy_path` varchar(200) DEFAULT NULL COMMENT '部署路径',
  `deploy_user` int(15) DEFAULT NULL COMMENT '部署用户',
  `diff_conf_file` varchar(200) DEFAULT NULL COMMENT '差异配置文件',
  `md5_value` varchar(50) DEFAULT NULL COMMENT 'MD5值',
  `name` varchar(50) DEFAULT NULL COMMENT '包名称',
  `start_file` varchar(200) DEFAULT NULL COMMENT '启动脚本文件',
  `stop_file` varchar(200) DEFAULT NULL COMMENT '停止脚本文件',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `upload_user` varchar(50) DEFAULT NULL COMMENT '上传人',
  `url` varchar(200) DEFAULT NULL COMMENT '存储路径',
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
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `dcn` varchar(15) DEFAULT NULL COMMENT 'DCN',
  `env` int(15) DEFAULT NULL COMMENT '环境',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `resource_set_design` varchar(15) DEFAULT NULL COMMENT '资源集设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `resource_set_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `dcn_design` varchar(15) DEFAULT NULL COMMENT '数据中心节点设计',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `running_instance` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `charge_type` int(15) DEFAULT NULL COMMENT '计费模式',
  `host` varchar(15) DEFAULT NULL COMMENT '资源集',
  `instance_disk` int(4) DEFAULT NULL COMMENT '实例磁盘(GB)',
  `instance_mem` int(2) DEFAULT NULL COMMENT '实例内存(GB)',
  `instance_num` int(2) DEFAULT NULL COMMENT '计费周期(月)',
  `port` varchar(50) DEFAULT NULL COMMENT '端口',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `service` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `dns_domain` int(15) DEFAULT NULL COMMENT '域名域',
  `dns_name` varchar(50) DEFAULT NULL COMMENT '域名名',
  `ha_type` int(15) DEFAULT NULL COMMENT '高可用',
  `service_design` varchar(15) DEFAULT NULL COMMENT '服务设计',
  `service_ip` varchar(15) DEFAULT NULL COMMENT '服务IP',
  `service_port` varchar(50) DEFAULT NULL COMMENT '服务端口',
  `unit` varchar(15) DEFAULT NULL COMMENT '单元',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `service_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `ha_type` int(15) DEFAULT NULL COMMENT '高可用',
  `name` varchar(50) DEFAULT NULL COMMENT '服务名称',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `subsys` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `env` int(15) DEFAULT NULL COMMENT '环境',
  `manager` varchar(50) DEFAULT NULL COMMENT '运维人员',
  `subsys_design` varchar(20) DEFAULT NULL COMMENT '子系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `subsys_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `business_group` int(15) DEFAULT NULL COMMENT '业务群组',
  `dcn_design_type` int(15) DEFAULT NULL COMMENT 'DCN设计类型',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `system_design` varchar(15) DEFAULT NULL COMMENT '系统设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `system_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `business_group` int(50) DEFAULT NULL COMMENT '业务群组',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `unit` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `instance_num` int(3) DEFAULT NULL COMMENT '实例数量',
  `package` varchar(20) DEFAULT NULL COMMENT '部署包',
  `subsys` varchar(20) DEFAULT NULL COMMENT '子系统',
  `unit_design` varchar(15) DEFAULT NULL COMMENT '单元统设计',
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
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `across_idc` int(15) DEFAULT NULL COMMENT '跨IDC部署',
  `name` varchar(50) DEFAULT NULL COMMENT '单元名称',
  `resource_set_design` varchar(15) DEFAULT NULL COMMENT '资源集设计',
  `resource_set_design_type` int(15) DEFAULT NULL COMMENT '资源集设计类型',
  `subsys_design` varchar(15) DEFAULT NULL COMMENT '系统',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `idc` varchar(15) DEFAULT NULL COMMENT '机房',
  `name` varchar(50) DEFAULT NULL COMMENT '服务名称',
  `network_segment` varchar(15) DEFAULT NULL COMMENT '网段',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `vpc` varchar(50) DEFAULT NULL COMMENT '虚拟专用网',
  `zone_design` varchar(15) DEFAULT NULL COMMENT '安全区域设计',
  `zone_layer` int(15) DEFAULT NULL COMMENT '层级',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `idc_design` varchar(15) DEFAULT NULL COMMENT '机房设计',
  `type` int(15) DEFAULT NULL COMMENT '类型',
  `zone_layer` int(15) DEFAULT NULL COMMENT '层级',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone_link` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `asset_code` varchar(50) DEFAULT NULL COMMENT '资产编码',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `zone1` varchar(15) DEFAULT NULL COMMENT '安全区域1',
  `zone2` varchar(15) DEFAULT NULL COMMENT '安全区域2',
  `zone_link_design` varchar(15) DEFAULT NULL COMMENT '安全区域连接设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zone_link_design` (
  `guid` varchar(15) NOT NULL COMMENT '全局唯一ID',
  `p_guid` varchar(15) DEFAULT NULL COMMENT '前全局唯一ID',
  `r_guid` varchar(15) DEFAULT NULL COMMENT '根全局唯一ID',
  `updated_by` varchar(50) DEFAULT NULL COMMENT '更新用户',
  `updated_date` datetime DEFAULT NULL COMMENT '更新日期',
  `created_by` varchar(50) DEFAULT NULL COMMENT '创建用户',
  `created_date` datetime DEFAULT NULL COMMENT '创建日期',
  `key_name` varchar(200) DEFAULT NULL COMMENT '唯一名称',
  `state` int(15) DEFAULT NULL COMMENT '状态',
  `fixed_date` varchar(19) DEFAULT NULL COMMENT '确认日期',
  `code` varchar(50) DEFAULT NULL COMMENT '编码',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述说明',
  `orchestration` int(15) DEFAULT NULL COMMENT '编排',
  `biz_key` varchar(50) DEFAULT NULL COMMENT '编排实例ID',
  `zone_design1` varchar(15) DEFAULT NULL COMMENT '安全区域设计',
  `zone_design2` varchar(15) DEFAULT NULL COMMENT '安全区域设计',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SET FOREIGN_KEY_CHECKS=1;